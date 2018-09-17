OBJECT Page 593 Change Log Setup (Table) List
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=�ndr.logopstn.oversigt (tabel);
               ENU=Change Log Setup (Table) List];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=Yes;
    SourceTable=Table2000000058;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 FILTERGROUP(2);
                 SETRANGE("Object Type","Object Type"::Table);
                 SETRANGE("Object ID",0,2000000000);
                 FILTERGROUP(0);
               END;

    OnAfterGetRecord=BEGIN
                       GetRec;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 15  ;2   ;Field     ;
                CaptionML=[DAN=ID;
                           ENU=ID];
                ToolTipML=[DAN="Angiver id'et for tabellen. ";
                           ENU="Specifies the ID of the table. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object ID";
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p� tabellen.;
                           ENU=Specifies the name of the table.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object Caption";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                Name=LogInsertion;
                CaptionML=[DAN=Logf�r inds�ttelse;
                           ENU=Log Insertion];
                ToolTipML=[DAN=Angiver, hvor inds�ttelse af nye data logf�res. Tom: Der logf�res ingen inds�ttelse i nogen felter. Visse felter: Der logf�res inds�ttelser for udvalgte felter. Alle felter: Inds�ttelser logf�res for alle felter.;
                           ENU=Specifies where insertions of new data are logged. Blank: No insertions in any fields are logged. Some fields: Insertions are logged for selected fields. All fields: Insertions are logged for all fields.];
                OptionCaptionML=[DAN=" ,Nogle felter,Alle felter";
                                 ENU=" ,Some Fields,All Fields"];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ChangeLogSetupTable."Log Insertion";
                OnValidate=VAR
                             NewValue@1001 : Option;
                           BEGIN
                             IF ChangeLogSetupTable."Table No." <> "Object ID" THEN
                               BEGIN
                               NewValue := ChangeLogSetupTable."Log Insertion";
                               GetRec;
                               ChangeLogSetupTable."Log Insertion" := NewValue;
                             END;

                             IF xChangeLogSetupTable.GET(ChangeLogSetupTable."Table No.") THEN
                               BEGIN
                               IF (xChangeLogSetupTable."Log Insertion" = xChangeLogSetupTable."Log Insertion"::"Some Fields") AND
                                  (xChangeLogSetupTable."Log Insertion" <> ChangeLogSetupTable."Log Insertion")
                               THEN
                                 IF CONFIRM(
                                      STRSUBSTNO(Text002,xChangeLogSetupTable.FIELDCAPTION("Log Insertion"),xChangeLogSetupTable."Log Insertion"),FALSE)
                                 THEN
                                   ChangeLogSetupTable.DelChangeLogFields(0);
                             END;
                             ChangeLogSetupTableLogInsertio;
                           END;

                OnAssistEdit=BEGIN
                               WITH ChangeLogSetupTable DO
                                 TESTFIELD("Log Insertion","Log Insertion"::"Some Fields");
                               AssistEdit;
                             END;
                              }

    { 8   ;2   ;Field     ;
                Name=LogModification;
                CaptionML=[DAN=Logf�r �ndring;
                           ENU=Log Modification];
                ToolTipML=[DAN=Angiver, at enhver �ndring af data logf�res.;
                           ENU=Specifies that any modification of data is logged.];
                OptionCaptionML=[DAN=" ,Nogle felter,Alle felter";
                                 ENU=" ,Some Fields,All Fields"];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ChangeLogSetupTable."Log Modification";
                OnValidate=VAR
                             NewValue@1001 : Option;
                           BEGIN
                             IF ChangeLogSetupTable."Table No." <> "Object ID" THEN
                               BEGIN
                               NewValue := ChangeLogSetupTable."Log Modification";
                               GetRec;
                               ChangeLogSetupTable."Log Modification" := NewValue;
                             END;

                             IF xChangeLogSetupTable.GET(ChangeLogSetupTable."Table No.") THEN
                               BEGIN
                               IF (xChangeLogSetupTable."Log Modification" = xChangeLogSetupTable."Log Modification"::"Some Fields") AND
                                  (xChangeLogSetupTable."Log Modification" <> ChangeLogSetupTable."Log Modification")
                               THEN
                                 IF CONFIRM(
                                      STRSUBSTNO(Text002,xChangeLogSetupTable.FIELDCAPTION("Log Modification"),xChangeLogSetupTable."Log Modification"),FALSE)
                                 THEN
                                   ChangeLogSetupTable.DelChangeLogFields(1);
                             END;
                             ChangeLogSetupTableLogModifica;
                           END;

                OnAssistEdit=BEGIN
                               WITH ChangeLogSetupTable DO
                                 TESTFIELD("Log Modification","Log Modification"::"Some Fields");
                               AssistEdit;
                             END;
                              }

    { 10  ;2   ;Field     ;
                Name=LogDeletion;
                CaptionML=[DAN=Logf�r sletning;
                           ENU=Log Deletion];
                ToolTipML=[DAN=Angiver, at enhver sletning af data logf�res.;
                           ENU=Specifies that any deletion of data is logged.];
                OptionCaptionML=[DAN=" ,Nogle felter,Alle felter";
                                 ENU=" ,Some Fields,All Fields"];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ChangeLogSetupTable."Log Deletion";
                OnValidate=VAR
                             NewValue@1001 : Option;
                           BEGIN
                             IF ChangeLogSetupTable."Table No." <> "Object ID" THEN
                               BEGIN
                               NewValue := ChangeLogSetupTable."Log Deletion";
                               GetRec;
                               ChangeLogSetupTable."Log Deletion" := NewValue;
                             END;

                             IF xChangeLogSetupTable.GET(ChangeLogSetupTable."Table No.") THEN
                               BEGIN
                               IF (xChangeLogSetupTable."Log Deletion" = xChangeLogSetupTable."Log Deletion"::"Some Fields") AND
                                  (xChangeLogSetupTable."Log Deletion" <> ChangeLogSetupTable."Log Deletion")
                               THEN
                                 IF CONFIRM(
                                      STRSUBSTNO(Text002,xChangeLogSetupTable.FIELDCAPTION("Log Deletion"),xChangeLogSetupTable."Log Deletion"),FALSE)
                                 THEN
                                   ChangeLogSetupTable.DelChangeLogFields(2);
                             END;
                             ChangeLogSetupTableLogDeletion;
                           END;

                OnAssistEdit=BEGIN
                               WITH ChangeLogSetupTable DO
                                 TESTFIELD("Log Deletion","Log Deletion"::"Some Fields");
                               AssistEdit;
                             END;
                              }

  }
  CODE
  {
    VAR
      ChangeLogSetupTable@1000 : Record 403;
      xChangeLogSetupTable@1002 : Record 403;
      Text002@1003 : TextConst 'DAN=Du har �ndret feltet %1, s� det ikke l�ngere er %2. Vil du fjerne feltmarkeringerne?;ENU=You have changed the %1 field to no longer be %2. Do you want to remove the field selections?';

    LOCAL PROCEDURE AssistEdit@1();
    VAR
      Field@1001 : Record 2000000041;
      ChangeLogSetupFieldList@1002 : Page 594;
    BEGIN
      Field.FILTERGROUP(2);
      Field.SETRANGE(TableNo,"Object ID");
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      Field.FILTERGROUP(0);
      WITH ChangeLogSetupTable DO
        ChangeLogSetupFieldList.SelectColumn(
          "Log Insertion" = "Log Insertion"::"Some Fields",
          "Log Modification" = "Log Modification"::"Some Fields",
          "Log Deletion" = "Log Deletion"::"Some Fields");
      ChangeLogSetupFieldList.SETTABLEVIEW(Field);
      ChangeLogSetupFieldList.RUN;
    END;

    LOCAL PROCEDURE UpdateRec@18();
    BEGIN
      WITH ChangeLogSetupTable DO
        IF ("Log Insertion" = "Log Insertion"::" ") AND ("Log Modification" = "Log Modification"::" ") AND
           ("Log Deletion" = "Log Deletion"::" ")
        THEN BEGIN
          IF DELETE THEN;
        END ELSE
          IF NOT MODIFY THEN
            INSERT;
    END;

    LOCAL PROCEDURE GetRec@2();
    BEGIN
      IF NOT ChangeLogSetupTable.GET("Object ID") THEN BEGIN
        ChangeLogSetupTable.INIT;
        ChangeLogSetupTable."Table No." := "Object ID";
      END;
    END;

    [External]
    PROCEDURE SetSource@4();
    VAR
      AllObjWithCaption@1001 : Record 2000000058;
    BEGIN
      DELETEALL;

      AllObjWithCaption.SETCURRENTKEY("Object Type","Object ID");
      AllObjWithCaption.SETRANGE("Object Type","Object Type"::Table);
      AllObjWithCaption.SETRANGE("Object ID",0,2000000006);

      IF AllObjWithCaption.FIND('-') THEN
        REPEAT
          Rec := AllObjWithCaption;
          INSERT;
        UNTIL AllObjWithCaption.NEXT = 0;
    END;

    LOCAL PROCEDURE ChangeLogSetupTableLogInsertio@19011102();
    BEGIN
      UpdateRec;
    END;

    LOCAL PROCEDURE ChangeLogSetupTableLogModifica@19025218();
    BEGIN
      UpdateRec;
    END;

    LOCAL PROCEDURE ChangeLogSetupTableLogDeletion@19043090();
    BEGIN
      UpdateRec;
    END;

    BEGIN
    END.
  }
}

