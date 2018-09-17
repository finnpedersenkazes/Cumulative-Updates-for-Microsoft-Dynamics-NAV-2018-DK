OBJECT Page 9247 Abs. Overview by Period Matrix
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
    CaptionML=[DAN=Matrix for frav�rsoversigt pr. periode;
               ENU=Abs. Overview by Period Matrix];
    LinksAllowed=No;
    SourceTable=Table5200;
    DataCaptionExpr='';
    PageType=List;
    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1047 : Integer;
                       MATRIX_NoOfColumns@1048 : Integer;
                     BEGIN
                       MATRIX_CurrentColumnOrdinal := 1;
                       MATRIX_NoOfColumns := ARRAYLEN(MATRIX_CellData);

                       WHILE MATRIX_CurrentColumnOrdinal <= MATRIX_NoOfColumns DO BEGIN
                         MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
                         MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
                       END;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                Name=No.;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 17  ;2   ;Field     ;
                Name=Full Name;
                CaptionML=[DAN=Fulde navn;
                           ENU=Full Name];
                ToolTipML=[DAN=Angiver navnet p� ressourcen.;
                           ENU=Specifies the name of resource.];
                ApplicationArea=#Advanced;
                SourceExpr=FullName }

    { 1015;2   ;Field     ;
                Name=Field1;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[1];
                CaptionClass='3,' + MATRIX_ColumnCaption[1];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(1);
                            END;
                             }

    { 1016;2   ;Field     ;
                Name=Field2;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[2];
                CaptionClass='3,' + MATRIX_ColumnCaption[2];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(2);
                            END;
                             }

    { 1017;2   ;Field     ;
                Name=Field3;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[3];
                CaptionClass='3,' + MATRIX_ColumnCaption[3];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(3);
                            END;
                             }

    { 1018;2   ;Field     ;
                Name=Field4;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[4];
                CaptionClass='3,' + MATRIX_ColumnCaption[4];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(4);
                            END;
                             }

    { 1019;2   ;Field     ;
                Name=Field5;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[5];
                CaptionClass='3,' + MATRIX_ColumnCaption[5];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(5);
                            END;
                             }

    { 1020;2   ;Field     ;
                Name=Field6;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[6];
                CaptionClass='3,' + MATRIX_ColumnCaption[6];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(6);
                            END;
                             }

    { 1021;2   ;Field     ;
                Name=Field7;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[7];
                CaptionClass='3,' + MATRIX_ColumnCaption[7];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(7);
                            END;
                             }

    { 1022;2   ;Field     ;
                Name=Field8;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[8];
                CaptionClass='3,' + MATRIX_ColumnCaption[8];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(8);
                            END;
                             }

    { 1023;2   ;Field     ;
                Name=Field9;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[9];
                CaptionClass='3,' + MATRIX_ColumnCaption[9];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(9);
                            END;
                             }

    { 1024;2   ;Field     ;
                Name=Field10;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[10];
                CaptionClass='3,' + MATRIX_ColumnCaption[10];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(10);
                            END;
                             }

    { 1025;2   ;Field     ;
                Name=Field11;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[11];
                CaptionClass='3,' + MATRIX_ColumnCaption[11];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(11);
                            END;
                             }

    { 1026;2   ;Field     ;
                Name=Field12;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[12];
                CaptionClass='3,' + MATRIX_ColumnCaption[12];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(12);
                            END;
                             }

    { 1027;2   ;Field     ;
                Name=Field13;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[13];
                CaptionClass='3,' + MATRIX_ColumnCaption[13];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(13);
                            END;
                             }

    { 1028;2   ;Field     ;
                Name=Field14;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[14];
                CaptionClass='3,' + MATRIX_ColumnCaption[14];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(14);
                            END;
                             }

    { 1029;2   ;Field     ;
                Name=Field15;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[15];
                CaptionClass='3,' + MATRIX_ColumnCaption[15];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(15);
                            END;
                             }

    { 1030;2   ;Field     ;
                Name=Field16;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[16];
                CaptionClass='3,' + MATRIX_ColumnCaption[16];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(16);
                            END;
                             }

    { 1031;2   ;Field     ;
                Name=Field17;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[17];
                CaptionClass='3,' + MATRIX_ColumnCaption[17];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(17);
                            END;
                             }

    { 1032;2   ;Field     ;
                Name=Field18;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[18];
                CaptionClass='3,' + MATRIX_ColumnCaption[18];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(18);
                            END;
                             }

    { 1033;2   ;Field     ;
                Name=Field19;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[19];
                CaptionClass='3,' + MATRIX_ColumnCaption[19];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(19);
                            END;
                             }

    { 1034;2   ;Field     ;
                Name=Field20;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[20];
                CaptionClass='3,' + MATRIX_ColumnCaption[20];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(20);
                            END;
                             }

    { 1035;2   ;Field     ;
                Name=Field21;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[21];
                CaptionClass='3,' + MATRIX_ColumnCaption[21];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(21);
                            END;
                             }

    { 1036;2   ;Field     ;
                Name=Field22;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[22];
                CaptionClass='3,' + MATRIX_ColumnCaption[22];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(22);
                            END;
                             }

    { 1037;2   ;Field     ;
                Name=Field23;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[23];
                CaptionClass='3,' + MATRIX_ColumnCaption[23];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(23);
                            END;
                             }

    { 1038;2   ;Field     ;
                Name=Field24;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[24];
                CaptionClass='3,' + MATRIX_ColumnCaption[24];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(24);
                            END;
                             }

    { 1039;2   ;Field     ;
                Name=Field25;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[25];
                CaptionClass='3,' + MATRIX_ColumnCaption[25];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(25);
                            END;
                             }

    { 1040;2   ;Field     ;
                Name=Field26;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[26];
                CaptionClass='3,' + MATRIX_ColumnCaption[26];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(26);
                            END;
                             }

    { 1041;2   ;Field     ;
                Name=Field27;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[27];
                CaptionClass='3,' + MATRIX_ColumnCaption[27];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(27);
                            END;
                             }

    { 1042;2   ;Field     ;
                Name=Field28;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[28];
                CaptionClass='3,' + MATRIX_ColumnCaption[28];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(28);
                            END;
                             }

    { 1043;2   ;Field     ;
                Name=Field29;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[29];
                CaptionClass='3,' + MATRIX_ColumnCaption[29];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(29);
                            END;
                             }

    { 1044;2   ;Field     ;
                Name=Field30;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[30];
                CaptionClass='3,' + MATRIX_ColumnCaption[30];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(30);
                            END;
                             }

    { 1045;2   ;Field     ;
                Name=Field31;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[31];
                CaptionClass='3,' + MATRIX_ColumnCaption[31];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(31);
                            END;
                             }

    { 1046;2   ;Field     ;
                Name=Field32;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[32];
                CaptionClass='3,' + MATRIX_ColumnCaption[32];
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(32);
                            END;
                             }

  }
  CODE
  {
    VAR
      MatrixRecords@1001 : ARRAY [32] OF Record 2000000007;
      AbsenceAmountType@1085 : 'Net Change,Balance at Date';
      MATRIX_CellData@1090 : ARRAY [32] OF Decimal;
      MATRIX_ColumnCaption@1091 : ARRAY [32] OF Text[1024];
      CauseOfAbsenceFilter@1000 : Code[10];

    LOCAL PROCEDURE SetDateFilter@1092(ColumnID@1000 : Integer);
    BEGIN
      IF AbsenceAmountType = AbsenceAmountType::"Net Change" THEN
        IF MatrixRecords[ColumnID]."Period Start" = MatrixRecords[ColumnID]."Period End" THEN
          SETRANGE("Date Filter",MatrixRecords[ColumnID]."Period Start")
        ELSE
          SETRANGE("Date Filter",MatrixRecords[ColumnID]."Period Start",MatrixRecords[ColumnID]."Period End")
      ELSE
        SETRANGE("Date Filter",0D,MatrixRecords[ColumnID]."Period End");
    END;

    [Internal]
    PROCEDURE Load@1093(MatrixColumns1@1007 : ARRAY [32] OF Text[1024];VAR MatrixRecords1@1008 : ARRAY [32] OF Record 2000000007;CauseOfAbsenceFilter1@1000 : Code[10];AbsenceAmountType1@1001 : 'Balance at Date,Net Change');
    VAR
      i@1002 : Integer;
    BEGIN
      COPYARRAY(MATRIX_ColumnCaption,MatrixColumns1,1);
      FOR i := 1 TO ARRAYLEN(MatrixRecords) DO
        MatrixRecords[i].COPY(MatrixRecords1[i]);
      CauseOfAbsenceFilter := CauseOfAbsenceFilter1;
      AbsenceAmountType := AbsenceAmountType1;
    END;

    LOCAL PROCEDURE MatrixOnDrillDown@1094(ColumnID@1009 : Integer);
    VAR
      EmployeeAbsence@1000 : Record 5207;
    BEGIN
      SetDateFilter(ColumnID);
      EmployeeAbsence.SETRANGE("Employee No.","No.");
      EmployeeAbsence.SETFILTER("Cause of Absence Code",CauseOfAbsenceFilter);
      EmployeeAbsence.SETFILTER("From Date",FORMAT("Date Filter"));
      PAGE.RUN(0,EmployeeAbsence);
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1097(ColumnID@1000 : Integer);
    BEGIN
      SetDateFilter(ColumnID);
      SETFILTER("Cause of Absence Filter",CauseOfAbsenceFilter);
      CALCFIELDS("Total Absence (Base)");
      MATRIX_CellData[ColumnID] := "Total Absence (Base)";
    END;

    BEGIN
    END.
  }
}

