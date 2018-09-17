OBJECT Table 700 Error Message
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Fejlmeddelelse;
               ENU=Error Message];
    LookupPageID=Page701;
    DrillDownPageID=Page701;
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Record ID           ;RecordID      ;OnValidate=VAR
                                                                RecordRef@1000 : RecordRef;
                                                              BEGIN
                                                                IF RecordRef.GET("Record ID") THEN
                                                                  "Table Number" := RecordRef.NUMBER;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 3   ;   ;Field Number        ;Integer       ;CaptionML=[DAN=Feltnummer;
                                                              ENU=Field Number] }
    { 4   ;   ;Message Type        ;Option        ;CaptionML=[DAN=Meddelelsestype;
                                                              ENU=Message Type];
                                                   OptionCaptionML=[DAN=Fejl,Advarsel,Oplysninger;
                                                                    ENU=Error,Warning,Information];
                                                   OptionString=Error,Warning,Information;
                                                   Editable=No }
    { 5   ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 6   ;   ;Additional Information;Text250     ;CaptionML=[DAN=Flere oplysninger;
                                                              ENU=Additional Information];
                                                   Editable=No }
    { 7   ;   ;Support Url         ;Text250       ;CaptionML=[DAN=URL-adresse til support;
                                                              ENU=Support Url];
                                                   Editable=No }
    { 8   ;   ;Table Number        ;Integer       ;CaptionML=[DAN=Tabelnummer;
                                                              ENU=Table Number] }
    { 10  ;   ;Context Record ID   ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontekstrecord-id;
                                                              ENU=Context Record ID] }
    { 11  ;   ;Field Name          ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table Number),
                                                                                                   No.=FIELD(Field Number)));
                                                   CaptionML=[DAN=Feltnavn;
                                                              ENU=Field Name] }
    { 12  ;   ;Table Name          ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Table Metadata".Caption WHERE (ID=FIELD(Table Number)));
                                                   CaptionML=[DAN=Tabelnavn;
                                                              ENU=Table Name] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
    {    ;Context Record ID,Record ID              }
    {    ;Message Type,ID                          }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      IfEmptyErr@1000 : TextConst '@@@="%1=caption of a field, %2=key of record";DAN=''%1'' i ''%2'' m� ikke v�re tom.;ENU=''%1'' in ''%2'' must not be blank.';
      IfLengthExceededErr@1001 : TextConst '@@@="%1=caption of a field, %2=key of record, %3=integer, %4=integer";DAN=Maksimuml�ngden af ''%1'' i ''%2'' er %3 tegn. Den faktiske l�ngde er %4.;ENU=The maximum length of ''%1'' in ''%2'' is %3 characters. The actual length is %4.';
      IfInvalidCharactersErr@1002 : TextConst '@@@="%1=caption of a field, %2=key of record";DAN=''%1'' i ''%2'' indeholder tegn, der ikke er gyldige.;ENU=''%1'' in ''%2'' contains characters that are not valid.';
      IfOutsideRangeErr@1006 : TextConst '@@@="%1=caption of a field, %2=key of record, %3=integer, %4=integer";DAN=''%1'' i ''%2'' ligger uden for det tilladte interval fra %3 til %4.;ENU=''%1'' in ''%2'' is outside of the permitted range from %3 to %4.';
      IfGreaterThanErr@1007 : TextConst '@@@="%1=caption of a field, %2=key of record, %3=integer";DAN=''%1'' i ''%2'' skal v�re mindre end eller lig med %3.;ENU=''%1'' in ''%2'' must be less than or equal to %3.';
      IfLessThanErr@1008 : TextConst '@@@="%1=caption of a field, %2=key of record, %3=integer";DAN=''%1'' i ''%2'' skal v�re st�rre end eller lig med %3.;ENU=''%1'' in ''%2'' must be greater than or equal to %3.';
      IfEqualToErr@1010 : TextConst '@@@="%1=caption of a field, %2=key of record, %3=integer";DAN=''%1'' i ''%2'' m� ikke v�re lig med %3.;ENU=''%1'' in ''%2'' must not be equal to %3.';
      IfNotEqualToErr@1009 : TextConst '@@@="%1=caption of a field, %2=key of record, %3=integer";DAN=''%1'' i ''%2'' skal v�re lig med %3.;ENU=''%1'' in ''%2'' must be equal to %3.';
      HasErrorsMsg@1003 : TextConst 'DAN=Der blev fundet en eller flere fejl. Du skal l�se alle fejlene, f�r du kan forts�tte.;ENU=One or more errors were found. You must resolve all the errors before you can proceed.';
      DataTypeManagement@1004 : Codeunit 701;
      DevMsgNotTemporaryErr@1005 : TextConst 'DAN=Denne funktion kan kun bruges, n�r recorden er midlertidig.;ENU=This function can only be used when the record is temporary.';
      ContextRecordID@1011 : RecordID;

    [External]
    PROCEDURE LogIfEmpty@19(RecRelatedVariant@1000 : Variant;FieldNumber@1001 : Integer;MessageType@1002 : Option) : Integer;
    VAR
      RecordRef@1032 : RecordRef;
      TempRecordRef@1031 : RecordRef;
      FieldRef@1006 : FieldRef;
      EmptyFieldRef@1005 : FieldRef;
      NewDescription@1004 : Text;
    BEGIN
      IF NOT DataTypeManagement.GetRecordRefAndFieldRef(RecRelatedVariant,FieldNumber,RecordRef,FieldRef) THEN
        EXIT(0);

      TempRecordRef.OPEN(RecordRef.NUMBER,TRUE);
      EmptyFieldRef := TempRecordRef.FIELD(FieldNumber);

      IF FieldRef.VALUE <> EmptyFieldRef.VALUE THEN
        EXIT(0);

      NewDescription := STRSUBSTNO(IfEmptyErr,FieldRef.CAPTION,FORMAT(RecordRef.RECORDID));

      EXIT(LogMessage(RecRelatedVariant,FieldNumber,MessageType,NewDescription));
    END;

    [External]
    PROCEDURE LogIfLengthExceeded@17(RecRelatedVariant@1000 : Variant;FieldNumber@1001 : Integer;MessageType@1002 : Option;MaxLength@1008 : Integer) : Integer;
    VAR
      RecordRef@1006 : RecordRef;
      FieldRef@1005 : FieldRef;
      NewDescription@1004 : Text;
      StringLength@1009 : Integer;
    BEGIN
      IF NOT DataTypeManagement.GetRecordRefAndFieldRef(RecRelatedVariant,FieldNumber,RecordRef,FieldRef) THEN
        EXIT(0);

      StringLength := STRLEN(FORMAT(FieldRef.VALUE));
      IF StringLength <= MaxLength THEN
        EXIT(0);

      NewDescription := STRSUBSTNO(IfLengthExceededErr,FieldRef.CAPTION,FORMAT(RecordRef.RECORDID),MaxLength,StringLength);

      EXIT(LogMessage(RecRelatedVariant,FieldNumber,MessageType,NewDescription));
    END;

    [External]
    PROCEDURE LogIfInvalidCharacters@18(RecRelatedVariant@1000 : Variant;FieldNumber@1001 : Integer;MessageType@1002 : Option;ValidCharacters@1008 : Text) : Integer;
    VAR
      RecordRef@1006 : RecordRef;
      FieldRef@1005 : FieldRef;
      NewDescription@1004 : Text;
    BEGIN
      IF NOT DataTypeManagement.GetRecordRefAndFieldRef(RecRelatedVariant,FieldNumber,RecordRef,FieldRef) THEN
        EXIT(0);

      IF DELCHR(FORMAT(FieldRef.VALUE),'=',ValidCharacters) = '' THEN
        EXIT(0);

      NewDescription := STRSUBSTNO(IfInvalidCharactersErr,FieldRef.CAPTION,FORMAT(RecordRef.RECORDID));

      EXIT(LogMessage(RecRelatedVariant,FieldNumber,MessageType,NewDescription));
    END;

    [External]
    PROCEDURE LogIfOutsideRange@11(RecRelatedVariant@1000 : Variant;FieldNumber@1001 : Integer;MessageType@1002 : Option;LowerBound@1007 : Variant;UpperBound@1010 : Variant) : Integer;
    VAR
      RecordRef@1006 : RecordRef;
      FieldRef@1005 : FieldRef;
      NewDescription@1004 : Text;
    BEGIN
      IF FieldValueIsWithinFilter(RecRelatedVariant,FieldNumber,RecordRef,FieldRef,'%1..%2',LowerBound,UpperBound) THEN
        EXIT(0);

      NewDescription := STRSUBSTNO(IfOutsideRangeErr,FieldRef.CAPTION,FORMAT(RecordRef.RECORDID),LowerBound,UpperBound);

      EXIT(LogMessage(RecRelatedVariant,FieldNumber,MessageType,NewDescription));
    END;

    [External]
    PROCEDURE LogIfGreaterThan@13(RecRelatedVariant@1000 : Variant;FieldNumber@1001 : Integer;MessageType@1002 : Option;LowerBound@1007 : Variant) : Integer;
    VAR
      RecordRef@1006 : RecordRef;
      FieldRef@1005 : FieldRef;
      NewDescription@1004 : Text;
    BEGIN
      IF FieldValueIsWithinFilter(RecRelatedVariant,FieldNumber,RecordRef,FieldRef,'<=%1',LowerBound,'') THEN
        EXIT(0);

      NewDescription := STRSUBSTNO(IfGreaterThanErr,FieldRef.CAPTION,FORMAT(RecordRef.RECORDID),LowerBound);

      EXIT(LogMessage(RecRelatedVariant,FieldNumber,MessageType,NewDescription));
    END;

    [External]
    PROCEDURE LogIfLessThan@20(RecRelatedVariant@1000 : Variant;FieldNumber@1001 : Integer;MessageType@1002 : Option;UpperBound@1010 : Variant) : Integer;
    VAR
      RecordRef@1006 : RecordRef;
      FieldRef@1005 : FieldRef;
      NewDescription@1004 : Text;
    BEGIN
      IF FieldValueIsWithinFilter(RecRelatedVariant,FieldNumber,RecordRef,FieldRef,'>=%1',UpperBound,'') THEN
        EXIT(0);

      NewDescription := STRSUBSTNO(IfLessThanErr,FieldRef.CAPTION,FORMAT(RecordRef.RECORDID),UpperBound);

      EXIT(LogMessage(RecRelatedVariant,FieldNumber,MessageType,NewDescription));
    END;

    [External]
    PROCEDURE LogIfEqualTo@12(RecRelatedVariant@1000 : Variant;FieldNumber@1001 : Integer;MessageType@1002 : Option;ValueVariant@1010 : Variant) : Integer;
    VAR
      RecordRef@1006 : RecordRef;
      FieldRef@1005 : FieldRef;
      NewDescription@1004 : Text;
    BEGIN
      IF FieldValueIsWithinFilter(RecRelatedVariant,FieldNumber,RecordRef,FieldRef,'<>%1',ValueVariant,'') THEN
        EXIT(0);

      NewDescription := STRSUBSTNO(IfEqualToErr,FieldRef.CAPTION,FORMAT(RecordRef.RECORDID),ValueVariant);

      EXIT(LogMessage(RecRelatedVariant,FieldNumber,MessageType,NewDescription));
    END;

    [External]
    PROCEDURE LogIfNotEqualTo@14(RecRelatedVariant@1000 : Variant;FieldNumber@1001 : Integer;MessageType@1002 : Option;ValueVariant@1010 : Variant) : Integer;
    VAR
      RecordRef@1006 : RecordRef;
      FieldRef@1005 : FieldRef;
      NewDescription@1004 : Text;
    BEGIN
      IF FieldValueIsWithinFilter(RecRelatedVariant,FieldNumber,RecordRef,FieldRef,'=%1',ValueVariant,'') THEN
        EXIT(0);

      NewDescription := STRSUBSTNO(IfNotEqualToErr,FieldRef.CAPTION,FORMAT(RecordRef.RECORDID),ValueVariant);

      EXIT(LogMessage(RecRelatedVariant,FieldNumber,MessageType,NewDescription));
    END;

    [External]
    PROCEDURE LogSimpleMessage@10(MessageType@1003 : Option;NewDescription@1004 : Text) : Integer;
    BEGIN
      AssertRecordTemporaryOrInContext;

      ID := 1;
      ClearFilters;
      IF FINDLAST THEN
        ID += 1;

      INIT;
      VALIDATE("Message Type",MessageType);
      VALIDATE(Description,COPYSTR(NewDescription,1,MAXSTRLEN(Description)));
      VALIDATE("Context Record ID",ContextRecordID);
      INSERT(TRUE);

      EXIT(ID);
    END;

    [External]
    PROCEDURE LogMessage@2(RecRelatedVariant@1000 : Variant;FieldNumber@1002 : Integer;MessageType@1003 : Option;NewDescription@1004 : Text) : Integer;
    VAR
      RecordRef@1001 : RecordRef;
      ErrorMessageID@1005 : Integer;
    BEGIN
      IF NOT DataTypeManagement.GetRecordRef(RecRelatedVariant,RecordRef) THEN
        EXIT(0);

      ErrorMessageID := FindRecord(RecordRef.RECORDID,FieldNumber,MessageType,NewDescription);
      IF ErrorMessageID <> 0 THEN
        EXIT(ErrorMessageID);

      LogSimpleMessage(MessageType,NewDescription);
      VALIDATE("Record ID",RecordRef.RECORDID);
      VALIDATE("Field Number",FieldNumber);
      MODIFY(TRUE);

      EXIT(ID);
    END;

    [External]
    PROCEDURE LogDetailedMessage@3(RecRelatedVariant@1003 : Variant;FieldNumber@1002 : Integer;MessageType@1001 : Option;NewDescription@1006 : Text;AdditionalInformation@1004 : Text[250];SupportUrl@1005 : Text[250]) : Integer;
    BEGIN
      LogMessage(RecRelatedVariant,FieldNumber,MessageType,NewDescription);
      VALIDATE("Additional Information",AdditionalInformation);
      VALIDATE("Support Url",SupportUrl);
      MODIFY(TRUE);

      EXIT(ID);
    END;

    [External]
    PROCEDURE AddMessageDetails@6(MessageID@1000 : Integer;AdditionalInformation@1002 : Text[250];SupportUrl@1001 : Text[250]);
    BEGIN
      IF MessageID = 0 THEN
        EXIT;

      GET(MessageID);
      VALIDATE("Additional Information",AdditionalInformation);
      VALIDATE("Support Url",SupportUrl);
      MODIFY(TRUE);
    END;

    [External]
    PROCEDURE SetContext@25(ContextRecordVariant@1002 : Variant);
    VAR
      RecordRef@1000 : RecordRef;
    BEGIN
      IF DataTypeManagement.GetRecordRef(ContextRecordVariant,RecordRef) THEN
        ContextRecordID := RecordRef.RECORDID;
    END;

    [External]
    PROCEDURE ClearContext@22();
    BEGIN
      CLEAR(ContextRecordID);
    END;

    [External]
    PROCEDURE ClearLog@7();
    BEGIN
      AssertRecordTemporaryOrInContext;

      ClearFilters;
      SetContextFilter;
      DELETEALL(TRUE);
    END;

    [External]
    PROCEDURE ClearLogRec@23(RecordVariant@1000 : Variant);
    BEGIN
      AssertRecordTemporaryOrInContext;

      ClearFilters;
      SetContextFilter;
      SetRecordFilter(RecordVariant);
      DELETEALL(TRUE);
    END;

    [External]
    PROCEDURE HasErrorMessagesRelatedTo@1(RecRelatedVariant@1000 : Variant) : Boolean;
    VAR
      RecordRef@1001 : RecordRef;
    BEGIN
      AssertRecordTemporaryOrInContext;

      IF NOT DataTypeManagement.GetRecordRef(RecRelatedVariant,RecordRef) THEN
        EXIT(FALSE);

      ClearFilters;
      SetContextFilter;
      SETRANGE("Record ID",RecordRef.RECORDID);
      EXIT(NOT ISEMPTY);
    END;

    [External]
    PROCEDURE ErrorMessageCount@8(LowestSeverityMessageType@1000 : Option) : Integer;
    BEGIN
      AssertRecordTemporaryOrInContext;

      ClearFilters;
      SetContextFilter;
      SETRANGE("Message Type","Message Type"::Error,LowestSeverityMessageType);
      EXIT(COUNT);
    END;

    [External]
    PROCEDURE HasErrors@9(ShowMessage@1000 : Boolean) : Boolean;
    BEGIN
      IF ErrorMessageCount("Message Type"::Error) = 0 THEN
        EXIT(FALSE);

      IF ShowMessage AND GUIALLOWED THEN
        MESSAGE(HasErrorsMsg);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ShowErrorMessages@5(RollBackOnError@1001 : Boolean) ErrorString : Text;
    VAR
      ErrorMessages@1000 : Page 700;
    BEGIN
      AssertRecordTemporaryOrInContext;

      ClearFilters;
      SetContextFilter;
      IF ISEMPTY THEN
        EXIT;

      IF GUIALLOWED THEN BEGIN
        ErrorMessages.SetRecords(Rec);
        ErrorMessages.RUN;
      END;

      ErrorString := ToString;

      IF RollBackOnError THEN
        IF HasErrors(FALSE) THEN
          ERROR('');

      EXIT;
    END;

    [External]
    PROCEDURE ToString@15() : Text;
    VAR
      ErrorString@1000 : Text;
    BEGIN
      AssertRecordTemporaryOrInContext;

      ClearFilters;
      SetContextFilter;
      SETCURRENTKEY("Message Type",ID);
      IF FINDSET THEN
        REPEAT
          IF ErrorString <> '' THEN
            ErrorString += '\';
          ErrorString += FORMAT("Message Type") + ': ' + Description;
        UNTIL NEXT = 0;
      ClearFilters;
      EXIT(ErrorString);
    END;

    [External]
    PROCEDURE ThrowError@16();
    BEGIN
      AssertRecordTemporaryOrInContext;

      IF HasErrors(FALSE) THEN
        ERROR(ToString);
    END;

    LOCAL PROCEDURE FieldValueIsWithinFilter@30(RecRelatedVariant@1004 : Variant;FieldNumber@1003 : Integer;VAR RecordRef@1000 : RecordRef;VAR FieldRef@1001 : FieldRef;FilterString@1002 : Text;FilterValue1@1005 : Variant;FilterValue2@1006 : Variant) : Boolean;
    VAR
      TempRecordRef@1013 : RecordRef;
      TempFieldRef@1011 : FieldRef;
    BEGIN
      IF NOT DataTypeManagement.GetRecordRefAndFieldRef(RecRelatedVariant,FieldNumber,RecordRef,FieldRef) THEN
        EXIT(FALSE);

      TempRecordRef.OPEN(RecordRef.NUMBER,TRUE);
      TempRecordRef.INIT;
      TempFieldRef := TempRecordRef.FIELD(FieldNumber);
      TempFieldRef.VALUE(FieldRef.VALUE);
      TempRecordRef.INSERT;

      TempFieldRef.SETFILTER(FilterString,FilterValue1,FilterValue2);

      EXIT(NOT TempRecordRef.ISEMPTY);
    END;

    [External]
    PROCEDURE FindRecord@21(RecordID@1000 : RecordID;FieldNumber@1003 : Integer;MessageType@1004 : Option;NewDescription@1002 : Text) : Integer;
    BEGIN
      ClearFilters;
      SetContextFilter;
      SETRANGE("Record ID",RecordID);
      SETRANGE("Field Number",FieldNumber);
      SETRANGE("Message Type",MessageType);
      SETRANGE(Description,COPYSTR(NewDescription,1,MAXSTRLEN(Description)));
      IF FINDFIRST THEN
        EXIT(ID);
      EXIT(0);
    END;

    LOCAL PROCEDURE AssertRecordTemporary@32();
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(DevMsgNotTemporaryErr);
    END;

    LOCAL PROCEDURE AssertRecordTemporaryOrInContext@27();
    VAR
      DummyEmptyRecordID@1000 : RecordID;
    BEGIN
      IF ContextRecordID = DummyEmptyRecordID THEN
        AssertRecordTemporary;
    END;

    [External]
    PROCEDURE CopyToTemp@38(VAR TempErrorMessage@1000 : TEMPORARY Record 700);
    VAR
      TempID@1001 : Integer;
    BEGIN
      IF NOT FINDSET THEN
        EXIT;

      TempErrorMessage.RESET;
      IF TempErrorMessage.FINDLAST THEN ;
      TempID := TempErrorMessage.ID;

      REPEAT
        IF TempErrorMessage.FindRecord("Record ID","Field Number","Message Type",Description) = 0 THEN BEGIN
          TempID += 1;
          TempErrorMessage := Rec;
          TempErrorMessage.ID := TempID;
          TempErrorMessage.INSERT;
        END;
      UNTIL NEXT = 0;
      TempErrorMessage.RESET;
    END;

    [External]
    PROCEDURE CopyFromTemp@4(VAR TempErrorMessage@1000 : TEMPORARY Record 700);
    VAR
      ErrorMessage@1001 : Record 700;
    BEGIN
      IF NOT TempErrorMessage.FINDSET THEN
        EXIT;

      REPEAT
        ErrorMessage := TempErrorMessage;
        ErrorMessage.ID := 0;
        ErrorMessage.INSERT(TRUE);
      UNTIL TempErrorMessage.NEXT = 0;
    END;

    [External]
    PROCEDURE CopyFromContext@24(ContextRecordVariant@1000 : Variant);
    VAR
      ErrorMessage@1001 : Record 700;
      RecordRef@1002 : RecordRef;
    BEGIN
      AssertRecordTemporary;

      IF NOT DataTypeManagement.GetRecordRef(ContextRecordVariant,RecordRef) THEN
        EXIT;

      ErrorMessage.SETRANGE("Context Record ID",RecordRef.RECORDID);
      ErrorMessage.CopyToTemp(Rec);
    END;

    LOCAL PROCEDURE ClearFilters@31();
    VAR
      LocalContextRecordID@1000 : RecordID;
    BEGIN
      LocalContextRecordID := ContextRecordID;
      RESET;
      ContextRecordID := LocalContextRecordID;
    END;

    LOCAL PROCEDURE SetContextFilter@33();
    VAR
      DummyEmptyContextRecordID@1000 : RecordID;
    BEGIN
      IF ContextRecordID = DummyEmptyContextRecordID THEN
        SETRANGE("Context Record ID")
      ELSE
        SETRANGE("Context Record ID",ContextRecordID);
    END;

    LOCAL PROCEDURE SetRecordFilter@26(RecordVariant@1000 : Variant);
    VAR
      RecordRef@1001 : RecordRef;
    BEGIN
      DataTypeManagement.GetRecordRef(RecordVariant,RecordRef);
      SETRANGE("Record ID",RecordRef.RECORDID);
    END;

    BEGIN
    END.
  }
}

