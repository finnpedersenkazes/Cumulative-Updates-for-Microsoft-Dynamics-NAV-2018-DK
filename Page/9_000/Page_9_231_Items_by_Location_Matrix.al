OBJECT Page 9231 Items by Location Matrix
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
    CaptionML=[DAN=Matrix for varer pr. lokation;
               ENU=Items by Location Matrix];
    LinksAllowed=No;
    SourceTable=Table27;
    PageType=ListPart;
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
               END;

    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1018 : Integer;
                     BEGIN
                       MATRIX_CurrentColumnOrdinal := 0;
                       IF TempMatrixLocation.FINDSET THEN
                         REPEAT
                           MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
                           MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
                         UNTIL (TempMatrixLocation.NEXT = 0) OR (MATRIX_CurrentColumnOrdinal = MATRIX_NoOfMatrixColumns);
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 11      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Varedisponering pr.;
                                 ENU=&Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      Name=<Action3>;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg�ngelige saldo for en vare udvikles over tid i henhold til udbud og eftersp�rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Location;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 12      ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller m�ned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Location;
                      RunObject=Page 157;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=Period }
      { 13      ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5414;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=ItemVariant }
      { 14      ;3   ;Action    ;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      RunObject=Page 492;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Filter),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Filter);
                      Image=Warehouse }
      { 6       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F� vist tilg�ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p� tilg�ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Advanced;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Location;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of the item.];
                ApplicationArea=#Location;
                SourceExpr=Description }

    { 1008;2   ;Field     ;
                Name=Field1;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[1];
                CaptionClass='3,' + MATRIX_ColumnCaption[1];
                Visible=Field1Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(1);
                            END;
                             }

    { 1009;2   ;Field     ;
                Name=Field2;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[2];
                CaptionClass='3,' + MATRIX_ColumnCaption[2];
                Visible=Field2Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(2);
                            END;
                             }

    { 1010;2   ;Field     ;
                Name=Field3;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[3];
                CaptionClass='3,' + MATRIX_ColumnCaption[3];
                Visible=Field3Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(3);
                            END;
                             }

    { 1011;2   ;Field     ;
                Name=Field4;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[4];
                CaptionClass='3,' + MATRIX_ColumnCaption[4];
                Visible=Field4Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(4);
                            END;
                             }

    { 1012;2   ;Field     ;
                Name=Field5;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[5];
                CaptionClass='3,' + MATRIX_ColumnCaption[5];
                Visible=Field5Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(5);
                            END;
                             }

    { 1013;2   ;Field     ;
                Name=Field6;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[6];
                CaptionClass='3,' + MATRIX_ColumnCaption[6];
                Visible=Field6Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(6);
                            END;
                             }

    { 1014;2   ;Field     ;
                Name=Field7;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[7];
                CaptionClass='3,' + MATRIX_ColumnCaption[7];
                Visible=Field7Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(7);
                            END;
                             }

    { 1015;2   ;Field     ;
                Name=Field8;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[8];
                CaptionClass='3,' + MATRIX_ColumnCaption[8];
                Visible=Field8Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(8);
                            END;
                             }

    { 1016;2   ;Field     ;
                Name=Field9;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[9];
                CaptionClass='3,' + MATRIX_ColumnCaption[9];
                Visible=Field9Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(9);
                            END;
                             }

    { 1017;2   ;Field     ;
                Name=Field10;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[10];
                CaptionClass='3,' + MATRIX_ColumnCaption[10];
                Visible=Field10Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(10);
                            END;
                             }

    { 1018;2   ;Field     ;
                Name=Field11;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[11];
                CaptionClass='3,' + MATRIX_ColumnCaption[11];
                Visible=Field11Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(11);
                            END;
                             }

    { 1019;2   ;Field     ;
                Name=Field12;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[12];
                CaptionClass='3,' + MATRIX_ColumnCaption[12];
                Visible=Field12Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(12);
                            END;
                             }

    { 1020;2   ;Field     ;
                Name=Field13;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[13];
                CaptionClass='3,' + MATRIX_ColumnCaption[13];
                Visible=Field13Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(13);
                            END;
                             }

    { 1021;2   ;Field     ;
                Name=Field14;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[14];
                CaptionClass='3,' + MATRIX_ColumnCaption[14];
                Visible=Field14Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(14);
                            END;
                             }

    { 1022;2   ;Field     ;
                Name=Field15;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[15];
                CaptionClass='3,' + MATRIX_ColumnCaption[15];
                Visible=Field15Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(15);
                            END;
                             }

    { 1023;2   ;Field     ;
                Name=Field16;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[16];
                CaptionClass='3,' + MATRIX_ColumnCaption[16];
                Visible=Field16Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(16);
                            END;
                             }

    { 1024;2   ;Field     ;
                Name=Field17;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[17];
                CaptionClass='3,' + MATRIX_ColumnCaption[17];
                Visible=Field17Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(17);
                            END;
                             }

    { 1025;2   ;Field     ;
                Name=Field18;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[18];
                CaptionClass='3,' + MATRIX_ColumnCaption[18];
                Visible=Field18Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(18);
                            END;
                             }

    { 1026;2   ;Field     ;
                Name=Field19;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[19];
                CaptionClass='3,' + MATRIX_ColumnCaption[19];
                Visible=Field19Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(19);
                            END;
                             }

    { 1027;2   ;Field     ;
                Name=Field20;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[20];
                CaptionClass='3,' + MATRIX_ColumnCaption[20];
                Visible=Field20Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(20);
                            END;
                             }

    { 1028;2   ;Field     ;
                Name=Field21;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[21];
                CaptionClass='3,' + MATRIX_ColumnCaption[21];
                Visible=Field21Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(21);
                            END;
                             }

    { 1029;2   ;Field     ;
                Name=Field22;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[22];
                CaptionClass='3,' + MATRIX_ColumnCaption[22];
                Visible=Field22Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(22);
                            END;
                             }

    { 1030;2   ;Field     ;
                Name=Field23;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[23];
                CaptionClass='3,' + MATRIX_ColumnCaption[23];
                Visible=Field23Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(23);
                            END;
                             }

    { 1031;2   ;Field     ;
                Name=Field24;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[24];
                CaptionClass='3,' + MATRIX_ColumnCaption[24];
                Visible=Field24Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(24);
                            END;
                             }

    { 1032;2   ;Field     ;
                Name=Field25;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[25];
                CaptionClass='3,' + MATRIX_ColumnCaption[25];
                Visible=Field25Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(25);
                            END;
                             }

    { 1033;2   ;Field     ;
                Name=Field26;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[26];
                CaptionClass='3,' + MATRIX_ColumnCaption[26];
                Visible=Field26Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(26);
                            END;
                             }

    { 1034;2   ;Field     ;
                Name=Field27;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[27];
                CaptionClass='3,' + MATRIX_ColumnCaption[27];
                Visible=Field27Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(27);
                            END;
                             }

    { 1035;2   ;Field     ;
                Name=Field28;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[28];
                CaptionClass='3,' + MATRIX_ColumnCaption[28];
                Visible=Field28Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(28);
                            END;
                             }

    { 1036;2   ;Field     ;
                Name=Field29;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[29];
                CaptionClass='3,' + MATRIX_ColumnCaption[29];
                Visible=Field29Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(29);
                            END;
                             }

    { 1037;2   ;Field     ;
                Name=Field30;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[30];
                CaptionClass='3,' + MATRIX_ColumnCaption[30];
                Visible=Field30Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(30);
                            END;
                             }

    { 1038;2   ;Field     ;
                Name=Field31;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[31];
                CaptionClass='3,' + MATRIX_ColumnCaption[31];
                Visible=Field31Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(31);
                            END;
                             }

    { 1039;2   ;Field     ;
                Name=Field32;
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                BlankNumbers=BlankZero;
                SourceExpr=MATRIX_CellData[32];
                CaptionClass='3,' + MATRIX_ColumnCaption[32];
                Visible=Field32Visible;
                OnDrillDown=BEGIN
                              MatrixOnDrillDown(32);
                            END;
                             }

  }
  CODE
  {
    VAR
      ItemLedgerEntry@1035 : Record 32;
      MatrixRecords@1002 : ARRAY [32] OF Record 14;
      TempMatrixLocation@1039 : TEMPORARY Record 14;
      ItemAvailFormsMgt@1003 : Codeunit 353;
      MATRIX_NoOfMatrixColumns@1001 : Integer;
      MATRIX_CellData@1042 : ARRAY [32] OF Decimal;
      MATRIX_ColumnCaption@1000 : ARRAY [32] OF Text[1024];
      MATRIX_CurrSetLength@1004 : Integer;
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

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1047(ColumnID@1000 : Integer);
    VAR
      TempItem@1001 : TEMPORARY Record 27;
    BEGIN
      TempItem.COPY(Rec);
      TempItem.SETRANGE("Location Filter",MatrixRecords[ColumnID].Code);
      TempItem.CALCFIELDS(Inventory);
      MATRIX_CellData[ColumnID] := TempItem.Inventory;
      SetVisible;
    END;

    [External]
    PROCEDURE Load@3(MatrixColumns1@1001 : ARRAY [32] OF Text[1024];VAR MatrixRecords1@1002 : ARRAY [32] OF Record 14;VAR MatrixRecord1@1000 : Record 14;CurrSetLength@1003 : Integer);
    BEGIN
      MATRIX_CurrSetLength := CurrSetLength;
      COPYARRAY(MATRIX_ColumnCaption,MatrixColumns1,1);
      COPYARRAY(MatrixRecords,MatrixRecords1,1);
      TempMatrixLocation.COPY(MatrixRecord1,TRUE);
    END;

    LOCAL PROCEDURE MatrixOnDrillDown@4(ColumnID@1000 : Integer);
    BEGIN
      ItemLedgerEntry.SETCURRENTKEY(
        "Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
      ItemLedgerEntry.SETRANGE("Item No.","No.");
      ItemLedgerEntry.SETRANGE("Location Code",MatrixRecords[ColumnID].Code);
      PAGE.RUN(0,ItemLedgerEntry);
    END;

    [External]
    PROCEDURE SetVisible@6();
    BEGIN
      Field1Visible := MATRIX_CurrSetLength > 0;
      Field2Visible := MATRIX_CurrSetLength > 1;
      Field3Visible := MATRIX_CurrSetLength > 2;
      Field4Visible := MATRIX_CurrSetLength > 3;
      Field5Visible := MATRIX_CurrSetLength > 4;
      Field6Visible := MATRIX_CurrSetLength > 5;
      Field7Visible := MATRIX_CurrSetLength > 6;
      Field8Visible := MATRIX_CurrSetLength > 7;
      Field9Visible := MATRIX_CurrSetLength > 8;
      Field10Visible := MATRIX_CurrSetLength > 9;
      Field11Visible := MATRIX_CurrSetLength > 10;
      Field12Visible := MATRIX_CurrSetLength > 11;
      Field13Visible := MATRIX_CurrSetLength > 12;
      Field14Visible := MATRIX_CurrSetLength > 13;
      Field15Visible := MATRIX_CurrSetLength > 14;
      Field16Visible := MATRIX_CurrSetLength > 15;
      Field17Visible := MATRIX_CurrSetLength > 16;
      Field18Visible := MATRIX_CurrSetLength > 17;
      Field19Visible := MATRIX_CurrSetLength > 18;
      Field20Visible := MATRIX_CurrSetLength > 19;
      Field21Visible := MATRIX_CurrSetLength > 20;
      Field22Visible := MATRIX_CurrSetLength > 21;
      Field23Visible := MATRIX_CurrSetLength > 22;
      Field24Visible := MATRIX_CurrSetLength > 23;
      Field25Visible := MATRIX_CurrSetLength > 24;
      Field26Visible := MATRIX_CurrSetLength > 25;
      Field27Visible := MATRIX_CurrSetLength > 26;
      Field28Visible := MATRIX_CurrSetLength > 27;
      Field29Visible := MATRIX_CurrSetLength > 28;
      Field30Visible := MATRIX_CurrSetLength > 29;
      Field31Visible := MATRIX_CurrSetLength > 30;
      Field32Visible := MATRIX_CurrSetLength > 31;
    END;

    BEGIN
    END.
  }
}

