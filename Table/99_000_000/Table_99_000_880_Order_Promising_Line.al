OBJECT Table 99000880 Order Promising Line
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linje for beregn. af lev.tid;
               ENU=Order Promising Line];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 10  ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 11  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code];
                                                   Editable=No }
    { 12  ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   Editable=No }
    { 13  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 14  ;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code];
                                                   Editable=No }
    { 15  ;   ;Qty. per Unit of Measure;Decimal   ;CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 16  ;   ;Unavailable Quantity;Decimal       ;CaptionML=[DAN=Ikketilg�ngeligt antal;
                                                              ENU=Unavailable Quantity];
                                                   DecimalPlaces=0:5 }
    { 17  ;   ;Quantity (Base)     ;Decimal       ;CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 18  ;   ;Unavailable Quantity (Base);Decimal;CaptionML=[DAN=Ikketilg�ng. antal (basis);
                                                              ENU=Unavailable Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 19  ;   ;Required Quantity (Base);Decimal   ;CaptionML=[DAN=P�kr�vet antal (basis);
                                                              ENU=Required Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 20  ;   ;Source Type         ;Option        ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Salg,Rekvisitionslinje,K�b,Varekladde,Styklistekladde,Varepost,Prod.ordrelinje,Prod.ordrekomponent,Planl�gningslinje,Planl�gningskomponent,Overf�rsel,Serviceordre,Job";
                                                                    ENU=" ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order,Job"];
                                                   OptionString=[ ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order,Job] }
    { 21  ;   ;Source Subtype      ;Integer       ;CaptionML=[DAN=Kildeundertype;
                                                              ENU=Source Subtype] }
    { 22  ;   ;Source ID           ;Code20        ;CaptionML=[DAN=Kilde-id;
                                                              ENU=Source ID] }
    { 23  ;   ;Source Batch Name   ;Code10        ;CaptionML=[DAN=Kildekladdenavn;
                                                              ENU=Source Batch Name] }
    { 25  ;   ;Source Line No.     ;Integer       ;CaptionML=[DAN=Kildelinjenr.;
                                                              ENU=Source Line No.] }
    { 30  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 31  ;   ;Required Quantity   ;Decimal       ;CaptionML=[DAN=P�kr�vet antal;
                                                              ENU=Required Quantity];
                                                   DecimalPlaces=0:5 }
    { 40  ;   ;Requested Delivery Date;Date       ;OnValidate=VAR
                                                                SalesLine@1000 : Record 37;
                                                                ServLine@1001 : Record 5902;
                                                                JobPlanningLine@1002 : Record 1003;
                                                              BEGIN
                                                                CASE "Source Type" OF
                                                                  "Source Type"::Sales:
                                                                    BEGIN
                                                                      SalesLine.GET("Source Subtype","Source ID","Source Line No.");
                                                                      "Requested Shipment Date" := CalcReqShipDate(SalesLine);
                                                                    END;
                                                                  "Source Type"::"Service Order":
                                                                    BEGIN
                                                                      ServLine.GET("Source Subtype","Source ID","Source Line No.");
                                                                      "Requested Shipment Date" := ServLine."Needed by Date";
                                                                    END;
                                                                  "Source Type"::Job:
                                                                    BEGIN
                                                                      JobPlanningLine.SETRANGE("Job No.","Source ID");
                                                                      JobPlanningLine.SETRANGE("Job Contract Entry No.","Source Line No.");
                                                                      JobPlanningLine.FINDFIRST;
                                                                      "Requested Shipment Date" := JobPlanningLine."Planning Date";
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=�nsket leveringsdato;
                                                              ENU=Requested Delivery Date] }
    { 41  ;   ;Planned Delivery Date;Date         ;OnValidate=VAR
                                                                SalesLine@1000 : Record 37;
                                                              BEGIN
                                                                IF "Planned Delivery Date" <> 0D THEN
                                                                  CASE "Source Type" OF
                                                                    "Source Type"::Sales:
                                                                      BEGIN
                                                                        SalesLine.GET("Source Subtype","Source ID","Source Line No.");
                                                                        SalesLine."Planned Delivery Date" := "Planned Delivery Date";
                                                                        SalesLine."Planned Shipment Date" := SalesLine.CalcPlannedDate;
                                                                        SalesLine."Shipment Date" := SalesLine.CalcShipmentDate;
                                                                        "Planned Delivery Date" := SalesLine."Planned Delivery Date";
                                                                        "Earliest Shipment Date" := SalesLine."Shipment Date";
                                                                        IF "Earliest Shipment Date" > "Planned Delivery Date" THEN
                                                                          "Planned Delivery Date" := "Earliest Shipment Date";
                                                                      END;
                                                                    "Source Type"::"Service Order","Source Type"::Job:
                                                                      "Earliest Shipment Date" := "Planned Delivery Date";
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Planlagt leveringsdato;
                                                              ENU=Planned Delivery Date] }
    { 42  ;   ;Original Shipment Date;Date        ;CaptionML=[DAN=Oprindelig afsendelsesdato;
                                                              ENU=Original Shipment Date] }
    { 43  ;   ;Earliest Shipment Date;Date        ;OnValidate=VAR
                                                                SalesLine@1000 : Record 37;
                                                              BEGIN
                                                                CASE "Source Type" OF
                                                                  "Source Type"::Sales:
                                                                    IF "Earliest Shipment Date" <> 0D THEN BEGIN
                                                                      SalesLine.GET("Source Subtype","Source ID","Source Line No.");
                                                                      SalesLine.VALIDATE("Shipment Date","Earliest Shipment Date");
                                                                      "Planned Delivery Date" := SalesLine."Planned Delivery Date";
                                                                    END;
                                                                  "Source Type"::"Service Order":
                                                                    IF "Earliest Shipment Date" <> 0D THEN
                                                                      "Planned Delivery Date" := "Earliest Shipment Date";
                                                                  "Source Type"::Job:
                                                                    IF "Earliest Shipment Date" <> 0D THEN
                                                                      "Planned Delivery Date" := "Earliest Shipment Date";
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Tidligste afsendelsesdato;
                                                              ENU=Earliest Shipment Date] }
    { 44  ;   ;Requested Shipment Date;Date       ;CaptionML=[DAN=�nsket afsendelsesdato;
                                                              ENU=Requested Shipment Date];
                                                   Editable=No }
    { 45  ;   ;Unavailability Date ;Date          ;CaptionML=[DAN=Dato for ikke-disponibel;
                                                              ENU=Unavailability Date] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Requested Shipment Date                  }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE TransferFromSalesLine@2(VAR SalesLine@1000 : Record 37);
    BEGIN
      "Source Type" := "Source Type"::Sales;
      "Source Subtype" := SalesLine."Document Type";
      "Source ID" := SalesLine."Document No.";
      "Source Line No." := SalesLine."Line No.";

      "Item No." := SalesLine."No.";
      "Variant Code" := SalesLine."Variant Code";
      "Location Code" := SalesLine."Location Code";
      VALIDATE("Requested Delivery Date",SalesLine."Requested Delivery Date");
      "Original Shipment Date" := SalesLine."Shipment Date";
      Description := SalesLine.Description;
      Quantity := SalesLine."Outstanding Quantity";
      "Unit of Measure Code" := SalesLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
      "Quantity (Base)" := SalesLine."Outstanding Qty. (Base)";
    END;

    [External]
    PROCEDURE TransferFromServLine@3(VAR ServLine@1000 : Record 5902);
    BEGIN
      "Source Type" := "Source Type"::"Service Order";
      "Source Subtype" := ServLine."Document Type";
      "Source ID" := ServLine."Document No.";
      "Source Line No." := ServLine."Line No.";

      "Item No." := ServLine."No.";
      "Variant Code" := ServLine."Variant Code";
      "Location Code" := ServLine."Location Code";
      VALIDATE("Requested Delivery Date",ServLine."Requested Delivery Date");
      "Original Shipment Date" := ServLine."Needed by Date";
      Description := ServLine.Description;
      Quantity := ServLine."Outstanding Quantity";
      "Unit of Measure Code" := ServLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := ServLine."Qty. per Unit of Measure";
      "Quantity (Base)" := ServLine."Outstanding Qty. (Base)";
    END;

    [External]
    PROCEDURE TransferFromJobPlanningLine@4(VAR JobPlanningLine@1000 : Record 1003);
    BEGIN
      "Source Type" := "Source Type"::Job;
      "Source Subtype" := JobPlanningLine.Status;
      "Source ID" := JobPlanningLine."Job No.";
      "Source Line No." := JobPlanningLine."Job Contract Entry No.";

      "Item No." := JobPlanningLine."No.";
      "Variant Code" := JobPlanningLine."Variant Code";
      "Location Code" := JobPlanningLine."Location Code";
      VALIDATE("Requested Delivery Date",JobPlanningLine."Requested Delivery Date");
      "Original Shipment Date" := JobPlanningLine."Planning Date";
      Description := JobPlanningLine.Description;
      Quantity := JobPlanningLine."Remaining Qty.";
      "Unit of Measure Code" := JobPlanningLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := JobPlanningLine."Qty. per Unit of Measure";
      "Quantity (Base)" := JobPlanningLine."Remaining Qty. (Base)";
    END;

    LOCAL PROCEDURE CalcReqShipDate@1(SalesLine@1000 : Record 37) : Date;
    BEGIN
      IF (SalesLine."Requested Delivery Date" <> 0D) AND
         (SalesLine."Promised Delivery Date" = 0D)
      THEN BEGIN
        SalesLine.SuspendStatusCheck(TRUE);
        SalesLine.VALIDATE("Requested Delivery Date",SalesLine."Requested Delivery Date");
      END;
      EXIT(SalesLine."Shipment Date");
    END;

    [External]
    PROCEDURE GetLastEntryNo@5() LastEntryNo : Integer;
    VAR
      CopyOfOrderPromisingLine@1000 : Record 99000880;
    BEGIN
      CopyOfOrderPromisingLine.COPY(Rec);
      RESET;
      IF FINDLAST THEN
        LastEntryNo := "Entry No.";
      COPY(CopyOfOrderPromisingLine);
    END;

    [External]
    PROCEDURE CalcAvailability@18() : Decimal;
    VAR
      Item@1004 : Record 27;
      AvailableToPromise@1001 : Codeunit 5790;
      GrossRequirement@1002 : Decimal;
      ScheduledReceipt@1003 : Decimal;
      PeriodType@1006 : 'Day,Week,Month,Quarter,Year';
      LookaheadDateformula@1005 : DateFormula;
      AvailabilityDate@1007 : Date;
    BEGIN
      IF Item.GET("Item No.") THEN BEGIN
        IF "Original Shipment Date" > 0D THEN
          AvailabilityDate := "Original Shipment Date"
        ELSE
          AvailabilityDate := WORKDATE;

        Item.RESET;
        Item.SETRANGE("Date Filter",0D,AvailabilityDate);
        Item.SETRANGE("Variant Filter","Variant Code");
        Item.SETRANGE("Location Filter","Location Code");
        Item.SETRANGE("Drop Shipment Filter",FALSE);
        EXIT(
          AvailableToPromise.QtyAvailabletoPromise(
            Item,
            GrossRequirement,
            ScheduledReceipt,
            AvailabilityDate,
            PeriodType,
            LookaheadDateformula));
      END;
    END;

    BEGIN
    END.
  }
}

