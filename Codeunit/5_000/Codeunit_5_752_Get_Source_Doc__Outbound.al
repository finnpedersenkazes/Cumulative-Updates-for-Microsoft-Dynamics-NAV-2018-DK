OBJECT Codeunit 5752 Get Source Doc. Outbound
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text001@1000 : TextConst 'DAN=Hvis %1 er %2 i %3 nr. %4, skal alle tilknyttede linjer, hvor typen er %5, bruge den samme lokation.;ENU=If %1 is %2 in %3 no. %4, then all associated lines where type is %5 must use the same location.';
      Text002@1001 : TextConst 'DAN=Lagerleverancen kunne ikke oprettes, da feltet Afsendelsesadvis er angivet til Komplet, og varenr. %1 ikke er tilg�ngeligt i lokationskoden %2.\\Hvis du vil oprette lagerleverancen, skal du enten �ndre feltet Afsendelsesadvis til Delvis i %3 nr. %4 eller udfylde lagerleverencedokumentet manuelt.;ENU=The warehouse shipment was not created because the Shipping Advice field is set to Complete, and item no. %1 is not available in location code %2.\\You can create the warehouse shipment by either changing the Shipping Advice field to Partial in %3 no. %4 or by manually filling in the warehouse shipment document.';
      Text003@1002 : TextConst 'DAN=Lagerleverancen blev ikke oprettet, da der findes en �ben lagerleverance for Salgshoved, og Afsendelsesadvis er %1.\\Du kan tilf�je varen eller varerne som en eller flere nye linjer i den eksisterende lagerleverance eller �ndre Afsendelsesadvis til Delvis.;ENU=The warehouse shipment was not created because an open warehouse shipment exists for the Sales Header and Shipping Advice is %1.\\You must add the item(s) as new line(s) to the existing warehouse shipment or change Shipping Advice to Partial.';
      Text004@1003 : TextConst 'DAN=%1 blev ikke fundet. Lagerleverancen kunne ikke oprettes.;ENU=No %1 was found. The warehouse shipment could not be created.';
      GetSourceDocuments@1004 : Report 5753;

    LOCAL PROCEDURE CreateWhseShipmentHeaderFromWhseRequest@13(VAR WarehouseRequest@1000 : Record 5765) : Boolean;
    BEGIN
      IF WarehouseRequest.ISEMPTY THEN
        EXIT(FALSE);

      CLEAR(GetSourceDocuments);
      GetSourceDocuments.USEREQUESTPAGE(FALSE);
      GetSourceDocuments.SETTABLEVIEW(WarehouseRequest);
      GetSourceDocuments.SetHideDialog(TRUE);
      GetSourceDocuments.RUNMODAL;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetOutboundDocs@1(VAR WhseShptHeader@1003 : Record 7320);
    VAR
      WhseGetSourceFilterRec@1001 : Record 5771;
      WhseSourceFilterSelection@1002 : Page 5784;
    BEGIN
      WhseShptHeader.FIND;
      WhseSourceFilterSelection.SetOneCreatedShptHeader(WhseShptHeader);
      WhseGetSourceFilterRec.FILTERGROUP(2);
      WhseGetSourceFilterRec.SETRANGE(Type,WhseGetSourceFilterRec.Type::Outbound);
      WhseGetSourceFilterRec.FILTERGROUP(0);
      WhseSourceFilterSelection.SETTABLEVIEW(WhseGetSourceFilterRec);
      WhseSourceFilterSelection.RUNMODAL;

      WhseShptHeader."Document Status" := WhseShptHeader.GetDocumentStatus(0);
      WhseShptHeader.MODIFY;
    END;

    [External]
    PROCEDURE GetSingleOutboundDoc@2(VAR WhseShptHeader@1000 : Record 7320);
    VAR
      WhseRqst@1001 : Record 5765;
      SourceDocSelection@1003 : Page 5793;
    BEGIN
      CLEAR(GetSourceDocuments);
      WhseShptHeader.FIND;

      WhseRqst.FILTERGROUP(2);
      WhseRqst.SETRANGE(Type,WhseRqst.Type::Outbound);
      WhseRqst.SETRANGE("Location Code",WhseShptHeader."Location Code");
      WhseRqst.FILTERGROUP(0);
      WhseRqst.SETRANGE("Document Status",WhseRqst."Document Status"::Released);
      WhseRqst.SETRANGE("Completely Handled",FALSE);

      SourceDocSelection.LOOKUPMODE(TRUE);
      SourceDocSelection.SETTABLEVIEW(WhseRqst);
      IF SourceDocSelection.RUNMODAL <> ACTION::LookupOK THEN
        EXIT;
      SourceDocSelection.GetResult(WhseRqst);

      GetSourceDocuments.SetOneCreatedShptHeader(WhseShptHeader);
      GetSourceDocuments.SetSkipBlocked(TRUE);
      GetSourceDocuments.USEREQUESTPAGE(FALSE);
      WhseRqst.SETRANGE("Location Code",WhseShptHeader."Location Code");
      GetSourceDocuments.SETTABLEVIEW(WhseRqst);
      GetSourceDocuments.RUNMODAL;

      WhseShptHeader."Document Status" :=
        WhseShptHeader.GetDocumentStatus(0);
      WhseShptHeader.MODIFY;
    END;

    [Internal]
    PROCEDURE CreateFromSalesOrder@3(SalesHeader@1000 : Record 36);
    BEGIN
      ShowResult(CreateFromSalesOrderHideDialog(SalesHeader));
    END;

    [Internal]
    PROCEDURE CreateFromSalesOrderHideDialog@15(SalesHeader@1000 : Record 36) : Boolean;
    VAR
      WhseRqst@1001 : Record 5765;
    BEGIN
      IF NOT SalesHeader.IsApprovedForPosting THEN
        EXIT(FALSE);

      FindWarehouseRequestForSalesOrder(WhseRqst,SalesHeader);

      IF WhseRqst.ISEMPTY THEN
        EXIT(FALSE);

      CreateWhseShipmentHeaderFromWhseRequest(WhseRqst);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreateFromPurchaseReturnOrder@6(PurchHeader@1000 : Record 38);
    BEGIN
      ShowResult(CreateFromPurchReturnOrderHideDialog(PurchHeader));
    END;

    [External]
    PROCEDURE CreateFromPurchReturnOrderHideDialog@20(PurchHeader@1000 : Record 38) : Boolean;
    VAR
      WhseRqst@1001 : Record 5765;
    BEGIN
      FindWarehouseRequestForPurchReturnOrder(WhseRqst,PurchHeader);
      EXIT(CreateWhseShipmentHeaderFromWhseRequest(WhseRqst));
    END;

    [External]
    PROCEDURE CreateFromOutbndTransferOrder@4(TransHeader@1000 : Record 5740);
    BEGIN
      ShowResult(CreateFromOutbndTransferOrderHideDialog(TransHeader));
    END;

    [External]
    PROCEDURE CreateFromOutbndTransferOrderHideDialog@23(TransHeader@1000 : Record 5740) : Boolean;
    VAR
      WhseRqst@1001 : Record 5765;
    BEGIN
      FindWarehouseRequestForOutbndTransferOrder(WhseRqst,TransHeader);
      EXIT(CreateWhseShipmentHeaderFromWhseRequest(WhseRqst));
    END;

    [External]
    PROCEDURE CreateFromServiceOrder@10(ServiceHeader@1000 : Record 5900);
    BEGIN
      ShowResult(CreateFromServiceOrderHideDialog(ServiceHeader));
    END;

    [External]
    PROCEDURE CreateFromServiceOrderHideDialog@26(ServiceHeader@1000 : Record 5900) : Boolean;
    VAR
      WhseRqst@1001 : Record 5765;
    BEGIN
      FindWarehouseRequestForServiceOrder(WhseRqst,ServiceHeader);
      EXIT(CreateWhseShipmentHeaderFromWhseRequest(WhseRqst));
    END;

    [External]
    PROCEDURE GetSingleWhsePickDoc@5(CurrentWhseWkshTemplate@1008 : Code[10];CurrentWhseWkshName@1004 : Code[10];LocationCode@1000 : Code[10]);
    VAR
      PickWkshName@1005 : Record 7327;
      WhsePickRqst@1001 : Record 7325;
      GetWhseSourceDocuments@1007 : Report 7304;
      WhsePickDocSelection@1003 : Page 7343;
    BEGIN
      PickWkshName.GET(CurrentWhseWkshTemplate,CurrentWhseWkshName,LocationCode);

      WhsePickRqst.FILTERGROUP(2);
      WhsePickRqst.SETRANGE(Status,WhsePickRqst.Status::Released);
      WhsePickRqst.SETRANGE("Completely Picked",FALSE);
      WhsePickRqst.SETRANGE("Location Code",LocationCode);
      WhsePickRqst.FILTERGROUP(0);

      WhsePickDocSelection.LOOKUPMODE(TRUE);
      WhsePickDocSelection.SETTABLEVIEW(WhsePickRqst);
      IF WhsePickDocSelection.RUNMODAL <> ACTION::LookupOK THEN
        EXIT;
      WhsePickDocSelection.GetResult(WhsePickRqst);

      GetWhseSourceDocuments.SetPickWkshName(
        CurrentWhseWkshTemplate,CurrentWhseWkshName,LocationCode);
      GetWhseSourceDocuments.USEREQUESTPAGE(FALSE);
      GetWhseSourceDocuments.SETTABLEVIEW(WhsePickRqst);
      GetWhseSourceDocuments.RUNMODAL;
    END;

    [External]
    PROCEDURE CheckSalesHeader@7(SalesHeader@1000 : Record 36;ShowError@1001 : Boolean) : Boolean;
    VAR
      SalesLine@1002 : Record 37;
      CurrItemVariant@1010 : Record 5401;
      SalesOrder@1004 : Page 42;
      QtyOutstandingBase@1006 : Decimal;
      RecordNo@1007 : Integer;
      TotalNoOfRecords@1008 : Integer;
      LocationCode@1005 : Code[10];
    BEGIN
      WITH SalesHeader DO BEGIN
        IF NOT ("Shipping Advice" = "Shipping Advice"::Complete) THEN
          EXIT(FALSE);

        SalesLine.SETCURRENTKEY("Document Type",Type,"No.","Variant Code");
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.SETRANGE(Type,SalesLine.Type::Item);
        IF SalesLine.FINDSET THEN
          REPEAT
            IF NOT SalesLine.IsServiceItem THEN
              SalesLine.MARK(TRUE);
          UNTIL SalesLine.NEXT = 0;
        SalesLine.MARKEDONLY(TRUE);

        IF SalesLine.FINDSET THEN BEGIN
          LocationCode := SalesLine."Location Code";
          SetItemVariant(CurrItemVariant,SalesLine."No.",SalesLine."Variant Code");
          TotalNoOfRecords := SalesLine.COUNT;
          REPEAT
            RecordNo += 1;

            IF SalesLine."Location Code" <> LocationCode THEN BEGIN
              IF ShowError THEN
                ERROR(Text001,FIELDCAPTION("Shipping Advice"),"Shipping Advice",
                  SalesOrder.CAPTION,"No.",SalesLine.Type);
              EXIT(TRUE);
            END;

            IF EqualItemVariant(CurrItemVariant,SalesLine."No.",SalesLine."Variant Code") THEN
              QtyOutstandingBase += SalesLine."Outstanding Qty. (Base)"
            ELSE BEGIN
              IF CheckAvailability(
                   CurrItemVariant,QtyOutstandingBase,SalesLine."Location Code",
                   SalesOrder.CAPTION,DATABASE::"Sales Line","Document Type","No.",ShowError)
              THEN
                EXIT(TRUE);
              SetItemVariant(CurrItemVariant,SalesLine."No.",SalesLine."Variant Code");
              QtyOutstandingBase := SalesLine."Outstanding Qty. (Base)";
            END;
            IF RecordNo = TotalNoOfRecords THEN BEGIN // last record
              IF CheckAvailability(
                   CurrItemVariant,QtyOutstandingBase,SalesLine."Location Code",
                   SalesOrder.CAPTION,DATABASE::"Sales Line","Document Type","No.",ShowError)
              THEN
                EXIT(TRUE);
            END;
          UNTIL SalesLine.NEXT = 0; // sorted by item
        END;
      END;
    END;

    [External]
    PROCEDURE CheckTransferHeader@8(TransferHeader@1000 : Record 5740;ShowError@1001 : Boolean) : Boolean;
    VAR
      TransferLine@1002 : Record 5741;
      CurrItemVariant@1009 : Record 5401;
      TransferOrder@1003 : Page 5740;
      QtyOutstandingBase@1005 : Decimal;
      RecordNo@1006 : Integer;
      TotalNoOfRecords@1007 : Integer;
    BEGIN
      WITH TransferHeader DO BEGIN
        IF NOT ("Shipping Advice" = "Shipping Advice"::Complete) THEN
          EXIT(FALSE);

        TransferLine.SETCURRENTKEY("Item No.");
        TransferLine.SETRANGE("Document No.","No.");
        IF TransferLine.FINDSET THEN BEGIN
          SetItemVariant(CurrItemVariant,TransferLine."Item No.",TransferLine."Variant Code");
          TotalNoOfRecords := TransferLine.COUNT;
          REPEAT
            RecordNo += 1;
            IF EqualItemVariant(CurrItemVariant,TransferLine."Item No.",TransferLine."Variant Code") THEN
              QtyOutstandingBase += TransferLine."Outstanding Qty. (Base)"
            ELSE BEGIN
              IF CheckAvailability(
                   CurrItemVariant,QtyOutstandingBase,TransferLine."Transfer-from Code",
                   TransferOrder.CAPTION,DATABASE::"Transfer Line",0,"No.",ShowError)
              THEN // outbound
                EXIT(TRUE);
              SetItemVariant(CurrItemVariant,TransferLine."Item No.",TransferLine."Variant Code");
              QtyOutstandingBase := TransferLine."Outstanding Qty. (Base)";
            END;
            IF RecordNo = TotalNoOfRecords THEN BEGIN // last record
              IF CheckAvailability(
                   CurrItemVariant,QtyOutstandingBase,TransferLine."Transfer-from Code",
                   TransferOrder.CAPTION,DATABASE::"Transfer Line",0,"No.",ShowError)
              THEN // outbound
                EXIT(TRUE);
            END;
          UNTIL TransferLine.NEXT = 0; // sorted by item
        END;
      END;
    END;

    LOCAL PROCEDURE CheckAvailability@9(CurrItemVariant@1013 : Record 5401;QtyBaseNeeded@1001 : Decimal;LocationCode@1011 : Code[10];FormCaption@1002 : Text[1024];SourceType@1003 : Integer;SourceSubType@1004 : Integer;SourceID@1005 : Code[20];ShowError@1006 : Boolean) : Boolean;
    VAR
      Item@1007 : Record 27;
      ReservEntry@1008 : Record 337;
      ReservEntry2@1009 : Record 337;
      QtyReservedForOrder@1010 : Decimal;
    BEGIN
      WITH Item DO BEGIN
        GET(CurrItemVariant."Item No.");
        SETRANGE("Location Filter",LocationCode);
        SETRANGE("Variant Filter",CurrItemVariant.Code);
        CALCFIELDS(Inventory,"Reserved Qty. on Inventory");

        // find qty reserved for this order
        ReservEntry.SetSourceFilter(SourceType,SourceSubType,SourceID,-1,TRUE);
        ReservEntry.SETRANGE("Item No.",CurrItemVariant."Item No.");
        ReservEntry.SETRANGE("Location Code",LocationCode);
        ReservEntry.SETRANGE("Variant Code",CurrItemVariant.Code);
        ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Reservation);
        IF ReservEntry.FINDSET THEN
          REPEAT
            ReservEntry2.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive);
            QtyReservedForOrder += ReservEntry2."Quantity (Base)";
          UNTIL ReservEntry.NEXT = 0;

        IF Inventory - ("Reserved Qty. on Inventory" - QtyReservedForOrder) < QtyBaseNeeded THEN BEGIN
          IF ShowError THEN
            ERROR(Text002,CurrItemVariant."Item No.",LocationCode,FormCaption,SourceID);
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE OpenWarehouseShipmentPage@14();
    VAR
      WarehouseShipmentHeader@1000 : Record 7320;
    BEGIN
      GetSourceDocuments.GetLastShptHeader(WarehouseShipmentHeader);
      PAGE.RUN(PAGE::"Warehouse Shipment",WarehouseShipmentHeader);
    END;

    LOCAL PROCEDURE GetRequireShipRqst@11(VAR WhseRqst@1000 : Record 5765);
    VAR
      Location@1001 : Record 14;
      LocationCode@1002 : Text;
    BEGIN
      IF WhseRqst.FINDSET THEN BEGIN
        REPEAT
          IF Location.RequireShipment(WhseRqst."Location Code") THEN
            LocationCode += WhseRqst."Location Code" + '|';
        UNTIL WhseRqst.NEXT = 0;
        IF LocationCode <> '' THEN BEGIN
          LocationCode := COPYSTR(LocationCode,1,STRLEN(LocationCode) - 1);
          IF LocationCode[1] = '|' THEN
            LocationCode := '''''' + LocationCode;
        END;
        WhseRqst.SETFILTER("Location Code",LocationCode);
      END;
    END;

    LOCAL PROCEDURE SetItemVariant@12(VAR CurrItemVariant@1000 : Record 5401;ItemNo@1001 : Code[20];VariantCode@1002 : Code[10]);
    BEGIN
      CurrItemVariant."Item No." := ItemNo;
      CurrItemVariant.Code := VariantCode;
    END;

    LOCAL PROCEDURE EqualItemVariant@16(CurrItemVariant@1002 : Record 5401;ItemNo@1001 : Code[20];VariantCode@1000 : Code[10]) : Boolean;
    BEGIN
      EXIT((CurrItemVariant."Item No." = ItemNo) AND (CurrItemVariant.Code = VariantCode));
    END;

    LOCAL PROCEDURE FindWarehouseRequestForSalesOrder@17(VAR WhseRqst@1000 : Record 5765;SalesHeader@1001 : Record 36);
    BEGIN
      WITH SalesHeader DO BEGIN
        TESTFIELD(Status,Status::Released);
        IF WhseShpmntConflict("Document Type","No.","Shipping Advice") THEN
          ERROR(Text003,FORMAT("Shipping Advice"));
        CheckSalesHeader(SalesHeader,TRUE);
        WhseRqst.SETRANGE(Type,WhseRqst.Type::Outbound);
        WhseRqst.SetSourceFilter(DATABASE::"Sales Line","Document Type","No.");
        WhseRqst.SETRANGE("Document Status",WhseRqst."Document Status"::Released);
        GetRequireShipRqst(WhseRqst);
      END;
    END;

    LOCAL PROCEDURE FindWarehouseRequestForPurchReturnOrder@19(VAR WhseRqst@1001 : Record 5765;PurchHeader@1000 : Record 38);
    BEGIN
      WITH PurchHeader DO BEGIN
        TESTFIELD(Status,Status::Released);
        WhseRqst.SETRANGE(Type,WhseRqst.Type::Outbound);
        WhseRqst.SetSourceFilter(DATABASE::"Purchase Line","Document Type","No.");
        WhseRqst.SETRANGE("Document Status",WhseRqst."Document Status"::Released);
        GetRequireShipRqst(WhseRqst);
      END;
    END;

    LOCAL PROCEDURE FindWarehouseRequestForOutbndTransferOrder@22(VAR WhseRqst@1000 : Record 5765;TransHeader@1001 : Record 5740);
    BEGIN
      WITH TransHeader DO BEGIN
        TESTFIELD(Status,Status::Released);
        CheckTransferHeader(TransHeader,TRUE);
        WhseRqst.SETRANGE(Type,WhseRqst.Type::Outbound);
        WhseRqst.SetSourceFilter(DATABASE::"Transfer Line",0,"No.");
        WhseRqst.SETRANGE("Document Status",WhseRqst."Document Status"::Released);
        GetRequireShipRqst(WhseRqst);
      END;
    END;

    LOCAL PROCEDURE FindWarehouseRequestForServiceOrder@27(VAR WhseRqst@1000 : Record 5765;ServiceHeader@1001 : Record 5900);
    BEGIN
      WITH ServiceHeader DO BEGIN
        TESTFIELD("Release Status","Release Status"::"Released to Ship");
        WhseRqst.SETRANGE(Type,WhseRqst.Type::Outbound);
        WhseRqst.SetSourceFilter(DATABASE::"Service Line","Document Type","No.");
        WhseRqst.SETRANGE("Document Status",WhseRqst."Document Status"::Released);
        GetRequireShipRqst(WhseRqst);
      END;
    END;

    LOCAL PROCEDURE ShowResult@30(WhseShipmentCreated@1000 : Boolean);
    VAR
      WarehouseRequest@1001 : Record 5765;
    BEGIN
      IF WhseShipmentCreated THEN BEGIN
        GetSourceDocuments.ShowShipmentDialog;
        OpenWarehouseShipmentPage;
      END ELSE
        MESSAGE(Text004,WarehouseRequest.TABLECAPTION);
    END;

    BEGIN
    END.
  }
}

