OBJECT Page 6004 Res. Availability (Service)
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressourcedisponering (service);
               ENU=Res. Availability (Service)];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table156;
    DataCaptionExpr='';
    PageType=Card;
    OnOpenPage=BEGIN
                 ServMgtSetup.GET;
                 ServHeader.GET(CurrentDocumentType,CurrentDocumentNo);
                 SetColumns(SetWanted::Initial);
                 UpdateFields;
               END;

    OnAfterGetRecord=BEGIN
                       IF ServHeader.GET(CurrentDocumentType,CurrentDocumentNo) THEN
                         "Service Zone Filter" := ServHeader."Service Zone Code"
                       ELSE
                         "Service Zone Filter" := '';

                       CALCFIELDS("In Customer Zone");
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
                                 MatrixForm@1117 : Page 9229;
                               BEGIN
                                 MatrixForm.SetData(CurrentDocumentType,CurrentDocumentNo,CurrentServItemLineNo,CurrentEntryNo,
                                   MatrixColumnCaptions,MatrixRecords,PeriodType);
                                 MatrixForm.SETTABLEVIEW(Rec);
                                 MatrixForm.RUNMODAL;
                               END;
                                }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Forrige s�t;
                                 ENU=Previous Set];
                      ToolTipML=[DAN=G� til det forrige datas�t.;
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
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=N�ste s�t;
                                 ENU=Next Set];
                      ToolTipML=[DAN=G� til det n�ste datas�t.;
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

    { 22  ;1   ;Group     ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode bel�bene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,M�ned,Kvartal,�r,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#Service;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             DateControl;
                             SetColumns(SetWanted::Initial);
                           END;
                            }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver de datoer, der bruges til at filtrere bel�bene i vinduet.;
                           ENU=Specifies the dates that will be used to filter the amounts in the window.];
                ApplicationArea=#Service;
                SourceExpr=DateFilter;
                OnValidate=BEGIN
                             DateControl;
                             SetColumns(SetWanted::Initial);
                           END;
                            }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Kolonnes�t;
                           ENU=Column set];
                ToolTipML=[DAN=Angiver v�rdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold �ndres ved at v�lge N�ste s�t eller Forrige s�t.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#Service;
                SourceExpr=ColumnsSet;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MatrixRecords@1021 : ARRAY [32] OF Record 2000000007;
      ResRec2@1041 : Record 156;
      ServMgtSetup@1001 : Record 5911;
      ServHeader@1002 : Record 5900;
      ApplicationManagement@1039 : Codeunit 1;
      CurrentDocumentType@1019 : Integer;
      CurrentDocumentNo@1007 : Code[20];
      CurrentServItemLineNo@1008 : Integer;
      CurrentEntryNo@1009 : Integer;
      PeriodType@1012 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      DateFilter@1035 : Text;
      SetWanted@1048 : 'Initial,Previous,Same,Next';
      PKFirstRecInCurrSet@1047 : Text[1024];
      MatrixColumnCaptions@1046 : ARRAY [32] OF Text[100];
      ColumnsSet@1045 : Text[1024];
      CurrSetLength@1044 : Integer;

    [External]
    PROCEDURE SetData@2(DocumentType@1003 : Integer;DocumentNo@1000 : Code[20];ServItemLineNo@1001 : Integer;EntryNo@1002 : Integer);
    BEGIN
      CurrentDocumentType := DocumentType;
      CurrentDocumentNo := DocumentNo;
      CurrentServItemLineNo := ServItemLineNo;
      CurrentEntryNo := EntryNo;
    END;

    LOCAL PROCEDURE UpdateFields@3();
    BEGIN
    END;

    LOCAL PROCEDURE DateControl@6();
    BEGIN
      IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;
      ResRec2.SETFILTER("Date Filter",DateFilter);
      DateFilter := ResRec2.GETFILTER("Date Filter");
    END;

    [Internal]
    PROCEDURE SetColumns@11(SetWanted@1001 : 'Initial,Previous,Same,Next');
    VAR
      MatrixMgt@1000 : Codeunit 9200;
    BEGIN
      MatrixMgt.GeneratePeriodMatrixData(SetWanted,32,FALSE,PeriodType,DateFilter,
        PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnsSet,CurrSetLength,MatrixRecords);
    END;

    BEGIN
    END.
  }
}

