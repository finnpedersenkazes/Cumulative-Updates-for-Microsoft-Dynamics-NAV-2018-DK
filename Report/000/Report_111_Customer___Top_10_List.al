OBJECT Report 111 Customer - Top 10 List
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitor - top 10-liste;
               ENU=Customer - Top 10 List];
    OnPreReport=VAR
                  CaptionManagement@1000 : Codeunit 42;
                BEGIN
                  CustFilter := CaptionManagement.GetRecordFiltersWithCaptions(Customer);
                  CustDateFilter := Customer.GETFILTER("Date Filter");
                END;

  }
  DATASET
  {
    { 6836;    ;DataItem;                    ;
               DataItemTable=Table18;
               DataItemTableView=SORTING(No.);
               OnPreDataItem=BEGIN
                               Window.OPEN(Text000);
                               i := 0;
                               CustAmount.DELETEALL;
                               CurrReport.CREATETOTALS("Sales (LCY)","Balance (LCY)");
                             END;

               OnAfterGetRecord=BEGIN
                                  Window.UPDATE(1,"No.");
                                  CALCFIELDS("Sales (LCY)","Balance (LCY)");
                                  IF ("Sales (LCY)" = 0) AND ("Balance (LCY)" = 0) THEN
                                    CurrReport.SKIP;
                                  CustAmount.INIT;
                                  CustAmount."Customer No." := "No.";
                                  IF ShowType = ShowType::"Sales (LCY)" THEN BEGIN
                                    CustAmount."Amount (LCY)" := -"Sales (LCY)";
                                    CustAmount."Amount 2 (LCY)" := -"Balance (LCY)";
                                  END ELSE BEGIN
                                    CustAmount."Amount (LCY)" := -"Balance (LCY)";
                                    CustAmount."Amount 2 (LCY)" := -"Sales (LCY)";
                                  END;
                                  CustAmount.INSERT;
                                  IF (NoOfRecordsToPrint = 0) OR (i < NoOfRecordsToPrint) THEN
                                    i := i + 1
                                  ELSE BEGIN
                                    CustAmount.FIND('+');
                                    CustAmount.DELETE;
                                  END;

                                  TotalSales += "Sales (LCY)";
                                  TotalBalance += "Balance (LCY)";
                                  ChartTypeNo := ChartType;
                                  ShowTypeNo := ShowType;
                                END;

               ReqFilterFields=No.,Customer Posting Group,Currency Code,Date Filter }

    { 5444;    ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               Window.CLOSE;
                               CurrReport.CREATETOTALS(Customer."Sales (LCY)",Customer."Balance (LCY)");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT CustAmount.FIND('-') THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF CustAmount.NEXT = 0 THEN
                                      CurrReport.BREAK;
                                  CustAmount."Amount (LCY)" := -CustAmount."Amount (LCY)";
                                  Customer.GET(CustAmount."Customer No.");
                                  Customer.CALCFIELDS("Sales (LCY)","Balance (LCY)");
                                  IF MaxAmount = 0 THEN
                                    MaxAmount := CustAmount."Amount (LCY)";
                                  CustAmount."Amount (LCY)" := -CustAmount."Amount (LCY)";
                                END;
                                 }

    { 3   ;1   ;Column  ;SortingCustomersCustDateFilter;
               SourceExpr=STRSUBSTNO(Text001,CustDateFilter) }

    { 6   ;1   ;Column  ;CompanyName         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 8   ;1   ;Column  ;RankedAccordingShowType;
               SourceExpr=STRSUBSTNO(Text002,SELECTSTR(ShowType + 1,Text004)) }

    { 32  ;1   ;Column  ;ShowTypeNo          ;
               SourceExpr=ShowTypeNo }

    { 36  ;1   ;Column  ;ChartTypeNo         ;
               SourceExpr=ChartTypeNo }

    { 9   ;1   ;Column  ;CustFilter_Customer ;
               SourceExpr=Customer.TABLECAPTION + ': ' + CustFilter }

    { 31  ;1   ;Column  ;CustFilter          ;
               SourceExpr=CustFilter }

    { 17  ;1   ;Column  ;No_Customer         ;
               IncludeCaption=Yes;
               SourceExpr=Customer."No." }

    { 18  ;1   ;Column  ;Name_Customer       ;
               IncludeCaption=Yes;
               SourceExpr=Customer.Name }

    { 19  ;1   ;Column  ;SalesLCY_Customer   ;
               IncludeCaption=Yes;
               SourceExpr=Customer."Sales (LCY)" }

    { 20  ;1   ;Column  ;BalanceLCY_Customer ;
               IncludeCaption=Yes;
               SourceExpr=Customer."Balance (LCY)" }

    { 34  ;1   ;Column  ;TotalSales          ;
               SourceExpr=TotalSales }

    { 35  ;1   ;Column  ;TotalBalance        ;
               SourceExpr=TotalBalance }

    { 1   ;1   ;Column  ;CustomerTop10ListCaption;
               SourceExpr=CustomerTop10ListCaptionLbl }

    { 4   ;1   ;Column  ;CurrReportPageNoCaption;
               SourceExpr=CurrReportPageNoCaptionLbl }

    { 22  ;1   ;Column  ;TotalCaption        ;
               SourceExpr=TotalCaptionLbl }

    { 25  ;1   ;Column  ;TotalSalesCaption   ;
               SourceExpr=TotalSalesCaptionLbl }

    { 28  ;1   ;Column  ;PercentofTotalSalesCaption;
               SourceExpr=PercentofTotalSalesCaptionLbl }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnInit=BEGIN
               ChartTypeVisible := TRUE;
             END;

      OnOpenPage=BEGIN
                   IF NoOfRecordsToPrint = 0 THEN
                     NoOfRecordsToPrint := 10;
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  Name=Show;
                  CaptionML=[DAN=Vis;
                             ENU=Show];
                  ToolTipML=[DAN=Angiver, hvordan rapporten skal sortere debitorerne: Salg efter k�bsm�ngde eller Saldo efter saldo. I begge tilf�lde vises debitorer med det st�rste bel�b f�rst.;
                             ENU="Specifies how the report will sort the customers: Sales, to sort by purchase volume; or Balance, to sort by balance. In either case, the customers with the largest amounts will be shown first."];
                  OptionCaptionML=[DAN=Salg (RV),Saldo (RV);
                                   ENU=Sales (LCY),Balance (LCY)];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ShowType }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Antal;
                             ENU=Quantity];
                  ToolTipML=[DAN=Angiver antallet af debitorer, der skal med i rapporten.;
                             ENU=Specifies the number of customers that will be included in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=NoOfRecordsToPrint }

      { 4   ;2   ;Field     ;
                  Name=ChartType;
                  CaptionML=[DAN=Diagramtype;
                             ENU=Chart Type];
                  ToolTipML=[DAN=Angiver diagramtypen.;
                             ENU=Specifies the chart type.];
                  OptionCaptionML=[DAN=S�jlediagram,Cirkeldiagram;
                                   ENU=Bar chart,Pie chart];
                  ApplicationArea=#All;
                  SourceExpr=ChartType;
                  Visible=ChartTypeVisible }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Debitorerne sorteres #1##########;ENU=Sorting customers    #1##########';
      Text001@1001 : TextConst 'DAN=Periode: %1;ENU=Period: %1';
      Text002@1002 : TextConst 'DAN=R�kkef�lge efter %1;ENU=Ranked according to %1';
      CustAmount@1003 : TEMPORARY Record 266;
      Window@1004 : Dialog;
      CustFilter@1006 : Text;
      CustDateFilter@1007 : Text;
      ShowType@1008 : 'Sales (LCY),Balance (LCY)';
      NoOfRecordsToPrint@1009 : Integer;
      MaxAmount@1014 : Decimal;
      i@1019 : Integer;
      TotalSales@1016 : Decimal;
      Text004@1017 : TextConst 'DAN=Salg (RV),Saldo (RV);ENU=Sales (LCY),Balance (LCY)';
      TotalBalance@1018 : Decimal;
      ChartType@1020 : 'Bar chart,Pie chart';
      ChartTypeNo@1021 : Integer;
      ShowTypeNo@1022 : Integer;
      ChartTypeVisible@19004067 : Boolean INDATASET;
      CustomerTop10ListCaptionLbl@3137 : TextConst 'DAN=Debitor - top 10-liste;ENU=Customer - Top 10 List';
      CurrReportPageNoCaptionLbl@2595 : TextConst 'DAN=Side;ENU=Page';
      TotalCaptionLbl@1909 : TextConst 'DAN=I alt;ENU=Total';
      TotalSalesCaptionLbl@1450 : TextConst 'DAN=Salg i alt;ENU=Total Sales';
      PercentofTotalSalesCaptionLbl@2243 : TextConst 'DAN=% af salg i alt;ENU=% of Total Sales';

    PROCEDURE InitializeRequest@2(SetChartType@1002 : Option;SetShowType@1000 : Option;NoOfRecords@1001 : Integer);
    BEGIN
      ChartType := SetChartType;
      ShowType := SetShowType;
      NoOfRecordsToPrint := NoOfRecords;
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
      <rd:DataSourceID>6f5c4ac1-03f2-450d-bbd7-1e7f8c0305e2</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="SortingCustomersCustDateFilter">
          <DataField>SortingCustomersCustDateFilter</DataField>
        </Field>
        <Field Name="CompanyName">
          <DataField>CompanyName</DataField>
        </Field>
        <Field Name="RankedAccordingShowType">
          <DataField>RankedAccordingShowType</DataField>
        </Field>
        <Field Name="ShowTypeNo">
          <DataField>ShowTypeNo</DataField>
        </Field>
        <Field Name="ChartTypeNo">
          <DataField>ChartTypeNo</DataField>
        </Field>
        <Field Name="CustFilter_Customer">
          <DataField>CustFilter_Customer</DataField>
        </Field>
        <Field Name="CustFilter">
          <DataField>CustFilter</DataField>
        </Field>
        <Field Name="No_Customer">
          <DataField>No_Customer</DataField>
        </Field>
        <Field Name="Name_Customer">
          <DataField>Name_Customer</DataField>
        </Field>
        <Field Name="SalesLCY_Customer">
          <DataField>SalesLCY_Customer</DataField>
        </Field>
        <Field Name="SalesLCY_CustomerFormat">
          <DataField>SalesLCY_CustomerFormat</DataField>
        </Field>
        <Field Name="BalanceLCY_Customer">
          <DataField>BalanceLCY_Customer</DataField>
        </Field>
        <Field Name="BalanceLCY_CustomerFormat">
          <DataField>BalanceLCY_CustomerFormat</DataField>
        </Field>
        <Field Name="TotalSales">
          <DataField>TotalSales</DataField>
        </Field>
        <Field Name="TotalSalesFormat">
          <DataField>TotalSalesFormat</DataField>
        </Field>
        <Field Name="TotalBalance">
          <DataField>TotalBalance</DataField>
        </Field>
        <Field Name="TotalBalanceFormat">
          <DataField>TotalBalanceFormat</DataField>
        </Field>
        <Field Name="CustomerTop10ListCaption">
          <DataField>CustomerTop10ListCaption</DataField>
        </Field>
        <Field Name="CurrReportPageNoCaption">
          <DataField>CurrReportPageNoCaption</DataField>
        </Field>
        <Field Name="TotalCaption">
          <DataField>TotalCaption</DataField>
        </Field>
        <Field Name="TotalSalesCaption">
          <DataField>TotalSalesCaption</DataField>
        </Field>
        <Field Name="PercentofTotalSalesCaption">
          <DataField>PercentofTotalSalesCaption</DataField>
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
          <Tablix Name="Table1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>0.87489in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.74978in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.12486in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.12486in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.12486in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.28346in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="No_CustomerCaption">
                          <CanGrow>true</CanGrow>
                          <UserSort>
                            <SortExpression>=Fields!No_Customer.Value</SortExpression>
                          </UserSort>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!No_CustomerCaption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>82</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Name_CustomerCaption">
                          <CanGrow>true</CanGrow>
                          <UserSort>
                            <SortExpression>=Fields!Name_Customer.Value</SortExpression>
                          </UserSort>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!Name_CustomerCaption.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>81</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox2">
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
                          <rd:DefaultName>textbox2</rd:DefaultName>
                          <ZIndex>80</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="SalesLCY_CustomerCaption">
                          <CanGrow>true</CanGrow>
                          <UserSort>
                            <SortExpression>=Fields!SalesLCY_Customer.Value</SortExpression>
                          </UserSort>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!SalesLCY_CustomerCaption.Value</Value>
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
                          <ZIndex>79</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BalanceLCY_CustomerCaption">
                          <CanGrow>true</CanGrow>
                          <UserSort>
                            <SortExpression>=Fields!BalanceLCY_Customer.Value</SortExpression>
                          </UserSort>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!BalanceLCY_CustomerCaption.Value</Value>
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
                          <ZIndex>78</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                        <Textbox Name="No_Customer">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!No_Customer.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>12</ZIndex>
                          <Style>
                            <BackgroundColor>=iif(RowNumber(Nothing) mod 2, "AliceBlue", "White")</BackgroundColor>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Name_Customer">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Name_Customer.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>11</ZIndex>
                          <Style>
                            <BackgroundColor>=iif(RowNumber(Nothing) mod 2, "AliceBlue", "White")</BackgroundColor>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                        <Textbox Name="SalesLCY_Customer">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!SalesLCY_Customer.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <Format>=Fields!SalesLCY_CustomerFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>10</ZIndex>
                          <Style>
                            <BackgroundColor>=iif(RowNumber(Nothing) mod 2, "AliceBlue", "White")</BackgroundColor>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BalanceLCY_Customer">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BalanceLCY_Customer.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <Format>=Fields!BalanceLCY_CustomerFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>9</ZIndex>
                          <Style>
                            <BackgroundColor>=iif(RowNumber(Nothing) mod 2, "AliceBlue", "White")</BackgroundColor>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                        <Textbox Name="textbox20">
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
                          <rd:DefaultName>textbox20</rd:DefaultName>
                          <ZIndex>26</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                        <Textbox Name="textbox1">
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
                          <rd:DefaultName>textbox1</rd:DefaultName>
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
                        <Textbox Name="textbox13">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>F2</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox13</rd:DefaultName>
                          <ZIndex>24</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>F2</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox22</rd:DefaultName>
                          <ZIndex>23</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox23">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>F2</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox23</rd:DefaultName>
                          <ZIndex>22</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                        <Textbox Name="TextBox11">
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
                          <ZIndex>40</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                        <Textbox Name="textbox212">
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
                          <rd:DefaultName>textbox21</rd:DefaultName>
                          <ZIndex>39</ZIndex>
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
                        <Textbox Name="TotalCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalCaption.Value)</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>38</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="SalesLCY_CustomerControl23">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!SalesLCY_Customer.Value)</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!SalesLCY_CustomerFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>37</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BalanceLCY_CustomerControl24">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!BalanceLCY_Customer.Value)</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!BalanceLCY_CustomerFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>36</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                        <Textbox Name="TextBox14">
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
                          <ZIndex>54</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                          <rd:DefaultName>textbox15</rd:DefaultName>
                          <ZIndex>53</ZIndex>
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
                        <Textbox Name="TotalSalesCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalSalesCaption.Value)</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>52</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustSalesLCY">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalSales.Value)</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <Format>=Fields!TotalSalesFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>51</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustBalanceLCY">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalBalance.Value)</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <Format>=Fields!TotalBalanceFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>50</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                        <Textbox Name="TextBox17">
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
                          <ZIndex>68</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                        <Textbox Name="textbox16">
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
                          <rd:DefaultName>textbox16</rd:DefaultName>
                          <ZIndex>67</ZIndex>
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
                        <Textbox Name="PercentofTotalSalesCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!PercentofTotalSalesCaption.Value)</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>66</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="SalesPct">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcPct(Sum(Fields!SalesLCY_Customer.Value), First(Fields!TotalSales.Value))</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <Format>=Fields!SalesLCY_CustomerFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>65</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BalancePct">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcPct(Sum(Fields!BalanceLCY_Customer.Value), First(Fields!TotalBalance.Value))</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                    <Format>=Fields!BalanceLCY_CustomerFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>64</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                  <Group Name="Table1_Details_Group">
                    <DataElementName>Detail</DataElementName>
                  </Group>
                  <TablixMembers>
                    <TablixMember />
                  </TablixMembers>
                  <DataElementName>Detail_Collection</DataElementName>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <KeepWithGroup>Before</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <KeepWithGroup>Before</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <KeepWithGroup>Before</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <KeepWithGroup>Before</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>0.95238cm</Top>
            <Height>2.83505cm</Height>
            <Width>15.2381cm</Width>
            <Style />
          </Tablix>
          <Textbox Name="CustFilter_Customer">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!CustFilter_Customer.Value)</Value>
                    <Style>
                      <FontSize>9pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Height>0.423cm</Height>
            <Width>14.28571cm</Width>
            <ZIndex>1</ZIndex>
            <Visibility>
              <Hidden>=IIF(First(Fields!CustFilter.Value) = "",TRUE,FALSE)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Chart Name="BarChart">
            <ChartCategoryHierarchy>
              <ChartMembers>
                <ChartMember>
                  <Group Name="chart1_CategoryGroup1">
                    <GroupExpressions>
                      <GroupExpression>=Fields!No_Customer.Value</GroupExpression>
                    </GroupExpressions>
                  </Group>
                  <Label>=Fields!No_Customer.Value</Label>
                  <DataElementOutput>Output</DataElementOutput>
                </ChartMember>
              </ChartMembers>
            </ChartCategoryHierarchy>
            <ChartSeriesHierarchy>
              <ChartMembers>
                <ChartMember>
                  <Label>=IIF(Fields!ShowTypeNo.Value = 0,Parameters!SalesLCY_CustomerCaption.Value,Parameters!BalanceLCY_CustomerCaption.Value)</Label>
                </ChartMember>
              </ChartMembers>
            </ChartSeriesHierarchy>
            <ChartData>
              <ChartSeriesCollection>
                <ChartSeries Name="Series1">
                  <ChartDataPoints>
                    <ChartDataPoint>
                      <ChartDataPointValues>
                        <Y>=IIF(Fields!ShowTypeNo.Value = 0,Fields!SalesLCY_Customer.Value,Fields!BalanceLCY_Customer.Value)</Y>
                      </ChartDataPointValues>
                      <ChartDataLabel>
                        <Style />
                      </ChartDataLabel>
                      <Style>
                        <Border>
                          <Width>0.376pt</Width>
                        </Border>
                        <Color>DarkKhaki</Color>
                        <BackgroundGradientType>LeftRight</BackgroundGradientType>
                        <BackgroundGradientEndColor>Khaki</BackgroundGradientEndColor>
                      </Style>
                      <ChartMarker>
                        <Size>6pt</Size>
                        <Style />
                      </ChartMarker>
                    </ChartDataPoint>
                  </ChartDataPoints>
                  <Type>Bar</Type>
                  <Style />
                  <ChartEmptyPoints>
                    <Style />
                    <ChartMarker>
                      <Style />
                    </ChartMarker>
                    <ChartDataLabel>
                      <Style />
                    </ChartDataLabel>
                  </ChartEmptyPoints>
                  <CustomProperties>
                    <CustomProperty>
                      <Name>PointWidth</Name>
                      <Value>0.6</Value>
                    </CustomProperty>
                  </CustomProperties>
                  <ValueAxisName>Primary</ValueAxisName>
                  <CategoryAxisName>Primary</CategoryAxisName>
                  <ChartSmartLabel>
                    <CalloutLineColor>Black</CalloutLineColor>
                    <MinMovingDistance>0pt</MinMovingDistance>
                  </ChartSmartLabel>
                </ChartSeries>
              </ChartSeriesCollection>
            </ChartData>
            <ChartAreas>
              <ChartArea Name="Default">
                <ChartCategoryAxes>
                  <ChartAxis Name="Primary">
                    <Style>
                      <Border>
                        <Style>None</Style>
                        <Width>0.75pt</Width>
                      </Border>
                    </Style>
                    <ChartAxisTitle>
                      <Caption />
                      <Style>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </ChartAxisTitle>
                    <Margin>False</Margin>
                    <ChartMajorGridLines>
                      <Enabled>False</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                    </ChartMajorGridLines>
                    <ChartMinorGridLines>
                      <Enabled>False</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                      <IntervalOffset>-1</IntervalOffset>
                    </ChartMinorGridLines>
                    <ChartMajorTickMarks>
                      <Enabled>True</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                    </ChartMajorTickMarks>
                    <ChartMinorTickMarks>
                      <Enabled>True</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                      <IntervalOffset>-1</IntervalOffset>
                    </ChartMinorTickMarks>
                    <Reverse>true</Reverse>
                    <PreventFontShrink>true</PreventFontShrink>
                    <PreventFontGrow>true</PreventFontGrow>
                    <IncludeZero>false</IncludeZero>
                  </ChartAxis>
                  <ChartAxis Name="Secondary">
                    <Style>
                      <FontSize>8pt</FontSize>
                    </Style>
                    <ChartAxisTitle>
                      <Caption />
                      <Style>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </ChartAxisTitle>
                    <CrossAt>NaN</CrossAt>
                    <Location>Opposite</Location>
                    <Minimum>NaN</Minimum>
                    <Maximum>NaN</Maximum>
                  </ChartAxis>
                </ChartCategoryAxes>
                <ChartValueAxes>
                  <ChartAxis Name="Primary">
                    <Style>
                      <Border>
                        <Style>None</Style>
                        <Width>0.75pt</Width>
                      </Border>
                    </Style>
                    <ChartAxisTitle>
                      <Caption />
                      <Style>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </ChartAxisTitle>
                    <Margin>True</Margin>
                    <ChartMajorGridLines>
                      <Enabled>True</Enabled>
                      <Style>
                        <Border>
                          <Color>DarkGray</Color>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                    </ChartMajorGridLines>
                    <ChartMinorGridLines>
                      <Enabled>False</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                    </ChartMinorGridLines>
                    <ChartMajorTickMarks>
                      <Enabled>True</Enabled>
                      <Style>
                        <Border>
                          <Color>DarkGray</Color>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                    </ChartMajorTickMarks>
                    <ChartMinorTickMarks>
                      <Type>None</Type>
                    </ChartMinorTickMarks>
                    <Scalar>true</Scalar>
                    <Minimum>0</Minimum>
                    <PreventFontShrink>true</PreventFontShrink>
                    <PreventFontGrow>true</PreventFontGrow>
                    <IncludeZero>false</IncludeZero>
                  </ChartAxis>
                  <ChartAxis Name="Secondary">
                    <Style>
                      <FontSize>8pt</FontSize>
                    </Style>
                    <ChartAxisTitle>
                      <Caption />
                      <Style>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </ChartAxisTitle>
                    <CrossAt>NaN</CrossAt>
                    <Location>Opposite</Location>
                    <Minimum>NaN</Minimum>
                    <Maximum>NaN</Maximum>
                  </ChartAxis>
                </ChartValueAxes>
                <ChartThreeDProperties>
                  <ProjectionMode>Perspective</ProjectionMode>
                  <Rotation>35</Rotation>
                  <Inclination>15</Inclination>
                  <WallThickness>1</WallThickness>
                  <Clustered>true</Clustered>
                </ChartThreeDProperties>
                <Style>
                  <Border>
                    <Width>0.75pt</Width>
                  </Border>
                  <BackgroundColor>WhiteSmoke</BackgroundColor>
                  <BackgroundGradientType>TopBottom</BackgroundGradientType>
                </Style>
              </ChartArea>
            </ChartAreas>
            <ChartLegends>
              <ChartLegend Name="Default">
                <Style>
                  <Border>
                    <Color>DarkGray</Color>
                    <Style>Solid</Style>
                    <Width>0.75pt</Width>
                  </Border>
                </Style>
                <Position>BottomCenter</Position>
                <Layout>Column</Layout>
                <ChartLegendTitle>
                  <Caption />
                  <Style>
                    <FontSize>8pt</FontSize>
                    <FontWeight>Bold</FontWeight>
                    <TextAlign>Center</TextAlign>
                  </Style>
                </ChartLegendTitle>
                <AutoFitTextDisabled>true</AutoFitTextDisabled>
              </ChartLegend>
            </ChartLegends>
            <ChartBorderSkin>
              <Style>
                <BackgroundColor>Gray</BackgroundColor>
                <BackgroundGradientType>None</BackgroundGradientType>
                <Color>White</Color>
              </Style>
            </ChartBorderSkin>
            <ChartNoDataMessage Name="NoDataMessage">
              <Caption>No Data Available</Caption>
              <Style>
                <BackgroundGradientType>None</BackgroundGradientType>
                <TextAlign>General</TextAlign>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </ChartNoDataMessage>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>5.64372cm</Top>
            <Height>8.88889cm</Height>
            <Width>12.38095cm</Width>
            <ZIndex>2</ZIndex>
            <Visibility>
              <Hidden>=IIF(Fields!ChartTypeNo.Value = 0,FALSE,TRUE)</Hidden>
            </Visibility>
            <CustomProperties>
              <CustomProperty>
                <Name>__Upgraded2005__</Name>
                <Value>__Upgraded2005__</Value>
              </CustomProperty>
            </CustomProperties>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <BackgroundColor>White</BackgroundColor>
              <FontSize>9pt</FontSize>
            </Style>
          </Chart>
          <Chart Name="PieChart">
            <ChartCategoryHierarchy>
              <ChartMembers>
                <ChartMember>
                  <Group Name="chart3_CategoryGroup1">
                    <GroupExpressions>
                      <GroupExpression>=Fields!No_Customer.Value</GroupExpression>
                    </GroupExpressions>
                  </Group>
                  <Label>=Fields!No_Customer.Value</Label>
                  <DataElementOutput>Output</DataElementOutput>
                </ChartMember>
              </ChartMembers>
            </ChartCategoryHierarchy>
            <ChartSeriesHierarchy>
              <ChartMembers>
                <ChartMember>
                  <Label>=IIF(Fields!ShowTypeNo.Value = 0,Parameters!SalesLCY_CustomerCaption.Value,Parameters!BalanceLCY_CustomerCaption.Value)</Label>
                </ChartMember>
              </ChartMembers>
            </ChartSeriesHierarchy>
            <ChartData>
              <ChartSeriesCollection>
                <ChartSeries Name="Series1">
                  <ChartDataPoints>
                    <ChartDataPoint>
                      <ChartDataPointValues>
                        <Y>=IIF(Fields!ShowTypeNo.Value = 0,Fields!SalesLCY_Customer.Value,Fields!BalanceLCY_Customer.Value)</Y>
                      </ChartDataPointValues>
                      <ChartDataLabel>
                        <Style />
                      </ChartDataLabel>
                      <Style>
                        <Border>
                          <Color>DarkGray</Color>
                          <Width>0.376pt</Width>
                        </Border>
                      </Style>
                      <ChartMarker>
                        <Size>6pt</Size>
                        <Style />
                      </ChartMarker>
                    </ChartDataPoint>
                  </ChartDataPoints>
                  <Type>Shape</Type>
                  <Style />
                  <ChartEmptyPoints>
                    <Style />
                    <ChartMarker>
                      <Style />
                    </ChartMarker>
                    <ChartDataLabel>
                      <Style />
                    </ChartDataLabel>
                  </ChartEmptyPoints>
                  <ValueAxisName>Primary</ValueAxisName>
                  <CategoryAxisName>Primary</CategoryAxisName>
                  <ChartSmartLabel>
                    <CalloutLineColor>Black</CalloutLineColor>
                    <MinMovingDistance>0pt</MinMovingDistance>
                  </ChartSmartLabel>
                </ChartSeries>
              </ChartSeriesCollection>
            </ChartData>
            <ChartAreas>
              <ChartArea Name="Default">
                <ChartCategoryAxes>
                  <ChartAxis Name="Primary">
                    <Style>
                      <Border>
                        <Style>None</Style>
                        <Width>0.75pt</Width>
                      </Border>
                    </Style>
                    <ChartAxisTitle>
                      <Caption />
                      <Style>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </ChartAxisTitle>
                    <Margin>False</Margin>
                    <Interval>1</Interval>
                    <ChartMajorGridLines>
                      <Enabled>False</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                    </ChartMajorGridLines>
                    <ChartMinorGridLines>
                      <Enabled>False</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                      <IntervalOffset>-1</IntervalOffset>
                    </ChartMinorGridLines>
                    <ChartMajorTickMarks>
                      <Enabled>True</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                    </ChartMajorTickMarks>
                    <ChartMinorTickMarks>
                      <Enabled>True</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                      <IntervalOffset>-1</IntervalOffset>
                    </ChartMinorTickMarks>
                    <Reverse>true</Reverse>
                    <PreventFontShrink>true</PreventFontShrink>
                    <PreventFontGrow>true</PreventFontGrow>
                    <IncludeZero>false</IncludeZero>
                  </ChartAxis>
                  <ChartAxis Name="Secondary">
                    <Style>
                      <FontSize>8pt</FontSize>
                    </Style>
                    <ChartAxisTitle>
                      <Caption />
                      <Style>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </ChartAxisTitle>
                    <CrossAt>NaN</CrossAt>
                    <Location>Opposite</Location>
                    <Minimum>NaN</Minimum>
                    <Maximum>NaN</Maximum>
                  </ChartAxis>
                </ChartCategoryAxes>
                <ChartValueAxes>
                  <ChartAxis Name="Primary">
                    <Style>
                      <Border>
                        <Style>None</Style>
                        <Width>0.75pt</Width>
                      </Border>
                    </Style>
                    <ChartAxisTitle>
                      <Caption />
                      <Style>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </ChartAxisTitle>
                    <Margin>True</Margin>
                    <ChartMajorGridLines>
                      <Enabled>True</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                    </ChartMajorGridLines>
                    <ChartMinorGridLines>
                      <Enabled>False</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                    </ChartMinorGridLines>
                    <ChartMajorTickMarks>
                      <Enabled>True</Enabled>
                      <Style>
                        <Border>
                          <Style>Solid</Style>
                          <Width>0.75pt</Width>
                        </Border>
                      </Style>
                      <Interval>NaN</Interval>
                    </ChartMajorTickMarks>
                    <ChartMinorTickMarks>
                      <Type>None</Type>
                    </ChartMinorTickMarks>
                    <Scalar>true</Scalar>
                    <Minimum>0</Minimum>
                    <PreventFontShrink>true</PreventFontShrink>
                    <PreventFontGrow>true</PreventFontGrow>
                    <IncludeZero>false</IncludeZero>
                  </ChartAxis>
                  <ChartAxis Name="Secondary">
                    <Style>
                      <FontSize>8pt</FontSize>
                    </Style>
                    <ChartAxisTitle>
                      <Caption />
                      <Style>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </ChartAxisTitle>
                    <CrossAt>NaN</CrossAt>
                    <Location>Opposite</Location>
                    <Minimum>NaN</Minimum>
                    <Maximum>NaN</Maximum>
                  </ChartAxis>
                </ChartValueAxes>
                <ChartThreeDProperties>
                  <ProjectionMode>Perspective</ProjectionMode>
                  <Shading>Simple</Shading>
                  <WallThickness>15</WallThickness>
                  <Clustered>true</Clustered>
                </ChartThreeDProperties>
                <Style>
                  <Border>
                    <Color>DarkGray</Color>
                    <Width>0.75pt</Width>
                  </Border>
                  <BackgroundColor>WhiteSmoke</BackgroundColor>
                  <BackgroundGradientType>TopBottom</BackgroundGradientType>
                </Style>
              </ChartArea>
            </ChartAreas>
            <ChartLegends>
              <ChartLegend Name="Default">
                <Style>
                  <Border>
                    <Color>DarkGray</Color>
                    <Style>Solid</Style>
                    <Width>0.75pt</Width>
                  </Border>
                </Style>
                <Position>BottomCenter</Position>
                <ChartLegendTitle>
                  <Caption />
                  <Style>
                    <FontSize>8pt</FontSize>
                    <FontWeight>Bold</FontWeight>
                    <TextAlign>Center</TextAlign>
                  </Style>
                </ChartLegendTitle>
                <AutoFitTextDisabled>true</AutoFitTextDisabled>
              </ChartLegend>
            </ChartLegends>
            <ChartBorderSkin>
              <Style>
                <BackgroundColor>Gray</BackgroundColor>
                <BackgroundGradientType>None</BackgroundGradientType>
                <Color>White</Color>
              </Style>
            </ChartBorderSkin>
            <ChartNoDataMessage Name="NoDataMessage">
              <Caption>No Data Available</Caption>
              <Style>
                <BackgroundGradientType>None</BackgroundGradientType>
                <TextAlign>General</TextAlign>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </ChartNoDataMessage>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>14.60317cm</Top>
            <Height>8.88889cm</Height>
            <Width>12.38095cm</Width>
            <ZIndex>3</ZIndex>
            <Visibility>
              <Hidden>=IIF(Fields!ChartTypeNo.Value = 1,FALSE,TRUE)</Hidden>
            </Visibility>
            <CustomProperties>
              <CustomProperty>
                <Name>__Upgraded2005__</Name>
                <Value>__Upgraded2005__</Value>
              </CustomProperty>
            </CustomProperties>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <BackgroundColor>White</BackgroundColor>
              <FontSize>9pt</FontSize>
            </Style>
          </Chart>
        </ReportItems>
        <Height>23.49206cm</Height>
        <Style />
      </Body>
      <Width>15.23845cm</Width>
      <Page>
        <PageHeader>
          <Height>2.53968cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="CurrReportPageNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CurrReportPageNoCaption.Value,"DataSet_Result") &amp; " " &amp; Globals!PageNumber</Value>
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
              <Top>0.423cm</Top>
              <Left>12.06385cm</Left>
              <Height>0.423cm</Height>
              <Width>3.1746cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustomerTop10ListCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CustomerTop10ListCaption.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="RankedAccordingShowType1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!RankedAccordingShowType.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>1.692cm</Top>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyName16">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CompanyName.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.846cm</Top>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SortingCustomersCustDateFilter1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!SortingCustomersCustDateFilter.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>4</ZIndex>
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
                      <Value>=Globals!ExecutionTime</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                        <Format>dd-MM-yyyy</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>12.06385cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="UserIdTextBox">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=User!UserID</Value>
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
              <Top>0.846cm</Top>
              <Left>11.96385cm</Left>
              <Height>0.423cm</Height>
              <Width>3.25cm</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
          <Style />
        </PageHeader>
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
    <ReportParameter Name="No_CustomerCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>No_CustomerCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>No_CustomerCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="Name_CustomerCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Name_CustomerCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Name_CustomerCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="SalesLCY_CustomerCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>SalesLCY_CustomerCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>SalesLCY_CustomerCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="BalanceLCY_CustomerCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>BalanceLCY_CustomerCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>BalanceLCY_CustomerCaption</Prompt>
    </ReportParameter>
  </ReportParameters>
  <ReportParametersLayout>
    <GridLayoutDefinition>
      <NumberOfColumns>1</NumberOfColumns>
      <NumberOfRows>4</NumberOfRows>
      <CellDefinitions>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>0</RowIndex>
          <ParameterName>No_CustomerCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>1</RowIndex>
          <ParameterName>Name_CustomerCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>2</RowIndex>
          <ParameterName>SalesLCY_CustomerCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>3</RowIndex>
          <ParameterName>BalanceLCY_CustomerCaption</ParameterName>
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

Shared Pct as Decimal
Public Function CalcPct(Amount1 as Decimal, Amount2 as Decimal) as Decimal 
    if Amount2 &lt;&gt; 0 then
       Pct = Amount1 / Amount2 * 100
    else
       Pct = 0
    end if
    REM Rounding precision = 0.1
    Return ROUND(10*Pct)/10
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>b0b59414-8f75-4e25-a7c8-b230383b57c8</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

