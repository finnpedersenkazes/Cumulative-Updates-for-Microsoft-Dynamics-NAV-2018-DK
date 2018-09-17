OBJECT Report 404 Purchase - Quote
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=K�bsrekvisition;
               ENU=Purchase - Quote];
    OnInitReport=BEGIN
                   CompanyInfo.GET;
                   PurchSetup.GET;
                 END;

    OnPreReport=BEGIN
                  IF NOT CurrReport.USEREQUESTPAGE THEN
                    InitLogInteraction;
                END;

    PreviewMode=PrintLayout;
  }
  DATASET
  {
    { 4458;    ;DataItem;                    ;
               DataItemTable=Table38;
               DataItemTableView=SORTING(Document Type,No.)
                                 WHERE(Document Type=CONST(Quote));
               ReqFilterHeadingML=[DAN=K�bsrekvisition;
                                   ENU=Purchase Quote];
               OnAfterGetRecord=BEGIN
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  FormatAddressFields("Purchase Header");
                                  FormatDocumentFields("Purchase Header");

                                  DimSetEntry1.SETRANGE("Dimension Set ID","Dimension Set ID");

                                  IF NOT IsReportInPreviewMode THEN BEGIN
                                    IF ArchiveDocument THEN
                                      ArchiveManagement.StorePurchDocument("Purchase Header",LogInteraction);

                                    IF LogInteraction THEN BEGIN
                                      CALCFIELDS("No. of Archived Versions");
                                      SegManagement.LogDocument(
                                        11,"No.","Doc. No. Occurrence","No. of Archived Versions",DATABASE::Vendor,"Pay-to Vendor No.",
                                        "Purchaser Code",'',"Posting Description",'');
                                    END;
                                  END;
                                END;

               ReqFilterFields=No.,Buy-from Vendor No.,No. Printed }

    { 98  ;1   ;Column  ;DocType_PurchHead   ;
               SourceExpr="Document Type" }

    { 99  ;1   ;Column  ;PurchHeadNo         ;
               SourceExpr="No." }

    { 13  ;1   ;Column  ;CompanyInfoPhoneNoCap;
               SourceExpr=CompanyInfoPhoneNoCapLbl }

    { 18  ;1   ;Column  ;CompanyInfoVATRegNoCap;
               SourceExpr=CompanyInfoVATRegNoCapLbl }

    { 20  ;1   ;Column  ;CompanyInfoGiroNoCap;
               SourceExpr=CompanyInfoGiroNoCapLbl }

    { 22  ;1   ;Column  ;CompanyInfoBankNameCap;
               SourceExpr=CompanyInfoBankNameCapLbl }

    { 24  ;1   ;Column  ;CompInfoBankAccNoCap;
               SourceExpr=CompInfoBankAccNoCapLbl }

    { 26  ;1   ;Column  ;DocumentDateCap     ;
               SourceExpr=DocumentDateCapLbl }

    { 39  ;1   ;Column  ;PageNoCaption       ;
               SourceExpr=PageNoCaptionLbl }

    { 42  ;1   ;Column  ;ShipmentMethodDescCap;
               SourceExpr=ShipmentMethodDescCapLbl }

    { 43  ;1   ;Column  ;PurchLineVendItemNoCap;
               SourceExpr=PurchLineVendItemNoCapLbl }

    { 52  ;1   ;Column  ;PurchaseLineDescCap ;
               SourceExpr=PurchaseLineDescCapLbl }

    { 53  ;1   ;Column  ;PurchaseLineQuantityCap;
               SourceExpr=PurchaseLineQuantityCapLbl }

    { 54  ;1   ;Column  ;PurchaseLineUOMCaption;
               SourceExpr=PurchaseLineUOMCaptionLbl }

    { 44  ;1   ;Column  ;PurchaseLineNoCaption;
               SourceExpr=PurchaseLineNoCaptionLbl }

    { 46  ;1   ;Column  ;PurchaserTextCaption;
               SourceExpr=PurchaserTextCaptionLbl }

    { 55  ;1   ;Column  ;ReferenceTextCaption;
               SourceExpr=ReferenceTextCaptionLbl }

    { 63  ;1   ;Column  ;HomePageCaption     ;
               SourceExpr=HomePageCaptionLbl }

    { 64  ;1   ;Column  ;EMailCaption        ;
               SourceExpr=EMailCaptionLbl }

    { 2   ;1   ;Column  ;VatRegistrationNoCaption;
               SourceExpr=VatRegistrationNoCaptionLbl }

    { 5701;1   ;DataItem;CopyLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               NoOfLoops := ABS(NoOfCopies) + 1;
                               CopyText := '';
                               SETRANGE(Number,1,NoOfLoops);
                               OutputNo := 1;
                             END;

               OnAfterGetRecord=BEGIN
                                  CLEAR(PurchLine);
                                  CLEAR(PurchPost);
                                  PurchLine.DELETEALL;
                                  PurchPost.GetPurchLines("Purchase Header",PurchLine,0);

                                  IF Number > 1 THEN BEGIN
                                    CopyText := FormatDocument.GetCOPYText;
                                    OutputNo += 1;
                                  END;
                                  CurrReport.PAGENO := 1;
                                END;

               OnPostDataItem=BEGIN
                                IF NOT IsReportInPreviewMode THEN
                                  CODEUNIT.RUN(CODEUNIT::"Purch.Header-Printed","Purchase Header");
                              END;
                               }

    { 6455;2   ;DataItem;PageLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 1   ;3   ;Column  ;PurchaseQuoteCopyText;
               SourceExpr=STRSUBSTNO(Text002,CopyText) }

    { 4   ;3   ;Column  ;VendAddr1           ;
               SourceExpr=VendAddr[1] }

    { 5   ;3   ;Column  ;CompanyAddr1        ;
               SourceExpr=CompanyAddr[1] }

    { 6   ;3   ;Column  ;VendAddr2           ;
               SourceExpr=VendAddr[2] }

    { 7   ;3   ;Column  ;CompanyAddr2        ;
               SourceExpr=CompanyAddr[2] }

    { 8   ;3   ;Column  ;VendAddr3           ;
               SourceExpr=VendAddr[3] }

    { 9   ;3   ;Column  ;CompanyAddr3        ;
               SourceExpr=CompanyAddr[3] }

    { 10  ;3   ;Column  ;VendAddr4           ;
               SourceExpr=VendAddr[4] }

    { 11  ;3   ;Column  ;CompanyAddr4        ;
               SourceExpr=CompanyAddr[4] }

    { 12  ;3   ;Column  ;VendAddr5           ;
               SourceExpr=VendAddr[5] }

    { 14  ;3   ;Column  ;CompanyInfoPhoneNo  ;
               IncludeCaption=No;
               SourceExpr=CompanyInfo."Phone No." }

    { 15  ;3   ;Column  ;VendAddr6           ;
               SourceExpr=VendAddr[6] }

    { 19  ;3   ;Column  ;CompanyInfoVatRegNo ;
               IncludeCaption=No;
               SourceExpr=CompanyInfo."VAT Registration No." }

    { 21  ;3   ;Column  ;CompanyInfoGiroNo   ;
               IncludeCaption=No;
               SourceExpr=CompanyInfo."Giro No." }

    { 23  ;3   ;Column  ;CompanyInfoBankName ;
               IncludeCaption=No;
               SourceExpr=CompanyInfo."Bank Name" }

    { 25  ;3   ;Column  ;CompanyInfoBankAccNo;
               IncludeCaption=No;
               SourceExpr=CompanyInfo."Bank Account No." }

    { 61  ;3   ;Column  ;CompanyInfoHomePage ;
               SourceExpr=CompanyInfo."Home Page" }

    { 62  ;3   ;Column  ;CompanyInfoEMail    ;
               SourceExpr=CompanyInfo."E-Mail" }

    { 27  ;3   ;Column  ;PaytoVendNo_PurchHdr;
               SourceExpr="Purchase Header"."Pay-to Vendor No." }

    { 28  ;3   ;Column  ;DocDate_PurchHdr    ;
               SourceExpr=FORMAT("Purchase Header"."Document Date",0,4) }

    { 29  ;3   ;Column  ;VatNoText           ;
               SourceExpr=VATNoText }

    { 30  ;3   ;Column  ;VatTRegNo_PurchHdr  ;
               SourceExpr="Purchase Header"."VAT Registration No." }

    { 32  ;3   ;Column  ;ExpctRecpDt_PurchHdr;
               SourceExpr=FORMAT("Purchase Header"."Expected Receipt Date") }

    { 33  ;3   ;Column  ;PurchaserText       ;
               SourceExpr=PurchaserText }

    { 34  ;3   ;Column  ;SalesPurchPersonName;
               SourceExpr=SalesPurchPerson.Name }

    { 36  ;3   ;Column  ;No1_PurchaseHdr     ;
               SourceExpr="Purchase Header"."No." }

    { 37  ;3   ;Column  ;ReferenceText       ;
               SourceExpr=ReferenceText }

    { 38  ;3   ;Column  ;YourRef_PurchHdr    ;
               SourceExpr="Purchase Header"."Your Reference" }

    { 3   ;3   ;Column  ;VendAddr7           ;
               SourceExpr=VendAddr[7] }

    { 74  ;3   ;Column  ;VendAddr8           ;
               SourceExpr=VendAddr[8] }

    { 75  ;3   ;Column  ;CompanyAddr5        ;
               SourceExpr=CompanyAddr[5] }

    { 76  ;3   ;Column  ;CompanyAddr6        ;
               SourceExpr=CompanyAddr[6] }

    { 41  ;3   ;Column  ;ShipMethodDesc      ;
               SourceExpr=ShipmentMethod.Description }

    { 59  ;3   ;Column  ;OutpuNo             ;
               SourceExpr=OutputNo }

    { 58  ;3   ;Column  ;BuyfromVendNo_PurchHdr;
               SourceExpr="Purchase Header"."Buy-from Vendor No." }

    { 31  ;3   ;Column  ;ExpectedDateCaption ;
               SourceExpr=ExpectedDateCaptionLbl }

    { 35  ;3   ;Column  ;QuoteNoCaption      ;
               SourceExpr=QuoteNoCaptionLbl }

    { 16  ;3   ;Column  ;PaytoVendNo_PurchHdrCaption;
               SourceExpr="Purchase Header".FIELDCAPTION("Pay-to Vendor No.") }

    { 17  ;3   ;Column  ;BuyfromVendNo_PurchHdrCaption;
               SourceExpr="Purchase Header".FIELDCAPTION("Buy-from Vendor No.") }

    { 7574;3   ;DataItem;DimensionLoop1      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowInternalInfo THEN
                                 CurrReport.BREAK;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry1.FINDSET THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;

                                  CLEAR(DimText);
                                  Continue := FALSE;
                                  REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                      DimText := STRSUBSTNO('%1 - %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
                                    ELSE
                                      DimText :=
                                        STRSUBSTNO(
                                          '%1; %2 - %3',DimText,
                                          DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                      DimText := OldDimText;
                                      Continue := TRUE;
                                      EXIT;
                                    END;
                                  UNTIL DimSetEntry1.NEXT = 0;
                                END;

               DataItemLinkReference=Purchase Header }

    { 56  ;4   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 86  ;4   ;Column  ;Number_DimensionLoop1;
               SourceExpr=Number }

    { 57  ;4   ;Column  ;HeaderDimensionsCaption;
               SourceExpr=HeaderDimensionsCaptionLbl }

    { 6547;3   ;DataItem;                    ;
               DataItemTable=Table39;
               DataItemTableView=SORTING(Document Type,Document No.,Line No.);
               OnPreDataItem=BEGIN
                               CurrReport.BREAK;
                             END;

               DataItemLinkReference=Purchase Header;
               DataItemLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.) }

    { 7551;3   ;DataItem;RoundLoop           ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               MoreLines := PurchLine.FIND('+');
                               WHILE MoreLines AND (PurchLine.Description = '') AND (PurchLine."Description 2" = '') AND
                                     (PurchLine."No." = '') AND (PurchLine.Quantity = 0) AND
                                     (PurchLine.Amount = 0)
                               DO
                                 MoreLines := PurchLine.NEXT(-1) <> 0;
                               IF NOT MoreLines THEN
                                 CurrReport.BREAK;
                               PurchLine.SETRANGE("Line No.",0,PurchLine."Line No.");
                               SETRANGE(Number,1,PurchLine.COUNT);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    PurchLine.FIND('-')
                                  ELSE
                                    PurchLine.NEXT;
                                  "Purchase Line" := PurchLine;
                                  IF ("Purchase Line"."Cross-Reference No." <> '') AND (NOT ShowInternalInfo) THEN
                                    "Purchase Line"."No." := "Purchase Line"."Cross-Reference No.";

                                  DimSetEntry2.SETRANGE("Dimension Set ID","Purchase Line"."Dimension Set ID");
                                END;

               OnPostDataItem=BEGIN
                                PurchLine.DELETEALL;
                              END;
                               }

    { 81  ;4   ;Column  ;ShowInternalInfo    ;
               SourceExpr=ShowInternalInfo }

    { 82  ;4   ;Column  ;ArchiveDocument     ;
               SourceExpr=ArchiveDocument }

    { 83  ;4   ;Column  ;LogInteraction      ;
               SourceExpr=LogInteraction }

    { 84  ;4   ;Column  ;Type_PurchaseLine   ;
               IncludeCaption=No;
               SourceExpr=FORMAT("Purchase Line".Type,0,2) }

    { 87  ;4   ;Column  ;LineNo_PurchaseLine ;
               IncludeCaption=No;
               SourceExpr="Purchase Line"."Line No." }

    { 45  ;4   ;Column  ;Description_PurchaseLine;
               IncludeCaption=No;
               SourceExpr="Purchase Line".Description }

    { 47  ;4   ;Column  ;Quantity_PurchaseLine;
               IncludeCaption=No;
               SourceExpr="Purchase Line".Quantity }

    { 48  ;4   ;Column  ;UnitOfMeasure_PurchaseLine;
               IncludeCaption=No;
               SourceExpr="Purchase Line"."Unit of Measure" }

    { 49  ;4   ;Column  ;ExpcRecpDt_PurchHdr ;
               IncludeCaption=No;
               SourceExpr=FORMAT("Purchase Line"."Expected Receipt Date") }

    { 51  ;4   ;Column  ;No_PurchaseLine     ;
               SourceExpr="Purchase Line"."No." }

    { 50  ;4   ;Column  ;VendItemNo_PurchLine;
               IncludeCaption=No;
               SourceExpr="Purchase Line"."Vendor Item No." }

    { 40  ;4   ;Column  ;PurchaseLineNoOurNoCap;
               SourceExpr=PurchaseLineNoOurNoCapLbl }

    { 3591;4   ;DataItem;DimensionLoop2      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowInternalInfo THEN
                                 CurrReport.BREAK;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;

                                  CLEAR(DimText);
                                  Continue := FALSE;
                                  REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                      DimText := STRSUBSTNO('%1 - %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
                                    ELSE
                                      DimText :=
                                        STRSUBSTNO(
                                          '%1; %2 - %3',DimText,
                                          DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                      DimText := OldDimText;
                                      Continue := TRUE;
                                      EXIT;
                                    END;
                                  UNTIL DimSetEntry2.NEXT = 0;
                                END;
                                 }

    { 60  ;5   ;Column  ;DimText1            ;
               SourceExpr=DimText }

    { 85  ;5   ;Column  ;Number2_DimensionLoop;
               SourceExpr=Number }

    { 79  ;5   ;Column  ;LineDimensionsCaption;
               SourceExpr=LineDimensionsCaptionLbl }

    { 8272;3   ;DataItem;Total3              ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF ("Purchase Header"."Sell-to Customer No." = '') AND (ShipToAddr[1] = '') THEN
                                 CurrReport.BREAK;
                             END;
                              }

    { 67  ;4   ;Column  ;SelltoCustNo_PurchHdr;
               SourceExpr="Purchase Header"."Sell-to Customer No." }

    { 68  ;4   ;Column  ;ShipToAddr1         ;
               SourceExpr=ShipToAddr[1] }

    { 69  ;4   ;Column  ;ShipToAddr2         ;
               SourceExpr=ShipToAddr[2] }

    { 70  ;4   ;Column  ;ShipToAddr3         ;
               SourceExpr=ShipToAddr[3] }

    { 71  ;4   ;Column  ;ShipToAddr4         ;
               SourceExpr=ShipToAddr[4] }

    { 72  ;4   ;Column  ;ShipToAddr5         ;
               SourceExpr=ShipToAddr[5] }

    { 73  ;4   ;Column  ;ShipToAddr6         ;
               SourceExpr=ShipToAddr[6] }

    { 77  ;4   ;Column  ;ShipToAddr7         ;
               SourceExpr=ShipToAddr[7] }

    { 78  ;4   ;Column  ;ShipToAddr8         ;
               SourceExpr=ShipToAddr[8] }

    { 65  ;4   ;Column  ;ShiptoAddressCaption;
               SourceExpr=ShiptoAddressCaptionLbl }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnInit=BEGIN
               LogInteractionEnable := TRUE;
               ArchiveDocument := PurchSetup."Archive Quotes and Orders";
             END;

      OnOpenPage=BEGIN
                   InitLogInteraction;

                   LogInteractionEnable := LogInteraction;
                 END;

    }
    CONTROLS
    {
      { 4   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 3   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Antal kopier;
                             ENU=No. of Copies];
                  ToolTipML=[DAN=Angiver, hvor mange kopier af bilaget der udskrives.;
                             ENU=Specifies how many copies of the document to print.];
                  ApplicationArea=#Advanced;
                  SourceExpr=NoOfCopies }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Vis interne oplysninger;
                             ENU=Show Internal Information];
                  ToolTipML=[DAN=Angiver, om den udskrevne rapport skal indeholde oplysninger, der kun er til intern brug.;
                             ENU=Specifies if you want the printed report to show information that is only for internal use.];
                  ApplicationArea=#Advanced;
                  SourceExpr=ShowInternalInfo }

      { 7   ;2   ;Field     ;
                  Name=ArchiveDocument;
                  CaptionML=[DAN=Arkiver dokument;
                             ENU=Archive Document];
                  ToolTipML=[DAN=Angiver, om bilaget arkiveres, efter du har udskrevet det.;
                             ENU=Specifies if the document is archived after you print it.];
                  ApplicationArea=#Advanced;
                  SourceExpr=ArchiveDocument;
                  OnValidate=BEGIN
                               IF NOT ArchiveDocument THEN
                                 LogInteraction := FALSE;
                             END;
                              }

      { 6   ;2   ;Field     ;
                  Name=LogInteraction;
                  CaptionML=[DAN=Logf�r interaktion;
                             ENU=Log Interaction];
                  ToolTipML=[DAN=Angiver, om programmet skal logf�re denne interaktion.;
                             ENU=Specifies if you want the program to log this interaction.];
                  ApplicationArea=#Advanced;
                  SourceExpr=LogInteraction;
                  Enabled=LogInteractionEnable;
                  OnValidate=BEGIN
                               IF LogInteraction THEN
                                 ArchiveDocument := ArchiveDocumentEnable;
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
      Text002@1002 : TextConst '@@@="%1 = Document No.";DAN=K�bsrekvisition %1;ENU=Purchase - Quote %1';
      ShipmentMethod@1006 : Record 10;
      SalesPurchPerson@1007 : Record 13;
      CompanyInfo@1008 : Record 79;
      PurchLine@1009 : TEMPORARY Record 39;
      DimSetEntry1@1010 : Record 480;
      DimSetEntry2@1011 : Record 480;
      RespCenter@1012 : Record 5714;
      Language@1013 : Record 8;
      PurchSetup@1036 : Record 312;
      PurchPost@1015 : Codeunit 90;
      FormatAddr@1003 : Codeunit 365;
      FormatDocument@1004 : Codeunit 368;
      SegManagement@1016 : Codeunit 5051;
      ArchiveManagement@1034 : Codeunit 5063;
      VendAddr@1017 : ARRAY [8] OF Text[50];
      ShipToAddr@1018 : ARRAY [8] OF Text[50];
      CompanyAddr@1019 : ARRAY [8] OF Text[50];
      PurchaserText@1020 : Text[30];
      VATNoText@1021 : Text[80];
      ReferenceText@1022 : Text[80];
      MoreLines@1023 : Boolean;
      NoOfCopies@1024 : Integer;
      NoOfLoops@1025 : Integer;
      CopyText@1026 : Text[30];
      DimText@1028 : Text[120];
      OldDimText@1029 : Text[75];
      ShowInternalInfo@1030 : Boolean;
      Continue@1031 : Boolean;
      ArchiveDocument@1033 : Boolean;
      LogInteraction@1032 : Boolean;
      OutputNo@1035 : Integer;
      ArchiveDocumentEnable@19005281 : Boolean INDATASET;
      LogInteractionEnable@19003940 : Boolean INDATASET;
      ExpectedDateCaptionLbl@7183 : TextConst 'DAN=Modtagelsesdato;ENU=Expected Date';
      QuoteNoCaptionLbl@9507 : TextConst 'DAN=Tilbudsnr.;ENU=Quote No.';
      HeaderDimensionsCaptionLbl@7125 : TextConst 'DAN=Dimensioner - hoved;ENU=Header Dimensions';
      PurchaseLineNoOurNoCapLbl@8081 : TextConst 'DAN=Vores nr.;ENU=Our No.';
      LineDimensionsCaptionLbl@3801 : TextConst 'DAN=Linjedimensioner;ENU=Line Dimensions';
      ShiptoAddressCaptionLbl@8743 : TextConst 'DAN=Leveringsadresse;ENU=Ship-to Address';
      CompanyInfoPhoneNoCapLbl@1413 : TextConst 'DAN=Telefon;ENU=Phone No.';
      CompanyInfoVATRegNoCapLbl@8393 : TextConst 'DAN=SE/CVR-nr.;ENU=VAT Reg. No.';
      CompanyInfoGiroNoCapLbl@6654 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      CompanyInfoBankNameCapLbl@5411 : TextConst 'DAN=Bank;ENU=Bank';
      CompInfoBankAccNoCapLbl@7395 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      DocumentDateCapLbl@9042 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      PageNoCaptionLbl@2773 : TextConst 'DAN=Side;ENU=Page';
      ShipmentMethodDescCapLbl@8526 : TextConst 'DAN=Leveringsform;ENU=Shipment Method';
      PurchLineVendItemNoCapLbl@7615 : TextConst 'DAN=Leverand�rs varenr.;ENU=Vendor Item No.';
      PurchaseLineDescCapLbl@7028 : TextConst 'DAN=Beskrivelse;ENU=Description';
      PurchaseLineQuantityCapLbl@5853 : TextConst 'DAN=Antal;ENU=Quantity';
      PurchaseLineUOMCaptionLbl@1251 : TextConst 'DAN=Enhed;ENU=Unit of Measure';
      PurchaseLineNoCaptionLbl@5817 : TextConst 'DAN=Varenr.;ENU=Item No.';
      PurchaserTextCaptionLbl@9842 : TextConst 'DAN=Indk�ber;ENU=Purchaser';
      ReferenceTextCaptionLbl@2889 : TextConst 'DAN=Reference;ENU=Your Reference';
      HomePageCaptionLbl@1436 : TextConst 'DAN=Hjemmeside;ENU=Home Page';
      EMailCaptionLbl@1638 : TextConst 'DAN=Mail;ENU=Email';
      VatRegistrationNoCaptionLbl@2131 : TextConst 'DAN=SE/CVR-nr.;ENU=VAT Registration No.';

    PROCEDURE IntializeRequest@1(NewNoOfCopies@1000 : Integer;NewShowInternalInfo@1001 : Boolean;NewArchiveDocument@1002 : Boolean;NewLogInteraction@1003 : Boolean);
    BEGIN
      NoOfCopies := NewNoOfCopies;
      ShowInternalInfo := NewShowInternalInfo;
      ArchiveDocument := NewArchiveDocument;
      LogInteraction := NewLogInteraction;
    END;

    LOCAL PROCEDURE IsReportInPreviewMode@8() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    LOCAL PROCEDURE InitLogInteraction@6();
    BEGIN
      LogInteraction := SegManagement.FindInteractTmplCode(11) <> '';
    END;

    LOCAL PROCEDURE FormatAddressFields@4(PurchaseHeader@1000 : Record 38);
    BEGIN
      FormatAddr.GetCompanyAddr(PurchaseHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
      FormatAddr.PurchHeaderPayTo(VendAddr,PurchaseHeader);
      FormatAddr.PurchHeaderShipTo(ShipToAddr,PurchaseHeader);
    END;

    LOCAL PROCEDURE FormatDocumentFields@2(PurchaseHeader@1000 : Record 38);
    BEGIN
      WITH PurchaseHeader DO BEGIN
        FormatDocument.SetPurchaser(SalesPurchPerson,"Purchaser Code",PurchaserText);
        FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");
        ReferenceText := FormatDocument.SetText("Your Reference" <> '',FIELDCAPTION("Your Reference"));
        VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FIELDCAPTION("VAT Registration No."));
      END;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
    <?xml version="1.0" encoding="utf-8"?>
<Report xmlns="http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner">
  <AutoRefresh>0</AutoRefresh>
  <DataSources>
    <DataSource Name="DataSource">
      <ConnectionProperties>
        <DataProvider>SQL</DataProvider>
        <ConnectString />
      </ConnectionProperties>
      <rd:SecurityType>None</rd:SecurityType>
      <rd:DataSourceID>7fb8c033-c2f8-4e9c-8e86-1859968dd7fc</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="DocType_PurchHead">
          <DataField>DocType_PurchHead</DataField>
        </Field>
        <Field Name="PurchHeadNo">
          <DataField>PurchHeadNo</DataField>
        </Field>
        <Field Name="CompanyInfoPhoneNoCap">
          <DataField>CompanyInfoPhoneNoCap</DataField>
        </Field>
        <Field Name="CompanyInfoVATRegNoCap">
          <DataField>CompanyInfoVATRegNoCap</DataField>
        </Field>
        <Field Name="CompanyInfoGiroNoCap">
          <DataField>CompanyInfoGiroNoCap</DataField>
        </Field>
        <Field Name="CompanyInfoBankNameCap">
          <DataField>CompanyInfoBankNameCap</DataField>
        </Field>
        <Field Name="CompInfoBankAccNoCap">
          <DataField>CompInfoBankAccNoCap</DataField>
        </Field>
        <Field Name="DocumentDateCap">
          <DataField>DocumentDateCap</DataField>
        </Field>
        <Field Name="PageNoCaption">
          <DataField>PageNoCaption</DataField>
        </Field>
        <Field Name="ShipmentMethodDescCap">
          <DataField>ShipmentMethodDescCap</DataField>
        </Field>
        <Field Name="PurchLineVendItemNoCap">
          <DataField>PurchLineVendItemNoCap</DataField>
        </Field>
        <Field Name="PurchaseLineDescCap">
          <DataField>PurchaseLineDescCap</DataField>
        </Field>
        <Field Name="PurchaseLineQuantityCap">
          <DataField>PurchaseLineQuantityCap</DataField>
        </Field>
        <Field Name="PurchaseLineUOMCaption">
          <DataField>PurchaseLineUOMCaption</DataField>
        </Field>
        <Field Name="PurchaseLineNoCaption">
          <DataField>PurchaseLineNoCaption</DataField>
        </Field>
        <Field Name="PurchaserTextCaption">
          <DataField>PurchaserTextCaption</DataField>
        </Field>
        <Field Name="ReferenceTextCaption">
          <DataField>ReferenceTextCaption</DataField>
        </Field>
        <Field Name="HomePageCaption">
          <DataField>HomePageCaption</DataField>
        </Field>
        <Field Name="EMailCaption">
          <DataField>EMailCaption</DataField>
        </Field>
        <Field Name="VatRegistrationNoCaption">
          <DataField>VatRegistrationNoCaption</DataField>
        </Field>
        <Field Name="PurchaseQuoteCopyText">
          <DataField>PurchaseQuoteCopyText</DataField>
        </Field>
        <Field Name="VendAddr1">
          <DataField>VendAddr1</DataField>
        </Field>
        <Field Name="CompanyAddr1">
          <DataField>CompanyAddr1</DataField>
        </Field>
        <Field Name="VendAddr2">
          <DataField>VendAddr2</DataField>
        </Field>
        <Field Name="CompanyAddr2">
          <DataField>CompanyAddr2</DataField>
        </Field>
        <Field Name="VendAddr3">
          <DataField>VendAddr3</DataField>
        </Field>
        <Field Name="CompanyAddr3">
          <DataField>CompanyAddr3</DataField>
        </Field>
        <Field Name="VendAddr4">
          <DataField>VendAddr4</DataField>
        </Field>
        <Field Name="CompanyAddr4">
          <DataField>CompanyAddr4</DataField>
        </Field>
        <Field Name="VendAddr5">
          <DataField>VendAddr5</DataField>
        </Field>
        <Field Name="CompanyInfoPhoneNo">
          <DataField>CompanyInfoPhoneNo</DataField>
        </Field>
        <Field Name="VendAddr6">
          <DataField>VendAddr6</DataField>
        </Field>
        <Field Name="CompanyInfoVatRegNo">
          <DataField>CompanyInfoVatRegNo</DataField>
        </Field>
        <Field Name="CompanyInfoGiroNo">
          <DataField>CompanyInfoGiroNo</DataField>
        </Field>
        <Field Name="CompanyInfoBankName">
          <DataField>CompanyInfoBankName</DataField>
        </Field>
        <Field Name="CompanyInfoBankAccNo">
          <DataField>CompanyInfoBankAccNo</DataField>
        </Field>
        <Field Name="CompanyInfoHomePage">
          <DataField>CompanyInfoHomePage</DataField>
        </Field>
        <Field Name="CompanyInfoEMail">
          <DataField>CompanyInfoEMail</DataField>
        </Field>
        <Field Name="PaytoVendNo_PurchHdr">
          <DataField>PaytoVendNo_PurchHdr</DataField>
        </Field>
        <Field Name="DocDate_PurchHdr">
          <DataField>DocDate_PurchHdr</DataField>
        </Field>
        <Field Name="VatNoText">
          <DataField>VatNoText</DataField>
        </Field>
        <Field Name="VatTRegNo_PurchHdr">
          <DataField>VatTRegNo_PurchHdr</DataField>
        </Field>
        <Field Name="ExpctRecpDt_PurchHdr">
          <DataField>ExpctRecpDt_PurchHdr</DataField>
        </Field>
        <Field Name="PurchaserText">
          <DataField>PurchaserText</DataField>
        </Field>
        <Field Name="SalesPurchPersonName">
          <DataField>SalesPurchPersonName</DataField>
        </Field>
        <Field Name="No1_PurchaseHdr">
          <DataField>No1_PurchaseHdr</DataField>
        </Field>
        <Field Name="ReferenceText">
          <DataField>ReferenceText</DataField>
        </Field>
        <Field Name="YourRef_PurchHdr">
          <DataField>YourRef_PurchHdr</DataField>
        </Field>
        <Field Name="VendAddr7">
          <DataField>VendAddr7</DataField>
        </Field>
        <Field Name="VendAddr8">
          <DataField>VendAddr8</DataField>
        </Field>
        <Field Name="CompanyAddr5">
          <DataField>CompanyAddr5</DataField>
        </Field>
        <Field Name="CompanyAddr6">
          <DataField>CompanyAddr6</DataField>
        </Field>
        <Field Name="ShipMethodDesc">
          <DataField>ShipMethodDesc</DataField>
        </Field>
        <Field Name="OutpuNo">
          <DataField>OutpuNo</DataField>
        </Field>
        <Field Name="BuyfromVendNo_PurchHdr">
          <DataField>BuyfromVendNo_PurchHdr</DataField>
        </Field>
        <Field Name="ExpectedDateCaption">
          <DataField>ExpectedDateCaption</DataField>
        </Field>
        <Field Name="QuoteNoCaption">
          <DataField>QuoteNoCaption</DataField>
        </Field>
        <Field Name="PaytoVendNo_PurchHdrCaption">
          <DataField>PaytoVendNo_PurchHdrCaption</DataField>
        </Field>
        <Field Name="BuyfromVendNo_PurchHdrCaption">
          <DataField>BuyfromVendNo_PurchHdrCaption</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="Number_DimensionLoop1">
          <DataField>Number_DimensionLoop1</DataField>
        </Field>
        <Field Name="HeaderDimensionsCaption">
          <DataField>HeaderDimensionsCaption</DataField>
        </Field>
        <Field Name="ShowInternalInfo">
          <DataField>ShowInternalInfo</DataField>
        </Field>
        <Field Name="ArchiveDocument">
          <DataField>ArchiveDocument</DataField>
        </Field>
        <Field Name="LogInteraction">
          <DataField>LogInteraction</DataField>
        </Field>
        <Field Name="Type_PurchaseLine">
          <DataField>Type_PurchaseLine</DataField>
        </Field>
        <Field Name="LineNo_PurchaseLine">
          <DataField>LineNo_PurchaseLine</DataField>
        </Field>
        <Field Name="Description_PurchaseLine">
          <DataField>Description_PurchaseLine</DataField>
        </Field>
        <Field Name="Quantity_PurchaseLine">
          <DataField>Quantity_PurchaseLine</DataField>
        </Field>
        <Field Name="Quantity_PurchaseLineFormat">
          <DataField>Quantity_PurchaseLineFormat</DataField>
        </Field>
        <Field Name="UnitOfMeasure_PurchaseLine">
          <DataField>UnitOfMeasure_PurchaseLine</DataField>
        </Field>
        <Field Name="ExpcRecpDt_PurchHdr">
          <DataField>ExpcRecpDt_PurchHdr</DataField>
        </Field>
        <Field Name="No_PurchaseLine">
          <DataField>No_PurchaseLine</DataField>
        </Field>
        <Field Name="VendItemNo_PurchLine">
          <DataField>VendItemNo_PurchLine</DataField>
        </Field>
        <Field Name="PurchaseLineNoOurNoCap">
          <DataField>PurchaseLineNoOurNoCap</DataField>
        </Field>
        <Field Name="DimText1">
          <DataField>DimText1</DataField>
        </Field>
        <Field Name="Number2_DimensionLoop">
          <DataField>Number2_DimensionLoop</DataField>
        </Field>
        <Field Name="LineDimensionsCaption">
          <DataField>LineDimensionsCaption</DataField>
        </Field>
        <Field Name="SelltoCustNo_PurchHdr">
          <DataField>SelltoCustNo_PurchHdr</DataField>
        </Field>
        <Field Name="ShipToAddr1">
          <DataField>ShipToAddr1</DataField>
        </Field>
        <Field Name="ShipToAddr2">
          <DataField>ShipToAddr2</DataField>
        </Field>
        <Field Name="ShipToAddr3">
          <DataField>ShipToAddr3</DataField>
        </Field>
        <Field Name="ShipToAddr4">
          <DataField>ShipToAddr4</DataField>
        </Field>
        <Field Name="ShipToAddr5">
          <DataField>ShipToAddr5</DataField>
        </Field>
        <Field Name="ShipToAddr6">
          <DataField>ShipToAddr6</DataField>
        </Field>
        <Field Name="ShipToAddr7">
          <DataField>ShipToAddr7</DataField>
        </Field>
        <Field Name="ShipToAddr8">
          <DataField>ShipToAddr8</DataField>
        </Field>
        <Field Name="ShiptoAddressCaption">
          <DataField>ShiptoAddressCaption</DataField>
        </Field>
      </Fields>
      <rd:DataSetInfo>
        <rd:DataSetName>DataSet</rd:DataSetName>
        <rd:SchemaPath>Report.xsd</rd:SchemaPath>
        <rd:TableName>Result</rd:TableName>
      </rd:DataSetInfo>
    </DataSet>
  </DataSets>
  <ReportSections>
    <ReportSection>
      <Body>
        <ReportItems>
          <Tablix Name="list1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>7.15442in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>2.69236in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1Contents">
                          <ReportItems>
                            <Tablix Name="TblPurchLine">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.86723in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.86723in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.93279in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.77874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.59124in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.1172in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PurchLineVendItemNoCap.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox6">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PurchaseLineNoCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox6</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox30">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PurchaseLineDescCap.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox30</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox32">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PurchaseLineQuantityCap.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox32</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox33">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PurchaseLineUOMCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox33</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox35">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!ExpectedDateCaption.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox35</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox47">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox47</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>6</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox36">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox36</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>6</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox28">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox28</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox57">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_PurchaseLine.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox34">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VendItemNo_PurchLine.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>10</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!Type_PurchaseLine.Value="1" and Fields!ShowInternalInfo.Value="FALSE",TRUE,FALSE)</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox38">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_PurchaseLine.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Normal</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>9</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF((Fields!Type_PurchaseLine.Value="1" AND Fields!ShowInternalInfo.Value="FALSE") OR (Fields!Type_PurchaseLine.Value="0"),TRUE,FALSE)</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox39">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_PurchaseLine.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox40">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Quantity_PurchaseLine.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox41">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitOfMeasure_PurchaseLine.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox42">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ExpcRecpDt_PurchHdr.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!Type_PurchaseLine.Value="0",TRUE,FALSE)</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox27">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineDimensionsCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox27</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!Number2_DimensionLoop.Value=1,False,True)</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox3">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText1.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox3</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="Table1_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!PurchHeadNo.Value</GroupExpression>
                                        <GroupExpression>=Fields!LineNo_PurchaseLine.Value</GroupExpression>
                                        <GroupExpression>=Fields!OutpuNo.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="LineNoGroup">
                                          <GroupExpressions>
                                            <GroupExpression>=Fields!No_PurchaseLine.Value</GroupExpression>
                                          </GroupExpressions>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=Iif(Fields!Type_PurchaseLine.Value = "0", false, true)</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <RepeatOnNewPage>true</RepeatOnNewPage>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!Description_PurchaseLine.Value="" OR Fields!Type_PurchaseLine.Value="0",TRUE,FALSE)</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <RepeatOnNewPage>true</RepeatOnNewPage>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Group Name="Table1_Details_Group">
                                              <DataElementName>Detail</DataElementName>
                                            </Group>
                                            <TablixMembers>
                                              <TablixMember>
                                                <Visibility>
                                                  <Hidden>=IIF(Fields!LineDimensionsCaption.Value="" OR Fields!ShowInternalInfo.Value="FALSE",TRUE,FALSE)</Hidden>
                                                </Visibility>
                                              </TablixMember>
                                            </TablixMembers>
                                            <DataElementName>Detail_Collection</DataElementName>
                                            <DataElementOutput>Output</DataElementOutput>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                        </TablixMembers>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!PurchaseLineDescCap.Value</FilterExpression>
                                  <Operator>NotEqual</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Height>1.76388cm</Height>
                              <Width>7.15443in</Width>
                              <Style />
                            </Tablix>
                            <Tablix Name="TblShipToAddr">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>7.15441in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox9">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!ShiptoAddressCaption.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox9</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox12">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr1.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox12</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox10">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr2.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox10</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox11">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr3.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox11</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox13">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr4.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox13</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox16">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr5.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox16</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox17">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr6.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox17</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox18">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr7.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox18</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox19">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr8.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox19</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table3_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!ShipToAddr1.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>2.56822cm</Top>
                              <Height>1.25001in</Height>
                              <Width>18.1722cm</Width>
                              <ZIndex>1</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="TblHeadDim">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.64729in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>5.50712in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox20">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!HeaderDimensionsCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>1</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!Number_DimensionLoop1.Value=1,False,True)</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox21">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <Group Name="table5_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!HeaderDimensionsCaption.Value="",TRUE,FALSE)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Top>6.48054cm</Top>
                              <Height>0.35278cm</Height>
                              <Width>18.1722cm</Width>
                              <ZIndex>2</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="tblCompAddr">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.53125in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.08333in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.15625in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyAddr">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Cstr(Fields!CompanyAddr1.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr2.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr3.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr4.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr5.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr6.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoPhoneNo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoEMail.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoVatRegNo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoGiroNo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankName.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankAccNo.Value) + Chr(177) + 
Cstr(Fields!PaytoVendNo_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!DocDate_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!VatNoText.Value) + Chr(177) + 
Cstr(Fields!VatTRegNo_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!No1_PurchaseHdr.Value) + Chr(177) + 
Cstr(Fields!PurchaserText.Value) + Chr(177) + 
Cstr(Fields!SalesPurchPersonName.Value) + Chr(177) + 
Cstr(Fields!ExpctRecpDt_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!ReferenceText.Value) + Chr(177) + 
Cstr(Fields!YourRef_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!PurchaseQuoteCopyText.Value) + Chr(177) + 
Cstr(Fields!VendAddr1.Value) + Chr(177) + 
Cstr(Fields!VendAddr2.Value) + Chr(177) + 
Cstr(Fields!VendAddr3.Value) + Chr(177) + 
Cstr(Fields!VendAddr4.Value) + Chr(177) + 
Cstr(Fields!VendAddr5.Value) + Chr(177) + 
Cstr(Fields!VendAddr6.Value) + Chr(177) + 
Cstr(Fields!VendAddr7.Value) + Chr(177) + 
Cstr(Fields!VendAddr8.Value) + Chr(177) + 
Cstr(Fields!ShipMethodDesc.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoHomePage.Value) + Chr(177) + 
Cstr(Fields!PaytoVendNo_PurchHdrCaption.Value) + Chr(177) + 
Cstr(Fields!PageNoCaption.Value) + Chr(177) + 
Cstr(Fields!ShipmentMethodDescCap.Value) + Chr(177) + 
Cstr(Fields!CompInfoBankAccNoCap.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankNameCap.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoGiroNoCap.Value) + Chr(177) + 
Cstr(Fields!VatRegistrationNoCaption.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoPhoneNoCap.Value) + Chr(177) + 
Cstr(Fields!ReferenceTextCaption.Value) + Chr(177) + 
Cstr(Fields!PurchaserTextCaption.Value) + Chr(177) + 
Cstr(Fields!QuoteNoCaption.Value) + Chr(177) + 
Cstr(Fields!ExpectedDateCaption.Value) + Chr(177) + 
Cstr(Fields!DocumentDateCap.Value) + Chr(177) + 
Cstr(Fields!HomePageCaption.Value) + Chr(177) + 
Cstr(Fields!EMailCaption.Value) + Chr(177) + 
Cstr(Fields!BuyfromVendNo_PurchHdrCaption.Value) + Chr(177) + 
Cstr(Fields!BuyfromVendNo_PurchHdr.Value)
, 1)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="NewPage">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=IIF(Code.IsNewPage(Fields!PurchHeadNo.Value,Fields!OutpuNo.Value),TRUE,FALSE)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Height>0.39688cm</Height>
                              <Width>1.56103cm</Width>
                              <ZIndex>3</ZIndex>
                              <Visibility>
                                <Hidden>true</Hidden>
                              </Visibility>
                              <Style />
                            </Tablix>
                          </ReportItems>
                          <KeepTogether>true</KeepTogether>
                          <Style />
                        </Rectangle>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
              </TablixRows>
            </TablixBody>
            <TablixColumnHierarchy>
              <TablixMembers>
                <TablixMember />
              </TablixMembers>
            </TablixColumnHierarchy>
            <TablixRowHierarchy>
              <TablixMembers>
                <TablixMember>
                  <Group Name="list1_Details_Group">
                    <GroupExpressions>
                      <GroupExpression>=Fields!DocType_PurchHead.Value</GroupExpression>
                      <GroupExpression>=Fields!PurchHeadNo.Value</GroupExpression>
                      <GroupExpression>=Fields!OutpuNo.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <SortExpressions>
                    <SortExpression>
                      <Value>=Fields!PurchHeadNo.Value</Value>
                    </SortExpression>
                    <SortExpression>
                      <Value>=Fields!DocType_PurchHead.Value</Value>
                    </SortExpression>
                  </SortExpressions>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <PageBreak>
              <BreakLocation>End</BreakLocation>
            </PageBreak>
            <Height>6.83859cm</Height>
            <Width>18.17223cm</Width>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>6.83859cm</Height>
        <Style />
      </Body>
      <Width>18.17223cm</Width>
      <Page>
        <PageHeader>
          <Height>7.61154cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="PurchHeadPaytoVendNoCap1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(34,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>111.59999pt</Top>
              <Height>11pt</Height>
              <Width>3.15771cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VendAddr8">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(31,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>90.69999pt</Top>
              <Height>11pt</Height>
              <Width>11.82097cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VendAddr7">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(30,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>80.69999pt</Top>
              <Height>11pt</Height>
              <Width>11.82097cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchHeaderPaytoVendNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(13,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>110.99998pt</Top>
              <Left>3.29883cm</Left>
              <Height>11pt</Height>
              <Width>8.52199cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VendAddr6">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(29,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>70.69999pt</Top>
              <Height>11pt</Height>
              <Width>11.82097cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VendAddr5">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(28,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>60.69999pt</Top>
              <Height>11pt</Height>
              <Width>11.82097cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VendAddr4">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(27,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>50.69999pt</Top>
              <Height>11pt</Height>
              <Width>11.82097cm</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VendAddr3">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(26,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>40.69999pt</Top>
              <Height>11pt</Height>
              <Width>11.82097cm</Width>
              <ZIndex>7</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VendAddr2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(25,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>30.69999pt</Top>
              <Height>11pt</Height>
              <Width>11.82097cm</Width>
              <ZIndex>8</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VendAddr1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(24,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.73025cm</Top>
              <Height>11pt</Height>
              <Width>11.82097cm</Width>
              <ZIndex>9</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SubStrNTxt002CopyTxt1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(23,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>14pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>11.82097cm</Left>
              <Height>20pt</Height>
              <Width>6.35125cm</Width>
              <ZIndex>10</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PageNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(35,1) &amp; " " &amp; Code.GetGroupPageNumber(ReportItems!NewPage.Value,Globals!PageNumber)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>20pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>6.35125cm</Width>
              <ZIndex>11</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipmentMthd">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(36,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>183.29997pt</Top>
              <Height>11pt</Height>
              <Width>3.15771cm</Width>
              <ZIndex>13</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipmentMethodVal">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(32,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>183.29997pt</Top>
              <Left>3.29883cm</Left>
              <Height>11pt</Height>
              <Width>8.52214cm</Width>
              <ZIndex>14</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr6">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(6,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>90pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>6.35125cm</Width>
              <ZIndex>15</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr5">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(5,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>80pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>6.35125cm</Width>
              <ZIndex>16</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr4">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(4,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>70pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>6.35125cm</Width>
              <ZIndex>17</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr3">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(3,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>60pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>6.35125cm</Width>
              <ZIndex>18</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(2,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>50pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>6.35125cm</Width>
              <ZIndex>19</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(1,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Normal</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>40pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>6.35125cm</Width>
              <ZIndex>20</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompInfoBankAccNoCap1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(37,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>163.40009pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>3.02437cm</Width>
              <ZIndex>21</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankNameCap1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(38,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>153.40009pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>3.02437cm</Width>
              <ZIndex>22</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoGiroNoCap1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(39,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>143.40009pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>3.02437cm</Width>
              <ZIndex>23</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoVATRegNoCap1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(40,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>133.40009pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>3.02437cm</Width>
              <ZIndex>24</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompInfoPhoneNoCap1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(41,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>100pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>3.02437cm</Width>
              <ZIndex>25</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankAccNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(12,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>163.40009pt</Top>
              <Left>14.84534cm</Left>
              <Height>11pt</Height>
              <Width>3.32688cm</Width>
              <ZIndex>26</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankName1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(11,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>153.40009pt</Top>
              <Left>14.84534cm</Left>
              <Height>11pt</Height>
              <Width>3.32688cm</Width>
              <ZIndex>27</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoGiroNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(10,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>143.40009pt</Top>
              <Left>14.84534cm</Left>
              <Height>11pt</Height>
              <Width>3.32688cm</Width>
              <ZIndex>28</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoVATRegNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(9,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>133.40009pt</Top>
              <Left>14.84534cm</Left>
              <Height>11pt</Height>
              <Width>3.32688cm</Width>
              <ZIndex>29</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoPhoneNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(7,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>100pt</Top>
              <Left>14.84534cm</Left>
              <Height>11pt</Height>
              <Width>3.32688cm</Width>
              <ZIndex>30</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaseHeaderYourRef1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(22,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>121.59999pt</Top>
              <Left>3.29883cm</Left>
              <Height>11pt</Height>
              <Width>8.52199cm</Width>
              <ZIndex>31</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ReferenceText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(42,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>121.59999pt</Top>
              <Left>0.00006cm</Left>
              <Height>11pt</Height>
              <Width>3.15765cm</Width>
              <ZIndex>32</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesPurchPersonName1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(19,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>173.40009pt</Top>
              <Left>14.84534cm</Left>
              <Height>11pt</Height>
              <Width>3.32688cm</Width>
              <ZIndex>33</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaserText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(43,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>173.40009pt</Top>
              <Left>11.82097cm</Left>
              <Height>11pt</Height>
              <Width>3.02437cm</Width>
              <ZIndex>34</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaseHeaderVATRegNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(16,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>131.60004pt</Top>
              <Left>3.29883cm</Left>
              <Height>11pt</Height>
              <Width>8.52199cm</Width>
              <ZIndex>35</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VATNoText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(15,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>131.60004pt</Top>
              <Height>11pt</Height>
              <Width>3.15765cm</Width>
              <ZIndex>36</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="QuoteNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(44,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>142.50003pt</Top>
              <Height>11pt</Height>
              <Width>3.15771cm</Width>
              <ZIndex>37</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ExpectedDateCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(45,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>173.29997pt</Top>
              <Height>11pt</Height>
              <Width>3.15771cm</Width>
              <ZIndex>38</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaseHeaderNo11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(17,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>142.50003pt</Top>
              <Left>3.29883cm</Left>
              <Height>11pt</Height>
              <Width>8.52214cm</Width>
              <ZIndex>39</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchHeaderExpecRecpDt1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(20,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>173.29997pt</Top>
              <Left>3.29883cm</Left>
              <Height>11pt</Height>
              <Width>8.52198cm</Width>
              <ZIndex>40</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ExecutionTimeTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(14,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Format>D</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>152.50003pt</Top>
              <Left>3.29883cm</Left>
              <Height>11pt</Height>
              <Width>8.52214cm</Width>
              <ZIndex>41</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompInfoBankAccNoCap2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(46,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>152.50003pt</Top>
              <Left>0.00006in</Left>
              <Height>11pt</Height>
              <Width>3.15756cm</Width>
              <ZIndex>42</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompInfoHomePageCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(47,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>110.99998pt</Top>
              <Left>11.82095cm</Left>
              <Height>11pt</Height>
              <Width>3.02437cm</Width>
              <ZIndex>43</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoHomePageValue">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(33,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>110.99998pt</Top>
              <Left>14.84534cm</Left>
              <Height>11pt</Height>
              <Width>3.32686cm</Width>
              <ZIndex>44</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompInfoEMailCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(48,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>122.30003pt</Top>
              <Left>11.82095cm</Left>
              <Height>11pt</Height>
              <Width>3.02437cm</Width>
              <ZIndex>45</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoEMailValue">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(8,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>122.30003pt</Top>
              <Left>14.84534cm</Left>
              <Height>11pt</Height>
              <Width>3.32686cm</Width>
              <ZIndex>46</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Textbox2">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(49,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <rd:DefaultName>Textbox2</rd:DefaultName>
              <Top>2.27375in</Top>
              <Height>11pt</Height>
              <Width>1.24319in</Width>
              <ZIndex>47</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
            <Textbox Name="Textbox4">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(50,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <rd:DefaultName>Textbox4</rd:DefaultName>
              <Top>2.2675in</Top>
              <Left>1.29875in</Left>
              <Height>11pt</Height>
              <Width>3.35518in</Width>
              <ZIndex>48</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
          </ReportItems>
          <Style />
        </PageHeader>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.76388cm</LeftMargin>
        <RightMargin>1.05834cm</RightMargin>
        <TopMargin>1.05834cm</TopMargin>
        <BottomMargin>1.48166cm</BottomMargin>
        <ColumnSpacing>1.27cm</ColumnSpacing>
        <Style />
      </Page>
    </ReportSection>
  </ReportSections>
  <Code>Public Function BlankZero(ByVal Value As Decimal)
    if Value = 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankPos(ByVal Value As Decimal)
    if Value &gt; 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankZeroAndPos(ByVal Value As Decimal)
    if Value &gt;= 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankNeg(ByVal Value As Decimal)
    if Value &lt; 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankNegAndZero(ByVal Value As Decimal)
    if Value &lt;= 0 then
        Return ""
    end if
    Return Value
End Function

Shared offset as Integer
Shared newPage as Object
Shared currentgroup1 as Object
Shared currentgroup2 as Object
Public Function GetGroupPageNumber(NewPage as Boolean, pagenumber as Integer) as Object
  If NewPage
    offset = pagenumber - 1
 End If
  Return pagenumber - offset
End Function

Public Function IsNewPage(group1 as Object, group2 as Object) As Boolean
newPage = FALSE
If Not (group1 = currentgroup1)
   NewPage = TRUE
   currentgroup2 = group2
   currentgroup1 = group1
ELSE
   If Not (group2 = currentgroup2)
      NewPage = TRUE
      currentgroup2 = group2
   End If
End If
Return NewPage
End Function

Shared Data1 as Object
Shared Data2 as Object

Public Function GetData(Num as Integer, Group as integer) as Object
if Group = 1 then
   Return Cstr(Choose(Num, Split(Cstr(Data1),Chr(177))))
End If

if Group = 2 then
   Return Cstr(Choose(Num, Split(Cstr(Data2),Chr(177))))
End If

End Function

Public Function SetData(NewData as Object,Group as integer)
  If Group = 1 and NewData &lt;&gt; "" Then
      Data1 = NewData
  End If

  If Group = 2 and NewData &lt;&gt; "" Then
      Data2 = NewData
  End If
  Return True
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>c4afa498-814a-4395-9fb2-deb68599db1c</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

