OBJECT Codeunit 6703 Exchange Contact Sync.
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    OnRun=VAR
            LocalExchangeSync@1000 : Record 6700;
          BEGIN
            LocalExchangeSync.SETRANGE(Enabled,TRUE);
            IF LocalExchangeSync.FINDSET THEN
              REPEAT
                O365SyncManagement.SyncExchangeContacts(LocalExchangeSync,FALSE);
              UNTIL LocalExchangeSync.NEXT = 0;
          END;

  }
  CODE
  {
    VAR
      TempContact@1007 : TEMPORARY Record 5050;
      O365SyncManagement@1001 : Codeunit 6700;
      O365ContactSyncHelper@1010 : Codeunit 6702;
      SkipDateFilters@1002 : Boolean;
      ProcessExchangeContactsMsg@1005 : TextConst 'DAN=Behandler kontakter fra Exchange.;ENU=Processing contacts from Exchange.';
      ProcessNavContactsMsg@1004 : TextConst 'DAN=Behandler kontakter i din virksomhed.;ENU=Processing contacts in your company.';

    [External]
    PROCEDURE GetRequestParameters@2(VAR ExchangeSync@1000 : Record 6700) : Text;
    VAR
      LocalContact@1005 : Record 5050;
      FilterPage@1004 : FilterPageBuilder;
      FilterText@1003 : Text;
      ContactTxt@1001 : Text;
    BEGIN
      FilterText := ExchangeSync.GetSavedFilter;

      ContactTxt := LocalContact.TABLECAPTION;
      FilterPage.PAGECAPTION := ContactTxt;
      FilterPage.ADDTABLE(ContactTxt,DATABASE::Contact);

      IF FilterText <> '' THEN
        FilterPage.SETVIEW(ContactTxt,FilterText);

      FilterPage.ADDFIELD(ContactTxt,LocalContact."Territory Code");
      FilterPage.ADDFIELD(ContactTxt,LocalContact."Company No.");
      FilterPage.ADDFIELD(ContactTxt,LocalContact."Salesperson Code");
      FilterPage.ADDFIELD(ContactTxt,LocalContact.City);
      FilterPage.ADDFIELD(ContactTxt,LocalContact.County);
      FilterPage.ADDFIELD(ContactTxt,LocalContact."Post Code");
      FilterPage.ADDFIELD(ContactTxt,LocalContact."Country/Region Code");

      IF FilterPage.RUNMODAL THEN
        FilterText := FilterPage.GETVIEW(ContactTxt);

      IF FilterText <> '' THEN BEGIN
        ExchangeSync.SaveFilter(FilterText);
        ExchangeSync.MODIFY(TRUE);
      END;

      EXIT(FilterText);
    END;

    [External]
    PROCEDURE GetRequestParametersFullSync@23(VAR ExchangeSync@1000 : Record 6700);
    BEGIN
      SkipDateFilters := TRUE;

      GetRequestParameters(ExchangeSync);
    END;

    [Internal]
    PROCEDURE SyncRecords@1(VAR ExchangeSync@1000 : Record 6700;FullSync@1001 : Boolean);
    BEGIN
      SkipDateFilters := FullSync;
      O365ContactSyncHelper.GetO365Contacts(ExchangeSync,TempContact);

      O365SyncManagement.ShowProgress(ProcessNavContactsMsg);
      ProcessNavContacts(ExchangeSync,TempContact,SkipDateFilters);

      O365SyncManagement.ShowProgress(ProcessExchangeContactsMsg);
      ProcessExchangeContacts(ExchangeSync,TempContact,SkipDateFilters);

      O365SyncManagement.CloseProgress;
      ExchangeSync."Last Sync Date Time" := CREATEDATETIME(TODAY,TIME);
      ExchangeSync.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE ProcessExchangeContacts@22(VAR ExchangeSync@1002 : Record 6700;VAR TempContact@1001 : TEMPORARY Record 5050;SkipDateFilters@1003 : Boolean);
    BEGIN
      TempContact.RESET;
      IF NOT SkipDateFilters THEN
        TempContact.SetLastDateTimeFilter(ExchangeSync."Last Sync Date Time");

      ProcessExchangeContactRecordSet(TempContact,ExchangeSync);
    END;

    LOCAL PROCEDURE ProcessExchangeContactRecordSet@21(VAR LocalContact@1000 : Record 5050;VAR ExchangeSync@1003 : Record 6700);
    VAR
      Contact@1004 : Record 5050;
      found@1001 : Boolean;
      ContactNo@1002 : Text;
    BEGIN
      IF LocalContact.FINDSET THEN
        REPEAT
          found := FALSE;
          ContactNo := '';
          Contact.RESET;
          CLEAR(Contact);
          Contact.SETRANGE("Search E-Mail",UPPERCASE(LocalContact."E-Mail"));
          IF Contact.FINDFIRST THEN BEGIN
            found := TRUE;
            ContactNo := Contact."No.";
          END;

          IF found THEN BEGIN
            IF NOT Contact."Privacy Blocked" THEN BEGIN
              O365ContactSyncHelper.TransferExchangeContactToNavContact(LocalContact,Contact,ExchangeSync);
              Contact."No." := COPYSTR(ContactNo,1,20);
              Contact.MODIFY(TRUE);
            END
          END ELSE BEGIN
            Contact."No." := '';
            Contact.Type := Contact.Type::Person;
            Contact.INSERT(TRUE);
            O365ContactSyncHelper.TransferExchangeContactToNavContact(LocalContact,Contact,ExchangeSync);
          END;
        UNTIL (LocalContact.NEXT = 0)
    END;

    LOCAL PROCEDURE ProcessNavContacts@10(VAR ExchangeSync@1000 : Record 6700;VAR TempContact@1002 : TEMPORARY Record 5050;SkipDateFilters@1003 : Boolean);
    VAR
      Contact@1001 : Record 5050;
    BEGIN
      SetContactFilter(Contact,ExchangeSync);
      IF NOT SkipDateFilters THEN
        Contact.SetLastDateTimeFilter(ExchangeSync."Last Sync Date Time");

      O365ContactSyncHelper.ProcessNavContactRecordSet(Contact,TempContact,ExchangeSync);
    END;

    LOCAL PROCEDURE SetContactFilter@16(VAR Contact@1000 : Record 5050;VAR ExchangeSync@1001 : Record 6700);
    BEGIN
      Contact.SETVIEW(ExchangeSync.GetSavedFilter);
      Contact.SETRANGE(Type,Contact.Type::Person);
      Contact.SETFILTER("E-Mail",'<>%1','');
      Contact.SETRANGE("Privacy Blocked",FALSE);
    END;

    BEGIN
    END.
  }
}

