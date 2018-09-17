OBJECT Table 959 Time Sheet Chart Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfiguration af timeseddeldiagram;
               ENU=Time Sheet Chart Setup];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Text132       ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Starting Date       ;Date          ;CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 3   ;   ;Show by             ;Option        ;CaptionML=[DAN=Vis efter;
                                                              ENU=Show by];
                                                   OptionCaptionML=[DAN=Status,Type,Bogf�rt;
                                                                    ENU=Status,Type,Posted];
                                                   OptionString=Status,Type,Posted }
    { 4   ;   ;Measure Type        ;Option        ;CaptionML=[DAN=M�letype;
                                                              ENU=Measure Type];
                                                   OptionCaptionML=[DAN=�ben,Sendt,Afvist,Godkendt,Planlagt,Bogf�rt,Ikke bogf�rt,Ressource,Sag,Service,Frav�r,Montageordre;
                                                                    ENU=Open,Submitted,Rejected,Approved,Scheduled,Posted,Not Posted,Resource,Job,Service,Absence,Assembly Order];
                                                   OptionString=Open,Submitted,Rejected,Approved,Scheduled,Posted,Not Posted,Resource,Job,Service,Absence,Assembly Order }
  }
  KEYS
  {
    {    ;User ID                                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text001@1000 : TextConst '@@@=Period: (date)..(date) | show by (Status or Posted) | updated (time).;DAN=Periode: %1..%2 | Sorter efter: %3 | Opdateret: %4.;ENU=Period: %1..%2 | Show by: %3 | Updated: %4.';

    [External]
    PROCEDURE GetCurrentSelectionText@1() : Text[250];
    BEGIN
      EXIT(STRSUBSTNO(Text001,"Starting Date",GetEndingDate,"Show by",TIME));
    END;

    [External]
    PROCEDURE SetStartingDate@2(StartingDate@1000 : Date);
    BEGIN
      "Starting Date" := StartingDate;
      MODIFY;
    END;

    [External]
    PROCEDURE GetEndingDate@4() : Date;
    BEGIN
      EXIT(CALCDATE('<1W>',"Starting Date") - 1);
    END;

    [External]
    PROCEDURE FindPeriod@3(Which@1000 : 'Previous,Next');
    BEGIN
      CASE Which OF
        Which::Previous:
          "Starting Date" := CALCDATE('<-1W>',"Starting Date");
        Which::Next:
          "Starting Date" := CALCDATE('<+1W>',"Starting Date");
      END;
      MODIFY;
    END;

    [External]
    PROCEDURE SetShowBy@5(ShowBy@1000 : Option);
    BEGIN
      "Show by" := ShowBy;
      MODIFY;
    END;

    [External]
    PROCEDURE MeasureIndex2MeasureType@6(MeasureIndex@1000 : Integer) : Integer;
    BEGIN
      CASE "Show by" OF
        "Show by"::Status:
          EXIT(MeasureIndex);
        "Show by"::Posted:
          CASE MeasureIndex OF
            0:
              EXIT("Measure Type"::Posted);
            1:
              EXIT("Measure Type"::"Not Posted");
            2:
              EXIT("Measure Type"::Scheduled);
          END;
        "Show by"::Type:
          BEGIN
            IF MeasureIndex = 5 THEN
              EXIT("Measure Type"::Scheduled);
            EXIT(MeasureIndex + 7);
          END;
      END;
    END;

    BEGIN
    END.
  }
}

