OBJECT Table 477 Report Inbox
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rapportindbakke;
               ENU=Report Inbox];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L›benummer;
                                                              ENU=Entry No.] }
    { 2   ;   ;User ID             ;Text65        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 3   ;   ;Report Output       ;BLOB          ;CaptionML=[DAN=Rapportresultat;
                                                              ENU=Report Output] }
    { 4   ;   ;Created Date-Time   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl‘t;
                                                              ENU=Created Date-Time];
                                                   Editable=No }
    { 5   ;   ;Job Queue Log Entry ID;GUID        ;CaptionML=[DAN=Id for logpost for opgavek›;
                                                              ENU=Job Queue Log Entry ID];
                                                   Editable=No }
    { 6   ;   ;Output Type         ;Option        ;CaptionML=[DAN=Resultattype;
                                                              ENU=Output Type];
                                                   OptionCaptionML=[DAN=PDF,Word,Excel;
                                                                    ENU=PDF,Word,Excel];
                                                   OptionString=PDF,Word,Excel;
                                                   Editable=No }
    { 7   ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 8   ;   ;Report ID           ;Integer       ;CaptionML=[DAN=Rapport-id;
                                                              ENU=Report ID];
                                                   Editable=No }
    { 9   ;   ;Report Name         ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Report),
                                                                                                                Object ID=FIELD(Report ID)));
                                                   CaptionML=[DAN=Rapportnavn;
                                                              ENU=Report Name];
                                                   Editable=No }
    { 10  ;   ;Read                ;Boolean       ;CaptionML=[DAN=L‘s;
                                                              ENU=Read] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;User ID,Created Date-Time                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      FileDownLoadTxt@1000 : TextConst 'DAN=Udl‘s;ENU=Export';
      ReportIsEmptyMsg@1001 : TextConst 'DAN=Rapporten er tom.;ENU=The report is empty.';
      NoReportsToShowErr@1002 : TextConst 'DAN=Der er ingen rapporter p† listen.;ENU=There are no reports in the list.';

    [External]
    PROCEDURE ShowReport@1();
    VAR
      Instr@1003 : InStream;
      Downloaded@1002 : Boolean;
      FileName@1004 : Text;
    BEGIN
      IF "Entry No." = 0 THEN
        ERROR(NoReportsToShowErr);

      CALCFIELDS("Report Output","Report Name");
      IF NOT "Report Output".HASVALUE THEN BEGIN
        Read := TRUE;
        MODIFY;
        COMMIT;
        MESSAGE(ReportIsEmptyMsg);
        EXIT;
      END;
      IF "Report Name" <> '' THEN
        FileName := DELCHR("Report Name",'=','/:*?"<>|') + Suffix
      ELSE
        FileName := DELCHR(Description,'=','/:*?"<>|') + Suffix;

      "Report Output".CREATEINSTREAM(Instr);
      Downloaded := DOWNLOADFROMSTREAM(Instr,FileDownLoadTxt,'','',FileName);

      IF NOT Read AND Downloaded THEN BEGIN
        Read := TRUE;
        MODIFY;
      END;
    END;

    LOCAL PROCEDURE Suffix@5() : Text;
    BEGIN
      CASE "Output Type" OF
        "Output Type"::PDF:
          EXIT('.pdf');
        "Output Type"::Word:
          EXIT('.docx');
        "Output Type"::Excel:
          EXIT('.xlsx');
      END;
    END;

    BEGIN
    END.
  }
}

