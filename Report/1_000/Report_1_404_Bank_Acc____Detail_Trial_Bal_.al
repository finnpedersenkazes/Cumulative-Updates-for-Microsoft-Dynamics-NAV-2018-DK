OBJECT Report 1404 Bank Acc. - Detail Trial Bal.
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bankkonto - kontokort;
               ENU=Bank Acc. - Detail Trial Bal.];
    OnInitReport=BEGIN
                   PageGroupNo := 1;
                 END;

    OnPreReport=BEGIN
                  BankAccFilter := "Bank Account".GETFILTERS;
                  DateFilter_BankAccount := "Bank Account".GETFILTER("Date Filter");
                END;

  }
  DATASET
  {
    { 4558;    ;DataItem;                    ;
               DataItemTable=Table270;
               DataItemTableView=SORTING(No.);
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                               CurrReport.CREATETOTALS("Bank Account Ledger Entry"."Amount (LCY)",StartBalanceLCY);
                             END;

               OnAfterGetRecord=BEGIN
                                  StartBalance := 0;
                                  IF DateFilter_BankAccount <> '' THEN
                                    IF GETRANGEMIN("Date Filter") <> 0D THEN BEGIN
                                      SETRANGE("Date Filter",0D,GETRANGEMIN("Date Filter") - 1);
                                      CALCFIELDS("Net Change","Net Change (LCY)");
                                      StartBalance := "Net Change";
                                      StartBalanceLCY := "Net Change (LCY)";
                                      SETFILTER("Date Filter",DateFilter_BankAccount);
                                    END;
                                  CurrReport.PRINTONLYIFDETAIL := ExcludeBalanceOnly OR (StartBalance = 0);
                                  BankAccBalance := StartBalance;
                                  BankAccBalanceLCY := StartBalanceLCY;

                                  IF PrintOnlyOnePerPage THEN
                                    PageGroupNo := PageGroupNo + 1;
                                END;

               ReqFilterFields=No.,Search Name,Bank Acc. Posting Group,Date Filter }

    { 3   ;1   ;Column  ;FilterPeriod_BankAccLedg;
               SourceExpr=STRSUBSTNO(Text000,DateFilter_BankAccount) }

    { 6   ;1   ;Column  ;CompanyName         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 15  ;1   ;Column  ;ExcludeBalanceOnly  ;
               SourceExpr=ExcludeBalanceOnly }

    { 29  ;1   ;Column  ;BankAccFilter       ;
               SourceExpr=BankAccFilter }

    { 30  ;1   ;Column  ;StartBalanceLCY     ;
               SourceExpr=StartBalanceLCY }

    { 31  ;1   ;Column  ;StartBalance        ;
               SourceExpr=StartBalance }

    { 56  ;1   ;Column  ;PrintOnlyOnePerPage ;
               SourceExpr=PrintOnlyOnePerPage }

    { 10  ;1   ;Column  ;ReportFilter        ;
               SourceExpr=STRSUBSTNO('%1: %2',TABLECAPTION,BankAccFilter) }

    { 22  ;1   ;Column  ;No_BankAccount      ;
               SourceExpr="No." }

    { 23  ;1   ;Column  ;Name_BankAccount    ;
               SourceExpr=Name }

    { 25  ;1   ;Column  ;PhNo_BankAccount    ;
               IncludeCaption=Yes;
               SourceExpr="Phone No." }

    { 27  ;1   ;Column  ;CurrencyCode_BankAccount;
               IncludeCaption=Yes;
               SourceExpr="Currency Code" }

    { 28  ;1   ;Column  ;StartBalance2       ;
               SourceExpr=StartBalance;
               AutoFormatType=1;
               AutoFormatExpr="Bank Account Ledger Entry"."Currency Code" }

    { 1   ;1   ;Column  ;BankAccDetailTrialBalCap;
               SourceExpr=BankAccDetailTrialBalCapLbl }

    { 4   ;1   ;Column  ;CurrReportPageNoCaption;
               SourceExpr=CurrReportPageNoCaptionLbl }

    { 9   ;1   ;Column  ;RepInclBankAcchavingBal;
               SourceExpr=RepInclBankAcchavingBalLbl }

    { 11  ;1   ;Column  ;BankAccLedgPostingDateCaption;
               SourceExpr=BankAccLedgPostingDateCaptionLbl }

    { 16  ;1   ;Column  ;BankAccBalanceCaption;
               SourceExpr=BankAccBalanceCaptionLbl }

    { 18  ;1   ;Column  ;OpenFormatCaption   ;
               SourceExpr=OpenFormatCaptionLbl }

    { 44  ;1   ;Column  ;BankAccBalanceLCYCaption;
               SourceExpr=BankAccBalanceLCYCaptionLbl }

    { 4920;1   ;DataItem;                    ;
               DataItemTable=Table271;
               DataItemTableView=SORTING(Bank Account No.,Posting Date);
               OnPreDataItem=BEGIN
                               BankAccLedgEntryExists := FALSE;
                               CurrReport.CREATETOTALS(Amount,"Amount (LCY)");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF NOT PrintReversedEntries AND Reversed THEN
                                    CurrReport.SKIP;
                                  BankAccLedgEntryExists := TRUE;
                                  BankAccBalance := BankAccBalance + Amount;
                                  BankAccBalanceLCY := BankAccBalanceLCY + "Amount (LCY)"
                                END;

               DataItemLink=Bank Account No.=FIELD(No.),
                            Posting Date=FIELD(Date Filter),
                            Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                            Global Dimension 1 Code=FIELD(Global Dimension 1 Filter) }

    { 35  ;2   ;Column  ;PostingDate_BankAccLedg;
               SourceExpr=FORMAT("Posting Date") }

    { 36  ;2   ;Column  ;DocType_BankAccLedg ;
               IncludeCaption=Yes;
               SourceExpr="Document Type" }

    { 37  ;2   ;Column  ;DocNo_BankAccLedg   ;
               IncludeCaption=Yes;
               SourceExpr="Document No." }

    { 2   ;2   ;Column  ;ExtDocNo_BankAccLedg;
               IncludeCaption=Yes;
               SourceExpr="External Document No." }

    { 38  ;2   ;Column  ;Desc_BankAccLedg    ;
               IncludeCaption=Yes;
               SourceExpr=Description }

    { 40  ;2   ;Column  ;BankAccBalance      ;
               SourceExpr=BankAccBalance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 41  ;2   ;Column  ;RemaningAmt_BankAccLedg;
               IncludeCaption=Yes;
               SourceExpr="Remaining Amount" }

    { 45  ;2   ;Column  ;EntryNo_BankAccLedg ;
               IncludeCaption=Yes;
               SourceExpr="Entry No." }

    { 8   ;2   ;Column  ;OpenFormat          ;
               OptionCaptionML=[DAN=�bn;
                                ENU=Open];
               SourceExpr=FORMAT(Open) }

    { 19  ;2   ;Column  ;Amount_BankAccLedg  ;
               IncludeCaption=Yes;
               SourceExpr=Amount }

    { 39  ;2   ;Column  ;EntryAmtLcy_BankAccLedg;
               IncludeCaption=Yes;
               SourceExpr="Amount (LCY)" }

    { 43  ;2   ;Column  ;BankAccBalanceLCY   ;
               SourceExpr=BankAccBalanceLCY;
               AutoFormatType=1 }

    { 33  ;2   ;Column  ;ContinuedCaption    ;
               SourceExpr=ContinuedCaptionLbl }

    { 5444;1   ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnAfterGetRecord=BEGIN
                                  IF NOT BankAccLedgEntryExists AND ((StartBalance = 0) OR ExcludeBalanceOnly) THEN BEGIN
                                    StartBalanceLCY := 0;
                                    CurrReport.SKIP;
                                  END;
                                END;
                                 }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Skift side pr. bankkonto;
                             ENU=New Page per Bank Account];
                  ToolTipML=[DAN=Angiver, om du vil udskrive hver bankkonto p� en separat side.;
                             ENU=Specifies if you want to print each bank account on a separate page.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintOnlyOnePerPage }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Udelad bankkonti, der kun har saldo;
                             ENU=Exclude Bank Accs. That Have a Balance Only];
                  ToolTipML=[DAN=Angiver, hvis du ikke �nsker, at rapporten skal omfatte poster for bankkonti, som har en saldo, men som ikke har en bev�gelse i den valgte tidsperiode.;
                             ENU=Specifies if you do not want the report to include entries for bank accounts that have a balance but do not have a net change during the selected time period.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ExcludeBalanceOnly;
                  MultiLine=Yes }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Medtag tilbagef�rte poster;
                             ENU=Include Reversed Entries];
                  ToolTipML=[DAN=Angiver, om du vil medtage tilbagef�rte poster i rapporten.;
                             ENU=Specifies if you want to include reversed entries in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintReversedEntries }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Periode: %1;ENU=Period: %1';
      PrintOnlyOnePerPage@1001 : Boolean;
      ExcludeBalanceOnly@1002 : Boolean;
      BankAccFilter@1003 : Text;
      DateFilter_BankAccount@1004 : Text;
      BankAccBalance@1005 : Decimal;
      BankAccBalanceLCY@1006 : Decimal;
      StartBalance@1007 : Decimal;
      StartBalanceLCY@1008 : Decimal;
      BankAccLedgEntryExists@1009 : Boolean;
      PrintReversedEntries@1010 : Boolean;
      PageGroupNo@1011 : Integer;
      BankAccDetailTrialBalCapLbl@1262 : TextConst 'DAN=Bankkonto - kontokort;ENU=Bank Acc. - Detail Trial Bal.';
      CurrReportPageNoCaptionLbl@2595 : TextConst 'DAN=Side;ENU=Page';
      RepInclBankAcchavingBalLbl@8592 : TextConst 'DAN=Rapporten indeholder ogs� bankkonti, der kun har saldi.;ENU=This report also includes bank accounts that only have balances.';
      BankAccLedgPostingDateCaptionLbl@3690 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      BankAccBalanceCaptionLbl@5054 : TextConst 'DAN=Saldo;ENU=Balance';
      OpenFormatCaptionLbl@1938 : TextConst 'DAN=�bn;ENU=Open';
      BankAccBalanceLCYCaptionLbl@9965 : TextConst 'DAN=Saldo (RV);ENU=Balance (LCY)';
      ContinuedCaptionLbl@2842 : TextConst 'DAN=Fortsat;ENU=Continued';

    PROCEDURE InitializeRequest@1(NewPrintOnlyOnePerPage@1000 : Boolean;NewExcludeBalanceOnly@1001 : Boolean;NewPrintReversedEntries@1002 : Boolean);
    BEGIN
      PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
      ExcludeBalanceOnly := NewExcludeBalanceOnly;
      PrintReversedEntries := NewPrintReversedEntries;
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
      <rd:DataSourceID>dd3e4e3c-392b-4e93-aa3c-e3b1c7e73e74</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="FilterPeriod_BankAccLedg">
          <DataField>FilterPeriod_BankAccLedg</DataField>
        </Field>
        <Field Name="CompanyName">
          <DataField>CompanyName</DataField>
        </Field>
        <Field Name="ExcludeBalanceOnly">
          <DataField>ExcludeBalanceOnly</DataField>
        </Field>
        <Field Name="BankAccFilter">
          <DataField>BankAccFilter</DataField>
        </Field>
        <Field Name="StartBalanceLCY">
          <DataField>StartBalanceLCY</DataField>
        </Field>
        <Field Name="StartBalanceLCYFormat">
          <DataField>StartBalanceLCYFormat</DataField>
        </Field>
        <Field Name="StartBalance">
          <DataField>StartBalance</DataField>
        </Field>
        <Field Name="StartBalanceFormat">
          <DataField>StartBalanceFormat</DataField>
        </Field>
        <Field Name="PrintOnlyOnePerPage">
          <DataField>PrintOnlyOnePerPage</DataField>
        </Field>
        <Field Name="ReportFilter">
          <DataField>ReportFilter</DataField>
        </Field>
        <Field Name="No_BankAccount">
          <DataField>No_BankAccount</DataField>
        </Field>
        <Field Name="Name_BankAccount">
          <DataField>Name_BankAccount</DataField>
        </Field>
        <Field Name="PhNo_BankAccount">
          <DataField>PhNo_BankAccount</DataField>
        </Field>
        <Field Name="CurrencyCode_BankAccount">
          <DataField>CurrencyCode_BankAccount</DataField>
        </Field>
        <Field Name="StartBalance2">
          <DataField>StartBalance2</DataField>
        </Field>
        <Field Name="StartBalance2Format">
          <DataField>StartBalance2Format</DataField>
        </Field>
        <Field Name="BankAccDetailTrialBalCap">
          <DataField>BankAccDetailTrialBalCap</DataField>
        </Field>
        <Field Name="CurrReportPageNoCaption">
          <DataField>CurrReportPageNoCaption</DataField>
        </Field>
        <Field Name="RepInclBankAcchavingBal">
          <DataField>RepInclBankAcchavingBal</DataField>
        </Field>
        <Field Name="BankAccLedgPostingDateCaption">
          <DataField>BankAccLedgPostingDateCaption</DataField>
        </Field>
        <Field Name="BankAccBalanceCaption">
          <DataField>BankAccBalanceCaption</DataField>
        </Field>
        <Field Name="OpenFormatCaption">
          <DataField>OpenFormatCaption</DataField>
        </Field>
        <Field Name="BankAccBalanceLCYCaption">
          <DataField>BankAccBalanceLCYCaption</DataField>
        </Field>
        <Field Name="PostingDate_BankAccLedg">
          <DataField>PostingDate_BankAccLedg</DataField>
        </Field>
        <Field Name="DocType_BankAccLedg">
          <DataField>DocType_BankAccLedg</DataField>
        </Field>
        <Field Name="DocNo_BankAccLedg">
          <DataField>DocNo_BankAccLedg</DataField>
        </Field>
        <Field Name="ExtDocNo_BankAccLedg">
          <DataField>ExtDocNo_BankAccLedg</DataField>
        </Field>
        <Field Name="Desc_BankAccLedg">
          <DataField>Desc_BankAccLedg</DataField>
        </Field>
        <Field Name="BankAccBalance">
          <DataField>BankAccBalance</DataField>
        </Field>
        <Field Name="BankAccBalanceFormat">
          <DataField>BankAccBalanceFormat</DataField>
        </Field>
        <Field Name="RemaningAmt_BankAccLedg">
          <DataField>RemaningAmt_BankAccLedg</DataField>
        </Field>
        <Field Name="RemaningAmt_BankAccLedgFormat">
          <DataField>RemaningAmt_BankAccLedgFormat</DataField>
        </Field>
        <Field Name="EntryNo_BankAccLedg">
          <DataField>EntryNo_BankAccLedg</DataField>
        </Field>
        <Field Name="OpenFormat">
          <DataField>OpenFormat</DataField>
        </Field>
        <Field Name="Amount_BankAccLedg">
          <DataField>Amount_BankAccLedg</DataField>
        </Field>
        <Field Name="Amount_BankAccLedgFormat">
          <DataField>Amount_BankAccLedgFormat</DataField>
        </Field>
        <Field Name="EntryAmtLcy_BankAccLedg">
          <DataField>EntryAmtLcy_BankAccLedg</DataField>
        </Field>
        <Field Name="EntryAmtLcy_BankAccLedgFormat">
          <DataField>EntryAmtLcy_BankAccLedgFormat</DataField>
        </Field>
        <Field Name="BankAccBalanceLCY">
          <DataField>BankAccBalanceLCY</DataField>
        </Field>
        <Field Name="BankAccBalanceLCYFormat">
          <DataField>BankAccBalanceLCYFormat</DataField>
        </Field>
        <Field Name="ContinuedCaption">
          <DataField>ContinuedCaption</DataField>
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
          <Tablix Name="BankAccLedger">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>1.62006cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.9461cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.27406cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.16987cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.49334cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.83731cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.41399cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.41399cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.43754cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.09941cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.49222cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.07938cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.01474cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox330">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!BankAccLedgPostingDateCaption.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>156</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox331">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DocType_BankAccLedgCaption.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>155</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox332">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DocNo_BankAccLedgCaption.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>154</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
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
                                  <Value>=First(Parameters!ExtDocNo_BankAccLedgCaption.Value)</Value>
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
                          <rd:DefaultName>Textbox6</rd:DefaultName>
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
                        <Textbox Name="textbox333">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!Desc_BankAccLedgCaption.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>153</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox334">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!Amount_BankAccLedgCaption.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>152</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox335">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!EntryAmtLcy_BankAccLedgCaption.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>151</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox336">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!BankAccBalanceCaption.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>150</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox337">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!BankAccBalanceLCYCaption.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>149</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox338">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!OpenFormatCaption.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>148</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox339">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(Parameters!RemaningAmt_BankAccLedgCaption.Value," ", Chr(10))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>147</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox340">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!EntryNo_BankAccLedgCaption.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>146</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox13">
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
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox13</rd:DefaultName>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox15">
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
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox15</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.17638cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox32">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox32</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                              <Width>1pt</Width>
                            </BottomBorder>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox44">
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
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox44</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox16">
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
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox16</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.17638cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox17">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox17</rd:DefaultName>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox28">
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
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox28</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox18">
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
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox18</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox218">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!No_BankAccount.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>140</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="textbox219">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Name_BankAccount.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>139</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="textbox220">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>138</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox221">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>137</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox222">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!StartBalance.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!StartBalanceFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>136</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
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
                                  <Value>=Fields!StartBalanceLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!StartBalanceLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>135</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox224">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>134</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox225">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>133</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox226">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>132</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
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
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox19">
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
                          <rd:DefaultName>Textbox19</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox234">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>126</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox235">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>125</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox236">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!PhNo_BankAccountCaption.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>124</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox237">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PhNo_BankAccount.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>123</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="textbox238">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>122</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox239">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>121</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox240">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>120</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox241">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>119</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox242">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>118</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox243">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>117</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox244">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>116</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox5">
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
                          <rd:DefaultName>Textbox5</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox20">
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
                          <rd:DefaultName>Textbox20</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox252">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>110</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox253">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>109</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox254">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!CurrencyCode_BankAccountCaption.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>108</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrencyCode_BankAccount.Value</Value>
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
                        <Textbox Name="Textbox3">
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
                          <rd:DefaultName>Textbox3</rd:DefaultName>
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
                        <Textbox Name="textbox257">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>105</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox258">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>104</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox259">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>103</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox260">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>102</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox261">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>101</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox262">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>100</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
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
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox21">
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
                          <rd:DefaultName>Textbox21</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox309">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDate_BankAccLedg.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>15</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox310">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocType_BankAccLedg.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>14</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Fields!DocNo_BankAccLedg.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>13</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox9">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!ExtDocNo_BankAccLedg.Value</Value>
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
                          <rd:DefaultName>Textbox9</rd:DefaultName>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox312">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Desc_BankAccLedg.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>12</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox313">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Amount_BankAccLedg.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!Amount_BankAccLedgFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>11</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox314">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryAmtLcy_BankAccLedg.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!EntryAmtLcy_BankAccLedgFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>10</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox315">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BankAccBalance.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!BankAccBalanceFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>9</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox316">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BankAccBalanceLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!BankAccBalanceLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>8</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox317">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!OpenFormat.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>7</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox318">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!RemaningAmt_BankAccLedg.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!RemaningAmt_BankAccLedgFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>6</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox319">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryNo_BankAccLedg.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>5</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="FlagSum1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=iif((RunningValue(Fields!Amount_BankAccLedg.Value, SUM, "table2_Group1")+ Fields!StartBalance.Value)=(sum(Fields!Amount_BankAccLedg.Value, "table2_Group1") + Fields!StartBalance.Value),true,false)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>3</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="SubTotal">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=RunningValue(Fields!EntryAmtLcy_BankAccLedg.Value, SUM, "table2_Group1")</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox156">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>30</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
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
                                  <Value />
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>29</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox158">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Name_BankAccount.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>28</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="textbox159">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!Amount_BankAccLedg.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!Amount_BankAccLedgFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>27</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                              <Width>1pt</Width>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox160">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!EntryAmtLcy_BankAccLedg.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!EntryAmtLcy_BankAccLedgFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>26</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                              <Width>1pt</Width>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox161">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!Amount_BankAccLedg.Value) + Fields!StartBalance.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!StartBalanceFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>25</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                              <Width>1pt</Width>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox162">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!EntryAmtLcy_BankAccLedg.Value) + Fields!StartBalanceLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!StartBalanceLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>24</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                              <Width>1pt</Width>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox163">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>23</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox164">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>22</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox165">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>21</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox167">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>19</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox23">
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
                          <rd:DefaultName>Textbox23</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox176">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>46</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox177">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>45</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox178">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>44</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox10">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox10</rd:DefaultName>
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
                        <Textbox Name="textbox179">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>43</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox180">
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
                                    <Format>=Fields!Amount_BankAccLedgFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>42</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox181">
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
                                    <Format>=Fields!EntryAmtLcy_BankAccLedgFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>41</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox182">
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
                                    <Format>=Fields!StartBalanceFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>40</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox183">
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
                                    <Format>=Fields!StartBalanceLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>39</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox184">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>38</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox185">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>37</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox186">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>36</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox188">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>34</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox24">
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
                          <rd:DefaultName>Textbox24</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
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
                  <Group Name="table2_Group2">
                    <GroupExpressions>
                      <GroupExpression>=IIF(Fields!PrintOnlyOnePerPage.Value,Fields!No_BankAccount.Value,1)</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <TablixMembers>
                    <TablixMember>
                      <Group Name="table2_Group1">
                        <GroupExpressions>
                          <GroupExpression>=Fields!No_BankAccount.Value</GroupExpression>
                        </GroupExpressions>
                      </Group>
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
                          <Visibility>
                            <Hidden>=iif(Fields!CurrencyCode_BankAccount.Value="",true,false)</Hidden>
                          </Visibility>
                          <KeepWithGroup>After</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Group Name="table2_Details_Group">
                            <DataElementName>Detail</DataElementName>
                          </Group>
                          <TablixMembers>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!DocNo_BankAccLedg.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
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
                      </TablixMembers>
                    </TablixMember>
                  </TablixMembers>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <PageBreak>
              <BreakLocation>End</BreakLocation>
            </PageBreak>
            <Top>28.1pt</Top>
            <Height>2.82222cm</Height>
            <Width>25.49201cm</Width>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
            </Style>
          </Tablix>
          <Textbox Name="textbox396">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!RepInclBankAcchavingBal.Value</Value>
                    <Style>
                      <FontFamily>Segoe UI</FontFamily>
                      <FontSize>8pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style>
                  <FontFamily>Segoe UI</FontFamily>
                  <FontSize>8pt</FontSize>
                </Style>
              </Paragraph>
            </Paragraphs>
            <Height>11pt</Height>
            <Width>25.04388cm</Width>
            <ZIndex>1</ZIndex>
            <Visibility>
              <Hidden>=IIF(not Fields!ExcludeBalanceOnly.Value,False,True)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
              <VerticalAlign>Middle</VerticalAlign>
              <PaddingRight>0.0625in</PaddingRight>
            </Style>
          </Textbox>
          <Textbox Name="textbox397">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!ReportFilter.Value</Value>
                    <Style>
                      <FontFamily>Segoe UI</FontFamily>
                      <FontSize>8pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style>
                  <FontFamily>Segoe UI</FontFamily>
                  <FontSize>8pt</FontSize>
                </Style>
              </Paragraph>
            </Paragraphs>
            <Top>13.6pt</Top>
            <Height>11pt</Height>
            <Width>25.12326cm</Width>
            <ZIndex>2</ZIndex>
            <Visibility>
              <Hidden>=IIF(Fields!BankAccFilter.Value = "",True,False)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
              <VerticalAlign>Middle</VerticalAlign>
              <PaddingRight>0.0625in</PaddingRight>
            </Style>
          </Textbox>
        </ReportItems>
        <Height>3.88147cm</Height>
        <Style>
          <FontFamily>Segoe UI</FontFamily>
          <FontSize>8pt</FontSize>
        </Style>
      </Body>
      <Width>25.49201cm</Width>
      <Page>
        <PageHeader>
          <Height>2.18757cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="CurrReportPAGENOCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CurrReportPageNoCaption.Value,"DataSet_Result") &amp; " " &amp; Globals!PageNumber</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>10pt</Top>
              <Left>16.0955cm</Left>
              <Height>11pt</Height>
              <Width>9.01712cm</Width>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BankAccDetailTrialBalCap1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!BankAccDetailTrialBalCap.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>14pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0pt</Top>
              <Height>20pt</Height>
              <Width>16.0955cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="COMPANYNAME1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CompanyName.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>30pt</Top>
              <Height>11pt</Height>
              <Width>16.0955cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="DateFilter_BankAccountPeriod1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!FilterPeriod_BankAccLedg.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>20pt</Top>
              <Height>11pt</Height>
              <Width>16.0955cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="UserIdTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=User!UserID</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>20pt</Top>
              <Left>16.0955cm</Left>
              <Height>11pt</Height>
              <Width>9.01712cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox346">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Globals!ExecutionTime</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Format>MM/dd/yyyy</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0pt</Top>
              <Left>16.0955cm</Left>
              <Height>11pt</Height>
              <Width>9.01712cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <Border />
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
          <Style>
            <FontFamily>Segoe UI</FontFamily>
            <FontSize>8pt</FontSize>
          </Style>
        </PageHeader>
        <PageFooter>
          <Height>0.82354cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="textbox36">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!ContinuedCaption.Value &amp;"..........","DataSet_Result")</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <rd:DefaultName>textbox36</rd:DefaultName>
              <Top>0.41255cm</Top>
              <Left>3.715cm</Left>
              <Height>11pt</Height>
              <Width>4.2225cm</Width>
              <Visibility>
                <Hidden>=ReportItems!FlagSum1.Value</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <Border />
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
              </Style>
            </Textbox>
            <Textbox Name="textbox362">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!SubTotal.Value</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Format>#,##0.00</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.43548cm</Top>
              <Left>17.45473cm</Left>
              <Height>11pt</Height>
              <Width>0.94024in</Width>
              <ZIndex>1</ZIndex>
              <Visibility>
                <Hidden>=ReportItems!FlagSum1.Value</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Top</VerticalAlign>
                <PaddingLeft>5pt</PaddingLeft>
                <PaddingRight>5pt</PaddingRight>
              </Style>
            </Textbox>
          </ReportItems>
          <Style>
            <FontFamily>Segoe UI</FontFamily>
            <FontSize>8pt</FontSize>
          </Style>
        </PageFooter>
        <PageHeight>21cm</PageHeight>
        <PageWidth>29.7cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.05834cm</LeftMargin>
        <RightMargin>1.05834cm</RightMargin>
        <TopMargin>1.05834cm</TopMargin>
        <BottomMargin>1.48166cm</BottomMargin>
        <ColumnSpacing>1.27cm</ColumnSpacing>
        <Style>
          <FontFamily>Segoe UI</FontFamily>
          <FontSize>8pt</FontSize>
        </Style>
      </Page>
    </ReportSection>
  </ReportSections>
  <ReportParameters>
    <ReportParameter Name="PhNo_BankAccountCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>PhNo_BankAccountCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>PhNo_BankAccountCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="CurrencyCode_BankAccountCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>CurrencyCode_BankAccountCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>CurrencyCode_BankAccountCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="DocType_BankAccLedgCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>DocType_BankAccLedgCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>DocType_BankAccLedgCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="DocNo_BankAccLedgCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>DocNo_BankAccLedgCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>DocNo_BankAccLedgCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="ExtDocNo_BankAccLedgCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>ExtDocNo_BankAccLedgCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>ExtDocNo_BankAccLedgCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="Desc_BankAccLedgCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Desc_BankAccLedgCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Desc_BankAccLedgCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="RemaningAmt_BankAccLedgCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>RemaningAmt_BankAccLedgCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>RemaningAmt_BankAccLedgCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="EntryNo_BankAccLedgCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>EntryNo_BankAccLedgCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>EntryNo_BankAccLedgCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="Amount_BankAccLedgCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Amount_BankAccLedgCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Amount_BankAccLedgCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="EntryAmtLcy_BankAccLedgCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>EntryAmtLcy_BankAccLedgCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>EntryAmtLcy_BankAccLedgCaption</Prompt>
    </ReportParameter>
  </ReportParameters>
  <ReportParametersLayout>
    <GridLayoutDefinition>
      <NumberOfColumns>1</NumberOfColumns>
      <NumberOfRows>10</NumberOfRows>
      <CellDefinitions>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>0</RowIndex>
          <ParameterName>PhNo_BankAccountCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>1</RowIndex>
          <ParameterName>CurrencyCode_BankAccountCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>2</RowIndex>
          <ParameterName>DocType_BankAccLedgCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>3</RowIndex>
          <ParameterName>DocNo_BankAccLedgCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>4</RowIndex>
          <ParameterName>ExtDocNo_BankAccLedgCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>5</RowIndex>
          <ParameterName>Desc_BankAccLedgCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>6</RowIndex>
          <ParameterName>RemaningAmt_BankAccLedgCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>7</RowIndex>
          <ParameterName>EntryNo_BankAccLedgCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>8</RowIndex>
          <ParameterName>Amount_BankAccLedgCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>9</RowIndex>
          <ParameterName>EntryAmtLcy_BankAccLedgCaption</ParameterName>
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
</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>fba17a2b-3b0e-4a00-9f8d-f08f7584a785</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

