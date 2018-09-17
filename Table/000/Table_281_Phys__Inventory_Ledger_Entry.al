OBJECT Table 281 Phys. Inventory Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lageropgõrelsespost;
               ENU=Phys. Inventory Ledger Entry];
    LookupPageID=Page390;
    DrillDownPageID=Page390;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 3   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 4   ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Kõb,Salg,Opregulering,Nedregulering,Overfõrsel,Forbrug,Afgang, ,Montageforbrug,Montageoutput;
                                                                    ENU=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output];
                                                   OptionString=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output }
    { 6   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 7   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 8   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 9   ;   ;Inventory Posting Group;Code20     ;TableRelation="Inventory Posting Group";
                                                   CaptionML=[DAN=Varebogfõringsgruppe;
                                                              ENU=Inventory Posting Group] }
    { 12  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 15  ;   ;Unit Amount         ;Decimal       ;CaptionML=[DAN=Pris;
                                                              ENU=Unit Amount];
                                                   AutoFormatType=2 }
    { 16  ;   ;Unit Cost           ;Decimal       ;CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2 }
    { 17  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 22  ;   ;Salespers./Purch. Code;Code20      ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Sëlger/indkõberkode;
                                                              ENU=Salespers./Purch. Code] }
    { 24  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 25  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 33  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 34  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 45  ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 46  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 54  ;   ;Qty. (Calculated)   ;Decimal       ;CaptionML=[DAN=Antal (beregnet);
                                                              ENU=Qty. (Calculated)];
                                                   DecimalPlaces=0:5 }
    { 55  ;   ;Qty. (Phys. Inventory);Decimal     ;CaptionML=[DAN=Antal (optalt);
                                                              ENU=Qty. (Phys. Inventory)];
                                                   DecimalPlaces=0:5 }
    { 56  ;   ;Last Item Ledger Entry No.;Integer ;TableRelation="Item Ledger Entry";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Sidste varepostlõbenr.;
                                                              ENU=Last Item Ledger Entry No.] }
    { 60  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 61  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 64  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 7380;   ;Phys Invt Counting Period Code;Code10;
                                                   TableRelation="Phys. Invt. Counting Period";
                                                   CaptionML=[DAN=Lageropg.-optëllingsperiodekode;
                                                              ENU=Phys Invt Counting Period Code];
                                                   Editable=No }
    { 7381;   ;Phys Invt Counting Period Type;Option;
                                                   CaptionML=[DAN=Lageropg.-optëllingsperiodetype;
                                                              ENU=Phys Invt Counting Period Type];
                                                   OptionCaptionML=[DAN=" ,Vare,Lagervare";
                                                                    ENU=" ,Item,SKU"];
                                                   OptionString=[ ,Item,SKU];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Item No.,Variant Code,Location Code,Posting Date;
                                                   SumIndexFields=Quantity }
    {    ;Item No.,Variant Code,Global Dimension 1 Code,Global Dimension 2 Code,Location Code,Posting Date;
                                                   SumIndexFields=Quantity }
    {    ;Document No.,Posting Date                }
    {    ;Item No.,Phys Invt Counting Period Type,Posting Date }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Item No.,Posting Date,Entry Type,Document No. }
  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;

    [External]
    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    BEGIN
    END.
  }
}

