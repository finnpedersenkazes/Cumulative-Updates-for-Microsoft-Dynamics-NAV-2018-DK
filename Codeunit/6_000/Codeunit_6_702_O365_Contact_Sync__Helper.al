OBJECT Codeunit 6702 O365 Contact Sync. Helper
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      O365SyncManagement@1000 : Codeunit 6700;
      CountryRegionNotFoundErr@1007 : TextConst 'DAN=Exchange-landet eller -omr�det findes ikke i denne virksomhed.;ENU=The Exchange Country/Region cannot be found in your company.';
      CreateExchangeContactTxt@1005 : TextConst 'DAN=Opret Exchange-kontakt.;ENU=Create exchange contact.';
      CreateNavContactTxt@1001 : TextConst '@@@="%1 = The contact";DAN=Opret kontakt. - %1;ENU=Create contact. - %1';
      UniqueCompanyNameErr@1006 : TextConst 'DAN=Exchange-virksomhedsnavnet er ikke unikt i din virksomhed.;ENU=The Exchange Company Name is not unique in your company.';

    [Internal]
    PROCEDURE GetO365Contacts@6(ExchangeSync@1002 : Record 6700;VAR TempContact@1003 : TEMPORARY Record 5050);
    VAR
      ExchangeContact@1001 : Record 6701;
      Counter@1000 : Integer;
      RecordsFound@1004 : Boolean;
      Success@1005 : Boolean;
    BEGIN
      TempContact.RESET;
      TempContact.DELETEALL;

      ExchangeContact.SETFILTER(EMailAddress1,'<>%1','');
      IF TryFindContacts(ExchangeContact,RecordsFound,Success) AND RecordsFound THEN
        REPEAT
          Counter := Counter + 1;
          CLEAR(TempContact);
          TempContact.INIT;
          TempContact."No." := STRSUBSTNO('%1',Counter);
          TempContact.Type := TempContact.Type::Person;

          TransferExchangeContactToNavContactNoValidate(ExchangeSync,ExchangeContact,TempContact);
          TempContact.INSERT; // Do not run the trigger so we preserve the dates.

        UNTIL (ExchangeContact.NEXT = 0)
      ELSE
        IF NOT Success THEN
          ERROR(GETLASTERRORTEXT);

      CLEAR(ExchangeContact);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryFindContacts@1(VAR ExchangeContact@1000 : Record 6701;VAR RecordsFound@1001 : Boolean;VAR Success@1002 : Boolean);
    BEGIN
      RecordsFound := ExchangeContact.FINDSET;
      Success := TRUE;
    END;

    [Internal]
    PROCEDURE TransferExchangeContactToNavContact@13(VAR ExchangeContact@1000 : Record 5050;VAR NavContact@1001 : Record 5050;ExchangeSync@1003 : Record 6700);
    BEGIN
      NavContact.Type := NavContact.Type::Person;

      // Map the ExchangeContact.CompanyName to NavContact.CompanyNo if possible
      IF ExchangeContact."Company Name" <> '' THEN
        IF IsCompanyNameUnique(ExchangeContact."Company Name") THEN BEGIN
          ValidateCompanyName(NavContact,ExchangeContact."Company Name");
          NavContact.MODIFY;
        END ELSE
          LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Company Name"),ExchangeContact."E-Mail");

      TransferContactNameInfo(ExchangeContact,NavContact,ExchangeSync);

      TransferCommonContactInfo(ExchangeContact,NavContact,ExchangeSync);
    END;

    [Internal]
    PROCEDURE TransferBookingContactToNavContact@2(VAR ExchangeContact@1000 : Record 5050;VAR NavContact@1001 : Record 5050);
    VAR
      ExchangeSync@1004 : Record 6700;
    BEGIN
      ExchangeSync.GET(USERID);

      // Map the ExchangeContact.CompanyName to NavContact.CompanyNo if possible
      IF ExchangeContact."Company Name" <> '' THEN
        IF IsCompanyNameUnique(ExchangeContact."Company Name") THEN BEGIN
          ValidateCompanyName(NavContact,ExchangeContact."Company Name");
          NavContact.MODIFY;
        END ELSE
          LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Company Name"),ExchangeContact."E-Mail")
      ELSE
        TransferContactNameInfo(ExchangeContact,NavContact,ExchangeSync);

      TransferCommonContactInfo(ExchangeContact,NavContact,ExchangeSync);
    END;

    [Internal]
    PROCEDURE ProcessNavContactRecordSet@24(VAR Contact@1000 : Record 5050;VAR TempContact@1005 : TEMPORARY Record 5050;VAR ExchangeSync@1002 : Record 6700);
    VAR
      ExchangeContact@1003 : Record 6701;
      LocalExchangeContact@1004 : Record 6701;
      found@1001 : Boolean;
    BEGIN
      IF Contact.FINDSET THEN BEGIN
        REPEAT
          found := FALSE;
          TempContact.RESET;
          TempContact.SETRANGE("E-Mail",Contact."E-Mail");
          IF TempContact.FINDFIRST THEN BEGIN
            found := TRUE;
            TempContact.DELETE;
          END;

          CLEAR(ExchangeContact);
          ExchangeContact.INIT;

          IF NOT TransferNavContactToExchangeContact(Contact,ExchangeContact) THEN
            O365SyncManagement.LogActivityFailed(ExchangeSync.RECORDID,ExchangeSync."User ID",
              CreateExchangeContactTxt,ExchangeContact.EMailAddress1)
          ELSE
            IF found THEN
              ExchangeContact.MODIFY
            ELSE BEGIN
              CLEAR(LocalExchangeContact);
              LocalExchangeContact.INIT;
              LocalExchangeContact.SETFILTER(EMailAddress1,'=%1',Contact."E-Mail");
              IF LocalExchangeContact.FINDFIRST THEN
                O365SyncManagement.LogActivityFailed(ExchangeSync.RECORDID,ExchangeSync."User ID",
                  CreateExchangeContactTxt,ExchangeContact.EMailAddress1)
              ELSE
                ExchangeContact.INSERT
            END;

        UNTIL Contact.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE TransferExchangeContactToNavContactNoValidate@17(ExchangeSync@1003 : Record 6700;VAR ExchangeContact@1000 : Record 6701;VAR NavContact@1001 : Record 5050);
    VAR
      DateFilterCalc@1004 : Codeunit 358;
      ExchContDateTimeUtc@1002 : DateTime;
    BEGIN
      IF NOT SetFirstName(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("First Name"),ExchangeContact.EMailAddress1);

      IF NOT SetMiddleName(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Middle Name"),ExchangeContact.EMailAddress1);

      IF NOT SetSurName(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION(Surname),ExchangeContact.EMailAddress1);

      IF NOT SetInitials(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION(Initials),ExchangeContact.EMailAddress1);

      IF NOT SetPostCode(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Post Code"),ExchangeContact.EMailAddress1);

      IF NOT SetEmail(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("E-Mail"),ExchangeContact.EMailAddress1);

      IF NOT SetEmail2(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("E-Mail 2"),ExchangeContact.EMailAddress1);

      IF NOT SetCompanyName(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Company Name"),ExchangeContact.EMailAddress1);

      IF NOT SetHomePage(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Home Page"),ExchangeContact.EMailAddress1);

      IF NOT SetPhoneNo(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Phone No."),ExchangeContact.EMailAddress1);

      IF NOT SetMobilePhoneNo(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Mobile Phone No."),ExchangeContact.EMailAddress1);

      IF NOT SetFaxNo(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Fax No."),ExchangeContact.EMailAddress1);

      IF NOT SetCity(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION(City),ExchangeContact.EMailAddress1);

      IF NOT SetCounty(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION(County),ExchangeContact.EMailAddress1);

      IF NOT SetNavContactAddresses(NavContact,ExchangeContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION(Address),ExchangeContact.EMailAddress1);

      ExchContDateTimeUtc := DateFilterCalc.ConvertToUtcDateTime(ExchangeContact.LastModifiedTime);
      NavContact."Last Date Modified" := DT2DATE(ExchContDateTimeUtc);
      NavContact."Last Time Modified" := DT2TIME(ExchContDateTimeUtc);

      // NOTE, we are using "Name 2" as the datatype is large enough to accomodate Exchange data type.
      IF NOT SetRegion(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Country/Region Code"),ExchangeContact.EMailAddress1);

      IF NOT SetJobTitle(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Job Title"),ExchangeContact.EMailAddress1);
    END;

    [TryFunction]
    [External]
    PROCEDURE TransferNavContactToExchangeContact@20(VAR NavContact@1000 : Record 5050;VAR ExchangeContact@1001 : Record 6701);
    BEGIN
      ExchangeContact.VALIDATE(EMailAddress1,NavContact."E-Mail");
      IF NavContact.Type = NavContact.Type::Person THEN
        ExchangeContact.VALIDATE(GivenName,NavContact."First Name");
      IF NavContact.Type = NavContact.Type::Company THEN
        ExchangeContact.VALIDATE(GivenName,COPYSTR(NavContact."Company Name",1,30));
      ExchangeContact.VALIDATE(MiddleName,NavContact."Middle Name");
      ExchangeContact.VALIDATE(Surname,NavContact.Surname);
      ExchangeContact.VALIDATE(Initials,NavContact.Initials);
      ExchangeContact.VALIDATE(PostalCode,NavContact."Post Code");
      ExchangeContact.VALIDATE(EMailAddress2,NavContact."E-Mail 2");
      ExchangeContact.VALIDATE(CompanyName,NavContact."Company Name");
      ExchangeContact.VALIDATE(BusinessHomePage,NavContact."Home Page");
      ExchangeContact.VALIDATE(BusinessPhone1,NavContact."Phone No.");
      ExchangeContact.VALIDATE(MobilePhone,NavContact."Mobile Phone No.");
      ExchangeContact.VALIDATE(BusinessFax,NavContact."Fax No.");
      ValidateExchangeContactAddress(ExchangeContact,NavContact);
      ExchangeContact.VALIDATE(City,NavContact.City);
      ExchangeContact.VALIDATE(State,NavContact.County);
      ExchangeContact.VALIDATE(Region,NavContact."Country/Region Code");
      ExchangeContact.VALIDATE(JobTitle,NavContact."Job Title");
    END;

    [TryFunction]
    LOCAL PROCEDURE SetNavContactAddresses@26(VAR NavContact@1002 : Record 5050;VAR ExchangeContact@1000 : Record 6701);
    VAR
      LineFeed@1001 : Char;
      LocalStreet@1003 : Text;
      LineFeedPos@1004 : Integer;
      CarriageReturn@1005 : Char;
      CarriageReturnPos@1006 : Integer;
    BEGIN
      // Split ExchangeContact.Street into NavContact.Address and Address2.
      LineFeed := 10;
      CarriageReturn := 13;
      LocalStreet := ExchangeContact.Street;
      LineFeedPos := STRPOS(LocalStreet,FORMAT(LineFeed));
      CarriageReturnPos := STRPOS(LocalStreet,FORMAT(CarriageReturn));
      IF LineFeedPos > 0 THEN BEGIN
        IF CarriageReturnPos = 0 THEN
          // Exchange has a bug when editing from OWA where the Carriage Return is ommitted.
          NavContact.Address := COPYSTR(LocalStreet,1,LineFeedPos - 1)
        ELSE
          NavContact.Address := COPYSTR(LocalStreet,1,LineFeedPos - 2);
        LocalStreet := COPYSTR(LocalStreet,LineFeedPos + 1);
        LineFeedPos := STRPOS(LocalStreet,FORMAT(LineFeed));
        CarriageReturnPos := STRPOS(LocalStreet,FORMAT(CarriageReturn));
        IF LineFeedPos > 0 THEN BEGIN
          IF CarriageReturnPos = 0 THEN
            LocalStreet := COPYSTR(LocalStreet,1,LineFeedPos - 1)
          ELSE
            LocalStreet := COPYSTR(LocalStreet,1,LineFeedPos - 2);
          NavContact."Address 2" := COPYSTR(LocalStreet,1,STRLEN(LocalStreet));
        END ELSE
          NavContact."Address 2" := COPYSTR(LocalStreet,1,STRLEN(LocalStreet));
      END ELSE
        NavContact.Address := COPYSTR(LocalStreet,1,50);
    END;

    [TryFunction]
    LOCAL PROCEDURE SetFirstName@34(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."First Name" := ExchangeContact.GivenName;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetMiddleName@28(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."Middle Name" := ExchangeContact.MiddleName;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetSurName@40(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact.Surname := ExchangeContact.Surname;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetInitials@42(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact.Initials := ExchangeContact.Initials;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetPostCode@46(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."Post Code" := ExchangeContact.PostalCode;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetEmail@37(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."E-Mail" := ExchangeContact.EMailAddress1;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetEmail2@39(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."E-Mail 2" := ExchangeContact.EMailAddress2;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetCompanyName@45(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."Company Name" := ExchangeContact.CompanyName;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetHomePage@48(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."Home Page" := ExchangeContact.BusinessHomePage;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetPhoneNo@51(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."Phone No." := ExchangeContact.BusinessPhone1;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetMobilePhoneNo@52(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."Mobile Phone No." := ExchangeContact.MobilePhone;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetFaxNo@55(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."Fax No." := ExchangeContact.BusinessFax;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetCity@56(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact.City := ExchangeContact.City;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetCounty@57(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact.County := ExchangeContact.State;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetRegion@33(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."Name 2" := ExchangeContact.Region;
    END;

    [TryFunction]
    LOCAL PROCEDURE SetJobTitle@35(VAR ExchangeContact@1001 : Record 6701;VAR NavContact@1000 : Record 5050);
    BEGIN
      NavContact."Job Title" := ExchangeContact.JobTitle;
    END;

    [TryFunction]
    LOCAL PROCEDURE IsCompanyNameUnique@3(ExchangeContactCompanyName@1001 : Text[50]);
    VAR
      LocalContact@1000 : Record 5050;
    BEGIN
      LocalContact.SETRANGE("Company Name",ExchangeContactCompanyName);
      LocalContact.SETRANGE(Type,LocalContact.Type::Company);
      IF LocalContact.COUNT <> 1 THEN
        ERROR(UniqueCompanyNameErr);
    END;

    LOCAL PROCEDURE ValidateCompanyName@27(VAR NavContact@1001 : Record 5050;ExchangeContactCompanyName@1002 : Text[50]);
    VAR
      LocalContact@1000 : Record 5050;
    BEGIN
      LocalContact.SETRANGE("Company Name",ExchangeContactCompanyName);
      LocalContact.SETRANGE(Type,LocalContact.Type::Company);
      IF LocalContact.FINDFIRST THEN
        IF LocalContact."Company Name" <> NavContact."Company Name" THEN
          NavContact.VALIDATE("Company No.",LocalContact."No.");
    END;

    [TryFunction]
    LOCAL PROCEDURE ValidateCountryRegion@25(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050);
    VAR
      LocalCountryRegion@1001 : Record 9;
    BEGIN
      // Map Exchange.Region to NavContact."Country/Region Code"
      // NOTE, we are using "Name 2" as the datatype is large enough to accomodate Exchange data type.
      IF ExchangeContact."Name 2" <> '' THEN
        IF STRLEN(ExchangeContact."Name 2") <= 10 THEN
          IF LocalCountryRegion.GET(ExchangeContact."Name 2") THEN
            NavContact.VALIDATE("Country/Region Code",COPYSTR(ExchangeContact."Name 2",1,10))
          ELSE
            ValidateCountryRegionByName(ExchangeContact."Name 2",NavContact)
        ELSE
          ValidateCountryRegionByName(ExchangeContact."Name 2",NavContact);
    END;

    LOCAL PROCEDURE ValidateCountryRegionByName@44(Country@1000 : Text[50];VAR NavContact@1002 : Record 5050);
    VAR
      LocalCountryRegion@1001 : Record 9;
    BEGIN
      LocalCountryRegion.SETRANGE(Name,Country);
      IF LocalCountryRegion.FINDFIRST THEN
        NavContact.VALIDATE("Country/Region Code",LocalCountryRegion.Code)
      ELSE
        ERROR(CountryRegionNotFoundErr);
    END;

    LOCAL PROCEDURE ValidateExchangeContactAddress@30(VAR ExchangeContact@1000 : Record 6701;VAR NavContact@1001 : Record 5050);
    VAR
      CrLf@1002 : Text[2];
      LocalStreet@1004 : Text;
    BEGIN
      // Concatenate NavContact.Address & Address2 into ExchangeContact.Street
      CrLf[1] := 13;
      CrLf[2] := 10;
      LocalStreet := NavContact.Address + CrLf + NavContact."Address 2" + CrLf;
      ExchangeContact.VALIDATE(Street,COPYSTR(LocalStreet,1,104));
    END;

    LOCAL PROCEDURE ValidateFirstName@36(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1001 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("First Name"),ExchangeContact."First Name") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateMiddleName@47(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("Middle Name"),ExchangeContact."Middle Name") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateSurname@49(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO(Surname),ExchangeContact.Surname) THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateInitials@53(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO(Initials),ExchangeContact.Initials) THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateEmail@54(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("E-Mail"),ExchangeContact."E-Mail") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateEmail2@60(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("E-Mail 2"),ExchangeContact."E-Mail 2") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateHomePage@61(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("Home Page"),ExchangeContact."Home Page") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidatePhoneNo@64(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("Phone No."),ExchangeContact."Phone No.") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateMobilePhoneNo@65(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("Mobile Phone No."),ExchangeContact."Mobile Phone No.") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateFaxNo@68(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("Fax No."),ExchangeContact."Fax No.") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateAddress@69(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO(Address),ExchangeContact.Address) THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateAddress2@72(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("Address 2"),ExchangeContact."Address 2") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateCity@73(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO(City),ExchangeContact.City) THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidatePostCode@77(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("Post Code"),ExchangeContact."Post Code") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateCounty@78(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO(County),ExchangeContact.County) THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ValidateJobTitle@81(ExchangeContact@1000 : Record 5050;VAR NavContact@1002 : Record 5050) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      NavContact.GET(NavContact."No.");
      RecRef.GETTABLE(NavContact);
      IF TryValidateField(RecRef,NavContact.FIELDNO("Job Title"),ExchangeContact."Job Title") THEN
        EXIT(RecRef.MODIFY);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE TransferContactNameInfo@11(VAR ExchangeContact@1002 : Record 5050;VAR NavContact@1001 : Record 5050;ExchangeSync@1000 : Record 6700);
    BEGIN
      IF NOT ValidateFirstName(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("First Name"),ExchangeContact."E-Mail");

      IF NOT ValidateMiddleName(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Middle Name"),ExchangeContact."E-Mail");

      IF NOT ValidateSurname(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION(Surname),ExchangeContact."E-Mail");

      IF NOT ValidateInitials(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION(Initials),ExchangeContact."E-Mail");
    END;

    LOCAL PROCEDURE TransferCommonContactInfo@5(VAR ExchangeContact@1000 : Record 5050;VAR NavContact@1001 : Record 5050;ExchangeSync@1003 : Record 6700);
    BEGIN
      IF NOT ValidateEmail(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("E-Mail"),ExchangeContact."E-Mail");

      IF NOT ValidateEmail2(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("E-Mail 2"),ExchangeContact."E-Mail");

      IF NOT ValidateHomePage(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Home Page"),ExchangeContact."E-Mail");

      IF NOT ValidatePhoneNo(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Phone No."),ExchangeContact."E-Mail");

      IF NOT ValidateMobilePhoneNo(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Mobile Phone No."),ExchangeContact."E-Mail");

      IF NOT ValidateFaxNo(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Fax No."),ExchangeContact."E-Mail");

      IF NOT ValidateAddress(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION(Address),ExchangeContact."E-Mail");

      IF NOT ValidateAddress2(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Address 2"),ExchangeContact."E-Mail");

      IF NOT ValidateCity(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION(City),ExchangeContact."E-Mail");

      IF NOT ValidatePostCode(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Post Code"),ExchangeContact."E-Mail");

      IF NOT ValidateCounty(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION(County),ExchangeContact."E-Mail");

      NavContact.VALIDATE("Last Date Modified",ExchangeContact."Last Date Modified");
      NavContact.VALIDATE("Last Time Modified",ExchangeContact."Last Time Modified");

      IF NOT ValidateCountryRegion(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Country/Region Code"),ExchangeContact."E-Mail");

      IF NOT ValidateJobTitle(ExchangeContact,NavContact) THEN
        LogFailure(ExchangeSync,NavContact.FIELDCAPTION("Job Title"),ExchangeContact."E-Mail");
    END;

    LOCAL PROCEDURE LogFailure@7(ExchangeSync@1000 : Record 6700;FieldCaption@1001 : Text;Identifier@1002 : Text);
    VAR
      Message@1003 : Text;
    BEGIN
      Message := STRSUBSTNO(CreateNavContactTxt,FieldCaption);
      O365SyncManagement.LogActivityFailed(ExchangeSync.RECORDID,ExchangeSync."User ID",Message,Identifier);
    END;

    LOCAL PROCEDURE TryValidateField@4(VAR RecRef@1000 : RecordRef;FieldNo@1002 : Integer;Value@1003 : Variant) : Boolean;
    VAR
      ConfigTryValidate@1004 : Codeunit 8613;
      FieldRef@1001 : FieldRef;
    BEGIN
      FieldRef := RecRef.FIELD(FieldNo);
      ConfigTryValidate.SetValidateParameters(FieldRef,Value);
      COMMIT;
      EXIT(ConfigTryValidate.RUN);
    END;

    BEGIN
    END.
  }
}

