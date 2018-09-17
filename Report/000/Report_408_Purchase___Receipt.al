OBJECT Report 408 Purchase - Receipt
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=K�b - f�lgeseddel;
               ENU=Purchase - Receipt];
    OnInitReport=BEGIN
                   CompanyInfo.GET;
                 END;

    OnPreReport=BEGIN
                  IF NOT CurrReport.USEREQUESTPAGE THEN
                    InitLogInteraction;
                END;

    PreviewMode=PrintLayout;
  }
  DATASET
  {
    { 2822;    ;DataItem;                    ;
               DataItemTable=Table120;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Bogf�rt k�bsleverance;
                                   ENU=Posted Purchase Receipt];
               OnAfterGetRecord=BEGIN
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  FormatAddressFields("Purch. Rcpt. Header");
                                  FormatDocumentFields("Purch. Rcpt. Header");

                                  DimSetEntry1.SETRANGE("Dimension Set ID","Dimension Set ID");

                                  IF LogInteraction THEN
                                    IF NOT IsReportInPreviewMode THEN
                                      SegManagement.LogDocument(
                                        15,"No.",0,0,DATABASE::Vendor,"Buy-from Vendor No.","Purchaser Code",'',"Posting Description",'');
                                END;

               ReqFilterFields=No.,Buy-from Vendor No.,No. Printed }

    { 80  ;1   ;Column  ;No_PurchRcptHeader  ;
               SourceExpr="No." }

    { 88  ;1   ;Column  ;DocDateCaption      ;
               SourceExpr=DocDateCaptionLbl }

    { 89  ;1   ;Column  ;PageCaption         ;
               SourceExpr=PageCaptionLbl }

    { 33  ;1   ;Column  ;DescCaption         ;
               SourceExpr=DescCaptionLbl }

    { 34  ;1   ;Column  ;QtyCaption          ;
               SourceExpr=QtyCaptionLbl }

    { 35  ;1   ;Column  ;UOMCaption          ;
               SourceExpr=UOMCaptionLbl }

    { 17  ;1   ;Column  ;PaytoVenNoCaption   ;
               SourceExpr=PaytoVenNoCaptionLbl }

    { 36  ;1   ;Column  ;EmailCaption        ;
               SourceExpr=EmailCaptionLbl }

    { 5701;1   ;DataItem;CopyLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               OutputNo := 1;

                               NoOfLoops := ABS(NoOfCopies) + 1;
                               CopyText := '';
                               SETRANGE(Number,1,NoOfLoops);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number > 1 THEN BEGIN
                                    CopyText := FormatDocument.GetCOPYText;
                                    OutputNo += 1;
                                  END;
                                  CurrReport.PAGENO := 1;
                                END;

               OnPostDataItem=BEGIN
                                IF NOT IsReportInPreviewMode THEN
                                  CODEUNIT.RUN(CODEUNIT::"Purch.Rcpt.-Printed","Purch. Rcpt. Header");
                              END;
                               }

    { 6455;2   ;DataItem;PageLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 1   ;3   ;Column  ;PurchRcptCopyText   ;
               SourceExpr=STRSUBSTNO(Text002,CopyText) }

    { 2   ;3   ;Column  ;CurrentReportPageNo ;
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

    { 14  ;3   ;Column  ;CompanyInfoPhoneNo  ;
               SourceExpr=CompanyInfo."Phone No." }

    { 15  ;3   ;Column  ;ShipToAddr6         ;
               SourceExpr=ShipToAddr[6] }

    { 42  ;3   ;Column  ;CompanyInfoHomePage ;
               SourceExpr=CompanyInfo."Home Page" }

    { 38  ;3   ;Column  ;CompanyInfoEmail    ;
               SourceExpr=CompanyInfo."E-Mail" }

    { 19  ;3   ;Column  ;CompanyInfoVATRegNo ;
               SourceExpr=CompanyInfo."VAT Registration No." }

    { 21  ;3   ;Column  ;CompanyInfoGiroNo   ;
               SourceExpr=CompanyInfo."Giro No." }

    { 23  ;3   ;Column  ;CompanyInfoBankName ;
               SourceExpr=CompanyInfo."Bank Name" }

    { 25  ;3   ;Column  ;CompanyInfoBankAccNo;
               SourceExpr=CompanyInfo."Bank Account No." }

    { 26  ;3   ;Column  ;DocDate_PurchRcptHeader;
               SourceExpr=FORMAT("Purch. Rcpt. Header"."Document Date",0,4) }

    { 27  ;3   ;Column  ;PurchaserText       ;
               SourceExpr=PurchaserText }

    { 28  ;3   ;Column  ;SalesPurchPersonName;
               SourceExpr=SalesPurchPerson.Name }

    { 30  ;3   ;Column  ;No1_PurchRcptHeader ;
               SourceExpr="Purch. Rcpt. Header"."No." }

    { 31  ;3   ;Column  ;ReferenceText       ;
               SourceExpr=ReferenceText }

    { 32  ;3   ;Column  ;YourRef_PurchRcptHeader;
               SourceExpr="Purch. Rcpt. Header"."Your Reference" }

    { 3   ;3   ;Column  ;ShipToAddr7         ;
               SourceExpr=ShipToAddr[7] }

    { 60  ;3   ;Column  ;ShipToAddr8         ;
               SourceExpr=ShipToAddr[8] }

    { 61  ;3   ;Column  ;CompanyAddr5        ;
               SourceExpr=CompanyAddr[5] }

    { 62  ;3   ;Column  ;CompanyAddr6        ;
               SourceExpr=CompanyAddr[6] }

    { 48  ;3   ;Column  ;OutputNo            ;
               SourceExpr=OutputNo }

    { 13  ;3   ;Column  ;PhoneNoCaption      ;
               SourceExpr=PhoneNoCaptionLbl }

    { 16  ;3   ;Column  ;HomePageCaption     ;
               SourceExpr=HomePageCaptionLbl }

    { 18  ;3   ;Column  ;VATRegNoCaption     ;
               SourceExpr=VATRegNoCaptionLbl }

    { 20  ;3   ;Column  ;GiroNoCaption       ;
               SourceExpr=GiroNoCaptionLbl }

    { 22  ;3   ;Column  ;BankNameCaption     ;
               SourceExpr=BankNameCaptionLbl }

    { 24  ;3   ;Column  ;AccNoCaption        ;
               SourceExpr=AccNoCaptionLbl }

    { 29  ;3   ;Column  ;ShipmentNoCaption   ;
               SourceExpr=ShipmentNoCaptionLbl }

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

               DataItemLinkReference=Purch. Rcpt. Header }

    { 45  ;4   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 46  ;4   ;Column  ;HeaderDimCaption    ;
               SourceExpr=HeaderDimCaptionLbl }

    { 3042;3   ;DataItem;                    ;
               DataItemTable=Table121;
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
                                  IF (NOT ShowCorrectionLines) AND Correction THEN
                                    CurrReport.SKIP;

                                  DimSetEntry2.SETRANGE("Dimension Set ID","Dimension Set ID");
                                END;

               DataItemLinkReference=Purch. Rcpt. Header;
               DataItemLink=Document No.=FIELD(No.) }

    { 68  ;4   ;Column  ;ShowInternalInfo    ;
               SourceExpr=ShowInternalInfo }

    { 71  ;4   ;Column  ;Type_PurchRcptLine  ;
               SourceExpr=FORMAT(Type,0,2) }

    { 37  ;4   ;Column  ;Desc_PurchRcptLine  ;
               IncludeCaption=No;
               SourceExpr=Description }

    { 39  ;4   ;Column  ;Qty_PurchRcptLine   ;
               IncludeCaption=No;
               SourceExpr=Quantity }

    { 40  ;4   ;Column  ;UOM_PurchRcptLine   ;
               IncludeCaption=No;
               SourceExpr="Unit of Measure" }

    { 41  ;4   ;Column  ;No_PurchRcptLine    ;
               SourceExpr="No." }

    { 83  ;4   ;Column  ;DocNo_PurchRcptLine ;
               SourceExpr="Document No." }

    { 84  ;4   ;Column  ;LineNo_PurchRcptLine;
               IncludeCaption=No;
               SourceExpr="Line No." }

    { 43  ;4   ;Column  ;No_PurchRcptLineCaption;
               SourceExpr=FIELDCAPTION("No.") }

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

    { 65  ;5   ;Column  ;DimText1            ;
               SourceExpr=DimText }

    { 66  ;5   ;Column  ;LineDimCaption      ;
               SourceExpr=LineDimCaptionLbl }

    { 3476;3   ;DataItem;Total               ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF "Purch. Rcpt. Header"."Buy-from Vendor No." = "Purch. Rcpt. Header"."Pay-to Vendor No." THEN
                                 CurrReport.BREAK;
                             END;
                              }

    { 50  ;4   ;Column  ;BuyfromVenNo_PurchRcptHeader;
               SourceExpr="Purch. Rcpt. Header"."Buy-from Vendor No." }

    { 44  ;4   ;Column  ;BuyfromVenNo_PurchRcptHeaderCaption;
               SourceExpr="Purch. Rcpt. Header".FIELDCAPTION("Buy-from Vendor No.") }

    { 3363;3   ;DataItem;Total2              ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 53  ;4   ;Column  ;PaytoVenNo_PurchRcptHeader;
               SourceExpr="Purch. Rcpt. Header"."Pay-to Vendor No." }

    { 54  ;4   ;Column  ;VendAddr1           ;
               SourceExpr=VendAddr[1] }

    { 55  ;4   ;Column  ;VendAddr2           ;
               SourceExpr=VendAddr[2] }

    { 56  ;4   ;Column  ;VendAddr3           ;
               SourceExpr=VendAddr[3] }

    { 57  ;4   ;Column  ;VendAddr4           ;
               SourceExpr=VendAddr[4] }

    { 58  ;4   ;Column  ;VendAddr5           ;
               SourceExpr=VendAddr[5] }

    { 59  ;4   ;Column  ;VendAddr6           ;
               SourceExpr=VendAddr[6] }

    { 63  ;4   ;Column  ;VendAddr7           ;
               SourceExpr=VendAddr[7] }

    { 64  ;4   ;Column  ;VendAddr8           ;
               SourceExpr=VendAddr[8] }

    { 51  ;4   ;Column  ;PaytoAddrCaption    ;
               SourceExpr=PaytoAddrCaptionLbl }

    { 47  ;4   ;Column  ;PaytoVenNo_PurchRcptHeaderCaption;
               SourceExpr="Purch. Rcpt. Header".FIELDCAPTION("Pay-to Vendor No.") }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnInit=BEGIN
               LogInteractionEnable := TRUE;
             END;

      OnOpenPage=BEGIN
                   InitLogInteraction;
                   LogInteractionEnable := LogInteraction;
                 END;

    }
    CONTROLS
    {
      { 5   ;0   ;Container ;
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

      { 4   ;2   ;Field     ;
                  Name=LogInteraction;
                  CaptionML=[DAN=Logf�r interaktion;
                             ENU=Log Interaction];
                  ToolTipML=[DAN=Angiver, om programmet skal logf�re denne interaktion.;
                             ENU=Specifies if you want the program to log this interaction.];
                  ApplicationArea=#Advanced;
                  SourceExpr=LogInteraction;
                  Enabled=LogInteractionEnable }

      { 6   ;2   ;Field     ;
                  CaptionML=[DAN=Vis rettelseslinjer;
                             ENU=Show Correction Lines];
                  ToolTipML=[DAN=Angiver, om rettelseslinjerne for en tilbagef�rsel af antalsposteringen vises i rapporten.;
                             ENU=Specifies if the correction lines of an undoing of quantity posting will be shown on the report.];
                  ApplicationArea=#Advanced;
                  SourceExpr=ShowCorrectionLines }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text002@1002 : TextConst '@@@="%1 = Document No.";DAN=K�b - f�lgeseddel %1;ENU=Purchase - Receipt %1';
      Text003@1003 : TextConst 'DAN=Side %1;ENU=Page %1';
      CompanyInfo@1004 : Record 79;
      SalesPurchPerson@1005 : Record 13;
      DimSetEntry1@1006 : Record 480;
      DimSetEntry2@1007 : Record 480;
      Language@1008 : Record 8;
      RespCenter@1009 : Record 5714;
      FormatAddr@1021 : Codeunit 365;
      FormatDocument@1029 : Codeunit 368;
      SegManagement@1011 : Codeunit 5051;
      VendAddr@1012 : ARRAY [8] OF Text[50];
      ShipToAddr@1013 : ARRAY [8] OF Text[50];
      CompanyAddr@1014 : ARRAY [8] OF Text[50];
      PurchaserText@1015 : Text[30];
      ReferenceText@1016 : Text[80];
      MoreLines@1017 : Boolean;
      NoOfCopies@1018 : Integer;
      NoOfLoops@1019 : Integer;
      CopyText@1020 : Text[30];
      DimText@1022 : Text[120];
      OldDimText@1023 : Text[75];
      ShowInternalInfo@1024 : Boolean;
      Continue@1025 : Boolean;
      LogInteraction@1026 : Boolean;
      ShowCorrectionLines@1027 : Boolean;
      OutputNo@1028 : Integer;
      LogInteractionEnable@19003940 : Boolean INDATASET;
      PhoneNoCaptionLbl@6169 : TextConst 'DAN=Telefon;ENU=Phone No.';
      HomePageCaptionLbl@1436 : TextConst 'DAN=Hjemmeside;ENU=Home Page';
      VATRegNoCaptionLbl@2224 : TextConst 'DAN=SE/CVR-nr.;ENU=VAT Registration No.';
      GiroNoCaptionLbl@7839 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      BankNameCaptionLbl@5585 : TextConst 'DAN=Bank;ENU=Bank';
      AccNoCaptionLbl@9799 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      ShipmentNoCaptionLbl@2735 : TextConst 'DAN=Leverancenr.;ENU=Shipment No.';
      HeaderDimCaptionLbl@2848 : TextConst 'DAN=Dimensioner - hoved;ENU=Header Dimensions';
      LineDimCaptionLbl@2096 : TextConst 'DAN=Linjedimensioner;ENU=Line Dimensions';
      PaytoAddrCaptionLbl@3498 : TextConst 'DAN=Adresse;ENU=Pay-to Address';
      DocDateCaptionLbl@6175 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      PageCaptionLbl@6215 : TextConst 'DAN=Side;ENU=Page';
      DescCaptionLbl@6283 : TextConst 'DAN=Beskrivelse;ENU=Description';
      QtyCaptionLbl@5734 : TextConst 'DAN=Antal;ENU=Quantity';
      UOMCaptionLbl@3385 : TextConst 'DAN=Enhed;ENU=Unit Of Measure';
      PaytoVenNoCaptionLbl@7136 : TextConst 'DAN=Faktureringsleverand�rnr.;ENU=Pay-to Vendor No.';
      EmailCaptionLbl@7682 : TextConst 'DAN=Mail;ENU=Email';

    PROCEDURE InitializeRequest@1(NewNoOfCopies@1000 : Integer;NewShowInternalInfo@1001 : Boolean;NewLogInteraction@1002 : Boolean;NewShowCorrectionLines@1003 : Boolean);
    BEGIN
      NoOfCopies := NewNoOfCopies;
      ShowInternalInfo := NewShowInternalInfo;
      LogInteraction := NewLogInteraction;
      ShowCorrectionLines := NewShowCorrectionLines;
    END;

    LOCAL PROCEDURE IsReportInPreviewMode@8() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    LOCAL PROCEDURE InitLogInteraction@6();
    BEGIN
      LogInteraction := SegManagement.FindInteractTmplCode(15) <> '';
    END;

    LOCAL PROCEDURE FormatAddressFields@2(VAR PurchRcptHeader@1000 : Record 120);
    BEGIN
      FormatAddr.GetCompanyAddr(PurchRcptHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
      FormatAddr.PurchRcptShipTo(ShipToAddr,PurchRcptHeader);
      FormatAddr.PurchRcptPayTo(VendAddr,PurchRcptHeader);
    END;

    LOCAL PROCEDURE FormatDocumentFields@3(PurchRcptHeader@1000 : Record 120);
    BEGIN
      WITH PurchRcptHeader DO BEGIN
        FormatDocument.SetPurchaser(SalesPurchPerson,"Purchaser Code",PurchaserText);

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
      <rd:DataSourceID>7f8a9ad9-df2a-441b-beaa-25367f5fea6b</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="No_PurchRcptHeader">
          <DataField>No_PurchRcptHeader</DataField>
        </Field>
        <Field Name="DocDateCaption">
          <DataField>DocDateCaption</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="DescCaption">
          <DataField>DescCaption</DataField>
        </Field>
        <Field Name="QtyCaption">
          <DataField>QtyCaption</DataField>
        </Field>
        <Field Name="UOMCaption">
          <DataField>UOMCaption</DataField>
        </Field>
        <Field Name="PaytoVenNoCaption">
          <DataField>PaytoVenNoCaption</DataField>
        </Field>
        <Field Name="EmailCaption">
          <DataField>EmailCaption</DataField>
        </Field>
        <Field Name="PurchRcptCopyText">
          <DataField>PurchRcptCopyText</DataField>
        </Field>
        <Field Name="CurrentReportPageNo">
          <DataField>CurrentReportPageNo</DataField>
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
        <Field Name="CompanyInfoPhoneNo">
          <DataField>CompanyInfoPhoneNo</DataField>
        </Field>
        <Field Name="ShipToAddr6">
          <DataField>ShipToAddr6</DataField>
        </Field>
        <Field Name="CompanyInfoHomePage">
          <DataField>CompanyInfoHomePage</DataField>
        </Field>
        <Field Name="CompanyInfoEmail">
          <DataField>CompanyInfoEmail</DataField>
        </Field>
        <Field Name="CompanyInfoVATRegNo">
          <DataField>CompanyInfoVATRegNo</DataField>
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
        <Field Name="DocDate_PurchRcptHeader">
          <DataField>DocDate_PurchRcptHeader</DataField>
        </Field>
        <Field Name="PurchaserText">
          <DataField>PurchaserText</DataField>
        </Field>
        <Field Name="SalesPurchPersonName">
          <DataField>SalesPurchPersonName</DataField>
        </Field>
        <Field Name="No1_PurchRcptHeader">
          <DataField>No1_PurchRcptHeader</DataField>
        </Field>
        <Field Name="ReferenceText">
          <DataField>ReferenceText</DataField>
        </Field>
        <Field Name="YourRef_PurchRcptHeader">
          <DataField>YourRef_PurchRcptHeader</DataField>
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
        <Field Name="OutputNo">
          <DataField>OutputNo</DataField>
        </Field>
        <Field Name="PhoneNoCaption">
          <DataField>PhoneNoCaption</DataField>
        </Field>
        <Field Name="HomePageCaption">
          <DataField>HomePageCaption</DataField>
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
        <Field Name="AccNoCaption">
          <DataField>AccNoCaption</DataField>
        </Field>
        <Field Name="ShipmentNoCaption">
          <DataField>ShipmentNoCaption</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="HeaderDimCaption">
          <DataField>HeaderDimCaption</DataField>
        </Field>
        <Field Name="ShowInternalInfo">
          <DataField>ShowInternalInfo</DataField>
        </Field>
        <Field Name="Type_PurchRcptLine">
          <DataField>Type_PurchRcptLine</DataField>
        </Field>
        <Field Name="Desc_PurchRcptLine">
          <DataField>Desc_PurchRcptLine</DataField>
        </Field>
        <Field Name="Qty_PurchRcptLine">
          <DataField>Qty_PurchRcptLine</DataField>
        </Field>
        <Field Name="Qty_PurchRcptLineFormat">
          <DataField>Qty_PurchRcptLineFormat</DataField>
        </Field>
        <Field Name="UOM_PurchRcptLine">
          <DataField>UOM_PurchRcptLine</DataField>
        </Field>
        <Field Name="No_PurchRcptLine">
          <DataField>No_PurchRcptLine</DataField>
        </Field>
        <Field Name="DocNo_PurchRcptLine">
          <DataField>DocNo_PurchRcptLine</DataField>
        </Field>
        <Field Name="LineNo_PurchRcptLine">
          <DataField>LineNo_PurchRcptLine</DataField>
        </Field>
        <Field Name="No_PurchRcptLineCaption">
          <DataField>No_PurchRcptLineCaption</DataField>
        </Field>
        <Field Name="DimText1">
          <DataField>DimText1</DataField>
        </Field>
        <Field Name="LineDimCaption">
          <DataField>LineDimCaption</DataField>
        </Field>
        <Field Name="BuyfromVenNo_PurchRcptHeader">
          <DataField>BuyfromVenNo_PurchRcptHeader</DataField>
        </Field>
        <Field Name="BuyfromVenNo_PurchRcptHeaderCaption">
          <DataField>BuyfromVenNo_PurchRcptHeaderCaption</DataField>
        </Field>
        <Field Name="PaytoVenNo_PurchRcptHeader">
          <DataField>PaytoVenNo_PurchRcptHeader</DataField>
        </Field>
        <Field Name="VendAddr1">
          <DataField>VendAddr1</DataField>
        </Field>
        <Field Name="VendAddr2">
          <DataField>VendAddr2</DataField>
        </Field>
        <Field Name="VendAddr3">
          <DataField>VendAddr3</DataField>
        </Field>
        <Field Name="VendAddr4">
          <DataField>VendAddr4</DataField>
        </Field>
        <Field Name="VendAddr5">
          <DataField>VendAddr5</DataField>
        </Field>
        <Field Name="VendAddr6">
          <DataField>VendAddr6</DataField>
        </Field>
        <Field Name="VendAddr7">
          <DataField>VendAddr7</DataField>
        </Field>
        <Field Name="VendAddr8">
          <DataField>VendAddr8</DataField>
        </Field>
        <Field Name="PaytoAddrCaption">
          <DataField>PaytoAddrCaption</DataField>
        </Field>
        <Field Name="PaytoVenNo_PurchRcptHeaderCaption">
          <DataField>PaytoVenNo_PurchRcptHeaderCaption</DataField>
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
                  <Width>7.09913in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>3.05417in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="TableLines">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.39982in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.64967in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.52481in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.52481in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.15998in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PurchRcptLineNoCapt">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_PurchRcptLineCaption.Value</Value>
                                                    <Style>
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
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <BottomBorder>
                                                <Style>None</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="DescCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DescCaption.Value</Value>
                                                    <Style>
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
                                          <Textbox Name="QtyCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!QtyCaption.Value</Value>
                                                    <Style>
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
                                          <Textbox Name="UOMCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UOMCaption.Value</Value>
                                                    <Style>
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
                                    <Height>0.06249in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox10">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox10</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox17">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox17</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox26">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
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
                                            <rd:DefaultName>textbox26</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox27">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox27</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06249in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox29">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox29</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Style>None</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox30">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox30</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Style>None</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                                    <Value />
                                                    <Style>
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
                                            <rd:DefaultName>textbox31</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Style>None</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox33</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Style>None</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.15998in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PurchRcptLineNo">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_PurchRcptLine.Value</Value>
                                                    <Style>
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
                                            <ZIndex>9</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!ShowInternalInfo.Value = "True" AND Fields!Type_PurchRcptLine.Value="0" OR Fields!Type_PurchRcptLine.Value="2" OR Fields!Type_PurchRcptLine.Value="4",FALSE,TRUE) OR IIF(Fields!ShowInternalInfo.Value="FALSE" AND Fields!Type_PurchRcptLine.Value="1",TRUE,FALSE)</Hidden>
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
                                          <Textbox Name="PurchRcptLineDesc">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Desc_PurchRcptLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>8</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!Type_PurchRcptLine.Value="5",TRUE,FALSE)</Hidden>
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
                                          <Textbox Name="PurchRcptLineQty">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Qty_PurchRcptLine.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!Qty_PurchRcptLine.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>7</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!Type_PurchRcptLine.Value="5",TRUE,FALSE)</Hidden>
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
                                          <Textbox Name="PurchRcptLineUOM">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UOM_PurchRcptLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!Type_PurchRcptLine.Value="5",TRUE,FALSE)</Hidden>
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
                                          <Textbox Name="LineDimCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineDimCaption.Value</Value>
                                                    <Style>
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
                                              <Border />
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineDimText">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText1.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <Border />
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
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="Table1_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!Type_PurchRcptLine.Value="5",TRUE,FALSE)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowInternalInfo.Value="True",False,True)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=CStr(Fields!LineNo_PurchRcptLine.Value)</FilterExpression>
                                  <Operator>GreaterThanOrEqual</Operator>
                                  <FilterValues>
                                    <FilterValue>""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Left>0.00001in</Left>
                              <Height>1.48293cm</Height>
                              <Width>18.03177cm</Width>
                              <Style>
                                <PaddingLeft>5pt</PaddingLeft>
                                <PaddingRight>5pt</PaddingRight>
                              </Style>
                            </Tablix>
                            <Tablix Name="TableBuyFromVen">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.37483in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.36457in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PurchRcptHdrBuyfromVenNoCapt">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BuyfromVenNo_PurchRcptHeaderCaption.Value</Value>
                                                    <Style>
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
                                              <Border />
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PurchRcptHdrBuyfromVenNo">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BuyfromVenNo_PurchRcptHeader.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <Border />
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                  <FilterExpression>=Fields!BuyfromVenNo_PurchRcptHeader.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>2.2167cm</Top>
                              <Left>0.00001in</Left>
                              <Height>0.35278cm</Height>
                              <Width>9.49808cm</Width>
                              <ZIndex>1</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!BuyfromVenNo_PurchRcptHeader.Value="",TRUE,FALSE)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <PaddingLeft>5pt</PaddingLeft>
                                <PaddingRight>5pt</PaddingRight>
                              </Style>
                            </Tablix>
                            <Tablix Name="list2">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.24959in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>1.28192in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Rectangle Name="list2_Contents">
                                            <ReportItems>
                                              <Tablix Name="TableVenDetails">
                                                <TablixBody>
                                                  <TablixColumns>
                                                    <TablixColumn>
                                                      <Width>3.24959in</Width>
                                                    </TablixColumn>
                                                  </TablixColumns>
                                                  <TablixRows>
                                                    <TablixRow>
                                                      <Height>0.13889in</Height>
                                                      <TablixCells>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="VendAddr1">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!VendAddr1.Value</Value>
                                                                      <Style>
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
                                                                <Border />
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
                                                            <Textbox Name="VendAddr2">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!VendAddr2.Value</Value>
                                                                      <Style>
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
                                                                <Border />
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
                                                            <Textbox Name="VendAddr3">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!VendAddr3.Value</Value>
                                                                      <Style>
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
                                                              <ZIndex>5</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="VendAddr4">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!VendAddr4.Value</Value>
                                                                      <Style>
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
                                                              <ZIndex>4</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="VendAddr5">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!VendAddr5.Value</Value>
                                                                      <Style>
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
                                                              <ZIndex>3</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="VendAddr6">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!VendAddr6.Value</Value>
                                                                      <Style>
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
                                                            <Textbox Name="VendAddr7">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!VendAddr7.Value</Value>
                                                                      <Style>
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
                                                            <Textbox Name="VendAddr8">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!VendAddr8.Value</Value>
                                                                      <Style>
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
                                                      <Group Name="table4_Details_Group">
                                                        <DataElementName>Detail</DataElementName>
                                                      </Group>
                                                      <TablixMembers>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!VendAddr1.Value="",TRUE,FALSE)</Hidden>
                                                          </Visibility>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!VendAddr2.Value="",TRUE,FALSE)</Hidden>
                                                          </Visibility>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!VendAddr3.Value="",TRUE,FALSE)</Hidden>
                                                          </Visibility>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!VendAddr4.Value="",TRUE,FALSE)</Hidden>
                                                          </Visibility>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!VendAddr5.Value="",TRUE,FALSE)</Hidden>
                                                          </Visibility>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!VendAddr6.Value="",TRUE,FALSE)</Hidden>
                                                          </Visibility>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!VendAddr7.Value="",TRUE,FALSE)</Hidden>
                                                          </Visibility>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!VendAddr8.Value="",TRUE,FALSE)</Hidden>
                                                          </Visibility>
                                                        </TablixMember>
                                                      </TablixMembers>
                                                      <DataElementName>Detail_Collection</DataElementName>
                                                      <DataElementOutput>Output</DataElementOutput>
                                                      <KeepTogether>true</KeepTogether>
                                                    </TablixMember>
                                                  </TablixMembers>
                                                </TablixRowHierarchy>
                                                <Top>0.40736cm</Top>
                                                <Height>2.82224cm</Height>
                                                <Width>8.25396cm</Width>
                                                <Style />
                                              </Tablix>
                                              <Tablix Name="TablePayToAddress">
                                                <TablixBody>
                                                  <TablixColumns>
                                                    <TablixColumn>
                                                      <Width>1.12486in</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>2.12474in</Width>
                                                    </TablixColumn>
                                                  </TablixColumns>
                                                  <TablixRows>
                                                    <TablixRow>
                                                      <Height>0.13889in</Height>
                                                      <TablixCells>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="PaytoAddrCaption">
                                                              <CanGrow>true</CanGrow>
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!PaytoAddrCaption.Value</Value>
                                                                      <Style>
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
                                                              <ZIndex>3</ZIndex>
                                                              <Style>
                                                                <Border>
                                                                  <Style>None</Style>
                                                                </Border>
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
                                                      <Group Name="table3_Details_Group">
                                                        <DataElementName>Detail</DataElementName>
                                                      </Group>
                                                      <TablixMembers>
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
                                                    <FilterExpression>=Fields!PaytoVenNo_PurchRcptHeader.Value</FilterExpression>
                                                    <Operator>GreaterThan</Operator>
                                                    <FilterValues>
                                                      <FilterValue>""</FilterValue>
                                                    </FilterValues>
                                                  </Filter>
                                                </Filters>
                                                <Height>0.35278cm</Height>
                                                <Width>8.25398cm</Width>
                                                <ZIndex>1</ZIndex>
                                                <Visibility>
                                                  <Hidden>=IIF(Fields!PaytoVenNo_PurchRcptHeader.Value="",TRUE,FALSE)</Hidden>
                                                </Visibility>
                                                <DataElementOutput>NoOutput</DataElementOutput>
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
                                    <Group Name="list2_Details_Group">
                                      <GroupExpressions>
                                        <GroupExpression>=1</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <Top>3.34272cm</Top>
                              <Height>3.25608cm</Height>
                              <Width>8.25396cm</Width>
                              <ZIndex>2</ZIndex>
                              <Style>
                                <PaddingLeft>5pt</PaddingLeft>
                                <PaddingRight>5pt</PaddingRight>
                              </Style>
                            </Tablix>
                            <Tablix Name="TableHdrDim">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.87681in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3.50161in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.72057in</Width>
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
                                            <rd:DefaultName>Textbox1</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox2</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox4">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox4</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="HeaderDimCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!HeaderDimCaption.Value)</Value>
                                                    <Style>
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
                                              <Border />
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="DimText">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!DimText.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Top>2.6375in</Top>
                              <Left>0.00035cm</Left>
                              <Height>1.05834cm</Height>
                              <Width>18.03144cm</Width>
                              <ZIndex>3</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!DimText.Value="",TRUE,FALSE)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <PaddingLeft>5pt</PaddingLeft>
                                <PaddingRight>5pt</PaddingRight>
                              </Style>
                            </Tablix>
                            <Tablix Name="Tablehidden">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.24577in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.34001in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.3993in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.03125in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyInfo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Fields!CompanyInfoPhoneNo.Value + Chr(177) +
Fields!CompanyInfoHomePage.Value + Chr(177) +
Fields!CompanyInfoVATRegNo.Value + Chr(177) +
Fields!CompanyInfoGiroNo.Value + Chr(177) +
Fields!CompanyInfoBankName.Value + Chr(177) +
Fields!CompanyInfoBankAccNo.Value + Chr(177) + 
Fields!CompanyInfoEmail.Value, 2)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddr">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>4</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Cstr(Fields!ShipToAddr1.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr2.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr3.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr4.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr5.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr6.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr7.Value) + Chr(177) + 
Cstr(Fields!ShipToAddr8.Value) + Chr(177) + 
Cstr(Fields!PurchaserText.Value) + Chr(177) + 
Cstr(Fields!SalesPurchPersonName.Value) + Chr(177) + 
Cstr(Fields!ReferenceText.Value) + Chr(177) + 
Cstr(Fields!YourRef_PurchRcptHeader.Value) + Chr(177) + 
Cstr(Fields!AccNoCaption.Value) + Chr(177) + 
Cstr(Fields!BankNameCaption.Value) + Chr(177) + 
Cstr(Fields!GiroNoCaption.Value) + Chr(177) + 
Cstr(Fields!VATRegNoCaption.Value) + Chr(177) + 
Cstr(Fields!HomePageCaption.Value) + Chr(177) + 
Cstr(Fields!PhoneNoCaption.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr6.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr5.Value) + Chr(177) + 
Cstr(Fields!ShipmentNoCaption.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr4.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr3.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr2.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr1.Value) + Chr(177) + 
Cstr(Fields!DocDateCaption.Value) + Chr(177) + 
Cstr(Fields!PageCaption.Value) + Chr(177) + 
Cstr(Fields!EmailCaption.Value) + Chr(177) + 
Cstr(Fields!PaytoVenNoCaption.Value)
, 1)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Info">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Fields!PurchRcptCopyText.Value + Chr(177) +
Fields!DocDate_PurchRcptHeader.Value + Chr(177) +
Fields!No1_PurchRcptHeader.Value + Chr(177) +
Fields!PaytoVenNo_PurchRcptHeader.Value, 3)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <Group Name="Details" />
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Top>0.00757in</Top>
                              <Left>5.6886in</Left>
                              <Height>0.03125in</Height>
                              <Width>0.98508in</Width>
                              <ZIndex>4</ZIndex>
                              <Visibility>
                                <Hidden>true</Hidden>
                              </Visibility>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <PaddingLeft>5pt</PaddingLeft>
                                <PaddingRight>5pt</PaddingRight>
                              </Style>
                            </Tablix>
                            <Textbox Name="NewPage">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=IIF(Code.IsNewPage(Fields!No_PurchRcptHeader.Value ,Fields!OutputNo.Value),TRUE,FALSE)</Value>
                                      <Style>
                                        <Color>Red</Color>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Left>4.65305in</Left>
                              <Height>0.03266in</Height>
                              <Width>1in</Width>
                              <ZIndex>5</ZIndex>
                              <Visibility>
                                <Hidden>true</Hidden>
                              </Visibility>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
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
                      <GroupExpression>=Fields!No1_PurchRcptHeader.Value</GroupExpression>
                      <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <PageBreak>
              <BreakLocation>End</BreakLocation>
            </PageBreak>
            <Left>0.01028in</Left>
            <Height>7.75759cm</Height>
            <Width>18.03179cm</Width>
            <Style>
              <Border>
                <Width>0.25pt</Width>
              </Border>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>7.75759cm</Height>
        <Style />
      </Body>
      <Width>18.05791cm</Width>
      <Page>
        <PageHeader>
          <Height>8.4335cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="PurchRcptHdrNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(3,3)</Value>
                      <Style>
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
              <Top>6.00142cm</Top>
              <Left>3.38989cm</Left>
              <Height>11pt</Height>
              <Width>9.32978cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="AccNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(13,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.81625cm</Top>
              <Left>12.70883cm</Left>
              <Height>11pt</Height>
              <Width>2.63929cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BankNameCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(14,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.39796cm</Top>
              <Left>12.70883cm</Left>
              <Height>11pt</Height>
              <Width>2.63929cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="GiroNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(15,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.00142cm</Top>
              <Left>12.71967cm</Left>
              <Height>11pt</Height>
              <Width>2.62845cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VATRegNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(16,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>5.57312cm</Top>
              <Left>12.70883cm</Left>
              <Height>11pt</Height>
              <Width>2.63929cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="HomePageCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(17,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>4.74382cm</Top>
              <Left>12.70883cm</Left>
              <Height>11pt</Height>
              <Width>2.63929cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PhoneNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(18,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>4.33553cm</Top>
              <Left>12.70883cm</Left>
              <Height>11pt</Height>
              <Width>2.63929cm</Width>
              <ZIndex>6</ZIndex>
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
                      <Value>=Code.GetData(19,1)</Value>
                      <Style>
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
              <Top>3.91848cm</Top>
              <Left>12.83053cm</Left>
              <Height>11pt</Height>
              <Width>5.22737cm</Width>
              <ZIndex>7</ZIndex>
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
                      <Value>=Code.GetData(20,1)</Value>
                      <Style>
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
              <Top>3.49019cm</Top>
              <Left>12.83053cm</Left>
              <Height>11pt</Height>
              <Width>5.22737cm</Width>
              <ZIndex>8</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr8">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(8,1)</Value>
                      <Style>
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
              <Top>3.91848cm</Top>
              <Height>11pt</Height>
              <Width>360pt</Width>
              <ZIndex>9</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr7">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(7,1)</Value>
                      <Style>
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
              <Top>3.49019cm</Top>
              <Height>11pt</Height>
              <Width>360pt</Width>
              <ZIndex>10</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchRcptHdrYourRef">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(12,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>4.74382cm</Top>
              <Left>3.36001cm</Left>
              <Height>11pt</Height>
              <Width>9.33999cm</Width>
              <ZIndex>11</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ReferenceText">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(11,1)</Value>
                      <Style>
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
              <Top>4.74382cm</Top>
              <Height>11pt</Height>
              <Width>3.28944cm</Width>
              <ZIndex>12</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchRcptHdrNoCapt">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(21,1)</Value>
                      <Style>
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
              <Top>6.00142cm</Top>
              <Height>11pt</Height>
              <Width>3.32474cm</Width>
              <ZIndex>13</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesPurchPersonName">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(10,1)</Value>
                      <Style>
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
              <Top>7.22007cm</Top>
              <Left>15.41515cm</Left>
              <Height>11pt</Height>
              <Width>2.64276cm</Width>
              <ZIndex>14</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaserText">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(9,1)</Value>
                      <Style>
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
              <Top>7.22007cm</Top>
              <Left>5.00775in</Left>
              <Height>11pt</Height>
              <Width>2.62844cm</Width>
              <ZIndex>15</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankAccNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(6,2)</Value>
                      <Style>
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
              <Top>6.81625cm</Top>
              <Left>15.41515cm</Left>
              <Height>11pt</Height>
              <Width>2.64276cm</Width>
              <ZIndex>16</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankName">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(5,2)</Value>
                      <Style>
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
              <Top>6.39796cm</Top>
              <Left>15.41515cm</Left>
              <Height>11pt</Height>
              <Width>2.64276cm</Width>
              <ZIndex>17</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoGiroNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(4,2)</Value>
                      <Style>
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
              <Top>6.00142cm</Top>
              <Left>15.41515cm</Left>
              <Height>11pt</Height>
              <Width>2.64276cm</Width>
              <ZIndex>18</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoVATRegNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(3,2)</Value>
                      <Style>
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
              <Top>5.57312cm</Top>
              <Left>15.41515cm</Left>
              <Height>11pt</Height>
              <Width>2.64276cm</Width>
              <ZIndex>19</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoHomePage">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(2,2)</Value>
                      <Style>
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
              <Top>4.74382cm</Top>
              <Left>15.41515cm</Left>
              <Height>11pt</Height>
              <Width>2.64276cm</Width>
              <ZIndex>20</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr6">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(6,1)</Value>
                      <Style>
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
              <Top>3.07089cm</Top>
              <Height>11pt</Height>
              <Width>360pt</Width>
              <ZIndex>21</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoPhoneNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(1,2)</Value>
                      <Style>
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
              <Top>4.33553cm</Top>
              <Left>15.41515cm</Left>
              <Height>11pt</Height>
              <Width>2.64276cm</Width>
              <ZIndex>22</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr5">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(5,1)</Value>
                      <Style>
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
              <Top>2.64535cm</Top>
              <Height>11pt</Height>
              <Width>360pt</Width>
              <ZIndex>23</ZIndex>
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
                      <Value>=Code.GetData(22,1)</Value>
                      <Style>
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
              <Top>3.07089cm</Top>
              <Left>12.83053cm</Left>
              <Height>11pt</Height>
              <Width>5.22737cm</Width>
              <ZIndex>24</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr4">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(4,1)</Value>
                      <Style>
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
              <Top>2.22705cm</Top>
              <Height>11pt</Height>
              <Width>360pt</Width>
              <ZIndex>25</ZIndex>
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
                      <Value>=Code.GetData(23,1)</Value>
                      <Style>
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
              <Top>2.64535cm</Top>
              <Left>12.83053cm</Left>
              <Height>11pt</Height>
              <Width>5.22737cm</Width>
              <ZIndex>26</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr3">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(3,1)</Value>
                      <Style>
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
              <Top>1.80077cm</Top>
              <Height>11pt</Height>
              <Width>360pt</Width>
              <ZIndex>27</ZIndex>
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
                      <Value>=Code.GetData(24,1)</Value>
                      <Style>
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
              <Top>2.22705cm</Top>
              <Left>12.83053cm</Left>
              <Height>11pt</Height>
              <Width>5.22737cm</Width>
              <ZIndex>28</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(2,1)</Value>
                      <Style>
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
              <Top>1.38048cm</Top>
              <Height>11pt</Height>
              <Width>360pt</Width>
              <ZIndex>29</ZIndex>
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
                      <Value>=Code.GetData(25,1)</Value>
                      <Style>
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
              <Top>1.80077cm</Top>
              <Left>12.83053cm</Left>
              <Height>11pt</Height>
              <Width>5.22737cm</Width>
              <ZIndex>30</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShipToAddr1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(1,1)</Value>
                      <Style>
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
              <Top>0.95065cm</Top>
              <Height>11pt</Height>
              <Width>360pt</Width>
              <ZIndex>31</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchRcptTitle">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(1,3)</Value>
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
              <Top>5pt</Top>
              <Left>9.40682cm</Left>
              <Height>20pt</Height>
              <Width>8.65108cm</Width>
              <ZIndex>32</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchRcptHdrDocDateCapt">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(26,1)</Value>
                      <Style>
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
              <Top>5.57312cm</Top>
              <Height>11pt</Height>
              <Width>3.31591cm</Width>
              <ZIndex>33</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PageNumberTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(27,1) &amp; " " &amp; Code.GetGroupPageNumber(ReportItems!NewPage.Value,Globals!PageNumber)</Value>
                      <Style>
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
              <Top>0.95065cm</Top>
              <Left>12.83053cm</Left>
              <Height>11pt</Height>
              <Width>5.22737cm</Width>
              <ZIndex>34</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchRcptHdrDocDate">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(2,3)</Value>
                      <Style>
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
              <Top>5.57312cm</Top>
              <Left>3.38989cm</Left>
              <Height>11pt</Height>
              <Width>9.32978cm</Width>
              <ZIndex>35</ZIndex>
              <Style />
            </Textbox>
            <Textbox Name="EmailCaptionion">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(28,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>2.03in</Top>
              <Left>5.01389in</Left>
              <Height>11pt</Height>
              <Width>2.63929cm</Width>
              <ZIndex>39</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoEMail">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(7,2)</Value>
                      <Style>
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
              <Top>2.03in</Top>
              <Left>15.41515cm</Left>
              <Height>11pt</Height>
              <Width>2.64276cm</Width>
              <ZIndex>40</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
            <Textbox Name="PurchRcptHdrPaytoVenNoCapt">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(29,1)</Value>
                      <Style>
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
              <Top>2.03in</Top>
              <Left>0.0204cm</Left>
              <Height>11pt</Height>
              <Width>3.23378cm</Width>
              <ZIndex>41</ZIndex>
              <Style>
                <Border />
              </Style>
            </Textbox>
            <Textbox Name="PurchRcptHdrPaytoVenNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(4,3)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>2.03in</Top>
              <Left>3.36001cm</Left>
              <Height>11pt</Height>
              <Width>9.33999cm</Width>
              <ZIndex>42</ZIndex>
              <Style>
                <Border />
              </Style>
            </Textbox>
          </ReportItems>
          <Style />
        </PageHeader>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <LeftMargin>1.76388cm</LeftMargin>
        <RightMargin>1.05834cm</RightMargin>
        <TopMargin>0.88194cm</TopMargin>
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
Shared Data3 as Object

Public Function GetData(Num as Integer, Group as integer) as Object
if Group = 1 then
   Return Cstr(Choose(Num, Split(Cstr(Data1),Chr(177))))
End If

if Group = 2 then
   Return Cstr(Choose(Num, Split(Cstr(Data2),Chr(177))))
End If

if Group = 3 then
   Return Cstr(Choose(Num, Split(Cstr(Data3),Chr(177))))
End If
End Function

Public Function SetData(NewData as Object,Group as integer)
  If Group = 1 and NewData &gt; "" Then
      Data1 = NewData
  End If

  If Group = 2 and NewData &gt; "" Then
      Data2 = NewData
  End If

  If Group = 3 and NewData &gt; "" Then
      Data3 = NewData
  End If
End Function

Shared NoOfPages as Integer

Public Function SetNoOfCopies(value as Integer)
      NoOfPages=value
End Function

Public Function GetNoOfCopies()
      Return NoOfPages
End Function
</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>d241ffee-7df1-4c9e-bac1-892b9e90e073</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

