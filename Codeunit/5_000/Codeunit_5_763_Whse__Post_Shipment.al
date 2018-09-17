OBJECT Codeunit 5763 Whse.-Post Shipment
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    TableNo=7321;
    Permissions=TableData 6550=r,
                TableData 7322=im,
                TableData 7323=i;
    OnRun=BEGIN
            OnBeforeRun(Rec);

            WhseShptLine.COPY(Rec);
            Code;
            Rec := WhseShptLine;

            OnAfterRun(Rec);
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Kildedokumentet %1 %2 er ikke frigivet.;ENU=The source document %1 %2 is not released.';
      Text001@1001 : TextConst 'DAN=Der er intet at bogf�re.;ENU=There is nothing to post.';
      Text003@1003 : TextConst 'DAN=Antal bogf�rte kildedokumenter: %1 ud af %2.;ENU=Number of source documents posted: %1 out of a total of %2.';
      Text004@1004 : TextConst 'DAN=Leveringslinjerne er blevet bogf�rt.;ENU=Ship lines have been posted.';
      Text005@1005 : TextConst 'DAN=Der findes stadig leveringslinjer.;ENU=Some ship lines remain.';
      WhseRqst@1006 : Record 5765;
      WhseShptHeader@1047 : Record 7320;
      WhseShptLine@1007 : Record 7321;
      WhseShptLineBuf@1041 : TEMPORARY Record 7321;
      SalesHeader@1010 : Record 36;
      PurchHeader@1009 : Record 38;
      TransHeader@1008 : Record 5740;
      ItemUnitOfMeasure@1086 : Record 5404;
      SalesShptHeader@1018 : Record 110;
      SalesInvHeader@1019 : Record 112;
      ReturnShptHeader@1020 : Record 6650;
      PurchCrMemHeader@1021 : Record 124;
      TransShptHeader@1022 : Record 5744;
      Location@1034 : Record 14;
      ServiceHeader@1002 : Record 5900;
      ServiceShptHeader@1023 : Record 5990;
      ServiceInvHeader@1013 : Record 5992;
      NoSeriesMgt@1014 : Codeunit 396;
      ItemTrackingMgt@1016 : Codeunit 6500;
      WhseJnlRegisterLine@1045 : Codeunit 7301;
      WMSMgt@1049 : Codeunit 7302;
      LastShptNo@1031 : Code[20];
      PostingDate@1048 : Date;
      CounterSourceDocOK@1039 : Integer;
      CounterSourceDocTotal@1040 : Integer;
      Print@1043 : Boolean;
      Invoice@1035 : Boolean;
      Text006@1015 : TextConst 'DAN=%1, %2 %3: du kan ikke levere mere, end der er blevet plukket til varesporingslinjerne.;ENU=%1, %2 %3: you cannot ship more than have been picked for the item tracking lines.';
      Text007@1102601000 : TextConst 'DAN=er ikke inden for den tilladte bogf�ringsperiode;ENU=is not within your range of allowed posting dates';
      InvoiceService@1012 : Boolean;
      FullATONotPostedErr@1011 : TextConst 'DAN=Lagerleverance %1, linjenr. %2 kan ikke bogf�res, da hele ordremontageantallet p� kildedokumentet skal leveres f�rst.;ENU=Warehouse shipment %1, Line No. %2 cannot be posted, because the full assemble-to-order quantity on the source document line must be shipped first.';

    LOCAL PROCEDURE Code@9();
    BEGIN
      WITH WhseShptLine DO BEGIN
        SETCURRENTKEY("No.");
        SETRANGE("No.","No.");
        SETFILTER("Qty. to Ship",'>0');
        IF FIND('-') THEN
          REPEAT
            TESTFIELD("Unit of Measure Code");
            IF "Shipping Advice" = "Shipping Advice"::Complete THEN
              TESTFIELD("Qty. (Base)","Qty. to Ship (Base)" + "Qty. Shipped (Base)");
            WhseRqst.GET(
              WhseRqst.Type::Outbound,"Location Code","Source Type","Source Subtype","Source No.");
            IF WhseRqst."Document Status" <> WhseRqst."Document Status"::Released THEN
              ERROR(Text000,"Source Document","Source No.");
            GetLocation("Location Code");
            IF Location."Require Pick" AND ("Shipping Advice" = "Shipping Advice"::Complete) THEN
              CheckItemTrkgPicked(WhseShptLine);
            IF Location."Bin Mandatory" THEN
              TESTFIELD("Bin Code");
            IF NOT "Assemble to Order" THEN
              IF NOT FullATOPosted THEN
                ERROR(FullATONotPostedErr,"No.","Line No.");

            OnAfterCheckWhseShptLine(WhseShptLine);
          UNTIL NEXT = 0
        ELSE
          ERROR(Text001);

        CounterSourceDocOK := 0;
        CounterSourceDocTotal := 0;

        GetLocation("Location Code");
        WhseShptHeader.GET("No.");
        WhseShptHeader.TESTFIELD("Posting Date");
        IF WhseShptHeader."Shipping No." = '' THEN BEGIN
          WhseShptHeader.TESTFIELD("Shipping No. Series");
          WhseShptHeader."Shipping No." :=
            NoSeriesMgt.GetNextNo(
              WhseShptHeader."Shipping No. Series",WhseShptHeader."Posting Date",TRUE);
        END;

        COMMIT;

        WhseShptHeader."Create Posted Header" := TRUE;
        WhseShptHeader.MODIFY;

        SETCURRENTKEY("No.","Source Type","Source Subtype","Source No.","Source Line No.");
        FINDSET(TRUE,TRUE);
        REPEAT
          SetSourceFilter("Source Type","Source Subtype","Source No.",-1,FALSE);
          GetSourceDocument;
          MakePreliminaryChecks;

          InitSourceDocumentLines(WhseShptLine);
          InitSourceDocumentHeader;
          COMMIT;

          CounterSourceDocTotal := CounterSourceDocTotal + 1;
          PostSourceDocument(WhseShptLine);

          IF FINDLAST THEN;
          SETRANGE("Source Type");
          SETRANGE("Source Subtype");
          SETRANGE("Source No.");
        UNTIL NEXT = 0;
      END;

      CLEAR(WMSMgt);
      CLEAR(WhseJnlRegisterLine);

      WhseShptLine.RESET;
    END;

    LOCAL PROCEDURE GetSourceDocument@19();
    BEGIN
      WITH WhseShptLine DO
        CASE "Source Type" OF
          DATABASE::"Sales Line":
            SalesHeader.GET("Source Subtype","Source No.");
          DATABASE::"Purchase Line": // Return Order
            PurchHeader.GET("Source Subtype","Source No.");
          DATABASE::"Transfer Line":
            TransHeader.GET("Source No.");
          DATABASE::"Service Line":
            ServiceHeader.GET("Source Subtype","Source No.");
        END;
    END;

    LOCAL PROCEDURE MakePreliminaryChecks@1102601000();
    VAR
      GenJnlCheckLine@1102601000 : Codeunit 11;
    BEGIN
      WITH WhseShptHeader DO BEGIN
        IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
          FIELDERROR("Posting Date",Text007);
      END;
    END;

    LOCAL PROCEDURE InitSourceDocumentHeader@2();
    VAR
      SalesRelease@1001 : Codeunit 414;
      PurchRelease@1002 : Codeunit 415;
      ReleaseServiceDocument@1003 : Codeunit 416;
      ModifyHeader@1000 : Boolean;
    BEGIN
      WITH WhseShptLine DO
        CASE "Source Type" OF
          DATABASE::"Sales Line":
            BEGIN
              IF (SalesHeader."Posting Date" = 0D) OR
                 (SalesHeader."Posting Date" <> WhseShptHeader."Posting Date")
              THEN BEGIN
                SalesRelease.Reopen(SalesHeader);
                SalesHeader.SetHideValidationDialog(TRUE);
                SalesHeader.VALIDATE("Posting Date",WhseShptHeader."Posting Date");
                SalesRelease.RUN(SalesHeader);
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipment Date" <> 0D) AND
                 (WhseShptHeader."Shipment Date" <> SalesHeader."Shipment Date")
              THEN BEGIN
                SalesHeader."Shipment Date" := WhseShptHeader."Shipment Date";
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."External Document No." <> '') AND
                 (WhseShptHeader."External Document No." <> SalesHeader."External Document No.")
              THEN BEGIN
                SalesHeader."External Document No." := WhseShptHeader."External Document No.";
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipping Agent Code" <> '') AND
                 (WhseShptHeader."Shipping Agent Code" <> SalesHeader."Shipping Agent Code")
              THEN BEGIN
                SalesHeader."Shipping Agent Code" := WhseShptHeader."Shipping Agent Code";
                SalesHeader."Shipping Agent Service Code" := WhseShptHeader."Shipping Agent Service Code";
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipping Agent Service Code" <> '') AND
                 (WhseShptHeader."Shipping Agent Service Code" <>
                  SalesHeader."Shipping Agent Service Code")
              THEN BEGIN
                SalesHeader."Shipping Agent Service Code" :=
                  WhseShptHeader."Shipping Agent Service Code";
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipment Method Code" <> '') AND
                 (WhseShptHeader."Shipment Method Code" <> SalesHeader."Shipment Method Code")
              THEN BEGIN
                SalesHeader."Shipment Method Code" := WhseShptHeader."Shipment Method Code";
                ModifyHeader := TRUE;
              END;
              IF ModifyHeader THEN
                SalesHeader.MODIFY;
            END;
          DATABASE::"Purchase Line": // Return Order
            BEGIN
              IF (PurchHeader."Posting Date" = 0D) OR
                 (PurchHeader."Posting Date" <> WhseShptHeader."Posting Date")
              THEN BEGIN
                PurchRelease.Reopen(PurchHeader);
                PurchHeader.SetHideValidationDialog(TRUE);
                PurchHeader.VALIDATE("Posting Date",WhseShptHeader."Posting Date");
                PurchRelease.RUN(PurchHeader);
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipment Date" <> 0D) AND
                 (WhseShptHeader."Shipment Date" <> PurchHeader."Expected Receipt Date")
              THEN BEGIN
                PurchHeader."Expected Receipt Date" := WhseShptHeader."Shipment Date";
                ModifyHeader := TRUE;
              END;
              IF WhseShptHeader."External Document No." <> '' THEN BEGIN
                PurchHeader."Vendor Authorization No." := WhseShptHeader."External Document No.";
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipment Method Code" <> '') AND
                 (WhseShptHeader."Shipment Method Code" <> PurchHeader."Shipment Method Code")
              THEN BEGIN
                PurchHeader."Shipment Method Code" := WhseShptHeader."Shipment Method Code";
                ModifyHeader := TRUE;
              END;
              IF ModifyHeader THEN
                PurchHeader.MODIFY;
            END;
          DATABASE::"Transfer Line":
            BEGIN
              IF (TransHeader."Posting Date" = 0D) OR
                 (TransHeader."Posting Date" <> WhseShptHeader."Posting Date")
              THEN BEGIN
                TransHeader.CalledFromWarehouse(TRUE);
                TransHeader.VALIDATE("Posting Date",WhseShptHeader."Posting Date");
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipment Date" <> 0D) AND
                 (TransHeader."Shipment Date" <> WhseShptHeader."Shipment Date")
              THEN BEGIN
                TransHeader."Shipment Date" := WhseShptHeader."Shipment Date";
                ModifyHeader := TRUE;
              END;
              IF WhseShptHeader."External Document No." <> '' THEN BEGIN
                TransHeader."External Document No." := WhseShptHeader."External Document No.";
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipping Agent Code" <> '') AND
                 (WhseShptHeader."Shipping Agent Code" <> TransHeader."Shipping Agent Code")
              THEN BEGIN
                TransHeader."Shipping Agent Code" := WhseShptHeader."Shipping Agent Code";
                TransHeader."Shipping Agent Service Code" := WhseShptHeader."Shipping Agent Service Code";
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipping Agent Service Code" <> '') AND
                 (WhseShptHeader."Shipping Agent Service Code" <>
                  TransHeader."Shipping Agent Service Code")
              THEN BEGIN
                TransHeader."Shipping Agent Service Code" :=
                  WhseShptHeader."Shipping Agent Service Code";
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipment Method Code" <> '') AND
                 (WhseShptHeader."Shipment Method Code" <> TransHeader."Shipment Method Code")
              THEN BEGIN
                TransHeader."Shipment Method Code" := WhseShptHeader."Shipment Method Code";
                ModifyHeader := TRUE;
              END;
              IF ModifyHeader THEN
                TransHeader.MODIFY;
            END;
          DATABASE::"Service Line":
            BEGIN
              IF (ServiceHeader."Posting Date" = 0D) OR (ServiceHeader."Posting Date" <> WhseShptHeader."Posting Date") THEN BEGIN
                ReleaseServiceDocument.Reopen(ServiceHeader);
                ServiceHeader.SetHideValidationDialog(TRUE);
                ServiceHeader.VALIDATE("Posting Date",WhseShptHeader."Posting Date");
                ReleaseServiceDocument.RUN(ServiceHeader);
                ServiceHeader.MODIFY;
              END;
              IF (WhseShptHeader."Shipping Agent Code" <> '') AND
                 (WhseShptHeader."Shipping Agent Code" <> ServiceHeader."Shipping Agent Code")
              THEN BEGIN
                ServiceHeader."Shipping Agent Code" := WhseShptHeader."Shipping Agent Code";
                ServiceHeader."Shipping Agent Service Code" := WhseShptHeader."Shipping Agent Service Code";
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipping Agent Service Code" <> '') AND
                 (WhseShptHeader."Shipping Agent Service Code" <> ServiceHeader."Shipping Agent Service Code")
              THEN BEGIN
                ServiceHeader."Shipping Agent Service Code" := WhseShptHeader."Shipping Agent Service Code";
                ModifyHeader := TRUE;
              END;
              IF (WhseShptHeader."Shipment Method Code" <> '') AND
                 (WhseShptHeader."Shipment Method Code" <> ServiceHeader."Shipment Method Code")
              THEN BEGIN
                ServiceHeader."Shipment Method Code" := WhseShptHeader."Shipment Method Code";
                ModifyHeader := TRUE;
              END;
              IF ModifyHeader THEN
                ServiceHeader.MODIFY;
            END;
        END;
    END;

    LOCAL PROCEDURE InitSourceDocumentLines@3(VAR WhseShptLine@1002 : Record 7321);
    VAR
      WhseShptLine2@1004 : Record 7321;
    BEGIN
      WhseShptLine2.COPY(WhseShptLine);
      CASE WhseShptLine2."Source Type" OF
        DATABASE::"Sales Line":
          HandleSalesLine(WhseShptLine2);
        DATABASE::"Purchase Line": // Return Order
          HandlePurchaseLine(WhseShptLine2);
        DATABASE::"Transfer Line":
          HandleTransferLine(WhseShptLine2);
        DATABASE::"Service Line":
          HandleServiceLine(WhseShptLine2);
      END;
      WhseShptLine2.SETRANGE("Source Line No.");
    END;

    LOCAL PROCEDURE PostSourceDocument@5(WhseShptLine@1000 : Record 7321);
    VAR
      WhseSetup@1005 : Record 5769;
      WhseShptHeader@1001 : Record 7320;
      SalesPost@1004 : Codeunit 80;
      PurchPost@1003 : Codeunit 90;
      TransferPostShipment@1002 : Codeunit 5704;
      ServicePost@1008 : Codeunit 5980;
    BEGIN
      WhseSetup.GET;
      WITH WhseShptLine DO BEGIN
        WhseShptHeader.GET("No.");
        CASE "Source Type" OF
          DATABASE::"Sales Line":
            BEGIN
              IF "Source Document" = "Source Document"::"Sales Order" THEN
                SalesHeader.Ship := TRUE
              ELSE
                SalesHeader.Receive := TRUE;
              SalesHeader.Invoice := Invoice;

              SalesPost.SetWhseShptHeader(WhseShptHeader);
              CASE WhseSetup."Shipment Posting Policy" OF
                WhseSetup."Shipment Posting Policy"::"Posting errors are not processed":
                  BEGIN
                    IF SalesPost.RUN(SalesHeader) THEN
                      CounterSourceDocOK := CounterSourceDocOK + 1;
                  END;
                WhseSetup."Shipment Posting Policy"::"Stop and show the first posting error":
                  BEGIN
                    SalesPost.RUN(SalesHeader);
                    CounterSourceDocOK := CounterSourceDocOK + 1;
                  END;
              END;

              IF Print THEN
                IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN
                  SalesShptHeader."No." := SalesHeader."Last Shipping No.";
                  SalesShptHeader.SETRECFILTER;
                  SalesShptHeader.PrintRecords(FALSE);
                  IF Invoice THEN BEGIN
                    SalesInvHeader."No." := SalesHeader."Last Posting No.";
                    SalesInvHeader.SETRECFILTER;
                    SalesInvHeader.PrintRecords(FALSE);
                  END;
                END;
              CLEAR(SalesPost);
            END;
          DATABASE::"Purchase Line": // Return Order
            BEGIN
              IF "Source Document" = "Source Document"::"Purchase Order" THEN
                PurchHeader.Receive := TRUE
              ELSE
                PurchHeader.Ship := TRUE;
              PurchHeader.Invoice := Invoice;

              PurchPost.SetWhseShptHeader(WhseShptHeader);
              CASE WhseSetup."Shipment Posting Policy" OF
                WhseSetup."Shipment Posting Policy"::"Posting errors are not processed":
                  BEGIN
                    IF PurchPost.RUN(PurchHeader) THEN
                      CounterSourceDocOK := CounterSourceDocOK + 1;
                  END;
                WhseSetup."Shipment Posting Policy"::"Stop and show the first posting error":
                  BEGIN
                    PurchPost.RUN(PurchHeader);
                    CounterSourceDocOK := CounterSourceDocOK + 1;
                  END;
              END;

              IF Print THEN
                IF "Source Document" = "Source Document"::"Purchase Return Order" THEN BEGIN
                  ReturnShptHeader."No." := PurchHeader."Last Return Shipment No.";
                  ReturnShptHeader.SETRECFILTER;
                  ReturnShptHeader.PrintRecords(FALSE);
                  IF Invoice THEN BEGIN
                    PurchCrMemHeader."No." := PurchHeader."Last Posting No.";
                    PurchCrMemHeader.SETRECFILTER;
                    PurchCrMemHeader.PrintRecords(FALSE);
                  END;
                END;
              CLEAR(PurchPost);
            END;
          DATABASE::"Transfer Line":
            BEGIN
              TransferPostShipment.SetWhseShptHeader(WhseShptHeader);
              CASE WhseSetup."Shipment Posting Policy" OF
                WhseSetup."Shipment Posting Policy"::"Posting errors are not processed":
                  BEGIN
                    IF TransferPostShipment.RUN(TransHeader) THEN
                      CounterSourceDocOK := CounterSourceDocOK + 1;
                  END;
                WhseSetup."Shipment Posting Policy"::"Stop and show the first posting error":
                  BEGIN
                    TransferPostShipment.RUN(TransHeader);
                    CounterSourceDocOK := CounterSourceDocOK + 1;
                  END;
              END;

              IF Print THEN BEGIN
                TransShptHeader."No." := TransHeader."Last Shipment No.";
                TransShptHeader.SETRECFILTER;
                TransShptHeader.PrintRecords(FALSE);
              END;
              CLEAR(TransferPostShipment);
            END;
          DATABASE::"Service Line":
            BEGIN
              ServicePost.SetPostingOptions(TRUE,FALSE,InvoiceService);
              CASE WhseSetup."Shipment Posting Policy" OF
                WhseSetup."Shipment Posting Policy"::"Posting errors are not processed":
                  BEGIN
                    IF ServicePost.RUN(ServiceHeader) THEN
                      CounterSourceDocOK := CounterSourceDocOK + 1;
                  END;
                WhseSetup."Shipment Posting Policy"::"Stop and show the first posting error":
                  BEGIN
                    ServicePost.RUN(ServiceHeader);
                    CounterSourceDocOK := CounterSourceDocOK + 1;
                  END;
              END;
              IF Print THEN
                IF "Source Document" = "Source Document"::"Service Order" THEN BEGIN
                  ServiceShptHeader."No." := ServiceHeader."Last Shipping No.";
                  ServiceShptHeader.SETRECFILTER;
                  ServiceShptHeader.PrintRecords(FALSE);
                  IF Invoice THEN BEGIN
                    ServiceInvHeader."No." := ServiceHeader."Last Posting No.";
                    ServiceInvHeader.SETRECFILTER;
                    ServiceInvHeader.PrintRecords(FALSE);
                  END;
                END;
              CLEAR(ServicePost);
            END;
        END;
      END;
    END;

    [External]
    PROCEDURE SetPrint@4(Print2@1000 : Boolean);
    BEGIN
      Print := Print2;
    END;

    [External]
    PROCEDURE PostUpdateWhseDocuments@14(VAR WhseShptHeaderParam@1000 : Record 7320);
    VAR
      WhseShptLine2@1003 : Record 7321;
    BEGIN
      WITH WhseShptLineBuf DO
        IF FIND('-') THEN BEGIN
          REPEAT
            WhseShptLine2.GET("No.","Line No.");
            IF "Qty. Outstanding" = "Qty. to Ship" THEN BEGIN
              ItemTrackingMgt.SetDeleteReservationEntries(TRUE);
              ItemTrackingMgt.DeleteWhseItemTrkgLines(
                DATABASE::"Warehouse Shipment Line",0,"No.",'',0,"Line No.","Location Code",TRUE);
              WhseShptLine2.DELETE;
            END ELSE BEGIN
              OnBeforePostUpdateWhseShptLine(WhseShptLine2);
              WhseShptLine2."Qty. Shipped" := "Qty. Shipped" + "Qty. to Ship";
              WhseShptLine2.VALIDATE("Qty. Outstanding","Qty. Outstanding" - "Qty. to Ship");
              WhseShptLine2."Qty. Shipped (Base)" := "Qty. Shipped (Base)" + "Qty. to Ship (Base)";
              WhseShptLine2."Qty. Outstanding (Base)" := "Qty. Outstanding (Base)" - "Qty. to Ship (Base)";
              WhseShptLine2.Status := WhseShptLine2.CalcStatusShptLine;
              WhseShptLine2.MODIFY;
              OnAfterPostUpdateWhseShptLine(WhseShptLine2);
            END;
          UNTIL NEXT = 0;
          DELETEALL;
        END;

      WhseShptLine2.SETRANGE("No.",WhseShptHeaderParam."No.");
      IF NOT WhseShptLine2.FINDFIRST THEN BEGIN
        WhseShptHeaderParam.DeleteRelatedLines;
        WhseShptHeaderParam.DELETE;
      END ELSE BEGIN
        WhseShptHeaderParam."Document Status" := WhseShptHeaderParam.GetDocumentStatus(0);
        IF WhseShptHeaderParam."Create Posted Header" THEN BEGIN
          WhseShptHeaderParam."Last Shipping No." := WhseShptHeaderParam."Shipping No.";
          WhseShptHeaderParam."Shipping No." := '';
          WhseShptHeaderParam."Create Posted Header" := FALSE;
        END;
        WhseShptHeaderParam.MODIFY;
      END;
    END;

    [External]
    PROCEDURE GetResultMessage@10();
    VAR
      MessageText@1000 : Text[250];
    BEGIN
      MessageText := Text003;
      IF CounterSourceDocOK > 0 THEN
        MessageText := MessageText + '\\' + Text004;
      IF CounterSourceDocOK < CounterSourceDocTotal THEN
        MessageText := MessageText + '\\' + Text005;
      MESSAGE(MessageText,CounterSourceDocOK,CounterSourceDocTotal);
    END;

    [External]
    PROCEDURE SetPostingSettings@1(PostInvoice@1001 : Boolean);
    BEGIN
      Invoice := PostInvoice;
      InvoiceService := PostInvoice;
    END;

    [External]
    PROCEDURE CreatePostedShptHeader@7(VAR PostedWhseShptHeader@1001 : Record 7322;VAR WhseShptHeader@1003 : Record 7320;LastShptNo2@1000 : Code[20];PostingDate2@1002 : Date);
    VAR
      WhseComment@1005 : Record 5770;
      WhseComment2@1004 : Record 5770;
    BEGIN
      LastShptNo := LastShptNo2;
      PostingDate := PostingDate2;

      IF NOT WhseShptHeader."Create Posted Header" THEN BEGIN
        PostedWhseShptHeader.GET(WhseShptHeader."Last Shipping No.");
        EXIT;
      END;

      PostedWhseShptHeader.INIT;
      PostedWhseShptHeader."No." := WhseShptHeader."Shipping No.";
      PostedWhseShptHeader."Location Code" := WhseShptHeader."Location Code";
      PostedWhseShptHeader."Assigned User ID" := WhseShptHeader."Assigned User ID";
      PostedWhseShptHeader."Assignment Date" := WhseShptHeader."Assignment Date";
      PostedWhseShptHeader."Assignment Time" := WhseShptHeader."Assignment Time";
      PostedWhseShptHeader."No. Series" := WhseShptHeader."Shipping No. Series";
      PostedWhseShptHeader."Bin Code" := WhseShptHeader."Bin Code";
      PostedWhseShptHeader."Zone Code" := WhseShptHeader."Zone Code";
      PostedWhseShptHeader."Posting Date" := WhseShptHeader."Posting Date";
      PostedWhseShptHeader."Shipment Date" := WhseShptHeader."Shipment Date";
      PostedWhseShptHeader."Shipping Agent Code" := WhseShptHeader."Shipping Agent Code";
      PostedWhseShptHeader."Shipping Agent Service Code" := WhseShptHeader."Shipping Agent Service Code";
      PostedWhseShptHeader."Shipment Method Code" := WhseShptHeader."Shipment Method Code";
      PostedWhseShptHeader.Comment := WhseShptHeader.Comment;
      PostedWhseShptHeader."Whse. Shipment No." := WhseShptHeader."No.";
      PostedWhseShptHeader."External Document No." := WhseShptHeader."External Document No.";
      PostedWhseShptHeader.INSERT;

      WhseComment.SETRANGE("Table Name",WhseComment."Table Name"::"Whse. Shipment");
      WhseComment.SETRANGE(Type,WhseComment.Type::" ");
      WhseComment.SETRANGE("No.",WhseShptHeader."No.");
      IF WhseComment.FIND('-') THEN
        REPEAT
          WhseComment2.INIT;
          WhseComment2 := WhseComment;
          WhseComment2."Table Name" := WhseComment2."Table Name"::"Posted Whse. Shipment";
          WhseComment2."No." := PostedWhseShptHeader."No.";
          WhseComment2.INSERT;
        UNTIL WhseComment.NEXT = 0;
    END;

    [External]
    PROCEDURE CreatePostedShptLine@48(VAR WhseShptLine@1000 : Record 7321;VAR PostedWhseShptHeader@1003 : Record 7322;VAR PostedWhseShptLine@1002 : Record 7323;VAR TempHandlingSpecification@1004 : Record 336);
    BEGIN
      UpdateWhseShptLineBuf(WhseShptLine);
      WITH PostedWhseShptLine DO BEGIN
        INIT;
        TRANSFERFIELDS(WhseShptLine);
        "No." := PostedWhseShptHeader."No.";
        Quantity := WhseShptLine."Qty. to Ship";
        "Qty. (Base)" := WhseShptLine."Qty. to Ship (Base)";
        IF WhseShptHeader."Shipment Date" <> 0D THEN
          "Shipment Date" := PostedWhseShptHeader."Shipment Date";
        "Source Type" := WhseShptLine."Source Type";
        "Source Subtype" := WhseShptLine."Source Subtype";
        "Source No." := WhseShptLine."Source No.";
        "Source Line No." := WhseShptLine."Source Line No.";
        "Source Document" := WhseShptLine."Source Document";
        CASE "Source Document" OF
          "Source Document"::"Purchase Order":
            "Posted Source Document" := "Posted Source Document"::"Posted Receipt";
          "Source Document"::"Service Order",
          "Source Document"::"Sales Order":
            "Posted Source Document" := "Posted Source Document"::"Posted Shipment";
          "Source Document"::"Purchase Return Order":
            "Posted Source Document" := "Posted Source Document"::"Posted Return Shipment";
          "Source Document"::"Sales Return Order":
            "Posted Source Document" := "Posted Source Document"::"Posted Return Receipt";
          "Source Document"::"Outbound Transfer":
            "Posted Source Document" := "Posted Source Document"::"Posted Transfer Shipment";
        END;
        "Posted Source No." := LastShptNo;
        "Posting Date" := PostingDate;
        "Whse. Shipment No." := WhseShptLine."No.";
        "Whse Shipment Line No." := WhseShptLine."Line No.";
        INSERT;
      END;

      PostWhseJnlLine(PostedWhseShptLine,TempHandlingSpecification);
      OnAfterPostWhseJnlLine(WhseShptLine);
    END;

    LOCAL PROCEDURE UpdateWhseShptLineBuf@16(WhseShptLine2@1000 : Record 7321);
    BEGIN
      WITH WhseShptLine2 DO BEGIN
        WhseShptLineBuf."No." := "No.";
        WhseShptLineBuf."Line No." := "Line No.";
        IF NOT WhseShptLineBuf.FIND THEN BEGIN
          WhseShptLineBuf.INIT;
          WhseShptLineBuf := WhseShptLine2;
          WhseShptLineBuf.INSERT;
        END;
      END;
    END;

    LOCAL PROCEDURE PostWhseJnlLine@12(VAR PostedWhseShptLine@1001 : Record 7323;VAR TempHandlingSpecification@1002 : Record 336);
    VAR
      TempWhseJnlLine@1004 : TEMPORARY Record 7311;
      TempWhseJnlLine2@1003 : TEMPORARY Record 7311;
    BEGIN
      GetLocation(PostedWhseShptLine."Location Code");
      IF Location."Bin Mandatory" THEN BEGIN
        CreateWhseJnlLine(TempWhseJnlLine,PostedWhseShptLine);
        WMSMgt.CheckWhseJnlLine(TempWhseJnlLine,0,0,FALSE);

        ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempHandlingSpecification,FALSE);
        IF TempWhseJnlLine2.FIND('-') THEN
          REPEAT
            WhseJnlRegisterLine.RUN(TempWhseJnlLine2);
          UNTIL TempWhseJnlLine2.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CreateWhseJnlLine@11(VAR WhseJnlLine@1002 : Record 7311;PostedWhseShptLine@1001 : Record 7323);
    VAR
      SourceCodeSetup@1000 : Record 242;
    BEGIN
      WITH PostedWhseShptLine DO BEGIN
        WhseJnlLine.INIT;
        WhseJnlLine."Entry Type" := WhseJnlLine."Entry Type"::"Negative Adjmt.";
        WhseJnlLine."Location Code" := "Location Code";
        WhseJnlLine."From Zone Code" := "Zone Code";
        WhseJnlLine."From Bin Code" := "Bin Code";
        WhseJnlLine."Item No." := "Item No.";
        WhseJnlLine.Description := Description;
        WhseJnlLine."Qty. (Absolute)" := Quantity;
        WhseJnlLine."Qty. (Absolute, Base)" := "Qty. (Base)";
        WhseJnlLine."User ID" := USERID;
        WhseJnlLine."Variant Code" := "Variant Code";
        WhseJnlLine."Unit of Measure Code" := "Unit of Measure Code";
        WhseJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
        WhseJnlLine.SetSource("Source Type","Source Subtype","Source No.","Source Line No.",0);
        WhseJnlLine."Source Document" := "Source Document";
        WhseJnlLine.SetWhseDoc(WhseJnlLine."Whse. Document Type"::Shipment,"No.","Line No.");
        GetItemUnitOfMeasure2("Item No.","Unit of Measure Code");
        WhseJnlLine.Cubage := WhseJnlLine."Qty. (Absolute)" * ItemUnitOfMeasure.Cubage;
        WhseJnlLine.Weight := WhseJnlLine."Qty. (Absolute)" * ItemUnitOfMeasure.Weight;
        WhseJnlLine."Reference No." := LastShptNo;
        WhseJnlLine."Registering Date" := PostingDate;
        WhseJnlLine."Registering No. Series" := WhseShptHeader."Shipping No. Series";
        SourceCodeSetup.GET;
        CASE "Source Document" OF
          "Source Document"::"Purchase Order":
            BEGIN
              WhseJnlLine."Source Code" := SourceCodeSetup.Purchases;
              WhseJnlLine."Reference Document" := WhseJnlLine."Reference Document"::"Posted Rcpt.";
            END;
          "Source Document"::"Sales Order":
            BEGIN
              WhseJnlLine."Source Code" := SourceCodeSetup.Sales;
              WhseJnlLine."Reference Document" := WhseJnlLine."Reference Document"::"Posted Shipment";
            END;
          "Source Document"::"Service Order":
            BEGIN
              WhseJnlLine."Source Code" := SourceCodeSetup."Service Management";
              WhseJnlLine."Reference Document" := WhseJnlLine."Reference Document"::"Posted Shipment";
            END;
          "Source Document"::"Purchase Return Order":
            BEGIN
              WhseJnlLine."Source Code" := SourceCodeSetup.Purchases;
              WhseJnlLine."Reference Document" := WhseJnlLine."Reference Document"::"Posted Rtrn. Shipment";
            END;
          "Source Document"::"Sales Return Order":
            BEGIN
              WhseJnlLine."Source Code" := SourceCodeSetup.Sales;
              WhseJnlLine."Reference Document" := WhseJnlLine."Reference Document"::"Posted Rtrn. Rcpt.";
            END;
          "Source Document"::"Outbound Transfer":
            BEGIN
              WhseJnlLine."Source Code" := SourceCodeSetup.Transfer;
              WhseJnlLine."Reference Document" := WhseJnlLine."Reference Document"::"Posted T. Shipment";
            END;
        END;
      END;
    END;

    LOCAL PROCEDURE GetItemUnitOfMeasure2@15(ItemNo@1000 : Code[20];UOMCode@1001 : Code[10]);
    BEGIN
      IF (ItemUnitOfMeasure."Item No." <> ItemNo) OR
         (ItemUnitOfMeasure.Code <> UOMCode)
      THEN
        IF NOT ItemUnitOfMeasure.GET(ItemNo,UOMCode) THEN
          ItemUnitOfMeasure.INIT;
    END;

    LOCAL PROCEDURE GetLocation@13(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        Location.INIT
      ELSE
        IF LocationCode <> Location.Code THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE CheckItemTrkgPicked@8(WhseShptLine@1000 : Record 7321);
    VAR
      ReservationEntry@1001 : Record 337;
      WhseItemTrkgLine@1002 : Record 6550;
      QtyPickedBase@1003 : Decimal;
      WhseSNRequired@1004 : Boolean;
      WhseLNRequired@1005 : Boolean;
    BEGIN
      IF WhseShptLine."Assemble to Order" THEN
        EXIT;
      ItemTrackingMgt.CheckWhseItemTrkgSetup(WhseShptLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
      IF NOT (WhseSNRequired OR WhseLNRequired) THEN
        EXIT;

      ReservationEntry.SetSourceFilter(
        WhseShptLine."Source Type",WhseShptLine."Source Subtype",WhseShptLine."Source No.",WhseShptLine."Source Line No.",TRUE);
      IF ReservationEntry.FIND('-') THEN
        REPEAT
          IF ReservationEntry.TrackingExists THEN BEGIN
            QtyPickedBase := 0;
            WhseItemTrkgLine.SETCURRENTKEY("Serial No.","Lot No.");
            WhseItemTrkgLine.SetTrackingFilter(ReservationEntry."Serial No.",ReservationEntry."Lot No.");
            WhseItemTrkgLine.SetSourceFilter(DATABASE::"Warehouse Shipment Line",-1,WhseShptLine."No.",WhseShptLine."Line No.",FALSE);
            IF WhseItemTrkgLine.FIND('-') THEN
              REPEAT
                QtyPickedBase := QtyPickedBase + WhseItemTrkgLine."Qty. Registered (Base)";
              UNTIL WhseItemTrkgLine.NEXT = 0;
            IF QtyPickedBase < ABS(ReservationEntry."Qty. to Handle (Base)") THEN
              ERROR(Text006,
                WhseShptLine."No.",WhseShptLine.FIELDCAPTION("Line No."),WhseShptLine."Line No.");
          END;
        UNTIL ReservationEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE HandleSalesLine@18(VAR WhseShptLine@1000 : Record 7321);
    VAR
      SalesLine@1001 : Record 37;
      ATOWhseShptLine@1008 : Record 7321;
      NonATOWhseShptLine@1009 : Record 7321;
      ATOLink@1003 : Record 904;
      AsmHeader@1004 : Record 900;
      ModifyLine@1002 : Boolean;
      ATOLineFound@1010 : Boolean;
      NonATOLineFound@1005 : Boolean;
      SumOfQtyToShip@1006 : Decimal;
      SumOfQtyToShipBase@1007 : Decimal;
    BEGIN
      WITH WhseShptLine DO BEGIN
        SalesLine.SETRANGE("Document Type","Source Subtype");
        SalesLine.SETRANGE("Document No.","Source No.");
        IF SalesLine.FIND('-') THEN
          REPEAT
            SETRANGE("Source Line No.",SalesLine."Line No.");
            IF FIND('-') THEN BEGIN
              IF "Source Document" = "Source Document"::"Sales Order" THEN BEGIN
                SumOfQtyToShip := 0;
                SumOfQtyToShipBase := 0;
                GetATOAndNonATOLines(ATOWhseShptLine,NonATOWhseShptLine,ATOLineFound,NonATOLineFound);
                IF ATOLineFound THEN BEGIN
                  SumOfQtyToShip += ATOWhseShptLine."Qty. to Ship";
                  SumOfQtyToShipBase += ATOWhseShptLine."Qty. to Ship (Base)";
                END;
                IF NonATOLineFound THEN BEGIN
                  SumOfQtyToShip += NonATOWhseShptLine."Qty. to Ship";
                  SumOfQtyToShipBase += NonATOWhseShptLine."Qty. to Ship (Base)";
                END;

                ModifyLine := SalesLine."Qty. to Ship" <> SumOfQtyToShip;
                IF ModifyLine THEN BEGIN
                  SalesLine.VALIDATE("Qty. to Ship",SumOfQtyToShip);
                  SalesLine."Qty. to Ship (Base)" := SumOfQtyToShipBase;
                  IF ATOLineFound THEN
                    ATOLink.UpdateQtyToAsmFromWhseShptLine(ATOWhseShptLine);
                  IF Invoice THEN
                    SalesLine.VALIDATE(
                      "Qty. to Invoice",
                      SalesLine."Qty. to Ship" + SalesLine."Quantity Shipped" - SalesLine."Quantity Invoiced");
                END;
              END ELSE BEGIN
                ModifyLine := SalesLine."Return Qty. to Receive" <> -"Qty. to Ship";
                IF ModifyLine THEN BEGIN
                  SalesLine.VALIDATE("Return Qty. to Receive",-"Qty. to Ship");
                  IF Invoice THEN
                    SalesLine.VALIDATE(
                      "Qty. to Invoice",
                      -"Qty. to Ship" + SalesLine."Return Qty. Received" - SalesLine."Quantity Invoiced");
                END;
              END;
              IF (WhseShptHeader."Shipment Date" <> 0D) AND
                 (SalesLine."Shipment Date" <> WhseShptHeader."Shipment Date") AND
                 ("Qty. to Ship" = "Qty. Outstanding")
              THEN BEGIN
                SalesLine."Shipment Date" := WhseShptHeader."Shipment Date";
                ModifyLine := TRUE;
                IF ATOLineFound THEN
                  IF AsmHeader.GET(ATOLink."Assembly Document Type",ATOLink."Assembly Document No.") THEN BEGIN
                    AsmHeader."Due Date" := WhseShptHeader."Shipment Date";
                    AsmHeader.MODIFY(TRUE);
                  END;
              END;
              IF SalesLine."Bin Code" <> "Bin Code" THEN BEGIN
                SalesLine."Bin Code" := "Bin Code";
                ModifyLine := TRUE;
                IF ATOLineFound THEN
                  ATOLink.UpdateAsmBinCodeFromWhseShptLine(ATOWhseShptLine);
              END;
            END ELSE BEGIN
              ModifyLine :=
                ((SalesHeader."Shipping Advice" <> SalesHeader."Shipping Advice"::Complete) OR
                 (SalesLine.Type = SalesLine.Type::Item)) AND
                ((SalesLine."Qty. to Ship" <> 0) OR
                 (SalesLine."Return Qty. to Receive" <> 0) OR
                 (SalesLine."Qty. to Invoice" <> 0));

              IF ModifyLine THEN BEGIN
                IF "Source Document" = "Source Document"::"Sales Order" THEN
                  SalesLine.VALIDATE("Qty. to Ship",0)
                ELSE
                  SalesLine.VALIDATE("Return Qty. to Receive",0);
                SalesLine.VALIDATE("Qty. to Invoice",0);
              END;
            END;
            IF ModifyLine THEN
              SalesLine.MODIFY;
          UNTIL SalesLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE HandlePurchaseLine@20(VAR WhseShptLine@1000 : Record 7321);
    VAR
      PurchLine@1002 : Record 39;
      ModifyLine@1001 : Boolean;
    BEGIN
      WITH WhseShptLine DO BEGIN
        PurchLine.SETRANGE("Document Type","Source Subtype");
        PurchLine.SETRANGE("Document No.","Source No.");
        IF PurchLine.FIND('-') THEN
          REPEAT
            SETRANGE("Source Line No.",PurchLine."Line No.");
            IF FIND('-') THEN BEGIN
              IF "Source Document" = "Source Document"::"Purchase Order" THEN BEGIN
                ModifyLine := PurchLine."Qty. to Receive" <> -"Qty. to Ship";
                IF ModifyLine THEN BEGIN
                  PurchLine.VALIDATE("Qty. to Receive",-"Qty. to Ship");
                  IF Invoice THEN
                    PurchLine.VALIDATE(
                      "Qty. to Invoice",
                      -"Qty. to Ship" + PurchLine."Quantity Received" - PurchLine."Quantity Invoiced");
                END;
              END ELSE BEGIN
                ModifyLine := PurchLine."Return Qty. to Ship" <> "Qty. to Ship";
                IF ModifyLine THEN BEGIN
                  PurchLine.VALIDATE("Return Qty. to Ship","Qty. to Ship");
                  IF Invoice THEN
                    PurchLine.VALIDATE(
                      "Qty. to Invoice",
                      "Qty. to Ship" + PurchLine."Return Qty. Shipped" - PurchLine."Quantity Invoiced");
                END;
              END;
              IF (WhseShptHeader."Shipment Date" <> 0D) AND
                 (PurchLine."Expected Receipt Date" <> WhseShptHeader."Shipment Date") AND
                 ("Qty. to Ship" = "Qty. Outstanding")
              THEN BEGIN
                PurchLine."Expected Receipt Date" := WhseShptHeader."Shipment Date";
                ModifyLine := TRUE;
              END;
              IF PurchLine."Bin Code" <> "Bin Code" THEN BEGIN
                PurchLine."Bin Code" := "Bin Code";
                ModifyLine := TRUE;
              END;
            END ELSE BEGIN
              ModifyLine :=
                (PurchLine."Qty. to Receive" <> 0) OR
                (PurchLine."Return Qty. to Ship" <> 0) OR
                (PurchLine."Qty. to Invoice" <> 0);
              IF ModifyLine THEN BEGIN
                IF "Source Document" = "Source Document"::"Purchase Order" THEN
                  PurchLine.VALIDATE("Qty. to Receive",0)
                ELSE
                  PurchLine.VALIDATE("Return Qty. to Ship",0);
                PurchLine.VALIDATE("Qty. to Invoice",0);
              END;
            END;
            IF ModifyLine THEN
              PurchLine.MODIFY;
          UNTIL PurchLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE HandleTransferLine@24(VAR WhseShptLine@1000 : Record 7321);
    VAR
      TransLine@1001 : Record 5741;
      ModifyLine@1002 : Boolean;
    BEGIN
      WITH WhseShptLine DO BEGIN
        TransLine.SETRANGE("Document No.","Source No.");
        TransLine.SETRANGE("Derived From Line No.",0);
        IF TransLine.FIND('-') THEN
          REPEAT
            SETRANGE("Source Line No.",TransLine."Line No.");
            IF FIND('-') THEN BEGIN
              ModifyLine := TransLine."Qty. to Ship" <> "Qty. to Ship";
              IF ModifyLine THEN
                TransLine.VALIDATE("Qty. to Ship","Qty. to Ship");
              IF (WhseShptHeader."Shipment Date" <> 0D) AND
                 (TransLine."Shipment Date" <> WhseShptHeader."Shipment Date") AND
                 ("Qty. to Ship" = "Qty. Outstanding")
              THEN BEGIN
                TransLine."Shipment Date" := WhseShptHeader."Shipment Date";
                ModifyLine := TRUE;
              END;
              IF TransLine."Transfer-from Bin Code" <> "Bin Code" THEN BEGIN
                TransLine."Transfer-from Bin Code" := "Bin Code";
                ModifyLine := TRUE;
              END;
            END ELSE BEGIN
              ModifyLine := TransLine."Qty. to Ship" <> 0;
              IF ModifyLine THEN BEGIN
                TransLine.VALIDATE("Qty. to Ship",0);
                TransLine.VALIDATE("Qty. to Receive",0);
              END;
            END;
            IF ModifyLine THEN
              TransLine.MODIFY;
          UNTIL TransLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE HandleServiceLine@28(VAR WhseShptLine@1000 : Record 7321);
    VAR
      ServLine@1001 : Record 5902;
      ModifyLine@1002 : Boolean;
    BEGIN
      WITH WhseShptLine DO BEGIN
        ServLine.SETRANGE("Document Type","Source Subtype");
        ServLine.SETRANGE("Document No.","Source No.");
        IF ServLine.FIND('-') THEN
          REPEAT
            SETRANGE("Source Line No.",ServLine."Line No.");  // Whse Shipment Line
            IF FIND('-') THEN BEGIN   // Whse Shipment Line
              IF "Source Document" = "Source Document"::"Service Order" THEN BEGIN
                ModifyLine := ServLine."Qty. to Ship" <> "Qty. to Ship";
                IF ModifyLine THEN BEGIN
                  ServLine.VALIDATE("Qty. to Ship","Qty. to Ship");
                  ServLine."Qty. to Ship (Base)" := "Qty. to Ship (Base)";
                  IF InvoiceService THEN BEGIN
                    ServLine.VALIDATE("Qty. to Consume",0);
                    ServLine.VALIDATE(
                      "Qty. to Invoice",
                      "Qty. to Ship" + ServLine."Quantity Shipped" - ServLine."Quantity Invoiced" -
                      ServLine."Quantity Consumed");
                  END;
                END;
              END;
              IF ServLine."Bin Code" <> "Bin Code" THEN BEGIN
                ServLine."Bin Code" := "Bin Code";
                ModifyLine := TRUE;
              END;
            END ELSE BEGIN
              ModifyLine :=
                ((ServiceHeader."Shipping Advice" <> ServiceHeader."Shipping Advice"::Complete) OR
                 (ServLine.Type = ServLine.Type::Item)) AND
                ((ServLine."Qty. to Ship" <> 0) OR
                 (ServLine."Qty. to Consume" <> 0) OR
                 (ServLine."Qty. to Invoice" <> 0));

              IF ModifyLine THEN BEGIN
                IF "Source Document" = "Source Document"::"Service Order" THEN
                  ServLine.VALIDATE("Qty. to Ship",0);
                ServLine.VALIDATE("Qty. to Invoice",0);
                ServLine.VALIDATE("Qty. to Consume",0);
              END;
            END;
            IF ModifyLine THEN
              ServLine.MODIFY;
          UNTIL ServLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE SetWhseJnlRegisterCU@26(VAR NewWhseJnlRegisterLine@1000 : Codeunit 7301);
    BEGIN
      WhseJnlRegisterLine := NewWhseJnlRegisterLine;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterRun@17(VAR WarehouseShipmentLine@1000 : Record 7321);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeRun@6(VAR WarehouseShipmentLine@1000 : Record 7321);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCheckWhseShptLine@27(VAR WarehouseShipmentLine@1000 : Record 7321);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostUpdateWhseShptLine@32(VAR WarehouseShipmentLine@1000 : Record 7321);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostUpdateWhseShptLine@29(VAR WarehouseShipmentLine@1000 : Record 7321);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostWhseJnlLine@31(VAR WarehouseShipmentLine@1000 : Record 7321);
    BEGIN
    END;

    BEGIN
    END.
  }
}

