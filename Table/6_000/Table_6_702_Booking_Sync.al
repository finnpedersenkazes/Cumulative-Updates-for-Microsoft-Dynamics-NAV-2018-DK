OBJECT Table 6702 Booking Sync
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 1261=rimd;
    CaptionML=[DAN=Bookings-synkronisering;
               ENU=Booking Sync];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim‘r n›gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Booking Mailbox Address;Text80     ;CaptionML=[DAN=Adresse for Bookings-postkasse;
                                                              ENU=Booking Mailbox Address] }
    { 3   ;   ;Booking Mailbox Name;Text250       ;CaptionML=[DAN=Navn til Bookings-postkasse;
                                                              ENU=Booking Mailbox Name] }
    { 4   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   NotBlank=Yes }
    { 5   ;   ;Last Customer Sync  ;DateTime      ;CaptionML=[DAN=Sidste debitorsynkronisering;
                                                              ENU=Last Customer Sync];
                                                   Editable=Yes }
    { 6   ;   ;Last Service Sync   ;DateTime      ;CaptionML=[DAN=Sidste tjenestesynkronisering;
                                                              ENU=Last Service Sync] }
    { 7   ;   ;Enabled             ;Boolean       ;CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
    { 8   ;   ;Sync Customers      ;Boolean       ;CaptionML=[DAN=Synkroniser debitorer;
                                                              ENU=Sync Customers] }
    { 9   ;   ;Customer Filter     ;BLOB          ;CaptionML=[DAN=Debitorfilter;
                                                              ENU=Customer Filter] }
    { 10  ;   ;Customer Template Code;Code10      ;TableRelation="Customer Template".Code;
                                                   CaptionML=[DAN=Debitorskabelonkode;
                                                              ENU=Customer Template Code] }
    { 12  ;   ;Sync Services       ;Boolean       ;CaptionML=[DAN=Synkroniseringstjenester;
                                                              ENU=Sync Services] }
    { 13  ;   ;Item Filter         ;BLOB          ;CaptionML=[DAN=Varefilter;
                                                              ENU=Item Filter] }
    { 14  ;   ;Item Template Code  ;Code10        ;TableRelation="Config. Template Header".Code WHERE (Table ID=FILTER(27));
                                                   CaptionML=[DAN=Vareskabelonkode;
                                                              ENU=Item Template Code] }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
    {    ;Booking Mailbox Address                  }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE GetCustomerFilter@1() FilterText : Text;
    VAR
      ReadStream@1000 : InStream;
    BEGIN
      CALCFIELDS("Customer Filter");
      "Customer Filter".CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(FilterText);
    END;

    [External]
    PROCEDURE GetItemFilter@2() FilterText : Text;
    VAR
      ReadStream@1000 : InStream;
    BEGIN
      CALCFIELDS("Item Filter");
      "Item Filter".CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(FilterText);
    END;

    [External]
    PROCEDURE SaveCustomerFilter@6(FilterText@1000 : Text);
    VAR
      WriteStream@1001 : OutStream;
    BEGIN
      CLEAR("Customer Filter");
      "Customer Filter".CREATEOUTSTREAM(WriteStream);
      WriteStream.WRITETEXT(FilterText);
      CLEAR("Last Customer Sync");
      MODIFY;
    END;

    [External]
    PROCEDURE SaveItemFilter@7(FilterText@1000 : Text);
    VAR
      WriteStream@1001 : OutStream;
    BEGIN
      CLEAR("Item Filter");
      "Item Filter".CREATEOUTSTREAM(WriteStream);
      WriteStream.WRITETEXT(FilterText);
      CLEAR("Last Service Sync");
      MODIFY;
    END;

    [External]
    PROCEDURE IsSetup@3() : Boolean;
    VAR
      PermissionManager@1000 : Codeunit 9002;
    BEGIN
      IF PermissionManager.SoftwareAsAService THEN
        EXIT(GET AND ("Last Service Sync" <> 0DT));
    END;

    BEGIN
    END.
  }
}

