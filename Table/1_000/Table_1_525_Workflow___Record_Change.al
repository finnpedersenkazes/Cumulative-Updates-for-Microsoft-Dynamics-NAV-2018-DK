OBJECT Table 1525 Workflow - Record Change
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Workflow - �ndring af record;
               ENU=Workflow - Record Change];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L�benummer;
                                                              ENU=Entry No.] }
    { 2   ;   ;Table No.           ;Integer       ;CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
    { 3   ;   ;Field No.           ;Integer       ;CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 4   ;   ;Old Value           ;Text250       ;CaptionML=[DAN=Gammel v�rdi;
                                                              ENU=Old Value] }
    { 5   ;   ;New Value           ;Text250       ;CaptionML=[DAN=Ny v�rdi;
                                                              ENU=New Value] }
    { 6   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 7   ;   ;Workflow Step Instance ID;GUID     ;CaptionML=[DAN=Id for workflowtrininstans;
                                                              ENU=Workflow Step Instance ID] }
    { 8   ;   ;Field Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                                                                   No.=FIELD(Field No.)));
                                                   CaptionML=[DAN=Felttitel;
                                                              ENU=Field Caption] }
    { 9   ;   ;Inactive            ;Boolean       ;CaptionML=[DAN=Inaktiv;
                                                              ENU=Inactive] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE GetFormattedNewValue@4(FormatOptionString@1000 : Boolean) : Text;
    BEGIN
      EXIT(FormatValue("New Value",FormatOptionString));
    END;

    [External]
    PROCEDURE GetFormattedOldValue@5(FormatOptionString@1000 : Boolean) : Text;
    BEGIN
      EXIT(FormatValue("Old Value",FormatOptionString));
    END;

    [External]
    PROCEDURE FormatValue@2(Value@1001 : Text;FormatOptionString@1002 : Boolean) : Text;
    VAR
      RecRef@1000 : RecordRef;
      FieldRef@1013 : FieldRef;
      Bool@1004 : Boolean;
      Date@1003 : Date;
      DateFormula@1005 : DateFormula;
      DateTime@1006 : DateTime;
      Decimal@1007 : Decimal;
      Duration@1008 : Duration;
      Integer@1009 : Integer;
      Option@1010 : Option;
      Time@1011 : Time;
      BigInteger@1012 : BigInteger;
    BEGIN
      RecRef.GET("Record ID");
      FieldRef := RecRef.FIELD("Field No.");
      CASE FORMAT(FieldRef.TYPE) OF
        'Date':
          BEGIN
            EVALUATE(Date,Value,9);
            EXIT(FORMAT(Date));
          END;
        'Boolean':
          BEGIN
            EVALUATE(Bool,Value,9);
            EXIT(FORMAT(Bool));
          END;
        'DateFormula':
          BEGIN
            EVALUATE(DateFormula,Value,9);
            EXIT(FORMAT(DateFormula));
          END;
        'DateTime':
          BEGIN
            EVALUATE(DateTime,Value,9);
            EXIT(FORMAT(DateTime));
          END;
        'BigInteger':
          BEGIN
            EVALUATE(BigInteger,Value,9);
            EXIT(FORMAT(BigInteger));
          END;
        'Time':
          BEGIN
            EVALUATE(Time,Value,9);
            EXIT(FORMAT(Time));
          END;
        'Option':
          BEGIN
            EVALUATE(Option,Value,9);
            IF FormatOptionString THEN BEGIN
              FieldRef.VALUE := Option;
              EXIT(FORMAT(FieldRef.VALUE));
            END;
            EXIT(FORMAT(Option));
          END;
        'Integer':
          BEGIN
            EVALUATE(Integer,Value,9);
            EXIT(FORMAT(Integer));
          END;
        'Duration':
          BEGIN
            EVALUATE(Duration,Value,9);
            EXIT(FORMAT(Duration));
          END;
        'Decimal':
          BEGIN
            EVALUATE(Decimal,Value,9);
            EXIT(FORMAT(Decimal));
          END;
        'Code','Text':
          EXIT(FORMAT(Value));
        ELSE
          EXIT(FORMAT(Value));
      END;
    END;

    BEGIN
    END.
  }
}

