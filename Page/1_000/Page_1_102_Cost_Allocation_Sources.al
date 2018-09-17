OBJECT Page 1102 Cost Allocation Sources
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
    CaptionML=[DAN=Omkostningsfordelingskilder;
               ENU=Cost Allocation Sources];
    SourceTable=Table1106;
    SourceTableView=SORTING(Level,Valid From,Valid To,Cost Type Range);
    PageType=List;
    CardPageID=Cost Allocation;
    ActionList=ACTIONS
    {
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Allokering;
                                 ENU=&Allocation];
                      Image=Allocate }
      { 3       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&FordelingsmÜl;
                                 ENU=&Allocation Target];
                      ToolTipML=[DAN=Angiver omkostningsfordelingens mÜlposter.;
                                 ENU=Specifies the cost allocation target entries.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1114;
                      RunPageLink=ID=FIELD(ID);
                      Image=Setup }
      { 4       ;2   ;Action    ;
                      Name=PageChartOfCostTypes;
                      CaptionML=[DAN=&Tilsvarende omkostningstyper;
                                 ENU=&Corresponding Cost Types];
                      ToolTipML=[DAN=Vis de relaterede finanskonti i vinduet Omkostningstyper.;
                                 ENU=View the related G/L accounts in the Chart of Cost Types window.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1100;
                      RunPageLink=No.=FIELD(FILTER(Cost Type Range));
                      Image=CompareCost }
      { 5       ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=Fordelinger;
                                 ENU=Allocations];
                      ToolTipML=[DAN=KontrollÇr og udskriv allokeringskilden og mÜlene, som er defineret i vinduet Omkostningsfordeling med henblik pÜ kontrol.;
                                 ENU=Verify and print the allocation source and targets that are defined in the Cost Allocation window for controlling purposes.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1129;
                      Promoted=Yes;
                      Image=Allocations;
                      PromotedCategory=Report }
      { 24      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=&Functions];
                      Image=Action }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=&Alloker omkostninger;
                                 ENU=&Allocate Costs];
                      ToolTipML=[DAN=Angiver omkostningsfordelingens indstillinger.;
                                 ENU=Specifies the cost allocation options.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1131;
                      Enabled=TRUE;
                      Image=Costs }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=&Beregn fordelingsnõgler;
                                 ENU=&Calculate Allocation Keys];
                      ToolTipML=[DAN=Genberegn de dynamiske fordelinger af alle fordelingsnõgler.;
                                 ENU=Recalculate the dynamic shares of all allocation keys.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Codeunit 1104;
                      Image=Calculate }
    }
  }
  CONTROLS
  {
    { 7   ;0   ;Container ;
                ContainerType=ContentArea }

    { 8   ;1   ;Group     ;
                GroupType=Repeater }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruger-id, som gëlder for omkostningsfordelingen.;
                           ENU=Specifies the user ID that applies to the cost allocation.];
                ApplicationArea=#CostAccounting;
                SourceExpr=ID }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket niveau bogfõring af omkostningsfordeling udfõres pÜ. Dette sikrer f.eks., at omkostninger fordeles pÜ niveau 1 fra omkostningsstedet ADM til omkostningsstederne WORKSHOP og PROD, fõr de tildeles pÜ niveau 2 fra omkostningsstedet PROD til omkostningsemnerne MùBLER, STOLE og MALING.;
                           ENU=Specifies by which level the cost allocation posting is done. For example, this makes sure that costs are allocated at level 1 from the ADM cost center to the WORKSHOP and PROD cost centers, before they are allocated at level 2 from the PROD cost center to the FURNITURE, CHAIRS, and PAINT cost objects.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Level }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsfordelingskildernes variant.;
                           ENU=Specifies the variant of the cost allocation sources.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Variant }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor omkostningsfordelingskilden begynder.;
                           ENU=Specifies the date that the cost allocation source starts.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Valid From" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor omkostningsfordelingskilden slutter.;
                           ENU=Specifies the date that the cost allocation source ends.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Valid To" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et omkostningstypeinterval for at definere, hvilke omkostningstyper der allokeres. Hvis alle omkostninger, som tilskrives omkostningsstedet, er allokeret, behõver du ikke indstille et omkostningstypeinterval.;
                           ENU=Specifies a cost type range to define which cost types are allocated. If all costs that are incurred by the cost center are allocated, you do not have to set a cost type range.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Type Range";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsstedets kode. Koden fungerer som en standardvërdi for omkostningsbogfõring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost center code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Center Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsemnets kode. Koden fungerer som en standardvërdi for omkostningsbogfõring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost object code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Object Code" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den omkostningstype, som kreditbogfõring bogfõres til. De omkostninger, der allokeres, bliver krediteret til kildeomkostningsstedet. Det er en god ide at konfigurere en hjëlpeomkostningstype, sÜ det senere er muligt at identificere bogfõringerne i statistikken og rapporterne.;
                           ENU=Specifies the cost type to which the credit posting is posted. The costs that are allocated are credited to the source cost center. It is useful to set up a helping cost type to later identify the allocation postings in the statistics and reports.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Credit to Cost Type" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af omkostningsfordelingsmÜlets andele.;
                           ENU=Specifies the sum of the shares of the cost allocation targets.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Total Share";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Blocked;
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om allokeringen kommer fra bÜde budgetterede og faktiske omkostninger, kun budgetterede omkostninger eller kun faktiske omkostninger.;
                           ENU=Specifies if the allocation comes from both budgeted and actual costs, only budgeted costs, or only actual costs.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Allocation Source Type";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kommentar, der gëlder for omkostningsfordelingen.;
                           ENU=Specifies a comment that applies to the cost allocation.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Comment }

  }
  CODE
  {

    BEGIN
    END.
  }
}

