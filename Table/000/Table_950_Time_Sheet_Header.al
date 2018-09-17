OBJECT Table 950 Time Sheet Header
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Resource No." <> '' THEN BEGIN
                 Resource.GET("Resource No.");
                 CheckResourcePrivacyBlocked(Resource);
                 Resource.TESTFIELD(Blocked,FALSE);
                 IF Resource."Time Sheet Owner User ID" <> '' THEN
                   AddToMyTimeSheets(Resource."Time Sheet Owner User ID");
               END;
             END;

    OnModify=BEGIN
               IF "Resource No." <> '' THEN BEGIN
                 Resource.GET("Resource No.");
                 CheckResourcePrivacyBlocked(Resource);
                 Resource.TESTFIELD(Blocked,FALSE);
               END;
             END;

    OnDelete=VAR
               TimeSheetCommentLine@1000 : Record 953;
             BEGIN
               IF "Resource No." <> '' THEN BEGIN
                 Resource.GET("Resource No.");
                 CheckResourcePrivacyBlocked(Resource);
                 Resource.TESTFIELD(Blocked,FALSE);
               END;

               TimeSheetLine.SETRANGE("Time Sheet No.","No.");
               TimeSheetLine.DELETEALL(TRUE);

               TimeSheetCommentLine.SETRANGE("No.","No.");
               TimeSheetCommentLine.SETRANGE("Time Sheet Line No.",0);
               TimeSheetCommentLine.DELETEALL;

               RemoveFromMyTimeSheets;
             END;

    OnRename=BEGIN
               IF "Resource No." <> '' THEN BEGIN
                 Resource.GET("Resource No.");
                 CheckResourcePrivacyBlocked(Resource);
                 Resource.TESTFIELD(Blocked,FALSE);
               END;
             END;

    CaptionML=[DAN=Timeseddelhoved;
               ENU=Time Sheet Header];
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
                                                   OnValidate=BEGIN
                                                                ResourcesSetup.GET;
                                                                IF "Resource No." <> '' THEN BEGIN
                                                                  Resource.GET("Resource No.");
                                                                  CheckResourcePrivacyBlocked(Resource);
                                                                  Resource.TESTFIELD(Blocked,FALSE);
                                                                  Resource.TESTFIELD("Time Sheet Owner User ID");
                                                                  Resource.TESTFIELD("Time Sheet Approver User ID");
                                                                  "Owner User ID" := Resource."Time Sheet Owner User ID";
                                                                  "Approver User ID" := Resource."Time Sheet Approver User ID";
                                                                END;
                                                              END;

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
    { 12  ;   ;Open Exists         ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Time Sheet Line" WHERE (Time Sheet No.=FIELD(No.),
                                                                                              Status=CONST(Open)));
                                                   CaptionML=[DAN=èben findes;
                                                              ENU=Open Exists];
                                                   Editable=No }
    { 13  ;   ;Submitted Exists    ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Time Sheet Line" WHERE (Time Sheet No.=FIELD(No.),
                                                                                              Status=CONST(Submitted)));
                                                   CaptionML=[DAN=Sendt findes;
                                                              ENU=Submitted Exists];
                                                   Editable=No }
    { 14  ;   ;Rejected Exists     ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Time Sheet Line" WHERE (Time Sheet No.=FIELD(No.),
                                                                                              Status=CONST(Rejected)));
                                                   CaptionML=[DAN=Afvist findes;
                                                              ENU=Rejected Exists];
                                                   Editable=No }
    { 15  ;   ;Approved Exists     ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Time Sheet Line" WHERE (Time Sheet No.=FIELD(No.),
                                                                                              Status=CONST(Approved)));
                                                   CaptionML=[DAN=Godkendt findes;
                                                              ENU=Approved Exists];
                                                   Editable=No }
    { 16  ;   ;Posted Exists       ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Time Sheet Posting Entry" WHERE (Time Sheet No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bogfõrt findes;
                                                              ENU=Posted Exists];
                                                   Editable=No }
    { 20  ;   ;Quantity            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Time Sheet Detail".Quantity WHERE (Time Sheet No.=FIELD(No.),
                                                                                                       Status=FIELD(Status Filter),
                                                                                                       Job No.=FIELD(Job No. Filter),
                                                                                                       Job Task No.=FIELD(Job Task No. Filter),
                                                                                                       Date=FIELD(Date Filter),
                                                                                                       Posted=FIELD(Posted Filter),
                                                                                                       Type=FIELD(Type Filter)));
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity] }
    { 21  ;   ;Posted Quantity     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Time Sheet Posting Entry".Quantity WHERE (Time Sheet No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bogfõrt antal;
                                                              ENU=Posted Quantity] }
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
      Resource@1001 : Record 156;
      ResourcesSetup@1003 : Record 314;
      TimeSheetLine@1000 : Record 951;
      Text001@1004 : TextConst 'DAN=%1 indeholder ikke linjer.;ENU=%1 does not contain lines.';
      TimeSheetMgt@1005 : Codeunit 950;
      Text002@1006 : TextConst 'DAN=Der er ingen tilgëngelige timesedler. Timeseddeladministratoren skal oprette timesedler, fõr du kan fÜ adgang til dem i dette vindue.;ENU=No time sheets are available. The time sheet administrator must create time sheets before you can access them in this window.';
      PrivacyBlockedErr@1002 : TextConst '@@@="%1=resource no.";DAN=Du kan ikke anvende ressourcen %1, fordi de er markeret som blokeret pga. beskyttelse af personlige oplysninger.;ENU=You cannot use resource %1 because they are marked as blocked due to privacy.';

    [External]
    PROCEDURE CalcQtyWithStatus@1(Status@1000 : 'Open,Submitted,Rejected,Approved') : Decimal;
    BEGIN
      SETRANGE("Status Filter",Status);
      CALCFIELDS(Quantity);
      EXIT(Quantity);
    END;

    [External]
    PROCEDURE Check@2();
    BEGIN
      TimeSheetLine.SETRANGE("Time Sheet No.","No.");
      IF TimeSheetLine.FINDSET THEN BEGIN
        REPEAT
          TimeSheetLine.TESTFIELD(Status,TimeSheetLine.Status::Approved);
          TimeSheetLine.TESTFIELD(Posted,TRUE);
        UNTIL TimeSheetLine.NEXT = 0;
      END ELSE
        ERROR(Text001,"No.");
    END;

    [External]
    PROCEDURE GetLastLineNo@5() : Integer;
    BEGIN
      TimeSheetLine.RESET;
      TimeSheetLine.SETRANGE("Time Sheet No.","No.");
      IF TimeSheetLine.FINDLAST THEN;
      EXIT(TimeSheetLine."Line No.");
    END;

    [External]
    PROCEDURE FindLastTimeSheetNo@25(FilterFieldNo@1002 : Integer) : Code[20];
    BEGIN
      RESET;
      SETCURRENTKEY("Resource No.","Starting Date");

      TimeSheetMgt.FilterTimeSheets(Rec,FilterFieldNo);
      SETFILTER("Starting Date",'%1..',WORKDATE);
      IF NOT FINDFIRST THEN BEGIN
        SETRANGE("Starting Date");
        SETRANGE("Ending Date");
        IF NOT FINDLAST THEN
          ERROR(Text002);
      END;
      EXIT("No.");
    END;

    LOCAL PROCEDURE AddToMyTimeSheets@3(UserID@1000 : Code[50]);
    VAR
      MyTimeSheets@1001 : Record 9155;
    BEGIN
      MyTimeSheets.INIT;
      MyTimeSheets."User ID" := UserID;
      MyTimeSheets."Time Sheet No." := "No.";
      MyTimeSheets."Start Date" := "Starting Date";
      MyTimeSheets."End Date" := "Ending Date";
      MyTimeSheets.Comment := Comment;
      MyTimeSheets.INSERT;
    END;

    LOCAL PROCEDURE RemoveFromMyTimeSheets@28();
    VAR
      MyTimeSheets@1000 : Record 9155;
    BEGIN
      MyTimeSheets.SETRANGE("Time Sheet No.","No.");
      IF MyTimeSheets.FINDFIRST THEN
        MyTimeSheets.DELETEALL;
    END;

    LOCAL PROCEDURE CheckResourcePrivacyBlocked@4(Resource@1000 : Record 156);
    BEGIN
      IF Resource."Privacy Blocked" THEN
        ERROR(PrivacyBlockedErr,Resource."No.");
    END;

    BEGIN
    END.
  }
}

