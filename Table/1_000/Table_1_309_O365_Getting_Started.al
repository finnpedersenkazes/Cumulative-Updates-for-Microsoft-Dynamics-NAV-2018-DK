OBJECT Table 1309 O365 Getting Started
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=O365-introduktion;
               ENU=O365 Getting Started];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Text132       ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 2   ;   ;Display Target      ;Code20        ;CaptionML=[DAN=Visningsm†l;
                                                              ENU=Display Target] }
    { 10  ;   ;Current Page        ;Integer       ;InitValue=1;
                                                   CaptionML=[DAN=Aktuel side;
                                                              ENU=Current Page] }
    { 11  ;   ;Tour in Progress    ;Boolean       ;CaptionML=[DAN=Igangv‘rende guide;
                                                              ENU=Tour in Progress] }
    { 12  ;   ;Tour Completed      ;Boolean       ;CaptionML=[DAN=Guide fuldf›rt;
                                                              ENU=Tour Completed] }
  }
  KEYS
  {
    {    ;User ID,Display Target                  ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ClientTypeManagement@1077 : Codeunit 4;

    [External]
    PROCEDURE AlreadyShown@4() : Boolean;
    BEGIN
      EXIT(GET(USERID,ClientTypeManagement.GetCurrentClientType));
    END;

    [External]
    PROCEDURE MarkAsShown@1();
    BEGIN
      INIT;
      "User ID" := USERID;
      "Display Target" := FORMAT(ClientTypeManagement.GetCurrentClientType);
      INSERT;
    END;

    [Integration]
    PROCEDURE OnO365DemoCompanyInitialize@2();
    BEGIN
    END;

    BEGIN
    END.
  }
}

