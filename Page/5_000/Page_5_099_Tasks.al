OBJECT Page 5099 Tasks
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opgaver;
               ENU=Tasks];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5102;
    DataCaptionExpr=FORMAT(SELECTSTR(OutputOption + 1,Text001));
    PageType=Card;
    OnOpenPage=BEGIN
                 CurrSetLength := 32;
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
                      ToolTipML=[DAN=Vis opgaverne i en matrix.;
                                 ENU=Show tasks in a matrix.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ShowMatrix;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MatrixForm@1124 : Page 9255;
                               BEGIN
                                 CLEAR(MatrixForm);
                                 MatrixForm.Load(MatrixColumnCaptions,MatrixRecords,TableOption,ColumnDateFilters,OutputOption,FilterSalesPerson,
                                   FilterTeam,FilterCampaign,FilterContact,StatusFilter,IncludeClosed,PriorityFilter);
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
      { 2       ;1   ;Action    ;
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
                OptionCaptionML=[DAN=Sëlger,Team,Kampagne,Kontakt;
                                 ENU=Salesperson,Team,Campaign,Contact];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=TableOption }

    { 25  ;2   ;Field     ;
                CaptionML=[DAN=Vis;
                           ENU=Show];
                ToolTipML=[DAN=Angiver, om den valgte vërdi vises i vinduet.;
                           ENU=Specifies if the selected value is shown in the window.];
                OptionCaptionML=[DAN=Antal opgaver,Kontaktnr.;
                                 ENU=No. of Tasks,Contact No.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=OutputOption }

    { 1907524401;1;Group  ;
                CaptionML=[DAN=Filtre;
                           ENU=Filters] }

    { 1   ;2   ;Field     ;
                CaptionML=[DAN=Sëlgerfilter;
                           ENU=Salesperson Filter];
                ToolTipML=[DAN=Angiver, hvilke sëlgere der medtages i visningen af matrix for opgaver.;
                           ENU=Specifies which salespeople will be included in the Tasks matrix view.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=FilterSalesPerson;
                TableRelation=Salesperson/Purchaser }

    { 29  ;2   ;Field     ;
                CaptionML=[DAN=Teamfilter;
                           ENU=Team Filter];
                ToolTipML=[DAN=Angiver, hvilke teams der medtages i visningen af matrix for opgaver.;
                           ENU=Specifies which teams will be included in the Tasks matrix view.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=FilterTeam;
                TableRelation=Team }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Kampagnefilter;
                           ENU=Campaign Filter];
                ToolTipML=[DAN=Angiver, hvilke kampagner der medtages i visningen af matrix for opgaver.;
                           ENU=Specifies which campaigns will be included in the Tasks matrix view.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=FilterCampaign;
                TableRelation=Campaign }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Filter til kontaktvirks.nr.;
                           ENU=Contact Company No. Filter];
                ToolTipML=[DAN=Angiver, hvilke kontakter der medtages i visningen af matrix for opgaver.;
                           ENU=Specifies which contacts will be included in the Tasks matrix view.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=FilterContact;
                TableRelation=Contact WHERE (Type=CONST(Company)) }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Statusfilter;
                           ENU=Status Filter];
                ToolTipML=[DAN=Angiver, hvilke opgavestatusser der medtages i visningen af matrix for opgaver.;
                           ENU=Specifies what tasks statuses will be included in the Tasks matrix view.];
                OptionCaptionML=[DAN=" ,Ikke startet,Igangsat,Afsluttet,Venter,Udskudt";
                                 ENU=" ,Not Started,In Progress,Completed,Waiting,Postponed"];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=StatusFilter }

    { 39  ;2   ;Field     ;
                CaptionML=[DAN=Inkluder lukkede opgaver;
                           ENU=Include Closed Tasks];
                ToolTipML=[DAN=Angiver, om lukkede opgaver medtages i visningen af matrix for opgaver.;
                           ENU=Specifies if closed tasks will be included in the Tasks matrix view.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=IncludeClosed }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Prioritetsfilter;
                           ENU=Priority Filter];
                ToolTipML=[DAN=Angiver, hvilke opgaveprioriteter der medtages i visningen af matrix for opgaver.;
                           ENU=Specifies which tasks priorities will be included in the Tasks matrix view.];
                OptionCaptionML=[DAN=" ,Lav,Normal,Hõj";
                                 ENU=" ,Low,Normal,High"];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=PriorityFilter }

    { 1906098301;1;Group  ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode belõbene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             CreateCaptionSet(SetWanted::Initial);
                           END;
                            }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Kolonnesët;
                           ENU=Column Set];
                ToolTipML=[DAN=Angiver vërdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold ëndres ved at vëlge Nëste sët eller Forrige sët.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=ColumnSet;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MatrixRecords@1125 : ARRAY [32] OF Record 2000000007;
      MatrixMgt@1000 : Codeunit 9200;
      PeriodType@1006 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      OutputOption@1007 : 'No. of Tasks,Contact No.';
      TableOption@1008 : 'Salesperson,Team,Campaign,Contact';
      StatusFilter@1009 : ' ,Not Started,In Progress,Completed,Waiting,Postponed';
      PriorityFilter@1010 : ' ,Low,Normal,High';
      IncludeClosed@1011 : Boolean;
      FilterSalesPerson@1012 : Code[250];
      FilterTeam@1013 : Code[250];
      FilterCampaign@1014 : Code[250];
      FilterContact@1015 : Code[250];
      Text001@1016 : TextConst 'DAN=Antal opgaver,Kontaktnr.;ENU=No. of Tasks,Contact No.';
      ColumnDateFilters@1026 : ARRAY [32] OF Text[50];
      MatrixColumnCaptions@1035 : ARRAY [32] OF Text[1024];
      ColumnSet@1034 : Text[1024];
      SetWanted@1033 : 'Initial,Previous,Same,Next';
      PKFirstRecInCurrSet@1032 : Text[100];
      CurrSetLength@1031 : Integer;

    LOCAL PROCEDURE CreateCaptionSet@16(SetWanted@1005 : 'Initial,Previous,Same,Next');
    BEGIN
      MatrixMgt.GeneratePeriodMatrixData(SetWanted,32,FALSE,PeriodType,'',
        PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
    END;

    BEGIN
    END.
  }
}

