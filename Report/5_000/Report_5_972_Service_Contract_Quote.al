OBJECT Report 5972 Service Contract Quote
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicekontrakttilbud;
               ENU=Service Contract Quote];
    OnInitReport=BEGIN
                   CompanyInfo.GET;
                   ServiceSetup.GET;
                   FormatDocument.SetLogoPosition(ServiceSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
                 END;

  }
  DATASET
  {
    { 9952;    ;DataItem;                    ;
               DataItemTable=Table5965;
               DataItemTableView=SORTING(Contract Type,Contract No.)
                                 WHERE(Contract Type=FILTER(Quote));
               PrintOnlyIfDetail=Yes;
               OnAfterGetRecord=BEGIN
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  FormatAddr.GetCompanyAddr("Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
                                  FormatAddr.ServContractSellto(CustAddr,"Service Contract Header");
                                  ShowShippingAddr := "Ship-to Code" <> '' ;
                                  IF ShowShippingAddr THEN
                                    FormatAddr.ServContractShipto(ShipToAddr,"Service Contract Header");

                                  IF LogInteraction THEN
                                    IF NOT IsReportInPreviewMode THEN BEGIN
                                      IF "Contact No." <> '' THEN
                                        SegManagement.LogDocument(
                                          24,"Contract No.",0,0,DATABASE::Contact,"Contact No.","Salesperson Code",'','','')
                                      ELSE
                                        SegManagement.LogDocument(
                                          24,"Contract No.",0,0,DATABASE::Customer,"Customer No.","Salesperson Code",'','','')
                                    END;
                                END;

               ReqFilterFields=Contract No.,Customer No.;
               CalcFields=Bill-to Name }

    { 94  ;1   ;Column  ;ContType_ServContractHdr;
               SourceExpr="Contract Type" }

    { 95  ;1   ;Column  ;ContNo_ServContractHdr;
               IncludeCaption=Yes;
               SourceExpr="Contract No." }

    { 5701;1   ;DataItem;CopyLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               NoOfLoops := ABS(NoOfCopies) + 1;
                               IF NoOfLoops <= 0 THEN
                                 NoOfLoops := 1;
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
                                END;
                                 }

    { 49  ;2   ;Column  ;OutputNo            ;
               SourceExpr=OutputNo }

    { 6455;2   ;DataItem;PageLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 46  ;3   ;Column  ;CompanyInfoPicture  ;
               SourceExpr=CompanyInfo.Picture }

    { 47  ;3   ;Column  ;CompanyInfo1Picture ;
               SourceExpr=CompanyInfo1.Picture }

    { 48  ;3   ;Column  ;CompanyInfo2Picture ;
               SourceExpr=CompanyInfo2.Picture }

    { 7   ;3   ;Column  ;CompanyInfo3Picture ;
               SourceExpr=CompanyInfo3.Picture }

    { 1   ;3   ;Column  ;AnnualAmt_ServContractHdr;
               IncludeCaption=Yes;
               SourceExpr="Service Contract Header"."Annual Amount" }

    { 60  ;3   ;Column  ;InvPeriod_ServContractHdr;
               IncludeCaption=Yes;
               SourceExpr="Service Contract Header"."Invoice Period" }

    { 61  ;3   ;Column  ;StartDt_ServContractHdr;
               SourceExpr=FORMAT("Service Contract Header"."Starting Date") }

    { 62  ;3   ;Column  ;NextInvDate_ServContractHdr;
               SourceExpr=FORMAT("Service Contract Header"."Next Invoice Date") }

    { 63  ;3   ;Column  ;AcceptBef_ServContractHdr;
               IncludeCaption=Yes;
               SourceExpr="Service Contract Header"."Accept Before" }

    { 65  ;3   ;Column  ;CompanyAddr6        ;
               SourceExpr=CompanyAddr[6] }

    { 66  ;3   ;Column  ;CompanyAddr5        ;
               SourceExpr=CompanyAddr[5] }

    { 73  ;3   ;Column  ;CompanyAddr4        ;
               SourceExpr=CompanyAddr[4] }

    { 74  ;3   ;Column  ;CompanyAddr3        ;
               SourceExpr=CompanyAddr[3] }

    { 75  ;3   ;Column  ;CompanyAddr2        ;
               SourceExpr=CompanyAddr[2] }

    { 76  ;3   ;Column  ;CompanyAddr1        ;
               SourceExpr=CompanyAddr[1] }

    { 77  ;3   ;Column  ;CurrReportPageNo    ;
               SourceExpr=STRSUBSTNO(Text002,FORMAT(CurrReport.PAGENO)) }

    { 78  ;3   ;Column  ;ServContractQuote   ;
               SourceExpr=STRSUBSTNO(Text001,CopyText) }

    { 79  ;3   ;Column  ;CustAddr6           ;
               SourceExpr=CustAddr[6] }

    { 80  ;3   ;Column  ;CustAddr5           ;
               SourceExpr=CustAddr[5] }

    { 81  ;3   ;Column  ;CustAddr4           ;
               SourceExpr=CustAddr[4] }

    { 82  ;3   ;Column  ;CustAddr2           ;
               SourceExpr=CustAddr[2] }

    { 83  ;3   ;Column  ;CustAddr3           ;
               SourceExpr=CustAddr[3] }

    { 84  ;3   ;Column  ;CustAddr1           ;
               SourceExpr=CustAddr[1] }

    { 85  ;3   ;Column  ;BilltoNam_ServContractHdr;
               SourceExpr="Service Contract Header"."Bill-to Name" }

    { 40  ;3   ;Column  ;CompanyInfoPhoneNo  ;
               SourceExpr=CompanyInfo."Phone No." }

    { 41  ;3   ;Column  ;CompanyInfoFaxNo    ;
               SourceExpr=CompanyInfo."Fax No." }

    { 42  ;3   ;Column  ;EMail_ServContractHdr;
               SourceExpr="Service Contract Header"."E-Mail" }

    { 43  ;3   ;Column  ;PhoneNo_ServContractHdr;
               SourceExpr="Service Contract Header"."Phone No." }

    { 54  ;3   ;Column  ;PageCaption         ;
               SourceExpr=STRSUBSTNO(Text002,'') }

    { 69  ;3   ;Column  ;ServContractStartDtCptn;
               SourceExpr=ServContractStartDtCptnLbl }

    { 71  ;3   ;Column  ;ServContractNextInvDtCptn;
               SourceExpr=ServContractNextInvDtCptnLbl }

    { 86  ;3   ;Column  ;InvoicetoCaption    ;
               SourceExpr=InvoicetoCaptionLbl }

    { 28  ;3   ;Column  ;CompanyInfoPhoneNoCaption;
               SourceExpr=CompanyInfoPhoneNoCaptionLbl }

    { 39  ;3   ;Column  ;CompanyInfoFaxNoCaption;
               SourceExpr=CompanyInfoFaxNoCaptionLbl }

    { 44  ;3   ;Column  ;ServContractPhoneNoCptn;
               SourceExpr=ServContractPhoneNoCptnLbl }

    { 45  ;3   ;Column  ;ServContractEMailCaption;
               SourceExpr=ServContractEMailCaptionLbl }

    { 7607;3   ;DataItem;                    ;
               DataItemTable=Table5972;
               DataItemTableView=SORTING(Contract Type,Contract No.,Type,No.,Starting Date);
               DataItemLinkReference=Service Contract Header;
               DataItemLink=Contract Type=FIELD(Contract Type),
                            Contract No.=FIELD(Contract No.) }

    { 14  ;4   ;Column  ;Type_ContractServDisc;
               IncludeCaption=Yes;
               SourceExpr=Type }

    { 30  ;4   ;Column  ;No_ContractServDisc ;
               IncludeCaption=Yes;
               SourceExpr="No." }

    { 32  ;4   ;Column  ;StartDt_ContractServDisc;
               SourceExpr=FORMAT("Starting Date") }

    { 34  ;4   ;Column  ;Discount_ContractServDisc;
               IncludeCaption=Yes;
               SourceExpr="Discount %" }

    { 99  ;4   ;Column  ;ContNo_ContractServDisc;
               SourceExpr="Contract No." }

    { 33  ;4   ;Column  ;ContractServDiscStrtDtCptn;
               SourceExpr=ContractServDiscStrtDtCptnLbl }

    { 36  ;4   ;Column  ;ServiceDiscountsCaption;
               SourceExpr=ServiceDiscountsCaptionLbl }

    { 6062;3   ;DataItem;                    ;
               DataItemTable=Table5964;
               DataItemTableView=SORTING(Contract Type,Contract No.,Line No.);
               DataItemLinkReference=Service Contract Header;
               DataItemLink=Contract Type=FIELD(Contract Type),
                            Contract No.=FIELD(Contract No.) }

    { 3   ;4   ;Column  ;ServItemNo_ServContractLine;
               IncludeCaption=Yes;
               SourceExpr="Service Item No." }

    { 21  ;4   ;Column  ;Desc_ServContractLine;
               IncludeCaption=Yes;
               SourceExpr=Description }

    { 37  ;4   ;Column  ;ItemNo_ServContractLine;
               IncludeCaption=Yes;
               SourceExpr="Item No." }

    { 50  ;4   ;Column  ;SlNo_ServContractLine;
               IncludeCaption=Yes;
               SourceExpr="Serial No." }

    { 52  ;4   ;Column  ;ServicePeriod_ServContractLine;
               IncludeCaption=Yes;
               SourceExpr="Service Period" }

    { 2   ;4   ;Column  ;UOMCode_ServContractLine;
               IncludeCaption=Yes;
               SourceExpr="Unit of Measure Code" }

    { 16  ;4   ;Column  ;RespTime_ServContractLine;
               IncludeCaption=Yes;
               SourceExpr="Response Time (Hours)" }

    { 18  ;4   ;Column  ;LineValue_ServContractLine;
               IncludeCaption=Yes;
               SourceExpr="Line Value" }

    { 101 ;4   ;Column  ;ContType_ServContractLine;
               SourceExpr="Contract Type" }

    { 102 ;4   ;Column  ;ContNo_ServContractLine;
               SourceExpr="Contract No." }

    { 103 ;4   ;Column  ;LineNo_ServContractLine;
               SourceExpr="Line No." }

    { 9771;4   ;DataItem;                    ;
               DataItemTable=Table5906;
               DataItemTableView=SORTING(Table Name,Table Subtype,No.,Type,Table Line No.,Line No.)
                                 ORDER(Ascending)
                                 WHERE(Table Name=FILTER(Service Contract));
               OnPreDataItem=BEGIN
                               IF NOT ShowComments THEN
                                 CurrReport.BREAK;
                             END;

               DataItemLink=Table Subtype=FIELD(Contract Type),
                            Table Line No.=FIELD(Line No.),
                            No.=FIELD(Contract No.) }

    { 55  ;5   ;Column  ;ShowComments        ;
               SourceExpr=ShowComments }

    { 9   ;5   ;Column  ;Date_ServiceCommentLine;
               SourceExpr=FORMAT(Date) }

    { 11  ;5   ;Column  ;Comment_ServCommentLine;
               IncludeCaption=Yes;
               SourceExpr=Comment }

    { 106 ;5   ;Column  ;TblSbtype_ServiceCommLine;
               SourceExpr="Table Subtype" }

    { 108 ;5   ;Column  ;Type_ServiceCommentLine;
               SourceExpr=Type }

    { 110 ;5   ;Column  ;LineNo_ServiceCommentLine;
               SourceExpr="Line No." }

    { 10  ;5   ;Column  ;ServCommentLineDtCaption;
               SourceExpr=ServCommentLineDtCaptionLbl }

    { 6218;2   ;DataItem;Shipto              ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF NOT ShowShippingAddr THEN
                                 CurrReport.BREAK;
                             END;
                              }

    { 20  ;3   ;Column  ;ShipToAddr6         ;
               SourceExpr=ShipToAddr[6] }

    { 23  ;3   ;Column  ;ShipToAddr5         ;
               SourceExpr=ShipToAddr[5] }

    { 24  ;3   ;Column  ;ShipToAddr4         ;
               SourceExpr=ShipToAddr[4] }

    { 25  ;3   ;Column  ;ShipToAddr3         ;
               SourceExpr=ShipToAddr[3] }

    { 26  ;3   ;Column  ;ShipToAddr2         ;
               SourceExpr=ShipToAddr[2] }

    { 58  ;3   ;Column  ;ShipToAddr1         ;
               SourceExpr=ShipToAddr[1] }

    { 56  ;3   ;Column  ;ShipToCode          ;
               SourceExpr="Service Contract Header"."Ship-to Code" }

    { 19  ;3   ;Column  ;ShiptoAddressCaption;
               SourceExpr=ShiptoAddressCaptionLbl }

    { 2756;2   ;DataItem;ServCommentLine2    ;
               DataItemTable=Table5906;
               DataItemTableView=SORTING(Table Name,Table Subtype,No.,Type,Table Line No.,Line No.)
                                 ORDER(Ascending)
                                 WHERE(Table Name=FILTER(Service Contract),
                                       Table Line No.=FILTER(0));
               OnPreDataItem=BEGIN
                               IF NOT ShowComments THEN
                                 CurrReport.BREAK;
                             END;

               DataItemLinkReference=Service Contract Header;
               DataItemLink=No.=FIELD(Contract No.),
                            Table Subtype=FIELD(Contract Type) }

    { 57  ;3   ;Column  ;ShowComments1       ;
               SourceExpr=ShowComments }

    { 4   ;3   ;Column  ;Date_ServCommentLine2;
               SourceExpr=FORMAT(Date) }

    { 6   ;3   ;Column  ;Comment_ServCommentLine2;
               IncludeCaption=Yes;
               SourceExpr=Comment }

    { 113 ;3   ;Column  ;ServCommentLine2TableSubtype;
               SourceExpr="Table Subtype" }

    { 115 ;3   ;Column  ;Type_ServCommentLine2;
               SourceExpr=Type }

    { 117 ;3   ;Column  ;LineNo_ServCommentLine2;
               SourceExpr="Line No." }

    { 8   ;3   ;Column  ;CommentsCaption     ;
               SourceExpr=CommentsCaptionLbl }

    { 5   ;3   ;Column  ;ServCommentLine2DtCaption;
               SourceExpr=ServCommentLine2DtCaptionLbl }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      OnInit=BEGIN
               LogInteractionEnable := TRUE;
             END;

      OnOpenPage=BEGIN
                   LogInteraction := SegManagement.FindInteractTmplCode(24) <> '';
                   LogInteractionEnable := LogInteraction;
                 END;

    }
    CONTROLS
    {
      { 4   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 2   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Antal kopier;
                             ENU=No. of Copies];
                  ToolTipML=[DAN=Angiver, hvor mange kopier af bilaget der udskrives.;
                             ENU=Specifies how many copies of the document to print.];
                  ApplicationArea=#Service;
                  SourceExpr=NoOfCopies }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Vis bem�rkninger;
                             ENU=Show Comments];
                  ToolTipML=[DAN=Angiver, om den udskrevne rapport skal vise eventuelle kommentarer til et element for et servicekontrakttilbud.;
                             ENU=Specifies if you want the printed report to show any comments to a service contract quote item.];
                  ApplicationArea=#Service;
                  SourceExpr=ShowComments }

      { 5   ;2   ;Field     ;
                  Name=LogInteraction;
                  CaptionML=[DAN=Logf�r interaktion;
                             ENU=Log Interaction];
                  ToolTipML=[DAN=Angiver, om de udskrevne kontrakttilbud skal registreres som interaktioner og f�jes til tabellen Interaktionslogpost.;
                             ENU=Specifies if you want the service contract quotes that you print to be recorded as interactions and to be added to the Interaction Log Entry table.];
                  ApplicationArea=#Service;
                  SourceExpr=LogInteraction;
                  Enabled=LogInteractionEnable }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      CompanyInfo@1000 : Record 79;
      CompanyInfo1@1018 : Record 79;
      CompanyInfo2@1017 : Record 79;
      CompanyInfo3@1033 : Record 79;
      ServiceSetup@1016 : Record 5911;
      RespCenter@1001 : Record 5714;
      Language@1012 : Record 8;
      FormatAddr@1002 : Codeunit 365;
      FormatDocument@1019 : Codeunit 368;
      SegManagement@1015 : Codeunit 5051;
      CustAddr@1003 : ARRAY [8] OF Text[50];
      ShipToAddr@1005 : ARRAY [8] OF Text[50];
      CompanyAddr@1004 : ARRAY [8] OF Text[50];
      ShowShippingAddr@1006 : Boolean;
      ShowComments@1013 : Boolean;
      NoOfCopies@1009 : Integer;
      NoOfLoops@1008 : Integer;
      CopyText@1007 : Text[30];
      Text001@1011 : TextConst 'DAN=Servicekontrakttilbud %1;ENU=Service Contract Quote %1';
      Text002@1010 : TextConst 'DAN=Side %1;ENU=Page %1';
      LogInteraction@1014 : Boolean;
      OutputNo@1020 : Integer;
      LogInteractionEnable@19003940 : Boolean INDATASET;
      ServContractStartDtCptnLbl@2844 : TextConst 'DAN=Startdato;ENU=Starting Date';
      ServContractNextInvDtCptnLbl@2163 : TextConst 'DAN=N�ste faktureringsdato;ENU=Next Invoice Date';
      InvoicetoCaptionLbl@4263 : TextConst 'DAN=Fakturer til;ENU=Invoice to';
      CompanyInfoPhoneNoCaptionLbl@6373 : TextConst 'DAN=Telefon;ENU=Phone No.';
      CompanyInfoFaxNoCaptionLbl@3758 : TextConst 'DAN=Telefax;ENU=Fax No.';
      ServContractPhoneNoCptnLbl@3691 : TextConst 'DAN=Telefon;ENU=Phone No.';
      ServContractEMailCaptionLbl@1608 : TextConst 'DAN=Mail;ENU=Email';
      ContractServDiscStrtDtCptnLbl@4827 : TextConst 'DAN=Startdato;ENU=Starting Date';
      ServiceDiscountsCaptionLbl@1215 : TextConst 'DAN=Servicerabatter;ENU=Service Discounts';
      ServCommentLineDtCaptionLbl@8707 : TextConst 'DAN=Dato;ENU=Date';
      ShiptoAddressCaptionLbl@8743 : TextConst 'DAN=Leveringsadresse;ENU=Ship-to Address';
      CommentsCaptionLbl@7447 : TextConst 'DAN=Bem�rkninger;ENU=Comments';
      ServCommentLine2DtCaptionLbl@7864 : TextConst 'DAN=Dato;ENU=Date';

    LOCAL PROCEDURE IsReportInPreviewMode@8() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    PROCEDURE InitializeRequestComment@1(ShowCommentsFrom@1000 : Boolean);
    BEGIN
      ShowComments := ShowCommentsFrom;
    END;

    BEGIN
    {
      CurrReport.SHOWOUTPUT := FALSE;
    }
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
      <rd:DataSourceID>0f2b0057-2d98-47e6-935b-98c2374103ed</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="ContType_ServContractHdr">
          <DataField>ContType_ServContractHdr</DataField>
        </Field>
        <Field Name="ContNo_ServContractHdr">
          <DataField>ContNo_ServContractHdr</DataField>
        </Field>
        <Field Name="OutputNo">
          <DataField>OutputNo</DataField>
        </Field>
        <Field Name="CompanyInfoPicture">
          <DataField>CompanyInfoPicture</DataField>
        </Field>
        <Field Name="CompanyInfo1Picture">
          <DataField>CompanyInfo1Picture</DataField>
        </Field>
        <Field Name="CompanyInfo2Picture">
          <DataField>CompanyInfo2Picture</DataField>
        </Field>
        <Field Name="CompanyInfo3Picture">
          <DataField>CompanyInfo3Picture</DataField>
        </Field>
        <Field Name="AnnualAmt_ServContractHdr">
          <DataField>AnnualAmt_ServContractHdr</DataField>
        </Field>
        <Field Name="AnnualAmt_ServContractHdrFormat">
          <DataField>AnnualAmt_ServContractHdrFormat</DataField>
        </Field>
        <Field Name="InvPeriod_ServContractHdr">
          <DataField>InvPeriod_ServContractHdr</DataField>
        </Field>
        <Field Name="StartDt_ServContractHdr">
          <DataField>StartDt_ServContractHdr</DataField>
        </Field>
        <Field Name="NextInvDate_ServContractHdr">
          <DataField>NextInvDate_ServContractHdr</DataField>
        </Field>
        <Field Name="AcceptBef_ServContractHdr">
          <DataField>AcceptBef_ServContractHdr</DataField>
        </Field>
        <Field Name="CompanyAddr6">
          <DataField>CompanyAddr6</DataField>
        </Field>
        <Field Name="CompanyAddr5">
          <DataField>CompanyAddr5</DataField>
        </Field>
        <Field Name="CompanyAddr4">
          <DataField>CompanyAddr4</DataField>
        </Field>
        <Field Name="CompanyAddr3">
          <DataField>CompanyAddr3</DataField>
        </Field>
        <Field Name="CompanyAddr2">
          <DataField>CompanyAddr2</DataField>
        </Field>
        <Field Name="CompanyAddr1">
          <DataField>CompanyAddr1</DataField>
        </Field>
        <Field Name="CurrReportPageNo">
          <DataField>CurrReportPageNo</DataField>
        </Field>
        <Field Name="ServContractQuote">
          <DataField>ServContractQuote</DataField>
        </Field>
        <Field Name="CustAddr6">
          <DataField>CustAddr6</DataField>
        </Field>
        <Field Name="CustAddr5">
          <DataField>CustAddr5</DataField>
        </Field>
        <Field Name="CustAddr4">
          <DataField>CustAddr4</DataField>
        </Field>
        <Field Name="CustAddr2">
          <DataField>CustAddr2</DataField>
        </Field>
        <Field Name="CustAddr3">
          <DataField>CustAddr3</DataField>
        </Field>
        <Field Name="CustAddr1">
          <DataField>CustAddr1</DataField>
        </Field>
        <Field Name="BilltoNam_ServContractHdr">
          <DataField>BilltoNam_ServContractHdr</DataField>
        </Field>
        <Field Name="CompanyInfoPhoneNo">
          <DataField>CompanyInfoPhoneNo</DataField>
        </Field>
        <Field Name="CompanyInfoFaxNo">
          <DataField>CompanyInfoFaxNo</DataField>
        </Field>
        <Field Name="EMail_ServContractHdr">
          <DataField>EMail_ServContractHdr</DataField>
        </Field>
        <Field Name="PhoneNo_ServContractHdr">
          <DataField>PhoneNo_ServContractHdr</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="ServContractStartDtCptn">
          <DataField>ServContractStartDtCptn</DataField>
        </Field>
        <Field Name="ServContractNextInvDtCptn">
          <DataField>ServContractNextInvDtCptn</DataField>
        </Field>
        <Field Name="InvoicetoCaption">
          <DataField>InvoicetoCaption</DataField>
        </Field>
        <Field Name="CompanyInfoPhoneNoCaption">
          <DataField>CompanyInfoPhoneNoCaption</DataField>
        </Field>
        <Field Name="CompanyInfoFaxNoCaption">
          <DataField>CompanyInfoFaxNoCaption</DataField>
        </Field>
        <Field Name="ServContractPhoneNoCptn">
          <DataField>ServContractPhoneNoCptn</DataField>
        </Field>
        <Field Name="ServContractEMailCaption">
          <DataField>ServContractEMailCaption</DataField>
        </Field>
        <Field Name="Type_ContractServDisc">
          <DataField>Type_ContractServDisc</DataField>
        </Field>
        <Field Name="No_ContractServDisc">
          <DataField>No_ContractServDisc</DataField>
        </Field>
        <Field Name="StartDt_ContractServDisc">
          <DataField>StartDt_ContractServDisc</DataField>
        </Field>
        <Field Name="Discount_ContractServDisc">
          <DataField>Discount_ContractServDisc</DataField>
        </Field>
        <Field Name="Discount_ContractServDiscFormat">
          <DataField>Discount_ContractServDiscFormat</DataField>
        </Field>
        <Field Name="ContNo_ContractServDisc">
          <DataField>ContNo_ContractServDisc</DataField>
        </Field>
        <Field Name="ContractServDiscStrtDtCptn">
          <DataField>ContractServDiscStrtDtCptn</DataField>
        </Field>
        <Field Name="ServiceDiscountsCaption">
          <DataField>ServiceDiscountsCaption</DataField>
        </Field>
        <Field Name="ServItemNo_ServContractLine">
          <DataField>ServItemNo_ServContractLine</DataField>
        </Field>
        <Field Name="Desc_ServContractLine">
          <DataField>Desc_ServContractLine</DataField>
        </Field>
        <Field Name="ItemNo_ServContractLine">
          <DataField>ItemNo_ServContractLine</DataField>
        </Field>
        <Field Name="SlNo_ServContractLine">
          <DataField>SlNo_ServContractLine</DataField>
        </Field>
        <Field Name="ServicePeriod_ServContractLine">
          <DataField>ServicePeriod_ServContractLine</DataField>
        </Field>
        <Field Name="UOMCode_ServContractLine">
          <DataField>UOMCode_ServContractLine</DataField>
        </Field>
        <Field Name="RespTime_ServContractLine">
          <DataField>RespTime_ServContractLine</DataField>
        </Field>
        <Field Name="RespTime_ServContractLineFormat">
          <DataField>RespTime_ServContractLineFormat</DataField>
        </Field>
        <Field Name="LineValue_ServContractLine">
          <DataField>LineValue_ServContractLine</DataField>
        </Field>
        <Field Name="LineValue_ServContractLineFormat">
          <DataField>LineValue_ServContractLineFormat</DataField>
        </Field>
        <Field Name="ContType_ServContractLine">
          <DataField>ContType_ServContractLine</DataField>
        </Field>
        <Field Name="ContNo_ServContractLine">
          <DataField>ContNo_ServContractLine</DataField>
        </Field>
        <Field Name="LineNo_ServContractLine">
          <DataField>LineNo_ServContractLine</DataField>
        </Field>
        <Field Name="ShowComments">
          <DataField>ShowComments</DataField>
        </Field>
        <Field Name="Date_ServiceCommentLine">
          <DataField>Date_ServiceCommentLine</DataField>
        </Field>
        <Field Name="Comment_ServCommentLine">
          <DataField>Comment_ServCommentLine</DataField>
        </Field>
        <Field Name="TblSbtype_ServiceCommLine">
          <DataField>TblSbtype_ServiceCommLine</DataField>
        </Field>
        <Field Name="Type_ServiceCommentLine">
          <DataField>Type_ServiceCommentLine</DataField>
        </Field>
        <Field Name="LineNo_ServiceCommentLine">
          <DataField>LineNo_ServiceCommentLine</DataField>
        </Field>
        <Field Name="ServCommentLineDtCaption">
          <DataField>ServCommentLineDtCaption</DataField>
        </Field>
        <Field Name="ShipToAddr6">
          <DataField>ShipToAddr6</DataField>
        </Field>
        <Field Name="ShipToAddr5">
          <DataField>ShipToAddr5</DataField>
        </Field>
        <Field Name="ShipToAddr4">
          <DataField>ShipToAddr4</DataField>
        </Field>
        <Field Name="ShipToAddr3">
          <DataField>ShipToAddr3</DataField>
        </Field>
        <Field Name="ShipToAddr2">
          <DataField>ShipToAddr2</DataField>
        </Field>
        <Field Name="ShipToAddr1">
          <DataField>ShipToAddr1</DataField>
        </Field>
        <Field Name="ShipToCode">
          <DataField>ShipToCode</DataField>
        </Field>
        <Field Name="ShiptoAddressCaption">
          <DataField>ShiptoAddressCaption</DataField>
        </Field>
        <Field Name="ShowComments1">
          <DataField>ShowComments1</DataField>
        </Field>
        <Field Name="Date_ServCommentLine2">
          <DataField>Date_ServCommentLine2</DataField>
        </Field>
        <Field Name="Comment_ServCommentLine2">
          <DataField>Comment_ServCommentLine2</DataField>
        </Field>
        <Field Name="ServCommentLine2TableSubtype">
          <DataField>ServCommentLine2TableSubtype</DataField>
        </Field>
        <Field Name="Type_ServCommentLine2">
          <DataField>Type_ServCommentLine2</DataField>
        </Field>
        <Field Name="LineNo_ServCommentLine2">
          <DataField>LineNo_ServCommentLine2</DataField>
        </Field>
        <Field Name="CommentsCaption">
          <DataField>CommentsCaption</DataField>
        </Field>
        <Field Name="ServCommentLine2DtCaption">
          <DataField>ServCommentLine2DtCaption</DataField>
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
                  <Width>7.20472in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>7.5578in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Textbox Name="ServiceContractHeaderBilltoCustomerNoCaption1">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!InvoicetoCaption.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                        <FontWeight>Bold</FontWeight>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Top>5.13021cm</Top>
                              <Height>0.423cm</Height>
                              <Width>3.45cm</Width>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Image Name="CompanyInfo2Picture1">
                              <Source>Database</Source>
                              <Value>=Fields!CompanyInfo2Picture.Value</Value>
                              <MIMEType>image/bmp</MIMEType>
                              <Sizing>FitProportional</Sizing>
                              <Top>1cm</Top>
                              <Left>12cm</Left>
                              <Height>14mm</Height>
                              <Width>60mm</Width>
                              <ZIndex>1</ZIndex>
                              <Visibility>
                                <Hidden>=iif(Code.IsEmpty(Fields!CompanyInfo2Picture.Value), true, false)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Image>
                            <Textbox Name="CompanyAddr11">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CompanyAddr1.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                        <FontWeight>Bold</FontWeight>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Top>1.26984cm</Top>
                              <Left>11.7cm</Left>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>2</ZIndex>
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
                                      <Value>=Fields!CompanyAddr2.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Top>1.69283cm</Top>
                              <Left>11.7cm</Left>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>3</ZIndex>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Image Name="CompanyInfo1Picture1">
                              <Source>Database</Source>
                              <Value>=Fields!CompanyInfo1Picture.Value</Value>
                              <MIMEType>image/bmp</MIMEType>
                              <Sizing>FitProportional</Sizing>
                              <Top>1cm</Top>
                              <Left>6cm</Left>
                              <Height>14mm</Height>
                              <Width>60mm</Width>
                              <ZIndex>4</ZIndex>
                              <Visibility>
                                <Hidden>=iif(Code.IsEmpty(Fields!CompanyInfo1Picture.Value), true, false)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Image>
                            <Textbox Name="CompanyAddr31">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CompanyAddr3.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.11584cm</Top>
                              <Left>11.7cm</Left>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>5</ZIndex>
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
                                      <Value>=Fields!CompanyAddr4.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.53883cm</Top>
                              <Left>11.7cm</Left>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>6</ZIndex>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Image Name="CompanyInfoPicture1">
                              <Source>Database</Source>
                              <Value>=Fields!CompanyInfo3Picture.Value</Value>
                              <MIMEType>image/bmp</MIMEType>
                              <Sizing>FitProportional</Sizing>
                              <Top>1cm</Top>
                              <Height>14mm</Height>
                              <Width>60mm</Width>
                              <ZIndex>7</ZIndex>
                              <Visibility>
                                <Hidden>=iif(Code.IsEmpty(Fields!CompanyInfo3Picture.Value), true, false)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Image>
                            <Textbox Name="ServiceContractHeaderBilltoCustomerNo1">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!BilltoNam_ServContractHdr.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Left</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <Top>5.60084cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>8</ZIndex>
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
                                      <Value>=Fields!CompanyAddr5.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.96184cm</Top>
                              <Left>11.7cm</Left>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>9</ZIndex>
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
                                      <Value>=Fields!CompanyAddr6.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Top>3.38484cm</Top>
                              <Left>11.7cm</Left>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>10</ZIndex>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Textbox Name="CustAddr11">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr1.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Left</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <Top>1.26984cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>11</ZIndex>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Textbox Name="CustAddr21">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr2.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Left</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <Top>1.69283cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>12</ZIndex>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Textbox Name="CustAddr31">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr3.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Left</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.11584cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>13</ZIndex>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Textbox Name="CustAddr41">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr4.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Left</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.53883cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>14</ZIndex>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Textbox Name="CustAddr51">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr5.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Left</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.96184cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>15</ZIndex>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Textbox Name="CustAddr61">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr6.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Left</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <Top>3.38484cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>16</ZIndex>
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
                                      <Value>=Fields!CurrReportPageNo.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Left</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <Top>0.50084cm</Top>
                              <Left>11.7cm</Left>
                              <Height>0.423cm</Height>
                              <Width>6.07778cm</Width>
                              <ZIndex>17</ZIndex>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Textbox Name="ServContractQuote1">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!ServContractQuote.Value</Value>
                                      <Style>
                                        <FontWeight>Bold</FontWeight>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Top>0.05084cm</Top>
                              <Left>11.7cm</Left>
                              <Height>0.423cm</Height>
                              <Width>5.76032cm</Width>
                              <ZIndex>18</ZIndex>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Tablix Name="table4">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.99987in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.7874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.7874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.7874in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServiceDiscountsCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox1</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                    <Height>0.37495in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox122">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!Type_ContractServDiscCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox12</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox13">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!No_ContractServDiscCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox13</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox14">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ContractServDiscStrtDtCptn.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox14</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox15">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!Discount_ContractServDiscCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox15</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox36">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Type_ContractServDisc.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox37">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_ContractServDisc.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox5">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!StartDt_ContractServDisc.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox5</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox9">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Discount_ContractServDisc.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Discount_ContractServDiscFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox9</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                    <Group Name="table4_Details_Group">
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
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!Type_ContractServDisc.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>7.93651cm</Top>
                              <Height>1.7984cm</Height>
                              <Width>8.53966cm</Width>
                              <ZIndex>19</ZIndex>
                              <Visibility>
                                <Hidden>=iif(Fields!Type_ContractServDisc.Value="",true,false)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="table5">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.87476in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.49969in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox56">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox56</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox60">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox60</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox48">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShiptoAddressCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox78">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr1.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox78</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox45">
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
                                            <rd:DefaultName>textbox45</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox50">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr2.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox70">
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
                                            <rd:DefaultName>textbox70</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox75">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr3.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox35">
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
                                            <rd:DefaultName>textbox35</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox67">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr4.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox32">
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
                                            <rd:DefaultName>textbox32</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox73">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr5.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox39">
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
                                            <rd:DefaultName>textbox39</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox71">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr6.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox40</rd:DefaultName>
                                            <Style>
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
                                      <TablixMember />
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr1.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr2.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr3.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr4.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr5.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr6.Value="",True,False)</Hidden>
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
                                  <FilterExpression>=Fields!ShiptoAddressCaption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>13.41905cm</Top>
                              <Height>3.38409cm</Height>
                              <Width>11.1111cm</Width>
                              <ZIndex>20</ZIndex>
                              <Visibility>
                                <Hidden>=iif(Fields!ShipToCode.Value&lt;&gt;"",false,true)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="table1">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.62992in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.98425in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.98425in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.76772in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.76772in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.76772in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.76772in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.76772in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.76772in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox18">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox18</rd:DefaultName>
                                            <ZIndex>56</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox19</rd:DefaultName>
                                            <ZIndex>55</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox63">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox63</rd:DefaultName>
                                            <ZIndex>54</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox20">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox20</rd:DefaultName>
                                            <ZIndex>53</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox21</rd:DefaultName>
                                            <ZIndex>52</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox8">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox8</rd:DefaultName>
                                            <ZIndex>51</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox25">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox25</rd:DefaultName>
                                            <ZIndex>50</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox28">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox28</rd:DefaultName>
                                            <ZIndex>49</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox311">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox31</rd:DefaultName>
                                            <ZIndex>48</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.37495in</Height>
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
                                                    <Value>=Parameters!ServItemNo_ServContractLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>47</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox11">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!Desc_ServContractLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>46</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox16">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!ItemNo_ServContractLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>45</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox17">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!SlNo_ServContractLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>44</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox22">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!UOMCode_ServContractLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox22</rd:DefaultName>
                                            <ZIndex>43</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox26">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!RespTime_ServContractLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
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
                                            <ZIndex>42</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox29">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!ServicePeriod_ServContractLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox29</rd:DefaultName>
                                            <ZIndex>41</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox34">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!LineValue_ServContractLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox34</rd:DefaultName>
                                            <ZIndex>40</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox93">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServItemNo_ServContractLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>39</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox94">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Desc_ServContractLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>38</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox95">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ItemNo_ServContractLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>37</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox96">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SlNo_ServContractLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>36</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox97">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UOMCode_ServContractLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>35</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox98">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!RespTime_ServContractLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!RespTime_ServContractLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>34</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox99">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServicePeriod_ServContractLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>33</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox100">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!LineValue_ServContractLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!LineValue_ServContractLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>32</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox2">
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
                                            <rd:DefaultName>textbox2</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox4">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox4</rd:DefaultName>
                                            <ZIndex>30</ZIndex>
                                            <Style>
                                              <PaddingLeft>15pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox6">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox6</rd:DefaultName>
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox7">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox7</rd:DefaultName>
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox24">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox24</rd:DefaultName>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox27">
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
                                            <rd:DefaultName>textbox27</rd:DefaultName>
                                            <ZIndex>26</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox30">
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
                                            <rd:DefaultName>textbox30</rd:DefaultName>
                                            <ZIndex>25</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox38">
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
                                            <rd:DefaultName>textbox38</rd:DefaultName>
                                            <ZIndex>24</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox41">
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
                                            <rd:DefaultName>textbox41</rd:DefaultName>
                                            <ZIndex>23</ZIndex>
                                            <Style>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox85">
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
                                            <rd:DefaultName>textbox85</rd:DefaultName>
                                            <ZIndex>22</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox44">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServCommentLineDtCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <PaddingLeft>15pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Value>=Parameters!Comment_ServCommentLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox89">
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
                                            <rd:DefaultName>textbox89</rd:DefaultName>
                                            <ZIndex>19</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox90">
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
                                            <rd:DefaultName>textbox90</rd:DefaultName>
                                            <ZIndex>18</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox91">
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
                                            <rd:DefaultName>textbox91</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox92">
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
                                            <rd:DefaultName>textbox92</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox53">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox53</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox54">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Date_ServiceCommentLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox54</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>15pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox68">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Comment_ServCommentLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox68</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox58">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox58</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox59">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!RespTime_ServContractLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox59</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox61">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox61</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox62">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!LineValue_ServContractLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox62</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox42">
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
                                            <rd:DefaultName>textbox42</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox47">
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
                                            <rd:DefaultName>textbox47</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox49">
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
                                            <rd:DefaultName>textbox49</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox51">
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
                                            <rd:DefaultName>textbox51</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox52">
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
                                            <rd:DefaultName>textbox52</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox55">
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
                                            <rd:DefaultName>textbox55</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox57">
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
                                            <rd:DefaultName>textbox57</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox64">
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
                                            <rd:DefaultName>textbox64</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox65">
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
                                            <rd:DefaultName>textbox65</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table1_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!ContType_ServContractLine.Value</GroupExpression>
                                        <GroupExpression>=Fields!LineNo_ServContractLine.Value</GroupExpression>
                                        <GroupExpression>=Fields!ContNo_ServContractLine.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="table1_Group2">
                                          <GroupExpressions>
                                            <GroupExpression>=Fields!LineNo_ServContractLine.Value</GroupExpression>
                                          </GroupExpressions>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <RepeatOnNewPage>true</RepeatOnNewPage>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <RepeatOnNewPage>true</RepeatOnNewPage>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=iif(Fields!ShowComments.Value,false,true)or iif(Fields!Comment_ServCommentLine.Value="",true,false) </Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <RepeatOnNewPage>true</RepeatOnNewPage>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Group Name="table1_Details_Group">
                                              <DataElementName>Detail</DataElementName>
                                            </Group>
                                            <TablixMembers>
                                              <TablixMember>
                                                <Visibility>
                                                  <Hidden>=iif(Fields!ShowComments.Value,false,true)or iif(Fields!Comment_ServCommentLine.Value="",true,false) </Hidden>
                                                </Visibility>
                                              </TablixMember>
                                            </TablixMembers>
                                            <DataElementName>Detail_Collection</DataElementName>
                                            <DataElementOutput>Output</DataElementOutput>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>Before</KeepWithGroup>
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
                                  <FilterExpression>=Fields!Desc_ServContractLine.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>9.84127cm</Top>
                              <Height>3.49044cm</Height>
                              <Width>18.30004cm</Width>
                              <ZIndex>21</ZIndex>
                              <Visibility>
                                <Hidden>=iif(Fields!Desc_ServContractLine.Value="",true,false)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="table2">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.99987in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.7874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.7874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.7874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3.24959in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.37495in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox76">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CommentsCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
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
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                          <Textbox Name="textbox77">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox77</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                  <TablixRow>
                                    <Height>0.37495in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox74">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServCommentLine2DtCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox74</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox82">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!Comment_ServCommentLine2Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox82</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox79">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox79</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox66">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Date_ServCommentLine2.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>d</Format>
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
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox69">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Comment_ServCommentLine2.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                    <Group Name="table2_Details_Group">
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
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!Comment_ServCommentLine2.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>16.86905cm</Top>
                              <Height>2.32776cm</Height>
                              <Width>16.79362cm</Width>
                              <ZIndex>22</ZIndex>
                              <Visibility>
                                <Hidden>=iif(Fields!ShowComments1.Value,false,true)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="table3">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.12205in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.07874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.70866in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ContNo_ServContractHdrCaption1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!ContNo_ServContractHdrCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox84">
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
                                            <rd:DefaultName>textbox84</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
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
                                          <Textbox Name="ContNo_ServContractHdr1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ContNo_ServContractHdr.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="StartDt_ServContractHdrCaption1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!AcceptBef_ServContractHdrCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox86">
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
                                            <rd:DefaultName>textbox86</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
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
                                          <Textbox Name="StartDt_ServContractHdr1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AcceptBef_ServContractHdr.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="InvPeriod_ServContractHdrCaption1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServContractStartDtCptn.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
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
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox87">
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
                                            <rd:DefaultName>textbox87</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
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
                                          <Textbox Name="InvPeriod_ServContractHdr1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!StartDt_ServContractHdr.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox33">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!InvPeriod_ServContractHdrCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox43">
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
                                            <rd:DefaultName>textbox43</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox23">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!InvPeriod_ServContractHdr.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
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
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="NextInvDate_ServContractHdrCaption1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServContractNextInvDtCptn.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
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
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox81">
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
                                            <rd:DefaultName>textbox81</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
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
                                          <Textbox Name="NextInvDate_ServContractHdr1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!NextInvDate_ServContractHdr.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
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
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AnnualAmt_ServContractHdrCaption1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Parameters!AnnualAmt_ServContractHdrCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
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
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox101">
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
                                            <rd:DefaultName>textbox101</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
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
                                          <Textbox Name="AnnualAmt_ServContractHdr1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(first(Fields!AnnualAmt_ServContractHdr.Value))</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!AnnualAmt_ServContractHdrFormat.Value</Format>
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
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Top>5.07937cm</Top>
                              <Left>11.7cm</Left>
                              <Height>2.53807cm</Height>
                              <Width>4.85cm</Width>
                              <ZIndex>23</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="table6">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.82677in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.07874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.65354in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyInfoPhoneNoCaption1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyInfoPhoneNoCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox3">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox3</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyInfoPhoneNo1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyInfoPhoneNo.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyInfoFaxNoCaption1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyInfoFaxNoCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox72">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox72</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyInfoFaxNo1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyInfoFaxNo.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Top>3.80952cm</Top>
                              <Left>11.7cm</Left>
                              <Height>0.84602cm</Height>
                              <Width>6.49999cm</Width>
                              <ZIndex>24</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="table7">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.82677in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.07874in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.65354in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.1811in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PhoneNo_ServContractHdrCaption1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServContractPhoneNoCptn.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox105">
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
                                            <rd:DefaultName>textbox105</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
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
                                          <Textbox Name="PhoneNo_ServContractHdr1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PhoneNo_ServContractHdr.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox88">
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
                                            <rd:DefaultName>textbox88</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="EMail_ServContractHdrCaption1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServContractEMailCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox106">
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
                                            <rd:DefaultName>textbox106</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
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
                                          <Textbox Name="EMail_ServContractHdr1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!EMail_ServContractHdr.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Top>3.80784cm</Top>
                              <Height>0.84602cm</Height>
                              <Width>9.49998cm</Width>
                              <ZIndex>25</ZIndex>
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
                      <GroupExpression>=Fields!ContType_ServContractHdr.Value</GroupExpression>
                      <GroupExpression>=Fields!ContNo_ServContractHdr.Value</GroupExpression>
                      <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <SortExpressions>
                    <SortExpression>
                      <Value>=Fields!ContType_ServContractHdr.Value</Value>
                    </SortExpression>
                    <SortExpression>
                      <Value>=Fields!ContNo_ServContractHdr.Value</Value>
                    </SortExpression>
                    <SortExpression>
                      <Value>=Fields!OutputNo.Value</Value>
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
            <Filters>
              <Filter>
                <FilterExpression>=cstr(Fields!OutputNo.Value)</FilterExpression>
                <Operator>GreaterThan</Operator>
                <FilterValues>
                  <FilterValue />
                </FilterValues>
              </Filter>
            </Filters>
            <Height>19.19681cm</Height>
            <Width>18.29999cm</Width>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>19.19681cm</Height>
        <Style />
      </Body>
      <Width>18.3cm</Width>
      <Page>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.5cm</LeftMargin>
        <TopMargin>2cm</TopMargin>
        <BottomMargin>2cm</BottomMargin>
        <Style />
      </Page>
    </ReportSection>
  </ReportSections>
  <ReportParameters>
    <ReportParameter Name="ContNo_ServContractHdrCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>ContNo_ServContractHdrCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>ContNo_ServContractHdrCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="AnnualAmt_ServContractHdrCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>AnnualAmt_ServContractHdrCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>AnnualAmt_ServContractHdrCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="InvPeriod_ServContractHdrCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>InvPeriod_ServContractHdrCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>InvPeriod_ServContractHdrCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="AcceptBef_ServContractHdrCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>AcceptBef_ServContractHdrCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>AcceptBef_ServContractHdrCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="Type_ContractServDiscCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Type_ContractServDiscCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Type_ContractServDiscCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="No_ContractServDiscCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>No_ContractServDiscCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>No_ContractServDiscCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="Discount_ContractServDiscCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Discount_ContractServDiscCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Discount_ContractServDiscCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="ServItemNo_ServContractLineCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>ServItemNo_ServContractLineCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>ServItemNo_ServContractLineCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="Desc_ServContractLineCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Desc_ServContractLineCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Desc_ServContractLineCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="ItemNo_ServContractLineCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>ItemNo_ServContractLineCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>ItemNo_ServContractLineCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="SlNo_ServContractLineCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>SlNo_ServContractLineCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>SlNo_ServContractLineCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="ServicePeriod_ServContractLineCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>ServicePeriod_ServContractLineCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>ServicePeriod_ServContractLineCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="UOMCode_ServContractLineCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>UOMCode_ServContractLineCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>UOMCode_ServContractLineCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="RespTime_ServContractLineCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>RespTime_ServContractLineCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>RespTime_ServContractLineCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="LineValue_ServContractLineCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>LineValue_ServContractLineCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>LineValue_ServContractLineCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="Comment_ServCommentLineCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Comment_ServCommentLineCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Comment_ServCommentLineCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="Comment_ServCommentLine2Caption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Comment_ServCommentLine2Caption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Comment_ServCommentLine2Caption</Prompt>
    </ReportParameter>
  </ReportParameters>
  <ReportParametersLayout>
    <GridLayoutDefinition>
      <NumberOfColumns>1</NumberOfColumns>
      <NumberOfRows>17</NumberOfRows>
      <CellDefinitions>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>0</RowIndex>
          <ParameterName>ContNo_ServContractHdrCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>1</RowIndex>
          <ParameterName>AnnualAmt_ServContractHdrCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>2</RowIndex>
          <ParameterName>InvPeriod_ServContractHdrCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>3</RowIndex>
          <ParameterName>AcceptBef_ServContractHdrCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>4</RowIndex>
          <ParameterName>Type_ContractServDiscCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>5</RowIndex>
          <ParameterName>No_ContractServDiscCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>6</RowIndex>
          <ParameterName>Discount_ContractServDiscCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>7</RowIndex>
          <ParameterName>ServItemNo_ServContractLineCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>8</RowIndex>
          <ParameterName>Desc_ServContractLineCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>9</RowIndex>
          <ParameterName>ItemNo_ServContractLineCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>10</RowIndex>
          <ParameterName>SlNo_ServContractLineCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>11</RowIndex>
          <ParameterName>ServicePeriod_ServContractLineCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>12</RowIndex>
          <ParameterName>UOMCode_ServContractLineCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>13</RowIndex>
          <ParameterName>RespTime_ServContractLineCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>14</RowIndex>
          <ParameterName>LineValue_ServContractLineCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>15</RowIndex>
          <ParameterName>Comment_ServCommentLineCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>16</RowIndex>
          <ParameterName>Comment_ServCommentLine2Caption</ParameterName>
        </CellDefinition>
      </CellDefinitions>
    </GridLayoutDefinition>
  </ReportParametersLayout>
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

Public Function GetGroupPageNumber(PageCaption as Object, NewPage as Boolean, pagenumber as Integer) as Object
  If NewPage
    offset = pagenumber - 1
    NewPage = FALSE
  End If
  Return PageCaption &amp; " " &amp; pagenumber - offset
End Function

Public Function IsNewPage() as Boolean
  NewPage = TRUE
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
  If Group = 1 and NewData &lt;&gt; "" Then
      Data1 = NewData
  End If

  If Group = 2 and NewData &lt;&gt; "" Then
      Data2 = NewData
  End If

  If Group = 3 and NewData &lt;&gt; "" Then
      Data3 = NewData
  End If

End Function

Public Function IsEmpty(value as Object) as boolean
  On Error Resume Next
  If Convert.ToBase64String(Value) = "" then
      Return True
  Else
      Return False
  End If
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>2fdb9e68-2e78-4ca6-b9c2-d1caad723ee2</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

