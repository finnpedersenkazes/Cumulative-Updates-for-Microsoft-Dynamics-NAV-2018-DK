OBJECT Table 9154 My Job
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Min sag;
               ENU=My Job];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.];
                                                   NotBlank=Yes }
    { 3   ;   ;Exclude from Business Chart;Boolean;CaptionML=[DAN=Udeluk fra virksomhedsdiagram;
                                                              ENU=Exclude from Business Chart] }
    { 4   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 5   ;   ;Status              ;Option        ;InitValue=Open;
                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Planlëgning,Tilbud,èben,Afsluttet;
                                                                    ENU=Planning,Quote,Open,Completed];
                                                   OptionString=Planning,Quote,Open,Completed }
    { 6   ;   ;Bill-to Name        ;Text50        ;CaptionML=[DAN=Faktureringsnavn;
                                                              ENU=Bill-to Name] }
    { 7   ;   ;Percent Completed   ;Decimal       ;CaptionML=[DAN=Procent afsluttet;
                                                              ENU=Percent Completed] }
    { 8   ;   ;Percent Invoiced    ;Decimal       ;CaptionML=[DAN=Procent faktureret;
                                                              ENU=Percent Invoiced] }
  }
  KEYS
  {
    {    ;User ID,Job No.                         ;Clustered=Yes }
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

