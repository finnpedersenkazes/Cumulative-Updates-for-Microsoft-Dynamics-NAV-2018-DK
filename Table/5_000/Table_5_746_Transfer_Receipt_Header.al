OBJECT Table 5746 Transfer Receipt Header
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=No.;
    OnDelete=VAR
               InvtCommentLine@1000 : Record 5748;
               TransRcptLine@1001 : Record 5747;
               MoveEntries@1002 : Codeunit 361;
             BEGIN
               TransRcptLine.SETRANGE("Document No.","No.");
               IF TransRcptLine.FIND('-') THEN
                 REPEAT
                   TransRcptLine.DELETE;
                 UNTIL TransRcptLine.NEXT = 0;

               InvtCommentLine.SETRANGE("Document Type",InvtCommentLine."Document Type"::"Posted Transfer Receipt");
               InvtCommentLine.SETRANGE("No.","No.");
               InvtCommentLine.DELETEALL;

               ItemTrackingMgt.DeleteItemEntryRelation(
                 DATABASE::"Transfer Receipt Line",0,"No.",'',0,0,TRUE);

               MoveEntries.MoveDocRelatedEntries(DATABASE::"Transfer Receipt Header","No.");
             END;

    CaptionML=[DAN=Overflytningskvitteringshoved;
               ENU=Transfer Receipt Header];
    LookupPageID=Page5753;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Transfer-from Code  ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Overflyt fra-kode;
                                                              ENU=Transfer-from Code] }
    { 3   ;   ;Transfer-from Name  ;Text50        ;CaptionML=[DAN=Overflyt fra-navn;
                                                              ENU=Transfer-from Name] }
    { 4   ;   ;Transfer-from Name 2;Text50        ;CaptionML=[DAN=Overflyt fra-navn 2;
                                                              ENU=Transfer-from Name 2] }
    { 5   ;   ;Transfer-from Address;Text50       ;CaptionML=[DAN=Overflyt fra-adresse;
                                                              ENU=Transfer-from Address] }
    { 6   ;   ;Transfer-from Address 2;Text50     ;CaptionML=[DAN=Overflyt fra-adresse 2;
                                                              ENU=Transfer-from Address 2] }
    { 7   ;   ;Transfer-from Post Code;Code20     ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Overflyt fra-postnr.;
                                                              ENU=Transfer-from Post Code] }
    { 8   ;   ;Transfer-from City  ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Overflyt fra-by;
                                                              ENU=Transfer-from City] }
    { 9   ;   ;Transfer-from County;Text30        ;CaptionML=[DAN=Overflyt fra-amt;
                                                              ENU=Transfer-from County] }
    { 10  ;   ;Trsf.-from Country/Region Code;Code10;
                                                   TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode, der overflyttes fra;
                                                              ENU=Trsf.-from Country/Region Code] }
    { 11  ;   ;Transfer-to Code    ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Overflyt til-kode;
                                                              ENU=Transfer-to Code] }
    { 12  ;   ;Transfer-to Name    ;Text50        ;CaptionML=[DAN=Overflyt til-navn;
                                                              ENU=Transfer-to Name] }
    { 13  ;   ;Transfer-to Name 2  ;Text50        ;CaptionML=[DAN=Overflyt til-navn 2;
                                                              ENU=Transfer-to Name 2] }
    { 14  ;   ;Transfer-to Address ;Text50        ;CaptionML=[DAN=Overflyt til-adresse;
                                                              ENU=Transfer-to Address] }
    { 15  ;   ;Transfer-to Address 2;Text50       ;CaptionML=[DAN=Overflyt til-adresse 2;
                                                              ENU=Transfer-to Address 2] }
    { 16  ;   ;Transfer-to Post Code;Code20       ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Overflyt til-postnr.;
                                                              ENU=Transfer-to Post Code] }
    { 17  ;   ;Transfer-to City    ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Overflyt til-by;
                                                              ENU=Transfer-to City] }
    { 18  ;   ;Transfer-to County  ;Text30        ;CaptionML=[DAN=Overflyt til-amt;
                                                              ENU=Transfer-to County] }
    { 19  ;   ;Trsf.-to Country/Region Code;Code10;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode, der overflyttes til;
                                                              ENU=Trsf.-to Country/Region Code] }
    { 20  ;   ;Transfer Order Date ;Date          ;CaptionML=[DAN=Overflytningsordredato;
                                                              ENU=Transfer Order Date] }
    { 21  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 22  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Inventory Comment Line" WHERE (Document Type=CONST(Posted Transfer Receipt),
                                                                                                     No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 23  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 24  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 25  ;   ;Transfer Order No.  ;Code20        ;TableRelation="Transfer Header";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Overflytningsordrenr.;
                                                              ENU=Transfer Order No.] }
    { 26  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 27  ;   ;Shipment Date       ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 28  ;   ;Receipt Date        ;Date          ;CaptionML=[DAN=Modtagelsesdato;
                                                              ENU=Receipt Date] }
    { 29  ;   ;In-Transit Code     ;Code10        ;TableRelation=Location.Code WHERE (Use As In-Transit=CONST(Yes));
                                                   CaptionML=[DAN=Transitkode;
                                                              ENU=In-Transit Code] }
    { 30  ;   ;Transfer-from Contact;Text50       ;CaptionML=[DAN=Overflyt fra-reference;
                                                              ENU=Transfer-from Contact] }
    { 31  ;   ;Transfer-to Contact ;Text50        ;CaptionML=[DAN=Overflyt til-reference;
                                                              ENU=Transfer-to Contact] }
    { 32  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 33  ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Spedit�rkode;
                                                              ENU=Shipping Agent Code] }
    { 34  ;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   CaptionML=[DAN=Spedit�rservicekode;
                                                              ENU=Shipping Agent Service Code] }
    { 35  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   CaptionML=[DAN=Leveringskode;
                                                              ENU=Shipment Method Code] }
    { 47  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type] }
    { 48  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=[DAN=Transportm�de;
                                                              ENU=Transport Method] }
    { 59  ;   ;Entry/Exit Point    ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Indf�rsels-/udf�rselssted;
                                                              ENU=Entry/Exit Point] }
    { 63  ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=Omr�de;
                                                              ENU=Area] }
    { 64  ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 70  ;   ;Direct Transfer     ;Boolean       ;CaptionML=[DAN=Direkte overf�rsel;
                                                              ENU=Direct Transfer] }
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
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Transfer-from Code,Transfer-to Code,Posting Date,Transfer Order Date }
  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;
      ItemTrackingMgt@1001 : Codeunit 6500;

    [External]
    PROCEDURE Navigate@2();
    VAR
      NavigateForm@1000 : Page 344;
    BEGIN
      NavigateForm.SetDoc("Posting Date","No.");
      NavigateForm.RUN;
    END;

    [External]
    PROCEDURE PrintRecords@3(ShowRequestForm@1000 : Boolean);
    VAR
      ReportSelection@1001 : Record 77;
      TransRcptHeader@1002 : Record 5746;
    BEGIN
      WITH TransRcptHeader DO BEGIN
        COPY(Rec);
        ReportSelection.PrintWithGUIYesNo(ReportSelection.Usage::Inv3,TransRcptHeader,ShowRequestForm,0);
      END;
    END;

    [External]
    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
    END;

    [External]
    PROCEDURE CopyFromTransferHeader@4(TransHeader@1000 : Record 5740);
    BEGIN
      "Transfer-from Code" := TransHeader."Transfer-from Code";
      "Transfer-from Name" := TransHeader."Transfer-from Name";
      "Transfer-from Name 2" := TransHeader."Transfer-from Name 2";
      "Transfer-from Address" := TransHeader."Transfer-from Address";
      "Transfer-from Address 2" := TransHeader."Transfer-from Address 2";
      "Transfer-from Post Code" := TransHeader."Transfer-from Post Code";
      "Transfer-from City" := TransHeader."Transfer-from City";
      "Transfer-from County" := TransHeader."Transfer-from County";
      "Trsf.-from Country/Region Code" := TransHeader."Trsf.-from Country/Region Code";
      "Transfer-from Contact" := TransHeader."Transfer-from Contact";
      "Transfer-to Code" := TransHeader."Transfer-to Code";
      "Transfer-to Name" := TransHeader."Transfer-to Name";
      "Transfer-to Name 2" := TransHeader."Transfer-to Name 2";
      "Transfer-to Address" := TransHeader."Transfer-to Address";
      "Transfer-to Address 2" := TransHeader."Transfer-to Address 2";
      "Transfer-to Post Code" := TransHeader."Transfer-to Post Code";
      "Transfer-to City" := TransHeader."Transfer-to City";
      "Transfer-to County" := TransHeader."Transfer-to County";
      "Trsf.-to Country/Region Code" := TransHeader."Trsf.-to Country/Region Code";
      "Transfer-to Contact" := TransHeader."Transfer-to Contact";
      "Transfer Order Date" := TransHeader."Posting Date";
      "Posting Date" := TransHeader."Posting Date";
      "Shipment Date" := TransHeader."Shipment Date";
      "Receipt Date" := TransHeader."Receipt Date";
      "Shortcut Dimension 1 Code" := TransHeader."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := TransHeader."Shortcut Dimension 2 Code";
      "Dimension Set ID" := TransHeader."Dimension Set ID";
      "Transfer Order No." := TransHeader."No.";
      "External Document No." := TransHeader."External Document No.";
      "In-Transit Code" := TransHeader."In-Transit Code";
      "Shipping Agent Code" := TransHeader."Shipping Agent Code";
      "Shipping Agent Service Code" := TransHeader."Shipping Agent Service Code";
      "Shipment Method Code" := TransHeader."Shipment Method Code";
      "Transaction Type" := TransHeader."Transaction Type";
      "Transport Method" := TransHeader."Transport Method";
      "Entry/Exit Point" := TransHeader."Entry/Exit Point";
      Area := TransHeader.Area;
      "Transaction Specification" := TransHeader."Transaction Specification";
      "Direct Transfer" := TransHeader."Direct Transfer";

      OnAfterCopyFromTransferHeader(Rec,TransHeader);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyFromTransferHeader@5(VAR TransferReceiptHeader@1000 : Record 5746;TransferHeader@1001 : Record 5740);
    BEGIN
    END;

    BEGIN
    END.
  }
}

