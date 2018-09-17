OBJECT Table 38 Purchase Header
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Buy-from Vendor Name;
    OnInsert=BEGIN
               InitInsert;

               IF GETFILTER("Buy-from Vendor No.") <> '' THEN
                 IF GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") THEN
                   VALIDATE("Buy-from Vendor No.",GETRANGEMIN("Buy-from Vendor No."));

               IF "Purchaser Code" = '' THEN
                 SetDefaultPurchaser;
             END;

    OnDelete=VAR
               PostPurchDelete@1000 : Codeunit 364;
               ArchiveManagement@1001 : Codeunit 5063;
             BEGIN
               IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
                 ERROR(
                   Text023,
                   RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);

               ArchiveManagement.AutoArchivePurchDocument(Rec);
               PostPurchDelete.DeleteHeader(
                 Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
                 ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt);
               VALIDATE("Applies-to ID",'');
               VALIDATE("Incoming Document Entry No.",0);

               ApprovalsMgmt.OnDeleteRecordInApprovalRequest(RECORDID);
               PurchLine.LOCKTABLE;

               WhseRequest.SETRANGE("Source Type",DATABASE::"Purchase Line");
               WhseRequest.SETRANGE("Source Subtype","Document Type");
               WhseRequest.SETRANGE("Source No.","No.");
               WhseRequest.DELETEALL(TRUE);

               PurchLine.SETRANGE("Document Type","Document Type");
               PurchLine.SETRANGE("Document No.","No.");
               PurchLine.SETRANGE(Type,PurchLine.Type::"Charge (Item)");
               DeletePurchaseLines;
               PurchLine.SETRANGE(Type);
               DeletePurchaseLines;

               PurchCommentLine.SETRANGE("Document Type","Document Type");
               PurchCommentLine.SETRANGE("No.","No.");
               PurchCommentLine.DELETEALL;

               IF (PurchRcptHeader."No." <> '') OR
                  (PurchInvHeader."No." <> '') OR
                  (PurchCrMemoHeader."No." <> '') OR
                  (ReturnShptHeader."No." <> '') OR
                  (PurchInvHeaderPrepmt."No." <> '') OR
                  (PurchCrMemoHeaderPrepmt."No." <> '')
               THEN
                 MESSAGE(PostedDocsToPrintCreatedMsg);
             END;

    OnRename=BEGIN
               ERROR(Text003,TABLECAPTION);
             END;

    CaptionML=[DAN=Kõbshoved;
               ENU=Purchase Header];
    LookupPageID=Page53;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returv.ordre;
                                                                    ENU=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order];
                                                   OptionString=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order }
    { 2   ;   ;Buy-from Vendor No. ;Code20        ;TableRelation=Vendor;
                                                   OnValidate=BEGIN
                                                                IF "No." = '' THEN
                                                                  InitRecord;
                                                                TESTFIELD(Status,Status::Open);
                                                                IF ("Buy-from Vendor No." <> xRec."Buy-from Vendor No.") AND
                                                                   (xRec."Buy-from Vendor No." <> '')
                                                                THEN BEGIN
                                                                  CheckDropShipmentLineExists;
                                                                  IF HideValidationDialog THEN
                                                                    Confirmed := TRUE
                                                                  ELSE
                                                                    Confirmed := CONFIRM(ConfirmChangeQst,FALSE,BuyFromVendorTxt);
                                                                  IF Confirmed THEN BEGIN
                                                                    IF InitFromVendor("Buy-from Vendor No.",FIELDCAPTION("Buy-from Vendor No.")) THEN
                                                                      EXIT;

                                                                    CheckReceiptInfo(PurchLine,FALSE);
                                                                    CheckPrepmtInfo(PurchLine);
                                                                    CheckReturnInfo(PurchLine,FALSE);

                                                                    PurchLine.RESET;
                                                                  END ELSE BEGIN
                                                                    Rec := xRec;
                                                                    EXIT;
                                                                  END;
                                                                END;

                                                                GetVend("Buy-from Vendor No.");
                                                                Vend.CheckBlockedVendOnDocs(Vend,FALSE);
                                                                Vend.TESTFIELD("Gen. Bus. Posting Group");
                                                                "Buy-from Vendor Name" := Vend.Name;
                                                                "Buy-from Vendor Name 2" := Vend."Name 2";
                                                                CopyBuyFromVendorAddressFieldsFromVendor(Vend,FALSE);
                                                                IF NOT SkipBuyFromContact THEN
                                                                  "Buy-from Contact" := Vend.Contact;
                                                                "Gen. Bus. Posting Group" := Vend."Gen. Bus. Posting Group";
                                                                "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
                                                                "Tax Area Code" := Vend."Tax Area Code";
                                                                "Tax Liable" := Vend."Tax Liable";
                                                                "VAT Country/Region Code" := Vend."Country/Region Code";
                                                                "VAT Registration No." := Vend."VAT Registration No.";
                                                                VALIDATE("Lead Time Calculation",Vend."Lead Time Calculation");
                                                                "Responsibility Center" := UserSetupMgt.GetRespCenter(1,Vend."Responsibility Center");
                                                                VALIDATE("Sell-to Customer No.",'');
                                                                VALIDATE("Location Code",UserSetupMgt.GetLocation(1,Vend."Location Code","Responsibility Center"));

                                                                IF "Buy-from Vendor No." = xRec."Pay-to Vendor No." THEN
                                                                  IF ReceivedPurchLinesExist OR ReturnShipmentExist THEN BEGIN
                                                                    TESTFIELD("VAT Bus. Posting Group",xRec."VAT Bus. Posting Group");
                                                                    TESTFIELD("Gen. Bus. Posting Group",xRec."Gen. Bus. Posting Group");
                                                                  END;

                                                                "Buy-from IC Partner Code" := Vend."IC Partner Code";
                                                                "Send IC Document" := ("Buy-from IC Partner Code" <> '') AND ("IC Direction" = "IC Direction"::Outgoing);

                                                                IF Vend."Pay-to Vendor No." <> '' THEN
                                                                  VALIDATE("Pay-to Vendor No.",Vend."Pay-to Vendor No.")
                                                                ELSE BEGIN
                                                                  IF "Buy-from Vendor No." = "Pay-to Vendor No." THEN
                                                                    SkipPayToContact := TRUE;
                                                                  VALIDATE("Pay-to Vendor No.","Buy-from Vendor No.");
                                                                  SkipPayToContact := FALSE;
                                                                END;
                                                                "Order Address Code" := '';

                                                                CopyPayToVendorAddressFieldsFromVendor(Vend,FALSE);
                                                                IF IsCreditDocType THEN BEGIN
                                                                  "Ship-to Name" := Vend.Name;
                                                                  "Ship-to Name 2" := Vend."Name 2";
                                                                  CopyShipToVendorAddressFieldsFromVendor(Vend,TRUE);
                                                                  "Ship-to Contact" := Vend.Contact;
                                                                  "Shipment Method Code" := Vend."Shipment Method Code";
                                                                  IF Vend."Location Code" <> '' THEN
                                                                    VALIDATE("Location Code",Vend."Location Code");
                                                                END;

                                                                IF (xRec."Buy-from Vendor No." <> "Buy-from Vendor No.") OR
                                                                   (xRec."Currency Code" <> "Currency Code") OR
                                                                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") OR
                                                                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                                                                THEN
                                                                  RecreatePurchLines(BuyFromVendorTxt);

                                                                IF NOT SkipBuyFromContact THEN
                                                                  UpdateBuyFromCont("Buy-from Vendor No.");

                                                                IF (xRec."Buy-from Vendor No." <> '') AND (xRec."Buy-from Vendor No." <> "Buy-from Vendor No.") THEN
                                                                  RecallModifyAddressNotification(GetModifyVendorAddressNotificationId);
                                                              END;

                                                   CaptionML=[DAN=Leverandõrnr.;
                                                              ENU=Buy-from Vendor No.] }
    { 3   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  PurchSetup.GET;
                                                                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 4   ;   ;Pay-to Vendor No.   ;Code20        ;TableRelation=Vendor;
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                IF (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") AND
                                                                   (xRec."Pay-to Vendor No." <> '')
                                                                THEN BEGIN
                                                                  IF HideValidationDialog THEN
                                                                    Confirmed := TRUE
                                                                  ELSE
                                                                    Confirmed := CONFIRM(ConfirmChangeQst,FALSE,PayToVendorTxt);
                                                                  IF Confirmed THEN BEGIN
                                                                    PurchLine.SETRANGE("Document Type","Document Type");
                                                                    PurchLine.SETRANGE("Document No.","No.");

                                                                    CheckReceiptInfo(PurchLine,TRUE);
                                                                    CheckPrepmtInfo(PurchLine);
                                                                    CheckReturnInfo(PurchLine,TRUE);

                                                                    PurchLine.RESET;
                                                                  END ELSE
                                                                    "Pay-to Vendor No." := xRec."Pay-to Vendor No.";
                                                                END;

                                                                GetVend("Pay-to Vendor No.");
                                                                Vend.CheckBlockedVendOnDocs(Vend,FALSE);
                                                                Vend.TESTFIELD("Vendor Posting Group");
                                                                PostingSetupMgt.CheckVendPostingGroupPayablesAccount("Vendor Posting Group");

                                                                "Pay-to Name" := Vend.Name;
                                                                "Pay-to Name 2" := Vend."Name 2";
                                                                CopyPayToVendorAddressFieldsFromVendor(Vend,FALSE);
                                                                IF NOT SkipPayToContact THEN
                                                                  "Pay-to Contact" := Vend.Contact;
                                                                "Payment Terms Code" := Vend."Payment Terms Code";
                                                                "Prepmt. Payment Terms Code" := Vend."Payment Terms Code";

                                                                IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                                                                  "Payment Method Code" := '';
                                                                  IF PaymentTerms.GET("Payment Terms Code") THEN
                                                                    IF PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN
                                                                      "Payment Method Code" := Vend."Payment Method Code"
                                                                END ELSE
                                                                  "Payment Method Code" := Vend."Payment Method Code";

                                                                "Shipment Method Code" := Vend."Shipment Method Code";
                                                                "Vendor Posting Group" := Vend."Vendor Posting Group";
                                                                GLSetup.GET;
                                                                IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." THEN BEGIN
                                                                  "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
                                                                  "VAT Country/Region Code" := Vend."Country/Region Code";
                                                                  "VAT Registration No." := Vend."VAT Registration No.";
                                                                  "Gen. Bus. Posting Group" := Vend."Gen. Bus. Posting Group";
                                                                END;
                                                                "Prices Including VAT" := Vend."Prices Including VAT";
                                                                "Currency Code" := Vend."Currency Code";
                                                                "Invoice Disc. Code" := Vend."Invoice Disc. Code";
                                                                "Language Code" := Vend."Language Code";
                                                                SetPurchaserCode(Vend."Purchaser Code","Purchaser Code");
                                                                VALIDATE("Payment Terms Code");
                                                                VALIDATE("Prepmt. Payment Terms Code");
                                                                VALIDATE("Payment Method Code");
                                                                VALIDATE("Currency Code");
                                                                VALIDATE("Creditor No.",Vend."Creditor No.");

                                                                OnValidatePurchaseHeaderPayToVendorNo(Vend);

                                                                IF "Document Type" = "Document Type"::Order THEN
                                                                  VALIDATE("Prepayment %",Vend."Prepayment %");

                                                                IF "Pay-to Vendor No." = xRec."Pay-to Vendor No." THEN BEGIN
                                                                  IF ReceivedPurchLinesExist THEN
                                                                    TESTFIELD("Currency Code",xRec."Currency Code");
                                                                END;

                                                                CreateDim(
                                                                  DATABASE::Vendor,"Pay-to Vendor No.",
                                                                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                                                                  DATABASE::Campaign,"Campaign No.",
                                                                  DATABASE::"Responsibility Center","Responsibility Center");

                                                                IF (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") AND
                                                                   (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.")
                                                                THEN
                                                                  RecreatePurchLines(PayToVendorTxt);

                                                                IF NOT SkipPayToContact THEN
                                                                  UpdatePayToCont("Pay-to Vendor No.");

                                                                "Pay-to IC Partner Code" := Vend."IC Partner Code";

                                                                IF (xRec."Pay-to Vendor No." <> '') AND (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") THEN
                                                                  RecallModifyAddressNotification(GetModifyPayToVendorAddressNotificationId);
                                                              END;

                                                   CaptionML=[DAN=Faktureringsleverandõrnr.;
                                                              ENU=Pay-to Vendor No.];
                                                   NotBlank=Yes }
    { 5   ;   ;Pay-to Name         ;Text50        ;TableRelation=Vendor;
                                                   OnValidate=VAR
                                                                Vendor@1000 : Record 23;
                                                              BEGIN
                                                                VALIDATE("Pay-to Vendor No.",Vendor.GetVendorNo("Pay-to Name"));
                                                              END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Pay-to Name] }
    { 6   ;   ;Pay-to Name 2       ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Pay-to Name 2] }
    { 7   ;   ;Pay-to Address      ;Text50        ;OnValidate=BEGIN
                                                                ModifyPayToVendorAddress;
                                                              END;

                                                   CaptionML=[DAN=Adresse;
                                                              ENU=Pay-to Address] }
    { 8   ;   ;Pay-to Address 2    ;Text50        ;OnValidate=BEGIN
                                                                ModifyPayToVendorAddress;
                                                              END;

                                                   CaptionML=[DAN=Adresse 2;
                                                              ENU=Pay-to Address 2] }
    { 9   ;   ;Pay-to City         ;Text30        ;TableRelation=IF (Pay-to Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Pay-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Pay-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(
                                                                  "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                                ModifyPayToVendorAddress;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=Pay-to City] }
    { 10  ;   ;Pay-to Contact      ;Text50        ;OnValidate=BEGIN
                                                                ModifyPayToVendorAddress;
                                                              END;

                                                   OnLookup=VAR
                                                              Contact@1000 : Record 5050;
                                                            BEGIN
                                                              LookupContact("Pay-to Vendor No.","Pay-to Contact No.",Contact);
                                                              IF PAGE.RUNMODAL(0,Contact) = ACTION::LookupOK THEN
                                                                VALIDATE("Pay-to Contact No.",Contact."No.");
                                                            END;

                                                   CaptionML=[DAN=Attention;
                                                              ENU=Pay-to Contact] }
    { 11  ;   ;Your Reference      ;Text35        ;CaptionML=[DAN=Reference;
                                                              ENU=Your Reference] }
    { 12  ;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Sell-to Customer No.));
                                                   OnValidate=VAR
                                                                ShipToAddr@1000 : Record 222;
                                                              BEGIN
                                                                IF ("Document Type" = "Document Type"::Order) AND
                                                                   (xRec."Ship-to Code" <> "Ship-to Code")
                                                                THEN BEGIN
                                                                  PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
                                                                  PurchLine.SETRANGE("Document No.","No.");
                                                                  PurchLine.SETFILTER("Sales Order Line No.",'<>0');
                                                                  IF NOT PurchLine.ISEMPTY THEN
                                                                    ERROR(
                                                                      YouCannotChangeFieldErr,
                                                                      FIELDCAPTION("Ship-to Code"));
                                                                END;

                                                                IF "Ship-to Code" <> '' THEN BEGIN
                                                                  ShipToAddr.GET("Sell-to Customer No.","Ship-to Code");
                                                                  SetShipToAddress(
                                                                    ShipToAddr.Name,ShipToAddr."Name 2",ShipToAddr.Address,ShipToAddr."Address 2",
                                                                    ShipToAddr.City,ShipToAddr."Post Code",ShipToAddr.County,ShipToAddr."Country/Region Code");
                                                                  "Ship-to Contact" := ShipToAddr.Contact;
                                                                  "Shipment Method Code" := ShipToAddr."Shipment Method Code";
                                                                  IF ShipToAddr."Location Code" <> '' THEN
                                                                    VALIDATE("Location Code",ShipToAddr."Location Code");
                                                                END ELSE BEGIN
                                                                  TESTFIELD("Sell-to Customer No.");
                                                                  Cust.GET("Sell-to Customer No.");
                                                                  SetShipToAddress(
                                                                    Cust.Name,Cust."Name 2",Cust.Address,Cust."Address 2",
                                                                    Cust.City,Cust."Post Code",Cust.County,Cust."Country/Region Code");
                                                                  "Ship-to Contact" := Cust.Contact;
                                                                  "Shipment Method Code" := Cust."Shipment Method Code";
                                                                  IF Cust."Location Code" <> '' THEN
                                                                    VALIDATE("Location Code",Cust."Location Code");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Leveringsadressekode;
                                                              ENU=Ship-to Code] }
    { 13  ;   ;Ship-to Name        ;Text50        ;CaptionML=[DAN=Leveringsnavn;
                                                              ENU=Ship-to Name] }
    { 14  ;   ;Ship-to Name 2      ;Text50        ;CaptionML=[DAN=Leveringsnavn 2;
                                                              ENU=Ship-to Name 2] }
    { 15  ;   ;Ship-to Address     ;Text50        ;CaptionML=[DAN=Leveringsadresse;
                                                              ENU=Ship-to Address] }
    { 16  ;   ;Ship-to Address 2   ;Text50        ;CaptionML=[DAN=Leveringsadresse 2;
                                                              ENU=Ship-to Address 2] }
    { 17  ;   ;Ship-to City        ;Text30        ;TableRelation=IF (Ship-to Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(
                                                                  "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leveringsby;
                                                              ENU=Ship-to City] }
    { 18  ;   ;Ship-to Contact     ;Text50        ;CaptionML=[DAN=Leveres attention;
                                                              ENU=Ship-to Contact] }
    { 19  ;   ;Order Date          ;Date          ;OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                IF ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND
                                                                   NOT ("Order Date" = xRec."Order Date")
                                                                THEN
                                                                  PriceMessageIfPurchLinesExist(FIELDCAPTION("Order Date"));
                                                              END;

                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Ordredato;
                                                              ENU=Order Date] }
    { 20  ;   ;Posting Date        ;Date          ;OnValidate=VAR
                                                                SkipJobCurrFactorUpdate@1000 : Boolean;
                                                              BEGIN
                                                                TestNoSeriesDate(
                                                                  "Posting No.","Posting No. Series",
                                                                  FIELDCAPTION("Posting No."),FIELDCAPTION("Posting No. Series"));
                                                                TestNoSeriesDate(
                                                                  "Prepayment No.","Prepayment No. Series",
                                                                  FIELDCAPTION("Prepayment No."),FIELDCAPTION("Prepayment No. Series"));
                                                                TestNoSeriesDate(
                                                                  "Prepmt. Cr. Memo No.","Prepmt. Cr. Memo No. Series",
                                                                  FIELDCAPTION("Prepmt. Cr. Memo No."),FIELDCAPTION("Prepmt. Cr. Memo No. Series"));

                                                                IF "Incoming Document Entry No." = 0 THEN
                                                                  VALIDATE("Document Date","Posting Date");

                                                                IF ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND
                                                                   NOT ("Posting Date" = xRec."Posting Date")
                                                                THEN
                                                                  PriceMessageIfPurchLinesExist(FIELDCAPTION("Posting Date"));

                                                                IF "Currency Code" <> '' THEN BEGIN
                                                                  UpdateCurrencyFactor;
                                                                  IF "Currency Factor" <> xRec."Currency Factor" THEN
                                                                    SkipJobCurrFactorUpdate := NOT ConfirmUpdateCurrencyFactor;
                                                                END;

                                                                IF "Posting Date" <> xRec."Posting Date" THEN
                                                                  IF DeferralHeadersExist THEN
                                                                    ConfirmUpdateDeferralDate;

                                                                IF PurchLinesExist THEN
                                                                  JobUpdatePurchLines(SkipJobCurrFactorUpdate);
                                                              END;

                                                   CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 21  ;   ;Expected Receipt Date;Date         ;OnValidate=BEGIN
                                                                IF "Expected Receipt Date" <> 0D THEN
                                                                  UpdatePurchLines(FIELDCAPTION("Expected Receipt Date"),CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=Forventet modt.dato;
                                                              ENU=Expected Receipt Date] }
    { 22  ;   ;Posting Description ;Text50        ;CaptionML=[DAN=Bogfõringsbeskrivelse;
                                                              ENU=Posting Description] }
    { 23  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   OnValidate=BEGIN
                                                                IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                                                                  PaymentTerms.GET("Payment Terms Code");
                                                                  IF IsCreditDocType AND NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                                                                    VALIDATE("Due Date","Document Date");
                                                                    VALIDATE("Pmt. Discount Date",0D);
                                                                    VALIDATE("Payment Discount %",0);
                                                                  END ELSE BEGIN
                                                                    "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                                                                    "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                                                                    IF NOT UpdateDocumentDate THEN
                                                                      VALIDATE("Payment Discount %",PaymentTerms."Discount %")
                                                                  END;
                                                                END ELSE BEGIN
                                                                  VALIDATE("Due Date","Document Date");
                                                                  IF NOT UpdateDocumentDate THEN BEGIN
                                                                    VALIDATE("Pmt. Discount Date",0D);
                                                                    VALIDATE("Payment Discount %",0);
                                                                  END;
                                                                END;
                                                                IF xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" THEN
                                                                  VALIDATE("Prepmt. Payment Terms Code","Payment Terms Code");
                                                              END;

                                                   CaptionML=[DAN=Betalingsbeting.kode;
                                                              ENU=Payment Terms Code] }
    { 24  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 25  ;   ;Payment Discount %  ;Decimal       ;OnValidate=BEGIN
                                                                IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date"),FIELDNO("Document Date")]) THEN
                                                                  TESTFIELD(Status,Status::Open);
                                                                GLSetup.GET;
                                                                IF "Payment Discount %" < GLSetup."VAT Tolerance %" THEN
                                                                  "VAT Base Discount %" := "Payment Discount %"
                                                                ELSE
                                                                  "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                                                                VALIDATE("VAT Base Discount %");
                                                              END;

                                                   CaptionML=[DAN=Kontantrabatpct.;
                                                              ENU=Payment Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 26  ;   ;Pmt. Discount Date  ;Date          ;CaptionML=[DAN=Kont.rabatdato;
                                                              ENU=Pmt. Discount Date] }
    { 27  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                              END;

                                                   CaptionML=[DAN=Leveringskode;
                                                              ENU=Shipment Method Code] }
    { 28  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                IF ("Location Code" <> xRec."Location Code") AND
                                                                   (xRec."Buy-from Vendor No." = "Buy-from Vendor No.")
                                                                THEN
                                                                  MessageIfPurchLinesExist(FIELDCAPTION("Location Code"));

                                                                UpdateShipToAddress;

                                                                IF "Location Code" = '' THEN BEGIN
                                                                  IF InvtSetup.GET THEN
                                                                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                                                                END ELSE BEGIN
                                                                  IF Location.GET("Location Code") THEN;
                                                                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 29  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                                                               Blocked=CONST(No));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 30  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Blocked=CONST(No));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 31  ;   ;Vendor Posting Group;Code20        ;TableRelation="Vendor Posting Group";
                                                   CaptionML=[DAN=Kreditorbogfõringsgruppe;
                                                              ENU=Vendor Posting Group];
                                                   Editable=No }
    { 32  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date")]) OR ("Currency Code" <> xRec."Currency Code") THEN
                                                                  TESTFIELD(Status,Status::Open);
                                                                IF (CurrFieldNo <> FIELDNO("Currency Code")) AND ("Currency Code" = xRec."Currency Code") THEN
                                                                  UpdateCurrencyFactor
                                                                ELSE
                                                                  IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                                                                    UpdateCurrencyFactor;
                                                                    IF PurchLinesExist THEN
                                                                      IF CONFIRM(ChangeCurrencyQst,FALSE,FIELDCAPTION("Currency Code")) THEN BEGIN
                                                                        SetHideValidationDialog(TRUE);
                                                                        RecreatePurchLines(FIELDCAPTION("Currency Code"));
                                                                        SetHideValidationDialog(FALSE);
                                                                      END ELSE
                                                                        ERROR(Text018,FIELDCAPTION("Currency Code"));
                                                                  END ELSE
                                                                    IF "Currency Code" <> '' THEN BEGIN
                                                                      UpdateCurrencyFactor;
                                                                      IF "Currency Factor" <> xRec."Currency Factor" THEN
                                                                        ConfirmUpdateCurrencyFactor;
                                                                    END;
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 33  ;   ;Currency Factor     ;Decimal       ;OnValidate=BEGIN
                                                                IF "Currency Factor" <> xRec."Currency Factor" THEN
                                                                  UpdatePurchLines(FIELDCAPTION("Currency Factor"),CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=Valutafaktor;
                                                              ENU=Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0;
                                                   Editable=No }
    { 35  ;   ;Prices Including VAT;Boolean       ;OnValidate=VAR
                                                                PurchLine@1000 : Record 39;
                                                                Currency@1001 : Record 4;
                                                                RecalculatePrice@1002 : Boolean;
                                                              BEGIN
                                                                TESTFIELD(Status,Status::Open);

                                                                IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN
                                                                  PurchLine.SETRANGE("Document Type","Document Type");
                                                                  PurchLine.SETRANGE("Document No.","No.");
                                                                  PurchLine.SETFILTER("Direct Unit Cost",'<>%1',0);
                                                                  PurchLine.SETFILTER("VAT %",'<>%1',0);
                                                                  IF PurchLine.FIND('-') THEN BEGIN
                                                                    RecalculatePrice :=
                                                                      CONFIRM(
                                                                        STRSUBSTNO(
                                                                          Text025 +
                                                                          Text027,
                                                                          FIELDCAPTION("Prices Including VAT"),PurchLine.FIELDCAPTION("Direct Unit Cost")),
                                                                        TRUE);
                                                                    PurchLine.SetPurchHeader(Rec);

                                                                    IF RecalculatePrice AND "Prices Including VAT" THEN
                                                                      PurchLine.MODIFYALL(Amount,0,TRUE);

                                                                    IF "Currency Code" = '' THEN
                                                                      Currency.InitRoundingPrecision
                                                                    ELSE
                                                                      Currency.GET("Currency Code");

                                                                    PurchLine.FINDSET;
                                                                    REPEAT
                                                                      PurchLine.TESTFIELD("Quantity Invoiced",0);
                                                                      PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
                                                                      IF NOT RecalculatePrice THEN BEGIN
                                                                        PurchLine."VAT Difference" := 0;
                                                                        PurchLine.UpdateAmounts;
                                                                      END ELSE
                                                                        IF "Prices Including VAT" THEN BEGIN
                                                                          PurchLine."Direct Unit Cost" :=
                                                                            ROUND(
                                                                              PurchLine."Direct Unit Cost" * (1 + PurchLine."VAT %" / 100),
                                                                              Currency."Unit-Amount Rounding Precision");
                                                                          IF PurchLine.Quantity <> 0 THEN BEGIN
                                                                            PurchLine."Line Discount Amount" :=
                                                                              ROUND(
                                                                                PurchLine.Quantity * PurchLine."Direct Unit Cost" * PurchLine."Line Discount %" / 100,
                                                                                Currency."Amount Rounding Precision");
                                                                            PurchLine.VALIDATE("Inv. Discount Amount",
                                                                              ROUND(
                                                                                PurchLine."Inv. Discount Amount" * (1 + PurchLine."VAT %" / 100),
                                                                                Currency."Amount Rounding Precision"));
                                                                          END;
                                                                        END ELSE BEGIN
                                                                          PurchLine."Direct Unit Cost" :=
                                                                            ROUND(
                                                                              PurchLine."Direct Unit Cost" / (1 + PurchLine."VAT %" / 100),
                                                                              Currency."Unit-Amount Rounding Precision");
                                                                          IF PurchLine.Quantity <> 0 THEN BEGIN
                                                                            PurchLine."Line Discount Amount" :=
                                                                              ROUND(
                                                                                PurchLine.Quantity * PurchLine."Direct Unit Cost" * PurchLine."Line Discount %" / 100,
                                                                                Currency."Amount Rounding Precision");
                                                                            PurchLine.VALIDATE("Inv. Discount Amount",
                                                                              ROUND(
                                                                                PurchLine."Inv. Discount Amount" / (1 + PurchLine."VAT %" / 100),
                                                                                Currency."Amount Rounding Precision"));
                                                                          END;
                                                                        END;
                                                                      PurchLine.MODIFY;
                                                                    UNTIL PurchLine.NEXT = 0;
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Priser inkl. moms;
                                                              ENU=Prices Including VAT] }
    { 37  ;   ;Invoice Disc. Code  ;Code20        ;OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                MessageIfPurchLinesExist(FIELDCAPTION("Invoice Disc. Code"));
                                                              END;

                                                   CaptionML=[DAN=Fakturarabatkode;
                                                              ENU=Invoice Disc. Code] }
    { 41  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   OnValidate=BEGIN
                                                                MessageIfPurchLinesExist(FIELDCAPTION("Language Code"));
                                                              END;

                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 43  ;   ;Purchaser Code      ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=VAR
                                                                ApprovalEntry@1001 : Record 454;
                                                              BEGIN
                                                                ValidatePurchaserOnPurchHeader(Rec,FALSE,FALSE);

                                                                ApprovalEntry.SETRANGE("Table ID",DATABASE::"Purchase Header");
                                                                ApprovalEntry.SETRANGE("Document Type","Document Type");
                                                                ApprovalEntry.SETRANGE("Document No.","No.");
                                                                ApprovalEntry.SETFILTER(Status,'%1|%2',ApprovalEntry.Status::Created,ApprovalEntry.Status::Open);
                                                                IF NOT ApprovalEntry.ISEMPTY THEN
                                                                  ERROR(Text042,FIELDCAPTION("Purchaser Code"));

                                                                CreateDim(
                                                                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                                                                  DATABASE::Vendor,"Pay-to Vendor No.",
                                                                  DATABASE::Campaign,"Campaign No.",
                                                                  DATABASE::"Responsibility Center","Responsibility Center");
                                                              END;

                                                   CaptionML=[DAN=Indkõberkode;
                                                              ENU=Purchaser Code] }
    { 45  ;   ;Order Class         ;Code10        ;CaptionML=[DAN=Ordregruppe;
                                                              ENU=Order Class] }
    { 46  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Purch. Comment Line" WHERE (Document Type=FIELD(Document Type),
                                                                                                  No.=FIELD(No.),
                                                                                                  Document Line No.=CONST(0)));
                                                   CaptionML=[DAN=Bemërkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 47  ;   ;No. Printed         ;Integer       ;CaptionML=[DAN=Udskrevet;
                                                              ENU=No. Printed];
                                                   Editable=No }
    { 51  ;   ;On Hold             ;Code3         ;CaptionML=[DAN=Afvent;
                                                              ENU=On Hold] }
    { 52  ;   ;Applies-to Doc. Type;Option        ;CaptionML=[DAN=Udligningsbilagstype;
                                                              ENU=Applies-to Doc. Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 53  ;   ;Applies-to Doc. No. ;Code20        ;OnValidate=BEGIN
                                                                IF "Applies-to Doc. No." <> '' THEN
                                                                  TESTFIELD("Bal. Account No.",'');

                                                                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." <> '') AND
                                                                   ("Applies-to Doc. No." <> '')
                                                                THEN BEGIN
                                                                  SetAmountToApply("Applies-to Doc. No.","Buy-from Vendor No.");
                                                                  SetAmountToApply(xRec."Applies-to Doc. No.","Buy-from Vendor No.");
                                                                END ELSE
                                                                  IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." = '') THEN
                                                                    SetAmountToApply("Applies-to Doc. No.","Buy-from Vendor No.")
                                                                  ELSE
                                                                    IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') THEN
                                                                      SetAmountToApply(xRec."Applies-to Doc. No.","Buy-from Vendor No.");
                                                              END;

                                                   OnLookup=VAR
                                                              GenJnlLine@1001 : Record 81;
                                                              GenJnlApply@1000 : Codeunit 225;
                                                              ApplyVendEntries@1002 : Page 233;
                                                            BEGIN
                                                              TESTFIELD("Bal. Account No.",'');
                                                              VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
                                                              VendLedgEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
                                                              VendLedgEntry.SETRANGE(Open,TRUE);
                                                              IF "Applies-to Doc. No." <> '' THEN BEGIN
                                                                VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                                                                VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                                                                IF VendLedgEntry.FINDFIRST THEN;
                                                                VendLedgEntry.SETRANGE("Document Type");
                                                                VendLedgEntry.SETRANGE("Document No.");
                                                              END ELSE
                                                                IF "Applies-to Doc. Type" <> 0 THEN BEGIN
                                                                  VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                                                                  IF VendLedgEntry.FINDFIRST THEN;
                                                                  VendLedgEntry.SETRANGE("Document Type");
                                                                END ELSE
                                                                  IF Amount <> 0 THEN BEGIN
                                                                    VendLedgEntry.SETRANGE(Positive,Amount < 0);
                                                                    IF VendLedgEntry.FINDFIRST THEN;
                                                                    VendLedgEntry.SETRANGE(Positive);
                                                                  END;
                                                              ApplyVendEntries.SetPurch(Rec,VendLedgEntry,PurchHeader.FIELDNO("Applies-to Doc. No."));
                                                              ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
                                                              ApplyVendEntries.SETRECORD(VendLedgEntry);
                                                              ApplyVendEntries.LOOKUPMODE(TRUE);
                                                              IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                                                ApplyVendEntries.GetVendLedgEntry(VendLedgEntry);
                                                                GenJnlApply.CheckAgainstApplnCurrency(
                                                                  "Currency Code",VendLedgEntry."Currency Code",GenJnlLine."Account Type"::Vendor,TRUE);
                                                                "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                                                                "Applies-to Doc. No." := VendLedgEntry."Document No.";
                                                              END;
                                                              CLEAR(ApplyVendEntries);
                                                            END;

                                                   CaptionML=[DAN=Udligningsbilagsnr.;
                                                              ENU=Applies-to Doc. No.] }
    { 55  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
                                                   OnValidate=BEGIN
                                                                IF "Bal. Account No." <> '' THEN
                                                                  CASE "Bal. Account Type" OF
                                                                    "Bal. Account Type"::"G/L Account":
                                                                      BEGIN
                                                                        GLAcc.GET("Bal. Account No.");
                                                                        GLAcc.CheckGLAcc;
                                                                        GLAcc.TESTFIELD("Direct Posting",TRUE);
                                                                      END;
                                                                    "Bal. Account Type"::"Bank Account":
                                                                      BEGIN
                                                                        BankAcc.GET("Bal. Account No.");
                                                                        BankAcc.TESTFIELD(Blocked,FALSE);
                                                                        BankAcc.TESTFIELD("Currency Code","Currency Code");
                                                                      END;
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 56  ;   ;Recalculate Invoice Disc.;Boolean  ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Purchase Line" WHERE (Document Type=FIELD(Document Type),
                                                                                            Document No.=FIELD(No.),
                                                                                            Recalculate Invoice Disc.=CONST(Yes)));
                                                   CaptionML=[DAN=Genberegn fakturarabat;
                                                              ENU=Recalculate Invoice Disc.];
                                                   Editable=No }
    { 57  ;   ;Receive             ;Boolean       ;CaptionML=[DAN=Modtag;
                                                              ENU=Receive] }
    { 58  ;   ;Invoice             ;Boolean       ;CaptionML=[DAN=Fakturer;
                                                              ENU=Invoice] }
    { 59  ;   ;Print Posted Documents;Boolean     ;CaptionML=[DAN=Udskriv bogfõrte dokumenter;
                                                              ENU=Print Posted Documents] }
    { 60  ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line".Amount WHERE (Document Type=FIELD(Document Type),
                                                                                                 Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Amount Including VAT;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Amount Including VAT" WHERE (Document Type=FIELD(Document Type),
                                                                                                                 Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Belõb inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 62  ;   ;Receiving No.       ;Code20        ;CaptionML=[DAN=Kõbslev.nr.;
                                                              ENU=Receiving No.] }
    { 63  ;   ;Posting No.         ;Code20        ;CaptionML=[DAN=Tildelt fakturanr.;
                                                              ENU=Posting No.] }
    { 64  ;   ;Last Receiving No.  ;Code20        ;TableRelation="Purch. Rcpt. Header";
                                                   CaptionML=[DAN=Sidste kõbslev.nr.;
                                                              ENU=Last Receiving No.];
                                                   Editable=No }
    { 65  ;   ;Last Posting No.    ;Code20        ;TableRelation="Purch. Inv. Header";
                                                   CaptionML=[DAN=Sidste fakturanr.;
                                                              ENU=Last Posting No.];
                                                   Editable=No }
    { 66  ;   ;Vendor Order No.    ;Code35        ;CaptionML=[DAN=Kreditors ordrenr.;
                                                              ENU=Vendor Order No.] }
    { 67  ;   ;Vendor Shipment No. ;Code35        ;CaptionML=[DAN=Kreditors lev.nr.;
                                                              ENU=Vendor Shipment No.] }
    { 68  ;   ;Vendor Invoice No.  ;Code35        ;OnValidate=VAR
                                                                VendorLedgerEntry@1000 : Record 25;
                                                              BEGIN
                                                                IF "Vendor Invoice No." <> '' THEN
                                                                  IF FindPostedDocumentWithSameExternalDocNo(VendorLedgerEntry,"Vendor Invoice No.") THEN
                                                                    ShowExternalDocAlreadyExistNotification(VendorLedgerEntry)
                                                                  ELSE
                                                                    RecallExternalDocAlreadyExistsNotification;
                                                              END;

                                                   CaptionML=[DAN=Kreditors fakturanr.;
                                                              ENU=Vendor Invoice No.] }
    { 69  ;   ;Vendor Cr. Memo No. ;Code35        ;OnValidate=VAR
                                                                VendorLedgerEntry@1000 : Record 25;
                                                              BEGIN
                                                                IF "Vendor Cr. Memo No." <> '' THEN
                                                                  IF FindPostedDocumentWithSameExternalDocNo(VendorLedgerEntry,"Vendor Cr. Memo No.") THEN
                                                                    ShowExternalDocAlreadyExistNotification(VendorLedgerEntry)
                                                                  ELSE
                                                                    RecallExternalDocAlreadyExistsNotification;
                                                              END;

                                                   CaptionML=[DAN=Kreditors kr.notanr.;
                                                              ENU=Vendor Cr. Memo No.] }
    { 70  ;   ;VAT Registration No.;Text20        ;CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
    { 72  ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   OnValidate=BEGIN
                                                                IF ("Document Type" = "Document Type"::Order) AND
                                                                   (xRec."Sell-to Customer No." <> "Sell-to Customer No.")
                                                                THEN BEGIN
                                                                  PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
                                                                  PurchLine.SETRANGE("Document No.","No.");
                                                                  PurchLine.SETFILTER("Sales Order Line No.",'<>0');
                                                                  IF NOT PurchLine.ISEMPTY THEN
                                                                    ERROR(
                                                                      YouCannotChangeFieldErr,
                                                                      FIELDCAPTION("Sell-to Customer No."));

                                                                  PurchLine.SETRANGE("Sales Order Line No.");
                                                                  PurchLine.SETFILTER("Special Order Sales Line No.",'<>0');
                                                                  IF NOT PurchLine.ISEMPTY THEN
                                                                    ERROR(
                                                                      YouCannotChangeFieldErr,
                                                                      FIELDCAPTION("Sell-to Customer No."));
                                                                END;

                                                                IF "Sell-to Customer No." = '' THEN
                                                                  VALIDATE("Location Code",UserSetupMgt.GetLocation(1,'',"Responsibility Center"))
                                                                ELSE
                                                                  VALIDATE("Ship-to Code",'');
                                                              END;

                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.] }
    { 73  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 74  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                IF (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") AND
                                                                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group")
                                                                THEN BEGIN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                                                                    "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                                                                  RecreatePurchLines(FIELDCAPTION("Gen. Bus. Posting Group"));
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 76  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   OnValidate=BEGIN
                                                                UpdatePurchLines(FIELDCAPTION("Transaction Type"),CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type] }
    { 77  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   OnValidate=BEGIN
                                                                UpdatePurchLines(FIELDCAPTION("Transport Method"),CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=TransportmÜde;
                                                              ENU=Transport Method] }
    { 78  ;   ;VAT Country/Region Code;Code10     ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for moms;
                                                              ENU=VAT Country/Region Code] }
    { 79  ;   ;Buy-from Vendor Name;Text50        ;TableRelation=Vendor;
                                                   OnValidate=VAR
                                                                Vendor@1000 : Record 23;
                                                              BEGIN
                                                                VALIDATE("Buy-from Vendor No.",Vendor.GetVendorNo("Buy-from Vendor Name"));
                                                              END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Leverandõrnavn;
                                                              ENU=Buy-from Vendor Name] }
    { 80  ;   ;Buy-from Vendor Name 2;Text50      ;CaptionML=[DAN=Leverandõrnavn 2;
                                                              ENU=Buy-from Vendor Name 2] }
    { 81  ;   ;Buy-from Address    ;Text50        ;OnValidate=BEGIN
                                                                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to Address"));
                                                                ModifyVendorAddress;
                                                              END;

                                                   CaptionML=[DAN=Leverandõradresse;
                                                              ENU=Buy-from Address] }
    { 82  ;   ;Buy-from Address 2  ;Text50        ;OnValidate=BEGIN
                                                                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to Address 2"));
                                                                ModifyVendorAddress;
                                                              END;

                                                   CaptionML=[DAN=Leverandõradresse 2;
                                                              ENU=Buy-from Address 2] }
    { 83  ;   ;Buy-from City       ;Text30        ;TableRelation=IF (Buy-from Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Buy-from Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Buy-from Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(
                                                                  "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to City"));
                                                                ModifyVendorAddress;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leverandõrby;
                                                              ENU=Buy-from City] }
    { 84  ;   ;Buy-from Contact    ;Text50        ;OnValidate=BEGIN
                                                                ModifyVendorAddress;
                                                              END;

                                                   OnLookup=VAR
                                                              Contact@1001 : Record 5050;
                                                            BEGIN
                                                              IF "Buy-from Vendor No." = '' THEN
                                                                EXIT;

                                                              LookupContact("Buy-from Vendor No.","Buy-from Contact No.",Contact);
                                                              IF PAGE.RUNMODAL(0,Contact) = ACTION::LookupOK THEN
                                                                VALIDATE("Buy-from Contact No.",Contact."No.");
                                                            END;

                                                   CaptionML=[DAN=Leverandõrattention;
                                                              ENU=Buy-from Contact] }
    { 85  ;   ;Pay-to Post Code    ;Code20        ;TableRelation=IF (Pay-to Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Pay-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Pay-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(
                                                                  "Pay-to City","Pay-to Post Code","Pay-to County","Pay-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                                ModifyPayToVendorAddress;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Pay-to Post Code] }
    { 86  ;   ;Pay-to County       ;Text30        ;OnValidate=BEGIN
                                                                ModifyPayToVendorAddress;
                                                              END;

                                                   CaptionML=[DAN=Amt;
                                                              ENU=Pay-to County] }
    { 87  ;   ;Pay-to Country/Region Code;Code10  ;TableRelation=Country/Region;
                                                   OnValidate=BEGIN
                                                                ModifyPayToVendorAddress;
                                                              END;

                                                   CaptionML=[DAN=Lande-/omrÜdekode til fakturering;
                                                              ENU=Pay-to Country/Region Code] }
    { 88  ;   ;Buy-from Post Code  ;Code20        ;TableRelation=IF (Buy-from Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Buy-from Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Buy-from Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(
                                                                  "Buy-from City","Buy-from Post Code","Buy-from County","Buy-from Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to Post Code"));
                                                                ModifyVendorAddress;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leverandõrpostnr.;
                                                              ENU=Buy-from Post Code] }
    { 89  ;   ;Buy-from County     ;Text30        ;OnValidate=BEGIN
                                                                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to County"));
                                                                ModifyVendorAddress;
                                                              END;

                                                   CaptionML=[DAN=Leverandõramt;
                                                              ENU=Buy-from County] }
    { 90  ;   ;Buy-from Country/Region Code;Code10;TableRelation=Country/Region;
                                                   OnValidate=BEGIN
                                                                UpdatePayToAddressFromBuyFromAddress(FIELDNO("Pay-to Country/Region Code"));
                                                                ModifyVendorAddress;
                                                              END;

                                                   CaptionML=[DAN=Lande-/omrÜdekode for leverandõr;
                                                              ENU=Buy-from Country/Region Code] }
    { 91  ;   ;Ship-to Post Code   ;Code20        ;TableRelation=IF (Ship-to Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(
                                                                  "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leveringspostnr.;
                                                              ENU=Ship-to Post Code] }
    { 92  ;   ;Ship-to County      ;Text30        ;CaptionML=[DAN=Leveringsamt;
                                                              ENU=Ship-to County] }
    { 93  ;   ;Ship-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for levering;
                                                              ENU=Ship-to Country/Region Code] }
    { 94  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Bankkonto;
                                                                    ENU=G/L Account,Bank Account];
                                                   OptionString=G/L Account,Bank Account }
    { 95  ;   ;Order Address Code  ;Code10        ;TableRelation="Order Address".Code WHERE (Vendor No.=FIELD(Buy-from Vendor No.));
                                                   OnValidate=BEGIN
                                                                IF "Order Address Code" <> '' THEN BEGIN
                                                                  OrderAddr.GET("Buy-from Vendor No.","Order Address Code");
                                                                  "Buy-from Vendor Name" := OrderAddr.Name;
                                                                  "Buy-from Vendor Name 2" := OrderAddr."Name 2";
                                                                  "Buy-from Address" := OrderAddr.Address;
                                                                  "Buy-from Address 2" := OrderAddr."Address 2";
                                                                  "Buy-from City" := OrderAddr.City;
                                                                  "Buy-from Contact" := OrderAddr.Contact;
                                                                  "Buy-from Post Code" := OrderAddr."Post Code";
                                                                  "Buy-from County" := OrderAddr.County;
                                                                  "Buy-from Country/Region Code" := OrderAddr."Country/Region Code";

                                                                  IF IsCreditDocType THEN BEGIN
                                                                    SetShipToAddress(
                                                                      OrderAddr.Name,OrderAddr."Name 2",OrderAddr.Address,OrderAddr."Address 2",
                                                                      OrderAddr.City,OrderAddr."Post Code",OrderAddr.County,OrderAddr."Country/Region Code");
                                                                    "Ship-to Contact" := OrderAddr.Contact;
                                                                  END
                                                                END ELSE BEGIN
                                                                  GetVend("Buy-from Vendor No.");
                                                                  "Buy-from Vendor Name" := Vend.Name;
                                                                  "Buy-from Vendor Name 2" := Vend."Name 2";
                                                                  CopyBuyFromVendorAddressFieldsFromVendor(Vend,TRUE);

                                                                  IF IsCreditDocType THEN BEGIN
                                                                    "Ship-to Name" := Vend.Name;
                                                                    "Ship-to Name 2" := Vend."Name 2";
                                                                    CopyShipToVendorAddressFieldsFromVendor(Vend,TRUE);
                                                                    "Ship-to Contact" := Vend.Contact;
                                                                    "Shipment Method Code" := Vend."Shipment Method Code";
                                                                    IF Vend."Location Code" <> '' THEN
                                                                      VALIDATE("Location Code",Vend."Location Code");
                                                                  END
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Bestillingsadressekode;
                                                              ENU=Order Address Code] }
    { 97  ;   ;Entry Point         ;Code10        ;TableRelation="Entry/Exit Point";
                                                   OnValidate=BEGIN
                                                                UpdatePurchLines(FIELDCAPTION("Entry Point"),CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=Indfõrselssted;
                                                              ENU=Entry Point] }
    { 98  ;   ;Correction          ;Boolean       ;CaptionML=[DAN=Rettelse;
                                                              ENU=Correction] }
    { 99  ;   ;Document Date       ;Date          ;OnValidate=BEGIN
                                                                IF xRec."Document Date" <> "Document Date" THEN
                                                                  UpdateDocumentDate := TRUE;
                                                                VALIDATE("Payment Terms Code");
                                                                VALIDATE("Prepmt. Payment Terms Code");
                                                              END;

                                                   CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 101 ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   OnValidate=BEGIN
                                                                UpdatePurchLines(FIELDCAPTION(Area),CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=OmrÜde;
                                                              ENU=Area] }
    { 102 ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   OnValidate=BEGIN
                                                                UpdatePurchLines(FIELDCAPTION("Transaction Specification"),CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 104 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   OnValidate=BEGIN
                                                                PaymentMethod.INIT;
                                                                IF "Payment Method Code" <> '' THEN
                                                                  PaymentMethod.GET("Payment Method Code");
                                                                "Bal. Account Type" := PaymentMethod."Bal. Account Type";
                                                                "Bal. Account No." := PaymentMethod."Bal. Account No.";
                                                                IF "Bal. Account No." <> '' THEN BEGIN
                                                                  TESTFIELD("Applies-to Doc. No.",'');
                                                                  TESTFIELD("Applies-to ID",'');
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 107 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 108 ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Posting No. Series" <> '' THEN BEGIN
                                                                  PurchSetup.GET;
                                                                  TestNoSeries;
                                                                  NoSeriesMgt.TestSeries(GetPostingNoSeriesCode,"Posting No. Series");
                                                                END;
                                                                TESTFIELD("Posting No.",'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              WITH PurchHeader DO BEGIN
                                                                PurchHeader := Rec;
                                                                PurchSetup.GET;
                                                                TestNoSeries;
                                                                IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode,"Posting No. Series") THEN
                                                                  VALIDATE("Posting No. Series");
                                                                Rec := PurchHeader;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Bogfõringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 109 ;   ;Receiving No. Series;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Receiving No. Series" <> '' THEN BEGIN
                                                                  PurchSetup.GET;
                                                                  PurchSetup.TESTFIELD("Posted Receipt Nos.");
                                                                  NoSeriesMgt.TestSeries(PurchSetup."Posted Receipt Nos.","Receiving No. Series");
                                                                END;
                                                                TESTFIELD("Receiving No.",'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              WITH PurchHeader DO BEGIN
                                                                PurchHeader := Rec;
                                                                PurchSetup.GET;
                                                                PurchSetup.TESTFIELD("Posted Receipt Nos.");
                                                                IF NoSeriesMgt.LookupSeries(PurchSetup."Posted Receipt Nos.","Receiving No. Series") THEN
                                                                  VALIDATE("Receiving No. Series");
                                                                Rec := PurchHeader;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Kõbslev. nummerserie;
                                                              ENU=Receiving No. Series] }
    { 114 ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                MessageIfPurchLinesExist(FIELDCAPTION("Tax Area Code"));
                                                              END;

                                                   CaptionML=[DAN=SkatteomrÜdekode;
                                                              ENU=Tax Area Code] }
    { 115 ;   ;Tax Liable          ;Boolean       ;OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                MessageIfPurchLinesExist(FIELDCAPTION("Tax Liable"));
                                                              END;

                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 116 ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                IF (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") AND
                                                                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                                                                THEN
                                                                  RecreatePurchLines(FIELDCAPTION("VAT Bus. Posting Group"));
                                                              END;

                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 118 ;   ;Applies-to ID       ;Code50        ;OnValidate=VAR
                                                                TempVendLedgEntry@1000 : TEMPORARY Record 25;
                                                                VendEntrySetApplID@1001 : Codeunit 111;
                                                              BEGIN
                                                                IF "Applies-to ID" <> '' THEN
                                                                  TESTFIELD("Bal. Account No.",'');
                                                                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN BEGIN
                                                                  VendLedgEntry.SETCURRENTKEY("Vendor No.",Open);
                                                                  VendLedgEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
                                                                  VendLedgEntry.SETRANGE(Open,TRUE);
                                                                  VendLedgEntry.SETRANGE("Applies-to ID",xRec."Applies-to ID");
                                                                  IF VendLedgEntry.FINDFIRST THEN
                                                                    VendEntrySetApplID.SetApplId(VendLedgEntry,TempVendLedgEntry,'');
                                                                  VendLedgEntry.RESET;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Udlignings-id;
                                                              ENU=Applies-to ID] }
    { 119 ;   ;VAT Base Discount % ;Decimal       ;OnValidate=BEGIN
                                                                GLSetup.GET;
                                                                IF "VAT Base Discount %" > GLSetup."VAT Tolerance %" THEN BEGIN
                                                                  IF HideValidationDialog THEN
                                                                    Confirmed := TRUE
                                                                  ELSE
                                                                    Confirmed :=
                                                                      CONFIRM(
                                                                        Text007 +
                                                                        Text008,FALSE,
                                                                        FIELDCAPTION("VAT Base Discount %"),
                                                                        GLSetup.FIELDCAPTION("VAT Tolerance %"),
                                                                        GLSetup.TABLECAPTION);
                                                                  IF NOT Confirmed THEN
                                                                    "VAT Base Discount %" := xRec."VAT Base Discount %";
                                                                END;

                                                                IF ("VAT Base Discount %" = xRec."VAT Base Discount %") AND
                                                                   (CurrFieldNo <> 0)
                                                                THEN
                                                                  EXIT;

                                                                PurchLine.SETRANGE("Document Type","Document Type");
                                                                PurchLine.SETRANGE("Document No.","No.");
                                                                PurchLine.SETFILTER(Type,'<>%1',PurchLine.Type::" ");
                                                                PurchLine.SETFILTER(Quantity,'<>0');
                                                                PurchLine.LOCKTABLE;
                                                                IF PurchLine.FINDSET THEN BEGIN
                                                                  MODIFY;
                                                                  REPEAT
                                                                    PurchLine.UpdateAmounts;
                                                                    PurchLine.MODIFY;
                                                                  UNTIL PurchLine.NEXT = 0;
                                                                END;
                                                                PurchLine.RESET;
                                                              END;

                                                   CaptionML=[DAN=Momsgrundlagsrabat %;
                                                              ENU=VAT Base Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 120 ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=èben,Frigivet,Afventer godkendelse,Afventer forudbetaling;
                                                                    ENU=Open,Released,Pending Approval,Pending Prepayment];
                                                   OptionString=Open,Released,Pending Approval,Pending Prepayment;
                                                   Editable=No }
    { 121 ;   ;Invoice Discount Calculation;Option;CaptionML=[DAN=Beregning af fakturarabat;
                                                              ENU=Invoice Discount Calculation];
                                                   OptionCaptionML=[DAN=Ingen,%,Belõb;
                                                                    ENU=None,%,Amount];
                                                   OptionString=None,%,Amount;
                                                   Editable=No }
    { 122 ;   ;Invoice Discount Value;Decimal     ;CaptionML=[DAN=Fakturarabatvërdi;
                                                              ENU=Invoice Discount Value];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 123 ;   ;Send IC Document    ;Boolean       ;OnValidate=BEGIN
                                                                IF "Send IC Document" THEN BEGIN
                                                                  TESTFIELD("Buy-from IC Partner Code");
                                                                  TESTFIELD("IC Direction","IC Direction"::Outgoing);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Send IC-dokument;
                                                              ENU=Send IC Document] }
    { 124 ;   ;IC Status           ;Option        ;CaptionML=[DAN=IC-status;
                                                              ENU=IC Status];
                                                   OptionCaptionML=[DAN=Ny,Ventende,Sendt;
                                                                    ENU=New,Pending,Sent];
                                                   OptionString=New,Pending,Sent }
    { 125 ;   ;Buy-from IC Partner Code;Code20    ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=Leverandõrkode for IC-partner;
                                                              ENU=Buy-from IC Partner Code];
                                                   Editable=No }
    { 126 ;   ;Pay-to IC Partner Code;Code20      ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=Fakt.kode for IC-partner;
                                                              ENU=Pay-to IC Partner Code];
                                                   Editable=No }
    { 129 ;   ;IC Direction        ;Option        ;OnValidate=BEGIN
                                                                IF "IC Direction" = "IC Direction"::Incoming THEN
                                                                  "Send IC Document" := FALSE;
                                                              END;

                                                   CaptionML=[DAN=IC-retning;
                                                              ENU=IC Direction];
                                                   OptionCaptionML=[DAN=UdgÜende,IndgÜende;
                                                                    ENU=Outgoing,Incoming];
                                                   OptionString=Outgoing,Incoming }
    { 130 ;   ;Prepayment No.      ;Code20        ;CaptionML=[DAN=Forudbetalingsnr.;
                                                              ENU=Prepayment No.] }
    { 131 ;   ;Last Prepayment No. ;Code20        ;TableRelation="Purch. Inv. Header";
                                                   CaptionML=[DAN=Sidste forudbetalingsnr.;
                                                              ENU=Last Prepayment No.] }
    { 132 ;   ;Prepmt. Cr. Memo No.;Code20        ;CaptionML=[DAN=Forudbetalingskreditnota nr.;
                                                              ENU=Prepmt. Cr. Memo No.] }
    { 133 ;   ;Last Prepmt. Cr. Memo No.;Code20   ;TableRelation="Purch. Cr. Memo Hdr.";
                                                   CaptionML=[DAN=Sidste forudbetalingskreditnota nr.;
                                                              ENU=Last Prepmt. Cr. Memo No.] }
    { 134 ;   ;Prepayment %        ;Decimal       ;OnValidate=BEGIN
                                                                IF xRec."Prepayment %" <> "Prepayment %" THEN
                                                                  UpdatePurchLines(FIELDCAPTION("Prepayment %"),CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=Forudbetaling i %;
                                                              ENU=Prepayment %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 135 ;   ;Prepayment No. Series;Code20       ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Prepayment No. Series" <> '' THEN BEGIN
                                                                  PurchSetup.GET;
                                                                  PurchSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                                                                  NoSeriesMgt.TestSeries(GetPostingPrepaymentNoSeriesCode,"Prepayment No. Series");
                                                                END;
                                                                TESTFIELD("Prepayment No.",'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              WITH PurchHeader DO BEGIN
                                                                PurchHeader := Rec;
                                                                PurchSetup.GET;
                                                                PurchSetup.TESTFIELD("Posted Prepmt. Inv. Nos.");
                                                                IF NoSeriesMgt.LookupSeries(GetPostingPrepaymentNoSeriesCode,"Prepayment No. Series") THEN
                                                                  VALIDATE("Prepayment No. Series");
                                                                Rec := PurchHeader;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Forudbetalingsnummerserie;
                                                              ENU=Prepayment No. Series] }
    { 136 ;   ;Compress Prepayment ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Komprimer forudbetaling;
                                                              ENU=Compress Prepayment] }
    { 137 ;   ;Prepayment Due Date ;Date          ;CaptionML=[DAN=Forfaldsdato for forudbetaling;
                                                              ENU=Prepayment Due Date] }
    { 138 ;   ;Prepmt. Cr. Memo No. Series;Code20 ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Prepmt. Cr. Memo No. Series" <> '' THEN BEGIN
                                                                  PurchSetup.GET;
                                                                  PurchSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                                                                  NoSeriesMgt.TestSeries(GetPostingPrepaymentNoSeriesCode,"Prepmt. Cr. Memo No. Series");
                                                                END;
                                                                TESTFIELD("Prepmt. Cr. Memo No.",'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              WITH PurchHeader DO BEGIN
                                                                PurchHeader := Rec;
                                                                PurchSetup.GET;
                                                                PurchSetup.TESTFIELD("Posted Prepmt. Cr. Memo Nos.");
                                                                IF NoSeriesMgt.LookupSeries(GetPostingPrepaymentNoSeriesCode,"Prepmt. Cr. Memo No. Series") THEN
                                                                  VALIDATE("Prepmt. Cr. Memo No. Series");
                                                                Rec := PurchHeader;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Nummerserie til forudbetalingskreditnota;
                                                              ENU=Prepmt. Cr. Memo No. Series] }
    { 139 ;   ;Prepmt. Posting Description;Text50 ;CaptionML=[DAN=Beskrivelse af bogfõrt forudbetaling;
                                                              ENU=Prepmt. Posting Description] }
    { 142 ;   ;Prepmt. Pmt. Discount Date;Date    ;CaptionML=[DAN=Forudb. - dato for kont.rabat;
                                                              ENU=Prepmt. Pmt. Discount Date] }
    { 143 ;   ;Prepmt. Payment Terms Code;Code10  ;TableRelation="Payment Terms";
                                                   OnValidate=VAR
                                                                PaymentTerms@1000 : Record 3;
                                                              BEGIN
                                                                IF ("Prepmt. Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                                                                  PaymentTerms.GET("Prepmt. Payment Terms Code");
                                                                  IF IsCreditDocType AND NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                                                                    VALIDATE("Prepayment Due Date","Document Date");
                                                                    VALIDATE("Prepmt. Pmt. Discount Date",0D);
                                                                    VALIDATE("Prepmt. Payment Discount %",0);
                                                                  END ELSE BEGIN
                                                                    "Prepayment Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                                                                    "Prepmt. Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                                                                    IF NOT UpdateDocumentDate THEN
                                                                      VALIDATE("Prepmt. Payment Discount %",PaymentTerms."Discount %")
                                                                  END;
                                                                END ELSE BEGIN
                                                                  VALIDATE("Prepayment Due Date","Document Date");
                                                                  IF NOT UpdateDocumentDate THEN BEGIN
                                                                    VALIDATE("Prepmt. Pmt. Discount Date",0D);
                                                                    VALIDATE("Prepmt. Payment Discount %",0);
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Forudb. - kode for betal.betingelser;
                                                              ENU=Prepmt. Payment Terms Code] }
    { 144 ;   ;Prepmt. Payment Discount %;Decimal ;OnValidate=BEGIN
                                                                IF NOT (CurrFieldNo IN [0,FIELDNO("Posting Date"),FIELDNO("Document Date")]) THEN
                                                                  TESTFIELD(Status,Status::Open);
                                                                GLSetup.GET;
                                                                IF "Payment Discount %" < GLSetup."VAT Tolerance %" THEN
                                                                  "VAT Base Discount %" := "Payment Discount %"
                                                                ELSE
                                                                  "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                                                                VALIDATE("VAT Base Discount %");
                                                              END;

                                                   CaptionML=[DAN=Forudb. - kontantrabat i %;
                                                              ENU=Prepmt. Payment Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 151 ;   ;Quote No.           ;Code20        ;CaptionML=[DAN=Tilbudsnr.;
                                                              ENU=Quote No.];
                                                   Editable=No }
    { 160 ;   ;Job Queue Status    ;Option        ;OnLookup=VAR
                                                              JobQueueEntry@1000 : Record 472;
                                                            BEGIN
                                                              IF "Job Queue Status" = "Job Queue Status"::" " THEN
                                                                EXIT;
                                                              JobQueueEntry.ShowStatusMsg("Job Queue Entry ID");
                                                            END;

                                                   CaptionML=[DAN=Opgavekõstatus;
                                                              ENU=Job Queue Status];
                                                   OptionCaptionML=[DAN=" ,Planlagt til bogfõring,Fejl,Bogfõring";
                                                                    ENU=" ,Scheduled for Posting,Error,Posting"];
                                                   OptionString=[ ,Scheduled for Posting,Error,Posting];
                                                   Editable=No }
    { 161 ;   ;Job Queue Entry ID  ;GUID          ;CaptionML=[DAN=Opgavekõpost-id;
                                                              ENU=Job Queue Entry ID];
                                                   Editable=No }
    { 165 ;   ;Incoming Document Entry No.;Integer;TableRelation="Incoming Document";
                                                   OnValidate=VAR
                                                                IncomingDocument@1000 : Record 130;
                                                              BEGIN
                                                                IF "Incoming Document Entry No." = xRec."Incoming Document Entry No." THEN
                                                                  EXIT;
                                                                IF "Incoming Document Entry No." = 0 THEN
                                                                  IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                                                                ELSE
                                                                  IncomingDocument.SetPurchDoc(Rec);
                                                              END;

                                                   CaptionML=[DAN=Lõbenr. for indgÜende bilag;
                                                              ENU=Incoming Document Entry No.] }
    { 170 ;   ;Creditor No.        ;Code20        ;CaptionML=[DAN=Kreditornr.;
                                                              ENU=Creditor No.];
                                                   Numeric=Yes }
    { 171 ;   ;Payment Reference   ;Code50        ;CaptionML=[DAN=Betalingsreference;
                                                              ENU=Payment Reference];
                                                   Numeric=Yes }
    { 300 ;   ;A. Rcd. Not Inv. Ex. VAT (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."A. Rcd. Not Inv. Ex. VAT (LCY)" WHERE (Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Belõb modtaget, men ikke faktureret (RV);
                                                              ENU=Amount Received Not Invoiced (LCY)] }
    { 301 ;   ;Amt. Rcd. Not Invoiced (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Amt. Rcd. Not Invoiced (LCY)" WHERE (Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Belõb modtaget, men ikke faktureret (RV), inkl, moms;
                                                              ENU=Amount Received Not Invoiced (LCY) Incl. VAT] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=BEGIN
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDocDim;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 1305;   ;Invoice Discount Amount;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Inv. Discount Amount" WHERE (Document No.=FIELD(No.),
                                                                                                                 Document Type=FIELD(Document Type)));
                                                   CaptionML=[DAN=Fakturarabatbelõb;
                                                              ENU=Invoice Discount Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5043;   ;No. of Archived Versions;Integer   ;FieldClass=FlowField;
                                                   CalcFormula=Max("Purchase Header Archive"."Version No." WHERE (Document Type=FIELD(Document Type),
                                                                                                                  No.=FIELD(No.),
                                                                                                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence)));
                                                   CaptionML=[DAN=Antal arkiverede vers.;
                                                              ENU=No. of Archived Versions];
                                                   Editable=No }
    { 5048;   ;Doc. No. Occurrence ;Integer       ;CaptionML=[DAN=Forekomster af dok.nr.;
                                                              ENU=Doc. No. Occurrence] }
    { 5050;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::Campaign,"Campaign No.",
                                                                  DATABASE::Vendor,"Pay-to Vendor No.",
                                                                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                                                                  DATABASE::"Responsibility Center","Responsibility Center");
                                                              END;

                                                   CaptionML=[DAN=Kampagnenr.;
                                                              ENU=Campaign No.] }
    { 5052;   ;Buy-from Contact No.;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                ContBusinessRelation@1000 : Record 5054;
                                                                Cont@1002 : Record 5050;
                                                              BEGIN
                                                                TESTFIELD(Status,Status::Open);

                                                                IF "Buy-from Contact No." <> '' THEN
                                                                  IF Cont.GET("Buy-from Contact No.") THEN
                                                                    Cont.CheckIfPrivacyBlockedGeneric;

                                                                IF ("Buy-from Contact No." <> xRec."Buy-from Contact No.") AND
                                                                   (xRec."Buy-from Contact No." <> '')
                                                                THEN BEGIN
                                                                  IF HideValidationDialog THEN
                                                                    Confirmed := TRUE
                                                                  ELSE
                                                                    Confirmed := CONFIRM(ConfirmChangeQst,FALSE,FIELDCAPTION("Buy-from Contact No."));
                                                                  IF Confirmed THEN BEGIN
                                                                    IF InitFromContact("Buy-from Contact No.","Buy-from Vendor No.",FIELDCAPTION("Buy-from Contact No.")) THEN
                                                                      EXIT
                                                                  END ELSE BEGIN
                                                                    Rec := xRec;
                                                                    EXIT;
                                                                  END;
                                                                END;

                                                                IF ("Buy-from Vendor No." <> '') AND ("Buy-from Contact No." <> '') THEN BEGIN
                                                                  Cont.GET("Buy-from Contact No.");
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Vendor,"Buy-from Vendor No.") THEN
                                                                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                                                                      ERROR(Text038,Cont."No.",Cont.Name,"Buy-from Vendor No.");
                                                                END;

                                                                UpdateBuyFromVend("Buy-from Contact No.");
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1001 : Record 5050;
                                                              ContBusinessRelation@1000 : Record 5054;
                                                            BEGIN
                                                              IF "Buy-from Vendor No." <> '' THEN
                                                                IF Cont.GET("Buy-from Contact No.") THEN
                                                                  Cont.SETRANGE("Company No.",Cont."Company No.")
                                                                ELSE
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Vendor,"Buy-from Vendor No.") THEN
                                                                    Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.")
                                                                  ELSE
                                                                    Cont.SETRANGE("No.",'');

                                                              IF "Buy-from Contact No." <> '' THEN
                                                                IF Cont.GET("Buy-from Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                                                xRec := Rec;
                                                                VALIDATE("Buy-from Contact No.",Cont."No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Leverandõrattentionnr.;
                                                              ENU=Buy-from Contact No.] }
    { 5053;   ;Pay-to Contact No.  ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                ContBusinessRelation@1004 : Record 5054;
                                                                Cont@1002 : Record 5050;
                                                              BEGIN
                                                                TESTFIELD(Status,Status::Open);

                                                                IF "Pay-to Contact No." <> '' THEN
                                                                  IF Cont.GET("Pay-to Contact No.") THEN
                                                                    Cont.CheckIfPrivacyBlockedGeneric;

                                                                IF ("Pay-to Contact No." <> xRec."Pay-to Contact No.") AND
                                                                   (xRec."Pay-to Contact No." <> '')
                                                                THEN BEGIN
                                                                  IF HideValidationDialog THEN
                                                                    Confirmed := TRUE
                                                                  ELSE
                                                                    Confirmed := CONFIRM(ConfirmChangeQst,FALSE,FIELDCAPTION("Pay-to Contact No."));
                                                                  IF Confirmed THEN BEGIN
                                                                    IF InitFromContact("Pay-to Contact No.","Pay-to Vendor No.",FIELDCAPTION("Pay-to Contact No.")) THEN
                                                                      EXIT
                                                                  END ELSE BEGIN
                                                                    "Pay-to Contact No." := xRec."Pay-to Contact No.";
                                                                    EXIT;
                                                                  END;
                                                                END;

                                                                IF ("Pay-to Vendor No." <> '') AND ("Pay-to Contact No." <> '') THEN BEGIN
                                                                  Cont.GET("Pay-to Contact No.");
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Vendor,"Pay-to Vendor No.") THEN
                                                                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                                                                      ERROR(Text038,Cont."No.",Cont.Name,"Pay-to Vendor No.");
                                                                END;

                                                                UpdatePayToVend("Pay-to Contact No.");
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1000 : Record 5050;
                                                              ContBusinessRelation@1001 : Record 5054;
                                                            BEGIN
                                                              IF "Pay-to Vendor No." <> '' THEN
                                                                IF Cont.GET("Pay-to Contact No.") THEN
                                                                  Cont.SETRANGE("Company No.",Cont."Company No.")
                                                                ELSE
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Vendor,"Pay-to Vendor No.") THEN
                                                                    Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.")
                                                                  ELSE
                                                                    Cont.SETRANGE("No.",'');

                                                              IF "Pay-to Contact No." <> '' THEN
                                                                IF Cont.GET("Pay-to Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                                                xRec := Rec;
                                                                VALIDATE("Pay-to Contact No.",Cont."No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Faktureringsleverandõr - attentionsnr.;
                                                              ENU=Pay-to Contact No.] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
                                                                  ERROR(
                                                                    Text028,
                                                                    RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);

                                                                "Location Code" := UserSetupMgt.GetLocation(1,'',"Responsibility Center");
                                                                IF "Location Code" = '' THEN BEGIN
                                                                  IF InvtSetup.GET THEN
                                                                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                                                                END ELSE BEGIN
                                                                  IF Location.GET("Location Code") THEN;
                                                                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                                                                END;

                                                                UpdateShipToAddress;

                                                                CreateDim(
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::Vendor,"Pay-to Vendor No.",
                                                                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                                                                  DATABASE::Campaign,"Campaign No.");

                                                                IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
                                                                  RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
                                                                  "Assigned User ID" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 5752;   ;Completely Received ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Min("Purchase Line"."Completely Received" WHERE (Document Type=FIELD(Document Type),
                                                                                                                Document No.=FIELD(No.),
                                                                                                                Type=FILTER(<>' '),
                                                                                                                Location Code=FIELD(Location Filter)));
                                                   CaptionML=[DAN=Modtagelse komplet;
                                                              ENU=Completely Received];
                                                   Editable=No }
    { 5753;   ;Posting from Whse. Ref.;Integer    ;AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=Bogfõring fra lagerref.;
                                                              ENU=Posting from Whse. Ref.] }
    { 5754;   ;Location Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Location;
                                                   CaptionML=[DAN=Lokationsfilter;
                                                              ENU=Location Filter] }
    { 5790;   ;Requested Receipt Date;Date        ;OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                IF "Promised Receipt Date" <> 0D THEN
                                                                  ERROR(
                                                                    Text034,
                                                                    FIELDCAPTION("Requested Receipt Date"),
                                                                    FIELDCAPTION("Promised Receipt Date"));

                                                                IF "Requested Receipt Date" <> xRec."Requested Receipt Date" THEN
                                                                  UpdatePurchLines(FIELDCAPTION("Requested Receipt Date"),CurrFieldNo <> 0);
                                                              END;

                                                   AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=ùnsket modtagelsesdato;
                                                              ENU=Requested Receipt Date] }
    { 5791;   ;Promised Receipt Date;Date         ;OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                IF "Promised Receipt Date" <> xRec."Promised Receipt Date" THEN
                                                                  UpdatePurchLines(FIELDCAPTION("Promised Receipt Date"),CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=Bekrëftet modtagelsesdato;
                                                              ENU=Promised Receipt Date] }
    { 5792;   ;Lead Time Calculation;DateFormula  ;OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                LeadTimeMgt.CheckLeadTimeIsNotNegative("Lead Time Calculation");

                                                                IF "Lead Time Calculation" <> xRec."Lead Time Calculation" THEN
                                                                  UpdatePurchLines(FIELDCAPTION("Lead Time Calculation"),CurrFieldNo <> 0);
                                                              END;

                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Leveringstid;
                                                              ENU=Lead Time Calculation] }
    { 5793;   ;Inbound Whse. Handling Time;DateFormula;
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                                IF "Inbound Whse. Handling Time" <> xRec."Inbound Whse. Handling Time" THEN
                                                                  UpdatePurchLines(FIELDCAPTION("Inbound Whse. Handling Time"),CurrFieldNo <> 0);
                                                              END;

                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=IndgÜende lagerekspeditionstid;
                                                              ENU=Inbound Whse. Handling Time] }
    { 5796;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 5800;   ;Vendor Authorization No.;Code35    ;CaptionML=[DAN=Leverandõrautorisationsnr.;
                                                              ENU=Vendor Authorization No.] }
    { 5801;   ;Return Shipment No. ;Code20        ;CaptionML=[DAN=Returvareleverancenr.;
                                                              ENU=Return Shipment No.] }
    { 5802;   ;Return Shipment No. Series;Code20  ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Return Shipment No. Series" <> '' THEN BEGIN
                                                                  PurchSetup.GET;
                                                                  PurchSetup.TESTFIELD("Posted Return Shpt. Nos.");
                                                                  NoSeriesMgt.TestSeries(PurchSetup."Posted Return Shpt. Nos.","Return Shipment No. Series");
                                                                END;
                                                                TESTFIELD("Return Shipment No.",'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              WITH PurchHeader DO BEGIN
                                                                PurchHeader := Rec;
                                                                PurchSetup.GET;
                                                                PurchSetup.TESTFIELD("Posted Return Shpt. Nos.");
                                                                IF NoSeriesMgt.LookupSeries(PurchSetup."Posted Return Shpt. Nos.","Return Shipment No. Series") THEN
                                                                  VALIDATE("Return Shipment No. Series");
                                                                Rec := PurchHeader;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Returvarelev.nummerserie;
                                                              ENU=Return Shipment No. Series] }
    { 5803;   ;Ship                ;Boolean       ;CaptionML=[DAN=Lever;
                                                              ENU=Ship] }
    { 5804;   ;Last Return Shipment No.;Code20    ;TableRelation="Return Shipment Header";
                                                   CaptionML=[DAN=Sidste returvareleverancenr.;
                                                              ENU=Last Return Shipment No.];
                                                   Editable=No }
    { 8000;   ;Id                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 9000;   ;Assigned User ID    ;Code50        ;TableRelation="User Setup";
                                                   OnValidate=BEGIN
                                                                IF NOT UserSetupMgt.CheckRespCenter2(1,"Responsibility Center","Assigned User ID") THEN
                                                                  ERROR(
                                                                    Text049,"Assigned User ID",
                                                                    RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter2("Assigned User ID"));
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
    { 9001;   ;Pending Approvals   ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Approval Entry" WHERE (Table ID=CONST(38),
                                                                                             Document Type=FIELD(Document Type),
                                                                                             Document No.=FIELD(No.),
                                                                                             Status=FILTER(Open|Created)));
                                                   CaptionML=[DAN=UdestÜende godkendelser;
                                                              ENU=Pending Approvals] }
  }
  KEYS
  {
    {    ;Document Type,No.                       ;Clustered=Yes }
    {    ;No.,Document Type                        }
    {    ;Document Type,Buy-from Vendor No.        }
    {    ;Document Type,Pay-to Vendor No.          }
    {    ;Buy-from Vendor No.                      }
    {    ;Incoming Document Entry No.              }
    {    ;Document Date                            }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text003@1003 : TextConst 'DAN=%1 kan ikke omdõbes.;ENU=You cannot rename a %1.';
      ConfirmChangeQst@1004 : TextConst '@@@="%1 = a Field Caption like Currency Code";DAN=Skal %1 ëndres?;ENU=Do you want to change %1?';
      Text005@1005 : TextConst 'DAN=Du kan ikke nulstille %1, fordi dokumentet stadig indeholder en eller flere linjer.;ENU=You cannot reset %1 because the document still has one or more lines.';
      YouCannotChangeFieldErr@1006 : TextConst '@@@=%1 - fieldcaption;DAN=Du kan ikke ëndre %1, fordi ordren er knyttet til en eller flere salgsordrer.;ENU=You cannot change %1 because the order is associated with one or more sales orders.';
      Text007@1007 : TextConst 'DAN=%1 er stõrre end %2 i tabellen %3.\;ENU=%1 is greater than %2 in the %3 table.\';
      Text008@1008 : TextConst 'DAN=Bekrëft ëndring?;ENU=Confirm change?';
      Text009@1009 : TextConst '@@@="%1 = Document No.";DAN=Hvis du sletter dette dokument, opstÜr der et hul i nummerserien for modtagelse. Der oprettes en tom modtagelse %1 for at udfylde hullet i nummerserien.\\Vil du fortsëtte?;ENU=Deleting this document will cause a gap in the number series for receipts. An empty receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?';
      Text012@1012 : TextConst '@@@="%1 = Document No.";DAN=Hvis du sletter dette dokument, opstÜr der et hul i nummerserien for bogfõrte fakturaer. Der oprettes en tom bogfõrt faktura %1 for at udfylde hullet i nummerserien.\\Vil du fortsëtte?;ENU=Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
      Text014@1014 : TextConst '@@@="%1 = Document No.";DAN=Hvis du sletter dette dokument, opstÜr der et hul i nummerserien for bogfõrte kreditnotaer. Der oprettes en tom bogfõrt kreditnota %1 for at udfylde hullet i nummerserien.\\Vil du fortsëtte?;ENU=Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
      Text016@1016 : TextConst 'DAN=Hvis du ëndrer %1, vil de eksisterende kõbslinjer blive slettet, og der vil blive oprettet nye kõbslinjer pÜ baggrund af de nye oplysninger i hovedet.\\;ENU=If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\';
      Text018@1017 : TextConst 'DAN=Du skal slette de eksisterende kõbslinjer, fõr du kan ëndre %1.;ENU=You must delete the existing purchase lines before you can change %1.';
      Text019@1018 : TextConst 'DAN=Du har ëndret %1 pÜ kõbshovedet, men det er ikke blevet ëndret pÜ de eksisterende kõbslinjer.\;ENU=You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.\';
      Text020@1019 : TextConst 'DAN=Du skal opdatere de eksisterende kõbslinjer manuelt.;ENU=You must update the existing purchase lines manually.';
      Text021@1020 : TextConst 'DAN=índringen kan pÜvirke den valutakurs, der blev brugt i prisberegningen pÜ kõbslinjerne.;ENU=The change may affect the exchange rate used on the price calculation of the purchase lines.';
      Text022@1021 : TextConst 'DAN=Vil du opdatere valutakursen?;ENU=Do you want to update the exchange rate?';
      Text023@1022 : TextConst 'DAN=Du kan ikke slette dette bilag. Dit id tillader kun behandling fra %1 %2.;ENU=You cannot delete this document. Your identification is set up to process from %1 %2 only.';
      Text025@1024 : TextConst 'DAN="Du har redigeret feltet %1. Bemërk, at genberegningen af moms kan resultere i õredifferencer, sÜ du skal kontrollere belõbene efter genberegningen. ";ENU="You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. "';
      Text027@1026 : TextConst 'DAN=Vil du opdatere feltet %2 pÜ linjerne, sÜ den nye vërdi for %1 afspejles?;ENU=Do you want to update the %2 field on the lines to reflect the new value of %1?';
      Text028@1027 : TextConst 'DAN=Dit id tillader kun behandling fra %1 %2.;ENU=Your identification is set up to process from %1 %2 only.';
      Text029@1028 : TextConst '@@@="%1 = Document No.";DAN=Hvis du sletter dette dokument, opstÜr der et hul i nummerserien for returforsendelser. Der oprettes en tom returforsendelse %1 for at udfylde hullet i nummerserien.\\Vil du fortsëtte?;ENU=Deleting this document will cause a gap in the number series for return shipments. An empty return shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?';
      Text032@1031 : TextConst 'DAN=Du har ëndret %1.\\;ENU=You have modified %1.\\';
      Text033@1032 : TextConst 'DAN=Vil du opdatere linjerne?;ENU=Do you want to update the lines?';
      PurchSetup@1033 : Record 312;
      GLSetup@1034 : Record 98;
      GLAcc@1035 : Record 15;
      PurchLine@1036 : Record 39;
      xPurchLine@1080 : Record 39;
      VendLedgEntry@1037 : Record 25;
      Vend@1038 : Record 23;
      PaymentTerms@1039 : Record 3;
      PaymentMethod@1040 : Record 289;
      CurrExchRate@1041 : Record 330;
      PurchHeader@1042 : Record 38;
      PurchCommentLine@1043 : Record 43;
      Cust@1045 : Record 18;
      CompanyInfo@1046 : Record 79;
      PostCode@1047 : Record 225;
      OrderAddr@1048 : Record 224;
      BankAcc@1049 : Record 270;
      PurchRcptHeader@1050 : Record 120;
      PurchInvHeader@1051 : Record 122;
      PurchCrMemoHeader@1052 : Record 124;
      ReturnShptHeader@1053 : Record 6650;
      PurchInvHeaderPrepmt@1090 : Record 122;
      PurchCrMemoHeaderPrepmt@1089 : Record 124;
      GenBusPostingGrp@1054 : Record 250;
      RespCenter@1056 : Record 5714;
      Location@1057 : Record 14;
      WhseRequest@1058 : Record 5765;
      InvtSetup@1059 : Record 313;
      SalespersonPurchaser@1932 : Record 13;
      NoSeriesMgt@1060 : Codeunit 396;
      DimMgt@1065 : Codeunit 408;
      ApprovalsMgmt@1082 : Codeunit 1535;
      UserSetupMgt@1066 : Codeunit 5700;
      LeadTimeMgt@1002 : Codeunit 5404;
      PostingSetupMgt@1023 : Codeunit 48;
      CurrencyDate@1069 : Date;
      HideValidationDialog@1070 : Boolean;
      Confirmed@1071 : Boolean;
      Text034@1072 : TextConst 'DAN=%1 kan ikke ëndres, nÜr %2 er udfyldt.;ENU=You cannot change the %1 when the %2 has been filled in.';
      Text037@1076 : TextConst 'DAN=Kontakten %1 %2 er ikke relateret til kreditoren %3.;ENU=Contact %1 %2 is not related to vendor %3.';
      Text038@1075 : TextConst 'DAN=Kontakten %1 %2 er relateret til en anden virksomhed end kreditoren %3.;ENU=Contact %1 %2 is related to a different company than vendor %3.';
      Text039@1077 : TextConst 'DAN=Kontakten %1 %2 er ikke relateret til en kreditor.;ENU=Contact %1 %2 is not related to a vendor.';
      SkipBuyFromContact@1030 : Boolean;
      SkipPayToContact@1078 : Boolean;
      Text040@1079 : TextConst 'DAN="Du kan ikke ëndre feltet %1, fordi %2 %3 har %4 = %5 og %6 allerede er blevet tildelt %7 %8.";ENU="You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8."';
      Text042@1084 : TextConst 'DAN=Du skal annullere godkendelsesprocessen, hvis du vil ëndre %1.;ENU=You must cancel the approval process if you wish to change the %1.';
      Text045@1086 : TextConst 'DAN=Hvis dette bilag slettes, opstÜr der et hul i nummerserien for forudbetalingsfakturaer. Der oprettes en tom forudbetalingsfaktura %1 for at udfylde hullet i nummerserien.\\Vil du fortsëtte?;ENU=Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
      Text046@1087 : TextConst 'DAN=Hvis dette bilag slettes, opstÜr der et hul i nummerserien for forudbetalingskreditnotaer. Der oprettes en tom forudbetalingskreditnota %1 for at udfylde hullet i nummerserien.\\Vil du fortsëtte?;ENU=Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
      Text049@1092 : TextConst 'DAN=%1 er konfigureret til kun at behandle emner fra %2 %3.;ENU=%1 is set up to process from %2 %3 only.';
      Text050@1067 : TextConst 'DAN=Der findes reservationer pÜ denne ordre. Disse reservationer annulleres, hvis der opstÜr en datokonflikt som fõlge af denne ëndring.\\Vil du fortsëtte?;ENU=Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\Do you want to continue?';
      Text051@1025 : TextConst 'DAN=Du har muligvis ëndret en dimension.\\Vil du opdatere linjerne?;ENU=You may have changed a dimension.\\Do you want to update the lines?';
      Text052@1091 : TextConst 'DAN=Feltet %1 pÜ kõbsordre %2 skal vëre det samme som pÜ salgsordre %3.;ENU=The %1 field on the purchase order %2 must be the same as on sales order %3.';
      UpdateDocumentDate@1120 : Boolean;
      PrepaymentInvoicesNotPaidErr@1074 : TextConst '@@@=You cannot post the document of type Order with the number 1001 before all related prepayment invoices are posted.;DAN=Du kan ikke bogfõre bilaget af typen %1 med nummeret %2, fõr alle relaterede forudbetalingsfakturaer er bogfõrt.;ENU=You cannot post the document of type %1 with the number %2 before all related prepayment invoices are posted.';
      Text054@1096 : TextConst 'DAN=Der er ubetalte forudbetalingsfakturaer, der er knyttet til dokumentet af typen %1 med nummer %2.;ENU=There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
      DeferralLineQst@1055 : TextConst '@@@="%1=The posting date on the document.";DAN=Du har ëndret %1 pÜ kõbshovedet. Vil du opdatere periodiseringsplanerne for linjerne med denne dato?;ENU=You have changed the %1 on the purchase header, do you want to update the deferral schedules for the lines with this date?';
      ChangeCurrencyQst@1073 : TextConst 'DAN=Hvis du ëndrer %1, slettes de eksisterende kõbslinjer, og der oprettes nye kõbslinjer pÜ baggrund af de nye oplysninger i hovedet. Du skal mÜske opdatere prisoplysningerne manuelt.\\Vil du ëndre %1?;ENU=If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created. You may need to update the price information manually.\\Do you want to change %1?';
      PostedDocsToPrintCreatedMsg@1083 : TextConst 'DAN=Et eller flere relaterede bogfõrte dokumenter er genereret under sletningen for at udfylde huller i bogfõringen af nummerserier. Du kan vise eller udskrive dokumenterne fra det respektive dokumentarkiv.;ENU=One or more related posted documents have been generated during deletion to fill gaps in the posting number series. You can view or print the documents from the respective document archive.';
      BuyFromVendorTxt@1010 : TextConst 'DAN=Leverandõr;ENU=Buy-from Vendor';
      PayToVendorTxt@1011 : TextConst 'DAN=Faktureringsleverandõr;ENU=Pay-to Vendor';
      DocumentNotPostedClosePageQst@1013 : TextConst 'DAN=Dokumentet er ikke bogfõrt.\Er du sikker pÜ, at du vil afslutte?;ENU=The document has not been posted.\Are you sure you want to exit?';
      DocTxt@1000 : TextConst 'DAN=Kõbsordre;ENU=Purchase Order';
      SelectNoSeriesAllowed@1015 : Boolean;
      MixedDropshipmentErr@1001 : TextConst 'DAN=Du kan ikke udskrive indkõbsordren, fordi den indeholder en eller flere linjer til direkte levering foruden almindelige kõbslinjer.;ENU=You cannot print the purchase order because it contains one or more lines for drop shipment in addition to regular purchase lines.';
      ModifyVendorAddressNotificationLbl@1062 : TextConst 'DAN=Opdater mailadressen;ENU=Update the address';
      DontShowAgainActionLbl@1064 : TextConst 'DAN=Vis ikke igen;ENU=Don''t show again';
      ModifyVendorAddressNotificationMsg@1063 : TextConst '@@@="%1=Vendor name";DAN=Den indtastede adresse for %1 er forskellig fra kreditorens eksisterende adresse.;ENU=The address you entered for %1 is different from the Vendor''s existing address.';
      ModifyBuyFromVendorAddressNotificationNameTxt@1106 : TextConst 'DAN=Opdater kreditorens leverandõradresse;ENU=Update Buy-from Vendor Address';
      ModifyBuyFromVendorAddressNotificationDescriptionTxt@1098 : TextConst 'DAN=Advar, hvis leverandõradressen pÜ salgsdokumenterne er forskellig fra kreditorens eksisterende adresse.;ENU=Warn if the Buy-from address on sales documents is different from the Vendor''s existing address.';
      ModifyPayToVendorAddressNotificationNameTxt@1102 : TextConst 'DAN=Opdater kreditorens faktureringsadresse;ENU=Update Pay-to Vendor Address';
      ModifyPayToVendorAddressNotificationDescriptionTxt@1099 : TextConst 'DAN=Advar, hvis faktureringsadressen pÜ salgsdokumenterne er forskellig fra kreditorens eksisterende adresse.;ENU=Warn if the Pay-to address on sales documents is different from the Vendor''s existing address.';
      PurchaseAlreadyExistsTxt@1029 : TextConst '@@@="%1 = Document Type; %2 = Document No.";DAN=Kõb %1 %2 findes allerede for denne kreditor.;ENU=Purchase %1 %2 already exists for this vendor.';
      ShowVendLedgEntryTxt@1044 : TextConst 'DAN=Vis kreditorposten.;ENU=Show the vendor ledger entry.';
      ShowDocAlreadyExistNotificationNameTxt@1068 : TextConst 'DAN=Der findes allerede et kõbsdokument med samme eksterne bilagsnummer.;ENU=Purchase document with same external document number already exists.';
      ShowDocAlreadyExistNotificationDescriptionTxt@1061 : TextConst 'DAN=Advar, hvis der allerede findes et kõbsdokument med samme eksterne bilagsnummer.;ENU=Warn if purchase document with same external document number already exists.';

    LOCAL PROCEDURE InitInsert@41();
    BEGIN
      IF "No." = '' THEN BEGIN
        TestNoSeries;
        NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
      END;

      IF NOT SkipInitialization THEN
        InitRecord;
    END;

    LOCAL PROCEDURE SkipInitialization@42() : Boolean;
    BEGIN
      IF "No." = '' THEN
        EXIT(FALSE);

      IF "Buy-from Vendor No." = '' THEN
        EXIT(FALSE);

      IF xRec."Document Type" <> "Document Type" THEN
        EXIT(FALSE);

      IF GETFILTER("Buy-from Vendor No.") <> '' THEN
        IF GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") THEN
          IF "Buy-from Vendor No." = GETRANGEMIN("Buy-from Vendor No.") THEN
            EXIT(FALSE);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE InitRecord@10();
    VAR
      ArchiveManagement@1000 : Codeunit 5063;
    BEGIN
      PurchSetup.GET;

      CASE "Document Type" OF
        "Document Type"::Quote,"Document Type"::Order:
          BEGIN
            NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Invoice Nos.");
            NoSeriesMgt.SetDefaultSeries("Receiving No. Series",PurchSetup."Posted Receipt Nos.");
            IF "Document Type" = "Document Type"::Order THEN BEGIN
              NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",PurchSetup."Posted Prepmt. Inv. Nos.");
              NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",PurchSetup."Posted Prepmt. Cr. Memo Nos.");
            END;
          END;
        "Document Type"::Invoice:
          BEGIN
            IF ("No. Series" <> '') AND
               (PurchSetup."Invoice Nos." = PurchSetup."Posted Invoice Nos.")
            THEN
              "Posting No. Series" := "No. Series"
            ELSE
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Invoice Nos.");
            IF PurchSetup."Receipt on Invoice" THEN
              NoSeriesMgt.SetDefaultSeries("Receiving No. Series",PurchSetup."Posted Receipt Nos.");
          END;
        "Document Type"::"Return Order":
          BEGIN
            NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Credit Memo Nos.");
            NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",PurchSetup."Posted Return Shpt. Nos.");
          END;
        "Document Type"::"Credit Memo":
          BEGIN
            IF ("No. Series" <> '') AND
               (PurchSetup."Credit Memo Nos." = PurchSetup."Posted Credit Memo Nos.")
            THEN
              "Posting No. Series" := "No. Series"
            ELSE
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Credit Memo Nos.");
            IF PurchSetup."Return Shipment on Credit Memo" THEN
              NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",PurchSetup."Posted Return Shpt. Nos.");
          END;
      END;

      IF "Document Type" IN
         ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Return Order","Document Type"::Quote]
      THEN
        "Order Date" := WORKDATE;

      IF "Document Type" = "Document Type"::Invoice THEN
        "Expected Receipt Date" := WORKDATE;

      IF NOT ("Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote]) AND
         ("Posting Date" = 0D)
      THEN
        "Posting Date" := WORKDATE;

      IF PurchSetup."Default Posting Date" = PurchSetup."Default Posting Date"::"No Date" THEN
        "Posting Date" := 0D;

      "Document Date" := WORKDATE;

      VALIDATE("Sell-to Customer No.",'');

      IF IsCreditDocType THEN BEGIN
        GLSetup.GET;
        Correction := GLSetup."Mark Cr. Memos as Corrections";
      END;

      "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

      IF InvtSetup.GET THEN
        "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";

      "Responsibility Center" := UserSetupMgt.GetRespCenter(1,"Responsibility Center");
      "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header","Document Type","No.");

      OnAfterInitRecord(Rec);
    END;

    LOCAL PROCEDURE InitNoSeries@52();
    BEGIN
      IF xRec."Receiving No." <> '' THEN BEGIN
        "Receiving No. Series" := xRec."Receiving No. Series";
        "Receiving No." := xRec."Receiving No.";
      END;
      IF xRec."Posting No." <> '' THEN BEGIN
        "Posting No. Series" := xRec."Posting No. Series";
        "Posting No." := xRec."Posting No.";
      END;
      IF xRec."Return Shipment No." <> '' THEN BEGIN
        "Return Shipment No. Series" := xRec."Return Shipment No. Series";
        "Return Shipment No." := xRec."Return Shipment No.";
      END;
      IF xRec."Prepayment No." <> '' THEN BEGIN
        "Prepayment No. Series" := xRec."Prepayment No. Series";
        "Prepayment No." := xRec."Prepayment No.";
      END;
      IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
        "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
        "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
      END;

      OnAfterInitNoSeries(Rec);
    END;

    [External]
    PROCEDURE AssistEdit@2(OldPurchHeader@1000 : Record 38) : Boolean;
    BEGIN
      PurchSetup.GET;
      TestNoSeries;
      IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldPurchHeader."No. Series","No. Series") THEN BEGIN
        PurchSetup.GET;
        TestNoSeries;
        NoSeriesMgt.SetSeries("No.");
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE TestNoSeries@6();
    BEGIN
      PurchSetup.GET;
      CASE "Document Type" OF
        "Document Type"::Quote:
          PurchSetup.TESTFIELD("Quote Nos.");
        "Document Type"::Order:
          PurchSetup.TESTFIELD("Order Nos.");
        "Document Type"::Invoice:
          BEGIN
            PurchSetup.TESTFIELD("Invoice Nos.");
            PurchSetup.TESTFIELD("Posted Invoice Nos.");
          END;
        "Document Type"::"Return Order":
          PurchSetup.TESTFIELD("Return Order Nos.");
        "Document Type"::"Credit Memo":
          BEGIN
            PurchSetup.TESTFIELD("Credit Memo Nos.");
            PurchSetup.TESTFIELD("Posted Credit Memo Nos.");
          END;
        "Document Type"::"Blanket Order":
          PurchSetup.TESTFIELD("Blanket Order Nos.");
      END;

      OnAfterTestNoSeries(Rec);
    END;

    LOCAL PROCEDURE GetNoSeriesCode@9() : Code[20];
    VAR
      NoSeriesCode@1001 : Code[20];
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote:
          NoSeriesCode := PurchSetup."Quote Nos.";
        "Document Type"::Order:
          NoSeriesCode := PurchSetup."Order Nos.";
        "Document Type"::Invoice:
          NoSeriesCode := PurchSetup."Invoice Nos.";
        "Document Type"::"Return Order":
          NoSeriesCode := PurchSetup."Return Order Nos.";
        "Document Type"::"Credit Memo":
          NoSeriesCode := PurchSetup."Credit Memo Nos.";
        "Document Type"::"Blanket Order":
          NoSeriesCode := PurchSetup."Blanket Order Nos.";
      END;
      EXIT(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode,SelectNoSeriesAllowed,"No. Series"));
    END;

    LOCAL PROCEDURE GetPostingNoSeriesCode@8() : Code[20];
    BEGIN
      IF IsCreditDocType THEN
        EXIT(PurchSetup."Posted Credit Memo Nos.");
      EXIT(PurchSetup."Posted Invoice Nos.");
    END;

    LOCAL PROCEDURE GetPostingPrepaymentNoSeriesCode@37() : Code[20];
    BEGIN
      IF IsCreditDocType THEN
        EXIT(PurchSetup."Posted Prepmt. Cr. Memo Nos.");
      EXIT(PurchSetup."Posted Prepmt. Inv. Nos.");
    END;

    LOCAL PROCEDURE TestNoSeriesDate@40(No@1000 : Code[20];NoSeriesCode@1001 : Code[20];NoCapt@1002 : Text[1024];NoSeriesCapt@1004 : Text[1024]);
    VAR
      NoSeries@1005 : Record 308;
    BEGIN
      IF (No <> '') AND (NoSeriesCode <> '') THEN BEGIN
        NoSeries.GET(NoSeriesCode);
        IF NoSeries."Date Order" THEN
          ERROR(
            Text040,
            FIELDCAPTION("Posting Date"),NoSeriesCapt,NoSeriesCode,
            NoSeries.FIELDCAPTION("Date Order"),NoSeries."Date Order","Document Type",
            NoCapt,No);
      END;
    END;

    [External]
    PROCEDURE ConfirmDeletion@11() : Boolean;
    VAR
      SourceCode@1001 : Record 230;
      SourceCodeSetup@1000 : Record 242;
      PostPurchDelete@1002 : Codeunit 364;
    BEGIN
      SourceCodeSetup.GET;
      SourceCodeSetup.TESTFIELD("Deleted Document");
      SourceCode.GET(SourceCodeSetup."Deleted Document");

      PostPurchDelete.InitDeleteHeader(
        Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
        ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt,SourceCode.Code);

      IF PurchRcptHeader."No." <> '' THEN
        IF NOT CONFIRM(Text009,TRUE,PurchRcptHeader."No.")
        THEN
          EXIT;
      IF PurchInvHeader."No." <> '' THEN
        IF NOT CONFIRM(Text012,TRUE,PurchInvHeader."No.")
        THEN
          EXIT;
      IF PurchCrMemoHeader."No." <> '' THEN
        IF NOT CONFIRM(Text014,TRUE,PurchCrMemoHeader."No.")
        THEN
          EXIT;
      IF ReturnShptHeader."No." <> '' THEN
        IF NOT CONFIRM(Text029,TRUE,ReturnShptHeader."No.")
        THEN
          EXIT;
      IF "Prepayment No." <> '' THEN
        IF NOT CONFIRM(Text045,TRUE,PurchInvHeaderPrepmt."No.")
        THEN
          EXIT;
      IF "Prepmt. Cr. Memo No." <> '' THEN
        IF NOT CONFIRM(Text046,TRUE,PurchCrMemoHeaderPrepmt."No.")
        THEN
          EXIT;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetVend@1(VendNo@1000 : Code[20]);
    BEGIN
      IF VendNo <> Vend."No." THEN
        Vend.GET(VendNo);
    END;

    [External]
    PROCEDURE PurchLinesExist@3() : Boolean;
    BEGIN
      PurchLine.RESET;
      PurchLine.SETRANGE("Document Type","Document Type");
      PurchLine.SETRANGE("Document No.","No.");
      EXIT(PurchLine.FINDFIRST);
    END;

    LOCAL PROCEDURE RecreatePurchLines@4(ChangedFieldName@1000 : Text[100]);
    VAR
      TempPurchLine@1001 : TEMPORARY Record 39;
      ItemChargeAssgntPurch@1005 : Record 5805;
      TempItemChargeAssgntPurch@1004 : TEMPORARY Record 5805;
      TempInteger@1003 : TEMPORARY Record 2000000026;
      SalesHeader@1006 : Record 36;
      TransferExtendedText@1009 : Codeunit 378;
      ExtendedTextAdded@1002 : Boolean;
    BEGIN
      IF PurchLinesExist THEN BEGIN
        IF HideValidationDialog THEN
          Confirmed := TRUE
        ELSE
          Confirmed :=
            CONFIRM(
              Text016 +
              ConfirmChangeQst,FALSE,ChangedFieldName);
        IF Confirmed THEN BEGIN
          PurchLine.LOCKTABLE;
          ItemChargeAssgntPurch.LOCKTABLE;
          MODIFY;

          PurchLine.RESET;
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          IF PurchLine.FINDSET THEN BEGIN
            REPEAT
              PurchLine.TESTFIELD("Quantity Received",0);
              PurchLine.TESTFIELD("Quantity Invoiced",0);
              PurchLine.TESTFIELD("Return Qty. Shipped",0);
              PurchLine.CALCFIELDS("Reserved Qty. (Base)");
              PurchLine.TESTFIELD("Reserved Qty. (Base)",0);
              PurchLine.TESTFIELD("Receipt No.",'');
              PurchLine.TESTFIELD("Return Shipment No.",'');
              PurchLine.TESTFIELD("Blanket Order No.",'');
              IF PurchLine."Drop Shipment" OR PurchLine."Special Order" THEN BEGIN
                CASE TRUE OF
                  PurchLine."Drop Shipment":
                    SalesHeader.GET(SalesHeader."Document Type"::Order,PurchLine."Sales Order No.");
                  PurchLine."Special Order":
                    SalesHeader.GET(SalesHeader."Document Type"::Order,PurchLine."Special Order Sales No.");
                END;
                TESTFIELD("Sell-to Customer No.",SalesHeader."Sell-to Customer No.");
                TESTFIELD("Ship-to Code",SalesHeader."Ship-to Code");
              END;

              PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
              TempPurchLine := PurchLine;
              IF PurchLine.Nonstock THEN BEGIN
                PurchLine.Nonstock := FALSE;
                PurchLine.MODIFY;
              END;
              TempPurchLine.INSERT;
            UNTIL PurchLine.NEXT = 0;

            ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
            ItemChargeAssgntPurch.SETRANGE("Document No.","No.");
            IF ItemChargeAssgntPurch.FINDSET THEN BEGIN
              REPEAT
                TempItemChargeAssgntPurch.INIT;
                TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
                TempItemChargeAssgntPurch.INSERT;
              UNTIL ItemChargeAssgntPurch.NEXT = 0;
              ItemChargeAssgntPurch.DELETEALL;
            END;

            PurchLine.DELETEALL(TRUE);

            PurchLine.INIT;
            PurchLine."Line No." := 0;
            TempPurchLine.FINDSET;
            ExtendedTextAdded := FALSE;
            REPEAT
              IF TempPurchLine."Attached to Line No." = 0 THEN BEGIN
                PurchLine.INIT;
                PurchLine."Line No." := PurchLine."Line No." + 10000;
                PurchLine.VALIDATE(Type,TempPurchLine.Type);
                IF TempPurchLine."No." = '' THEN BEGIN
                  PurchLine.VALIDATE(Description,TempPurchLine.Description);
                  PurchLine.VALIDATE("Description 2",TempPurchLine."Description 2");
                END ELSE BEGIN
                  PurchLine.VALIDATE("No.",TempPurchLine."No.");
                  IF PurchLine.Type <> PurchLine.Type::" " THEN
                    CASE TRUE OF
                      TempPurchLine."Drop Shipment":
                        TransferSavedFieldsDropShipment(PurchLine,TempPurchLine);
                      TempPurchLine."Special Order":
                        TransferSavedFieldsSpecialOrder(PurchLine,TempPurchLine);
                      ELSE
                        TransferSavedFields(PurchLine,TempPurchLine);
                    END;
                END;

                PurchLine.INSERT;
                ExtendedTextAdded := FALSE;

                IF PurchLine.Type = PurchLine.Type::Item THEN BEGIN
                  ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
                  TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",TempPurchLine."Document Type");
                  TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",TempPurchLine."Document No.");
                  TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",TempPurchLine."Line No.");
                  IF TempItemChargeAssgntPurch.FINDSET THEN
                    REPEAT
                      IF NOT TempItemChargeAssgntPurch.MARK THEN BEGIN
                        TempItemChargeAssgntPurch."Applies-to Doc. Line No." := PurchLine."Line No.";
                        TempItemChargeAssgntPurch.Description := PurchLine.Description;
                        TempItemChargeAssgntPurch.MODIFY;
                        TempItemChargeAssgntPurch.MARK(TRUE);
                      END;
                    UNTIL TempItemChargeAssgntPurch.NEXT = 0;
                END;
                IF PurchLine.Type = PurchLine.Type::"Charge (Item)" THEN BEGIN
                  TempInteger.INIT;
                  TempInteger.Number := PurchLine."Line No.";
                  TempInteger.INSERT;
                END;
              END ELSE
                IF NOT ExtendedTextAdded THEN BEGIN
                  TransferExtendedText.PurchCheckIfAnyExtText(PurchLine,TRUE);
                  TransferExtendedText.InsertPurchExtText(PurchLine);
                  OnAfterTransferExtendedTextForPurchaseLineRecreation(PurchLine);
                  PurchLine.FINDLAST;
                  ExtendedTextAdded := TRUE;
                END;
            UNTIL TempPurchLine.NEXT = 0;

            ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
            TempPurchLine.SETRANGE(Type,PurchLine.Type::"Charge (Item)");
            IF TempPurchLine.FINDSET THEN
              REPEAT
                TempItemChargeAssgntPurch.SETRANGE("Document Line No.",TempPurchLine."Line No.");
                IF TempItemChargeAssgntPurch.FINDSET THEN BEGIN
                  REPEAT
                    TempInteger.FINDFIRST;
                    ItemChargeAssgntPurch.INIT;
                    ItemChargeAssgntPurch := TempItemChargeAssgntPurch;
                    ItemChargeAssgntPurch."Document Line No." := TempInteger.Number;
                    ItemChargeAssgntPurch.VALIDATE("Unit Cost",0);
                    ItemChargeAssgntPurch.INSERT;
                  UNTIL TempItemChargeAssgntPurch.NEXT = 0;
                  TempInteger.DELETE;
                END;
              UNTIL TempPurchLine.NEXT = 0;

            TempPurchLine.SETRANGE(Type);
            TempPurchLine.DELETEALL;
            ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
            TempItemChargeAssgntPurch.DELETEALL;
          END;
        END ELSE
          ERROR(
            Text018,ChangedFieldName);
      END;
    END;

    LOCAL PROCEDURE TransferSavedFields@72(VAR DestinationPurchaseLine@1000 : Record 39;VAR SourcePurchaseLine@1001 : Record 39);
    BEGIN
      DestinationPurchaseLine.VALIDATE("Unit of Measure Code",SourcePurchaseLine."Unit of Measure Code");
      DestinationPurchaseLine.VALIDATE("Variant Code",SourcePurchaseLine."Variant Code");
      DestinationPurchaseLine."Prod. Order No." := SourcePurchaseLine."Prod. Order No.";
      IF DestinationPurchaseLine."Prod. Order No." <> '' THEN BEGIN
        DestinationPurchaseLine.Description := SourcePurchaseLine.Description;
        DestinationPurchaseLine.VALIDATE("VAT Prod. Posting Group",SourcePurchaseLine."VAT Prod. Posting Group");
        DestinationPurchaseLine.VALIDATE("Gen. Prod. Posting Group",SourcePurchaseLine."Gen. Prod. Posting Group");
        DestinationPurchaseLine.VALIDATE("Expected Receipt Date",SourcePurchaseLine."Expected Receipt Date");
        DestinationPurchaseLine.VALIDATE("Requested Receipt Date",SourcePurchaseLine."Requested Receipt Date");
        DestinationPurchaseLine.VALIDATE("Qty. per Unit of Measure",SourcePurchaseLine."Qty. per Unit of Measure");
      END;
      IF (SourcePurchaseLine."Job No." <> '') AND (SourcePurchaseLine."Job Task No." <> '') THEN BEGIN
        DestinationPurchaseLine.VALIDATE("Job No.",SourcePurchaseLine."Job No.");
        DestinationPurchaseLine.VALIDATE("Job Task No.",SourcePurchaseLine."Job Task No.");
        DestinationPurchaseLine."Job Line Type" := SourcePurchaseLine."Job Line Type";
      END;
      IF SourcePurchaseLine.Quantity <> 0 THEN
        DestinationPurchaseLine.VALIDATE(Quantity,SourcePurchaseLine.Quantity);
      IF ("Currency Code" = xRec."Currency Code") AND (PurchLine."Direct Unit Cost" = 0) THEN
        DestinationPurchaseLine.VALIDATE("Direct Unit Cost",SourcePurchaseLine."Direct Unit Cost");
      DestinationPurchaseLine."Routing No." := SourcePurchaseLine."Routing No.";
      DestinationPurchaseLine."Routing Reference No." := SourcePurchaseLine."Routing Reference No.";
      DestinationPurchaseLine."Operation No." := SourcePurchaseLine."Operation No.";
      DestinationPurchaseLine."Work Center No." := SourcePurchaseLine."Work Center No.";
      DestinationPurchaseLine."Prod. Order Line No." := SourcePurchaseLine."Prod. Order Line No.";
      DestinationPurchaseLine."Overhead Rate" := SourcePurchaseLine."Overhead Rate";
    END;

    LOCAL PROCEDURE TransferSavedFieldsDropShipment@79(VAR DestinationPurchaseLine@1001 : Record 39;VAR SourcePurchaseLine@1000 : Record 39);
    VAR
      SalesLine@1003 : Record 37;
      CopyDocMgt@1002 : Codeunit 6620;
    BEGIN
      SalesLine.GET(SalesLine."Document Type"::Order,
        SourcePurchaseLine."Sales Order No.",
        SourcePurchaseLine."Sales Order Line No.");
      CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,DestinationPurchaseLine);
      DestinationPurchaseLine."Drop Shipment" := SourcePurchaseLine."Drop Shipment";
      DestinationPurchaseLine."Purchasing Code" := SalesLine."Purchasing Code";
      DestinationPurchaseLine."Sales Order No." := SourcePurchaseLine."Sales Order No.";
      DestinationPurchaseLine."Sales Order Line No." := SourcePurchaseLine."Sales Order Line No.";
      EVALUATE(DestinationPurchaseLine."Inbound Whse. Handling Time",'<0D>');
      DestinationPurchaseLine.VALIDATE("Inbound Whse. Handling Time");
      SalesLine.VALIDATE("Unit Cost (LCY)",DestinationPurchaseLine."Unit Cost (LCY)");
      SalesLine."Purchase Order No." := DestinationPurchaseLine."Document No.";
      SalesLine."Purch. Order Line No." := DestinationPurchaseLine."Line No.";
      SalesLine.MODIFY;
    END;

    LOCAL PROCEDURE TransferSavedFieldsSpecialOrder@82(VAR DestinationPurchaseLine@1003 : Record 39;VAR SourcePurchaseLine@1002 : Record 39);
    VAR
      SalesLine@1004 : Record 37;
      CopyDocMgt@1000 : Codeunit 6620;
    BEGIN
      SalesLine.GET(SalesLine."Document Type"::Order,
        SourcePurchaseLine."Special Order Sales No.",
        SourcePurchaseLine."Special Order Sales Line No.");
      CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,DestinationPurchaseLine);
      DestinationPurchaseLine."Special Order" := SourcePurchaseLine."Special Order";
      DestinationPurchaseLine."Purchasing Code" := SalesLine."Purchasing Code";
      DestinationPurchaseLine."Special Order Sales No." := SourcePurchaseLine."Special Order Sales No.";
      DestinationPurchaseLine."Special Order Sales Line No." := SourcePurchaseLine."Special Order Sales Line No.";
      DestinationPurchaseLine.VALIDATE("Unit of Measure Code",SourcePurchaseLine."Unit of Measure Code");
      IF SourcePurchaseLine.Quantity <> 0 THEN
        DestinationPurchaseLine.VALIDATE(Quantity,SourcePurchaseLine.Quantity);

      SalesLine.VALIDATE("Unit Cost (LCY)",DestinationPurchaseLine."Unit Cost (LCY)");
      SalesLine."Special Order Purchase No." := DestinationPurchaseLine."Document No.";
      SalesLine."Special Order Purch. Line No." := DestinationPurchaseLine."Line No.";
      SalesLine.MODIFY;
    END;

    LOCAL PROCEDURE MessageIfPurchLinesExist@5(ChangedFieldName@1000 : Text[100]);
    BEGIN
      IF PurchLinesExist AND NOT HideValidationDialog THEN
        MESSAGE(
          Text019 +
          Text020,
          ChangedFieldName);
    END;

    LOCAL PROCEDURE PriceMessageIfPurchLinesExist@7(ChangedFieldName@1000 : Text[100]);
    BEGIN
      IF PurchLinesExist AND NOT HideValidationDialog THEN
        MESSAGE(
          Text019 +
          Text021,ChangedFieldName);
    END;

    LOCAL PROCEDURE UpdateCurrencyFactor@12();
    BEGIN
      IF "Currency Code" <> '' THEN BEGIN
        IF "Posting Date" <> 0D THEN
          CurrencyDate := "Posting Date"
        ELSE
          CurrencyDate := WORKDATE;

        "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
      END ELSE
        "Currency Factor" := 0;
    END;

    LOCAL PROCEDURE ConfirmUpdateCurrencyFactor@13() : Boolean;
    BEGIN
      IF HideValidationDialog THEN
        Confirmed := TRUE
      ELSE
        Confirmed := CONFIRM(Text022,FALSE);
      IF Confirmed THEN
        VALIDATE("Currency Factor")
      ELSE
        "Currency Factor" := xRec."Currency Factor";
      EXIT(Confirmed);
    END;

    [External]
    PROCEDURE SetHideValidationDialog@14(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    [External]
    PROCEDURE UpdatePurchLines@15(ChangedFieldName@1000 : Text[100];AskQuestion@1001 : Boolean);
    VAR
      PurchLineReserve@1003 : Codeunit 99000834;
      Question@1002 : Text[250];
    BEGIN
      IF NOT PurchLinesExist THEN
        EXIT;

      IF AskQuestion THEN BEGIN
        Question := STRSUBSTNO(
            Text032 +
            Text033,ChangedFieldName);
        IF GUIALLOWED THEN
          IF DIALOG.CONFIRM(Question,TRUE) THEN
            CASE ChangedFieldName OF
              FIELDCAPTION("Expected Receipt Date"),
              FIELDCAPTION("Requested Receipt Date"),
              FIELDCAPTION("Promised Receipt Date"),
              FIELDCAPTION("Lead Time Calculation"),
              FIELDCAPTION("Inbound Whse. Handling Time"):
                ConfirmResvDateConflict;
            END
          ELSE
            EXIT;
      END;

      PurchLine.LOCKTABLE;
      MODIFY;

      PurchLine.RESET;
      PurchLine.SETRANGE("Document Type","Document Type");
      PurchLine.SETRANGE("Document No.","No.");
      IF PurchLine.FINDSET THEN
        REPEAT
          xPurchLine := PurchLine;
          CASE ChangedFieldName OF
            FIELDCAPTION("Expected Receipt Date"):
              IF PurchLine."No." <> '' THEN
                PurchLine.VALIDATE("Expected Receipt Date","Expected Receipt Date");
            FIELDCAPTION("Currency Factor"):
              IF PurchLine.Type <> PurchLine.Type::" " THEN
                PurchLine.VALIDATE("Direct Unit Cost");
            FIELDCAPTION("Transaction Type"):
              PurchLine.VALIDATE("Transaction Type","Transaction Type");
            FIELDCAPTION("Transport Method"):
              PurchLine.VALIDATE("Transport Method","Transport Method");
            FIELDCAPTION("Entry Point"):
              PurchLine.VALIDATE("Entry Point","Entry Point");
            FIELDCAPTION(Area):
              PurchLine.VALIDATE(Area,Area);
            FIELDCAPTION("Transaction Specification"):
              PurchLine.VALIDATE("Transaction Specification","Transaction Specification");
            FIELDCAPTION("Requested Receipt Date"):
              IF PurchLine."No." <> '' THEN
                PurchLine.VALIDATE("Requested Receipt Date","Requested Receipt Date");
            FIELDCAPTION("Prepayment %"):
              IF PurchLine."No." <> '' THEN
                PurchLine.VALIDATE("Prepayment %","Prepayment %");
            FIELDCAPTION("Promised Receipt Date"):
              IF PurchLine."No." <> '' THEN
                PurchLine.VALIDATE("Promised Receipt Date","Promised Receipt Date");
            FIELDCAPTION("Lead Time Calculation"):
              IF PurchLine."No." <> '' THEN
                PurchLine.VALIDATE("Lead Time Calculation","Lead Time Calculation");
            FIELDCAPTION("Inbound Whse. Handling Time"):
              IF PurchLine."No." <> '' THEN
                PurchLine.VALIDATE("Inbound Whse. Handling Time","Inbound Whse. Handling Time");
            PurchLine.FIELDCAPTION("Deferral Code"):
              IF PurchLine."No." <> '' THEN
                PurchLine.VALIDATE("Deferral Code");
            ELSE
              OnUpdatePurchLinesByChangedFieldName(Rec,PurchLine,ChangedFieldName);
          END;
          PurchLine.MODIFY(TRUE);
          PurchLineReserve.VerifyChange(PurchLine,xPurchLine);
        UNTIL PurchLine.NEXT = 0;
    END;

    LOCAL PROCEDURE ConfirmResvDateConflict@31();
    VAR
      ResvEngMgt@1000 : Codeunit 99000831;
    BEGIN
      IF ResvEngMgt.ResvExistsForPurchHeader(Rec) THEN
        IF NOT CONFIRM(Text050,FALSE) THEN
          ERROR('');
    END;

    [External]
    PROCEDURE CreateDim@16(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1006 : Integer;No4@1007 : Code[20]);
    VAR
      SourceCodeSetup@1010 : Record 242;
      TableID@1011 : ARRAY [10] OF Integer;
      No@1012 : ARRAY [10] OF Code[20];
      OldDimSetID@1008 : Integer;
    BEGIN
      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      TableID[4] := Type4;
      No[4] := No4;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      OldDimSetID := "Dimension Set ID";
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Purchases,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);

      IF (OldDimSetID <> "Dimension Set ID") AND PurchLinesExist THEN BEGIN
        MODIFY;
        UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@19(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    VAR
      OldDimSetID@1005 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
      IF "No." <> '' THEN
        MODIFY;

      IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
        MODIFY;
        IF PurchLinesExist THEN
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    LOCAL PROCEDURE ReceivedPurchLinesExist@20() : Boolean;
    BEGIN
      PurchLine.RESET;
      PurchLine.SETRANGE("Document Type","Document Type");
      PurchLine.SETRANGE("Document No.","No.");
      PurchLine.SETFILTER("Quantity Received",'<>0');
      EXIT(PurchLine.FINDFIRST);
    END;

    LOCAL PROCEDURE ReturnShipmentExist@5800() : Boolean;
    BEGIN
      PurchLine.RESET;
      PurchLine.SETRANGE("Document Type","Document Type");
      PurchLine.SETRANGE("Document No.","No.");
      PurchLine.SETFILTER("Return Qty. Shipped",'<>0');
      EXIT(PurchLine.FINDFIRST);
    END;

    [External]
    PROCEDURE UpdateShipToAddress@21();
    BEGIN
      IF IsCreditDocType THEN
        EXIT;

      IF ("Location Code" <> '') AND Location.GET("Location Code") AND ("Sell-to Customer No." = '') THEN BEGIN
        SetShipToAddress(
          Location.Name,Location."Name 2",Location.Address,Location."Address 2",
          Location.City,Location."Post Code",Location.County,Location."Country/Region Code");
        "Ship-to Contact" := Location.Contact;
      END;

      IF ("Location Code" = '') AND ("Sell-to Customer No." = '') THEN BEGIN
        CompanyInfo.GET;
        "Ship-to Code" := '';
        SetShipToAddress(
          CompanyInfo."Ship-to Name",CompanyInfo."Ship-to Name 2",CompanyInfo."Ship-to Address",CompanyInfo."Ship-to Address 2",
          CompanyInfo."Ship-to City",CompanyInfo."Ship-to Post Code",CompanyInfo."Ship-to County",
          CompanyInfo."Ship-to Country/Region Code");
        "Ship-to Contact" := CompanyInfo."Ship-to Contact";
      END;

      OnAfterUpdateShipToAddress(Rec);
    END;

    LOCAL PROCEDURE DeletePurchaseLines@17();
    VAR
      ReservMgt@1000 : Codeunit 99000845;
    BEGIN
      IF PurchLine.FINDSET THEN BEGIN
        ReservMgt.DeleteDocumentReservation(DATABASE::"Purchase Line","Document Type","No.",HideValidationDialog);
        REPEAT
          PurchLine.SuspendStatusCheck(TRUE);
          PurchLine.DELETE(TRUE);
        UNTIL PurchLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE ClearItemAssgntPurchFilter@22(VAR TempItemChargeAssgntPurch@1000 : TEMPORARY Record 5805);
    BEGIN
      TempItemChargeAssgntPurch.SETRANGE("Document Line No.");
      TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
      TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
      TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
    END;

    LOCAL PROCEDURE CheckReceiptInfo@70(VAR PurchLine@1000 : Record 39;PayTo@1001 : Boolean);
    BEGIN
      IF "Document Type" = "Document Type"::Order THEN
        PurchLine.SETFILTER("Quantity Received",'<>0')
      ELSE
        IF "Document Type" = "Document Type"::Invoice THEN BEGIN
          IF NOT PayTo THEN
            PurchLine.SETRANGE("Buy-from Vendor No.",xRec."Buy-from Vendor No.");
          PurchLine.SETFILTER("Receipt No.",'<>%1','');
        END;

      IF PurchLine.FINDFIRST THEN
        IF "Document Type" = "Document Type"::Order THEN
          PurchLine.TESTFIELD("Quantity Received",0)
        ELSE
          PurchLine.TESTFIELD("Receipt No.",'');
      PurchLine.SETRANGE("Receipt No.");
      PurchLine.SETRANGE("Quantity Received");
      IF NOT PayTo THEN
        PurchLine.SETRANGE("Buy-from Vendor No.");
    END;

    LOCAL PROCEDURE CheckPrepmtInfo@119(VAR PurchLine@1000 : Record 39);
    BEGIN
      IF "Document Type" = "Document Type"::Order THEN BEGIN
        PurchLine.SETFILTER("Prepmt. Amt. Inv.",'<>0');
        IF PurchLine.FIND('-') THEN
          PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
        PurchLine.SETRANGE("Prepmt. Amt. Inv.");
      END;
    END;

    LOCAL PROCEDURE CheckReturnInfo@121(VAR PurchLine@1000 : Record 39;PayTo@1001 : Boolean);
    BEGIN
      IF "Document Type" = "Document Type"::"Return Order" THEN
        PurchLine.SETFILTER("Return Qty. Shipped",'<>0')
      ELSE
        IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
          IF NOT PayTo THEN
            PurchLine.SETRANGE("Buy-from Vendor No.",xRec."Buy-from Vendor No.");
          PurchLine.SETFILTER("Return Shipment No.",'<>%1','');
        END;

      IF PurchLine.FINDFIRST THEN
        IF "Document Type" = "Document Type"::"Return Order" THEN
          PurchLine.TESTFIELD("Return Qty. Shipped",0)
        ELSE
          PurchLine.TESTFIELD("Return Shipment No.",'');
    END;

    LOCAL PROCEDURE UpdateBuyFromCont@24(VendorNo@1000 : Code[20]);
    VAR
      ContBusRel@1003 : Record 5054;
      Vend@1004 : Record 23;
      OfficeContact@1001 : Record 5050;
      OfficeMgt@1002 : Codeunit 1630;
    BEGIN
      IF OfficeMgt.GetContact(OfficeContact,VendorNo) THEN BEGIN
        SetHideValidationDialog(TRUE);
        UpdateBuyFromVend(OfficeContact."No.");
        SetHideValidationDialog(FALSE);
      END ELSE
        IF Vend.GET(VendorNo) THEN BEGIN
          IF Vend."Primary Contact No." <> '' THEN
            "Buy-from Contact No." := Vend."Primary Contact No."
          ELSE
            "Buy-from Contact No." := ContBusRel.GetContactNo(ContBusRel."Link to Table"::Vendor,"Buy-from Vendor No.");
          "Buy-from Contact" := Vend.Contact;
        END;

      IF "Buy-from Contact No." <> '' THEN
        IF OfficeContact.GET("Buy-from Contact No.") THEN
          OfficeContact.CheckIfPrivacyBlockedGeneric;
    END;

    LOCAL PROCEDURE UpdatePayToCont@27(VendorNo@1000 : Code[20]);
    VAR
      ContBusRel@1003 : Record 5054;
      Vend@1001 : Record 23;
      Contact@1002 : Record 5050;
    BEGIN
      IF Vend.GET(VendorNo) THEN BEGIN
        IF Vend."Primary Contact No." <> '' THEN
          "Pay-to Contact No." := Vend."Primary Contact No."
        ELSE
          "Pay-to Contact No." := ContBusRel.GetContactNo(ContBusRel."Link to Table"::Vendor,"Pay-to Vendor No.");
        "Pay-to Contact" := Vend.Contact;
      END;

      IF "Pay-to Contact No." <> '' THEN
        IF Contact.GET("Pay-to Contact No.") THEN
          Contact.CheckIfPrivacyBlockedGeneric;
    END;

    LOCAL PROCEDURE UpdateBuyFromVend@25(ContactNo@1002 : Code[20]);
    VAR
      ContBusinessRelation@1007 : Record 5054;
      Vend@1006 : Record 23;
      Cont@1005 : Record 5050;
    BEGIN
      IF Cont.GET(ContactNo) THEN BEGIN
        "Buy-from Contact No." := Cont."No.";
        IF Cont.Type = Cont.Type::Person THEN
          "Buy-from Contact" := Cont.Name
        ELSE
          IF Vend.GET("Buy-from Vendor No.") THEN
            "Buy-from Contact" := Vend.Contact
          ELSE
            "Buy-from Contact" := ''
      END ELSE BEGIN
        "Buy-from Contact" := '';
        EXIT;
      END;

      IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Vendor,Cont."Company No.") THEN BEGIN
        IF ("Buy-from Vendor No." <> '') AND
           ("Buy-from Vendor No." <> ContBusinessRelation."No.")
        THEN
          ERROR(Text037,Cont."No.",Cont.Name,"Buy-from Vendor No.");
        IF "Buy-from Vendor No." = '' THEN BEGIN
          SkipBuyFromContact := TRUE;
          VALIDATE("Buy-from Vendor No.",ContBusinessRelation."No.");
          SkipBuyFromContact := FALSE;
        END;
      END ELSE
        ERROR(Text039,Cont."No.",Cont.Name);

      IF ("Buy-from Vendor No." = "Pay-to Vendor No.") OR
         ("Pay-to Vendor No." = '')
      THEN
        VALIDATE("Pay-to Contact No.","Buy-from Contact No.");
    END;

    LOCAL PROCEDURE UpdatePayToVend@26(ContactNo@1000 : Code[20]);
    VAR
      ContBusinessRelation@1005 : Record 5054;
      Vend@1004 : Record 23;
      Cont@1003 : Record 5050;
    BEGIN
      IF Cont.GET(ContactNo) THEN BEGIN
        "Pay-to Contact No." := Cont."No.";
        IF Cont.Type = Cont.Type::Person THEN
          "Pay-to Contact" := Cont.Name
        ELSE
          IF Vend.GET("Pay-to Vendor No.") THEN
            "Pay-to Contact" := Vend.Contact
          ELSE
            "Pay-to Contact" := '';
      END ELSE BEGIN
        "Pay-to Contact" := '';
        EXIT;
      END;

      IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Vendor,Cont."Company No.") THEN BEGIN
        IF "Pay-to Vendor No." = '' THEN BEGIN
          SkipPayToContact := TRUE;
          VALIDATE("Pay-to Vendor No.",ContBusinessRelation."No.");
          SkipPayToContact := FALSE;
        END ELSE
          IF "Pay-to Vendor No." <> ContBusinessRelation."No." THEN
            ERROR(Text037,Cont."No.",Cont.Name,"Pay-to Vendor No.");
      END ELSE
        ERROR(Text039,Cont."No.",Cont.Name);
    END;

    [External]
    PROCEDURE CreateInvtPutAwayPick@29();
    VAR
      WhseRequest@1000 : Record 5765;
    BEGIN
      TESTFIELD(Status,Status::Released);

      WhseRequest.RESET;
      WhseRequest.SETCURRENTKEY("Source Document","Source No.");
      CASE "Document Type" OF
        "Document Type"::Order:
          WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Purchase Order");
        "Document Type"::"Return Order":
          WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Purchase Return Order");
      END;
      WhseRequest.SETRANGE("Source No.","No.");
      REPORT.RUNMODAL(REPORT::"Create Invt Put-away/Pick/Mvmt",TRUE,FALSE,WhseRequest);
    END;

    [External]
    PROCEDURE ShowDocDim@32();
    VAR
      OldDimSetID@1000 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

      IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
        MODIFY;
        IF PurchLinesExist THEN
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    LOCAL PROCEDURE UpdateAllLineDim@34(NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 : Integer);
    VAR
      NewDimSetID@1002 : Integer;
      ReceivedShippedItemLineDimChangeConfirmed@1003 : Boolean;
    BEGIN
      // Update all lines with changed dimensions.

      IF NewParentDimSetID = OldParentDimSetID THEN
        EXIT;
      IF NOT CONFIRM(Text051) THEN
        EXIT;

      PurchLine.RESET;
      PurchLine.SETRANGE("Document Type","Document Type");
      PurchLine.SETRANGE("Document No.","No.");
      PurchLine.LOCKTABLE;
      IF PurchLine.FIND('-') THEN
        REPEAT
          NewDimSetID := DimMgt.GetDeltaDimSetID(PurchLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
          IF PurchLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
            PurchLine."Dimension Set ID" := NewDimSetID;

            IF NOT HideValidationDialog AND GUIALLOWED THEN
              VerifyReceivedShippedItemLineDimChange(ReceivedShippedItemLineDimChangeConfirmed);

            DimMgt.UpdateGlobalDimFromDimSetID(
              PurchLine."Dimension Set ID",PurchLine."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 2 Code");
            PurchLine.MODIFY;
          END;
        UNTIL PurchLine.NEXT = 0;
    END;

    LOCAL PROCEDURE VerifyReceivedShippedItemLineDimChange@71(VAR ReceivedShippedItemLineDimChangeConfirmed@1000 : Boolean);
    BEGIN
      IF PurchLine.IsReceivedShippedItemDimChanged THEN
        IF NOT ReceivedShippedItemLineDimChangeConfirmed THEN
          ReceivedShippedItemLineDimChangeConfirmed := PurchLine.ConfirmReceivedShippedItemDimChange;
    END;

    [External]
    PROCEDURE SetAmountToApply@18(AppliesToDocNo@1000 : Code[20];VendorNo@1001 : Code[20]);
    VAR
      VendLedgEntry@1002 : Record 25;
    BEGIN
      VendLedgEntry.SETCURRENTKEY("Document No.");
      VendLedgEntry.SETRANGE("Document No.",AppliesToDocNo);
      VendLedgEntry.SETRANGE("Vendor No.",VendorNo);
      VendLedgEntry.SETRANGE(Open,TRUE);
      IF VendLedgEntry.FINDFIRST THEN BEGIN
        IF VendLedgEntry."Amount to Apply" = 0 THEN  BEGIN
          VendLedgEntry.CALCFIELDS("Remaining Amount");
          VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
        END ELSE
          VendLedgEntry."Amount to Apply" := 0;
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
      END;
    END;

    [External]
    PROCEDURE SetShipToForSpecOrder@23();
    BEGIN
      IF Location.GET("Location Code") THEN BEGIN
        "Ship-to Code" := '';
        SetShipToAddress(
          Location.Name,Location."Name 2",Location.Address,Location."Address 2",
          Location.City,Location."Post Code",Location.County,Location."Country/Region Code");
        "Ship-to Contact" := Location.Contact;
        "Location Code" := Location.Code;
      END ELSE BEGIN
        CompanyInfo.GET;
        "Ship-to Code" := '';
        SetShipToAddress(
          CompanyInfo."Ship-to Name",CompanyInfo."Ship-to Name 2",CompanyInfo."Ship-to Address",CompanyInfo."Ship-to Address 2",
          CompanyInfo."Ship-to City",CompanyInfo."Ship-to Post Code",CompanyInfo."Ship-to County",
          CompanyInfo."Ship-to Country/Region Code");
        "Ship-to Contact" := CompanyInfo."Ship-to Contact";
        "Location Code" := '';
      END;
    END;

    LOCAL PROCEDURE JobUpdatePurchLines@28(SkipJobCurrFactorUpdate@1000 : Boolean);
    BEGIN
      WITH PurchLine DO BEGIN
        SETFILTER("Job No.",'<>%1','');
        SETFILTER("Job Task No.",'<>%1','');
        LOCKTABLE;
        IF FINDSET(TRUE,FALSE) THEN BEGIN
          SetPurchHeader(Rec);
          REPEAT
            IF NOT SkipJobCurrFactorUpdate THEN
              JobSetCurrencyFactor;
            CreateTempJobJnlLine(FALSE);
            UpdateJobPrices;
            MODIFY;
          UNTIL NEXT = 0;
        END;
      END
    END;

    [Internal]
    PROCEDURE GetPstdDocLinesToRevere@47();
    VAR
      PurchPostedDocLines@1002 : Page 5855;
    BEGIN
      GetVend("Buy-from Vendor No.");
      PurchPostedDocLines.SetToPurchHeader(Rec);
      PurchPostedDocLines.SETRECORD(Vend);
      PurchPostedDocLines.LOOKUPMODE := TRUE;
      IF PurchPostedDocLines.RUNMODAL = ACTION::LookupOK THEN
        PurchPostedDocLines.CopyLineToDoc;

      CLEAR(PurchPostedDocLines);
    END;

    [External]
    PROCEDURE SetSecurityFilterOnRespCenter@43();
    BEGIN
      IF UserSetupMgt.GetPurchasesFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetPurchasesFilter);
        FILTERGROUP(0);
      END;

      SETRANGE("Date Filter",0D,WORKDATE - 1);
    END;

    [External]
    PROCEDURE CalcInvDiscForHeader@45();
    VAR
      PurchaseInvDisc@1000 : Codeunit 70;
    BEGIN
      PurchSetup.GET;
      IF PurchSetup."Calc. Inv. Discount" THEN
        PurchaseInvDisc.CalculateIncDiscForHeader(Rec);
    END;

    [External]
    PROCEDURE AddShipToAddress@46(SalesHeader@1000 : Record 36;ShowError@1001 : Boolean);
    VAR
      PurchLine2@1002 : Record 39;
    BEGIN
      IF ShowError THEN BEGIN
        PurchLine2.RESET;
        PurchLine2.SETRANGE("Document Type","Document Type"::Order);
        PurchLine2.SETRANGE("Document No.","No.");
        IF NOT PurchLine2.ISEMPTY THEN BEGIN
          IF "Ship-to Name" <> SalesHeader."Ship-to Name" THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Name"),"No.",SalesHeader."No.");
          IF "Ship-to Name 2" <> SalesHeader."Ship-to Name 2" THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Name 2"),"No.",SalesHeader."No.");
          IF "Ship-to Address" <> SalesHeader."Ship-to Address" THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Address"),"No.",SalesHeader."No.");
          IF "Ship-to Address 2" <> SalesHeader."Ship-to Address 2" THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Address 2"),"No.",SalesHeader."No.");
          IF "Ship-to Post Code" <> SalesHeader."Ship-to Post Code" THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Post Code"),"No.",SalesHeader."No.");
          IF "Ship-to City" <> SalesHeader."Ship-to City" THEN
            ERROR(Text052,FIELDCAPTION("Ship-to City"),"No.",SalesHeader."No.");
          IF "Ship-to Contact" <> SalesHeader."Ship-to Contact" THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Contact"),"No.",SalesHeader."No.");
        END ELSE BEGIN
          // no purchase line exists
          "Ship-to Name" := SalesHeader."Ship-to Name";
          "Ship-to Name 2" := SalesHeader."Ship-to Name 2";
          "Ship-to Address" := SalesHeader."Ship-to Address";
          "Ship-to Address 2" := SalesHeader."Ship-to Address 2";
          "Ship-to Post Code" := SalesHeader."Ship-to Post Code";
          "Ship-to City" := SalesHeader."Ship-to City";
          "Ship-to Contact" := SalesHeader."Ship-to Contact";
        END;
      END;
    END;

    [External]
    PROCEDURE DropShptOrderExists@48(SalesHeader@1000 : Record 36) : Boolean;
    VAR
      SalesLine2@1001 : Record 37;
    BEGIN
      // returns TRUE if sales is either Drop Shipment of Special Order
      SalesLine2.RESET;
      SalesLine2.SETRANGE("Document Type",SalesLine2."Document Type"::Order);
      SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
      SalesLine2.SETRANGE("Drop Shipment",TRUE);
      EXIT(NOT SalesLine2.ISEMPTY);
    END;

    [External]
    PROCEDURE SpecialOrderExists@81(SalesHeader@1000 : Record 36) : Boolean;
    VAR
      SalesLine3@1001 : Record 37;
    BEGIN
      SalesLine3.RESET;
      SalesLine3.SETRANGE("Document Type",SalesLine3."Document Type"::Order);
      SalesLine3.SETRANGE("Document No.",SalesHeader."No.");
      SalesLine3.SETRANGE("Special Order",TRUE);
      EXIT(NOT SalesLine3.ISEMPTY);
    END;

    LOCAL PROCEDURE CheckDropShipmentLineExists@153();
    VAR
      SalesShipmentLine@1000 : Record 111;
    BEGIN
      SalesShipmentLine.SETRANGE("Purchase Order No.","No.");
      SalesShipmentLine.SETRANGE("Drop Shipment",TRUE);
      IF NOT SalesShipmentLine.ISEMPTY THEN
        ERROR(YouCannotChangeFieldErr,FIELDCAPTION("Buy-from Vendor No."));
    END;

    [External]
    PROCEDURE QtyToReceiveIsZero@30() : Boolean;
    BEGIN
      PurchLine.RESET;
      PurchLine.SETRANGE("Document Type","Document Type");
      PurchLine.SETRANGE("Document No.","No.");
      PurchLine.SETFILTER("Qty. to Receive",'<>0');
      EXIT(PurchLine.ISEMPTY);
    END;

    LOCAL PROCEDURE IsApprovedForPosting@50() : Boolean;
    VAR
      PrepaymentMgt@1000 : Codeunit 441;
    BEGIN
      IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN BEGIN
        IF PrepaymentMgt.TestPurchasePrepayment(Rec) THEN
          ERROR(STRSUBSTNO(PrepaymentInvoicesNotPaidErr,"Document Type","No."));
        IF PrepaymentMgt.TestPurchasePayment(Rec) THEN
          IF NOT CONFIRM(STRSUBSTNO(Text054,"Document Type","No."),TRUE) THEN
            EXIT(FALSE);
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE IsApprovedForPostingBatch@51() : Boolean;
    VAR
      PrepaymentMgt@1000 : Codeunit 441;
    BEGIN
      IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN BEGIN
        IF PrepaymentMgt.TestPurchasePrepayment(Rec) THEN
          EXIT(FALSE);
        IF PrepaymentMgt.TestPurchasePayment(Rec) THEN
          EXIT(FALSE);
        EXIT(TRUE);
      END;
    END;

    [Internal]
    PROCEDURE IsTotalValid@36() : Boolean;
    VAR
      IncomingDocument@1002 : Record 130;
      PurchaseLine@1001 : Record 39;
      TempTotalPurchaseLine@1000 : TEMPORARY Record 39;
      DocumentTotals@1003 : Codeunit 57;
      VATAmount@1004 : Decimal;
    BEGIN
      IF NOT IncomingDocument.GET("Incoming Document Entry No.") THEN
        EXIT(TRUE);

      IF IncomingDocument."Amount Incl. VAT" = 0 THEN
        EXIT(TRUE);

      PurchaseLine.SETRANGE("Document Type","Document Type");
      PurchaseLine.SETRANGE("Document No.","No.");
      IF NOT PurchaseLine.FINDFIRST THEN
        EXIT(TRUE);

      IF IncomingDocument."Currency Code" <> PurchaseLine."Currency Code" THEN
        EXIT(TRUE);

      TempTotalPurchaseLine.INIT;
      DocumentTotals.PurchaseCalculateTotalsWithInvoiceRounding(PurchaseLine,VATAmount,TempTotalPurchaseLine);

      EXIT(IncomingDocument."Amount Incl. VAT" = TempTotalPurchaseLine."Amount Including VAT");
    END;

    [External]
    PROCEDURE SendToPosting@57(PostingCodeunitID@1000 : Integer);
    BEGIN
      IF NOT IsApprovedForPosting THEN
        EXIT;
      CODEUNIT.RUN(PostingCodeunitID,Rec);
    END;

    [External]
    PROCEDURE CancelBackgroundPosting@33();
    VAR
      PurchasePostViaJobQueue@1000 : Codeunit 98;
    BEGIN
      PurchasePostViaJobQueue.CancelQueueEntry(Rec);
    END;

    [External]
    PROCEDURE AddSpecialOrderToAddress@80(SalesHeader@1000 : Record 36;ShowError@1001 : Boolean);
    VAR
      PurchLine3@1003 : Record 39;
      LocationCode@1004 : Record 14;
    BEGIN
      IF ShowError THEN BEGIN
        PurchLine3.RESET;
        PurchLine3.SETRANGE("Document Type","Document Type"::Order);
        PurchLine3.SETRANGE("Document No.","No.");
        IF NOT PurchLine3.ISEMPTY THEN BEGIN
          LocationCode.GET("Location Code");
          IF "Ship-to Name" <> LocationCode.Name THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Name"),"No.",SalesHeader."No.");
          IF "Ship-to Name 2" <> LocationCode."Name 2" THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Name 2"),"No.",SalesHeader."No.");
          IF "Ship-to Address" <> LocationCode.Address THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Address"),"No.",SalesHeader."No.");
          IF "Ship-to Address 2" <> LocationCode."Address 2" THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Address 2"),"No.",SalesHeader."No.");
          IF "Ship-to Post Code" <> LocationCode."Post Code" THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Post Code"),"No.",SalesHeader."No.");
          IF "Ship-to City" <> LocationCode.City THEN
            ERROR(Text052,FIELDCAPTION("Ship-to City"),"No.",SalesHeader."No.");
          IF "Ship-to Contact" <> LocationCode.Contact THEN
            ERROR(Text052,FIELDCAPTION("Ship-to Contact"),"No.",SalesHeader."No.");
        END ELSE
          SetShipToForSpecOrder;
      END;
    END;

    [External]
    PROCEDURE InvoicedLineExists@56() : Boolean;
    VAR
      PurchLine@1000 : Record 39;
    BEGIN
      PurchLine.SETRANGE("Document Type","Document Type");
      PurchLine.SETRANGE("Document No.","No.");
      PurchLine.SETFILTER(Type,'<>%1',PurchLine.Type::" ");
      PurchLine.SETFILTER("Quantity Invoiced",'<>%1',0);
      EXIT(NOT PurchLine.ISEMPTY);
    END;

    [External]
    PROCEDURE CreateDimSetForPrepmtAccDefaultDim@44();
    VAR
      PurchaseLine@1001 : Record 39;
      TempPurchaseLine@1002 : TEMPORARY Record 39;
    BEGIN
      PurchaseLine.SETRANGE("Document Type","Document Type");
      PurchaseLine.SETRANGE("Document No.","No.");
      PurchaseLine.SETFILTER("Prepmt. Amt. Inv.",'<>%1',0);
      IF PurchaseLine.FINDSET THEN
        REPEAT
          CollectParamsInBufferForCreateDimSet(TempPurchaseLine,PurchaseLine);
        UNTIL PurchaseLine.NEXT = 0;
      TempPurchaseLine.RESET;
      TempPurchaseLine.MARKEDONLY(FALSE);
      IF TempPurchaseLine.FINDSET THEN
        REPEAT
          PurchaseLine.CreateDim(DATABASE::"G/L Account",TempPurchaseLine."No.",
            DATABASE::Job,TempPurchaseLine."Job No.",
            DATABASE::"Responsibility Center",TempPurchaseLine."Responsibility Center",
            DATABASE::"Work Center",TempPurchaseLine."Work Center No.");
        UNTIL TempPurchaseLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CollectParamsInBufferForCreateDimSet@49(VAR TempPurchaseLine@1000 : TEMPORARY Record 39;PurchaseLine@1001 : Record 39);
    VAR
      GenPostingSetup@1002 : Record 252;
      DefaultDimension@1003 : Record 352;
    BEGIN
      TempPurchaseLine.SETRANGE("Gen. Bus. Posting Group",PurchaseLine."Gen. Bus. Posting Group");
      TempPurchaseLine.SETRANGE("Gen. Prod. Posting Group",PurchaseLine."Gen. Prod. Posting Group");
      IF NOT TempPurchaseLine.FINDFIRST THEN BEGIN
        GenPostingSetup.GET(PurchaseLine."Gen. Bus. Posting Group",PurchaseLine."Gen. Prod. Posting Group");
        GenPostingSetup.TESTFIELD("Purch. Prepayments Account");
        DefaultDimension.SETRANGE("Table ID",DATABASE::"G/L Account");
        DefaultDimension.SETRANGE("No.",GenPostingSetup."Purch. Prepayments Account");
        InsertTempPurchaseLineInBuffer(TempPurchaseLine,PurchaseLine,
          GenPostingSetup."Purch. Prepayments Account",DefaultDimension.ISEMPTY);
      END ELSE
        IF NOT TempPurchaseLine.MARK THEN BEGIN
          TempPurchaseLine.SETRANGE("Job No.",PurchaseLine."Job No.");
          TempPurchaseLine.SETRANGE("Responsibility Center",PurchaseLine."Responsibility Center");
          TempPurchaseLine.SETRANGE("Work Center No.",PurchaseLine."Work Center No.");
          IF TempPurchaseLine.ISEMPTY THEN
            InsertTempPurchaseLineInBuffer(TempPurchaseLine,PurchaseLine,TempPurchaseLine."No.",FALSE)
        END;
    END;

    LOCAL PROCEDURE InsertTempPurchaseLineInBuffer@35(VAR TempPurchaseLine@1000 : TEMPORARY Record 39;PurchaseLine@1001 : Record 39;AccountNo@1002 : Code[20];DefaultDimenstionsNotExist@1003 : Boolean);
    BEGIN
      TempPurchaseLine.INIT;
      TempPurchaseLine."Line No." := PurchaseLine."Line No.";
      TempPurchaseLine."No." := AccountNo;
      TempPurchaseLine."Job No." := PurchaseLine."Job No.";
      TempPurchaseLine."Responsibility Center" := PurchaseLine."Responsibility Center";
      TempPurchaseLine."Work Center No." := PurchaseLine."Work Center No.";
      TempPurchaseLine."Gen. Bus. Posting Group" := PurchaseLine."Gen. Bus. Posting Group";
      TempPurchaseLine."Gen. Prod. Posting Group" := PurchaseLine."Gen. Prod. Posting Group";
      TempPurchaseLine.MARK := DefaultDimenstionsNotExist;
      TempPurchaseLine.INSERT;
    END;

    [Internal]
    PROCEDURE OpenPurchaseOrderStatistics@60();
    BEGIN
      CalcInvDiscForHeader;
      CreateDimSetForPrepmtAccDefaultDim;
      COMMIT;
      PAGE.RUNMODAL(PAGE::"Purchase Order Statistics",Rec);
    END;

    [External]
    PROCEDURE GetCardpageID@58() : Integer;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote:
          EXIT(PAGE::"Purchase Quote");
        "Document Type"::Order:
          EXIT(PAGE::"Purchase Order");
        "Document Type"::Invoice:
          EXIT(PAGE::"Purchase Invoice");
        "Document Type"::"Credit Memo":
          EXIT(PAGE::"Purchase Credit Memo");
        "Document Type"::"Blanket Order":
          EXIT(PAGE::"Blanket Purchase Order");
        "Document Type"::"Return Order":
          EXIT(PAGE::"Purchase Return Order");
      END;
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnCheckPurchasePostRestrictions@54();
    BEGIN
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnCheckPurchaseReleaseRestrictions@55();
    BEGIN
    END;

    [External]
    PROCEDURE SetStatus@53(NewStatus@1000 : Option);
    BEGIN
      Status := NewStatus;
      MODIFY;
    END;

    [External]
    PROCEDURE TriggerOnAfterPostPurchaseDoc@116(VAR GenJnlPostLine@1001 : Codeunit 12;PurchRcpHdrNo@1002 : Code[20];RetShptHdrNo@1003 : Code[20];PurchInvHdrNo@1004 : Code[20];PurchCrMemoHdrNo@1005 : Code[20]);
    VAR
      PurchPost@1000 : Codeunit 90;
    BEGIN
      PurchPost.OnAfterPostPurchaseDoc(Rec,GenJnlPostLine,PurchRcpHdrNo,RetShptHdrNo,PurchInvHdrNo,PurchCrMemoHdrNo);
    END;

    [External]
    PROCEDURE DeferralHeadersExist@38() : Boolean;
    VAR
      DeferralHeader@1000 : Record 1701;
      DeferralUtilities@1001 : Codeunit 1720;
    BEGIN
      DeferralHeader.SETRANGE("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
      DeferralHeader.SETRANGE("Gen. Jnl. Template Name",'');
      DeferralHeader.SETRANGE("Gen. Jnl. Batch Name",'');
      DeferralHeader.SETRANGE("Document Type","Document Type");
      DeferralHeader.SETRANGE("Document No.","No.");
      EXIT(NOT DeferralHeader.ISEMPTY);
    END;

    LOCAL PROCEDURE ConfirmUpdateDeferralDate@85();
    BEGIN
      IF HideValidationDialog THEN
        Confirmed := TRUE
      ELSE
        Confirmed := CONFIRM(DeferralLineQst,FALSE,FIELDCAPTION("Posting Date"));
      IF Confirmed THEN
        UpdatePurchLines(PurchLine.FIELDCAPTION("Deferral Code"),FALSE);
    END;

    [External]
    PROCEDURE IsCreditDocType@110() : Boolean;
    BEGIN
      EXIT("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
    END;

    [External]
    PROCEDURE SetBuyFromVendorFromFilter@186();
    VAR
      BuyFromVendorNo@1000 : Code[20];
    BEGIN
      BuyFromVendorNo := GetFilterVendNo;
      IF BuyFromVendorNo = '' THEN BEGIN
        FILTERGROUP(2);
        BuyFromVendorNo := GetFilterVendNo;
        FILTERGROUP(0);
      END;
      IF BuyFromVendorNo <> '' THEN
        VALIDATE("Buy-from Vendor No.",BuyFromVendorNo);
    END;

    [External]
    PROCEDURE CopyBuyFromVendorFilter@59();
    VAR
      BuyFromVendorFilter@1000 : Text;
    BEGIN
      BuyFromVendorFilter := GETFILTER("Buy-from Vendor No.");
      IF BuyFromVendorFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETFILTER("Buy-from Vendor No.",BuyFromVendorFilter);
        FILTERGROUP(0)
      END;
    END;

    LOCAL PROCEDURE GetFilterVendNo@64() : Code[20];
    BEGIN
      IF GETFILTER("Buy-from Vendor No.") <> '' THEN
        IF GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") THEN
          EXIT(GETRANGEMAX("Buy-from Vendor No."));
    END;

    [External]
    PROCEDURE HasBuyFromAddress@65() : Boolean;
    BEGIN
      CASE TRUE OF
        "Buy-from Address" <> '':
          EXIT(TRUE);
        "Buy-from Address 2" <> '':
          EXIT(TRUE);
        "Buy-from City" <> '':
          EXIT(TRUE);
        "Buy-from Country/Region Code" <> '':
          EXIT(TRUE);
        "Buy-from County" <> '':
          EXIT(TRUE);
        "Buy-from Post Code" <> '':
          EXIT(TRUE);
        "Buy-from Contact" <> '':
          EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE HasShipToAddress@103() : Boolean;
    BEGIN
      CASE TRUE OF
        "Ship-to Address" <> '':
          EXIT(TRUE);
        "Ship-to Address 2" <> '':
          EXIT(TRUE);
        "Ship-to City" <> '':
          EXIT(TRUE);
        "Ship-to Country/Region Code" <> '':
          EXIT(TRUE);
        "Ship-to County" <> '':
          EXIT(TRUE);
        "Ship-to Post Code" <> '':
          EXIT(TRUE);
        "Ship-to Contact" <> '':
          EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE HasPayToAddress@66() : Boolean;
    BEGIN
      CASE TRUE OF
        "Pay-to Address" <> '':
          EXIT(TRUE);
        "Pay-to Address 2" <> '':
          EXIT(TRUE);
        "Pay-to City" <> '':
          EXIT(TRUE);
        "Pay-to Country/Region Code" <> '':
          EXIT(TRUE);
        "Pay-to County" <> '':
          EXIT(TRUE);
        "Pay-to Post Code" <> '':
          EXIT(TRUE);
        "Pay-to Contact" <> '':
          EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CopyBuyFromVendorAddressFieldsFromVendor@62(VAR BuyFromVendor@1000 : Record 23;ForceCopy@1001 : Boolean);
    BEGIN
      IF BuyFromVendorIsReplaced OR ShouldCopyAddressFromBuyFromVendor(BuyFromVendor) OR ForceCopy THEN BEGIN
        "Buy-from Address" := BuyFromVendor.Address;
        "Buy-from Address 2" := BuyFromVendor."Address 2";
        "Buy-from City" := BuyFromVendor.City;
        "Buy-from Post Code" := BuyFromVendor."Post Code";
        "Buy-from County" := BuyFromVendor.County;
        "Buy-from Country/Region Code" := BuyFromVendor."Country/Region Code";
      END;
    END;

    LOCAL PROCEDURE CopyShipToVendorAddressFieldsFromVendor@98(VAR BuyFromVendor@1000 : Record 23;ForceCopy@1001 : Boolean);
    BEGIN
      IF BuyFromVendorIsReplaced OR (NOT HasShipToAddress) OR ForceCopy THEN BEGIN
        "Ship-to Address" := BuyFromVendor.Address;
        "Ship-to Address 2" := BuyFromVendor."Address 2";
        "Ship-to City" := BuyFromVendor.City;
        "Ship-to Post Code" := BuyFromVendor."Post Code";
        "Ship-to County" := BuyFromVendor.County;
        VALIDATE("Ship-to Country/Region Code",BuyFromVendor."Country/Region Code");
      END;
    END;

    LOCAL PROCEDURE CopyPayToVendorAddressFieldsFromVendor@63(VAR PayToVendor@1000 : Record 23;ForceCopy@1001 : Boolean);
    BEGIN
      IF PayToVendorIsReplaced OR ShouldCopyAddressFromPayToVendor(PayToVendor) OR ForceCopy THEN BEGIN
        "Pay-to Address" := PayToVendor.Address;
        "Pay-to Address 2" := PayToVendor."Address 2";
        "Pay-to City" := PayToVendor.City;
        "Pay-to Post Code" := PayToVendor."Post Code";
        "Pay-to County" := PayToVendor.County;
        "Pay-to Country/Region Code" := PayToVendor."Country/Region Code";
      END;
    END;

    [External]
    PROCEDURE SetShipToAddress@117(ShipToName@1000 : Text[50];ShipToName2@1001 : Text[50];ShipToAddress@1002 : Text[50];ShipToAddress2@1003 : Text[50];ShipToCity@1004 : Text[30];ShipToPostCode@1005 : Code[20];ShipToCounty@1006 : Text[30];ShipToCountryRegionCode@1007 : Code[10]);
    BEGIN
      "Ship-to Name" := ShipToName;
      "Ship-to Name 2" := ShipToName2;
      "Ship-to Address" := ShipToAddress;
      "Ship-to Address 2" := ShipToAddress2;
      "Ship-to City" := ShipToCity;
      "Ship-to Post Code" := ShipToPostCode;
      "Ship-to County" := ShipToCounty;
      "Ship-to Country/Region Code" := ShipToCountryRegionCode;
    END;

    LOCAL PROCEDURE ShouldCopyAddressFromBuyFromVendor@101(BuyFromVendor@1000 : Record 23) : Boolean;
    BEGIN
      EXIT((NOT HasBuyFromAddress) AND BuyFromVendor.HasAddress);
    END;

    LOCAL PROCEDURE ShouldCopyAddressFromPayToVendor@102(PayToVendor@1000 : Record 23) : Boolean;
    BEGIN
      EXIT((NOT HasPayToAddress) AND PayToVendor.HasAddress);
    END;

    LOCAL PROCEDURE BuyFromVendorIsReplaced@96() : Boolean;
    BEGIN
      EXIT((xRec."Buy-from Vendor No." <> '') AND (xRec."Buy-from Vendor No." <> "Buy-from Vendor No."));
    END;

    LOCAL PROCEDURE PayToVendorIsReplaced@97() : Boolean;
    BEGIN
      EXIT((xRec."Pay-to Vendor No." <> '') AND (xRec."Pay-to Vendor No." <> "Pay-to Vendor No."));
    END;

    LOCAL PROCEDURE UpdatePayToAddressFromBuyFromAddress@61(FieldNumber@1000 : Integer);
    BEGIN
      IF ("Order Address Code" = '') AND PayToAddressEqualsOldBuyFromAddress THEN
        CASE FieldNumber OF
          FIELDNO("Pay-to Address"):
            IF xRec."Buy-from Address" = "Pay-to Address" THEN
              "Pay-to Address" := "Buy-from Address";
          FIELDNO("Pay-to Address 2"):
            IF xRec."Buy-from Address 2" = "Pay-to Address 2" THEN
              "Pay-to Address 2" := "Buy-from Address 2";
          FIELDNO("Pay-to City"), FIELDNO("Pay-to Post Code"):
            BEGIN
              IF xRec."Buy-from City" = "Pay-to City" THEN
                "Pay-to City" := "Buy-from City";
              IF xRec."Buy-from Post Code" = "Pay-to Post Code" THEN
                "Pay-to Post Code" := "Buy-from Post Code";
              IF xRec."Buy-from County" = "Pay-to County" THEN
                "Pay-to County" := "Buy-from County";
              IF xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code" THEN
                "Pay-to Country/Region Code" := "Buy-from Country/Region Code";
            END;
          FIELDNO("Pay-to County"):
            IF xRec."Buy-from County" = "Pay-to County" THEN
              "Pay-to County" := "Buy-from County";
          FIELDNO("Pay-to Country/Region Code"):
            IF  xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code" THEN
              "Pay-to Country/Region Code" := "Buy-from Country/Region Code";
        END;
    END;

    LOCAL PROCEDURE PayToAddressEqualsOldBuyFromAddress@67() : Boolean;
    BEGIN
      IF (xRec."Buy-from Address" = "Pay-to Address") AND
         (xRec."Buy-from Address 2" = "Pay-to Address 2") AND
         (xRec."Buy-from City" = "Pay-to City") AND
         (xRec."Buy-from County" = "Pay-to County") AND
         (xRec."Buy-from Post Code" = "Pay-to Post Code") AND
         (xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code")
      THEN
        EXIT(TRUE);
    END;

    [External]
    PROCEDURE ConfirmCloseUnposted@104() : Boolean;
    VAR
      InstructionMgt@1000 : Codeunit 1330;
    BEGIN
      IF PurchLinesExist THEN
        EXIT(InstructionMgt.ShowConfirm(DocumentNotPostedClosePageQst,InstructionMgt.QueryPostOnCloseCode));
      EXIT(TRUE)
    END;

    [External]
    PROCEDURE InitFromPurchHeader@109(SourcePurchHeader@1000 : Record 38);
    BEGIN
      "Document Date" := SourcePurchHeader."Document Date";
      "Expected Receipt Date" := SourcePurchHeader."Expected Receipt Date";
      "Shortcut Dimension 1 Code" := SourcePurchHeader."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := SourcePurchHeader."Shortcut Dimension 2 Code";
      "Dimension Set ID" := SourcePurchHeader."Dimension Set ID";
      "Location Code" := SourcePurchHeader."Location Code";
      SetShipToAddress(
        SourcePurchHeader."Ship-to Name",SourcePurchHeader."Ship-to Name 2",SourcePurchHeader."Ship-to Address",
        SourcePurchHeader."Ship-to Address 2",SourcePurchHeader."Ship-to City",SourcePurchHeader."Ship-to Post Code",
        SourcePurchHeader."Ship-to County",SourcePurchHeader."Ship-to Country/Region Code");
      "Ship-to Contact" := SourcePurchHeader."Ship-to Contact";
    END;

    LOCAL PROCEDURE InitFromVendor@68(VendorNo@1000 : Code[20];VendorCaption@1001 : Text) : Boolean;
    BEGIN
      PurchLine.SETRANGE("Document Type","Document Type");
      PurchLine.SETRANGE("Document No.","No.");
      IF VendorNo = '' THEN BEGIN
        IF NOT PurchLine.ISEMPTY THEN
          ERROR(Text005,VendorCaption);
        INIT;
        PurchSetup.GET;
        "No. Series" := xRec."No. Series";
        InitRecord;
        InitNoSeries;
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE InitFromContact@69(ContactNo@1000 : Code[20];VendorNo@1001 : Code[20];ContactCaption@1002 : Text) : Boolean;
    BEGIN
      PurchLine.SETRANGE("Document Type","Document Type");
      PurchLine.SETRANGE("Document No.","No.");
      IF (ContactNo = '') AND (VendorNo = '') THEN BEGIN
        IF NOT PurchLine.ISEMPTY THEN
          ERROR(Text005,ContactCaption);
        INIT;
        PurchSetup.GET;
        "No. Series" := xRec."No. Series";
        InitRecord;
        InitNoSeries;
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE LookupContact@122(VendorNo@1000 : Code[20];ContactNo@1003 : Code[20];VAR Contact@1001 : Record 5050);
    VAR
      ContactBusinessRelation@1002 : Record 5054;
    BEGIN
      IF ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Vendor,VendorNo) THEN
        Contact.SETRANGE("Company No.",ContactBusinessRelation."Contact No.")
      ELSE
        Contact.SETRANGE("Company No.",'');
      IF ContactNo <> '' THEN
        IF Contact.GET(ContactNo) THEN ;
    END;

    [Internal]
    PROCEDURE SendRecords@75();
    VAR
      DocumentSendingProfile@1000 : Record 60;
      DummyReportSelections@1001 : Record 77;
    BEGIN
      CheckMixedDropShipment;

      DocumentSendingProfile.SendVendorRecords(
        DummyReportSelections.Usage::"P.Order",Rec,DocTxt,"Buy-from Vendor No.","No.",
        FIELDNO("Buy-from Vendor No."),FIELDNO("No."));
    END;

    [External]
    PROCEDURE PrintRecords@74(ShowRequestForm@1002 : Boolean);
    VAR
      DocumentSendingProfile@1001 : Record 60;
      DummyReportSelections@1000 : Record 77;
    BEGIN
      CheckMixedDropShipment;

      DocumentSendingProfile.TrySendToPrinterVendor(
        DummyReportSelections.Usage::"P.Order",Rec,FIELDNO("Buy-from Vendor No."),ShowRequestForm);
    END;

    [External]
    PROCEDURE SendProfile@73(VAR DocumentSendingProfile@1000 : Record 60);
    VAR
      DummyReportSelections@1001 : Record 77;
    BEGIN
      CheckMixedDropShipment;

      DocumentSendingProfile.SendVendor(
        DummyReportSelections.Usage::"P.Order",Rec,"No.","Buy-from Vendor No.",
        DocTxt,FIELDNO("Buy-from Vendor No."),FIELDNO("No."));
    END;

    LOCAL PROCEDURE CheckMixedDropShipment@84();
    BEGIN
      IF HasMixedDropShipment THEN
        ERROR(MixedDropshipmentErr);
    END;

    LOCAL PROCEDURE HasMixedDropShipment@83() : Boolean;
    VAR
      PurchaseLine@1000 : Record 39;
      HasDropShipmentLines@1001 : Boolean;
    BEGIN
      PurchaseLine.SETRANGE("Document Type","Document Type");
      PurchaseLine.SETRANGE("Document No.","No.");
      PurchaseLine.SETFILTER("No.",'<>%1','');
      PurchaseLine.SETRANGE("Drop Shipment",TRUE);

      HasDropShipmentLines := NOT PurchaseLine.ISEMPTY;

      PurchaseLine.SETRANGE("Drop Shipment",FALSE);

      EXIT(HasDropShipmentLines AND NOT PurchaseLine.ISEMPTY);
    END;

    LOCAL PROCEDURE SetDefaultPurchaser@76();
    VAR
      UserSetup@1000 : Record 91;
    BEGIN
      IF NOT UserSetup.GET(USERID) THEN
        EXIT;

      IF UserSetup."Salespers./Purch. Code" <> '' THEN
        IF SalespersonPurchaser.GET(UserSetup."Salespers./Purch. Code") THEN
          IF NOT SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) THEN
            VALIDATE("Purchaser Code",UserSetup."Salespers./Purch. Code");
    END;

    PROCEDURE OnAfterValidateBuyFromVendorNo@77(VAR PurchaseHeader@1000 : Record 38;VAR xPurchaseHeader@1001 : Record 38);
    BEGIN
      IF PurchaseHeader.GETFILTER("Buy-from Vendor No.") = xPurchaseHeader."Buy-from Vendor No." THEN
        IF PurchaseHeader."Buy-from Vendor No." <> xPurchaseHeader."Buy-from Vendor No." THEN
          PurchaseHeader.SETRANGE("Buy-from Vendor No.");
    END;

    PROCEDURE BatchConfirmUpdateDeferralDate@78(VAR BatchConfirm@1000 : ' ,Skip,Update';ReplacePostingDate@1001 : Boolean;PostingDateReq@1002 : Date);
    BEGIN
      IF (NOT ReplacePostingDate) OR (PostingDateReq = "Posting Date") OR (BatchConfirm = BatchConfirm::Skip) THEN
        EXIT;

      IF NOT DeferralHeadersExist THEN
        EXIT;

      "Posting Date" := PostingDateReq;
      CASE BatchConfirm OF
        BatchConfirm::" ":
          BEGIN
            ConfirmUpdateDeferralDate;
            IF Confirmed THEN
              BatchConfirm := BatchConfirm::Update
            ELSE
              BatchConfirm := BatchConfirm::Skip;
          END;
        BatchConfirm::Update:
          UpdatePurchLines(PurchLine.FIELDCAPTION("Deferral Code"),FALSE);
      END;
      COMMIT;
    END;

    PROCEDURE SetAllowSelectNoSeries@86();
    BEGIN
      SelectNoSeriesAllowed := TRUE;
    END;

    LOCAL PROCEDURE ModifyPayToVendorAddress@194();
    VAR
      Vendor@1000 : Record 23;
    BEGIN
      IF IsCreditDocType THEN
        EXIT;
      IF ("Pay-to Vendor No." <> "Buy-from Vendor No.") AND Vendor.GET("Pay-to Vendor No.") THEN
        IF HasPayToAddress AND HasDifferentPayToAddress(Vendor) THEN
          ShowModifyAddressNotification(GetModifyPayToVendorAddressNotificationId,
            ModifyVendorAddressNotificationLbl,ModifyVendorAddressNotificationMsg,
            'CopyPayToVendorAddressFieldsFromSalesDocument',"Pay-to Vendor No.",
            "Pay-to Name",FIELDNAME("Pay-to Vendor No."));
    END;

    LOCAL PROCEDURE ModifyVendorAddress@150();
    VAR
      Vendor@1000 : Record 23;
    BEGIN
      IF IsCreditDocType THEN
        EXIT;
      IF Vendor.GET("Buy-from Vendor No.") AND HasBuyFromAddress AND HasDifferentBuyFromAddress(Vendor) THEN
        ShowModifyAddressNotification(GetModifyVendorAddressNotificationId,
          ModifyVendorAddressNotificationLbl,ModifyVendorAddressNotificationMsg,
          'CopyBuyFromVendorAddressFieldsFromSalesDocument',"Buy-from Vendor No.",
          "Buy-from Vendor Name",FIELDNAME("Buy-from Vendor No."));
    END;

    LOCAL PROCEDURE ShowModifyAddressNotification@157(NotificationID@1001 : GUID;NotificationLbl@1004 : Text;NotificationMsg@1005 : Text;NotificationFunctionTok@1006 : Text;VendorNumber@1002 : Code[20];VendorName@1003 : Text[50];VendorNumberFieldName@1008 : Text);
    VAR
      MyNotifications@1009 : Record 1518;
      NotificationLifecycleMgt@1007 : Codeunit 1511;
      ModifyVendorAddressNotification@1000 : Notification;
    BEGIN
      IF NOT MyNotifications.IsEnabled(NotificationID) THEN
        EXIT;

      ModifyVendorAddressNotification.ID := NotificationID;
      ModifyVendorAddressNotification.MESSAGE := STRSUBSTNO(NotificationMsg,VendorName);
      ModifyVendorAddressNotification.ADDACTION(NotificationLbl,CODEUNIT::"Document Notifications",NotificationFunctionTok);
      ModifyVendorAddressNotification.ADDACTION(
        DontShowAgainActionLbl,CODEUNIT::"Document Notifications",'HidePurchaseNotificationForCurrentUser');
      ModifyVendorAddressNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      ModifyVendorAddressNotification.SETDATA(FIELDNAME("Document Type"),FORMAT("Document Type"));
      ModifyVendorAddressNotification.SETDATA(FIELDNAME("No."),"No.");
      ModifyVendorAddressNotification.SETDATA(VendorNumberFieldName,VendorNumber);
      NotificationLifecycleMgt.SendNotification(ModifyVendorAddressNotification,RECORDID);
    END;

    PROCEDURE RecallModifyAddressNotification@148(NotificationID@1001 : GUID);
    VAR
      MyNotifications@1002 : Record 1518;
      ModifyVendorAddressNotification@1000 : Notification;
    BEGIN
      IF IsCreditDocType OR (NOT MyNotifications.IsEnabled(NotificationID)) THEN
        EXIT;
      ModifyVendorAddressNotification.ID := NotificationID;
      ModifyVendorAddressNotification.RECALL;
    END;

    PROCEDURE GetModifyVendorAddressNotificationId@193() : GUID;
    BEGIN
      EXIT('CF3D0CD3-C54A-47D1-8A3F-57A6CCBA8DDE');
    END;

    PROCEDURE GetModifyPayToVendorAddressNotificationId@191() : GUID;
    BEGIN
      EXIT('16E45B3A-CB9F-4B2C-9F08-2BCE39E9E980');
    END;

    PROCEDURE GetShowExternalDocAlreadyExistNotificationId@92() : GUID;
    BEGIN
      EXIT('D87F624C-D3BE-4E6B-A369-D18AE269181A');
    END;

    PROCEDURE SetModifyVendorAddressNotificationDefaultState@196();
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      MyNotifications.InsertDefault(GetModifyVendorAddressNotificationId,
        ModifyBuyFromVendorAddressNotificationNameTxt,ModifyBuyFromVendorAddressNotificationDescriptionTxt,TRUE);
    END;

    PROCEDURE SetModifyPayToVendorAddressNotificationDefaultState@197();
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      MyNotifications.InsertDefault(GetModifyPayToVendorAddressNotificationId,
        ModifyPayToVendorAddressNotificationNameTxt,ModifyPayToVendorAddressNotificationDescriptionTxt,TRUE);
    END;

    PROCEDURE SetShowExternalDocAlreadyExistNotificationDefaultState@87(DefaultState@1001 : Boolean);
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      MyNotifications.InsertDefault(GetShowExternalDocAlreadyExistNotificationId,
        ShowDocAlreadyExistNotificationNameTxt,ShowDocAlreadyExistNotificationDescriptionTxt,DefaultState);
    END;

    PROCEDURE DontNotifyCurrentUserAgain@141(NotificationID@1001 : GUID);
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      IF NOT MyNotifications.Disable(NotificationID) THEN
        CASE NotificationID OF
          GetModifyVendorAddressNotificationId:
            MyNotifications.InsertDefault(NotificationID,ModifyBuyFromVendorAddressNotificationNameTxt,
              ModifyBuyFromVendorAddressNotificationDescriptionTxt,FALSE);
          GetModifyPayToVendorAddressNotificationId:
            MyNotifications.InsertDefault(NotificationID,ModifyPayToVendorAddressNotificationNameTxt,
              ModifyPayToVendorAddressNotificationDescriptionTxt,FALSE);
        END;
    END;

    LOCAL PROCEDURE HasDifferentBuyFromAddress@195(Vendor@1000 : Record 23) : Boolean;
    BEGIN
      EXIT(("Buy-from Address" <> Vendor.Address) OR
        ("Buy-from Address 2" <> Vendor."Address 2") OR
        ("Buy-from City" <> Vendor.City) OR
        ("Buy-from Country/Region Code" <> Vendor."Country/Region Code") OR
        ("Buy-from County" <> Vendor.County) OR
        ("Buy-from Post Code" <> Vendor."Post Code") OR
        ("Buy-from Contact" <> Vendor.Contact));
    END;

    LOCAL PROCEDURE HasDifferentPayToAddress@192(Vendor@1000 : Record 23) : Boolean;
    BEGIN
      EXIT(("Pay-to Address" <> Vendor.Address) OR
        ("Pay-to Address 2" <> Vendor."Address 2") OR
        ("Pay-to City" <> Vendor.City) OR
        ("Pay-to Country/Region Code" <> Vendor."Country/Region Code") OR
        ("Pay-to County" <> Vendor.County) OR
        ("Pay-to Post Code" <> Vendor."Post Code") OR
        ("Pay-to Contact" <> Vendor.Contact));
    END;

    LOCAL PROCEDURE FindPostedDocumentWithSameExternalDocNo@88(VAR VendorLedgerEntry@1000 : Record 25;ExternalDocumentNo@1001 : Code[35]) : Boolean;
    BEGIN
      VendorLedgerEntry.SETRANGE("External Document No.",ExternalDocumentNo);
      VendorLedgerEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
      VendorLedgerEntry.SETRANGE("Document Type",GetGenJnlDocumentType);
      VendorLedgerEntry.SETRANGE(Reversed,FALSE);
      EXIT(VendorLedgerEntry.FINDFIRST);
    END;

    LOCAL PROCEDURE ShowExternalDocAlreadyExistNotification@89(VendorLedgerEntry@1000 : Record 25);
    VAR
      NotificationLifecycleMgt@1002 : Codeunit 1511;
      DocAlreadyExistNotification@1001 : Notification;
    BEGIN
      IF NOT IsDocAlreadyExistNotificationEnabled THEN
        EXIT;

      DocAlreadyExistNotification.ID := GetShowExternalDocAlreadyExistNotificationId;
      DocAlreadyExistNotification.MESSAGE :=
        STRSUBSTNO(PurchaseAlreadyExistsTxt,VendorLedgerEntry."Document Type",VendorLedgerEntry."External Document No.");
      DocAlreadyExistNotification.ADDACTION(ShowVendLedgEntryTxt,CODEUNIT::"Document Notifications",'ShowVendorLedgerEntry');
      DocAlreadyExistNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      DocAlreadyExistNotification.SETDATA(FIELDNAME("Document Type"),FORMAT("Document Type"));
      DocAlreadyExistNotification.SETDATA(FIELDNAME("No."),"No.");
      DocAlreadyExistNotification.SETDATA(VendorLedgerEntry.FIELDNAME("Entry No."),FORMAT(VendorLedgerEntry."Entry No."));
      NotificationLifecycleMgt.SendNotificationWithAdditionalContext(
        DocAlreadyExistNotification,RECORDID,GetShowExternalDocAlreadyExistNotificationId);
    END;

    LOCAL PROCEDURE GetGenJnlDocumentType@90() : Integer;
    VAR
      RefGenJournalLine@1000 : Record 81;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::"Blanket Order",
        "Document Type"::Quote,
        "Document Type"::Invoice,
        "Document Type"::Order:
          EXIT(RefGenJournalLine."Document Type"::Invoice);
        ELSE
          EXIT(RefGenJournalLine."Document Type"::"Credit Memo");
      END;
    END;

    LOCAL PROCEDURE RecallExternalDocAlreadyExistsNotification@39();
    VAR
      NotificationLifecycleMgt@1000 : Codeunit 1511;
    BEGIN
      IF NOT IsDocAlreadyExistNotificationEnabled THEN
        EXIT;

      NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
        RECORDID,GetShowExternalDocAlreadyExistNotificationId,TRUE);
    END;

    LOCAL PROCEDURE IsDocAlreadyExistNotificationEnabled@91() : Boolean;
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      IF NOT MyNotifications.GET(USERID,GetShowExternalDocAlreadyExistNotificationId) THEN
        EXIT(FALSE);

      EXIT(MyNotifications.Enabled);
    END;

    [External]
    PROCEDURE ShipToAddressEqualsCompanyShipToAddress@111() : Boolean;
    VAR
      CompanyInformation@1000 : Record 79;
    BEGIN
      CompanyInformation.GET;
      EXIT(IsShipToAddressEqualToCompanyShipToAddress(Rec,CompanyInformation));
    END;

    LOCAL PROCEDURE IsShipToAddressEqualToCompanyShipToAddress@113(PurchaseHeader@1000 : Record 38;CompanyInformation@1001 : Record 79) : Boolean;
    BEGIN
      EXIT(
        (PurchaseHeader."Ship-to Address" = CompanyInformation."Ship-to Address") AND
        (PurchaseHeader."Ship-to Address 2" = CompanyInformation."Ship-to Address 2") AND
        (PurchaseHeader."Ship-to City" = CompanyInformation."Ship-to City") AND
        (PurchaseHeader."Ship-to County" = CompanyInformation."Ship-to County") AND
        (PurchaseHeader."Ship-to Post Code" = CompanyInformation."Ship-to Post Code") AND
        (PurchaseHeader."Ship-to Country/Region Code" = CompanyInformation."Ship-to Country/Region Code") AND
        (PurchaseHeader."Ship-to Name" = CompanyInformation."Ship-to Name"));
    END;

    [External]
    PROCEDURE BuyFromAddressEqualsShipToAddress@94() : Boolean;
    BEGIN
      EXIT(
        ("Ship-to Address" = "Buy-from Address") AND
        ("Ship-to Address 2" = "Buy-from Address 2") AND
        ("Ship-to City" = "Buy-from City") AND
        ("Ship-to County" = "Buy-from County") AND
        ("Ship-to Post Code" = "Buy-from Post Code") AND
        ("Ship-to Country/Region Code" = "Buy-from Country/Region Code") AND
        ("Ship-to Name" = "Buy-from Vendor Name"));
    END;

    LOCAL PROCEDURE SetPurchaserCode@933(PurchaserCodeToCheck@1000 : Code[20];VAR PurchaserCodeToAssign@1001 : Code[20]);
    BEGIN
      IF PurchaserCodeToCheck <> '' THEN
        IF SalespersonPurchaser.GET(PurchaserCodeToCheck) THEN
          IF SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) THEN
            PurchaserCodeToAssign := ''
          ELSE
            PurchaserCodeToAssign := PurchaserCodeToCheck;
    END;

    PROCEDURE ValidatePurchaserOnPurchHeader@912(PurchaseHeader2@1000 : Record 38;IsTransaction@1001 : Boolean;IsPostAction@1002 : Boolean);
    BEGIN
      IF PurchaseHeader2."Purchaser Code" <> '' THEN
        IF SalespersonPurchaser.GET(PurchaseHeader2."Purchaser Code") THEN
          IF SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) THEN BEGIN
            IF IsTransaction THEN
              ERROR(SalespersonPurchaser.GetPrivacyBlockedTransactionText(SalespersonPurchaser,IsPostAction,FALSE));
            IF NOT IsTransaction THEN
              ERROR(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser,FALSE));
          END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitRecord@138(VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitNoSeries@140(VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTestNoSeries@136(VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateShipToAddress@137(VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnUpdatePurchLinesByChangedFieldName@139(PurchHeader@1000 : Record 38;VAR PurchLine@1001 : Record 39;ChangedFieldName@1002 : Text[100]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@164(VAR PurchaseHeader@1000 : Record 38;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferExtendedTextForPurchaseLineRecreation@165(VAR PurchLine@1000 : Record 39);
    BEGIN
    END;

    [Integration(TRUE)]
    PROCEDURE OnValidatePurchaseHeaderPayToVendorNo@1215(Vendor@1214 : Record 23);
    BEGIN
    END;

    BEGIN
    END.
  }
}

