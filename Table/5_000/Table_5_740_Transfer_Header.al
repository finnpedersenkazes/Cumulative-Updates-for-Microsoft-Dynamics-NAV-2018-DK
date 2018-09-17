OBJECT Table 5740 Transfer Header
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               GetInventorySetup;
               IF "No." = '' THEN BEGIN
                 TestNoSeries;
                 NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
               END;
               InitRecord;
               VALIDATE("Shipment Date",WORKDATE);
             END;

    OnDelete=VAR
               TransLine@1000 : Record 5741;
               InvtCommentLine@1001 : Record 5748;
               ReservMgt@1002 : Codeunit 99000845;
             BEGIN
               TESTFIELD(Status,Status::Open);

               WhseRequest.SETRANGE("Source Type",DATABASE::"Transfer Line");
               WhseRequest.SETRANGE("Source No.","No.");
               IF NOT WhseRequest.ISEMPTY THEN
                 WhseRequest.DELETEALL(TRUE);

               ReservMgt.DeleteDocumentReservation(DATABASE::"Transfer Line",0,"No.",HideValidationDialog);

               TransLine.SETRANGE("Document No.","No.");
               TransLine.DELETEALL(TRUE);

               InvtCommentLine.SETRANGE("Document Type",InvtCommentLine."Document Type"::"Transfer Order");
               InvtCommentLine.SETRANGE("No.","No.");
               InvtCommentLine.DELETEALL;
             END;

    OnRename=BEGIN
               ERROR(Text000,TABLECAPTION);
             END;

    CaptionML=[DAN=Overflytningshoved;
               ENU=Transfer Header];
    LookupPageID=Page5742;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  GetInventorySetup;
                                                                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Transfer-from Code  ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=VAR
                                                                Location@1000 : Record 14;
                                                                Confirmed@1001 : Boolean;
                                                              BEGIN
                                                                TestStatusOpen;

                                                                IF ("Transfer-from Code" = "Transfer-to Code") AND
                                                                   ("Transfer-from Code" <> '')
                                                                THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("Transfer-from Code"),FIELDCAPTION("Transfer-to Code"),
                                                                    TABLECAPTION,"No.");

                                                                IF "Direct Transfer" THEN
                                                                  VerifyNoOutboundWhseHandlingOnLocation("Transfer-from Code");

                                                                IF xRec."Transfer-from Code" <> "Transfer-from Code" THEN BEGIN
                                                                  IF HideValidationDialog OR
                                                                     (xRec."Transfer-from Code" = '')
                                                                  THEN
                                                                    Confirmed := TRUE
                                                                  ELSE BEGIN
                                                                    IF xRec.HasTransferLines THEN
                                                                      Confirmed := CONFIRM(UpdateTransferFromCodeQst,FALSE)
                                                                    ELSE
                                                                      Confirmed := CONFIRM(Text002,FALSE,FIELDCAPTION("Transfer-from Code"));
                                                                  END;
                                                                  IF Confirmed THEN BEGIN
                                                                    IF Location.GET("Transfer-from Code") THEN BEGIN
                                                                      "Transfer-from Name" := Location.Name;
                                                                      "Transfer-from Name 2" := Location."Name 2";
                                                                      "Transfer-from Address" := Location.Address;
                                                                      "Transfer-from Address 2" := Location."Address 2";
                                                                      "Transfer-from Post Code" := Location."Post Code";
                                                                      "Transfer-from City" := Location.City;
                                                                      "Transfer-from County" := Location.County;
                                                                      "Trsf.-from Country/Region Code" := Location."Country/Region Code";
                                                                      "Transfer-from Contact" := Location.Contact;
                                                                      IF NOT "Direct Transfer" THEN BEGIN
                                                                        "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                                                                        TransferRoute.GetTransferRoute(
                                                                          "Transfer-from Code","Transfer-to Code","In-Transit Code",
                                                                          "Shipping Agent Code","Shipping Agent Service Code");
                                                                        TransferRoute.GetShippingTime(
                                                                          "Transfer-from Code","Transfer-to Code",
                                                                          "Shipping Agent Code","Shipping Agent Service Code",
                                                                          "Shipping Time");
                                                                        TransferRoute.CalcReceiptDate(
                                                                          "Shipment Date",
                                                                          "Receipt Date",
                                                                          "Shipping Time",
                                                                          "Outbound Whse. Handling Time",
                                                                          "Inbound Whse. Handling Time",
                                                                          "Transfer-from Code",
                                                                          "Transfer-to Code",
                                                                          "Shipping Agent Code",
                                                                          "Shipping Agent Service Code");
                                                                      END;
                                                                    END;
                                                                    TransLine.LOCKTABLE;
                                                                    TransLine.SETRANGE("Document No.","No.");
                                                                    IF TransLine.FINDSET THEN
                                                                      TransLine.DELETEALL(TRUE);
                                                                  END ELSE
                                                                    "Transfer-from Code" := xRec."Transfer-from Code";
                                                                END;
                                                              END;

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
    { 7   ;   ;Transfer-from Post Code;Code20     ;TableRelation=IF (Trsf.-from Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Trsf.-from Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Trsf.-from Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(
                                                                  "Transfer-from City","Transfer-from Post Code",
                                                                  "Transfer-from County","Trsf.-from Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Overflyt fra-postnr.;
                                                              ENU=Transfer-from Post Code] }
    { 8   ;   ;Transfer-from City  ;Text30        ;TableRelation=IF (Trsf.-from Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Trsf.-from Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Trsf.-from Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(
                                                                  "Transfer-from City","Transfer-from Post Code",
                                                                  "Transfer-from County","Trsf.-from Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

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
                                                   OnValidate=VAR
                                                                Location@1000 : Record 14;
                                                                Confirmed@1001 : Boolean;
                                                              BEGIN
                                                                TestStatusOpen;

                                                                IF ("Transfer-from Code" = "Transfer-to Code") AND
                                                                   ("Transfer-to Code" <> '')
                                                                THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("Transfer-from Code"),FIELDCAPTION("Transfer-to Code"),
                                                                    TABLECAPTION,"No.");

                                                                IF "Direct Transfer" THEN
                                                                  VerifyNoInboundWhseHandlingOnLocation("Transfer-to Code");

                                                                IF xRec."Transfer-to Code" <> "Transfer-to Code" THEN BEGIN
                                                                  IF HideValidationDialog OR (xRec."Transfer-to Code" = '') THEN
                                                                    Confirmed := TRUE
                                                                  ELSE
                                                                    Confirmed := CONFIRM(Text002,FALSE,FIELDCAPTION("Transfer-to Code"));
                                                                  IF Confirmed THEN BEGIN
                                                                    IF Location.GET("Transfer-to Code") THEN BEGIN
                                                                      "Transfer-to Name" := Location.Name;
                                                                      "Transfer-to Name 2" := Location."Name 2";
                                                                      "Transfer-to Address" := Location.Address;
                                                                      "Transfer-to Address 2" := Location."Address 2";
                                                                      "Transfer-to Post Code" := Location."Post Code";
                                                                      "Transfer-to City" := Location.City;
                                                                      "Transfer-to County" := Location.County;
                                                                      "Trsf.-to Country/Region Code" := Location."Country/Region Code";
                                                                      "Transfer-to Contact" := Location.Contact;
                                                                      IF NOT "Direct Transfer" THEN BEGIN
                                                                        "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                                                                        TransferRoute.GetTransferRoute(
                                                                          "Transfer-from Code","Transfer-to Code","In-Transit Code",
                                                                          "Shipping Agent Code","Shipping Agent Service Code");
                                                                        TransferRoute.GetShippingTime(
                                                                          "Transfer-from Code","Transfer-to Code",
                                                                          "Shipping Agent Code","Shipping Agent Service Code",
                                                                          "Shipping Time");
                                                                        TransferRoute.CalcReceiptDate(
                                                                          "Shipment Date",
                                                                          "Receipt Date",
                                                                          "Shipping Time",
                                                                          "Outbound Whse. Handling Time",
                                                                          "Inbound Whse. Handling Time",
                                                                          "Transfer-from Code",
                                                                          "Transfer-to Code",
                                                                          "Shipping Agent Code",
                                                                          "Shipping Agent Service Code");
                                                                      END;
                                                                      TransLine.LOCKTABLE;
                                                                      TransLine.SETRANGE("Document No.","No.");
                                                                      IF TransLine.FINDSET THEN;
                                                                    END;
                                                                    UpdateTransLines(Rec,FIELDNO("Transfer-to Code"));
                                                                  END ELSE BEGIN
                                                                    "Transfer-to Code" := xRec."Transfer-to Code";
                                                                    EXIT;
                                                                  END;
                                                                END;
                                                              END;

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
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(
                                                                  "Transfer-to City","Transfer-to Post Code","Transfer-to County",
                                                                  "Trsf.-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Overflyt til-postnr.;
                                                              ENU=Transfer-to Post Code] }
    { 17  ;   ;Transfer-to City    ;Text30        ;TableRelation=IF (Trsf.-to Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Trsf.-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Trsf.-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(
                                                                  "Transfer-to City","Transfer-to Post Code","Transfer-to County",
                                                                  "Trsf.-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Overflyt til-by;
                                                              ENU=Transfer-to City] }
    { 18  ;   ;Transfer-to County  ;Text30        ;CaptionML=[DAN=Overflyt til-amt;
                                                              ENU=Transfer-to County] }
    { 19  ;   ;Trsf.-to Country/Region Code;Code10;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode, der overflyttes til;
                                                              ENU=Trsf.-to Country/Region Code] }
    { 20  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 21  ;   ;Shipment Date       ;Date          ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                TransferRoute.CalcReceiptDate(
                                                                  "Shipment Date",
                                                                  "Receipt Date",
                                                                  "Shipping Time",
                                                                  "Outbound Whse. Handling Time",
                                                                  "Inbound Whse. Handling Time",
                                                                  "Transfer-from Code",
                                                                  "Transfer-to Code",
                                                                  "Shipping Agent Code",
                                                                  "Shipping Agent Service Code");
                                                                UpdateTransLines(Rec,FIELDNO("Shipment Date"));
                                                              END;

                                                   CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 22  ;   ;Receipt Date        ;Date          ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                TransferRoute.CalcShipmentDate(
                                                                  "Shipment Date",
                                                                  "Receipt Date",
                                                                  "Shipping Time",
                                                                  "Outbound Whse. Handling Time",
                                                                  "Inbound Whse. Handling Time",
                                                                  "Transfer-from Code",
                                                                  "Transfer-to Code",
                                                                  "Shipping Agent Code",
                                                                  "Shipping Agent Service Code");
                                                                UpdateTransLines(Rec,FIELDNO("Receipt Date"));
                                                              END;

                                                   CaptionML=[DAN=Modtagelsesdato;
                                                              ENU=Receipt Date] }
    { 23  ;   ;Status              ;Option        ;OnValidate=BEGIN
                                                                UpdateTransLines(Rec,FIELDNO(Status));
                                                              END;

                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=�ben,Frigivet;
                                                                    ENU=Open,Released];
                                                   OptionString=Open,Released;
                                                   Editable=No }
    { 24  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Inventory Comment Line" WHERE (Document Type=CONST(Transfer Order),
                                                                                                     No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 25  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 26  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 27  ;   ;In-Transit Code     ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(Yes));
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                UpdateTransLines(Rec,FIELDNO("In-Transit Code"));
                                                              END;

                                                   CaptionML=[DAN=Transitkode;
                                                              ENU=In-Transit Code] }
    { 28  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 29  ;   ;Last Shipment No.   ;Code20        ;TableRelation="Transfer Shipment Header";
                                                   CaptionML=[DAN=Sidste leverancenr.;
                                                              ENU=Last Shipment No.];
                                                   Editable=No }
    { 30  ;   ;Last Receipt No.    ;Code20        ;TableRelation="Transfer Receipt Header";
                                                   CaptionML=[DAN=Sidste modtagelsesnr.;
                                                              ENU=Last Receipt No.];
                                                   Editable=No }
    { 31  ;   ;Transfer-from Contact;Text50       ;CaptionML=[DAN=Overflyt fra-reference;
                                                              ENU=Transfer-from Contact] }
    { 32  ;   ;Transfer-to Contact ;Text50        ;CaptionML=[DAN=Overflyt til-reference;
                                                              ENU=Transfer-to Contact] }
    { 33  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 34  ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                IF "Shipping Agent Code" <> xRec."Shipping Agent Code" THEN
                                                                  VALIDATE("Shipping Agent Service Code",'');
                                                                UpdateTransLines(Rec,FIELDNO("Shipping Agent Code"));
                                                              END;

                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Spedit�rkode;
                                                              ENU=Shipping Agent Code] }
    { 35  ;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                TransferRoute.GetShippingTime(
                                                                  "Transfer-from Code","Transfer-to Code",
                                                                  "Shipping Agent Code","Shipping Agent Service Code",
                                                                  "Shipping Time");
                                                                TransferRoute.CalcReceiptDate(
                                                                  "Shipment Date",
                                                                  "Receipt Date",
                                                                  "Shipping Time",
                                                                  "Outbound Whse. Handling Time",
                                                                  "Inbound Whse. Handling Time",
                                                                  "Transfer-from Code",
                                                                  "Transfer-to Code",
                                                                  "Shipping Agent Code",
                                                                  "Shipping Agent Service Code");

                                                                UpdateTransLines(Rec,FIELDNO("Shipping Agent Service Code"));
                                                              END;

                                                   CaptionML=[DAN=Spedit�rservicekode;
                                                              ENU=Shipping Agent Service Code] }
    { 36  ;   ;Shipping Time       ;DateFormula   ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                TransferRoute.CalcReceiptDate(
                                                                  "Shipment Date",
                                                                  "Receipt Date",
                                                                  "Shipping Time",
                                                                  "Outbound Whse. Handling Time",
                                                                  "Inbound Whse. Handling Time",
                                                                  "Transfer-from Code",
                                                                  "Transfer-to Code",
                                                                  "Shipping Agent Code",
                                                                  "Shipping Agent Service Code");

                                                                UpdateTransLines(Rec,FIELDNO("Shipping Time"));
                                                              END;

                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Transporttid;
                                                              ENU=Shipping Time] }
    { 37  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
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
    { 70  ;   ;Direct Transfer     ;Boolean       ;OnValidate=BEGIN
                                                                IF "Direct Transfer" THEN BEGIN
                                                                  VerifyNoOutboundWhseHandlingOnLocation("Transfer-from Code");
                                                                  VerifyNoInboundWhseHandlingOnLocation("Transfer-to Code");
                                                                  VALIDATE("In-Transit Code",'');
                                                                END;

                                                                IF NOT "Direct Transfer" AND HasTransferLines THEN
                                                                  VALIDATE("Direct Transfer",TRUE);

                                                                MODIFY(TRUE);
                                                                UpdateTransLines(Rec,FIELDNO("Direct Transfer"));
                                                              END;

                                                   CaptionML=[DAN=Direkte overf�rsel;
                                                              ENU=Direct Transfer] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=BEGIN
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDocDim;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 5750;   ;Shipping Advice     ;Option        ;OnValidate=BEGIN
                                                                IF "Shipping Advice" <> xRec."Shipping Advice" THEN BEGIN
                                                                  TestStatusOpen;
                                                                  WhseSourceHeader.TransHeaderVerifyChange(Rec,xRec);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Afsendelsesadvis;
                                                              ENU=Shipping Advice];
                                                   OptionCaptionML=[DAN=Delvis,Komplet;
                                                                    ENU=Partial,Complete];
                                                   OptionString=Partial,Complete }
    { 5751;   ;Posting from Whse. Ref.;Integer    ;CaptionML=[DAN=Bogf�ring fra lagerref.;
                                                              ENU=Posting from Whse. Ref.] }
    { 5752;   ;Completely Shipped  ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Min("Transfer Line"."Completely Shipped" WHERE (Document No.=FIELD(No.),
                                                                                                               Shipment Date=FIELD(Date Filter),
                                                                                                               Transfer-from Code=FIELD(Location Filter),
                                                                                                               Derived From Line No.=CONST(0)));
                                                   CaptionML=[DAN=Levering komplet;
                                                              ENU=Completely Shipped];
                                                   Editable=No }
    { 5753;   ;Completely Received ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Min("Transfer Line"."Completely Received" WHERE (Document No.=FIELD(No.),
                                                                                                                Receipt Date=FIELD(Date Filter),
                                                                                                                Transfer-to Code=FIELD(Location Filter),
                                                                                                                Derived From Line No.=CONST(0)));
                                                   CaptionML=[DAN=Modtagelse komplet;
                                                              ENU=Completely Received];
                                                   Editable=No }
    { 5754;   ;Location Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Location;
                                                   CaptionML=[DAN=Lokationsfilter;
                                                              ENU=Location Filter] }
    { 5793;   ;Outbound Whse. Handling Time;DateFormula;
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                TransferRoute.CalcReceiptDate(
                                                                  "Shipment Date",
                                                                  "Receipt Date",
                                                                  "Shipping Time",
                                                                  "Outbound Whse. Handling Time",
                                                                  "Inbound Whse. Handling Time",
                                                                  "Transfer-from Code",
                                                                  "Transfer-to Code",
                                                                  "Shipping Agent Code",
                                                                  "Shipping Agent Service Code");

                                                                UpdateTransLines(Rec,FIELDNO("Outbound Whse. Handling Time"));
                                                              END;

                                                   CaptionML=[DAN=Udg�ende lagerekspeditionstid;
                                                              ENU=Outbound Whse. Handling Time] }
    { 5794;   ;Inbound Whse. Handling Time;DateFormula;
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                TransferRoute.CalcReceiptDate(
                                                                  "Shipment Date",
                                                                  "Receipt Date",
                                                                  "Shipping Time",
                                                                  "Outbound Whse. Handling Time",
                                                                  "Inbound Whse. Handling Time",
                                                                  "Transfer-from Code",
                                                                  "Transfer-to Code",
                                                                  "Shipping Agent Code",
                                                                  "Shipping Agent Service Code");

                                                                UpdateTransLines(Rec,FIELDNO("Inbound Whse. Handling Time"));
                                                              END;

                                                   CaptionML=[DAN=Indg�ende lagerekspeditionstid;
                                                              ENU=Inbound Whse. Handling Time] }
    { 5796;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 8000;   ;Has Shipped Lines   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Transfer Line" WHERE (Document No.=FIELD(No.),
                                                                                            Quantity Shipped=FILTER(>0)));
                                                   CaptionML=[DAN=Har sprunget over linjer;
                                                              ENU=Has Shipped Lines] }
    { 9000;   ;Assigned User ID    ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Transfer-from Code,Transfer-to Code,Shipment Date,Status }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text001@1001 : TextConst 'DAN=%1 og %2 kan ikke v�re det samme i %3 %4.;ENU=%1 and %2 cannot be the same in %3 %4.';
      Text002@1002 : TextConst 'DAN=Skal %1 �ndres?;ENU=Do you want to change %1?';
      TransferOrderPostedMsg1@1003 : TextConst '@@@="%1 = transfer order number e.g. Transfer order 1003 was successfully posted and is now deleted ";DAN=Overf�rselsordren %1 blev bogf�rt korrekt og er nu slettet.;ENU=Transfer order %1 was successfully posted and is now deleted.';
      TransferRoute@1004 : Record 5742;
      TransHeader@1005 : Record 5740;
      TransLine@1016 : Record 5741;
      PostCode@1006 : Record 225;
      InvtSetup@1007 : Record 313;
      WhseRequest@1008 : Record 5765;
      DimMgt@1009 : Codeunit 408;
      NoSeriesMgt@1010 : Codeunit 396;
      WhseSourceHeader@1011 : Codeunit 5781;
      HideValidationDialog@1013 : Boolean;
      HasInventorySetup@1012 : Boolean;
      CalledFromWhse@1015 : Boolean;
      UpdateTransferFromCodeQst@1018 : TextConst 'DAN=Hvis du �ndrer den lokation, der overflyttes fra, slettes overf�rselslinjerne.\\Vil du forts�tte?;ENU=If you change the transfer-from location, the transfer order lines will be deleted.\\Do you want to continue?';
      Text007@1014 : TextConst 'DAN=Du har muligvis �ndret en dimension.\\Vil du opdatere linjerne?;ENU=You may have changed a dimension.\\Do you want to update the lines?';

    [External]
    PROCEDURE InitRecord@10();
    BEGIN
      IF "Posting Date" = 0D THEN
        VALIDATE("Posting Date",WORKDATE);
    END;

    [External]
    PROCEDURE AssistEdit@1(OldTransHeader@1000 : Record 5740) : Boolean;
    BEGIN
      WITH TransHeader DO BEGIN
        TransHeader := Rec;
        GetInventorySetup;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldTransHeader."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          Rec := TransHeader;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE TestNoSeries@6();
    BEGIN
      InvtSetup.TESTFIELD("Transfer Order Nos.");
    END;

    LOCAL PROCEDURE GetNoSeriesCode@9() : Code[20];
    BEGIN
      EXIT(InvtSetup."Transfer Order Nos.");
    END;

    [External]
    PROCEDURE SetHideValidationDialog@14(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@19(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    VAR
      OldDimSetID@1002 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");

      IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
        MODIFY;
        IF TransferLinesExist THEN
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    LOCAL PROCEDURE GetInventorySetup@2();
    BEGIN
      IF NOT HasInventorySetup THEN BEGIN
        InvtSetup.GET;
        HasInventorySetup := TRUE;
      END;
    END;

    LOCAL PROCEDURE UpdateTransLines@15(TransferHeader@1002 : Record 5740;FieldID@1000 : Integer);
    VAR
      TransferLine@1001 : Record 5741;
    BEGIN
      TransferLine.SETRANGE("Document No.","No.");
      TransferLine.SETFILTER("Item No.",'<>%1','');
      IF TransferLine.FINDSET THEN BEGIN
        TransferLine.LOCKTABLE;
        REPEAT
          CASE FieldID OF
            FIELDNO("In-Transit Code"):
              TransferLine.VALIDATE("In-Transit Code",TransferHeader."In-Transit Code");
            FIELDNO("Transfer-from Code"):
              BEGIN
                TransferLine.VALIDATE("Transfer-from Code",TransferHeader."Transfer-from Code");
                TransferLine.VALIDATE("Shipping Agent Code",TransferHeader."Shipping Agent Code");
                TransferLine.VALIDATE("Shipping Agent Service Code",TransferHeader."Shipping Agent Service Code");
                TransferLine.VALIDATE("Shipment Date",TransferHeader."Shipment Date");
                TransferLine.VALIDATE("Receipt Date",TransferHeader."Receipt Date");
                TransferLine.VALIDATE("Shipping Time",TransferHeader."Shipping Time");
              END;
            FIELDNO("Transfer-to Code"):
              BEGIN
                TransferLine.VALIDATE("Transfer-to Code",TransferHeader."Transfer-to Code");
                TransferLine.VALIDATE("Shipping Agent Code",TransferHeader."Shipping Agent Code");
                TransferLine.VALIDATE("Shipping Agent Service Code",TransferHeader."Shipping Agent Service Code");
                TransferLine.VALIDATE("Shipment Date",TransferHeader."Shipment Date");
                TransferLine.VALIDATE("Receipt Date",TransferHeader."Receipt Date");
                TransferLine.VALIDATE("Shipping Time",TransferHeader."Shipping Time");
              END;
            FIELDNO("Shipping Agent Code"):
              BEGIN
                TransferLine.VALIDATE("Shipping Agent Code",TransferHeader."Shipping Agent Code");
                TransferLine.BlockDynamicTracking(TRUE);
                TransferLine.VALIDATE("Shipping Agent Service Code",TransferHeader."Shipping Agent Service Code");
                TransferLine.VALIDATE("Shipment Date",TransferHeader."Shipment Date");
                TransferLine.VALIDATE("Receipt Date",TransferHeader."Receipt Date");
                TransferLine.VALIDATE("Shipping Time",TransferHeader."Shipping Time");
                TransferLine.BlockDynamicTracking(FALSE);
                TransferLine.DateConflictCheck;
              END;
            FIELDNO("Shipping Agent Service Code"):
              BEGIN
                TransferLine.BlockDynamicTracking(TRUE);
                TransferLine.VALIDATE("Shipping Agent Service Code",TransferHeader."Shipping Agent Service Code");
                TransferLine.VALIDATE("Shipment Date",TransferHeader."Shipment Date");
                TransferLine.VALIDATE("Receipt Date",TransferHeader."Receipt Date");
                TransferLine.VALIDATE("Shipping Time",TransferHeader."Shipping Time");
                TransferLine.BlockDynamicTracking(FALSE);
                TransferLine.DateConflictCheck;
              END;
            FIELDNO("Shipment Date"):
              BEGIN
                TransferLine.BlockDynamicTracking(TRUE);
                TransferLine.VALIDATE("Shipment Date",TransferHeader."Shipment Date");
                TransferLine.VALIDATE("Receipt Date",TransferHeader."Receipt Date");
                TransferLine.VALIDATE("Shipping Time",TransferHeader."Shipping Time");
                TransferLine.BlockDynamicTracking(FALSE);
                TransferLine.DateConflictCheck;
              END;
            FIELDNO("Receipt Date"),FIELDNO("Shipping Time"):
              BEGIN
                TransferLine.BlockDynamicTracking(TRUE);
                TransferLine.VALIDATE("Shipping Time",TransferHeader."Shipping Time");
                TransferLine.VALIDATE("Receipt Date",TransferHeader."Receipt Date");
                TransferLine.BlockDynamicTracking(FALSE);
                TransferLine.DateConflictCheck;
              END;
            FIELDNO("Outbound Whse. Handling Time"):
              TransferLine.VALIDATE("Outbound Whse. Handling Time",TransferHeader."Outbound Whse. Handling Time");
            FIELDNO("Inbound Whse. Handling Time"):
              TransferLine.VALIDATE("Inbound Whse. Handling Time",TransferHeader."Inbound Whse. Handling Time");
            FIELDNO(Status):
              TransferLine.VALIDATE(Status,TransferHeader.Status);
            FIELDNO("Direct Transfer"):
              BEGIN
                TransferLine.VALIDATE("In-Transit Code",TransferHeader."In-Transit Code");
                TransferLine.VALIDATE("Item No.",TransferLine."Item No.");
              END;
            ELSE
              OnUpdateTransLines(TransferLine,TransferHeader,FieldID);
          END;
          TransferLine.MODIFY(TRUE);
        UNTIL TransferLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE ShouldDeleteOneTransferOrder@11(VAR TransLine2@1000 : Record 5741) : Boolean;
    BEGIN
      IF TransLine2.FIND('-') THEN
        REPEAT
          IF (TransLine2.Quantity <> TransLine2."Quantity Shipped") OR
             (TransLine2.Quantity <> TransLine2."Quantity Received") OR
             (TransLine2."Quantity (Base)" <> TransLine2."Qty. Shipped (Base)") OR
             (TransLine2."Quantity (Base)" <> TransLine2."Qty. Received (Base)") OR
             (TransLine2."Quantity Shipped" <> TransLine2."Quantity Received") OR
             (TransLine2."Qty. Shipped (Base)" <> TransLine2."Qty. Received (Base)")
          THEN
            EXIT(FALSE);
        UNTIL TransLine2.NEXT = 0;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE DeleteOneTransferOrder@4(VAR TransHeader2@1000 : Record 5740;VAR TransLine2@1001 : Record 5741);
    VAR
      ItemChargeAssgntPurch@1002 : Record 5805;
      WhseRequest@1003 : Record 5765;
      InvtCommentLine@1004 : Record 5748;
      No@1007 : Code[20];
    BEGIN
      No := TransHeader2."No.";

      WhseRequest.SETRANGE("Source Type",DATABASE::"Transfer Line");
      WhseRequest.SETRANGE("Source No.",No);
      IF NOT WhseRequest.ISEMPTY THEN
        WhseRequest.DELETEALL(TRUE);

      InvtCommentLine.SETRANGE("Document Type",InvtCommentLine."Document Type"::"Transfer Order");
      InvtCommentLine.SETRANGE("No.",No);
      InvtCommentLine.DELETEALL;

      ItemChargeAssgntPurch.SETCURRENTKEY(
        "Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",ItemChargeAssgntPurch."Applies-to Doc. Type"::"Transfer Receipt");
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",TransLine2."Document No.");
      ItemChargeAssgntPurch.DELETEALL;

      IF TransLine2.FIND('-') THEN
        TransLine2.DELETEALL;

      TransHeader2.DELETE;
      IF NOT HideValidationDialog THEN
        MESSAGE(TransferOrderPostedMsg1,No);
    END;

    LOCAL PROCEDURE TestStatusOpen@37();
    BEGIN
      IF NOT CalledFromWhse THEN
        TESTFIELD(Status,Status::Open);
    END;

    [External]
    PROCEDURE CalledFromWarehouse@7300(CalledFromWhse2@1000 : Boolean);
    BEGIN
      CalledFromWhse := CalledFromWhse2;
    END;

    [External]
    PROCEDURE CreateInvtPutAwayPick@29();
    VAR
      WhseRequest@1000 : Record 5765;
    BEGIN
      TESTFIELD(Status,Status::Released);

      WhseRequest.RESET;
      WhseRequest.SETCURRENTKEY("Source Document","Source No.");
      WhseRequest.SETFILTER(
        "Source Document",'%1|%2',
        WhseRequest."Source Document"::"Inbound Transfer",
        WhseRequest."Source Document"::"Outbound Transfer");
      WhseRequest.SETRANGE("Source No.","No.");
      REPORT.RUNMODAL(REPORT::"Create Invt Put-away/Pick/Mvmt",TRUE,FALSE,WhseRequest);
    END;

    [External]
    PROCEDURE ShowDocDim@3();
    VAR
      OldDimSetID@1000 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

      IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
        MODIFY;
        IF TransferLinesExist THEN
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    LOCAL PROCEDURE TransferLinesExist@5() : Boolean;
    BEGIN
      TransLine.RESET;
      TransLine.SETRANGE("Document No.","No.");
      EXIT(TransLine.FINDFIRST);
    END;

    LOCAL PROCEDURE UpdateAllLineDim@34(NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 : Integer);
    VAR
      NewDimSetID@1002 : Integer;
      ShippedLineDimChangeConfirmed@1003 : Boolean;
    BEGIN
      // Update all lines with changed dimensions.

      IF NewParentDimSetID = OldParentDimSetID THEN
        EXIT;
      IF NOT CONFIRM(Text007) THEN
        EXIT;

      TransLine.RESET;
      TransLine.SETRANGE("Document No.","No.");
      TransLine.LOCKTABLE;
      IF TransLine.FIND('-') THEN
        REPEAT
          NewDimSetID := DimMgt.GetDeltaDimSetID(TransLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
          IF TransLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
            TransLine."Dimension Set ID" := NewDimSetID;

            VerifyShippedLineDimChange(ShippedLineDimChangeConfirmed);

            DimMgt.UpdateGlobalDimFromDimSetID(
              TransLine."Dimension Set ID",TransLine."Shortcut Dimension 1 Code",TransLine."Shortcut Dimension 2 Code");
            TransLine.MODIFY;
          END;
        UNTIL TransLine.NEXT = 0;
    END;

    LOCAL PROCEDURE VerifyShippedLineDimChange@71(VAR ShippedLineDimChangeConfirmed@1000 : Boolean);
    BEGIN
      IF TransLine.IsShippedDimChanged THEN
        IF NOT ShippedLineDimChangeConfirmed THEN
          ShippedLineDimChangeConfirmed := TransLine.ConfirmShippedDimChange;
    END;

    [External]
    PROCEDURE CheckBeforePost@7();
    BEGIN
      TESTFIELD("Transfer-from Code");
      TESTFIELD("Transfer-to Code");
      IF "Transfer-from Code" = "Transfer-to Code" THEN
        ERROR(
          Text001,
          FIELDCAPTION("Transfer-from Code"),FIELDCAPTION("Transfer-to Code"),
          TABLECAPTION,"No.");

      IF NOT "Direct Transfer" THEN
        TESTFIELD("In-Transit Code")
      ELSE BEGIN
        VerifyNoOutboundWhseHandlingOnLocation("Transfer-from Code");
        VerifyNoInboundWhseHandlingOnLocation("Transfer-to Code");
      END;
      TESTFIELD(Status,Status::Released);
      TESTFIELD("Posting Date");
    END;

    [External]
    PROCEDURE CheckInvtPostingSetup@8();
    VAR
      InventoryPostingSetup@1000 : Record 5813;
    BEGIN
      InventoryPostingSetup.SETRANGE("Location Code","Transfer-from Code");
      InventoryPostingSetup.FINDFIRST;
      InventoryPostingSetup.SETRANGE("Location Code","Transfer-to Code");
      InventoryPostingSetup.FINDFIRST;
    END;

    PROCEDURE HasShippedItems@23() : Boolean;
    VAR
      TransferLine@1000 : Record 5741;
    BEGIN
      TransferLine.SETRANGE("Document No.","No.");
      TransferLine.SETFILTER("Item No.",'<>%1','');
      TransferLine.SETFILTER("Quantity Shipped",'>%1',0);
      EXIT(NOT TransferLine.ISEMPTY);
    END;

    PROCEDURE HasTransferLines@24() : Boolean;
    VAR
      TransferLine@1000 : Record 5741;
    BEGIN
      TransferLine.SETRANGE("Document No.","No.");
      TransferLine.SETFILTER("Item No.",'<>%1','');
      EXIT(NOT TransferLine.ISEMPTY);
    END;

    [Integration]
    LOCAL PROCEDURE OnUpdateTransLines@12(VAR TransferLine@1000 : Record 5741;TransferHeader@1001 : Record 5740;FieldID@1002 : Integer);
    BEGIN
    END;

    [External]
    PROCEDURE VerifyNoOutboundWhseHandlingOnLocation@13(LocationCode@1000 : Code[10]);
    VAR
      Location@1001 : Record 14;
    BEGIN
      IF NOT Location.GET(LocationCode) THEN
        EXIT;

      Location.TESTFIELD("Require Pick",FALSE);
      Location.TESTFIELD("Require Shipment",FALSE);
    END;

    [External]
    PROCEDURE VerifyNoInboundWhseHandlingOnLocation@18(LocationCode@1000 : Code[10]);
    VAR
      Location@1001 : Record 14;
    BEGIN
      IF NOT Location.GET(LocationCode) THEN
        EXIT;

      Location.TESTFIELD("Require Put-away",FALSE);
      Location.TESTFIELD("Require Receive",FALSE);
    END;

    BEGIN
    END.
  }
}

