OBJECT Page 9213 ResGrp. Alloc. per Job Matrix
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Matrix for ressourcegruppe allokeret p� sager;
               ENU=Res. Gr. Allocated per Job Matrix];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table167;
    PageType=List;
    OnInit=BEGIN
             Col32Visible := TRUE;
             Col31Visible := TRUE;
             Col30Visible := TRUE;
             Col29Visible := TRUE;
             Col28Visible := TRUE;
             Col27Visible := TRUE;
             Col26Visible := TRUE;
             Col25Visible := TRUE;
             Col24Visible := TRUE;
             Col23Visible := TRUE;
             Col22Visible := TRUE;
             Col21Visible := TRUE;
             Col20Visible := TRUE;
             Col19Visible := TRUE;
             Col18Visible := TRUE;
             Col17Visible := TRUE;
             Col16Visible := TRUE;
             Col15Visible := TRUE;
             Col14Visible := TRUE;
             Col13Visible := TRUE;
             Col12Visible := TRUE;
             Col11Visible := TRUE;
             Col10Visible := TRUE;
             Col9Visible := TRUE;
             Col8Visible := TRUE;
             Col7Visible := TRUE;
             Col6Visible := TRUE;
             Col5Visible := TRUE;
             Col4Visible := TRUE;
             Col3Visible := TRUE;
             Col2Visible := TRUE;
             Col1Visible := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       MatrixOnAfterGetRecord;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Jobs;
                SourceExpr="No.";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to Name";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                Name=Col1;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MatrixCellData[1];
                CaptionClass='3,' + MatrixColumnCaptions[1];
                Visible=Col1Visible;
                Editable=FALSE;
                DrillDownPageID=Job Planning Lines;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(1);
                            END;
                             }

    { 8   ;2   ;Field     ;
                Name=Col2;
                DrillDown=Yes;
                ApplicationArea=#All;
                BlankZero=Yes;
                SourceExpr=MatrixCellData[2];
                CaptionClass='3,' + MatrixColumnCaptions[2];
                Visible=Col2Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(2);
                            END;
                             }

    { 10  ;2   ;Field     ;
                Name=Col3;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[3];
                CaptionClass='3,' + MatrixColumnCaptions[3];
                Visible=Col3Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(3);
                            END;
                             }

    { 12  ;2   ;Field     ;
                Name=Col4;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[4];
                CaptionClass='3,' + MatrixColumnCaptions[4];
                Visible=Col4Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(4);
                            END;
                             }

    { 16  ;2   ;Field     ;
                Name=Col5;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[5];
                CaptionClass='3,' + MatrixColumnCaptions[5];
                Visible=Col5Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(5);
                            END;
                             }

    { 18  ;2   ;Field     ;
                Name=Col6;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[6];
                CaptionClass='3,' + MatrixColumnCaptions[6];
                Visible=Col6Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(6);
                            END;
                             }

    { 20  ;2   ;Field     ;
                Name=Col7;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[7];
                CaptionClass='3,' + MatrixColumnCaptions[7];
                Visible=Col7Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(7);
                            END;
                             }

    { 14  ;2   ;Field     ;
                Name=Col8;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[8];
                CaptionClass='3,' + MatrixColumnCaptions[8];
                Visible=Col8Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(8);
                            END;
                             }

    { 25  ;2   ;Field     ;
                Name=Col9;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[9];
                CaptionClass='3,' + MatrixColumnCaptions[9];
                Visible=Col9Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(9);
                            END;
                             }

    { 29  ;2   ;Field     ;
                Name=Col10;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[10];
                CaptionClass='3,' + MatrixColumnCaptions[10];
                Visible=Col10Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(10);
                            END;
                             }

    { 31  ;2   ;Field     ;
                Name=Col11;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[11];
                CaptionClass='3,' + MatrixColumnCaptions[11];
                Visible=Col11Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(11);
                            END;
                             }

    { 33  ;2   ;Field     ;
                Name=Col12;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[12];
                CaptionClass='3,' + MatrixColumnCaptions[12];
                Visible=Col12Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(12);
                            END;
                             }

    { 63  ;2   ;Field     ;
                Name=Col13;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[13];
                CaptionClass='3,' + MatrixColumnCaptions[13];
                Visible=Col13Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(13);
                            END;
                             }

    { 69  ;2   ;Field     ;
                Name=Col14;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[14];
                CaptionClass='3,' + MatrixColumnCaptions[14];
                Visible=Col14Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(14);
                            END;
                             }

    { 65  ;2   ;Field     ;
                Name=Col15;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[15];
                CaptionClass='3,' + MatrixColumnCaptions[15];
                Visible=Col15Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(15);
                            END;
                             }

    { 67  ;2   ;Field     ;
                Name=Col16;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[16];
                CaptionClass='3,' + MatrixColumnCaptions[16];
                Visible=Col16Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(16);
                            END;
                             }

    { 57  ;2   ;Field     ;
                Name=Col17;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[17];
                CaptionClass='3,' + MatrixColumnCaptions[17];
                Visible=Col17Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(17);
                            END;
                             }

    { 59  ;2   ;Field     ;
                Name=Col18;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[18];
                CaptionClass='3,' + MatrixColumnCaptions[18];
                Visible=Col18Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(18);
                            END;
                             }

    { 61  ;2   ;Field     ;
                Name=Col19;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[19];
                CaptionClass='3,' + MatrixColumnCaptions[19];
                Visible=Col19Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(19);
                            END;
                             }

    { 51  ;2   ;Field     ;
                Name=Col20;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[20];
                CaptionClass='3,' + MatrixColumnCaptions[20];
                Visible=Col20Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(20);
                            END;
                             }

    { 53  ;2   ;Field     ;
                Name=Col21;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[21];
                CaptionClass='3,' + MatrixColumnCaptions[21];
                Visible=Col21Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(21);
                            END;
                             }

    { 55  ;2   ;Field     ;
                Name=Col22;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[22];
                CaptionClass='3,' + MatrixColumnCaptions[22];
                Visible=Col22Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(22);
                            END;
                             }

    { 35  ;2   ;Field     ;
                Name=Col23;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[23];
                CaptionClass='3,' + MatrixColumnCaptions[23];
                Visible=Col23Visible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(23);
                            END;
                             }

    { 47  ;2   ;Field     ;
                Name=Col24;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[24];
                CaptionClass='3,' + MatrixColumnCaptions[24];
                Visible=Col24Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(24);
                            END;
                             }

    { 37  ;2   ;Field     ;
                Name=Col25;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[25];
                CaptionClass='3,' + MatrixColumnCaptions[25];
                Visible=Col25Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(25);
                            END;
                             }

    { 39  ;2   ;Field     ;
                Name=Col26;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[26];
                CaptionClass='3,' + MatrixColumnCaptions[26];
                Visible=Col26Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(26);
                            END;
                             }

    { 41  ;2   ;Field     ;
                Name=Col27;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[27];
                CaptionClass='3,' + MatrixColumnCaptions[27];
                Visible=Col27Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(27);
                            END;
                             }

    { 43  ;2   ;Field     ;
                Name=Col28;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[28];
                CaptionClass='3,' + MatrixColumnCaptions[28];
                Visible=Col28Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(28);
                            END;
                             }

    { 27  ;2   ;Field     ;
                Name=Col29;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[29];
                CaptionClass='3,' + MatrixColumnCaptions[29];
                Visible=Col29Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(29);
                            END;
                             }

    { 49  ;2   ;Field     ;
                Name=Col30;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[30];
                CaptionClass='3,' + MatrixColumnCaptions[30];
                Visible=Col30Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(30);
                            END;
                             }

    { 71  ;2   ;Field     ;
                Name=Col31;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[31];
                CaptionClass='3,' + MatrixColumnCaptions[31];
                Visible=Col31Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(31);
                            END;
                             }

    { 45  ;2   ;Field     ;
                Name=Col32;
                ApplicationArea=#All;
                SourceExpr=MatrixCellData[32];
                CaptionClass='3,' + MatrixColumnCaptions[32];
                Visible=Col32Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(32);
                            END;
                             }

  }
  CODE
  {
    VAR
      MatrixColumnDateFilters@1003 : ARRAY [32] OF Record 2000000007;
      MatrixRec@1001 : Record 1003;
      MatrixColumnCaptions@1000 : ARRAY [32] OF Text[100];
      MatrixCellData@1002 : ARRAY [32] OF Text[100];
      MatrixCellQuantity@1004 : Decimal;
      Col1Visible@19025629 : Boolean INDATASET;
      Col2Visible@19021341 : Boolean INDATASET;
      Col3Visible@19017245 : Boolean INDATASET;
      Col4Visible@19012957 : Boolean INDATASET;
      Col5Visible@19046722 : Boolean INDATASET;
      Col6Visible@19042434 : Boolean INDATASET;
      Col7Visible@19037570 : Boolean INDATASET;
      Col8Visible@19008029 : Boolean INDATASET;
      Col9Visible@19077853 : Boolean INDATASET;
      Col10Visible@19043419 : Boolean INDATASET;
      Col11Visible@19043374 : Boolean INDATASET;
      Col12Visible@19043225 : Boolean INDATASET;
      Col13Visible@19043452 : Boolean INDATASET;
      Col14Visible@19043535 : Boolean INDATASET;
      Col15Visible@19043506 : Boolean INDATASET;
      Col16Visible@19043341 : Boolean INDATASET;
      Col17Visible@19043568 : Boolean INDATASET;
      Col18Visible@19043139 : Boolean INDATASET;
      Col19Visible@19043126 : Boolean INDATASET;
      Col20Visible@19027867 : Boolean INDATASET;
      Col21Visible@19027822 : Boolean INDATASET;
      Col22Visible@19027673 : Boolean INDATASET;
      Col23Visible@19027900 : Boolean INDATASET;
      Col24Visible@19027983 : Boolean INDATASET;
      Col25Visible@19027954 : Boolean INDATASET;
      Col26Visible@19027789 : Boolean INDATASET;
      Col27Visible@19028016 : Boolean INDATASET;
      Col28Visible@19027587 : Boolean INDATASET;
      Col29Visible@19027574 : Boolean INDATASET;
      Col30Visible@19075227 : Boolean INDATASET;
      Col31Visible@19075182 : Boolean INDATASET;
      Col32Visible@19075033 : Boolean INDATASET;

    [Internal]
    PROCEDURE Load@1(VAR NewVerticalRec@1000 : Record 167;VAR NewHorizontalRec@1001 : Record 1003;NewMatrixColumnCaptions@1002 : ARRAY [32] OF Text[100];VAR NewMatrixDateFilters@1003 : ARRAY [32] OF Record 2000000007);
    BEGIN
      COPY(NewVerticalRec);
      MatrixRec.COPY(NewHorizontalRec);
      COPYARRAY(MatrixColumnCaptions,NewMatrixColumnCaptions,1);
      COPYARRAY(MatrixColumnDateFilters,NewMatrixDateFilters,1);
    END;

    LOCAL PROCEDURE MatrixOnAfterGetRecord@4();
    VAR
      I@1000 : Integer;
    BEGIN
      MatrixRec.RESET;
      MatrixRec.SETRANGE(Type,MatrixRec.Type::Resource);
      MatrixRec.SETRANGE("Job No.","No.");
      MatrixRec.SETRANGE("Schedule Line",TRUE);
      IF GETFILTER("Resource Gr. Filter") <> '' THEN
        MatrixRec.SETFILTER("Resource Group No.",GETRANGEMIN("Resource Gr. Filter"),GETRANGEMAX("Resource Gr. Filter"));

      FOR I := 1 TO ARRAYLEN(MatrixColumnDateFilters) DO BEGIN
        MatrixCellQuantity := 0;
        MatrixRec.SETRANGE("Planning Date",MatrixColumnDateFilters[I]."Period Start",
          MatrixColumnDateFilters[I]."Period End");
        IF MatrixRec.FIND('-') THEN
          REPEAT
            MatrixCellQuantity += ROUND(MatrixRec.Quantity * MatrixRec."Qty. per Unit of Measure",0.00001)
          UNTIL MatrixRec.NEXT = 0;

        IF MatrixCellQuantity <> 0 THEN
          MatrixCellData[I] := FORMAT(MatrixCellQuantity)
        ELSE
          MatrixCellData[I] := '';
      END;

      SetVisible;
    END;

    LOCAL PROCEDURE MatrixOnDrillDown@7(Column@1000 : Integer);
    VAR
      PlanningLine@1001 : Record 1003;
    BEGIN
      PlanningLine.SETFILTER("Resource Group No.",GETRANGEMIN("Resource Gr. Filter"),GETRANGEMAX("Resource Gr. Filter"));
      PlanningLine.SETRANGE("Planning Date",MatrixColumnDateFilters[Column]."Period Start",
        MatrixColumnDateFilters[Column]."Period End");
      PlanningLine.SETRANGE("Job No.","No.");
      PlanningLine.SETRANGE(Type,PlanningLine.Type::Resource);
      PlanningLine.SETRANGE("Schedule Line",TRUE);

      PAGE.RUNMODAL(PAGE::"Job Planning Lines",PlanningLine);
    END;

    [External]
    PROCEDURE SetVisible@6();
    BEGIN
      Col1Visible := MatrixColumnCaptions[1] <> '';
      Col2Visible := MatrixColumnCaptions[2] <> '';
      Col3Visible := MatrixColumnCaptions[3] <> '';
      Col4Visible := MatrixColumnCaptions[4] <> '';
      Col5Visible := MatrixColumnCaptions[5] <> '';
      Col6Visible := MatrixColumnCaptions[6] <> '';
      Col7Visible := MatrixColumnCaptions[7] <> '';
      Col8Visible := MatrixColumnCaptions[8] <> '';
      Col9Visible := MatrixColumnCaptions[9] <> '';
      Col10Visible := MatrixColumnCaptions[10] <> '';
      Col11Visible := MatrixColumnCaptions[11] <> '';
      Col12Visible := MatrixColumnCaptions[12] <> '';
      Col13Visible := MatrixColumnCaptions[13] <> '';
      Col14Visible := MatrixColumnCaptions[14] <> '';
      Col15Visible := MatrixColumnCaptions[15] <> '';
      Col16Visible := MatrixColumnCaptions[16] <> '';
      Col17Visible := MatrixColumnCaptions[17] <> '';
      Col18Visible := MatrixColumnCaptions[18] <> '';
      Col19Visible := MatrixColumnCaptions[19] <> '';
      Col20Visible := MatrixColumnCaptions[20] <> '';
      Col21Visible := MatrixColumnCaptions[21] <> '';
      Col22Visible := MatrixColumnCaptions[22] <> '';
      Col23Visible := MatrixColumnCaptions[23] <> '';
      Col24Visible := MatrixColumnCaptions[24] <> '';
      Col25Visible := MatrixColumnCaptions[25] <> '';
      Col26Visible := MatrixColumnCaptions[26] <> '';
      Col27Visible := MatrixColumnCaptions[27] <> '';
      Col28Visible := MatrixColumnCaptions[28] <> '';
      Col29Visible := MatrixColumnCaptions[29] <> '';
      Col30Visible := MatrixColumnCaptions[30] <> '';
      Col31Visible := MatrixColumnCaptions[31] <> '';
      Col32Visible := MatrixColumnCaptions[32] <> '';
    END;

    BEGIN
    END.
  }
}

