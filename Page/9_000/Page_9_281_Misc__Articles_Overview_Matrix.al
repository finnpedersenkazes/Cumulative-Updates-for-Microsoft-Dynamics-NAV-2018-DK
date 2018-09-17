OBJECT Page 9281 Misc. Articles Overview Matrix
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
    CaptionML=[DAN=Oversigtsmatrix for div. udstyr;
               ENU=Misc. Articles Overview Matrix];
    LinksAllowed=No;
    SourceTable=Table5200;
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

    OnOpenPage=BEGIN
                 SetColumnVisibility;
               END;

    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1022 : Integer;
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
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Fulde navn;
                           ENU=Full Name];
                ToolTipML=[DAN=Angiver det fulde navn p� den medarbejder, der er ansvarlig for det udstyr (biler, computere, kreditkort og s� videre), som du har registreret.;
                           ENU=Specifies the full name of the employee, relating to the miscellaneous articles (cars, computers, credit cards, and so on) that you have registered.];
                ApplicationArea=#Advanced;
                SourceExpr=FullName }

    { 1012;2   ;Field     ;
                Name=Field1;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[1];
                CaptionClass='3,' + MATRIX_CaptionSet[1];
                Visible=Field1Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(1);
                            END;
                             }

    { 1013;2   ;Field     ;
                Name=Field2;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[2];
                CaptionClass='3,' + MATRIX_CaptionSet[2];
                Visible=Field2Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(2);
                            END;
                             }

    { 1014;2   ;Field     ;
                Name=Field3;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[3];
                CaptionClass='3,' + MATRIX_CaptionSet[3];
                Visible=Field3Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(3);
                            END;
                             }

    { 1015;2   ;Field     ;
                Name=Field4;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[4];
                CaptionClass='3,' + MATRIX_CaptionSet[4];
                Visible=Field4Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(4);
                            END;
                             }

    { 1016;2   ;Field     ;
                Name=Field5;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[5];
                CaptionClass='3,' + MATRIX_CaptionSet[5];
                Visible=Field5Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(5);
                            END;
                             }

    { 1017;2   ;Field     ;
                Name=Field6;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[6];
                CaptionClass='3,' + MATRIX_CaptionSet[6];
                Visible=Field6Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(6);
                            END;
                             }

    { 1018;2   ;Field     ;
                Name=Field7;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[7];
                CaptionClass='3,' + MATRIX_CaptionSet[7];
                Visible=Field7Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(7);
                            END;
                             }

    { 1019;2   ;Field     ;
                Name=Field8;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[8];
                CaptionClass='3,' + MATRIX_CaptionSet[8];
                Visible=Field8Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(8);
                            END;
                             }

    { 1020;2   ;Field     ;
                Name=Field9;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[9];
                CaptionClass='3,' + MATRIX_CaptionSet[9];
                Visible=Field9Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(9);
                            END;
                             }

    { 1021;2   ;Field     ;
                Name=Field10;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[10];
                CaptionClass='3,' + MATRIX_CaptionSet[10];
                Visible=Field10Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(10);
                            END;
                             }

    { 1050;2   ;Field     ;
                Name=Field11;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[11];
                CaptionClass='3,' + MATRIX_CaptionSet[11];
                Visible=Field11Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(11);
                            END;
                             }

    { 1052;2   ;Field     ;
                Name=Field12;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[12];
                CaptionClass='3,' + MATRIX_CaptionSet[12];
                Visible=Field12Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(12);
                            END;
                             }

    { 1054;2   ;Field     ;
                Name=Field13;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[13];
                CaptionClass='3,' + MATRIX_CaptionSet[13];
                Visible=Field13Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(13);
                            END;
                             }

    { 1056;2   ;Field     ;
                Name=Field14;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[14];
                CaptionClass='3,' + MATRIX_CaptionSet[14];
                Visible=Field14Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(14);
                            END;
                             }

    { 1058;2   ;Field     ;
                Name=Field15;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[15];
                CaptionClass='3,' + MATRIX_CaptionSet[15];
                Visible=Field15Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(15);
                            END;
                             }

    { 1060;2   ;Field     ;
                Name=Field16;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[16];
                CaptionClass='3,' + MATRIX_CaptionSet[16];
                Visible=Field16Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(16);
                            END;
                             }

    { 1062;2   ;Field     ;
                Name=Field17;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[17];
                CaptionClass='3,' + MATRIX_CaptionSet[17];
                Visible=Field17Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(17);
                            END;
                             }

    { 1064;2   ;Field     ;
                Name=Field18;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[18];
                CaptionClass='3,' + MATRIX_CaptionSet[18];
                Visible=Field18Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(18);
                            END;
                             }

    { 1066;2   ;Field     ;
                Name=Field19;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[19];
                CaptionClass='3,' + MATRIX_CaptionSet[19];
                Visible=Field19Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(19);
                            END;
                             }

    { 1068;2   ;Field     ;
                Name=Field20;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[20];
                CaptionClass='3,' + MATRIX_CaptionSet[20];
                Visible=Field20Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(20);
                            END;
                             }

    { 1070;2   ;Field     ;
                Name=Field21;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[21];
                CaptionClass='3,' + MATRIX_CaptionSet[21];
                Visible=Field21Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(21);
                            END;
                             }

    { 1072;2   ;Field     ;
                Name=Field22;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[22];
                CaptionClass='3,' + MATRIX_CaptionSet[22];
                Visible=Field22Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(22);
                            END;
                             }

    { 1074;2   ;Field     ;
                Name=Field23;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[23];
                CaptionClass='3,' + MATRIX_CaptionSet[23];
                Visible=Field23Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(23);
                            END;
                             }

    { 1076;2   ;Field     ;
                Name=Field24;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[24];
                CaptionClass='3,' + MATRIX_CaptionSet[24];
                Visible=Field24Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(24);
                            END;
                             }

    { 1078;2   ;Field     ;
                Name=Field25;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[25];
                CaptionClass='3,' + MATRIX_CaptionSet[25];
                Visible=Field25Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(25);
                            END;
                             }

    { 1080;2   ;Field     ;
                Name=Field26;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[26];
                CaptionClass='3,' + MATRIX_CaptionSet[26];
                Visible=Field26Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(26);
                            END;
                             }

    { 1082;2   ;Field     ;
                Name=Field27;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[27];
                CaptionClass='3,' + MATRIX_CaptionSet[27];
                Visible=Field27Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(27);
                            END;
                             }

    { 1084;2   ;Field     ;
                Name=Field28;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[28];
                CaptionClass='3,' + MATRIX_CaptionSet[28];
                Visible=Field28Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(28);
                            END;
                             }

    { 1086;2   ;Field     ;
                Name=Field29;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[29];
                CaptionClass='3,' + MATRIX_CaptionSet[29];
                Visible=Field29Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(29);
                            END;
                             }

    { 1088;2   ;Field     ;
                Name=Field30;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[30];
                CaptionClass='3,' + MATRIX_CaptionSet[30];
                Visible=Field30Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(30);
                            END;
                             }

    { 1090;2   ;Field     ;
                Name=Field31;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[31];
                CaptionClass='3,' + MATRIX_CaptionSet[31];
                Visible=Field31Visible;
                OnDrillDown=BEGIN
                              MATRIX_OnDrillDown(31);
                            END;
                             }

    { 1092;2   ;Field     ;
                Name=Field32;
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=MATRIX_CellData[32];
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
      MatrixRecords@1035 : ARRAY [32] OF Record 5213;
      MiscArticleInformation@1001 : Record 5214;
      MATRIX_CurrentNoOfMatrixColumn@1036 : Integer;
      MATRIX_CellData@1037 : ARRAY [32] OF Boolean;
      MATRIX_CaptionSet@1038 : ARRAY [32] OF Text[80];
      HasInfo@1000 : Boolean;
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
    PROCEDURE Load@1039(MatrixColumns1@1005 : ARRAY [32] OF Text[1024];VAR MatrixRecords1@1006 : ARRAY [32] OF Record 5213;CurrentNoOfMatrixColumns@1007 : Integer);
    BEGIN
      COPYARRAY(MATRIX_CaptionSet,MatrixColumns1,1);
      COPYARRAY(MatrixRecords,MatrixRecords1,1);
      MATRIX_CurrentNoOfMatrixColumn := CurrentNoOfMatrixColumns;
    END;

    LOCAL PROCEDURE MATRIX_OnDrillDown@1040(MATRIX_ColumnOrdinal@1008 : Integer);
    BEGIN
      MiscArticleInformation.SETRANGE("Employee No.","No.");
      MiscArticleInformation.SETRANGE("Misc. Article Code",MatrixRecords[MATRIX_ColumnOrdinal].Code);
      PAGE.RUN(PAGE::"Misc. Article Information",MiscArticleInformation);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1042(MATRIX_ColumnOrdinal@1010 : Integer);
    BEGIN
      MiscArticleInformation.SETRANGE("Employee No.","No.");
      MiscArticleInformation.SETRANGE("Misc. Article Code",
        MatrixRecords[MATRIX_ColumnOrdinal].Code);
      HasInfo := MiscArticleInformation.FINDFIRST;
      MiscArticleInformation.SETRANGE("Employee No.");
      MiscArticleInformation.SETRANGE("Misc. Article Code");
      MATRIX_CellData[MATRIX_ColumnOrdinal] := HasInfo;
    END;

    [External]
    PROCEDURE SetColumnVisibility@2();
    BEGIN
      Field1Visible := MATRIX_CurrentNoOfMatrixColumn >= 1;
      Field2Visible := MATRIX_CurrentNoOfMatrixColumn >= 2;
      Field3Visible := MATRIX_CurrentNoOfMatrixColumn >= 3;
      Field4Visible := MATRIX_CurrentNoOfMatrixColumn >= 4;
      Field5Visible := MATRIX_CurrentNoOfMatrixColumn >= 5;
      Field6Visible := MATRIX_CurrentNoOfMatrixColumn >= 6;
      Field7Visible := MATRIX_CurrentNoOfMatrixColumn >= 7;
      Field8Visible := MATRIX_CurrentNoOfMatrixColumn >= 8;
      Field9Visible := MATRIX_CurrentNoOfMatrixColumn >= 9;
      Field10Visible := MATRIX_CurrentNoOfMatrixColumn >= 10;
      Field11Visible := MATRIX_CurrentNoOfMatrixColumn >= 11;
      Field12Visible := MATRIX_CurrentNoOfMatrixColumn >= 12;
      Field13Visible := MATRIX_CurrentNoOfMatrixColumn >= 13;
      Field14Visible := MATRIX_CurrentNoOfMatrixColumn >= 14;
      Field15Visible := MATRIX_CurrentNoOfMatrixColumn >= 15;
      Field16Visible := MATRIX_CurrentNoOfMatrixColumn >= 16;
      Field17Visible := MATRIX_CurrentNoOfMatrixColumn >= 17;
      Field18Visible := MATRIX_CurrentNoOfMatrixColumn >= 18;
      Field19Visible := MATRIX_CurrentNoOfMatrixColumn >= 19;
      Field20Visible := MATRIX_CurrentNoOfMatrixColumn >= 20;
      Field21Visible := MATRIX_CurrentNoOfMatrixColumn >= 21;
      Field22Visible := MATRIX_CurrentNoOfMatrixColumn >= 22;
      Field23Visible := MATRIX_CurrentNoOfMatrixColumn >= 23;
      Field24Visible := MATRIX_CurrentNoOfMatrixColumn >= 24;
      Field25Visible := MATRIX_CurrentNoOfMatrixColumn >= 25;
      Field26Visible := MATRIX_CurrentNoOfMatrixColumn >= 26;
      Field27Visible := MATRIX_CurrentNoOfMatrixColumn >= 27;
      Field28Visible := MATRIX_CurrentNoOfMatrixColumn >= 28;
      Field29Visible := MATRIX_CurrentNoOfMatrixColumn >= 29;
      Field30Visible := MATRIX_CurrentNoOfMatrixColumn >= 30;
      Field31Visible := MATRIX_CurrentNoOfMatrixColumn >= 31;
      Field32Visible := MATRIX_CurrentNoOfMatrixColumn >= 32;
    END;

    BEGIN
    END.
  }
}

