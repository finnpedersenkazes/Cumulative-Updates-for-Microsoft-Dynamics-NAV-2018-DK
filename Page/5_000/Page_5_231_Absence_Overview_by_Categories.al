OBJECT Page 5231 Absence Overview by Categories
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Frav‘rsoversigt pr. kategori;
               ENU=Absence Overview by Categories];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5200;
    DataCaptionExpr='';
    PageType=Card;
    OnOpenPage=BEGIN
                 MATRIX_GenerateColumnCaptions(SetWanted::Initial);
                 IF HASFILTER THEN
                   EmployeeNoFilter := GETFILTER("Employee No. Filter");
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1       ;1   ;Action    ;
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
                                 MatrixForm@1055 : Page 9273;
                               BEGIN
                                 MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords,PeriodType,AbsenceAmountType,EmployeeNoFilter);
                                 MatrixForm.RUNMODAL;
                               END;
                                }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Forrige s‘t;
                                 ENU=Previous Set];
                      ToolTipML=[DAN=G† til det forrige datas‘t.;
                                 ENU=Go to the previous set of data.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(SetWanted::Previous);
                               END;
                                }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=N‘ste s‘t;
                                 ENU=Next Set];
                      ToolTipML=[DAN=G† til det n‘ste datas‘t.;
                                 ENU=Go to the next set of data.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(SetWanted::Next);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options] }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Medarbejdernr.filter;
                           ENU=Employee No. Filter];
                ToolTipML=[DAN=Angiver de medarbejdere, der skal med i oversigten.;
                           ENU=Specifies the employees that will be included in the overview.];
                ApplicationArea=#Advanced;
                SourceExpr=EmployeeNoFilter;
                TableRelation=Employee }

    { 1906098301;1;Group  ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode bel›bene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,M†ned,Kvartal,r,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#Advanced;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             MATRIX_GenerateColumnCaptions(SetWanted::Initial);
                           END;
                            }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Bel›bstype;
                           ENU=Amount Type];
                ToolTipML=[DAN=Angiver frav‘rets bel›bstype.;
                           ENU=Specifies the amount type of the absence.];
                OptionCaptionML=[DAN=Bev‘gelse,Saldo til dato;
                                 ENU=Net Change,Balance at Date];
                ApplicationArea=#Advanced;
                SourceExpr=AbsenceAmountType }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Kolonnes‘t;
                           ENU=Column Set];
                ToolTipML=[DAN=Angiver v‘rdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold ‘ndres ved at v‘lge N‘ste s‘t eller Forrige s‘t.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CaptionRange;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MatrixRecord@1002 : Record 5206;
      MatrixRecords@1056 : ARRAY [32] OF Record 5206;
      PeriodType@1008 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      AbsenceAmountType@1006 : 'Balance at Date,Net Change';
      MATRIX_CaptionSet@1057 : ARRAY [32] OF Text[80];
      EmployeeNoFilter@1004 : Text;
      PKFirstRecInCurrSet@1011 : Text;
      MATRIX_CaptionRange@1010 : Text;
      MatrixCaptions@1009 : Integer;
      SetWanted@1007 : 'Initial,Previous,Same,Next';

    LOCAL PROCEDURE MATRIX_GenerateColumnCaptions@1107(SetWanted@1001 : 'First,Previous,Same,Next');
    VAR
      MatrixMgt@1003 : Codeunit 9200;
      RecRef@1002 : RecordRef;
      CurrentMatrixRecordOrdinal@1000 : Integer;
    BEGIN
      CLEAR(MATRIX_CaptionSet);
      CLEAR(MatrixRecords);
      CurrentMatrixRecordOrdinal := 1;
      RecRef.GETTABLE(MatrixRecord);
      RecRef.SETTABLE(MatrixRecord);

      MatrixMgt.GenerateMatrixData(RecRef,SetWanted,ARRAYLEN(MatrixRecords),1,PKFirstRecInCurrSet,
        MATRIX_CaptionSet,MATRIX_CaptionRange,MatrixCaptions);
      IF MatrixCaptions > 0 THEN BEGIN
        MatrixRecord.SETPOSITION(PKFirstRecInCurrSet);
        MatrixRecord.FIND;
        REPEAT
          MatrixRecords[CurrentMatrixRecordOrdinal].COPY(MatrixRecord);
          CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
        UNTIL (CurrentMatrixRecordOrdinal > MatrixCaptions) OR (MatrixRecord.NEXT <> 1);
      END;
    END;

    BEGIN
    END.
  }
}

