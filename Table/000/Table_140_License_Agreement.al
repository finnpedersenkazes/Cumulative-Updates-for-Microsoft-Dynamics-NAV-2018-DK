OBJECT Table 140 License Agreement
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
               TESTFIELD("Primary Key",'');
             END;

    CaptionML=[DAN=Licensaftale;
               ENU=License Agreement];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim‘rn›gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Message for Accepting User;Text250 ;CaptionML=[DAN=Meddelelse til accepterende bruger;
                                                              ENU=Message for Accepting User] }
    { 3   ;   ;Effective Date      ;Date          ;OnValidate=BEGIN
                                                                IF "Effective Date" <> xRec."Effective Date" THEN BEGIN
                                                                  "Effective Date Changed By" := USERID;
                                                                  "Effective Date Changed On" := CURRENTDATETIME;
                                                                  VALIDATE(Accepted,FALSE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Ikrafttr‘delsesdato;
                                                              ENU=Effective Date] }
    { 4   ;   ;Effective Date Changed By;Text65   ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Ikrafttr‘delsesdato ‘ndret af;
                                                              ENU=Effective Date Changed By];
                                                   Editable=No }
    { 5   ;   ;Effective Date Changed On;DateTime ;CaptionML=[DAN=Ikrafttr‘delsesdato ‘ndret d.;
                                                              ENU=Effective Date Changed On];
                                                   Editable=No }
    { 6   ;   ;Accepted            ;Boolean       ;OnValidate=BEGIN
                                                                IF Accepted THEN BEGIN
                                                                  "Accepted By" := USERID;
                                                                  "Accepted On" := CURRENTDATETIME;
                                                                END ELSE BEGIN
                                                                  "Accepted By" := '';
                                                                  "Accepted On" := CREATEDATETIME(0D,0T);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Accepteret;
                                                              ENU=Accepted] }
    { 7   ;   ;Accepted By         ;Text65        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Accepteret af;
                                                              ENU=Accepted By];
                                                   Editable=No }
    { 8   ;   ;Accepted On         ;DateTime      ;CaptionML=[DAN=Accepteret d.;
                                                              ENU=Accepted On];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoPartnerAgreementErr@1001 : TextConst 'DAN=Partneren har ikke angivet aftalen.;ENU=The partner has not provided the agreement.';

    [External]
    PROCEDURE ShowEULA@1();
    BEGIN
      ERROR(NoPartnerAgreementErr)
    END;

    [External]
    PROCEDURE GetActive@2() : Boolean;
    BEGIN
      EXIT(("Effective Date" <> 0D) AND ("Effective Date" <= TODAY))
    END;

    BEGIN
    END.
  }
}

