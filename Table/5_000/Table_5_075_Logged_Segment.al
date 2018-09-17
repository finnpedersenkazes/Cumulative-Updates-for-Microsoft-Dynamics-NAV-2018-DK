OBJECT Table 5075 Logged Segment
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Gemt m†lgruppe;
               ENU=Logged Segment];
    LookupPageID=Page5139;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Segment No.         ;Code20        ;CaptionML=[DAN=M†lgruppenr.;
                                                              ENU=Segment No.] }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;No. of Interactions ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Interaction Log Entry" WHERE (Logged Segment Entry No.=FIELD(Entry No.),
                                                                                                    Canceled=FIELD(Canceled)));
                                                   CaptionML=[DAN=Antal interaktioner;
                                                              ENU=No. of Interactions];
                                                   Editable=No }
    { 5   ;   ;No. of Campaign Entries;Integer    ;FieldClass=FlowField;
                                                   CalcFormula=Count("Campaign Entry" WHERE (Register No.=FIELD(Entry No.),
                                                                                             Canceled=FIELD(Canceled)));
                                                   CaptionML=[DAN=Antal kampagneposter;
                                                              ENU=No. of Campaign Entries];
                                                   Editable=No }
    { 6   ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date] }
    { 7   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 8   ;   ;Canceled            ;Boolean       ;CaptionML=[DAN=Annulleret;
                                                              ENU=Canceled] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Segment No.                              }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,Segment No.,Creation Date }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 %2 er markeret som %3.\Vil du fjerne markeringen?;ENU=%1 %2 is marked %3.\Do you wish to remove the checkmark?';
      Text002@1002 : TextConst 'DAN=Vil du markere %1 %2 som %3?;ENU=Do you wish to mark %1 %2 as %3?';
      Text005@1004 : TextConst 'DAN=Vil du fjerne markeringen af de markerede %1-linjer?;ENU=Do you wish to remove the checkmark from the selected %1 lines?';
      Text006@1003 : TextConst 'DAN="Vil du markere de valgte %1-linjer som %2? ";ENU="Do you wish to mark the selected %1 lines as %2? "';

    [External]
    PROCEDURE ToggleCanceledCheckmark@2();
    VAR
      MasterCanceledCheckmark@1000 : Boolean;
    BEGIN
      IF FIND('-') THEN BEGIN
        IF ConfirmToggleCanceledCheckmark(COUNT) THEN BEGIN
          MasterCanceledCheckmark := NOT Canceled;
          REPEAT
            SetCanceledCheckmark(MasterCanceledCheckmark);
          UNTIL NEXT = 0
        END;
      END
    END;

    [External]
    PROCEDURE SetCanceledCheckmark@1(CanceledCheckmark@1002 : Boolean);
    VAR
      InteractLogEntry@1000 : Record 5065;
      CampaignEntry@1001 : Record 5072;
    BEGIN
      Canceled := CanceledCheckmark;
      MODIFY;

      CampaignEntry.SETCURRENTKEY("Register No.");
      CampaignEntry.SETRANGE("Register No.","Entry No.");
      CampaignEntry.MODIFYALL(Canceled,Canceled);

      InteractLogEntry.SETCURRENTKEY("Logged Segment Entry No.");
      InteractLogEntry.SETRANGE("Logged Segment Entry No.","Entry No.");
      InteractLogEntry.MODIFYALL(Canceled,Canceled);
    END;

    LOCAL PROCEDURE ConfirmToggleCanceledCheckmark@3(NumberOfSelectedLines@1000 : Integer) : Boolean;
    BEGIN
      IF NumberOfSelectedLines = 1 THEN BEGIN
        IF Canceled THEN
          EXIT(CONFIRM(Text000,TRUE,TABLECAPTION,"Entry No.",FIELDCAPTION(Canceled)));

        EXIT(CONFIRM(Text002,TRUE,TABLECAPTION,"Entry No.",FIELDCAPTION(Canceled)));
      END;

      IF Canceled THEN
        EXIT(CONFIRM(Text005,TRUE,TABLECAPTION));

      EXIT(CONFIRM(Text006,TRUE,TABLECAPTION,FIELDCAPTION(Canceled)));
    END;

    BEGIN
    END.
  }
}

