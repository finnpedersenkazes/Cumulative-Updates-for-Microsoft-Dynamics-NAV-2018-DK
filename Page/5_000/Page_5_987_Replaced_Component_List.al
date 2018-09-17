OBJECT Page 5987 Replaced Component List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Erstattet komponentoversigt;
               ENU=Replaced Component List];
    SourceTable=Table5941;
    DataCaptionFields=Parent Service Item No.,Line No.;
    PageType=List;
    AutoSplitKey=Yes;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ko&mponent;
                                 ENU=&Component];
                      Image=Components }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Leverance;
                                 ENU=Shipment];
                      ToolTipML=[DAN=F� vist relaterede bogf�rte serviceleverancer.;
                                 ENU=View related posted service shipments.];
                      ApplicationArea=#Service;
                      RunObject=Page 5974;
                      RunPageLink=Order No.=FIELD(Service Order No.);
                      Image=Shipment }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at komponenten er i brug.;
                           ENU=Specifies that the component is in use.];
                ApplicationArea=#Service;
                SourceExpr=Active }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den serviceartikel, som komponenten indg�r i.;
                           ENU=Specifies the number of the service item in which the component is included.];
                ApplicationArea=#Service;
                SourceExpr="Parent Service Item No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponenttypen.;
                           ENU=Specifies the component type.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af komponenten.;
                           ENU=Specifies a description of the component.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p� komponenten.;
                           ENU=Specifies the serial number of the component.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                OnAssistEdit=BEGIN
                               AssistEditSerialNo;
                             END;
                              }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor komponenten blev installeret.;
                           ENU=Specifies the date when the component was installed.];
                ApplicationArea=#Service;
                SourceExpr="Date Installed" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den serviceordre, hvor komponenten blev udskiftet.;
                           ENU=Specifies the number of the service order under which this component was replaced.];
                ApplicationArea=#Service;
                SourceExpr="Service Order No." }

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

