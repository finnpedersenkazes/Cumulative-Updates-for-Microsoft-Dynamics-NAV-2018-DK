OBJECT Page 99000812 Prod. BOM Matrix per Version
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Prod.stykl.matrix pr. version;
               ENU=Prod. BOM Matrix per Version];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table99000788;
    DataCaptionExpr='';
    PageType=Card;
    OnOpenPage=BEGIN
                 BuildMatrix;
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 77      ;1   ;Action    ;
                      CaptionML=[DAN=Vi&s matrix;
                                 ENU=&Show Matrix];
                      ToolTipML=[DAN=Vis dataoversigten i henhold til de valgte filtre og indstillinger.;
                                 ENU=View the data overview according to the selected filters and options.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ShowMatrix;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MatrixForm@1192 : Page 9287;
                               BEGIN
                                 CLEAR(MatrixForm);
                                 MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords,MATRIX_CurrSetLength,ProdBOM,ShowLevel);
                                 MatrixForm.RUNMODAL;
                               END;
                                }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Forrige s�t;
                                 ENU=Previous Set];
                      ToolTipML=[DAN=G� til det forrige datas�t.;
                                 ENU=Go to the previous set of data.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MATRIX_GenerateMatrix(MATRIX_SetWanted::Previous);
                               END;
                                }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=N�ste s�t;
                                 ENU=Next Set];
                      ToolTipML=[DAN=G� til det n�ste datas�t.;
                                 ENU=Go to the next set of data.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MATRIX_GenerateMatrix(MATRIX_SetWanted::Next);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options] }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Niveauer;
                           ENU=Levels];
                ToolTipML=[DAN=Angiver et filter for denne matrix. Du kan v�lge Enkelt eller Flere for at f� vist linjerne i dette filter.;
                           ENU=Specifies a filter for this matrix. You can choose Single or Multi to show the lines in this filter.];
                OptionCaptionML=[DAN=Enkelt,Flere;
                                 ENU=Single,Multi];
                ApplicationArea=#Manufacturing;
                SourceExpr=ShowLevel;
                OnValidate=BEGIN
                             ShowLevelOnAfterValidate;
                           END;
                            }

    { 1906098301;1;Group  ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 13  ;2   ;Field     ;
                CaptionML=[DAN=Kolonnes�t;
                           ENU=Column Set];
                ToolTipML=[DAN=Angiver v�rdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold �ndres ved at v�lge N�ste s�t eller Forrige s�t.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#Manufacturing;
                SourceExpr=MATRIX_CaptionRange;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MatrixRecords@1006 : ARRAY [32] OF Record 99000779;
      MATRIX_MatrixRecord@1005 : Record 99000779;
      ProdBOM@1001 : Record 99000771;
      BOMMatrixMgt@1000 : Codeunit 99000771;
      MATRIX_CaptionSet@1194 : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange@1195 : Text[80];
      ShowLevel@1002 : 'Single,Multi';
      MATRIX_SetWanted@1004 : 'First,Previous,Same,Next';
      PKFirstMatrixRecInSet@1007 : Text[100];
      MATRIX_CurrSetLength@1008 : Integer;

    [External]
    PROCEDURE Set@2(VAR NewProdBOM@1000 : Record 99000771);
    BEGIN
      ProdBOM.COPY(NewProdBOM);
    END;

    LOCAL PROCEDURE BuildMatrix@4();
    BEGIN
      CLEAR(BOMMatrixMgt);
      BOMMatrixMgt.BOMMatrixFromBOM(ProdBOM,ShowLevel = ShowLevel::Multi);
      MATRIX_MatrixRecord.SETRANGE("Production BOM No.",ProdBOM."No.");
      MATRIX_GenerateMatrix(MATRIX_SetWanted::First);
    END;

    LOCAL PROCEDURE MATRIX_GenerateMatrix@3(SetWanted@1001 : 'First,Previous,Same,Next');
    VAR
      MatrixMgt@1003 : Codeunit 9200;
      RecRef@1002 : RecordRef;
      CurrentMatrixRecordOrdinal@1000 : Integer;
    BEGIN
      CLEAR(MATRIX_CaptionSet);
      CLEAR(MatrixRecords);
      CurrentMatrixRecordOrdinal := 0;

      RecRef.GETTABLE(MATRIX_MatrixRecord);
      RecRef.SETTABLE(MATRIX_MatrixRecord);
      MatrixMgt.GenerateMatrixData(RecRef,SetWanted,ARRAYLEN(MatrixRecords),2,PKFirstMatrixRecInSet,MATRIX_CaptionSet,
        MATRIX_CaptionRange,MATRIX_CurrSetLength);

      IF MATRIX_CurrSetLength > 0 THEN BEGIN
        MATRIX_MatrixRecord.SETPOSITION(PKFirstMatrixRecInSet);
        MATRIX_MatrixRecord.FIND;

        REPEAT
          CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
          MatrixRecords[CurrentMatrixRecordOrdinal].COPY(MATRIX_MatrixRecord);
        UNTIL (CurrentMatrixRecordOrdinal = MATRIX_CurrSetLength) OR (MATRIX_MatrixRecord.NEXT <> 1);
      END;
    END;

    [External]
    PROCEDURE SetCaption@1() : Text[80];
    BEGIN
      EXIT(ProdBOM."No." + ' ' + ProdBOM.Description);
    END;

    LOCAL PROCEDURE ShowLevelOnAfterValidate@19042710();
    BEGIN
      BuildMatrix;
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

