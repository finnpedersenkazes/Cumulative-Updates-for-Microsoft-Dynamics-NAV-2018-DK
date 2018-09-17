OBJECT Page 432 Reminder Levels
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rykkerniveauer;
               ENU=Reminder Levels];
    SourceTable=Table293;
    DataCaptionFields=Reminder Terms Code;
    PageType=List;
    OnOpenPage=BEGIN
                 ReminderTerms.SETFILTER(Code,GETFILTER("Reminder Terms Code"));
                 ShowColumn := TRUE;
                 IF ReminderTerms.FINDFIRST THEN BEGIN
                   ReminderTerms.SETRECFILTER;
                   IF ReminderTerms.GETFILTER(Code) = GETFILTER("Reminder Terms Code") THEN
                     ShowColumn := FALSE;
                 END;
                 ReminderTermsCodeVisible := ShowColumn;
               END;

    OnNewRecord=BEGIN
                  NewRecord;
                END;

    OnAfterGetCurrRecord=BEGIN
                           CheckAddFeeCalcType;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Niveau;
                                 ENU=&Level];
                      Image=ReminderTerms }
      { 2       ;2   ;Action    ;
                      Name=BeginningText;
                      CaptionML=[DAN=Starttekst;
                                 ENU=Beginning Text];
                      ToolTipML=[DAN=Definer en starttekst for hvert rykkerniveau. Teksten udskrives p† rykkeren.;
                                 ENU=Define a beginning text for each reminder level. The text will then be printed on the reminder.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 433;
                      RunPageLink=Reminder Terms Code=FIELD(Reminder Terms Code),
                                  Reminder Level=FIELD(No.),
                                  Position=CONST(Beginning);
                      Image=BeginningText }
      { 3       ;2   ;Action    ;
                      Name=EndingText;
                      CaptionML=[DAN=Sluttekst;
                                 ENU=Ending Text];
                      ToolTipML=[DAN=Definer en sluttekst for hvert rykkerniveau. Teksten udskrives p† rykkeren.;
                                 ENU=Define an ending text for each reminder level. The text will then be printed on the reminder.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 433;
                      RunPageLink=Reminder Terms Code=FIELD(Reminder Terms Code),
                                  Reminder Level=FIELD(No.),
                                  Position=CONST(Ending);
                      Image=EndingText }
      { 21      ;2   ;Separator  }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Valutaer;
                                 ENU=Currencies];
                      ToolTipML=[DAN=Vis eller rediger yderligere feed i andre valutaer.;
                                 ENU=View or edit additional feed in additional currencies.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 478;
                      RunPageLink=Reminder Terms Code=FIELD(Reminder Terms Code),
                                  No.=FIELD(No.);
                      Enabled=AddFeeFieldsEnabled;
                      Image=Currency }
      { 1000    ;1   ;ActionGroup;
                      CaptionML=[DAN=Ops‘tning;
                                 ENU=Setup] }
      { 24      ;2   ;Action    ;
                      Name=Additional Fee;
                      CaptionML=[DAN=Opkr‘vningsgebyr;
                                 ENU=Additional Fee];
                      ToolTipML=[DAN=Vis eller rediger de gebyrer, der g‘lder for forsinkede betalinger.;
                                 ENU=View or edit the fees that apply to late payments.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1050;
                      RunPageLink=Charge Per Line=CONST(No),
                                  Reminder Terms Code=FIELD(Reminder Terms Code),
                                  Reminder Level No.=FIELD(No.);
                      Promoted=Yes;
                      Enabled=AddFeeSetupEnabled;
                      Image=SetupColumns;
                      PromotedCategory=Process }
      { 25      ;2   ;Action    ;
                      Name=Additional Fee per Line;
                      CaptionML=[DAN=Opkr‘vningsgebyr pr. linje;
                                 ENU=Additional Fee per Line];
                      ToolTipML=[DAN=Vis eller rediger de gebyrer, der g‘lder for forsinkede betalinger.;
                                 ENU=View or edit the fees that apply to late payments.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1050;
                      RunPageLink=Charge Per Line=CONST(Yes),
                                  Reminder Terms Code=FIELD(Reminder Terms Code),
                                  Reminder Level No.=FIELD(No.);
                      Promoted=Yes;
                      Enabled=AddFeeSetupEnabled;
                      Image=SetupLines;
                      PromotedCategory=Process }
      { 1001    ;2   ;Action    ;
                      Name=View Additional Fee Chart;
                      CaptionML=[DAN=Vis diagram over opkr‘vningsgebyrer;
                                 ENU=View Additional Fee Chart];
                      ToolTipML=[DAN=Vis yderligere gebyrer i et diagram.;
                                 ENU=View additional fees in a chart.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Forecast;
                      OnAction=VAR
                                 AddFeeChart@1000 : Page 1051;
                               BEGIN
                                 IF FileMgt.IsWebClient THEN
                                   ERROR(ChartNotAvailableInWebErr,PRODUCTNAME.SHORT);

                                 AddFeeChart.SetViewMode(Rec,FALSE,TRUE);
                                 AddFeeChart.RUNMODAL;
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

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rykkerens rykkerbetingelseskode.;
                           ENU=Specifies the reminder terms code for the reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reminder Terms Code";
                Visible=ReminderTermsCodeVisible }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l‘ngden p† respitperioden for det p†g‘ldende rykkerniveau.;
                           ENU=Specifies the length of the grace period for this reminder level.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Grace Period" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der bestemmer, hvordan forfaldsdatoen p† rykkeren beregnes.;
                           ENU=Specifies a formula that determines how to calculate the due date on the reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date Calculation" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal beregnes rente p† rykkerlinjerne.;
                           ENU=Specifies whether interest should be calculated on the reminder lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Calculate Interest" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opkr‘vningsgebyret i RV, som bliver lagt oven i rykkeren.;
                           ENU=Specifies the amount of the additional fee in LCY that will be added on the reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Additional Fee (LCY)";
                Enabled=AddFeeFieldsEnabled }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjebel›bet for det ekstra gebyr.;
                           ENU=Specifies the line amount of the additional fee.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Add. Fee per Line Amount (LCY)";
                Enabled=AddFeeFieldsEnabled }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan de ekstra gebyrer beregnes.;
                           ENU=Specifies how the additional fees are calculated.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Add. Fee Calculation Type";
                OnValidate=BEGIN
                             CheckAddFeeCalcType;
                           END;
                            }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af det ekstra gebyr.;
                           ENU=Specifies a description of the additional fee.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Add. Fee per Line Description" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ReminderTerms@1000 : Record 292;
      FileMgt@1006 : Codeunit 419;
      ShowColumn@1001 : Boolean;
      ReminderTermsCodeVisible@19022050 : Boolean INDATASET;
      AddFeeSetupEnabled@1002 : Boolean;
      AddFeeFieldsEnabled@1003 : Boolean;
      ChartNotAvailableInWebErr@1007 : TextConst '@@@=%1 - product name;DAN=Diagrammet kan ikke vises i webklienten %1. Se diagrammet for at bruge %1 Windows-klienten.;ENU=The chart cannot be shown in the %1 Web client. To see the chart, use the %1 Windows client.';

    LOCAL PROCEDURE CheckAddFeeCalcType@1000();
    BEGIN
      IF "Add. Fee Calculation Type" = "Add. Fee Calculation Type"::Fixed THEN BEGIN
        AddFeeSetupEnabled := FALSE;
        AddFeeFieldsEnabled := TRUE;
      END ELSE BEGIN
        AddFeeSetupEnabled := TRUE;
        AddFeeFieldsEnabled := FALSE;
      END;
    END;

    BEGIN
    END.
  }
}

