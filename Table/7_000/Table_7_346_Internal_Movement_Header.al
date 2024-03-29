OBJECT Table 7346 Internal Movement Header
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               InvtSetup.GET;
               IF "No." = '' THEN BEGIN
                 InvtSetup.TESTFIELD("Internal Movement Nos.");
                 NoSeriesMgt.InitSeries(
                   InvtSetup."Internal Movement Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;
             END;

    OnDelete=BEGIN
               DeleteRelatedLines;
             END;

    OnRename=BEGIN
               ERROR(Text002,TABLECAPTION);
             END;

    CaptionML=[DAN=Hoved - intern flytning;
               ENU=Internal Movement Header];
    LookupPageID=Page7400;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                InvtSetup.GET;
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  NoSeriesMgt.TestManual(InvtSetup."Internal Movement Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                IF NOT WmsManagement.LocationIsAllowed("Location Code") THEN
                                                                  ERROR(Text003,"Location Code");

                                                                CheckLocationSettings("Location Code");
                                                                IF "Location Code" <> xRec."Location Code" THEN
                                                                  "To Bin Code" := '';

                                                                FILTERGROUP := 2;
                                                                SETRANGE("Location Code","Location Code");
                                                                FILTERGROUP := 0;
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 3   ;   ;Assigned User ID    ;Code50        ;TableRelation="Warehouse Employee" WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                IF "Assigned User ID" <> '' THEN BEGIN
                                                                  "Assignment Date" := TODAY;
                                                                  "Assignment Time" := TIME;
                                                                END ELSE BEGIN
                                                                  "Assignment Date" := 0D;
                                                                  "Assignment Time" := 0T;
                                                                END;
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
    { 4   ;   ;Assignment Date     ;Date          ;CaptionML=[DAN=Tildelt den;
                                                              ENU=Assignment Date];
                                                   Editable=No }
    { 5   ;   ;Assignment Time     ;Time          ;CaptionML=[DAN=Tildelt kl.;
                                                              ENU=Assignment Time];
                                                   Editable=No }
    { 6   ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 7   ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Warehouse Comment Line" WHERE (Table Name=CONST(Internal Movement),
                                                                                                     Type=CONST(" "),
                                                                                                     No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 8   ;   ;To Bin Code         ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=VAR
                                                                BinType@1000 : Record 7303;
                                                                InternalMovementLine@1001 : Record 7347;
                                                              BEGIN
                                                                IF xRec."To Bin Code" <> "To Bin Code" THEN BEGIN
                                                                  IF "To Bin Code" <> '' THEN BEGIN
                                                                    GetLocation("Location Code");
                                                                    Location.TESTFIELD("Bin Mandatory");
                                                                    IF "To Bin Code" = Location."Adjustment Bin Code" THEN
                                                                      FIELDERROR(
                                                                        "To Bin Code",
                                                                        STRSUBSTNO(
                                                                          Text001,Location.FIELDCAPTION("Adjustment Bin Code"),
                                                                          Location.TABLECAPTION));

                                                                    Bin.GET("Location Code","To Bin Code");
                                                                    IF Bin."Bin Type Code" <> '' THEN
                                                                      IF BinType.GET(Bin."Bin Type Code") THEN
                                                                        BinType.TESTFIELD(Receive,FALSE);
                                                                  END;
                                                                  InternalMovementLine.SETRANGE("No.","No.");
                                                                  IF NOT InternalMovementLine.ISEMPTY THEN
                                                                    MESSAGE(Text004,FIELDCAPTION("To Bin Code"),TABLECAPTION);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Til placeringskode;
                                                              ENU=To Bin Code] }
    { 10  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 12  ;   ;Sorting Method      ;Option        ;OnValidate=BEGIN
                                                                IF "Sorting Method" <> xRec."Sorting Method" THEN
                                                                  SortWhseDoc;
                                                              END;

                                                   CaptionML=[DAN=Sorteringsmetode;
                                                              ENU=Sorting Method];
                                                   OptionCaptionML=[DAN=" ,Vare,Placering,Forfaldsdato";
                                                                    ENU=" ,Item,Shelf or Bin,Due Date"];
                                                   OptionString=[ ,Item,Shelf or Bin,Due Date] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Location@1009 : Record 14;
      Bin@1011 : Record 7354;
      InvtSetup@1001 : Record 313;
      NoSeriesMgt@1003 : Codeunit 396;
      WmsManagement@1014 : Codeunit 7302;
      ItemTrackingMgt@1015 : Codeunit 6500;
      Text001@1008 : TextConst 'DAN=kan ikke v�re %1 i %2;ENU=must not be the %1 of the %2';
      Text002@1010 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text003@1013 : TextConst 'DAN=Lokationskoden %1 kan ikke bruges.;ENU=You cannot use Location Code %1.';
      Text004@1002 : TextConst 'DAN=Du har �ndret %1 p� %2, men der er ikke foretaget �ndringer p� de eksisterende interne flytningslinjer.\Du skal opdatere de eksisterende interne flytningslinjer manuelt.;ENU=You have changed the %1 on the %2, but it has not been changed on the existing internal movement lines.\You must update the existing internal movement lines manually.';
      NoAllowedLocationsErr@1000 : TextConst 'DAN=Intern flytning er ikke mulig p� lokationer, hvor du er lagermedarbejder.;ENU=Internal movement is not possible at any locations where you are a warehouse employee.';

    LOCAL PROCEDURE SortWhseDoc@3();
    VAR
      InternalMovementLine@1001 : Record 7347;
      SequenceNo@1000 : Integer;
    BEGIN
      InternalMovementLine.RESET;
      InternalMovementLine.SETRANGE("No.","No.");
      CASE "Sorting Method" OF
        "Sorting Method"::Item:
          InternalMovementLine.SETCURRENTKEY("No.","Item No.");
        "Sorting Method"::"Shelf or Bin":
          BEGIN
            GetLocation("Location Code");
            IF Location."Bin Mandatory" THEN
              InternalMovementLine.SETCURRENTKEY("No.","From Bin Code")
            ELSE
              InternalMovementLine.SETCURRENTKEY("No.","Shelf No.");
          END;
        "Sorting Method"::"Due Date":
          InternalMovementLine.SETCURRENTKEY("No.","Due Date");
      END;

      IF InternalMovementLine.FIND('-') THEN BEGIN
        SequenceNo := 10000;
        REPEAT
          InternalMovementLine."Sorting Sequence No." := SequenceNo;
          InternalMovementLine.MODIFY;
          SequenceNo := SequenceNo + 10000;
        UNTIL InternalMovementLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE AssistEdit@8() : Boolean;
    BEGIN
      InvtSetup.GET;
      InvtSetup.TESTFIELD("Internal Movement Nos.");
      IF NoSeriesMgt.SelectSeries(InvtSetup."Internal Movement Nos.",xRec."No. Series","No. Series")
      THEN BEGIN
        NoSeriesMgt.SetSeries("No.");
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE GetLocation@10(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    [External]
    PROCEDURE OpenInternalMovementHeader@2(VAR InternalMovementHeader@1001 : Record 7346);
    VAR
      WhseEmployee@1003 : Record 7301;
      CurrentLocationCode@1006 : Code[10];
    BEGIN
      WhseEmployee.SETRANGE("Location Code",InternalMovementHeader."Location Code");
      IF NOT WhseEmployee.ISEMPTY THEN
        CurrentLocationCode := InternalMovementHeader."Location Code"
      ELSE
        CurrentLocationCode := GetDefaultOrFirstAllowedLocation;

      InternalMovementHeader.FILTERGROUP := 2;
      InternalMovementHeader.SETRANGE("Location Code",CurrentLocationCode);
      InternalMovementHeader.FILTERGROUP := 0;
    END;

    [External]
    PROCEDURE LookupInternalMovementHeader@1(VAR InternalMovementHeader@1001 : Record 7346);
    BEGIN
      COMMIT;
      InternalMovementHeader.FILTERGROUP := 2;
      InternalMovementHeader.SETRANGE("Location Code");
      IF PAGE.RUNMODAL(0,InternalMovementHeader) = ACTION::LookupOK THEN;
      InternalMovementHeader.SETRANGE("Location Code",InternalMovementHeader."Location Code");
      InternalMovementHeader.FILTERGROUP := 0;
    END;

    LOCAL PROCEDURE DeleteRelatedLines@9();
    VAR
      InternalMovementLine@1003 : Record 7347;
      WhseCommentLine@1001 : Record 5770;
    BEGIN
      InternalMovementLine.SETRANGE("No.","No.");
      InternalMovementLine.DELETEALL;

      WhseCommentLine.SETRANGE("Table Name",WhseCommentLine."Table Name"::"Internal Movement");
      WhseCommentLine.SETRANGE(Type,WhseCommentLine.Type::" ");
      WhseCommentLine.SETRANGE("No.","No.");
      WhseCommentLine.DELETEALL;

      ItemTrackingMgt.DeleteWhseItemTrkgLines(
        DATABASE::"Internal Movement Line",0,"No.",'',0,0,'',FALSE);
    END;

    [External]
    PROCEDURE CheckLocationSettings@5(LocationCode@1000 : Code[10]);
    BEGIN
      GetLocation(LocationCode);
      Location.TESTFIELD("Directed Put-away and Pick",FALSE);
      Location.TESTFIELD("Bin Mandatory",TRUE);
    END;

    LOCAL PROCEDURE GetDefaultOrFirstAllowedLocation@16() LocationCode : Code[10];
    VAR
      WhseEmployeesatLocations@1001 : Query 7301;
    BEGIN
      WhseEmployeesatLocations.SETRANGE(User_ID,USERID);
      WhseEmployeesatLocations.SETRANGE(Bin_Mandatory,TRUE);
      WhseEmployeesatLocations.SETRANGE(Directed_Put_away_and_Pick,FALSE);

      WhseEmployeesatLocations.SETRANGE(Default,TRUE);
      IF GetFirstLocationCodeFromLocationsofWhseEmployee(LocationCode,WhseEmployeesatLocations) THEN
        EXIT(LocationCode);

      WhseEmployeesatLocations.SETRANGE(Default);
      IF GetFirstLocationCodeFromLocationsofWhseEmployee(LocationCode,WhseEmployeesatLocations) THEN
        EXIT(LocationCode);

      ERROR(NoAllowedLocationsErr);
    END;

    LOCAL PROCEDURE GetFirstLocationCodeFromLocationsofWhseEmployee@24(VAR LocationCode@1001 : Code[10];VAR WhseEmployeesatLocations@1000 : Query 7301) : Boolean;
    BEGIN
      WhseEmployeesatLocations.TOPNUMBEROFROWS(1);
      IF WhseEmployeesatLocations.OPEN THEN
        IF WhseEmployeesatLocations.READ THEN BEGIN
          LocationCode := WhseEmployeesatLocations.Code;
          WhseEmployeesatLocations.CLOSE;
          EXIT(TRUE);
        END;

      EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

