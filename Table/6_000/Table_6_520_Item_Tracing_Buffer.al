OBJECT Table 6520 Item Tracing Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varesporingsbuffer;
               ENU=Item Tracing Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 2   ;   ;Parent Item Ledger Entry No.;Integer;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Styklistelõbenr.;
                                                              ENU=Parent Item Ledger Entry No.];
                                                   Editable=No }
    { 3   ;   ;Level               ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Niveau;
                                                              ENU=Level];
                                                   Editable=No }
    { 4   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.];
                                                   Editable=No }
    { 5   ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date];
                                                   Editable=No }
    { 6   ;   ;Entry Type          ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Kõb,Salg,Opregulering,Nedregulering,Overfõrsel,Forbrug,Afgang, ,Montageforbrug,Montageoutput;
                                                                    ENU=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output];
                                                   OptionString=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output;
                                                   Editable=No }
    { 7   ;   ;Source Type         ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Vare";
                                                                    ENU=" ,Customer,Vendor,Item"];
                                                   OptionString=[ ,Customer,Vendor,Item];
                                                   Editable=No }
    { 8   ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) Customer
                                                                 ELSE IF (Source Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Source Type=CONST(Item)) Item;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.];
                                                   Editable=No }
    { 9   ;   ;Source Name         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildenavn;
                                                              ENU=Source Name];
                                                   Editable=No }
    { 10  ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.];
                                                   Editable=No }
    { 11  ;   ;Description         ;Text100       ;OnLookup=BEGIN
                                                              WhereUsedMgt.ShowDocument("Record Identifier");
                                                            END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 12  ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   Editable=No }
    { 13  ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 14  ;   ;Remaining Quantity  ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Restantal;
                                                              ENU=Remaining Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 16  ;   ;Open                ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=èben;
                                                              ENU=Open];
                                                   Editable=No }
    { 17  ;   ;Positive            ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Positiv;
                                                              ENU=Positive];
                                                   Editable=No }
    { 18  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code];
                                                   Editable=No }
    { 19  ;   ;Serial No.          ;Code20        ;OnLookup=BEGIN
                                                              ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",0,"Serial No.");
                                                            END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.];
                                                   Editable=No }
    { 20  ;   ;Lot No.             ;Code20        ;OnLookup=BEGIN
                                                              ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",1,"Lot No.");
                                                            END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.];
                                                   Editable=No }
    { 21  ;   ;Item Ledger Entry No.;Integer      ;TableRelation="Item Ledger Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varepostlõbenr.;
                                                              ENU=Item Ledger Entry No.];
                                                   Editable=No }
    { 22  ;   ;Created by          ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Created by");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprettet af;
                                                              ENU=Created by];
                                                   Editable=No }
    { 23  ;   ;Created on          ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprettet d.;
                                                              ENU=Created on];
                                                   Editable=No }
    { 24  ;   ;Record Identifier   ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record Identifier];
                                                   Editable=No }
    { 25  ;   ;Item Description    ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varebeskrivelse;
                                                              ENU=Item Description] }
    { 26  ;   ;Already Traced      ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Allerede sporet;
                                                              ENU=Already Traced];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Line No.                                ;Clustered=Yes }
    {    ;Item Ledger Entry No.                    }
    {    ;Serial No.,Item Ledger Entry No.         }
    {    ;Lot No.,Item Ledger Entry No.            }
    {    ;Item No.,Item Ledger Entry No.           }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ItemTrackingMgt@1000000000 : Codeunit 6500;
      WhereUsedMgt@1000 : Codeunit 6520;

    [External]
    PROCEDURE SetDescription@2(Description2@1000 : Text[100]);
    BEGIN
      Description := FORMAT(Description2,-MAXSTRLEN(Description));
    END;

    BEGIN
    END.
  }
}

