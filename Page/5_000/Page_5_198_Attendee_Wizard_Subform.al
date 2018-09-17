OBJECT Page 5198 Attendee Wizard Subform
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table5199;
    DelayedInsert=Yes;
    PageType=ListPart;
    SourceTableTemporary=Yes;
    AutoSplitKey=Yes;
    OnAfterGetRecord=BEGIN
                       StyleIsStrong := FALSE;
                       AttendanceTypeIndent := 0;
                       SendInvitationEditable := TRUE;

                       IF "Attendance Type" = "Attendance Type"::"To-do Organizer" THEN BEGIN
                         StyleIsStrong := TRUE;
                         SendInvitationEditable := FALSE;
                         "Send Invitation" := TRUE;
                       END ELSE
                         AttendanceTypeIndent := 1;
                     END;

    OnInsertRecord=VAR
                     xAttendee@1001 : Record 5199;
                     SplitResult@1003 : Integer;
                   BEGIN
                     xAttendee.COPY(Rec);
                     ValidateAttendee(Rec,Rec);
                     RESET;
                     Rec := xAttendee;
                     IF GET("To-do No.","Line No.") THEN BEGIN
                       REPEAT
                       UNTIL (NEXT = 0) OR ("Line No." = xRec."Line No.");
                       NEXT(-1);
                       SplitResult := ROUND((xRec."Line No." - "Line No.") / 2,1,'=');
                     END;
                     COPY(xAttendee);
                     "Line No." := "Line No." + SplitResult;
                     INSERT;
                     EXIT(FALSE);
                   END;

    OnModifyRecord=VAR
                     xAttendee@1000 : Record 5199;
                   BEGIN
                     xAttendee.COPY(Rec);
                     GET("To-do No.","Line No.");
                     IF ("Attendee No." IN [SalespersonFilter,ContactFilter]) AND
                        (("Attendee Type" <> "Attendee Type") OR
                         ("Attendee No." <> "Attendee No.") OR
                         (("Attendance Type" = "Attendance Type"::"To-do Organizer") AND
                          ("Attendance Type" <> "Attendance Type"::"To-do Organizer")))
                     THEN
                       ERROR(Text001,TABLECAPTION);
                     ValidateAttendee(xAttendee,Rec);
                     COPY(xAttendee);
                     MODIFY;
                     EXIT(FALSE);
                   END;

    OnDeleteRecord=BEGIN
                     GET("To-do No.","Line No.");
                     IF "Attendee No." IN [SalespersonFilter,ContactFilter] THEN
                       ERROR(Text001,TABLECAPTION);
                     DELETE;
                     EXIT(FALSE);
                   END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=AttendanceTypeIndent;
                IndentationControls=Attendance Type;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver m�dets deltagelsestype. Du kan v�lge mellem: N�dvendig, Valgfri og Opgavearrang�r.;
                           ENU=Specifies the type of attendance for the meeting. You can select from: Required, Optional and Task Organizer.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Attendance Type";
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver deltagertypen. Du kan v�lge mellem Kontakt eller S�lger.;
                           ENU=Specifies the type of the attendee. You can choose from Contact or Salesperson.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Attendee Type";
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den deltager, som tager del i opgaven.;
                           ENU=Specifies the number of the attendee participating in the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Attendee No.";
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den deltager, som tager del i opgaven.;
                           ENU=Specifies the name of the attendee participating in the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Attendee Name";
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du vil sende en invitation til deltageren via mail. Indstillingen Send invitation er kun tilg�ngelig for kontakter og s�lgere, der har en mailadresse. Indstillingen Send invitation er ikke tilg�ngelig for m�dearrang�ren.;
                           ENU=Specifies that you want to send an invitation to the attendee by e-mail. The Send Invitation option is only available for contacts and salespeople with an e-mail address. The Send Invitation option is not available for the meeting organizer.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Send Invitation";
                Editable=SendInvitationEditable }

  }
  CODE
  {
    VAR
      SalespersonFilter@1001 : Code[20];
      Text001@1002 : TextConst 'DAN=Du kan ikke slette eller �ndre denne %1.;ENU=You cannot delete or change this %1.';
      ContactFilter@1003 : Code[20];
      StyleIsStrong@1000 : Boolean INDATASET;
      SendInvitationEditable@1004 : Boolean INDATASET;
      AttendanceTypeIndent@1005 : Integer INDATASET;

    [External]
    PROCEDURE SetAttendee@2(VAR Attendee@1000 : Record 5199);
    BEGIN
      DELETEALL;

      IF Attendee.FINDSET THEN
        REPEAT
          Rec := Attendee;
          INSERT;
        UNTIL Attendee.NEXT = 0;
    END;

    [External]
    PROCEDURE GetAttendee@3(VAR Attendee@1000 : Record 5199);
    BEGIN
      Attendee.DELETEALL;

      IF FINDSET THEN
        REPEAT
          Attendee := Rec;
          Attendee.INSERT;
        UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE UpdateForm@1();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE SetTaskFilter@4(NewSalespersonFilter@1000 : Code[20];NewContactFilter@1001 : Code[20]);
    BEGIN
      SalespersonFilter := NewSalespersonFilter;
      ContactFilter := NewContactFilter;
    END;

    BEGIN
    END.
  }
}

