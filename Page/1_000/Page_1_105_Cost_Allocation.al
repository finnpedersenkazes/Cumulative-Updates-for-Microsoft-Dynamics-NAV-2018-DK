OBJECT Page 1105 Cost Allocation
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningsfordeling;
               ENU=Cost Allocation];
    SourceTable=Table1106;
    PageType=Document;
    ActionList=ACTIONS
    {
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Allokering;
                                 ENU=Allo&cation];
                      Image=Allocate }
      { 3       ;2   ;Separator  }
      { 4       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Omkost&ningsposter;
                                 ENU=Cost E&ntries];
                      ToolTipML=[DAN=Vis omkostningsposter, som kan komme fra kilder sÜsom automatisk overfõrsel af finansposter til omkostningsposter, manuel bogfõring for rene omkostningsposter, interne afgifter og manuelle allokeringer samt automatisk tildeling af bogfõringer for faktiske omkostninger.;
                                 ENU=View cost entries, which can come from sources such as automatic transfer of general ledger entries to cost entries, manual posting for pure cost entries, internal charges, and manual allocations, and automatic allocation postings for actual costs.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1103;
                      RunPageView=SORTING(Allocation ID,Posting Date);
                      RunPageLink=Allocation ID=FIELD(ID);
                      Image=CostEntries }
      { 5       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 6       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Beregn fordelingsnõgle;
                                 ENU=Calculate Allocation Key];
                      ToolTipML=[DAN=Genberegn de dynamiske fordelinger af fordelingsnõglen.;
                                 ENU=Recalculate the dynamic shares of the allocation key.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      Image=CalculateCost;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CostAccAllocation@1000 : Codeunit 1104;
                               BEGIN
                                 CostAccAllocation.CalcAllocationKey(Rec);
                               END;
                                }
      { 8       ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Fordelinger;
                                 ENU=Allocations];
                      ToolTipML=[DAN=KontrollÇr og udskriv allokeringskilden og mÜlene, som er defineret i vinduet Omkostningsfordeling med henblik pÜ kontrol.;
                                 ENU=Verify and print the allocation source and targets that are defined in the Cost Allocation window for controlling purposes.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1129;
                      Promoted=Yes;
                      Image=Allocations;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 10  ;0   ;Container ;
                ContainerType=ContentArea }

    { 11  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det id, som gëlder for omkostningsfordelingen.;
                           ENU=Specifies the ID that applies to the cost allocation.];
                ApplicationArea=#CostAccounting;
                SourceExpr=ID }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket niveau bogfõring af omkostningsfordeling udfõres pÜ. Dette sikrer f.eks., at omkostninger fordeles pÜ niveau 1 fra omkostningsstedet ADM til omkostningsstederne WORKSHOP og PROD, fõr de tildeles pÜ niveau 2 fra omkostningsstedet PROD til omkostningsemnerne MùBLER, STOLE og MALING.;
                           ENU=Specifies by which level the cost allocation posting is done. For example, this makes sure that costs are allocated at level 1 from the ADM cost center to the WORKSHOP and PROD cost centers, before they are allocated at level 2 from the PROD cost center to the FURNITURE, CHAIRS, and PAINT cost objects.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Level;
                Importance=Promoted }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor omkostningsfordelingen begynder.;
                           ENU=Specifies the date when the cost allocation starts.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Valid From";
                Importance=Promoted }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor omkostningsfordelingen slutter.;
                           ENU=Specifies the date that the cost allocation ends.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Valid To";
                Importance=Promoted }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsfordelingernes variant.;
                           ENU=Specifies the variant of the cost allocation.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Variant;
                Importance=Promoted }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et omkostningstypeinterval for at definere, hvilke omkostningstyper der allokeres. Hvis alle omkostninger, som tilskrives omkostningsstedet, er allokeret, behõver du ikke indstille et omkostningstypeinterval.;
                           ENU=Specifies a cost type range to define which cost types are allocated. If all costs that are incurred by the cost center are allocated, you do not have to set a cost type range.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Type Range" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsstedets kode. Koden fungerer som en standardvërdi for omkostningsbogfõring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost center code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Center Code" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsemnets kode. Koden fungerer som en standardvërdi for omkostningsbogfõring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost object code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Object Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den omkostningstype, som kreditbogfõring bogfõres til. De omkostninger, der allokeres, bliver krediteret til kildeomkostningsstedet. Det er en god ide at konfigurere en hjëlpeomkostningstype, sÜ det senere er muligt at identificere bogfõringerne i statistikken og rapporterne.;
                           ENU=Specifies the cost type to which the credit posting is posted. The costs that are allocated are credited to the source cost center. It is useful to set up a helping cost type to later identify the allocation postings in the statistics and reports.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Credit to Cost Type" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Blocked }

    { 22  ;1   ;Part      ;
                Name=AllocTarget;
                ApplicationArea=#CostAccounting;
                SubPageLink=ID=FIELD(ID);
                PagePartID=Page1106 }

    { 23  ;1   ;Group     ;
                CaptionML=[DAN=Statistik;
                           ENU=Statistics] }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om allokeringen kommer fra bÜde budgetterede og faktiske omkostninger, kun budgetterede omkostninger eller kun faktiske omkostninger.;
                           ENU=Specifies if the allocation comes from both budgeted and actual costs, only budgeted costs, or only actual costs.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Allocation Source Type";
                Importance=Promoted }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr omkostningsfordelingen sidst blev rettet.;
                           ENU=Specifies when the cost allocation was last modified.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Last Date Modified" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogfõrt posten, der skal bruges, f.eks. i ëndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#CostAccounting;
                SourceExpr="User ID" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kommentar, der gëlder for omkostningsfordelingen.;
                           ENU=Specifies a comment that applies to the cost allocation.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Comment }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af de fordelte andele.;
                           ENU=Specifies the sum of the shares allocated.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Total Share" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

