OBJECT Page 491 Items by Location
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varer pr. lokation;
               ENU=Items by Location];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table27;
    DataCaptionExpr='';
    PageType=ListPlus;
    OnInit=BEGIN
             TempMatrixLocation.GetLocationsIncludingUnspecifiedLocation(FALSE,FALSE);
           END;

    OnOpenPage=BEGIN
                 SetColumns(MATRIX_SetWanted::Initial);
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 31      ;1   ;Action    ;
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
                                 SetColumns(MATRIX_SetWanted::Previous);
                               END;
                                }
      { 32      ;1   ;Action    ;
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
                                 SetColumns(MATRIX_SetWanted::Next);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 12  ;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options] }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Vis varer i transit;
                           ENU=Show Items in Transit];
                ToolTipML=[DAN=Angiver de varer, der er i transit mellem lokationer.;
                           ENU=Specifies the items in transit between locations.];
                ApplicationArea=#Advanced;
                SourceExpr=ShowInTransit;
                OnValidate=BEGIN
                             ShowInTransitOnAfterValidate;
                           END;
                            }

    { 15  ;2   ;Field     ;
                CaptionML=[DAN=Vis kolonnenavn;
                           ENU=Show Column Name];
                ToolTipML=[DAN=Angiver, at navnene p� kolonner vises i matrixvinduet.;
                           ENU=Specifies that the names of columns are shown in the matrix window.];
                ApplicationArea=#Location;
                SourceExpr=ShowColumnName;
                OnValidate=BEGIN
                             ShowColumnNameOnAfterValidate;
                           END;
                            }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Kolonnes�t;
                           ENU=Column Set];
                ToolTipML=[DAN=Angiver v�rdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold �ndres ved at v�lge N�ste s�t eller Forrige s�t.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#Location;
                SourceExpr=MATRIX_CaptionRange;
                Editable=FALSE }

    { 1   ;1   ;Part      ;
                Name=MatrixForm;
                ApplicationArea=#Location;
                PagePartID=Page9231;
                PartType=Page;
                ShowFilter=No }

  }
  CODE
  {
    VAR
      TempMatrixLocation@1000 : TEMPORARY Record 14;
      MatrixRecords@1010 : ARRAY [32] OF Record 14;
      MatrixRecordRef@1007 : RecordRef;
      MATRIX_SetWanted@1006 : 'Initial,Previous,Same,Next';
      ShowColumnName@1002 : Boolean;
      ShowInTransit@1003 : Boolean;
      MATRIX_CaptionSet@1008 : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange@1011 : Text[100];
      MATRIX_PKFirstRecInCurrSet@1001 : Text[80];
      MATRIX_CurrSetLength@1004 : Integer;
      UnspecifiedLocationCodeTxt@1005 : TextConst '@@@=Code for unspecified location;DAN=IKKE ANGIVET;ENU=UNSPECIFIED';

    [Internal]
    PROCEDURE SetColumns@6(SetWanted@1002 : 'Initial,Previous,Same,Next');
    VAR
      MatrixMgt@1000 : Codeunit 9200;
      CaptionFieldNo@1001 : Integer;
      CurrentMatrixRecordOrdinal@1003 : Integer;
    BEGIN
      TempMatrixLocation.SETRANGE("Use As In-Transit",ShowInTransit);

      CLEAR(MATRIX_CaptionSet);
      CLEAR(MatrixRecords);
      CurrentMatrixRecordOrdinal := 1;

      MatrixRecordRef.GETTABLE(TempMatrixLocation);
      MatrixRecordRef.SETTABLE(TempMatrixLocation);

      IF ShowColumnName THEN
        CaptionFieldNo := TempMatrixLocation.FIELDNO(Name)
      ELSE
        CaptionFieldNo := TempMatrixLocation.FIELDNO(Code);

      MatrixMgt.GenerateMatrixData(MatrixRecordRef,SetWanted,ARRAYLEN(MatrixRecords),CaptionFieldNo,MATRIX_PKFirstRecInCurrSet,
        MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrSetLength);

      IF MATRIX_CaptionSet[1] = '' THEN BEGIN
        MATRIX_CaptionSet[1] := UnspecifiedLocationCodeTxt;
        MATRIX_CaptionRange := STRSUBSTNO('%1%2',MATRIX_CaptionSet[1],MATRIX_CaptionRange);
      END;

      IF MATRIX_CurrSetLength > 0 THEN BEGIN
        TempMatrixLocation.SETPOSITION(MATRIX_PKFirstRecInCurrSet);
        TempMatrixLocation.FIND;
        REPEAT
          MatrixRecords[CurrentMatrixRecordOrdinal].COPY(TempMatrixLocation);
          CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
        UNTIL (CurrentMatrixRecordOrdinal > MATRIX_CurrSetLength) OR (TempMatrixLocation.NEXT <> 1);
      END;

      UpdateMatrixSubform;
    END;

    LOCAL PROCEDURE ShowColumnNameOnAfterValidate@19074585();
    BEGIN
      SetColumns(MATRIX_SetWanted::Same);
    END;

    LOCAL PROCEDURE ShowInTransitOnAfterValidate@19033613();
    BEGIN
      SetColumns(MATRIX_SetWanted::Initial);
    END;

    LOCAL PROCEDURE UpdateMatrixSubform@10();
    BEGIN
      CurrPage.MatrixForm.PAGE.Load(MATRIX_CaptionSet,MatrixRecords,TempMatrixLocation,MATRIX_CurrSetLength);
      CurrPage.MatrixForm.PAGE.SETRECORD(Rec);
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

