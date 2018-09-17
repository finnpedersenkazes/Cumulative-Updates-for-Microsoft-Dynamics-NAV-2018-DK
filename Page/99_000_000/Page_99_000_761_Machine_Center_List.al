OBJECT Page 99000761 Machine Center List
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
    CaptionML=[DAN=Prod.ress.oversigt;
               ENU=Machine Center List];
    SourceTable=Table99000758;
    PageType=List;
    CardPageID=Machine Center Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=Pr&od.ress.;
                                 ENU=&Mach. Ctr.];
                      Image=MachineCenter }
      { 11      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=K&apacitetsposter;
                                 ENU=Capacity Ledger E&ntries];
                      ToolTipML=[DAN=Vis kapacitetsposterne for den involverede produktionsordre. Kapaciteten registreres enten som tid (operationstid, stoptid eller opstillingstid) eller som antal (spildantal eller afgangsantal).;
                                 ENU=View the capacity ledger entries of the involved production order. Capacity is recorded either as time (run time, stop time, or setup time) or as quantity (scrap quantity or output quantity).];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5832;
                      RunPageView=SORTING(Type,No.,Work Shift Code,Item No.,Posting Date);
                      RunPageLink=Type=CONST(Machine Center),
                                  No.=FIELD(No.),
                                  Posting Date=FIELD(Date Filter);
                      Image=CapacityLedger }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000784;
                      RunPageLink=Table Name=CONST(Machine Center),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=&Belastning;
                                 ENU=Lo&ad];
                      ToolTipML=[DAN=FÜ vist tilgëngeligheden af produktionsressourcen eller arbejdscenteret, herunder kapaciteten, det allokerede antal, rest efter ordre og belastningen i procentdele af den samlede kapacitet.;
                                 ENU=View the availability of the machine or work center, including its the capacity, the allocated quantity, availability after orders, and the load in percent of its total capacity.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000889;
                      RunPageView=SORTING(No.);
                      RunPageLink=No.=FIELD(No.);
                      Image=WorkCenterLoad }
      { 9       ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000762;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Work Shift Filter=FIELD(Work Shift Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Planlëgn.;
                                 ENU=Pla&nning];
                      Image=Planning }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=&Kalender;
                                 ENU=&Calendar];
                      ToolTipML=[DAN=èbn produktionskalenderen, eksempelvis for at se belastningen.;
                                 ENU=Open the shop calendar, for example to see the load.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000770;
                      Promoted=Yes;
                      Image=MachineCenterCalendar;
                      PromotedCategory=Process }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Fra&vër;
                                 ENU=A&bsence];
                      ToolTipML=[DAN="FÜ vist, hvilke arbejdsdage der ikke er ledige. ";
                                 ENU="View which working days are not available. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000772;
                      RunPageLink=Capacity Type=CONST(Machine Center),
                                  No.=FIELD(No.),
                                  Date=FIELD(Date Filter);
                      Promoted=Yes;
                      Image=WorkCenterAbsence;
                      PromotedCategory=Process }
      { 8       ;2   ;Action    ;
                      CaptionML=[DAN=&Operationsliste;
                                 ENU=Ta&sk List];
                      ToolTipML=[DAN=Vis oversigten over operationer, der er planlagt for produktionsressourcen.;
                                 ENU=View the list of operations that are scheduled for the machine center.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000916;
                      RunPageView=SORTING(Type,No.)
                                  WHERE(Type=CONST(Machine Center),
                                        Status=FILTER(..Released),
                                        Routing Status=FILTER(<>Finished));
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=TaskList;
                      PromotedCategory=Process }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1907112806;1 ;Action    ;
                      CaptionML=[DAN=Prod.ress.oversigt;
                                 ENU=Machine Center List];
                      ToolTipML=[DAN=Vis oversigten over produktionsressourcer.;
                                 ENU=View the list of machine centers.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000760;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907150206;1 ;Action    ;
                      CaptionML=[DAN=Prod.ress.belastning;
                                 ENU=Machine Center Load];
                      ToolTipML=[DAN=FÜ en oversigt over tilgëngeligheden pÜ produktionsressourcen, f.eks. kapaciteten, det allokerede antal, tilgëngelighed efter ordre og belastningen i procent.;
                                 ENU=Get an overview of availability at the machine center, such as the capacity, the allocated quantity, availability after order, and the load in percent.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000784;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906511306;1 ;Action    ;
                      CaptionML=[DAN=Prod.ress.belastning - grad;
                                 ENU=Machine Center Load/Bar];
                      ToolTipML=[DAN=Vis en liste over produktionsressourcer, der er overbelastede i henhold til planen. Effektiviteten eller overbelastningen vises i effektivitetsgrader.;
                                 ENU=View a list of machine centers that are overloaded according to the plan. The efficiency or overloading is shown by efficiency bars.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000786;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et navn til produktionsressourcen.;
                           ENU=Specifies a name for the machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det arbejdscenter, som produktionsressourcen skal tildeles.;
                           ENU=Specifies the number of the work center to assign this machine center to.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Center No." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kapaciteten for produktionsressourcen.;
                           ENU=Specifies the capacity of the machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Capacity }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver produktionsressourcens effektivitetsfaktor som en procentdel.;
                           ENU=Specifies the efficiency factor as a percentage of the machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Efficiency }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den minimale effektivitet for produktionsressourcen.;
                           ENU=Specifies the minimum efficiency of this machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Minimum Efficiency";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den maksimale effektivitet for produktionsressourcen.;
                           ENU=Specifies the maximum efficiency of this machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Maximum Efficiency";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor meget tilgëngelig kapacitet der skal planlëgges samtidig for en operation i produktionsressourcen.;
                           ENU=Specifies how much available capacity must be concurrently planned for one operation at this machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Concurrent Capacities";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at sõge efter den õnskede record, hvis du ikke kan huske vërdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Search Name" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Direct Unit Cost";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af centrets omkostning, der omfatter indirekte omkostninger, sÜsom vedligeholdelse af maskiner.;
                           ENU=Specifies the percentage of the center's cost that includes indirect costs, such as machine maintenance.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Indirect Cost %";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver IPO-bidraget for produktionsressourcen.;
                           ENU=Specifies the overhead rate of this machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Rate";
                Visible=FALSE }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver, hvornÜr produktionsressourcekortet sidst blev ëndret.;
                           ENU=Specifies when the machine center card was last modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified";
                Visible=FALSE }

    { 1102601002;2;Field  ;
                ToolTipML=[DAN=Angiver, hvordan forbruget af varen (komponenten) beregnes og hÜndteres i produktionsprocesserne. Manuelt: Angiv og bogfõr forbrug i forbrugskladden manuelt. Fremad: Bogfõrer automatisk forbrug ifõlge produktionsordrekomponentlinjerne, nÜr den fõrste handling starter. Baglëns: Beregner og bogfõrer automatisk forbrug ifõlge produktionsordrekomponentlinjerne, nÜr produktionsordren er fërdig. Pluk + Fremad / Pluk + Baglëns: Variationer med lagersted.;
                           ENU=Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Flushing Method";
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

