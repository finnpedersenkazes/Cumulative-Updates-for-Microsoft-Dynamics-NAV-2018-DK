OBJECT Table 5907 Service Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicepost;
               ENU=Service Ledger Entry];
    LookupPageID=Page5912;
    DrillDownPageID=Page5912;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Service Contract No.;Code20        ;TableRelation="Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract));
                                                   CaptionML=[DAN=Servicekontraktnr.;
                                                              ENU=Service Contract No.] }
    { 3   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion,Leverance";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Shipment"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,Shipment] }
    { 4   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 5   ;   ;Serv. Contract Acc. Gr. Code;Code10;TableRelation="Service Contract Account Group".Code;
                                                   CaptionML=[DAN=Servicekontraktkto.grp.kode;
                                                              ENU=Serv. Contract Acc. Gr. Code] }
    { 6   ;   ;Document Line No.   ;Integer       ;CaptionML=[DAN=Dokumentlinjenr.;
                                                              ENU=Document Line No.] }
    { 8   ;   ;Moved from Prepaid Acc.;Boolean    ;CaptionML=[DAN=Flyttet fra forudbet.konto;
                                                              ENU=Moved from Prepaid Acc.] }
    { 9   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 11  ;   ;Amount (LCY)        ;Decimal       ;CaptionML=[DAN=Belõb (RV);
                                                              ENU=Amount (LCY)];
                                                   AutoFormatType=1 }
    { 12  ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.] }
    { 13  ;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Customer No.));
                                                   CaptionML=[DAN=Leveringsadressekode;
                                                              ENU=Ship-to Code] }
    { 14  ;   ;Item No. (Serviced) ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Artikelnr. (repareret);
                                                              ENU=Item No. (Serviced)] }
    { 15  ;   ;Serial No. (Serviced);Code20       ;CaptionML=[DAN=Serienr. (repareret);
                                                              ENU=Serial No. (Serviced)] }
    { 16  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 17  ;   ;Contract Invoice Period;Text30     ;CaptionML=[DAN=Fakt.periode under kontrakt;
                                                              ENU=Contract Invoice Period] }
    { 18  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 19  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 20  ;   ;Service Item No. (Serviced);Code20 ;TableRelation="Service Item";
                                                   CaptionML=[DAN=Serviceartikelnr. (repareret);
                                                              ENU=Service Item No. (Serviced)] }
    { 21  ;   ;Variant Code (Serviced);Code10     ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD("Item No. (Serviced)"));
                                                   CaptionML=[DAN=Variantkode (repareret);
                                                              ENU=Variant Code (Serviced)] }
    { 22  ;   ;Contract Group Code ;Code10        ;TableRelation="Contract Group".Code;
                                                   CaptionML=[DAN=Kontraktgruppekode;
                                                              ENU=Contract Group Code] }
    { 23  ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Ressource,Vare,Serviceomkostning,Servicekontrakt,Finanskonto";
                                                                    ENU=" ,Resource,Item,Service Cost,Service Contract,G/L Account"];
                                                   OptionString=[ ,Resource,Item,Service Cost,Service Contract,G/L Account] }
    { 24  ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Service Contract)) "Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract))
                                                                 ELSE IF (Type=CONST(" ")) "Standard Text"
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(Resource)) Resource
                                                                 ELSE IF (Type=CONST(Service Cost)) "Service Cost"
                                                                 ELSE IF (Type=CONST(G/L Account)) "G/L Account";
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 25  ;   ;Cost Amount         ;Decimal       ;CaptionML=[DAN=Kostbelõb;
                                                              ENU=Cost Amount];
                                                   AutoFormatType=1 }
    { 26  ;   ;Discount Amount     ;Decimal       ;CaptionML=[DAN=Rabatbelõb;
                                                              ENU=Discount Amount];
                                                   AutoFormatType=1 }
    { 27  ;   ;Unit Cost           ;Decimal       ;CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2 }
    { 28  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 29  ;   ;Charged Qty.        ;Decimal       ;CaptionML=[DAN=Faktureret antal;
                                                              ENU=Charged Qty.];
                                                   DecimalPlaces=0:5 }
    { 30  ;   ;Unit Price          ;Decimal       ;CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   AutoFormatType=2 }
    { 31  ;   ;Discount %          ;Decimal       ;CaptionML=[DAN=Rabatpct.;
                                                              ENU=Discount %];
                                                   DecimalPlaces=0:5 }
    { 32  ;   ;Contract Disc. Amount;Decimal      ;CaptionML=[DAN=Rabatbelõb ifõlge kontrakt;
                                                              ENU=Contract Disc. Amount];
                                                   AutoFormatType=1 }
    { 33  ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.] }
    { 34  ;   ;Fault Reason Code   ;Code10        ;TableRelation="Fault Reason Code";
                                                   CaptionML=[DAN=FejlÜrsagskode;
                                                              ENU=Fault Reason Code] }
    { 35  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 37  ;   ;Service Order Type  ;Code10        ;TableRelation="Service Order Type";
                                                   CaptionML=[DAN=Serviceordretype;
                                                              ENU=Service Order Type] }
    { 39  ;   ;Service Order No.   ;Code20        ;OnLookup=BEGIN
                                                              CLEAR(ServOrderMgt);
                                                              ServOrderMgt.ServHeaderLookup(1,"Service Order No.");
                                                            END;

                                                   CaptionML=[DAN=Serviceordrenr.;
                                                              ENU=Service Order No.] }
    { 40  ;   ;Job No.             ;Code20        ;TableRelation=Job.No. WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.));
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 41  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 42  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogfõringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 43  ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 44  ;   ;Unit of Measure Code;Code10        ;TableRelation="Unit of Measure";
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 45  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 46  ;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 47  ;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 48  ;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 50  ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Brug,Salg,Forbrug,Kontrakt;
                                                                    ENU=Usage,Sale,Consume,Contract];
                                                   OptionString=Usage,Sale,Consume,Contract }
    { 51  ;   ;Open                ;Boolean       ;CaptionML=[DAN=èben;
                                                              ENU=Open] }
    { 52  ;   ;Serv. Price Adjmt. Gr. Code;Code10 ;TableRelation="Service Price Adjustment Group";
                                                   CaptionML=[DAN=Serviceprisreg.gruppekode;
                                                              ENU=Serv. Price Adjmt. Gr. Code] }
    { 53  ;   ;Service Price Group Code;Code10    ;TableRelation="Service Price Group";
                                                   CaptionML=[DAN=Serviceprisgruppekode;
                                                              ENU=Service Price Group Code] }
    { 54  ;   ;Prepaid             ;Boolean       ;CaptionML=[DAN=Forudbetalt;
                                                              ENU=Prepaid] }
    { 55  ;   ;Apply Until Entry No.;Integer      ;CaptionML=[DAN=Udlign indtil lõbenr.;
                                                              ENU=Apply Until Entry No.] }
    { 56  ;   ;Applies-to Entry No.;Integer       ;AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udlign.lõbenr.;
                                                              ENU=Applies-to Entry No.] }
    { 57  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 58  ;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 59  ;   ;Job Line Type       ;Option        ;InitValue=Budget;
                                                   CaptionML=[DAN=Linjetype for sag;
                                                              ENU=Job Line Type];
                                                   OptionCaptionML=[DAN=" ,Budget,Fakturerbar,BÜde budget og fakturerbar";
                                                                    ENU=" ,Budget,Billable,Both Budget and Billable"];
                                                   OptionString=[ ,Budget,Billable,Both Budget and Billable] }
    { 60  ;   ;Job Posted          ;Boolean       ;CaptionML=[DAN=Sagen er bogfõrt;
                                                              ENU=Job Posted] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Document No.,Posting Date                }
    {    ;Entry Type,Document Type,Document No.,Document Line No. }
    {    ;Service Contract No.,Entry No.,Entry Type,Type,Moved from Prepaid Acc.,Posting Date,Open,Prepaid,Service Item No. (Serviced),Customer No.,Contract Group Code,Responsibility Center;
                                                   SumIndexFields=Amount (LCY),Cost Amount,Quantity,Charged Qty.,Contract Disc. Amount }
    {    ;Service Order No.,Service Item No. (Serviced),Entry Type,Moved from Prepaid Acc.,Posting Date,Open,Type,Service Contract No.;
                                                   SumIndexFields=Amount (LCY),Cost Amount,Quantity,Charged Qty.,Amount }
    {    ;Type,No.,Entry Type,Moved from Prepaid Acc.,Posting Date,Open,Prepaid;
                                                   SumIndexFields=Amount (LCY),Cost Amount,Quantity,Charged Qty. }
    {    ;Service Item No. (Serviced),Entry Type,Moved from Prepaid Acc.,Type,Posting Date,Open,Service Contract No.,Prepaid,Customer No.,Contract Group Code,Responsibility Center;
                                                   SumIndexFields=Amount (LCY),Cost Amount }
    {    ;Service Item No. (Serviced),Entry Type,Type,Service Contract No.,Posting Date,Service Order No.;
                                                   SumIndexFields=Amount (LCY),Cost Amount,Quantity,Charged Qty. }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Entry Type,Service Contract No.,Posting Date }
  }
  CODE
  {
    VAR
      ServOrderMgt@1001 : Codeunit 5900;
      DimMgt@1000 : Codeunit 408;

    [External]
    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    [External]
    PROCEDURE CopyFromServHeader@4(ServHeader@1000 : Record 5900);
    BEGIN
      "Service Order Type" := ServHeader."Service Order Type";
      "Customer No." := ServHeader."Customer No.";
      "Bill-to Customer No." := ServHeader."Bill-to Customer No.";
      "Service Order Type" := ServHeader."Service Order Type";
      "Responsibility Center" := ServHeader."Responsibility Center";
    END;

    [External]
    PROCEDURE CopyFromServLine@2(ServLine@1000 : Record 5902;DocNo@1002 : Code[20]);
    BEGIN
      CASE ServLine.Type OF
        ServLine.Type::Item:
          BEGIN
            Type := Type::Item;
            "Bin Code" := ServLine."Bin Code";
          END;
        ServLine.Type::Resource:
          Type := Type::Resource;
        ServLine.Type::Cost:
          Type := Type::"Service Cost";
        ServLine.Type::"G/L Account":
          Type := Type::"G/L Account";
      END;

      IF ServLine."Document Type" = ServLine."Document Type"::Order THEN
        "Service Order No." := ServLine."Document No.";

      "Location Code" := ServLine."Location Code";
      "Job No." := ServLine."Job No.";
      "Job Task No." := ServLine."Job Task No.";
      "Job Line Type" := ServLine."Job Line Type";

      "Document Type" := "Document Type"::Shipment;
      "Document No." := DocNo;
      "Document Line No." := ServLine."Line No.";
      "Moved from Prepaid Acc." := TRUE;
      "Posting Date" := ServLine."Posting Date";
      "Entry Type" := "Entry Type"::Usage;
      "Ship-to Code" := ServLine."Ship-to Code";
      "Global Dimension 1 Code" := ServLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := ServLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServLine."Dimension Set ID";
      "Gen. Bus. Posting Group" := ServLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServLine."Gen. Prod. Posting Group";
      Description := ServLine.Description;
      "Fault Reason Code" := ServLine."Fault Reason Code";
      "Unit of Measure Code" := ServLine."Unit of Measure Code";
      "Work Type Code" := ServLine."Work Type Code";
      "Serv. Price Adjmt. Gr. Code" := ServLine."Serv. Price Adjmt. Gr. Code";
      "Service Price Group Code" := ServLine."Service Price Group Code";
      "Discount %" := ServLine."Line Discount %";
      "Variant Code" := ServLine."Variant Code";
    END;

    [External]
    PROCEDURE CopyServicedInfo@3(ServiceItemNo@1000 : Code[20];ItemNo@1001 : Code[20];SerialNo@1002 : Code[20];VariantCode@1003 : Code[10]);
    BEGIN
      "Service Item No. (Serviced)" := ServiceItemNo;
      "Item No. (Serviced)" := ItemNo;
      "Serial No. (Serviced)" := SerialNo;
      "Variant Code (Serviced)" := VariantCode;
    END;

    BEGIN
    END.
  }
}

