OBJECT Page 99000765 Routing Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table99000764;
    DelayedInsert=Yes;
    PageType=ListPart;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1904648904;1 ;ActionGroup;
                      CaptionML=[DAN=&Operation;
                                 ENU=&Operation];
                      Image=Task }
      { 1901652604;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      Image=ViewComments;
                      OnAction=BEGIN
                                 ShowComment;
                               END;
                                }
      { 1901991804;2 ;Action    ;
                      CaptionML=[DAN=Funk&tioner;
                                 ENU=&Tools];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om funktioner, der er tildelt til handlingen.;
                                 ENU=View or edit information about tools that are assigned to the operation.];
                      ApplicationArea=#Manufacturing;
                      Image=Tools;
                      OnAction=BEGIN
                                 ShowTools;
                               END;
                                }
      { 1900295804;2 ;Action    ;
                      CaptionML=[DAN=Me&darbejdere;
                                 ENU=&Personnel];
                      ToolTipML=[DAN=Vis eller rediger de medarbejdere, der er knyttet til operationen.;
                                 ENU=View or edit the personnel that are assigned to the operation.];
                      ApplicationArea=#Manufacturing;
                      Image=User;
                      OnAction=BEGIN
                                 ShowPersonnel;
                               END;
                                }
      { 1901742204;2 ;Action    ;
                      CaptionML=[DAN=&Kvalitetsm†l;
                                 ENU=&Quality Measures];
                      ToolTipML=[DAN=Vis eller rediger de kvalitetsoplysninger, der er knyttet til operationen.;
                                 ENU=View or edit the quality details that are assigned to the operation.];
                      ApplicationArea=#Manufacturing;
                      OnAction=BEGIN
                                 ShowQualityMeasures;
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
                ToolTipML=[DAN=Angiver operationsnummeret for rutelinjen.;
                           ENU=Specifies the operation number for this routing line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Operation No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forrige operationsnummer, som tildeles automatisk.;
                           ENU=Specifies the previous operation number, which is automatically assigned.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Previous Operation No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det n‘ste operationsnummer. Brug feltet, hvis du benytter parallelle ruter.;
                           ENU=Specifies the next operation number. You use this field if you use parallel routings.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Next Operation No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kapacitetstype, der skal bruges til den aktuelle operation.;
                           ENU=Specifies the kind of capacity type to use for the actual operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en standardopgave.;
                           ENU=Specifies a standard task.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Standard Task Code";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rutebindingskoden.;
                           ENU=Specifies the routing link code.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing Link Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opstillingstiden for operationen.;
                           ENU=Specifies the setup time of the operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Setup Time" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den enhedskode, der anvendes for operationens opstillingstid.;
                           ENU=Specifies the unit of measure code that applies to the setup time of the operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Setup Time Unit of Meas. Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationstiden for operationen.;
                           ENU=Specifies the run time of the operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Run Time" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den enhedskode, der anvendes for operationens operationstid.;
                           ENU=Specifies the unit of measure code that applies to the run time of the operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Run Time Unit of Meas. Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ventetiden ud fra v‘rdien i feltet Ventetids enhedskode.;
                           ENU=Specifies the wait time according to the value in the Wait Time Unit of Measure field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Wait Time" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den enhedskode, der g‘lder for operationens ventetid.;
                           ENU=Specifies the unit of measure code that applies to the wait time.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Wait Time Unit of Meas. Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transporttiden ud fra v‘rdien i feltet Transporttids enhedskode.;
                           ENU=Specifies the move time according to the value in the Move Time Unit of Measure field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Move Time" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den enhedskode, der g‘lder for operationens transporttid.;
                           ENU=Specifies the unit of measure code that applies to the move time.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Move Time Unit of Meas. Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det faste spildantal.;
                           ENU=Specifies the fixed scrap quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Fixed Scrap Quantity" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spildfaktoren i procent.;
                           ENU=Specifies the scrap factor in percent.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Factor %" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en minimal procestid.;
                           ENU=Specifies a minimum process time.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Minimum Process Time";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en maksimal procestid.;
                           ENU=Specifies a maximum process time.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Maximum Process Time";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal maskiner eller personer, der arbejder samtidig.;
                           ENU=Specifies the number of machines or persons that are working concurrently.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Concurrent Capacities" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver send-ahead-antallet.;
                           ENU=Specifies the send-ahead quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Send-Ahead Quantity" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationens kostpris, hvis den er forskellig fra kostprisen p† arbejdscenter- eller produktionsressourcekortet.;
                           ENU=Specifies the unit cost for this operation if it is different than the unit cost on the work center or machine center card.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost per" }

  }
  CODE
  {
    VAR
      RtngComment@1000 : Record 99000775;

    LOCAL PROCEDURE ShowComment@1();
    BEGIN
      RtngComment.SETRANGE("Routing No.","Routing No.");
      RtngComment.SETRANGE("Operation No.","Operation No.");
      RtngComment.SETRANGE("Version Code","Version Code");

      PAGE.RUN(PAGE::"Routing Comment Sheet",RtngComment);
    END;

    LOCAL PROCEDURE ShowTools@2();
    VAR
      RtngTool@1000 : Record 99000802;
    BEGIN
      RtngTool.SETRANGE("Routing No.","Routing No.");
      RtngTool.SETRANGE("Version Code","Version Code");
      RtngTool.SETRANGE("Operation No.","Operation No.");

      PAGE.RUN(PAGE::"Routing Tools",RtngTool);
    END;

    LOCAL PROCEDURE ShowPersonnel@3();
    VAR
      RtngPersonnel@1000 : Record 99000803;
    BEGIN
      RtngPersonnel.SETRANGE("Routing No.","Routing No.");
      RtngPersonnel.SETRANGE("Version Code","Version Code");
      RtngPersonnel.SETRANGE("Operation No.","Operation No.");

      PAGE.RUN(PAGE::"Routing Personnel",RtngPersonnel);
    END;

    LOCAL PROCEDURE ShowQualityMeasures@4();
    VAR
      RtngQltyMeasure@1000 : Record 99000805;
    BEGIN
      RtngQltyMeasure.SETRANGE("Routing No.","Routing No.");
      RtngQltyMeasure.SETRANGE("Version Code","Version Code");
      RtngQltyMeasure.SETRANGE("Operation No.","Operation No.");

      PAGE.RUN(PAGE::"Routing Quality Measures",RtngQltyMeasure);
    END;

    BEGIN
    END.
  }
}

