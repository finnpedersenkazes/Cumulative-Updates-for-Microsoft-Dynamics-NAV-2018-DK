OBJECT Report 5913 Service - Shipment
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Service - leverance;
               ENU=Service - Shipment];
    OnInitReport=BEGIN
                   CompanyInfo.GET;
                   ServiceSetup.GET;
                   FormatDocument.SetLogoPosition(ServiceSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
                 END;

  }
  DATASET
  {
    { 2735;    ;DataItem;                    ;
               DataItemTable=Table5990;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Bogf�rt serviceleverance;
                                   ENU=Posted Service Shipment];
               OnAfterGetRecord=BEGIN
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  FormatAddressFields("Service Shipment Header");
                                  FormatDocumentFields("Service Shipment Header");
                                END;

               ReqFilterFields=No.,Customer No.,No. Printed }

    { 128 ;1   ;Column  ;No_ServiceShptHrd   ;
               SourceExpr="No." }

    { 26  ;1   ;Column  ;DocumentDate        ;
               SourceExpr=DocumentDateLbl }

    { 35  ;1   ;Column  ;EmailIdCaption      ;
               SourceExpr=EmailIdCaptionLbl }

    { 37  ;1   ;Column  ;HomePageCaption     ;
               SourceExpr=HomePageCaptionLbl }

    { 40  ;1   ;Column  ;SrvcShipHeaderCustNoCaption;
               SourceExpr=SrvcShipHeaderCustNoCaptionLbl }

    { 16  ;1   ;Column  ;WarrantyCaption     ;
               SourceExpr=WarrantyCaptionLbl }

    { 5701;1   ;DataItem;CopyLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               NoOfLoops := 1 + ABS(NoOfCopies);
                               CopyText := '';
                               SETRANGE(Number,1,NoOfLoops);
                               OutputNo := 1;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number > 1 THEN BEGIN
                                    CopyText := FormatDocument.GetCOPYText;
                                    OutputNo += 1;
                                  END;
                                  CurrReport.PAGENO := 1;
                                  TotalQty := 0;           // Item Tracking
                                END;

               OnPostDataItem=BEGIN
                                IF NOT IsReportInPreviewMode THEN
                                  CODEUNIT.RUN(CODEUNIT::"Service Shpt.-Printed","Service Shipment Header");
                              END;
                               }

    { 6455;2   ;DataItem;PageLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               // Item Tracking:
                               IF ShowLotSN THEN BEGIN
                                 TrackingSpecCount := 0;
                                 OldRefNo := 0;
                                 ShowGroup := FALSE;
                               END;
                             END;
                              }

    { 75  ;3   ;Column  ;CompanyInfo2Picture ;
               SourceExpr=CompanyInfo2.Picture }

    { 74  ;3   ;Column  ;CompanyInfo1Picture ;
               SourceExpr=CompanyInfo1.Picture }

    { 54  ;3   ;Column  ;CompanyInfo3Picture ;
               SourceExpr=CompanyInfo3.Picture }

    { 1   ;3   ;Column  ;ServiceShptCopyText ;
               SourceExpr=STRSUBSTNO(Text002,CopyText) }

    { 2   ;3   ;Column  ;CurrReportPageNo    ;
               SourceExpr=STRSUBSTNO(Text003,FORMAT(CurrReport.PAGENO)) }

    { 4   ;3   ;Column  ;ShipToAddr1         ;
               SourceExpr=ShipToAddr[1] }

    { 5   ;3   ;Column  ;CompanyAddr1        ;
               SourceExpr=CompanyAddr[1] }

    { 6   ;3   ;Column  ;ShipToAddr2         ;
               SourceExpr=ShipToAddr[2] }

    { 7   ;3   ;Column  ;CompanyAddr2        ;
               SourceExpr=CompanyAddr[2] }

    { 8   ;3   ;Column  ;ShipToAddr3         ;
               SourceExpr=ShipToAddr[3] }

    { 9   ;3   ;Column  ;CompanyAddr3        ;
               SourceExpr=CompanyAddr[3] }

    { 10  ;3   ;Column  ;ShipToAddr4         ;
               SourceExpr=ShipToAddr[4] }

    { 11  ;3   ;Column  ;CompanyAddr4        ;
               SourceExpr=CompanyAddr[4] }

    { 12  ;3   ;Column  ;ShipToAddr5         ;
               SourceExpr=ShipToAddr[5] }

    { 14  ;3   ;Column  ;PhoneNo_CompanyInfo ;
               SourceExpr=CompanyInfo."Phone No." }

    { 15  ;3   ;Column  ;ShipToAddr6         ;
               SourceExpr=ShipToAddr[6] }

    { 36  ;3   ;Column  ;HomePage            ;
               SourceExpr=CompanyInfo."Home Page" }

    { 38  ;3   ;Column  ;EMailId             ;
               SourceExpr=CompanyInfo."E-Mail" }

    { 19  ;3   ;Column  ;CompanyInfoVATRegnNo;
               SourceExpr=CompanyInfo."VAT Registration No." }

    { 21  ;3   ;Column  ;CompanyInfoGiroNo   ;
               SourceExpr=CompanyInfo."Giro No." }

    { 23  ;3   ;Column  ;CompanyInfoBankName ;
               SourceExpr=CompanyInfo."Bank Name" }

    { 25  ;3   ;Column  ;CompanyInfoBankAccNo;
               SourceExpr=CompanyInfo."Bank Account No." }

    { 27  ;3   ;Column  ;CustNo_ServShptHrd  ;
               SourceExpr="Service Shipment Header"."Customer No." }

    { 28  ;3   ;Column  ;ServShptHrdDocDt    ;
               SourceExpr=FORMAT("Service Shipment Header"."Document Date") }

    { 29  ;3   ;Column  ;SalesPersonText     ;
               SourceExpr=SalesPersonText }

    { 30  ;3   ;Column  ;SalesPurchPersonName;
               SourceExpr=SalesPurchPerson.Name }

    { 32  ;3   ;Column  ;No1_ServiceShptHrd  ;
               SourceExpr="Service Shipment Header"."No." }

    { 33  ;3   ;Column  ;ReferenceText       ;
               SourceExpr=ReferenceText }

    { 34  ;3   ;Column  ;YourRef_ServShptHrd ;
               SourceExpr="Service Shipment Header"."Your Reference" }

    { 3   ;3   ;Column  ;ShipToAddr7         ;
               SourceExpr=ShipToAddr[7] }

    { 64  ;3   ;Column  ;ShipToAddr8         ;
               SourceExpr=ShipToAddr[8] }

    { 65  ;3   ;Column  ;CompanyAddr5        ;
               SourceExpr=CompanyAddr[5] }

    { 66  ;3   ;Column  ;CompanyAddr6        ;
               SourceExpr=CompanyAddr[6] }

    { 99  ;3   ;Column  ;PostingDate_ServShptHrd;
               SourceExpr=FORMAT("Service Shipment Header"."Posting Date") }

    { 43  ;3   ;Column  ;PageCaption         ;
               SourceExpr=STRSUBSTNO(Text003,'') }

    { 17  ;3   ;Column  ;OutputNo            ;
               SourceExpr=OutputNo }

    { 96  ;3   ;Column  ;ItemTrackingAppendixCaption;
               SourceExpr=ItemTrackingAppendixCaptionLbl }

    { 13  ;3   ;Column  ;PhoneNoCaption      ;
               SourceExpr=PhoneNoCaptionLbl }

    { 18  ;3   ;Column  ;VATRegNoCaption     ;
               SourceExpr=VATRegNoCaptionLbl }

    { 20  ;3   ;Column  ;GiroNoCaption       ;
               SourceExpr=GiroNoCaptionLbl }

    { 22  ;3   ;Column  ;BankNameCaption     ;
               SourceExpr=BankNameCaptionLbl }

    { 24  ;3   ;Column  ;BankAccNoCaption    ;
               SourceExpr=BankAccNoCaptionLbl }

    { 31  ;3   ;Column  ;ServiceShpHdrNoCaption;
               SourceExpr=ServiceShpHdrNoCaptionLbl }

    { 100 ;3   ;Column  ;ServiceShpHdrPostingDateCaption;
               SourceExpr=ServiceShpHdrPostingDateCaptionLbl }

    { 70  ;3   ;Column  ;CustNo_ServShptHrdCaption;
               SourceExpr="Service Shipment Header".FIELDCAPTION("Customer No.") }

    { 7574;3   ;DataItem;DimensionLoop1      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF NOT ShowInternalInfo THEN
                                 CurrReport.BREAK;
                               FindDimTxt("Service Shipment Header"."Dimension Set ID");
                               SETRANGE(Number,1,DimTxtArrLength);
                             END;

               OnAfterGetRecord=BEGIN
                                  DimText := DimTxtArr[Number];
                                END;

               DataItemLinkReference=Service Shipment Header }

    { 51  ;4   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 44  ;4   ;Column  ;DimensionLoop1Number;
               SourceExpr=Number }

    { 52  ;4   ;Column  ;HdrDimsCaption      ;
               SourceExpr=HdrDimsCaptionLbl }

    { 2078;3   ;DataItem;                    ;
               DataItemTable=Table5989;
               DataItemTableView=SORTING(No.,Line No.);
               DataItemLinkReference=Service Shipment Header;
               DataItemLink=No.=FIELD(No.) }

    { 86  ;4   ;Column  ;ContractNo_ServShptItemLn;
               SourceExpr="Contract No." }

    { 82  ;4   ;Column  ;Des_ServShptItemLn  ;
               SourceExpr=Description }

    { 80  ;4   ;Column  ;SerialNo_ServShptItemLn;
               SourceExpr="Serial No." }

    { 78  ;4   ;Column  ;ItemNo_ServShptItemLn;
               SourceExpr="Item No." }

    { 76  ;4   ;Column  ;ItemGrpCode_ServShptLn;
               SourceExpr="Service Item Group Code" }

    { 69  ;4   ;Column  ;ServItemNo_ServShptItemLn;
               SourceExpr="Service Item No." }

    { 45  ;4   ;Column  ;Warranty            ;
               SourceExpr=FORMAT(Warranty) }

    { 131 ;4   ;Column  ;LnNo_ServShptItemLn ;
               SourceExpr="Line No." }

    { 88  ;4   ;Column  ;SrvcShpItemLineCaption;
               SourceExpr=SrvcShpItemLineCaptionLbl }

    { 71  ;4   ;Column  ;ContractNo_ServShptItemLnCaption;
               SourceExpr=FIELDCAPTION("Contract No.") }

    { 73  ;4   ;Column  ;Des_ServShptItemLnCaption;
               SourceExpr=FIELDCAPTION(Description) }

    { 77  ;4   ;Column  ;SerialNo_ServShptItemLnCaption;
               SourceExpr=FIELDCAPTION("Serial No.") }

    { 79  ;4   ;Column  ;ItemNo_ServShptItemLnCaption;
               SourceExpr=FIELDCAPTION("Item No.") }

    { 81  ;4   ;Column  ;ItemGrpCode_ServShptLnCaption;
               SourceExpr=FIELDCAPTION("Service Item Group Code") }

    { 83  ;4   ;Column  ;ServItemNo_ServShptItemLnCaption;
               SourceExpr=FIELDCAPTION("Service Item No.") }

    { 6162;3   ;DataItem;                    ;
               DataItemTable=Table5991;
               DataItemTableView=SORTING(Document No.,Line No.);
               OnPreDataItem=BEGIN
                               MoreLines := FIND('+');
                               WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) DO
                                 MoreLines := NEXT(-1) <> 0;
                               IF NOT MoreLines THEN
                                 CurrReport.BREAK;
                               SETRANGE("Line No.",0,"Line No.");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF NOT ShowCorrectionLines AND Correction THEN
                                    CurrReport.SKIP;
                                END;

               OnPostDataItem=BEGIN
                                IF ShowLotSN THEN
                                  TrackingSpecCount :=
                                    ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,
                                      "Service Shipment Header"."No.",DATABASE::"Service Shipment Header",0);
                              END;

               DataItemLinkReference=Service Shipment Header;
               DataItemLink=Document No.=FIELD(No.) }

    { 39  ;4   ;Column  ;ServShptLnDescription;
               SourceExpr=Description }

    { 48  ;4   ;Column  ;ShowInternalInfo    ;
               SourceExpr=ShowInternalInfo }

    { 47  ;4   ;Column  ;ShowCorrectionLines ;
               SourceExpr=ShowCorrectionLines }

    { 46  ;4   ;Column  ;ShowLotSN           ;
               SourceExpr=ShowLotSN }

    { 105 ;4   ;Column  ;Type_ServiceShptItemLn;
               SourceExpr=Type }

    { 41  ;4   ;Column  ;Qty_ServiceShptItemLn;
               SourceExpr=Quantity }

    { 42  ;4   ;Column  ;UnitofMeasure_ServShptLn;
               SourceExpr="Unit of Measure" }

    { 92  ;4   ;Column  ;No_ServiceShptItemLn;
               SourceExpr="No." }

    { 95  ;4   ;Column  ;QtyInvoiced_ServShptLine;
               SourceExpr="Quantity Invoiced" }

    { 98  ;4   ;Column  ;QtyConsumed_ServShptLine;
               SourceExpr="Quantity Consumed" }

    { 133 ;4   ;Column  ;LnNo_ServiceShptItemLn;
               SourceExpr="Line No." }

    { 89  ;4   ;Column  ;ServiceShpLineCaption;
               SourceExpr=ServiceShpLineCaptionLbl }

    { 93  ;4   ;Column  ;QtyInvoicedCaption  ;
               SourceExpr=QtyInvoicedCaptionLbl }

    { 94  ;4   ;Column  ;QtyConsumedCaption  ;
               SourceExpr=QtyConsumedCaptionLbl }

    { 84  ;4   ;Column  ;ServShptLnDescriptionCaption;
               SourceExpr=FIELDCAPTION(Description) }

    { 85  ;4   ;Column  ;Qty_ServiceShptItemLnCaption;
               SourceExpr=FIELDCAPTION(Quantity) }

    { 87  ;4   ;Column  ;UnitofMeasure_ServShptLnCaption;
               SourceExpr=FIELDCAPTION("Unit of Measure") }

    { 91  ;4   ;Column  ;No_ServiceShptItemLnCaption;
               SourceExpr=FIELDCAPTION("No.") }

    { 3591;4   ;DataItem;DimensionLoop2      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF NOT ShowInternalInfo THEN
                                 CurrReport.BREAK;
                               FindDimTxt("Service Shipment Line"."Dimension Set ID");
                               SETRANGE(Number,1,DimTxtArrLength);
                             END;

               OnAfterGetRecord=BEGIN
                                  DimText := DimTxtArr[Number];
                                END;
                                 }

    { 56  ;5   ;Column  ;DimText_DimLoop2    ;
               SourceExpr=DimText }

    { 49  ;5   ;Column  ;DimensionLoop2Number;
               SourceExpr=Number }

    { 72  ;5   ;Column  ;LineDimsCaption     ;
               SourceExpr=LineDimsCaptionLbl }

    { 3476;3   ;DataItem;Total               ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 3363;3   ;DataItem;Total2              ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF NOT ShowCustAddr THEN
                                 CurrReport.BREAK;
                             END;
                              }

    { 57  ;4   ;Column  ;BilltoCustNo_ServShptHrd;
               SourceExpr="Service Shipment Header"."Bill-to Customer No." }

    { 58  ;4   ;Column  ;CustAddr1           ;
               SourceExpr=CustAddr[1] }

    { 59  ;4   ;Column  ;CustAddr2           ;
               SourceExpr=CustAddr[2] }

    { 60  ;4   ;Column  ;CustAddr3           ;
               SourceExpr=CustAddr[3] }

    { 61  ;4   ;Column  ;CustAddr4           ;
               SourceExpr=CustAddr[4] }

    { 62  ;4   ;Column  ;CustAddr5           ;
               SourceExpr=CustAddr[5] }

    { 63  ;4   ;Column  ;CustAddr6           ;
               SourceExpr=CustAddr[6] }

    { 67  ;4   ;Column  ;CustAddr7           ;
               SourceExpr=CustAddr[7] }

    { 68  ;4   ;Column  ;CustAddr8           ;
               SourceExpr=CustAddr[8] }

    { 55  ;4   ;Column  ;BilltoAddrCaption   ;
               SourceExpr=BilltoAddrCaptionLbl }

    { 101 ;4   ;Column  ;BilltoCustNo_ServShptHrdCaption;
               SourceExpr="Service Shipment Header".FIELDCAPTION("Bill-to Customer No.") }

    { 6034;3   ;DataItem;ItemTrackingLine    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF TrackingSpecCount = 0 THEN
                                 CurrReport.BREAK;
                               CurrReport.NEWPAGE;
                               SETRANGE(Number,1,TrackingSpecCount);
                               TrackingSpecBuffer.SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name",
                                 "Source Prod. Order Line","Source Ref. No.");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    TrackingSpecBuffer.FINDSET
                                  ELSE
                                    TrackingSpecBuffer.NEXT;

                                  IF NOT ShowCorrectionLines AND TrackingSpecBuffer.Correction THEN
                                    CurrReport.SKIP;
                                  IF TrackingSpecBuffer.Correction THEN
                                    TrackingSpecBuffer."Quantity (Base)" := -TrackingSpecBuffer."Quantity (Base)";

                                  ShowTotal := FALSE;
                                  IF ItemTrackingAppendix.IsStartNewGroup(TrackingSpecBuffer) THEN
                                    ShowTotal := TRUE;

                                  ShowGroup := FALSE;
                                  IF (TrackingSpecBuffer."Source Ref. No." <> OldRefNo) OR
                                     (TrackingSpecBuffer."Item No." <> OldNo)
                                  THEN BEGIN
                                    OldRefNo := TrackingSpecBuffer."Source Ref. No.";
                                    OldNo := TrackingSpecBuffer."Item No.";
                                    TotalQty := 0;
                                  END ELSE
                                    ShowGroup := TRUE;
                                  TotalQty += TrackingSpecBuffer."Quantity (Base)";
                                END;
                                 }

    { 108 ;4   ;Column  ;TrackingSpecBufItemNo;
               SourceExpr=TrackingSpecBuffer."Item No." }

    { 109 ;4   ;Column  ;TrackingSpecBufDesc ;
               SourceExpr=TrackingSpecBuffer.Description }

    { 110 ;4   ;Column  ;TrackingSpecBufLotNo;
               SourceExpr=TrackingSpecBuffer."Lot No." }

    { 111 ;4   ;Column  ;TrackingSpecBufSerialNo;
               SourceExpr=TrackingSpecBuffer."Serial No." }

    { 112 ;4   ;Column  ;TrackingSpecBufQty  ;
               SourceExpr=TrackingSpecBuffer."Quantity (Base)" }

    { 53  ;4   ;Column  ;ShowTotal           ;
               SourceExpr=ShowTotal }

    { 50  ;4   ;Column  ;ShowGroup           ;
               SourceExpr=ShowGroup }

    { 97  ;4   ;Column  ;QuantityCaption     ;
               SourceExpr=QuantityCaptionLbl }

    { 115 ;4   ;Column  ;SerialNoCaption     ;
               SourceExpr=SerialNoCaptionLbl }

    { 116 ;4   ;Column  ;LotNoCaption        ;
               SourceExpr=LotNoCaptionLbl }

    { 90  ;4   ;Column  ;DescriptionCaption  ;
               SourceExpr=DescriptionCaptionLbl }

    { 3353;4   ;DataItem;TotalItemTracking   ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 114 ;5   ;Column  ;TotalQty            ;
               SourceExpr=TotalQty }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
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
                  ApplicationArea=#Service;
                  SourceExpr=NoOfCopies }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Vis interne oplysninger;
                             ENU=Show Internal Information];
                  ToolTipML=[DAN=Angiver, om den udskrevne rapport skal indeholde oplysninger, der kun er til intern brug.;
                             ENU=Specifies if you want the printed report to show information that is only for internal use.];
                  ApplicationArea=#Service;
                  SourceExpr=ShowInternalInfo }

      { 6   ;2   ;Field     ;
                  Name=Show Correction Lines;
                  CaptionML=[DAN=Vis rettelseslinjer;
                             ENU=Show Correction Lines];
                  ToolTipML=[DAN=Angiver, om rettelseslinjerne for en tilbagef�rsel af antalsposteringen vises i rapporten.;
                             ENU=Specifies if the correction lines of an undoing of quantity posting will be shown on the report.];
                  ApplicationArea=#Service;
                  SourceExpr=ShowCorrectionLines }

      { 9   ;2   ;Field     ;
                  CaptionML=[DAN=Vis appendiks til lot-/serienr.;
                             ENU=Show Lot/Serial No. Appendix];
                  ToolTipML=[DAN=Angiver, om du vil udskrive et appendiks til serviceleverancerapporten, som viser lot- og serienumrene i leverancen.;
                             ENU=Specifies if you want to print an appendix to the service shipment report that shows the lot and serial numbers that are in the shipment.];
                  ApplicationArea=#Service;
                  SourceExpr=ShowLotSN }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text002@1002 : TextConst 'DAN=Service - leverance %1;ENU=Service - Shipment %1';
      Text003@1003 : TextConst 'DAN=Side %1;ENU=Page %1';
      SalesPurchPerson@1004 : Record 13;
      CompanyInfo@1005 : Record 79;
      CompanyInfo1@1030 : Record 79;
      CompanyInfo2@1031 : Record 79;
      CompanyInfo3@1007 : Record 79;
      ServiceSetup@1033 : Record 5911;
      DimSetEntry@1006 : Record 480;
      Language@1008 : Record 8;
      RespCenter@1010 : Record 5714;
      TrackingSpecBuffer@1023 : TEMPORARY Record 336;
      ItemTrackingAppendix@1034 : Report 6521;
      FormatAddr@1011 : Codeunit 365;
      FormatDocument@1027 : Codeunit 368;
      ItemTrackingDocMgt@1024 : Codeunit 6503;
      NoOfCopies@1018 : Integer;
      NoOfLoops@1019 : Integer;
      TrackingSpecCount@1037 : Integer;
      OldRefNo@1041 : Integer;
      TotalQty@1028 : Decimal;
      OldNo@1040 : Code[20];
      CopyText@1020 : Text[30];
      CustAddr@1016 : ARRAY [8] OF Text[50];
      ShipToAddr@1015 : ARRAY [8] OF Text[50];
      CompanyAddr@1014 : ARRAY [8] OF Text[50];
      SalesPersonText@1013 : Text[20];
      ReferenceText@1012 : Text[80];
      DimText@1025 : Text[120];
      ShowCustAddr@1021 : Boolean;
      MoreLines@1017 : Boolean;
      ShowInternalInfo@1026 : Boolean;
      ShowCorrectionLines@1029 : Boolean;
      ShowLotSN@1032 : Boolean;
      ShowTotal@1035 : Boolean;
      ShowGroup@1039 : Boolean;
      OutputNo@1000000000 : Integer;
      DimTxtArrLength@1102601000 : Integer;
      DimTxtArr@1102601001 : ARRAY [500] OF Text[50];
      ItemTrackingAppendixCaptionLbl@2141 : TextConst 'DAN=Appendiks for varesporing;ENU=Item Tracking - Appendix';
      PhoneNoCaptionLbl@6169 : TextConst 'DAN=Telefon;ENU=Phone No.';
      VATRegNoCaptionLbl@2224 : TextConst 'DAN=SE/CVR-nr.;ENU=VAT Registration No.';
      GiroNoCaptionLbl@7839 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      BankNameCaptionLbl@5585 : TextConst 'DAN=Bank;ENU=Bank';
      BankAccNoCaptionLbl@1535 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      ServiceShpHdrNoCaptionLbl@4699 : TextConst 'DAN=Leverancenr.;ENU=Shipment No.';
      ServiceShpHdrPostingDateCaptionLbl@3251 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      HdrDimsCaptionLbl@2756 : TextConst 'DAN=Dimensioner - hoved;ENU=Header Dimensions';
      SrvcShpItemLineCaptionLbl@2714 : TextConst 'DAN=Artikellinje for serviceleverance;ENU=Service Shipment Item Line';
      ServiceShpLineCaptionLbl@5803 : TextConst 'DAN=Serviceleverancelinje;ENU=Service Shipment Line';
      QtyInvoicedCaptionLbl@2799 : TextConst 'DAN=Faktureret (antal);ENU=Quantity Invoiced';
      QtyConsumedCaptionLbl@3633 : TextConst 'DAN=Antal forbrugt;ENU=Quantity Consumed';
      LineDimsCaptionLbl@6798 : TextConst 'DAN=Linjedimensioner;ENU=Line Dimensions';
      BilltoAddrCaptionLbl@6886 : TextConst 'DAN=Faktureringsadresse;ENU=Bill-to Address';
      QuantityCaptionLbl@7263 : TextConst 'DAN=Antal;ENU=Quantity';
      SerialNoCaptionLbl@8381 : TextConst 'DAN=Serienr.;ENU=Serial No.';
      LotNoCaptionLbl@7033 : TextConst 'DAN=Lotnr.;ENU=Lot No.';
      DescriptionCaptionLbl@3701 : TextConst 'DAN=Beskrivelse;ENU=Description';
      DocumentDateLbl@2421 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      EmailIdCaptionLbl@6912 : TextConst 'DAN=Mail;ENU=Email';
      HomePageCaptionLbl@1436 : TextConst 'DAN=HomePage;ENU=HomePage';
      SrvcShipHeaderCustNoCaptionLbl@1609 : TextConst 'DAN=Debitornr.;ENU=Customer No';
      WarrantyCaptionLbl@8167 : TextConst 'DAN=Garanti;ENU=Warranty';

    LOCAL PROCEDURE FindDimTxt@1102601000(DimSetID@1001 : Integer);
    VAR
      Separation@1102601001 : Text[5];
      i@1102601002 : Integer;
      TxtToAdd@1102601003 : Text[120];
      StartNewLine@1102601004 : Boolean;
    BEGIN
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      DimTxtArrLength := 0;
      FOR i := 1 TO ARRAYLEN(DimTxtArr) DO
        DimTxtArr[i] := '';
      IF NOT DimSetEntry.FINDSET THEN
        EXIT;
      Separation := '; ';
      REPEAT
        TxtToAdd := DimSetEntry."Dimension Code" + ' - ' + DimSetEntry."Dimension Value Code";
        IF DimTxtArrLength = 0 THEN
          StartNewLine := TRUE
        ELSE
          StartNewLine := STRLEN(DimTxtArr[DimTxtArrLength]) + STRLEN(Separation) + STRLEN(TxtToAdd) > MAXSTRLEN(DimTxtArr[1]);
        IF StartNewLine THEN BEGIN
          DimTxtArrLength += 1;
          DimTxtArr[DimTxtArrLength] := TxtToAdd
        END ELSE
          DimTxtArr[DimTxtArrLength] := DimTxtArr[DimTxtArrLength] + Separation + TxtToAdd;
      UNTIL DimSetEntry.NEXT = 0;
    END;

    PROCEDURE InitializeRequest@1(NewShowInternalInfo@1002 : Boolean;NewShowCorrectionLines@1001 : Boolean;NewShowLotSN@1000 : Boolean);
    BEGIN
      ShowInternalInfo := NewShowInternalInfo;
      ShowCorrectionLines := NewShowCorrectionLines;
      ShowLotSN := NewShowLotSN;
    END;

    LOCAL PROCEDURE IsReportInPreviewMode@8() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    LOCAL PROCEDURE FormatAddressFields@2(VAR ServiceShipmentHeader@1000 : Record 5990);
    BEGIN
      FormatAddr.GetCompanyAddr(ServiceShipmentHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
      FormatAddr.ServiceShptShipTo(ShipToAddr,ServiceShipmentHeader);
      ShowCustAddr := FormatAddr.ServiceShptBillTo(CustAddr,ShipToAddr,ServiceShipmentHeader);
    END;

    LOCAL PROCEDURE FormatDocumentFields@3(ServiceShipmentHeader@1000 : Record 5990);
    BEGIN
      WITH ServiceShipmentHeader DO BEGIN
        FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);

        ReferenceText := FormatDocument.SetText("Your Reference" <> '',FIELDCAPTION("Your Reference"));
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
      <rd:DataSourceID>1252870b-5770-4964-aecc-e123d926b792</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="No_ServiceShptHrd">
          <DataField>No_ServiceShptHrd</DataField>
        </Field>
        <Field Name="DocumentDate">
          <DataField>DocumentDate</DataField>
        </Field>
        <Field Name="EmailIdCaption">
          <DataField>EmailIdCaption</DataField>
        </Field>
        <Field Name="HomePageCaption">
          <DataField>HomePageCaption</DataField>
        </Field>
        <Field Name="SrvcShipHeaderCustNoCaption">
          <DataField>SrvcShipHeaderCustNoCaption</DataField>
        </Field>
        <Field Name="WarrantyCaption">
          <DataField>WarrantyCaption</DataField>
        </Field>
        <Field Name="CompanyInfo2Picture">
          <DataField>CompanyInfo2Picture</DataField>
        </Field>
        <Field Name="CompanyInfo1Picture">
          <DataField>CompanyInfo1Picture</DataField>
        </Field>
        <Field Name="CompanyInfo3Picture">
          <DataField>CompanyInfo3Picture</DataField>
        </Field>
        <Field Name="ServiceShptCopyText">
          <DataField>ServiceShptCopyText</DataField>
        </Field>
        <Field Name="CurrReportPageNo">
          <DataField>CurrReportPageNo</DataField>
        </Field>
        <Field Name="ShipToAddr1">
          <DataField>ShipToAddr1</DataField>
        </Field>
        <Field Name="CompanyAddr1">
          <DataField>CompanyAddr1</DataField>
        </Field>
        <Field Name="ShipToAddr2">
          <DataField>ShipToAddr2</DataField>
        </Field>
        <Field Name="CompanyAddr2">
          <DataField>CompanyAddr2</DataField>
        </Field>
        <Field Name="ShipToAddr3">
          <DataField>ShipToAddr3</DataField>
        </Field>
        <Field Name="CompanyAddr3">
          <DataField>CompanyAddr3</DataField>
        </Field>
        <Field Name="ShipToAddr4">
          <DataField>ShipToAddr4</DataField>
        </Field>
        <Field Name="CompanyAddr4">
          <DataField>CompanyAddr4</DataField>
        </Field>
        <Field Name="ShipToAddr5">
          <DataField>ShipToAddr5</DataField>
        </Field>
        <Field Name="PhoneNo_CompanyInfo">
          <DataField>PhoneNo_CompanyInfo</DataField>
        </Field>
        <Field Name="ShipToAddr6">
          <DataField>ShipToAddr6</DataField>
        </Field>
        <Field Name="HomePage">
          <DataField>HomePage</DataField>
        </Field>
        <Field Name="EMailId">
          <DataField>EMailId</DataField>
        </Field>
        <Field Name="CompanyInfoVATRegnNo">
          <DataField>CompanyInfoVATRegnNo</DataField>
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
        <Field Name="CustNo_ServShptHrd">
          <DataField>CustNo_ServShptHrd</DataField>
        </Field>
        <Field Name="ServShptHrdDocDt">
          <DataField>ServShptHrdDocDt</DataField>
        </Field>
        <Field Name="SalesPersonText">
          <DataField>SalesPersonText</DataField>
        </Field>
        <Field Name="SalesPurchPersonName">
          <DataField>SalesPurchPersonName</DataField>
        </Field>
        <Field Name="No1_ServiceShptHrd">
          <DataField>No1_ServiceShptHrd</DataField>
        </Field>
        <Field Name="ReferenceText">
          <DataField>ReferenceText</DataField>
        </Field>
        <Field Name="YourRef_ServShptHrd">
          <DataField>YourRef_ServShptHrd</DataField>
        </Field>
        <Field Name="ShipToAddr7">
          <DataField>ShipToAddr7</DataField>
        </Field>
        <Field Name="ShipToAddr8">
          <DataField>ShipToAddr8</DataField>
        </Field>
        <Field Name="CompanyAddr5">
          <DataField>CompanyAddr5</DataField>
        </Field>
        <Field Name="CompanyAddr6">
          <DataField>CompanyAddr6</DataField>
        </Field>
        <Field Name="PostingDate_ServShptHrd">
          <DataField>PostingDate_ServShptHrd</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="OutputNo">
          <DataField>OutputNo</DataField>
        </Field>
        <Field Name="ItemTrackingAppendixCaption">
          <DataField>ItemTrackingAppendixCaption</DataField>
        </Field>
        <Field Name="PhoneNoCaption">
          <DataField>PhoneNoCaption</DataField>
        </Field>
        <Field Name="VATRegNoCaption">
          <DataField>VATRegNoCaption</DataField>
        </Field>
        <Field Name="GiroNoCaption">
          <DataField>GiroNoCaption</DataField>
        </Field>
        <Field Name="BankNameCaption">
          <DataField>BankNameCaption</DataField>
        </Field>
        <Field Name="BankAccNoCaption">
          <DataField>BankAccNoCaption</DataField>
        </Field>
        <Field Name="ServiceShpHdrNoCaption">
          <DataField>ServiceShpHdrNoCaption</DataField>
        </Field>
        <Field Name="ServiceShpHdrPostingDateCaption">
          <DataField>ServiceShpHdrPostingDateCaption</DataField>
        </Field>
        <Field Name="CustNo_ServShptHrdCaption">
          <DataField>CustNo_ServShptHrdCaption</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="DimensionLoop1Number">
          <DataField>DimensionLoop1Number</DataField>
        </Field>
        <Field Name="HdrDimsCaption">
          <DataField>HdrDimsCaption</DataField>
        </Field>
        <Field Name="ContractNo_ServShptItemLn">
          <DataField>ContractNo_ServShptItemLn</DataField>
        </Field>
        <Field Name="Des_ServShptItemLn">
          <DataField>Des_ServShptItemLn</DataField>
        </Field>
        <Field Name="SerialNo_ServShptItemLn">
          <DataField>SerialNo_ServShptItemLn</DataField>
        </Field>
        <Field Name="ItemNo_ServShptItemLn">
          <DataField>ItemNo_ServShptItemLn</DataField>
        </Field>
        <Field Name="ItemGrpCode_ServShptLn">
          <DataField>ItemGrpCode_ServShptLn</DataField>
        </Field>
        <Field Name="ServItemNo_ServShptItemLn">
          <DataField>ServItemNo_ServShptItemLn</DataField>
        </Field>
        <Field Name="Warranty">
          <DataField>Warranty</DataField>
        </Field>
        <Field Name="LnNo_ServShptItemLn">
          <DataField>LnNo_ServShptItemLn</DataField>
        </Field>
        <Field Name="SrvcShpItemLineCaption">
          <DataField>SrvcShpItemLineCaption</DataField>
        </Field>
        <Field Name="ContractNo_ServShptItemLnCaption">
          <DataField>ContractNo_ServShptItemLnCaption</DataField>
        </Field>
        <Field Name="Des_ServShptItemLnCaption">
          <DataField>Des_ServShptItemLnCaption</DataField>
        </Field>
        <Field Name="SerialNo_ServShptItemLnCaption">
          <DataField>SerialNo_ServShptItemLnCaption</DataField>
        </Field>
        <Field Name="ItemNo_ServShptItemLnCaption">
          <DataField>ItemNo_ServShptItemLnCaption</DataField>
        </Field>
        <Field Name="ItemGrpCode_ServShptLnCaption">
          <DataField>ItemGrpCode_ServShptLnCaption</DataField>
        </Field>
        <Field Name="ServItemNo_ServShptItemLnCaption">
          <DataField>ServItemNo_ServShptItemLnCaption</DataField>
        </Field>
        <Field Name="ServShptLnDescription">
          <DataField>ServShptLnDescription</DataField>
        </Field>
        <Field Name="ShowInternalInfo">
          <DataField>ShowInternalInfo</DataField>
        </Field>
        <Field Name="ShowCorrectionLines">
          <DataField>ShowCorrectionLines</DataField>
        </Field>
        <Field Name="ShowLotSN">
          <DataField>ShowLotSN</DataField>
        </Field>
        <Field Name="Type_ServiceShptItemLn">
          <DataField>Type_ServiceShptItemLn</DataField>
        </Field>
        <Field Name="Qty_ServiceShptItemLn">
          <DataField>Qty_ServiceShptItemLn</DataField>
        </Field>
        <Field Name="Qty_ServiceShptItemLnFormat">
          <DataField>Qty_ServiceShptItemLnFormat</DataField>
        </Field>
        <Field Name="UnitofMeasure_ServShptLn">
          <DataField>UnitofMeasure_ServShptLn</DataField>
        </Field>
        <Field Name="No_ServiceShptItemLn">
          <DataField>No_ServiceShptItemLn</DataField>
        </Field>
        <Field Name="QtyInvoiced_ServShptLine">
          <DataField>QtyInvoiced_ServShptLine</DataField>
        </Field>
        <Field Name="QtyInvoiced_ServShptLineFormat">
          <DataField>QtyInvoiced_ServShptLineFormat</DataField>
        </Field>
        <Field Name="QtyConsumed_ServShptLine">
          <DataField>QtyConsumed_ServShptLine</DataField>
        </Field>
        <Field Name="QtyConsumed_ServShptLineFormat">
          <DataField>QtyConsumed_ServShptLineFormat</DataField>
        </Field>
        <Field Name="LnNo_ServiceShptItemLn">
          <DataField>LnNo_ServiceShptItemLn</DataField>
        </Field>
        <Field Name="ServiceShpLineCaption">
          <DataField>ServiceShpLineCaption</DataField>
        </Field>
        <Field Name="QtyInvoicedCaption">
          <DataField>QtyInvoicedCaption</DataField>
        </Field>
        <Field Name="QtyConsumedCaption">
          <DataField>QtyConsumedCaption</DataField>
        </Field>
        <Field Name="ServShptLnDescriptionCaption">
          <DataField>ServShptLnDescriptionCaption</DataField>
        </Field>
        <Field Name="Qty_ServiceShptItemLnCaption">
          <DataField>Qty_ServiceShptItemLnCaption</DataField>
        </Field>
        <Field Name="UnitofMeasure_ServShptLnCaption">
          <DataField>UnitofMeasure_ServShptLnCaption</DataField>
        </Field>
        <Field Name="No_ServiceShptItemLnCaption">
          <DataField>No_ServiceShptItemLnCaption</DataField>
        </Field>
        <Field Name="DimText_DimLoop2">
          <DataField>DimText_DimLoop2</DataField>
        </Field>
        <Field Name="DimensionLoop2Number">
          <DataField>DimensionLoop2Number</DataField>
        </Field>
        <Field Name="LineDimsCaption">
          <DataField>LineDimsCaption</DataField>
        </Field>
        <Field Name="BilltoCustNo_ServShptHrd">
          <DataField>BilltoCustNo_ServShptHrd</DataField>
        </Field>
        <Field Name="CustAddr1">
          <DataField>CustAddr1</DataField>
        </Field>
        <Field Name="CustAddr2">
          <DataField>CustAddr2</DataField>
        </Field>
        <Field Name="CustAddr3">
          <DataField>CustAddr3</DataField>
        </Field>
        <Field Name="CustAddr4">
          <DataField>CustAddr4</DataField>
        </Field>
        <Field Name="CustAddr5">
          <DataField>CustAddr5</DataField>
        </Field>
        <Field Name="CustAddr6">
          <DataField>CustAddr6</DataField>
        </Field>
        <Field Name="CustAddr7">
          <DataField>CustAddr7</DataField>
        </Field>
        <Field Name="CustAddr8">
          <DataField>CustAddr8</DataField>
        </Field>
        <Field Name="BilltoAddrCaption">
          <DataField>BilltoAddrCaption</DataField>
        </Field>
        <Field Name="BilltoCustNo_ServShptHrdCaption">
          <DataField>BilltoCustNo_ServShptHrdCaption</DataField>
        </Field>
        <Field Name="TrackingSpecBufItemNo">
          <DataField>TrackingSpecBufItemNo</DataField>
        </Field>
        <Field Name="TrackingSpecBufDesc">
          <DataField>TrackingSpecBufDesc</DataField>
        </Field>
        <Field Name="TrackingSpecBufLotNo">
          <DataField>TrackingSpecBufLotNo</DataField>
        </Field>
        <Field Name="TrackingSpecBufSerialNo">
          <DataField>TrackingSpecBufSerialNo</DataField>
        </Field>
        <Field Name="TrackingSpecBufQty">
          <DataField>TrackingSpecBufQty</DataField>
        </Field>
        <Field Name="TrackingSpecBufQtyFormat">
          <DataField>TrackingSpecBufQtyFormat</DataField>
        </Field>
        <Field Name="ShowTotal">
          <DataField>ShowTotal</DataField>
        </Field>
        <Field Name="ShowGroup">
          <DataField>ShowGroup</DataField>
        </Field>
        <Field Name="QuantityCaption">
          <DataField>QuantityCaption</DataField>
        </Field>
        <Field Name="SerialNoCaption">
          <DataField>SerialNoCaption</DataField>
        </Field>
        <Field Name="LotNoCaption">
          <DataField>LotNoCaption</DataField>
        </Field>
        <Field Name="DescriptionCaption">
          <DataField>DescriptionCaption</DataField>
        </Field>
        <Field Name="TotalQty">
          <DataField>TotalQty</DataField>
        </Field>
        <Field Name="TotalQtyFormat">
          <DataField>TotalQtyFormat</DataField>
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
                  <Width>7.27768in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>5.09719in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="ShipmentItemLineCaption">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.86828in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.41356in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.49623in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.90962in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.74426in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.16552in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.90962in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.07497in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.08285in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.74426in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.2482in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.62025in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox174">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SrvcShpItemLineCaption.Value</Value>
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
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>12</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                          <Textbox Name="textbox30">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServItemNo_ServShptItemLnCaption.Value</Value>
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
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox31">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ItemGrpCode_ServShptLnCaption.Value</Value>
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
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox32">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ItemNo_ServShptItemLnCaption.Value</Value>
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
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox33">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SerialNo_ServShptItemLnCaption.Value</Value>
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
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox34">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Des_ServShptItemLnCaption.Value</Value>
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
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox35">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!WarrantyCaption.Value</Value>
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
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox36">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ContractNo_ServShptItemLnCaption.Value</Value>
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
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox210">
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox210</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>12</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                          <Textbox Name="Textbox198">
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox198</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>12</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                          <Textbox Name="textbox133">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServItemNo_ServShptItemLn.Value</Value>
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
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox144">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ItemGrpCode_ServShptLn.Value</Value>
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
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox145">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ItemNo_ServShptItemLn.Value</Value>
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
                                            <ZIndex>4</ZIndex>
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
                                          <Textbox Name="textbox154">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SerialNo_ServShptItemLn.Value</Value>
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
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox155">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Des_ServShptItemLn.Value</Value>
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
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox156">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Warranty.Value</Value>
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
                                          <Textbox Name="textbox157">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ContractNo_ServShptItemLn.Value</Value>
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
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table5_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!No1_ServiceShptHrd.Value</GroupExpression>
                                        <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                                        <GroupExpression>=Fields!LnNo_ServShptItemLn.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <SortExpressions>
                                      <SortExpression>
                                        <Value>=Fields!LnNo_ServShptItemLn.Value</Value>
                                      </SortExpression>
                                      <SortExpression>
                                        <Value>=Fields!OutputNo.Value</Value>
                                      </SortExpression>
                                      <SortExpression>
                                        <Value>=Fields!No_ServiceShptHrd.Value</Value>
                                      </SortExpression>
                                    </SortExpressions>
                                    <TablixMembers>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                      </TablixMember>
                                      <TablixMember>
                                        <Group Name="table5_Group2">
                                          <GroupExpressions>
                                            <GroupExpression>=Fields!No1_ServiceShptHrd.Value</GroupExpression>
                                            <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                                            <GroupExpression>=Fields!LnNo_ServShptItemLn.Value</GroupExpression>
                                          </GroupExpressions>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                        </TablixMembers>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Cstr(Fields!LnNo_ServShptItemLn.Value)</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>0pt</Top>
                              <Left>0pt</Left>
                              <Height>1.4111cm</Height>
                              <Width>7.27762in</Width>
                              <Style>
                                <PaddingLeft>5pt</PaddingLeft>
                              </Style>
                            </Tablix>
                            <Tablix Name="ShipmentLineCaption">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.86828in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.41356in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.49623in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.90962in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.74426in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.16552in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.90962in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.07497in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.08285in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.74426in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.2482in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.62025in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.27778in</Height>
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
                                                    <Value />
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
                                            <rd:DefaultName>Textbox1</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>12</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                          <Textbox Name="textbox260">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServiceShpLineCaption.Value</Value>
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
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>12</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                          <Textbox Name="textbox275">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_ServiceShptItemLnCaption.Value</Value>
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
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox276">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServShptLnDescriptionCaption.Value</Value>
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
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox277">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Qty_ServiceShptItemLnCaption.Value</Value>
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
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox278">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!QtyInvoicedCaption.Value</Value>
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
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox279">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!QtyConsumedCaption.Value</Value>
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
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox280">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitofMeasure_ServShptLnCaption.Value</Value>
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
                                            <ZIndex>10</ZIndex>
                                            <Style>
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
                                          <Textbox Name="Textbox130">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox130</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>12</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                          <Textbox Name="Textbox143">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox143</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>12</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                          <Textbox Name="textbox21">
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox21</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox22">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServShptLnDescription.Value</Value>
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
                                            <rd:DefaultName>textbox22</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>11</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                          <Textbox Name="textbox222">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_ServiceShptItemLn.Value</Value>
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
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox223">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServShptLnDescription.Value</Value>
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
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox224">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Qty_ServiceShptItemLn.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!Qty_ServiceShptItemLnFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox227">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!QtyInvoiced_ServShptLine.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!QtyInvoiced_ServShptLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>4</ZIndex>
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
                                          <Textbox Name="textbox228">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!QtyConsumed_ServShptLine.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!QtyConsumed_ServShptLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox229">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitofMeasure_ServShptLn.Value</Value>
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
                                            <ZIndex>2</ZIndex>
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
                                          <Textbox Name="textbox244">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!LineDimsCaption.Value, "table6_Group1")</Value>
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
                                            <ZIndex>1</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!DimensionLoop2Number.Value = 1,False,True)</Hidden>
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
                                          <Textbox Name="textbox245">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!DimText_DimLoop2.Value, "table6_Group1")</Value>
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
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>10</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
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
                                    <Group Name="table6_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!No1_ServiceShptHrd.Value</GroupExpression>
                                        <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                                        <GroupExpression>=Fields!LnNo_ServiceShptItemLn.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <SortExpressions>
                                      <SortExpression>
                                        <Value>=Fields!LnNo_ServiceShptItemLn.Value</Value>
                                      </SortExpression>
                                      <SortExpression>
                                        <Value>=Fields!OutputNo.Value</Value>
                                      </SortExpression>
                                      <SortExpression>
                                        <Value>=Fields!No_ServiceShptHrd.Value</Value>
                                      </SortExpression>
                                    </SortExpressions>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=Iif(Fields!Type_ServiceShptItemLn.Value = " ", false, true)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=Iif(Fields!Type_ServiceShptItemLn.Value = " ", true, false)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Group Name="table6_Details_Group">
                                          <DataElementName>Detail</DataElementName>
                                        </Group>
                                        <SortExpressions>
                                          <SortExpression>
                                            <Value>=Fields!OutputNo.Value</Value>
                                          </SortExpression>
                                          <SortExpression>
                                            <Value>=Fields!No_ServiceShptHrd.Value</Value>
                                          </SortExpression>
                                        </SortExpressions>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!DimensionLoop2Number.Value &gt; 0,False,True)</Hidden>
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
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=CStr(Fields!LnNo_ServiceShptItemLn.Value)</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>1.4397cm</Top>
                              <Height>2.82222cm</Height>
                              <Width>7.27762in</Width>
                              <ZIndex>1</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="table3">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.9092in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3.36856in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.27778in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox53">
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox53</rd:DefaultName>
                                            <Style />
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustAddr1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustAddr1.Value</Value>
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
                                            <rd:DefaultName>CustAddr1</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustAddr2">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustAddr2.Value</Value>
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
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustAddr3">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustAddr3.Value</Value>
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
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustAddr4">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustAddr4.Value</Value>
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
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustAddr5">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustAddr5.Value</Value>
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
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustAddr6">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustAddr6.Value</Value>
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
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustAddr7">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustAddr7.Value</Value>
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
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustAddr8">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustAddr8.Value</Value>
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
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                    <KeepWithGroup>After</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table3_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIf(Fields!CustAddr1.Value = "",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIf(Fields!CustAddr2.Value = "",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIf(Fields!CustAddr3.Value = "",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIf(Fields!CustAddr4.Value = "",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIf(Fields!CustAddr5.Value = "",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIf(Fields!CustAddr6.Value = "",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIf(Fields!CustAddr7.Value = "",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIf(Fields!CustAddr8.Value = "",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!No_ServiceShptHrd.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>5.69552cm</Top>
                              <Left>0pt</Left>
                              <Height>3.52781cm</Height>
                              <Width>18.48551cm</Width>
                              <ZIndex>2</ZIndex>
                              <Style>
                                <FontSize>9pt</FontSize>
                              </Style>
                            </Tablix>
                            <Tablix Name="table4">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.14222in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.71899in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.26033in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.13041in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.0123in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.25in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox59">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox59</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>5</ColSpan>
                                        </CellContents>
                                      </TablixCell>
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
                                          <Textbox Name="textbox13">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ItemNo_ServShptItemLnCaption.Value</Value>
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
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox37">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DescriptionCaption.Value</Value>
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
                                            <rd:DefaultName>textbox37</rd:DefaultName>
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox43">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LotNoCaption.Value</Value>
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
                                            <rd:DefaultName>textbox43</rd:DefaultName>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox45">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SerialNoCaption.Value</Value>
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
                                            <rd:DefaultName>textbox45</rd:DefaultName>
                                            <ZIndex>26</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox46">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!QuantityCaption.Value</Value>
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
                                            <rd:DefaultName>textbox46</rd:DefaultName>
                                            <ZIndex>25</ZIndex>
                                            <Style>
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
                                          <Textbox Name="Textbox225">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox225</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>5</ColSpan>
                                        </CellContents>
                                      </TablixCell>
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
                                          <Textbox Name="Textbox234">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox234</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>5</ColSpan>
                                        </CellContents>
                                      </TablixCell>
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
                                          <Textbox Name="textbox3">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TrackingSpecBufItemNo.Value</Value>
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
                                            <ZIndex>23</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!ShowGroup.Value = False,False,True)</Hidden>
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
                                          <Textbox Name="textbox15">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TrackingSpecBufDesc.Value</Value>
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
                                            <ZIndex>22</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!ShowGroup.Value = False,False,True)</Hidden>
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
                                          <Textbox Name="textbox18">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TrackingSpecBufLotNo.Value</Value>
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
                                            <ZIndex>21</ZIndex>
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
                                          <Textbox Name="textbox19">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TrackingSpecBufSerialNo.Value</Value>
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
                                            <ZIndex>20</ZIndex>
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
                                          <Textbox Name="textbox20">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TrackingSpecBufQty.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!TotalQtyFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>19</ZIndex>
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
                                          <Textbox Name="textbox29">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TrackingSpecBufItemNo.Value</Value>
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
                                            <ZIndex>17</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!ShowGroup.Value = False,False,True)</Hidden>
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
                                          <Textbox Name="textbox5">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TrackingSpecBufDesc.Value</Value>
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
                                            <ZIndex>16</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!ShowGroup.Value = False,False,True)</Hidden>
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
                                          <Textbox Name="textbox9">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TrackingSpecBufLotNo.Value</Value>
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
                                            <ZIndex>15</ZIndex>
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
                                          <Textbox Name="textbox10">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TrackingSpecBufSerialNo.Value</Value>
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
                                            <ZIndex>14</ZIndex>
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
                                          <Textbox Name="textbox11">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TrackingSpecBufQty.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!TotalQtyFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>13</ZIndex>
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
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox25">
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox25</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox39">
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
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox39</rd:DefaultName>
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
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox40">
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox40</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox47</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
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
                                          <Textbox Name="textbox26">
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox26</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox49">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalQty.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalQtyFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox49</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!TrackingSpecBufItemNo.Value = "",True,False)</Hidden>
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
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
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
                                    <KeepTogether>true</KeepTogether>
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
                                    <Group Name="table4_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!TrackingSpecBufItemNo.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="table4_Details_Group">
                                          <DataElementName>Detail</DataElementName>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!ShowGroup.Value = False,False,True)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!ShowGroup.Value = True,False,True)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!ShowTotal.Value = True,False,True)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!ShowTotal.Value = True,False,True)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!ShowTotal.Value = True,False,True)</Hidden>
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
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!TrackingSpecBufItemNo.Value</FilterExpression>
                                  <Operator>GreaterThanOrEqual</Operator>
                                  <FilterValues>
                                    <FilterValue>""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>10.19522cm</Top>
                              <Left>0pt</Left>
                              <Height>2.75163cm</Height>
                              <Width>18.4512cm</Width>
                              <ZIndex>3</ZIndex>
                              <Visibility>
                                <Hidden>=IIf(Fields!TrackingSpecBufItemNo.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <FontSize>9pt</FontSize>
                              </Style>
                            </Tablix>
                            <Tablix Name="AddressCaption">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.44393in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3.83369in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.27778in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox57">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox57</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BilltoAddrCaption.Value</Value>
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
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox4">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BilltoCustNo_ServShptHrdCaption.Value</Value>
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
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox14">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BilltoCustNo_ServShptHrd.Value</Value>
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
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                    <KeepWithGroup>After</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table1_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIf(Fields!BilltoAddrCaption.Value = "",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIf((Fields!BilltoCustNo_ServShptHrd.Value &lt;&gt; "") And (Fields!CustNo_ServShptHrd.Value &lt;&gt; "") And (Fields!BilltoCustNo_ServShptHrd.Value &lt;&gt; Fields!CustNo_ServShptHrd.Value),False,True)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!No_ServiceShptHrd.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>4.276cm</Top>
                              <Height>1.41112cm</Height>
                              <Width>18.48516cm</Width>
                              <ZIndex>4</ZIndex>
                              <Style>
                                <FontSize>9pt</FontSize>
                              </Style>
                            </Tablix>
                            <Tablix Name="table8">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.03125in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.14349in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.04705in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="HeaderInfo">
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
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Cstr(Fields!ServiceShptCopyText.Value) + Chr(177) + 
Cstr(Fields!PageCaption.Value) + Chr(177) + 
Cstr(Fields!CurrReportPageNo.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr1.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr2.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr3.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr4.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr5.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr6.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr7.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr8.Value) + Chr(177) + 
Cstr(Fields!PhoneNo_CompanyInfo.Value) + Chr(177) + 
Cstr(Fields!HomePage.Value) + Chr(177) + 
Cstr(Fields!EMailId.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoVATRegnNo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoGiroNo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankName.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankAccNo.Value) + Chr(177) + 
Cstr(Fields!CustNo_ServShptHrd.Value) + Chr(177) + 
Cstr(Fields!SalesPersonText.Value) + Chr(177) + 
Cstr(Fields!YourRef_ServShptHrd.Value) + Chr(177) + 
Cstr(Fields!ServShptHrdDocDt.Value) + Chr(177) + 
Cstr(Fields!No1_ServiceShptHrd.Value) + Chr(177) + 
Cstr(Fields!PostingDate_ServShptHrd.Value) + Chr(177) + 
Cstr(Fields!SalesPurchPersonName.Value) + Chr(177) + 
Cstr(Fields!ReferenceText.Value) + Chr(177) + 
Cstr(Fields!CustAddr1.Value) + Chr(177) + 
Cstr(Fields!CustAddr2.Value) + Chr(177) + 
Cstr(Fields!CustAddr3.Value) + Chr(177) + 
Cstr(Fields!CustAddr4.Value) + Chr(177) + 
Cstr(Fields!CustAddr5.Value) + Chr(177) + 
Cstr(Fields!CustAddr6.Value) + Chr(177) + 
Cstr(Fields!CustAddr7.Value) + Chr(177) + 
Cstr(Fields!CustAddr8.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr1.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr2.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr3.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr4.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr5.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr6.Value) + Chr(177) + 
Cstr(Fields!CustNo_ServShptHrdCaption.Value) + Chr(177) + 
Cstr(Fields!ServiceShpHdrPostingDateCaption.Value) + Chr(177) + 
Cstr(Fields!ServiceShpHdrNoCaption.Value) + Chr(177) + 
Cstr(Fields!BankAccNoCaption.Value) + Chr(177) + 
Cstr(Fields!BankNameCaption.Value) + Chr(177) + 
Cstr(Fields!GiroNoCaption.Value) + Chr(177) + 
Cstr(Fields!VATRegNoCaption.Value) + Chr(177) + 
Cstr(Fields!HomePageCaption.Value) + Chr(177) + 
Cstr(Fields!PhoneNoCaption.Value) + Chr(177) + 
Cstr(Fields!DocumentDate.Value) + Chr(177) + 
Cstr(Fields!EmailIdCaption.Value)
)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="NewPage">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=IIf(Code.IsNewPage,True,False)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style />
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
                              <Top>0pt</Top>
                              <Left>0pt</Left>
                              <Height>0.11951cm</Height>
                              <Width>0.44384cm</Width>
                              <ZIndex>5</ZIndex>
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
                      <GroupExpression>=Fields!No1_ServiceShptHrd.Value</GroupExpression>
                      <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <SortExpressions>
                    <SortExpression>
                      <Value>=Fields!OutputNo.Value</Value>
                    </SortExpression>
                    <SortExpression>
                      <Value>=Fields!No_ServiceShptHrd.Value</Value>
                    </SortExpression>
                  </SortExpressions>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <KeepTogether>true</KeepTogether>
            <DataSetName>DataSet_Result</DataSetName>
            <Height>12.94686cm</Height>
            <Width>18.48531cm</Width>
            <Style>
              <FontSize>9pt</FontSize>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>12.94686cm</Height>
        <Style />
      </Body>
      <Width>18.48549cm</Width>
      <Page>
        <PageHeader>
          <Height>9.79444cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Image Name="CompanyInfo2Picture1">
              <Source>Database</Source>
              <Value>=Convert.ToBase64String(Fields!CompanyInfo1Picture.Value)</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Left>12cm</Left>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <Visibility>
                <Hidden>=iif(Isnothing(Fields!CompanyInfo1Picture.Value) = True,true,false)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <Border />
              </Style>
            </Image>
            <Image Name="CompanyInfo1Picture1">
              <Source>Database</Source>
              <Value>=Convert.ToBase64String(Fields!CompanyInfo2Picture.Value)</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Left>6cm</Left>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>1</ZIndex>
              <Visibility>
                <Hidden>=iif(IsNothing(Fields!CompanyInfo2Picture.Value) = True,true,false)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <Border />
              </Style>
            </Image>
            <Image Name="CompanyInfoPicture1">
              <Source>Database</Source>
              <Value>=Convert.ToBase64String(Fields!CompanyInfo3Picture.Value)</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>2</ZIndex>
              <Visibility>
                <Hidden>=iif(IsNothing(Fields!CompanyInfo3Picture.Value) = True,true,false)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <Border />
              </Style>
            </Image>
            <Textbox Name="SrvcShipHeaderCustNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(41)</Value>
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
              <Top>6.28982cm</Top>
              <Height>11pt</Height>
              <Width>3.1907cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr81">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(11)</Value>
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
              <Top>5.51614cm</Top>
              <Height>11pt</Height>
              <Width>11.44801cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr71">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(10)</Value>
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
              <Top>5.12489cm</Top>
              <Height>11pt</Height>
              <Width>11.44801cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesHeaderYourReference1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(21)</Value>
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
              <Top>6.66983cm</Top>
              <Left>3.25114cm</Left>
              <Height>11pt</Height>
              <Width>8.19688cm</Width>
              <ZIndex>6</ZIndex>
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
                      <Value>=Code.GetData(26)</Value>
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
              <Top>6.68813cm</Top>
              <Height>11pt</Height>
              <Width>3.1907cm</Width>
              <ZIndex>7</ZIndex>
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
                      <Value>=Code.GetData(25)</Value>
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
              <Top>8.68673cm</Top>
              <Left>14.828cm</Left>
              <Height>11pt</Height>
              <Width>3.65749cm</Width>
              <ZIndex>8</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesPersonText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(20)</Value>
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
              <Top>8.68673cm</Top>
              <Left>4.51256in</Left>
              <Height>11pt</Height>
              <Width>3.36609cm</Width>
              <ZIndex>9</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceShipmentHeaderCustomerNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(19)</Value>
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
              <Top>6.28982cm</Top>
              <Left>3.25114cm</Left>
              <Height>11pt</Height>
              <Width>8.19689cm</Width>
              <ZIndex>10</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr61">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(61)</Value>
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
              <Top>4.73364cm</Top>
              <Height>11pt</Height>
              <Width>11.44801cm</Width>
              <ZIndex>11</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr51">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(8)</Value>
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
              <Top>4.34239cm</Top>
              <Height>11pt</Height>
              <Width>11.44801cm</Width>
              <ZIndex>12</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr41">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(7)</Value>
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
              <Top>3.95114cm</Top>
              <Height>11pt</Height>
              <Width>11.44801cm</Width>
              <ZIndex>13</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr31">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(6)</Value>
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
              <Top>3.55989cm</Top>
              <Height>11pt</Height>
              <Width>11.44801cm</Width>
              <ZIndex>14</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr21">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(5)</Value>
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
              <Top>3.16864cm</Top>
              <Height>11pt</Height>
              <Width>11.44802cm</Width>
              <ZIndex>15</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(4)</Value>
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
              <Top>2.76224cm</Top>
              <Height>11pt</Height>
              <Width>11.44801cm</Width>
              <ZIndex>16</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceShipmentHeaderPostingDateCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(42)</Value>
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
              <Top>7.84571cm</Top>
              <Height>11pt</Height>
              <Width>3.1907cm</Width>
              <ZIndex>17</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceShipmentHeaderNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(43)</Value>
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
              <Top>7.43579cm</Top>
              <Height>11pt</Height>
              <Width>3.1907cm</Width>
              <ZIndex>18</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankAccountNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(44)</Value>
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
              <Top>8.28456cm</Top>
              <Left>11.46182cm</Left>
              <Height>11pt</Height>
              <Width>3.36608cm</Width>
              <ZIndex>19</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankNameCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(45)</Value>
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
              <Top>7.86156cm</Top>
              <Left>11.46182cm</Left>
              <Height>11pt</Height>
              <Width>3.36608cm</Width>
              <ZIndex>20</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoGiroNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(46)</Value>
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
              <Top>7.47031cm</Top>
              <Left>11.46182cm</Left>
              <Height>11pt</Height>
              <Width>3.36608cm</Width>
              <ZIndex>21</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoVATRegistrationNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(47)</Value>
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
              <Top>7.07906cm</Top>
              <Left>11.46182cm</Left>
              <Height>11pt</Height>
              <Width>3.36608cm</Width>
              <ZIndex>22</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyHomePageCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(48)</Value>
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
              <Top>6.28564cm</Top>
              <Left>11.46191cm</Left>
              <Height>11pt</Height>
              <Width>3.36609cm</Width>
              <ZIndex>23</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoPhoneNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(49)</Value>
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
              <Top>5.89439cm</Top>
              <Left>11.46191cm</Left>
              <Height>11pt</Height>
              <Width>3.36609cm</Width>
              <ZIndex>24</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PageCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(2) &amp; " " &amp; Code.GetGroupPageNumber(ReportItems!NewPage.Value,Globals!PageNumber)</Value>
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
              <Top>2.75869cm</Top>
              <Left>11.46191cm</Left>
              <Height>11pt</Height>
              <Width>7.02348cm</Width>
              <ZIndex>25</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceShipmentHeaderPostingDate1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(24)</Value>
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
              <Top>7.84571cm</Top>
              <Left>3.25114cm</Left>
              <Height>11pt</Height>
              <Width>8.19688cm</Width>
              <ZIndex>26</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr61">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(40)</Value>
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
              <Top>5.50314cm</Top>
              <Left>11.46191cm</Left>
              <Height>11pt</Height>
              <Width>7.02348cm</Width>
              <ZIndex>27</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr51">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(39)</Value>
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
              <Top>5.07981cm</Top>
              <Left>11.46191cm</Left>
              <Height>11pt</Height>
              <Width>7.02348cm</Width>
              <ZIndex>28</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceShipmentHeaderNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(23)</Value>
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
              <Top>7.43226cm</Top>
              <Left>3.25114cm</Left>
              <Height>11pt</Height>
              <Width>8.19688cm</Width>
              <ZIndex>29</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankAccountNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(18)</Value>
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
              <Top>8.28456cm</Top>
              <Left>14.8279cm</Left>
              <Height>11pt</Height>
              <Width>3.65749cm</Width>
              <ZIndex>30</ZIndex>
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
                      <Value>=Code.GetData(17)</Value>
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
              <Top>7.89331cm</Top>
              <Left>14.8279cm</Left>
              <Height>11pt</Height>
              <Width>3.65749cm</Width>
              <ZIndex>31</ZIndex>
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
                      <Value>=Code.GetData(16)</Value>
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
              <Top>7.50206cm</Top>
              <Left>14.8279cm</Left>
              <Height>11pt</Height>
              <Width>3.65749cm</Width>
              <ZIndex>32</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoVATRegistrationNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(15)</Value>
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
              <Top>7.11081cm</Top>
              <Left>14.8279cm</Left>
              <Height>11pt</Height>
              <Width>3.65749cm</Width>
              <ZIndex>33</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyHomepage1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(13)</Value>
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
              <Top>6.28564cm</Top>
              <Left>14.828cm</Left>
              <Height>11pt</Height>
              <Width>3.65749cm</Width>
              <ZIndex>34</ZIndex>
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
                      <Value>=Code.GetData(12)</Value>
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
              <Top>5.89439cm</Top>
              <Left>14.8279cm</Left>
              <Height>11pt</Height>
              <Width>3.65759cm</Width>
              <ZIndex>35</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr41">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(38)</Value>
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
              <Top>4.72063cm</Top>
              <Left>11.46191cm</Left>
              <Height>11pt</Height>
              <Width>7.02348cm</Width>
              <ZIndex>36</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr31">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(37)</Value>
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
              <Top>4.32938cm</Top>
              <Left>11.46191cm</Left>
              <Height>11pt</Height>
              <Width>7.02348cm</Width>
              <ZIndex>37</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr21">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(36)</Value>
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
              <Top>3.93813cm</Top>
              <Left>11.46191cm</Left>
              <Height>11pt</Height>
              <Width>7.02348cm</Width>
              <ZIndex>38</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(35)</Value>
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
              <Top>3.54688cm</Top>
              <Left>11.46191cm</Left>
              <Height>11pt</Height>
              <Width>7.02348cm</Width>
              <ZIndex>39</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="FORMATServiceShipmentHeaderDocumentDate041">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(22)</Value>
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
              <Top>7.08226cm</Top>
              <Left>3.25114cm</Left>
              <Height>11pt</Height>
              <Width>8.19688cm</Width>
              <ZIndex>40</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Textbox60">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(50)</Value>
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
              <rd:DefaultName>Textbox60</rd:DefaultName>
              <Top>2.78829in</Top>
              <Height>11pt</Height>
              <Width>3.1907cm</Width>
              <ZIndex>41</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
            <Textbox Name="EmailIdCaption1">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(51)</Value>
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
              <Top>2.63604in</Top>
              <Left>4.51111in</Left>
              <Height>11pt</Height>
              <Width>1.32669in</Width>
              <ZIndex>42</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoEmailId1">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(14)</Value>
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
              <Top>2.63604in</Top>
              <Left>5.83779in</Left>
              <Height>11pt</Height>
              <Width>1.43996in</Width>
              <ZIndex>43</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
            <Textbox Name="ServiceShptCopyText1">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(1)</Value>
                      <Style>
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
              <Top>0.81542in</Top>
              <Height>0.25in</Height>
              <Width>7.27223in</Width>
              <ZIndex>44</ZIndex>
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
        <LeftMargin>1.05834cm</LeftMargin>
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

Shared Offset As Integer
Shared NewPage As Object
Shared CurrentGroup1 As Object
Shared CurrentGroup2 As Object

Public Function GetGroupPageNumber(NewPage As Boolean, PageNumber As Integer) As Object
    If NewPage
        Offset = PageNumber - 1
        NewPage = False
    End If
    Return PageNumber - Offset
End Function

Public Function IsNewPage As Boolean
    NewPage = True
    Return NewPage
End Function

Shared HeaderData As Object

Public Function GetData(Num As Integer) As Object
   Return Cstr(Choose(Num, Split(Cstr(HeaderData),Chr(177))))
End Function

Public Function SetData(NewData As Object)
  If NewData &lt;&gt; "" Then
      HeaderData = NewData
  End If
  Return True
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>82baf48b-b02d-4bb8-bc81-2a3089e08718</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

