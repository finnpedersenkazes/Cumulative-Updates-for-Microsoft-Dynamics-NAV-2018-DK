OBJECT Report 4 Detail Trial Balance
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Detaljeret r�balance;
               ENU=Detail Trial Balance];
    OnPreReport=BEGIN
                  GLFilter := "G/L Account".GETFILTERS;
                  GLDateFilter := "G/L Account".GETFILTER("Date Filter");
                END;

  }
  DATASET
  {
    { 6710;    ;DataItem;                    ;
               DataItemTable=Table15;
               DataItemTableView=WHERE(Account Type=CONST(Posting));
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               PageGroupNo := 1;

                               CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                             END;

               OnAfterGetRecord=VAR
                                  GLEntry@1001 : Record 17;
                                  Date@1000 : Record 2000000007;
                                BEGIN
                                  StartBalance := 0;
                                  IF GLDateFilter <> '' THEN BEGIN
                                    Date.SETRANGE("Period Type",Date."Period Type"::Date);
                                    Date.SETFILTER("Period Start",GLDateFilter);
                                    IF Date.FINDFIRST THEN BEGIN
                                      SETRANGE("Date Filter",0D,CLOSINGDATE(Date."Period Start" - 1));
                                      CALCFIELDS("Net Change");
                                      StartBalance := "Net Change";
                                      SETFILTER("Date Filter",GLDateFilter);
                                    END;
                                  END;

                                  IF PrintOnlyOnePerPage THEN BEGIN
                                    GLEntry.RESET;
                                    GLEntry.SETRANGE("G/L Account No.","No.");
                                    IF CurrReport.PRINTONLYIFDETAIL AND GLEntry.FINDFIRST THEN
                                      PageGroupNo := PageGroupNo + 1;
                                  END;
                                END;

               ReqFilterFields=No.,Search Name,Income/Balance,Debit/Credit,Date Filter }

    { 3   ;1   ;Column  ;PeriodGLDtFilter    ;
               SourceExpr=STRSUBSTNO(Text000,GLDateFilter) }

    { 6   ;1   ;Column  ;CompanyName         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 49  ;1   ;Column  ;ExcludeBalanceOnly  ;
               SourceExpr=ExcludeBalanceOnly }

    { 54  ;1   ;Column  ;PrintReversedEntries;
               SourceExpr=PrintReversedEntries }

    { 50  ;1   ;Column  ;PageGroupNo         ;
               SourceExpr=PageGroupNo }

    { 51  ;1   ;Column  ;PrintClosingEntries ;
               SourceExpr=PrintClosingEntries }

    { 52  ;1   ;Column  ;PrintOnlyCorrections;
               SourceExpr=PrintOnlyCorrections }

    { 10  ;1   ;Column  ;GLAccTableCaption   ;
               SourceExpr=TABLECAPTION + ': ' + GLFilter }

    { 48  ;1   ;Column  ;GLFilter            ;
               SourceExpr=GLFilter }

    { 12  ;1   ;Column  ;EmptyString         ;
               SourceExpr='' }

    { 61  ;1   ;Column  ;No_GLAcc            ;
               SourceExpr="No." }

    { 1   ;1   ;Column  ;DetailTrialBalCaption;
               SourceExpr=DetailTrialBalCaptionLbl }

    { 4   ;1   ;Column  ;PageCaption         ;
               SourceExpr=PageCaptionLbl }

    { 8   ;1   ;Column  ;BalanceCaption      ;
               SourceExpr=BalanceCaptionLbl }

    { 9   ;1   ;Column  ;PeriodCaption       ;
               SourceExpr=PeriodCaptionLbl }

    { 47  ;1   ;Column  ;OnlyCorrectionsCaption;
               SourceExpr=OnlyCorrectionsCaptionLbl }

    { 11  ;1   ;Column  ;NetChangeCaption    ;
               SourceExpr=NetChangeCaptionLbl }

    { 17  ;1   ;Column  ;GLEntryDebitAmtCaption;
               SourceExpr=GLEntryDebitAmtCaptionLbl }

    { 18  ;1   ;Column  ;GLEntryCreditAmtCaption;
               SourceExpr=GLEntryCreditAmtCaptionLbl }

    { 19  ;1   ;Column  ;GLBalCaption        ;
               SourceExpr=GLBalCaptionLbl }

    { 8098;1   ;DataItem;PageCounter         ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnAfterGetRecord=BEGIN
                                  CurrReport.PRINTONLYIFDETAIL := ExcludeBalanceOnly OR (StartBalance = 0);
                                END;
                                 }

    { 22  ;2   ;Column  ;Name_GLAcc          ;
               SourceExpr="G/L Account".Name }

    { 23  ;2   ;Column  ;StartBalance        ;
               SourceExpr=StartBalance;
               AutoFormatType=1 }

    { 7069;2   ;DataItem;                    ;
               DataItemTable=Table17;
               DataItemTableView=SORTING(G/L Account No.,Posting Date);
               OnPreDataItem=BEGIN
                               GLBalance := StartBalance;
                               CurrReport.CREATETOTALS(Amount,"Debit Amount","Credit Amount","VAT Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF PrintOnlyCorrections THEN
                                    IF NOT (("Debit Amount" < 0) OR ("Credit Amount" < 0)) THEN
                                      CurrReport.SKIP;
                                  IF NOT PrintReversedEntries AND Reversed THEN
                                    CurrReport.SKIP;

                                  GLBalance := GLBalance + Amount;
                                  IF ("Posting Date" = CLOSINGDATE("Posting Date")) AND
                                     NOT PrintClosingEntries
                                  THEN BEGIN
                                    "Debit Amount" := 0;
                                    "Credit Amount" := 0;
                                  END;

                                  IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
                                    ClosingEntry := TRUE
                                  ELSE
                                    ClosingEntry := FALSE;
                                END;

               DataItemLinkReference=G/L Account;
               DataItemLink=G/L Account No.=FIELD(No.),
                            Posting Date=FIELD(Date Filter),
                            Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                            Business Unit Code=FIELD(Business Unit Filter) }

    { 25  ;3   ;Column  ;VATAmount_GLEntry   ;
               IncludeCaption=Yes;
               SourceExpr="VAT Amount" }

    { 26  ;3   ;Column  ;DebitAmount_GLEntry ;
               SourceExpr="Debit Amount" }

    { 27  ;3   ;Column  ;CreditAmount_GLEntry;
               SourceExpr="Credit Amount" }

    { 29  ;3   ;Column  ;PostingDate_GLEntry ;
               SourceExpr=FORMAT("Posting Date") }

    { 30  ;3   ;Column  ;DocumentNo_GLEntry  ;
               SourceExpr="Document No." }

    { 15  ;3   ;Column  ;ExtDocNo_GLEntry    ;
               IncludeCaption=Yes;
               SourceExpr="External Document No." }

    { 31  ;3   ;Column  ;Description_GLEntry ;
               SourceExpr=Description }

    { 35  ;3   ;Column  ;GLBalance           ;
               SourceExpr=GLBalance;
               AutoFormatType=1 }

    { 36  ;3   ;Column  ;EntryNo_GLEntry     ;
               SourceExpr="Entry No." }

    { 55  ;3   ;Column  ;ClosingEntry        ;
               SourceExpr=ClosingEntry }

    { 56  ;3   ;Column  ;Reversed_GLEntry    ;
               SourceExpr=Reversed }

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

      { 1   ;2   ;Field     ;
                  Name=NewPageperGLAcc;
                  CaptionML=[DAN=Skift side pr. finanskonto;
                             ENU=New Page per G/L Acc.];
                  ToolTipML=[DAN=Angiver, om oplysninger om hver enkelt finanskonto udskrives p� en ny side, hvis du har valgt to eller flere finanskonti, der skal medtages i rapporten.;
                             ENU=Specifies if each G/L account information is printed on a new page if you have chosen two or more G/L accounts to be included in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintOnlyOnePerPage }

      { 2   ;2   ;Field     ;
                  Name=ExcludeGLAccsHaveBalanceOnly;
                  CaptionML=[DAN=Udelad finanskonti, der kun har saldo;
                             ENU=Exclude G/L Accs. That Have a Balance Only];
                  ToolTipML=[DAN=Angiver, hvis du ikke �nsker, at rapporten skal omfatte poster for finanskonti, som har en saldo, men som ikke har en bev�gelse i den valgte tidsperiode.;
                             ENU=Specifies if you do not want the report to include entries for G/L accounts that have a balance but do not have a net change during the selected time period.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ExcludeBalanceOnly;
                  MultiLine=Yes }

      { 3   ;2   ;Field     ;
                  Name=InclClosingEntriesWithinPeriod;
                  CaptionML=[DAN=Medtag ogs� ultimoposter inden for perioden;
                             ENU=Include Closing Entries Within the Period];
                  ToolTipML=[DAN=Angiver, om du �nsker, at rapporten omfatter ultimoposter. Dette er nyttigt, hvis rapporten d�kker et helt regnskabs�r. Ultimodatoen er en fiktiv dato mellem den sidste dag i det gamle regnskabs�r og den f�rste dag i det nye. De vises med et U foran datoen, f.eks. U123194. Hvis du ikke markerer dette afkrydsningsfelt, vises der ingen ultimodatoer.;
                             ENU=Specifies if you want the report to include closing entries. This is useful if the report covers an entire fiscal year. Closing entries are listed on a fictitious date between the last day of one fiscal year and the first day of the next one. They have a C before the date, such as C123194. If you do not select this field, no closing entries are shown.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintClosingEntries;
                  MultiLine=Yes }

      { 6   ;2   ;Field     ;
                  Name=IncludeReversedEntries;
                  CaptionML=[DAN=Medtag tilbagef�rte poster;
                             ENU=Include Reversed Entries];
                  ToolTipML=[DAN=Angiver, om du vil medtage tilbagef�rte poster i rapporten.;
                             ENU=Specifies if you want to include reversed entries in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintReversedEntries }

      { 4   ;2   ;Field     ;
                  Name=PrintCorrectionsOnly;
                  CaptionML=[DAN=Udskriv kun rettelser;
                             ENU=Print Corrections Only];
                  ToolTipML=[DAN=Angiver, om rapporten kun skal vise de poster, der er blevet tilbagef�rt, og de tilh�rende korrigerende poster.;
                             ENU=Specifies if you want the report to show only the entries that have been reversed and their matching correcting entries.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintOnlyCorrections }

    }
  }
  LABELS
  {
    { 2   ;PostingDateCaption  ;CaptionML=[DAN=Bogf�ringsdato;
                                           ENU=Posting Date] }
    { 5   ;DocNoCaption        ;CaptionML=[DAN=Bilagsnr.;
                                           ENU=Document No.] }
    { 7   ;DescCaption         ;CaptionML=[DAN=Beskrivelse;
                                           ENU=Description] }
    { 13  ;VATAmtCaption       ;CaptionML=[DAN=Momsbel�b;
                                           ENU=VAT Amount] }
    { 14  ;EntryNoCaption      ;CaptionML=[DAN=L�benr.;
                                           ENU=Entry No.] }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Periode: %1;ENU=Period: %1';
      GLDateFilter@1001 : Text;
      GLFilter@1002 : Text;
      GLBalance@1003 : Decimal;
      StartBalance@1004 : Decimal;
      PrintOnlyOnePerPage@1005 : Boolean;
      ExcludeBalanceOnly@1006 : Boolean;
      PrintClosingEntries@1007 : Boolean;
      PrintOnlyCorrections@1008 : Boolean;
      PrintReversedEntries@1009 : Boolean;
      PageGroupNo@1010 : Integer;
      ClosingEntry@1012 : Boolean;
      DetailTrialBalCaptionLbl@5948 : TextConst 'DAN=Detaljeret r�balance;ENU=Detail Trial Balance';
      PageCaptionLbl@6215 : TextConst 'DAN=Side;ENU=Page';
      BalanceCaptionLbl@6364 : TextConst 'DAN=Dette omfatter ogs� finanskonti, der kun har en saldo.;ENU=This also includes general ledger accounts that only have a balance.';
      PeriodCaptionLbl@7978 : TextConst 'DAN=Rapporten indeholder ogs� ultimoposter i perioden.;ENU=This report also includes closing entries within the period.';
      OnlyCorrectionsCaptionLbl@1160 : TextConst 'DAN=Det er kun korrigeringer, der er inkluderet.;ENU=Only corrections are included.';
      NetChangeCaptionLbl@2192 : TextConst 'DAN=Bev�gelse;ENU=Net Change';
      GLEntryDebitAmtCaptionLbl@3560 : TextConst 'DAN=Debet;ENU=Debit';
      GLEntryCreditAmtCaptionLbl@4092 : TextConst 'DAN=Kredit;ENU=Credit';
      GLBalCaptionLbl@2356 : TextConst 'DAN=Saldo;ENU=Balance';

    PROCEDURE InitializeRequest@1(NewPrintOnlyOnePerPage@1000 : Boolean;NewExcludeBalanceOnly@1001 : Boolean;NewPrintClosingEntries@1002 : Boolean;NewPrintReversedEntries@1003 : Boolean;NewPrintOnlyCorrections@1004 : Boolean);
    BEGIN
      PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
      ExcludeBalanceOnly := NewExcludeBalanceOnly;
      PrintClosingEntries := NewPrintClosingEntries;
      PrintReversedEntries := NewPrintReversedEntries;
      PrintOnlyCorrections := NewPrintOnlyCorrections;
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
      <rd:DataSourceID>c396a512-e01c-4416-83e6-146281d0d75b</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="PeriodGLDtFilter">
          <DataField>PeriodGLDtFilter</DataField>
        </Field>
        <Field Name="CompanyName">
          <DataField>CompanyName</DataField>
        </Field>
        <Field Name="ExcludeBalanceOnly">
          <DataField>ExcludeBalanceOnly</DataField>
        </Field>
        <Field Name="PrintReversedEntries">
          <DataField>PrintReversedEntries</DataField>
        </Field>
        <Field Name="PageGroupNo">
          <DataField>PageGroupNo</DataField>
        </Field>
        <Field Name="PrintClosingEntries">
          <DataField>PrintClosingEntries</DataField>
        </Field>
        <Field Name="PrintOnlyCorrections">
          <DataField>PrintOnlyCorrections</DataField>
        </Field>
        <Field Name="GLAccTableCaption">
          <DataField>GLAccTableCaption</DataField>
        </Field>
        <Field Name="GLFilter">
          <DataField>GLFilter</DataField>
        </Field>
        <Field Name="EmptyString">
          <DataField>EmptyString</DataField>
        </Field>
        <Field Name="No_GLAcc">
          <DataField>No_GLAcc</DataField>
        </Field>
        <Field Name="DetailTrialBalCaption">
          <DataField>DetailTrialBalCaption</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="BalanceCaption">
          <DataField>BalanceCaption</DataField>
        </Field>
        <Field Name="PeriodCaption">
          <DataField>PeriodCaption</DataField>
        </Field>
        <Field Name="OnlyCorrectionsCaption">
          <DataField>OnlyCorrectionsCaption</DataField>
        </Field>
        <Field Name="NetChangeCaption">
          <DataField>NetChangeCaption</DataField>
        </Field>
        <Field Name="GLEntryDebitAmtCaption">
          <DataField>GLEntryDebitAmtCaption</DataField>
        </Field>
        <Field Name="GLEntryCreditAmtCaption">
          <DataField>GLEntryCreditAmtCaption</DataField>
        </Field>
        <Field Name="GLBalCaption">
          <DataField>GLBalCaption</DataField>
        </Field>
        <Field Name="Name_GLAcc">
          <DataField>Name_GLAcc</DataField>
        </Field>
        <Field Name="StartBalance">
          <DataField>StartBalance</DataField>
        </Field>
        <Field Name="StartBalanceFormat">
          <DataField>StartBalanceFormat</DataField>
        </Field>
        <Field Name="VATAmount_GLEntry">
          <DataField>VATAmount_GLEntry</DataField>
        </Field>
        <Field Name="VATAmount_GLEntryFormat">
          <DataField>VATAmount_GLEntryFormat</DataField>
        </Field>
        <Field Name="DebitAmount_GLEntry">
          <DataField>DebitAmount_GLEntry</DataField>
        </Field>
        <Field Name="DebitAmount_GLEntryFormat">
          <DataField>DebitAmount_GLEntryFormat</DataField>
        </Field>
        <Field Name="CreditAmount_GLEntry">
          <DataField>CreditAmount_GLEntry</DataField>
        </Field>
        <Field Name="CreditAmount_GLEntryFormat">
          <DataField>CreditAmount_GLEntryFormat</DataField>
        </Field>
        <Field Name="PostingDate_GLEntry">
          <DataField>PostingDate_GLEntry</DataField>
        </Field>
        <Field Name="DocumentNo_GLEntry">
          <DataField>DocumentNo_GLEntry</DataField>
        </Field>
        <Field Name="ExtDocNo_GLEntry">
          <DataField>ExtDocNo_GLEntry</DataField>
        </Field>
        <Field Name="Description_GLEntry">
          <DataField>Description_GLEntry</DataField>
        </Field>
        <Field Name="GLBalance">
          <DataField>GLBalance</DataField>
        </Field>
        <Field Name="GLBalanceFormat">
          <DataField>GLBalanceFormat</DataField>
        </Field>
        <Field Name="EntryNo_GLEntry">
          <DataField>EntryNo_GLEntry</DataField>
        </Field>
        <Field Name="ClosingEntry">
          <DataField>ClosingEntry</DataField>
        </Field>
        <Field Name="Reversed_GLEntry">
          <DataField>Reversed_GLEntry</DataField>
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
          <Tablix Name="TableGLEntry">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>1.9cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.28462cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.28462cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.92639cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.97414cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.23414cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.23414cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.23259cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>73</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox111">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>72</ZIndex>
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
                        <Textbox Name="Textbox33">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox33</rd:DefaultName>
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
                        <Textbox Name="TextBox12">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>71</ZIndex>
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
                        <Textbox Name="TextBox13">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>70</ZIndex>
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
                        <Textbox Name="NetChangeCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!NetChangeCaption.Value)</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>69</ZIndex>
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
                        <Textbox Name="TextBox15">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>68</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                        <Textbox Name="TextBox19">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>63</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox110">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>62</ZIndex>
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
                        <Textbox Name="Textbox34">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox34</rd:DefaultName>
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
                        <Textbox Name="TextBox1112">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>61</ZIndex>
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
                        <Textbox Name="TextBox112">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>60</ZIndex>
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
                        <Textbox Name="EmptyString">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(First(Fields!EmptyString.Value)="","...............................................................",First(Fields!EmptyString.Value))</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>59</ZIndex>
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
                        <Textbox Name="TextBox114">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>58</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                        <Textbox Name="GLEntryPostingDateCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!PostingDateCaption.Value</Value>
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
                          <ZIndex>53</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="GLEntryDocumentNoCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DocNoCaption.Value</Value>
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
                          <ZIndex>52</ZIndex>
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
                        <Textbox Name="GLEntryExtDocNoCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!ExtDocNo_GLEntryCaption.Value</Value>
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
                        <Textbox Name="GLEntryDescriptionCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DescCaption.Value</Value>
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
                          <ZIndex>51</ZIndex>
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
                        <Textbox Name="GLEntryVATAmountControl32Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!VATAmtCaption.Value</Value>
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
                          <ZIndex>50</ZIndex>
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
                        <Textbox Name="GLEntryDebitAmountControl33Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!GLEntryDebitAmtCaption.Value)</Value>
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
                          <ZIndex>49</ZIndex>
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
                        <Textbox Name="GLEntryCreditAmountControl34Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!GLEntryCreditAmtCaption.Value)</Value>
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
                          <ZIndex>48</ZIndex>
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
                        <Textbox Name="GLBalanceCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!GLBalCaption.Value)</Value>
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
                          <ZIndex>47</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                        <Textbox Name="Textbox37">
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
                          <rd:DefaultName>Textbox37</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>8</ColSpan>
                      </CellContents>
                    </TablixCell>
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
                  <Height>0.17638cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox11">
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
                          <rd:DefaultName>Textbox11</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>8</ColSpan>
                      </CellContents>
                    </TablixCell>
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
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox41">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!No_GLAcc.Value</Value>
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
                          <ZIndex>39</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Name_GLAcc.Value</Value>
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
                          <ZIndex>38</ZIndex>
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
                        <Textbox Name="textbox5">
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
                          <rd:DefaultName>textbox5</rd:DefaultName>
                          <ZIndex>37</ZIndex>
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
                        <Textbox Name="textbox6">
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
                          <rd:DefaultName>textbox6</rd:DefaultName>
                          <ZIndex>36</ZIndex>
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
                        <Textbox Name="textbox7">
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
                          <rd:DefaultName>textbox7</rd:DefaultName>
                          <ZIndex>35</ZIndex>
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
                        <Textbox Name="textbox8">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!StartBalance.Value</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!StartBalanceFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox8</rd:DefaultName>
                          <ZIndex>34</ZIndex>
                          <Style>
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
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="GLEntryPostingDate">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDate_GLEntry.Value</Value>
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
                          <ZIndex>13</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="GLEntryDocumentNo">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocumentNo_GLEntry.Value</Value>
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
                          <ZIndex>12</ZIndex>
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
                        <Textbox Name="GLEntryExtDocNo">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!ExtDocNo_GLEntry.Value</Value>
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
                        <Textbox Name="GLEntryDescription">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Description_GLEntry.Value</Value>
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
                          <ZIndex>11</ZIndex>
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
                        <Textbox Name="GLEntryVATAmountControl32">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VATAmount_GLEntry.Value</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!VATAmount_GLEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>10</ZIndex>
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
                        <Textbox Name="GLEntryDebitAmountControl33">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.BlankZero(Fields!DebitAmount_GLEntry.Value)</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!DebitAmount_GLEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>9</ZIndex>
                          <DataElementOutput>NoOutput</DataElementOutput>
                          <Style>
                            <Border />
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
                        <Textbox Name="GLEntryCreditAmountControl34">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.BlankZero(Fields!CreditAmount_GLEntry.Value)</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!CreditAmount_GLEntryFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>8</ZIndex>
                          <DataElementOutput>NoOutput</DataElementOutput>
                          <Style>
                            <Border />
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
                        <Textbox Name="GLBalance">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!GLBalance.Value</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!GLBalanceFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>7</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
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
                  <Height>0.35278cm</Height>
                  <TablixCells>
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
                          <rd:DefaultName>textbox25</rd:DefaultName>
                          <ZIndex>26</ZIndex>
                          <Style>
                            <Border>
                              <Color>#cccccc</Color>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Fields!Name_GLAcc.Value</Value>
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
                          <ZIndex>25</ZIndex>
                          <Style>
                            <Border>
                              <Color>#cccccc</Color>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="textbox28">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF((CountDistinct(Fields!VATAmount_GLEntry.Value)=0)and(First(Fields!VATAmount_GLEntry.Value)=0),0,Sum(Fields!VATAmount_GLEntry.Value))</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>="#,##0.00"</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox28</rd:DefaultName>
                          <ZIndex>24</ZIndex>
                          <Style>
                            <Border>
                              <Color>#cccccc</Color>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Code.BlankZero(Sum(Fields!DebitAmount_GLEntry.Value))</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>="#,##0.00"</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox29</rd:DefaultName>
                          <ZIndex>23</ZIndex>
                          <DataElementOutput>NoOutput</DataElementOutput>
                          <Style>
                            <Border>
                              <Color>#cccccc</Color>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
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
                                  <Value>=Code.BlankZero(Sum(Fields!CreditAmount_GLEntry.Value))</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>="#,##0.00"</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox30</rd:DefaultName>
                          <ZIndex>22</ZIndex>
                          <DataElementOutput>NoOutput</DataElementOutput>
                          <Style>
                            <Border>
                              <Color>#cccccc</Color>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
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
                                  <Value>=IIF(Parameters!VATAmount_GLEntryCaption.Value&lt;&gt;"", Last(Fields!GLBalance.Value),Fields!StartBalance.Value)</Value>
                                  <Style>
                                    <FontStyle>Normal</FontStyle>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>="#,##0.00"</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox31</rd:DefaultName>
                          <ZIndex>21</ZIndex>
                          <Style>
                            <Border>
                              <Color>#cccccc</Color>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
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
                  <Height>0.35278cm</Height>
                  <TablixCells>
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
                          <rd:DefaultName>Textbox4</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
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
                          <rd:DefaultName>Textbox10</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox38">
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
                          <rd:DefaultName>Textbox38</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox14">
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
                          <rd:DefaultName>Textbox14</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                          <rd:DefaultName>Textbox17</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>Textbox18</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>Textbox20</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>Textbox21</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
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
                  <Visibility>
                    <Hidden>=IIF(CountRows()=0,TRUE,FALSE)</Hidden>
                  </Visibility>
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
                  <Group Name="Table1_Group">
                    <GroupExpressions>
                      <GroupExpression>=Fields!PageGroupNo.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <TablixMembers>
                    <TablixMember>
                      <Group Name="Table1_Group2">
                        <GroupExpressions>
                          <GroupExpression>=Fields!No_GLAcc.Value</GroupExpression>
                        </GroupExpressions>
                      </Group>
                      <TablixMembers>
                        <TablixMember>
                          <KeepWithGroup>After</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Group Name="Table1_Details_Group">
                            <DataElementName>Detail</DataElementName>
                          </Group>
                          <TablixMembers>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF(((First(Fields!PrintClosingEntries.Value, "Table1_Group2")=FALSE) and Fields!ClosingEntry.Value) or 
Fields!EntryNo_GLEntry.Value&lt;=0 or 
((not Fields!PrintReversedEntries.Value)and(Fields!Reversed_GLEntry.Value)) or 
(Fields!PrintOnlyCorrections.Value and(not ((Fields!DebitAmount_GLEntry.Value&lt;0)or(Fields!CreditAmount_GLEntry.Value&lt;0)))),TRUE,FALSE)</Hidden>
                              </Visibility>
                            </TablixMember>
                          </TablixMembers>
                          <DataElementName>Detail_Collection</DataElementName>
                          <DataElementOutput>Output</DataElementOutput>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF((CountDistinct(Fields!ClosingEntry.Value)=1) and (First(Fields!ClosingEntry.Value)) and
(not Fields!PrintClosingEntries.Value),TRUE,FALSE)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF((CountDistinct(Fields!ClosingEntry.Value)=1) and (First(Fields!ClosingEntry.Value)) and
(not Fields!PrintClosingEntries.Value),TRUE,FALSE)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                        </TablixMember>
                      </TablixMembers>
                      <Visibility>
                        <Hidden>=IIF((First(Fields!StartBalance.Value)=0) and (First(Fields!EntryNo_GLEntry.Value) = 0),TRUE,FALSE)</Hidden>
                      </Visibility>
                    </TablixMember>
                  </TablixMembers>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <RepeatColumnHeaders>true</RepeatColumnHeaders>
            <RepeatRowHeaders>true</RepeatRowHeaders>
            <DataSetName>DataSet_Result</DataSetName>
            <PageBreak>
              <BreakLocation>End</BreakLocation>
            </PageBreak>
            <Top>1.44825cm</Top>
            <Height>2.82222cm</Height>
            <Width>18.07063cm</Width>
            <Style />
          </Tablix>
          <Textbox Name="GLAccountTABLECAPTIONGLFilter">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!GLAccTableCaption.Value)</Value>
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
            <Top>30pt</Top>
            <Height>11pt</Height>
            <Width>18.07063cm</Width>
            <ZIndex>1</ZIndex>
            <Visibility>
              <Hidden>=IIF((First(Fields!GLFilter.Value)="") or
(First(Fields!PrintOnlyCorrections.Value) and (not ((Fields!DebitAmount_GLEntry.Value&lt;0)or(Fields!CreditAmount_GLEntry.Value&lt;0)))),TRUE,FALSE)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
              <PaddingLeft>2pt</PaddingLeft>
            </Style>
          </Textbox>
          <Tablix Name="tableCaptionData">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>18.15cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox45">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!BalanceCaption.Value)</Value>
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
                          <rd:DefaultName>textbox45</rd:DefaultName>
                          <ZIndex>2</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
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
                        <Textbox Name="textbox42">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!PeriodCaption.Value)</Value>
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
                          <rd:DefaultName>textbox42</rd:DefaultName>
                          <ZIndex>1</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
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
                        <Textbox Name="textbox27">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!OnlyCorrectionsCaption.Value</Value>
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
                          <rd:DefaultName>textbox27</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                  <Visibility>
                    <Hidden>=IIF(Fields!ExcludeBalanceOnly.Value,TRUE,FALSE)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF(Fields!PrintClosingEntries.Value,FALSE,TRUE)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF(Fields!PrintOnlyCorrections.Value,FALSE,TRUE)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <Height>1.05834cm</Height>
            <Width>18.15cm</Width>
            <ZIndex>2</ZIndex>
            <Visibility>
              <Hidden>=IIF(CountRows()=0,TRUE,FALSE)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>4.27048cm</Height>
        <Style />
      </Body>
      <Width>18.15008cm</Width>
      <Page>
        <PageHeader>
          <Height>2.14312cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="DetailTrialBalanceCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!DetailTrialBalCaption.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>14pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Height>20pt</Height>
              <Width>13.87063cm</Width>
              <Style>
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
                        <FontWeight>Normal</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>30pt</Top>
              <Height>11pt</Height>
              <Width>18.15cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="STRSUBSTNOText000GLDateFilter1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!PeriodGLDtFilter.Value,"DataSet_Result")</Value>
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
              <Top>20pt</Top>
              <Height>11pt</Height>
              <Width>13.87063cm</Width>
              <ZIndex>2</ZIndex>
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
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Format>dd-MM-yyyy</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>13.87063cm</Left>
              <Height>11pt</Height>
              <Width>4.27936cm</Width>
              <ZIndex>3</ZIndex>
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
              <Left>13.87063cm</Left>
              <Height>11pt</Height>
              <Width>4.27937cm</Width>
              <ZIndex>4</ZIndex>
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
                      <Value>=First(Fields!PageCaption.Value,"DataSet_Result") &amp; " " &amp; Globals!PageNumber</Value>
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
              <Top>10pt</Top>
              <Left>13.87063cm</Left>
              <Height>11pt</Height>
              <Width>4.27937cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
          <Style />
        </PageHeader>
        <PageHeight>27.9cm</PageHeight>
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
  <ReportParameters>
    <ReportParameter Name="VATAmount_GLEntryCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>VATAmount_GLEntryCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>VATAmount_GLEntryCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="ExtDocNo_GLEntryCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>ExtDocNo_GLEntryCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>ExtDocNo_GLEntryCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="PostingDateCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>PostingDateCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>PostingDateCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="DocNoCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>DocNoCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>DocNoCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="DescCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>DescCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>DescCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="VATAmtCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>VATAmtCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>VATAmtCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="EntryNoCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>EntryNoCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>EntryNoCaption</Prompt>
    </ReportParameter>
  </ReportParameters>
  <ReportParametersLayout>
    <GridLayoutDefinition>
      <NumberOfColumns>1</NumberOfColumns>
      <NumberOfRows>7</NumberOfRows>
      <CellDefinitions>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>0</RowIndex>
          <ParameterName>VATAmount_GLEntryCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>1</RowIndex>
          <ParameterName>ExtDocNo_GLEntryCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>2</RowIndex>
          <ParameterName>PostingDateCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>3</RowIndex>
          <ParameterName>DocNoCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>4</RowIndex>
          <ParameterName>DescCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>5</RowIndex>
          <ParameterName>VATAmtCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>6</RowIndex>
          <ParameterName>EntryNoCaption</ParameterName>
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
  <rd:ReportID>62e8f68c-8a67-4807-9608-4433fc5e1619</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

