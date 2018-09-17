OBJECT Table 5909 Service Shipment Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Serviceleverancebuffer;
               ENU=Service Shipment Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Document No.        ;Code20        ;TableRelation="Service Invoice Header";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 2   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 5   ;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,Ressource,Anl‘g,Gebyr (vare)";
                                                                    ENU=" ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)"];
                                                   OptionString=[ ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)] }
    { 6   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(Resource)) Resource
                                                                 ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 7   ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity] }
    { 8   ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
  }
  KEYS
  {
    {    ;Document No.,Line No.,Entry No.         ;SumIndexFields=Quantity;
                                                   Clustered=Yes }
    {    ;Document No.,Line No.,Posting Date       }
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

