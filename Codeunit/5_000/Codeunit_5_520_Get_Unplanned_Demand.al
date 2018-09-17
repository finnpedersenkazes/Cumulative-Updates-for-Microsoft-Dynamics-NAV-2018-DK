OBJECT Codeunit 5520 Get Unplanned Demand
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    TableNo=5520;
    OnRun=BEGIN
            DELETEALL;
            SalesLine.SETFILTER("Document Type",'%1|%2',SalesLine."Document Type"::Order,SalesLine."Document Type"::"Return Order");
            ProdOrderComp.SETFILTER(
              Status,'%1|%2|%3',ProdOrderComp.Status::Planned,ProdOrderComp.Status::"Firm Planned",ProdOrderComp.Status::Released);
            ServLine.SETRANGE("Document Type",ServLine."Document Type"::Order);
            AsmLine.SETRANGE("Document Type",AsmLine."Document Type"::Order);
            JobPlanningLine.SETRANGE(Status,JobPlanningLine.Status::Order);

            OpenWindow(Text000,SalesLine.COUNT + ProdOrderComp.COUNT + ServLine.COUNT + JobPlanningLine.COUNT);
            GetUnplannedSalesLine(Rec);
            GetUnplannedProdOrderComp(Rec);
            GetUnplannedAsmLine(Rec);
            GetUnplannedServLine(Rec);
            GetUnplannedJobPlanningLine(Rec);
            Window.CLOSE;

            RESET;
            SETCURRENTKEY("Demand Date",Level);
            SETRANGE(Level,1);
            OpenWindow(Text000,COUNT);
            CalcNeededDemands(Rec);
            Window.CLOSE;
          END;

  }
  CODE
  {
    VAR
      SalesLine@1000 : Record 37;
      ProdOrderComp@1002 : Record 5407;
      Text000@1004 : TextConst 'DAN=Bestemmer ikke-planlagte ordrer @1@@@@@@@;ENU=Determining Unplanned Orders @1@@@@@@@';
      ServLine@1007 : Record 5902;
      JobPlanningLine@1006 : Record 1003;
      AsmLine@1010 : Record 901;
      Window@1009 : Dialog;
      WindowUpdateDateTime@1008 : DateTime;
      NoOfRecords@1005 : Integer;
      i@1003 : Integer;
      DemandQtyBase@1001 : Decimal;
      IncludeMetDemandForSpecificSalesOrderNo@1011 : Code[20];

    [External]
    PROCEDURE SetIncludeMetDemandForSpecificSalesOrderNo@8(SalesOrderNo@1000 : Code[20]);
    BEGIN
      IncludeMetDemandForSpecificSalesOrderNo := SalesOrderNo;
    END;

    LOCAL PROCEDURE GetUnplannedSalesLine@5(VAR UnplannedDemand@1000 : Record 5520);
    VAR
      SalesHeader@1001 : Record 36;
    BEGIN
      WITH UnplannedDemand DO
        IF SalesLine.FIND('-') THEN
          REPEAT
            UpdateWindow;
            DemandQtyBase := GetSalesLineNeededQty(SalesLine);
            IF DemandQtyBase > 0 THEN BEGIN
              IF NOT ((SalesLine."Document Type" = "Demand SubType") AND
                      (SalesLine."Document No." = "Demand Order No."))
              THEN BEGIN
                SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.");
                InsertUnplannedDemand(
                  UnplannedDemand,"Demand Type"::Sales,SalesLine."Document Type",SalesLine."Document No.",SalesHeader.Status);
              END;
              InsertSalesLine(UnplannedDemand);
            END;
          UNTIL SalesLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetUnplannedProdOrderComp@6(VAR UnplannedDemand@1000 : Record 5520);
    BEGIN
      WITH UnplannedDemand DO
        IF ProdOrderComp.FIND('-') THEN
          REPEAT
            UpdateWindow;
            DemandQtyBase := GetProdOrderCompNeededQty(ProdOrderComp);
            IF DemandQtyBase > 0 THEN BEGIN
              IF NOT ((ProdOrderComp.Status = "Demand SubType") AND
                      (ProdOrderComp."Prod. Order No." = "Demand Order No."))
              THEN
                InsertUnplannedDemand(
                  UnplannedDemand,"Demand Type"::Production,ProdOrderComp.Status,ProdOrderComp."Prod. Order No.",ProdOrderComp.Status);
              InsertProdOrderCompLine(UnplannedDemand);
            END;
          UNTIL ProdOrderComp.NEXT = 0;
    END;

    LOCAL PROCEDURE GetUnplannedAsmLine@14(VAR UnplannedDemand@1000 : Record 5520);
    VAR
      AsmHeader@1001 : Record 900;
    BEGIN
      WITH UnplannedDemand DO
        IF AsmLine.FIND('-') THEN
          REPEAT
            UpdateWindow;
            DemandQtyBase := GetAsmLineNeededQty(AsmLine);
            IF DemandQtyBase > 0 THEN BEGIN
              IF NOT ((AsmLine."Document Type" = "Demand SubType") AND
                      (AsmLine."Document No." = "Demand Order No."))
              THEN BEGIN
                AsmHeader.GET(AsmLine."Document Type",AsmLine."Document No.");
                InsertUnplannedDemand(
                  UnplannedDemand,"Demand Type"::Assembly,AsmLine."Document Type",AsmLine."Document No.",AsmHeader.Status);
              END;
              InsertAsmLine(UnplannedDemand);
            END;
          UNTIL AsmLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetUnplannedServLine@17(VAR UnplannedDemand@1000 : Record 5520);
    VAR
      ServHeader@1001 : Record 5900;
    BEGIN
      WITH UnplannedDemand DO
        IF ServLine.FIND('-') THEN
          REPEAT
            UpdateWindow;
            DemandQtyBase := GetServLineNeededQty(ServLine);
            IF DemandQtyBase > 0 THEN BEGIN
              IF NOT ((ServLine."Document Type" = "Demand SubType") AND
                      (ServLine."Document No." = "Demand Order No."))
              THEN BEGIN
                ServHeader.GET(ServLine."Document Type",ServLine."Document No.");
                InsertUnplannedDemand(
                  UnplannedDemand,"Demand Type"::Service,ServLine."Document Type",ServLine."Document No.",ServHeader.Status);
              END;
              InsertServLine(UnplannedDemand);
            END;
          UNTIL ServLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetUnplannedJobPlanningLine@19(VAR UnplannedDemand@1000 : Record 5520);
    VAR
      Job@1001 : Record 167;
    BEGIN
      WITH UnplannedDemand DO
        IF JobPlanningLine.FIND('-') THEN
          REPEAT
            UpdateWindow;
            DemandQtyBase := GetJobPlanningLineNeededQty(JobPlanningLine);
            IF DemandQtyBase > 0 THEN BEGIN
              IF NOT ((JobPlanningLine.Status = "Demand SubType") AND
                      (JobPlanningLine."Job No." = "Demand Order No."))
              THEN BEGIN
                Job.GET(JobPlanningLine."Job No.");
                InsertUnplannedDemand(
                  UnplannedDemand,"Demand Type"::Job,JobPlanningLine.Status,JobPlanningLine."Job No.",Job.Status);
              END;
              InsertJobPlanningLine(UnplannedDemand);
            END;
          UNTIL JobPlanningLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetSalesLineNeededQty@1(SalesLine@1000 : Record 37) : Decimal;
    BEGIN
      WITH SalesLine DO BEGIN
        IF Planned OR ("No." = '') OR (Type <> Type::Item) OR "Drop Shipment" OR "Special Order" OR IsServiceItem THEN
          EXIT(0);

        CALCFIELDS("Reserved Qty. (Base)");
        EXIT(-SignedXX("Outstanding Qty. (Base)" - "Reserved Qty. (Base)"));
      END;
    END;

    LOCAL PROCEDURE GetProdOrderCompNeededQty@2(ProdOrderComp@1000 : Record 5407) : Decimal;
    BEGIN
      WITH ProdOrderComp DO BEGIN
        IF "Item No." = '' THEN
          EXIT(0);

        CALCFIELDS("Reserved Qty. (Base)");
        EXIT("Remaining Qty. (Base)" - "Reserved Qty. (Base)");
      END;
    END;

    LOCAL PROCEDURE GetAsmLineNeededQty@15(AsmLine@1000 : Record 901) : Decimal;
    BEGIN
      WITH AsmLine DO BEGIN
        IF ("No." = '') OR (Type <> Type::Item) THEN
          EXIT(0);

        CALCFIELDS("Reserved Qty. (Base)");
        EXIT(-SignedXX("Remaining Quantity (Base)" - "Reserved Qty. (Base)"));
      END;
    END;

    LOCAL PROCEDURE GetServLineNeededQty@21(ServLine@1000 : Record 5902) : Decimal;
    BEGIN
      WITH ServLine DO BEGIN
        IF Planned OR ("No." = '') OR (Type <> Type::Item) THEN
          EXIT(0);

        CALCFIELDS("Reserved Qty. (Base)");
        EXIT(-SignedXX("Outstanding Qty. (Base)" - "Reserved Qty. (Base)"));
      END;
    END;

    LOCAL PROCEDURE GetJobPlanningLineNeededQty@22(JobPlanningLine@1000 : Record 1003) : Decimal;
    BEGIN
      WITH JobPlanningLine DO BEGIN
        IF Planned OR ("No." = '') OR (Type <> Type::Item) OR IsServiceItem THEN
          EXIT(0);

        CALCFIELDS("Reserved Qty. (Base)");
        EXIT("Remaining Qty. (Base)" - "Reserved Qty. (Base)");
      END;
    END;

    LOCAL PROCEDURE InsertSalesLine@4(VAR UnplannedDemand@1000 : Record 5520);
    VAR
      UnplannedDemand2@1001 : Record 5520;
    BEGIN
      WITH UnplannedDemand DO BEGIN
        UnplannedDemand2.COPY(UnplannedDemand);
        InitRecord(
          SalesLine."Line No.",0,SalesLine."No.",SalesLine.Description,SalesLine."Variant Code",SalesLine."Location Code",
          SalesLine."Bin Code",SalesLine."Unit of Measure Code",SalesLine."Qty. per Unit of Measure",
          DemandQtyBase,SalesLine."Shipment Date");
        Reserve := SalesLine.Reserve = SalesLine.Reserve::Always;
        "Special Order" := SalesLine."Special Order";
        "Purchasing Code" := SalesLine."Purchasing Code";
        INSERT;
        COPY(UnplannedDemand2);
      END;
    END;

    LOCAL PROCEDURE InsertProdOrderCompLine@7(VAR UnplannedDemand@1001 : Record 5520);
    VAR
      UnplannedDemand2@1000 : Record 5520;
      Item@1002 : Record 27;
    BEGIN
      WITH UnplannedDemand DO BEGIN
        UnplannedDemand2.COPY(UnplannedDemand);
        InitRecord(
          ProdOrderComp."Prod. Order Line No.",ProdOrderComp."Line No.",ProdOrderComp."Item No.",ProdOrderComp.Description,
          ProdOrderComp."Variant Code",ProdOrderComp."Location Code",ProdOrderComp."Bin Code",ProdOrderComp."Unit of Measure Code",
          ProdOrderComp."Qty. per Unit of Measure",DemandQtyBase,ProdOrderComp."Due Date");
        Item.GET("Item No.");
        Reserve :=
          (Item.Reserve = Item.Reserve::Always) AND
          NOT (("Demand Type" = "Demand Type"::Production) AND
               ("Demand SubType" = ProdOrderComp.Status::Planned));
        INSERT;
        COPY(UnplannedDemand2);
      END;
    END;

    LOCAL PROCEDURE InsertAsmLine@13(VAR UnplannedDemand@1000 : Record 5520);
    VAR
      UnplannedDemand2@1001 : Record 5520;
    BEGIN
      WITH UnplannedDemand DO BEGIN
        UnplannedDemand2.COPY(UnplannedDemand);
        InitRecord(
          AsmLine."Line No.",0,AsmLine."No.",AsmLine.Description,AsmLine."Variant Code",AsmLine."Location Code",
          AsmLine."Bin Code",AsmLine."Unit of Measure Code",AsmLine."Qty. per Unit of Measure",
          DemandQtyBase,AsmLine."Due Date");
        Reserve := AsmLine.Reserve = AsmLine.Reserve::Always;
        INSERT;
        COPY(UnplannedDemand2);
      END;
    END;

    LOCAL PROCEDURE InsertServLine@23(VAR UnplannedDemand@1000 : Record 5520);
    VAR
      UnplannedDemand2@1001 : Record 5520;
    BEGIN
      WITH UnplannedDemand DO BEGIN
        UnplannedDemand2.COPY(UnplannedDemand);
        InitRecord(
          ServLine."Line No.",0,ServLine."No.",ServLine.Description,ServLine."Variant Code",ServLine."Location Code",
          ServLine."Bin Code",ServLine."Unit of Measure Code",ServLine."Qty. per Unit of Measure",
          DemandQtyBase,ServLine."Needed by Date");
        Reserve := ServLine.Reserve = ServLine.Reserve::Always;
        INSERT;
        COPY(UnplannedDemand2);
      END;
    END;

    LOCAL PROCEDURE InsertJobPlanningLine@24(VAR UnplannedDemand@1000 : Record 5520);
    VAR
      UnplannedDemand2@1001 : Record 5520;
    BEGIN
      WITH UnplannedDemand DO BEGIN
        UnplannedDemand2.COPY(UnplannedDemand);
        InitRecord(
          JobPlanningLine."Job Contract Entry No.",0,JobPlanningLine."No.",JobPlanningLine.Description,JobPlanningLine."Variant Code",
          JobPlanningLine."Location Code",JobPlanningLine."Bin Code",JobPlanningLine."Unit of Measure Code",
          JobPlanningLine."Qty. per Unit of Measure",DemandQtyBase,JobPlanningLine."Planning Date");
        Reserve := JobPlanningLine.Reserve = JobPlanningLine.Reserve::Always;
        INSERT;
        COPY(UnplannedDemand2);
      END;
    END;

    LOCAL PROCEDURE InsertUnplannedDemand@20(VAR UnplannedDemand@1000 : Record 5520;DemandType@1001 : Integer;DemandSubtype@1002 : Integer;DemandOrderNo@1003 : Code[20];DemandStatus@1004 : Integer);
    BEGIN
      WITH UnplannedDemand DO BEGIN
        INIT;
        "Demand Type" := DemandType;
        "Demand SubType" := DemandSubtype;
        VALIDATE("Demand Order No.",DemandOrderNo);
        Status := DemandStatus;
        Level := 0;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE CalcNeededDemands@10(VAR UnplannedDemand@1000 : Record 5520);
    VAR
      TempUnplannedDemand@1004 : TEMPORARY Record 5520;
      OrderPlanningMgt@1002 : Codeunit 5522;
      HeaderExists@1005 : Boolean;
      ForceIncludeDemand@1001 : Boolean;
    BEGIN
      WITH TempUnplannedDemand DO BEGIN
        UnplannedDemand.RESET;
        MoveUnplannedDemand(UnplannedDemand,TempUnplannedDemand);

        SETCURRENTKEY("Demand Date",Level);
        SETRANGE(Level,1);
        WHILE FIND('-') DO BEGIN
          HeaderExists := FALSE;
          REPEAT
            UpdateWindow;
            UnplannedDemand := TempUnplannedDemand;
            IF UnplannedDemand."Special Order" THEN
              UnplannedDemand."Needed Qty. (Base)" := "Quantity (Base)"
            ELSE
              UnplannedDemand."Needed Qty. (Base)" :=
                OrderPlanningMgt.CalcNeededQty(
                  OrderPlanningMgt.CalcATPQty("Item No.","Variant Code","Location Code","Demand Date") +
                  CalcDemand(TempUnplannedDemand,FALSE) + CalcDemand(UnplannedDemand,TRUE),
                  "Quantity (Base)");

            ForceIncludeDemand :=
              (UnplannedDemand."Demand Order No." = IncludeMetDemandForSpecificSalesOrderNo) AND
              (UnplannedDemand."Demand Type" = UnplannedDemand."Demand Type"::Sales) AND
              (UnplannedDemand."Demand SubType" = SalesLine."Document Type"::Order);

            IF ForceIncludeDemand OR (UnplannedDemand."Needed Qty. (Base)" > 0) THEN BEGIN
              UnplannedDemand.INSERT;
              IF NOT HeaderExists THEN BEGIN
                InsertUnplannedDemandHeader(TempUnplannedDemand,UnplannedDemand);
                HeaderExists := TRUE;
                SETRANGE("Demand Type","Demand Type");
                SETRANGE("Demand SubType","Demand SubType");
                SETRANGE("Demand Order No.","Demand Order No.");
              END;
            END;
            DELETE;
          UNTIL NEXT = 0;
          SETRANGE("Demand Type");
          SETRANGE("Demand SubType");
          SETRANGE("Demand Order No.");
        END;
      END;
    END;

    LOCAL PROCEDURE CalcDemand@9(VAR UnplannedDemand@1000 : Record 5520;Planned@1001 : Boolean) DemandQty : Decimal;
    VAR
      UnplannedDemand2@1002 : Record 5520;
    BEGIN
      WITH UnplannedDemand DO BEGIN
        UnplannedDemand2.COPY(UnplannedDemand);
        RESET;
        SETCURRENTKEY("Item No.","Variant Code","Location Code","Demand Date");
        SETRANGE("Item No.","Item No.");
        SETRANGE("Variant Code","Variant Code");
        SETRANGE("Location Code","Location Code");
        IF Planned THEN BEGIN
          SETRANGE("Demand Date",0D,"Demand Date");
          CALCSUMS("Needed Qty. (Base)");
          DemandQty := "Needed Qty. (Base)";
        END ELSE BEGIN
          SETRANGE("Demand Date","Demand Date");
          CALCSUMS("Quantity (Base)");
          DemandQty := "Quantity (Base)";
        END;
        COPY(UnplannedDemand2);
      END;
    END;

    LOCAL PROCEDURE MoveUnplannedDemand@11(VAR FromUnplannedDemand@1000 : Record 5520;VAR ToUnplannedDemand@1001 : Record 5520);
    BEGIN
      WITH FromUnplannedDemand DO BEGIN
        ToUnplannedDemand.DELETEALL;
        IF FIND('-') THEN
          REPEAT
            ToUnplannedDemand := FromUnplannedDemand;
            ToUnplannedDemand.INSERT;
            DELETE;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE InsertUnplannedDemandHeader@18(VAR FromUnplannedDemand@1001 : Record 5520;VAR ToUnplannedDemand@1000 : Record 5520);
    VAR
      UnplannedDemand2@1002 : Record 5520;
    BEGIN
      UnplannedDemand2.COPY(FromUnplannedDemand);

      WITH FromUnplannedDemand DO BEGIN
        RESET;
        SETRANGE("Demand Type","Demand Type");
        SETRANGE("Demand SubType","Demand SubType");
        SETRANGE("Demand Order No.","Demand Order No.");
        SETRANGE(Level,0);
        FIND('-');
        ToUnplannedDemand := FromUnplannedDemand;
        ToUnplannedDemand."Demand Date" := UnplannedDemand2."Demand Date";
        ToUnplannedDemand.INSERT;
      END;

      FromUnplannedDemand.COPY(UnplannedDemand2);
    END;

    LOCAL PROCEDURE OpenWindow@12(DisplayText@1001 : Text[250];NoOfRecords2@1000 : Integer);
    BEGIN
      i := 0;
      NoOfRecords := NoOfRecords2;
      WindowUpdateDateTime := CURRENTDATETIME;
      Window.OPEN(DisplayText);
    END;

    LOCAL PROCEDURE UpdateWindow@3();
    BEGIN
      i := i + 1;
      IF CURRENTDATETIME - WindowUpdateDateTime >= 300 THEN BEGIN
        WindowUpdateDateTime := CURRENTDATETIME;
        Window.UPDATE(1,ROUND(i / NoOfRecords * 10000,1));
      END;
    END;

    BEGIN
    END.
  }
}

