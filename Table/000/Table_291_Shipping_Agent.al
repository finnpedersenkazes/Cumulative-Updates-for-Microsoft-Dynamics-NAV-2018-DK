OBJECT Table 291 Shipping Agent
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    DataCaptionFields=Code,Name;
    OnDelete=VAR
               ShippingAgentServices@1000 : Record 5790;
             BEGIN
               ShippingAgentServices.SETRANGE("Shipping Agent Code",Code);
               ShippingAgentServices.DELETEALL;

               CalendarManagement.DeleteCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::"Shipping Agent",Code);
             END;

    OnRename=BEGIN
               CalendarManagement.RenameCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::"Shipping Agent",Code,xRec.Code);
             END;

    CaptionML=[DAN=Spedit›r;
               ENU=Shipping Agent];
    LookupPageID=Page428;
    DrillDownPageID=Page428;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Internet Address    ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=Internet-adresse;
                                                              ENU=Internet Address] }
    { 4   ;   ;Account No.         ;Text30        ;CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CustomizedCalendarChange@1001 : Record 7602;
      CalendarManagement@1000 : Codeunit 7600;

    BEGIN
    END.
  }
}

