OBJECT Page 99000816 Production Order Statistics
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Prod.ordrestatistik;
               ENU=Production Order Statistics];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5405;
    DataCaptionFields=No.,Description;
    PageType=Card;
    OnOpenPage=VAR
                 MfgSetup@1000 : Record 99000765;
               BEGIN
                 MfgSetup.GET;
                 MfgSetup.TESTFIELD("Show Capacity In");
                 CapacityUoM := MfgSetup."Show Capacity In";
               END;

    OnAfterGetRecord=VAR
                       CalendarMgt@1000 : Codeunit 99000755;
                     BEGIN
                       CLEAR(StdCost);
                       CLEAR(ExpCost);
                       CLEAR(ActCost);
                       CLEAR(CostCalcMgt);

                       GLSetup.GET;

                       ExpCapNeed := CostCalcMgt.CalcProdOrderExpCapNeed(Rec,FALSE) / CalendarMgt.TimeFactor(CapacityUoM);
                       ActTimeUsed := CostCalcMgt.CalcProdOrderActTimeUsed(Rec,FALSE) / CalendarMgt.TimeFactor(CapacityUoM);
                       ProdOrderLine.SETRANGE(Status,Status);
                       ProdOrderLine.SETRANGE("Prod. Order No.","No.");
                       ProdOrderLine.SETRANGE("Planning Level Code",0);
                       ProdOrderLine.SETFILTER("Item No.",'<>%1','');
                       IF ProdOrderLine.FIND('-') THEN
                         REPEAT
                           CostCalcMgt.CalcShareOfTotalCapCost(ProdOrderLine,ShareOfTotalCapCost);
                           CostCalcMgt.CalcProdOrderLineStdCost(
                             ProdOrderLine,1,GLSetup."Amount Rounding Precision",
                             StdCost[1],StdCost[2],StdCost[3],StdCost[4],StdCost[5]);
                           CostCalcMgt.CalcProdOrderLineExpCost(
                             ProdOrderLine,ShareOfTotalCapCost,
                             ExpCost[1],ExpCost[2],ExpCost[3],ExpCost[4],ExpCost[5]);
                           CostCalcMgt.CalcProdOrderLineActCost(
                             ProdOrderLine,
                             ActCost[1],ActCost[2],ActCost[3],ActCost[4],ActCost[5],
                             DummyVar,DummyVar,DummyVar,DummyVar,DummyVar);
                         UNTIL ProdOrderLine.NEXT = 0;

                       CalcTotal(StdCost,StdCost[6]);
                       CalcTotal(ExpCost,ExpCost[6]);
                       CalcTotal(ActCost,ActCost[6]);
                       CalcVariance;
                       TimeExpendedPct := CalcIndicatorPct(ExpCapNeed,ActTimeUsed);
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 1903895301;2;Group  ;
                GroupType=FixedLayout }

    { 1900545401;3;Group  ;
                CaptionML=[DAN=Kostpris (standard);
                           ENU=Standard Cost] }

    { 38  ;4   ;Field     ;
                Name=MaterialCost_StandardCost;
                CaptionML=[DAN=Materialekostpris;
                           ENU=Material Cost];
                ToolTipML=[DAN=Angiver den materialekostpris, der er relateret til produktionsordren.;
                           ENU=Specifies the material cost related to the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr=StdCost[1];
                AutoFormatType=1;
                Editable=FALSE }

    { 25  ;4   ;Field     ;
                Name=CapacityCost_StandardCost;
                CaptionML=[DAN=Kapacitetskostpris;
                           ENU=Capacity Cost];
                ToolTipML=[DAN=Angiver kostbel�bet for alle produktionskapaciteter (produktionsressourcer og arbejdscentre), der bruges til linjerne i produktionsordren.;
                           ENU=Specifies the cost amount of all production capacities (machine and work centers) that are used for lines in the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr=StdCost[2];
                AutoFormatType=1;
                Editable=FALSE }

    { 30  ;4   ;Field     ;
                CaptionML=[DAN=Underleverand�rkostpris;
                           ENU=Subcontracted Cost];
                ToolTipML=[DAN=Angiver underleverand�rkostbel�bet for alle linjer i produktionsordren.;
                           ENU=Specifies the subcontracted cost amount of all the lines in the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr=StdCost[3];
                AutoFormatType=1;
                Editable=FALSE }

    { 29  ;4   ;Field     ;
                CaptionML=[DAN=Indirekte kap.kostpris;
                           ENU=Capacity Overhead];
                ToolTipML=[DAN=Angiver indirekte kapacitetskostpris for alle linjer i produktionsordren.;
                           ENU=Specifies the capacity overhead amount of all the lines in the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr=StdCost[4];
                AutoFormatType=1;
                Editable=FALSE }

    { 45  ;4   ;Field     ;
                CaptionML=[DAN=Indirekte prod.kostpris;
                           ENU=Manufacturing Overhead];
                ToolTipML=[DAN=Angiver de produktionsomkostninger, der er relateret til produktionsordren.;
                           ENU=Specifies the manufacturing overhead related to the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr=StdCost[5];
                AutoFormatType=1;
                Editable=FALSE }

    { 23  ;4   ;Field     ;
                Name=TotalCost_StandardCost;
                CaptionML=[DAN=Kostbel�b;
                           ENU=Total Cost];
                ToolTipML=[DAN=Angiver summen af linjerne i hver kolonne.;
                           ENU=Specifies the sum of the lines in each column.];
                ApplicationArea=#Manufacturing;
                SourceExpr=StdCost[6];
                AutoFormatType=1;
                Editable=FALSE }

    { 10  ;4   ;Field     ;
                CaptionML=[DAN=Kapacitetsbehov;
                           ENU=Capacity Need];
                ToolTipML=[DAN=Angiver det samlede kapacitetsbehov for alle linjer i produktionsordren.;
                           ENU=Specifies the total capacity need of all the lines in the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr=CapacityUoM;
                TableRelation="Capacity Unit of Measure".Code;
                OnValidate=VAR
                             CalendarMgt@1000 : Codeunit 99000755;
                           BEGIN
                             ExpCapNeed := CostCalcMgt.CalcProdOrderExpCapNeed(Rec,FALSE) / CalendarMgt.TimeFactor(CapacityUoM);
                             ActTimeUsed := CostCalcMgt.CalcProdOrderActTimeUsed(Rec,FALSE) / CalendarMgt.TimeFactor(CapacityUoM);
                           END;
                            }

    { 1900724501;3;Group  ;
                CaptionML=[DAN=Forventet kostpris;
                           ENU=Expected Cost] }

    { 39  ;4   ;Field     ;
                Name=MaterialCost_ExpectedCost;
                ApplicationArea=#Manufacturing;
                SourceExpr=ExpCost[1];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 9   ;4   ;Field     ;
                Name=CapacityCost_ExpectedCost;
                ApplicationArea=#Manufacturing;
                SourceExpr=ExpCost[2];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 31  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=ExpCost[3];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 32  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=ExpCost[4];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 44  ;4   ;Field     ;
                Name=MfgOverhead_ExpectedCost;
                ApplicationArea=#Manufacturing;
                SourceExpr=ExpCost[5];
                Editable=FALSE;
                ShowCaption=No }

    { 19  ;4   ;Field     ;
                Name=TotalCost_ExpectedCost;
                ApplicationArea=#Manufacturing;
                SourceExpr=ExpCost[6];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 11  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=ExpCapNeed;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CostCalcMgt.CalcProdOrderExpCapNeed(Rec,TRUE);
                            END;

                ShowCaption=No }

    { 1900724401;3;Group  ;
                CaptionML=[DAN=Faktisk kostpris;
                           ENU=Actual Cost] }

    { 40  ;4   ;Field     ;
                Name=MaterialCost_ActualCost;
                ApplicationArea=#Manufacturing;
                SourceExpr=ActCost[1];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 12  ;4   ;Field     ;
                Name=CapacityCost_ActualCost;
                ApplicationArea=#Manufacturing;
                SourceExpr=ActCost[2];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 33  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=ActCost[3];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 34  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=ActCost[4];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 43  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=ActCost[5];
                Editable=FALSE;
                ShowCaption=No }

    { 20  ;4   ;Field     ;
                Name=TotalCost_ActualCost;
                ApplicationArea=#Manufacturing;
                SourceExpr=ActCost[6];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 14  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=ActTimeUsed;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CostCalcMgt.CalcProdOrderActTimeUsed(Rec,TRUE);
                            END;

                ShowCaption=No }

    { 1900724301;3;Group  ;
                CaptionML=[DAN=Afv.pct.;
                           ENU=Dev. %] }

    { 41  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=VarPct[1];
                Editable=FALSE;
                ShowCaption=No }

    { 15  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=VarPct[2];
                Editable=FALSE;
                ShowCaption=No }

    { 35  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=VarPct[3];
                Editable=FALSE;
                ShowCaption=No }

    { 36  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=VarPct[4];
                Editable=FALSE;
                ShowCaption=No }

    { 42  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=VarPct[5];
                Editable=FALSE;
                ShowCaption=No }

    { 21  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=VarPct[6];
                Editable=FALSE;
                ShowCaption=No }

    { 17  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=TimeExpendedPct;
                Editable=FALSE;
                ShowCaption=No }

    { 1900295601;3;Group  ;
                CaptionML=[DAN=Afvigelse;
                           ENU=Variance] }

    { 24  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=VarAmt[1];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 22  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=VarAmt[2];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 16  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=VarAmt[3];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 13  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=VarAmt[4];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 7   ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=VarAmt[5];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

    { 47  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=VarAmt[6];
                AutoFormatType=1;
                Editable=FALSE;
                ShowCaption=No }

  }
  CODE
  {
    VAR
      ProdOrderLine@1007 : Record 5406;
      GLSetup@1008 : Record 98;
      CostCalcMgt@1006 : Codeunit 5836;
      StdCost@1000 : ARRAY [6] OF Decimal;
      ExpCost@1001 : ARRAY [6] OF Decimal;
      ActCost@1002 : ARRAY [6] OF Decimal;
      VarAmt@1018 : ARRAY [6] OF Decimal;
      VarPct@1019 : ARRAY [6] OF Decimal;
      DummyVar@1005 : Decimal;
      ShareOfTotalCapCost@1004 : Decimal;
      TimeExpendedPct@1003 : Decimal;
      ExpCapNeed@1009 : Decimal;
      ActTimeUsed@1010 : Decimal;
      CapacityUoM@1012 : Code[10];

    LOCAL PROCEDURE CalcTotal@2(Operand@1000 : ARRAY [6] OF Decimal;VAR Total@1001 : Decimal);
    VAR
      i@1002 : Integer;
    BEGIN
      Total := 0;

      FOR i := 1 TO ARRAYLEN(Operand) - 1 DO
        Total := Total + Operand[i];
    END;

    LOCAL PROCEDURE CalcVariance@3();
    VAR
      i@1000 : Integer;
    BEGIN
      FOR i := 1 TO ARRAYLEN(VarAmt) DO BEGIN
        VarAmt[i] := ActCost[i] - StdCost[i];
        VarPct[i] := CalcIndicatorPct(StdCost[i],ActCost[i]);
      END;
    END;

    LOCAL PROCEDURE CalcIndicatorPct@1(Value@1000 : Decimal;Sum@1001 : Decimal) : Decimal;
    BEGIN
      IF Value = 0 THEN
        EXIT(0);

      EXIT(ROUND((Sum - Value) / Value * 100,1));
    END;

    BEGIN
    END.
  }
}

