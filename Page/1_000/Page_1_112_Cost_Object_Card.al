OBJECT Page 1112 Cost Object Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningsemnekort;
               ENU=Cost Object Card];
    SourceTable=Table1113;
    PageType=Card;
    RefreshOnActivate=Yes;
    ActionList=ACTIONS
    {
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Omkostningsemne;
                                 ENU=&Cost Object];
                      Image=Costs }
      { 3       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=P&oster;
                                 ENU=E&ntries];
                      ToolTipML=[DAN=Vis poster for omkostningsemnet.;
                                 ENU=View the entries for the cost object.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1103;
                      RunPageView=SORTING(Cost Object Code,Cost Type No.,Allocated,Posting Date);
                      RunPageLink=Cost Object Code=FIELD(Code);
                      Image=Entries }
      { 4       ;2   ;Separator  }
      { 5       ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=&Saldo;
                                 ENU=&Balance];
                      ToolTipML=[DAN=Vis en oversigt over saldoen til dato eller bev‘gelsen for forskellige tidsintervaller for det omkostningsemne, du v‘lger. Du kan v‘lge forskellige tidsintervaller og indstille filtre p† de omkostningssteder og omkostningsemner, som du vil se.;
                                 ENU=View a summary of the balance at date or the net change for different time periods for the cost object that you select. You can select different time intervals and set filters on the cost centers and cost objects that you want to see.];
                      ApplicationArea=#CostAccounting;
                      Image=Balance;
                      OnAction=VAR
                                 CostType@1000 : Record 1103;
                               BEGIN
                                 IF Totaling = '' THEN
                                   CostType.SETFILTER("Cost Object Filter",Code)
                                 ELSE
                                   CostType.SETFILTER("Cost Object Filter",Totaling);

                                 PAGE.RUN(PAGE::"Cost Type Balance",CostType);
                               END;
                                }
      { 6       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Dimensionsv‘rdier;
                                 ENU=Dimension Values];
                      ToolTipML=[DAN=Vis eller rediger dimensionsv‘rdierne for den aktuelle dimension.;
                                 ENU=View or edit the dimension values for the current dimension.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 537;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 8   ;0   ;Container ;
                ContainerType=ContentArea }

    { 9   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for omkostningsemnet.;
                           ENU=Specifies the code for the cost object.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Code }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† omkostningsemnets kort.;
                           ENU=Specifies the name of the cost object card.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Name;
                Importance=Promoted }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form†let med omkostningsemnet, f.eks. Omkostningsemne, Overskrift eller Fra-sum. De nyoprettede omkostningsemner tildeles automatisk typen Omkostningsemne, men dette kan ‘ndres.;
                           ENU=Specifies the purpose of the cost object, such as Cost Object, Heading, or Begin-Total. Newly created cost objects are automatically assigned the Cost Object type, but you can change this.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Line Type" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment‘lles for at give en balancesum. Hvordan poster samment‘lles afh‘nger af v‘rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Totaling }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kommentar, der g‘lder for omkostningsemnet.;
                           ENU=Specifies a comment that applies to the cost object.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Comment }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bev‘gelsen p† kontosaldoen i den periode, der er indtastet i feltet Datofilter.;
                           ENU=Specifies the net change in the account balance during the time period in the Date Filter field.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Net Change";
                Importance=Promoted }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsemnets sorteringsr‘kkef›lge.;
                           ENU=Specifies the sorting order of the cost object.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Sorting Order" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal v‘re en tom linje umiddelbart efter dette omkostningssted, n†r du printer diagrammet over omkostningssteder. Felterne Ny side, Tom linje og Indrykning definerer layoutet af diagrammet over omkostningssteder.;
                           ENU=Specifies whether you want a blank line to appear immediately after this cost center when you print the chart of cost centers. The New Page, Blank Line, and Indentation fields define the layout of the chart of cost centers.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Blank Line" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil starte en ny side direkte efter dette omkostningssted, n†r du udskriver diagrammet over pengestr›mskonti.;
                           ENU=Specifies if you want a new page to start immediately after this cost center when you print the chart of cash flow accounts.];
                ApplicationArea=#CostAccounting;
                SourceExpr="New Page" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Blocked }

  }
  CODE
  {

    BEGIN
    END.
  }
}

