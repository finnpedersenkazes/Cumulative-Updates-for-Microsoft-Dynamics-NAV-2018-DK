OBJECT Table 7322 Posted Whse. Shipment Header
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 7323=rd;
    OnInsert=BEGIN
               WhseSetup.GET;
               IF "No." = '' THEN BEGIN
                 WhseSetup.TESTFIELD("Posted Whse. Shipment Nos.");
                 NoSeriesMgt.InitSeries(
                   WhseSetup."Posted Whse. Shipment Nos.",xRec."No. Series","Posting Date","No.","No. Series");
               END;
             END;

    OnDelete=VAR
               PostedWhseShptLine@1001 : Record 7323;
               WhseCommentLine@1000 : Record 5770;
             BEGIN
               PostedWhseShptLine.SETRANGE("No.","No.");
               PostedWhseShptLine.DELETEALL;

               WhseCommentLine.SETRANGE("Table Name",WhseCommentLine."Table Name"::"Posted Whse. Shipment");
               WhseCommentLine.SETRANGE(Type,WhseCommentLine.Type::" ");
               WhseCommentLine.SETRANGE("No.","No.");
               WhseCommentLine.DELETEALL;
             END;

    CaptionML=[DAN=Bogf. lagerleverancehoved;
               ENU=Posted Whse. Shipment Header];
    LookupPageID=Page7340;
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
                                                              ENU=Assigned User ID] }
    { 4   ;   ;Assignment Date     ;Date          ;CaptionML=[DAN=Tildelt den;
                                                              ENU=Assignment Date];
                                                   Editable=No }
    { 5   ;   ;Assignment Time     ;Time          ;CaptionML=[DAN=Tildelt kl.;
                                                              ENU=Assignment Time];
                                                   Editable=No }
    { 7   ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 11  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Warehouse Comment Line" WHERE (Table Name=CONST(Posted Whse. Shipment),
                                                                                                     Type=CONST(" "),
                                                                                                     No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 12  ;   ;Bin Code            ;Code20        ;TableRelation=IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                 ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                  Zone Code=FIELD(Zone Code));
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 13  ;   ;Zone Code           ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   CaptionML=[DAN=Zonekode;
                                                              ENU=Zone Code] }
    { 39  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 40  ;   ;Shipment Date       ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 41  ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Spedit›rkode;
                                                              ENU=Shipping Agent Code] }
    { 42  ;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   CaptionML=[DAN=Spedit›rservicekode;
                                                              ENU=Shipping Agent Service Code] }
    { 43  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   CaptionML=[DAN=Leveringskode;
                                                              ENU=Shipment Method Code] }
    { 45  ;   ;Whse. Shipment No.  ;Code20        ;CaptionML=[DAN=Lagerleverancenr. (logistik);
                                                              ENU=Whse. Shipment No.] }
    { 48  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Location Code                            }
    {    ;Whse. Shipment No.                       }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Location Code,Posting Date           }
  }
  CODE
  {
    VAR
      WhseSetup@1000 : Record 5769;
      NoSeriesMgt@1001 : Codeunit 396;
      Text000@1002 : TextConst 'DAN=Du skal f›rst oprette brugeren %1 som lagermedarbejder.;ENU=You must first set up user %1 as a warehouse employee.';

    [External]
    PROCEDURE LookupPostedWhseShptHeader@3(VAR PostedWhseShptHeader@1001 : Record 7322);
    BEGIN
      COMMIT;
      IF USERID <> '' THEN BEGIN
        PostedWhseShptHeader.FILTERGROUP := 2;
        PostedWhseShptHeader.SETRANGE("Location Code");
      END;
      IF PAGE.RUNMODAL(0,PostedWhseShptHeader) = ACTION::LookupOK THEN;
      IF USERID <> '' THEN BEGIN
        PostedWhseShptHeader.FILTERGROUP := 2;
        PostedWhseShptHeader.SETRANGE("Location Code",PostedWhseShptHeader."Location Code");
        PostedWhseShptHeader.FILTERGROUP := 0;
      END;
    END;

    [External]
    PROCEDURE FindFirstAllowedRec@1(Which@1000 : Text[1024]) : Boolean;
    VAR
      PostedWhseShptHeader@1001 : Record 7322;
      WMSManagement@1002 : Codeunit 7302;
    BEGIN
      IF FIND(Which) THEN BEGIN
        PostedWhseShptHeader := Rec;
        WHILE TRUE DO BEGIN
          IF WMSManagement.LocationIsAllowedToView("Location Code") THEN
            EXIT(TRUE);

          IF NEXT(1) = 0 THEN BEGIN
            Rec := PostedWhseShptHeader;
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
    PROCEDURE FindNextAllowedRec@2(Steps@1000 : Integer) : Integer;
    VAR
      PostedWhseShptHeader@1002 : Record 7322;
      WMSManagement@1001 : Codeunit 7302;
      RealSteps@1003 : Integer;
      NextSteps@1004 : Integer;
    BEGIN
      RealSteps := 0;
      IF Steps <> 0 THEN BEGIN
        PostedWhseShptHeader := Rec;
        REPEAT
          NextSteps := NEXT(Steps / ABS(Steps));
          IF WMSManagement.LocationIsAllowedToView("Location Code") THEN BEGIN
            RealSteps := RealSteps + NextSteps;
            PostedWhseShptHeader := Rec;
          END;
        UNTIL (NextSteps = 0) OR (RealSteps = Steps);
        Rec := PostedWhseShptHeader;
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

