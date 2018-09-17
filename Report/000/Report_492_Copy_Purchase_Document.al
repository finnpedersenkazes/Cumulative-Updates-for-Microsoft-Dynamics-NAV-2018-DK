OBJECT Report 492 Copy Purchase Document
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kopier k›bsdokument;
               ENU=Copy Purchase Document];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  PurchSetup.GET;
                  CopyDocMgt.SetProperties(
                    IncludeHeader,RecalculateLines,FALSE,FALSE,FALSE,PurchSetup."Exact Cost Reversing Mandatory",FALSE);
                  CopyDocMgt.CopyPurchDoc(DocType,DocNo,PurchHeader)
                END;

  }
  DATASET
  {
  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   IF DocNo <> '' THEN BEGIN
                     CASE DocType OF
                       DocType::Quote:
                         IF FromPurchHeader.GET(FromPurchHeader."Document Type"::Quote,DocNo) THEN;
                       DocType::"Blanket Order":
                         IF FromPurchHeader.GET(FromPurchHeader."Document Type"::"Blanket Order",DocNo) THEN;
                       DocType::Order:
                         IF FromPurchHeader.GET(FromPurchHeader."Document Type"::Order,DocNo) THEN;
                       DocType::Invoice:
                         IF FromPurchHeader.GET(FromPurchHeader."Document Type"::Invoice,DocNo) THEN;
                       DocType::"Return Order":
                         IF FromPurchHeader.GET(FromPurchHeader."Document Type"::"Return Order",DocNo) THEN;
                       DocType::"Credit Memo":
                         IF FromPurchHeader.GET(FromPurchHeader."Document Type"::"Credit Memo",DocNo) THEN;
                       DocType::"Posted Receipt":
                         IF FromPurchRcptHeader.GET(DocNo) THEN
                           FromPurchHeader.TRANSFERFIELDS(FromPurchRcptHeader);
                       DocType::"Posted Invoice":
                         IF FromPurchInvHeader.GET(DocNo) THEN
                           FromPurchHeader.TRANSFERFIELDS(FromPurchInvHeader);
                       DocType::"Posted Return Shipment":
                         IF FromReturnShptHeader.GET(DocNo) THEN
                           FromPurchHeader.TRANSFERFIELDS(FromReturnShptHeader);
                       DocType::"Posted Credit Memo":
                         IF FromPurchCrMemoHeader.GET(DocNo) THEN
                           FromPurchHeader.TRANSFERFIELDS(FromPurchCrMemoHeader);
                     END;
                     IF FromPurchHeader."No." = '' THEN
                       DocNo := '';
                   END;
                   ValidateDocNo;
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 3   ;2   ;Field     ;
                  Name=DocumentType;
                  CaptionML=[DAN=Bilagstype;
                             ENU=Document Type];
                  ToolTipML=[DAN=Angiver typen af det salgsdokument, der behandles af rapporten eller k›rslen.;
                             ENU=Specifies the type of document that is processed by the report or batch job.];
                  OptionCaptionML=[DAN=Rekvisition,Rammeordre,Ordre,Faktura,Returvareordre,Kreditnota,Bogf. k›bslev.,Bogf. faktura,Bogf. returvaremodt.,Bogf. kreditnota;
                                   ENU=Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Receipt,Posted Invoice,Posted Return Shipment,Posted Credit Memo];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DocType;
                  OnValidate=BEGIN
                               DocNo := '';
                               ValidateDocNo;
                             END;
                              }

      { 8   ;2   ;Field     ;
                  Name=DocumentNo;
                  CaptionML=[DAN=Bilagsnr.;
                             ENU=Document No.];
                  ToolTipML=[DAN=Angiver nummeret p† det salgsdokument, der behandles af rapporten eller k›rslen.;
                             ENU=Specifies the number of the document that is processed by the report or batch job.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DocNo;
                  OnValidate=BEGIN
                               ValidateDocNo;
                             END;

                  OnLookup=BEGIN
                             LookupDocNo;
                           END;
                            }

      { 5   ;2   ;Field     ;
                  Name=BuyfromVendorNo;
                  CaptionML=[DAN=Leverand›rnr.;
                             ENU=Buy-from Vendor No.];
                  ToolTipML=[DAN=Angiver kreditoren i henhold til v‘rdierne i felterne Bilagsnr. og Dokumenttype.;
                             ENU=Specifies the vendor according to the values in the Document No. and Document Type fields.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=FromPurchHeader."Buy-from Vendor No.";
                  Editable=FALSE }

      { 7   ;2   ;Field     ;
                  Name=BuyfromVendorName;
                  CaptionML=[DAN=Leverand›rnavn;
                             ENU=Buy-from Vendor Name];
                  ToolTipML=[DAN=Angiver kreditoren i henhold til v‘rdierne i felterne Bilagsnr. og Dokumenttype.;
                             ENU=Specifies the vendor according to the values in the Document No. and Document Type fields.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=FromPurchHeader."Buy-from Vendor Name";
                  Editable=FALSE }

      { 1   ;2   ;Field     ;
                  Name=IncludeHeader_Options;
                  CaptionML=[DAN=Inkluder hoved;
                             ENU=Include Header];
                  ToolTipML=[DAN=Angiver, om du ogs† vil kopiere oplysningerne fra dokumenthovedet. Hvis du kopierer tilbud, og feltet Bogf›ringsdato er tomt i det nye dokument, bruges arbejdsdatoen som bogf›ringsdato for det nye dokument.;
                             ENU=Specifies if you also want to copy the information from the document header. When you copy quotes, if the posting date field of the new document is empty, the work date is used as the posting date of the new document.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=IncludeHeader;
                  OnValidate=BEGIN
                               ValidateIncludeHeader;
                             END;
                              }

      { 4   ;2   ;Field     ;
                  Name=RecalculateLines;
                  CaptionML=[DAN=Genberegn linjer;
                             ENU=Recalculate Lines];
                  ToolTipML=[DAN=Angiver, at linjerne genberegnes og inds‘ttes p† det k›bsdokument, du er ved at oprette. K›rslen bevarer varenumre og varebeholdning, men beregner bel›bene p† linjerne baseret p† kreditoroplysningerne p† det nye dokumenthoved. P† den m†de tager k›rslen h›jde for varepriser og rabatter, der er specielt knyttet til kreditoren p† det nye hoved.;
                             ENU=Specifies that lines are recalculate and inserted on the purchase document you are creating. The batch job retains the item numbers and item quantities but recalculates the amounts on the lines based on the vendor information on the new document header. In this way, the batch job accounts for item prices and discounts that are specifically linked to the vendor on the new header.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=RecalculateLines;
                  OnValidate=BEGIN
                               IF (DocType = DocType::"Posted Receipt") OR (DocType = DocType::"Posted Return Shipment") THEN
                                 RecalculateLines := TRUE;
                             END;
                              }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      PurchHeader@1007 : Record 38;
      FromPurchHeader@1010 : Record 38;
      FromPurchRcptHeader@1012 : Record 120;
      FromPurchInvHeader@1014 : Record 122;
      FromReturnShptHeader@1008 : Record 6650;
      FromPurchCrMemoHeader@1016 : Record 124;
      PurchSetup@1003 : Record 312;
      CopyDocMgt@1033 : Codeunit 6620;
      DocType@1024 : 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Receipt,Posted Invoice,Posted Return Shipment,Posted Credit Memo';
      DocNo@1025 : Code[20];
      IncludeHeader@1026 : Boolean;
      RecalculateLines@1027 : Boolean;
      Text000@1002 : TextConst 'DAN=Prisoplysningerne kan muligvis ikke tilbagef›res korrekt, hvis du kopierer en %1. Kopi‚r eventuelt en %2 i stedet, eller brug funktionen %3.;ENU=The price information may not be reversed correctly, if you copy a %1. If possible, copy a %2 instead or use %3 functionality.';
      Text001@1001 : TextConst 'DAN=Annuller modtagelse;ENU=Undo Receipt';
      Text002@1000 : TextConst 'DAN=Annuller returvarelev.;ENU=Undo Return Shipment';
      Text003@1004 : TextConst 'DAN=Rekvisition,Rammeordre,Ordre,Faktura,Returvareordre,Kreditnota,Bogf. k›bslev.,Bogf. faktura,Bogf. returvaremodt.,Bogf. kreditnota;ENU=Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Receipt,Posted Invoice,Posted Return Shipment,Posted Credit Memo';

    [External]
    PROCEDURE SetPurchHeader@2(VAR NewPurchHeader@1000 : Record 38);
    BEGIN
      NewPurchHeader.TESTFIELD("No.");
      PurchHeader := NewPurchHeader;
    END;

    LOCAL PROCEDURE ValidateDocNo@1();
    VAR
      DocType2@1000 : 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Receipt,Posted Invoice,Posted Return Shipment,Posted Credit Memo';
    BEGIN
      IF DocNo = '' THEN
        FromPurchHeader.INIT
      ELSE
        IF DocNo <> FromPurchHeader."No." THEN BEGIN
          FromPurchHeader.INIT;
          CASE DocType OF
            DocType::Quote,
            DocType::"Blanket Order",
            DocType::Order,
            DocType::Invoice,
            DocType::"Return Order",
            DocType::"Credit Memo":
              FromPurchHeader.GET(CopyDocMgt.PurchHeaderDocType(DocType),DocNo);
            DocType::"Posted Receipt":
              BEGIN
                FromPurchRcptHeader.GET(DocNo);
                FromPurchHeader.TRANSFERFIELDS(FromPurchRcptHeader);
                IF PurchHeader."Document Type" IN
                   [PurchHeader."Document Type"::"Return Order",PurchHeader."Document Type"::"Credit Memo"]
                THEN BEGIN
                  DocType2 := DocType2::"Posted Invoice";
                  MESSAGE(Text000,SELECTSTR(1 + DocType,Text003),SELECTSTR(1 + DocType2,Text003),Text001);
                END;
              END;
            DocType::"Posted Invoice":
              BEGIN
                FromPurchInvHeader.GET(DocNo);
                FromPurchHeader.TRANSFERFIELDS(FromPurchInvHeader);
              END;
            DocType::"Posted Return Shipment":
              BEGIN
                FromReturnShptHeader.GET(DocNo);
                FromPurchHeader.TRANSFERFIELDS(FromReturnShptHeader);
                IF PurchHeader."Document Type" IN
                   [PurchHeader."Document Type"::Order,PurchHeader."Document Type"::Invoice]
                THEN BEGIN
                  DocType2 := DocType2::"Posted Credit Memo";
                  MESSAGE(Text000,SELECTSTR(1 + DocType,Text003),SELECTSTR(1 + DocType2,Text003),Text002);
                END;
              END;
            DocType::"Posted Credit Memo":
              BEGIN
                FromPurchCrMemoHeader.GET(DocNo);
                FromPurchHeader.TRANSFERFIELDS(FromPurchCrMemoHeader);
              END;
          END;
        END;
      FromPurchHeader."No." := '';

      IncludeHeader :=
        (DocType IN [DocType::"Posted Invoice",DocType::"Posted Credit Memo"]) AND
        ((DocType = DocType::"Posted Credit Memo") <>
         (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo")) AND
        (PurchHeader."Buy-from Vendor No." IN [FromPurchHeader."Buy-from Vendor No.",'']);

      OnBeforeValidateIncludeHeader(IncludeHeader);
      ValidateIncludeHeader;
    END;

    LOCAL PROCEDURE LookupDocNo@3();
    BEGIN
      CASE DocType OF
        DocType::Quote,
        DocType::"Blanket Order",
        DocType::Order,
        DocType::Invoice,
        DocType::"Return Order",
        DocType::"Credit Memo":
          BEGIN
            FromPurchHeader.FILTERGROUP := 0;
            FromPurchHeader.SETRANGE("Document Type",CopyDocMgt.PurchHeaderDocType(DocType));
            IF PurchHeader."Document Type" = CopyDocMgt.PurchHeaderDocType(DocType) THEN
              FromPurchHeader.SETFILTER("No.",'<>%1',PurchHeader."No.");
            FromPurchHeader.FILTERGROUP := 2;
            FromPurchHeader."Document Type" := CopyDocMgt.PurchHeaderDocType(DocType);
            FromPurchHeader."No." := DocNo;
            IF (DocNo = '') AND (PurchHeader."Buy-from Vendor No." <> '') THEN
              IF FromPurchHeader.SETCURRENTKEY("Document Type","Buy-from Vendor No.") THEN BEGIN
                FromPurchHeader."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                IF FromPurchHeader.FIND('=><') THEN;
              END;
            IF PAGE.RUNMODAL(0,FromPurchHeader) = ACTION::LookupOK THEN
              DocNo := FromPurchHeader."No.";
          END;
        DocType::"Posted Receipt":
          BEGIN
            FromPurchRcptHeader."No." := DocNo;
            IF (DocNo = '') AND (PurchHeader."Buy-from Vendor No." <> '') THEN
              IF FromPurchRcptHeader.SETCURRENTKEY("Buy-from Vendor No.") THEN BEGIN
                FromPurchRcptHeader."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                IF FromPurchRcptHeader.FIND('=><') THEN;
              END;
            IF PAGE.RUNMODAL(0,FromPurchRcptHeader) = ACTION::LookupOK THEN
              DocNo := FromPurchRcptHeader."No.";
          END;
        DocType::"Posted Invoice":
          BEGIN
            FromPurchInvHeader."No." := DocNo;
            IF (DocNo = '') AND (PurchHeader."Buy-from Vendor No." <> '') THEN
              IF FromPurchInvHeader.SETCURRENTKEY("Buy-from Vendor No.") THEN BEGIN
                FromPurchInvHeader."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                IF FromPurchInvHeader.FIND('=><') THEN;
              END;
            FromPurchInvHeader.FILTERGROUP(2);
            FromPurchInvHeader.SETRANGE("Prepayment Invoice",FALSE);
            FromPurchInvHeader.FILTERGROUP(0);
            IF PAGE.RUNMODAL(0,FromPurchInvHeader) = ACTION::LookupOK THEN
              DocNo := FromPurchInvHeader."No.";
          END;
        DocType::"Posted Return Shipment":
          BEGIN
            FromReturnShptHeader."No." := DocNo;
            IF (DocNo = '') AND (PurchHeader."Buy-from Vendor No." <> '') THEN
              IF FromReturnShptHeader.SETCURRENTKEY("Buy-from Vendor No.") THEN BEGIN
                FromReturnShptHeader."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                IF FromReturnShptHeader.FIND('=><') THEN;
              END;
            IF PAGE.RUNMODAL(0,FromReturnShptHeader) = ACTION::LookupOK THEN
              DocNo := FromReturnShptHeader."No.";
          END;
        DocType::"Posted Credit Memo":
          BEGIN
            FromPurchCrMemoHeader."No." := DocNo;
            IF (DocNo = '') AND (PurchHeader."Buy-from Vendor No." <> '') THEN
              IF FromPurchCrMemoHeader.SETCURRENTKEY("Buy-from Vendor No.") THEN BEGIN
                FromPurchCrMemoHeader."Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                IF FromPurchCrMemoHeader.FIND('=><') THEN;
              END;
            FromPurchCrMemoHeader.FILTERGROUP(2);
            FromPurchCrMemoHeader.SETRANGE("Prepayment Credit Memo",FALSE);
            FromPurchCrMemoHeader.FILTERGROUP(0);
            IF PAGE.RUNMODAL(0,FromPurchCrMemoHeader) = ACTION::LookupOK THEN
              DocNo := FromPurchCrMemoHeader."No.";
          END;
      END;
      ValidateDocNo;
    END;

    LOCAL PROCEDURE ValidateIncludeHeader@4();
    BEGIN
      RecalculateLines :=
        (DocType IN [DocType::"Posted Receipt",DocType::"Posted Return Shipment"]) OR NOT IncludeHeader;
    END;

    PROCEDURE InitializeRequest@5(NewDocType@1001 : Option;NewDocNo@1000 : Code[20];NewIncludeHeader@1002 : Boolean;NewRecalcLines@1003 : Boolean);
    BEGIN
      DocType := NewDocType;
      DocNo := NewDocNo;
      IncludeHeader := NewIncludeHeader;
      RecalculateLines := NewRecalcLines;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeValidateIncludeHeader@1016(VAR DoIncludeHeader@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

