OBJECT Table 7312 Warehouse Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagerpost;
               ENU=Warehouse Entry];
    LookupPageID=Page7318;
    DrillDownPageID=Page7318;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 3   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.];
                                                   BlankZero=Yes }
    { 4   ;   ;Registering Date    ;Date          ;CaptionML=[DAN=Registreringsdato;
                                                              ENU=Registering Date] }
    { 5   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 6   ;   ;Zone Code           ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   CaptionML=[DAN=Zonekode;
                                                              ENU=Zone Code] }
    { 7   ;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 8   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 9   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 10  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 11  ;   ;Qty. (Base)         ;Decimal       ;CaptionML=[DAN=Antal (basis);
                                                              ENU=Qty. (Base)];
                                                   DecimalPlaces=0:5 }
    { 20  ;   ;Source Type         ;Integer       ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type] }
    { 21  ;   ;Source Subtype      ;Option        ;CaptionML=[DAN=Kildeundertype;
                                                              ENU=Source Subtype];
                                                   OptionCaptionML=[DAN=0,1,2,3,4,5,6,7,8,9,10;
                                                                    ENU=0,1,2,3,4,5,6,7,8,9,10];
                                                   OptionString=0,1,2,3,4,5,6,7,8,9,10 }
    { 22  ;   ;Source No.          ;Code20        ;CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 23  ;   ;Source Line No.     ;Integer       ;CaptionML=[DAN=Kildelinjenr.;
                                                              ENU=Source Line No.];
                                                   BlankZero=Yes }
    { 24  ;   ;Source Subline No.  ;Integer       ;CaptionML=[DAN=Kildeunderlinjenr.;
                                                              ENU=Source Subline No.] }
    { 25  ;   ;Source Document     ;Option        ;CaptionML=[DAN=Kildedokument;
                                                              ENU=Source Document];
                                                   OptionCaptionML=[DAN=,S.ordre,S.faktura,S.kreditnota,S.returv.ordre,K.ordre,K.faktura,K.kreditnota,K.returv.ordre,Indg. overf›r.,Udg. overf›r.,Prod.forbrug,Varekld.,Lageropg.kld.,Ompost.kld.,Forbrugskld.,Afgangskld.,Styklistekld.,Serv.ordre,Sagskld.,Montageforbrug,Montageordre;
                                                                    ENU=,S. Order,S. Invoice,S. Credit Memo,S. Return Order,P. Order,P. Invoice,P. Credit Memo,P. Return Order,Inb. Transfer,Outb. Transfer,Prod. Consumption,Item Jnl.,Phys. Invt. Jnl.,Reclass. Jnl.,Consumption Jnl.,Output Jnl.,BOM Jnl.,Serv. Order,Job Jnl.,Assembly Consumption,Assembly Order];
                                                   OptionString=,S. Order,S. Invoice,S. Credit Memo,S. Return Order,P. Order,P. Invoice,P. Credit Memo,P. Return Order,Inb. Transfer,Outb. Transfer,Prod. Consumption,Item Jnl.,Phys. Invt. Jnl.,Reclass. Jnl.,Consumption Jnl.,Output Jnl.,BOM Jnl.,Serv. Order,Job Jnl.,Assembly Consumption,Assembly Order;
                                                   BlankZero=Yes }
    { 26  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 29  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=rsagskode;
                                                              ENU=Reason Code] }
    { 33  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 35  ;   ;Bin Type Code       ;Code10        ;TableRelation="Bin Type";
                                                   CaptionML=[DAN=Placeringstypekode;
                                                              ENU=Bin Type Code] }
    { 40  ;   ;Cubage              ;Decimal       ;CaptionML=[DAN=Rumm†l;
                                                              ENU=Cubage];
                                                   DecimalPlaces=0:5 }
    { 41  ;   ;Weight              ;Decimal       ;CaptionML=[DAN=V‘gt;
                                                              ENU=Weight];
                                                   DecimalPlaces=0:5 }
    { 45  ;   ;Journal Template Name;Code10       ;CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name] }
    { 50  ;   ;Whse. Document No.  ;Code20        ;CaptionML=[DAN=Lagerdokumentnr.;
                                                              ENU=Whse. Document No.] }
    { 51  ;   ;Whse. Document Type ;Option        ;CaptionML=[DAN=Lagerdokumenttype;
                                                              ENU=Whse. Document Type];
                                                   OptionCaptionML=[DAN=Lagerkladde,Modtagelse,Leverance,Internt l‘g-p†-lager,Internt pluk,Produktion,Lagerplac.opg., ,Montage;
                                                                    ENU=Whse. Journal,Receipt,Shipment,Internal Put-away,Internal Pick,Production,Whse. Phys. Inventory, ,Assembly];
                                                   OptionString=Whse. Journal,Receipt,Shipment,Internal Put-away,Internal Pick,Production,Whse. Phys. Inventory, ,Assembly }
    { 52  ;   ;Whse. Document Line No.;Integer    ;CaptionML=[DAN=Lagerdokumentlinjenr.;
                                                              ENU=Whse. Document Line No.];
                                                   BlankZero=Yes }
    { 55  ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Nedregulering,Opregulering,Bev‘gelse;
                                                                    ENU=Negative Adjmt.,Positive Adjmt.,Movement];
                                                   OptionString=Negative Adjmt.,Positive Adjmt.,Movement }
    { 60  ;   ;Reference Document  ;Option        ;CaptionML=[DAN=Referencedokument;
                                                              ENU=Reference Document];
                                                   OptionCaptionML=[DAN=" ,Bogf›rt modt.,Bogf. k›bsfakt.,Bogf. returv.modt.,Bogf. k›bskred.nota,Bogf. leverance,Bogf. salgsfakt.,Bogf. returv.leverance,Bogf. salgskred.nota,Bogf. overf›r.kvit.,Bogf. overf›r.lev.,Varekladde,Prod.,L‘g-p†-lager,Pluk,Bev‘gelse,Styklistekld.,Sagskladde,Montage";
                                                                    ENU=" ,Posted Rcpt.,Posted P. Inv.,Posted Rtrn. Rcpt.,Posted P. Cr. Memo,Posted Shipment,Posted S. Inv.,Posted Rtrn. Shipment,Posted S. Cr. Memo,Posted T. Receipt,Posted T. Shipment,Item Journal,Prod.,Put-away,Pick,Movement,BOM Journal,Job Journal,Assembly"];
                                                   OptionString=[ ,Posted Rcpt.,Posted P. Inv.,Posted Rtrn. Rcpt.,Posted P. Cr. Memo,Posted Shipment,Posted S. Inv.,Posted Rtrn. Shipment,Posted S. Cr. Memo,Posted T. Receipt,Posted T. Shipment,Item Journal,Prod.,Put-away,Pick,Movement,BOM Journal,Job Journal,Assembly] }
    { 61  ;   ;Reference No.       ;Code20        ;CaptionML=[DAN=Referencenr.;
                                                              ENU=Reference No.] }
    { 67  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5 }
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 6500;   ;Serial No.          ;Code20        ;OnLookup=BEGIN
                                                              ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",0,"Serial No.");
                                                            END;

                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
    { 6501;   ;Lot No.             ;Code20        ;OnLookup=BEGIN
                                                              ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",1,"Lot No.");
                                                            END;

                                                   CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.] }
    { 6502;   ;Warranty Date       ;Date          ;CaptionML=[DAN=Garantioph›r den;
                                                              ENU=Warranty Date] }
    { 6503;   ;Expiration Date     ;Date          ;CaptionML=[DAN=Udl›bsdato;
                                                              ENU=Expiration Date] }
    { 7380;   ;Phys Invt Counting Period Code;Code10;
                                                   TableRelation="Phys. Invt. Counting Period";
                                                   CaptionML=[DAN=Lageropg.-opt‘llingsperiodekode;
                                                              ENU=Phys Invt Counting Period Code];
                                                   Editable=No }
    { 7381;   ;Phys Invt Counting Period Type;Option;
                                                   CaptionML=[DAN=Lageropg.-opt‘llingsperiodetype;
                                                              ENU=Phys Invt Counting Period Type];
                                                   OptionCaptionML=[DAN=" ,Vare,Lagervare";
                                                                    ENU=" ,Item,SKU"];
                                                   OptionString=[ ,Item,SKU];
                                                   Editable=No }
    { 7382;   ;Dedicated           ;Boolean       ;CaptionML=[DAN=Dedikeret;
                                                              ENU=Dedicated];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Reference No.,Registering Date           }
    {    ;Source Type,Source Subtype,Source No.,Source Line No.,Source Subline No.,Source Document,Bin Code }
    { No ;Serial No.,Item No.,Variant Code,Location Code,Bin Code;
                                                   SumIndexFields=Qty. (Base) }
    {    ;Item No.,Bin Code,Location Code,Variant Code,Unit of Measure Code,Lot No.,Serial No.,Entry Type,Dedicated;
                                                   SumIndexFields=Qty. (Base),Cubage,Weight,Quantity }
    {    ;Item No.,Location Code,Variant Code,Bin Type Code,Unit of Measure Code,Lot No.,Serial No.,Dedicated;
                                                   SumIndexFields=Qty. (Base),Cubage,Weight }
    {    ;Bin Code,Location Code,Item No.         ;SumIndexFields=Cubage,Weight,Qty. (Base) }
    {    ;Location Code,Item No.,Variant Code,Zone Code,Bin Code,Lot No.;
                                                   SumIndexFields=Qty. (Base) }
    {    ;Location Code                           ;SumIndexFields=Qty. (Base);
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    { No ;Lot No.                                  }
    { No ;Serial No.                               }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Registering Date,Entry No.,Location Code,Item No. }
  }
  CODE
  {
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;

    [External]
    PROCEDURE SetSourceFilter@42(SourceType@1004 : Integer;SourceSubType@1003 : Option;SourceNo@1002 : Code[20];SourceLineNo@1001 : Integer;SetKey@1005 : Boolean);
    BEGIN
      IF SetKey THEN
        SETCURRENTKEY("Source Type","Source Subtype","Source No.","Source Line No.");
      SETRANGE("Source Type",SourceType);
      IF SourceSubType >= 0 THEN
        SETRANGE("Source Subtype",SourceSubType);
      SETRANGE("Source No.",SourceNo);
      IF SourceLineNo >= 0 THEN
        SETRANGE("Source Line No.",SourceLineNo);
    END;

    [External]
    PROCEDURE TrackingExists@1() : Boolean;
    BEGIN
      EXIT(("Lot No." <> '') OR ("Serial No." <> ''));
    END;

    BEGIN
    END.
  }
}

