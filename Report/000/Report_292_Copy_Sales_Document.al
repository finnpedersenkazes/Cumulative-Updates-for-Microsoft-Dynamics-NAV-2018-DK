OBJECT Report 292 Copy Sales Document
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kopier salgsdokument;
               ENU=Copy Sales Document];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  SalesSetup.GET;
                  CopyDocMgt.SetProperties(
                    IncludeHeader,RecalculateLines,FALSE,FALSE,FALSE,SalesSetup."Exact Cost Reversing Mandatory",FALSE);
                  CopyDocMgt.CopySalesDoc(DocType,DocNo,SalesHeader)
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
                         IF FromSalesHeader.GET(FromSalesHeader."Document Type"::Quote,DocNo) THEN;
                       DocType::"Blanket Order":
                         IF FromSalesHeader.GET(FromSalesHeader."Document Type"::"Blanket Order",DocNo) THEN;
                       DocType::Order:
                         IF FromSalesHeader.GET(FromSalesHeader."Document Type"::Order,DocNo) THEN;
                       DocType::Invoice:
                         IF FromSalesHeader.GET(FromSalesHeader."Document Type"::Invoice,DocNo) THEN;
                       DocType::"Return Order":
                         IF FromSalesHeader.GET(FromSalesHeader."Document Type"::"Return Order",DocNo) THEN;
                       DocType::"Credit Memo":
                         IF FromSalesHeader.GET(FromSalesHeader."Document Type"::"Credit Memo",DocNo) THEN;
                       DocType::"Posted Shipment":
                         IF FromSalesShptHeader.GET(DocNo) THEN
                           FromSalesHeader.TRANSFERFIELDS(FromSalesShptHeader);
                       DocType::"Posted Invoice":
                         IF FromSalesInvHeader.GET(DocNo) THEN
                           FromSalesHeader.TRANSFERFIELDS(FromSalesInvHeader);
                       DocType::"Posted Return Receipt":
                         IF FromReturnRcptHeader.GET(DocNo) THEN
                           FromSalesHeader.TRANSFERFIELDS(FromReturnRcptHeader);
                       DocType::"Posted Credit Memo":
                         IF FromSalesCrMemoHeader.GET(DocNo) THEN
                           FromSalesHeader.TRANSFERFIELDS(FromSalesCrMemoHeader);
                     END;
                     IF FromSalesHeader."No." = '' THEN
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
                  OptionCaptionML=[DAN=Tilbud,Rammeordre,Ordre,Faktura,Returvareordre,Kreditnota,Bogf. salgslev.,Bogf. faktura,Bogf. returvaremodt.,Bogf. kreditnota;
                                   ENU=Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Shipment,Posted Invoice,Posted Return Receipt,Posted Credit Memo];
                  ApplicationArea=#Suite;
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
                  ApplicationArea=#Suite;
                  SourceExpr=DocNo;
                  OnValidate=BEGIN
                               ValidateDocNo;
                             END;

                  OnLookup=BEGIN
                             LookupDocNo;
                           END;
                            }

      { 5   ;2   ;Field     ;
                  Name=SellToCustNo;
                  CaptionML=[DAN=Kundenr.;
                             ENU=Sell-to Customer No.];
                  ToolTipML=[DAN=Angiver det kundenummer, der vises p† det nye salgsbilag.;
                             ENU=Specifies the sell-to customer number that will appear on the new sales document.];
                  ApplicationArea=#Suite;
                  SourceExpr=FromSalesHeader."Sell-to Customer No.";
                  Editable=FALSE }

      { 7   ;2   ;Field     ;
                  Name=SellToCustName;
                  CaptionML=[DAN=Kundenavn;
                             ENU=Sell-to Customer Name];
                  ToolTipML=[DAN=Angiver det debitornavn, der vises p† det nye salgsbilag.;
                             ENU=Specifies the sell-to customer name that will appear on the new sales document.];
                  ApplicationArea=#Suite;
                  SourceExpr=FromSalesHeader."Sell-to Customer Name";
                  Editable=FALSE }

      { 1   ;2   ;Field     ;
                  Name=IncludeHeader_Options;
                  CaptionML=[DAN=Inkluder hoved;
                             ENU=Include Header];
                  ToolTipML=[DAN=Angiver, om du ogs† vil kopiere oplysningerne fra dokumenthovedet. Hvis du kopierer tilbud, og feltet Bogf›ringsdato er tomt i det nye dokument, bruges arbejdsdatoen som bogf›ringsdato for det nye dokument.;
                             ENU=Specifies if you also want to copy the information from the document header. When you copy quotes, if the posting date field of the new document is empty, the work date is used as the posting date of the new document.];
                  ApplicationArea=#Suite;
                  SourceExpr=IncludeHeader;
                  OnValidate=BEGIN
                               ValidateIncludeHeader;
                             END;
                              }

      { 4   ;2   ;Field     ;
                  Name=RecalculateLines;
                  CaptionML=[DAN=Genberegn linjer;
                             ENU=Recalculate Lines];
                  ToolTipML=[DAN=Angiver, at linjerne genberegnes og inds‘ttes p† det salgsdokument, du er ved at oprette. K›rslen bevarer varenumre og varebeholdning, men beregner bel›bene p† linjerne baseret p† kundeoplysningerne p† det nye dokumenthoved. P† den m†de tager k›rslen h›jde for varepriser og rabatter, der er specielt knyttet til kunden p† det nye hoved.;
                             ENU=Specifies that lines are recalculate and inserted on the sales document you are creating. The batch job retains the item numbers and item quantities but recalculates the amounts on the lines based on the customer information on the new document header. In this way, the batch job accounts for item prices and discounts that are specifically linked to the customer on the new header.];
                  ApplicationArea=#Suite;
                  SourceExpr=RecalculateLines;
                  OnValidate=BEGIN
                               IF (DocType = DocType::"Posted Shipment") OR (DocType = DocType::"Posted Return Receipt") THEN
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
      SalesHeader@1007 : Record 36;
      FromSalesHeader@1010 : Record 36;
      FromSalesShptHeader@1012 : Record 110;
      FromSalesInvHeader@1014 : Record 112;
      FromReturnRcptHeader@1016 : Record 6660;
      FromSalesCrMemoHeader@1018 : Record 114;
      SalesSetup@1003 : Record 311;
      CopyDocMgt@1008 : Codeunit 6620;
      DocType@1026 : 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Shipment,Posted Invoice,Posted Return Receipt,Posted Credit Memo';
      DocNo@1027 : Code[20];
      IncludeHeader@1028 : Boolean;
      RecalculateLines@1029 : Boolean;
      Text000@1000 : TextConst 'DAN=Prisoplysningerne kan muligvis ikke tilbagef›res korrekt, hvis du kopierer en %1. Kopier eventuelt en %2 i stedet, eller brug funktionen %3.;ENU=The price information may not be reversed correctly, if you copy a %1. If possible copy a %2 instead or use %3 functionality.';
      Text001@1001 : TextConst 'DAN=Annuller leverance;ENU=Undo Shipment';
      Text002@1002 : TextConst 'DAN=Annuller returvaremodt.;ENU=Undo Return Receipt';
      Text003@1004 : TextConst 'DAN=Tilbud,Rammeordre,Ordre,Faktura,Returvareordre,Kreditnota,Bogf. salgslev.,Bogf. faktura,Bogf. returvaremodt.,Bogf. kreditnota;ENU=Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Shipment,Posted Invoice,Posted Return Receipt,Posted Credit Memo';

    PROCEDURE SetSalesHeader@2(VAR NewSalesHeader@1000 : Record 36);
    BEGIN
      NewSalesHeader.TESTFIELD("No.");
      SalesHeader := NewSalesHeader;
    END;

    LOCAL PROCEDURE ValidateDocNo@10();
    VAR
      DocType2@1000 : 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Shipment,Posted Invoice,Posted Return Receipt,Posted Credit Memo';
    BEGIN
      IF DocNo = '' THEN
        FromSalesHeader.INIT
      ELSE
        IF FromSalesHeader."No." = '' THEN BEGIN
          FromSalesHeader.INIT;
          CASE DocType OF
            DocType::Quote,
            DocType::"Blanket Order",
            DocType::Order,
            DocType::Invoice,
            DocType::"Return Order",
            DocType::"Credit Memo":
              FromSalesHeader.GET(CopyDocMgt.SalesHeaderDocType(DocType),DocNo);
            DocType::"Posted Shipment":
              BEGIN
                FromSalesShptHeader.GET(DocNo);
                FromSalesHeader.TRANSFERFIELDS(FromSalesShptHeader);
                IF SalesHeader."Document Type" IN
                   [SalesHeader."Document Type"::"Return Order",SalesHeader."Document Type"::"Credit Memo"]
                THEN BEGIN
                  DocType2 := DocType2::"Posted Invoice";
                  MESSAGE(Text000,SELECTSTR(1 + DocType,Text003),SELECTSTR(1 + DocType2,Text003),Text001);
                END;
              END;
            DocType::"Posted Invoice":
              BEGIN
                FromSalesInvHeader.GET(DocNo);
                FromSalesHeader.TRANSFERFIELDS(FromSalesInvHeader);
              END;
            DocType::"Posted Return Receipt":
              BEGIN
                FromReturnRcptHeader.GET(DocNo);
                FromSalesHeader.TRANSFERFIELDS(FromReturnRcptHeader);
                IF SalesHeader."Document Type" IN
                   [SalesHeader."Document Type"::Order,SalesHeader."Document Type"::Invoice]
                THEN BEGIN
                  DocType2 := DocType2::"Posted Credit Memo";
                  MESSAGE(Text000,SELECTSTR(1 + DocType,Text003),SELECTSTR(1 + DocType2,Text003),Text002);
                END;
              END;
            DocType::"Posted Credit Memo":
              BEGIN
                FromSalesCrMemoHeader.GET(DocNo);
                FromSalesHeader.TRANSFERFIELDS(FromSalesCrMemoHeader);
              END;
          END;
        END;
      FromSalesHeader."No." := '';

      IncludeHeader :=
        (DocType IN [DocType::"Posted Invoice",DocType::"Posted Credit Memo"]) AND
        ((DocType = DocType::"Posted Credit Memo") <>
         (SalesHeader."Document Type" IN
          [SalesHeader."Document Type"::"Return Order",SalesHeader."Document Type"::"Credit Memo"])) AND
        (SalesHeader."Bill-to Customer No." IN [FromSalesHeader."Bill-to Customer No.",'']);

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
            FromSalesHeader.FILTERGROUP := 0;
            FromSalesHeader.SETRANGE("Document Type",CopyDocMgt.SalesHeaderDocType(DocType));
            IF SalesHeader."Document Type" = CopyDocMgt.SalesHeaderDocType(DocType) THEN
              FromSalesHeader.SETFILTER("No.",'<>%1',SalesHeader."No.");
            FromSalesHeader.FILTERGROUP := 2;
            FromSalesHeader."Document Type" := CopyDocMgt.SalesHeaderDocType(DocType);
            FromSalesHeader."No." := DocNo;
            IF (DocNo = '') AND (SalesHeader."Sell-to Customer No." <> '') THEN
              IF FromSalesHeader.SETCURRENTKEY("Document Type","Sell-to Customer No.") THEN BEGIN
                FromSalesHeader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                IF FromSalesHeader.FIND('=><') THEN;
              END;
            IF PAGE.RUNMODAL(0,FromSalesHeader) = ACTION::LookupOK THEN
              DocNo := FromSalesHeader."No.";
          END;
        DocType::"Posted Shipment":
          BEGIN
            FromSalesShptHeader."No." := DocNo;
            IF (DocNo = '') AND (SalesHeader."Sell-to Customer No." <> '') THEN
              IF FromSalesShptHeader.SETCURRENTKEY("Sell-to Customer No.") THEN BEGIN
                FromSalesShptHeader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                IF FromSalesShptHeader.FIND('=><') THEN;
              END;
            IF PAGE.RUNMODAL(0,FromSalesShptHeader) = ACTION::LookupOK THEN
              DocNo := FromSalesShptHeader."No.";
          END;
        DocType::"Posted Invoice":
          BEGIN
            FromSalesInvHeader."No." := DocNo;
            IF (DocNo = '') AND (SalesHeader."Sell-to Customer No." <> '') THEN
              IF FromSalesInvHeader.SETCURRENTKEY("Sell-to Customer No.") THEN BEGIN
                FromSalesInvHeader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                IF FromSalesInvHeader.FIND('=><') THEN;
              END;
            FromSalesInvHeader.FILTERGROUP(2);
            FromSalesInvHeader.SETRANGE("Prepayment Invoice",FALSE);
            FromSalesInvHeader.FILTERGROUP(0);
            IF PAGE.RUNMODAL(0,FromSalesInvHeader) = ACTION::LookupOK THEN
              DocNo := FromSalesInvHeader."No.";
          END;
        DocType::"Posted Return Receipt":
          BEGIN
            FromReturnRcptHeader."No." := DocNo;
            IF (DocNo = '') AND (SalesHeader."Sell-to Customer No." <> '') THEN
              IF FromReturnRcptHeader.SETCURRENTKEY("Sell-to Customer No.") THEN BEGIN
                FromReturnRcptHeader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                IF FromReturnRcptHeader.FIND('=><') THEN;
              END;
            IF PAGE.RUNMODAL(0,FromReturnRcptHeader) = ACTION::LookupOK THEN
              DocNo := FromReturnRcptHeader."No.";
          END;
        DocType::"Posted Credit Memo":
          BEGIN
            FromSalesCrMemoHeader."No." := DocNo;
            IF (DocNo = '') AND (SalesHeader."Sell-to Customer No." <> '') THEN
              IF FromSalesCrMemoHeader.SETCURRENTKEY("Sell-to Customer No.") THEN BEGIN
                FromSalesCrMemoHeader."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                IF FromSalesCrMemoHeader.FIND('=><') THEN;
              END;
            FromSalesCrMemoHeader.FILTERGROUP(2);
            FromSalesCrMemoHeader.SETRANGE("Prepayment Credit Memo",FALSE);
            FromSalesCrMemoHeader.FILTERGROUP(0);
            IF PAGE.RUNMODAL(0,FromSalesCrMemoHeader) = ACTION::LookupOK THEN
              DocNo := FromSalesCrMemoHeader."No.";
          END;
      END;
      ValidateDocNo;
    END;

    LOCAL PROCEDURE ValidateIncludeHeader@4();
    BEGIN
      RecalculateLines :=
        (DocType IN [DocType::"Posted Shipment",DocType::"Posted Return Receipt"]) OR NOT IncludeHeader;
    END;

    PROCEDURE InitializeRequest@1(NewDocType@1001 : Option;NewDocNo@1000 : Code[20];NewIncludeHeader@1002 : Boolean;NewRecalcLines@1003 : Boolean);
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

