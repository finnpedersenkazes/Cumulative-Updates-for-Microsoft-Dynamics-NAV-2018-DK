OBJECT Table 730 Standard Address
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF NOT ISTEMPORARY THEN
                 ERROR(DevMsgNotTemporaryErr);
             END;

    CaptionML=[DAN=Standardadresse;
               ENU=Standard Address];
  }
  FIELDS
  {
    { 1   ;   ;Related RecordID    ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Relateret RecordID;
                                                              ENU=Related RecordID] }
    { 2   ;   ;Address Type        ;Option        ;CaptionML=[DAN=Adressetype;
                                                              ENU=Address Type];
                                                   OptionCaptionML=[DAN=" ,Kunde,Fakturering";
                                                                    ENU=" ,Sell-to,Bill-to"];
                                                   OptionString=[ ,Sell-to,Bill-to] }
    { 3   ;   ;Address             ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Address] }
    { 4   ;   ;Address 2           ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2] }
    { 5   ;   ;City                ;Text30        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 6   ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code] }
    { 7   ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 8   ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
  }
  KEYS
  {
    {    ;Related RecordID                        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PostCode@1000 : Record 225;
      DevMsgNotTemporaryErr@1001 : TextConst 'DAN=Denne funktion kan kun bruges, n�r recorden er midlertidig.;ENU=This function can only be used when the record is temporary.';
      FormatAddress@1002 : Codeunit 365;

    PROCEDURE ToString@5() FullAddress : Text;
    VAR
      AddressArray@1001 : ARRAY [8] OF Text[90];
      AddressPosition@1000 : Integer;
    BEGIN
      FormatAddress.FormatAddr(AddressArray,'','','',Address,"Address 2",City,"Post Code",County,"Country/Region Code");
      FOR AddressPosition := 1 TO 8 DO BEGIN
        AddressArray[AddressPosition] := DELCHR(AddressArray[AddressPosition],'<',', ');
        IF AddressArray[AddressPosition] <> '' THEN BEGIN
          IF FullAddress = '' THEN
            FullAddress := AddressArray[AddressPosition]
          ELSE
            FullAddress += ', ' + AddressArray[AddressPosition]
        END;
      END;
    END;

    PROCEDURE CopyFromCustomer@2(Customer@1000 : Record 18);
    BEGIN
      INIT;
      "Related RecordID" := Customer.RECORDID;
      Address := Customer.Address;
      "Address 2" := Customer."Address 2";
      City := Customer.City;
      "Country/Region Code" := Customer."Country/Region Code";
      "Post Code" := Customer."Post Code";
      County := Customer.County;
      INSERT(TRUE);
    END;

    PROCEDURE CopyFromCompanyInformation@6(CompanyInformation@1000 : Record 79);
    BEGIN
      INIT;
      "Related RecordID" := CompanyInformation.RECORDID;
      Address := CompanyInformation.Address;
      "Address 2" := CompanyInformation."Address 2";
      City := CompanyInformation.City;
      "Country/Region Code" := CompanyInformation."Country/Region Code";
      "Post Code" := CompanyInformation."Post Code";
      County := CompanyInformation.County;
      INSERT(TRUE);
    END;

    PROCEDURE CopyFromSalesHeaderSellTo@7(SalesHeader@1000 : Record 36);
    BEGIN
      INIT;
      "Address Type" := "Address Type"::"Sell-to";
      "Related RecordID" := SalesHeader.RECORDID;
      Address := SalesHeader."Sell-to Address";
      "Address 2" := SalesHeader."Sell-to Address 2";
      City := SalesHeader."Sell-to City";
      "Country/Region Code" := SalesHeader."Sell-to Country/Region Code";
      "Post Code" := SalesHeader."Sell-to Post Code";
      County := SalesHeader."Sell-to County";
      INSERT(TRUE);
    END;

    PROCEDURE CopyFromSalesInvoiceHeaderSellTo@11(SalesInvoiceHeader@1000 : Record 112);
    BEGIN
      INIT;
      "Address Type" := "Address Type"::"Sell-to";
      "Related RecordID" := SalesInvoiceHeader.RECORDID;
      Address := SalesInvoiceHeader."Sell-to Address";
      "Address 2" := SalesInvoiceHeader."Sell-to Address 2";
      City := SalesInvoiceHeader."Sell-to City";
      "Country/Region Code" := SalesInvoiceHeader."Sell-to Country/Region Code";
      "Post Code" := SalesInvoiceHeader."Sell-to Post Code";
      County := SalesInvoiceHeader."Sell-to County";
      INSERT(TRUE);
    END;

    PROCEDURE SaveToRecord@1();
    VAR
      RecID@1001 : RecordID;
    BEGIN
      RecID := "Related RecordID";
      CASE RecID.TABLENO OF
        DATABASE::Customer:
          SaveToCustomer;
        DATABASE::"Company Information":
          SaveToCompanyInformation;
        DATABASE::"Sales Header":
          CASE "Address Type" OF
            "Address Type"::"Sell-to":
              SaveToSalesHeaderSellTo;
          END;
      END;
    END;

    LOCAL PROCEDURE SaveToCustomer@3();
    VAR
      Customer@1000 : Record 18;
    BEGIN
      Customer.LOCKTABLE;
      Customer.GET("Related RecordID");
      Customer.VALIDATE(Address,Address);
      Customer.VALIDATE("Address 2","Address 2");
      Customer.VALIDATE(City,City);
      Customer.VALIDATE("Country/Region Code","Country/Region Code");
      Customer.VALIDATE("Post Code","Post Code");
      Customer.VALIDATE(County,County);
      Customer.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE SaveToCompanyInformation@4();
    VAR
      CompanyInformation@1001 : Record 79;
    BEGIN
      CompanyInformation.LOCKTABLE;
      CompanyInformation.GET("Related RecordID");
      CompanyInformation.VALIDATE(Address,Address);
      CompanyInformation.VALIDATE("Address 2","Address 2");
      CompanyInformation.VALIDATE(City,City);
      CompanyInformation.VALIDATE("Country/Region Code","Country/Region Code");
      CompanyInformation.VALIDATE("Post Code","Post Code");
      CompanyInformation.VALIDATE(County,County);
      CompanyInformation.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE SaveToSalesHeaderSellTo@8();
    VAR
      SalesHeader@1001 : Record 36;
    BEGIN
      SalesHeader.LOCKTABLE;
      SalesHeader.GET("Related RecordID");
      SalesHeader.VALIDATE("Sell-to Address",Address);
      SalesHeader.VALIDATE("Sell-to Address 2","Address 2");
      SalesHeader.VALIDATE("Sell-to City",City);
      SalesHeader.VALIDATE("Sell-to Country/Region Code","Country/Region Code");
      SalesHeader.VALIDATE("Sell-to Post Code","Post Code");
      SalesHeader.VALIDATE("Sell-to County",County);
      SalesHeader.MODIFY(TRUE);
    END;

    BEGIN
    END.
  }
}

