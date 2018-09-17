OBJECT Page 5131 Opportunities
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgsmuligheder;
               ENU=Opportunities];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5102;
    DataCaptionExpr=FORMAT(SELECTSTR(OutPutOption + 1,Text002));
    PageType=Card;
    OnOpenPage=BEGIN
                 CreateCaptionSet(SetWanted::Initial);
               END;

    OnFindRecord=BEGIN
                   EXIT(TRUE);
                 END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 77      ;1   ;Action    ;
                      Name=ShowMatrix;
                      CaptionML=[DAN=Vi&s matrix;
                                 ENU=&Show Matrix];
                      ToolTipML=[DAN=Vis dataoversigten i henhold til de valgte filtre og indstillinger.;
                                 ENU=View the data overview according to the selected filters and options.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ShowMatrix;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MatrixForm@1634 : Page 9257;
                                 EstValFilter@1001 : Text;
                                 CloseOppFilter@1002 : Text;
                                 SuccesChanceFilter@1003 : Text;
                                 ProbabilityFilter@1004 : Text;
                                 CompleteFilter@1005 : Text;
                                 CaldCurrValFilter@1006 : Text;
                                 SalesCycleFilter@1007 : Text;
                                 CycleStageFilter@1008 : Text;
                               BEGIN
                                 CLEAR(MatrixForm);
                                 CloseOppFilter := GETFILTER("Close Opportunity Filter");
                                 SuccesChanceFilter := GETFILTER("Chances of Success % Filter");
                                 ProbabilityFilter := GETFILTER("Probability % Filter");
                                 CompleteFilter := GETFILTER("Completed % Filter");
                                 EstValFilter := GETFILTER("Estimated Value Filter");
                                 CaldCurrValFilter := GETFILTER("Calcd. Current Value Filter");
                                 SalesCycleFilter := GETFILTER("Sales Cycle Filter");
                                 CycleStageFilter := GETFILTER("Sales Cycle Stage Filter");

                                 MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords,TableOption,OutPutOption,RoundingFactor,
                                   OptionStatusFilter,CloseOppFilter,SuccesChanceFilter,ProbabilityFilter,CompleteFilter,EstValFilter,
                                   CaldCurrValFilter,SalesCycleFilter,CycleStageFilter,Periods);

                                 MatrixForm.RUNMODAL;
                               END;
                                }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Forrige sët;
                                 ENU=Previous Set];
                      ToolTipML=[DAN=GÜ til det forrige datasët.;
                                 ENU=Go to the previous set of data.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CreateCaptionSet(SetWanted::Previous);
                               END;
                                }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=Nëste sët;
                                 ENU=Next Set];
                      ToolTipML=[DAN=GÜ til det nëste datasët.;
                                 ENU=Go to the next set of data.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CreateCaptionSet(SetWanted::Next);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 6   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Vis som linjer;
                           ENU=Show as Lines];
                ToolTipML=[DAN=Angiver, hvilke vërdier du vil have vist som linjer i vinduet. PÜ denne mÜde fÜr du vist det samme matrixvindue fra forskellige synsvinkler, isër nÜr du bruger bÜde feltet Vis som linjer og Vis som kolonner.;
                           ENU=Specifies which values you want to show as lines in the window. This allows you to see the same matrix window from various perspectives, especially when you use both the Show as Lines field and the Show as Columns field.];
                OptionCaptionML=[DAN=Sëlger,Kampagne,Kontakt;
                                 ENU=Salesperson,Campaign,Contact];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=TableOption }

    { 25  ;2   ;Field     ;
                CaptionML=[DAN=Vis;
                           ENU=Show];
                ToolTipML=[DAN=Angiver, om den valgte vërdi vises i vinduet.;
                           ENU=Specifies if the selected value is shown in the window.];
                OptionCaptionML=[DAN=Antal salgsmuligheder,AnslÜet vërdi (RV),Beregn. aktuel vërdi (RV),Gnsn. anslÜet vërdi (RV),Gnsn. beregn. aktuel vërdi (RV);
                                 ENU=No of Opportunities,Estimated Value (LCY),Calc. Current Value (LCY),Avg. Estimated Value (LCY),Avg. Calc. Current Value (LCY)];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=OutPutOption }

    { 23  ;2   ;Field     ;
                CaptionML=[DAN=Afrundingsfaktor;
                           ENU=Rounding Factor];
                ToolTipML=[DAN=Angiver afrundingsfaktoren for belõb.;
                           ENU=Specifies the factor that is used to round the amounts.];
                OptionCaptionML=[DAN=Ingen,1,1000,1000000;
                                 ENU=None,1,1000,1000000];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=RoundingFactor }

    { 1907524401;1;Group  ;
                CaptionML=[DAN=Filtre;
                           ENU=Filters] }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Statusfilter;
                           ENU=Status Filter];
                ToolTipML=[DAN=Angiver, hvilken status der vises salgsmuligheder for.;
                           ENU=Specifies for which status opportunities are displayed.];
                OptionCaptionML=[DAN=Igangsat,Vundet,Tabt;
                                 ENU=In Progress,Won,Lost];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=OptionStatusFilter }

    { 1906098301;1;Group  ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode belõbene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             PeriodTypeOnAfterValidate;
                           END;
                            }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Kolonnesët;
                           ENU=Column Set];
                ToolTipML=[DAN=Angiver vërdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold ëndres ved at vëlge Nëste sët eller Forrige sët.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=MATRIX_CaptionRange;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MatrixRecords@1635 : ARRAY [32] OF Record 2000000007;
      MatrixMgt@1001 : Codeunit 9200;
      MATRIX_CaptionSet@1636 : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange@1637 : Text[80];
      PeriodType@1006 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      OptionStatusFilter@1007 : 'In Progress,Won,Lost';
      OutPutOption@1008 : 'No of Opportunities,Estimated Value (LCY),Calc. Current Value (LCY),Avg. Estimated Value (LCY),Avg. Calc. Current Value (LCY)';
      RoundingFactor@1009 : 'None,1,1000,1000000';
      TableOption@1010 : 'SalesPerson,Campaign,Contact';
      Text002@1011 : TextConst 'DAN=Antal salgsmuligheder,AnslÜet vërdi (RV),Beregn. aktuel vërdi (RV),Gnsn. anslÜet vërdi (RV),Gnsn. beregn. aktuel vërdi (RV);ENU=No of Opportunities,Estimated Value (LCY),Calc. Current Value (LCY),Avg. Estimated Value (LCY),Avg. Calc. Current Value (LCY)';
      Periods@1021 : Integer;
      Datefilter@1000 : Text[1024];
      SetWanted@1016 : 'Initial,Previous,Same,Next';
      PKFirstRecInCurrSet@1017 : Text[100];

    LOCAL PROCEDURE CreateCaptionSet@16(SetWanted@1001 : 'Initial,Previous,Same,Next');
    BEGIN
      MatrixMgt.GeneratePeriodMatrixData(SetWanted,ARRAYLEN(MatrixRecords),FALSE,PeriodType,Datefilter,PKFirstRecInCurrSet,
        MATRIX_CaptionSet,MATRIX_CaptionRange,Periods,MatrixRecords);
    END;

    LOCAL PROCEDURE PeriodTypeOnAfterValidate@19015506();
    BEGIN
      CreateCaptionSet(SetWanted::Initial);
    END;

    BEGIN
    END.
  }
}

