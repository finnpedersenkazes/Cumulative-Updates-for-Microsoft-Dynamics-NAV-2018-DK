OBJECT Page 99000760 Machine Center Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Prod.ress.kort;
               ENU=Machine Center Card];
    SourceTable=Table99000758;
    PageType=Card;
    OnInit=BEGIN
             FromProductionBinCodeEnable := TRUE;
             ToProductionBinCodeEnable := TRUE;
             OpenShopFloorBinCodeEnable := TRUE;
           END;

    OnOpenPage=BEGIN
                 OnActivateForm;
               END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateEnabled;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 62      ;1   ;ActionGroup;
                      CaptionML=[DAN=Pr&od.ress.;
                                 ENU=&Mach. Ctr.];
                      Image=MachineCenter }
      { 66      ;2   ;Action    ;
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
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000784;
                      RunPageView=WHERE(Table Name=CONST(Machine Center));
                      RunPageLink=No.=FIELD(No.);
                      Image=ViewComments }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=&Belastning;
                                 ENU=Lo&ad];
                      ToolTipML=[DAN=F� vist tilg�ngeligheden af produktionsressourcen eller arbejdscenteret, herunder kapaciteten, det allokerede antal, rest efter ordre og belastningen i procentdele af den samlede kapacitet.;
                                 ENU=View the availability of the machine or work center, including its capacity, the allocated quantity, availability after orders, and the load in percent of its total capacity.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000889;
                      RunPageLink=No.=FIELD(No.),
                                  Work Shift Filter=FIELD(Work Shift Filter);
                      Promoted=Yes;
                      Image=WorkCenterLoad;
                      PromotedCategory=Process }
      { 11      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om recorden, f.eks. v�rdien af bogf�rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000762;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Work Shift Filter=FIELD(Work Shift Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 61      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Planl�gn.;
                                 ENU=Pla&nning];
                      Image=Planning }
      { 68      ;2   ;Action    ;
                      CaptionML=[DAN=&Kalender;
                                 ENU=&Calendar];
                      ToolTipML=[DAN=�bn produktionskalenderen, eksempelvis for at se belastningen.;
                                 ENU=Open the shop calendar, for example to see the load.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000770;
                      Promoted=Yes;
                      Image=MachineCenterCalendar;
                      PromotedCategory=Process }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Fra&v�r;
                                 ENU=A&bsence];
                      ToolTipML=[DAN="F� vist, hvilke arbejdsdage der ikke er ledige. ";
                                 ENU="View which working days are not available. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000772;
                      RunPageLink=Capacity Type=CONST(Machine Center),
                                  No.=FIELD(No.),
                                  Date=FIELD(Date Filter);
                      Promoted=Yes;
                      Image=WorkCenterAbsence;
                      PromotedCategory=Process }
      { 10      ;2   ;Action    ;
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
                      Image=TaskList }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No.";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et navn til produktionsressourcen.;
                           ENU=Specifies a name for the machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Name;
                Importance=Promoted }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det arbejdscenter, som produktionsressourcen skal tildeles.;
                           ENU=Specifies the number of the work center to assign this machine center to.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Center No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s�ge efter den �nskede record, hvis du ikke kan huske v�rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Search Name" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf�res under transaktioner - eksempelvis en debitor, som er erkl�ret insolvent, eller en vare, som er sat i karant�ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Blocked }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r produktionsressourcekortet sidst blev �ndret.;
                           ENU=Specifies when the machine center card was last modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified" }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Bogf�ring;
                           ENU=Posting] }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Direct Unit Cost";
                Importance=Promoted }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af centrets omkostning, der omfatter indirekte omkostninger, s�som vedligeholdelse af maskiner.;
                           ENU=Specifies the percentage of the center's cost that includes indirect costs, such as machine maintenance.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Indirect Cost %" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver IPO-bidraget for produktionsressourcen.;
                           ENU=Specifies the overhead rate of this machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Rate" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan forbruget af varen (komponenten) beregnes og h�ndteres i produktionsprocesserne. Manuelt: Angiv og bogf�r forbrug i forbrugskladden manuelt. Fremad: Bogf�rer automatisk forbrug if�lge produktionsordrekomponentlinjerne, n�r den f�rste handling starter. Bagl�ns: Beregner og bogf�rer automatisk forbrug if�lge produktionsordrekomponentlinjerne, n�r produktionsordren er f�rdig. Pluk + Fremad / Pluk + Bagl�ns: Variationer med lagersted.;
                           ENU=Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Flushing Method";
                Importance=Promoted }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Gen. Prod. Posting Group";
                Importance=Promoted }

    { 1905773001;1;Group  ;
                CaptionML=[DAN=Planl�gning;
                           ENU=Scheduling] }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kapaciteten for produktionsressourcen.;
                           ENU=Specifies the capacity of the machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Capacity;
                Importance=Promoted }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver produktionsressourcens effektivitetsfaktor som en procentdel.;
                           ENU=Specifies the efficiency factor as a percentage of the machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Efficiency }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver k�tiden for produktionsressourcen.;
                           ENU=Specifies the queue time of the machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Queue Time" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedskoden for k�tiden.;
                           ENU=Specifies the queue time unit of measure code.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Queue Time Unit of Meas. Code" }

    { 1906729701;1;Group  ;
                CaptionML=[DAN=Ruteops�tning;
                           ENU=Routing Setup] }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid det tager at konfigurere maskinen.;
                           ENU=Specifies how long it takes to set up the machine.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Setup Time";
                Importance=Promoted }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, en sag venter i produktionsressourcen, fra en operation er afsluttet, og indtil den flyttes til n�ste operation.;
                           ENU=Specifies the time a job remains at the machine center after an operation is completed, until it is moved to the next operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Wait Time";
                Importance=Promoted }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det tager at flytte et produktionslot videre p� maskinen.;
                           ENU=Specifies the move time required for a production lot on this machine.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Move Time";
                Importance=Promoted }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det faste spildantal.;
                           ENU=Specifies the fixed scrap quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Fixed Scrap Quantity" }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spildet i procent.;
                           ENU=Specifies the scrap in percent.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap %" }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver send-ahead-antallet.;
                           ENU=Specifies the send-ahead quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Send-Ahead Quantity" }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den minimale procestid for produktionsressourcen.;
                           ENU=Specifies the minimum process time of the machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Minimum Process Time" }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den maksimale procestid for produktionsressourcen.;
                           ENU=Specifies the maximum process time of the machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Maximum Process Time" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor meget tilg�ngelig kapacitet der skal planl�gges samtidig for en operation i produktionsressourcen.;
                           ENU=Specifies how much available capacity must be concurrently planned for one operation at this machine center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Concurrent Capacities" }

    { 1907509201;1;Group  ;
                CaptionML=[DAN=Lagersted;
                           ENU=Warehouse] }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, hvor produktionsressourcen fungerer som standard.;
                           ENU=Specifies the location where the machine center operates by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, der er standard som �ben produktionsplacering p� arbejdscenteret.;
                           ENU=Specifies the bin that functions as the default open shop floor bin at the work center.];
                ApplicationArea=#Warehouse;
                SourceExpr="Open Shop Floor Bin Code";
                Enabled=OpenShopFloorBinCodeEnable }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor de komponenter, der plukkes til produktionen, placeres som standard, f�r de kan forbruges.;
                           ENU=Specifies the bin where components picked for production are placed by default before they can be consumed.];
                ApplicationArea=#Warehouse;
                SourceExpr="To-Production Bin Code";
                Enabled=ToProductionBinCodeEnable }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor f�rdigvarer hentes som standard, n�r processen omfatter lageraktivitet.;
                           ENU=Specifies the bin where finished end items are taken from by default when the process involves warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="From-Production Bin Code";
                Enabled=FromProductionBinCodeEnable }

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
    VAR
      OpenShopFloorBinCodeEnable@19054478 : Boolean INDATASET;
      ToProductionBinCodeEnable@19078604 : Boolean INDATASET;
      FromProductionBinCodeEnable@19048183 : Boolean INDATASET;

    LOCAL PROCEDURE UpdateEnabled@1();
    VAR
      Location@1000 : Record 14;
      EditEnabled@1001 : Boolean;
    BEGIN
      IF "Location Code" <> '' THEN
        Location.GET("Location Code");

      EditEnabled := ("Location Code" <> '') AND Location."Bin Mandatory";
      OpenShopFloorBinCodeEnable := EditEnabled;
      ToProductionBinCodeEnable := EditEnabled;
      FromProductionBinCodeEnable := EditEnabled;
    END;

    LOCAL PROCEDURE OnActivateForm@19002417();
    BEGIN
      UpdateEnabled;
    END;

    BEGIN
    END.
  }
}

