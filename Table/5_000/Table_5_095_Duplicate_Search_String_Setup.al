OBJECT Table 5095 Duplicate Search String Setup
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnDelete=VAR
               ContDuplicateSearchString@1000 : Record 5086;
             BEGIN
               ContDuplicateSearchString.SETRANGE("Field No.","Field No.");
               ContDuplicateSearchString.SETRANGE("Part of Field","Part of Field");
               ContDuplicateSearchString.DELETEALL;
             END;

    CaptionML=[DAN=Ops�tn. af dublets�gestreng;
               ENU=Duplicate Search String Setup];
  }
  FIELDS
  {
    { 1   ;   ;Field No.           ;Integer       ;OnValidate=VAR
                                                                Field@1000 : Record 2000000041;
                                                              BEGIN
                                                                Field.GET(DATABASE::Contact,"Field No.");
                                                                "Field Name" := Field.FieldName;
                                                              END;

                                                   CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 2   ;   ;Part of Field       ;Option        ;CaptionML=[DAN=Del af felt;
                                                              ENU=Part of Field];
                                                   OptionCaptionML=[DAN=F�rste,Sidste;
                                                                    ENU=First,Last];
                                                   OptionString=First,Last }
    { 3   ;   ;Length              ;Integer       ;InitValue=5;
                                                   CaptionML=[DAN=L�ngde;
                                                              ENU=Length];
                                                   MinValue=2;
                                                   MaxValue=10 }
    { 4   ;   ;Field Name          ;Text30        ;CaptionML=[DAN=Feltnavn;
                                                              ENU=Field Name] }
  }
  KEYS
  {
    {    ;Field No.,Part of Field                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE CreateDefaultSetup@1();
    VAR
      Contact@1000 : Record 5050;
    BEGIN
      DELETEALL;

      InsertDuplicateSearchString(Contact.FIELDNO(Name),5);
      InsertDuplicateSearchString(Contact.FIELDNO(Address),5);
      InsertDuplicateSearchString(Contact.FIELDNO(City),5);
      InsertDuplicateSearchString(Contact.FIELDNO("Phone No."),5);
      InsertDuplicateSearchString(Contact.FIELDNO("VAT Registration No."),5);
      InsertDuplicateSearchString(Contact.FIELDNO("Post Code"),5);
      InsertDuplicateSearchString(Contact.FIELDNO("E-Mail"),5);
      InsertDuplicateSearchString(Contact.FIELDNO("Mobile Phone No."),5);
    END;

    LOCAL PROCEDURE InsertDuplicateSearchString@3(FieldNo@1000 : Integer;SearchLength@1001 : Integer);
    BEGIN
      INIT;
      VALIDATE("Field No.",FieldNo);
      VALIDATE("Part of Field","Part of Field"::First);
      VALIDATE(Length,SearchLength);
      INSERT;

      VALIDATE("Part of Field","Part of Field"::Last);
      INSERT;
    END;

    [External]
    PROCEDURE LookupFieldName@2();
    VAR
      Field@1001 : Record 2000000041;
      FieldList@1000 : Page 6218;
    BEGIN
      CLEAR(FieldList);
      Field.SETRANGE(TableNo,DATABASE::Contact);
      Field.SETFILTER(Type,'%1|%2',Field.Type::Text,Field.Type::Code);
      Field.SETRANGE(Class,Field.Class::Normal);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      FieldList.SETTABLEVIEW(Field);
      FieldList.LOOKUPMODE := TRUE;
      IF FieldList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        FieldList.GETRECORD(Field);
        VALIDATE("Field No.",Field."No.");
      END;
    END;

    BEGIN
    END.
  }
}

