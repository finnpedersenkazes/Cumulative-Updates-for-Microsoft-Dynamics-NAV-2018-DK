OBJECT Table 94 Inventory Posting Group
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
               CheckGroupUsage;
             END;

    CaptionML=[DAN=Varebogf›ringsgruppe;
               ENU=Inventory Posting Group];
    LookupPageID=Page112;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Code,Description                         }
  }
  CODE
  {
    VAR
      YouCannotDeleteErr@1001 : TextConst '@@@="%1 = Code";DAN=Du kan ikke slette %1.;ENU=You cannot delete %1.';

    LOCAL PROCEDURE CheckGroupUsage@1();
    VAR
      Item@1000 : Record 27;
      ValueEntry@1001 : Record 5802;
    BEGIN
      Item.SETRANGE("Inventory Posting Group",Code);
      IF NOT Item.ISEMPTY THEN
        ERROR(YouCannotDeleteErr,Code);

      ValueEntry.SETRANGE("Inventory Posting Group",Code);
      IF NOT ValueEntry.ISEMPTY THEN
        ERROR(YouCannotDeleteErr,Code);
    END;

    BEGIN
    END.
  }
}

