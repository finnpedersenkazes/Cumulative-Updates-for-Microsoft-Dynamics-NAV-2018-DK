OBJECT Table 225 Post Code
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Postnr.;
               ENU=Post Code];
    LookupPageID=Page367;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;OnValidate=VAR
                                                                PostCode@1000 : Record 225;
                                                              BEGIN
                                                                PostCode.SETRANGE("Search City","Search City");
                                                                PostCode.SETRANGE(Code,Code);
                                                                IF NOT PostCode.ISEMPTY THEN
                                                                  ERROR(Text000,FIELDCAPTION(Code),Code);
                                                              END;

                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;City                ;Text30        ;OnValidate=VAR
                                                                PostCode@1000 : Record 225;
                                                              BEGIN
                                                                TESTFIELD(Code);
                                                                "Search City" := City;
                                                                IF xRec."Search City" <> "Search City" THEN BEGIN
                                                                  PostCode.SETRANGE("Search City","Search City");
                                                                  PostCode.SETRANGE(Code,Code);
                                                                  IF NOT PostCode.ISEMPTY THEN
                                                                    ERROR(Text000,FIELDCAPTION(City),City);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=By;
                                                              ENU=City];
                                                   NotBlank=Yes }
    { 3   ;   ;Search City         ;Code30        ;CaptionML=[DAN=S�gebynavn;
                                                              ENU=Search City] }
    { 4   ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code] }
    { 5   ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
  }
  KEYS
  {
    {    ;Code,City                               ;Clustered=Yes }
    {    ;City,Code                                }
    {    ;Search City                              }
    {    ;Country/Region Code                      }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Code,City,Country/Region Code,County     }
    { 2   ;Brick               ;Code,City,County,Country/Region Code     }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 %2 findes allerede.;ENU=%1 %2 already exists.';

    [External]
    PROCEDURE ValidateCity@5(VAR City@1000 : Text[30];VAR PostCode@1001 : Code[20];VAR County@1006 : Text[30];VAR CountryCode@1005 : Code[10];UseDialog@1007 : Boolean);
    VAR
      PostCodeRec@1002 : Record 225;
      PostCodeRec2@1004 : Record 225;
      SearchCity@1003 : Code[30];
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;

      IF City <> '' THEN BEGIN
        SearchCity := City;
        PostCodeRec.SETCURRENTKEY("Search City");
        IF STRPOS(SearchCity,'*') = STRLEN(SearchCity) THEN
          PostCodeRec.SETFILTER("Search City",SearchCity)
        ELSE
          PostCodeRec.SETRANGE("Search City",SearchCity);
        IF NOT PostCodeRec.FINDFIRST THEN
          EXIT;

        IF CountryCode <> '' THEN BEGIN
          PostCodeRec.SETRANGE("Country/Region Code",CountryCode);
          IF NOT PostCodeRec.FINDFIRST THEN
            PostCodeRec.SETRANGE("Country/Region Code");
        END;

        PostCodeRec2.COPY(PostCodeRec);
        IF UseDialog AND (PostCodeRec2.NEXT = 1) THEN
          IF PAGE.RUNMODAL(PAGE::"Post Codes",PostCodeRec,PostCodeRec.Code) <> ACTION::LookupOK THEN
            ERROR('');
        PostCode := PostCodeRec.Code;
        City := PostCodeRec.City;
        CountryCode := PostCodeRec."Country/Region Code";
        County := PostCodeRec.County;
      END;
    END;

    [External]
    PROCEDURE ValidatePostCode@6(VAR City@1001 : Text[30];VAR PostCode@1000 : Code[20];VAR County@1005 : Text[30];VAR CountryCode@1006 : Code[10];UseDialog@1004 : Boolean);
    VAR
      PostCodeRec@1002 : Record 225;
      PostCodeRec2@1003 : Record 225;
    BEGIN
      IF PostCode <> '' THEN BEGIN
        IF STRPOS(PostCode,'*') = STRLEN(PostCode) THEN
          PostCodeRec.SETFILTER(Code,PostCode)
        ELSE
          PostCodeRec.SETRANGE(Code,PostCode);
        IF NOT PostCodeRec.FINDFIRST THEN
          EXIT;

        IF CountryCode <> '' THEN BEGIN
          PostCodeRec.SETRANGE("Country/Region Code",CountryCode);
          IF NOT PostCodeRec.FINDFIRST THEN
            PostCodeRec.SETRANGE("Country/Region Code");
        END;

        PostCodeRec2.COPY(PostCodeRec);
        IF UseDialog AND (PostCodeRec2.NEXT = 1) AND GUIALLOWED THEN
          IF PAGE.RUNMODAL(PAGE::"Post Codes",PostCodeRec,PostCodeRec.Code) <> ACTION::LookupOK THEN
            EXIT;
        PostCode := PostCodeRec.Code;
        City := PostCodeRec.City;
        CountryCode := PostCodeRec."Country/Region Code";
        County := PostCodeRec.County;
      END;
    END;

    [External]
    PROCEDURE UpdateFromSalesHeader@8(SalesHeader@1000 : Record 36;PostCodeChanged@1001 : Boolean);
    BEGIN
      CreatePostCode(SalesHeader."Sell-to Post Code",SalesHeader."Sell-to City",
        SalesHeader."Sell-to Country/Region Code",SalesHeader."Sell-to County",PostCodeChanged);
    END;

    [External]
    PROCEDURE UpdateFromCustomer@15(Customer@1000 : Record 18;PostCodeChanged@1001 : Boolean);
    BEGIN
      CreatePostCode(Customer."Post Code",Customer.City,
        Customer."Country/Region Code",Customer.County,PostCodeChanged);
    END;

    [External]
    PROCEDURE UpdateFromCompanyInformation@16(CompanyInformation@1000 : Record 79;PostCodeChanged@1001 : Boolean);
    BEGIN
      CreatePostCode(CompanyInformation."Post Code",CompanyInformation.City,
        CompanyInformation."Country/Region Code",CompanyInformation.County,PostCodeChanged);
    END;

    [External]
    PROCEDURE UpdateFromStandardAddress@1(StandardAddress@1000 : Record 730;PostCodeChanged@1001 : Boolean);
    BEGIN
      CreatePostCode(StandardAddress."Post Code",StandardAddress.City,
        StandardAddress."Country/Region Code",StandardAddress.County,PostCodeChanged);
    END;

    LOCAL PROCEDURE CreatePostCode@17(NewPostCode@1000 : Code[20];NewCity@1001 : Text[30];NewCountryRegion@1002 : Code[10];NewCounty@1003 : Text[30];PostCodeChanged@1004 : Boolean);
    BEGIN
      IF NewPostCode = '' THEN
        EXIT;

      SETRANGE(Code,NewPostCode);
      IF FINDFIRST THEN BEGIN
        IF PostCodeChanged THEN
          EXIT; // If the post code was updated, then don't insert the city for the old post code into the new post code
        IF (NewCity <> '') AND (City <> NewCity) THEN
          RENAME(NewPostCode,NewCity);
        IF NewCountryRegion <> '' THEN
          "Country/Region Code" := NewCountryRegion;
        IF NewCounty <> '' THEN
          County := NewCounty;
        MODIFY;
      END ELSE BEGIN
        INIT;

        Code := NewPostCode;
        City := NewCity;
        "Country/Region Code" := NewCountryRegion;
        County := NewCounty;
        INSERT;
      END;
    END;

    [External]
    PROCEDURE ValidateCountryCode@11(VAR CityTxt@1004 : Text[30];VAR PostCode@1003 : Code[20];VAR CountyTxt@1002 : Text[30];VAR CountryCode@1001 : Code[10]);
    VAR
      PostCodeRec@1005 : Record 225;
    BEGIN
      IF xRec."Country/Region Code" = CountryCode THEN
        EXIT;
      IF (CountryCode = '') OR (PostCode = '') THEN
        EXIT;

      PostCodeRec.SETRANGE("Country/Region Code",CountryCode);
      PostCodeRec.SETRANGE(Code,PostCode);
      IF PostCodeRec.FINDFIRST THEN BEGIN
        PostCode := PostCodeRec.Code;
        CityTxt := PostCodeRec.City;
        CountryCode := PostCodeRec."Country/Region Code";
        CountyTxt := PostCodeRec.County;
      END;
    END;

    BEGIN
    END.
  }
}

