OBJECT Table 1150 Report Totals Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer til rapporttotaler;
               ENU=Report Totals Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 2   ;   ;Description         ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount] }
    { 4   ;   ;Amount Formatted    ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Formateret bel›b;
                                                              ENU=Amount Formatted] }
    { 5   ;   ;Font Bold           ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fed skrifttype;
                                                              ENU=Font Bold] }
    { 6   ;   ;Font Underline      ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Understreget skrifttype;
                                                              ENU=Font Underline] }
    { 7   ;   ;Font Italics        ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kursiv skrifttype;
                                                              ENU=Font Italics] }
  }
  KEYS
  {
    {    ;Line No.                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE Add@1(NewDescription@1000 : Text[250];NewAmount@1001 : Decimal;NewBold@1002 : Boolean;NewUnderline@1003 : Boolean;NewItalics@1004 : Boolean);
    BEGIN
      IF FINDLAST THEN;
      INIT;
      "Line No." += 1;
      Description := NewDescription;
      Amount := NewAmount;
      "Amount Formatted" := FORMAT(Amount,0,'<Precision,2><Standard Format,0>');
      "Font Bold" := NewBold;
      "Font Underline" := NewUnderline;
      "Font Italics" := NewItalics;
      INSERT(TRUE);
    END;

    BEGIN
    END.
  }
}

