OBJECT Table 203 Res. Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressourcepost;
               ENU=Res. Ledger Entry];
    LookupPageID=Page202;
    DrillDownPageID=Page202;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Forbrug,Salg;
                                                                    ENU=Usage,Sale];
                                                   OptionString=Usage,Sale }
    { 3   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 4   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 5   ;   ;Resource No.        ;Code20        ;TableRelation=Resource;
                                                   CaptionML=[DAN=Ressourcenr.;
                                                              ENU=Resource No.] }
    { 6   ;   ;Resource Group No.  ;Code20        ;TableRelation="Resource Group";
                                                   CaptionML=[DAN=Ressourcegruppenr.;
                                                              ENU=Resource Group No.] }
    { 7   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 8   ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 9   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 10  ;   ;Unit of Measure Code;Code10        ;TableRelation="Unit of Measure";
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 11  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 12  ;   ;Direct Unit Cost    ;Decimal       ;CaptionML=[DAN=K�bspris;
                                                              ENU=Direct Unit Cost];
                                                   AutoFormatType=2 }
    { 13  ;   ;Unit Cost           ;Decimal       ;CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2 }
    { 14  ;   ;Total Cost          ;Decimal       ;CaptionML=[DAN=Kostbel�b;
                                                              ENU=Total Cost];
                                                   AutoFormatType=1 }
    { 15  ;   ;Unit Price          ;Decimal       ;CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   AutoFormatType=2 }
    { 16  ;   ;Total Price         ;Decimal       ;CaptionML=[DAN=Salgsbel�b;
                                                              ENU=Total Price];
                                                   AutoFormatType=1 }
    { 17  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 18  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 20  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 21  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 22  ;   ;Chargeable          ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Fakturerbar;
                                                              ENU=Chargeable] }
    { 23  ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 24  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 25  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 26  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 27  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 28  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 29  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 30  ;   ;Source Type         ;Option        ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Debitor";
                                                                    ENU=" ,Customer"];
                                                   OptionString=[ ,Customer] }
    { 31  ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) Customer.No.;
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 32  ;   ;Qty. per Unit of Measure;Decimal   ;CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure] }
    { 33  ;   ;Quantity (Base)     ;Decimal       ;CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)] }
    { 90  ;   ;Order Type          ;Option        ;CaptionML=[DAN=Ordretype;
                                                              ENU=Order Type];
                                                   OptionCaptionML=[DAN=" ,Produktion,Overf�rsel,Service,Montage";
                                                                    ENU=" ,Production,Transfer,Service,Assembly"];
                                                   OptionString=[ ,Production,Transfer,Service,Assembly] }
    { 91  ;   ;Order No.           ;Code20        ;CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.] }
    { 92  ;   ;Order Line No.      ;Integer       ;CaptionML=[DAN=Ordrelinjenr.;
                                                              ENU=Order Line No.] }
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
    {    ;Resource No.,Posting Date                }
    {    ;Entry Type,Chargeable,Unit of Measure Code,Resource No.,Posting Date;
                                                   SumIndexFields=Quantity,Total Cost,Total Price,Quantity (Base) }
    {    ;Entry Type,Chargeable,Unit of Measure Code,Resource Group No.,Posting Date;
                                                   SumIndexFields=Quantity,Total Cost,Total Price,Quantity (Base) }
    {    ;Document No.,Posting Date                }
    {    ;Order Type,Order No.,Order Line No.,Entry Type;
                                                   SumIndexFields=Quantity }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,Entry Type,Document No.,Posting Date }
  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;

    [External]
    PROCEDURE CopyFromResJnlLine@2(ResJnlLine@1000 : Record 207);
    BEGIN
      "Entry Type" := ResJnlLine."Entry Type";
      "Document No." := ResJnlLine."Document No.";
      "External Document No." := ResJnlLine."External Document No.";
      "Order Type" := ResJnlLine."Order Type";
      "Order No." := ResJnlLine."Order No.";
      "Order Line No." := ResJnlLine."Order Line No.";
      "Posting Date" := ResJnlLine."Posting Date";
      "Document Date" := ResJnlLine."Document Date";
      "Resource No." := ResJnlLine."Resource No.";
      "Resource Group No." := ResJnlLine."Resource Group No.";
      Description := ResJnlLine.Description;
      "Work Type Code" := ResJnlLine."Work Type Code";
      "Job No." := ResJnlLine."Job No.";
      "Unit of Measure Code" := ResJnlLine."Unit of Measure Code";
      Quantity := ResJnlLine.Quantity;
      "Direct Unit Cost" := ResJnlLine."Direct Unit Cost";
      "Unit Cost" := ResJnlLine."Unit Cost";
      "Total Cost" := ResJnlLine."Total Cost";
      "Unit Price" := ResJnlLine."Unit Price";
      "Total Price" := ResJnlLine."Total Price";
      "Global Dimension 1 Code" := ResJnlLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := ResJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ResJnlLine."Dimension Set ID";
      "Source Code" := ResJnlLine."Source Code";
      "Journal Batch Name" := ResJnlLine."Journal Batch Name";
      "Reason Code" := ResJnlLine."Reason Code";
      "Gen. Bus. Posting Group" := ResJnlLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ResJnlLine."Gen. Prod. Posting Group";
      "No. Series" := ResJnlLine."Posting No. Series";
      "Source Type" := ResJnlLine."Source Type";
      "Source No." := ResJnlLine."Source No.";
      "Qty. per Unit of Measure" := ResJnlLine."Qty. per Unit of Measure";

      OnAfterCopyFromResJnlLine(Rec,ResJnlLine);
    END;

    [External]
    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    [Integration]
    [External]
    PROCEDURE OnAfterCopyFromResJnlLine@3(VAR ResLedgerEntry@1000 : Record 203;ResJournalLine@1001 : Record 207);
    BEGIN
    END;

    BEGIN
    END.
  }
}

