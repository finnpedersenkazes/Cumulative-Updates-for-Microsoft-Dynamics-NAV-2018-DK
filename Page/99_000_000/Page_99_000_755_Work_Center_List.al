OBJECT Page 99000755 Work Center List
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
    CaptionML=[DAN=Arbejdscenteroversigt;
               ENU=Work Center List];
    SourceTable=Table99000754;
    PageType=List;
    CardPageID=Work Center Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Arb.center;
                                 ENU=Wor&k Ctr.];
                      Image=WorkCenter }
      { 30      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=K&apacitetsposter;
                                 ENU=Capacity Ledger E&ntries];
                      ToolTipML=[DAN=Vis kapacitetsposterne for den involverede produktionsordre. Kapaciteten registreres enten som tid (operationstid, stoptid eller opstillingstid) eller som antal (spildantal eller afgangsantal).;
                                 ENU=View the capacity ledger entries of the involved production order. Capacity is recorded either as time (run time, stop time, or setup time) or as quantity (scrap quantity or output quantity).];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5832;
                      RunPageView=SORTING(Work Center No.,Work Shift Code,Posting Date);
                      RunPageLink=Work Center No.=FIELD(No.),
                                  Posting Date=FIELD(Date Filter);
                      Image=CapacityLedger }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000784;
                      RunPageView=WHERE(Table Name=CONST(Work Center));
                      RunPageLink=No.=FIELD(No.);
                      Image=ViewComments }
      { 28      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 38      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=F� vist eller rediger de enkelte s�t af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(99000754),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 40      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Dimensions;
                      Image=DimensionSets;
                      OnAction=VAR
                                 Work@1001 : Record 99000754;
                                 DefaultDimMultiple@1000 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Work);
                                 DefaultDimMultiple.SetMultiWorkCenter(Work);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=&Belastning;
                                 ENU=Lo&ad];
                      ToolTipML=[DAN=F� vist tilg�ngeligheden af produktionsressourcen eller arbejdscenteret, herunder kapaciteten, det allokerede antal, rest efter ordre og belastningen i procentdele af den samlede kapacitet.;
                                 ENU=View the availability of the machine or work center, including its capacity, the allocated quantity, availability after orders, and the load in percent of its total capacity.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000887;
                      RunPageView=SORTING(No.);
                      RunPageLink=No.=FIELD(No.);
                      Image=WorkCenterLoad }
      { 24      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om recorden, f.eks. v�rdien af bogf�rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000756;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Work Shift Filter=FIELD(Work Shift Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Planl�gn.;
                                 ENU=Pla&nning];
                      Image=Planning }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=&Kalender;
                                 ENU=&Calendar];
                      ToolTipML=[DAN=�bn produktionskalenderen, eksempelvis for at se belastningen.;
                                 ENU=Open the shop calendar, for example to see the load.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000769;
                      Promoted=Yes;
                      Image=MachineCenterCalendar;
                      PromotedCategory=Process }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Fra&v�r;
                                 ENU=A&bsence];
                      ToolTipML=[DAN="F� vist, hvilke arbejdsdage der ikke er ledige. ";
                                 ENU="View which working days are not available. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000772;
                      RunPageLink=Capacity Type=CONST(Work Center),
                                  No.=FIELD(No.),
                                  Date=FIELD(Date Filter);
                      Promoted=Yes;
                      Image=WorkCenterAbsence;
                      PromotedCategory=Process }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=&Operationsliste;
                                 ENU=Ta&sk List];
                      ToolTipML=[DAN=Vis oversigten over operationer, der er planlagt for arbejdscenteret.;
                                 ENU=View the list of operations that are scheduled for the work center.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000915;
                      RunPageView=SORTING(Type,No.)
                                  WHERE(Type=CONST(Work Center),
                                        Status=FILTER(..Released),
                                        Routing Status=FILTER(<>Finished));
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=TaskList;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907912104;1 ;Action    ;
                      CaptionML=[DAN=Beregn arbejdscenterkalender;
                                 ENU=Calculate Work Center Calendar];
                      ToolTipML=[DAN=Opret nye kalenderposter for arbejdscenteret for at definere den tilg�ngelige daglige kapacitet.;
                                 ENU=Create new calendar entries for the work center to define the available daily capacity.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99001046;
                      Promoted=Yes;
                      Image=CalcWorkCenterCalendar;
                      PromotedCategory=Process }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1900368306;1 ;Action    ;
                      CaptionML=[DAN=Arbejdscenteroversigt;
                                 ENU=Work Center List];
                      ToolTipML=[DAN=Vis eller rediger listen over arbejdscentre.;
                                 ENU=View or edit the list of work centers.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000759;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900358106;1 ;Action    ;
                      CaptionML=[DAN=Arbejdscenterbelastning;
                                 ENU=Work Center Load];
                      ToolTipML=[DAN=F� en oversigt over tilg�ngeligheden p� arbejdscenteret, f.eks. kapaciteten, det allokerede antal, tilg�ngelighed efter ordre og belastningen i procent.;
                                 ENU=Get an overview of availability at the work center, such as the capacity, the allocated quantity, availability after order, and the load in percent.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000783;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902181406;1 ;Action    ;
                      CaptionML=[DAN=Arbejdscenterbelastning - grad;
                                 ENU=Work Center Load/Bar];
                      ToolTipML=[DAN=Vis en liste over arbejdscentre, der er overbelastede i henhold til planen. Effektiviteten eller overbelastningen vises i effektivitetsgrader.;
                                 ENU=View a list of work centers that are overloaded according to the plan. The efficiency or overloading is shown by efficiency bars.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000785;
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� arbejdscenteret.;
                           ENU=Specifies the name of the work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt arbejdscenter.;
                           ENU=Specifies an alternate work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Alternate Work Center" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdscentergruppen, hvis arbejdscenteret eller den underliggende produktionsressource er tilknyttet en arbejdscentergruppe.;
                           ENU=Specifies the work center group, if the work center or underlying machine center is assigned to a work center group.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Center Group Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Direct Unit Cost";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af centrets omkostning, der omfatter indirekte omkostninger, s�som vedligeholdelse af maskiner.;
                           ENU=Specifies the percentage of the center's cost that includes indirect costs, such as machine maintenance.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Indirect Cost %";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den m�ngde arbejde, der kan udf�res i en bestemt tidsperiode. Kapaciteten i et arbejdscenter angiver, hvor mange maskiner eller personer, der arbejder samtidig. Hvis du f.eks. angiver 2, betyder det, at arbejdscentret skal bruge det halve af den tid, som et arbejdscenter med kapaciteten 1 skal bruge. ";
                           ENU="Specifies the amount of work that can be done in a specified time period. The capacity of a work center indicates how many machines or persons are working at the same time. If you enter 2, for example, the work center will take half of the time compared to a work center with the capacity of 1. "];
                ApplicationArea=#Manufacturing;
                SourceExpr=Capacity }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdscenterets effektivitetsfaktor som en procentdel.;
                           ENU=Specifies the efficiency factor as a percentage of the work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Efficiency;
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den maksimale effektivitetsfaktor for arbejdscenteret.;
                           ENU=Specifies the maximum efficiency factor of the work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Maximum Efficiency";
                Visible=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den minimale effektivitetsfaktor for arbejdscenteret.;
                           ENU=Specifies the minimum efficiency factor of the work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Minimum Efficiency";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver simuleringstypen for arbejdscenteret.;
                           ENU=Specifies the simulation type for the work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Simulation Type";
                Visible=FALSE }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den produktionskalenderkode, som planl�gningen for arbejdscenteret henviser til.;
                           ENU=Specifies the shop calendar code that the planning of this work center refers to.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Shop Calendar Code" }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s�ge efter den �nskede record, hvis du ikke kan huske v�rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Search Name" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver IPO-bidraget for arbejdscenteret.;
                           ENU=Specifies the overhead rate of this work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Rate";
                Visible=FALSE }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn�r arbejdscenterkortet sidst blev �ndret.;
                           ENU=Specifies when the work center card was last modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified";
                Visible=FALSE }

    { 1102601002;2;Field  ;
                ToolTipML=[DAN=Angiver, hvordan forbruget af varen (komponenten) beregnes og h�ndteres i produktionsprocesserne. Manuelt: Angiv og bogf�r forbrug i forbrugskladden manuelt. Fremad: Bogf�rer automatisk forbrug if�lge produktionsordrekomponentlinjerne, n�r den f�rste handling starter. Bagl�ns: Beregner og bogf�rer automatisk forbrug if�lge produktionsordrekomponentlinjerne, n�r produktionsordren er f�rdig. Pluk + Fremad / Pluk + Bagl�ns: Variationer med lagersted.;
                           ENU=Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Flushing Method";
                Visible=FALSE }

    { 1102601004;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret p� den underleverand�r, der forsyner arbejdscenteret.;
                           ENU=Specifies the number of a subcontractor who supplies this work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Subcontractor No.";
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

