OBJECT Table 51 User Time Register
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Brugertidsforbrug;
               ENU=User Time Register];
    LookupPageID=Page71;
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=VAR
                                                                UserMgt@1000 : Codeunit 418;
                                                              BEGIN
                                                                UserMgt.ValidateUserID("User ID");
                                                              END;

                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   NotBlank=Yes }
    { 2   ;   ;Date                ;Date          ;CaptionML=[DAN=Dato;
                                                              ENU=Date] }
    { 3   ;   ;Minutes             ;Decimal       ;CaptionML=[DAN=Minutter;
                                                              ENU=Minutes];
                                                   DecimalPlaces=0:0;
                                                   MinValue=0 }
  }
  KEYS
  {
    {    ;User ID,Date                            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

