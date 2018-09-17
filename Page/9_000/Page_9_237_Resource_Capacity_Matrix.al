OBJECT Page 9237 Resource Capacity Matrix
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[DAN=Matrix for ressourcekapacitet;
               ENU=Resource Capacity Matrix];
    LinksAllowed=No;
    SourceTable=Table156;
    PageType=ListPart;
    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1043 : Integer;
                     BEGIN
                       MATRIX_CurrentColumnOrdinal := 0;
                       WHILE MATRIX_CurrentColumnOrdinal < MATRIX_NoOfMatrixColumns DO BEGIN
                         MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
                         MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=R&essource;
                                 ENU=&Resource];
                      Image=Resource }
      { 8       ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 76;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Unit of Measure Filter=FIELD(Unit of Measure Filter),
                                  Chargeable Filter=FIELD(Chargeable Filter);
                      Image=EditLines }
      { 9       ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger som f.eks. v‘rdien for bogf›rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 223;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Unit of Measure Filter=FIELD(Unit of Measure Filter),
                                  Chargeable Filter=FIELD(Chargeable Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Resource),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 11      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(156),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 12      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 202;
                      RunPageView=SORTING(Resource No.);
                      RunPageLink=Resource No.=FIELD(No.);
                      Image=CustomerLedger }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Priser;
                                 ENU=&Prices];
                      Image=Price }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Kostpriser;
                                 ENU=Costs];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om omkostninger for ressourcen.;
                                 ENU=View or change detailed information about costs for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 203;
                      RunPageLink=Type=CONST(Resource),
                                  Code=FIELD(No.);
                      Image=ResourceCosts }
      { 14      ;2   ;Action    ;
                      CaptionML=[DAN=Priser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller rediger priser for ressourcen.;
                                 ENU=View or edit prices for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 204;
                      RunPageLink=Type=CONST(Resource),
                                  Code=FIELD(No.);
                      Image=Price }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Plan&l‘gn.;
                                 ENU=Plan&ning];
                      Image=Planning }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=&Angiv kapacitet;
                                 ENU=&Set Capacity];
                      ToolTipML=[DAN=Rediger kapaciteten for ressourcen, f.eks. en tekniker.;
                                 ENU=Change the capacity of the resource, such as a technician.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 6013;
                      RunPageLink=No.=FIELD(No.) }
      { 16      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource&disponering;
                                 ENU=Resource A&vailability];
                      ToolTipML=[DAN=Vis en oversigt over ressourcekapaciteter, antallet af ressourcetimer, der er allokeret til sager i ordre, det antal, der er allokeret til serviceordrer, den kapacitet, der er tildelt til sager i tilbud, og ressourcetilg‘ngelighed.;
                                 ENU=View a summary of resource capacities, the quantity of resource hours allocated to jobs on order, the quantity allocated to service orders, the capacity assigned to jobs on quote, and the resource availability.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 225;
                      RunPageLink=No.=FIELD(No.),
                                  Unit of Measure Filter=FIELD(Unit of Measure Filter),
                                  Chargeable Filter=FIELD(Chargeable Filter);
                      Image=Calendar }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Jobs;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af ressourcen.;
                           ENU=Specifies a description of the resource.];
                ApplicationArea=#Jobs;
                SourceExpr=Name }

    { 1011;2   ;Field     ;
                Name=Field1;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[1];
                CaptionClass='3,' + MATRIX_ColumnCaption[1];
                OnValidate=BEGIN
                             ValidateCapacity(1);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(1)
                            END;
                             }

    { 1012;2   ;Field     ;
                Name=Field2;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[2];
                CaptionClass='3,' + MATRIX_ColumnCaption[2];
                OnValidate=BEGIN
                             ValidateCapacity(2);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(2)
                            END;
                             }

    { 1013;2   ;Field     ;
                Name=Field3;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[3];
                CaptionClass='3,' + MATRIX_ColumnCaption[3];
                OnValidate=BEGIN
                             ValidateCapacity(3);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(3)
                            END;
                             }

    { 1014;2   ;Field     ;
                Name=Field4;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[4];
                CaptionClass='3,' + MATRIX_ColumnCaption[4];
                OnValidate=BEGIN
                             ValidateCapacity(4);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(4)
                            END;
                             }

    { 1015;2   ;Field     ;
                Name=Field5;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[5];
                CaptionClass='3,' + MATRIX_ColumnCaption[5];
                OnValidate=BEGIN
                             ValidateCapacity(5);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(5)
                            END;
                             }

    { 1016;2   ;Field     ;
                Name=Field6;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[6];
                CaptionClass='3,' + MATRIX_ColumnCaption[6];
                OnValidate=BEGIN
                             ValidateCapacity(6);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(6)
                            END;
                             }

    { 1017;2   ;Field     ;
                Name=Field7;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[7];
                CaptionClass='3,' + MATRIX_ColumnCaption[7];
                OnValidate=BEGIN
                             ValidateCapacity(7);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(7)
                            END;
                             }

    { 1018;2   ;Field     ;
                Name=Field8;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[8];
                CaptionClass='3,' + MATRIX_ColumnCaption[8];
                OnValidate=BEGIN
                             ValidateCapacity(8);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(8)
                            END;
                             }

    { 1019;2   ;Field     ;
                Name=Field9;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[9];
                CaptionClass='3,' + MATRIX_ColumnCaption[9];
                OnValidate=BEGIN
                             ValidateCapacity(9);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(9)
                            END;
                             }

    { 1020;2   ;Field     ;
                Name=Field10;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[10];
                CaptionClass='3,' + MATRIX_ColumnCaption[10];
                OnValidate=BEGIN
                             ValidateCapacity(10);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(10)
                            END;
                             }

    { 1021;2   ;Field     ;
                Name=Field11;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[11];
                CaptionClass='3,' + MATRIX_ColumnCaption[11];
                OnValidate=BEGIN
                             ValidateCapacity(11);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(11)
                            END;
                             }

    { 1022;2   ;Field     ;
                Name=Field12;
                ApplicationArea=#Jobs;
                SourceExpr=MATRIX_CellData[12];
                CaptionClass='3,' + MATRIX_ColumnCaption[12];
                OnValidate=BEGIN
                             ValidateCapacity(12);
                           END;

                OnDrillDown=BEGIN
                              MatrixOnDrillDown(12)
                            END;
                             }

  }
  CODE
  {
    VAR
      MatrixRecords@1000 : ARRAY [32] OF Record 2000000007;
      QtyType@1081 : 'Net Change,Balance at Date';
      MATRIX_NoOfMatrixColumns@1084 : Integer;
      MATRIX_CellData@1085 : ARRAY [32] OF Decimal;
      MATRIX_ColumnCaption@1001 : ARRAY [32] OF Text[1024];

    LOCAL PROCEDURE SetDateFilter@1086(ColumnID@1000 : Integer);
    BEGIN
      IF QtyType = QtyType::"Net Change" THEN
        IF MatrixRecords[ColumnID]."Period Start" = MatrixRecords[ColumnID]."Period End" THEN
          SETRANGE("Date Filter",MatrixRecords[ColumnID]."Period Start")
        ELSE
          SETRANGE("Date Filter",MatrixRecords[ColumnID]."Period Start",MatrixRecords[ColumnID]."Period End")
      ELSE
        SETRANGE("Date Filter",0D,MatrixRecords[ColumnID]."Period End");
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1091(ColumnID@1000 : Integer);
    BEGIN
      SetDateFilter(ColumnID);
      CALCFIELDS(Capacity);
      IF Capacity <> 0 THEN
        MATRIX_CellData[ColumnID] := Capacity
      ELSE
        MATRIX_CellData[ColumnID] := 0;
    END;

    [Internal]
    PROCEDURE Load@3(QtyType1@1000 : 'Net Change,Balance at Date';MatrixColumns1@1001 : ARRAY [32] OF Text[1024];VAR MatrixRecords1@1002 : ARRAY [32] OF Record 2000000007;NoOfMatrixColumns1@1004 : Integer);
    VAR
      i@1005 : Integer;
    BEGIN
      QtyType := QtyType1;
      COPYARRAY(MATRIX_ColumnCaption,MatrixColumns1,1);
      FOR i := 1 TO ARRAYLEN(MatrixRecords) DO
        MatrixRecords[i].COPY(MatrixRecords1[i]);
      MATRIX_NoOfMatrixColumns := NoOfMatrixColumns1;
    END;

    LOCAL PROCEDURE MatrixOnDrillDown@4(ColumnID@1000 : Integer);
    VAR
      ResCapacityEntries@1001 : Record 160;
    BEGIN
      SetDateFilter(ColumnID);
      ResCapacityEntries.SETCURRENTKEY("Resource No.",Date);
      ResCapacityEntries.SETRANGE("Resource No.","No.");
      ResCapacityEntries.SETFILTER(Date,GETFILTER("Date Filter"));
      PAGE.RUN(0,ResCapacityEntries);
    END;

    LOCAL PROCEDURE ValidateCapacity@1(MATRIX_ColumnOrdinal@1000 : Integer);
    BEGIN
      SetDateFilter(MATRIX_ColumnOrdinal);
      CALCFIELDS(Capacity);
      VALIDATE(Capacity,MATRIX_CellData[MATRIX_ColumnOrdinal]);
    END;

    BEGIN
    END.
  }
}

