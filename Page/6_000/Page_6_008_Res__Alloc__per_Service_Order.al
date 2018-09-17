OBJECT Page 6008 Res. Alloc. per Service Order
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressource allokeret pr. serviceordre;
               ENU=Resource Allocated per Service Order];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5900;
    DataCaptionExpr='';
    PageType=Card;
    OnOpenPage=BEGIN
                 SetColumns(SetWanted::Initial);
                 IF HASFILTER THEN
                   ResourceFilter := GETFILTER("Resource Filter");
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 13      ;1   ;Action    ;
                      Name=ShowMatrix;
                      CaptionML=[DAN=Vis matrix;
                                 ENU=Show Matrix];
                      ToolTipML=[DAN=èbn matrixvinduet for at se data i henhold til de angivne vërdier.;
                                 ENU=Open the matrix window to see data according to the specified values.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ShowMatrix;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 HorizontalRecord@1003 : Record 5950;
                                 ResPerServiceOrderMatrix@1000 : Page 9215;
                               BEGIN
                                 HorizontalRecord.SETRANGE("Resource No.",ResourceFilter);
                                 ServiceHeader.SETFILTER("Resource Filter",ResourceFilter);
                                 ResPerServiceOrderMatrix.Load(ServiceHeader,HorizontalRecord,MatrixColumnCaptions,MatrixRecords,CurrSetLength);
                                 ResPerServiceOrderMatrix.RUNMODAL;
                               END;
                                }
      { 10      ;1   ;Action    ;
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
      { 14      ;1   ;Action    ;
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

    { 12  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 1   ;2   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Ressourcefilter;
                           ENU=Resource Filter];
                ToolTipML=[DAN=Angiver den ressource, som tildelingerne gëlder for.;
                           ENU=Specifies the resource that the allocations apply to.];
                ApplicationArea=#Advanced;
                SourceExpr=ResourceFilter;
                TableRelation=Resource;
                LookupPageID=Resource List }

    { 1906098301;1;Group  ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode belõbene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#Advanced;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             DateControl;
                             SetColumns(SetWanted::Initial);
                             PeriodTypeOnAfterValidate;
                           END;
                            }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver de datoer, der bruges til at filtrere belõbene i vinduet.;
                           ENU=Specifies the dates that will be used to filter the amounts in the window.];
                ApplicationArea=#Advanced;
                SourceExpr=DateFilter;
                OnValidate=BEGIN
                             DateControl;
                             SetColumns(SetWanted::Initial);
                             DateFilterOnAfterValidate;
                           END;
                            }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Kolonnesët;
                           ENU=Column set];
                ToolTipML=[DAN=Angiver vërdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold ëndres ved at vëlge Nëste sët eller Forrige sët.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#Advanced;
                SourceExpr=ColumnsSet;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MatrixRecords@1001 : ARRAY [32] OF Record 2000000007;
      ResRec2@1028 : Record 156;
      ServiceHeader@1020 : Record 5900;
      ApplicationManagement@1027 : Codeunit 1;
      DateFilter@1000 : Text;
      ResourceFilter@1018 : Text;
      PeriodType@1005 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      SetWanted@1023 : 'Initial,Previous,Same,Next';
      PKFirstRecInCurrSet@1007 : Text[1024];
      MatrixColumnCaptions@1006 : ARRAY [32] OF Text[100];
      ColumnsSet@1003 : Text[1024];
      CurrSetLength@1024 : Integer;

    LOCAL PROCEDURE DateControl@6();
    BEGIN
      IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;
      ResRec2.SETFILTER("Date Filter",DateFilter);
      DateFilter := ResRec2.GETFILTER("Date Filter");
    END;

    [Internal]
    PROCEDURE SetColumns@7(SetWanted@1001 : 'Initial,Previous,Same,Next');
    VAR
      MatrixMgt@1000 : Codeunit 9200;
    BEGIN
      MatrixMgt.GeneratePeriodMatrixData(SetWanted,32,FALSE,PeriodType,DateFilter,
        PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnsSet,CurrSetLength,MatrixRecords);
    END;

    LOCAL PROCEDURE PeriodTypeOnAfterValidate@19015506();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE DateFilterOnAfterValidate@19006009();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

