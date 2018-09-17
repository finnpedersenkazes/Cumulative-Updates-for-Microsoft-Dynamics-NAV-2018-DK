OBJECT Codeunit 311 Item-Check Avail.
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    Permissions=TableData 1518=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Opdateringen er afbrudt p� grund af advarslen.;ENU=The update has been interrupted to respect the warning.';
      AvailableToPromise@1006 : Codeunit 5790;
      NotificationLifecycleMgt@1021 : Codeunit 1511;
      ItemNo@1017 : Code[20];
      UnitOfMeasureCode@1016 : Code[10];
      ItemLocationCode@1022 : Code[10];
      NewItemNetChange@1015 : Decimal;
      OldItemNetChange@1014 : Decimal;
      OldItemNetResChange@1024 : Decimal;
      NewItemNetResChange@1025 : Decimal;
      ItemNetChange@1013 : Decimal;
      QtyPerUnitOfMeasure@1012 : Decimal;
      InitialQtyAvailable@1011 : Decimal;
      UseOrderPromise@1010 : Boolean;
      GrossReq@1009 : Decimal;
      ReservedReq@1001 : Decimal;
      SchedRcpt@1008 : Decimal;
      ReservedRcpt@1002 : Decimal;
      EarliestAvailDate@1005 : Date;
      InventoryQty@1004 : Decimal;
      OldItemShipmentDate@1003 : Date;
      NotificationMsg@1007 : TextConst '@@@="%1=Item No.";DAN=Den disponible beholdning af varen %1 er mindre end det angivne antal p� denne lokation.;ENU=The available inventory for item %1 is lower than the entered quantity at this location.';
      DetailsTxt@1019 : TextConst 'DAN=Vis detaljer;ENU=Show details';
      ItemAvailabilityNotificationTxt@1020 : TextConst 'DAN=Varedisponering er lav.;ENU=Item availability is low.';
      ItemAvailabilityNotificationDescriptionTxt@1018 : TextConst 'DAN=Vis en advarsel, n�r nogen opretter en salgsordre eller salgsfaktura for en vare, som ikke er p� lager.;ENU=Show a warning when someone creates a sales order or sales invoice for an item that is out of stock.';

    [External]
    PROCEDURE ItemJnlCheckLine@1(ItemJnlLine@1000 : Record 83) Rollback : Boolean;
    BEGIN
      NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
        ItemJnlLine.RECORDID,GetItemAvailabilityNotificationId,TRUE);
      IF ItemJnlLineShowWarning(ItemJnlLine) THEN
        Rollback := ShowAndHandleAvailabilityPage(ItemJnlLine.RECORDID);
    END;

    [External]
    PROCEDURE SalesLineCheck@2(SalesLine@1000 : Record 37) Rollback : Boolean;
    VAR
      TempAsmHeader@1007 : TEMPORARY Record 900;
      TempAsmLine@1003 : TEMPORARY Record 901;
      ATOLink@1001 : Record 904;
    BEGIN
      NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
        SalesLine.RECORDID,GetItemAvailabilityNotificationId,TRUE);
      IF SalesLineShowWarning(SalesLine) THEN
        Rollback := ShowAndHandleAvailabilityPage(SalesLine.RECORDID);

      IF NOT Rollback THEN
        IF ATOLink.SalesLineCheckAvailShowWarning(SalesLine,TempAsmHeader,TempAsmLine) THEN
          Rollback := ShowAsmWarningYesNo(TempAsmHeader,TempAsmLine);
    END;

    [External]
    PROCEDURE TransferLineCheck@3(TransLine@1000 : Record 5741) Rollback : Boolean;
    BEGIN
      NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
        TransLine.RECORDID,GetItemAvailabilityNotificationId,TRUE);
      IF TransferLineShowWarning(TransLine) THEN
        Rollback := ShowAndHandleAvailabilityPage(TransLine.RECORDID);
    END;

    [External]
    PROCEDURE ServiceInvLineCheck@4(ServInvLine@1000 : Record 5902) Rollback : Boolean;
    BEGIN
      NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
        ServInvLine.RECORDID,GetItemAvailabilityNotificationId,TRUE);
      IF ServiceInvLineShowWarning(ServInvLine) THEN
        Rollback := ShowAndHandleAvailabilityPage(ServInvLine.RECORDID);
    END;

    [External]
    PROCEDURE JobPlanningLineCheck@5(JobPlanningLine@1000 : Record 1003) Rollback : Boolean;
    BEGIN
      NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
        JobPlanningLine.RECORDID,GetItemAvailabilityNotificationId,TRUE);
      IF JobPlanningLineShowWarning(JobPlanningLine) THEN
        Rollback := ShowAndHandleAvailabilityPage(JobPlanningLine.RECORDID);
    END;

    [External]
    PROCEDURE AssemblyLineCheck@6(AssemblyLine@1000 : Record 901) Rollback : Boolean;
    BEGIN
      NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
        AssemblyLine.RECORDID,GetItemAvailabilityNotificationId,TRUE);
      IF AsmOrderLineShowWarning(AssemblyLine) THEN
        Rollback := ShowAndHandleAvailabilityPage(AssemblyLine.RECORDID);
    END;

    [External]
    PROCEDURE ShowAsmWarningYesNo@22(VAR AsmHeader@1003 : Record 900;VAR AsmLine@1002 : Record 901) Rollback : Boolean;
    VAR
      AsmLineMgt@1000 : Codeunit 905;
    BEGIN
      Rollback := AsmLineMgt.ShowAvailability(FALSE,AsmHeader,AsmLine);
    END;

    [External]
    PROCEDURE ItemJnlLineShowWarning@15(ItemJnlLine@1000 : Record 83) : Boolean;
    BEGIN
      IF NOT ShowWarningForThisItem(ItemJnlLine."Item No.") THEN
        EXIT(FALSE);

      CASE ItemJnlLine."Entry Type" OF
        ItemJnlLine."Entry Type"::Purchase,ItemJnlLine."Entry Type"::"Positive Adjmt.":
          ItemNetChange := ItemJnlLine.Quantity;
        ItemJnlLine."Entry Type"::Sale,ItemJnlLine."Entry Type"::"Negative Adjmt.",ItemJnlLine."Entry Type"::Transfer:
          ItemNetChange := -ItemJnlLine.Quantity;
      END;
      EXIT(
        ShowWarning(
          ItemJnlLine."Item No.",
          ItemJnlLine."Variant Code",
          ItemJnlLine."Location Code",
          ItemJnlLine."Unit of Measure Code",
          ItemJnlLine."Qty. per Unit of Measure",
          ItemNetChange,
          0,
          0D,
          0D));
    END;

    [External]
    PROCEDURE SalesLineShowWarning@14(SalesLine@1000 : Record 37) : Boolean;
    VAR
      OldSalesLine@1002 : Record 37;
      CompanyInfo@1004 : Record 79;
      LookAheadDate@1005 : Date;
    BEGIN
      IF SalesLine."Drop Shipment" THEN
        EXIT(FALSE);
      IF SalesLine.IsServiceItem THEN
        EXIT(FALSE);
      IF SalesLine.FullQtyIsForAsmToOrder THEN
        EXIT(FALSE);
      IF NOT ShowWarningForThisItem(SalesLine."No.") THEN
        EXIT(FALSE);

      CLEAR(AvailableToPromise);

      OldItemNetChange := 0;
      OldSalesLine := SalesLine;
      IF OldSalesLine.FIND THEN BEGIN // Find previous quantity within Check-Avail. Period
        CompanyInfo.GET;
        LookAheadDate :=
          AvailableToPromise.AdjustedEndingDate(
            CALCDATE(CompanyInfo."Check-Avail. Period Calc.",SalesLine."Shipment Date"),
            CompanyInfo."Check-Avail. Time Bucket");
        IF (OldSalesLine."Document Type" = OldSalesLine."Document Type"::Order) AND
           (OldSalesLine."No." = SalesLine."No.") AND
           (OldSalesLine."Variant Code" = SalesLine."Variant Code") AND
           (OldSalesLine."Location Code" = SalesLine."Location Code") AND
           (OldSalesLine."Bin Code" = SalesLine."Bin Code") AND
           NOT OldSalesLine."Drop Shipment" AND
           (OldSalesLine."Shipment Date" <= LookAheadDate)
        THEN
          IF OldSalesLine."Shipment Date" > SalesLine."Shipment Date" THEN
            AvailableToPromise.SetChangedSalesLine(OldSalesLine)
          ELSE BEGIN
            OldItemNetChange := -OldSalesLine."Outstanding Qty. (Base)";
            OldSalesLine.CALCFIELDS("Reserved Qty. (Base)");
            OldItemNetResChange := -OldSalesLine."Reserved Qty. (Base)";
          END;
      END;

      NewItemNetResChange := -(SalesLine."Qty. to Asm. to Order (Base)" - OldSalesLine.QtyBaseOnATO);

      IF SalesLine."Document Type" = SalesLine."Document Type"::Order THEN
        UseOrderPromise := TRUE;
      EXIT(
        ShowWarning(
          SalesLine."No.",
          SalesLine."Variant Code",
          SalesLine."Location Code",
          SalesLine."Unit of Measure Code",
          SalesLine."Qty. per Unit of Measure",
          -SalesLine."Outstanding Quantity",
          OldItemNetChange,
          SalesLine."Shipment Date",
          OldSalesLine."Shipment Date"));
    END;

    LOCAL PROCEDURE ShowWarning@13(ItemNoArg@1000 : Code[20];ItemVariantCodeArg@1001 : Code[10];ItemLocationCodeArg@1002 : Code[10];UnitOfMeasureCodeArg@1004 : Code[10];QtyPerUnitOfMeasureArg@1005 : Decimal;NewItemNetChangeArg@1006 : Decimal;OldItemNetChangeArg@1007 : Decimal;ShipmentDateArg@1008 : Date;OldShipmentDateArg@1009 : Date) : Boolean;
    VAR
      Item@1003 : Record 27;
    BEGIN
      ItemNo := ItemNoArg;
      UnitOfMeasureCode := UnitOfMeasureCodeArg;
      QtyPerUnitOfMeasure := QtyPerUnitOfMeasureArg;
      NewItemNetChange := NewItemNetChangeArg;
      OldItemNetChange := ConvertQty(OldItemNetChangeArg);
      OldItemShipmentDate := OldShipmentDateArg;
      ItemLocationCode := ItemLocationCodeArg;

      IF NewItemNetChange >= 0 THEN
        EXIT(FALSE);

      SetFilterOnItem(Item,ItemNo,ItemVariantCodeArg,ItemLocationCode,ShipmentDateArg);
      Calculate(Item);
      EXIT(InitialQtyAvailable + ItemNetChange - OldItemNetResChange < 0);
    END;

    LOCAL PROCEDURE SetFilterOnItem@28(VAR Item@1000 : Record 27;ItemNo@1003 : Code[20];ItemVariantCode@1002 : Code[10];ItemLocationCode@1001 : Code[10];ShipmentDate@1004 : Date);
    BEGIN
      Item.GET(ItemNo);
      Item.SETRANGE("No.",ItemNo);
      Item.SETRANGE("Variant Filter",ItemVariantCode);
      Item.SETRANGE("Location Filter",ItemLocationCode);
      Item.SETRANGE("Drop Shipment Filter",FALSE);

      IF UseOrderPromise THEN
        Item.SETRANGE("Date Filter",0D,ShipmentDate)
      ELSE
        Item.SETRANGE("Date Filter",0D,WORKDATE);
    END;

    LOCAL PROCEDURE Calculate@12(VAR Item@1002 : Record 27);
    VAR
      CompanyInfo@1000 : Record 79;
    BEGIN
      CompanyInfo.GET;
      QtyAvailToPromise(Item,CompanyInfo);
      EarliestAvailDate := EarliestAvailabilityDate(Item,CompanyInfo);

      IF NOT UseOrderPromise THEN
        SchedRcpt := 0;

      OldItemNetResChange := ConvertQty(OldItemNetResChange);
      NewItemNetResChange := ConvertQty(NewItemNetResChange);

      ItemNetChange := 0;
      IF Item."No." = ItemNo THEN BEGIN
        ItemNetChange := NewItemNetChange;
        IF GrossReq + OldItemNetChange >= 0 THEN
          GrossReq := GrossReq + OldItemNetChange;
      END;

      InitialQtyAvailable :=
        InventoryQty +
        (SchedRcpt - ReservedRcpt) - (GrossReq - ReservedReq) -
        NewItemNetResChange;
    END;

    LOCAL PROCEDURE QtyAvailToPromise@17(VAR Item@1000 : Record 27;CompanyInfo@1003 : Record 79);
    BEGIN
      AvailableToPromise.QtyAvailabletoPromise(
        Item,GrossReq,SchedRcpt,Item.GETRANGEMAX("Date Filter"),
        CompanyInfo."Check-Avail. Time Bucket",CompanyInfo."Check-Avail. Period Calc.");
      InventoryQty := ConvertQty(AvailableToPromise.CalcAvailableInventory(Item));
      GrossReq := ConvertQty(GrossReq);
      ReservedReq := ConvertQty(AvailableToPromise.CalcReservedRequirement(Item) + OldItemNetResChange);
      SchedRcpt := ConvertQty(SchedRcpt);
      ReservedRcpt := ConvertQty(AvailableToPromise.CalcReservedReceipt(Item));
    END;

    LOCAL PROCEDURE EarliestAvailabilityDate@19(VAR Item@1000 : Record 27;CompanyInfo@1002 : Record 79) : Date;
    VAR
      AvailableQty@1003 : Decimal;
      NewItemNetChangeBase@1001 : Decimal;
      OldItemNetChangeBase@1004 : Decimal;
    BEGIN
      NewItemNetChangeBase := ConvertQtyToBaseQty(NewItemNetChange);
      OldItemNetChangeBase := ConvertQtyToBaseQty(OldItemNetChange);
      EXIT(
        AvailableToPromise.EarliestAvailabilityDate(
          Item,-NewItemNetChangeBase,Item.GETRANGEMAX("Date Filter"),-OldItemNetChangeBase,OldItemShipmentDate,AvailableQty,
          CompanyInfo."Check-Avail. Time Bucket",CompanyInfo."Check-Avail. Period Calc."));
    END;

    LOCAL PROCEDURE ConvertQty@31(Qty@1000 : Decimal) : Decimal;
    BEGIN
      IF QtyPerUnitOfMeasure = 0 THEN
        QtyPerUnitOfMeasure := 1;
      EXIT(ROUND(Qty / QtyPerUnitOfMeasure,0.00001));
    END;

    LOCAL PROCEDURE ConvertQtyToBaseQty@26(Qty@1000 : Decimal) : Decimal;
    BEGIN
      IF QtyPerUnitOfMeasure = 0 THEN
        QtyPerUnitOfMeasure := 1;
      EXIT(ROUND(Qty * QtyPerUnitOfMeasure,0.00001));
    END;

    [External]
    PROCEDURE TransferLineShowWarning@11(TransLine@1000 : Record 5741) : Boolean;
    VAR
      OldTransLine@1002 : Record 5741;
    BEGIN
      IF NOT ShowWarningForThisItem(TransLine."Item No.") THEN
        EXIT(FALSE);

      UseOrderPromise := TRUE;

      OldTransLine := TransLine;
      IF OldTransLine.FIND THEN // Find previous quantity
        IF (OldTransLine."Item No." = TransLine."Item No.") AND
           (OldTransLine."Variant Code" = TransLine."Variant Code") AND
           (OldTransLine."Transfer-from Code" = TransLine."Transfer-from Code")
        THEN BEGIN
          OldItemNetChange := -OldTransLine."Outstanding Qty. (Base)";
          OldTransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");
          OldItemNetResChange := -OldTransLine."Reserved Qty. Outbnd. (Base)";
        END;

      EXIT(
        ShowWarning(
          TransLine."Item No.",
          TransLine."Variant Code",
          TransLine."Transfer-from Code",
          TransLine."Unit of Measure Code",
          TransLine."Qty. per Unit of Measure",
          -TransLine."Outstanding Quantity",
          OldItemNetChange,
          TransLine."Shipment Date",
          OldTransLine."Shipment Date"));
    END;

    [External]
    PROCEDURE ServiceInvLineShowWarning@10(ServLine@1000 : Record 5902) : Boolean;
    VAR
      OldServLine@1002 : Record 5902;
    BEGIN
      IF NOT ShowWarningForThisItem(ServLine."No.") THEN
        EXIT(FALSE);

      OldItemNetChange := 0;

      OldServLine := ServLine;

      IF OldServLine.FIND THEN // Find previous quantity
        IF (OldServLine."Document Type" = OldServLine."Document Type"::Order) AND
           (OldServLine."No." = ServLine."No.") AND
           (OldServLine."Variant Code" = ServLine."Variant Code") AND
           (OldServLine."Location Code" = ServLine."Location Code") AND
           (OldServLine."Bin Code" = ServLine."Bin Code")
        THEN BEGIN
          OldItemNetChange := -OldServLine."Outstanding Qty. (Base)";
          OldServLine.CALCFIELDS("Reserved Qty. (Base)");
          OldItemNetResChange := -OldServLine."Reserved Qty. (Base)";
        END;

      UseOrderPromise := TRUE;
      EXIT(
        ShowWarning(
          ServLine."No.",
          ServLine."Variant Code",
          ServLine."Location Code",
          ServLine."Unit of Measure Code",
          ServLine."Qty. per Unit of Measure",
          -ServLine."Outstanding Quantity",
          OldItemNetChange,
          ServLine."Needed by Date",
          OldServLine."Needed by Date"));
    END;

    [External]
    PROCEDURE JobPlanningLineShowWarning@8(JobPlanningLine@1000 : Record 1003) : Boolean;
    VAR
      OldJobPlanningLine@1002 : Record 1003;
    BEGIN
      IF NOT ShowWarningForThisItem(JobPlanningLine."No.") THEN
        EXIT(FALSE);

      OldItemNetChange := 0;

      OldJobPlanningLine := JobPlanningLine;

      IF OldJobPlanningLine.FIND THEN // Find previous quantity
        IF (OldJobPlanningLine.Type = OldJobPlanningLine.Type::Item) AND
           (OldJobPlanningLine."No." = JobPlanningLine."No.") AND
           (OldJobPlanningLine."Variant Code" = JobPlanningLine."Variant Code") AND
           (OldJobPlanningLine."Location Code" = JobPlanningLine."Location Code") AND
           (OldJobPlanningLine."Bin Code" = JobPlanningLine."Bin Code")
        THEN BEGIN
          OldItemNetChange := -OldJobPlanningLine."Quantity (Base)";
          OldJobPlanningLine.CALCFIELDS("Reserved Qty. (Base)");
          OldItemNetResChange := -OldJobPlanningLine."Reserved Qty. (Base)";
        END;

      UseOrderPromise := TRUE;
      EXIT(
        ShowWarning(
          JobPlanningLine."No.",
          JobPlanningLine."Variant Code",
          JobPlanningLine."Location Code",
          JobPlanningLine."Unit of Measure Code",
          JobPlanningLine."Qty. per Unit of Measure",
          -JobPlanningLine."Remaining Qty.",
          OldItemNetChange,
          JobPlanningLine."Planning Date",
          OldJobPlanningLine."Planning Date"));
    END;

    [External]
    PROCEDURE AsmOrderLineShowWarning@9(AssemblyLine@1000 : Record 901) : Boolean;
    VAR
      OldAssemblyLine@1001 : Record 901;
    BEGIN
      CLEAR(AvailableToPromise);

      OldItemNetChange := 0;

      OldAssemblyLine := AssemblyLine;

      IF OldAssemblyLine.FIND THEN // Find previous quantity
        IF (OldAssemblyLine."Document Type" = OldAssemblyLine."Document Type"::Order) AND
           (OldAssemblyLine.Type = OldAssemblyLine.Type::Item) AND
           (OldAssemblyLine."No." = AssemblyLine."No.") AND
           (OldAssemblyLine."Variant Code" = AssemblyLine."Variant Code") AND
           (OldAssemblyLine."Location Code" = AssemblyLine."Location Code") AND
           (OldAssemblyLine."Bin Code" = AssemblyLine."Bin Code")
        THEN
          IF OldAssemblyLine."Due Date" > AssemblyLine."Due Date" THEN
            AvailableToPromise.SetChangedAsmLine(OldAssemblyLine)
          ELSE BEGIN
            OldItemNetChange := -OldAssemblyLine."Remaining Quantity (Base)";
            OldAssemblyLine.CALCFIELDS("Reserved Qty. (Base)");
            OldItemNetResChange := -OldAssemblyLine."Reserved Qty. (Base)";
          END;

      UseOrderPromise := TRUE;
      EXIT(
        ShowWarning(
          AssemblyLine."No.",
          AssemblyLine."Variant Code",
          AssemblyLine."Location Code",
          AssemblyLine."Unit of Measure Code",
          AssemblyLine."Qty. per Unit of Measure",
          -AssemblyLine."Remaining Quantity",
          OldItemNetChange,
          AssemblyLine."Due Date",
          OldAssemblyLine."Due Date"));
    END;

    [External]
    PROCEDURE AsmOrderCalculate@18(AssemblyHeader@1000 : Record 900;VAR InventoryQty2@1006 : Decimal;VAR GrossReq2@1005 : Decimal;VAR ReservedReq2@1007 : Decimal;VAR SchedRcpt2@1004 : Decimal;VAR ReservedRcpt2@1008 : Decimal);
    VAR
      OldAssemblyHeader@1001 : Record 900;
      Item@1002 : Record 27;
      CompanyInfo@1003 : Record 79;
    BEGIN
      WITH AssemblyHeader DO BEGIN
        UseOrderPromise := TRUE;

        IF "Due Date" = 0D THEN
          "Due Date" := WORKDATE;
        SetFilterOnItem(Item,"Item No.","Variant Code","Location Code","Due Date");
        CompanyInfo.GET;
        QtyAvailToPromise(Item,CompanyInfo);

        OldAssemblyHeader := AssemblyHeader;
        IF OldAssemblyHeader.FIND THEN // Find previous quantity
          IF (OldAssemblyHeader."Document Type" = OldAssemblyHeader."Document Type"::Order) AND
             (OldAssemblyHeader."No." = "No.") AND
             (OldAssemblyHeader."Item No." = "Item No.") AND
             (OldAssemblyHeader."Variant Code" = "Variant Code") AND
             (OldAssemblyHeader."Location Code" = "Location Code") AND
             (OldAssemblyHeader."Bin Code" = "Bin Code")
          THEN BEGIN
            OldAssemblyHeader.CALCFIELDS("Reserved Qty. (Base)");
            SchedRcpt :=
              SchedRcpt - ConvertQty(OldAssemblyHeader."Remaining Quantity (Base)" - OldAssemblyHeader."Reserved Qty. (Base)");
          END;
      END;
      FetchCalculation2(InventoryQty2,GrossReq2,ReservedReq2,SchedRcpt2,ReservedRcpt2);
    END;

    [External]
    PROCEDURE FetchCalculation@16(VAR ItemNo2@1007 : Code[20];VAR UnitOfMeasureCode2@1006 : Code[10];VAR InventoryQty2@1005 : Decimal;VAR GrossReq2@1004 : Decimal;VAR ReservedReq2@1009 : Decimal;VAR SchedRcpt2@1003 : Decimal;VAR ReservedRcpt2@1010 : Decimal;VAR CurrentQuantity2@1002 : Decimal;VAR CurrentReservedQty2@1008 : Decimal;VAR TotalQuantity2@1001 : Decimal;VAR EarliestAvailDate2@1000 : Date);
    BEGIN
      ItemNo2 := ItemNo;
      UnitOfMeasureCode2 := UnitOfMeasureCode;
      FetchCalculation2(InventoryQty2,GrossReq2,ReservedReq2,SchedRcpt2,ReservedRcpt2);
      CurrentQuantity2 := -NewItemNetChange;
      CurrentReservedQty2 := -(NewItemNetResChange + OldItemNetResChange);
      TotalQuantity2 := InitialQtyAvailable + ItemNetChange;
      EarliestAvailDate2 := EarliestAvailDate;
    END;

    LOCAL PROCEDURE FetchCalculation2@25(VAR InventoryQty2@1002 : Decimal;VAR GrossReq2@1001 : Decimal;VAR ReservedReq2@1003 : Decimal;VAR SchedRcpt2@1000 : Decimal;VAR ReservedRcpt2@1004 : Decimal);
    BEGIN
      InventoryQty2 := InventoryQty;
      GrossReq2 := GrossReq;
      ReservedReq2 := ReservedReq;
      SchedRcpt2 := SchedRcpt;
      ReservedRcpt2 := ReservedRcpt;
    END;

    [External]
    PROCEDURE RaiseUpdateInterruptedError@20();
    BEGIN
      ERROR(Text000);
    END;

    LOCAL PROCEDURE ShowAndHandleAvailabilityPage@36(RecordId@1000 : RecordID) Rollback : Boolean;
    VAR
      ItemNo2@1008 : Code[20];
      UnitOfMeasureCode2@1007 : Code[10];
      InventoryQty2@1006 : Decimal;
      GrossReq2@1005 : Decimal;
      ReservedReq2@1010 : Decimal;
      SchedRcpt2@1004 : Decimal;
      ReservedRcpt2@1011 : Decimal;
      CurrentQuantity2@1003 : Decimal;
      CurrentReservedQty2@1009 : Decimal;
      TotalQuantity2@1002 : Decimal;
      EarliestAvailDate2@1001 : Date;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT(FALSE);

      FetchCalculation(
        ItemNo2,UnitOfMeasureCode2,InventoryQty2,
        GrossReq2,ReservedReq2,SchedRcpt2,ReservedRcpt2,
        CurrentQuantity2,CurrentReservedQty2,TotalQuantity2,EarliestAvailDate2);
      Rollback := CreateAndSendNotification(UnitOfMeasureCode2,InventoryQty2,
          GrossReq2,ReservedReq2,SchedRcpt2,ReservedRcpt2,
          CurrentQuantity2,CurrentReservedQty2,TotalQuantity2,EarliestAvailDate2,RecordId,ItemLocationCode);
    END;

    [External]
    PROCEDURE ShowNotificationDetails@34(AvailabilityCheckNotification@1000 : Notification);
    VAR
      ItemAvailabilityCheck@1001 : Page 1872;
    BEGIN
      ItemAvailabilityCheck.InitializeFromNotification(AvailabilityCheckNotification);
      ItemAvailabilityCheck.SetHeading(AvailabilityCheckNotification.MESSAGE);
      ItemAvailabilityCheck.RUNMODAL;
    END;

    LOCAL PROCEDURE CreateAndSendNotification@30(UnitOfMeasureCode@1009 : Code[20];InventoryQty@1008 : Decimal;GrossReq@1007 : Decimal;ReservedReq@1006 : Decimal;SchedRcpt@1005 : Decimal;ReservedRcpt@1004 : Decimal;CurrentQuantity@1003 : Decimal;CurrentReservedQty@1002 : Decimal;TotalQuantity@1001 : Decimal;EarliestAvailDate@1000 : Date;RecordId@1014 : RecordID;LocationCode@1012 : Code[10]) : Boolean;
    VAR
      ItemAvailabilityCheck@1011 : Page 1872;
      AvailabilityCheckNotification@1010 : Notification;
    BEGIN
      AvailabilityCheckNotification.ID(CREATEGUID);
      AvailabilityCheckNotification.MESSAGE(STRSUBSTNO(NotificationMsg,ItemNo));
      AvailabilityCheckNotification.SCOPE(NOTIFICATIONSCOPE::LocalScope);
      AvailabilityCheckNotification.ADDACTION(DetailsTxt,CODEUNIT::"Item-Check Avail.",'ShowNotificationDetails');
      ItemAvailabilityCheck.PopulateDataOnNotification(AvailabilityCheckNotification,ItemNo,UnitOfMeasureCode,
        InventoryQty,GrossReq,ReservedReq,SchedRcpt,ReservedRcpt,CurrentQuantity,CurrentReservedQty,
        TotalQuantity,EarliestAvailDate,LocationCode);
      NotificationLifecycleMgt.SendNotificationWithAdditionalContext(
        AvailabilityCheckNotification,RecordId,GetItemAvailabilityNotificationId);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE ShowWarningForThisItem@7(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      Item@1001 : Record 27;
      SalesSetup@1002 : Record 311;
    BEGIN
      IF NOT Item.GET(ItemNo) THEN
        EXIT(FALSE);

      IF Item.Type = Item.Type::Service THEN
        EXIT(FALSE);

      IF NOT IsItemAvailabilityNotificationEnabled(Item) THEN
        EXIT(FALSE);

      CASE Item."Stockout Warning" OF
        Item."Stockout Warning"::No:
          EXIT(FALSE);
        Item."Stockout Warning"::Yes:
          EXIT(TRUE);
        Item."Stockout Warning"::Default:
          BEGIN
            SalesSetup.GET;
            IF SalesSetup."Stockout Warning" THEN
              EXIT(TRUE);
            EXIT(FALSE);
          END;
      END;
    END;

    [External]
    PROCEDURE GetItemAvailabilityNotificationId@27() : GUID;
    BEGIN
      EXIT('2712AD06-C48B-4C20-820E-347A60C9AD00');
    END;

    LOCAL PROCEDURE IsItemAvailabilityNotificationEnabled@24(Item@1000 : Record 27) : Boolean;
    VAR
      MyNotifications@1001 : Record 1518;
    BEGIN
      EXIT(MyNotifications.IsEnabledForRecord(GetItemAvailabilityNotificationId,Item));
    END;

    [EventSubscriber(Page,1518,OnInitializingNotificationWithDefaultState)]
    LOCAL PROCEDURE OnInitializingNotificationWithDefaultState@29();
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      MyNotifications.InsertDefaultWithTableNum(GetItemAvailabilityNotificationId,
        ItemAvailabilityNotificationTxt,
        ItemAvailabilityNotificationDescriptionTxt,
        DATABASE::Item);
    END;

    BEGIN
    END.
  }
}

