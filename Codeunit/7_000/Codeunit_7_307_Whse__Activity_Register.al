OBJECT Codeunit 7307 Whse.-Activity-Register
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    TableNo=5767;
    Permissions=TableData 5772=i,
                TableData 5773=i,
                TableData 6550=rim,
                TableData 7310=imd,
                TableData 7318=m,
                TableData 7319=m,
                TableData 7344=i,
                TableData 7345=i;
    OnRun=BEGIN
            WhseActivLine.COPY(Rec);
            WhseActivLine.SETAUTOCALCFIELDS;
            Code;
            Rec := WhseActivLine;
          END;

  }
  CODE
  {
    VAR
      Text000@1001 : TextConst 'DAN=Lageraktivitet        #1##########\\;ENU=Warehouse Activity    #1##########\\';
      Text001@1002 : TextConst 'DAN=Linjerne kontrolleres #2######\;ENU=Checking lines        #2######\';
      Text002@1005 : TextConst 'DAN=Linjerne registreres  #3###### @4@@@@@@@@@@@@@;ENU=Registering lines     #3###### @4@@@@@@@@@@@@@';
      Location@1006 : Record 14;
      Item@1029 : Record 27;
      WhseActivHeader@1000 : Record 5766;
      WhseActivLine@1010 : Record 5767;
      RegisteredWhseActivHeader@1008 : Record 5772;
      RegisteredWhseActivLine@1009 : Record 5773;
      RegisteredInvtMovementHdr@1031 : Record 7344;
      RegisteredInvtMovementLine@1032 : Record 7345;
      WhseShptHeader@1015 : Record 7320;
      PostedWhseRcptHeader@1014 : Record 7318;
      WhseInternalPickHeader@1017 : Record 7333;
      WhseInternalPutAwayHeader@1021 : Record 7331;
      WhseShptLine@1011 : Record 7321;
      PostedWhseRcptLine@1013 : Record 7319;
      WhseInternalPickLine@1018 : Record 7334;
      WhseInternalPutAwayLine@1022 : Record 7332;
      ProdCompLine@1019 : Record 5407;
      AssemblyLine@1033 : Record 901;
      ProdOrder@1020 : Record 5405;
      AssemblyHeader@1037 : Record 900;
      ItemUnitOfMeasure@1004 : Record 5404;
      TempBinContentBuffer@1016 : TEMPORARY Record 7330;
      SourceCodeSetup@1007 : Record 242;
      Cust@1026 : Record 18;
      TempTrackingSpecification@1030 : TEMPORARY Record 336;
      ItemTrackingMgt@1023 : Codeunit 6500;
      WhseJnlRegisterLine@1012 : Codeunit 7301;
      NoSeriesMgt@1025 : Codeunit 396;
      Window@1027 : Dialog;
      NoOfRecords@1034 : Integer;
      LineCount@1035 : Integer;
      HideDialog@1036 : Boolean;
      Text003@1003 : TextConst 'DAN=Der er intet at registrere.;ENU=There is nothing to register.';
      Text004@1024 : TextConst 'DAN=Den varesporing, der er angivet for kildelinjen, bel�ber sig til mere end den m�ngde, du har angivet.\Du skal regulere den eksisterende varesporing og derefter indtaste den nye m�ngde igen.;ENU=Item tracking defined for the source line accounts for more than the quantity you have entered.\You must adjust the existing item tracking and then reenter the new quantity.';
      Text005@1028 : TextConst 'DAN=%1 %2 er ikke disponibel p� lager eller er allerede reserveret til et andet dokument.;ENU=%1 %2 is not available on inventory or it has already been reserved for another document.';

    LOCAL PROCEDURE Code@3();
    VAR
      OldWhseActivLine@1000 : Record 5767;
      TempWhseActivLineToReserve@1004 : TEMPORARY Record 5767;
      QtyDiff@1002 : Decimal;
      QtyBaseDiff@1003 : Decimal;
      LastLine@1001 : Boolean;
    BEGIN
      WITH WhseActivHeader DO BEGIN
        WhseActivLine.SETRANGE("Activity Type",WhseActivLine."Activity Type");
        WhseActivLine.SETRANGE("No.",WhseActivLine."No.");
        WhseActivLine.SETFILTER("Qty. to Handle (Base)",'<>0');
        IF WhseActivLine.ISEMPTY THEN
          ERROR(Text003);
        CheckWhseItemTrkgLine(WhseActivLine);

        GET(WhseActivLine."Activity Type",WhseActivLine."No.");
        LocationGet("Location Code");

        UpdateWindow(1,"No.");

        // Check Lines
        CheckLines;

        // Register lines
        SourceCodeSetup.GET;
        LineCount := 0;
        WhseActivLine.LOCKTABLE;
        IF WhseActivLine.FIND('-') THEN BEGIN
          CreateRegActivHeader(WhseActivHeader);
          REPEAT
            LineCount := LineCount + 1;
            UpdateWindow(3,'');
            UpdateWindow(4,'');
            IF Location."Bin Mandatory" THEN
              RegisterWhseJnlLine(WhseActivLine);
            CreateRegActivLine(WhseActivLine);
            OnAfterCreateRegActivLine(WhseActivLine,RegisteredWhseActivLine,RegisteredInvtMovementLine);
          UNTIL WhseActivLine.NEXT = 0;
        END;

        TempWhseActivLineToReserve.DELETEALL;
        WhseActivLine.SETCURRENTKEY(
          "Activity Type","No.","Whse. Document Type","Whse. Document No.");
        IF WhseActivLine.FIND('-') THEN
          REPEAT
            CopyWhseActivityLineToReservBuf(TempWhseActivLineToReserve,WhseActivLine);

            IF Type <> Type::Movement THEN
              UpdateWhseSourceDocLine(WhseActivLine);
            IF WhseActivLine."Qty. Outstanding" = WhseActivLine."Qty. to Handle" THEN BEGIN
              OnBeforeWhseActivLineDelete(WhseActivLine);
              WhseActivLine.DELETE
            END ELSE BEGIN
              QtyDiff := WhseActivLine."Qty. Outstanding" - WhseActivLine."Qty. to Handle";
              QtyBaseDiff := WhseActivLine."Qty. Outstanding (Base)" - WhseActivLine."Qty. to Handle (Base)";
              WhseActivLine.VALIDATE("Qty. Outstanding",QtyDiff);
              IF WhseActivLine."Qty. Outstanding (Base)" > QtyBaseDiff THEN // round off error- qty same, not base qty
                WhseActivLine."Qty. Outstanding (Base)" := QtyBaseDiff;
              WhseActivLine.VALIDATE("Qty. to Handle",QtyDiff);
              IF WhseActivLine."Qty. to Handle (Base)" > QtyBaseDiff THEN // round off error- qty same, not base qty
                WhseActivLine."Qty. to Handle (Base)" := QtyBaseDiff;
              IF HideDialog THEN
                WhseActivLine.VALIDATE("Qty. to Handle",0);
              WhseActivLine.VALIDATE(
                "Qty. Handled",WhseActivLine.Quantity - WhseActivLine."Qty. Outstanding");
              WhseActivLine.MODIFY;
            END;

            OldWhseActivLine := WhseActivLine;
            LastLine := WhseActivLine.NEXT = 0;

            IF LastLine OR
               (OldWhseActivLine."Whse. Document Type" <> WhseActivLine."Whse. Document Type") OR
               (OldWhseActivLine."Whse. Document No." <> WhseActivLine."Whse. Document No.") OR
               (OldWhseActivLine."Action Type" <> WhseActivLine."Action Type")
            THEN
              UpdateWhseDocHeader(OldWhseActivLine);

            OldWhseActivLine.DeleteBinContent(OldWhseActivLine."Action Type"::Take);
          UNTIL LastLine;
        ItemTrackingMgt.SetPick(OldWhseActivLine."Activity Type" = OldWhseActivLine."Activity Type"::Pick);
        ItemTrackingMgt.SynchronizeWhseItemTracking(TempTrackingSpecification,RegisteredWhseActivLine."No.",FALSE);
        AutoReserveForSalesLine(TempWhseActivLineToReserve);

        IF Location."Bin Mandatory" THEN BEGIN
          LineCount := 0;
          CLEAR(OldWhseActivLine);
          WhseActivLine.RESET;
          WhseActivLine.SETCURRENTKEY(
            "Activity Type","No.","Whse. Document Type","Whse. Document No.");
          WhseActivLine.SETRANGE("Activity Type",Type);
          WhseActivLine.SETRANGE("No.","No.");
          IF WhseActivLine.FIND('-') THEN
            REPEAT
              IF ((LineCount = 1) AND
                  ((OldWhseActivLine."Whse. Document Type" <> WhseActivLine."Whse. Document Type") OR
                   (OldWhseActivLine."Whse. Document No." <> WhseActivLine."Whse. Document No.")))
              THEN BEGIN
                LineCount := 0;
                OldWhseActivLine.DELETE;
              END;
              OldWhseActivLine := WhseActivLine;
              LineCount := LineCount + 1;
            UNTIL WhseActivLine.NEXT = 0;
          IF LineCount = 1 THEN
            OldWhseActivLine.DELETE;
        END;
        WhseActivLine.RESET;
        WhseActivLine.SETRANGE("Activity Type",Type);
        WhseActivLine.SETRANGE("No.","No.");
        WhseActivLine.SETFILTER("Qty. Outstanding",'<>%1',0);
        IF NOT WhseActivLine.FIND('-') THEN
          DELETE(TRUE)
        ELSE BEGIN
          "Last Registering No." := "Registering No.";
          "Registering No." := '';
          MODIFY;
          IF NOT HideDialog THEN
            WhseActivLine.AutofillQtyToHandle(WhseActivLine);
          OnAfterAutofillQtyToHandle(WhseActivLine);
        END;
        IF NOT HideDialog THEN
          Window.CLOSE;
        COMMIT;
        CLEAR(WhseJnlRegisterLine);
      END;
    END;

    LOCAL PROCEDURE RegisterWhseJnlLine@5(WhseActivLine@1000 : Record 5767);
    VAR
      WhseJnlLine@1001 : Record 7311;
      WMSMgt@1002 : Codeunit 7302;
    BEGIN
      WITH WhseActivLine DO BEGIN
        WhseJnlLine.INIT;
        WhseJnlLine."Location Code" := "Location Code";
        WhseJnlLine."Item No." := "Item No.";
        WhseJnlLine."Registering Date" := WORKDATE;
        WhseJnlLine."User ID" := USERID;
        WhseJnlLine."Variant Code" := "Variant Code";
        WhseJnlLine."Entry Type" := WhseJnlLine."Entry Type"::Movement;
        IF "Action Type" = "Action Type"::Take THEN BEGIN
          WhseJnlLine."From Zone Code" := "Zone Code";
          WhseJnlLine."From Bin Code" := "Bin Code";
        END ELSE BEGIN
          WhseJnlLine."To Zone Code" := "Zone Code";
          WhseJnlLine."To Bin Code" := "Bin Code";
        END;
        WhseJnlLine.Description := Description;

        LocationGet("Location Code");
        IF Location."Directed Put-away and Pick" THEN BEGIN
          WhseJnlLine.Quantity := "Qty. to Handle";
          WhseJnlLine."Unit of Measure Code" := "Unit of Measure Code";
          WhseJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          GetItemUnitOfMeasure2("Item No.","Unit of Measure Code");
          WhseJnlLine.Cubage :=
            ABS(WhseJnlLine.Quantity) * ItemUnitOfMeasure.Cubage;
          WhseJnlLine.Weight :=
            ABS(WhseJnlLine.Quantity) * ItemUnitOfMeasure.Weight;
        END ELSE BEGIN
          WhseJnlLine.Quantity := "Qty. to Handle (Base)";
          WhseJnlLine."Unit of Measure Code" := WMSMgt.GetBaseUOM("Item No.");
          WhseJnlLine."Qty. per Unit of Measure" := 1;
        END;
        WhseJnlLine."Qty. (Base)" := "Qty. to Handle (Base)";
        WhseJnlLine."Qty. (Absolute)" := WhseJnlLine.Quantity;
        WhseJnlLine."Qty. (Absolute, Base)" := "Qty. to Handle (Base)";

        WhseJnlLine.SetSource("Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
        WhseJnlLine."Source Document" := "Source Document";
        WhseJnlLine."Reference No." := RegisteredWhseActivHeader."No.";
        CASE "Activity Type" OF
          "Activity Type"::"Put-away":
            BEGIN
              WhseJnlLine."Source Code" := SourceCodeSetup."Whse. Put-away";
              WhseJnlLine.SetWhseDoc("Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
              WhseJnlLine."Reference Document" := WhseJnlLine."Reference Document"::"Put-away";
            END;
          "Activity Type"::Pick:
            BEGIN
              WhseJnlLine."Source Code" := SourceCodeSetup."Whse. Pick";
              WhseJnlLine.SetWhseDoc("Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
              WhseJnlLine."Reference Document" := WhseJnlLine."Reference Document"::Pick;
            END;
          "Activity Type"::Movement:
            BEGIN
              WhseJnlLine."Source Code" := SourceCodeSetup."Whse. Movement";
              WhseJnlLine."Whse. Document Type" := WhseJnlLine."Whse. Document Type"::" ";
              WhseJnlLine."Reference Document" := WhseJnlLine."Reference Document"::Movement;
            END;
          "Activity Type"::"Invt. Put-away",
          "Activity Type"::"Invt. Pick",
          "Activity Type"::"Invt. Movement":
            WhseJnlLine."Whse. Document Type" := WhseJnlLine."Whse. Document Type"::" ";
        END;
        IF "Serial No." <> '' THEN
          TESTFIELD("Qty. per Unit of Measure",1);
        WhseJnlLine.SetTracking("Serial No.","Lot No.","Warranty Date","Expiration Date");
        WhseJnlRegisterLine.RUN(WhseJnlLine);
      END;
    END;

    LOCAL PROCEDURE CreateRegActivHeader@2(WhseActivHeader@1000 : Record 5766);
    VAR
      WhseCommentLine@1001 : Record 5770;
      WhseCommentLine2@1002 : Record 5770;
      TableNameFrom@1003 : Option;
      TableNameTo@1004 : Option;
      RegisteredType@1005 : Option;
      RegisteredNo@1006 : Code[20];
    BEGIN
      TableNameFrom := WhseCommentLine."Table Name"::"Whse. Activity Header";
      IF WhseActivHeader.Type = WhseActivHeader.Type::"Invt. Movement" THEN BEGIN
        RegisteredInvtMovementHdr.INIT;
        RegisteredInvtMovementHdr.TRANSFERFIELDS(WhseActivHeader);
        RegisteredInvtMovementHdr."No." := WhseActivHeader."Registering No.";
        RegisteredInvtMovementHdr."Invt. Movement No." := WhseActivHeader."No.";
        RegisteredInvtMovementHdr.INSERT;

        TableNameTo := WhseCommentLine."Table Name"::"Registered Invt. Movement";
        RegisteredType := 0;
        RegisteredNo := RegisteredInvtMovementHdr."No.";
      END ELSE BEGIN
        RegisteredWhseActivHeader.INIT;
        RegisteredWhseActivHeader.TRANSFERFIELDS(WhseActivHeader);
        RegisteredWhseActivHeader.Type := WhseActivHeader.Type;
        RegisteredWhseActivHeader."No." := WhseActivHeader."Registering No.";
        RegisteredWhseActivHeader."Whse. Activity No." := WhseActivHeader."No.";
        RegisteredWhseActivHeader."Registering Date" := WORKDATE;
        RegisteredWhseActivHeader."No. Series" := WhseActivHeader."Registering No. Series";
        RegisteredWhseActivHeader.INSERT;

        TableNameTo := WhseCommentLine2."Table Name"::"Rgstrd. Whse. Activity Header";
        RegisteredType := RegisteredWhseActivHeader.Type;
        RegisteredNo := RegisteredWhseActivHeader."No.";
      END;

      WhseCommentLine.SETRANGE("Table Name",TableNameFrom);
      WhseCommentLine.SETRANGE(Type,WhseActivHeader.Type);
      WhseCommentLine.SETRANGE("No.",WhseActivHeader."No.");
      WhseCommentLine.LOCKTABLE;

      IF WhseCommentLine.FIND('-') THEN
        REPEAT
          WhseCommentLine2.INIT;
          WhseCommentLine2 := WhseCommentLine;
          WhseCommentLine2."Table Name" := TableNameTo;
          WhseCommentLine2.Type := RegisteredType;
          WhseCommentLine2."No." := RegisteredNo;
          WhseCommentLine2.INSERT;
        UNTIL WhseCommentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateRegActivLine@6(WhseActivLine@1000 : Record 5767);
    BEGIN
      IF WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::"Invt. Movement" THEN BEGIN
        RegisteredInvtMovementLine.INIT;
        RegisteredInvtMovementLine.TRANSFERFIELDS(WhseActivLine);
        RegisteredInvtMovementLine."No." := RegisteredInvtMovementHdr."No.";
        RegisteredInvtMovementLine.VALIDATE(Quantity,WhseActivLine."Qty. to Handle");
        RegisteredInvtMovementLine.INSERT;
      END ELSE BEGIN
        RegisteredWhseActivLine.INIT;
        RegisteredWhseActivLine.TRANSFERFIELDS(WhseActivLine);
        RegisteredWhseActivLine."Activity Type" := RegisteredWhseActivHeader.Type;
        RegisteredWhseActivLine."No." := RegisteredWhseActivHeader."No.";
        RegisteredWhseActivLine.Quantity := WhseActivLine."Qty. to Handle";
        RegisteredWhseActivLine."Qty. (Base)" := WhseActivLine."Qty. to Handle (Base)";
        RegisteredWhseActivLine.INSERT;
      END;
    END;

    LOCAL PROCEDURE UpdateWhseSourceDocLine@11(WhseActivLine@1000 : Record 5767);
    VAR
      WhseDocType2@1001 : Option;
    BEGIN
      WITH WhseActivLine DO BEGIN
        IF "Original Breakbulk" THEN
          EXIT;
        IF ("Whse. Document Type" = "Whse. Document Type"::Shipment) AND "Assemble to Order" THEN
          WhseDocType2 := "Whse. Document Type"::Assembly
        ELSE
          WhseDocType2 := "Whse. Document Type";
        CASE WhseDocType2 OF
          "Whse. Document Type"::Shipment:
            IF ("Action Type" <> "Action Type"::Take) AND ("Breakbulk No." = 0) THEN BEGIN
              UpdateWhseShptLine(
                "Whse. Document No.","Whse. Document Line No.",
                "Qty. to Handle","Qty. to Handle (Base)","Qty. per Unit of Measure");
              RegisterWhseItemTrkgLine(WhseActivLine);
            END;
          "Whse. Document Type"::"Internal Pick":
            IF ("Action Type" <> "Action Type"::Take) AND ("Breakbulk No." = 0) THEN BEGIN
              UpdateWhseIntPickLine(
                "Whse. Document No.","Whse. Document Line No.",
                "Qty. to Handle","Qty. to Handle (Base)","Qty. per Unit of Measure");
              RegisterWhseItemTrkgLine(WhseActivLine);
            END;
          "Whse. Document Type"::Production:
            IF ("Action Type" <> "Action Type"::Take) AND ("Breakbulk No." = 0) THEN BEGIN
              UpdateProdCompLine(
                "Source Subtype","Source No.","Source Line No.","Source Subline No.",
                "Qty. to Handle","Qty. to Handle (Base)","Qty. per Unit of Measure");
              RegisterWhseItemTrkgLine(WhseActivLine);
            END;
          "Whse. Document Type"::Assembly:
            IF ("Action Type" <> "Action Type"::Take) AND ("Breakbulk No." = 0) THEN BEGIN
              UpdateAssemblyLine(
                "Source Subtype","Source No.","Source Line No.",
                "Qty. to Handle","Qty. to Handle (Base)","Qty. per Unit of Measure");
              RegisterWhseItemTrkgLine(WhseActivLine);
            END;
          "Whse. Document Type"::Receipt:
            IF "Action Type" <> "Action Type"::Place THEN BEGIN
              UpdatePostedWhseRcptLine(
                "Whse. Document No.","Whse. Document Line No.",
                "Qty. to Handle","Qty. to Handle (Base)","Qty. per Unit of Measure");
              RegisterWhseItemTrkgLine(WhseActivLine);
            END;
          "Whse. Document Type"::"Internal Put-away":
            IF "Action Type" <> "Action Type"::Take THEN BEGIN
              UpdateWhseIntPutAwayLine(
                "Whse. Document No.","Whse. Document Line No.",
                "Qty. to Handle","Qty. to Handle (Base)","Qty. per Unit of Measure");
              RegisterWhseItemTrkgLine(WhseActivLine);
            END;
        END;
      END;

      IF WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::"Invt. Movement" THEN
        UpdateSourceDocForInvtMovement(WhseActivLine);
    END;

    LOCAL PROCEDURE UpdateWhseDocHeader@7(WhseActivLine@1000 : Record 5767);
    VAR
      WhsePutAwayRqst@1003 : Record 7324;
      WhsePickRqst@1001 : Record 7325;
    BEGIN
      WITH WhseActivLine DO
        CASE "Whse. Document Type" OF
          "Whse. Document Type"::Shipment:
            IF "Action Type" <> "Action Type"::Take THEN BEGIN
              WhseShptHeader.GET("Whse. Document No.");
              WhseShptHeader.VALIDATE(
                "Document Status",WhseShptHeader.GetDocumentStatus(0));
              WhseShptHeader.MODIFY;
            END;
          "Whse. Document Type"::Receipt:
            IF "Action Type" <> "Action Type"::Place THEN BEGIN
              PostedWhseRcptHeader.GET("Whse. Document No.");
              PostedWhseRcptLine.RESET;
              PostedWhseRcptLine.SETRANGE("No.",PostedWhseRcptHeader."No.");
              IF PostedWhseRcptLine.FINDFIRST THEN BEGIN
                PostedWhseRcptHeader."Document Status" := PostedWhseRcptHeader.GetHeaderStatus(0);
                PostedWhseRcptHeader.MODIFY;
              END;
              IF PostedWhseRcptHeader."Document Status" =
                 PostedWhseRcptHeader."Document Status"::"Completely Put Away"
              THEN BEGIN
                WhsePutAwayRqst.SETRANGE("Document Type",WhsePutAwayRqst."Document Type"::Receipt);
                WhsePutAwayRqst.SETRANGE("Document No.",PostedWhseRcptHeader."No.");
                WhsePutAwayRqst.DELETEALL;
                ItemTrackingMgt.DeleteWhseItemTrkgLines(
                  DATABASE::"Posted Whse. Receipt Line",0,PostedWhseRcptHeader."No.",'',0,0,'',FALSE);
              END;
            END;
          "Whse. Document Type"::"Internal Pick":
            IF "Action Type" <> "Action Type"::Take THEN BEGIN
              WhseInternalPickHeader.GET("Whse. Document No.");
              WhseInternalPickLine.RESET;
              WhseInternalPickLine.SETRANGE("No.","Whse. Document No.");
              IF WhseInternalPickLine.FINDFIRST THEN BEGIN
                WhseInternalPickHeader."Document Status" :=
                  WhseInternalPickHeader.GetDocumentStatus(0);
                WhseInternalPickHeader.MODIFY;
                IF WhseInternalPickHeader."Document Status" =
                   WhseInternalPickHeader."Document Status"::"Completely Picked"
                THEN BEGIN
                  WhseInternalPickHeader.DeleteRelatedLines;
                  WhseInternalPickHeader.DELETE;
                END;
              END ELSE BEGIN
                WhseInternalPickHeader.DeleteRelatedLines;
                WhseInternalPickHeader.DELETE;
              END;
            END;
          "Whse. Document Type"::"Internal Put-away":
            IF "Action Type" <> "Action Type"::Take THEN BEGIN
              WhseInternalPutAwayHeader.GET("Whse. Document No.");
              WhseInternalPutAwayLine.RESET;
              WhseInternalPutAwayLine.SETRANGE("No.","Whse. Document No.");
              IF WhseInternalPutAwayLine.FINDFIRST THEN BEGIN
                WhseInternalPutAwayHeader."Document Status" :=
                  WhseInternalPutAwayHeader.GetDocumentStatus(0);
                WhseInternalPutAwayHeader.MODIFY;
                IF WhseInternalPutAwayHeader."Document Status" =
                   WhseInternalPutAwayHeader."Document Status"::"Completely Put Away"
                THEN BEGIN
                  WhseInternalPutAwayHeader.DeleteRelatedLines;
                  WhseInternalPutAwayHeader.DELETE;
                END;
              END ELSE BEGIN
                WhseInternalPutAwayHeader.DeleteRelatedLines;
                WhseInternalPutAwayHeader.DELETE;
              END;
            END;
          "Whse. Document Type"::Production:
            IF "Action Type" <> "Action Type"::Take THEN BEGIN
              ProdOrder.GET("Source Subtype","Source No.");
              ProdOrder.CALCFIELDS("Completely Picked");
              IF ProdOrder."Completely Picked" THEN BEGIN
                WhsePickRqst.SETRANGE("Document Type",WhsePickRqst."Document Type"::Production);
                WhsePickRqst.SETRANGE("Document No.",ProdOrder."No.");
                WhsePickRqst.MODIFYALL("Completely Picked",TRUE);
                ItemTrackingMgt.DeleteWhseItemTrkgLines(
                  DATABASE::"Prod. Order Component","Source Subtype","Source No.",'',0,0,'',FALSE);
              END;
            END;
          "Whse. Document Type"::Assembly:
            IF "Action Type" <> "Action Type"::Take THEN BEGIN
              AssemblyHeader.GET("Source Subtype","Source No.");
              IF AssemblyHeader.CompletelyPicked THEN BEGIN
                WhsePickRqst.SETRANGE("Document Type",WhsePickRqst."Document Type"::Assembly);
                WhsePickRqst.SETRANGE("Document No.",AssemblyHeader."No.");
                WhsePickRqst.MODIFYALL("Completely Picked",TRUE);
                ItemTrackingMgt.DeleteWhseItemTrkgLines(
                  DATABASE::"Assembly Line","Source Subtype","Source No.",'',0,0,'',FALSE);
              END;
            END;
        END;
    END;

    LOCAL PROCEDURE UpdateWhseShptLine@8(WhseDocNo@1000 : Code[20];WhseDocLineNo@1001 : Integer;QtyToHandle@1002 : Decimal;QtyToHandleBase@1003 : Decimal;QtyPerUOM@1004 : Decimal);
    BEGIN
      WhseShptLine.GET(WhseDocNo,WhseDocLineNo);
      WhseShptLine."Qty. Picked (Base)" :=
        WhseShptLine."Qty. Picked (Base)" + QtyToHandleBase;
      IF QtyPerUOM = WhseShptLine."Qty. per Unit of Measure" THEN
        WhseShptLine."Qty. Picked" := WhseShptLine."Qty. Picked" + QtyToHandle
      ELSE
        WhseShptLine."Qty. Picked" :=
          ROUND(WhseShptLine."Qty. Picked" + QtyToHandleBase / QtyPerUOM);

      WhseShptLine."Completely Picked" :=
        (WhseShptLine."Qty. Picked" = WhseShptLine.Quantity) OR (WhseShptLine."Qty. Picked (Base)" = WhseShptLine."Qty. (Base)");

      // Handle rounding residual when completely picked
      IF WhseShptLine."Completely Picked" AND (WhseShptLine."Qty. Picked" <> WhseShptLine.Quantity) THEN
        WhseShptLine."Qty. Picked" := WhseShptLine.Quantity;

      WhseShptLine.VALIDATE("Qty. to Ship",WhseShptLine."Qty. Picked" - WhseShptLine."Qty. Shipped");
      WhseShptLine."Qty. to Ship (Base)" := WhseShptLine."Qty. Picked (Base)" - WhseShptLine."Qty. Shipped (Base)";
      WhseShptLine.Status := WhseShptLine.CalcStatusShptLine;
      WhseShptLine.MODIFY;
      OnAfterWhseShptLineModify(WhseShptLine);
    END;

    LOCAL PROCEDURE UpdatePostedWhseRcptLine@14(WhseDocNo@1004 : Code[20];WhseDocLineNo@1003 : Integer;QtyToHandle@1002 : Decimal;QtyToHandleBase@1001 : Decimal;QtyPerUOM@1000 : Decimal);
    BEGIN
      PostedWhseRcptHeader.LOCKTABLE;
      PostedWhseRcptHeader.GET(WhseDocNo);
      PostedWhseRcptLine.LOCKTABLE;
      PostedWhseRcptLine.GET(WhseDocNo,WhseDocLineNo);
      PostedWhseRcptLine."Qty. Put Away (Base)" :=
        PostedWhseRcptLine."Qty. Put Away (Base)" + QtyToHandleBase;
      IF QtyPerUOM = PostedWhseRcptLine."Qty. per Unit of Measure" THEN
        PostedWhseRcptLine."Qty. Put Away" :=
          PostedWhseRcptLine."Qty. Put Away" + QtyToHandle
      ELSE
        PostedWhseRcptLine."Qty. Put Away" :=
          ROUND(
            PostedWhseRcptLine."Qty. Put Away" +
            QtyToHandleBase / PostedWhseRcptLine."Qty. per Unit of Measure");
      PostedWhseRcptLine.Status := PostedWhseRcptLine.GetLineStatus;
      PostedWhseRcptLine.MODIFY;
    END;

    LOCAL PROCEDURE UpdateWhseIntPickLine@17(WhseDocNo@1004 : Code[20];WhseDocLineNo@1003 : Integer;QtyToHandle@1002 : Decimal;QtyToHandleBase@1001 : Decimal;QtyPerUOM@1000 : Decimal);
    BEGIN
      WhseInternalPickLine.GET(WhseDocNo,WhseDocLineNo);
      IF WhseInternalPickLine."Qty. (Base)" =
         WhseInternalPickLine."Qty. Picked (Base)" + QtyToHandleBase
      THEN
        WhseInternalPickLine.DELETE
      ELSE BEGIN
        WhseInternalPickLine."Qty. Picked (Base)" :=
          WhseInternalPickLine."Qty. Picked (Base)" + QtyToHandleBase;
        IF QtyPerUOM = WhseInternalPickLine."Qty. per Unit of Measure" THEN
          WhseInternalPickLine."Qty. Picked" :=
            WhseInternalPickLine."Qty. Picked" + QtyToHandle
        ELSE
          WhseInternalPickLine."Qty. Picked" :=
            ROUND(
              WhseInternalPickLine."Qty. Picked" + QtyToHandleBase / QtyPerUOM);
        WhseInternalPickLine.VALIDATE(
          "Qty. Outstanding",WhseInternalPickLine."Qty. Outstanding" - QtyToHandle);
        WhseInternalPickLine.Status := WhseInternalPickLine.CalcStatusPickLine;
        WhseInternalPickLine.MODIFY;
      END;
    END;

    LOCAL PROCEDURE UpdateWhseIntPutAwayLine@12(WhseDocNo@1004 : Code[20];WhseDocLineNo@1003 : Integer;QtyToHandle@1002 : Decimal;QtyToHandleBase@1001 : Decimal;QtyPerUOM@1000 : Decimal);
    BEGIN
      WhseInternalPutAwayLine.GET(WhseDocNo,WhseDocLineNo);
      IF WhseInternalPutAwayLine."Qty. (Base)" =
         WhseInternalPutAwayLine."Qty. Put Away (Base)" + QtyToHandleBase
      THEN
        WhseInternalPutAwayLine.DELETE
      ELSE BEGIN
        WhseInternalPutAwayLine."Qty. Put Away (Base)" :=
          WhseInternalPutAwayLine."Qty. Put Away (Base)" + QtyToHandleBase;
        IF QtyPerUOM = WhseInternalPutAwayLine."Qty. per Unit of Measure" THEN
          WhseInternalPutAwayLine."Qty. Put Away" :=
            WhseInternalPutAwayLine."Qty. Put Away" + QtyToHandle
        ELSE
          WhseInternalPutAwayLine."Qty. Put Away" :=
            ROUND(
              WhseInternalPutAwayLine."Qty. Put Away" +
              QtyToHandleBase / WhseInternalPutAwayLine."Qty. per Unit of Measure");
        WhseInternalPutAwayLine.VALIDATE(
          "Qty. Outstanding",WhseInternalPutAwayLine."Qty. Outstanding" - QtyToHandle);
        WhseInternalPutAwayLine.Status := WhseInternalPutAwayLine.CalcStatusPutAwayLine;
        WhseInternalPutAwayLine.MODIFY;
      END;
    END;

    LOCAL PROCEDURE UpdateProdCompLine@13(SourceSubType@1006 : Option;SourceNo@1004 : Code[20];SourceLineNo@1003 : Integer;SourceSubLineNo@1005 : Integer;QtyToHandle@1002 : Decimal;QtyToHandleBase@1001 : Decimal;QtyPerUOM@1000 : Decimal);
    BEGIN
      ProdCompLine.GET(SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo);
      ProdCompLine."Qty. Picked (Base)" :=
        ProdCompLine."Qty. Picked (Base)" + QtyToHandleBase;
      IF QtyPerUOM = ProdCompLine."Qty. per Unit of Measure" THEN
        ProdCompLine."Qty. Picked" := ProdCompLine."Qty. Picked" + QtyToHandle
      ELSE
        ProdCompLine."Qty. Picked" :=
          ROUND(ProdCompLine."Qty. Picked" + QtyToHandleBase / QtyPerUOM);
      ProdCompLine."Completely Picked" :=
        ProdCompLine."Qty. Picked" = ProdCompLine."Expected Quantity";
      ProdCompLine.MODIFY;
    END;

    LOCAL PROCEDURE UpdateAssemblyLine@32(SourceSubType@1006 : Option;SourceNo@1004 : Code[20];SourceLineNo@1003 : Integer;QtyToHandle@1002 : Decimal;QtyToHandleBase@1001 : Decimal;QtyPerUOM@1000 : Decimal);
    BEGIN
      AssemblyLine.GET(SourceSubType,SourceNo,SourceLineNo);
      AssemblyLine."Qty. Picked (Base)" :=
        AssemblyLine."Qty. Picked (Base)" + QtyToHandleBase;
      IF QtyPerUOM = AssemblyLine."Qty. per Unit of Measure" THEN
        AssemblyLine."Qty. Picked" := AssemblyLine."Qty. Picked" + QtyToHandle
      ELSE
        AssemblyLine."Qty. Picked" :=
          ROUND(AssemblyLine."Qty. Picked" + QtyToHandleBase / QtyPerUOM);
      AssemblyLine.MODIFY;
    END;

    LOCAL PROCEDURE LocationGet@4(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE GetItemUnitOfMeasure2@9(ItemNo@1000 : Code[20];UOMCode@1001 : Code[10]);
    BEGIN
      IF (ItemUnitOfMeasure."Item No." <> ItemNo) OR
         (ItemUnitOfMeasure.Code <> UOMCode)
      THEN
        IF NOT ItemUnitOfMeasure.GET(ItemNo,UOMCode) THEN
          ItemUnitOfMeasure.INIT;
    END;

    LOCAL PROCEDURE UpdateTempBinContentBuffer@1(WhseActivLine@1000 : Record 5767);
    VAR
      WMSMgt@1002 : Codeunit 7302;
      UOMCode@1003 : Code[10];
      Sign@1001 : Integer;
    BEGIN
      WITH WhseActivLine DO BEGIN
        IF Location."Directed Put-away and Pick" THEN
          UOMCode := "Unit of Measure Code"
        ELSE
          UOMCode := WMSMgt.GetBaseUOM("Item No.");
        IF NOT TempBinContentBuffer.GET("Location Code","Bin Code","Item No.","Variant Code",UOMCode,"Lot No.","Serial No.")
        THEN BEGIN
          TempBinContentBuffer.INIT;
          TempBinContentBuffer."Location Code" := "Location Code";
          TempBinContentBuffer."Zone Code" := "Zone Code";
          TempBinContentBuffer."Bin Code" := "Bin Code";
          TempBinContentBuffer."Item No." := "Item No.";
          TempBinContentBuffer."Variant Code" := "Variant Code";
          TempBinContentBuffer."Unit of Measure Code" := UOMCode;
          TempBinContentBuffer."Lot No." := "Lot No.";
          TempBinContentBuffer."Serial No." := "Serial No.";
          TempBinContentBuffer.INSERT;
        END;
        Sign := 1;
        IF "Action Type" = "Action Type"::Take THEN
          Sign := -1;

        TempBinContentBuffer."Base Unit of Measure" := WMSMgt.GetBaseUOM("Item No.");
        TempBinContentBuffer."Qty. to Handle (Base)" := TempBinContentBuffer."Qty. to Handle (Base)" + Sign * "Qty. to Handle (Base)";
        TempBinContentBuffer."Qty. Outstanding (Base)" :=
          TempBinContentBuffer."Qty. Outstanding (Base)" + Sign * "Qty. Outstanding (Base)";
        TempBinContentBuffer.Cubage := TempBinContentBuffer.Cubage + Sign * Cubage;
        TempBinContentBuffer.Weight := TempBinContentBuffer.Weight + Sign * Weight;
        TempBinContentBuffer.MODIFY;
      END;
    END;

    LOCAL PROCEDURE CheckBin@18();
    VAR
      Bin@1000 : Record 7354;
    BEGIN
      WITH TempBinContentBuffer DO BEGIN
        SETFILTER("Qty. to Handle (Base)",'>0');
        IF FIND('-') THEN
          REPEAT
            SETRANGE("Qty. to Handle (Base)");
            SETRANGE("Bin Code","Bin Code");
            CALCSUMS(Cubage,Weight);
            Bin.GET("Location Code","Bin Code");
            Bin.CheckIncreaseBin(
              "Bin Code",'',"Qty. to Handle (Base)",Cubage,Weight,Cubage,Weight,TRUE,FALSE);
            SETFILTER("Qty. to Handle (Base)",'>0');
            FIND('+');
            SETRANGE("Bin Code");
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckBinContent@10();
    VAR
      BinContent@1000 : Record 7302;
      Bin@1001 : Record 7354;
      UOMMgt@1005 : Codeunit 5402;
      BreakBulkQtyBaseToPlace@1002 : Decimal;
      AbsQtyToHandle@1006 : Decimal;
      AbsQtyToHandleBase@1007 : Decimal;
      WhseSNRequired@1003 : Boolean;
      WhseLNRequired@1004 : Boolean;
    BEGIN
      WITH TempBinContentBuffer DO BEGIN
        SETFILTER("Qty. to Handle (Base)",'<>0');
        IF FIND('-') THEN
          REPEAT
            IF "Qty. to Handle (Base)" < 0 THEN BEGIN
              BinContent.GET(
                "Location Code","Bin Code",
                "Item No.","Variant Code","Unit of Measure Code");
              ItemTrackingMgt.CheckWhseItemTrkgSetup(BinContent."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
              IF WhseLNRequired THEN
                BinContent.SETRANGE("Lot No. Filter","Lot No.");
              IF WhseSNRequired THEN
                BinContent.SETRANGE("Serial No. Filter","Serial No.");
              BreakBulkQtyBaseToPlace := CalcBreakBulkQtyToPlace(TempBinContentBuffer);
              GetItem("Item No.");
              AbsQtyToHandleBase := ABS("Qty. to Handle (Base)");
              AbsQtyToHandle := ROUND(AbsQtyToHandleBase / UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code"),0.00001);
              IF BreakBulkQtyBaseToPlace > 0 THEN
                BinContent.CheckDecreaseBinContent(AbsQtyToHandle,AbsQtyToHandleBase,BreakBulkQtyBaseToPlace - "Qty. to Handle (Base)")
              ELSE
                BinContent.CheckDecreaseBinContent(AbsQtyToHandle,AbsQtyToHandleBase,ABS("Qty. Outstanding (Base)"));
              IF AbsQtyToHandleBase <> ABS("Qty. to Handle (Base)") THEN BEGIN
                "Qty. to Handle (Base)" := AbsQtyToHandleBase * "Qty. to Handle (Base)" / ABS("Qty. to Handle (Base)");
                MODIFY;
              END;
            END ELSE BEGIN
              Bin.GET("Location Code","Bin Code");
              Bin.CheckWhseClass("Item No.",FALSE);
            END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CalcBreakBulkQtyToPlace@20(TempBinContentBuffer@1000 : Record 7330) QtyBase : Decimal;
    VAR
      BreakBulkWhseActivLine@1001 : Record 5767;
    BEGIN
      WITH TempBinContentBuffer DO BEGIN
        BreakBulkWhseActivLine.SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Action Type","Variant Code",
          "Unit of Measure Code","Breakbulk No.","Activity Type","Lot No.","Serial No.");
        BreakBulkWhseActivLine.SETRANGE("Item No.","Item No.");
        BreakBulkWhseActivLine.SETRANGE("Bin Code","Bin Code");
        BreakBulkWhseActivLine.SETRANGE("Location Code","Location Code");
        BreakBulkWhseActivLine.SETRANGE("Action Type",BreakBulkWhseActivLine."Action Type"::Place);
        BreakBulkWhseActivLine.SETRANGE("Variant Code","Variant Code");
        BreakBulkWhseActivLine.SETRANGE("Unit of Measure Code","Unit of Measure Code");
        BreakBulkWhseActivLine.SETFILTER("Breakbulk No.",'<>0');
        BreakBulkWhseActivLine.SETRANGE("Activity Type",WhseActivHeader.Type);
        BreakBulkWhseActivLine.SETRANGE("No.",WhseActivHeader."No.");
        BreakBulkWhseActivLine.SetTrackingFilter("Serial No.","Lot No.");
        IF BreakBulkWhseActivLine.FIND('-') THEN
          REPEAT
            QtyBase := QtyBase + BreakBulkWhseActivLine."Qty. to Handle (Base)";
          UNTIL BreakBulkWhseActivLine.NEXT = 0;
      END;
      EXIT(QtyBase);
    END;

    LOCAL PROCEDURE CheckWhseItemTrkgLine@28(VAR WhseActivLine@1000 : Record 5767);
    VAR
      TempWhseActivLine@1003 : TEMPORARY Record 5767;
      QtyAvailToRegisterBase@1001 : Decimal;
      QtyAvailToInsertBase@1002 : Decimal;
      QtyToRegisterBase@1004 : Decimal;
      WhseSNRequired@1005 : Boolean;
      WhseLNRequired@1007 : Boolean;
    BEGIN
      IF NOT
         ((WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::Pick) OR
          (WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::"Invt. Movement"))
      THEN
        EXIT;

      IF WhseActivLine.FIND('-') THEN
        REPEAT
          TempWhseActivLine := WhseActivLine;
          IF NOT (TempWhseActivLine."Action Type" = TempWhseActivLine."Action Type"::Place) THEN
            TempWhseActivLine.INSERT;
        UNTIL WhseActivLine.NEXT = 0;

      TempWhseActivLine.SETCURRENTKEY("Item No.");
      IF TempWhseActivLine.FIND('-') THEN
        REPEAT
          TempWhseActivLine.SETRANGE("Item No.",TempWhseActivLine."Item No.");
          ItemTrackingMgt.CheckWhseItemTrkgSetup(TempWhseActivLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
          IF WhseSNRequired OR WhseLNRequired THEN
            REPEAT
              IF WhseSNRequired THEN BEGIN
                TempWhseActivLine.TESTFIELD("Serial No.");
                TempWhseActivLine.TESTFIELD("Qty. (Base)",1);
              END;
              IF WhseLNRequired THEN
                TempWhseActivLine.TESTFIELD("Lot No.");
            UNTIL TempWhseActivLine.NEXT = 0
          ELSE BEGIN
            TempWhseActivLine.FIND('+');
            TempWhseActivLine.DELETEALL;
          END;
          TempWhseActivLine.SETRANGE("Item No.");
        UNTIL TempWhseActivLine.NEXT = 0;

      TempWhseActivLine.RESET;
      TempWhseActivLine.SETCURRENTKEY(
        "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
      TempWhseActivLine.SETRANGE("Breakbulk No.",0);
      IF TempWhseActivLine.FIND('-') THEN
        REPEAT
          ItemTrackingMgt.CheckWhseItemTrkgSetup(TempWhseActivLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
          // Per document
          TempWhseActivLine.SetSourceFilter(
            TempWhseActivLine."Source Type",TempWhseActivLine."Source Subtype",TempWhseActivLine."Source No.",
            TempWhseActivLine."Source Line No.",TempWhseActivLine."Source Subline No.",FALSE);
          REPEAT
            // Per Lot/SN
            TempWhseActivLine.SETRANGE("Item No.",TempWhseActivLine."Item No.");
            QtyAvailToInsertBase := CalcQtyAvailToInsertBase(TempWhseActivLine);
            TempWhseActivLine.SetTrackingFilter(TempWhseActivLine."Serial No.",TempWhseActivLine."Lot No.");
            QtyToRegisterBase := 0;
            REPEAT
              QtyToRegisterBase := QtyToRegisterBase + TempWhseActivLine."Qty. to Handle (Base)";
            UNTIL TempWhseActivLine.NEXT = 0;

            QtyAvailToRegisterBase := CalcQtyAvailToRegisterBase(TempWhseActivLine);
            IF QtyToRegisterBase > QtyAvailToRegisterBase THEN
              QtyAvailToInsertBase -= QtyToRegisterBase - QtyAvailToRegisterBase;
            IF QtyAvailToInsertBase < 0 THEN
              ERROR(Text004);

            IF (TempWhseActivLine."Serial No." <> '') OR (TempWhseActivLine."Lot No." <> '') THEN
              IF NOT IsQtyAvailToPickNonSpecificReservation(TempWhseActivLine,WhseSNRequired,WhseLNRequired,QtyToRegisterBase) THEN
                AvailabilityError(TempWhseActivLine);

            // Clear filters, Lot/SN
            TempWhseActivLine.ClearTrackingFilter;
            TempWhseActivLine.SETRANGE("Item No.");
          UNTIL TempWhseActivLine.NEXT = 0; // Per Lot/SN
          // Clear filters, document
          TempWhseActivLine.ClearSourceFilter;
        UNTIL TempWhseActivLine.NEXT = 0;   // Per document
    END;

    LOCAL PROCEDURE RegisterWhseItemTrkgLine@16(WhseActivLine2@1000 : Record 5767);
    VAR
      ProdOrderComp@1008 : Record 5407;
      AssemblyLine@1010 : Record 901;
      WhseShptLine@1007 : Record 7321;
      QtyToRegisterBase@1003 : Decimal;
      DueDate@1004 : Date;
      NextEntryNo@1009 : Integer;
      WhseSNRequired@1001 : Boolean;
      WhseLNRequired@1002 : Boolean;
      WhseDocType2@1011 : Option;
    BEGIN
      ItemTrackingMgt.CheckWhseItemTrkgSetup(WhseActivLine2."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
      IF NOT (WhseSNRequired OR WhseLNRequired) THEN
        EXIT;

      QtyToRegisterBase := InitTempTrackingSpecification(WhseActivLine2,TempTrackingSpecification);

      TempTrackingSpecification.RESET;

      IF QtyToRegisterBase > 0 THEN BEGIN
        IF (WhseActivLine2."Activity Type" = WhseActivLine2."Activity Type"::Pick) OR
           (WhseActivLine2."Activity Type" = WhseActivLine2."Activity Type"::"Invt. Movement")
        THEN
          InsertRegWhseItemTrkgLine(WhseActivLine2,QtyToRegisterBase);

        IF (WhseActivLine2."Whse. Document Type" IN
            [WhseActivLine2."Whse. Document Type"::Shipment,
             WhseActivLine2."Whse. Document Type"::Production,
             WhseActivLine2."Whse. Document Type"::Assembly]) OR
           ((WhseActivLine2."Activity Type" = WhseActivLine2."Activity Type"::"Invt. Movement") AND
            (WhseActivLine2."Source Type" > 0))
        THEN BEGIN
          IF (WhseActivLine2."Whse. Document Type" = WhseActivLine2."Whse. Document Type"::Shipment) AND
             WhseActivLine2."Assemble to Order"
          THEN
            WhseDocType2 := WhseActivLine2."Whse. Document Type"::Assembly
          ELSE
            WhseDocType2 := WhseActivLine2."Whse. Document Type";
          CASE WhseDocType2 OF
            WhseActivLine2."Whse. Document Type"::Shipment:
              BEGIN
                WhseShptLine.GET(WhseActivLine2."Whse. Document No.",WhseActivLine2."Whse. Document Line No.");
                DueDate := WhseShptLine."Shipment Date";
              END;
            WhseActivLine2."Whse. Document Type"::Production:
              BEGIN
                ProdOrderComp.GET(WhseActivLine2."Source Subtype",WhseActivLine2."Source No.",
                  WhseActivLine2."Source Line No.",WhseActivLine2."Source Subline No.");
                DueDate := ProdOrderComp."Due Date";
              END;
            WhseActivLine2."Whse. Document Type"::Assembly:
              BEGIN
                AssemblyLine.GET(WhseActivLine2."Source Subtype",WhseActivLine2."Source No.",
                  WhseActivLine2."Source Line No.");
                DueDate := AssemblyLine."Due Date";
              END;
          END;

          IF WhseActivLine2."Activity Type" = WhseActivLine2."Activity Type"::"Invt. Movement" THEN
            CASE WhseActivLine2."Source Type" OF
              DATABASE::"Prod. Order Component":
                BEGIN
                  ProdOrderComp.GET(WhseActivLine2."Source Subtype",WhseActivLine2."Source No.",
                    WhseActivLine2."Source Line No.",WhseActivLine2."Source Subline No.");
                  DueDate := ProdOrderComp."Due Date";
                END;
              DATABASE::"Assembly Line":
                BEGIN
                  AssemblyLine.GET(WhseActivLine2."Source Subtype",WhseActivLine2."Source No.",
                    WhseActivLine2."Source Line No.");
                  DueDate := AssemblyLine."Due Date";
                END;
            END;

          NextEntryNo := GetNextTempEntryNo(TempTrackingSpecification);

          TempTrackingSpecification.INIT;
          TempTrackingSpecification."Entry No." := NextEntryNo;
          IF WhseActivLine."Source Type" = DATABASE::"Prod. Order Component" THEN
            TempTrackingSpecification.SetSource(
              WhseActivLine2."Source Type",WhseActivLine2."Source Subtype",WhseActivLine2."Source No.",
              WhseActivLine2."Source Subline No.",'',WhseActivLine2."Source Line No.")
          ELSE
            TempTrackingSpecification.SetSource(
              WhseActivLine2."Source Type",WhseActivLine2."Source Subtype",WhseActivLine2."Source No.",
              WhseActivLine2."Source Line No.",'',0);
          TempTrackingSpecification."Creation Date" := DueDate;
          TempTrackingSpecification."Qty. to Handle (Base)" := QtyToRegisterBase;
          TempTrackingSpecification."Item No." := WhseActivLine2."Item No.";
          TempTrackingSpecification."Variant Code" := WhseActivLine2."Variant Code";
          TempTrackingSpecification."Location Code" := WhseActivLine2."Location Code";
          TempTrackingSpecification.Description := WhseActivLine2.Description;
          TempTrackingSpecification."Qty. per Unit of Measure" := WhseActivLine2."Qty. per Unit of Measure";
          TempTrackingSpecification.SetTracking(
            WhseActivLine2."Serial No.",WhseActivLine2."Lot No.",
            WhseActivLine2."Warranty Date",WhseActivLine2."Expiration Date");
          TempTrackingSpecification."Quantity (Base)" := QtyToRegisterBase;
          TempTrackingSpecification.INSERT;
          OnAfterRegWhseItemTrkgLine(WhseActivLine2,TempTrackingSpecification);
        END;
      END;
    END;

    LOCAL PROCEDURE InitTempTrackingSpecification@34(WhseActivLine2@1002 : Record 5767;VAR TempTrackingSpecification@1001 : TEMPORARY Record 336) QtyToRegisterBase : Decimal;
    VAR
      WhseItemTrkgLine@1000 : Record 6550;
      QtyToHandleBase@1003 : Decimal;
    BEGIN
      QtyToRegisterBase := WhseActivLine2."Qty. to Handle (Base)";
      SetPointerFilter(WhseActivLine2,WhseItemTrkgLine);

      WITH WhseItemTrkgLine DO BEGIN
        SETRANGE("Serial No.",WhseActivLine2."Serial No.");
        SETRANGE("Lot No.",WhseActivLine2."Lot No.");
        IF FINDSET THEN
          REPEAT
            IF "Quantity (Base)" > "Qty. Registered (Base)" THEN BEGIN
              IF QtyToRegisterBase > ("Quantity (Base)" - "Qty. Registered (Base)") THEN BEGIN
                QtyToHandleBase := "Quantity (Base)" - "Qty. Registered (Base)";
                QtyToRegisterBase := QtyToRegisterBase - QtyToHandleBase;
                "Qty. Registered (Base)" := "Quantity (Base)";
              END ELSE BEGIN
                "Qty. Registered (Base)" += QtyToRegisterBase;
                QtyToHandleBase := QtyToRegisterBase;
                QtyToRegisterBase := 0;
              END;
              IF NOT UpdateTempTracking(WhseActivLine2,QtyToHandleBase,TempTrackingSpecification) THEN BEGIN
                TempTrackingSpecification.SETCURRENTKEY("Lot No.","Serial No.");
                TempTrackingSpecification.SetTrackingFilter(WhseActivLine2."Serial No.",WhseActivLine2."Lot No.");
                IF TempTrackingSpecification.FINDFIRST THEN BEGIN
                  TempTrackingSpecification."Qty. to Handle (Base)" += QtyToHandleBase;
                  TempTrackingSpecification.MODIFY;
                END;
              END;
              ItemTrackingMgt.SetRegistering(TRUE);
              ItemTrackingMgt.CalcWhseItemTrkgLine(WhseItemTrkgLine);
              MODIFY;
            END;
          UNTIL (NEXT = 0) OR (QtyToRegisterBase = 0);
      END;
    END;

    LOCAL PROCEDURE CalcQtyAvailToRegisterBase@19(WhseActivLine@1000 : Record 5767) : Decimal;
    VAR
      WhseItemTrkgLine@1001 : Record 6550;
    BEGIN
      SetPointerFilter(WhseActivLine,WhseItemTrkgLine);
      WhseItemTrkgLine.SetTrackingFilter(WhseActivLine."Serial No.",WhseActivLine."Lot No.");
      WhseItemTrkgLine.CALCSUMS("Quantity (Base)","Qty. Registered (Base)");
      EXIT(WhseItemTrkgLine."Quantity (Base)" - WhseItemTrkgLine."Qty. Registered (Base)");
    END;

    LOCAL PROCEDURE SourceLineQtyBase@27(WhseActivLine@1000 : Record 5767) : Decimal;
    VAR
      WhsePostedRcptLine@1003 : Record 7319;
      WhseShipmentLine@1001 : Record 7321;
      WhseIntPutAwayLine@1004 : Record 7332;
      WhseIntPickLine@1002 : Record 7334;
      ProdOrderComponent@1005 : Record 5407;
      AssemblyLine@1009 : Record 901;
      WhseMovementWksh@1006 : Record 7326;
      WhseActivLine2@1008 : Record 5767;
      QtyBase@1007 : Decimal;
      WhseDocType2@1010 : Option;
    BEGIN
      IF (WhseActivLine."Whse. Document Type" = WhseActivLine."Whse. Document Type"::Shipment) AND
         WhseActivLine."Assemble to Order"
      THEN
        WhseDocType2 := WhseActivLine."Whse. Document Type"::Assembly
      ELSE
        WhseDocType2 := WhseActivLine."Whse. Document Type";
      CASE WhseDocType2 OF
        WhseActivLine."Whse. Document Type"::Receipt:
          IF WhsePostedRcptLine.GET(
               WhseActivLine."Whse. Document No.",WhseActivLine."Whse. Document Line No.")
          THEN
            EXIT(WhsePostedRcptLine."Qty. (Base)");
        WhseActivLine."Whse. Document Type"::Shipment:
          IF WhseShipmentLine.GET(
               WhseActivLine."Whse. Document No.",WhseActivLine."Whse. Document Line No.")
          THEN
            EXIT(WhseShipmentLine."Qty. (Base)");
        WhseActivLine."Whse. Document Type"::"Internal Put-away":
          IF WhseIntPutAwayLine.GET(
               WhseActivLine."Whse. Document No.",WhseActivLine."Whse. Document Line No.")
          THEN
            EXIT(WhseIntPutAwayLine."Qty. (Base)");
        WhseActivLine."Whse. Document Type"::"Internal Pick":
          IF WhseIntPickLine.GET(
               WhseActivLine."Whse. Document No.",WhseActivLine."Whse. Document Line No.")
          THEN
            EXIT(WhseIntPickLine."Qty. (Base)");
        WhseActivLine."Whse. Document Type"::Production:
          IF ProdOrderComponent.GET(
               WhseActivLine."Source Subtype",WhseActivLine."Source No.",
               WhseActivLine."Source Line No.",WhseActivLine."Source Subline No.")
          THEN
            EXIT(ProdOrderComponent."Expected Qty. (Base)");
        WhseActivLine."Whse. Document Type"::Assembly:
          IF AssemblyLine.GET(
               WhseActivLine."Source Subtype",WhseActivLine."Source No.",
               WhseActivLine."Source Line No.")
          THEN
            EXIT(AssemblyLine."Quantity (Base)");
        WhseActivLine."Whse. Document Type"::"Movement Worksheet":
          IF WhseMovementWksh.GET(
               WhseActivLine."Whse. Document No.",WhseActivLine."Source No.",
               WhseActivLine."Location Code",WhseActivLine."Source Line No.")
          THEN
            EXIT(WhseMovementWksh."Qty. (Base)");
      END;

      IF WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::"Invt. Movement" THEN
        CASE WhseActivLine."Source Document" OF
          WhseActivLine."Source Document"::"Prod. Consumption":
            IF ProdOrderComponent.GET(
                 WhseActivLine."Source Subtype",WhseActivLine."Source No.",
                 WhseActivLine."Source Line No.",WhseActivLine."Source Subline No.")
            THEN
              EXIT(ProdOrderComponent."Expected Qty. (Base)");
          WhseActivLine."Source Document"::"Assembly Consumption":
            IF AssemblyLine.GET(
                 WhseActivLine."Source Subtype",WhseActivLine."Source No.",
                 WhseActivLine."Source Line No.")
            THEN
              EXIT(AssemblyLine."Quantity (Base)");
          WhseActivLine."Source Document"::" ":
            BEGIN
              WhseActivLine2.SETCURRENTKEY("No.","Line No.","Activity Type");
              WhseActivLine2.SETRANGE("Activity Type",WhseActivLine."Activity Type");
              WhseActivLine2.SETRANGE("No.",WhseActivLine."No.");
              WhseActivLine2.SETFILTER("Action Type",'<%1',WhseActivLine2."Action Type"::Place);
              WhseActivLine2.SETFILTER("Qty. to Handle (Base)",'<>0');
              WhseActivLine2.SETRANGE("Breakbulk No.",0);
              IF WhseActivLine2.FIND('-') THEN
                REPEAT
                  QtyBase += WhseActivLine2."Qty. (Base)";
                UNTIL WhseActivLine2.NEXT = 0;
              EXIT(QtyBase);
            END;
        END;
    END;

    LOCAL PROCEDURE CalcQtyAvailToInsertBase@22(WhseActivLine@1000 : Record 5767) : Decimal;
    VAR
      WhseItemTrkgLine@1001 : Record 6550;
    BEGIN
      SetPointerFilter(WhseActivLine,WhseItemTrkgLine);
      WhseItemTrkgLine.CALCSUMS(WhseItemTrkgLine."Quantity (Base)");
      EXIT(SourceLineQtyBase(WhseActivLine) - WhseItemTrkgLine."Quantity (Base)");
    END;

    LOCAL PROCEDURE CalcQtyReservedOnInventory@40(WhseActivLine@1000 : Record 5767;SNRequired@1001 : Boolean;LNRequired@1002 : Boolean);
    BEGIN
      WITH WhseActivLine DO BEGIN
        GetItem("Item No.");
        Item.SETRANGE("Location Filter","Location Code");
        Item.SETRANGE("Variant Filter","Variant Code");
        IF "Lot No." <> '' THEN BEGIN
          IF LNRequired THEN
            Item.SETRANGE("Lot No. Filter","Lot No.")
          ELSE
            Item.SETFILTER("Lot No. Filter",'%1|%2',"Lot No.",'')
        END ELSE
          Item.SETRANGE("Lot No. Filter");
        IF "Serial No." <> '' THEN BEGIN
          IF SNRequired THEN
            Item.SETRANGE("Serial No. Filter","Serial No.")
          ELSE
            Item.SETFILTER("Serial No. Filter",'%1|%2',"Serial No.",'');
        END ELSE
          Item.SETRANGE("Serial No. Filter");
        Item.CALCFIELDS("Reserved Qty. on Inventory");
      END;
    END;

    LOCAL PROCEDURE InsertRegWhseItemTrkgLine@21(WhseActivLine@1000 : Record 5767;QtyToRegisterBase@1001 : Decimal);
    VAR
      WhseItemTrkgLine2@1002 : Record 6550;
      NextEntryNo@1003 : Integer;
    BEGIN
      WITH WhseItemTrkgLine2 DO BEGIN
        RESET;
        IF FINDLAST THEN
          NextEntryNo := "Entry No." + 1;

        INIT;
        "Entry No." := NextEntryNo;
        "Item No." := WhseActivLine."Item No.";
        Description := WhseActivLine.Description;
        "Variant Code" := WhseActivLine."Variant Code";
        "Location Code" := WhseActivLine."Location Code";
        SetPointer(WhseActivLine,WhseItemTrkgLine2);
        SetTracking(
          WhseActivLine."Serial No.",WhseActivLine."Lot No.",WhseActivLine."Warranty Date",WhseActivLine."Expiration Date");
        "Quantity (Base)" := QtyToRegisterBase;
        "Qty. per Unit of Measure" := WhseActivLine."Qty. per Unit of Measure";
        "Qty. Registered (Base)" := QtyToRegisterBase;
        "Created by Whse. Activity Line" := TRUE;
        ItemTrackingMgt.SetRegistering(TRUE);
        ItemTrackingMgt.CalcWhseItemTrkgLine(WhseItemTrkgLine2);
        INSERT;
      END;
      OnAfterInsRegWhseItemTrkgLine(WhseActivLine,WhseItemTrkgLine2);
    END;

    [External]
    PROCEDURE SetPointer@33(WhseActivLine@1000 : Record 5767;VAR WhseItemTrkgLine@1001 : Record 6550);
    VAR
      WhseDocType2@1002 : Option;
    BEGIN
      WITH WhseActivLine DO BEGIN
        IF ("Whse. Document Type" = "Whse. Document Type"::Shipment) AND "Assemble to Order" THEN
          WhseDocType2 := "Whse. Document Type"::Assembly
        ELSE
          WhseDocType2 := "Whse. Document Type";
        CASE WhseDocType2 OF
          "Whse. Document Type"::Receipt:
            WhseItemTrkgLine.SetSource(
              DATABASE::"Posted Whse. Receipt Line",0,"Whse. Document No.","Whse. Document Line No.",'',0);
          "Whse. Document Type"::Shipment:
            WhseItemTrkgLine.SetSource(
              DATABASE::"Warehouse Shipment Line",0,"Whse. Document No.","Whse. Document Line No.",'',0);
          "Whse. Document Type"::"Internal Put-away":
            WhseItemTrkgLine.SetSource(
              DATABASE::"Whse. Internal Put-away Line",0,"Whse. Document No.","Whse. Document Line No.",'',0);
          "Whse. Document Type"::"Internal Pick":
            WhseItemTrkgLine.SetSource(
              DATABASE::"Whse. Internal Pick Line",0,"Whse. Document No.","Whse. Document Line No.",'',0);
          "Whse. Document Type"::Production:
            WhseItemTrkgLine.SetSource(
              DATABASE::"Prod. Order Component","Source Subtype","Source No.","Source Subline No.",'',"Source Line No.");
          "Whse. Document Type"::Assembly:
            WhseItemTrkgLine.SetSource(
              DATABASE::"Assembly Line","Source Subtype","Source No.","Source Line No.",'',0);
          "Whse. Document Type"::"Movement Worksheet":
            WhseItemTrkgLine.SetSource(
              DATABASE::"Whse. Worksheet Line",0,"Source No.","Whse. Document Line No.",
              COPYSTR("Whse. Document No.",1,MAXSTRLEN(WhseItemTrkgLine."Source Batch Name")),0);
        END;
        WhseItemTrkgLine."Location Code" := "Location Code";
        IF "Activity Type" = "Activity Type"::"Invt. Movement" THEN BEGIN
          WhseItemTrkgLine.SetSource("Source Type","Source Subtype","Source No.","Source Line No.",'',0);
          IF "Source Type" = DATABASE::"Prod. Order Component" THEN
            WhseItemTrkgLine.SetSource("Source Type","Source Subtype","Source No.","Source Subline No.",'',"Source Line No.")
          ELSE
            WhseItemTrkgLine.SetSource("Source Type","Source Subtype","Source No.","Source Line No.",'',0);
          WhseItemTrkgLine."Location Code" := "Location Code";
        END;
      END;
    END;

    [External]
    PROCEDURE SetPointerFilter@35(WhseActivLine@1000 : Record 5767;VAR WhseItemTrkgLine@1001 : Record 6550);
    VAR
      WhseItemTrkgLine2@1002 : Record 6550;
    BEGIN
      SetPointer(WhseActivLine,WhseItemTrkgLine2);
      WhseItemTrkgLine.SetSourceFilter(
        WhseItemTrkgLine2."Source Type",WhseItemTrkgLine2."Source Subtype",
        WhseItemTrkgLine2."Source ID",WhseItemTrkgLine2."Source Ref. No.",TRUE);
      WhseItemTrkgLine.SetSourceFilter2(WhseItemTrkgLine2."Source Batch Name",WhseItemTrkgLine2."Source Prod. Order Line");
      WhseItemTrkgLine.SETRANGE("Location Code",WhseItemTrkgLine2."Location Code");
    END;

    [External]
    PROCEDURE ShowHideDialog@36(HideDialog2@1000 : Boolean);
    BEGIN
      HideDialog := HideDialog2;
    END;

    LOCAL PROCEDURE CalcTotalAvailQtyToPick@56(WhseActivLine@1000 : Record 5767;SNRequired@1002 : Boolean;LNRequired@1001 : Boolean) : Decimal;
    VAR
      WhseEntry@1006 : Record 7312;
      ItemLedgEntry@1012 : Record 32;
      TempWhseActivLine2@1015 : TEMPORARY Record 5767;
      WarehouseActivityLine@1017 : Record 5767;
      CreatePick@1025 : Codeunit 7312;
      WhseAvailMgt@1013 : Codeunit 7314;
      BinTypeFilter@1016 : Text;
      TotalAvailQtyBase@1004 : Decimal;
      QtyInWhseBase@1008 : Decimal;
      QtyOnPickBinsBase@1007 : Decimal;
      QtyOnOutboundBinsBase@1009 : Decimal;
      QtyOnDedicatedBinsBase@1014 : Decimal;
      SubTotalBase@1010 : Decimal;
      QtyReservedOnPickShipBase@1011 : Decimal;
      LineReservedQtyBase@1005 : Decimal;
      QtyPickedNotShipped@1003 : Decimal;
    BEGIN
      WITH WhseActivLine DO BEGIN
        CalcQtyReservedOnInventory(WhseActivLine,SNRequired,LNRequired);

        LocationGet("Location Code");
        IF Location."Directed Put-away and Pick" OR
           ("Activity Type" = "Activity Type"::"Invt. Movement")
        THEN BEGIN
          WhseEntry.SETCURRENTKEY("Item No.","Location Code","Variant Code","Bin Type Code");
          WhseEntry.SETRANGE("Item No.","Item No.");
          WhseEntry.SETRANGE("Location Code","Location Code");
          WhseEntry.SETRANGE("Variant Code","Variant Code");
          IF "Lot No." <> '' THEN
            IF LNRequired THEN
              WhseEntry.SETRANGE("Lot No.","Lot No.")
            ELSE
              WhseEntry.SETFILTER("Lot No.",'%1|%2',"Lot No.",'');
          IF "Serial No." <> '' THEN
            IF SNRequired THEN
              WhseEntry.SETRANGE("Serial No.","Serial No.")
            ELSE
              WhseEntry.SETFILTER("Serial No.",'%1|%2',"Serial No.",'');
          WhseEntry.CALCSUMS("Qty. (Base)");
          QtyInWhseBase := WhseEntry."Qty. (Base)";

          BinTypeFilter := CreatePick.GetBinTypeFilter(0);
          IF BinTypeFilter <> '' THEN
            WhseEntry.SETFILTER("Bin Type Code",'<>%1',BinTypeFilter); // Pick from all but Receive area
          WhseEntry.CALCSUMS("Qty. (Base)");
          QtyOnPickBinsBase := WhseEntry."Qty. (Base)";

          QtyOnOutboundBinsBase :=
            CreatePick.CalcQtyOnOutboundBins(
              "Location Code","Item No.","Variant Code","Lot No.","Serial No.",TRUE);

          QtyOnDedicatedBinsBase :=
            WhseAvailMgt.CalcQtyOnDedicatedBins("Location Code","Item No.","Variant Code","Lot No.","Serial No.");

          SubTotalBase :=
            QtyInWhseBase -
            QtyOnPickBinsBase - QtyOnOutboundBinsBase - QtyOnDedicatedBinsBase;
          IF "Activity Type" <> "Activity Type"::"Invt. Movement" THEN
            SubTotalBase -= ABS(Item."Reserved Qty. on Inventory");

          IF SubTotalBase < 0 THEN BEGIN
            CreatePick.FilterWhsePickLinesWithUndefinedBin(
              WarehouseActivityLine,"Item No.","Location Code","Variant Code",
              LNRequired,"Lot No.",SNRequired,"Serial No.");
            IF WarehouseActivityLine.FINDSET THEN
              REPEAT
                TempWhseActivLine2 := WarehouseActivityLine;
                TempWhseActivLine2."Qty. Outstanding (Base)" *= -1;
                TempWhseActivLine2.INSERT;
              UNTIL WarehouseActivityLine.NEXT = 0;

            QtyReservedOnPickShipBase :=
              WhseAvailMgt.CalcReservQtyOnPicksShips("Location Code","Item No.","Variant Code",TempWhseActivLine2);

            LineReservedQtyBase :=
              WhseAvailMgt.CalcLineReservedQtyOnInvt(
                "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",TRUE,'','',TempWhseActivLine2);

            IF ABS(SubTotalBase) < QtyReservedOnPickShipBase + LineReservedQtyBase THEN
              QtyReservedOnPickShipBase := ABS(SubTotalBase) - LineReservedQtyBase;

            TotalAvailQtyBase :=
              QtyOnPickBinsBase +
              SubTotalBase +
              QtyReservedOnPickShipBase +
              LineReservedQtyBase;
          END ELSE
            TotalAvailQtyBase := QtyOnPickBinsBase;
        END ELSE BEGIN
          ItemLedgEntry.SETCURRENTKEY(
            "Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date","Expiration Date","Lot No.","Serial No.");
          ItemLedgEntry.SETRANGE("Item No.","Item No.");
          ItemLedgEntry.SETRANGE("Variant Code","Variant Code");
          ItemLedgEntry.SETRANGE(Open,TRUE);
          ItemLedgEntry.SETRANGE("Location Code","Location Code");

          IF "Serial No." <> '' THEN
            IF SNRequired THEN
              ItemLedgEntry.SETRANGE("Serial No.","Serial No.")
            ELSE
              ItemLedgEntry.SETFILTER("Serial No.",'%1|%2',"Serial No.",'');

          IF "Lot No." <> '' THEN
            IF LNRequired THEN
              ItemLedgEntry.SETRANGE("Lot No.","Lot No.")
            ELSE
              ItemLedgEntry.SETFILTER("Lot No.",'%1|%2',"Lot No.",'');

          ItemLedgEntry.CALCSUMS("Remaining Quantity");
          QtyInWhseBase := ItemLedgEntry."Remaining Quantity";

          QtyPickedNotShipped := CalcQtyPickedNotShipped(WhseActivLine,SNRequired,LNRequired);

          LineReservedQtyBase :=
            WhseAvailMgt.CalcLineReservedQtyOnInvt(
              "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",FALSE,'','',TempWhseActivLine2);

          TotalAvailQtyBase :=
            QtyInWhseBase -
            QtyPickedNotShipped -
            ABS(Item."Reserved Qty. on Inventory") +
            LineReservedQtyBase;
        END;

        EXIT(TotalAvailQtyBase);
      END;
    END;

    LOCAL PROCEDURE IsQtyAvailToPickNonSpecificReservation@51(WhseActivLine@1001 : Record 5767;SNRequired@1002 : Boolean;LNRequired@1003 : Boolean;QtyToRegister@1004 : Decimal) : Boolean;
    VAR
      QtyAvailToPick@1000 : Decimal;
    BEGIN
      QtyAvailToPick := CalcTotalAvailQtyToPick(WhseActivLine,SNRequired,LNRequired);
      IF QtyAvailToPick < QtyToRegister THEN
        IF ReleaseNonSpecificReservations(WhseActivLine,SNRequired,LNRequired,QtyToRegister - QtyAvailToPick) THEN
          QtyAvailToPick := CalcTotalAvailQtyToPick(WhseActivLine,SNRequired,LNRequired);

      EXIT(QtyAvailToPick >= QtyToRegister);
    END;

    LOCAL PROCEDURE CalcQtyPickedNotShipped@24(WhseActivLine@1001 : Record 5767;SNRequired@1000 : Boolean;LNRequired@1004 : Boolean) QtyBasePicked : Decimal;
    VAR
      ReservEntry@1005 : Record 337;
      RegWhseActivLine@1002 : Record 5773;
      QtyHandled@1003 : Decimal;
    BEGIN
      WITH WhseActivLine DO BEGIN
        ReservEntry.RESET;
        ReservEntry.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status");
        ReservEntry.SETRANGE("Item No.","Item No.");
        ReservEntry.SETRANGE("Variant Code","Variant Code");
        ReservEntry.SETRANGE("Location Code","Location Code");
        ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Surplus);

        IF SNRequired THEN
          ReservEntry.SETRANGE("Serial No.","Serial No.")
        ELSE
          ReservEntry.SETFILTER("Serial No.",'%1|%2',"Serial No.",'');

        IF LNRequired THEN
          ReservEntry.SETRANGE("Lot No.","Lot No.")
        ELSE
          ReservEntry.SETFILTER("Lot No.",'%1|%2',"Lot No.",'');

        IF ReservEntry.FIND('-') THEN
          REPEAT
            IF NOT ((ReservEntry."Source Type" = "Source Type") AND
                    (ReservEntry."Source Subtype" = "Source Subtype") AND
                    (ReservEntry."Source ID" = "Source No.") AND
                    ((ReservEntry."Source Ref. No." = "Source Line No.") OR
                     (ReservEntry."Source Ref. No." = "Source Subline No."))) AND
               NOT ReservEntry.Positive
            THEN
              QtyBasePicked := QtyBasePicked + ABS(ReservEntry."Quantity (Base)");
          UNTIL ReservEntry.NEXT = 0;

        IF SNRequired OR LNRequired THEN BEGIN
          RegWhseActivLine.SETRANGE("Activity Type","Activity Type");
          RegWhseActivLine.SETRANGE("No.","No.");
          RegWhseActivLine.SETRANGE("Line No.","Line No.");
          RegWhseActivLine.SETRANGE("Lot No.","Lot No.");
          RegWhseActivLine.SETRANGE("Serial No.","Serial No.");
          RegWhseActivLine.SETRANGE("Bin Code","Bin Code");
          IF RegWhseActivLine.FINDSET THEN
            REPEAT
              QtyHandled := QtyHandled + RegWhseActivLine."Qty. (Base)";
            UNTIL RegWhseActivLine.NEXT = 0;
          QtyBasePicked := QtyBasePicked + QtyHandled;
        END ELSE
          QtyBasePicked := QtyBasePicked + "Qty. Handled (Base)";
      END;

      EXIT(QtyBasePicked);
    END;

    LOCAL PROCEDURE GetItem@23(ItemNo@1000 : Code[20]);
    BEGIN
      IF ItemNo <> Item."No." THEN
        Item.GET(ItemNo);
    END;

    LOCAL PROCEDURE UpdateTempTracking@31(WhseActivLine2@1000 : Record 5767;QtyToHandleBase@1002 : Decimal;VAR TempTrackingSpecification@1003 : TEMPORARY Record 336) : Boolean;
    VAR
      NextEntryNo@1004 : Integer;
      Inserted@1001 : Boolean;
    BEGIN
      WITH WhseActivLine2 DO BEGIN
        NextEntryNo := GetNextTempEntryNo(TempTrackingSpecification);
        TempTrackingSpecification.INIT;
        IF WhseActivLine."Source Type" = DATABASE::"Prod. Order Component" THEN
          TempTrackingSpecification.SetSource("Source Type","Source Subtype","Source No.","Source Subline No.",'',"Source Line No.")
        ELSE
          TempTrackingSpecification.SetSource("Source Type","Source Subtype","Source No.","Source Line No.",'',0);

        ItemTrackingMgt.SetPointerFilter(TempTrackingSpecification);
        TempTrackingSpecification.SetTrackingFilter("Serial No.","Lot No.");
        IF TempTrackingSpecification.ISEMPTY THEN BEGIN
          TempTrackingSpecification."Entry No." := NextEntryNo;
          TempTrackingSpecification."Creation Date" := TODAY;
          TempTrackingSpecification."Qty. to Handle (Base)" := QtyToHandleBase;
          TempTrackingSpecification."Item No." := "Item No.";
          TempTrackingSpecification."Variant Code" := "Variant Code";
          TempTrackingSpecification."Location Code" := "Location Code";
          TempTrackingSpecification.Description := Description;
          TempTrackingSpecification."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          TempTrackingSpecification.SetTracking("Serial No.","Lot No.","Warranty Date","Expiration Date");
          TempTrackingSpecification.Correction := TRUE;
          TempTrackingSpecification.INSERT;
          Inserted := TRUE;
          TempTrackingSpecification.RESET;
          OnAfterRegWhseItemTrkgLine(WhseActivLine2,TempTrackingSpecification);
        END;
      END;
      EXIT(Inserted);
    END;

    LOCAL PROCEDURE CheckItemTrackingInfoBlocked@25(ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];SerialNo@1002 : Code[20];LotNo@1003 : Code[20]);
    VAR
      SerialNoInfo@1004 : Record 6504;
      LotNoInfo@1005 : Record 6505;
    BEGIN
      IF (SerialNo = '') AND (LotNo = '') THEN
        EXIT;

      IF SerialNo <> '' THEN
        IF SerialNoInfo.GET(ItemNo,VariantCode,SerialNo) THEN
          SerialNoInfo.TESTFIELD(Blocked,FALSE);

      IF LotNo <> '' THEN
        IF LotNoInfo.GET(ItemNo,VariantCode,LotNo) THEN
          LotNoInfo.TESTFIELD(Blocked,FALSE);
    END;

    LOCAL PROCEDURE UpdateWindow@26(ControlNo@1001 : Integer;Value@1002 : Code[20]);
    BEGIN
      IF NOT HideDialog THEN
        CASE ControlNo OF
          1:
            BEGIN
              Window.OPEN(Text000 + Text001 + Text002);
              Window.UPDATE(1,Value);
            END;
          2:
            Window.UPDATE(2,LineCount);
          3:
            Window.UPDATE(3,LineCount);
          4:
            Window.UPDATE(4,ROUND(LineCount / NoOfRecords * 10000,1));
        END;
    END;

    LOCAL PROCEDURE CheckLines@29();
    BEGIN
      WITH WhseActivHeader DO BEGIN
        TempBinContentBuffer.DELETEALL;
        LineCount := 0;
        IF WhseActivLine.FIND('-') THEN
          REPEAT
            LineCount := LineCount + 1;
            UpdateWindow(2,'');
            WhseActivLine.CheckBinInSourceDoc;
            WhseActivLine.TESTFIELD("Item No.");
            IF (WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::Pick) AND
               (WhseActivLine."Destination Type" = WhseActivLine."Destination Type"::Customer)
            THEN BEGIN
              WhseActivLine.TESTFIELD("Destination No.");
              Cust.GET(WhseActivLine."Destination No.");
              Cust.CheckBlockedCustOnDocs(Cust,"Source Document",FALSE,FALSE);
            END;
            IF Location."Bin Mandatory" THEN BEGIN
              WhseActivLine.TESTFIELD("Unit of Measure Code");
              WhseActivLine.TESTFIELD("Bin Code");
              WhseActivLine.CheckWhseDocLine;
              UpdateTempBinContentBuffer(WhseActivLine);
            END;
            OnAfterCheckWhseActivLine(WhseActivLine);

            IF ((WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::Pick) OR
                (WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::"Invt. Pick") OR
                (WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::"Invt. Movement")) AND
               (WhseActivLine."Action Type" = WhseActivLine."Action Type"::Take)
            THEN
              CheckItemTrackingInfoBlocked(
                WhseActivLine."Item No.",WhseActivLine."Variant Code",WhseActivLine."Serial No.",WhseActivLine."Lot No.");
          UNTIL WhseActivLine.NEXT = 0;
        NoOfRecords := LineCount;

        IF Location."Bin Mandatory" THEN BEGIN
          CheckBinContent;
          CheckBin;
        END;

        IF "Registering No." = '' THEN BEGIN
          TESTFIELD("Registering No. Series");
          "Registering No." := NoSeriesMgt.GetNextNo("Registering No. Series","Assignment Date",TRUE);
          MODIFY;
          COMMIT;
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateSourceDocForInvtMovement@30(WhseActivityLine@1000 : Record 5767);
    BEGIN
      IF (WhseActivityLine."Action Type" = WhseActivityLine."Action Type"::Take) OR
         (WhseActivityLine."Source Document" = WhseActivityLine."Source Document"::" ")
      THEN
        EXIT;

      WITH WhseActivityLine DO
        CASE "Source Document" OF
          "Source Document"::"Prod. Consumption":
            BEGIN
              UpdateProdCompLine(
                "Source Subtype","Source No.","Source Line No.","Source Subline No.",
                "Qty. to Handle","Qty. to Handle (Base)","Qty. per Unit of Measure");
              RegisterWhseItemTrkgLine(WhseActivLine);
            END;
          "Source Document"::"Assembly Consumption":
            BEGIN
              UpdateAssemblyLine(
                "Source Subtype","Source No.","Source Line No.",
                "Qty. to Handle","Qty. to Handle (Base)","Qty. per Unit of Measure");
              RegisterWhseItemTrkgLine(WhseActivLine);
            END;
          ELSE
        END;
    END;

    LOCAL PROCEDURE GetNextTempEntryNo@37(VAR TempTrackingSpecification@1000 : TEMPORARY Record 336) : Integer;
    BEGIN
      TempTrackingSpecification.RESET;
      IF TempTrackingSpecification.FINDLAST THEN
        EXIT(TempTrackingSpecification."Entry No." + 1);

      EXIT(1);
    END;

    LOCAL PROCEDURE AutoReserveForSalesLine@38(VAR TempWhseActivLineToReserve@1003 : TEMPORARY Record 5767);
    VAR
      SalesLine@1002 : Record 37;
      ReservMgt@1001 : Codeunit 99000845;
      FullAutoReservation@1000 : Boolean;
    BEGIN
      IF TempWhseActivLineToReserve.FINDSET THEN
        REPEAT
          SalesLine.GET(
            SalesLine."Document Type"::Order,TempWhseActivLineToReserve."Source No.",TempWhseActivLineToReserve."Source Line No.");

          IF NOT IsSalesLineCompletelyReserved(
               SalesLine,TempWhseActivLineToReserve."Serial No.",TempWhseActivLineToReserve."Lot No.")
          THEN BEGIN
            ReservMgt.SetSalesLine(SalesLine);
            ReservMgt.SetSerialLotNo(TempWhseActivLineToReserve."Serial No.",TempWhseActivLineToReserve."Lot No.");
            ReservMgt.AutoReserve(
              FullAutoReservation,'',SalesLine."Shipment Date",TempWhseActivLineToReserve."Qty. to Handle",
              TempWhseActivLineToReserve."Qty. to Handle (Base)");
          END;
        UNTIL TempWhseActivLineToReserve.NEXT = 0;
    END;

    LOCAL PROCEDURE CopyWhseActivityLineToReservBuf@39(VAR TempWhseActivLineToReserve@1001 : TEMPORARY Record 5767;WhseActivLine@1000 : Record 5767);
    BEGIN
      IF NOT IsPickPlaceForSalesOrderTrackedItem(WhseActivLine) THEN
        EXIT;

      TempWhseActivLineToReserve.TRANSFERFIELDS(WhseActivLine);
      TempWhseActivLineToReserve.INSERT;
    END;

    LOCAL PROCEDURE ReleaseNonSpecificReservations@52(WhseActivLine@1005 : Record 5767;SNRequired@1004 : Boolean;LNRequired@1003 : Boolean;QtyToRelease@1000 : Decimal) : Boolean;
    VAR
      LateBindingMgt@1002 : Codeunit 6502;
      xReservedQty@1001 : Decimal;
    BEGIN
      IF QtyToRelease <= 0 THEN
        EXIT;

      CalcQtyReservedOnInventory(WhseActivLine,SNRequired,LNRequired);

      IF LNRequired OR SNRequired THEN
        IF Item."Reserved Qty. on Inventory" > 0 THEN BEGIN
          xReservedQty := Item."Reserved Qty. on Inventory";
          LateBindingMgt.ReleaseForReservation(
            WhseActivLine."Item No.",WhseActivLine."Variant Code",WhseActivLine."Location Code",
            WhseActivLine."Serial No.",WhseActivLine."Lot No.",QtyToRelease);
          Item.CALCFIELDS("Reserved Qty. on Inventory");
        END;

      EXIT(xReservedQty > Item."Reserved Qty. on Inventory");
    END;

    LOCAL PROCEDURE AvailabilityError@49(WhseActivLine@1000 : Record 5767);
    BEGIN
      IF WhseActivLine."Serial No." <> '' THEN
        ERROR(Text005,WhseActivLine.FIELDCAPTION("Serial No."),WhseActivLine."Serial No.");

      IF WhseActivLine."Lot No." <> '' THEN
        ERROR(Text005,WhseActivLine.FIELDCAPTION("Lot No."),WhseActivLine."Lot No.");
    END;

    LOCAL PROCEDURE IsPickPlaceForSalesOrderTrackedItem@44(WhseActivityLine@1000 : Record 5767) : Boolean;
    BEGIN
      EXIT(
        (WhseActivityLine."Activity Type" = WhseActivityLine."Activity Type"::Pick) AND
        (WhseActivityLine."Action Type" = WhseActivityLine."Action Type"::Place) AND
        (WhseActivityLine."Source Document" = WhseActivityLine."Source Document"::"Sales Order") AND
        ((WhseActivityLine."Serial No." <> '') OR (WhseActivityLine."Lot No." <> '')));
    END;

    LOCAL PROCEDURE IsSalesLineCompletelyReserved@41(SalesLine@1000 : Record 37;SerialNo@1001 : Code[20];LotNo@1002 : Code[20]) : Boolean;
    VAR
      ReservationEntry@1003 : Record 337;
    BEGIN
      ReservationEntry.SETRANGE("Source Type",DATABASE::"Sales Line");
      ReservationEntry.SETRANGE("Source Subtype",SalesLine."Document Type");
      ReservationEntry.SETRANGE("Source ID",SalesLine."Document No.");
      ReservationEntry.SETRANGE("Source Ref. No.",SalesLine."Line No.");
      ReservationEntry.SETRANGE("Serial No.",SerialNo);
      ReservationEntry.SETRANGE("Lot No.",LotNo);
      IF ReservationEntry.ISEMPTY THEN
        EXIT(FALSE);

      ReservationEntry.SETFILTER("Reservation Status",'<>%1',ReservationEntry."Reservation Status"::Reservation);
      EXIT(ReservationEntry.ISEMPTY);
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeWhseActivLineDelete@1001(VAR WarehouseActivityLine@1000 : Record 5767);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterWhseShptLineModify@1002(VAR WarehouseShipmentLine@1000 : Record 7321);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateRegActivLine@1003(VAR WarehouseActivityLine@1000 : Record 5767;VAR RegisteredWhseActivLine@1002 : Record 5773;VAR RegisteredInvtMovementLine@1001 : Record 7345);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAutofillQtyToHandle@1004(VAR WarehouseActivityLine@1000 : Record 5767);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCheckWhseActivLine@1005(VAR WarehouseActivityLine@1000 : Record 5767);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterRegWhseItemTrkgLine@45(VAR WhseActivLine2@1000 : Record 5767;VAR TempTrackingSpecification@1001 : TEMPORARY Record 336);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsRegWhseItemTrkgLine@43(VAR WhseActivLine2@1000 : Record 5767;VAR WhseItemTrkgLine@1001 : Record 6550);
    BEGIN
    END;

    BEGIN
    END.
  }
}

