OBJECT Table 5113 Contact Dupl. Details Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontaktdubletdetaljebuffer;
               ENU=Contact Dupl. Details Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Field No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 2   ;   ;Field Name          ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Feltnavn;
                                                              ENU=Field Name] }
    { 3   ;   ;Field Value         ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Feltv�rdi;
                                                              ENU=Field Value] }
    { 4   ;   ;Duplicate Field Value;Text250      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dubletfeltv�rdi;
                                                              ENU=Duplicate Field Value] }
  }
  KEYS
  {
    {    ;Field No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE CreateContactDuplicateDetails@1(ContactNo@1007 : Code[20];DuplicateContactNo@1006 : Code[20]);
    VAR
      DuplicateSearchStringSetup@1000 : Record 5095;
      Contact@1001 : Record 5050;
      DuplicateContact@1002 : Record 5050;
      ContactRecRef@1003 : RecordRef;
      DuplicateContactRecRef@1004 : RecordRef;
      FieldRef@1005 : FieldRef;
    BEGIN
      IF (ContactNo = '') OR (DuplicateContactNo = '') THEN
        EXIT;

      Contact.GET(ContactNo);
      DuplicateContact.GET(DuplicateContactNo);
      ContactRecRef.GETTABLE(Contact);
      DuplicateContactRecRef.GETTABLE(DuplicateContact);

      DuplicateSearchStringSetup.FINDSET;
      REPEAT
        INIT;
        "Field No." := DuplicateSearchStringSetup."Field No.";
        "Field Name" := DuplicateSearchStringSetup."Field Name";
        FieldRef := ContactRecRef.FIELD("Field No.");
        "Field Value" := FieldRef.VALUE;
        FieldRef := DuplicateContactRecRef.FIELD("Field No.");
        "Duplicate Field Value" := FieldRef.VALUE;
        IF INSERT THEN;
      UNTIL DuplicateSearchStringSetup.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

