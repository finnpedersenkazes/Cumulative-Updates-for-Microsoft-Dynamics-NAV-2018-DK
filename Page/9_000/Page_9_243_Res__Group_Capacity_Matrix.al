OBJECT Page 9243 Res. Group Capacity Matrix
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
    CaptionML=[DAN=Matrix for ressourcegrp.kapacitet;
               ENU=Res. Group Capacity Matrix];
    LinksAllowed=No;
    SourceTable=Table152;
    PageType=ListPart;
    OnOpenPage=BEGIN
                 MATRIX_NoOfMatrixColumns := ARRAYLEN(MATRIX_CellData);
               END;

    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1043 : Integer;
                       MATRIX_Steps@1044 : Integer;
                     BEGIN
                       MATRIX_CurrentColumnOrdinal := 0;
                       IF MATRIX_OnFindRecord('=><') THEN BEGIN
                         MATRIX_CurrentColumnOrdinal := 1;
                         REPEAT
                           MATRIX_ColumnOrdinal := MATRIX_CurrentColumnOrdinal;
                           MATRIX_OnAfterGetRecord(MATRIX_ColumnOrdinal);
                           MATRIX_Steps := MATRIX_OnNextRecord(1);
                           MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + MATRIX_Steps;
                         UNTIL (MATRIX_CurrentColumnOrdinal - MATRIX_Steps = MATRIX_NoOfMatrixColumns) OR (MATRIX_Steps = 0);
                         IF MATRIX_CurrentColumnOrdinal <> 1 THEN
                           MATRIX_OnNextRecord(1 - MATRIX_CurrentColumnOrdinal);
                       END
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=Res.&gruppe;
                                 ENU=Res. &Group];
                      Image=Group }
      { 8       ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger som f.eks. v�rdien for bogf�rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 230;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Unit of Measure Filter=FIELD(Unit of Measure Filter),
                                  Chargeable Filter=FIELD(Chargeable Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Resource Group),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 10      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(152),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Priser;
                                 ENU=&Prices];
                      Image=Price }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Kostpriser;
                                 ENU=Costs];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om omkostninger for ressourcen.;
                                 ENU=View or change detailed information about costs for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 203;
                      RunPageLink=Type=CONST("Group(Resource)"),
                                  Code=FIELD(No.);
                      Image=ResourceCosts }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Priser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller rediger priser for ressourcen.;
                                 ENU=View or edit prices for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 204;
                      RunPageLink=Type=CONST("Group(Resource)"),
                                  Code=FIELD(No.);
                      Image=Price }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Plan&l�gn.;
                                 ENU=Plan&ning];
                      Image=Planning }
      { 13      ;2   ;Action    ;
                      Name=ResGroupAvailability;
                      CaptionML=[DAN=&Ressourcegruppedisponering;
                                 ENU=Res. Group Availa&bility];
                      ToolTipML=[DAN=Vis en oversigt over ressourcegruppekapaciteter, antallet af ressourcetimer, der er allokeret til sager i ordre, det antal, der er allokeret til serviceordrer, den kapacitet, der er tildelt til sager i tilbud, og ressourcegruppetilg�ngelighed.;
                                 ENU=View a summary of resource group capacities, the quantity of resource hours allocated to jobs on order, the quantity allocated to service orders, the capacity assigned to jobs on quote, and the resource group availability.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 226;
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
                Name=No.;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Jobs;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                Name=Name;
                ToolTipML=[DAN=Angiver en kort beskrivelse af ressourcegruppen.;
                           ENU=Specifies a short description of the resource group.];
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
                              MatrixOnDrillDown(1);
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
                              MatrixOnDrillDown(2);
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
                              MatrixOnDrillDown(3);
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
                              MatrixOnDrillDown(4);
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
                              MatrixOnDrillDown(5);
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
                              MatrixOnDrillDown(6);
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
                              MatrixOnDrillDown(7);
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
                              MatrixOnDrillDown(8);
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
                              MatrixOnDrillDown(9);
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
                              MatrixOnDrillDown(10);
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
                              MatrixOnDrillDown(11);
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
                              MatrixOnDrillDown(12);
                            END;
                             }

  }
  CODE
  {
    VAR
      MatrixRecord@1082 : Record 2000000007;
      MatrixRecords@1083 : ARRAY [32] OF Record 2000000007;
      PeriodFormMgt@1002 : Codeunit 359;
      PeriodType@1001 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      QtyType@1000 : 'Net Change,Balance at Date';
      MATRIX_ColumnOrdinal@1084 : Integer;
      MATRIX_NoOfMatrixColumns@1085 : Integer;
      MATRIX_CellData@1086 : ARRAY [32] OF Text[1024];
      MATRIX_ColumnCaption@1087 : ARRAY [32] OF Text[1024];

    LOCAL PROCEDURE SetDateFilter@1088(ColumnID@1000 : Integer);
    BEGIN
      IF QtyType = QtyType::"Net Change" THEN
        IF MatrixRecords[ColumnID]."Period Start" = MatrixRecords[ColumnID]."Period End" THEN
          SETRANGE("Date Filter",MatrixRecords[ColumnID]."Period Start")
        ELSE
          SETRANGE("Date Filter",MatrixRecords[ColumnID]."Period Start",MatrixRecords[ColumnID]."Period End")
      ELSE
        SETRANGE("Date Filter",0D,MatrixRecords[ColumnID]."Period End");
    END;

    LOCAL PROCEDURE MATRIX_OnFindRecord@1089(Which@1007 : Text[1024]) : Boolean;
    BEGIN
      EXIT(PeriodFormMgt.FindDate(Which,MatrixRecord,PeriodType));
    END;

    LOCAL PROCEDURE MATRIX_OnNextRecord@1090(Steps@1008 : Integer) : Integer;
    BEGIN
      EXIT(PeriodFormMgt.NextDate(Steps,MatrixRecord,PeriodType));
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1091(ColumnID@1000 : Integer);
    BEGIN
      SetDateFilter(ColumnID);
      CALCFIELDS(Capacity);
      IF Capacity <> 0 THEN
        MATRIX_CellData[MATRIX_ColumnOrdinal] := FORMAT(Capacity)
      ELSE
        MATRIX_CellData[MATRIX_ColumnOrdinal] := '';
    END;

    LOCAL PROCEDURE MatrixOnDrillDown@4(ColumnID@1000 : Integer);
    VAR
      ResCapacityEntries@1001 : Record 160;
    BEGIN
      SetDateFilter(ColumnID);
      ResCapacityEntries.SETCURRENTKEY("Resource Group No.",Date);
      ResCapacityEntries.SETRANGE("Resource Group No.","No.");
      ResCapacityEntries.SETFILTER(Date,GETFILTER("Date Filter"));
      PAGE.RUN(0,ResCapacityEntries);
    END;

    [Internal]
    PROCEDURE Load@3(PeriodType1@1003 : 'Day,Week,Month,Quarter,Year,Accounting Period';QtyType1@1000 : 'Net Change,Balance at Date';MatrixColumns1@1001 : ARRAY [32] OF Text[1024];VAR MatrixRecords1@1002 : ARRAY [32] OF Record 2000000007);
    VAR
      i@1004 : Integer;
    BEGIN
      PeriodType := PeriodType1;
      QtyType := QtyType1;
      COPYARRAY(MATRIX_ColumnCaption,MatrixColumns1,1);
      FOR i := 1 TO ARRAYLEN(MatrixRecords) DO
        MatrixRecords[i].COPY(MatrixRecords1[i]);
    END;

    LOCAL PROCEDURE ValidateCapacity@1(ColumnID@1000 : Integer);
    BEGIN
      SetDateFilter(ColumnID);
      CALCFIELDS(Capacity);
      EVALUATE(Capacity,MATRIX_CellData[ColumnID]);
      VALIDATE(Capacity);
    END;

    BEGIN
    END.
  }
}

