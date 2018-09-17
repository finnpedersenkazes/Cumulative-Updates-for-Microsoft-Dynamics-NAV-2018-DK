OBJECT Page 9291 Work Center Calendar Matrix
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Matrix for arbejdscenterkalender;
               ENU=Work Center Calendar Matrix];
    LinksAllowed=No;
    SourceTable=Table99000754;
    DataCaptionExpr='';
    PageType=List;
    OnOpenPage=BEGIN
                 MATRIX_CurrentNoOfMatrixColumn := ARRAYLEN(MATRIX_CellData);
               END;

    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1044 : Integer;
                     BEGIN
                       MATRIX_CurrentColumnOrdinal := 0;
                       WHILE MATRIX_CurrentColumnOrdinal < MATRIX_CurrentNoOfMatrixColumn DO BEGIN
                         MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
                         MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Arb.center;
                                 ENU=Wor&k Ctr.];
                      Image=WorkCenter }
      { 9       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=K&apacitetsposter;
                                 ENU=Capacity Ledger E&ntries];
                      ToolTipML=[DAN=Vis kapacitetsposterne for den involverede produktionsordre. Kapaciteten registreres enten som tid (operationstid, stoptid eller opstillingstid) eller som antal (spildantal eller afgangsantal).;
                                 ENU=View the capacity ledger entries of the involved production order. Capacity is recorded either as time (run time, stop time, or setup time) or as quantity (scrap quantity or output quantity).];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5832;
                      RunPageView=SORTING(Work Center No.,Work Shift Code,Posting Date);
                      RunPageLink=Work Center No.=FIELD(No.),
                                  Posting Date=FIELD(Date Filter);
                      Image=CapacityLedger }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000784;
                      RunPageView=WHERE(Table Name=CONST(Work Center));
                      RunPageLink=No.=FIELD(No.);
                      Image=ViewComments }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=&Belastning;
                                 ENU=Lo&ad];
                      ToolTipML=[DAN=F� vist tilg�ngeligheden af produktionsressourcen eller arbejdscenteret, herunder kapaciteten, det allokerede antal, rest efter ordre og belastningen i procentdele af den samlede kapacitet.;
                                 ENU=View the availability of the machine or work center, including its capacity, the allocated quantity, availability after orders, and the load in percent of its total capacity.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000887;
                      RunPageView=SORTING(No.);
                      RunPageLink=No.=FIELD(No.);
                      Image=WorkCenterLoad }
      { 13      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om recorden, f.eks. v�rdien af bogf�rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000756;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Work Shift Filter=FIELD(Work Shift Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Pla&nl�gning;
                                 ENU=Pla&nning];
                      Image=Planning }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=&Frav�r;
                                 ENU=A&bsence];
                      ToolTipML=[DAN="F� vist, hvilke arbejdsdage der ikke er ledige. ";
                                 ENU="View which working days are not available. "];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000772;
                      RunPageView=SORTING(Capacity Type,No.,Date);
                      RunPageLink=Capacity Type=CONST(Work Center),
                                  No.=FIELD(No.),
                                  Date=FIELD(Date Filter);
                      Image=WorkCenterAbsence }
      { 16      ;2   ;Action    ;
                      CaptionML=[DAN=&Operationsliste;
                                 ENU=Ta&sk List];
                      ToolTipML=[DAN=Vis oversigten over operationer, der er planlagt for arbejdscenteret.;
                                 ENU=View the list of operations that are scheduled for the work center.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000915;
                      RunPageView=SORTING(Type,No.,Starting Date);
                      RunPageLink=Type=CONST(Work Center),
                                  No.=FIELD(No.),
                                  Routing Status=FILTER(<>Finished);
                      Image=TaskList }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 5       ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn;
                                 ENU=Calculate];
                      ToolTipML=[DAN=Opdater vinduet med alle nye kapacitetsposter.;
                                 ENU=Update the window with any new capacity ledger entries.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99001046;
                      Image=Calculate }
      { 14      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Genberegn;
                                 ENU=Recalculate];
                      ToolTipML=[DAN=Opdater kalenderposterne efter �ndringer i produktionskalenderen eller i kalenderfrav�rsposterne. Programmet kontrollerer, om de eksisterende kalenderposter svarer til produktionskalenderen og kalenderfrav�rsposterne. Hvis de ikke stemmer overens, rettes kalenderen.;
                                 ENU=Update the calendar entries after you make modifications in the shop calendar or with the calendar absences. The program checks the existing calendar entries to see whether they correspond to the shop calendar and the calendar absences. If they don't correspond, the appropriate calendar is corrected.];
                      ApplicationArea=#Manufacturing;
                      Image=Refresh;
                      OnAction=VAR
                                 Calendarentry@1001 : Record 99000757;
                               BEGIN
                                 Calendarentry.SETRANGE("Capacity Type",Calendarentry."Capacity Type"::"Work Center");
                                 REPORT.RUNMODAL(REPORT::"Recalculate Calendar",TRUE,TRUE,Calendarentry);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� arbejdscenteret.;
                           ENU=Specifies the name of the work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Name }

    { 1012;2   ;Field     ;
                Name=Field1;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[1];
                CaptionClass='3,' + MATRIX_CaptionSet[1];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(1);
                            END;
                             }

    { 1013;2   ;Field     ;
                Name=Field2;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[2];
                CaptionClass='3,' + MATRIX_CaptionSet[2];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(2);
                            END;
                             }

    { 1014;2   ;Field     ;
                Name=Field3;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[3];
                CaptionClass='3,' + MATRIX_CaptionSet[3];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(3);
                            END;
                             }

    { 1015;2   ;Field     ;
                Name=Field4;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[4];
                CaptionClass='3,' + MATRIX_CaptionSet[4];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(4);
                            END;
                             }

    { 1016;2   ;Field     ;
                Name=Field5;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[5];
                CaptionClass='3,' + MATRIX_CaptionSet[5];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(5);
                            END;
                             }

    { 1017;2   ;Field     ;
                Name=Field6;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[6];
                CaptionClass='3,' + MATRIX_CaptionSet[6];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(6);
                            END;
                             }

    { 1018;2   ;Field     ;
                Name=Field7;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[7];
                CaptionClass='3,' + MATRIX_CaptionSet[7];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(7);
                            END;
                             }

    { 1019;2   ;Field     ;
                Name=Field8;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[8];
                CaptionClass='3,' + MATRIX_CaptionSet[8];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(8);
                            END;
                             }

    { 1020;2   ;Field     ;
                Name=Field9;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[9];
                CaptionClass='3,' + MATRIX_CaptionSet[9];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(9);
                            END;
                             }

    { 1021;2   ;Field     ;
                Name=Field10;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[10];
                CaptionClass='3,' + MATRIX_CaptionSet[10];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(10);
                            END;
                             }

    { 1022;2   ;Field     ;
                Name=Field11;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[11];
                CaptionClass='3,' + MATRIX_CaptionSet[11];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(11);
                            END;
                             }

    { 1023;2   ;Field     ;
                Name=Field12;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[12];
                CaptionClass='3,' + MATRIX_CaptionSet[12];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(12);
                            END;
                             }

    { 1024;2   ;Field     ;
                Name=Field13;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[13];
                CaptionClass='3,' + MATRIX_CaptionSet[13];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(13);
                            END;
                             }

    { 1025;2   ;Field     ;
                Name=Field14;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[14];
                CaptionClass='3,' + MATRIX_CaptionSet[14];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(14);
                            END;
                             }

    { 1026;2   ;Field     ;
                Name=Field15;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[15];
                CaptionClass='3,' + MATRIX_CaptionSet[15];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(15);
                            END;
                             }

    { 1027;2   ;Field     ;
                Name=Field16;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[16];
                CaptionClass='3,' + MATRIX_CaptionSet[16];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(16);
                            END;
                             }

    { 1028;2   ;Field     ;
                Name=Field17;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[17];
                CaptionClass='3,' + MATRIX_CaptionSet[17];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(17);
                            END;
                             }

    { 1029;2   ;Field     ;
                Name=Field18;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[18];
                CaptionClass='3,' + MATRIX_CaptionSet[18];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(18);
                            END;
                             }

    { 1030;2   ;Field     ;
                Name=Field19;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[19];
                CaptionClass='3,' + MATRIX_CaptionSet[19];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(19);
                            END;
                             }

    { 1031;2   ;Field     ;
                Name=Field20;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[20];
                CaptionClass='3,' + MATRIX_CaptionSet[20];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(20);
                            END;
                             }

    { 1032;2   ;Field     ;
                Name=Field21;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[21];
                CaptionClass='3,' + MATRIX_CaptionSet[21];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(21);
                            END;
                             }

    { 1033;2   ;Field     ;
                Name=Field22;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[22];
                CaptionClass='3,' + MATRIX_CaptionSet[22];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(22);
                            END;
                             }

    { 1034;2   ;Field     ;
                Name=Field23;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[23];
                CaptionClass='3,' + MATRIX_CaptionSet[23];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(23);
                            END;
                             }

    { 1035;2   ;Field     ;
                Name=Field24;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[24];
                CaptionClass='3,' + MATRIX_CaptionSet[24];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(24);
                            END;
                             }

    { 1036;2   ;Field     ;
                Name=Field25;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[25];
                CaptionClass='3,' + MATRIX_CaptionSet[25];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(25);
                            END;
                             }

    { 1037;2   ;Field     ;
                Name=Field26;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[26];
                CaptionClass='3,' + MATRIX_CaptionSet[26];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(26);
                            END;
                             }

    { 1038;2   ;Field     ;
                Name=Field27;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[27];
                CaptionClass='3,' + MATRIX_CaptionSet[27];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(27);
                            END;
                             }

    { 1039;2   ;Field     ;
                Name=Field28;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[28];
                CaptionClass='3,' + MATRIX_CaptionSet[28];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(28);
                            END;
                             }

    { 1040;2   ;Field     ;
                Name=Field29;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[29];
                CaptionClass='3,' + MATRIX_CaptionSet[29];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(29);
                            END;
                             }

    { 1041;2   ;Field     ;
                Name=Field30;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[30];
                CaptionClass='3,' + MATRIX_CaptionSet[30];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(30);
                            END;
                             }

    { 1042;2   ;Field     ;
                Name=Field31;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[31];
                CaptionClass='3,' + MATRIX_CaptionSet[31];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(31);
                            END;
                             }

    { 1043;2   ;Field     ;
                Name=Field32;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[32];
                CaptionClass='3,' + MATRIX_CaptionSet[32];
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(32);
                            END;
                             }

  }
  CODE
  {
    VAR
      MatrixRecords@1000 : ARRAY [32] OF Record 2000000007;
      MATRIX_CurrentNoOfMatrixColumn@1082 : Integer;
      MATRIX_CellData@1083 : ARRAY [32] OF Decimal;
      MATRIX_CaptionSet@1084 : ARRAY [32] OF Text[80];

    LOCAL PROCEDURE SetDateFilter@1085(MATRIX_ColumnOrdinal@1000 : Integer);
    BEGIN
      IF MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" THEN
        SETRANGE("Date Filter",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
      ELSE
        SETRANGE("Date Filter",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start",MatrixRecords[MATRIX_ColumnOrdinal]."Period End")
    END;

    [Internal]
    PROCEDURE Load@1086(MatrixColumns1@1005 : ARRAY [32] OF Text[1024];VAR MatrixRecords1@1006 : ARRAY [32] OF Record 2000000007;CurrentNoOfMatrixColumns@1007 : Integer);
    BEGIN
      COPYARRAY(MATRIX_CaptionSet,MatrixColumns1,1);
      COPYARRAY(MatrixRecords,MatrixRecords1,1);
      MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
    END;

    LOCAL PROCEDURE MATRIX_OnDrillDown@1087(MATRIX_ColumnOrdinal@1008 : Integer);
    VAR
      CalendarEntry@1001 : Record 99000757;
    BEGIN
      CalendarEntry.SETRANGE("Capacity Type",CalendarEntry."Capacity Type"::"Work Center");
      CalendarEntry.SETRANGE("No.","No.");

      IF MatrixRecords[MATRIX_ColumnOrdinal]."Period Start" = MatrixRecords[MATRIX_ColumnOrdinal]."Period End" THEN
        CalendarEntry.SETRANGE(Date,MatrixRecords[MATRIX_ColumnOrdinal]."Period Start")
      ELSE
        CalendarEntry.SETRANGE(Date,
          MatrixRecords[MATRIX_ColumnOrdinal]."Period Start",MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

      PAGE.RUNMODAL(PAGE::"Calendar Entries",CalendarEntry);
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1089(MATRIX_ColumnOrdinal@1010 : Integer);
    BEGIN
      SetDateFilter(MATRIX_ColumnOrdinal);
      CALCFIELDS("Capacity (Effective)");
      MATRIX_CellData[MATRIX_ColumnOrdinal] := "Capacity (Effective)" ;
    END;

    BEGIN
    END.
  }
}

