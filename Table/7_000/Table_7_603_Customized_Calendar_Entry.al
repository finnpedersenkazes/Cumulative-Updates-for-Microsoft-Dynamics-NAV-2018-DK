OBJECT Table 7603 Customized Calendar Entry
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tilpasset kalenderpost;
               ENU=Customized Calendar Entry];
  }
  FIELDS
  {
    { 1   ;   ;Source Type         ;Option        ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=Virksomhed,Debitor,Kreditor,Lokation,Spedit�r,Service;
                                                                    ENU=Company,Customer,Vendor,Location,Shipping Agent,Service];
                                                   OptionString=Company,Customer,Vendor,Location,Shipping Agent,Service;
                                                   Editable=No }
    { 2   ;   ;Source Code         ;Code20        ;CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code];
                                                   Editable=No }
    { 3   ;   ;Additional Source Code;Code20      ;CaptionML=[DAN=Ekstra kildespor;
                                                              ENU=Additional Source Code] }
    { 4   ;   ;Base Calendar Code  ;Code10        ;TableRelation="Base Calendar";
                                                   CaptionML=[DAN=Basiskalenderkode;
                                                              ENU=Base Calendar Code];
                                                   Editable=No }
    { 5   ;   ;Date                ;Date          ;CaptionML=[DAN=Dato;
                                                              ENU=Date];
                                                   Editable=No }
    { 6   ;   ;Description         ;Text30        ;OnValidate=BEGIN
                                                                UpdateExceptionEntry;
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 7   ;   ;Nonworking          ;Boolean       ;OnValidate=BEGIN
                                                                UpdateExceptionEntry;
                                                              END;

                                                   CaptionML=[DAN=Fridag;
                                                              ENU=Nonworking];
                                                   Editable=Yes }
  }
  KEYS
  {
    {    ;Source Type,Source Code,Additional Source Code,Base Calendar Code,Date;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Customer@1003 : Record 18;
      Vendor@1002 : Record 23;
      Location@1001 : Record 14;
      ServMgtsetup@1004 : Record 5911;
      ShippingAgentService@1000 : Record 5790;

    LOCAL PROCEDURE UpdateExceptionEntry@1();
    VAR
      CalendarException@1001 : Record 7602;
    BEGIN
      CalendarException.SETRANGE("Source Type","Source Type");
      CalendarException.SETRANGE("Source Code","Source Code");
      CalendarException.SETRANGE("Base Calendar Code","Base Calendar Code");
      CalendarException.SETRANGE(Date,Date);
      CalendarException.DELETEALL;
      CalendarException.INIT;
      CalendarException."Source Type" := "Source Type";
      CalendarException."Source Code" := "Source Code";
      CalendarException."Base Calendar Code" := "Base Calendar Code";
      CalendarException.VALIDATE(Date,Date);
      CalendarException.Nonworking := Nonworking;
      CalendarException.Description := Description;
      CalendarException.INSERT;
    END;

    [External]
    PROCEDURE GetCaption@2() : Text[250];
    BEGIN
      CASE "Source Type" OF
        "Source Type"::Company:
          EXIT(COMPANYNAME);
        "Source Type"::Customer:
          IF Customer.GET("Source Code") THEN
            EXIT("Source Code" + ' ' + Customer.Name);
        "Source Type"::Vendor:
          IF Vendor.GET("Source Code") THEN
            EXIT("Source Code" + ' ' + Vendor.Name);
        "Source Type"::Location:
          IF Location.GET("Source Code") THEN
            EXIT("Source Code" + ' ' + Location.Name);
        "Source Type"::"Shipping Agent":
          IF ShippingAgentService.GET("Source Code","Additional Source Code") THEN
            EXIT("Source Code" + ' ' + "Additional Source Code" + ' ' + ShippingAgentService.Description);
        "Source Type"::Service:
          IF ServMgtsetup.GET THEN
            EXIT("Source Code" + ' ' + ServMgtsetup.TABLECAPTION);
      END;
    END;

    BEGIN
    END.
  }
}

