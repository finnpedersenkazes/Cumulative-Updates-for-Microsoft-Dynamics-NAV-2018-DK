OBJECT Page 6071 Contract Gain/Loss (Contracts)
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontraktgevinst/-tab (kontrakt);
               ENU=Contract Gain/Loss (Contract)];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table2000000007;
    DataCaptionExpr='';
    PageType=Card;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 IF PeriodStart = 0D THEN
                   PeriodStart := WORKDATE;
                 MATRIX_GenerateColumnCaptions(SetWanted::Initial);
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
                      ToolTipML=[DAN=Vis dataoversigten i henhold til de valgte filtre og indstillinger.;
                                 ENU=View the data overview according to the selected filters and options.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ShowMatrix;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MatrixForm@1098 : Page 9267;
                               BEGIN
                                 IF PeriodStart = 0D THEN
                                   PeriodStart := WORKDATE;
                                 CLEAR(MatrixForm);

                                 MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords,MATRIX_CurrentNoOfColumns,AmountType,PeriodType,
                                   ContractFilter,PeriodStart);
                                 MatrixForm.RUNMODAL;
                               END;
                                }
      { 1110    ;1   ;Action    ;
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
                                 MATRIX_GenerateColumnCaptions(SetWanted::Previous);
                               END;
                                }
      { 1112    ;1   ;Action    ;
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
                                 MATRIX_GenerateColumnCaptions(SetWanted::Next);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 22  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 15  ;2   ;Field     ;
                CaptionML=[DAN=Periodestart;
                           ENU=Period Start];
                ToolTipML=[DAN=Angiver startdatoen for den periode, du vil vise.;
                           ENU=Specifies the starting date of the period that you want to view.];
                ApplicationArea=#Service;
                SourceExpr=PeriodStart }

    { 1907524401;1;Group  ;
                CaptionML=[DAN=Filtre;
                           ENU=Filters] }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontraktnr.filter;
                           ENU=Contract No. Filter];
                ToolTipML=[DAN=Angiver det servicekontraktnummer, som du vil se gevinster eller tab for.;
                           ENU=Specifies the service contract number for which you want to view gains or losses.];
                ApplicationArea=#Service;
                SourceExpr=ContractFilter;
                OnValidate=BEGIN
                             MATRIX_GenerateColumnCaptions(SetWanted::Initial);
                             ContractFilterOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           ServContract.RESET;
                           ServContract.SETRANGE("Contract Type",ServContract."Contract Type"::Contract);
                           IF PAGE.RUNMODAL(0,ServContract) = ACTION::LookupOK THEN BEGIN
                             Text := ServContract."Contract No.";
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 1906098301;1;Group  ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 1107;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode bel�bene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,M�ned,Kvartal,�r;
                                 ENU=Day,Week,Month,Quarter,Year];
                ApplicationArea=#Service;
                SourceExpr=PeriodType }

    { 1108;2   ;Field     ;
                CaptionML=[DAN=Vis som;
                           ENU=View as];
                ToolTipML=[DAN=Angiver, hvordan bel�bene vises. Bev�gelse: Bev�gelsen i saldoen for den valgte periode. Saldo til dato: Saldoen p� den sidste dag i den valgte periode.;
                           ENU=Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.];
                OptionCaptionML=[DAN=Bev�gelse,Saldo til dato;
                                 ENU=Net Change,Balance at Date];
                ApplicationArea=#Service;
                SourceExpr=AmountType }

    { 1109;2   ;Field     ;
                CaptionML=[DAN=Kolonnes�t;
                           ENU=Column Set];
                ToolTipML=[DAN=Angiver v�rdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold �ndres ved at v�lge N�ste s�t eller Forrige s�t.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#Service;
                SourceExpr=MATRIX_CaptionRange;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      ServContract@1021 : Record 5965;
      MatrixRecords@1099 : ARRAY [32] OF Record 5965;
      MatrixRecord@1019 : Record 5965;
      MATRIX_CaptionSet@1100 : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange@1101 : Text;
      PKFirstRecInCurrSet@1105 : Text;
      MATRIX_CurrentNoOfColumns@1106 : Integer;
      AmountType@1004 : 'Net Change,Balance at Date';
      PeriodType@1005 : 'Day,Week,Month,Quarter,Year';
      ContractFilter@1006 : Text[250];
      PeriodStart@1008 : Date;
      SetWanted@1002 : 'Initial,Previous,Same,Next';

    LOCAL PROCEDURE MATRIX_GenerateColumnCaptions@1107(SetWanted@1001 : 'First,Previous,Same,Next');
    VAR
      MatrixMgt@1002 : Codeunit 9200;
      RecRef@1003 : RecordRef;
      CurrentMatrixRecordOrdinal@1000 : Integer;
    BEGIN
      CLEAR(MATRIX_CaptionSet);
      CLEAR(MatrixRecords);
      CurrentMatrixRecordOrdinal := 1;
      IF ContractFilter <> '' THEN
        MatrixRecord.SETFILTER("Contract No.",ContractFilter)
      ELSE
        MatrixRecord.SETRANGE("Contract No.");

      RecRef.GETTABLE(MatrixRecord);
      RecRef.SETTABLE(MatrixRecord);

      MatrixMgt.GenerateMatrixData(RecRef,SetWanted,ARRAYLEN(MatrixRecords),1,PKFirstRecInCurrSet,
        MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
      IF MATRIX_CurrentNoOfColumns > 0 THEN BEGIN
        MatrixRecord.SETPOSITION(PKFirstRecInCurrSet);
        MatrixRecord.FIND;
        REPEAT
          MatrixRecords[CurrentMatrixRecordOrdinal].COPY(MatrixRecord);
          CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
        UNTIL (CurrentMatrixRecordOrdinal > MATRIX_CurrentNoOfColumns) OR (MatrixRecord.NEXT <> 1);
      END;
    END;

    LOCAL PROCEDURE ContractFilterOnAfterValidate@19030304();
    BEGIN
      CurrPage.UPDATE(TRUE);
    END;

    BEGIN
    END.
  }
}

