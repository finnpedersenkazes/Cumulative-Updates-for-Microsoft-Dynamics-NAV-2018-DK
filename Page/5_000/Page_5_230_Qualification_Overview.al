OBJECT Page 5230 Qualification Overview
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kvalifikationsoversigt;
               ENU=Qualification Overview];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    DataCaptionExpr='';
    PageType=Card;
    OnOpenPage=BEGIN
                 MATRIX_GenerateColumnCaptions(SetWanted::Initial);
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
                                 MatrixForm@1050 : Page 9271;
                               BEGIN
                                 MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords);
                                 MatrixForm.RUNMODAL;
                               END;
                                }
      { 15      ;1   ;Action    ;
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
      { 16      ;1   ;Action    ;
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

    { 10  ;1   ;Group     ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 13  ;2   ;Field     ;
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
      MatrixRecord@1003 : Record 5202;
      MatrixRecords@1051 : ARRAY [32] OF Record 5202;
      MATRIX_CaptionSet@1052 : ARRAY [32] OF Text[80];
      PKFirstRecInCurrSet@1005 : Text;
      MATRIX_CaptionRange@1002 : Text[80];
      MatrixCaptions@1001 : Integer;
      SetWanted@1000 : 'Initial,Previous,Same,Next';

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

