OBJECT Page 5119 Sales Cycles
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgsprocesser;
               ENU=Sales Cycles];
    SourceTable=Table5090;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Salgspr&oces;
                                 ENU=Sales &Cycle];
                      Image=Stages }
      { 11      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger s†som v‘rdien for bogf›rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5120;
                      RunPageLink=Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5072;
                      RunPageLink=Table Name=CONST(Sales Cycle),
                                  No.=FIELD(Code),
                                  Sub No.=CONST(0);
                      Image=ViewComments }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=F&aser;
                                 ENU=S&tages];
                      ToolTipML=[DAN=F† vist en liste over de forskellige faser i salgsprocessen.;
                                 ENU=View a list of the different stages within the sales cycle.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5121;
                      RunPageLink=Sales Cycle Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Stages;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for salgsprocessen.;
                           ENU=Specifies the code of the sales cycle.];
                ApplicationArea=#All;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af salgsprocessen.;
                           ENU=Specifies the description of the sales cycle.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den metode, der skal bruges til at beregne sandsynligheden for, at salgsmuligheder fuldf›rer salgsprocessen. Der er fire indstillinger:;
                           ENU=Specifies the method to use to calculate the probability of opportunities completing the sales cycle. There are four options:];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Probability Calculation" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Blocked }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du har tildelt kommentarer til salgsprocessen.;
                           ENU=Specifies that you have assigned comments to the sales cycle.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 5   ;1   ;Part      ;
                CaptionML=[DAN=Statistik;
                           ENU=Statistics];
                ApplicationArea=#RelationshipMgmt;
                SubPageLink=Code=FIELD(Code);
                PagePartID=Page5175;
                PartType=Page }

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

