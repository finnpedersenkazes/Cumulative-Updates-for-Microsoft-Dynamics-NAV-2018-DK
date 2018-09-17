OBJECT Page 5228 Misc. Articles Overview
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udstyrsoversigt;
               ENU=Misc. Articles Overview];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5200;
    DataCaptionExpr='';
    PageType=Card;
    OnOpenPage=BEGIN
                 MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::First);
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
                                 MatrixForm@1043 : Page 9281;
                               BEGIN
                                 CLEAR(MatrixForm);

                                 MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords,MATRIX_CurrentNoOfColumns);
                                 MatrixForm.RUNMODAL;
                               END;
                                }
      { 3       ;1   ;Action    ;
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
                                 MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Previous);
                               END;
                                }
      { 4       ;1   ;Action    ;
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
                                 MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Next);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 2   ;2   ;Field     ;
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
      MatrixRecords@1044 : ARRAY [32] OF Record 5213;
      MATRIX_MatrixRecord@1001 : Record 5213;
      MatrixMgt@1000 : Codeunit 9200;
      MATRIX_CaptionSet@1045 : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange@1046 : Text[80];
      MATRIX_PKFirstRecInCurrSet@1050 : Text;
      MATRIX_CurrentNoOfColumns@1051 : Integer;
      MATRIX_SetWanted@1005 : 'First,Previous,Same,Next';

    LOCAL PROCEDURE MATRIX_GenerateColumnCaptions@1096(SetWanted@1000 : 'First,Previous,Same,Next');
    VAR
      RecRef@1002 : RecordRef;
      CurrentMatrixRecordOrdinal@1001 : Integer;
    BEGIN
      CLEAR(MATRIX_CaptionSet);
      CLEAR(MatrixRecords);
      CurrentMatrixRecordOrdinal := 1;

      RecRef.GETTABLE(MATRIX_MatrixRecord);
      RecRef.SETTABLE(MATRIX_MatrixRecord);
      MatrixMgt.GenerateMatrixData(RecRef,SetWanted,ARRAYLEN(MatrixRecords),1,MATRIX_PKFirstRecInCurrSet,MATRIX_CaptionSet
        ,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);

      IF MATRIX_CurrentNoOfColumns > 0 THEN BEGIN
        MATRIX_MatrixRecord.SETPOSITION(MATRIX_PKFirstRecInCurrSet);
        MATRIX_MatrixRecord.FIND;
        REPEAT
          MatrixRecords[CurrentMatrixRecordOrdinal].COPY(MATRIX_MatrixRecord);
          CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
        UNTIL (CurrentMatrixRecordOrdinal > MATRIX_CurrentNoOfColumns) OR (MATRIX_MatrixRecord.NEXT <> 1);
      END;
    END;

    BEGIN
    END.
  }
}

