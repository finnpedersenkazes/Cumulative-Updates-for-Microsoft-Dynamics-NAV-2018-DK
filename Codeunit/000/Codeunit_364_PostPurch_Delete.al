OBJECT Codeunit 364 PostPurch-Delete
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    Permissions=TableData 120=i,
                TableData 121=rid,
                TableData 122=ri,
                TableData 123=rid,
                TableData 124=i,
                TableData 125=rid,
                TableData 6650=i,
                TableData 6651=rid;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ItemTrackingMgt@1004 : Codeunit 6500;
      MoveEntries@1005 : Codeunit 361;
      DocumentDeletionErr@1006 : TextConst '@@@=%1 - Posting Date;DAN=Du kan ikke slette bogf›rte k›bsdokumenter, der er bogf›rt efter %1. \\Datoen er defineret af feltet Tillad sletning af dokument f›r i vinduet Ops‘tning af K›b.;ENU=You cannot delete posted purchase documents that are posted after %1. \\The date is defined by the Allow Document Deletion Before field in the Purchases & Payables Setup window.';

    [External]
    PROCEDURE DeleteHeader@18(PurchHeader@1000 : Record 38;VAR PurchRcptHeader@1001 : Record 120;VAR PurchInvHeader@1002 : Record 122;VAR PurchCrMemoHdr@1003 : Record 124;VAR ReturnShptHeader@1004 : Record 6650;VAR PurchInvHeaderPrepmt@1006 : Record 122;VAR PurchCrMemoHdrPrepmt@1005 : Record 124);
    VAR
      PurchInvLine@1007 : Record 123;
      PurchCrMemoLine@1008 : Record 125;
      PurchRcptLine@1009 : Record 121;
      ReturnShptLine@1012 : Record 6651;
      SourceCode@1010 : Record 230;
      SourceCodeSetup@1011 : Record 242;
    BEGIN
      WITH PurchHeader DO BEGIN
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD("Deleted Document");
        SourceCode.GET(SourceCodeSetup."Deleted Document");

        InitDeleteHeader(
          PurchHeader,PurchRcptHeader,PurchInvHeader,PurchCrMemoHdr,
          ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHdrPrepmt,SourceCode.Code);
        IF PurchRcptHeader."No." <> '' THEN BEGIN
          PurchRcptHeader.INSERT;
          PurchRcptLine.INIT;
          PurchRcptLine."Document No." := PurchRcptHeader."No.";
          PurchRcptLine."Line No." := 10000;
          PurchRcptLine.Description := SourceCode.Description;
          PurchRcptLine.INSERT;
        END;

        IF ReturnShptHeader."No." <> '' THEN BEGIN
          ReturnShptHeader.INSERT;
          ReturnShptLine.INIT;
          ReturnShptLine."Document No." := ReturnShptHeader."No.";
          ReturnShptLine."Line No." := 10000;
          ReturnShptLine.Description := SourceCode.Description;
          ReturnShptLine.INSERT;
        END;

        IF PurchInvHeader."No." <> '' THEN BEGIN
          PurchInvHeader.INSERT;
          PurchInvLine.INIT;
          PurchInvLine."Document No." := PurchInvHeader."No.";
          PurchInvLine."Line No." := 10000;
          PurchInvLine.Description := SourceCode.Description;
          PurchInvLine.INSERT;
        END;

        IF PurchCrMemoHdr."No." <> '' THEN BEGIN
          PurchCrMemoHdr.INSERT(TRUE);
          PurchCrMemoLine.INIT;
          PurchCrMemoLine."Document No." := PurchCrMemoHdr."No.";
          PurchCrMemoLine."Line No." := 10000;
          PurchCrMemoLine.Description := SourceCode.Description;
          PurchCrMemoLine.INSERT;
        END;

        IF PurchInvHeaderPrepmt."No." <> '' THEN BEGIN
          PurchInvHeaderPrepmt.INSERT;
          PurchInvLine."Document No." := PurchInvHeaderPrepmt."No.";
          PurchInvLine."Line No." := 10000;
          PurchInvLine.Description := SourceCode.Description;
          PurchInvLine.INSERT;
        END;

        IF PurchCrMemoHdrPrepmt."No." <> '' THEN BEGIN
          PurchCrMemoHdrPrepmt.INSERT;
          PurchCrMemoLine.INIT;
          PurchCrMemoLine."Document No." := PurchCrMemoHdrPrepmt."No.";
          PurchCrMemoLine."Line No." := 10000;
          PurchCrMemoLine.Description := SourceCode.Description;
          PurchCrMemoLine.INSERT;
        END;
      END;
    END;

    [External]
    PROCEDURE DeletePurchRcptLines@1(PurchRcptHeader@1000 : Record 120);
    VAR
      PurchRcptLine@1001 : Record 121;
    BEGIN
      PurchRcptLine.SETRANGE("Document No.",PurchRcptHeader."No.");
      IF PurchRcptLine.FIND('-') THEN
        REPEAT
          PurchRcptLine.TESTFIELD("Quantity Invoiced",PurchRcptLine.Quantity);
          PurchRcptLine.DELETE;
        UNTIL PurchRcptLine.NEXT = 0;
      ItemTrackingMgt.DeleteItemEntryRelation(
        DATABASE::"Purch. Rcpt. Line",0,PurchRcptHeader."No.",'',0,0,TRUE);

      MoveEntries.MoveDocRelatedEntries(DATABASE::"Purch. Rcpt. Header",PurchRcptHeader."No.");
    END;

    [External]
    PROCEDURE DeletePurchInvLines@2(PurchInvHeader@1000 : Record 122);
    VAR
      PurchInvLine@1001 : Record 123;
    BEGIN
      PurchInvLine.SETRANGE("Document No.",PurchInvHeader."No.");
      IF PurchInvLine.FIND('-') THEN
        REPEAT
          PurchInvLine.DELETE;
          ItemTrackingMgt.DeleteValueEntryRelation(PurchInvLine.RowID1);
        UNTIL PurchInvLine.NEXT = 0;

      MoveEntries.MoveDocRelatedEntries(DATABASE::"Purch. Inv. Header",PurchInvHeader."No.");
    END;

    [External]
    PROCEDURE DeletePurchCrMemoLines@3(PurchCrMemoHeader@1000 : Record 124);
    VAR
      PurchCrMemoLine@1001 : Record 125;
    BEGIN
      PurchCrMemoLine.SETRANGE("Document No.",PurchCrMemoHeader."No.");
      IF PurchCrMemoLine.FIND('-') THEN
        REPEAT
          PurchCrMemoLine.DELETE;
        UNTIL PurchCrMemoLine.NEXT = 0;
      ItemTrackingMgt.DeleteItemEntryRelation(
        DATABASE::"Purch. Cr. Memo Line",0,PurchCrMemoHeader."No.",'',0,0,TRUE);

      MoveEntries.MoveDocRelatedEntries(DATABASE::"Purch. Cr. Memo Hdr.",PurchCrMemoHeader."No.");
    END;

    [External]
    PROCEDURE DeletePurchShptLines@5800(ReturnShptHeader@1000 : Record 6650);
    VAR
      ReturnShipmentLine@1001 : Record 6651;
    BEGIN
      ReturnShipmentLine.SETRANGE("Document No.",ReturnShptHeader."No.");
      IF ReturnShipmentLine.FIND('-') THEN
        REPEAT
          ReturnShipmentLine.TESTFIELD("Quantity Invoiced",ReturnShipmentLine.Quantity);
          ReturnShipmentLine.DELETE;
        UNTIL ReturnShipmentLine.NEXT = 0;
      ItemTrackingMgt.DeleteItemEntryRelation(
        DATABASE::"Return Shipment Line",0,ReturnShptHeader."No.",'',0,0,TRUE);

      MoveEntries.MoveDocRelatedEntries(DATABASE::"Return Shipment Header",ReturnShptHeader."No.");
    END;

    [External]
    PROCEDURE InitDeleteHeader@19(PurchHeader@1000 : Record 38;VAR PurchRcptHeader@1001 : Record 120;VAR PurchInvHeader@1002 : Record 122;VAR PurchCrMemoHdr@1003 : Record 124;VAR ReturnShptHeader@1004 : Record 6650;VAR PurchInvHeaderPrepmt@1006 : Record 122;VAR PurchCrMemoHdrPrepmt@1005 : Record 124;SourceCode@1008 : Code[10]);
    VAR
      PurchSetup@1007 : Record 312;
    BEGIN
      WITH PurchHeader DO BEGIN
        CLEAR(PurchRcptHeader);
        CLEAR(PurchInvHeader);
        CLEAR(PurchCrMemoHdr);
        CLEAR(ReturnShptHeader);
        PurchSetup.GET;

        IF ("Receiving No. Series" <> '') AND ("Receiving No." <> '') THEN BEGIN
          PurchRcptHeader.TRANSFERFIELDS(PurchHeader);
          PurchRcptHeader."No." := "Receiving No.";
          PurchRcptHeader."Posting Date" := TODAY;
          PurchRcptHeader."User ID" := USERID;
          PurchRcptHeader."Source Code" := SourceCode;
        END;

        IF ("Return Shipment No. Series" <> '') AND ("Return Shipment No." <> '') THEN BEGIN
          ReturnShptHeader.TRANSFERFIELDS(PurchHeader);
          ReturnShptHeader."No." := "Return Shipment No.";
          ReturnShptHeader."Posting Date" := TODAY;
          ReturnShptHeader."User ID" := USERID;
          ReturnShptHeader."Source Code" := SourceCode;
        END;

        IF ("Posting No. Series" <> '') AND
           (("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
            ("Posting No." <> '') OR
            ("Document Type" = "Document Type"::Invoice) AND
            ("No. Series" = "Posting No. Series"))
        THEN BEGIN
          PurchInvHeader.TRANSFERFIELDS(PurchHeader);
          IF "Posting No." <> '' THEN
            PurchInvHeader."No." := "Posting No.";
          IF "Document Type" = "Document Type"::Invoice THEN BEGIN
            PurchInvHeader."Pre-Assigned No. Series" := "No. Series";
            PurchInvHeader."Pre-Assigned No." := "No.";
          END ELSE BEGIN
            PurchInvHeader."Pre-Assigned No. Series" := '';
            PurchInvHeader."Pre-Assigned No." := '';
            PurchInvHeader."Order No. Series" := "No. Series";
            PurchInvHeader."Order No." := "No.";
          END;
          PurchInvHeader."Posting Date" := TODAY;
          PurchInvHeader."User ID" := USERID;
          PurchInvHeader."Source Code" := SourceCode;
        END;

        IF ("Posting No. Series" <> '') AND
           (("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
            ("Posting No." <> '') OR
            ("Document Type" = "Document Type"::"Credit Memo") AND
            ("No. Series" = "Posting No. Series"))
        THEN BEGIN
          PurchCrMemoHdr.TRANSFERFIELDS(PurchHeader);
          IF "Posting No." <> '' THEN
            PurchCrMemoHdr."No." := "Posting No.";
          PurchCrMemoHdr."Pre-Assigned No. Series" := "No. Series";
          PurchCrMemoHdr."Pre-Assigned No." := "No.";
          PurchCrMemoHdr."Posting Date" := TODAY;
          PurchCrMemoHdr."User ID" := USERID;
          PurchCrMemoHdr."Source Code" := SourceCode;
        END;

        IF ("Prepayment No. Series" <> '') AND ("Prepayment No." <> '') THEN BEGIN
          TESTFIELD("Document Type","Document Type"::Order);
          PurchInvHeaderPrepmt.TRANSFERFIELDS(PurchHeader);
          PurchInvHeaderPrepmt."No." := "Prepayment No.";
          PurchInvHeaderPrepmt."Order No. Series" := "No. Series";
          PurchInvHeaderPrepmt."Prepayment Order No." := "No.";
          PurchInvHeaderPrepmt."Posting Date" := TODAY;
          PurchInvHeaderPrepmt."Pre-Assigned No. Series" := '';
          PurchInvHeaderPrepmt."Pre-Assigned No." := '';
          PurchInvHeaderPrepmt."User ID" := USERID;
          PurchInvHeaderPrepmt."Source Code" := SourceCode;
          PurchInvHeaderPrepmt."Prepayment Invoice" := TRUE;
        END;

        IF ("Prepmt. Cr. Memo No. Series" <> '') AND ("Prepmt. Cr. Memo No." <> '') THEN BEGIN
          TESTFIELD("Document Type","Document Type"::Order);
          PurchCrMemoHdrPrepmt.TRANSFERFIELDS(PurchHeader);
          PurchCrMemoHdrPrepmt."No." := "Prepmt. Cr. Memo No.";
          PurchCrMemoHdrPrepmt."Prepayment Order No." := "No.";
          PurchCrMemoHdrPrepmt."Posting Date" := TODAY;
          PurchCrMemoHdrPrepmt."Pre-Assigned No. Series" := '';
          PurchCrMemoHdrPrepmt."Pre-Assigned No." := '';
          PurchCrMemoHdrPrepmt."User ID" := USERID;
          PurchCrMemoHdrPrepmt."Source Code" := SourceCode;
          PurchCrMemoHdrPrepmt."Prepayment Credit Memo" := TRUE;
        END;
      END;
    END;

    [External]
    PROCEDURE IsDocumentDeletionAllowed@4(PostingDate@1001 : Date);
    VAR
      PurchSetup@1000 : Record 312;
    BEGIN
      PurchSetup.GET;
      PurchSetup.TESTFIELD("Allow Document Deletion Before");
      IF PostingDate >= PurchSetup."Allow Document Deletion Before" THEN
        ERROR(STRSUBSTNO(DocumentDeletionErr,PurchSetup."Allow Document Deletion Before"));
    END;

    BEGIN
    END.
  }
}

