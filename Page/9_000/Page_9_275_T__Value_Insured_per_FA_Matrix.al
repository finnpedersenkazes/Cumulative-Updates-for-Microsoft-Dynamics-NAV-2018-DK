OBJECT Page 9275 T. Value Insured per FA Matrix
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
    CaptionML=[DAN=Matrix for forsikringssummer pr. anl�g;
               ENU=T. Value Insured per FA Matrix];
    LinksAllowed=No;
    SourceTable=Table5600;
    PageType=List;
    OnInit=BEGIN
             Field32Visible := TRUE;
             Field31Visible := TRUE;
             Field30Visible := TRUE;
             Field29Visible := TRUE;
             Field28Visible := TRUE;
             Field27Visible := TRUE;
             Field26Visible := TRUE;
             Field25Visible := TRUE;
             Field24Visible := TRUE;
             Field23Visible := TRUE;
             Field22Visible := TRUE;
             Field21Visible := TRUE;
             Field20Visible := TRUE;
             Field19Visible := TRUE;
             Field18Visible := TRUE;
             Field17Visible := TRUE;
             Field16Visible := TRUE;
             Field15Visible := TRUE;
             Field14Visible := TRUE;
             Field13Visible := TRUE;
             Field12Visible := TRUE;
             Field11Visible := TRUE;
             Field10Visible := TRUE;
             Field9Visible := TRUE;
             Field8Visible := TRUE;
             Field7Visible := TRUE;
             Field6Visible := TRUE;
             Field5Visible := TRUE;
             Field4Visible := TRUE;
             Field3Visible := TRUE;
             Field2Visible := TRUE;
             Field1Visible := TRUE;
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

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af anl�gget.;
                           ENU=Specifies a description of the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 1012;2   ;Field     ;
                Name=Field1;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[1];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[1];
                Visible=Field1Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(1);
                            END;
                             }

    { 1013;2   ;Field     ;
                Name=Field2;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[2];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[2];
                Visible=Field2Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(2);
                            END;
                             }

    { 1014;2   ;Field     ;
                Name=Field3;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[3];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[3];
                Visible=Field3Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(3);
                            END;
                             }

    { 1015;2   ;Field     ;
                Name=Field4;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[4];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[4];
                Visible=Field4Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(4);
                            END;
                             }

    { 1016;2   ;Field     ;
                Name=Field5;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[5];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[5];
                Visible=Field5Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(5);
                            END;
                             }

    { 1017;2   ;Field     ;
                Name=Field6;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[6];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[6];
                Visible=Field6Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(6);
                            END;
                             }

    { 1018;2   ;Field     ;
                Name=Field7;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[7];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[7];
                Visible=Field7Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(7);
                            END;
                             }

    { 1019;2   ;Field     ;
                Name=Field8;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[8];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[8];
                Visible=Field8Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(8);
                            END;
                             }

    { 1020;2   ;Field     ;
                Name=Field9;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[9];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[9];
                Visible=Field9Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(9);
                            END;
                             }

    { 1021;2   ;Field     ;
                Name=Field10;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[10];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[10];
                Visible=Field10Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(10);
                            END;
                             }

    { 1022;2   ;Field     ;
                Name=Field11;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[11];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[11];
                Visible=Field11Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(11);
                            END;
                             }

    { 1023;2   ;Field     ;
                Name=Field12;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[12];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[12];
                Visible=Field12Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(12);
                            END;
                             }

    { 1024;2   ;Field     ;
                Name=Field13;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[13];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[13];
                Visible=Field13Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(13);
                            END;
                             }

    { 1025;2   ;Field     ;
                Name=Field14;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[14];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[14];
                Visible=Field14Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(14);
                            END;
                             }

    { 1026;2   ;Field     ;
                Name=Field15;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[15];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[15];
                Visible=Field15Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(15);
                            END;
                             }

    { 1027;2   ;Field     ;
                Name=Field16;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[16];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[16];
                Visible=Field16Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(16);
                            END;
                             }

    { 1028;2   ;Field     ;
                Name=Field17;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[17];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[17];
                Visible=Field17Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(17);
                            END;
                             }

    { 1029;2   ;Field     ;
                Name=Field18;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[18];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[18];
                Visible=Field18Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(18);
                            END;
                             }

    { 1030;2   ;Field     ;
                Name=Field19;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[19];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[19];
                Visible=Field19Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(19);
                            END;
                             }

    { 1031;2   ;Field     ;
                Name=Field20;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[20];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[20];
                Visible=Field20Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(20);
                            END;
                             }

    { 1032;2   ;Field     ;
                Name=Field21;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[21];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[21];
                Visible=Field21Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(21);
                            END;
                             }

    { 1033;2   ;Field     ;
                Name=Field22;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[22];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[22];
                Visible=Field22Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(22);
                            END;
                             }

    { 1034;2   ;Field     ;
                Name=Field23;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[23];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[23];
                Visible=Field23Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(23);
                            END;
                             }

    { 1035;2   ;Field     ;
                Name=Field24;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[24];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[24];
                Visible=Field24Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(24);
                            END;
                             }

    { 1036;2   ;Field     ;
                Name=Field25;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[25];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[25];
                Visible=Field25Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(25);
                            END;
                             }

    { 1037;2   ;Field     ;
                Name=Field26;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[26];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[26];
                Visible=Field26Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(26);
                            END;
                             }

    { 1038;2   ;Field     ;
                Name=Field27;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[27];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[27];
                Visible=Field27Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(27);
                            END;
                             }

    { 1039;2   ;Field     ;
                Name=Field28;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[28];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[28];
                Visible=Field28Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(28);
                            END;
                             }

    { 1040;2   ;Field     ;
                Name=Field29;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[29];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[29];
                Visible=Field29Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(29);
                            END;
                             }

    { 1041;2   ;Field     ;
                Name=Field30;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[30];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[30];
                Visible=Field30Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(30);
                            END;
                             }

    { 1042;2   ;Field     ;
                Name=Field31;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[31];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[31];
                Visible=Field31Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(31);
                            END;
                             }

    { 1043;2   ;Field     ;
                Name=Field32;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[32];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[32];
                Visible=Field32Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(32);
                            END;
                             }

  }
  CODE
  {
    VAR
      InsCov@1000 : Record 5629;
      MatrixRecords@1001 : ARRAY [32] OF Record 5628;
      InsCoverageLedgEntry@1080 : Record 5629;
      MatrixMgt@1004 : Codeunit 9200;
      RoundingFactor@1082 : 'None,1,1000,1000000';
      MATRIX_CurrentNoOfMatrixColumn@1085 : Integer;
      MATRIX_CellData@1086 : ARRAY [32] OF Decimal;
      MATRIX_CaptionSet@1087 : ARRAY [32] OF Text[80];
      DateFilter@1003 : Text[250];
      RoundingFactorFormatString@1005 : Text;
      Field1Visible@19069335 : Boolean INDATASET;
      Field2Visible@19014807 : Boolean INDATASET;
      Field3Visible@19062679 : Boolean INDATASET;
      Field4Visible@19074839 : Boolean INDATASET;
      Field5Visible@19043543 : Boolean INDATASET;
      Field6Visible@19067287 : Boolean INDATASET;
      Field7Visible@19067863 : Boolean INDATASET;
      Field8Visible@19039959 : Boolean INDATASET;
      Field9Visible@19008663 : Boolean INDATASET;
      Field10Visible@19006501 : Boolean INDATASET;
      Field11Visible@19052468 : Boolean INDATASET;
      Field12Visible@19013039 : Boolean INDATASET;
      Field13Visible@19079726 : Boolean INDATASET;
      Field14Visible@19077225 : Boolean INDATASET;
      Field15Visible@19035896 : Boolean INDATASET;
      Field16Visible@19003763 : Boolean INDATASET;
      Field17Visible@19049730 : Boolean INDATASET;
      Field18Visible@19007213 : Boolean INDATASET;
      Field19Visible@19053180 : Boolean INDATASET;
      Field20Visible@19014629 : Boolean INDATASET;
      Field21Visible@19060596 : Boolean INDATASET;
      Field22Visible@19021167 : Boolean INDATASET;
      Field23Visible@19047854 : Boolean INDATASET;
      Field24Visible@19045353 : Boolean INDATASET;
      Field25Visible@19004024 : Boolean INDATASET;
      Field26Visible@19011891 : Boolean INDATASET;
      Field27Visible@19057858 : Boolean INDATASET;
      Field28Visible@19015341 : Boolean INDATASET;
      Field29Visible@19061308 : Boolean INDATASET;
      Field30Visible@19010597 : Boolean INDATASET;
      Field31Visible@19056564 : Boolean INDATASET;
      Field32Visible@19017135 : Boolean INDATASET;

    [External]
    PROCEDURE Load@1093(MatrixColumns1@1005 : ARRAY [32] OF Text[1024];VAR MatrixRecords1@1006 : ARRAY [32] OF Record 5628;CurrentNoOfMatrixColumns@1007 : Integer;DateFilterLocal@1003 : Text[250];RoundingFactorLocal@1001 : 'None,1,1000,1000000');
    BEGIN
      COPYARRAY(MATRIX_CaptionSet,MatrixColumns1,1);
      COPYARRAY(MatrixRecords,MatrixRecords1,1);
      MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
      DateFilter := DateFilterLocal;
      RoundingFactor := RoundingFactorLocal;
      RoundingFactorFormatString := MatrixMgt.GetFormatString(RoundingFactor,FALSE);
    END;

    LOCAL PROCEDURE MATRIX_OnDrillDown@1094(MATRIX_ColumnOrdinal@1008 : Integer);
    BEGIN
      InsCov.SETFILTER("Posting Date",DateFilter);
      InsCov.SETRANGE("Insurance No.",MatrixRecords[MATRIX_ColumnOrdinal]."No.");
      InsCov.SETRANGE("Disposed FA",FALSE);
      InsCov.SETRANGE("FA No.","No.");

      PAGE.RUNMODAL(PAGE::"Ins. Coverage Ledger Entries",InsCov);
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1096(MATRIX_ColumnOrdinal@1010 : Integer);
    BEGIN
      InsCoverageLedgEntry.RESET;
      InsCoverageLedgEntry.SETCURRENTKEY("FA No.","Insurance No.");
      InsCoverageLedgEntry.SETRANGE("Insurance No.",MatrixRecords[MATRIX_ColumnOrdinal]."No.");
      InsCoverageLedgEntry.SETRANGE("FA No.","No.");
      InsCoverageLedgEntry.SETRANGE("Disposed FA",FALSE);
      InsCoverageLedgEntry.SETFILTER("Posting Date",DateFilter);
      InsCoverageLedgEntry.CALCSUMS(Amount);

      MATRIX_CellData[MATRIX_ColumnOrdinal] := MatrixMgt.RoundValue(InsCoverageLedgEntry.Amount,RoundingFactor);
      SetVisible;
    END;

    [External]
    PROCEDURE SetVisible@6();
    BEGIN
      Field1Visible := MATRIX_CaptionSet[1] <> '';
      Field2Visible := MATRIX_CaptionSet[2] <> '';
      Field3Visible := MATRIX_CaptionSet[3] <> '';
      Field4Visible := MATRIX_CaptionSet[4] <> '';
      Field5Visible := MATRIX_CaptionSet[5] <> '';
      Field6Visible := MATRIX_CaptionSet[6] <> '';
      Field7Visible := MATRIX_CaptionSet[7] <> '';
      Field8Visible := MATRIX_CaptionSet[8] <> '';
      Field9Visible := MATRIX_CaptionSet[9] <> '';
      Field10Visible := MATRIX_CaptionSet[10] <> '';
      Field11Visible := MATRIX_CaptionSet[11] <> '';
      Field12Visible := MATRIX_CaptionSet[12] <> '';
      Field13Visible := MATRIX_CaptionSet[13] <> '';
      Field14Visible := MATRIX_CaptionSet[14] <> '';
      Field15Visible := MATRIX_CaptionSet[15] <> '';
      Field16Visible := MATRIX_CaptionSet[16] <> '';
      Field17Visible := MATRIX_CaptionSet[17] <> '';
      Field18Visible := MATRIX_CaptionSet[18] <> '';
      Field19Visible := MATRIX_CaptionSet[19] <> '';
      Field20Visible := MATRIX_CaptionSet[20] <> '';
      Field21Visible := MATRIX_CaptionSet[21] <> '';
      Field22Visible := MATRIX_CaptionSet[22] <> '';
      Field23Visible := MATRIX_CaptionSet[23] <> '';
      Field24Visible := MATRIX_CaptionSet[24] <> '';
      Field25Visible := MATRIX_CaptionSet[25] <> '';
      Field26Visible := MATRIX_CaptionSet[26] <> '';
      Field27Visible := MATRIX_CaptionSet[27] <> '';
      Field28Visible := MATRIX_CaptionSet[28] <> '';
      Field29Visible := MATRIX_CaptionSet[29] <> '';
      Field30Visible := MATRIX_CaptionSet[30] <> '';
      Field31Visible := MATRIX_CaptionSet[31] <> '';
      Field32Visible := MATRIX_CaptionSet[32] <> '';
    END;

    LOCAL PROCEDURE FormatStr@8() : Text;
    BEGIN
      EXIT(RoundingFactorFormatString);
    END;

    BEGIN
    END.
  }
}

