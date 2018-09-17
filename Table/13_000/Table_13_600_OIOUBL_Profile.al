OBJECT Table 13600 OIOUBL Profile
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVDK11.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=OIOUBL-profil;
               ENU=OIOUBL Profile];
    LookupPageID=Page13600;
    DrillDownPageID=Page13600;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code] }
    { 2   ;   ;Profile ID          ;Text50        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Profil-id;
                                                              ENU=Profile ID] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;AllFields           ;Code,Profile ID                          }
  }
  CODE
  {

    PROCEDURE GetOIOUBLProfileID@1060000(OIOUBLProfileCode@1060000 : Code[10];CustomerNo@1060003 : Code[20]) : Text;
    VAR
      OIOUBLProfile@1060001 : Record 13600;
      SalesSetup@1060002 : Record 311;
      Customer@1060004 : Record 18;
    BEGIN
      IF OIOUBLProfileCode = '' THEN BEGIN
        Customer.GET(CustomerNo);
        OIOUBLProfileCode := Customer."OIOUBL Profile Code";
        IF OIOUBLProfileCode = '' THEN BEGIN
          SalesSetup.GET;
          SalesSetup.TESTFIELD("Default OIOUBL Profile Code");
          OIOUBLProfileCode := SalesSetup."Default OIOUBL Profile Code";
        END;
      END;

      OIOUBLProfile.GET(OIOUBLProfileCode);
      OIOUBLProfile.TESTFIELD("Profile ID");

      EXIT(OIOUBLProfile."Profile ID");
    END;

    PROCEDURE UpdateEmptyOIOUBLProfileCodes@1060002(OIOUBLProfileCode@1060000 : Code[10];PrevOIOUBLProfileCode@1060001 : Code[10]);
    VAR
      SalesHeader@1060002 : Record 36;
      ServiceHeader@1060003 : Record 5900;
    BEGIN
      IF (OIOUBLProfileCode <> PrevOIOUBLProfileCode) AND (PrevOIOUBLProfileCode = '') THEN BEGIN
        SalesHeader.SETRANGE("OIOUBL Profile Code",'');
        SalesHeader.MODIFYALL("OIOUBL Profile Code",OIOUBLProfileCode);

        ServiceHeader.SETRANGE("OIOUBL Profile Code",'');
        ServiceHeader.MODIFYALL("OIOUBL Profile Code",OIOUBLProfileCode);
      END;
    END;

    BEGIN
    END.
  }
}

