OBJECT Table 9191 Terms And Conditions State
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    CaptionML=[DAN=Tilstand for vilk†r og betingelser;
               ENU=Terms And Conditions State];
  }
  FIELDS
  {
    { 1   ;   ;Terms And Conditions Code;Code20   ;TableRelation="Terms And Conditions";
                                                   CaptionML=[DAN=Kode for vilk†r og betingelser;
                                                              ENU=Terms And Conditions Code] }
    { 2   ;   ;User ID             ;Code50        ;TableRelation=User;
                                                   ValidateTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 3   ;   ;Accepted            ;Boolean       ;CaptionML=[DAN=Accepteret;
                                                              ENU=Accepted] }
    { 4   ;   ;Date Accepted       ;DateTime      ;CaptionML=[DAN=Dato accepteret;
                                                              ENU=Date Accepted] }
  }
  KEYS
  {
    {    ;Terms And Conditions Code,User ID       ;Clustered=Yes }
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

