OBJECT Page 6067 Contract Gain/Loss (Customers)
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontraktgevinst/-tab (debitorer);
               ENU=Contract Gain/Loss (Customers)];
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
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ShowMatrix;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MatrixForm@1098 : Page 9261;
                               BEGIN
                                 IF CustomerNo = '' THEN
                                   ERROR(Text003);
                                 IF PeriodStart = 0D THEN
                                   PeriodStart := WORKDATE;
                                 CLEAR(MatrixForm);

                                 MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords,MATRIX_CurrentNoOfColumns,AmountType,PeriodType,
                                   CustomerNo,PeriodStart,ShipToCodeFilter);
                                 MatrixForm.RUNMODAL;
                               END;
                                }
      { 1110    ;1   ;Action    ;
                      CaptionML=[DAN=Forrige s�t;
                                 ENU=Previous Set];
                      ToolTipML=[DAN=G� til det forrige datas�t.;
                                 ENU=Go to the previous set of data.];
                      ApplicationArea=#Service;
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
                      ApplicationArea=#Service;
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
                SourceExpr=PeriodStart;
                OnValidate=BEGIN
                             MATRIX_GenerateColumnCaptions(SetWanted::Initial);
                           END;
                            }

    { 1907524401;1;Group  ;
                CaptionML=[DAN=Filtre;
                           ENU=Filters] }

    { 1   ;2   ;Field     ;
                CaptionML=[DAN=Debitornr.filter;
                           ENU=Customer No. Filter];
                ToolTipML=[DAN=Angiver, hvilke debitorer der skal vises i vinduet ved at angive filtre.;
                           ENU=Specifies which customers are included in the window by setting filters.];
                ApplicationArea=#Service;
                SourceExpr=CustomerNo;
                OnValidate=BEGIN
                             IF NOT Cust.GET(CustomerNo) THEN
                               CLEAR(Cust);
                             ShipToCodeFilter := '';
                             MATRIX_GenerateColumnCaptions(SetWanted::Initial);
                             CustomerNoOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           IF PAGE.RUNMODAL(0,Cust) = ACTION::LookupOK THEN BEGIN
                             Text := Cust."No.";
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Lev.adressekodefilter;
                           ENU=Ship-to Code Filter];
                ToolTipML=[DAN=Angiver, hvilke debitorer der skal medtages i visningen, ved at definere filtre i felterne Leveres til. Hvis du ikke angiver nogen filtre, omfatter vinduet oplysninger om alle debitorer.;
                           ENU=Specifies which customers are included in the view by setting filters in Ship-to fields. If you do not set any filters, the window will include information about all customers.];
                ApplicationArea=#Service;
                SourceExpr=ShipToCodeFilter;
                OnValidate=BEGIN
                             MATRIX_GenerateColumnCaptions(SetWanted::Initial);
                             ShipToCodeFilterOnAfterValidat;
                           END;

                OnLookup=BEGIN
                           ShiptoAddr.RESET;
                           ShiptoAddr.SETRANGE("Customer No.",CustomerNo);
                           IF PAGE.RUNMODAL(0,ShiptoAddr) = ACTION::LookupOK THEN BEGIN
                             Text := ShiptoAddr.Code;
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
      ShiptoAddr@1024 : Record 222;
      Cust@1023 : Record 18;
      MatrixRecords@1099 : ARRAY [32] OF Record 222;
      MatrixRecord@1019 : Record 222;
      MATRIX_CaptionSet@1100 : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange@1101 : Text;
      PKFirstRecInCurrSet@1105 : Text;
      MATRIX_CurrentNoOfColumns@1106 : Integer;
      AmountType@1004 : 'Net Change,Balance at Date';
      PeriodType@1005 : 'Day,Week,Month,Quarter,Year';
      PeriodStart@1008 : Date;
      CustomerNo@1002 : Code[20];
      ShipToCodeFilter@1022 : Text[250];
      Text003@1025 : TextConst 'DAN=Du skal v�lge en debitor i Filtre, Debitornr.filter.;ENU=You must choose a customer in Filters, Customer No. Filter.';
      SetWanted@1006 : 'Initial,Previous,Same,Next';

    LOCAL PROCEDURE MATRIX_GenerateColumnCaptions@1107(SetWanted@1001 : 'First,Previous,Same,Next');
    VAR
      MatrixMgt@1003 : Codeunit 9200;
      RecRef@1002 : RecordRef;
      CurrentMatrixRecordOrdinal@1000 : Integer;
    BEGIN
      CLEAR(MATRIX_CaptionSet);
      CLEAR(MatrixRecords);
      CurrentMatrixRecordOrdinal := 1;
      MatrixRecord.SETRANGE("Customer No.",CustomerNo);
      IF ShipToCodeFilter <> '' THEN
        MatrixRecord.SETFILTER(Code,ShipToCodeFilter);
      RecRef.GETTABLE(MatrixRecord);
      RecRef.SETTABLE(MatrixRecord);

      MatrixMgt.GenerateMatrixData(RecRef,SetWanted,ARRAYLEN(MatrixRecords),2,PKFirstRecInCurrSet,
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

    LOCAL PROCEDURE CustomerNoOnAfterValidate@19016267();
    BEGIN
      CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE ShipToCodeFilterOnAfterValidat@19068628();
    BEGIN
      CurrPage.UPDATE(TRUE);
    END;

    BEGIN
    END.
  }
}

