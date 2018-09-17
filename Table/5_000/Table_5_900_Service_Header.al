OBJECT Table 5900 Service Header
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019,NAVDK11.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 5914=d,
                TableData 5950=rimd;
    DataCaptionFields=No.,Name,Description;
    OnInsert=VAR
               ServShptHeader@1001 : Record 5990;
             BEGIN
               ServSetup.GET ;
               IF "No." = '' THEN BEGIN
                 TestNoSeries;
                 NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series",0D,"No.","No. Series");
               END;

               IF "Document Type" = "Document Type"::Order THEN BEGIN
                 ServShptHeader.SETRANGE("Order No.","No.");
                 IF NOT ServShptHeader.ISEMPTY THEN
                   ERROR(Text008,FORMAT("Document Type"),FIELDCAPTION("No."),"No.");
               END;

               InitRecord;

               CLEAR(ServLogMgt);
               ServLogMgt.ServHeaderCreate(Rec);

               IF "Salesperson Code" = '' THEN
                 SetDefaultSalesperson;

               IF GETFILTER("Customer No.") <> '' THEN BEGIN
                 CLEAR(xRec."Ship-to Code");
                 IF GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") THEN
                   VALIDATE("Customer No.",GETRANGEMIN("Customer No."));
               END;

               IF GETFILTER("Contact No.") <> '' THEN
                 IF GETRANGEMIN("Contact No.") = GETRANGEMAX("Contact No.") THEN
                   VALIDATE("Contact No.",GETRANGEMIN("Contact No."));
             END;

    OnModify=BEGIN
               UpdateServiceOrderChangeLog(xRec);
             END;

    OnDelete=VAR
               ServDocRegister@1000 : Record 5936;
               ServDocLog@1001 : Record 5912;
               ServOrderAlloc@1007 : Record 5950;
               ServCommentLine@1008 : Record 5906;
               WhseRequest@1003 : Record 5765;
               Loaner@1006 : Record 5913;
               LoanerEntry@1004 : Record 5914;
               ServAllocMgt@1002 : Codeunit 5930;
               ReservMgt@1005 : Codeunit 99000845;
             BEGIN
               IF NOT UserSetupMgt.CheckRespCenter(2,"Responsibility Center") THEN
                 ERROR(Text000,UserSetupMgt.GetServiceFilter);

               IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                 ServLine.RESET;
                 ServLine.SETRANGE("Document Type",ServLine."Document Type"::Invoice);
                 ServLine.SETRANGE("Document No.","No.");
                 ServLine.SETFILTER("Appl.-to Service Entry",'>%1',0);
                 IF NOT ServLine.ISEMPTY THEN
                   ERROR(Text046,"No.");
               END;

               ServPost.DeleteHeader(Rec,ServShptHeader,ServInvHeader,ServCrMemoHeader);
               VALIDATE("Applies-to ID",'');

               ServLine.RESET;
               ServLine.LOCKTABLE;

               ReservMgt.DeleteDocumentReservation(DATABASE::"Service Line","Document Type","No.",HideValidationDialog);

               WhseRequest.DeleteRequest(DATABASE::"Service Line","Document Type","No.");

               ServLine.SETRANGE("Document Type","Document Type");
               ServLine.SETRANGE("Document No.","No.");
               ServLine.SuspendStatusCheck(TRUE);
               ServLine.DELETEALL(TRUE);

               ServCommentLine.RESET;
               ServCommentLine.SETRANGE("Table Name",ServCommentLine."Table Name"::"Service Header");
               ServCommentLine.SETRANGE("Table Subtype","Document Type");
               ServCommentLine.SETRANGE("No.","No.");
               ServCommentLine.DELETEALL;

               ServDocRegister.SETCURRENTKEY("Destination Document Type","Destination Document No.");
               CASE "Document Type" OF
                 "Document Type"::Invoice:
                   BEGIN
                     ServDocRegister.SETRANGE("Destination Document Type",ServDocRegister."Destination Document Type"::Invoice);
                     ServDocRegister.SETRANGE("Destination Document No.","No.");
                     ServDocRegister.DELETEALL;
                   END;
                 "Document Type"::"Credit Memo":
                   BEGIN
                     ServDocRegister.SETRANGE("Destination Document Type",ServDocRegister."Destination Document Type"::"Credit Memo");
                     ServDocRegister.SETRANGE("Destination Document No.","No.");
                     ServDocRegister.DELETEALL;
                   END;
               END;

               ServOrderAlloc.RESET;
               ServOrderAlloc.SETCURRENTKEY("Document Type");
               ServOrderAlloc.SETRANGE("Document Type","Document Type");
               ServOrderAlloc.SETRANGE("Document No.","No.");
               ServOrderAlloc.SETRANGE(Posted,FALSE);
               ServOrderAlloc.DELETEALL;
               ServAllocMgt.SetServOrderAllocStatus(Rec);

               ServItemLine.RESET;
               ServItemLine.SETRANGE("Document Type","Document Type");
               ServItemLine.SETRANGE("Document No.","No.");
               IF ServItemLine.FIND('-') THEN
                 REPEAT
                   IF ServItemLine."Loaner No." <> '' THEN BEGIN
                     Loaner.GET(ServItemLine."Loaner No.");
                     LoanerEntry.SETRANGE("Document Type","Document Type" + 1);
                     LoanerEntry.SETRANGE("Document No.","No.");
                     LoanerEntry.SETRANGE("Loaner No.",ServItemLine."Loaner No.");
                     LoanerEntry.SETRANGE(Lent,TRUE);
                     IF NOT LoanerEntry.ISEMPTY THEN
                       ERROR(
                         Text040,
                         TABLECAPTION,
                         ServItemLine."Document No.",
                         ServItemLine."Line No.",
                         ServItemLine.FIELDCAPTION("Loaner No."),
                         ServItemLine."Loaner No.");

                     LoanerEntry.SETRANGE(Lent,TRUE);
                     LoanerEntry.DELETEALL;
                   END;

                   CLEAR(ServLogMgt);
                   ServLogMgt.ServItemOffServOrder(ServItemLine);
                   ServItemLine.DELETE;
                 UNTIL ServItemLine.NEXT = 0;

               ServDocLog.RESET;
               ServDocLog.SETRANGE("Document Type","Document Type");
               ServDocLog.SETRANGE("Document No.","No.");
               ServDocLog.DELETEALL;

               ServDocLog.RESET;
               ServDocLog.SETRANGE(Before,"No.");
               ServDocLog.SETFILTER("Document Type",'%1|%2|%3',
                 ServDocLog."Document Type"::Shipment,ServDocLog."Document Type"::"Posted Invoice",
                 ServDocLog."Document Type"::"Posted Credit Memo");
               ServDocLog.DELETEALL;

               IF (ServShptHeader."No." <> '') OR
                  (ServInvHeader."No." <> '') OR
                  (ServCrMemoHeader."No." <> '')
               THEN
                 MESSAGE(PostedDocsToPrintCreatedMsg);
             END;

    OnRename=BEGIN
               ERROR(Text044,TABLECAPTION);
             END;

    CaptionML=[DAN=Serviceordrehoved;
               ENU=Service Header];
    LookupPageID=Page5901;
    DrillDownPageID=Page5901;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota;
                                                                    ENU=Quote,Order,Invoice,Credit Memo];
                                                   OptionString=Quote,Order,Invoice,Credit Memo }
    { 2   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   OnValidate=BEGIN
                                                                IF ("Customer No." <> xRec."Customer No.") AND (xRec."Customer No." <> '') THEN BEGIN
                                                                  IF "Contract No." <> '' THEN
                                                                    ERROR(
                                                                      Text003,
                                                                      FIELDCAPTION("Customer No."),
                                                                      "Document Type",FIELDCAPTION("No."),"No.",
                                                                      FIELDCAPTION("Contract No."),"Contract No.");
                                                                  IF HideValidationDialog OR NOT GUIALLOWED THEN
                                                                    Confirmed := TRUE
                                                                  ELSE
                                                                    IF ServItemLineExists THEN
                                                                      Confirmed :=
                                                                        CONFIRM(
                                                                          Text004,
                                                                          FALSE,FIELDCAPTION("Customer No."))
                                                                    ELSE
                                                                      IF ServLineExists THEN
                                                                        Confirmed :=
                                                                          CONFIRM(
                                                                            Text057,
                                                                            FALSE,FIELDCAPTION("Customer No."))
                                                                      ELSE
                                                                        Confirmed := CONFIRM(Text005,FALSE,FIELDCAPTION("Customer No."));
                                                                  IF Confirmed THEN BEGIN
                                                                    ServLine.SETRANGE("Document Type","Document Type");
                                                                    ServLine.SETRANGE("Document No.","No.");
                                                                    IF "Document Type" = "Document Type"::Order THEN
                                                                      ServLine.SETFILTER("Quantity Shipped",'<>0')
                                                                    ELSE
                                                                      IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                                                                        ServLine.SETRANGE("Customer No.",xRec."Customer No.");
                                                                        ServLine.SETFILTER("Shipment No.",'<>%1','');
                                                                      END;

                                                                    IF ServLine.FINDFIRST THEN BEGIN
                                                                      IF "Document Type" = "Document Type"::Order THEN
                                                                        ServLine.TESTFIELD("Quantity Shipped",0)
                                                                      ELSE
                                                                        ServLine.TESTFIELD("Shipment No.",'');
                                                                    END;
                                                                    MODIFY(TRUE);

                                                                    ServLine.LOCKTABLE;
                                                                    ServLine.RESET;
                                                                    ServLine.SETRANGE("Document Type","Document Type");
                                                                    ServLine.SETRANGE("Document No.","No.");
                                                                    ServLine.DELETEALL(TRUE);

                                                                    ServItemLine.LOCKTABLE;
                                                                    ServItemLine.RESET;
                                                                    ServItemLine.SETRANGE("Document Type","Document Type");
                                                                    ServItemLine.SETRANGE("Document No.","No.");
                                                                    ServItemLine.DELETEALL(TRUE);

                                                                    GET("Document Type","No.");
                                                                    IF "Customer No." = '' THEN BEGIN
                                                                      INIT;
                                                                      ServSetup.GET;
                                                                      "No. Series" := xRec."No. Series";
                                                                      InitRecord;
                                                                      IF xRec."Shipping No." <> '' THEN BEGIN
                                                                        "Shipping No. Series" := xRec."Shipping No. Series";
                                                                        "Shipping No." := xRec."Shipping No.";
                                                                      END;
                                                                      IF xRec."Posting No." <> '' THEN BEGIN
                                                                        "Posting No. Series" := xRec."Posting No. Series";
                                                                        "Posting No." := xRec."Posting No.";
                                                                      END;
                                                                      EXIT;
                                                                    END;
                                                                  END ELSE BEGIN
                                                                    Rec := xRec;
                                                                    EXIT;
                                                                  END;
                                                                END;

                                                                GetCust("Customer No.");
                                                                IF "Customer No." <> '' THEN BEGIN
                                                                  Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,FALSE);
                                                                  Cust.TESTFIELD("Gen. Bus. Posting Group");
                                                                  Name := Cust.Name;
                                                                  "Name 2" := Cust."Name 2";
                                                                  Address := Cust.Address;
                                                                  "Address 2" := Cust."Address 2";
                                                                  City := Cust.City;
                                                                  "Post Code" := Cust."Post Code";
                                                                  County := Cust.County;
                                                                  "Country/Region Code" := Cust."Country/Region Code";
                                                                  "Account Code" := Cust."Account Code";
                                                                  IF NOT SkipContact THEN BEGIN
                                                                    "Contact Name" := Cust.Contact;
                                                                    "Phone No." := Cust."Phone No.";
                                                                    "E-Mail" := Cust."E-Mail";
                                                                  END;
                                                                  "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                                                                  "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                                                                  "Tax Area Code" := Cust."Tax Area Code";
                                                                  "Tax Liable" := Cust."Tax Liable";
                                                                  "VAT Registration No." := Cust."VAT Registration No.";
                                                                  "Shipping Advice" := Cust."Shipping Advice";
                                                                  "Responsibility Center" := UserSetupMgt.GetRespCenter(2,Cust."Responsibility Center");
                                                                  VALIDATE("Location Code",UserSetupMgt.GetLocation(2,Cust."Location Code","Responsibility Center"));
                                                                END;

                                                                IF "Customer No." = xRec."Customer No." THEN
                                                                  IF ShippedServLinesExist THEN BEGIN
                                                                    TESTFIELD("VAT Bus. Posting Group",xRec."VAT Bus. Posting Group");
                                                                    TESTFIELD("Gen. Bus. Posting Group",xRec."Gen. Bus. Posting Group");
                                                                  END;

                                                                COMMIT;
                                                                IF Cust."Bill-to Customer No." <> '' THEN
                                                                  VALIDATE("Bill-to Customer No.",Cust."Bill-to Customer No.")
                                                                ELSE BEGIN
                                                                  IF "Bill-to Customer No." = "Customer No." THEN
                                                                    SkipBillToContact := TRUE;
                                                                  VALIDATE("Bill-to Customer No.","Customer No.");
                                                                  SkipBillToContact := FALSE;
                                                                END;

                                                                VALIDATE("Ship-to Code",'');
                                                                VALIDATE("Service Zone Code");

                                                                IF NOT SkipContact THEN
                                                                  UpdateCont("Customer No.");

                                                                "OIOUBL Profile Code" := Cust."OIOUBL Profile Code";
                                                              END;

                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.] }
    { 3   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  ServSetup.GET;
                                                                  TestNoSeriesManual;
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 4   ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   OnValidate=VAR
                                                                PaymentTerms@1001 : Record 3;
                                                                CustCheckCrLimit@1000 : Codeunit 312;
                                                              BEGIN
                                                                IF (xRec."Bill-to Customer No." <> "Bill-to Customer No.") AND
                                                                   (xRec."Bill-to Customer No." <> '')
                                                                THEN BEGIN
                                                                  IF HideValidationDialog OR NOT GUIALLOWED THEN
                                                                    Confirmed := TRUE
                                                                  ELSE
                                                                    Confirmed := CONFIRM(Text005,FALSE,FIELDCAPTION("Bill-to Customer No."));
                                                                  IF Confirmed THEN BEGIN
                                                                    ServLine.SETRANGE("Document Type","Document Type");
                                                                    ServLine.SETRANGE("Document No.","No.");
                                                                    IF "Document Type" = "Document Type"::Order THEN
                                                                      ServLine.SETFILTER("Quantity Shipped",'<>0')
                                                                    ELSE
                                                                      IF "Document Type" = "Document Type"::Invoice THEN
                                                                        ServLine.SETFILTER("Shipment No.",'<>%1','');

                                                                    IF ServLine.FINDFIRST THEN
                                                                      IF "Document Type" = "Document Type"::Order THEN
                                                                        ServLine.TESTFIELD("Quantity Shipped",0)
                                                                      ELSE
                                                                        ServLine.TESTFIELD("Shipment No.",'');
                                                                    ServLine.RESET;
                                                                  END ELSE
                                                                    "Bill-to Customer No." := xRec."Bill-to Customer No.";
                                                                END;

                                                                GetCust("Bill-to Customer No.");
                                                                Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,FALSE);
                                                                Cust.TESTFIELD("Customer Posting Group");
                                                                "EAN No." := Cust.GLN;

                                                                IF GUIALLOWED AND NOT HideValidationDialog AND
                                                                   ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order,"Document Type"::Invoice])
                                                                THEN
                                                                  CustCheckCrLimit.ServiceHeaderCheck(Rec);

                                                                "Bill-to Name" := Cust.Name;
                                                                "Bill-to Name 2" := Cust."Name 2";
                                                                "Bill-to Address" := Cust.Address;
                                                                "Bill-to Address 2" := Cust."Address 2";
                                                                "Bill-to City" := Cust.City;
                                                                "Bill-to Post Code" := Cust."Post Code";
                                                                "Bill-to County" := Cust.County;
                                                                "Bill-to Country/Region Code" := Cust."Country/Region Code";
                                                                IF NOT SkipBillToContact THEN
                                                                  "Bill-to Contact" := Cust.Contact;
                                                                "Payment Terms Code" := Cust."Payment Terms Code";

                                                                IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                                                                  "Payment Method Code" := '';
                                                                  IF PaymentTerms.GET("Payment Terms Code") THEN
                                                                    IF PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN
                                                                      "Payment Method Code" := Cust."Payment Method Code"
                                                                END ELSE
                                                                  "Payment Method Code" := Cust."Payment Method Code";
                                                                GLSetup.GET;
                                                                IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." THEN BEGIN
                                                                  "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                                                                  "VAT Registration No." := Cust."VAT Registration No.";
                                                                  "VAT Country/Region Code" := Cust."Country/Region Code";
                                                                  "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                                                                END;
                                                                "Customer Posting Group" := Cust."Customer Posting Group";
                                                                "Currency Code" := Cust."Currency Code";
                                                                "Customer Price Group" := Cust."Customer Price Group";
                                                                "Prices Including VAT" := Cust."Prices Including VAT";
                                                                "Allow Line Disc." := Cust."Allow Line Disc.";
                                                                "Invoice Disc. Code" := Cust."Invoice Disc. Code";
                                                                "Customer Disc. Group" := Cust."Customer Disc. Group";
                                                                "Language Code" := Cust."Language Code";
                                                                SetSalespersonCode(Cust."Salesperson Code","Salesperson Code");
                                                                Reserve := Cust.Reserve;
                                                                ValidateServPriceGrOnServItem;

                                                                IF "Bill-to Customer No." = xRec."Bill-to Customer No." THEN
                                                                  IF ShippedServLinesExist THEN BEGIN
                                                                    TESTFIELD("Customer Disc. Group",xRec."Customer Disc. Group");
                                                                    TESTFIELD("Currency Code",xRec."Currency Code");
                                                                  END;

                                                                CreateDim(
                                                                  DATABASE::"Service Order Type","Service Order Type",
                                                                  DATABASE::Customer,"Bill-to Customer No.",
                                                                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::"Service Contract Header","Contract No.");

                                                                VALIDATE("Payment Terms Code");
                                                                VALIDATE("Payment Method Code");
                                                                VALIDATE("Currency Code");

                                                                IF (xRec."Customer No." = "Customer No.") AND
                                                                   (xRec."Bill-to Customer No." <> "Bill-to Customer No.")
                                                                THEN
                                                                  RecreateServLines(FIELDCAPTION("Bill-to Customer No."));

                                                                IF NOT SkipBillToContact THEN
                                                                  UpdateBillToCont("Bill-to Customer No.");
                                                              END;

                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.];
                                                   NotBlank=Yes }
    { 5   ;   ;Bill-to Name        ;Text50        ;CaptionML=[DAN=Faktureringsnavn;
                                                              ENU=Bill-to Name] }
    { 6   ;   ;Bill-to Name 2      ;Text50        ;CaptionML=[DAN=Faktureringsnavn 2;
                                                              ENU=Bill-to Name 2] }
    { 7   ;   ;Bill-to Address     ;Text50        ;CaptionML=[DAN=Faktureringsadresse;
                                                              ENU=Bill-to Address] }
    { 8   ;   ;Bill-to Address 2   ;Text50        ;CaptionML=[DAN=Faktureringsadresse 2;
                                                              ENU=Bill-to Address 2] }
    { 9   ;   ;Bill-to City        ;Text30        ;TableRelation=IF (Bill-to Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(
                                                                  "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Faktureringsby;
                                                              ENU=Bill-to City] }
    { 10  ;   ;Bill-to Contact     ;Text50        ;CaptionML=[DAN=Faktureres attention;
                                                              ENU=Bill-to Contact] }
    { 11  ;   ;Your Reference      ;Text35        ;CaptionML=[DAN=Reference;
                                                              ENU=Your Reference] }
    { 12  ;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Customer No.));
                                                   OnValidate=VAR
                                                                ShipToAddr@1000 : Record 222;
                                                              BEGIN
                                                                IF ("Ship-to Code" <> xRec."Ship-to Code") AND
                                                                   ("Customer No." = xRec."Customer No.")
                                                                THEN BEGIN
                                                                  IF ("Contract No." <> '') AND NOT HideValidationDialog THEN
                                                                    ERROR(
                                                                      Text003,
                                                                      FIELDCAPTION("Ship-to Code"),
                                                                      "Document Type",FIELDCAPTION("No."),"No.",
                                                                      FIELDCAPTION("Contract No."),"Contract No.");
                                                                  IF ServItemLineExists THEN BEGIN
                                                                    IF NOT
                                                                       CONFIRM(
                                                                         Text004,
                                                                         FALSE,FIELDCAPTION("Ship-to Code"))
                                                                    THEN BEGIN
                                                                      "Ship-to Code" := xRec."Ship-to Code";
                                                                      EXIT;
                                                                    END;
                                                                  END ELSE
                                                                    IF ServLineExists THEN
                                                                      IF NOT
                                                                         CONFIRM(
                                                                           Text057,
                                                                           FALSE,FIELDCAPTION("Ship-to Code"))
                                                                      THEN BEGIN
                                                                        "Ship-to Code" := xRec."Ship-to Code";
                                                                        EXIT;
                                                                      END;
                                                                END;

                                                                IF "Document Type" <> "Document Type"::"Credit Memo" THEN
                                                                  IF "Ship-to Code" <> '' THEN BEGIN
                                                                    IF xRec."Ship-to Code" <> '' THEN BEGIN
                                                                      GetCust("Customer No.");
                                                                      IF Cust."Location Code" <> '' THEN
                                                                        "Location Code" := Cust."Location Code";
                                                                      "Tax Area Code" := Cust."Tax Area Code";
                                                                    END;
                                                                    ShipToAddr.GET("Customer No.","Ship-to Code");
                                                                    SetShipToAddress(
                                                                      ShipToAddr.Name,ShipToAddr."Name 2",ShipToAddr.Address,ShipToAddr."Address 2",
                                                                      ShipToAddr.City,ShipToAddr."Post Code",ShipToAddr.County,ShipToAddr."Country/Region Code");
                                                                    "Ship-to Contact" := ShipToAddr.Contact;
                                                                    "Ship-to Phone" := ShipToAddr."Phone No.";
                                                                    IF ShipToAddr."Location Code" <> '' THEN
                                                                      "Location Code" := ShipToAddr."Location Code";
                                                                    "Ship-to Fax No." := ShipToAddr."Fax No.";
                                                                    "Ship-to E-Mail" := ShipToAddr."E-Mail";
                                                                    IF ShipToAddr."Tax Area Code" <> '' THEN
                                                                      "Tax Area Code" := ShipToAddr."Tax Area Code";
                                                                    "Tax Liable" := ShipToAddr."Tax Liable";
                                                                  END ELSE
                                                                    IF "Customer No." <> '' THEN BEGIN
                                                                      GetCust("Customer No.");
                                                                      SetShipToAddress(
                                                                        Cust.Name,Cust."Name 2",Cust.Address,Cust."Address 2",
                                                                        Cust.City,Cust."Post Code",Cust.County,Cust."Country/Region Code");
                                                                      "Ship-to Contact" := Cust.Contact;
                                                                      "Ship-to Phone" := Cust."Phone No.";
                                                                      "Tax Area Code" := Cust."Tax Area Code";
                                                                      "Tax Liable" := Cust."Tax Liable";
                                                                      IF Cust."Location Code" <> '' THEN
                                                                        "Location Code" := Cust."Location Code";
                                                                      "Ship-to Fax No." := Cust."Fax No.";
                                                                      "Ship-to E-Mail" := Cust."E-Mail";
                                                                    END;

                                                                IF (xRec."Customer No." = "Customer No.") AND
                                                                   (xRec."Ship-to Code" <> "Ship-to Code")
                                                                THEN
                                                                  IF (xRec."VAT Country/Region Code" <> "VAT Country/Region Code") OR
                                                                     (xRec."Tax Area Code" <> "Tax Area Code")
                                                                  THEN
                                                                    RecreateServLines(FIELDCAPTION("Ship-to Code"))
                                                                  ELSE BEGIN
                                                                    IF xRec."Tax Liable" <> "Tax Liable" THEN
                                                                      VALIDATE("Tax Liable");
                                                                  END;

                                                                VALIDATE("Service Zone Code");

                                                                IF ("Ship-to Code" <> xRec."Ship-to Code") AND
                                                                   ("Customer No." = xRec."Customer No.")
                                                                THEN BEGIN
                                                                  MODIFY(TRUE);
                                                                  ServLine.LOCKTABLE;
                                                                  ServItemLine.LOCKTABLE;
                                                                  ServLine.RESET;
                                                                  ServLine.SETRANGE("Document Type","Document Type");
                                                                  ServLine.SETRANGE("Document No.","No.");
                                                                  ServLine.DELETEALL(TRUE);
                                                                  ServItemLine.RESET;
                                                                  ServItemLine.SETRANGE("Document Type","Document Type");
                                                                  ServItemLine.SETRANGE("Document No.","No.");
                                                                  ServItemLine.DELETEALL(TRUE);
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
                                                                IF "Order Date" <> xRec."Order Date" THEN BEGIN
                                                                  IF ("Order Date" > "Starting Date") AND
                                                                     ("Starting Date" <> 0D)
                                                                  THEN
                                                                    ERROR(Text007,FIELDCAPTION("Order Date"),FIELDCAPTION("Starting Date"));

                                                                  IF ("Order Date" > "Finishing Date") AND
                                                                     ("Finishing Date" <> 0D)
                                                                  THEN
                                                                    ERROR(Text007,FIELDCAPTION("Order Date"),FIELDCAPTION("Finishing Date"));

                                                                  IF "Starting Time" <> 0T THEN
                                                                    VALIDATE("Starting Time");
                                                                  ServItemLine.RESET;
                                                                  ServItemLine.SETCURRENTKEY("Document Type","Document No.","Starting Date");
                                                                  ServItemLine.SETRANGE("Document Type","Document Type");
                                                                  ServItemLine.SETRANGE("Document No.","No.");
                                                                  ServItemLine.SETFILTER("Starting Date",'<>%1',0D);
                                                                  IF ServItemLine.FIND('-') THEN
                                                                    REPEAT
                                                                      IF ServItemLine."Starting Date" < "Order Date" THEN
                                                                        ERROR(
                                                                          Text027,FIELDCAPTION("Order Date"),
                                                                          ServItemLine.FIELDCAPTION("Starting Date"));
                                                                    UNTIL ServItemLine.NEXT = 0;

                                                                  ServItemLine.RESET;
                                                                  ServItemLine.SETRANGE("Document Type","Document Type");
                                                                  ServItemLine.SETRANGE("Document No.","No.");
                                                                  IF ServItemLine.FIND('-') THEN
                                                                    REPEAT
                                                                      ServItemLine.CheckWarranty("Order Date");
                                                                      ServItemLine.CalculateResponseDateTime("Order Date","Order Time");
                                                                      ServItemLine.MODIFY;
                                                                    UNTIL ServItemLine.NEXT = 0;
                                                                  UpdateServLines(FIELDCAPTION("Order Date"),FALSE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Ordredato;
                                                              ENU=Order Date];
                                                   NotBlank=Yes }
    { 20  ;   ;Posting Date        ;Date          ;OnValidate=VAR
                                                                NoSeries@1000 : Record 308;
                                                              BEGIN
                                                                IF ("Posting No." <> '') AND ("Posting No. Series" <> '') THEN BEGIN
                                                                  NoSeries.GET("Posting No. Series");
                                                                  IF NoSeries."Date Order" THEN
                                                                    ERROR(
                                                                      Text045,
                                                                      FIELDCAPTION("Posting Date"),FIELDCAPTION("Posting No. Series"),"Posting No. Series",
                                                                      NoSeries.FIELDCAPTION("Date Order"),NoSeries."Date Order","Document Type",
                                                                      FIELDCAPTION("Posting No."),"Posting No.");
                                                                END;

                                                                VALIDATE("Document Date","Posting Date");

                                                                ServLine.SETRANGE("Document Type","Document Type");
                                                                ServLine.SETRANGE("Document No.","No.");
                                                                IF ServLine.FINDSET THEN
                                                                  REPEAT
                                                                    IF "Posting Date" <> ServLine."Posting Date" THEN BEGIN
                                                                      ServLine."Posting Date" := "Posting Date";
                                                                      ServLine.MODIFY;
                                                                    END;
                                                                  UNTIL ServLine.NEXT = 0;

                                                                IF ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND
                                                                   NOT ("Posting Date" = xRec."Posting Date")
                                                                THEN BEGIN
                                                                  IF ServLineExists THEN
                                                                    ServLine.MODIFYALL("Posting Date","Posting Date");
                                                                END;

                                                                IF "Currency Code" <> '' THEN BEGIN
                                                                  UpdateCurrencyFactor;
                                                                  IF "Currency Factor" <> xRec."Currency Factor" THEN
                                                                    ConfirmUpdateCurrencyFactor;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 22  ;   ;Posting Description ;Text50        ;CaptionML=[DAN=Bogf�ringsbeskrivelse;
                                                              ENU=Posting Description] }
    { 23  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   OnValidate=VAR
                                                                PaymentTerms@1000 : Record 3;
                                                              BEGIN
                                                                IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                                                                  PaymentTerms.GET("Payment Terms Code");
                                                                  IF ("Document Type" IN ["Document Type"::"Credit Memo"]) AND
                                                                     NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos"
                                                                  THEN BEGIN
                                                                    VALIDATE("Due Date","Document Date");
                                                                    VALIDATE("Pmt. Discount Date",0D);
                                                                    VALIDATE("Payment Discount %",0);
                                                                  END ELSE BEGIN
                                                                    "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                                                                    "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                                                                    VALIDATE("Payment Discount %",PaymentTerms."Discount %")
                                                                  END;
                                                                END ELSE BEGIN
                                                                  VALIDATE("Due Date","Document Date");
                                                                  VALIDATE("Pmt. Discount Date",0D);
                                                                  VALIDATE("Payment Discount %",0);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Betalingsbeting.kode;
                                                              ENU=Payment Terms Code] }
    { 24  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 25  ;   ;Payment Discount %  ;Decimal       ;OnValidate=BEGIN
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
                                                                TESTFIELD("Release Status","Release Status"::Open);
                                                              END;

                                                   CaptionML=[DAN=Leveringskode;
                                                              ENU=Shipment Method Code] }
    { 28  ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   OnValidate=BEGIN
                                                                IF ("Location Code" <> xRec."Location Code") AND
                                                                   ("Customer No." = xRec."Customer No.")
                                                                THEN
                                                                  MessageIfServLinesExist(FIELDCAPTION("Location Code"));

                                                                UpdateShipToAddress;
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 29  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                                                               Blocked=CONST(No));
                                                   OnValidate=BEGIN
                                                                CheckHeaderDimension;
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 30  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Blocked=CONST(No));
                                                   OnValidate=BEGIN
                                                                CheckHeaderDimension;
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 31  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group";
                                                   CaptionML=[DAN=Debitorbogf�ringsgruppe;
                                                              ENU=Customer Posting Group];
                                                   Editable=No }
    { 32  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                IF CurrFieldNo <> FIELDNO("Currency Code") THEN
                                                                  UpdateCurrencyFactor
                                                                ELSE
                                                                  IF "Currency Code" <> xRec."Currency Code" THEN BEGIN
                                                                    IF ServLineExists AND ("Contract No." <> '') AND
                                                                       ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"])
                                                                    THEN
                                                                      ERROR(Text058,FIELDCAPTION("Currency Code"),"Document Type","No.","Contract No.");

                                                                    UpdateCurrencyFactor;
                                                                    ValidateServPriceGrOnServItem;
                                                                    RecreateServLines(FIELDCAPTION("Currency Code"));
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
                                                                  UpdateServLines(FIELDCAPTION("Currency Factor"),FALSE);
                                                              END;

                                                   CaptionML=[DAN=Valutafaktor;
                                                              ENU=Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0;
                                                   Editable=No }
    { 34  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   OnValidate=BEGIN
                                                                PriceMsgIfServLinesExist(FIELDCAPTION("Customer Price Group"));
                                                              END;

                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group] }
    { 35  ;   ;Prices Including VAT;Boolean       ;OnValidate=VAR
                                                                ServLine@1002 : Record 5902;
                                                                Currency@1001 : Record 4;
                                                                RecalculatePrice@1000 : Boolean;
                                                              BEGIN
                                                                IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN
                                                                  TESTFIELD("Max. Labor Unit Price",0);
                                                                  ServLine.SETRANGE("Document Type","Document Type");
                                                                  ServLine.SETRANGE("Document No.","No.");
                                                                  ServLine.SETFILTER(Type,'>0');
                                                                  ServLine.SETFILTER(Quantity,'<>0');
                                                                  IF ServLine.FIND('-') THEN
                                                                    REPEAT
                                                                      ServLine.Amount := 0;
                                                                      ServLine."Amount Including VAT" := 0;
                                                                      ServLine."VAT Base Amount" := 0;
                                                                      ServLine.InitOutstandingAmount;
                                                                      ServLine.MODIFY;
                                                                    UNTIL ServLine.NEXT = 0;
                                                                  ServLine.SETRANGE(Type);
                                                                  ServLine.SETRANGE(Quantity);

                                                                  ServLine.SETFILTER("Unit Price",'<>%1',0);
                                                                  ServLine.SETFILTER("VAT %",'<>%1',0);
                                                                  IF ServLine.FIND('-') THEN BEGIN
                                                                    RecalculatePrice :=
                                                                      CONFIRM(
                                                                        STRSUBSTNO(
                                                                          Text055,
                                                                          FIELDCAPTION("Prices Including VAT"),ServLine.FIELDCAPTION("Unit Price")),
                                                                        TRUE);
                                                                    ServLine.SetServHeader(Rec);

                                                                    IF "Currency Code" = '' THEN
                                                                      Currency.InitRoundingPrecision
                                                                    ELSE
                                                                      Currency.GET("Currency Code");

                                                                    REPEAT
                                                                      ServLine.TESTFIELD("Quantity Invoiced",0);
                                                                      IF NOT RecalculatePrice THEN BEGIN
                                                                        ServLine."VAT Difference" := 0;
                                                                        ServLine.InitOutstandingAmount;
                                                                      END ELSE
                                                                        IF "Prices Including VAT" THEN BEGIN
                                                                          ServLine."Unit Price" :=
                                                                            ROUND(
                                                                              ServLine."Unit Price" * (1 + (ServLine."VAT %" / 100)),
                                                                              Currency."Unit-Amount Rounding Precision");
                                                                          IF ServLine.Quantity <> 0 THEN BEGIN
                                                                            ServLine."Line Discount Amount" :=
                                                                              ROUND(
                                                                                ServLine.CalcChargeableQty * ServLine."Unit Price" * ServLine."Line Discount %" / 100,
                                                                                Currency."Amount Rounding Precision");
                                                                            ServLine.VALIDATE("Inv. Discount Amount",
                                                                              ROUND(
                                                                                ServLine."Inv. Discount Amount" * (1 + (ServLine."VAT %" / 100)),
                                                                                Currency."Amount Rounding Precision"));
                                                                          END;
                                                                        END ELSE BEGIN
                                                                          ServLine."Unit Price" :=
                                                                            ROUND(
                                                                              ServLine."Unit Price" / (1 + (ServLine."VAT %" / 100)),
                                                                              Currency."Unit-Amount Rounding Precision");
                                                                          IF ServLine.Quantity <> 0 THEN BEGIN
                                                                            ServLine."Line Discount Amount" :=
                                                                              ROUND(
                                                                                ServLine.CalcChargeableQty * ServLine."Unit Price" * ServLine."Line Discount %" / 100,
                                                                                Currency."Amount Rounding Precision");
                                                                            ServLine.VALIDATE("Inv. Discount Amount",
                                                                              ROUND(
                                                                                ServLine."Inv. Discount Amount" / (1 + (ServLine."VAT %" / 100)),
                                                                                Currency."Amount Rounding Precision"));
                                                                          END;
                                                                        END;
                                                                      ServLine.MODIFY;
                                                                    UNTIL ServLine.NEXT = 0;
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Priser inkl. moms;
                                                              ENU=Prices Including VAT] }
    { 37  ;   ;Invoice Disc. Code  ;Code20        ;OnLookup=BEGIN
                                                              MessageIfServLinesExist(FIELDCAPTION("Invoice Disc. Code"));
                                                            END;

                                                   CaptionML=[DAN=Fakturarabatkode;
                                                              ENU=Invoice Disc. Code] }
    { 40  ;   ;Customer Disc. Group;Code20        ;TableRelation="Customer Discount Group";
                                                   OnValidate=BEGIN
                                                                MessageIfServLinesExist(FIELDCAPTION("Customer Disc. Group"));
                                                              END;

                                                   CaptionML=[DAN=Debitorrabatgruppe;
                                                              ENU=Customer Disc. Group] }
    { 41  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   OnValidate=BEGIN
                                                                MessageIfServLinesExist(FIELDCAPTION("Language Code"));
                                                              END;

                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 43  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=BEGIN
                                                                ValidateSalesPersonOnServiceHeader(Rec,FALSE,FALSE);

                                                                CreateDim(
                                                                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                                                                  DATABASE::Customer,"Bill-to Customer No.",
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::"Service Order Type","Service Order Type",
                                                                  DATABASE::"Service Contract Header","Contract No.");
                                                              END;

                                                   CaptionML=[DAN=S�lgerkode;
                                                              ENU=Salesperson Code] }
    { 46  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Service Comment Line" WHERE (Table Name=CONST(Service Header),
                                                                                                   Table Subtype=FIELD(Document Type),
                                                                                                   No.=FIELD(No.),
                                                                                                   Type=CONST(General)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 47  ;   ;No. Printed         ;Integer       ;CaptionML=[DAN=Udskrevet;
                                                              ENU=No. Printed];
                                                   Editable=No }
    { 52  ;   ;Applies-to Doc. Type;Option        ;CaptionML=[DAN=Udligningsbilagstype;
                                                              ENU=Applies-to Doc. Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 53  ;   ;Applies-to Doc. No. ;Code20        ;OnValidate=VAR
                                                                CustLedgEntry@1000 : Record 21;
                                                              BEGIN
                                                                IF "Applies-to Doc. No." <> '' THEN
                                                                  TESTFIELD("Bal. Account No.",'');

                                                                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." <> '') AND
                                                                   ("Applies-to Doc. No." <> '')
                                                                THEN BEGIN
                                                                  CustLedgEntry.SetAmountToApply("Applies-to Doc. No.","Customer No.");
                                                                  CustLedgEntry.SetAmountToApply(xRec."Applies-to Doc. No.","Customer No.");
                                                                END ELSE
                                                                  IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." = '') THEN
                                                                    CustLedgEntry.SetAmountToApply("Applies-to Doc. No.","Customer No.")
                                                                  ELSE
                                                                    IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') THEN
                                                                      CustLedgEntry.SetAmountToApply(xRec."Applies-to Doc. No.","Customer No.");
                                                              END;

                                                   OnLookup=VAR
                                                              CustLedgEntry@1001 : Record 21;
                                                              GenJnlLine@1002 : Record 81;
                                                              GenJnlApply@1003 : Codeunit 225;
                                                              ApplyCustEntries@1000 : Page 232;
                                                            BEGIN
                                                              TESTFIELD("Bal. Account No.",'');
                                                              CustLedgEntry.SetApplyToFilters("Bill-to Customer No.","Applies-to Doc. Type","Applies-to Doc. No.",0);

                                                              ApplyCustEntries.SetService(Rec,CustLedgEntry,ServHeader.FIELDNO("Applies-to Doc. No."));
                                                              ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
                                                              ApplyCustEntries.SETRECORD(CustLedgEntry);
                                                              ApplyCustEntries.LOOKUPMODE(TRUE);
                                                              IF ApplyCustEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                                                ApplyCustEntries.GetCustLedgEntry(CustLedgEntry);
                                                                GenJnlApply.CheckAgainstApplnCurrency(
                                                                  "Currency Code",CustLedgEntry."Currency Code",GenJnlLine."Account Type"::Customer,TRUE);
                                                                "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                                                                "Applies-to Doc. No." := CustLedgEntry."Document No.";
                                                              END;
                                                              CLEAR(ApplyCustEntries);
                                                            END;

                                                   CaptionML=[DAN=Udligningsbilagsnr.;
                                                              ENU=Applies-to Doc. No.] }
    { 55  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
                                                   OnValidate=VAR
                                                                GLAcc@1000 : Record 15;
                                                                BankAcc@1001 : Record 270;
                                                              BEGIN
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
    { 62  ;   ;Shipping No.        ;Code20        ;CaptionML=[DAN=Salgsleveringsnr.;
                                                              ENU=Shipping No.] }
    { 63  ;   ;Posting No.         ;Code20        ;CaptionML=[DAN=Tildelt fakturanr.;
                                                              ENU=Posting No.] }
    { 64  ;   ;Last Shipping No.   ;Code20        ;TableRelation="Service Shipment Header";
                                                   CaptionML=[DAN=Sidste salgslev.nr.;
                                                              ENU=Last Shipping No.];
                                                   Editable=No }
    { 65  ;   ;Last Posting No.    ;Code20        ;TableRelation="Service Invoice Header";
                                                   CaptionML=[DAN=Sidste fakturanr.;
                                                              ENU=Last Posting No.];
                                                   Editable=No }
    { 70  ;   ;VAT Registration No.;Text20        ;CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
    { 73  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 74  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=VAR
                                                                GenBusPostingGroup@1000 : Record 250;
                                                              BEGIN
                                                                IF "Gen. Bus. Posting Group" <> xRec."Gen. Bus. Posting Group" THEN BEGIN
                                                                  IF GenBusPostingGroup.ValidateVatBusPostingGroup(GenBusPostingGroup,"Gen. Bus. Posting Group") THEN
                                                                    "VAT Bus. Posting Group" := GenBusPostingGroup."Def. VAT Bus. Posting Group";
                                                                  RecreateServLines(FIELDCAPTION("Gen. Bus. Posting Group"));
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 75  ;   ;EU 3-Party Trade    ;Boolean       ;CaptionML=[DAN=Trekantshandel;
                                                              ENU=EU 3-Party Trade] }
    { 76  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   OnValidate=BEGIN
                                                                UpdateServLines(FIELDCAPTION("Transaction Type"),FALSE);
                                                              END;

                                                   CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type] }
    { 77  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   OnValidate=BEGIN
                                                                UpdateServLines(FIELDCAPTION("Transport Method"),FALSE);
                                                              END;

                                                   CaptionML=[DAN=Transportm�de;
                                                              ENU=Transport Method] }
    { 78  ;   ;VAT Country/Region Code;Code10     ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode for moms;
                                                              ENU=VAT Country/Region Code] }
    { 79  ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 80  ;   ;Name 2              ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2] }
    { 81  ;   ;Address             ;Text50        ;OnValidate=BEGIN
                                                                UpdateShipToAddressFromGeneralAddress(FIELDNO("Ship-to Address"));
                                                              END;

                                                   CaptionML=[DAN=Adresse;
                                                              ENU=Address] }
    { 82  ;   ;Address 2           ;Text50        ;OnValidate=BEGIN
                                                                UpdateShipToAddressFromGeneralAddress(FIELDNO("Ship-to Address 2"));
                                                              END;

                                                   CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2] }
    { 83  ;   ;City                ;Text30        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                                UpdateShipToAddressFromGeneralAddress(FIELDNO("Ship-to City"));
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 84  ;   ;Contact Name        ;Text50        ;CaptionML=[DAN=Kontaktnavn;
                                                              ENU=Contact Name] }
    { 85  ;   ;Bill-to Post Code   ;Code20        ;TableRelation=IF (Bill-to Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(
                                                                  "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Faktureringspostnr.;
                                                              ENU=Bill-to Post Code] }
    { 86  ;   ;Bill-to County      ;Text30        ;CaptionML=[DAN=Faktureringsamt;
                                                              ENU=Bill-to County] }
    { 87  ;   ;Bill-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode til fakturering;
                                                              ENU=Bill-to Country/Region Code] }
    { 88  ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                                UpdateShipToAddressFromGeneralAddress(FIELDNO("Ship-to Post Code"));
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 89  ;   ;County              ;Text30        ;OnValidate=BEGIN
                                                                UpdateShipToAddressFromGeneralAddress(FIELDNO("Ship-to County"));
                                                              END;

                                                   CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 90  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   OnValidate=BEGIN
                                                                UpdateShipToAddressFromGeneralAddress(FIELDNO("Ship-to Country/Region Code"));

                                                                VALIDATE("Ship-to Country/Region Code");
                                                              END;

                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code] }
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
                                                   OnValidate=BEGIN
                                                                IF "Ship-to Country/Region Code" <> '' THEN
                                                                  "VAT Country/Region Code" := "Ship-to Country/Region Code"
                                                                ELSE
                                                                  "VAT Country/Region Code" := "Country/Region Code";
                                                              END;

                                                   CaptionML=[DAN=Lande-/omr�dekode for levering;
                                                              ENU=Ship-to Country/Region Code] }
    { 94  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Bankkonto;
                                                                    ENU=G/L Account,Bank Account];
                                                   OptionString=G/L Account,Bank Account }
    { 97  ;   ;Exit Point          ;Code10        ;TableRelation="Entry/Exit Point";
                                                   OnValidate=BEGIN
                                                                UpdateServLines(FIELDCAPTION("Exit Point"),FALSE);
                                                              END;

                                                   CaptionML=[DAN=Udf�rselssted;
                                                              ENU=Exit Point] }
    { 98  ;   ;Correction          ;Boolean       ;CaptionML=[DAN=Rettelse;
                                                              ENU=Correction] }
    { 99  ;   ;Document Date       ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Payment Terms Code");
                                                              END;

                                                   CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 101 ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   OnValidate=BEGIN
                                                                UpdateServLines(FIELDCAPTION(Area),FALSE);
                                                              END;

                                                   CaptionML=[DAN=Omr�de;
                                                              ENU=Area] }
    { 102 ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   OnValidate=BEGIN
                                                                UpdateServLines(FIELDCAPTION("Transaction Specification"),FALSE);
                                                              END;

                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 104 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   OnValidate=VAR
                                                                PaymentMethod@1000 : Record 289;
                                                              BEGIN
                                                                IF PaymentMethod.GET("Payment Method Code") THEN BEGIN
                                                                  "Bal. Account Type" := PaymentMethod."Bal. Account Type";
                                                                  "Bal. Account No." := PaymentMethod."Bal. Account No.";
                                                                END;
                                                                IF "Bal. Account No." <> '' THEN BEGIN
                                                                  TESTFIELD("Applies-to Doc. No.",'');
                                                                  TESTFIELD("Applies-to ID",'');
                                                                END;
                                                                "Payment Channel" := PaymentMethod."Payment Channel";
                                                              END;

                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 105 ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Release Status","Release Status"::Open);
                                                                IF xRec."Shipping Agent Code" = "Shipping Agent Code" THEN
                                                                  EXIT;

                                                                "Shipping Agent Service Code" := '';
                                                                GetShippingTime(FIELDNO("Shipping Agent Code"));
                                                                UpdateServLines(FIELDCAPTION("Shipping Agent Code"),CurrFieldNo <> 0);
                                                              END;

                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Spedit�rkode;
                                                              ENU=Shipping Agent Code] }
    { 107 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 108 ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Posting No. Series" <> '' THEN BEGIN
                                                                  ServSetup.GET;
                                                                  TestNoSeries;
                                                                  NoSeriesMgt.TestSeries(GetPostingNoSeriesCode,"Posting No. Series");
                                                                END;
                                                                TESTFIELD("Posting No.",'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              WITH ServHeader DO BEGIN
                                                                ServHeader := Rec;
                                                                ServSetup.GET;
                                                                TestNoSeries;
                                                                IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode,"Posting No. Series") THEN
                                                                  VALIDATE("Posting No. Series");
                                                                Rec := ServHeader;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Bogf�ringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 109 ;   ;Shipping No. Series ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Shipping No. Series" <> '' THEN BEGIN
                                                                  ServSetup.GET;
                                                                  ServSetup.TESTFIELD("Posted Service Shipment Nos.");
                                                                  NoSeriesMgt.TestSeries(ServSetup."Posted Service Shipment Nos.","Shipping No. Series");
                                                                END;
                                                                TESTFIELD("Shipping No.",'');
                                                              END;

                                                   CaptionML=[DAN=Leverancenummerserie;
                                                              ENU=Shipping No. Series] }
    { 114 ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                MessageIfServLinesExist(FIELDCAPTION("Tax Area Code"));
                                                              END;

                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 115 ;   ;Tax Liable          ;Boolean       ;OnValidate=BEGIN
                                                                MessageIfServLinesExist(FIELDCAPTION("Tax Liable"));
                                                              END;

                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 116 ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "VAT Bus. Posting Group" <> xRec."VAT Bus. Posting Group" THEN
                                                                  RecreateServLines(FIELDCAPTION("VAT Bus. Posting Group"));
                                                              END;

                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 117 ;   ;Reserve             ;Option        ;CaptionML=[DAN=Reserver;
                                                              ENU=Reserve];
                                                   OptionCaptionML=[DAN=Aldrig,Eventuelt,Altid;
                                                                    ENU=Never,Optional,Always];
                                                   OptionString=Never,Optional,Always }
    { 118 ;   ;Applies-to ID       ;Code50        ;OnValidate=VAR
                                                                CustLedgEntry@1002 : Record 21;
                                                                TempCustLedgEntry@1000 : TEMPORARY Record 21;
                                                                CustEntrySetApplID@1001 : Codeunit 101;
                                                              BEGIN
                                                                IF "Applies-to ID" <> '' THEN
                                                                  TESTFIELD("Bal. Account No.",'');
                                                                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN BEGIN
                                                                  CustLedgEntry.SETCURRENTKEY("Customer No.",Open);
                                                                  CustLedgEntry.SETRANGE("Customer No.","Bill-to Customer No.");
                                                                  CustLedgEntry.SETRANGE(Open,TRUE);
                                                                  CustLedgEntry.SETRANGE("Applies-to ID",xRec."Applies-to ID");
                                                                  IF CustLedgEntry.FINDFIRST THEN
                                                                    CustEntrySetApplID.SetApplId(CustLedgEntry,TempCustLedgEntry,'');
                                                                  CustLedgEntry.RESET;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Udlignings-id;
                                                              ENU=Applies-to ID] }
    { 119 ;   ;VAT Base Discount % ;Decimal       ;OnValidate=BEGIN
                                                                GLSetup.GET;
                                                                IF "VAT Base Discount %" > GLSetup."VAT Tolerance %" THEN
                                                                  ERROR(
                                                                    Text011,
                                                                    FIELDCAPTION("VAT Base Discount %"),
                                                                    GLSetup.FIELDCAPTION("VAT Tolerance %"),
                                                                    GLSetup.TABLECAPTION);

                                                                IF ("VAT Base Discount %" = xRec."VAT Base Discount %") AND
                                                                   (CurrFieldNo <> 0)
                                                                THEN
                                                                  EXIT;

                                                                ServLine.RESET;
                                                                ServLine.SETRANGE("Document Type","Document Type");
                                                                ServLine.SETRANGE("Document No.","No.");
                                                                ServLine.SETFILTER(Type,'<>%1',ServLine.Type::" ");
                                                                ServLine.SETFILTER(Quantity,'<>0');
                                                                ServLine.LOCKTABLE;
                                                                LOCKTABLE;
                                                                IF ServLine.FINDSET THEN BEGIN
                                                                  MODIFY;
                                                                  REPEAT
                                                                    IF (ServLine."Quantity Invoiced" <> ServLine.Quantity) OR
                                                                       ("Shipping Advice" <> "Shipping Advice"::Partial) OR
                                                                       (CurrFieldNo <> 0)
                                                                    THEN BEGIN
                                                                      ServLine.UpdateAmounts;
                                                                      ServLine.MODIFY;
                                                                    END;
                                                                  UNTIL ServLine.NEXT = 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Momsgrundlagsrabat %;
                                                              ENU=VAT Base Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 120 ;   ;Status              ;Option        ;OnValidate=VAR
                                                                JobQueueEntry@1000 : Record 472;
                                                                RepairStatus@1001 : Record 5927;
                                                              BEGIN
                                                                ServItemLine.RESET;
                                                                ServItemLine.SETRANGE("Document Type","Document Type");
                                                                ServItemLine.SETRANGE("Document No.","No.");
                                                                LinesExist := TRUE;
                                                                IF ServItemLine.FIND('-') THEN
                                                                  REPEAT
                                                                    IF ServItemLine."Repair Status Code" <> '' THEN BEGIN
                                                                      RepairStatus.GET(ServItemLine."Repair Status Code");
                                                                      IF ((Status = Status::Pending) AND NOT RepairStatus."Pending Status Allowed") OR
                                                                         ((Status = Status::"In Process") AND NOT RepairStatus."In Process Status Allowed") OR
                                                                         ((Status = Status::Finished) AND NOT RepairStatus."Finished Status Allowed") OR
                                                                         ((Status = Status::"On Hold") AND NOT RepairStatus."On Hold Status Allowed")
                                                                      THEN
                                                                        ERROR(
                                                                          Text031,
                                                                          FIELDCAPTION(Status),FORMAT(Status),TABLECAPTION,"No.",ServItemLine.FIELDCAPTION("Repair Status Code"),
                                                                          ServItemLine."Repair Status Code",ServItemLine.TABLECAPTION,ServItemLine."Line No.")
                                                                    END;
                                                                  UNTIL ServItemLine.NEXT = 0
                                                                ELSE
                                                                  LinesExist := FALSE;

                                                                CASE Status OF
                                                                  Status::"In Process":
                                                                    BEGIN
                                                                      IF NOT LinesExist THEN BEGIN
                                                                        "Starting Date" := WORKDATE;
                                                                        VALIDATE("Starting Time",TIME);
                                                                      END ELSE
                                                                        UpdateStartingDateTime;
                                                                    END;
                                                                  Status::Finished:
                                                                    BEGIN
                                                                      TestMandatoryFields(ServLine);
                                                                      IF Status <> xRec.Status THEN
                                                                        IF "Notify Customer" = "Notify Customer"::"By Email" THEN BEGIN
                                                                          TESTFIELD("Customer No.");
                                                                          CLEAR(NotifyCust);
                                                                          NotifyCust.RUN(Rec);
                                                                        END;
                                                                      IF NOT LinesExist THEN BEGIN
                                                                        IF ("Finishing Date" = 0D) AND ("Finishing Time" = 0T) THEN BEGIN
                                                                          "Finishing Date" := WORKDATE;
                                                                          "Finishing Time" := TIME;
                                                                        END;
                                                                      END ELSE
                                                                        UpdateFinishingDateTime;
                                                                    END;
                                                                END;

                                                                IF Status <> Status::Finished THEN BEGIN
                                                                  "Finishing Date" := 0D;
                                                                  "Finishing Time" := 0T;
                                                                  "Service Time (Hours)" := 0;
                                                                END;

                                                                IF ("Starting Date" <> 0D) AND
                                                                   ("Finishing Date" <> 0D) AND
                                                                   NOT LinesExist
                                                                THEN BEGIN
                                                                  CALCFIELDS("Contract Serv. Hours Exist");
                                                                  "Service Time (Hours)" :=
                                                                    ServOrderMgt.CalcServTime(
                                                                      "Starting Date","Starting Time","Finishing Date","Finishing Time",
                                                                      "Contract No.","Contract Serv. Hours Exist");
                                                                END;

                                                                IF Status = Status::Pending THEN
                                                                  IF ServSetup.GET THEN
                                                                    IF ServSetup."First Warning Within (Hours)" <> 0 THEN
                                                                      IF JobQueueEntry.WRITEPERMISSION THEN BEGIN
                                                                        JobQueueEntry.SETRANGE("Object Type to Run",JobQueueEntry."Object Type to Run"::Codeunit);
                                                                        JobQueueEntry.SETRANGE("Object ID to Run",CODEUNIT::"ServOrder-Check Response Time");
                                                                        JobQueueEntry.SETRANGE(Status,JobQueueEntry.Status::"On Hold");
                                                                        IF JobQueueEntry.FINDFIRST THEN
                                                                          JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
                                                                      END;
                                                              END;

                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Igangsat,I arbejde,Udf�rt,Afvent;
                                                                    ENU=Pending,In Process,Finished,On Hold];
                                                   OptionString=Pending,In Process,Finished,On Hold }
    { 121 ;   ;Invoice Discount Calculation;Option;CaptionML=[DAN=Beregning af fakturarabat;
                                                              ENU=Invoice Discount Calculation];
                                                   OptionCaptionML=[DAN=Ingen,%,Bel�b;
                                                                    ENU=None,%,Amount];
                                                   OptionString=None,%,Amount;
                                                   Editable=No }
    { 122 ;   ;Invoice Discount Value;Decimal     ;CaptionML=[DAN=Fakturarabatv�rdi;
                                                              ENU=Invoice Discount Value];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 130 ;   ;Release Status      ;Option        ;CaptionML=[DAN=Frigivelsesstatus;
                                                              ENU=Release Status];
                                                   OptionCaptionML=[DAN=�ben,Frigivet til afsendelse;
                                                                    ENU=Open,Released to Ship];
                                                   OptionString=Open,Released to Ship;
                                                   Editable=No }
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
    { 5052;   ;Contact No.         ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1000 : Record 5050;
                                                                ContBusinessRelation@1001 : Record 5054;
                                                              BEGIN
                                                                IF ("Contact No." <> xRec."Contact No.") AND
                                                                   (xRec."Contact No." <> '')
                                                                THEN BEGIN
                                                                  IF HideValidationDialog THEN
                                                                    Confirmed := TRUE
                                                                  ELSE
                                                                    Confirmed := CONFIRM(Text005,FALSE,FIELDCAPTION("Contact No."));
                                                                  IF Confirmed THEN BEGIN
                                                                    ServLine.RESET;
                                                                    ServLine.SETRANGE("Document Type","Document Type");
                                                                    ServLine.SETRANGE("Document No.","No.");
                                                                    IF ("Contact No." = '') AND ("Customer No." = '') THEN BEGIN
                                                                      IF NOT ServLine.ISEMPTY THEN
                                                                        ERROR(Text050,FIELDCAPTION("Contact No."));
                                                                      InitRecordFromContact;
                                                                      EXIT;
                                                                    END;
                                                                  END ELSE BEGIN
                                                                    Rec := xRec;
                                                                    EXIT;
                                                                  END;
                                                                END;

                                                                IF ("Customer No." <> '') AND ("Contact No." <> '') THEN BEGIN
                                                                  Cont.GET("Contact No.");
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Customer No.") AND
                                                                     (ContBusinessRelation."Contact No." <> Cont."Company No.")
                                                                  THEN
                                                                    ERROR(Text038,Cont."No.",Cont.Name,"Customer No.");
                                                                END;

                                                                UpdateCust("Contact No.");
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1000 : Record 5050;
                                                              ContBusinessRelation@1001 : Record 5054;
                                                            BEGIN
                                                              IF "Customer No." <> '' THEN
                                                                IF Cont.GET("Contact No.") THEN
                                                                  Cont.SETRANGE("Company No.",Cont."Company No.")
                                                                ELSE
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Customer No.") THEN
                                                                    Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.")
                                                                  ELSE
                                                                    Cont.SETRANGE("No.",'');

                                                              IF "Contact No." <> '' THEN
                                                                IF Cont.GET("Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                                                xRec := Rec;
                                                                VALIDATE("Contact No.",Cont."No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Kontaktnr.;
                                                              ENU=Contact No.] }
    { 5053;   ;Bill-to Contact No. ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1001 : Record 5050;
                                                                ContBusinessRelation@1000 : Record 5054;
                                                              BEGIN
                                                                IF ("Bill-to Contact No." <> xRec."Bill-to Contact No.") AND
                                                                   (xRec."Bill-to Contact No." <> '')
                                                                THEN BEGIN
                                                                  IF HideValidationDialog THEN
                                                                    Confirmed := TRUE
                                                                  ELSE
                                                                    Confirmed := CONFIRM(Text005,FALSE,FIELDCAPTION("Bill-to Contact No."));
                                                                  IF Confirmed THEN BEGIN
                                                                    ServLine.RESET;
                                                                    ServLine.SETRANGE("Document Type","Document Type");
                                                                    ServLine.SETRANGE("Document No.","No.");
                                                                    IF ("Bill-to Contact No." = '') AND ("Bill-to Customer No." = '') THEN BEGIN
                                                                      IF NOT ServLine.ISEMPTY THEN
                                                                        ERROR(Text050,FIELDCAPTION("Bill-to Contact No."));
                                                                      InitRecordFromContact;
                                                                      EXIT;
                                                                    END;
                                                                  END ELSE BEGIN
                                                                    "Bill-to Contact No." := xRec."Bill-to Contact No.";
                                                                    EXIT;
                                                                  END;
                                                                END;

                                                                IF ("Bill-to Customer No." <> '') AND ("Bill-to Contact No." <> '') THEN BEGIN
                                                                  Cont.GET("Bill-to Contact No.");
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Bill-to Customer No.") AND
                                                                     (ContBusinessRelation."Contact No." <> Cont."Company No.")
                                                                  THEN
                                                                    ERROR(Text038,Cont."No.",Cont.Name,"Bill-to Customer No.");
                                                                END;

                                                                UpdateBillToCust("Bill-to Contact No.");
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1001 : Record 5050;
                                                              ContBusinessRelation@1000 : Record 5054;
                                                            BEGIN
                                                              IF "Bill-to Customer No." <> '' THEN
                                                                IF Cont.GET("Bill-to Contact No.") THEN
                                                                  Cont.SETRANGE("Company No.",Cont."Company No.")
                                                                ELSE
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Bill-to Customer No.") THEN
                                                                    Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.")
                                                                  ELSE
                                                                    Cont.SETRANGE("No.",'');

                                                              IF "Bill-to Contact No." <> '' THEN
                                                                IF Cont.GET("Bill-to Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                                                xRec := Rec;
                                                                VALIDATE("Bill-to Contact No.",Cont."No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Faktureres attentionnr.;
                                                              ENU=Bill-to Contact No.] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   OnValidate=VAR
                                                                RespCenter@1000 : Record 5714;
                                                              BEGIN
                                                                IF NOT UserSetupMgt.CheckRespCenter(2,"Responsibility Center") THEN
                                                                  ERROR(
                                                                    Text010,
                                                                    RespCenter.TABLECAPTION,UserSetupMgt.GetServiceFilter);

                                                                UpdateShipToAddress;

                                                                CreateDim(
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::Customer,"Bill-to Customer No.",
                                                                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                                                                  DATABASE::"Service Order Type","Service Order Type",
                                                                  DATABASE::"Service Contract Header","Contract No.");

                                                                ServItemLine.RESET;
                                                                ServItemLine.SETRANGE("Document Type","Document Type");
                                                                ServItemLine.SETRANGE("Document No.","No.");
                                                                IF ServItemLine.FIND('-') THEN
                                                                  REPEAT
                                                                    ServItemLine.VALIDATE("Responsibility Center","Responsibility Center");
                                                                    ServItemLine.MODIFY(TRUE);
                                                                  UNTIL ServItemLine.NEXT = 0;

                                                                IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
                                                                  RecreateServLines(FIELDCAPTION("Responsibility Center"));
                                                                  VALIDATE("Location Code",UserSetupMgt.GetLocation(2,'',"Responsibility Center"));
                                                                  "Assigned User ID" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 5750;   ;Shipping Advice     ;Option        ;OnValidate=VAR
                                                                WhseValidateSourceHeader@1000 : Codeunit 5781;
                                                              BEGIN
                                                                TESTFIELD("Release Status","Release Status"::Open);
                                                                IF InventoryPickConflict("Document Type","No.","Shipping Advice") THEN
                                                                  ERROR(Text064,FIELDCAPTION("Shipping Advice"),FORMAT("Shipping Advice"),TABLECAPTION);
                                                                IF WhseShpmntConflict("Document Type","No.","Shipping Advice") THEN
                                                                  ERROR(STRSUBSTNO(Text065,FIELDCAPTION("Shipping Advice"),FORMAT("Shipping Advice"),TABLECAPTION));
                                                                WhseValidateSourceHeader.ServiceHeaderVerifyChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Afsendelsesadvis;
                                                              ENU=Shipping Advice];
                                                   OptionCaptionML=[DAN=Delvis,Komplet;
                                                                    ENU=Partial,Complete];
                                                   OptionString=Partial,Complete }
    { 5752;   ;Completely Shipped  ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Min("Service Line"."Completely Shipped" WHERE (Document Type=FIELD(Document Type),
                                                                                                              Document No.=FIELD(No.),
                                                                                                              Type=FILTER(<>' '),
                                                                                                              Location Code=FIELD(Location Filter)));
                                                   CaptionML=[DAN=Levering komplet;
                                                              ENU=Completely Shipped];
                                                   Editable=No }
    { 5754;   ;Location Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Location.Code;
                                                   CaptionML=[DAN=Lokationsfilter;
                                                              ENU=Location Filter] }
    { 5792;   ;Shipping Time       ;DateFormula   ;OnValidate=BEGIN
                                                                TESTFIELD("Release Status","Release Status"::Open);
                                                                IF "Shipping Time" <> xRec."Shipping Time" THEN
                                                                  UpdateServLines(FIELDCAPTION("Shipping Time"),CurrFieldNo <> 0);
                                                              END;

                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Transporttid;
                                                              ENU=Shipping Time] }
    { 5794;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Release Status","Release Status"::Open);
                                                                GetShippingTime(FIELDNO("Shipping Agent Service Code"));
                                                                UpdateServLines(FIELDCAPTION("Shipping Agent Service Code"),CurrFieldNo <> 0);
                                                              END;

                                                   CaptionML=[DAN=Spedit�rservicekode;
                                                              ENU=Shipping Agent Service Code] }
    { 5796;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 5902;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 5904;   ;Service Order Type  ;Code10        ;TableRelation="Service Order Type";
                                                   OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::"Service Order Type","Service Order Type",
                                                                  DATABASE::Customer,"Bill-to Customer No.",
                                                                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::"Service Contract Header","Contract No.");
                                                              END;

                                                   CaptionML=[DAN=Serviceordretype;
                                                              ENU=Service Order Type] }
    { 5905;   ;Link Service to Service Item;Boolean;
                                                   OnValidate=BEGIN
                                                                IF "Link Service to Service Item" <> xRec."Link Service to Service Item" THEN BEGIN
                                                                  ServLine.RESET;
                                                                  ServLine.SETRANGE("Document Type","Document Type");
                                                                  ServLine.SETRANGE("Document No.","No.");
                                                                  ServLine.SETFILTER(Type,'<>%1',ServLine.Type::Cost);
                                                                  IF ServLine.FIND('-') THEN
                                                                    MESSAGE(
                                                                      Text001,
                                                                      FIELDCAPTION("Link Service to Service Item"),
                                                                      "No.");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Sammenk�d service med artikel;
                                                              ENU=Link Service to Service Item] }
    { 5907;   ;Priority            ;Option        ;CaptionML=[DAN=Prioritet;
                                                              ENU=Priority];
                                                   OptionCaptionML=[DAN=Lav,Medium,H�j;
                                                                    ENU=Low,Medium,High];
                                                   OptionString=Low,Medium,High;
                                                   Editable=No }
    { 5911;   ;Allocated Hours     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Order Allocation"."Allocated Hours" WHERE (Document Type=FIELD(Document Type),
                                                                                                                       Document No.=FIELD(No.),
                                                                                                                       Allocation Date=FIELD(Date Filter),
                                                                                                                       Resource No.=FIELD(Resource Filter),
                                                                                                                       Status=FILTER(Active|Finished),
                                                                                                                       Resource Group No.=FIELD(Resource Group Filter)));
                                                   CaptionML=[DAN=Allokerede timer;
                                                              ENU=Allocated Hours];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5915;   ;Phone No.           ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.] }
    { 5916;   ;E-Mail              ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Mail;
                                                              ENU=Email] }
    { 5917;   ;Phone No. 2         ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon 2;
                                                              ENU=Phone No. 2] }
    { 5918;   ;Fax No.             ;Text30        ;CaptionML=[DAN=Telefax;
                                                              ENU=Fax No.] }
    { 5921;   ;No. of Unallocated Items;Integer   ;FieldClass=FlowField;
                                                   CalcFormula=Count("Service Item Line" WHERE (Document Type=FIELD(Document Type),
                                                                                                Document No.=FIELD(No.),
                                                                                                No. of Active/Finished Allocs=CONST(0)));
                                                   CaptionML=[DAN=Antal ikkeallokerede artikler;
                                                              ENU=No. of Unallocated Items];
                                                   Editable=No }
    { 5923;   ;Order Time          ;Time          ;OnValidate=BEGIN
                                                                IF "Order Time" <> xRec."Order Time" THEN BEGIN
                                                                  IF ("Order Time" > "Starting Time") AND
                                                                     ("Starting Time" <> 0T) AND
                                                                     ("Order Date" = "Starting Date")
                                                                  THEN
                                                                    ERROR(Text007,FIELDCAPTION("Order Time"),FIELDCAPTION("Starting Time"));
                                                                  IF "Starting Time" <> 0T THEN
                                                                    VALIDATE("Starting Time");
                                                                  ServItemLine.RESET;
                                                                  ServItemLine.SETRANGE("Document Type","Document Type");
                                                                  ServItemLine.SETRANGE("Document No.","No.");
                                                                  IF ServItemLine.FIND('-') THEN
                                                                    REPEAT
                                                                      ServItemLine.CalculateResponseDateTime("Order Date","Order Time");
                                                                      ServItemLine.MODIFY;
                                                                    UNTIL ServItemLine.NEXT = 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Ordretidspunkt;
                                                              ENU=Order Time];
                                                   NotBlank=Yes }
    { 5924;   ;Default Response Time (Hours);Decimal;
                                                   CaptionML=[DAN=Standardsvartid (timer);
                                                              ENU=Default Response Time (Hours)];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 5925;   ;Actual Response Time (Hours);Decimal;
                                                   CaptionML=[DAN=Reel svartid (timer);
                                                              ENU=Actual Response Time (Hours)];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 5926;   ;Service Time (Hours);Decimal       ;CaptionML=[DAN=Servicetid (timer);
                                                              ENU=Service Time (Hours)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5927;   ;Response Date       ;Date          ;CaptionML=[DAN=Svardato;
                                                              ENU=Response Date];
                                                   Editable=No }
    { 5928;   ;Response Time       ;Time          ;CaptionML=[DAN=Svartidspunkt;
                                                              ENU=Response Time];
                                                   Editable=No }
    { 5929;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                IF "Starting Date" <> 0D THEN BEGIN
                                                                  IF "Starting Date" < "Order Date" THEN
                                                                    ERROR(Text026,FIELDCAPTION("Starting Date"),FIELDCAPTION("Order Date"));

                                                                  IF ("Starting Date" > "Finishing Date") AND
                                                                     ("Finishing Date" <> 0D)
                                                                  THEN
                                                                    ERROR(Text007,FIELDCAPTION("Starting Date"),FIELDCAPTION("Finishing Time"));

                                                                  ServItemLine.RESET;
                                                                  ServItemLine.SETCURRENTKEY("Document Type","Document No.","Starting Date");
                                                                  ServItemLine.SETRANGE("Document Type","Document Type");
                                                                  ServItemLine.SETRANGE("Document No.","No.");
                                                                  ServItemLine.SETFILTER("Starting Date",'<>%1',0D);
                                                                  IF ServItemLine.FIND('-') THEN
                                                                    REPEAT
                                                                      IF ServItemLine."Starting Date" < "Starting Date" THEN
                                                                        ERROR(Text024,FIELDCAPTION("Starting Date"));
                                                                    UNTIL ServItemLine.NEXT = 0;

                                                                  IF TIME < "Order Time" THEN
                                                                    VALIDATE("Starting Time","Order Time")
                                                                  ELSE
                                                                    VALIDATE("Starting Time",TIME);
                                                                END ELSE BEGIN
                                                                  "Starting Time" := 0T;
                                                                  "Actual Response Time (Hours)" := 0;
                                                                  "Finishing Date" := 0D;
                                                                  "Finishing Time" := 0T;
                                                                  "Service Time (Hours)" := 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 5930;   ;Starting Time       ;Time          ;OnValidate=BEGIN
                                                                TESTFIELD("Starting Date");

                                                                IF ("Starting Date" = "Finishing Date") AND
                                                                   ("Starting Time" > "Finishing Time")
                                                                THEN
                                                                  ERROR(Text007,FIELDCAPTION("Starting Time"),FIELDCAPTION("Finishing Time"));

                                                                IF ("Starting Date" = "Order Date") AND
                                                                   ("Starting Time" < "Order Time")
                                                                THEN
                                                                  ERROR(Text026,FIELDCAPTION("Starting Time"),FIELDCAPTION("Order Time"));

                                                                IF ("Starting Time" = 0T) AND (xRec."Starting Time" <> 0T) THEN BEGIN
                                                                  "Finishing Time" := 0T;
                                                                  "Finishing Date" := 0D;
                                                                  "Service Time (Hours)" := 0;
                                                                END;

                                                                IF ("Starting Time" <> 0T) AND
                                                                   ("Starting Date" <> 0D)
                                                                THEN BEGIN
                                                                  CALCFIELDS("Contract Serv. Hours Exist");
                                                                  "Actual Response Time (Hours)" :=
                                                                    ServOrderMgt.CalcServTime(
                                                                      "Order Date","Order Time","Starting Date","Starting Time",
                                                                      "Contract No.","Contract Serv. Hours Exist");
                                                                END ELSE
                                                                  "Actual Response Time (Hours)" := 0;
                                                                IF "Finishing Time" <> 0T THEN
                                                                  VALIDATE("Finishing Time");
                                                              END;

                                                   CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Starting Time] }
    { 5931;   ;Finishing Date      ;Date          ;OnValidate=BEGIN
                                                                IF "Finishing Date" <> 0D THEN BEGIN
                                                                  IF "Finishing Date" < "Starting Date" THEN
                                                                    ERROR(Text026,FIELDCAPTION("Finishing Date"),FIELDCAPTION("Starting Date"));

                                                                  IF "Finishing Date" < "Order Date" THEN
                                                                    ERROR(
                                                                      Text026,
                                                                      FIELDCAPTION("Finishing Date"),
                                                                      FIELDCAPTION("Order Date"));

                                                                  IF "Starting Date" = 0D THEN BEGIN
                                                                    "Starting Date" := "Finishing Date";
                                                                    "Starting Time" := TIME;
                                                                    CALCFIELDS("Contract Serv. Hours Exist");
                                                                    "Actual Response Time (Hours)" :=
                                                                      ServOrderMgt.CalcServTime(
                                                                        "Order Date","Order Time","Starting Date","Starting Time",
                                                                        "Contract No.","Contract Serv. Hours Exist");
                                                                  END;

                                                                  IF "Finishing Date" <> xRec."Finishing Date" THEN BEGIN
                                                                    IF TIME < "Starting Time" THEN
                                                                      "Finishing Time" := "Starting Time"
                                                                    ELSE
                                                                      "Finishing Time" := TIME;
                                                                    VALIDATE("Finishing Time");
                                                                  END;

                                                                  ServItemLine.RESET;
                                                                  ServItemLine.SETCURRENTKEY("Document Type","Document No.","Finishing Date");
                                                                  ServItemLine.SETRANGE("Document Type","Document Type");
                                                                  ServItemLine.SETRANGE("Document No.","No.");
                                                                  ServItemLine.SETFILTER("Finishing Date",'<>%1',0D);
                                                                  IF ServItemLine.FIND('-') THEN
                                                                    REPEAT
                                                                      IF ServItemLine."Finishing Date" > "Finishing Date" THEN
                                                                        ERROR(Text025,FIELDCAPTION("Finishing Date"));
                                                                    UNTIL ServItemLine.NEXT = 0;
                                                                END ELSE BEGIN
                                                                  "Finishing Time" := 0T;
                                                                  "Service Time (Hours)" := 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=F�rdigg�relsesdato;
                                                              ENU=Finishing Date] }
    { 5932;   ;Finishing Time      ;Time          ;OnValidate=BEGIN
                                                                TESTFIELD("Finishing Date");
                                                                IF "Finishing Time" <> 0T THEN BEGIN
                                                                  IF ("Starting Date" = "Finishing Date") AND
                                                                     ("Finishing Time" < "Starting Time")
                                                                  THEN
                                                                    ERROR(
                                                                      Text026,FIELDCAPTION("Finishing Time"),
                                                                      FIELDCAPTION("Starting Time"));

                                                                  IF ("Finishing Date" = "Order Date") AND
                                                                     ("Finishing Time" < "Order Time")
                                                                  THEN
                                                                    ERROR(
                                                                      Text026,FIELDCAPTION("Finishing Time"),
                                                                      FIELDCAPTION("Order Time"));

                                                                  ServItemLine.RESET;
                                                                  ServItemLine.SETCURRENTKEY("Document Type","Document No.","Finishing Date");
                                                                  ServItemLine.SETRANGE("Document Type","Document Type");
                                                                  ServItemLine.SETRANGE("Document No.","No.");
                                                                  ServItemLine.SETFILTER("Finishing Date",'<>%1',0D);
                                                                  IF ServItemLine.FIND('-') THEN
                                                                    REPEAT
                                                                      IF (ServItemLine."Finishing Date" = "Finishing Date") AND
                                                                         (ServItemLine."Finishing Time" > "Finishing Time")
                                                                      THEN
                                                                        ERROR(Text025,FIELDCAPTION("Finishing Time"));
                                                                    UNTIL ServItemLine.NEXT = 0;

                                                                  CALCFIELDS("Contract Serv. Hours Exist");
                                                                  "Service Time (Hours)" :=
                                                                    ServOrderMgt.CalcServTime(
                                                                      "Starting Date","Starting Time","Finishing Date","Finishing Time",
                                                                      "Contract No.","Contract Serv. Hours Exist");
                                                                END ELSE
                                                                  "Service Time (Hours)" := 0;
                                                              END;

                                                   CaptionML=[DAN=F�rdigg�relsestidspunkt;
                                                              ENU=Finishing Time] }
    { 5933;   ;Contract Serv. Hours Exist;Boolean ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Service Hour" WHERE (Service Contract No.=FIELD(Contract No.)));
                                                   CaptionML=[DAN=Kontraktserv.�bn.tider findes;
                                                              ENU=Contract Serv. Hours Exist];
                                                   Editable=No }
    { 5934;   ;Reallocation Needed ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Service Order Allocation" WHERE (Status=CONST(Reallocation Needed),
                                                                                                       Resource No.=FIELD(Resource Filter),
                                                                                                       Document Type=FIELD(Document Type),
                                                                                                       Document No.=FIELD(No.),
                                                                                                       Resource Group No.=FIELD(Resource Group Filter)));
                                                   CaptionML=[DAN=Genallokering n�dvendig;
                                                              ENU=Reallocation Needed];
                                                   Editable=No }
    { 5936;   ;Notify Customer     ;Option        ;CaptionML=[DAN=Underret kunde;
                                                              ENU=Notify Customer];
                                                   OptionCaptionML=[DAN=Nej,Via telefon 1,Via telefon 2,Via telefax,Via mail;
                                                                    ENU=No,By Phone 1,By Phone 2,By Fax,By Email];
                                                   OptionString=No,By Phone 1,By Phone 2,By Fax,By Email }
    { 5937;   ;Max. Labor Unit Price;Decimal      ;OnValidate=BEGIN
                                                                IF ServLineExists THEN
                                                                  MESSAGE(
                                                                    Text001,
                                                                    FIELDCAPTION("Max. Labor Unit Price"),
                                                                    "No.");
                                                              END;

                                                   CaptionML=[DAN=Maks. arbejdsenhedspris;
                                                              ENU=Max. Labor Unit Price];
                                                   BlankZero=Yes;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 5938;   ;Warning Status      ;Option        ;CaptionML=[DAN=Advarselsstatus;
                                                              ENU=Warning Status];
                                                   OptionCaptionML=[DAN=" ,F�rste advarsel,Anden advarsel,Tredje advarsel";
                                                                    ENU=" ,First Warning,Second Warning,Third Warning"];
                                                   OptionString=[ ,First Warning,Second Warning,Third Warning] }
    { 5939;   ;No. of Allocations  ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Service Order Allocation" WHERE (Document Type=FIELD(Document Type),
                                                                                                       Document No.=FIELD(No.),
                                                                                                       Resource No.=FIELD(Resource Filter),
                                                                                                       Resource Group No.=FIELD(Resource Group Filter),
                                                                                                       Allocation Date=FIELD(Date Filter),
                                                                                                       Status=FILTER(Active|Finished)));
                                                   CaptionML=[DAN=Antal allokeringer;
                                                              ENU=No. of Allocations];
                                                   Editable=No }
    { 5940;   ;Contract No.        ;Code20        ;TableRelation="Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract),
                                                                                                                 Customer No.=FIELD(Customer No.),
                                                                                                                 Ship-to Code=FIELD(Ship-to Code),
                                                                                                                 Bill-to Customer No.=FIELD(Bill-to Customer No.));
                                                   OnValidate=VAR
                                                                ServContractHeader@1001 : Record 5965;
                                                                ServContractLine@1000 : Record 5964;
                                                              BEGIN
                                                                IF "Contract No." <> xRec."Contract No." THEN BEGIN
                                                                  IF "Contract No." <> '' THEN BEGIN
                                                                    TESTFIELD("Order Date");
                                                                    ServContractHeader.GET(ServContractHeader."Contract Type"::Contract,"Contract No.");
                                                                    IF ServContractHeader.Status <> ServContractHeader.Status::Signed THEN
                                                                      ERROR(Text041,"Contract No.");
                                                                    IF ServContractHeader."Starting Date" > "Order Date" THEN
                                                                      ERROR(Text042,"Contract No.");
                                                                    IF (ServContractHeader."Expiration Date" <> 0D) AND
                                                                       (ServContractHeader."Expiration Date" < "Order Date")
                                                                    THEN
                                                                      ERROR(Text043,"Contract No.");
                                                                  END;
                                                                  ServItemLine.RESET;
                                                                  ServItemLine.SETRANGE("Document Type","Document Type");
                                                                  ServItemLine.SETRANGE("Document No.","No.");
                                                                  IF ServItemLine.FIND('-') THEN
                                                                    ERROR(Text028,
                                                                      FIELDCAPTION("Contract No."),ServItemLine.TABLECAPTION);
                                                                  IF NOT
                                                                     CONFIRM(
                                                                       Text029,
                                                                       FALSE,ServContractLine.FIELDCAPTION("Next Planned Service Date"),
                                                                       ServContractLine.TABLECAPTION,
                                                                       FIELDCAPTION("Contract No."))
                                                                  THEN BEGIN
                                                                    "Contract No." := xRec."Contract No.";
                                                                    EXIT;
                                                                  END;

                                                                  IF "Contract No." <> '' THEN BEGIN
                                                                    TESTFIELD("Customer No.");
                                                                    TESTFIELD("Bill-to Customer No.");
                                                                    "Default Response Time (Hours)" := ServContractHeader."Response Time (Hours)";
                                                                    TESTFIELD("Ship-to Code",ServContractHeader."Ship-to Code");
                                                                    "Service Order Type" := ServContractHeader."Service Order Type";
                                                                    VALIDATE("Currency Code",ServContractHeader."Currency Code");
                                                                    "Max. Labor Unit Price" := ServContractHeader."Max. Labor Unit Price";
                                                                    "Your Reference" := ServContractHeader."Your Reference";
                                                                    "Service Zone Code" := ServContractHeader."Service Zone Code";
                                                                  END;
                                                                END;

                                                                IF "Contract No." <> '' THEN
                                                                  CreateDim(
                                                                    DATABASE::"Service Contract Header","Contract No.",
                                                                    DATABASE::"Service Order Type","Service Order Type",
                                                                    DATABASE::Customer,"Bill-to Customer No.",
                                                                    DATABASE::"Salesperson/Purchaser","Salesperson Code",
                                                                    DATABASE::"Responsibility Center","Responsibility Center");
                                                              END;

                                                   OnLookup=VAR
                                                              ServContractHeader@1000 : Record 5965;
                                                              ServContractList@1001 : Page 6051;
                                                            BEGIN
                                                              IF "Contract No." <> '' THEN
                                                                IF ServContractHeader.GET(ServContractHeader."Contract Type"::Contract,"Contract No.") THEN
                                                                  ServContractList.SETRECORD(ServContractHeader);

                                                              ServContractHeader.RESET;
                                                              ServContractHeader.FILTERGROUP(2);
                                                              ServContractHeader.SETCURRENTKEY("Customer No.","Ship-to Code");
                                                              ServContractHeader.SETRANGE("Customer No.","Customer No.");
                                                              ServContractHeader.SETRANGE("Ship-to Code","Ship-to Code");
                                                              ServContractHeader.SETRANGE("Contract Type",ServContractHeader."Contract Type"::Contract);
                                                              ServContractHeader.SETRANGE("Bill-to Customer No.","Bill-to Customer No.");
                                                              ServContractHeader.SETRANGE(Status,ServContractHeader.Status::Signed);
                                                              ServContractHeader.SETFILTER("Starting Date",'<=%1',"Order Date");
                                                              ServContractHeader.SETFILTER("Expiration Date",'>=%1 | =%2',"Order Date",0D);
                                                              ServContractHeader.FILTERGROUP(0);
                                                              CLEAR(ServContractList);
                                                              ServContractList.SETTABLEVIEW(ServContractHeader);
                                                              ServContractList.LOOKUPMODE(TRUE);
                                                              IF ServContractList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                                                ServContractList.GETRECORD(ServContractHeader);
                                                                VALIDATE("Contract No.",ServContractHeader."Contract No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Kontraktnr.;
                                                              ENU=Contract No.] }
    { 5951;   ;Type Filter         ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Typefilter;
                                                              ENU=Type Filter];
                                                   OptionCaptionML=[DAN=" ,Ressource,Vare,Serviceomkostninger,Servicekontrakt";
                                                                    ENU=" ,Resource,Item,Service Cost,Service Contract"];
                                                   OptionString=[ ,Resource,Item,Service Cost,Service Contract] }
    { 5952;   ;Customer Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Customer.No.;
                                                   CaptionML=[DAN=Debitorfilter;
                                                              ENU=Customer Filter] }
    { 5953;   ;Resource Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Resource;
                                                   CaptionML=[DAN=Ressourcefilter;
                                                              ENU=Resource Filter] }
    { 5954;   ;Contract Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract));
                                                   CaptionML=[DAN=Kontraktfilter;
                                                              ENU=Contract Filter] }
    { 5955;   ;Ship-to Fax No.     ;Text30        ;CaptionML=[DAN=Leveringstelefax;
                                                              ENU=Ship-to Fax No.] }
    { 5956;   ;Ship-to E-Mail      ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("Ship-to E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Leveringsmail;
                                                              ENU=Ship-to Email] }
    { 5957;   ;Resource Group Filter;Code20       ;FieldClass=FlowFilter;
                                                   TableRelation="Resource Group";
                                                   CaptionML=[DAN=Ressourcegruppefilter;
                                                              ENU=Resource Group Filter] }
    { 5958;   ;Ship-to Phone       ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Levering/telefon;
                                                              ENU=Ship-to Phone] }
    { 5959;   ;Ship-to Phone 2     ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Levering/telefon 2;
                                                              ENU=Ship-to Phone 2] }
    { 5966;   ;Service Zone Filter ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Service Zone".Code;
                                                   CaptionML=[DAN=Servicezonefilter;
                                                              ENU=Service Zone Filter] }
    { 5968;   ;Service Zone Code   ;Code10        ;TableRelation="Service Zone".Code;
                                                   OnValidate=VAR
                                                                ShipToAddr@1000 : Record 222;
                                                              BEGIN
                                                                IF ShipToAddr.GET("Customer No.","Ship-to Code") THEN
                                                                  "Service Zone Code" := ShipToAddr."Service Zone Code"
                                                                ELSE
                                                                  IF Cust.GET("Customer No.") THEN
                                                                    "Service Zone Code" := Cust."Service Zone Code"
                                                                  ELSE
                                                                    "Service Zone Code" := '';
                                                              END;

                                                   CaptionML=[DAN=Servicezonekode;
                                                              ENU=Service Zone Code];
                                                   Editable=No }
    { 5981;   ;Expected Finishing Date;Date       ;CaptionML=[DAN=Forventet f�rdigg�relsesdato;
                                                              ENU=Expected Finishing Date] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;OnValidate=BEGIN
                                                                MessageIfServLinesExist(FIELDCAPTION("Allow Line Disc."));
                                                              END;

                                                   CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
    { 9000;   ;Assigned User ID    ;Code50        ;TableRelation="User Setup";
                                                   OnValidate=BEGIN
                                                                IF NOT UserSetupMgt.CheckRespCenter2(2,"Responsibility Center","Assigned User ID") THEN
                                                                  ERROR(Text060,"Assigned User ID",UserSetupMgt.GetServiceFilter2("Assigned User ID"));
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
    { 9001;   ;Quote No.           ;Code20        ;CaptionML=[DAN=Tilbudsnr.;
                                                              ENU=Quote No.] }
    { 13600;  ;EAN No.             ;Code13        ;OnValidate=BEGIN
                                                                IF "EAN No." = '' THEN
                                                                  EXIT;

                                                                IF NOT OIOUBLDocumentEncode.IsValidEANNo("EAN No.") THEN
                                                                  FIELDERROR("EAN No.",Text13606);
                                                              END;

                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=EAN-nr.;
                                                              ENU=EAN No.] }
    { 13601;  ;Account Code        ;Text30        ;OnValidate=BEGIN
                                                                ServLine.RESET;
                                                                ServLine.SETRANGE("Document Type","Document Type");
                                                                ServLine.SETRANGE("Document No.","No.");
                                                                ServLine.SETFILTER("Account Code",'%1|%2',xRec."Account Code",'');
                                                                ServLine.MODIFYALL("Account Code","Account Code");
                                                              END;

                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontokode;
                                                              ENU=Account Code] }
    { 13604;  ;OIOUBL Profile Code ;Code10        ;TableRelation="OIOUBL Profile";
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=OIOUBL-profilkode;
                                                              ENU=OIOUBL Profile Code] }
    { 13608;  ;Contact Role        ;Option        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontaktens rolle;
                                                              ENU=Contact Role];
                                                   OptionCaptionML=[DAN=" ,,,Indk�bsansvarlig,,,Bogholder,,,Budgetansvarlig,,,Indk�ber";
                                                                    ENU=" ,,,Purchase Responsible,,,Accountant,,,Budget Responsible,,,Requisitioner"];
                                                   OptionString=[ ,,,Purchase Responsible,,,Accountant,,,Budget Responsible,,,Requisitioner] }
    { 13620;  ;Payment Channel     ;Option        ;OnValidate=BEGIN
                                                                IF "Payment Channel" = "Payment Channel"::"Payment Slip" THEN
                                                                  ERROR(Text13607,FIELDCAPTION("Payment Channel"),"Payment Channel");
                                                              END;

                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Betalingskanal;
                                                              ENU=Payment Channel];
                                                   OptionCaptionML=[DAN=" ,Betalingsbon,Kontooverf�rsel,National transaktion,Direct Debit";
                                                                    ENU=" ,Payment Slip,Account Transfer,National Clearing,Direct Debit"];
                                                   OptionString=[ ,Payment Slip,Account Transfer,National Clearing,Direct Debit] }
  }
  KEYS
  {
    {    ;Document Type,No.                       ;Clustered=Yes }
    {    ;No.,Document Type                        }
    {    ;Customer No.,Order Date                  }
    {    ;Contract No.,Status,Posting Date         }
    {    ;Status,Response Date,Response Time,Priority }
    {    ;Status,Priority,Response Date,Response Time }
    {    ;Document Type,Customer No.,Order Date   ;MaintainSQLIndex=No }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Document Type,No.,Customer No.,Posting Date,Status }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst '@@@="%1=User management service filter;";DAN=Du kan ikke slette dette bilag. Dit id tillader kun behandling fra Ansvarscenter %1.;ENU=You cannot delete this document. Your identification is set up to process from Responsibility Center %1 only.';
      Text001@1001 : TextConst 'DAN=Hvis du �ndrer %1 i servicehovedet %2, opdateres de eksisterende servicelinjer ikke.\Du skal opdatere de eksisterende servicelinjer manuelt.;ENU=Changing %1 in service header %2 will not update the existing service lines.\You must update the existing service lines manually.';
      Text003@1003 : TextConst '@@@="%1=Customer number field caption;%2=Document type;%3=Number field caption;%4=Number;%5=Contract number field caption;%6=Contract number; ";DAN=Du kan ikke �ndre %1, fordi %2 %3 %4 er tilknyttet en %5 %6.;ENU=You cannot change the %1 because the %2 %3 %4 is associated with a %5 %6.';
      Text004@1004 : TextConst 'DAN=Hvis du �ndrer %1, slettes den eksisterende serviceartikellinje og den eksisterende servicelinje.\Vil du �ndre %1?;ENU=When you change the %1 the existing Service item line and service line will be deleted.\Do you want to change the %1?';
      Text005@1005 : TextConst 'DAN=Vil du �ndre %1?;ENU=Do you want to change the %1?';
      Text007@1007 : TextConst 'DAN=%1 kan ikke v�re st�rre end %2.;ENU=%1 cannot be greater than %2.';
      Text008@1008 : TextConst '@@@="%1=Document type format;%2=Number field caption;%3=Number;";DAN="Du kan ikke oprette service %1 med %2=%3, fordi dette nummer allerede anvendes i systemet.";ENU="You cannot create Service %1 with %2=%3 because this number has already been used in the system."';
      Text010@1010 : TextConst '@@@="%1=Resposibility center table caption;%2=User management service filter;";DAN=Dit id tillader kun behandling fra %1 %2.;ENU=Your identification is set up to process from %1 %2 only.';
      Text011@1011 : TextConst 'DAN=%1 kan ikke v�re st�rre end %2 i tabellen %3.;ENU=%1 cannot be greater than %2 in the %3 table.';
      Text012@1012 : TextConst 'DAN=Hvis du �ndrer %1, vil de eksisterende servicelinjer blive slettet, og der vil blive oprettet nye servicelinjer p� baggrund af de nye oplysninger i hovedet.\Vil du �ndre %1?;ENU=If you change %1, the existing service lines will be deleted and the program will create new service lines based on the new information on the header.\Do you want to change the %1?';
      Text013@1089 : TextConst 'DAN=Hvis du sletter dette dokument, opst�r der et hul i nummerserien for bogf�rte kreditnotaer. Der oprettes en tom bogf�rt kreditnota %1 for at udfylde hullet i nummerserien.\\Vil du forts�tte?;ENU=Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
      Text015@1015 : TextConst 'DAN=Vil du opdatere valutakursen?;ENU=Do you want to update the exchange rate?';
      Text016@1016 : TextConst 'DAN=Du har �ndret %1.\Vil du opdatere servicelinjerne?;ENU=You have modified %1.\Do you want to update the service lines?';
      Text018@1018 : TextConst '@@@="%1=Service order type field caption;%2=table caption;%3=Document type field caption;%4=Document type format;%5=Number field caption;%6=Number format;";DAN="Du har ikke angivet %1 for %2 %3=%4, %5=%6.";ENU="You have not specified the %1 for %2 %3=%4, %5=%6."';
      Text019@1019 : TextConst 'DAN=Du har �ndret %1 p� servicehovedet, men v�rdien er ikke blevet �ndret p� de eksisterende servicelinjer.\�ndringen kan p�virke den anvendte valutakurs i prisberegningen p� servicelinjerne.;ENU=You have changed %1 on the service header, but it has not been changed on the existing service lines.\The change may affect the exchange rate used in the price calculation of the service lines.';
      Text021@1021 : TextConst 'DAN=Du har �ndret %1 p� %2, men v�rdien er ikke blevet �ndret p� de eksisterende servicelinjer.\Du skal opdatere de eksisterende servicelinjer manuelt.;ENU=You have changed %1 on the %2, but it has not been changed on the existing service lines.\You must update the existing service lines manually.';
      ServSetup@1023 : Record 5911;
      Cust@1024 : Record 18;
      ServHeader@1025 : Record 5900;
      ServLine@1026 : Record 5902;
      ServItemLine@1027 : Record 5901;
      PostCode@1031 : Record 225;
      CurrExchRate@1033 : Record 330;
      GLSetup@1034 : Record 98;
      ServShptHeader@1085 : Record 5990;
      ServInvHeader@1084 : Record 5992;
      ServCrMemoHeader@1077 : Record 5994;
      ReservEntry@1076 : Record 337;
      TempReservEntry@1075 : TEMPORARY Record 337;
      Salesperson@1906 : Record 13;
      ServOrderMgt@1037 : Codeunit 5900;
      DimMgt@1038 : Codeunit 408;
      NoSeriesMgt@1039 : Codeunit 396;
      ServLogMgt@1040 : Codeunit 5906;
      UserSetupMgt@1043 : Codeunit 5700;
      NotifyCust@1044 : Codeunit 5915;
      ServPost@1101 : Codeunit 5980;
      OIOUBLDocumentEncode@1000000000 : Codeunit 13600;
      CurrencyDate@1046 : Date;
      TempLinkToServItem@1047 : Boolean;
      HideValidationDialog@1048 : Boolean;
      Text024@1002 : TextConst 'DAN=%1 kan ikke v�re st�rre end den mindste %1 p�\serviceartikellinjerne.;ENU=The %1 cannot be greater than the minimum %1 of the\ Service Item Lines.';
      Text025@1050 : TextConst 'DAN=%1 kan ikke v�re mindre end den st�rste %1 p� de relaterede\ serviceartikellinjer.;ENU=The %1 cannot be less than the maximum %1 of the related\ Service Item Lines.';
      Text026@1051 : TextConst 'DAN=%1 m� ikke v�re tidligere end %2.;ENU=%1 cannot be earlier than the %2.';
      Text027@1052 : TextConst 'DAN=%1 m� ikke v�re st�rre end den mindste %2 p� de relaterede\ serviceartikellinjer.;ENU=The %1 cannot be greater than the minimum %2 of the related\ Service Item Lines.';
      ValidatingFromLines@1053 : Boolean;
      LinesExist@1054 : Boolean;
      Text028@1057 : TextConst 'DAN=%1 kan ikke �ndres, fordi %2 findes.;ENU=You cannot change the %1 because %2 exists.';
      Text029@1056 : TextConst 'DAN=Feltet %1 p� %2 opdateres, hvis du �ndrer %3 manuelt.\Vil du forts�tte?;ENU=The %1 field on the %2 will be updated if you change %3 manually.\Do you want to continue?';
      Text031@1059 : TextConst '@@@="%1=Status field caption;%2=Status format;%3=table caption;%4=Number;%5=ServItemLine repair status code field caption;%6=ServItemLine repair status code;%7=ServItemLine table caption;%8=ServItemLine line number;";DAN=Du kan ikke �ndre %1 til %2 i %3 %4.\\%5 %6 i linjen %7 %8 forhindrer dette.;ENU=You cannot change %1 to %2 in %3 %4.\\%5 %6 in %7 %8 line is preventing it.';
      Text037@1060 : TextConst '@@@="%1=Contact number;%2=Contact name;%3=Customer number;";DAN=Kontakten %1 %2 er ikke knyttet til debitoren %3.;ENU=Contact %1 %2 is not related to customer %3.';
      Text038@1013 : TextConst '@@@="%1=Contact number;%2=Contact name;%3=Customer number;";DAN=Kontakten %1 %2 er knyttet til en anden virksomhed end debitoren %3.;ENU=Contact %1 %2 is related to a different company than customer %3.';
      Text039@1061 : TextConst '@@@="%1=Contact number;%2=Contact name;";DAN=Kontakten %1 %2 er ikke knyttet til en debitor.;ENU=Contact %1 %2 is not related to a customer.';
      ContactNo@1045 : Code[20];
      Text040@1063 : TextConst '@@@="%1=table caption;%2=ServItemLine document number;%3=ServItemLine line number;%4=ServItemLine loaner number field caption;%5=ServItemLine loaner number;";DAN=Du kan ikke slette %1 %2, fordi %4 %5 for serviceartikellinjen %3 ikke er modtaget.;ENU=You cannot delete %1 %2 because the %4 %5 for Service Item Line %3 has not been received.';
      SkipContact@1064 : Boolean;
      SkipBillToContact@1062 : Boolean;
      Text041@1068 : TextConst 'DAN=Kontrakten %1 er ikke underskrevet.;ENU=Contract %1 is not signed.';
      Text042@1069 : TextConst 'DAN=Serviceperioden for kontrakten %1 er ikke begyndt endnu.;ENU=The service period for contract %1 has not yet started.';
      Text043@1070 : TextConst 'DAN=Serviceperioden for kontrakten %1 er udl�bet.;ENU=The service period for contract %1 has expired.';
      Text044@1073 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Confirmed@1080 : Boolean;
      Text045@1083 : TextConst '@@@="%1=Posting date field caption;%2=Posting number series field caption;%3=Posting number series;%4=NoSeries date order field caption;%5=NoSeries date order;%6=Document type;%7=posting number field caption;%8=Posting number;";DAN="Du kan ikke �ndre feltet %1, fordi %2 %3 har %4 = %5 og %6 allerede er blevet tildelt %7 %8.";ENU="You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8."';
      Text046@1104 : TextConst 'DAN=Du kan ikke slette fakturaen %1, fordi der findes en eller flere serviceposter til denne faktura.;ENU=You cannot delete invoice %1 because one or more service ledger entries exist for this invoice.';
      Text047@1100 : TextConst 'DAN=Du kan ikke �ndre %1, fordi der er reservation, varesporing eller ordresporing p� salgsordren.;ENU=You cannot change %1 because reservation, item tracking, or order tracking exists on the sales order.';
      Text050@1094 : TextConst 'DAN=Du kan ikke nulstille %1, fordi dokumentet stadig indeholder en eller flere linjer.;ENU=You cannot reset %1 because the document still has one or more lines.';
      Text051@1082 : TextConst '@@@="%1=Document type format;%2=Number;";DAN=Servicen %1 %2 findes allerede.;ENU=The service %1 %2 already exists.';
      Text053@1093 : TextConst 'DAN=Hvis du sletter dette dokument, opst�r der et hul i nummerserien for leverancer. Der oprettes en tom leverance %1 for at udfylde hullet i nummerserien.\\Vil du forts�tte?;ENU=Deleting this document will cause a gap in the number series for shipments. An empty shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?';
      Text054@1091 : TextConst 'DAN=Hvis du sletter dette dokument, opst�r der et hul i nummerserien for bogf�rte fakturaer. Der oprettes en tom bogf�rt faktura %1 for at udfylde hullet i nummerserien.\\Vil du forts�tte?;ENU=Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
      Text055@1079 : TextConst 'DAN=Du har redigeret feltet %1. Bem�rk, at genberegningen af moms kan resultere i �redifferencer, s� du skal kontrollere bel�bene efter genberegningen. Vil du opdatere feltet %2 p� linjerne, s� den nye v�rdi for %1 afspejles?;ENU=You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. Do you want to update the %2 field on the lines to reflect the new value of %1?';
      Text057@1103 : TextConst 'DAN=N�r du �ndrer %1, slettes den eksisterende servicelinje.\Vil du �ndre %1?;ENU=When you change the %1 the existing service line will be deleted.\Do you want to change the %1?';
      Text058@1088 : TextConst '@@@="%1=Currency code field caption;%2=Document type;%3=Number;%4=Contract number;";DAN=Du kan ikke �ndre %1, fordi %2 %3 er tilknyttet kontrakt %4.;ENU=You cannot change %1 because %2 %3 is linked to Contract %4.';
      Text060@1154 : TextConst '@@@="%1=Assigned user ID;%2=User management service filter assigned user id;";DAN=Ansvarscenteret tillader kun behandling fra %1 %2.;ENU=Responsibility Center is set up to process from %1 %2 only.';
      Text061@1099 : TextConst 'DAN=Du har muligvis �ndret en dimension.\\Vil du opdatere linjerne?;ENU=You may have changed a dimension.\\Do you want to update the lines?';
      Text062@1087 : TextConst 'DAN=Der findes et �bent lagerpluk for %1, og fordi %2 er angivet til %3.\\Du skal f�rst bogf�re eller slette lagerplukket eller �ndre %2 til Delvis.;ENU=An open inventory pick exists for the %1 and because %2 is %3.\\You must first post or delete the inventory pick or change %2 to Partial.';
      Text063@1102 : TextConst 'DAN=Der findes en �ben lagerleverance for %1, og %2 er %3.\\Du kan tilf�je varerne som nye linjer i den eksisterende lagerleverance eller �ndre %2 til Delvis.;ENU=An open warehouse shipment exists for the %1 and %2 is %3.\\You must add the item(s) as new line(s) to the existing warehouse shipment or change %2 to Partial.';
      Text064@1105 : TextConst 'DAN=Du kan ikke �ndre %1 til %2 grundet et �bent pluk (lager) p� %3.;ENU=You cannot change %1 to %2 because an open inventory pick on the %3.';
      Text065@1106 : TextConst 'DAN=Du kan ikke �ndre %1 til %2, fordi der findes en �ben lagerleverance for %3.;ENU=You cannot change %1  to %2 because an open warehouse shipment exists for the %3.';
      Text13606@1101100001 : TextConst 'DAN=indeholder ikke et gyldigt 13-cifret EAN-nr.;ENU=does not contain a valid, 13-digit EAN No.';
      Text13607@1101100002 : TextConst 'DAN=%1 %2 underst�ttes ikke i denne version af OIOUBL.;ENU=%1 %2 is not supported in this version of OIOUBL.';
      Text066@1017 : TextConst 'DAN=Du kan ikke �ndre dimensionen, da der er serviceposter forbundet til denne linje.;ENU=You cannot change the dimension because there are service entries connected to this line.';
      PostedDocsToPrintCreatedMsg@1022 : TextConst 'DAN=Et eller flere relaterede bogf�rte dokumenter er genereret under sletningen for at udfylde huller i bogf�ringen af nummerserier. Du kan vise eller udskrive dokumenterne fra det respektive dokumentarkiv.;ENU=One or more related posted documents have been generated during deletion to fill gaps in the posting number series. You can view or print the documents from the respective document archive.';
      DocumentNotPostedClosePageQst@1020 : TextConst 'DAN=Dokumentet er ikke bogf�rt.\Er du sikker p�, at du vil afslutte?;ENU=The document has not been posted.\Are you sure you want to exit?';

    PROCEDURE AssistEdit@1(OldServHeader@1000 : Record 5900) : Boolean;
    VAR
      ServHeader2@1001 : Record 5900;
    BEGIN
      WITH ServHeader DO BEGIN
        COPY(Rec);
        ServSetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldServHeader."No. Series","No. Series") THEN BEGIN
          IF ("Customer No." = '') AND ("Contact No." = '') THEN
            CheckCreditMaxBeforeInsert(FALSE);

          NoSeriesMgt.SetSeries("No.");
          IF ServHeader2.GET("Document Type","No.") THEN
            ERROR(Text051,LOWERCASE(FORMAT("Document Type")),"No.");
          Rec := ServHeader;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE CreateDim@16(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1006 : Integer;No4@1007 : Code[20];Type5@1012 : Integer;No5@1011 : Code[20]);
    VAR
      SourceCodeSetup@1008 : Record 242;
      ServiceContractHeader@1015 : Record 5965;
      No@1010 : ARRAY [10] OF Code[20];
      TableID@1009 : ARRAY [10] OF Integer;
      ContractDimensionSetID@1014 : Integer;
      OldDimSetID@1013 : Integer;
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
      TableID[5] := Type5;
      No[5] := No5;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      OldDimSetID := "Dimension Set ID";

      IF "Contract No." <> '' THEN BEGIN
        ServiceContractHeader.GET(ServiceContractHeader."Contract Type"::Contract,"Contract No.");
        ContractDimensionSetID := ServiceContractHeader."Dimension Set ID";
      END;

      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup."Service Management",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",ContractDimensionSetID,DATABASE::"Service Contract Header");

      IF ("Dimension Set ID" <> OldDimSetID) AND (ServItemLineExists OR ServLineExists) THEN BEGIN
        MODIFY;
        UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    [External]
    PROCEDURE UpdateAllLineDim@41(NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 : Integer);
    VAR
      NewDimSetID@1002 : Integer;
    BEGIN
      // Update all lines with changed dimensions.
      IF NewParentDimSetID = OldParentDimSetID THEN
        EXIT;
      IF NOT CONFIRM(Text061) THEN
        EXIT;

      ServLine.RESET;
      ServLine.SETRANGE("Document Type","Document Type");
      ServLine.SETRANGE("Document No.","No.");
      ServLine.LOCKTABLE;
      IF ServLine.FIND('-') THEN
        REPEAT
          NewDimSetID := DimMgt.GetDeltaDimSetID(ServLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
          IF ServLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
            ServLine."Dimension Set ID" := NewDimSetID;
            DimMgt.UpdateGlobalDimFromDimSetID(
              ServLine."Dimension Set ID",ServLine."Shortcut Dimension 1 Code",ServLine."Shortcut Dimension 2 Code");
            ServLine.MODIFY;
          END;
        UNTIL ServLine.NEXT = 0;

      ServItemLine.RESET;
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      ServItemLine.LOCKTABLE;
      IF ServItemLine.FIND('-') THEN
        REPEAT
          NewDimSetID := DimMgt.GetDeltaDimSetID(ServItemLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
          IF ServItemLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
            ServItemLine."Dimension Set ID" := NewDimSetID;
            DimMgt.UpdateGlobalDimFromDimSetID(
              ServItemLine."Dimension Set ID",ServItemLine."Shortcut Dimension 1 Code",ServItemLine."Shortcut Dimension 2 Code");
            ServItemLine.MODIFY;
          END;
        UNTIL ServItemLine.NEXT = 0;
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@19(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    VAR
      OldDimSetID@1002 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");

      IF ServItemLineExists OR ServLineExists THEN
        UpdateAllLineDim("Dimension Set ID",OldDimSetID);
    END;

    LOCAL PROCEDURE UpdateCurrencyFactor@12();
    BEGIN
      IF "Currency Code" <> '' THEN BEGIN
        CurrencyDate := "Posting Date";
        "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
      END ELSE
        "Currency Factor" := 0;
    END;

    LOCAL PROCEDURE RecreateServLines@2(ChangedFieldName@1000 : Text[100]);
    VAR
      TempServLine@1002 : TEMPORARY Record 5902;
      ServDocReg@1005 : Record 5936;
      TempServDocReg@1004 : TEMPORARY Record 5936;
      ExtendedTextAdded@1003 : Boolean;
    BEGIN
      IF ServLineExists THEN BEGIN
        IF HideValidationDialog OR NOT GUIALLOWED THEN
          Confirmed := TRUE
        ELSE
          Confirmed :=
            CONFIRM(
              Text012,
              FALSE,ChangedFieldName);
        IF Confirmed THEN BEGIN
          ServLine.LOCKTABLE;
          ReservEntry.LOCKTABLE;
          MODIFY;

          ServLine.RESET;
          ServLine.SETRANGE("Document Type","Document Type");
          ServLine.SETRANGE("Document No.","No.");
          IF ServLine.FIND('-') THEN BEGIN
            REPEAT
              ServLine.TESTFIELD("Quantity Shipped",0);
              ServLine.TESTFIELD("Quantity Invoiced",0);
              ServLine.TESTFIELD("Shipment No.",'');
              TempServLine := ServLine;
              IF ServLine.Nonstock THEN BEGIN
                ServLine.Nonstock := FALSE;
                ServLine.MODIFY;
              END;
              TempServLine.INSERT;
              CopyReservEntryToTemp(ServLine);
            UNTIL ServLine.NEXT = 0;

            IF "Location Code" <> xRec."Location Code" THEN
              IF NOT TempReservEntry.ISEMPTY THEN
                ERROR(Text047,FIELDCAPTION("Location Code"));

            IF "Document Type" = "Document Type"::Invoice THEN BEGIN
              ServDocReg.SETCURRENTKEY("Destination Document Type","Destination Document No.");
              ServDocReg.SETRANGE("Destination Document Type",ServDocReg."Destination Document Type"::Invoice);
              ServDocReg.SETRANGE("Destination Document No.",TempServLine."Document No.");
              IF ServDocReg.FIND('-') THEN
                REPEAT
                  TempServDocReg := ServDocReg;
                  TempServDocReg.INSERT;
                UNTIL ServDocReg.NEXT = 0;
            END;
            ServLine.DELETEALL(TRUE);

            IF "Document Type" = "Document Type"::Invoice THEN BEGIN
              IF TempServDocReg.FIND('-') THEN
                REPEAT
                  ServDocReg := TempServDocReg;
                  ServDocReg.INSERT;
                UNTIL TempServDocReg.NEXT = 0;
            END;

            CreateServiceLines(TempServLine,ExtendedTextAdded);
            TempServLine.SETRANGE(Type);
            TempServLine.DELETEALL;
          END;
        END ELSE
          ERROR('');
      END;
    END;

    LOCAL PROCEDURE ConfirmUpdateCurrencyFactor@13();
    BEGIN
      IF CONFIRM(Text015,FALSE) THEN
        VALIDATE("Currency Factor")
      ELSE
        "Currency Factor" := xRec."Currency Factor";
    END;

    LOCAL PROCEDURE UpdateServLines@15(ChangedFieldName@1000 : Text[100];AskQuestion@1001 : Boolean);
    VAR
      Question@1002 : Text[250];
    BEGIN
      IF ServLineExists AND AskQuestion THEN BEGIN
        Question := STRSUBSTNO(
            Text016,
            ChangedFieldName);
        IF GUIALLOWED THEN
          IF NOT CONFIRM(Question,TRUE) THEN
            EXIT
      END;

      IF ServLineExists THEN BEGIN
        ServLine.LOCKTABLE;
        ServLine.RESET;
        ServLine.SETRANGE("Document Type","Document Type");
        ServLine.SETRANGE("Document No.","No.");

        ServLine.SETRANGE("Quantity Shipped",0);
        ServLine.SETRANGE("Quantity Invoiced",0);
        ServLine.SETRANGE("Quantity Consumed",0);
        ServLine.SETRANGE("Shipment No.",'');

        IF ServLine.FIND('-') THEN
          REPEAT
            CASE ChangedFieldName OF
              FIELDCAPTION("Currency Factor"):
                IF (ServLine."Posting Date" = "Posting Date") AND (ServLine.Type <> ServLine.Type::" ") THEN BEGIN
                  ServLine.VALIDATE("Unit Price");
                  ServLine.MODIFY(TRUE);
                END;
              FIELDCAPTION("Posting Date"):
                BEGIN
                  ServLine.VALIDATE("Posting Date","Posting Date");
                  ServLine.MODIFY(TRUE);
                END;
              FIELDCAPTION("Responsibility Center"):
                BEGIN
                  ServLine.VALIDATE("Responsibility Center","Responsibility Center");
                  ServLine.MODIFY(TRUE);
                  ServItemLine.RESET;
                  ServItemLine.SETRANGE("Document Type","Document Type");
                  ServItemLine.SETRANGE("Document No.","No.");
                  IF ServItemLine.FIND('-') THEN
                    REPEAT
                      ServItemLine.VALIDATE("Responsibility Center","Responsibility Center");
                      ServItemLine.MODIFY(TRUE);
                    UNTIL ServItemLine.NEXT = 0;
                END;
              FIELDCAPTION("Order Date"):
                BEGIN
                  ServLine."Order Date" := "Order Date";
                  ServLine.MODIFY(TRUE);
                END;
              FIELDCAPTION("Transaction Type"):
                BEGIN
                  ServLine.VALIDATE("Transaction Type","Transaction Type");
                  ServLine.MODIFY(TRUE);
                END;
              FIELDCAPTION("Transport Method"):
                BEGIN
                  ServLine.VALIDATE("Transport Method","Transport Method");
                  ServLine.MODIFY(TRUE);
                END;
              FIELDCAPTION("Exit Point"):
                BEGIN
                  ServLine.VALIDATE("Exit Point","Exit Point");
                  ServLine.MODIFY(TRUE);
                END;
              FIELDCAPTION(Area):
                BEGIN
                  ServLine.VALIDATE(Area,Area);
                  ServLine.MODIFY(TRUE);
                END;
              FIELDCAPTION("Transaction Specification"):
                BEGIN
                  ServLine.VALIDATE("Transaction Specification","Transaction Specification");
                  ServLine.MODIFY(TRUE);
                END;
              FIELDCAPTION("Shipping Agent Code"):
                BEGIN
                  ServLine.VALIDATE("Shipping Agent Code","Shipping Agent Code");
                  ServLine.MODIFY(TRUE);
                END;
              FIELDCAPTION("Shipping Time"):
                BEGIN
                  ServLine.VALIDATE("Shipping Time","Shipping Time");
                  ServLine.MODIFY(TRUE);
                END;
              FIELDCAPTION("Shipping Agent Service Code"):
                BEGIN
                  ServLine.VALIDATE("Shipping Agent Service Code","Shipping Agent Service Code");
                  ServLine.MODIFY(TRUE);
                END;
              ELSE
                OnUpdateServLineByChangedFieldName(ServHeader,ServLine,ChangedFieldName);
            END;
          UNTIL ServLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE TestMandatoryFields@9(VAR PassedServLine@1002 : Record 5902);
    BEGIN
      ServSetup.GET;
      CheckMandSalesPersonOrderData(ServSetup);
      PassedServLine.RESET;
      ServLine.RESET;
      ServLine.SETRANGE("Document Type","Document Type");
      ServLine.SETRANGE("Document No.","No.");

      IF PassedServLine.FIND('-') THEN
        REPEAT
          IF (PassedServLine."Qty. to Ship" <> 0) OR
             (PassedServLine."Qty. to Invoice" <> 0) OR
             (PassedServLine."Qty. to Consume" <> 0)
          THEN BEGIN
            IF ("Document Type" = "Document Type"::Order) AND
               "Link Service to Service Item" AND
               (PassedServLine.Type IN [PassedServLine.Type::Item,PassedServLine.Type::Resource])
            THEN
              PassedServLine.TESTFIELD("Service Item Line No.");

            CASE PassedServLine.Type OF
              PassedServLine.Type::Item:
                BEGIN
                  IF ServSetup."Unit of Measure Mandatory" THEN
                    PassedServLine.TESTFIELD("Unit of Measure Code");
                END;
              PassedServLine.Type::Resource:
                BEGIN
                  IF ServSetup."Work Type Code Mandatory" THEN
                    PassedServLine.TESTFIELD("Work Type Code");
                  IF ServSetup."Unit of Measure Mandatory" THEN
                    PassedServLine.TESTFIELD("Unit of Measure Code");
                END;
              PassedServLine.Type::Cost:
                IF ServSetup."Unit of Measure Mandatory" THEN
                  PassedServLine.TESTFIELD("Unit of Measure Code");
            END;

            IF PassedServLine."Job No." <> '' THEN
              PassedServLine.TESTFIELD("Qty. to Consume",PassedServLine."Qty. to Ship");
          END;
        UNTIL PassedServLine.NEXT = 0
      ELSE
        IF ServLine.FIND('-') THEN
          REPEAT
            IF (ServLine."Qty. to Ship" <> 0) OR
               (ServLine."Qty. to Invoice" <> 0) OR
               (ServLine."Qty. to Consume" <> 0)
            THEN BEGIN
              IF ("Document Type" = "Document Type"::Order) AND
                 "Link Service to Service Item" AND
                 (ServLine.Type IN [ServLine.Type::Item,ServLine.Type::Resource])
              THEN
                ServLine.TESTFIELD("Service Item Line No.");

              CASE ServLine.Type OF
                ServLine.Type::Item:
                  BEGIN
                    IF ServSetup."Unit of Measure Mandatory" THEN
                      ServLine.TESTFIELD("Unit of Measure Code");
                  END;
                ServLine.Type::Resource:
                  BEGIN
                    IF ServSetup."Work Type Code Mandatory" THEN
                      ServLine.TESTFIELD("Work Type Code");
                    IF ServSetup."Unit of Measure Mandatory" THEN
                      ServLine.TESTFIELD("Unit of Measure Code");
                  END;
                ServLine.Type::Cost:
                  IF ServSetup."Unit of Measure Mandatory" THEN
                    ServLine.TESTFIELD("Unit of Measure Code");
              END;

              IF ServLine."Job No." <> '' THEN
                ServLine.TESTFIELD("Qty. to Consume",ServLine."Qty. to Ship");
            END;
          UNTIL ServLine.NEXT = 0;
    END;

    [External]
    PROCEDURE UpdateResponseDateTime@3();
    BEGIN
      ServItemLine.RESET;
      ServItemLine.SETCURRENTKEY("Document Type","Document No.","Response Date");
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      IF ServItemLine.FIND('-') THEN BEGIN
        "Response Date" := ServItemLine."Response Date";
        "Response Time" := ServItemLine."Response Time";
        MODIFY(TRUE);
      END;
    END;

    LOCAL PROCEDURE UpdateStartingDateTime@5();
    BEGIN
      IF ValidatingFromLines THEN
        EXIT;
      ServItemLine.RESET;
      ServItemLine.SETCURRENTKEY("Document Type","Document No.","Starting Date");
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      ServItemLine.SETFILTER("Starting Date",'<>%1',0D);
      IF ServItemLine.FIND('-') THEN BEGIN
        "Starting Date" := ServItemLine."Starting Date";
        "Starting Time" := ServItemLine."Starting Time";
        MODIFY(TRUE);
      END ELSE BEGIN
        "Starting Date" := 0D;
        "Starting Time" := 0T;
      END;
    END;

    LOCAL PROCEDURE UpdateFinishingDateTime@8();
    BEGIN
      IF ValidatingFromLines THEN
        EXIT;
      ServItemLine.RESET;
      ServItemLine.SETCURRENTKEY("Document Type","Document No.","Finishing Date");
      ServItemLine.ASCENDING := FALSE;
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      ServItemLine.SETFILTER("Finishing Date",'<>%1',0D);
      IF ServItemLine.FIND('-') THEN BEGIN
        "Finishing Date" := ServItemLine."Finishing Date";
        "Finishing Time" := ServItemLine."Finishing Time";
        MODIFY(TRUE);
      END ELSE BEGIN
        "Finishing Date" := 0D;
        "Finishing Time" := 0T;
      END;
    END;

    LOCAL PROCEDURE PriceMsgIfServLinesExist@10(ChangedFieldName@1000 : Text[100]);
    BEGIN
      IF ServLineExists THEN
        MESSAGE(
          Text019,
          ChangedFieldName);
    END;

    LOCAL PROCEDURE ServItemLineExists@4() : Boolean;
    VAR
      ServItemLine@1000 : Record 5901;
    BEGIN
      ServItemLine.RESET;
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      EXIT(NOT ServItemLine.ISEMPTY);
    END;

    LOCAL PROCEDURE ServLineExists@11() : Boolean;
    BEGIN
      ServLine.RESET;
      ServLine.SETRANGE("Document Type","Document Type");
      ServLine.SETRANGE("Document No.","No.");
      EXIT(NOT ServLine.ISEMPTY);
    END;

    LOCAL PROCEDURE MessageIfServLinesExist@7(ChangedFieldName@1000 : Text[100]);
    BEGIN
      IF ServLineExists AND NOT HideValidationDialog THEN
        MESSAGE(
          Text021,
          ChangedFieldName,TABLECAPTION);
    END;

    LOCAL PROCEDURE ValidateServPriceGrOnServItem@6();
    BEGIN
      ServItemLine.RESET;
      ServItemLine.SETRANGE("Document Type","Document Type");
      ServItemLine.SETRANGE("Document No.","No.");
      IF ServItemLine.FIND('-') THEN BEGIN
        ServItemLine.SetServHeader(Rec);
        REPEAT
          IF ServItemLine."Service Price Group Code" <> '' THEN BEGIN
            ServItemLine.VALIDATE("Service Price Group Code");
            ServItemLine.MODIFY;
          END;
        UNTIL ServItemLine.NEXT = 0
      END;
    END;

    [External]
    PROCEDURE SetHideValidationDialog@14(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    [External]
    PROCEDURE SetValidatingFromLines@17(NewValidatingFromLines@1000 : Boolean);
    BEGIN
      ValidatingFromLines := NewValidatingFromLines;
    END;

    LOCAL PROCEDURE TestNoSeries@21();
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote:
          ServSetup.TESTFIELD("Service Quote Nos.");
        "Document Type"::Order:
          ServSetup.TESTFIELD("Service Order Nos.");
      END;
    END;

    LOCAL PROCEDURE GetNoSeriesCode@20() : Code[20];
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote:
          EXIT(ServSetup."Service Quote Nos.");
        "Document Type"::Order:
          EXIT(ServSetup."Service Order Nos.");
        "Document Type"::Invoice:
          EXIT(ServSetup."Service Invoice Nos.");
        "Document Type"::"Credit Memo":
          EXIT(ServSetup."Service Credit Memo Nos.");
      END;
    END;

    LOCAL PROCEDURE TestNoSeriesManual@33();
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote:
          NoSeriesMgt.TestManual(ServSetup."Service Quote Nos.");
        "Document Type"::Order:
          NoSeriesMgt.TestManual(ServSetup."Service Order Nos.");
        "Document Type"::Invoice:
          NoSeriesMgt.TestManual(ServSetup."Service Invoice Nos.");
        "Document Type"::"Credit Memo":
          NoSeriesMgt.TestManual(ServSetup."Service Credit Memo Nos.");
      END;
    END;

    LOCAL PROCEDURE UpdateCont@24(CustomerNo@1000 : Code[20]);
    VAR
      ContBusRel@1003 : Record 5054;
      Cont@1002 : Record 5050;
      Cust@1004 : Record 18;
    BEGIN
      IF Cust.GET(CustomerNo) THEN BEGIN
        CLEAR(ServOrderMgt);
        ContactNo := ServOrderMgt.FindContactInformation(Cust."No.");
        IF Cont.GET(ContactNo) THEN BEGIN
          "Contact No." := Cont."No.";
          "Contact Name" := Cont.Name;
          "Phone No." := Cont."Phone No.";
          "Fax No." := Cont."Fax No.";
          "E-Mail" := Cont."E-Mail";
        END ELSE BEGIN
          IF Cust."Primary Contact No." <> '' THEN
            "Contact No." := Cust."Primary Contact No."
          ELSE
            IF ContBusRel.FindByRelation(ContBusRel."Link to Table"::Customer,"Customer No.") THEN
              "Contact No." := ContBusRel."Contact No."
            ELSE
              "Contact No." := '';
          "Contact Name" := Cust.Contact;
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateBillToCont@27(CustomerNo@1000 : Code[20]);
    VAR
      ContBusRel@1003 : Record 5054;
      Cont@1002 : Record 5050;
      Cust@1001 : Record 18;
    BEGIN
      IF Cust.GET(CustomerNo) THEN BEGIN
        CLEAR(ServOrderMgt);
        ContactNo := ServOrderMgt.FindContactInformation("Bill-to Customer No.");
        IF Cont.GET(ContactNo) THEN BEGIN
          "Bill-to Contact No." := Cont."No.";
          "Bill-to Contact" := Cont.Name;
        END ELSE BEGIN
          IF Cust."Primary Contact No." <> '' THEN
            "Bill-to Contact No." := Cust."Primary Contact No."
          ELSE
            IF ContBusRel.FindByRelation(ContBusRel."Link to Table"::Customer,"Bill-to Customer No.") THEN
              "Bill-to Contact No." := ContBusRel."Contact No."
            ELSE
              "Bill-to Contact No." := '';
          "Bill-to Contact" := Cust.Contact;
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateCust@25(ContactNo@1002 : Code[20]);
    VAR
      ContBusinessRelation@1007 : Record 5054;
      Cust@1006 : Record 18;
      Cont@1005 : Record 5050;
    BEGIN
      IF Cont.GET(ContactNo) THEN BEGIN
        "Contact No." := Cont."No.";
        "Phone No." := Cont."Phone No.";
        "E-Mail" := Cont."E-Mail";
      END ELSE BEGIN
        "Phone No." := '';
        "Fax No." := '';
        "E-Mail" := '';
        "Contact Name" := '';
        EXIT;
      END;

      IF Cont.Type = Cont.Type::Person THEN
        "Contact Name" := Cont.Name
      ELSE
        IF Cust.GET("Customer No.") THEN
          "Contact Name" := Cust.Contact
        ELSE
          "Contact Name" := '';

      IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") THEN BEGIN
        IF ("Customer No." <> '') AND
           ("Customer No." <> ContBusinessRelation."No.")
        THEN
          ERROR(Text037,Cont."No.",Cont.Name,"Customer No.");

        IF "Customer No." = '' THEN BEGIN
          SkipContact := TRUE;
          VALIDATE("Customer No.",ContBusinessRelation."No.");
          SkipContact := FALSE;
        END;
      END ELSE
        ERROR(Text039,Cont."No.",Cont.Name);

      IF ("Customer No." = "Bill-to Customer No.") OR
         ("Bill-to Customer No." = '')
      THEN
        VALIDATE("Bill-to Contact No.","Contact No.");

      OnAfterUpdateCust(Rec);
    END;

    LOCAL PROCEDURE UpdateBillToCust@26(ContactNo@1000 : Code[20]);
    VAR
      ContBusinessRelation@1005 : Record 5054;
      Cust@1004 : Record 18;
      Cont@1003 : Record 5050;
    BEGIN
      IF Cont.GET(ContactNo) THEN BEGIN
        "Bill-to Contact No." := Cont."No.";
        IF Cont.Type = Cont.Type::Person THEN
          "Bill-to Contact" := Cont.Name
        ELSE
          IF Cust.GET("Bill-to Customer No.") THEN
            "Bill-to Contact" := Cust.Contact
          ELSE
            "Bill-to Contact" := '';
      END ELSE BEGIN
        "Bill-to Contact" := '';
        EXIT;
      END;

      IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") THEN BEGIN
        IF "Bill-to Customer No." = '' THEN BEGIN
          SkipBillToContact := TRUE;
          VALIDATE("Bill-to Customer No.",ContBusinessRelation."No.");
          SkipBillToContact := FALSE;
        END ELSE
          IF "Bill-to Customer No." <> ContBusinessRelation."No." THEN
            ERROR(Text037,Cont."No.",Cont.Name,"Bill-to Customer No.");
      END ELSE
        ERROR(Text039,Cont."No.",Cont.Name);
    END;

    PROCEDURE CheckCreditMaxBeforeInsert@28(HideCreditCheckDialogue@1004 : Boolean);
    VAR
      ServHeader@1001 : Record 5900;
      ContBusinessRelation@1002 : Record 5054;
      Cont@1003 : Record 5050;
      CustCheckCreditLimit@1000 : Codeunit 312;
    BEGIN
      IF HideCreditCheckDialogue THEN
        EXIT;
      IF GETFILTER("Customer No.") <> '' THEN BEGIN
        IF GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") THEN BEGIN
          ServHeader."Bill-to Customer No." := GETRANGEMIN("Customer No.");
          CustCheckCreditLimit.ServiceHeaderCheck(ServHeader);
        END
      END ELSE
        IF GETFILTER("Contact No.") <> '' THEN
          IF GETRANGEMIN("Contact No.") = GETRANGEMAX("Contact No.") THEN BEGIN
            Cont.GET(GETRANGEMIN("Contact No."));
            IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") THEN BEGIN
              ServHeader."Bill-to Customer No." := ContBusinessRelation."No.";
              CustCheckCreditLimit.ServiceHeaderCheck(ServHeader);
            END;
          END;
    END;

    [External]
    PROCEDURE UpdateServiceOrderChangeLog@22(VAR OldServHeader@1000 : Record 5900);
    BEGIN
      IF Status <> OldServHeader.Status THEN
        ServLogMgt.ServHeaderStatusChange(Rec,OldServHeader);

      IF "Customer No." <> OldServHeader."Customer No." THEN
        ServLogMgt.ServHeaderCustomerChange(Rec,OldServHeader);

      IF "Ship-to Code" <> OldServHeader."Ship-to Code" THEN
        ServLogMgt.ServHeaderShiptoChange(Rec,OldServHeader);

      IF "Contract No." <> OldServHeader."Contract No." THEN
        ServLogMgt.ServHeaderContractNoChanged(Rec,OldServHeader);
    END;

    LOCAL PROCEDURE GetPostingNoSeriesCode@39() : Code[20];
    BEGIN
      IF "Document Type" IN ["Document Type"::"Credit Memo"] THEN
        EXIT(ServSetup."Posted Serv. Credit Memo Nos.");
      EXIT(ServSetup."Posted Service Invoice Nos.");
    END;

    [External]
    PROCEDURE InitRecord@32();
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote,"Document Type"::Order:
          BEGIN
            NoSeriesMgt.SetDefaultSeries("Posting No. Series",ServSetup."Posted Service Invoice Nos.");
            NoSeriesMgt.SetDefaultSeries("Shipping No. Series",ServSetup."Posted Service Shipment Nos.");
          END;
        "Document Type"::Invoice:
          BEGIN
            IF ("No. Series" <> '') AND
               (ServSetup."Service Invoice Nos." = ServSetup."Posted Service Invoice Nos.")
            THEN
              "Posting No. Series" := "No. Series"
            ELSE
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",ServSetup."Posted Service Invoice Nos.");
            IF ServSetup."Shipment on Invoice" THEN
              NoSeriesMgt.SetDefaultSeries("Shipping No. Series",ServSetup."Posted Service Shipment Nos.");
          END;
        "Document Type"::"Credit Memo":
          BEGIN
            IF ("No. Series" <> '') AND
               (ServSetup."Service Credit Memo Nos." = ServSetup."Posted Serv. Credit Memo Nos.")
            THEN
              "Posting No. Series" := "No. Series"
            ELSE
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",ServSetup."Posted Serv. Credit Memo Nos.");
          END;
      END;

      IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote]
      THEN BEGIN
        "Order Date" := WORKDATE;
        "Order Time" := TIME;
      END;

      "Posting Date" := WORKDATE;
      "Document Date" := WORKDATE;
      "Default Response Time (Hours)" := ServSetup."Default Response Time (Hours)";
      "Link Service to Service Item" := ServSetup."Link Service to Service Item";

      IF Cust.GET("Customer No.") THEN
        VALIDATE("Location Code",UserSetupMgt.GetLocation(2,Cust."Location Code","Responsibility Center"));

      IF "Document Type" IN ["Document Type"::"Credit Memo"] THEN BEGIN
        GLSetup.GET;
        Correction := GLSetup."Mark Cr. Memos as Corrections";
      END;

      "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

      Reserve := Reserve::Optional;

      IF Cust.GET("Customer No.") THEN
        IF Cust."Responsibility Center" <> '' THEN
          "Responsibility Center" := UserSetupMgt.GetRespCenter(2,Cust."Responsibility Center")
        ELSE
          "Responsibility Center" := UserSetupMgt.GetRespCenter(2,"Responsibility Center")
      ELSE
        "Responsibility Center" := UserSetupMgt.GetServiceFilter;

      OnAfterInitRecord(Rec);
    END;

    LOCAL PROCEDURE InitRecordFromContact@43();
    BEGIN
      INIT;
      ServSetup.GET;
      InitRecord;
      "No. Series" := xRec."No. Series";
      IF xRec."Shipping No." <> '' THEN BEGIN
        "Shipping No. Series" := xRec."Shipping No. Series";
        "Shipping No." := xRec."Shipping No.";
      END;
      IF xRec."Posting No." <> '' THEN BEGIN
        "Posting No. Series" := xRec."Posting No. Series";
        "Posting No." := xRec."Posting No.";
      END;
    END;

    LOCAL PROCEDURE GetCust@30(CustNo@1000 : Code[20]);
    BEGIN
      IF NOT (("Document Type" = "Document Type"::Quote) AND (CustNo = '')) THEN BEGIN
        IF CustNo <> Cust."No." THEN
          Cust.GET(CustNo);
      END ELSE
        CLEAR(Cust);
    END;

    LOCAL PROCEDURE ShippedServLinesExist@31() : Boolean;
    BEGIN
      ServLine.RESET;
      ServLine.SETRANGE("Document Type","Document Type");
      ServLine.SETRANGE("Document No.","No.");
      ServLine.SETFILTER("Quantity Shipped",'<>0');
      EXIT(ServLine.FIND('-'));
    END;

    LOCAL PROCEDURE UpdateShipToAddress@29();
    VAR
      Location@1000 : Record 14;
      CompanyInfo@1001 : Record 79;
    BEGIN
      IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
        IF "Location Code" <> '' THEN BEGIN
          Location.GET("Location Code");
          SetShipToAddress(
            Location.Name,Location."Name 2",Location.Address,Location."Address 2",
            Location.City,Location."Post Code",Location.County,Location."Country/Region Code");
          "Ship-to Contact" := Location.Contact;
        END ELSE BEGIN
          CompanyInfo.GET;
          "Ship-to Code" := '';
          SetShipToAddress(
            CompanyInfo."Ship-to Name",CompanyInfo."Ship-to Name 2",CompanyInfo."Ship-to Address",CompanyInfo."Ship-to Address 2",
            CompanyInfo."Ship-to City",CompanyInfo."Ship-to Post Code",CompanyInfo."Ship-to County",
            CompanyInfo."Ship-to Country/Region Code");
          "Ship-to Contact" := CompanyInfo."Ship-to Contact";
        END;
        "VAT Country/Region Code" := "Country/Region Code";
      END;

      OnAfterUpdateShipToAddress(Rec);
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
      VALIDATE("Ship-to Country/Region Code",ShipToCountryRegionCode);
    END;

    [External]
    PROCEDURE ConfirmDeletion@36() : Boolean;
    BEGIN
      ServPost.TestDeleteHeader(Rec,ServShptHeader,ServInvHeader,ServCrMemoHeader);
      IF ServShptHeader."No." <> '' THEN
        IF NOT
           CONFIRM(
             Text053,
             TRUE,ServShptHeader."No.")
        THEN
          EXIT;
      IF ServInvHeader."No." <> '' THEN
        IF NOT
           CONFIRM(
             Text054,
             TRUE,ServInvHeader."No.")
        THEN
          EXIT;
      IF ServCrMemoHeader."No." <> '' THEN
        IF NOT
           CONFIRM(
             Text013,
             TRUE,ServCrMemoHeader."No.")
        THEN
          EXIT;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CopyReservEntryToTemp@44(OldServLine@1001 : Record 5902);
    BEGIN
      ReservEntry.RESET;
      ReservEntry.SetSourceFilter(
        DATABASE::"Service Line",OldServLine."Document Type",OldServLine."Document No.",OldServLine."Line No.",FALSE);
      IF ReservEntry.FINDSET THEN
        REPEAT
          TempReservEntry := ReservEntry;
          TempReservEntry.INSERT;
        UNTIL ReservEntry.NEXT = 0;
      ReservEntry.DELETEALL;
    END;

    LOCAL PROCEDURE CopyReservEntryFromTemp@56(OldServLine@1001 : Record 5902;NewSourceRefNo@1000 : Integer);
    BEGIN
      TempReservEntry.RESET;
      TempReservEntry.SetSourceFilter(
        DATABASE::"Service Line",OldServLine."Document Type",OldServLine."Document No.",OldServLine."Line No.",FALSE);
      IF TempReservEntry.FINDSET THEN
        REPEAT
          ReservEntry := TempReservEntry;
          ReservEntry."Source Ref. No." := NewSourceRefNo;
          IF NOT ReservEntry.INSERT THEN;
        UNTIL TempReservEntry.NEXT = 0;
      TempReservEntry.DELETEALL;
    END;

    [External]
    PROCEDURE ShowDocDim@23();
    VAR
      OldDimSetID@1000 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2("Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
        MODIFY;
        IF ServItemLineExists OR ServLineExists THEN
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    [External]
    PROCEDURE LookupAdjmtValueEntries@37(QtyType@1000 : 'General,Invoicing');
    VAR
      ItemLedgEntry@1004 : Record 32;
      ServiceLine@1001 : Record 5902;
      ServiceShptLine@1005 : Record 5991;
      TempValueEntry@1003 : TEMPORARY Record 5802;
    BEGIN
      ServiceLine.SETRANGE("Document Type","Document Type");
      ServiceLine.SETRANGE("Document No.","No.");
      TempValueEntry.RESET;
      TempValueEntry.DELETEALL;

      CASE "Document Type" OF
        "Document Type"::Order,"Document Type"::Invoice:
          BEGIN
            IF ServiceLine.FINDSET THEN
              REPEAT
                IF (ServiceLine.Type = ServiceLine.Type::Item) AND (ServiceLine.Quantity <> 0) THEN
                  IF ServiceLine."Shipment No." <> '' THEN BEGIN
                    ServiceShptLine.SETRANGE("Document No.",ServiceLine."Shipment No.");
                    ServiceShptLine.SETRANGE("Line No.",ServiceLine."Shipment Line No.");
                  END ELSE BEGIN
                    ServiceShptLine.SETCURRENTKEY("Order No.","Order Line No.");
                    ServiceShptLine.SETRANGE("Order No.",ServiceLine."Document No.");
                    ServiceShptLine.SETRANGE("Order Line No.",ServiceLine."Line No.");
                  END;
                ServiceShptLine.SETRANGE(Correction,FALSE);
                IF QtyType = QtyType::Invoicing THEN
                  ServiceShptLine.SETFILTER("Qty. Shipped Not Invoiced",'<>0');

                IF ServiceShptLine.FINDSET THEN
                  REPEAT
                    ServiceShptLine.FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
                    IF ItemLedgEntry.FINDSET THEN
                      REPEAT
                        CreateTempAdjmtValueEntries(TempValueEntry,ItemLedgEntry."Entry No.");
                      UNTIL ItemLedgEntry.NEXT = 0;
                  UNTIL ServiceShptLine.NEXT = 0;
              UNTIL ServiceLine.NEXT = 0;
          END;
      END;
      PAGE.RUNMODAL(0,TempValueEntry);
    END;

    LOCAL PROCEDURE CreateTempAdjmtValueEntries@38(VAR TempValueEntry@1001 : TEMPORARY Record 5802;ItemLedgEntryNo@1000 : Integer);
    VAR
      ValueEntry@1002 : Record 5802;
    BEGIN
      ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
      ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntryNo);
      IF ValueEntry.FINDSET THEN
        REPEAT
          IF ValueEntry.Adjustment THEN BEGIN
            TempValueEntry := ValueEntry;
            IF TempValueEntry.INSERT THEN;
          END;
        UNTIL ValueEntry.NEXT = 0;
    END;

    [Internal]
    PROCEDURE CalcInvDiscForHeader@45();
    VAR
      ServiceInvDisc@1000 : Codeunit 5950;
    BEGIN
      ServiceInvDisc.CalculateIncDiscForHeader(Rec);
    END;

    [External]
    PROCEDURE SetSecurityFilterOnRespCenter@42();
    BEGIN
      IF UserSetupMgt.GetServiceFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetServiceFilter);
        FILTERGROUP(0);
      END;

      SETRANGE("Date Filter",0D,WORKDATE - 1);
    END;

    LOCAL PROCEDURE CheckMandSalesPersonOrderData@40(ServiceMgtSetup@1000 : Record 5911);
    BEGIN
      IF ServiceMgtSetup."Salesperson Mandatory" THEN
        TESTFIELD("Salesperson Code");

      IF "Document Type" = "Document Type"::Order THEN BEGIN
        IF ServiceMgtSetup."Service Order Type Mandatory" AND ("Service Order Type" = '') THEN
          ERROR(Text018,
            FIELDCAPTION("Service Order Type"),TABLECAPTION,
            FIELDCAPTION("Document Type"),FORMAT("Document Type"),
            FIELDCAPTION("No."),FORMAT("No."));
        IF ServiceMgtSetup."Service Order Start Mandatory" THEN BEGIN
          TESTFIELD("Starting Date");
          TESTFIELD("Starting Time");
        END;
        IF ServiceMgtSetup."Service Order Finish Mandatory" THEN BEGIN
          TESTFIELD("Finishing Date");
          TESTFIELD("Finishing Time");
        END;
        IF ServiceMgtSetup."Fault Reason Code Mandatory" AND NOT ValidatingFromLines THEN BEGIN
          ServItemLine.RESET;
          ServItemLine.SETRANGE("Document Type","Document Type");
          ServItemLine.SETRANGE("Document No.","No.");
          IF ServItemLine.FIND('-') THEN
            REPEAT
              ServItemLine.TESTFIELD("Fault Reason Code");
            UNTIL ServItemLine.NEXT = 0;
        END;
      END;
    END;

    [External]
    PROCEDURE InventoryPickConflict@47(DocType@1004 : 'Quote,Order,Invoice,Credit Memo';DocNo@1003 : Code[20];ShippingAdvice@1002 : 'Partial,Complete') : Boolean;
    VAR
      WarehouseActivityLine@1000 : Record 5767;
      ServiceLine@1001 : Record 5902;
    BEGIN
      IF ShippingAdvice <> ShippingAdvice::Complete THEN
        EXIT(FALSE);
      WarehouseActivityLine.SETCURRENTKEY("Source Type","Source Subtype","Source No.");
      WarehouseActivityLine.SETRANGE("Source Type",DATABASE::"Service Line");
      WarehouseActivityLine.SETRANGE("Source Subtype",DocType);
      WarehouseActivityLine.SETRANGE("Source No.",DocNo);
      IF WarehouseActivityLine.ISEMPTY THEN
        EXIT(FALSE);
      ServiceLine.SETRANGE("Document Type",DocType);
      ServiceLine.SETRANGE("Document No.",DocNo);
      ServiceLine.SETRANGE(Type,ServiceLine.Type::Item);
      IF ServiceLine.ISEMPTY THEN
        EXIT(FALSE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE InvPickConflictResolutionTxt@48() : Text[500];
    BEGIN
      EXIT(STRSUBSTNO(Text062,TABLECAPTION,FIELDCAPTION("Shipping Advice"),FORMAT("Shipping Advice")));
    END;

    [External]
    PROCEDURE WhseShpmntConflict@52(DocType@1002 : 'Quote,Order,Invoice,Credit Memo';DocNo@1001 : Code[20];ShippingAdvice@1000 : 'Partial,Complete') : Boolean;
    VAR
      WarehouseShipmentLine@1003 : Record 7321;
    BEGIN
      IF ShippingAdvice <> ShippingAdvice::Complete THEN
        EXIT(FALSE);
      WarehouseShipmentLine.SETCURRENTKEY("Source Type","Source Subtype","Source No.","Source Line No.");
      WarehouseShipmentLine.SETRANGE("Source Type",DATABASE::"Service Line");
      WarehouseShipmentLine.SETRANGE("Source Subtype",DocType);
      WarehouseShipmentLine.SETRANGE("Source No.",DocNo);
      IF WarehouseShipmentLine.ISEMPTY THEN
        EXIT(FALSE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE WhseShpmtConflictResolutionTxt@54() : Text[500];
    BEGIN
      EXIT(STRSUBSTNO(Text063,TABLECAPTION,FIELDCAPTION("Shipping Advice"),FORMAT("Shipping Advice")));
    END;

    LOCAL PROCEDURE GetShippingTime@49(CalledByFieldNo@1000 : Integer);
    VAR
      ShippingAgentServices@1001 : Record 5790;
    BEGIN
      IF (CalledByFieldNo <> CurrFieldNo) AND (CurrFieldNo <> 0) THEN
        EXIT;

      IF ShippingAgentServices.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
        "Shipping Time" := ShippingAgentServices."Shipping Time"
      ELSE BEGIN
        GetCust("Customer No.");
        "Shipping Time" := Cust."Shipping Time"
      END;
      IF NOT (CalledByFieldNo IN [FIELDNO("Shipping Agent Code"),FIELDNO("Shipping Agent Service Code")]) THEN
        VALIDATE("Shipping Time");
    END;

    LOCAL PROCEDURE CheckHeaderDimension@46();
    BEGIN
      IF ("Contract No." <> '') AND ("Document Type" = "Document Type"::Invoice) THEN
        ERROR(Text066);
    END;

    LOCAL PROCEDURE CreateServiceLines@50(VAR TempServLine@1004 : TEMPORARY Record 5902;VAR ExtendedTextAdded@1000 : Boolean);
    VAR
      TransferExtendedText@1001 : Codeunit 378;
    BEGIN
      ServLine.INIT;
      ServLine."Line No." := 0;
      TempServLine.FIND('-');
      ExtendedTextAdded := FALSE;

      REPEAT
        IF TempServLine."Attached to Line No." = 0 THEN BEGIN
          ServLine.INIT;
          ServLine.SetHideReplacementDialog(TRUE);
          ServLine.SetHideCostWarning(TRUE);
          ServLine."Line No." := ServLine."Line No." + 10000;
          ServLine.VALIDATE(Type,TempServLine.Type);
          IF TempServLine."No." <> '' THEN BEGIN
            ServLine.VALIDATE("No.",TempServLine."No.");
            IF ServLine.Type <> ServLine.Type::" " THEN BEGIN
              ServLine.VALIDATE("Unit of Measure Code",TempServLine."Unit of Measure Code");
              ServLine.VALIDATE("Variant Code",TempServLine."Variant Code");
              IF TempServLine.Quantity <> 0 THEN
                ServLine.VALIDATE(Quantity,TempServLine.Quantity);
            END;
          END;

          ServLine."Serv. Price Adjmt. Gr. Code" := TempServLine."Serv. Price Adjmt. Gr. Code";
          ServLine."Document No." := TempServLine."Document No.";
          ServLine."Service Item No." := TempServLine."Service Item No.";
          ServLine."Appl.-to Service Entry" := TempServLine."Appl.-to Service Entry";
          ServLine."Service Item Line No." := TempServLine."Service Item Line No.";
          ServLine.VALIDATE(Description,TempServLine.Description);
          ServLine.VALIDATE("Description 2",TempServLine."Description 2");

          IF TempServLine."No." <> '' THEN BEGIN
            TempLinkToServItem := "Link Service to Service Item";
            IF "Link Service to Service Item" THEN BEGIN
              "Link Service to Service Item" := FALSE;
              MODIFY(TRUE);
            END;
            ServLine."Spare Part Action" := TempServLine."Spare Part Action";
            ServLine."Component Line No." := TempServLine."Component Line No.";
            ServLine."Replaced Item No." := TempServLine."Replaced Item No.";
            ServLine.VALIDATE("Work Type Code",TempServLine."Work Type Code");

            ServLine."Location Code" := TempServLine."Location Code";
            IF ServLine.Type <> ServLine.Type::" " THEN BEGIN
              IF ServLine.Type = ServLine.Type::Item THEN BEGIN
                ServLine.VALIDATE("Variant Code",TempServLine."Variant Code");
                IF ServLine."Location Code" <> '' THEN
                  ServLine."Bin Code" := TempServLine."Bin Code";
              END;
              ServLine."Fault Reason Code" := TempServLine."Fault Reason Code";
              ServLine."Exclude Warranty" := TempServLine."Exclude Warranty";
              ServLine."Exclude Contract Discount" := TempServLine."Exclude Contract Discount";
              ServLine.VALIDATE("Contract No.",TempServLine."Contract No.");
              ServLine.VALIDATE(Warranty,TempServLine.Warranty);
            END;
            ServLine."Fault Area Code" := TempServLine."Fault Area Code";
            ServLine."Symptom Code" := TempServLine."Symptom Code";
            ServLine."Resolution Code" := TempServLine."Resolution Code";
            ServLine."Fault Code" := TempServLine."Fault Code";
            ServLine.VALIDATE("Dimension Set ID",TempServLine."Dimension Set ID");
          END;
          "Link Service to Service Item" := TempLinkToServItem;

          ServLine.INSERT;
          ExtendedTextAdded := FALSE;
        END ELSE
          IF NOT ExtendedTextAdded THEN BEGIN
            TransferExtendedText.ServCheckIfAnyExtText(ServLine,TRUE);
            TransferExtendedText.InsertServExtText(ServLine);
            OnAfterTransferExtendedTextForServLineRecreation(ServLine);
            ServLine.FIND('+');
            ExtendedTextAdded := TRUE;
          END;
        CopyReservEntryFromTemp(TempServLine,ServLine."Line No.");
      UNTIL TempServLine.NEXT = 0;
    END;

    [External]
    PROCEDURE SetCustomerFromFilter@186();
    VAR
      CustomerNo@1000 : Code[20];
    BEGIN
      CustomerNo := GetFilterCustNo;
      IF CustomerNo = '' THEN BEGIN
        FILTERGROUP(2);
        CustomerNo := GetFilterCustNo;
        FILTERGROUP(0);
      END;
      IF CustomerNo <> '' THEN
        VALIDATE("Customer No.",CustomerNo);
    END;

    LOCAL PROCEDURE GetFilterCustNo@64() : Code[20];
    BEGIN
      IF GETFILTER("Customer No.") <> '' THEN
        IF GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") THEN
          EXIT(GETRANGEMAX("Customer No."));
    END;

    LOCAL PROCEDURE UpdateShipToAddressFromGeneralAddress@53(FieldNumber@1000 : Integer);
    BEGIN
      IF ("Ship-to Code" = '') AND (NOT ShipToAddressModified) THEN
        CASE FieldNumber OF
          FIELDNO("Ship-to Address"):
            IF xRec.Address = "Ship-to Address" THEN
              "Ship-to Address" := Address;
          FIELDNO("Ship-to Address 2"):
            IF xRec."Address 2" = "Ship-to Address 2" THEN
              "Ship-to Address 2" := "Address 2";
          FIELDNO("Ship-to City"), FIELDNO("Ship-to Post Code"):
            BEGIN
              IF xRec.City = "Ship-to City" THEN
                "Ship-to City" := City;
              IF xRec."Post Code" = "Ship-to Post Code" THEN
                "Ship-to Post Code" := "Post Code";
              IF xRec.County = "Ship-to County" THEN
                "Ship-to County" := County;
              IF xRec."Country/Region Code" = "Ship-to Country/Region Code" THEN
                "Ship-to Country/Region Code" := "Country/Region Code";
            END;
          FIELDNO("Ship-to County"):
            IF xRec.County = "Ship-to County" THEN
              "Ship-to County" := County;
          FIELDNO("Ship-to Country/Region Code"):
            IF  xRec."Country/Region Code" = "Ship-to Country/Region Code" THEN
              "Ship-to Country/Region Code" := "Country/Region Code";
        END;
    END;

    [External]
    PROCEDURE CopyCustomerFilter@51();
    VAR
      CustomerFilter@1000 : Text;
    BEGIN
      CustomerFilter := GETFILTER("Customer No.");
      IF CustomerFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETFILTER("Customer No.",CustomerFilter);
        FILTERGROUP(0)
      END;
    END;

    LOCAL PROCEDURE ShipToAddressModified@55() : Boolean;
    BEGIN
      IF (xRec.Address <> "Ship-to Address") OR
         (xRec."Address 2" <> "Ship-to Address 2") OR
         (xRec.City <> "Ship-to City") OR
         (xRec.County <> "Ship-to County") OR
         (xRec."Post Code" <> "Ship-to Post Code") OR
         (xRec."Country/Region Code" <> "Ship-to Country/Region Code")
      THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE ConfirmCloseUnposted@98() : Boolean;
    VAR
      InstructionMgt@1000 : Codeunit 1330;
    BEGIN
      IF ServLineExists OR ServItemLineExists THEN
        EXIT(InstructionMgt.ShowConfirm(DocumentNotPostedClosePageQst,InstructionMgt.QueryPostOnCloseCode));
      EXIT(TRUE)
    END;

    LOCAL PROCEDURE SetDefaultSalesperson@18();
    VAR
      UserSetup@1000 : Record 91;
    BEGIN
      IF NOT UserSetup.GET(USERID) THEN
        EXIT;

      IF UserSetup."Salespers./Purch. Code" <> '' THEN
        VALIDATE("Salesperson Code",UserSetup."Salespers./Purch. Code");
    END;

    PROCEDURE ValidateSalesPersonOnServiceHeader@433(ServiceHeader2@1000 : Record 5900;IsTransaction@1001 : Boolean;IsPostAction@1002 : Boolean);
    BEGIN
      IF ServiceHeader2."Salesperson Code" <> '' THEN
        IF Salesperson.GET(ServiceHeader2."Salesperson Code") THEN
          IF Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) THEN BEGIN
            IF IsTransaction THEN
              ERROR(Salesperson.GetPrivacyBlockedTransactionText(Salesperson,IsPostAction,TRUE));
            IF NOT IsTransaction THEN
              ERROR(Salesperson.GetPrivacyBlockedGenericText(Salesperson,TRUE));
          END;
    END;

    LOCAL PROCEDURE SetSalespersonCode@218(SalesPersonCodeToCheck@1000 : Code[20];VAR SalesPersonCodeToAssign@1001 : Code[20]);
    BEGIN
      IF SalesPersonCodeToCheck <> '' THEN
        IF Salesperson.GET(SalesPersonCodeToCheck) THEN
          IF Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) THEN
            SalesPersonCodeToAssign := ''
          ELSE
            SalesPersonCodeToAssign := SalesPersonCodeToCheck;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitRecord@34(VAR ServiceHeader@1000 : Record 5900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateShipToAddress@137(VAR ServiceHeader@1000 : Record 5900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnUpdateServLineByChangedFieldName@139(ServiceHeader@1000 : Record 5900;VAR ServiceLine@1001 : Record 5902;ChangedFieldName@1002 : Text[100]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@138(VAR ServiceHeader@1000 : Record 5900;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateCust@140(VAR ServiceHeader@1000 : Record 5900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferExtendedTextForServLineRecreation@141(VAR ServLine@1001 : Record 5902);
    BEGIN
    END;

    BEGIN
    END.
  }
}

