OBJECT Page 99000764 Routing List
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
    CaptionML=[DAN=Ruteoversigt;
               ENU=Routing List];
    SourceTable=Table99000763;
    DataCaptionFields=No.,Description;
    PageType=List;
    CardPageID=Routing;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Ru&te;
                                 ENU=&Routing];
                      Image=Route }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000784;
                      RunPageLink=Table Name=CONST(Routing Header),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=&Version;
                                 ENU=&Versions];
                      ToolTipML=[DAN="Vis eller rediger andre versioner af ruten, typisk med andre operationsdata. ";
                                 ENU="View or edit other versions of the routing, typically with other operations data. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000808;
                      RunPageLink=Routing No.=FIELD(No.);
                      Promoted=No;
                      Image=RoutingVersions;
                      PromotedCategory=Process }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Indg†r-i;
                                 ENU=Where-used];
                      ToolTipML=[DAN=F† vist en liste over styklister, hvor varen anvendes.;
                                 ENU=View a list of BOMs in which the item is used.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000782;
                      RunPageView=SORTING(Routing No.);
                      RunPageLink=Routing No.=FIELD(No.);
                      Image=Where-Used }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1906688806;1 ;Action    ;
                      CaptionML=[DAN=Rutediagram;
                                 ENU=Routing Sheet];
                      ToolTipML=[DAN=Vis grundl‘ggende oplysninger om ruter, f.eks. send-ahead-antal, opstillingstid, operationstid og tidsenhed. Rapporten viser de operationer, der skal udf›res i denne rute, de produktionsressourcer eller arbejdscentre, der skal anvendes, personale, v‘rkt›jer og beskrivelsen af hver operation.;
                                 ENU=View basic information for routings, such as send-ahead quantity, setup time, run time and time unit. This report shows you the operations to be performed in this routing, the work or machine centers to be used, the personnel, the tools, and the description of each operation.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000787;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
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
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af rutehovedet.;
                           ENU=Specifies a description for the routing header.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver, i hvilken r‘kkef›lge operationer p† ruten skal udf›res.;
                           ENU=Specifies in which order operations in the routing are performed.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Type;
                Visible=FALSE }

    { 1102601002;2;Field  ;
                ToolTipML=[DAN=Angiver status for ruten.;
                           ENU=Specifies the status of this routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Status;
                Visible=FALSE }

    { 1102601004;2;Field  ;
                ToolTipML=[DAN=Angiver den nummerserie, du vil bruge til at oprette en ny version af ruten.;
                           ENU=Specifies the number series you want to use to create a new version of this routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Version Nos.";
                Visible=FALSE }

    { 1102601006;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r rutekortet sidst blev ‘ndret.;
                           ENU=Specifies when the routing card was last modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

