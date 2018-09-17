OBJECT Page 9241 G/L Entries Dim. Overv. Matrix
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Matrix for oversigt over finanspostdimensioner;
               ENU=G/L Entries Dim. Overv. Matrix];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table17;
    DataCaptionExpr=GetCaption;
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
                 MATRIX_NoOfMatrixColumns := ARRAYLEN(MATRIX_CellData);
                 SetColumnVisibility;
               END;

    OnFindRecord=VAR
                   Found@1398 : Boolean;
                 BEGIN
                   IF RunOnTempRec THEN BEGIN
                     TempGLEntry := Rec;
                     Found := TempGLEntry.FIND(Which);
                     IF Found THEN
                       Rec := TempGLEntry;
                     EXIT(Found);
                   END;
                   EXIT(FIND(Which));
                 END;

    OnNextRecord=VAR
                   ResultSteps@1001 : Integer;
                 BEGIN
                   IF RunOnTempRec THEN BEGIN
                     TempGLEntry := Rec;
                     ResultSteps := TempGLEntry.NEXT(Steps);
                     IF ResultSteps <> 0 THEN
                       Rec := TempGLEntry;
                     EXIT(ResultSteps);
                   END;
                   EXIT(NEXT(Steps));
                 END;

    OnAfterGetRecord=VAR
                       MATRIX_Steps@1401 : Integer;
                     BEGIN
                       MATRIX_CurrentColumnOrdinal := 0;
                       IF MATRIX_PKFirstCaptionInSet <> '' THEN
                         MatrixRecord.SETPOSITION(MATRIX_PKFirstCaptionInSet);
                       IF MATRIX_OnFindRecord('=') THEN BEGIN
                         MATRIX_CurrentColumnOrdinal := 1;
                         REPEAT
                           MATRIX_OnAfterGetRecord;
                           MATRIX_Steps := MATRIX_OnNextRecord(1);
                           MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + MATRIX_Steps;
                         UNTIL (MATRIX_CurrentColumnOrdinal - MATRIX_Steps = MATRIX_NoOfMatrixColumns) OR (MATRIX_Steps = 0);
                         IF MATRIX_CurrentColumnOrdinal <> 1 THEN BEGIN
                           MATRIX_OnNextRecord(1 - MATRIX_CurrentColumnOrdinal);
                           MATRIX_CurrentColumnOrdinal := 1;
                         END;
                       END;

                       MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=Post;
                                 ENU=Entry];
                      Image=Entry }
      { 12      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 3       ;0   ;ActionContainer;
                      Name=Action17;
                      ActionContainerType=ActionItems }
      { 4       ;1   ;Action    ;
                      Name=<Action16>;
                      CaptionML=[DAN=Naviger;
                                 ENU=Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf�ringsdatoen p� den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Suite;
                      Image=Navigate;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf�ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Suite;
                SourceExpr="Posting Date" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken bilagstype posten tilh�rer.;
                           ENU=Specifies the document type that the entry belongs to.];
                ApplicationArea=#Suite;
                SourceExpr="Document Type" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bilagsnummer.;
                           ENU=Specifies the entry's Document No.];
                ApplicationArea=#Suite;
                SourceExpr="Document No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den konto, som posten er bogf�rt p�.;
                           ENU=Specifies the number of the account that the entry has been posted to.];
                ApplicationArea=#Suite;
                SourceExpr="G/L Account No." }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel�bet for posten.;
                           ENU=Specifies the Amount of the entry.];
                ApplicationArea=#Suite;
                SourceExpr=Amount }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Suite;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Suite;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Suite;
                SourceExpr="Entry No." }

    { 1366;2   ;Field     ;
                Name=Field1;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[1];
                CaptionClass='3,' + MATRIX_ColumnCaptions[1];
                Visible=Field1Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(1);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1367;2   ;Field     ;
                Name=Field2;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[2];
                CaptionClass='3,' + MATRIX_ColumnCaptions[2];
                Visible=Field2Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(2);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1368;2   ;Field     ;
                Name=Field3;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[3];
                CaptionClass='3,' + MATRIX_ColumnCaptions[3];
                Visible=Field3Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(3);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1369;2   ;Field     ;
                Name=Field4;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[4];
                CaptionClass='3,' + MATRIX_ColumnCaptions[4];
                Visible=Field4Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(4);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1370;2   ;Field     ;
                Name=Field5;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[5];
                CaptionClass='3,' + MATRIX_ColumnCaptions[5];
                Visible=Field5Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(5);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1371;2   ;Field     ;
                Name=Field6;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[6];
                CaptionClass='3,' + MATRIX_ColumnCaptions[6];
                Visible=Field6Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(6);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1372;2   ;Field     ;
                Name=Field7;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[7];
                CaptionClass='3,' + MATRIX_ColumnCaptions[7];
                Visible=Field7Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(7);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1373;2   ;Field     ;
                Name=Field8;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[8];
                CaptionClass='3,' + MATRIX_ColumnCaptions[8];
                Visible=Field8Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(8);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1374;2   ;Field     ;
                Name=Field9;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[9];
                CaptionClass='3,' + MATRIX_ColumnCaptions[9];
                Visible=Field9Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(9);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1375;2   ;Field     ;
                Name=Field10;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[10];
                CaptionClass='3,' + MATRIX_ColumnCaptions[10];
                Visible=Field10Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(10);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1376;2   ;Field     ;
                Name=Field11;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[11];
                CaptionClass='3,' + MATRIX_ColumnCaptions[11];
                Visible=Field11Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(11);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1377;2   ;Field     ;
                Name=Field12;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[12];
                CaptionClass='3,' + MATRIX_ColumnCaptions[12];
                Visible=Field12Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(12);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1378;2   ;Field     ;
                Name=Field13;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[13];
                CaptionClass='3,' + MATRIX_ColumnCaptions[13];
                Visible=Field13Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(13);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1379;2   ;Field     ;
                Name=Field14;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[14];
                CaptionClass='3,' + MATRIX_ColumnCaptions[14];
                Visible=Field14Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(14);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1380;2   ;Field     ;
                Name=Field15;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[15];
                CaptionClass='3,' + MATRIX_ColumnCaptions[15];
                Visible=Field15Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(15);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1381;2   ;Field     ;
                Name=Field16;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[16];
                CaptionClass='3,' + MATRIX_ColumnCaptions[16];
                Visible=Field16Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(16);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1382;2   ;Field     ;
                Name=Field17;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[17];
                CaptionClass='3,' + MATRIX_ColumnCaptions[17];
                Visible=Field17Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(17);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1383;2   ;Field     ;
                Name=Field18;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[18];
                CaptionClass='3,' + MATRIX_ColumnCaptions[18];
                Visible=Field18Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(18);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1384;2   ;Field     ;
                Name=Field19;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[19];
                CaptionClass='3,' + MATRIX_ColumnCaptions[19];
                Visible=Field19Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(19);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1385;2   ;Field     ;
                Name=Field20;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[20];
                CaptionClass='3,' + MATRIX_ColumnCaptions[20];
                Visible=Field20Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(20);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1386;2   ;Field     ;
                Name=Field21;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[21];
                CaptionClass='3,' + MATRIX_ColumnCaptions[21];
                Visible=Field21Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(21);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1387;2   ;Field     ;
                Name=Field22;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[22];
                CaptionClass='3,' + MATRIX_ColumnCaptions[22];
                Visible=Field22Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(22);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1388;2   ;Field     ;
                Name=Field23;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[23];
                CaptionClass='3,' + MATRIX_ColumnCaptions[23];
                Visible=Field23Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(23);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1389;2   ;Field     ;
                Name=Field24;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[24];
                CaptionClass='3,' + MATRIX_ColumnCaptions[24];
                Visible=Field24Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(24);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1390;2   ;Field     ;
                Name=Field25;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[25];
                CaptionClass='3,' + MATRIX_ColumnCaptions[25];
                Visible=Field25Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(25);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1391;2   ;Field     ;
                Name=Field26;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[26];
                CaptionClass='3,' + MATRIX_ColumnCaptions[26];
                Visible=Field26Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(26);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1392;2   ;Field     ;
                Name=Field27;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[27];
                CaptionClass='3,' + MATRIX_ColumnCaptions[27];
                Visible=Field27Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(27);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1393;2   ;Field     ;
                Name=Field28;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[28];
                CaptionClass='3,' + MATRIX_ColumnCaptions[28];
                Visible=Field28Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(28);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1394;2   ;Field     ;
                Name=Field29;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[29];
                CaptionClass='3,' + MATRIX_ColumnCaptions[29];
                Visible=Field29Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(29);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1395;2   ;Field     ;
                Name=Field30;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[30];
                CaptionClass='3,' + MATRIX_ColumnCaptions[30];
                Visible=Field30Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(30);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1396;2   ;Field     ;
                Name=Field31;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[31];
                CaptionClass='3,' + MATRIX_ColumnCaptions[31];
                Visible=Field31Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(31);
                           MATRIX_OnLookup;
                         END;
                          }

    { 1397;2   ;Field     ;
                Name=Field32;
                ApplicationArea=#All;
                SourceExpr=MATRIX_CellData[32];
                CaptionClass='3,' + MATRIX_ColumnCaptions[32];
                Visible=Field32Visible;
                OnLookup=BEGIN
                           MATRIX_UpdateMatrixRecord(32);
                           MATRIX_OnLookup;
                         END;
                          }

  }
  CODE
  {
    VAR
      GLAcc@1441 : Record 15;
      TempGLEntry@1442 : TEMPORARY Record 17;
      DimSetEntry@1004 : Record 480;
      MatrixRecord@1005 : Record 348;
      Navigate@1444 : Page 344;
      RunOnTempRec@1445 : Boolean;
      MATRIX_NoOfMatrixColumns@1448 : Integer;
      MATRIX_CellData@1449 : ARRAY [32] OF Text[80];
      MATRIX_ColumnCaptions@1000 : ARRAY [32] OF Text[80];
      MATRIX_CurrentColumnOrdinal@1001 : Integer;
      MATRIX_PKFirstCaptionInSet@1002 : Text;
      MATRIX_CurrSetLength@1003 : Integer;
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

    LOCAL PROCEDURE GetCaption@1450() : Text[250];
    BEGIN
      IF GLAcc."No." <> "G/L Account No." THEN
        GLAcc.GET("G/L Account No.");
      EXIT(STRSUBSTNO('%1 %2',GLAcc."No.",GLAcc.Name));
    END;

    LOCAL PROCEDURE MATRIX_UpdateMatrixRecord@1451(MATRIX_NewColumnOrdinal@1360 : Integer);
    BEGIN
      MATRIX_CurrentColumnOrdinal := MATRIX_NewColumnOrdinal;
      MatrixRecord.SETPOSITION(MATRIX_PKFirstCaptionInSet);
      MATRIX_OnFindRecord('=');
      MATRIX_OnNextRecord(MATRIX_NewColumnOrdinal - 1);
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1453();
    BEGIN
      IF NOT DimSetEntry.GET("Dimension Set ID",MatrixRecord.Code)
      THEN BEGIN
        DimSetEntry.INIT;
        DimSetEntry."Dimension Code" := MatrixRecord.Code;
      END;
      MATRIX_CellData[MATRIX_CurrentColumnOrdinal] := FORMAT(DimSetEntry."Dimension Value Code");
    END;

    LOCAL PROCEDURE MATRIX_OnFindRecord@1454(Which@1362 : Text[1024]) : Boolean;
    BEGIN
      EXIT(MatrixRecord.FIND(Which));
    END;

    LOCAL PROCEDURE MATRIX_OnNextRecord@1455(Steps@1363 : Integer) : Integer;
    BEGIN
      EXIT(MatrixRecord.NEXT(Steps));
    END;

    [External]
    PROCEDURE Load@1(NewMATRIX_Captions@1000 : ARRAY [32] OF Text[80];PKFirstCaptionInSet@1001 : Text;LengthOfCurrSet@1002 : Integer);
    BEGIN
      COPYARRAY(MATRIX_ColumnCaptions,NewMATRIX_Captions,1);
      MATRIX_PKFirstCaptionInSet := PKFirstCaptionInSet;
      MATRIX_CurrSetLength := LengthOfCurrSet;
    END;

    LOCAL PROCEDURE MATRIX_OnLookup@2();
    VAR
      DimVal@1000 : Record 349;
    BEGIN
      DimVal.SETRANGE("Dimension Code",MatrixRecord.Code);
      DimVal."Dimension Code" := DimSetEntry."Dimension Code";
      DimVal.Code := DimSetEntry."Dimension Value Code";
      PAGE.RUNMODAL(PAGE::"Dimension Value List",DimVal);
    END;

    [External]
    PROCEDURE SetTempGLEntry@3(VAR NewGLEntry@1000 : Record 17);
    BEGIN
      RunOnTempRec := TRUE;
      TempGLEntry.DELETEALL;
      IF NewGLEntry.FIND('-') THEN
        REPEAT
          TempGLEntry := NewGLEntry;
          TempGLEntry.INSERT;
        UNTIL NewGLEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE SetColumnVisibility@4();
    BEGIN
      Field1Visible := MATRIX_CurrSetLength >= 1;
      Field2Visible := MATRIX_CurrSetLength >= 2;
      Field3Visible := MATRIX_CurrSetLength >= 3;
      Field4Visible := MATRIX_CurrSetLength >= 4;
      Field5Visible := MATRIX_CurrSetLength >= 5;
      Field6Visible := MATRIX_CurrSetLength >= 6;
      Field7Visible := MATRIX_CurrSetLength >= 7;
      Field8Visible := MATRIX_CurrSetLength >= 8;
      Field9Visible := MATRIX_CurrSetLength >= 9;
      Field10Visible := MATRIX_CurrSetLength >= 10;
      Field11Visible := MATRIX_CurrSetLength >= 11;
      Field12Visible := MATRIX_CurrSetLength >= 12;
      Field13Visible := MATRIX_CurrSetLength >= 13;
      Field14Visible := MATRIX_CurrSetLength >= 14;
      Field15Visible := MATRIX_CurrSetLength >= 15;
      Field16Visible := MATRIX_CurrSetLength >= 16;
      Field17Visible := MATRIX_CurrSetLength >= 17;
      Field18Visible := MATRIX_CurrSetLength >= 18;
      Field19Visible := MATRIX_CurrSetLength >= 19;
      Field20Visible := MATRIX_CurrSetLength >= 20;
      Field21Visible := MATRIX_CurrSetLength >= 21;
      Field22Visible := MATRIX_CurrSetLength >= 22;
      Field23Visible := MATRIX_CurrSetLength >= 23;
      Field24Visible := MATRIX_CurrSetLength >= 24;
      Field25Visible := MATRIX_CurrSetLength >= 25;
      Field26Visible := MATRIX_CurrSetLength >= 26;
      Field27Visible := MATRIX_CurrSetLength >= 27;
      Field28Visible := MATRIX_CurrSetLength >= 28;
      Field29Visible := MATRIX_CurrSetLength >= 29;
      Field30Visible := MATRIX_CurrSetLength >= 30;
      Field31Visible := MATRIX_CurrSetLength >= 31;
      Field32Visible := MATRIX_CurrSetLength >= 32;
    END;

    BEGIN
    END.
  }
}

