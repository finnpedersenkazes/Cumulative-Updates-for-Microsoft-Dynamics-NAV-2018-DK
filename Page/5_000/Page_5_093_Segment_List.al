OBJECT Page 5093 Segment List
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
    CaptionML=[DAN=M†lgruppeoversigt;
               ENU=Segment List];
    SourceTable=Table5076;
    DataCaptionFields=Campaign No.,Salesperson Code;
    PageType=List;
    CardPageID=Segment;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=&M†lgruppe;
                                 ENU=&Segment];
                      Image=Segment }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Opg&aver;
                                 ENU=T&asks];
                      ToolTipML=[DAN=Se de opgaver, der er tildelt s‘lgere eller teams. Opgaver kan k‘des til kontakter og/eller kampagner.;
                                 ENU=View the tasks that have been assigned to salespeople or teams. Tasks can be linked to contacts and/or campaigns.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5096;
                      RunPageView=SORTING(Segment No.);
                      RunPageLink=Segment No.=FIELD(No.);
                      Image=TaskList }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen for m†lgruppen.;
                           ENU=Specifies the description of the segment.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som m†lgruppen er blevet oprettet til.;
                           ENU=Specifies the number of the campaign for which the segment has been created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden p† den s‘lger, som er ansvarlig for denne m†lgruppe og/eller interaktion.;
                           ENU=Specifies the code of the salesperson responsible for this segment and/or interaction.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor m†lgruppen blev oprettet.;
                           ENU=Specifies the date that the segment was created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Date }

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

