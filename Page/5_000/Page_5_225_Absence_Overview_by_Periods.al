OBJECT Page 5225 Absence Overview by Periods
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Fravërsoversigt pr. periode;
               ENU=Absence Overview by Periods];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5200;
    DataCaptionExpr='';
    PageType=Card;
    OnOpenPage=BEGIN
                 SetColumns(SetWanted::Initial);
                 IF HASFILTER THEN
                   CauseOfAbsenceFilter := GETFILTER("Cause of Absence Filter");
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
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ShowMatrix;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 AbsOverviewByPeriodMatrix@1098 : Page 9247;
                               BEGIN
                                 AbsOverviewByPeriodMatrix.Load(MatrixColumnCaptions,MatrixRecords,CauseOfAbsenceFilter,QtyType);
                                 AbsOverviewByPeriodMatrix.RUNMODAL;
                               END;
                                }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Forrige sët;
                                 ENU=Previous Set];
                      ToolTipML=[DAN=GÜ til det forrige datasët.;
                                 ENU=Go to the previous set of data.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SetColumns(SetWanted::Previous);
                               END;
                                }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Nëste sët;
                                 ENU=Next Set];
                      ToolTipML=[DAN=GÜ til det nëste datasët.;
                                 ENU=Go to the next set of data.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SetColumns(SetWanted::Next);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 14  ;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options] }

    { 4   ;2   ;Field     ;
                Name=Cause Of Absence Filter;
                CaptionML=[DAN=FravërsÜrsagsfilter;
                           ENU=Cause of Absence Filter];
                ToolTipML=[DAN=Angiver de fravërsÜrsager, der skal med i oversigten.;
                           ENU=Specifies the absence causes that will be included in the overview.];
                ApplicationArea=#Advanced;
                SourceExpr=CauseOfAbsenceFilter;
                TableRelation="Cause of Absence" }

    { 1906098301;1;Group  ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode belõbene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#Advanced;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             SetColumns(SetWanted::Initial);
                           END;
                            }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Vis som;
                           ENU=View as];
                ToolTipML=[DAN=Angiver, hvordan belõbene vises. Bevëgelse: Bevëgelsen i saldoen for den valgte periode. Saldo til dato: Saldoen pÜ den sidste dag i den valgte periode.;
                           ENU=Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.];
                OptionCaptionML=[DAN=Bevëgelse,Saldo til dato;
                                 ENU=Net Change,Balance at Date];
                ApplicationArea=#Advanced;
                SourceExpr=QtyType }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kolonnesët;
                           ENU=Column Set];
                ToolTipML=[DAN=Angiver vërdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold ëndres ved at vëlge Nëste sët eller Forrige sët.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#Advanced;
                SourceExpr=ColumnSet;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MatrixRecords@1003 : ARRAY [32] OF Record 2000000007;
      QtyType@1007 : 'Balance at Date,Net Change';
      PeriodType@1001 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      CauseOfAbsenceFilter@1010 : Code[10];
      MatrixColumnCaptions@1006 : ARRAY [32] OF Text[1024];
      ColumnSet@1005 : Text[1024];
      SetWanted@1009 : 'Initial,Previous,Same,Next';
      PKFirstRecInCurrSet@1008 : Text[100];
      CurrSetLength@1004 : Integer;

    [Internal]
    PROCEDURE SetColumns@11(SetWanted@1001 : 'Initial,Previous,Same,Next');
    VAR
      MatrixMgt@1000 : Codeunit 9200;
    BEGIN
      MatrixMgt.GeneratePeriodMatrixData(SetWanted,32,FALSE,PeriodType,'',
        PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
    END;

    BEGIN
    END.
  }
}

