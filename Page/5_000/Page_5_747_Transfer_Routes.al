OBJECT Page 5747 Transfer Routes
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Overflytningsruter;
               ENU=Transfer Routes];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table14;
    DataCaptionExpr='';
    SourceTableView=WHERE(Use As In-Transit=CONST(No));
    PageType=Card;
    OnOpenPage=BEGIN
                 MATRIX_MatrixRecord.SETRANGE("Use As In-Transit",FALSE);
                 MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::First);
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1104    ;1   ;Action    ;
                      CaptionML=[DAN=Forrige s�t;
                                 ENU=Previous Set];
                      ToolTipML=[DAN=G� til det forrige datas�t.;
                                 ENU=Go to the previous set of data.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Previous);
                               END;
                                }
      { 1106    ;1   ;Action    ;
                      CaptionML=[DAN=N�ste s�t;
                                 ENU=Next Set];
                      ToolTipML=[DAN=G� til det n�ste datas�t.;
                                 ENU=Go to the next set of data.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
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

    { 13  ;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options] }

    { 11  ;2   ;Field     ;
                CaptionML=[DAN=Vis;
                           ENU=Show];
                ToolTipML=[DAN=Angiver, om den valgte v�rdi vises i vinduet.;
                           ENU=Specifies if the selected value is shown in the window.];
                OptionCaptionML=[DAN=Transitkode,Spedit�rkode,Spedit�rservicekode;
                                 ENU=In-Transit Code,Shipping Agent Code,Shipping Agent Service Code];
                ApplicationArea=#Location;
                SourceExpr=Show;
                OnValidate=BEGIN
                             UpdateMatrixSubform;
                           END;
                            }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Vis overflyt til-navn;
                           ENU=Show Transfer-to Name];
                ToolTipML=[DAN=Angiver, at navnet p� den lokation, der overflyttes til, vises p� ruten.;
                           ENU="Specifies that the name of the transfer-to location is shown on the routing. "];
                ApplicationArea=#Location;
                SourceExpr=ShowTransferToName;
                OnValidate=BEGIN
                             ShowTransferToNameOnAfterValid;
                           END;
                            }

    { 1103;2   ;Field     ;
                CaptionML=[DAN=Kolonnes�t;
                           ENU=Column Set];
                ToolTipML=[DAN=Angiver v�rdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold �ndres ved at v�lge N�ste s�t eller Forrige s�t.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#Location;
                SourceExpr=MATRIX_CaptionRange;
                Editable=FALSE }

    { 2   ;1   ;Part      ;
                Name=MatrixForm;
                ApplicationArea=#Location;
                PagePartID=Page9285;
                PartType=Page }

  }
  CODE
  {
    VAR
      MATRIX_MatrixRecord@1001 : Record 14;
      MatrixRecords@1000 : ARRAY [32] OF Record 14;
      MATRIX_CaptionSet@1094 : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange@1095 : Text;
      MATRIX_PKFirstRecInCurrSet@1099 : Text;
      MATRIX_CurrentNoOfColumns@1100 : Integer;
      ShowTransferToName@1003 : Boolean;
      Show@1004 : 'In-Transit Code,Shipping Agent Code,Shipping Agent Service Code';
      MATRIX_SetWanted@1007 : 'First,Previous,Same,Next';

    LOCAL PROCEDURE MATRIX_GenerateColumnCaptions@1107(SetWanted@1001 : 'First,Previous,Same,Next');
    VAR
      MatrixMgt@1003 : Codeunit 9200;
      RecRef@1002 : RecordRef;
      CurrentMatrixRecordOrdinal@1000 : Integer;
      CaptionField@1004 : Integer;
    BEGIN
      CLEAR(MATRIX_CaptionSet);
      CLEAR(MatrixRecords);
      CurrentMatrixRecordOrdinal := 1;

      RecRef.GETTABLE(MATRIX_MatrixRecord);
      RecRef.SETTABLE(MATRIX_MatrixRecord);

      IF ShowTransferToName THEN
        CaptionField := 2
      ELSE
        CaptionField := 1;

      MatrixMgt.GenerateMatrixData(RecRef,SetWanted,ARRAYLEN(MatrixRecords),CaptionField,MATRIX_PKFirstRecInCurrSet,MATRIX_CaptionSet
        ,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);

      IF MATRIX_CurrentNoOfColumns > 0 THEN BEGIN
        MATRIX_MatrixRecord.SETPOSITION(MATRIX_PKFirstRecInCurrSet);
        MATRIX_MatrixRecord.FIND;
        REPEAT
          MatrixRecords[CurrentMatrixRecordOrdinal].COPY(MATRIX_MatrixRecord);
          CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
        UNTIL (CurrentMatrixRecordOrdinal > MATRIX_CurrentNoOfColumns) OR (MATRIX_MatrixRecord.NEXT <> 1);
      END;

      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE ShowTransferToNameOnAfterValid@19010412();
    BEGIN
      MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Same);
    END;

    LOCAL PROCEDURE UpdateMatrixSubform@3();
    BEGIN
      CurrPage.MatrixForm.PAGE.Load(MATRIX_CaptionSet,MatrixRecords,MATRIX_CurrentNoOfColumns,Show);
      CurrPage.MatrixForm.PAGE.SETRECORD(Rec);
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

