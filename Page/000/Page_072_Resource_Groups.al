OBJECT Page 72 Resource Groups
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressourcegrupper;
               ENU=Resource Groups];
    SourceTable=Table152;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 12      ;1   ;ActionGroup;
                      CaptionML=[DAN=Res.&gruppe;
                                 ENU=Res. &Group];
                      Image=Group }
      { 14      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger som f.eks. v‘rdien for bogf›rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 230;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Unit of Measure Filter=FIELD(Unit of Measure Filter),
                                  Chargeable Filter=FIELD(Chargeable Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Resource Group),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 23      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 10      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=F† vist eller rediger de enkelte s‘t af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(152),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 22      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Jobs;
                      Image=DimensionSets;
                      OnAction=VAR
                                 ResGr@1001 : Record 152;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ResGr);
                                 DefaultDimMultiple.SetMultiResGr(ResGr);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Priser;
                                 ENU=&Prices];
                      Image=Price }
      { 16      ;2   ;Action    ;
                      CaptionML=[DAN=Kostpriser;
                                 ENU=Costs];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om omkostninger for ressourcen.;
                                 ENU=View or change detailed information about costs for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 203;
                      RunPageLink=Type=CONST("Group(Resource)"),
                                  Code=FIELD(No.);
                      Image=ResourceCosts }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Salgspriser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller rediger priser for ressourcen.;
                                 ENU=View or edit prices for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 204;
                      RunPageLink=Type=CONST("Group(Resource)"),
                                  Code=FIELD(No.);
                      Image=Price }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Plan&l‘gn.;
                                 ENU=Plan&ning];
                      Image=Planning }
      { 18      ;2   ;Action    ;
                      Name=ResGroupCapacity;
                      CaptionML=[DAN=Ressourcegrp.&kapacitet;
                                 ENU=Res. Group &Capacity];
                      ToolTipML=[DAN=Vis kapaciteten for ressourcegruppen.;
                                 ENU=View the capacity of the resource group.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 214;
                      RunPageOnRec=Yes;
                      Image=Capacity }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Ressource&gruppe allokeret p† sager;
                                 ENU=Res. Group All&ocated per Job];
                      ToolTipML=[DAN=Vis sagens tildelinger for ressourcegruppen.;
                                 ENU=View the job allocations of the resource group.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 228;
                      RunPageLink=Resource Gr. Filter=FIELD(No.);
                      Image=ViewJob }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcegruppe allokeret p† service&ordrer;
                                 ENU=Res. Group Allocated per Service &Order];
                      ToolTipML=[DAN=Vis serviceordrens tildelinger for ressourcegruppen.;
                                 ENU=View the service order allocations of the resource group.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 6009;
                      RunPageLink=Resource Group Filter=FIELD(No.);
                      Image=ViewServiceOrder }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=&Ressourcegruppedisponering;
                                 ENU=Res. Group Availa&bility];
                      ToolTipML=[DAN=Vis en oversigt over ressourcegruppekapaciteter, antallet af ressourcetimer, der er allokeret til sager i ordre, det antal, der er allokeret til serviceordrer, den kapacitet, der er tildelt til sager i tilbud, og ressourcegruppetilg‘ngelighed.;
                                 ENU=View a summary of resource group capacities, the quantity of resource hours allocated to jobs on order, the quantity allocated to service orders, the capacity assigned to jobs on quote, and the resource group availability.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 226;
                      RunPageLink=No.=FIELD(No.),
                                  Unit of Measure Filter=FIELD(Unit of Measure Filter),
                                  Chargeable Filter=FIELD(Chargeable Filter);
                      Image=Calendar }
      { 1900000005;0 ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1907852105;1 ;Action    ;
                      CaptionML=[DAN=Ny ressource;
                                 ENU=New Resource];
                      ToolTipML=[DAN=Opret en ny ressource.;
                                 ENU=Create a new resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 76;
                      RunPageLink=Resource Group No.=FIELD(No.);
                      Promoted=Yes;
                      Image=NewResource;
                      PromotedCategory=New;
                      RunPageMode=Create }
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
                ApplicationArea=#Jobs;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af ressourcegruppen.;
                           ENU=Specifies a short description of the resource group.];
                ApplicationArea=#Jobs;
                SourceExpr=Name }

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

