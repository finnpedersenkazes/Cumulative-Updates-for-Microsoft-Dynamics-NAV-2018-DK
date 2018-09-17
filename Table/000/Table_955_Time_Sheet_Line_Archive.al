OBJECT Table 955 Time Sheet Line Archive
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=VAR
               TimeSheetDetailArchive@1001 : Record 956;
               TimeSheetCmtLineArchive@1000 : Record 957;
             BEGIN
               TimeSheetDetailArchive.SETRANGE("Time Sheet No.","Time Sheet No.");
               TimeSheetDetailArchive.SETRANGE("Time Sheet Line No.","Line No.");
               TimeSheetDetailArchive.DELETEALL;

               TimeSheetCmtLineArchive.SETRANGE("No.","Time Sheet No.");
               TimeSheetCmtLineArchive.SETRANGE("Time Sheet Line No.","Line No.");
               TimeSheetCmtLineArchive.DELETEALL;
             END;

    CaptionML=[DAN=Timeseddellinjearkiv;
               ENU=Time Sheet Line Archive];
  }
  FIELDS
  {
    { 1   ;   ;Time Sheet No.      ;Code20        ;TableRelation="Time Sheet Header Archive";
                                                   CaptionML=[DAN=Timeseddelnr.;
                                                              ENU=Time Sheet No.] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Time Sheet Starting Date;Date      ;CaptionML=[DAN=Startdato for timeseddel;
                                                              ENU=Time Sheet Starting Date];
                                                   Editable=No }
    { 5   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Ressource,Sag,Service,Fravër,Montageordre";
                                                                    ENU=" ,Resource,Job,Service,Absence,Assembly Order"];
                                                   OptionString=[ ,Resource,Job,Service,Absence,Assembly Order] }
    { 6   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 7   ;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 9   ;   ;Cause of Absence Code;Code10       ;TableRelation="Cause of Absence";
                                                   CaptionML=[DAN=FravërsÜrsagskode;
                                                              ENU=Cause of Absence Code] }
    { 10  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 11  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 12  ;   ;Approver ID         ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Godkender-id;
                                                              ENU=Approver ID];
                                                   Editable=No }
    { 13  ;   ;Service Order No.   ;Code20        ;TableRelation=IF (Posted=CONST(No)) "Service Header".No. WHERE (Document Type=CONST(Order));
                                                   CaptionML=[DAN=Serviceordrenr.;
                                                              ENU=Service Order No.] }
    { 14  ;   ;Service Order Line No.;Integer     ;CaptionML=[DAN=Serviceordrelinjenr.;
                                                              ENU=Service Order Line No.] }
    { 15  ;   ;Total Quantity      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Time Sheet Detail Archive".Quantity WHERE (Time Sheet No.=FIELD(Time Sheet No.),
                                                                                                               Time Sheet Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=I alt;
                                                              ENU=Total Quantity];
                                                   Editable=No }
    { 17  ;   ;Chargeable          ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Fakturerbar;
                                                              ENU=Chargeable] }
    { 18  ;   ;Assembly Order No.  ;Code20        ;TableRelation=IF (Posted=CONST(No)) "Assembly Header".No. WHERE (Document Type=CONST(Order));
                                                   CaptionML=[DAN=Montageordrenr.;
                                                              ENU=Assembly Order No.] }
    { 19  ;   ;Assembly Order Line No.;Integer    ;CaptionML=[DAN=Montageordrelinjenr.;
                                                              ENU=Assembly Order Line No.] }
    { 20  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=èben,Sendt,Afvist,Godkendt;
                                                                    ENU=Open,Submitted,Rejected,Approved];
                                                   OptionString=Open,Submitted,Rejected,Approved;
                                                   Editable=No }
    { 21  ;   ;Approved By         ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Godkendt af;
                                                              ENU=Approved By];
                                                   Editable=No }
    { 22  ;   ;Approval Date       ;Date          ;CaptionML=[DAN=Godkendelsesdato;
                                                              ENU=Approval Date];
                                                   Editable=No }
    { 23  ;   ;Posted              ;Boolean       ;CaptionML=[DAN=Bogfõrt;
                                                              ENU=Posted];
                                                   Editable=No }
    { 26  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Time Sheet Comment Line" WHERE (No.=FIELD(Time Sheet No.),
                                                                                                      Time Sheet Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Bemërkning;
                                                              ENU=Comment];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Time Sheet No.,Line No.                 ;Clustered=Yes }
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

