OBJECT Table 5772 Registered Whse. Activity Hdr.
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 5773=rimd;
    OnDelete=VAR
               RgstrdWhseActivLine@1001 : Record 5773;
               WhseCommentLine@1000 : Record 5770;
             BEGIN
               RgstrdWhseActivLine.SETRANGE("Activity Type",Type);
               RgstrdWhseActivLine.SETRANGE("No.","No.");
               RgstrdWhseActivLine.DELETEALL;

               WhseCommentLine.SETRANGE("Table Name",WhseCommentLine."Table Name"::"Rgstrd. Whse. Activity Header");
               WhseCommentLine.SETRANGE(Type,Type);
               WhseCommentLine.SETRANGE("No.","No.");
               WhseCommentLine.DELETEALL;
             END;

    CaptionML=[DAN=Registreret lageraktivitetshoved;
               ENU=Registered Whse. Activity Hdr.];
    LookupPageID=Page5797;
  }
  FIELDS
  {
    { 1   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,L‘g-p†-lager,Pluk,Bev‘gelse";
                                                                    ENU=" ,Put-away,Pick,Movement"];
                                                   OptionString=[ ,Put-away,Pick,Movement] }
    { 2   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 3   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   NotBlank=Yes }
    { 4   ;   ;Assigned User ID    ;Code50        ;TableRelation="Warehouse Employee" WHERE (Location Code=FIELD(Location Code));
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
    { 5   ;   ;Assignment Date     ;Date          ;CaptionML=[DAN=Tildelt den;
                                                              ENU=Assignment Date] }
    { 6   ;   ;Assignment Time     ;Time          ;CaptionML=[DAN=Tildelt kl.;
                                                              ENU=Assignment Time] }
    { 7   ;   ;Sorting Method      ;Option        ;CaptionML=[DAN=Sorteringsmetode;
                                                              ENU=Sorting Method];
                                                   OptionCaptionML=[DAN=" ,Vare,Bilag,Placering,Forfaldsdato,Levering,Placeringsniv.,Handlingstype";
                                                                    ENU=" ,Item,Document,Shelf or Bin,Due Date,Ship-To,Bin Ranking,Action Type"];
                                                   OptionString=[ ,Item,Document,Shelf or Bin,Due Date,Ship-To,Bin Ranking,Action Type] }
    { 8   ;   ;Registering Date    ;Date          ;CaptionML=[DAN=Registreringsdato;
                                                              ENU=Registering Date] }
    { 9   ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 10  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Warehouse Comment Line" WHERE (Table Name=CONST(Rgstrd. Whse. Activity Header),
                                                                                                     Type=FIELD(Type),
                                                                                                     No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 11  ;   ;Whse. Activity No.  ;Code20        ;CaptionML=[DAN=Lageraktivitetsnr.;
                                                              ENU=Whse. Activity No.] }
    { 12  ;   ;No. Printed         ;Integer       ;CaptionML=[DAN=Udskrevet;
                                                              ENU=No. Printed];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Type,No.                                ;Clustered=Yes }
    {    ;No.,Type                                 }
    {    ;Whse. Activity No.                       }
    {    ;Location Code                            }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE SetWhseLocationFilter@12();
    VAR
      WmsManagement@1000 : Codeunit 7302;
    BEGIN
      IF USERID <> '' THEN BEGIN
        FILTERGROUP := 2;
        SETRANGE("Location Code",WmsManagement.GetAllowedLocation("Location Code"));
        FILTERGROUP := 0;
      END;
    END;

    [External]
    PROCEDURE LookupRegisteredActivityHeader@1(VAR CurrentLocationCode@1000 : Code[10];VAR RegisteredWhseActivHeader@1001 : Record 5772);
    BEGIN
      COMMIT;
      IF USERID <> '' THEN BEGIN
        RegisteredWhseActivHeader.FILTERGROUP := 2;
        RegisteredWhseActivHeader.SETRANGE("Location Code");
      END;
      IF PAGE.RUNMODAL(0,RegisteredWhseActivHeader) = ACTION::LookupOK THEN;
      IF USERID <> '' THEN BEGIN
        RegisteredWhseActivHeader.FILTERGROUP := 2;
        RegisteredWhseActivHeader.SETRANGE("Location Code",RegisteredWhseActivHeader."Location Code");
        RegisteredWhseActivHeader.FILTERGROUP := 0;
      END;
      CurrentLocationCode := RegisteredWhseActivHeader."Location Code";
    END;

    BEGIN
    END.
  }
}

