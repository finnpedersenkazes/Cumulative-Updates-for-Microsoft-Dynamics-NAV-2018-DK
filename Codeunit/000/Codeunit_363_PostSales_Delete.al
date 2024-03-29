OBJECT Codeunit 363 PostSales-Delete
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    Permissions=TableData 110=i,
                TableData 111=rid,
                TableData 112=i,
                TableData 113=rid,
                TableData 114=i,
                TableData 115=rid,
                TableData 6660=i,
                TableData 6661=rid;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      SalesShptLine@1000 : Record 111;
      SalesInvLine@1001 : Record 113;
      SalesCrMemoLine@1002 : Record 115;
      SalesRcptLine@1003 : Record 6661;
      ItemTrackingMgt@1004 : Codeunit 6500;
      MoveEntries@1005 : Codeunit 361;
      DocumentDeletionErr@1006 : TextConst '@@@=%1 - Posting Date;DAN=Du kan ikke slette bogf�rte salgsdokumenter, der er bogf�rt efter %1. \\Datoen er defineret af feltet Tillad sletning af dokument f�r i vinduet Ops�tning af Salg.;ENU=You cannot delete posted sales documents that are posted after %1. \\The date is defined by the Allow Document Deletion Before field in the Sales & Receivables Setup window.';

    [External]
    PROCEDURE DeleteHeader@18(SalesHeader@1000 : Record 36;VAR SalesShptHeader@1001 : Record 110;VAR SalesInvHeader@1002 : Record 112;VAR SalesCrMemoHeader@1003 : Record 114;VAR ReturnRcptHeader@1004 : Record 6660;VAR SalesInvHeaderPrePmt@1006 : Record 112;VAR SalesCrMemoHeaderPrePmt@1005 : Record 114);
    VAR
      SalesInvLine@1007 : Record 113;
      SalesCrMemoLine@1008 : Record 115;
      SalesShptLine@1009 : Record 111;
      ReturnRcptLine@1010 : Record 6661;
      SourceCode@1011 : Record 230;
      SourceCodeSetup@1012 : Record 242;
    BEGIN
      WITH SalesHeader DO BEGIN
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD("Deleted Document");
        SourceCode.GET(SourceCodeSetup."Deleted Document");

        InitDeleteHeader(
          SalesHeader,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,
          ReturnRcptHeader,SalesInvHeaderPrePmt,SalesCrMemoHeaderPrePmt,SourceCode.Code);

        IF SalesShptHeader."No." <> '' THEN BEGIN
          SalesShptHeader.INSERT;
          SalesShptLine.INIT;
          SalesShptLine."Document No." := SalesShptHeader."No.";
          SalesShptLine."Line No." := 10000;
          SalesShptLine.Description := SourceCode.Description;
          SalesShptLine.INSERT;
        END;

        IF ReturnRcptHeader."No." <> '' THEN BEGIN
          ReturnRcptHeader.INSERT;
          ReturnRcptLine.INIT;
          ReturnRcptLine."Document No." := ReturnRcptHeader."No.";
          ReturnRcptLine."Line No." := 10000;
          ReturnRcptLine.Description := SourceCode.Description;
          ReturnRcptLine.INSERT;
        END;

        IF SalesInvHeader."No." <> '' THEN BEGIN
          SalesInvHeader.INSERT;
          SalesInvLine.INIT;
          SalesInvLine."Document No." := SalesInvHeader."No.";
          SalesInvLine."Line No." := 10000;
          SalesInvLine.Description := SourceCode.Description;
          SalesInvLine.INSERT;
        END;

        IF SalesCrMemoHeader."No." <> '' THEN BEGIN
          SalesCrMemoHeader.INSERT;
          SalesCrMemoLine.INIT;
          SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
          SalesCrMemoLine."Line No." := 10000;
          SalesCrMemoLine.Description := SourceCode.Description;
          SalesCrMemoLine.INSERT;
        END;

        IF SalesInvHeaderPrePmt."No." <> '' THEN BEGIN
          SalesInvHeaderPrePmt.INSERT;
          SalesInvLine."Document No." := SalesInvHeaderPrePmt."No.";
          SalesInvLine."Line No." := 10000;
          SalesInvLine.Description := SourceCode.Description;
          SalesInvLine.INSERT;
        END;

        IF SalesCrMemoHeaderPrePmt."No." <> '' THEN BEGIN
          SalesCrMemoHeaderPrePmt.INSERT;
          SalesCrMemoLine.INIT;
          SalesCrMemoLine."Document No." := SalesCrMemoHeaderPrePmt."No.";
          SalesCrMemoLine."Line No." := 10000;
          SalesCrMemoLine.Description := SourceCode.Description;
          SalesCrMemoLine.INSERT;
        END;
      END;
    END;

    [External]
    PROCEDURE DeleteSalesShptLines@1(SalesShptHeader@1000 : Record 110);
    BEGIN
      SalesShptLine.SETRANGE("Document No.",SalesShptHeader."No.");
      IF SalesShptLine.FIND('-') THEN
        REPEAT
          SalesShptLine.TESTFIELD("Quantity Invoiced",SalesShptLine.Quantity);
          SalesShptLine.DELETE(TRUE);
        UNTIL SalesShptLine.NEXT = 0;
      ItemTrackingMgt.DeleteItemEntryRelation(
        DATABASE::"Sales Shipment Line",0,SalesShptHeader."No.",'',0,0,TRUE);

      MoveEntries.MoveDocRelatedEntries(DATABASE::"Sales Shipment Header",SalesShptHeader."No.");
    END;

    [External]
    PROCEDURE DeleteSalesInvLines@2(SalesInvHeader@1000 : Record 112);
    BEGIN
      SalesInvLine.SETRANGE("Document No.",SalesInvHeader."No.");
      IF SalesInvLine.FIND('-') THEN
        REPEAT
          SalesInvLine.DELETE;
          ItemTrackingMgt.DeleteValueEntryRelation(SalesInvLine.RowID1);
        UNTIL SalesInvLine.NEXT = 0;

      MoveEntries.MoveDocRelatedEntries(DATABASE::"Sales Invoice Header",SalesInvHeader."No.");
    END;

    [External]
    PROCEDURE DeleteSalesCrMemoLines@3(SalesCrMemoHeader@1000 : Record 114);
    BEGIN
      SalesCrMemoLine.SETRANGE("Document No.",SalesCrMemoHeader."No.");
      IF SalesCrMemoLine.FIND('-') THEN
        REPEAT
          SalesCrMemoLine.DELETE;
        UNTIL SalesCrMemoLine.NEXT = 0;
      ItemTrackingMgt.DeleteItemEntryRelation(
        DATABASE::"Sales Cr.Memo Line",0,SalesCrMemoHeader."No.",'',0,0,TRUE);

      MoveEntries.MoveDocRelatedEntries(DATABASE::"Sales Cr.Memo Header",SalesCrMemoHeader."No.");
    END;

    [External]
    PROCEDURE DeleteSalesRcptLines@5800(ReturnRcptHeader@1000 : Record 6660);
    BEGIN
      SalesRcptLine.SETRANGE("Document No.",ReturnRcptHeader."No.");
      IF SalesRcptLine.FIND('-') THEN
        REPEAT
          SalesRcptLine.TESTFIELD("Quantity Invoiced",SalesRcptLine.Quantity);
          SalesRcptLine.DELETE;
        UNTIL SalesRcptLine.NEXT = 0;
      ItemTrackingMgt.DeleteItemEntryRelation(
        DATABASE::"Return Receipt Line",0,ReturnRcptHeader."No.",'',0,0,TRUE);

      MoveEntries.MoveDocRelatedEntries(DATABASE::"Return Receipt Header",ReturnRcptHeader."No.");
    END;

    [External]
    PROCEDURE InitDeleteHeader@19(SalesHeader@1000 : Record 36;VAR SalesShptHeader@1001 : Record 110;VAR SalesInvHeader@1002 : Record 112;VAR SalesCrMemoHeader@1003 : Record 114;VAR ReturnRcptHeader@1004 : Record 6660;VAR SalesInvHeaderPrePmt@1006 : Record 112;VAR SalesCrMemoHeaderPrePmt@1005 : Record 114;SourceCode@1008 : Code[10]);
    VAR
      SalesSetup@1007 : Record 311;
    BEGIN
      WITH SalesHeader DO BEGIN
        CLEAR(SalesShptHeader);
        CLEAR(SalesInvHeader);
        CLEAR(SalesCrMemoHeader);
        CLEAR(ReturnRcptHeader);
        SalesSetup.GET;

        IF ("Shipping No. Series" <> '') AND ("Shipping No." <> '') THEN BEGIN
          SalesShptHeader.TRANSFERFIELDS(SalesHeader);
          SalesShptHeader."No." := "Shipping No.";
          SalesShptHeader."Posting Date" := TODAY;
          SalesShptHeader."User ID" := USERID;
          SalesShptHeader."Source Code" := SourceCode;
        END;

        IF ("Return Receipt No. Series" <> '') AND ("Return Receipt No." <> '') THEN BEGIN
          ReturnRcptHeader.TRANSFERFIELDS(SalesHeader);
          ReturnRcptHeader."No." := "Return Receipt No.";
          ReturnRcptHeader."Posting Date" := TODAY;
          ReturnRcptHeader."User ID" := USERID;
          ReturnRcptHeader."Source Code" := SourceCode;
        END;

        IF ("Posting No. Series" <> '') AND
           (("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
            ("Posting No." <> '') OR
            ("Document Type" = "Document Type"::Invoice) AND
            ("No. Series" = "Posting No. Series"))
        THEN BEGIN
          SalesInvHeader.TRANSFERFIELDS(SalesHeader);
          IF "Posting No." <> '' THEN
            SalesInvHeader."No." := "Posting No.";
          IF "Document Type" = "Document Type"::Invoice THEN BEGIN
            SalesInvHeader."Pre-Assigned No. Series" := "No. Series";
            SalesInvHeader."Pre-Assigned No." := "No.";
          END ELSE BEGIN
            SalesInvHeader."Pre-Assigned No. Series" := '';
            SalesInvHeader."Pre-Assigned No." := '';
            SalesInvHeader."Order No. Series" := "No. Series";
            SalesInvHeader."Order No." := "No.";
          END;
          SalesInvHeader."Posting Date" := TODAY;
          SalesInvHeader."User ID" := USERID;
          SalesInvHeader."Source Code" := SourceCode;
        END;

        IF ("Posting No. Series" <> '') AND
           (("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
            ("Posting No." <> '') OR
            ("Document Type" = "Document Type"::"Credit Memo") AND
            ("No. Series" = "Posting No. Series"))
        THEN BEGIN
          SalesCrMemoHeader.TRANSFERFIELDS(SalesHeader);
          IF "Posting No." <> '' THEN
            SalesCrMemoHeader."No." := "Posting No.";
          SalesCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
          SalesCrMemoHeader."Pre-Assigned No." := "No.";
          SalesCrMemoHeader."Posting Date" := TODAY;
          SalesCrMemoHeader."User ID" := USERID;
          SalesCrMemoHeader."Source Code" := SourceCode;
        END;
        IF ("Prepayment No. Series" <> '') AND ("Prepayment No." <> '') THEN BEGIN
          TESTFIELD("Document Type","Document Type"::Order);
          SalesInvHeaderPrePmt.TRANSFERFIELDS(SalesHeader);
          SalesInvHeaderPrePmt."No." := "Prepayment No.";
          SalesInvHeaderPrePmt."Order No. Series" := "No. Series";
          SalesInvHeaderPrePmt."Prepayment Order No." := "No.";
          SalesInvHeaderPrePmt."Posting Date" := TODAY;
          SalesInvHeaderPrePmt."Pre-Assigned No. Series" := '';
          SalesInvHeaderPrePmt."Pre-Assigned No." := '';
          SalesInvHeaderPrePmt."User ID" := USERID;
          SalesInvHeaderPrePmt."Source Code" := SourceCode;
          SalesInvHeaderPrePmt."Prepayment Invoice" := TRUE;
        END;

        IF ("Prepmt. Cr. Memo No. Series" <> '') AND ("Prepmt. Cr. Memo No." <> '') THEN BEGIN
          TESTFIELD("Document Type","Document Type"::Order);
          SalesCrMemoHeaderPrePmt.TRANSFERFIELDS(SalesHeader);
          SalesCrMemoHeaderPrePmt."No." := "Prepmt. Cr. Memo No.";
          SalesCrMemoHeaderPrePmt."Prepayment Order No." := "No.";
          SalesCrMemoHeaderPrePmt."Posting Date" := TODAY;
          SalesCrMemoHeaderPrePmt."Pre-Assigned No. Series" := '';
          SalesCrMemoHeaderPrePmt."Pre-Assigned No." := '';
          SalesCrMemoHeaderPrePmt."User ID" := USERID;
          SalesCrMemoHeaderPrePmt."Source Code" := SourceCode;
          SalesCrMemoHeaderPrePmt."Prepayment Credit Memo" := TRUE;
        END;
      END;
    END;

    [External]
    PROCEDURE IsDocumentDeletionAllowed@4(PostingDate@1001 : Date);
    VAR
      SalesSetup@1000 : Record 311;
    BEGIN
      SalesSetup.GET;
      SalesSetup.TESTFIELD("Allow Document Deletion Before");
      IF PostingDate >= SalesSetup."Allow Document Deletion Before" THEN
        ERROR(STRSUBSTNO(DocumentDeletionErr,SalesSetup."Allow Document Deletion Before"));
    END;

    BEGIN
    END.
  }
}

