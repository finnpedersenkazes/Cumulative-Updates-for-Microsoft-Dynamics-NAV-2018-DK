OBJECT Report 780 Certificate of Supply
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Leveringscertifikat;
               ENU=Certificate of Supply];
    OnInitReport=BEGIN
                   CompanyInfo.GET;
                   PrintLineDetails := TRUE;
                   CreateCertificatesofSupply := FALSE;
                 END;

  }
  DATASET
  {
    { 13  ;    ;DataItem;CertificateOfSupply ;
               DataItemTable=Table780;
               OnPreDataItem=VAR
                               SalesShipmentHeader@1000 : Record 110;
                               ServiceShipmentHeader@1001 : Record 5990;
                               ReturnShipmentHeader@1002 : Record 6650;
                               CertificateOfSupply2@1003 : Record 780;
                             BEGIN
                               IF (GETFILTER("Document Type") = '') XOR
                                  (GETRANGEMIN("Document Type") <> GETRANGEMAX("Document Type"))
                               THEN
                                 ERROR(MultipleDocumentsErr);

                               IF CreateCertificatesofSupply THEN
                                 CASE GETRANGEMIN("Document Type") OF
                                   "Document Type"::"Sales Shipment":
                                     BEGIN
                                       COPYFILTER("Document No.",SalesShipmentHeader."No.");
                                       IF SalesShipmentHeader.FINDSET THEN
                                         REPEAT
                                           CertificateOfSupply2.InitFromSales(SalesShipmentHeader);
                                           CertificateOfSupply2.SetRequired(SalesShipmentHeader."No.");
                                         UNTIL SalesShipmentHeader.NEXT = 0;
                                     END;
                                   "Document Type"::"Service Shipment":
                                     BEGIN
                                       COPYFILTER("Document No.",ServiceShipmentHeader."No.");
                                       IF ServiceShipmentHeader.FINDSET THEN
                                         REPEAT
                                           CertificateOfSupply2.InitFromService(ServiceShipmentHeader);
                                           CertificateOfSupply2.SetRequired(ServiceShipmentHeader."No.")
                                         UNTIL ServiceShipmentHeader.NEXT = 0;
                                     END;
                                   "Document Type"::"Return Shipment":
                                     BEGIN
                                       COPYFILTER("Document No.",ReturnShipmentHeader."No.");
                                       IF ReturnShipmentHeader.FINDFIRST THEN
                                         REPEAT
                                           CertificateOfSupply2.InitFromPurchase(ReturnShipmentHeader);
                                           CertificateOfSupply2.SetRequired(ReturnShipmentHeader."No.")
                                         UNTIL ServiceShipmentHeader.NEXT = 0;
                                     END
                                 END
                             END;

               OnAfterGetRecord=VAR
                                  Language@1000 : Record 8;
                                BEGIN
                                  CLEAR(TempServiceShipmentHeader);
                                  TempServiceShipmentLine.RESET;
                                  TempServiceShipmentLine.DELETEALL;
                                  CurrReport.LANGUAGE := Language.GetLanguageID(GetLanguageCode(CertificateOfSupply));
                                  SetSource(CertificateOfSupply);
                                  IF PrintLineDetails THEN
                                    GetLines(CertificateOfSupply);
                                END;

               ReqFilterFields=Document Type,Document No. }

    { 3595;1   ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               MaxIteration=1;
               OnPostDataItem=BEGIN
                                IF NOT IsReportInPreviewMode THEN
                                  CertificateOfSupply.SetPrintedTrue;
                              END;
                               }

    { 15  ;2   ;Column  ;FORMAT_TODAY_0_4_   ;
               SourceExpr=FORMAT(TODAY,0,4) }

    { 16  ;2   ;Column  ;COMPANYNAME         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 12  ;2   ;Column  ;COMPANYADDRESS      ;
               SourceExpr=CompanyInfo.Address }

    { 44  ;2   ;Column  ;COMPANYADDRESS2     ;
               SourceExpr=CompanyInfo."Address 2" }

    { 14  ;2   ;Column  ;COMPANYCITY         ;
               SourceExpr=CompanyInfo.City }

    { 34  ;2   ;Column  ;COMPANYCOUNTRYCODE  ;
               SourceExpr=CompanyInfo."Country/Region Code" }

    { 20  ;2   ;Column  ;Quantity_of_the_object_of_the_supply_Caption;
               SourceExpr=Quantity_of_the_object_of_the_supply_Lbl }

    { 21  ;2   ;Column  ;Standard_commercial_description___in_the_case_of_vehicles__including_vehicle_identification_number_Caption;
               SourceExpr=Standard_commercial_description___in_the_case_of_vehicles__including_vehicle_identification_number_Lbl }

    { 22  ;2   ;Column  ;Date_the_object_of_the_supply_was_received_in_the_Member_State_of_entry_if_the_supplying_trader_transported_or_dispatched_theCaption;
               SourceExpr=Date_the_object_of_the_supply_was_received_in_the_Member_State_of_entry_if_the_supplying_trader_transported_or_dispatched_theLbl }

    { 23  ;2   ;Column  ;Date_the_transportation_ended_if_the_customer_transported_the_object_of_the_supply_himself_or_herself_Caption;
               SourceExpr=Date_the_transportation_ended_if_the_customer_transported_the_object_of_the_supply_himself_or_herself_Lbl }

    { 24  ;2   ;Column  ;in_atCaption        ;
               SourceExpr=in_atLbl }

    { 25  ;2   ;Column  ;Member_State_and_place_of_entry_as_part_of_the_transport_or_dispatch_of_the_object_Caption;
               SourceExpr=Member_State_and_place_of_entry_as_part_of_the_transport_or_dispatch_of_the_object_Lbl }

    { 26  ;2   ;Column  ;Date_of_issue_of_the_certificate_Caption;
               SourceExpr=Date_of_issue_of_the_certificate_Lbl }

    { 27  ;2   ;Column  ;Signature_of_the_customer_or_of_the_authorised_representative_as_well_as_the_signatory_s_name_in_capitals_Caption;
               SourceExpr=Signature_of_the_customer_or_of_the_authorised_representative_as_well_as_the_signatory_s_name_in_capitals_Lbl }

    { 28  ;2   ;Column  ;Reference_Document_Caption;
               SourceExpr=Reference_Document_Lbl }

    { 45  ;2   ;Column  ;Shipment_Method_Caption;
               SourceExpr=Shipment_Method_Lbl }

    { 19  ;2   ;Column  ;Vehicle_Registration_No_Caption;
               SourceExpr=Vehicle_Registration_No_Lbl }

    { 30  ;2   ;Column  ;Certification_of_the_entry_of_the_object_of_an_intra___Community_supply_into_another_Caption;
               SourceExpr=Certification_of_the_entry_of_the_object_of_an_intra___Community_supply_into_another_Lbl }

    { 31  ;2   ;Column  ;EU_Member_State__Entry_Certificate_Caption;
               SourceExpr=EU_Member_State__Entry_Certificate_Lbl }

    { 32  ;2   ;Column  ;Name_and_address_of_the_customer_of_the_intra_Community_supply__if_applicable__E_Mail_address_Caption;
               SourceExpr=Name_and_address_of_the_customer_of_the_intra_Community_supply__if_applicable__E_Mail_address_Lbl }

    { 33  ;2   ;Column  ;I_as_the_customer_hereby_certify_my_receipt_the_entry_of_the_following_object_of_an_intra___Community_supplyCaption;
               SourceExpr=I_as_the_customer_hereby_certify_my_receipt_the_entry_of_the_following_object_of_an_intra___Community_supplyLbl }

    { 1170000000;2;Column;on_Caption         ;
               SourceExpr=onLbl }

    { 1170000002;2;Column;Received_Caption   ;
               SourceExpr=receivedLbl }

    { 1170000003;2;Column;delete_As_Appropriate_Caption;
               SourceExpr=deleteAsAppropriateLbl }

    { 11  ;2   ;Column  ;No                  ;
               SourceExpr=TempServiceShipmentHeader."No." }

    { 10  ;2   ;Column  ;Bill_to_Name        ;
               SourceExpr=TempServiceShipmentHeader."Bill-to Name" }

    { 9   ;2   ;Column  ;Bill_to_Address     ;
               SourceExpr=TempServiceShipmentHeader."Bill-to Address" }

    { 8   ;2   ;Column  ;Bill_to_Address2    ;
               SourceExpr=TempServiceShipmentHeader."Bill-to Address 2" }

    { 7   ;2   ;Column  ;Bill_to_City        ;
               SourceExpr=TempServiceShipmentHeader."Bill-to City" }

    { 6   ;2   ;Column  ;Bill_To_CountryRegion_Code;
               SourceExpr=TempServiceShipmentHeader."Bill-to Country/Region Code" }

    { 5   ;2   ;Column  ;EMail               ;
               SourceExpr=TempServiceShipmentHeader."E-Mail" }

    { 4   ;2   ;Column  ;Ship_to_Address     ;
               SourceExpr=TempServiceShipmentHeader."Ship-to Address" }

    { 3   ;2   ;Column  ;Ship_to_Address2    ;
               SourceExpr=TempServiceShipmentHeader."Ship-to Address 2" }

    { 17  ;2   ;Column  ;Ship_to_City        ;
               SourceExpr=TempServiceShipmentHeader."Ship-to City" }

    { 2   ;2   ;Column  ;Ship_to_Country_Region_Code;
               SourceExpr=TempServiceShipmentHeader."Ship-to Country/Region Code" }

    { 1   ;2   ;Column  ;Ship_to_Name        ;
               SourceExpr=TempServiceShipmentHeader."Ship-to Name" }

    { 46  ;2   ;Column  ;Shipment_Method_Code;
               SourceExpr=CertificateOfSupply."Shipment Method Code" }

    { 47  ;2   ;Column  ;Vehicle_Registration_No;
               SourceExpr=CertificateOfSupply."Vehicle Registration No." }

    { 43  ;2   ;Column  ;PrintLineDetails    ;
               SourceExpr=PrintLineDetails }

    { 18  ;2   ;DataItem;<Integer2>          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 ORDER(Ascending)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               TempServiceShipmentLine.SETFILTER(Quantity,'<>%1',0);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempServiceShipmentLine.FINDSET THEN
                                      CurrReport.BREAK
                                  END ELSE
                                    IF TempServiceShipmentLine.NEXT = 0 THEN
                                      CurrReport.BREAK;
                                END;
                                 }

    { 39  ;3   ;Column  ;Item_No_Caption     ;
               SourceExpr=TempServiceShipmentLine.FIELDCAPTION("No.") }

    { 40  ;3   ;Column  ;Decription_Caption  ;
               SourceExpr=TempServiceShipmentLine.FIELDCAPTION(Description) }

    { 41  ;3   ;Column  ;Quantity_Caption    ;
               SourceExpr=TempServiceShipmentLine.FIELDCAPTION(Quantity) }

    { 42  ;3   ;Column  ;Unit_of_Measure_Caption;
               SourceExpr=TempServiceShipmentLine.FIELDCAPTION("Unit of Measure" ) }

    { 38  ;3   ;Column  ;Line_No             ;
               SourceExpr=TempServiceShipmentLine."Line No." }

    { 29  ;3   ;Column  ;Item_No             ;
               SourceExpr=TempServiceShipmentLine."No." }

    { 35  ;3   ;Column  ;Description         ;
               SourceExpr=TempServiceShipmentLine.Description }

    { 36  ;3   ;Column  ;Quantity            ;
               SourceExpr=TempServiceShipmentLine.Quantity }

    { 37  ;3   ;Column  ;Unit_of_Measure     ;
               SourceExpr=TempServiceShipmentLine."Unit of Measure Code" }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
    }
    CONTROLS
    {
      { 1   ;    ;Container ;
                  Name=Certificate Of Supply;
                  ContainerType=ContentArea }

      { 2   ;1   ;Field     ;
                  Name=PrintLineDetails;
                  CaptionML=[DAN=Udskriv linjedetaljer;
                             ENU=Print Line Details];
                  ToolTipML=[DAN=Angiver, om du �nsker oplysninger fra linjerne i forsendelsesdokument p� leveringscertifikatet.;
                             ENU=Specifies if you want to information from the lines on the shipment document on the certificate of supply.];
                  ApplicationArea=#Advanced;
                  SourceExpr=PrintLineDetails }

      { 3   ;1   ;Field     ;
                  Name=CreateCertificatesofSupply;
                  CaptionML=[DAN=Opret leveringscertifikater, hvis de ikke allerede er oprettet;
                             ENU=Create Certificates of Supply if Not Already Created];
                  ToolTipML=[DAN=Angiver, om du vil oprette et leveringscertifikat, n�r du s�lger varer til en debitor i et andet EU-land/-omr�de.;
                             ENU=Specifies if you want to create a certificate of supply, when you sell goods to a customer in another EU country/region.];
                  ApplicationArea=#Advanced;
                  SourceExpr=CreateCertificatesofSupply }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Quantity_of_the_object_of_the_supply_Lbl@1008 : TextConst 'DAN=(M�ngden af leveringsobjektet);ENU=(Quantity of the object of the supply)';
      Standard_commercial_description___in_the_case_of_vehicles__including_vehicle_identification_number_Lbl@1009 : TextConst 'DAN=(Kommerciel standardbeskrivelse - ved k�ret�jer skal k�ret�jets identifikationsnummer medtages);ENU=(Standard commercial description - in the case of vehicles, including vehicle identification number)';
      Date_the_object_of_the_supply_was_received_in_the_Member_State_of_entry_if_the_supplying_trader_transported_or_dispatched_theLbl@1100 : TextConst 'DAN=(Den dato, leveringsobjektet blev modtaget i indgangsmedlemsstaten, hvis leverand�ren transporterede eller sendte leveringsobjektet, eller hvis debitoren sendte leveringsobjektet);ENU=(Date the object of the supply was received in the Member State of entry if the supplying trader transported or dispatched the object of the supply or if the customer dispatched the object of the supply)';
      Date_the_transportation_ended_if_the_customer_transported_the_object_of_the_supply_himself_or_herself_Lbl@1155 : TextConst 'DAN=(Den dato, transporten sluttede, hvis debitoren selv transporterede leveringsobjektet);ENU=(Date the transportation ended if the customer transported the object of the supply himself or herself)';
      in_atLbl@1101 : TextConst 'DAN=i/p� 1);ENU=in/at 1)';
      Member_State_and_place_of_entry_as_part_of_the_transport_or_dispatch_of_the_object_Lbl@1102 : TextConst 'DAN=(Medlemsstat og indgangssted som en del af objektets transport eller forsendelse);ENU=(Member State and place of entry as part of the transport or dispatch of the object)';
      Date_of_issue_of_the_certificate_Lbl@1103 : TextConst 'DAN=(Datoen for udstedelsen af certifikatet);ENU=(Date of issue of the certificate)';
      Signature_of_the_customer_or_of_the_authorised_representative_as_well_as_the_signatory_s_name_in_capitals_Lbl@1104 : TextConst 'DAN=(Debitorens eller den bemyndigede repr�sentants underskrift samt underskriverens navn med store bogstaver);ENU=(Signature of the customer or of the authorised representative as well as the signatory''s name in capitals)';
      Reference_Document_Lbl@1105 : TextConst 'DAN=Forsendelse af referencedokument;ENU=Reference Document Shipment';
      Vehicle_Registration_No_Lbl@1011 : TextConst 'DAN=K�ret�jets registreringsnummer;ENU=Vehicle Registration No.';
      Shipment_Method_Lbl@1012 : TextConst 'DAN=Leveringsform;ENU=Shipment Method';
      Certification_of_the_entry_of_the_object_of_an_intra___Community_supply_into_another_Lbl@1106 : TextConst 'DAN="Certificering af indgangen af objektet for en levering inden for F�llesskabet til en anden ";ENU="Certification of the entry of the object of an intra - Community supply into another "';
      EU_Member_State__Entry_Certificate_Lbl@1107 : TextConst 'DAN=EU-medlemsstat (indgangscertifikat);ENU=EU Member State (Entry Certificate)';
      Name_and_address_of_the_customer_of_the_intra_Community_supply__if_applicable__E_Mail_address_Lbl@1108 : TextConst 'DAN=(Navn og adresse p� debitoren for leveringen inden for F�llesskabet, hvis relevant, mailadresse);ENU=(Name and address of the customer of the intra-Community supply, if applicable, Email-address)';
      I_as_the_customer_hereby_certify_my_receipt_the_entry_of_the_following_object_of_an_intra___Community_supplyLbl@1109 : TextConst 'DAN=Undertegnede debitor bekr�fter herved modtagelsen/indgangen af f�lgende objekt for en levering inden for F�llesskabet;ENU=I as the customer hereby certify my receipt/the entry of the following object of an intra - Community supply';
      TempServiceShipmentHeader@1000 : TEMPORARY Record 5990;
      TempServiceShipmentLine@1002 : TEMPORARY Record 5991;
      CompanyInfo@1001 : Record 79;
      PrintLineDetails@1003 : Boolean;
      onLbl@1004 : TextConst 'DAN=den;ENU=on';
      receivedLbl@1005 : TextConst 'DAN=modtaget/ankommet 1);ENU=received/arrived 1)';
      deleteAsAppropriateLbl@1006 : TextConst 'DAN=1) Slet efter behov;ENU=1) Delete as appropriate';
      MultipleDocumentsErr@1007 : TextConst 'DAN=Flere dokumenttyper er ikke tilladt.;ENU=Multiple Document Types are not allowed.';
      CreateCertificatesofSupply@1010 : Boolean;

    LOCAL PROCEDURE SetSource@5(CertificateOfSupply@1001 : Record 780);
    VAR
      SalesShipmentHeader@1002 : Record 110;
      ServiceShipmentHeader@1003 : Record 5990;
      ReturnShipmentHeader@1004 : Record 6650;
    BEGIN
      CASE CertificateOfSupply."Document Type" OF
        CertificateOfSupply."Document Type"::"Sales Shipment":
          BEGIN
            SalesShipmentHeader.GET(CertificateOfSupply."Document No.");
            SetSourceSales(SalesShipmentHeader);
          END;
        CertificateOfSupply."Document Type"::"Service Shipment":
          BEGIN
            ServiceShipmentHeader.GET(CertificateOfSupply."Document No.");
            SetSourceService(ServiceShipmentHeader);
          END;
        CertificateOfSupply."Document Type"::"Return Shipment":
          BEGIN
            ReturnShipmentHeader.GET(CertificateOfSupply."Document No.");
            SetSourcePurchase(ReturnShipmentHeader);
          END;
      END;
    END;

    LOCAL PROCEDURE SetSourceSales@1(SalesShipmentHeader@1000 : Record 110);
    VAR
      Customer@1001 : Record 18;
    BEGIN
      // bill to details
      Customer.GET(SalesShipmentHeader."Bill-to Customer No.");
      TempServiceShipmentHeader."Bill-to Name" := SalesShipmentHeader."Bill-to Name";
      TempServiceShipmentHeader."Bill-to Customer No." := SalesShipmentHeader."Bill-to Customer No.";
      TempServiceShipmentHeader."Bill-to Address" := SalesShipmentHeader."Bill-to Address";
      TempServiceShipmentHeader."Bill-to Address 2" := SalesShipmentHeader."Bill-to Address 2";
      TempServiceShipmentHeader."Bill-to City" := SalesShipmentHeader."Bill-to City";
      TempServiceShipmentHeader."Bill-to Country/Region Code" := SalesShipmentHeader."Bill-to Country/Region Code";
      TempServiceShipmentHeader."E-Mail" := Customer."E-Mail";
      TempServiceShipmentHeader."No." := SalesShipmentHeader."No.";

      // ship contact details
      TempServiceShipmentHeader."Ship-to Name" := SalesShipmentHeader."Ship-to Name";
      TempServiceShipmentHeader."Ship-to Address" := SalesShipmentHeader."Ship-to Address";
      TempServiceShipmentHeader."Ship-to Address 2" := SalesShipmentHeader."Ship-to Address 2";
      TempServiceShipmentHeader."Ship-to City" := SalesShipmentHeader."Ship-to City";
      TempServiceShipmentHeader."Ship-to Country/Region Code" := SalesShipmentHeader."Ship-to Country/Region Code";
    END;

    LOCAL PROCEDURE SetSourceService@3(ServiceShipmentHeader@1000 : Record 5990);
    BEGIN
      TempServiceShipmentHeader := ServiceShipmentHeader;
    END;

    LOCAL PROCEDURE SetSourcePurchase@4(ReturnShipmentHeader@1000 : Record 6650);
    VAR
      Vendor@1001 : Record 23;
    BEGIN
      Vendor.GET(ReturnShipmentHeader."Buy-from Vendor No.");

      // bill to details
      TempServiceShipmentHeader."Bill-to Name" := ReturnShipmentHeader."Buy-from Vendor Name";
      TempServiceShipmentHeader."Bill-to Address" := ReturnShipmentHeader."Buy-from Address";
      TempServiceShipmentHeader."Bill-to Address 2" := ReturnShipmentHeader."Buy-from Address 2";
      TempServiceShipmentHeader."Bill-to City" := ReturnShipmentHeader."Buy-from City";
      TempServiceShipmentHeader."Bill-to Country/Region Code" := ReturnShipmentHeader."Buy-from Country/Region Code";
      TempServiceShipmentHeader."E-Mail" := Vendor."E-Mail";
      TempServiceShipmentHeader."No." := ReturnShipmentHeader."No.";

      // ship contact details
      TempServiceShipmentHeader."Ship-to Name" := ReturnShipmentHeader."Ship-to Name";
      TempServiceShipmentHeader."Ship-to Address" := ReturnShipmentHeader."Ship-to Address";
      TempServiceShipmentHeader."Ship-to Address 2" := ReturnShipmentHeader."Ship-to Address 2";
      TempServiceShipmentHeader."Ship-to City" := ReturnShipmentHeader."Ship-to City";
      TempServiceShipmentHeader."Ship-to Country/Region Code" := ReturnShipmentHeader."Ship-to Country/Region Code";
    END;

    LOCAL PROCEDURE IsReportInPreviewMode@9() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    LOCAL PROCEDURE GetLines@11(CertificateOfSupply@1001 : Record 780);
    VAR
      SalesShipmentHeader@1002 : Record 110;
      ServiceShipmentHeader@1003 : Record 5990;
      ReturnShipmentHeader@1004 : Record 6650;
    BEGIN
      CASE CertificateOfSupply."Document Type" OF
        CertificateOfSupply."Document Type"::"Sales Shipment":
          BEGIN
            SalesShipmentHeader.GET(CertificateOfSupply."Document No.");
            GetSalesLines(SalesShipmentHeader."No.");
          END;
        CertificateOfSupply."Document Type"::"Service Shipment":
          BEGIN
            ServiceShipmentHeader.GET(CertificateOfSupply."Document No.");
            GetServiceLines(ServiceShipmentHeader."No.");
          END;
        CertificateOfSupply."Document Type"::"Return Shipment":
          BEGIN
            ReturnShipmentHeader.GET(CertificateOfSupply."Document No.");
            GetPurchaseLines(ReturnShipmentHeader."No.");
          END;
      END;
      TempServiceShipmentLine.FINDSET;
    END;

    LOCAL PROCEDURE GetSalesLines@2(SalesShipmentHeaderNo@1000 : Code[20]);
    VAR
      SalesShipmentLine@1001 : Record 111;
    BEGIN
      SalesShipmentLine.SETRANGE("Document No.",SalesShipmentHeaderNo);
      IF SalesShipmentLine.FINDSET THEN
        REPEAT
          TempServiceShipmentLine."Line No." := SalesShipmentLine."Line No.";
          TempServiceShipmentLine."No." := SalesShipmentLine."No.";
          TempServiceShipmentLine.Description := SalesShipmentLine.Description;
          TempServiceShipmentLine.Quantity := SalesShipmentLine.Quantity;
          TempServiceShipmentLine."Unit of Measure Code" := SalesShipmentLine."Unit of Measure";
          TempServiceShipmentLine.INSERT;
        UNTIL SalesShipmentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetServiceLines@6(ServiceShipmentHeaderNo@1001 : Code[20]);
    VAR
      ServiceShipmentLine@1000 : Record 5991;
    BEGIN
      ServiceShipmentLine.SETRANGE("Document No.",ServiceShipmentHeaderNo);
      IF ServiceShipmentLine.FINDSET THEN
        REPEAT
          TempServiceShipmentLine := ServiceShipmentLine;
          TempServiceShipmentLine.INSERT;
        UNTIL ServiceShipmentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetPurchaseLines@7(ReturnShipmentHeaderNo@1000 : Code[20]);
    VAR
      ReturnShipmentLine@1001 : Record 6651;
    BEGIN
      ReturnShipmentLine.SETRANGE("Document No.",ReturnShipmentHeaderNo);
      IF ReturnShipmentLine.FINDSET THEN
        REPEAT
          TempServiceShipmentLine."Line No." := ReturnShipmentLine."Line No.";
          TempServiceShipmentLine."No." := ReturnShipmentLine."No.";
          TempServiceShipmentLine.Description := ReturnShipmentLine.Description;
          TempServiceShipmentLine.Quantity := ReturnShipmentLine.Quantity;
          TempServiceShipmentLine."Unit of Measure Code" := ReturnShipmentLine."Unit of Measure";
          TempServiceShipmentLine.INSERT;
        UNTIL ReturnShipmentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetLanguageCode@8(CertificateOfSupply@1004 : Record 780) : Code[10];
    VAR
      SalesShipmentHeader@1003 : Record 110;
      ServiceShipmentHeader@1002 : Record 5990;
      ReturnShipmentHeader@1001 : Record 6650;
    BEGIN
      CASE CertificateOfSupply."Document Type" OF
        CertificateOfSupply."Document Type"::"Sales Shipment":
          BEGIN
            SalesShipmentHeader.GET(CertificateOfSupply."Document No.");
            EXIT(SalesShipmentHeader."Language Code");
          END;
        CertificateOfSupply."Document Type"::"Service Shipment":
          BEGIN
            ServiceShipmentHeader.GET(CertificateOfSupply."Document No.");
            EXIT(ServiceShipmentHeader."Language Code");
          END;
        CertificateOfSupply."Document Type"::"Return Shipment":
          BEGIN
            ReturnShipmentHeader.GET(CertificateOfSupply."Document No.");
            EXIT(ReturnShipmentHeader."Language Code");
          END;
      END;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
    <?xml version="1.0" encoding="utf-8"?>
<Report xmlns="http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner">
  <AutoRefresh>0</AutoRefresh>
  <DataSources>
    <DataSource Name="DataSource">
      <ConnectionProperties>
        <DataProvider>SQL</DataProvider>
        <ConnectString />
      </ConnectionProperties>
      <rd:SecurityType>None</rd:SecurityType>
      <rd:DataSourceID>8e0a86be-aaa3-455a-a881-4a5cdb69d361</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="FORMAT_TODAY_0_4_">
          <DataField>FORMAT_TODAY_0_4_</DataField>
        </Field>
        <Field Name="COMPANYNAME">
          <DataField>COMPANYNAME</DataField>
        </Field>
        <Field Name="COMPANYADDRESS">
          <DataField>COMPANYADDRESS</DataField>
        </Field>
        <Field Name="COMPANYADDRESS2">
          <DataField>COMPANYADDRESS2</DataField>
        </Field>
        <Field Name="COMPANYCITY">
          <DataField>COMPANYCITY</DataField>
        </Field>
        <Field Name="COMPANYCOUNTRYCODE">
          <DataField>COMPANYCOUNTRYCODE</DataField>
        </Field>
        <Field Name="Quantity_of_the_object_of_the_supply_Caption">
          <DataField>Quantity_of_the_object_of_the_supply_Caption</DataField>
        </Field>
        <Field Name="Standard_commercial_description___in_the_case_of_vehicles__including_vehicle_identification_number_Caption">
          <DataField>Standard_commercial_description___in_the_case_of_vehicles__including_vehicle_identification_number_Caption</DataField>
        </Field>
        <Field Name="Date_the_object_of_the_supply_was_received_in_the_Member_State_of_entry_if_the_supplying_trader_transported_or_dispatched_theCaption">
          <DataField>Date_the_object_of_the_supply_was_received_in_the_Member_State_of_entry_if_the_supplying_trader_transported_or_dispatched_theCaption</DataField>
        </Field>
        <Field Name="Date_the_transportation_ended_if_the_customer_transported_the_object_of_the_supply_himself_or_herself_Caption">
          <DataField>Date_the_transportation_ended_if_the_customer_transported_the_object_of_the_supply_himself_or_herself_Caption</DataField>
        </Field>
        <Field Name="in_atCaption">
          <DataField>in_atCaption</DataField>
        </Field>
        <Field Name="Member_State_and_place_of_entry_as_part_of_the_transport_or_dispatch_of_the_object_Caption">
          <DataField>Member_State_and_place_of_entry_as_part_of_the_transport_or_dispatch_of_the_object_Caption</DataField>
        </Field>
        <Field Name="Date_of_issue_of_the_certificate_Caption">
          <DataField>Date_of_issue_of_the_certificate_Caption</DataField>
        </Field>
        <Field Name="Signature_of_the_customer_or_of_the_authorised_representative_as_well_as_the_signatory_s_name_in_capitals_Caption">
          <DataField>Signature_of_the_customer_or_of_the_authorised_representative_as_well_as_the_signatory_s_name_in_capitals_Caption</DataField>
        </Field>
        <Field Name="Reference_Document_Caption">
          <DataField>Reference_Document_Caption</DataField>
        </Field>
        <Field Name="Shipment_Method_Caption">
          <DataField>Shipment_Method_Caption</DataField>
        </Field>
        <Field Name="Vehicle_Registration_No_Caption">
          <DataField>Vehicle_Registration_No_Caption</DataField>
        </Field>
        <Field Name="Certification_of_the_entry_of_the_object_of_an_intra___Community_supply_into_another_Caption">
          <DataField>Certification_of_the_entry_of_the_object_of_an_intra___Community_supply_into_another_Caption</DataField>
        </Field>
        <Field Name="EU_Member_State__Entry_Certificate_Caption">
          <DataField>EU_Member_State__Entry_Certificate_Caption</DataField>
        </Field>
        <Field Name="Name_and_address_of_the_customer_of_the_intra_Community_supply__if_applicable__E_Mail_address_Caption">
          <DataField>Name_and_address_of_the_customer_of_the_intra_Community_supply__if_applicable__E_Mail_address_Caption</DataField>
        </Field>
        <Field Name="I_as_the_customer_hereby_certify_my_receipt_the_entry_of_the_following_object_of_an_intra___Community_supplyCaption">
          <DataField>I_as_the_customer_hereby_certify_my_receipt_the_entry_of_the_following_object_of_an_intra___Community_supplyCaption</DataField>
        </Field>
        <Field Name="on_Caption">
          <DataField>on_Caption</DataField>
        </Field>
        <Field Name="Received_Caption">
          <DataField>Received_Caption</DataField>
        </Field>
        <Field Name="delete_As_Appropriate_Caption">
          <DataField>delete_As_Appropriate_Caption</DataField>
        </Field>
        <Field Name="No">
          <DataField>No</DataField>
        </Field>
        <Field Name="Bill_to_Name">
          <DataField>Bill_to_Name</DataField>
        </Field>
        <Field Name="Bill_to_Address">
          <DataField>Bill_to_Address</DataField>
        </Field>
        <Field Name="Bill_to_Address2">
          <DataField>Bill_to_Address2</DataField>
        </Field>
        <Field Name="Bill_to_City">
          <DataField>Bill_to_City</DataField>
        </Field>
        <Field Name="Bill_To_CountryRegion_Code">
          <DataField>Bill_To_CountryRegion_Code</DataField>
        </Field>
        <Field Name="EMail">
          <DataField>EMail</DataField>
        </Field>
        <Field Name="Ship_to_Address">
          <DataField>Ship_to_Address</DataField>
        </Field>
        <Field Name="Ship_to_Address2">
          <DataField>Ship_to_Address2</DataField>
        </Field>
        <Field Name="Ship_to_City">
          <DataField>Ship_to_City</DataField>
        </Field>
        <Field Name="Ship_to_Country_Region_Code">
          <DataField>Ship_to_Country_Region_Code</DataField>
        </Field>
        <Field Name="Ship_to_Name">
          <DataField>Ship_to_Name</DataField>
        </Field>
        <Field Name="Shipment_Method_Code">
          <DataField>Shipment_Method_Code</DataField>
        </Field>
        <Field Name="Vehicle_Registration_No">
          <DataField>Vehicle_Registration_No</DataField>
        </Field>
        <Field Name="PrintLineDetails">
          <DataField>PrintLineDetails</DataField>
        </Field>
        <Field Name="Item_No_Caption">
          <DataField>Item_No_Caption</DataField>
        </Field>
        <Field Name="Decription_Caption">
          <DataField>Decription_Caption</DataField>
        </Field>
        <Field Name="Quantity_Caption">
          <DataField>Quantity_Caption</DataField>
        </Field>
        <Field Name="Unit_of_Measure_Caption">
          <DataField>Unit_of_Measure_Caption</DataField>
        </Field>
        <Field Name="Line_No">
          <DataField>Line_No</DataField>
        </Field>
        <Field Name="Item_No">
          <DataField>Item_No</DataField>
        </Field>
        <Field Name="Description">
          <DataField>Description</DataField>
        </Field>
        <Field Name="Quantity">
          <DataField>Quantity</DataField>
        </Field>
        <Field Name="QuantityFormat">
          <DataField>QuantityFormat</DataField>
        </Field>
        <Field Name="Unit_of_Measure">
          <DataField>Unit_of_Measure</DataField>
        </Field>
      </Fields>
      <rd:DataSetInfo>
        <rd:DataSetName>DataSet</rd:DataSetName>
        <rd:SchemaPath>Report.xsd</rd:SchemaPath>
        <rd:TableName>Result</rd:TableName>
      </rd:DataSetInfo>
    </DataSet>
  </DataSets>
  <ReportSections>
    <ReportSection>
      <Body>
        <ReportItems>
          <Tablix Name="table1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>0.625in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.375in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.625in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.5in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.5in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.5in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="COMPANYNAME">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!COMPANYNAME.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>COMPANYNAME</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox1</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox13">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox13</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox67">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!COMPANYADDRESS.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox29">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox29</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox4">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox4</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox6">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!COMPANYADDRESS2.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox6</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox26">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox26</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox31">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox31</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox39">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox39</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox70">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!COMPANYCITY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox3">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox3</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox41">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox41</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox32">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!COMPANYCOUNTRYCODE.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox32</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox42">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox42</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox44">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox44</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox45">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox45</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox11">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox11</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox12">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox12</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox14">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox14</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox15">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox15</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox28">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox28</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox30">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox30</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox61">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Certification_of_the_entry_of_the_object_of_an_intra___Community_supply_into_another_Caption.Value</Value>
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox55">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EU_Member_State__Entry_Certificate_Caption.Value</Value>
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox5">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox5</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox58">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>= " " + Code.FormatAddress(Fields!Bill_to_Name.Value,Fields!Bill_to_Address.Value,Fields!Bill_to_Address2.Value,Fields!Bill_to_City.Value,Fields!Bill_To_CountryRegion_Code.Value) + " " + Fields!EMail.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox43">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Name_and_address_of_the_customer_of_the_intra_Community_supply__if_applicable__E_Mail_address_Caption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
                            <BottomBorder>
                              <Style>None</Style>
                              <Width>1pt</Width>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox2</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox7">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox7</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox8">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox8</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox9">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox9</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox10">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox10</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox18">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox18</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox46">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!I_as_the_customer_hereby_certify_my_receipt_the_entry_of_the_following_object_of_an_intra___Community_supplyCaption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox24">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox24</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox33">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox33</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox34">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox34</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox35">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox35</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox36">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox36</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox54">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox54</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox37">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Reference_Document_Caption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox38">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!No.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox17">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox17</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox88">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox88</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.6cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Shipment_Method_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Shipment_Method_Caption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Shipment_Method_Caption</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Shipment_Method_Code">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Shipment_Method_Code.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Shipment_Method_Code</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Shipment_Code">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vehicle_Registration_No_Caption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Shipment_Code</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Vehicle_Registration_No">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vehicle_Registration_No.Value</Value>
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Vehicle_Registration_No</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.63898in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Tablix Name="Tablix2">
                          <TablixBody>
                            <TablixColumns>
                              <TablixColumn>
                                <Width>1.88333in</Width>
                              </TablixColumn>
                              <TablixColumn>
                                <Width>2.86875in</Width>
                              </TablixColumn>
                              <TablixColumn>
                                <Width>0.84167in</Width>
                              </TablixColumn>
                              <TablixColumn>
                                <Width>1.49999in</Width>
                              </TablixColumn>
                            </TablixColumns>
                            <TablixRows>
                              <TablixRow>
                                <Height>0.21299in</Height>
                                <TablixCells>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Textbox197">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value />
                                                <Style />
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Textbox197</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Color>LightGrey</Color>
                                            <Style>None</Style>
                                          </Border>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Textbox198">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value />
                                                <Style />
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Textbox198</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Color>LightGrey</Color>
                                            <Style>None</Style>
                                          </Border>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Textbox199">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value />
                                                <Style />
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Textbox199</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Color>LightGrey</Color>
                                            <Style>None</Style>
                                          </Border>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Textbox200">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value />
                                                <Style />
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Textbox200</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Color>LightGrey</Color>
                                            <Style>None</Style>
                                          </Border>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                </TablixCells>
                              </TablixRow>
                              <TablixRow>
                                <Height>0.21299in</Height>
                                <TablixCells>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Item_No_Caption">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value>=First(Fields!Item_No_Caption.Value)</Value>
                                                <Style>
                                                  <FontSize>9pt</FontSize>
                                                </Style>
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Item_No_Caption</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Style>None</Style>
                                          </Border>
                                          <BottomBorder>
                                            <Style>Solid</Style>
                                          </BottomBorder>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Decription_Caption">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value>=First(Fields!Decription_Caption.Value)</Value>
                                                <Style>
                                                  <FontSize>9pt</FontSize>
                                                </Style>
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Decription_Caption</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Style>None</Style>
                                          </Border>
                                          <BottomBorder>
                                            <Style>Solid</Style>
                                          </BottomBorder>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Quantity_Caption">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value>=First(Fields!Quantity_Caption.Value)</Value>
                                                <Style>
                                                  <FontSize>9pt</FontSize>
                                                </Style>
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Quantity_Caption</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Style>None</Style>
                                          </Border>
                                          <BottomBorder>
                                            <Style>Solid</Style>
                                          </BottomBorder>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Unit_of_Measure_Caption">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value>=First(Fields!Unit_of_Measure_Caption.Value)</Value>
                                                <Style>
                                                  <FontSize>9pt</FontSize>
                                                </Style>
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Unit_of_Measure_Caption</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Style>None</Style>
                                          </Border>
                                          <BottomBorder>
                                            <Style>Solid</Style>
                                          </BottomBorder>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                </TablixCells>
                              </TablixRow>
                              <TablixRow>
                                <Height>0.21299in</Height>
                                <TablixCells>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Item_No">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value>=Fields!Item_No.Value</Value>
                                                <Style>
                                                  <FontSize>9pt</FontSize>
                                                </Style>
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Item_No</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Color>LightGrey</Color>
                                            <Style>None</Style>
                                          </Border>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Description">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value>=Fields!Description.Value</Value>
                                                <Style>
                                                  <FontSize>9pt</FontSize>
                                                </Style>
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Description</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Color>LightGrey</Color>
                                            <Style>None</Style>
                                          </Border>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Quantity">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value>=Code.BlankZero(Fields!Quantity.Value)</Value>
                                                <Style>
                                                  <FontSize>9pt</FontSize>
                                                </Style>
                                              </TextRun>
                                            </TextRuns>
                                            <Style>
                                              <TextAlign>Left</TextAlign>
                                            </Style>
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Quantity</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Color>LightGrey</Color>
                                            <Style>None</Style>
                                          </Border>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Unit_of_Measure">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value>=Fields!Unit_of_Measure.Value</Value>
                                                <Style>
                                                  <FontSize>9pt</FontSize>
                                                </Style>
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Unit_of_Measure</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Color>LightGrey</Color>
                                            <Style>None</Style>
                                          </Border>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                    </CellContents>
                                  </TablixCell>
                                </TablixCells>
                              </TablixRow>
                            </TablixRows>
                          </TablixBody>
                          <TablixColumnHierarchy>
                            <TablixMembers>
                              <TablixMember />
                              <TablixMember />
                              <TablixMember />
                              <TablixMember />
                            </TablixMembers>
                          </TablixColumnHierarchy>
                          <TablixRowHierarchy>
                            <TablixMembers>
                              <TablixMember>
                                <TablixHeader>
                                  <Size>0.03125in</Size>
                                  <CellContents>
                                    <Textbox Name="Textbox196">
                                      <CanGrow>true</CanGrow>
                                      <KeepTogether>true</KeepTogether>
                                      <Paragraphs>
                                        <Paragraph>
                                          <TextRuns>
                                            <TextRun>
                                              <Value />
                                              <Style />
                                            </TextRun>
                                          </TextRuns>
                                          <Style />
                                        </Paragraph>
                                      </Paragraphs>
                                      <rd:DefaultName>Textbox196</rd:DefaultName>
                                      <Style>
                                        <Border>
                                          <Color>LightGrey</Color>
                                          <Style>None</Style>
                                        </Border>
                                        <PaddingLeft>2pt</PaddingLeft>
                                        <PaddingRight>2pt</PaddingRight>
                                        <PaddingTop>2pt</PaddingTop>
                                        <PaddingBottom>2pt</PaddingBottom>
                                      </Style>
                                    </Textbox>
                                  </CellContents>
                                </TablixHeader>
                                <KeepWithGroup>After</KeepWithGroup>
                              </TablixMember>
                              <TablixMember>
                                <TablixHeader>
                                  <Size>0.03125in</Size>
                                  <CellContents>
                                    <Textbox Name="Textbox195">
                                      <CanGrow>true</CanGrow>
                                      <KeepTogether>true</KeepTogether>
                                      <Paragraphs>
                                        <Paragraph>
                                          <TextRuns>
                                            <TextRun>
                                              <Value />
                                              <Style />
                                            </TextRun>
                                          </TextRuns>
                                          <Style />
                                        </Paragraph>
                                      </Paragraphs>
                                      <rd:DefaultName>Textbox195</rd:DefaultName>
                                      <Style>
                                        <Border>
                                          <Color>LightGrey</Color>
                                          <Style>None</Style>
                                        </Border>
                                        <PaddingLeft>2pt</PaddingLeft>
                                        <PaddingRight>2pt</PaddingRight>
                                        <PaddingTop>2pt</PaddingTop>
                                        <PaddingBottom>2pt</PaddingBottom>
                                      </Style>
                                    </Textbox>
                                  </CellContents>
                                </TablixHeader>
                                <TablixMembers>
                                  <TablixMember />
                                </TablixMembers>
                                <KeepWithGroup>After</KeepWithGroup>
                              </TablixMember>
                              <TablixMember>
                                <Group Name="Group1">
                                  <GroupExpressions>
                                    <GroupExpression>=Fields!Line_No.Value</GroupExpression>
                                  </GroupExpressions>
                                </Group>
                                <SortExpressions>
                                  <SortExpression>
                                    <Value>=Fields!Line_No.Value</Value>
                                  </SortExpression>
                                </SortExpressions>
                                <TablixHeader>
                                  <Size>0.03125in</Size>
                                  <CellContents>
                                    <Textbox Name="Group1">
                                      <CanGrow>true</CanGrow>
                                      <KeepTogether>true</KeepTogether>
                                      <Paragraphs>
                                        <Paragraph>
                                          <TextRuns>
                                            <TextRun>
                                              <Value>=Fields!Line_No.Value</Value>
                                              <Style />
                                            </TextRun>
                                          </TextRuns>
                                          <Style />
                                        </Paragraph>
                                      </Paragraphs>
                                      <rd:DefaultName>Group1</rd:DefaultName>
                                      <Visibility>
                                        <Hidden>true</Hidden>
                                      </Visibility>
                                      <Style>
                                        <Border>
                                          <Color>LightGrey</Color>
                                          <Style>None</Style>
                                        </Border>
                                        <PaddingLeft>2pt</PaddingLeft>
                                        <PaddingRight>2pt</PaddingRight>
                                        <PaddingTop>2pt</PaddingTop>
                                        <PaddingBottom>2pt</PaddingBottom>
                                      </Style>
                                    </Textbox>
                                  </CellContents>
                                </TablixHeader>
                                <TablixMembers>
                                  <TablixMember>
                                    <Group Name="Details" />
                                    <TablixMembers>
                                      <TablixMember />
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixMember>
                            </TablixMembers>
                          </TablixRowHierarchy>
                          <KeepTogether>true</KeepTogether>
                          <DataSetName>DataSet_Result</DataSetName>
                          <Visibility>
                            <Hidden>=NOT Fields!PrintLineDetails.Value</Hidden>
                          </Visibility>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                          </Style>
                        </Tablix>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.9201in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Tablix Name="Tablix5">
                          <TablixBody>
                            <TablixColumns>
                              <TablixColumn>
                                <Width>3.53125in</Width>
                              </TablixColumn>
                              <TablixColumn>
                                <Width>1.78125in</Width>
                              </TablixColumn>
                              <TablixColumn>
                                <Width>1.78125in</Width>
                              </TablixColumn>
                            </TablixColumns>
                            <TablixRows>
                              <TablixRow>
                                <Height>0.23003in</Height>
                                <TablixCells>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="textbox15">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value />
                                                <Style />
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>textbox13</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Style>None</Style>
                                          </Border>
                                          <BottomBorder>
                                            <Color>Black</Color>
                                            <Style>Solid</Style>
                                          </BottomBorder>
                                          <PaddingLeft>1pt</PaddingLeft>
                                          <PaddingRight>1pt</PaddingRight>
                                          <PaddingTop>1pt</PaddingTop>
                                          <PaddingBottom>1pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                      <ColSpan>3</ColSpan>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell />
                                  <TablixCell />
                                </TablixCells>
                              </TablixRow>
                              <TablixRow>
                                <Height>0.23003in</Height>
                                <TablixCells>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="textbox41">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value>=Fields!Quantity_of_the_object_of_the_supply_Caption.Value</Value>
                                                <Style>
                                                  <FontSize>9pt</FontSize>
                                                </Style>
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <Style>
                                          <TopBorder>
                                            <Color>Black</Color>
                                            <Style>Solid</Style>
                                          </TopBorder>
                                          <PaddingLeft>1pt</PaddingLeft>
                                          <PaddingRight>1pt</PaddingRight>
                                          <PaddingTop>1pt</PaddingTop>
                                          <PaddingBottom>1pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                      <ColSpan>3</ColSpan>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell />
                                  <TablixCell />
                                </TablixCells>
                              </TablixRow>
                              <TablixRow>
                                <Height>0.23003in</Height>
                                <TablixCells>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="Textbox216">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value />
                                                <Style />
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <rd:DefaultName>Textbox216</rd:DefaultName>
                                        <Style>
                                          <Border>
                                            <Style>None</Style>
                                          </Border>
                                          <BottomBorder>
                                            <Color>Black</Color>
                                            <Style>Solid</Style>
                                          </BottomBorder>
                                          <PaddingLeft>2pt</PaddingLeft>
                                          <PaddingRight>2pt</PaddingRight>
                                          <PaddingTop>2pt</PaddingTop>
                                          <PaddingBottom>2pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                      <ColSpan>3</ColSpan>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell />
                                  <TablixCell />
                                </TablixCells>
                              </TablixRow>
                              <TablixRow>
                                <Height>0.23003in</Height>
                                <TablixCells>
                                  <TablixCell>
                                    <CellContents>
                                      <Textbox Name="textbox32">
                                        <CanGrow>true</CanGrow>
                                        <KeepTogether>true</KeepTogether>
                                        <Paragraphs>
                                          <Paragraph>
                                            <TextRuns>
                                              <TextRun>
                                                <Value>=Fields!Standard_commercial_description___in_the_case_of_vehicles__including_vehicle_identification_number_Caption.Value</Value>
                                                <Style>
                                                  <FontSize>9pt</FontSize>
                                                </Style>
                                              </TextRun>
                                            </TextRuns>
                                            <Style />
                                          </Paragraph>
                                        </Paragraphs>
                                        <Style>
                                          <PaddingLeft>1pt</PaddingLeft>
                                          <PaddingRight>1pt</PaddingRight>
                                          <PaddingTop>1pt</PaddingTop>
                                          <PaddingBottom>1pt</PaddingBottom>
                                        </Style>
                                      </Textbox>
                                      <ColSpan>3</ColSpan>
                                    </CellContents>
                                  </TablixCell>
                                  <TablixCell />
                                  <TablixCell />
                                </TablixCells>
                              </TablixRow>
                            </TablixRows>
                          </TablixBody>
                          <TablixColumnHierarchy>
                            <TablixMembers>
                              <TablixMember />
                              <TablixMember />
                              <TablixMember />
                            </TablixMembers>
                          </TablixColumnHierarchy>
                          <TablixRowHierarchy>
                            <TablixMembers>
                              <TablixMember>
                                <Group Name="Group2">
                                  <GroupExpressions>
                                    <GroupExpression>=Fields!No.Value</GroupExpression>
                                  </GroupExpressions>
                                </Group>
                                <SortExpressions>
                                  <SortExpression>
                                    <Value>=Fields!No.Value</Value>
                                  </SortExpression>
                                </SortExpressions>
                                <TablixHeader>
                                  <Size>0.03125in</Size>
                                  <CellContents>
                                    <Textbox Name="Group2">
                                      <CanGrow>true</CanGrow>
                                      <KeepTogether>true</KeepTogether>
                                      <Paragraphs>
                                        <Paragraph>
                                          <TextRuns>
                                            <TextRun>
                                              <Value>=Fields!No.Value</Value>
                                              <Style />
                                            </TextRun>
                                          </TextRuns>
                                          <Style />
                                        </Paragraph>
                                      </Paragraphs>
                                      <rd:DefaultName>Group2</rd:DefaultName>
                                      <Visibility>
                                        <Hidden>true</Hidden>
                                      </Visibility>
                                      <Style>
                                        <Border>
                                          <Style>None</Style>
                                        </Border>
                                        <BottomBorder>
                                          <Style>Solid</Style>
                                        </BottomBorder>
                                        <PaddingLeft>1pt</PaddingLeft>
                                        <PaddingRight>1pt</PaddingRight>
                                        <PaddingTop>1pt</PaddingTop>
                                        <PaddingBottom>1pt</PaddingBottom>
                                      </Style>
                                    </Textbox>
                                  </CellContents>
                                </TablixHeader>
                                <TablixMembers>
                                  <TablixMember>
                                    <Group Name="Details1">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!No.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixMember>
                            </TablixMembers>
                          </TablixRowHierarchy>
                          <Visibility>
                            <Hidden>=Fields!PrintLineDetails.Value</Hidden>
                          </Visibility>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                          </Style>
                        </Tablix>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="on_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!on_Caption.Value</Value>
                                  <Style>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>on_Caption</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                        <rd:Selected>true</rd:Selected>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox56">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox56</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox57">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox57</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox59">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox59</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox16">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox16</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox23">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox23</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox40">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox40</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox47">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox47</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox48">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox48</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox49">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox49</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox25">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Date_the_object_of_the_supply_was_received_in_the_Member_State_of_entry_if_the_supplying_trader_transported_or_dispatched_theCaption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox101">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox101</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox102">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox102</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox103">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox103</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox104">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox104</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox105">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox105</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox106">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox106</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox62">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox62</rd:DefaultName>
                          <Style>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.25in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Date_the_transportation_ended_if_the_customer_transported_the_object_of_the_supply_himself_or_herself_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Date_the_transportation_ended_if_the_customer_transported_the_object_of_the_supply_himself_or_herself_Caption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Date_the_transportation_ended_if_the_customer_transported_the_object_of_the_supply_himself_or_herself_Caption</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="in_atCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!in_atCaption.Value</Value>
                                  <Style>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>in_atCaption</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox50">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox50</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox20">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox21">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox75">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox75</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox27">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox27</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox94">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox94</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox69">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>= " " + Code.FormatAddress(Fields!Ship_to_Name.Value,Fields!Ship_to_Address.Value,Fields!Ship_to_Address2.Value,Fields!Ship_to_City.Value,Fields!Ship_to_Country_Region_Code.Value)</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox69</rd:DefaultName>
                          <Style>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox22">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Member_State_and_place_of_entry_as_part_of_the_transport_or_dispatch_of_the_object_Caption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Received_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Received_Caption.Value</Value>
                                  <Style>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Received_Caption</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox51">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox51</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox52">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox52</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox60">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox60</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox63">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox63</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox64">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox64</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox65">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox65</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox79">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox79</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox80">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox80</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox81">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox81</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox82">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox82</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox83">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox83</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox84">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox84</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox78">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!FORMAT_TODAY_0_4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox78</rd:DefaultName>
                          <Style>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Date_of_issue_of_the_certificate_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Date_of_issue_of_the_certificate_Caption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Date_of_issue_of_the_certificate_Caption</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox113">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox113</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox114">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox114</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox115">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox115</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox116">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox116</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox117">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox117</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox118">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox118</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox87">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox87</rd:DefaultName>
                          <Style>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Signature_of_the_customer_or_of_the_authorised_representative_as_well_as_the_signatory_s_name_in_capitals_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Signature_of_the_customer_or_of_the_authorised_representative_as_well_as_the_signatory_s_name_in_capitals_Caption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Signature_of_the_customer_or_of_the_authorised_representative_as_well_as_the_signatory_s_name_in_capitals_Caption</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox90">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox90</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox91">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox91</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox92">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox92</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox93">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox93</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox95">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox95</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox96">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox96</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.23622in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="delete_As_Appropriate_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!delete_As_Appropriate_Caption.Value</Value>
                                  <Style>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>delete_As_Appropriate_Caption</rd:DefaultName>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>1pt</PaddingRight>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>6</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
              </TablixRows>
            </TablixBody>
            <TablixColumnHierarchy>
              <TablixMembers>
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
              </TablixMembers>
            </TablixColumnHierarchy>
            <TablixRowHierarchy>
              <TablixMembers>
                <TablixMember>
                  <Group Name="table1_Details_Group">
                    <GroupExpressions>
                      <GroupExpression>=Fields!No.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>End</BreakLocation>
                    </PageBreak>
                    <DataElementName>Detail</DataElementName>
                  </Group>
                  <TablixMembers>
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                    <TablixMember />
                  </TablixMembers>
                  <DataElementName>Detail_Collection</DataElementName>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Height>21.45528cm</Height>
            <Width>18.0975cm</Width>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>22.05528cm</Height>
        <Style />
      </Body>
      <Width>18.0975cm</Width>
      <Page>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveWidth>29.65cm</InteractiveWidth>
        <LeftMargin>1.5cm</LeftMargin>
        <RightMargin>1.2cm</RightMargin>
        <TopMargin>2cm</TopMargin>
        <BottomMargin>2cm</BottomMargin>
        <Style />
      </Page>
    </ReportSection>
  </ReportSections>
  <Code>Public Function BlankZero(ByVal Value As Decimal)
    if Value = 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankPos(ByVal Value As Decimal)
    if Value &gt; 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankZeroAndPos(ByVal Value As Decimal)
    if Value &gt;= 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankNeg(ByVal Value As Decimal)
    if Value &lt; 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankNegAndZero(ByVal Value As Decimal)
    if Value &lt;= 0 then
        Return ""
    end if
    Return Value
End Function

Public Function FormatAddress(ByVal Name As String,ByVal Address As String,ByVal Address2 As String,ByVal City As String,ByVal Country As String)
        Dim FullAddress as String
        FullAddress = Name
    if  Address &lt;&gt; "" then
                FullAddress = FullAddress + ", " + Address 
    end if
        if  Address2 &lt;&gt; "" then
                FullAddress = FullAddress + ", " + Address2 
    end if
        if  City &lt;&gt; "" then
                FullAddress = FullAddress + ", " + City 
        end if          
        if  Country &lt;&gt; "" then
                FullAddress = FullAddress + ", " + Country      
    end if
    Return FullAddress 
End Function



</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>56cbba59-76c1-4d5c-9ece-c49128d9b2e8</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

