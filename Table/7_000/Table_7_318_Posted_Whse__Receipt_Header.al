OBJECT Table 7318 Posted Whse. Receipt Header
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
               WhseSetup.GET;
               IF "No." = '' THEN BEGIN
                 WhseSetup.TESTFIELD("Whse. Receipt Nos.");
                 NoSeriesMgt.InitSeries(
                   WhseSetup."Posted Whse. Receipt Nos.",xRec."No. Series","Posting Date","No.","No. Series");
               END;
             END;

    OnDelete=BEGIN
               DeleteRelatedLines;
             END;

    CaptionML=[DAN=Bogf. lagermodt.hoved;
               ENU=Posted Whse. Receipt Header];
    LookupPageID=Page7333;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 3   ;   ;Assigned User ID    ;Code50        ;TableRelation="Warehouse Employee" WHERE (Location Code=FIELD(Location Code));
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID];
                                                   Editable=No }
    { 4   ;   ;Assignment Date     ;Date          ;CaptionML=[DAN=Tildelt den;
                                                              ENU=Assignment Date];
                                                   Editable=No }
    { 5   ;   ;Assignment Time     ;Time          ;CaptionML=[DAN=Tildelt kl.;
                                                              ENU=Assignment Time];
                                                   Editable=No }
    { 7   ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 8   ;   ;Zone Code           ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   CaptionML=[DAN=Zonekode;
                                                              ENU=Zone Code] }
    { 9   ;   ;Bin Code            ;Code20        ;TableRelation=IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                 ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                  Zone Code=FIELD(Zone Code));
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 11  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Warehouse Comment Line" WHERE (Table Name=CONST(Posted Whse. Receipt),
                                                                                                     Type=CONST(" "),
                                                                                                     No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 12  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 13  ;   ;Vendor Shipment No. ;Code35        ;CaptionML=[DAN=Kreditors lev.nr.;
                                                              ENU=Vendor Shipment No.] }
    { 14  ;   ;Whse. Receipt No.   ;Code20        ;CaptionML=[DAN=Lagermodt.nr.;
                                                              ENU=Whse. Receipt No.] }
    { 15  ;   ;Document Status     ;Option        ;CaptionML=[DAN=Bilagsstatus;
                                                              ENU=Document Status];
                                                   OptionCaptionML=[DAN=" ,Delvist lagt-p�-lager,Fuldt lagt-p�-lager";
                                                                    ENU=" ,Partially Put Away,Completely Put Away"];
                                                   OptionString=[ ,Partially Put Away,Completely Put Away];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Location Code                            }
    {    ;Whse. Receipt No.                        }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Location Code,Posting Date,Document Status }
  }
  CODE
  {
    VAR
      WhseSetup@1001 : Record 5769;
      NoSeriesMgt@1000 : Codeunit 396;
      Text000@1002 : TextConst 'DAN=Du skal f�rst oprette brugeren %1 som lagermedarbejder.;ENU=You must first set up user %1 as a warehouse employee.';

    [External]
    PROCEDURE GetHeaderStatus@15(LineNo@1003 : Integer) : Integer;
    VAR
      PostedWhseRcptLine2@1001 : Record 7319;
      OrderStatus@1002 : ' ,Partially Put Away,Completely Put Away';
      First@1000 : Boolean;
    BEGIN
      First := TRUE;
      PostedWhseRcptLine2.SETRANGE("No.","No.");
      WITH PostedWhseRcptLine2 DO BEGIN
        IF LineNo <> 0 THEN
          SETFILTER("Line No.",'<>%1',LineNo);
        IF FIND('-') THEN
          REPEAT
            CASE OrderStatus OF
              OrderStatus::" ":
                IF (Status = Status::"Completely Put Away") AND
                   (NOT First)
                THEN
                  OrderStatus := OrderStatus::"Partially Put Away"
                ELSE
                  OrderStatus := Status;
              OrderStatus::"Completely Put Away":
                IF Status <> Status::"Completely Put Away" THEN
                  OrderStatus := OrderStatus::"Partially Put Away";
            END;
            First := FALSE;
          UNTIL NEXT = 0;
      END;
      EXIT(OrderStatus);
    END;

    LOCAL PROCEDURE DeleteRelatedLines@2();
    VAR
      Location@1004 : Record 14;
      WhsePutAwayRequest@1005 : Record 7324;
      PostedWhseRcptLine@1002 : Record 7319;
      WhseCommentLine@1003 : Record 5770;
    BEGIN
      IF Location.RequirePutaway("Location Code") THEN
        TESTFIELD("Document Status","Document Status"::"Completely Put Away");

      WhsePutAwayRequest.SETRANGE("Document Type",WhsePutAwayRequest."Document Type"::Receipt);
      WhsePutAwayRequest.SETRANGE("Document No.","No.");
      WhsePutAwayRequest.DELETEALL;

      PostedWhseRcptLine.SETRANGE("No.","No.");
      PostedWhseRcptLine.DELETEALL;

      WhseCommentLine.SETRANGE("Table Name",WhseCommentLine."Table Name"::"Posted Whse. Receipt");
      WhseCommentLine.SETRANGE(Type,WhseCommentLine.Type::" ");
      WhseCommentLine.SETRANGE("No.","No.");
      WhseCommentLine.DELETEALL;
    END;

    [External]
    PROCEDURE LookupPostedWhseRcptHeader@5(VAR PostedWhseRcptHeader@1001 : Record 7318);
    BEGIN
      COMMIT;
      IF USERID <> '' THEN BEGIN
        PostedWhseRcptHeader.FILTERGROUP := 2;
        PostedWhseRcptHeader.SETRANGE("Location Code");
      END;
      IF PAGE.RUNMODAL(0,PostedWhseRcptHeader) = ACTION::LookupOK THEN;
      IF USERID <> '' THEN BEGIN
        PostedWhseRcptHeader.FILTERGROUP := 2;
        PostedWhseRcptHeader.SETRANGE("Location Code",PostedWhseRcptHeader."Location Code");
        PostedWhseRcptHeader.FILTERGROUP := 0;
      END;
    END;

    [External]
    PROCEDURE FindFirstAllowedRec@1(Which@1000 : Text[1024]) : Boolean;
    VAR
      PostedWhseRcptHeader@1001 : Record 7318;
      WMSManagement@1002 : Codeunit 7302;
    BEGIN
      IF FIND(Which) THEN BEGIN
        PostedWhseRcptHeader := Rec;
        WHILE TRUE DO BEGIN
          IF WMSManagement.LocationIsAllowedToView("Location Code") THEN
            EXIT(TRUE);

          IF NEXT(1) = 0 THEN BEGIN
            Rec := PostedWhseRcptHeader;
            IF FIND(Which) THEN
              WHILE TRUE DO BEGIN
                IF WMSManagement.LocationIsAllowedToView("Location Code") THEN
                  EXIT(TRUE);

                IF NEXT(-1) = 0 THEN
                  EXIT(FALSE);
              END;
          END;
        END;
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE FindNextAllowedRec@3(Steps@1000 : Integer) : Integer;
    VAR
      PostedWhseRcptHeader@1002 : Record 7318;
      WMSManagement@1001 : Codeunit 7302;
      RealSteps@1003 : Integer;
      NextSteps@1004 : Integer;
    BEGIN
      RealSteps := 0;
      IF Steps <> 0 THEN BEGIN
        PostedWhseRcptHeader := Rec;
        REPEAT
          NextSteps := NEXT(Steps / ABS(Steps));
          IF WMSManagement.LocationIsAllowedToView("Location Code") THEN BEGIN
            RealSteps := RealSteps + NextSteps;
            PostedWhseRcptHeader := Rec;
          END;
        UNTIL (NextSteps = 0) OR (RealSteps = Steps);
        Rec := PostedWhseRcptHeader;
        IF NOT FIND THEN;
      END;
      EXIT(RealSteps);
    END;

    [External]
    PROCEDURE ErrorIfUserIsNotWhseEmployee@4();
    VAR
      WhseEmployee@1000 : Record 7301;
    BEGIN
      IF USERID <> '' THEN BEGIN
        WhseEmployee.SETRANGE("User ID",USERID);
        IF WhseEmployee.ISEMPTY THEN
          ERROR(Text000,USERID);
      END;
    END;

    BEGIN
    END.
  }
}

