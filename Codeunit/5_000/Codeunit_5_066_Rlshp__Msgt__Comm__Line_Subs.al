OBJECT Codeunit 5066 Rlshp. Msgt. Comm. Line Subs
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    [EventSubscriber(Table,5061,OnAfterInsertEvent)]
    LOCAL PROCEDURE SetContactDateTimeModifiedOnAfterCommentLineInsert@1(VAR Rec@1000 : Record 5061;RunTrigger@1001 : Boolean);
    BEGIN
      TouchContact(Rec."No.");
    END;

    [EventSubscriber(Table,5061,OnAfterModifyEvent)]
    LOCAL PROCEDURE SetContactDateTimeModifiedOnAfterCommentLineModify@8(VAR Rec@1000 : Record 5061;VAR xRec@1001 : Record 5061;RunTrigger@1002 : Boolean);
    BEGIN
      TouchContact(Rec."No.");
    END;

    [EventSubscriber(Table,5061,OnAfterDeleteEvent)]
    LOCAL PROCEDURE SetContactDateTimeModifiedOnAfterCommentLineDelete@9(VAR Rec@1000 : Record 5061;RunTrigger@1001 : Boolean);
    BEGIN
      IF RunTrigger THEN
        TouchContact(Rec."No.");
    END;

    [EventSubscriber(Table,5061,OnAfterRenameEvent)]
    LOCAL PROCEDURE SetContactDateTimeModifiedOnAfterCommentLineRename@10(VAR Rec@1000 : Record 5061;VAR xRec@1001 : Record 5061;RunTrigger@1002 : Boolean);
    BEGIN
      IF xRec."No." = Rec."No." THEN
        TouchContact(Rec."No.")
      ELSE BEGIN
        TouchContact(Rec."No.");
        TouchContact(xRec."No.");
      END;
    END;

    LOCAL PROCEDURE TouchContact@4(ContactNo@1000 : Code[20]);
    VAR
      Cont@1001 : Record 5050;
      RlshpMgtCommentLine@1002 : Record 5061;
    BEGIN
      IF RlshpMgtCommentLine."Table Name" = RlshpMgtCommentLine."Table Name"::Contact THEN
        Cont.TouchContact(ContactNo);
    END;

    BEGIN
    END.
  }
}

