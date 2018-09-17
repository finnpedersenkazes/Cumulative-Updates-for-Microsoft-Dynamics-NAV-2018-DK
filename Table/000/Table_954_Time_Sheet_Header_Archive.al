OBJECT Table 954 Time Sheet Header Archive
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
               TimeSheetLineArchive@1001 : Record 955;
               TimeSheetCmtLineArchive@1000 : Record 957;
             BEGIN
               TimeSheetLineArchive.SETRANGE("Time Sheet No.","No.");
               TimeSheetLineArchive.DELETEALL(TRUE);

               TimeSheetCmtLineArchive.SETRANGE("No.","No.");
               TimeSheetCmtLineArchive.SETRANGE("Time Sheet Line No.",0);
               TimeSheetCmtLineArchive.DELETEALL;
             END;

    CaptionML=[DAN=Timeseddelhovedarkiv;
               ENU=Time Sheet Header Archive];
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 3   ;   ;Starting Date       ;Date          ;CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 4   ;   ;Ending Date         ;Date          ;CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 5   ;   ;Resource No.        ;Code20        ;TableRelation=Resource;
                                                   CaptionML=[DAN=Ressourcenr.;
                                                              ENU=Resource No.] }
    { 7   ;   ;Owner User ID       ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id pÜ ejer;
                                                              ENU=Owner User ID] }
    { 8   ;   ;Approver User ID    ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id pÜ godkender;
                                                              ENU=Approver User ID] }
    { 20  ;   ;Quantity            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Time Sheet Detail Archive".Quantity WHERE (Time Sheet No.=FIELD(No.),
                                                                                                               Status=FIELD(Status Filter),
                                                                                                               Job No.=FIELD(Job No. Filter),
                                                                                                               Job Task No.=FIELD(Job Task No. Filter),
                                                                                                               Date=FIELD(Date Filter),
                                                                                                               Posted=FIELD(Posted Filter),
                                                                                                               Type=FIELD(Type Filter)));
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity] }
    { 26  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Time Sheet Comment Line" WHERE (No.=FIELD(No.),
                                                                                                      Time Sheet Line No.=CONST(0)));
                                                   CaptionML=[DAN=Bemërkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 30  ;   ;Status Filter       ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Statusfilter;
                                                              ENU=Status Filter];
                                                   OptionCaptionML=[DAN=èben,Sendt,Afvist,Godkendt;
                                                                    ENU=Open,Submitted,Rejected,Approved];
                                                   OptionString=Open,Submitted,Rejected,Approved }
    { 31  ;   ;Job No. Filter      ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Sagsnummerfilter;
                                                              ENU=Job No. Filter] }
    { 32  ;   ;Job Task No. Filter ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Sagsopgavenummerfilter;
                                                              ENU=Job Task No. Filter] }
    { 33  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 34  ;   ;Posted Filter       ;Boolean       ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Bogfõrt filter;
                                                              ENU=Posted Filter] }
    { 35  ;   ;Type Filter         ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Typefilter;
                                                              ENU=Type Filter];
                                                   OptionCaptionML=[DAN=" ,Ressource,Sag,Service,Fravër,Montageordre";
                                                                    ENU=" ,Resource,Job,Service,Absence,Assembly Order"];
                                                   OptionString=[ ,Resource,Job,Service,Absence,Assembly Order] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Resource No.,Starting Date               }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Starting Date,Ending Date,Resource No. }
  }
  CODE
  {
    VAR
      TimeSheetMgt@1002 : Codeunit 950;

    [External]
    PROCEDURE FindLastTimeSheetArchiveNo@27(FilterFieldNo@1002 : Integer) : Code[20];
    BEGIN
      RESET;
      SETCURRENTKEY("Resource No.","Starting Date");

      TimeSheetMgt.FilterTimeSheetsArchive(Rec,FilterFieldNo);
      SETFILTER("Starting Date",'%1..',WORKDATE);
      IF NOT FINDFIRST THEN BEGIN
        SETRANGE("Starting Date");
        SETRANGE("Ending Date");
        FINDLAST;
      END;
      EXIT("No.");
    END;

    BEGIN
    END.
  }
}

