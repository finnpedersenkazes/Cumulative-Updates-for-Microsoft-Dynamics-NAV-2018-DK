OBJECT Table 1512 Notification Setup
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    OnDelete=VAR
               NotificationSchedule@1000 : Record 1513;
             BEGIN
               IF NotificationSchedule.GET("User ID","Notification Type") THEN
                 NotificationSchedule.DELETE(TRUE);
             END;

    CaptionML=[DAN=Konfiguration af notifikation;
               ENU=Notification Setup];
    LookupPageID=Page1512;
    DrillDownPageID=Page1512;
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Notification Type   ;Option        ;CaptionML=[DAN=Notifikationstype;
                                                              ENU=Notification Type];
                                                   OptionCaptionML=[DAN=Ny record,Godkendelse,Forfald;
                                                                    ENU=New Record,Approval,Overdue];
                                                   OptionString=New Record,Approval,Overdue }
    { 3   ;   ;Notification Method ;Option        ;CaptionML=[DAN=Notifikationsmetode;
                                                              ENU=Notification Method];
                                                   OptionCaptionML=[DAN=Mail,Notat;
                                                                    ENU=Email,Note];
                                                   OptionString=Email,Note }
    { 5   ;   ;Schedule            ;Option        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Notification Schedule".Recurrence WHERE (User ID=FIELD(User ID),
                                                                                                                Notification Type=FIELD(Notification Type)));
                                                   CaptionML=[DAN=Plan;
                                                              ENU=Schedule];
                                                   OptionCaptionML=[DAN=ùjeblikkeligt,Dagligt,Ugentligt,MÜnedligt;
                                                                    ENU=Instantly,Daily,Weekly,Monthly];
                                                   OptionString=Instantly,Daily,Weekly,Monthly }
    { 6   ;   ;Display Target      ;Option        ;CaptionML=[DAN=VisningsmÜl;
                                                              ENU=Display Target];
                                                   OptionCaptionML=[DAN=Web,Windows;
                                                                    ENU=Web,Windows];
                                                   OptionString=Web,Windows }
  }
  KEYS
  {
    {    ;User ID,Notification Type               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE GetNotificationSetup@1(NotificationType@1002 : 'New Record,Approval,Overdue');
    VAR
      NotificationManagement@1000 : Codeunit 1510;
    BEGIN
      IF GET(USERID,NotificationType) THEN
        EXIT;
      IF GET('',NotificationType) THEN
        EXIT;
      NotificationManagement.CreateDefaultNotificationSetup(NotificationType);
      GET('',NotificationType)
    END;

    [External]
    PROCEDURE GetNotificationSetupForUser@2(NotificationType@1000 : 'New Record,Approval,Overdue';RecipientUserID@1001 : Code[50]);
    BEGIN
      IF GET(RecipientUserID,NotificationType) THEN
        EXIT;
      GetNotificationSetup(NotificationType);
    END;

    BEGIN
    END.
  }
}

