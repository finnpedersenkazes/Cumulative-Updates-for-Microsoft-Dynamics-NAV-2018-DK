OBJECT Table 5488 Trial Balance Entity Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=R†balanceenheds buffer;
               ENU=Trial Balance Entity Buffer];
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nr.;
                                                              ENU=No.] }
    { 2   ;   ;Name                ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Net Change Debit    ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debetbev‘gelse;
                                                              ENU=Net Change Debit] }
    { 4   ;   ;Net Change Credit   ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditbev‘gelse;
                                                              ENU=Net Change Credit] }
    { 5   ;   ;Balance at Date Debit;Text30       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debetsaldo til dato;
                                                              ENU=Balance at Date Debit] }
    { 6   ;   ;Balance at Date Credit;Text30      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditsaldo til dato;
                                                              ENU=Balance at Date Credit] }
    { 7   ;   ;Date Filter         ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 8   ;   ;Total Debit         ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Samlet debit;
                                                              ENU=Total Debit] }
    { 9   ;   ;Total Credit        ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Samlet kredit;
                                                              ENU=Total Credit] }
    { 10  ;   ;Account Type        ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontotype;
                                                              ENU=Account Type];
                                                   OptionCaptionML=[DAN=Bogf›ring,Overskrift,Sum,Fra-sum,Til-sum;
                                                                    ENU=Posting,Heading,Total,Begin-Total,End-Total];
                                                   OptionString=Posting,Heading,Total,Begin-Total,End-Total }
    { 11  ;   ;Account Id          ;GUID          ;TableRelation="G/L Account".Id;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Konto-id;
                                                              ENU=Account Id] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
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

