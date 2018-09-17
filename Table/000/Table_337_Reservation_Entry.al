OBJECT Table 337 Reservation Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=VAR
               ActionMessageEntry@1000 : Record 99000849;
             BEGIN
               ActionMessageEntry.SETCURRENTKEY("Reservation Entry");
               ActionMessageEntry.SETRANGE("Reservation Entry","Entry No.");
               ActionMessageEntry.DELETEALL;
             END;

    CaptionML=[DAN=Reservationspost;
               ENU=Reservation Entry];
    LookupPageID=Page497;
    DrillDownPageID=Page497;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 3   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 4   ;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                Quantity := CalcReservationQuantity;
                                                                "Qty. to Handle (Base)" := "Quantity (Base)";
                                                                "Qty. to Invoice (Base)" := "Quantity (Base)";
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5   ;   ;Reservation Status  ;Option        ;CaptionML=[DAN=Reservationsstatus;
                                                              ENU=Reservation Status];
                                                   OptionCaptionML=[DAN=Reservation,Sporing,Overskud,Emne;
                                                                    ENU=Reservation,Tracking,Surplus,Prospect];
                                                   OptionString=Reservation,Tracking,Surplus,Prospect }
    { 7   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 8   ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date] }
    { 9   ;   ;Transferred from Entry No.;Integer ;TableRelation="Reservation Entry";
                                                   CaptionML=[DAN=Overf�rt fra post nr.;
                                                              ENU=Transferred from Entry No.] }
    { 10  ;   ;Source Type         ;Integer       ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type] }
    { 11  ;   ;Source Subtype      ;Option        ;CaptionML=[DAN=Kildeundertype;
                                                              ENU=Source Subtype];
                                                   OptionCaptionML=[DAN=0,1,2,3,4,5,6,7,8,9,10;
                                                                    ENU=0,1,2,3,4,5,6,7,8,9,10];
                                                   OptionString=0,1,2,3,4,5,6,7,8,9,10 }
    { 12  ;   ;Source ID           ;Code20        ;CaptionML=[DAN=Kilde-id;
                                                              ENU=Source ID] }
    { 13  ;   ;Source Batch Name   ;Code10        ;CaptionML=[DAN=Kildekladdenavn;
                                                              ENU=Source Batch Name] }
    { 14  ;   ;Source Prod. Order Line;Integer    ;CaptionML=[DAN=Kildeprod.ordrelinje;
                                                              ENU=Source Prod. Order Line] }
    { 15  ;   ;Source Ref. No.     ;Integer       ;CaptionML=[DAN=Kildereferencenr.;
                                                              ENU=Source Ref. No.] }
    { 16  ;   ;Item Ledger Entry No.;Integer      ;TableRelation="Item Ledger Entry";
                                                   CaptionML=[DAN=Varepostl�benr.;
                                                              ENU=Item Ledger Entry No.];
                                                   Editable=No }
    { 22  ;   ;Expected Receipt Date;Date         ;CaptionML=[DAN=Forventet modt.dato;
                                                              ENU=Expected Receipt Date] }
    { 23  ;   ;Shipment Date       ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 24  ;   ;Serial No.          ;Code20        ;CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
    { 25  ;   ;Created By          ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Created By");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af;
                                                              ENU=Created By] }
    { 27  ;   ;Changed By          ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Changed By");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=�ndret af;
                                                              ENU=Changed By] }
    { 28  ;   ;Positive            ;Boolean       ;CaptionML=[DAN=Positiv;
                                                              ENU=Positive];
                                                   Editable=No }
    { 29  ;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   OnValidate=BEGIN
                                                                Quantity := ROUND("Quantity (Base)" / "Qty. per Unit of Measure",0.00001);
                                                              END;

                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 30  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 31  ;   ;Action Message Adjustment;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Action Message Entry".Quantity WHERE (Reservation Entry=FIELD(Entry No.),
                                                                                                          Calculation=CONST(Sum)));
                                                   CaptionML=[DAN=Aktionsmeddelelsesjustering;
                                                              ENU=Action Message Adjustment];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 32  ;   ;Binding             ;Option        ;CaptionML=[DAN=Binding;
                                                              ENU=Binding];
                                                   OptionCaptionML=[DAN=" ,Ordre-til-ordre";
                                                                    ENU=" ,Order-to-Order"];
                                                   OptionString=[ ,Order-to-Order];
                                                   Editable=No }
    { 33  ;   ;Suppressed Action Msg.;Boolean     ;CaptionML=[DAN=Undertrykt aktionsmeddelelse;
                                                              ENU=Suppressed Action Msg.] }
    { 34  ;   ;Planning Flexibility;Option        ;CaptionML=[DAN=Planl�gningsfleksibilitet;
                                                              ENU=Planning Flexibility];
                                                   OptionCaptionML=[DAN=Ubegr�nset,Ingen;
                                                                    ENU=Unlimited,None];
                                                   OptionString=Unlimited,None }
    { 38  ;   ;Appl.-to Item Entry ;Integer       ;CaptionML=[DAN=Udl.varepostl�benr.;
                                                              ENU=Appl.-to Item Entry] }
    { 40  ;   ;Warranty Date       ;Date          ;CaptionML=[DAN=Garantioph�r den;
                                                              ENU=Warranty Date];
                                                   Editable=No }
    { 41  ;   ;Expiration Date     ;Date          ;CaptionML=[DAN=Udl�bsdato;
                                                              ENU=Expiration Date];
                                                   Editable=No }
    { 50  ;   ;Qty. to Handle (Base);Decimal      ;CaptionML=[DAN=H�ndteringsantal (basis);
                                                              ENU=Qty. to Handle (Base)];
                                                   DecimalPlaces=0:5 }
    { 51  ;   ;Qty. to Invoice (Base);Decimal     ;CaptionML=[DAN=Fakturer antal (basis);
                                                              ENU=Qty. to Invoice (Base)];
                                                   DecimalPlaces=0:5 }
    { 53  ;   ;Quantity Invoiced (Base);Decimal   ;CaptionML=[DAN=Faktureret antal (basis);
                                                              ENU=Quantity Invoiced (Base)];
                                                   DecimalPlaces=0:5 }
    { 80  ;   ;New Serial No.      ;Code20        ;CaptionML=[DAN=Nyt serienr.;
                                                              ENU=New Serial No.];
                                                   Editable=No }
    { 81  ;   ;New Lot No.         ;Code20        ;CaptionML=[DAN=Nyt lotnr.;
                                                              ENU=New Lot No.];
                                                   Editable=No }
    { 900 ;   ;Disallow Cancellation;Boolean      ;CaptionML=[DAN=Afvis annullering;
                                                              ENU=Disallow Cancellation] }
    { 5400;   ;Lot No.             ;Code20        ;CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.] }
    { 5401;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5811;   ;Appl.-from Item Entry;Integer      ;CaptionML=[DAN=Udlign fra-varepost;
                                                              ENU=Appl.-from Item Entry];
                                                   MinValue=0 }
    { 5817;   ;Correction          ;Boolean       ;CaptionML=[DAN=Rettelse;
                                                              ENU=Correction] }
    { 6505;   ;New Expiration Date ;Date          ;CaptionML=[DAN=Ny udl�bsdato;
                                                              ENU=New Expiration Date];
                                                   Editable=No }
    { 6510;   ;Item Tracking       ;Option        ;CaptionML=[DAN=Varesporing;
                                                              ENU=Item Tracking];
                                                   OptionCaptionML=[DAN=Ingen,Lotnr.,Lot- og serienr.,Serienr.;
                                                                    ENU=None,Lot No.,Lot and Serial No.,Serial No.];
                                                   OptionString=None,Lot No.,Lot and Serial No.,Serial No.;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.,Positive                      ;Clustered=Yes }
    {    ;Source ID,Source Ref. No.,Source Type,Source Subtype,Source Batch Name,Source Prod. Order Line,Reservation Status,Shipment Date,Expected Receipt Date;
                                                   SumIndexFields=Quantity (Base),Quantity,Qty. to Handle (Base),Qty. to Invoice (Base) }
    {    ;Item No.,Variant Code,Location Code     ;MaintainSIFTIndex=No }
    {    ;Item No.,Variant Code,Location Code,Reservation Status,Shipment Date,Expected Receipt Date,Serial No.,Lot No.;
                                                   SumIndexFields=Quantity (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Item No.,Source Type,Source Subtype,Reservation Status,Location Code,Variant Code,Shipment Date,Expected Receipt Date,Serial No.,Lot No.;
                                                   SumIndexFields=Quantity (Base),Quantity;
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Item No.,Variant Code,Location Code,Item Tracking,Reservation Status,Lot No.,Serial No.;
                                                   SumIndexFields=Quantity (Base);
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    { No ;Lot No.                                  }
    { No ;Serial No.                               }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Positive,Item No.,Description,Quantity }
  }
  CODE
  {
    VAR
      Text001@1000 : TextConst 'DAN=Linje;ENU=Line';

    [External]
    PROCEDURE TextCaption@1() : Text[255];
    VAR
      ItemLedgEntry@1000 : Record 32;
      SalesLine@1007 : Record 37;
      ReqLine@1006 : Record 246;
      PurchLine@1005 : Record 39;
      ItemJnlLine@1004 : Record 83;
      ProdOrderLine@1003 : Record 5406;
      ProdOrderComp@1002 : Record 5407;
      AssemblyHeader@1011 : Record 900;
      AssemblyLine@1012 : Record 901;
      TransLine@1001 : Record 5741;
      ServLine@1009 : Record 5902;
      JobJnlLine@1010 : Record 210;
    BEGIN
      CASE "Source Type" OF
        DATABASE::"Item Ledger Entry":
          EXIT(ItemLedgEntry.TABLECAPTION);
        DATABASE::"Sales Line":
          EXIT(SalesLine.TABLECAPTION);
        DATABASE::"Requisition Line":
          EXIT(ReqLine.TABLECAPTION);
        DATABASE::"Purchase Line":
          EXIT(PurchLine.TABLECAPTION);
        DATABASE::"Item Journal Line":
          EXIT(ItemJnlLine.TABLECAPTION);
        DATABASE::"Job Journal Line":
          EXIT(JobJnlLine.TABLECAPTION);
        DATABASE::"Prod. Order Line":
          EXIT(ProdOrderLine.TABLECAPTION);
        DATABASE::"Prod. Order Component":
          EXIT(ProdOrderComp.TABLECAPTION);
        DATABASE::"Assembly Header":
          EXIT(AssemblyHeader.TABLECAPTION);
        DATABASE::"Assembly Line":
          EXIT(AssemblyLine.TABLECAPTION);
        DATABASE::"Transfer Line":
          EXIT(TransLine.TABLECAPTION);
        DATABASE::"Service Line":
          EXIT(ServLine.TABLECAPTION);
        ELSE
          EXIT(Text001);
      END;
    END;

    [External]
    PROCEDURE SummEntryNo@3() : Integer;
    BEGIN
      CASE "Source Type" OF
        DATABASE::"Item Ledger Entry":
          EXIT(1);
        DATABASE::"Purchase Line":
          EXIT(11 + "Source Subtype");
        DATABASE::"Requisition Line":
          EXIT(21);
        DATABASE::"Sales Line":
          EXIT(31 + "Source Subtype");
        DATABASE::"Item Journal Line":
          EXIT(41 + "Source Subtype");
        DATABASE::"Job Journal Line":
          EXIT(51 + "Source Subtype");
        DATABASE::"Prod. Order Line":
          EXIT(61 + "Source Subtype");
        DATABASE::"Prod. Order Component":
          EXIT(71 + "Source Subtype");
        DATABASE::"Transfer Line":
          EXIT(101 + "Source Subtype");
        DATABASE::"Service Line":
          EXIT(110);
        DATABASE::"Assembly Header":
          EXIT(141 + "Source Subtype");
        DATABASE::"Assembly Line":
          EXIT(151 + "Source Subtype");
        ELSE
          EXIT(0);
      END;
    END;

    [External]
    PROCEDURE HasSamePointer@24(ReservEntry@1000 : Record 337) : Boolean;
    BEGIN
      EXIT(
        ("Source Type" = ReservEntry."Source Type") AND
        ("Source Subtype" = ReservEntry."Source Subtype") AND
        ("Source ID" = ReservEntry."Source ID") AND
        ("Source Batch Name" = ReservEntry."Source Batch Name") AND
        ("Source Prod. Order Line" = ReservEntry."Source Prod. Order Line") AND
        ("Source Ref. No." = ReservEntry."Source Ref. No."));
    END;

    [External]
    PROCEDURE HasSamePointerWithSpec@58(TrackingSpecification@1000 : Record 336) : Boolean;
    BEGIN
      EXIT(
        ("Source Type" = TrackingSpecification."Source Type") AND
        ("Source Subtype" = TrackingSpecification."Source Subtype") AND
        ("Source ID" = TrackingSpecification."Source ID") AND
        ("Source Batch Name" = TrackingSpecification."Source Batch Name") AND
        ("Source Prod. Order Line" = TrackingSpecification."Source Prod. Order Line") AND
        ("Source Ref. No." = TrackingSpecification."Source Ref. No."));
    END;

    [External]
    PROCEDURE SetPointer@2(RowID@1000 : Text[250]);
    VAR
      ItemTrackingMgt@1001 : Codeunit 6500;
      StrArray@1002 : ARRAY [6] OF Text[100];
    BEGIN
      ItemTrackingMgt.DecomposeRowID(RowID,StrArray);
      EVALUATE("Source Type",StrArray[1]);
      EVALUATE("Source Subtype",StrArray[2]);
      "Source ID" := StrArray[3];
      "Source Batch Name" := StrArray[4];
      EVALUATE("Source Prod. Order Line",StrArray[5]);
      EVALUATE("Source Ref. No.",StrArray[6]);
    END;

    [External]
    PROCEDURE SetPointerFilter@15();
    BEGIN
      SETCURRENTKEY(
        "Source ID","Source Ref. No.","Source Type","Source Subtype",
        "Source Batch Name","Source Prod. Order Line","Reservation Status",
        "Shipment Date","Expected Receipt Date");
      SETRANGE("Source ID","Source ID");
      SETRANGE("Source Ref. No.","Source Ref. No.");
      SETRANGE("Source Type","Source Type");
      SETRANGE("Source Subtype","Source Subtype");
      SETRANGE("Source Batch Name","Source Batch Name");
      SETRANGE("Source Prod. Order Line","Source Prod. Order Line");
    END;

    [External]
    PROCEDURE Lock@4();
    VAR
      Rec2@1000 : Record 337;
    BEGIN
      Rec2.SETCURRENTKEY("Item No.");
      IF "Item No." <> '' THEN
        Rec2.SETRANGE("Item No.","Item No.");
      Rec2.LOCKTABLE;
      IF Rec2.FINDLAST THEN;
    END;

    [External]
    PROCEDURE SetItemData@29(ItemNo@1000 : Code[20];ItemDescription@1001 : Text[50];LocationCode@1002 : Code[10];VariantCode@1003 : Code[10];QtyPerUoM@1004 : Decimal);
    BEGIN
      "Item No." := ItemNo;
      Description := ItemDescription;
      "Location Code" := LocationCode;
      "Variant Code" := VariantCode;
      "Qty. per Unit of Measure" := QtyPerUoM;
    END;

    [External]
    PROCEDURE SetSource@21(SourceType@1000 : Integer;SourceSubtype@1001 : Integer;SourceID@1002 : Code[20];SourceRefNo@1003 : Integer;SourceBatchName@1004 : Code[10];SourceProdOrderLine@1005 : Integer);
    BEGIN
      "Source Type" := SourceType;
      "Source Subtype" := SourceSubtype;
      "Source ID" := SourceID;
      "Source Ref. No." := SourceRefNo;
      "Source Batch Name" := SourceBatchName;
      "Source Prod. Order Line" := SourceProdOrderLine;
    END;

    [External]
    PROCEDURE SetSourceFilter@31(SourceType@1011 : Integer;SourceSubtype@1010 : Integer;SourceID@1009 : Code[20];SourceRefNo@1008 : Integer;SourceKey@1000 : Boolean);
    BEGIN
      IF SourceKey THEN
        SETCURRENTKEY(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line");
      SETRANGE("Source Type",SourceType);
      IF SourceSubtype >= 0 THEN
        SETRANGE("Source Subtype",SourceSubtype);
      SETRANGE("Source ID",SourceID);
      IF SourceRefNo >= 0 THEN
        SETRANGE("Source Ref. No.",SourceRefNo);
    END;

    [External]
    PROCEDURE SetSourceFilter2@9(SourceBatchName@1007 : Code[10];SourceProdOrderLine@1006 : Integer);
    BEGIN
      SETRANGE("Source Batch Name",SourceBatchName);
      SETRANGE("Source Prod. Order Line",SourceProdOrderLine);
    END;

    [External]
    PROCEDURE ClearTracking@20();
    BEGIN
      "Serial No." := '';
      "Lot No." := '';
      "Warranty Date" := 0D;
      "Expiration Date" := 0D;
    END;

    [External]
    PROCEDURE ClearTrackingFilter@14();
    BEGIN
      SETRANGE("Serial No.");
      SETRANGE("Lot No.");
    END;

    [External]
    PROCEDURE CopyTrackingFromItemLedgEntry@25(ItemLedgerEntry@1000 : Record 32);
    BEGIN
      "Serial No." := ItemLedgerEntry."Serial No.";
      "Lot No." := ItemLedgerEntry."Lot No.";
    END;

    [External]
    PROCEDURE CopyTrackingFromReservEntry@26(ReservationEntry@1000 : Record 337);
    BEGIN
      "Serial No." := ReservationEntry."Serial No.";
      "Lot No." := ReservationEntry."Lot No.";
    END;

    [External]
    PROCEDURE CopyTrackingFromSpec@19(TrackingSpecification@1000 : Record 336);
    BEGIN
      "Serial No." := TrackingSpecification."Serial No.";
      "Lot No." := TrackingSpecification."Lot No.";
      "Warranty Date" := TrackingSpecification."Warranty Date";
      "Expiration Date" := TrackingSpecification."Expiration Date";
    END;

    [External]
    PROCEDURE CopyTrackingFromWhseActivLine@27(WarehouseActivityLine@1000 : Record 5767);
    BEGIN
      "Serial No." := WarehouseActivityLine."Serial No.";
      "Lot No." := WarehouseActivityLine."Lot No.";
      "Expiration Date" := WarehouseActivityLine."Expiration Date";
    END;

    [External]
    PROCEDURE SetTrackingFilter@12(SerialNo@1007 : Code[20];LotNo@1006 : Code[20]);
    BEGIN
      SETRANGE("Serial No.",SerialNo);
      SETRANGE("Lot No.",LotNo);
    END;

    [External]
    PROCEDURE SetTrackingFilterBlank@23();
    BEGIN
      SETRANGE("Serial No.",'');
      SETRANGE("Lot No.",'');
    END;

    [External]
    PROCEDURE SetTrackingFilterFromItemJnlLine@8(ItemJournalLine@1000 : Record 83);
    BEGIN
      SETRANGE("Serial No.",ItemJournalLine."Serial No.");
      SETRANGE("Lot No.",ItemJournalLine."Lot No.");
    END;

    [External]
    PROCEDURE SetTrackingFilterFromReservEntry@17(ReservEntry@1000 : Record 337);
    BEGIN
      SETRANGE("Serial No.",ReservEntry."Serial No.");
      SETRANGE("Lot No.",ReservEntry."Lot No.");
    END;

    [External]
    PROCEDURE SetTrackingFilterFromSpec@16(TrackingSpecification@1000 : Record 336);
    BEGIN
      SETRANGE("Serial No.",TrackingSpecification."Serial No.");
      SETRANGE("Lot No.",TrackingSpecification."Lot No.");
    END;

    [External]
    PROCEDURE SetTrackingFilterFromWhseSpec@18(WhseItemTrackingLine@1000 : Record 6550);
    BEGIN
      SETRANGE("Serial No.",WhseItemTrackingLine."Serial No.");
      SETRANGE("Lot No.",WhseItemTrackingLine."Lot No.");
    END;

    [External]
    PROCEDURE UpdateItemTracking@5();
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      "Item Tracking" := ItemTrackingMgt.ItemTrackingOption("Lot No.","Serial No.");
    END;

    [External]
    PROCEDURE UpdateActionMessageEntries@13(OldReservEntry@1000 : Record 337);
    VAR
      ActionMessageEntry@1002 : Record 99000849;
      ActionMessageEntry2@1003 : Record 99000849;
      OldReservEntry2@1004 : Record 337;
    BEGIN
      IF OldReservEntry."Reservation Status" = OldReservEntry."Reservation Status"::Surplus THEN BEGIN
        ActionMessageEntry.FilterFromReservEntry(OldReservEntry);
        IF ActionMessageEntry.FINDSET THEN
          REPEAT
            ActionMessageEntry2 := ActionMessageEntry;
            ActionMessageEntry2.TransferFromReservEntry(Rec);
            ActionMessageEntry2.MODIFY;
          UNTIL ActionMessageEntry.NEXT = 0;
        MODIFY;
      END ELSE
        IF OldReservEntry2.GET(OldReservEntry."Entry No.",NOT OldReservEntry.Positive) THEN BEGIN
          IF HasSamePointer(OldReservEntry2) THEN BEGIN
            OldReservEntry2.DELETE;
            DELETE;
          END ELSE
            MODIFY;
        END ELSE
          MODIFY;
    END;

    [External]
    PROCEDURE ClearItemTrackingFields@7();
    BEGIN
      "Lot No." := '';
      "Serial No." := '';
      UpdateItemTracking;
    END;

    LOCAL PROCEDURE CalcReservationQuantity@62() : Decimal;
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      IF "Qty. per Unit of Measure" = 1 THEN
        EXIT("Quantity (Base)");

      ReservEntry.SETFILTER("Entry No.",'<>%1',"Entry No.");
      ReservEntry.SetSourceFilter("Source Type","Source Subtype","Source ID","Source Ref. No.",FALSE);
      ReservEntry.SetSourceFilter2("Source Batch Name","Source Prod. Order Line");
      ReservEntry.SETRANGE("Reservation Status","Reservation Status"::Reservation);
      ReservEntry.CALCSUMS("Quantity (Base)",Quantity);
      EXIT(
        ROUND((ReservEntry."Quantity (Base)" + "Quantity (Base)") / "Qty. per Unit of Measure",0.00001) -
        ReservEntry.Quantity);
    END;

    [External]
    PROCEDURE ClearApplFromToItemEntry@6();
    BEGIN
      IF Positive THEN
        "Appl.-to Item Entry" := 0
      ELSE
        "Appl.-from Item Entry" := 0;
    END;

    [External]
    PROCEDURE TestItemFields@10(ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 : Code[10]);
    BEGIN
      TESTFIELD("Item No.",ItemNo);
      TESTFIELD("Variant Code",VariantCode);
      TESTFIELD("Location Code",LocationCode);
    END;

    [External]
    PROCEDURE TrackingExists@11() : Boolean;
    BEGIN
      EXIT(("Serial No." <> '') OR ("Lot No." <> ''));
    END;

    [External]
    PROCEDURE TransferReservations@22(VAR OldReservEntry@1006 : Record 337;ItemNo@1000 : Code[20];VariantCode@1002 : Code[10];LocationCode@1003 : Code[10];TransferAll@1007 : Boolean;TransferQty@1015 : Decimal;QtyPerUOM@1008 : Decimal;SourceType@1009 : Integer;SourceSubtype@1010 : Option;SourceID@1011 : Code[20];SourceBatchName@1012 : Code[10];SourceProdOrderLine@1013 : Integer;SourceRefNo@1014 : Integer);
    VAR
      NewReservEntry@1004 : Record 337;
      CreateReservEntry@1005 : Codeunit 99000830;
      Status@1001 : 'Reservation,Tracking,Surplus,Prospect';
    BEGIN
      IF TransferAll THEN BEGIN
        OldReservEntry.FINDSET;
        OldReservEntry.TESTFIELD("Qty. per Unit of Measure",QtyPerUOM);
        REPEAT
          OldReservEntry.TestItemFields(ItemNo,VariantCode,LocationCode);

          NewReservEntry := OldReservEntry;
          NewReservEntry.SetSource(SourceType,SourceSubtype,SourceID,SourceRefNo,SourceBatchName,SourceProdOrderLine);

          NewReservEntry.UpdateActionMessageEntries(OldReservEntry);
        UNTIL OldReservEntry.NEXT = 0;
      END ELSE
        FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
          IF TransferQty = 0 THEN
            EXIT;
          OldReservEntry.SETRANGE("Reservation Status",Status);
          IF OldReservEntry.FINDSET THEN
            REPEAT
              OldReservEntry.TestItemFields(ItemNo,VariantCode,LocationCode);

              TransferQty :=
                CreateReservEntry.TransferReservEntry(
                  SourceType,SourceSubtype,SourceID,SourceBatchName,SourceProdOrderLine,SourceRefNo,
                  QtyPerUOM,OldReservEntry,TransferQty);
            UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
        END;
    END;

    BEGIN
    END.
  }
}

