OBJECT Codeunit 1305 Sales-Quote to Invoice
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    TableNo=36;
    OnRun=VAR
            Cust@1008 : Record 18;
            SalesInvoiceLine@1000 : Record 37;
            SalesSetup@1001 : Record 311;
            CustCheckCrLimit@1006 : Codeunit 312;
          BEGIN
            TESTFIELD("Document Type","Document Type"::Quote);

            IF "Sell-to Customer No." = '' THEN
              ERROR(SpecifyCustomerErr);

            IF "Bill-to Customer No." = '' THEN
              ERROR(SpecifyBillToCustomerNoErr,FIELDCAPTION("Bill-to Customer No."));

            Cust.GET("Sell-to Customer No.");
            Cust.CheckBlockedCustOnDocs(Cust,"Document Type"::Quote,TRUE,FALSE);
            CALCFIELDS("Amount Including VAT","Invoice Discount Amount","Work Description");

            ValidateSalesPersonOnSalesHeader(Rec,TRUE,FALSE);

            SalesInvoiceHeader := Rec;

            SalesInvoiceLine.LOCKTABLE;

            CreateSalesInvoiceHeader(SalesInvoiceHeader,Rec);
            CreateSalesInvoiceLines(SalesInvoiceHeader,Rec);
            OnAfterInsertAllSalesInvLines(SalesInvoiceLine,Rec);

            SalesSetup.GET;
            IF SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" THEN BEGIN
              SalesInvoiceHeader."Posting Date" := 0D;
              SalesInvoiceHeader.MODIFY;
            END;
            UpdateEmailParameters(SalesInvoiceHeader);
            UpdateCouponClaims(SalesInvoiceHeader);

            OnBeforeDeletionOfQuote(Rec,SalesInvoiceHeader);

            DELETELINKS;
            DELETE;

            COMMIT;
            CLEAR(CustCheckCrLimit);

            OnAfterOnRun(Rec,SalesInvoiceHeader);
          END;

  }
  CODE
  {
    VAR
      SalesInvoiceHeader@1000 : Record 36;
      SpecifyCustomerErr@1002 : TextConst 'DAN=Du skal v�lge en debitor, f�r du kan �ndre et tilbud til en faktura.;ENU=You must select a customer before you can convert a quote to an invoice.';
      SpecifyBillToCustomerNoErr@1003 : TextConst '@@@=%1 is Bill-To Customer No.;DAN=Du skal angive %1, f�r du kan �ndre et tilbud til en faktura.;ENU=You must specify the %1 before you can convert a quote to an invoice.';

    [External]
    PROCEDURE GetSalesInvoiceHeader@1(VAR SalesHeader2@1000 : Record 36);
    BEGIN
      SalesHeader2 := SalesInvoiceHeader;
    END;

    LOCAL PROCEDURE CreateSalesInvoiceHeader@3(VAR SalesInvoiceHeader@1000 : Record 36;SalesQuoteHeader@1001 : Record 36);
    BEGIN
      WITH SalesQuoteHeader DO BEGIN
        SalesInvoiceHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;

        SalesInvoiceHeader."No. Printed" := 0;
        SalesInvoiceHeader.Status := SalesInvoiceHeader.Status::Open;
        SalesInvoiceHeader."No." := '';

        SalesInvoiceHeader."Quote No." := "No.";
        SalesInvoiceHeader.INSERT(TRUE);

        IF "Posting Date" <> 0D THEN
          SalesInvoiceHeader."Posting Date" := "Posting Date"
        ELSE
          SalesInvoiceHeader."Posting Date" := WORKDATE;
        SalesInvoiceHeader.InitFromSalesHeader(SalesQuoteHeader);
        OnBeforeInsertSalesInvoiceHeader(SalesInvoiceHeader,SalesQuoteHeader);
        SalesInvoiceHeader.MODIFY;
      END;
    END;

    LOCAL PROCEDURE CreateSalesInvoiceLines@4(SalesInvoiceHeader@1003 : Record 36;SalesQuoteHeader@1002 : Record 36);
    VAR
      SalesQuoteLine@1000 : Record 37;
      SalesInvoiceLine@1004 : Record 37;
      Resource@1001 : Record 156;
    BEGIN
      WITH SalesQuoteHeader DO BEGIN
        SalesQuoteLine.RESET;
        SalesQuoteLine.SETRANGE("Document Type","Document Type");
        SalesQuoteLine.SETRANGE("Document No.","No.");

        IF SalesQuoteLine.FINDSET THEN
          REPEAT
            IF SalesQuoteLine.Type = SalesQuoteLine.Type::Resource THEN
              IF SalesQuoteLine."No." <> '' THEN
                IF Resource.GET(SalesQuoteLine."No.") THEN BEGIN
                  Resource.CheckResourcePrivacyBlocked(FALSE);
                  Resource.TESTFIELD(Blocked,FALSE);
                END;
            SalesInvoiceLine := SalesQuoteLine;
            SalesInvoiceLine."Document Type" := SalesInvoiceHeader."Document Type";
            SalesInvoiceLine."Document No." := SalesInvoiceHeader."No.";
            IF SalesInvoiceLine."No." <> '' THEN
              SalesInvoiceLine.DefaultDeferralCode;
            OnBeforeInsertSalesInvoiceLine(SalesQuoteLine,SalesQuoteHeader,SalesInvoiceLine,SalesInvoiceHeader);
            SalesInvoiceLine.INSERT;
            OnAfterInsertSalesInvoiceLine(SalesQuoteLine,SalesQuoteHeader,SalesInvoiceLine,SalesInvoiceHeader);
          UNTIL SalesQuoteLine.NEXT = 0;

        MoveLineCommentsToSalesInvoice(SalesInvoiceHeader,SalesQuoteHeader);

        SalesQuoteLine.DELETEALL;
      END;
    END;

    LOCAL PROCEDURE MoveLineCommentsToSalesInvoice@5(SalesInvoiceHeader@1001 : Record 36;SalesQuoteHeader@1000 : Record 36);
    VAR
      SalesCommentLine@1003 : Record 44;
      RecordLinkManagement@1004 : Codeunit 447;
    BEGIN
      SalesCommentLine.CopyComments(
        SalesQuoteHeader."Document Type",SalesInvoiceHeader."Document Type",SalesQuoteHeader."No.",SalesInvoiceHeader."No.");
      RecordLinkManagement.CopyLinks(SalesQuoteHeader,SalesInvoiceHeader);
    END;

    LOCAL PROCEDURE UpdateEmailParameters@197(SalesHeader@1000 : Record 36);
    VAR
      EmailParameter@1001 : Record 9510;
    BEGIN
      EmailParameter.SETRANGE("Document No",SalesHeader."Quote No.");
      EmailParameter.SETRANGE("Document Type",SalesHeader."Document Type"::Quote);
      EmailParameter.DELETEALL;
    END;

    LOCAL PROCEDURE UpdateCouponClaims@2(SalesHeader@1000 : Record 36);
    VAR
      O365CouponClaimDocLink@1001 : Record 2116;
    BEGIN
      O365CouponClaimDocLink.SETRANGE("Document No.",SalesHeader."Quote No.");
      O365CouponClaimDocLink.SETRANGE("Document Type",SalesHeader."Document Type"::Quote);
      IF O365CouponClaimDocLink.FINDSET(TRUE,TRUE) THEN
        REPEAT
          O365CouponClaimDocLink.RENAME(
            O365CouponClaimDocLink."Claim ID",O365CouponClaimDocLink."Graph Contact ID",SalesHeader."Document Type",SalesHeader."No.");
        UNTIL O365CouponClaimDocLink.NEXT = 0;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertSalesInvoiceHeader@7(VAR SalesInvoiceHeader@1000 : Record 36;QuoteSalesHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertSalesInvoiceLine@9(VAR SalesQuoteLine@1004 : Record 37;SalesQuoteHeader@1003 : Record 36;SalesInvoiceLine@1002 : Record 37;SalesInvoiceHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertAllSalesInvLines@11(VAR SalesInvoiceLine@1001 : Record 37;SalesQuoteHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterOnRun@10(VAR SalesHeader@1000 : Record 36;VAR SalesInvoiceHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertSalesInvoiceLine@8(VAR SalesQuoteLine@1004 : Record 37;SalesQuoteHeader@1003 : Record 36;SalesInvoiceLine@1002 : Record 37;SalesInvoiceHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeDeletionOfQuote@6(VAR SalesHeader@1000 : Record 36;VAR SalesInvoiceHeader@1001 : Record 36);
    BEGIN
    END;

    BEGIN
    END.
  }
}

