OBJECT Table 99000752 Shop Calendar Working Days
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Shop Calendar Code;
    OnInsert=BEGIN
               CheckRedundancy;
             END;

    OnRename=BEGIN
               CheckRedundancy;
             END;

    CaptionML=[DAN=Arb.dage (produktionskalender);
               ENU=Shop Calendar Working Days];
  }
  FIELDS
  {
    { 1   ;   ;Shop Calendar Code  ;Code10        ;TableRelation="Shop Calendar";
                                                   CaptionML=[DAN=Produktionskalenderkode;
                                                              ENU=Shop Calendar Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Day                 ;Option        ;CaptionML=[DAN=Dag;
                                                              ENU=Day];
                                                   OptionCaptionML=[DAN=Mandag,Tirsdag,Onsdag,Torsdag,Fredag,L�rdag,S�ndag;
                                                                    ENU=Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday];
                                                   OptionString=Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday }
    { 3   ;   ;Work Shift Code     ;Code10        ;TableRelation="Work Shift";
                                                   CaptionML=[DAN=Arbejdsskiftskode;
                                                              ENU=Work Shift Code];
                                                   NotBlank=Yes }
    { 4   ;   ;Starting Time       ;Time          ;OnValidate=BEGIN
                                                                IF ("Ending Time" = 0T) OR
                                                                   ("Ending Time" < "Starting Time")
                                                                THEN BEGIN
                                                                  ShopCalendar.SETRANGE("Shop Calendar Code","Shop Calendar Code");
                                                                  ShopCalendar.SETRANGE(Day,Day);
                                                                  ShopCalendar.SETRANGE("Starting Time","Starting Time",235959T);
                                                                  IF ShopCalendar.FINDFIRST THEN
                                                                    "Ending Time" := ShopCalendar."Starting Time"
                                                                  ELSE
                                                                    "Ending Time" := 235959T;
                                                                END;
                                                                CheckRedundancy;
                                                              END;

                                                   CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Starting Time] }
    { 5   ;   ;Ending Time         ;Time          ;OnValidate=BEGIN
                                                                IF ("Ending Time" < "Starting Time") AND
                                                                   ("Ending Time" <> 000000T)
                                                                THEN
                                                                  ERROR(Text000,FIELDCAPTION("Ending Time"),FIELDCAPTION("Starting Time"));

                                                                CheckRedundancy;
                                                              END;

                                                   CaptionML=[DAN=Sluttidspunkt;
                                                              ENU=Ending Time] }
  }
  KEYS
  {
    {    ;Shop Calendar Code,Day,Starting Time,Ending Time,Work Shift Code;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 skal v�re st�rre end %2.;ENU=%1 must be higher than %2.';
      Text001@1001 : TextConst 'DAN=Der er redundans i produktionskalenderen. Faktisk arbejdsskift %1 fra : %2 til %3. Sammenfaldende arbejdsskift %4 fra : %5 til %6.;ENU=There is redundancy in the Shop Calendar. Actual work shift %1 from : %2 to %3. Conflicting work shift %4 from : %5 to %6.';
      ShopCalendar@1002 : Record 99000752;

    LOCAL PROCEDURE CheckRedundancy@1();
    VAR
      ShopCalendar2@1000 : Record 99000752;
      TempShopCalendar@1001 : TEMPORARY Record 99000752;
    BEGIN
      ShopCalendar2.SETRANGE("Shop Calendar Code","Shop Calendar Code");
      ShopCalendar2.SETRANGE(Day,Day);
      IF ShopCalendar2.FIND('-') THEN
        REPEAT
          TempShopCalendar := ShopCalendar2;
          TempShopCalendar.INSERT;
        UNTIL ShopCalendar2.NEXT = 0;

      TempShopCalendar := xRec;
      IF TempShopCalendar.DELETE THEN ;

      TempShopCalendar.SETRANGE("Shop Calendar Code","Shop Calendar Code");
      TempShopCalendar.SETRANGE(Day,Day);
      TempShopCalendar.SETRANGE("Starting Time",0T,"Ending Time" - 1);
      TempShopCalendar.SETRANGE("Ending Time","Starting Time" + 1,235959T);

      IF TempShopCalendar.FINDFIRST THEN BEGIN
        IF (TempShopCalendar."Starting Time" = "Starting Time") AND
           (TempShopCalendar."Ending Time" = "Ending Time") AND
           (TempShopCalendar."Work Shift Code" = "Work Shift Code")
        THEN
          EXIT;

        ERROR(
          Text001,
          "Work Shift Code",
          "Starting Time",
          "Ending Time",
          TempShopCalendar."Work Shift Code",
          TempShopCalendar."Starting Time",
          TempShopCalendar."Ending Time");
      END;
    END;

    BEGIN
    END.
  }
}

