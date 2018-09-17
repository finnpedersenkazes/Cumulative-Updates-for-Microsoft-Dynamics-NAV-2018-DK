OBJECT Page 99000754 Work Center Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Arbejdscenterkort;
               ENU=Work Center Card];
    SourceTable=Table99000754;
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
      { 54      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Arb.center;
                                 ENU=Wor&k Ctr.];
                      Image=WorkCenter }
      { 45      ;2   ;Action    ;
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
      { 63      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(99000754),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000784;
                      RunPageView=WHERE(Table Name=CONST(Work Center));
                      RunPageLink=No.=FIELD(No.);
                      Image=ViewComments }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=&Belastning;
                                 ENU=Lo&ad];
                      ToolTipML=[DAN=FÜ vist tilgëngeligheden af produktionsressourcen eller arbejdscenteret, herunder kapaciteten, det allokerede antal, rest efter ordre og belastningen i procentdele af den samlede kapacitet.;
                                 ENU=View the availability of the machine or work center, including its capacity, the allocated quantity, availability after orders, and the load in percent of its total capacity.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000887;
                      RunPageLink=No.=FIELD(No.),
                                  Work Shift Filter=FIELD(Work Shift Filter);
                      Promoted=Yes;
                      Image=WorkCenterLoad;
                      PromotedCategory=Process }
      { 56      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000756;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Work Shift Filter=FIELD(Work Shift Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 53      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Planlëgn.;
                                 ENU=Pla&nning];
                      Image=Planning }
      { 59      ;2   ;Action    ;
                      CaptionML=[DAN=&Kalender;
                                 ENU=&Calendar];
                      ToolTipML=[DAN=èbn produktionskalenderen, eksempelvis for at se belastningen.;
                                 ENU=Open the shop calendar, for example to see the load.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000769;
                      Promoted=Yes;
                      Image=MachineCenterCalendar;
                      PromotedCategory=Process }
      { 74      ;2   ;Action    ;
                      CaptionML=[DAN=Fra&vër;
                                 ENU=A&bsence];
                      ToolTipML=[DAN="FÜ vist, hvilke arbejdsdage der ikke er ledige. ";
                                 ENU="View which working days are not available. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000772;
                      RunPageView=SORTING(Capacity Type,No.,Date,Starting Time);
                      RunPageLink=Capacity Type=CONST(Work Center),
                                  No.=FIELD(No.),
                                  Date=FIELD(Date Filter);
                      Promoted=Yes;
                      Image=WorkCenterAbsence;
                      PromotedCategory=Process }
      { 36      ;2   ;Action    ;
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
                      Image=TaskList }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1906187306;1 ;Action    ;
                      CaptionML=[DAN=U.leverandõr - ordreoversigt;
                                 ENU=Subcontractor - Dispatch List];
                      ToolTipML=[DAN=Vis oversigten over materiale, der skal sendes til produktionsunderleverandõrer.;
                                 ENU=View the list of material to be sent to manufacturing subcontractors.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000789;
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
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
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
                ToolTipML=[DAN=Angiver navnet pÜ arbejdscenteret.;
                           ENU=Specifies the name of the work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Name;
                Importance=Promoted }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdscentergruppen, hvis arbejdscenteret eller den underliggende produktionsressource er tilknyttet en arbejdscentergruppe.;
                           ENU=Specifies the work center group, if the work center or underlying machine center is assigned to a work center group.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Center Group Code";
                Importance=Promoted }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt arbejdscenter.;
                           ENU=Specifies an alternate work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Alternate Work Center" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at sõge efter den õnskede record, hvis du ikke kan huske vërdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Search Name" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Blocked }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr arbejdscenterkortet sidst blev ëndret.;
                           ENU=Specifies when the work center card was last modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified" }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Bogfõring;
                           ENU=Posting] }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Direct Unit Cost";
                Importance=Promoted }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af centrets omkostning, der omfatter indirekte omkostninger, sÜsom vedligeholdelse af maskiner.;
                           ENU=Specifies the percentage of the center's cost that includes indirect costs, such as machine maintenance.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Indirect Cost %" }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver IPO-bidraget for arbejdscenteret.;
                           ENU=Specifies the overhead rate of this work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Rate" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den beregning af kostpris, der skal udfõres.;
                           ENU=Specifies the unit cost calculation that is to be made.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost Calculation";
                Importance=Promoted }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor du kan angive kostprisen.;
                           ENU=Specifies where to define the unit costs.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Specific Unit Cost" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik pÜ analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilgëngelige pÜ alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik pÜ analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilgëngelige pÜ alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Code" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den underleverandõr, der forsyner arbejdscenteret.;
                           ENU=Specifies the number of a subcontractor who supplies this work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Subcontractor No." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan forbruget af varen (komponenten) beregnes og hÜndteres i produktionsprocesserne. Manuelt: Angiv og bogfõr forbrug i forbrugskladden manuelt. Fremad: Bogfõrer automatisk forbrug ifõlge produktionsordrekomponentlinjerne, nÜr den fõrste handling starter. Baglëns: Beregner og bogfõrer automatisk forbrug ifõlge produktionsordrekomponentlinjerne, nÜr produktionsordren er fërdig. Pluk + Fremad / Pluk + Baglëns: Variationer med lagersted.;
                           ENU=Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Flushing Method";
                Importance=Promoted }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Gen. Prod. Posting Group";
                Importance=Promoted }

    { 1905773001;1;Group  ;
                CaptionML=[DAN=Planlëgning;
                           ENU=Scheduling] }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code";
                Importance=Promoted }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kapaciteten pÜ arbejdscenteret.;
                           ENU=Specifies the capacity of the work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Capacity;
                Importance=Promoted }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdscenterets effektivitetsfaktor som en procentdel.;
                           ENU=Specifies the efficiency factor as a percentage of the work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Efficiency }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den fëlles kalender bruges.;
                           ENU=Specifies whether the consolidated calendar is used.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Consolidated Calendar" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den produktionskalenderkode, som planlëgningen for arbejdscenteret henviser til.;
                           ENU=Specifies the shop calendar code that the planning of this work center refers to.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Shop Calendar Code";
                Importance=Promoted }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kõtiden for arbejdscenteret.;
                           ENU=Specifies the queue time of the work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Queue Time" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedskoden for kõtiden.;
                           ENU=Specifies the queue time unit of measure code.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Queue Time Unit of Meas. Code" }

    { 1907509201;1;Group  ;
                CaptionML=[DAN=Lagersted;
                           ENU=Warehouse] }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor arbejdscenteret fungerer som standard.;
                           ENU=Specifies the location where the work center operates by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, der er standard som Üben produktionsplacering pÜ arbejdscenteret.;
                           ENU=Specifies the bin that functions as the default open shop floor bin at the work center.];
                ApplicationArea=#Warehouse;
                SourceExpr="Open Shop Floor Bin Code";
                Enabled=OpenShopFloorBinCodeEnable }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering i produktionsomrÜdet, hvor de komponenter, der plukkes til produktionen placeres som standard, fõr de kan forbruges.;
                           ENU=Specifies the bin in the production area where components that are picked for production are placed by default before they can be consumed.];
                ApplicationArea=#Warehouse;
                SourceExpr="To-Production Bin Code";
                Enabled=ToProductionBinCodeEnable }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering i produktionsomrÜdet, hvor fërdigvarer hentes som standard, nÜr processen omfatter lageraktivitet.;
                           ENU=Specifies the bin in the production area where finished end items are taken by default when the process involves warehouse activity.];
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
    BEGIN
      IF "Location Code" <> '' THEN
        Location.GET("Location Code");

      OpenShopFloorBinCodeEnable := Location."Bin Mandatory";
      ToProductionBinCodeEnable := Location."Bin Mandatory";
      FromProductionBinCodeEnable := Location."Bin Mandatory";
    END;

    LOCAL PROCEDURE OnActivateForm@19002417();
    BEGIN
      UpdateEnabled;
    END;

    BEGIN
    END.
  }
}

