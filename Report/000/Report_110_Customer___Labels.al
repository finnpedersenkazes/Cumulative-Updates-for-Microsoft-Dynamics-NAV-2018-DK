OBJECT Report 110 Customer - Labels
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitor - etiketter;
               ENU=Customer - Labels];
    OnPreReport=BEGIN
                  GroupNo := 1;
                  RecPerPageNum := 7;
                END;

  }
  DATASET
  {
    { 6836;    ;DataItem;                    ;
               DataItemTable=Table18;
               OnPreDataItem=BEGIN
                               CASE LabelFormat OF
                                 LabelFormat::"36 x 70 mm (3 columns)",LabelFormat::"37 x 70 mm (3 columns)":
                                   NoOfColumns := 3;
                                 LabelFormat::"36 x 105 mm (2 columns)",LabelFormat::"37 x 105 mm (2 columns)":
                                   NoOfColumns := 2;
                               END;
                               NoOfRecords := COUNT;
                               RecordNo := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  RecordNo := RecordNo + 1;
                                  ColumnNo := ColumnNo + 1;
                                  FormatAddr.Customer(CustAddr[ColumnNo],Customer);
                                  IF RecordNo = NoOfRecords THEN BEGIN
                                    FOR i := ColumnNo + 1 TO NoOfColumns DO
                                      CLEAR(CustAddr[i]);
                                    ColumnNo := 0;
                                  END ELSE BEGIN
                                    IF ColumnNo = NoOfColumns THEN
                                      ColumnNo := 0;
                                  END;

                                  IF ColumnNo = 0 THEN BEGIN
                                    IF Counter = RecPerPageNum THEN BEGIN
                                      GroupNo := GroupNo + 1;
                                      Counter := 0;
                                    END;
                                    Counter := Counter + 1;
                                  END;
                                END;

               ReqFilterFields=No.,Name }

    { 1   ;1   ;Column  ;CustAddr_1__1_      ;
               SourceExpr=CustAddr[1][1] }

    { 2   ;1   ;Column  ;CustAddr_1__2_      ;
               SourceExpr=CustAddr[1][2] }

    { 3   ;1   ;Column  ;CustAddr_1__3_      ;
               SourceExpr=CustAddr[1][3] }

    { 4   ;1   ;Column  ;CustAddr_1__4_      ;
               SourceExpr=CustAddr[1][4] }

    { 5   ;1   ;Column  ;CustAddr_1__5_      ;
               SourceExpr=CustAddr[1][5] }

    { 6   ;1   ;Column  ;CustAddr_1__6_      ;
               SourceExpr=CustAddr[1][6] }

    { 7   ;1   ;Column  ;CustAddr_2__1_      ;
               SourceExpr=CustAddr[2][1] }

    { 8   ;1   ;Column  ;CustAddr_2__2_      ;
               SourceExpr=CustAddr[2][2] }

    { 9   ;1   ;Column  ;CustAddr_2__3_      ;
               SourceExpr=CustAddr[2][3] }

    { 10  ;1   ;Column  ;CustAddr_2__4_      ;
               SourceExpr=CustAddr[2][4] }

    { 11  ;1   ;Column  ;CustAddr_2__5_      ;
               SourceExpr=CustAddr[2][5] }

    { 12  ;1   ;Column  ;CustAddr_2__6_      ;
               SourceExpr=CustAddr[2][6] }

    { 13  ;1   ;Column  ;CustAddr_3__1_      ;
               SourceExpr=CustAddr[3][1] }

    { 14  ;1   ;Column  ;CustAddr_3__2_      ;
               SourceExpr=CustAddr[3][2] }

    { 15  ;1   ;Column  ;CustAddr_3__3_      ;
               SourceExpr=CustAddr[3][3] }

    { 16  ;1   ;Column  ;CustAddr_3__4_      ;
               SourceExpr=CustAddr[3][4] }

    { 17  ;1   ;Column  ;CustAddr_3__5_      ;
               SourceExpr=CustAddr[3][5] }

    { 18  ;1   ;Column  ;CustAddr_3__6_      ;
               SourceExpr=CustAddr[3][6] }

    { 61  ;1   ;Column  ;CustAddr_1__7_      ;
               SourceExpr=CustAddr[1][7] }

    { 62  ;1   ;Column  ;CustAddr_1__8_      ;
               SourceExpr=CustAddr[1][8] }

    { 63  ;1   ;Column  ;CustAddr_2__7_      ;
               SourceExpr=CustAddr[2][7] }

    { 64  ;1   ;Column  ;CustAddr_2__8_      ;
               SourceExpr=CustAddr[2][8] }

    { 65  ;1   ;Column  ;CustAddr_3__7_      ;
               SourceExpr=CustAddr[3][7] }

    { 66  ;1   ;Column  ;CustAddr_3__8_      ;
               SourceExpr=CustAddr[3][8] }

    { 81  ;1   ;Column  ;ShowBody1           ;
               SourceExpr=(ColumnNo = 0) AND (LabelFormat = LabelFormat::"36 x 70 mm (3 columns)") }

    { 85  ;1   ;Column  ;GroupNo1            ;
               SourceExpr=GroupNo }

    { 82  ;1   ;Column  ;ShowBody2           ;
               SourceExpr=(ColumnNo = 0) AND (LabelFormat = LabelFormat::"37 x 70 mm (3 columns)") }

    { 83  ;1   ;Column  ;ShowBody3           ;
               SourceExpr=(ColumnNo = 0) AND (LabelFormat = LabelFormat::"36 x 105 mm (2 columns)") }

    { 84  ;1   ;Column  ;ShowBody4           ;
               SourceExpr=(ColumnNo = 0) AND (LabelFormat = LabelFormat::"37 x 105 mm (2 columns)") }

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
                  CaptionML=[DAN=Format;
                             ENU=Format];
                  ToolTipML=[DAN=Angiver navnets format.;
                             ENU=Specifies the format of the label.];
                  OptionCaptionML=[DAN=36 x 70 mm (3 kolonner),37 x 70 mm (3 kolonner),36 x 105 mm (2 kolonner),37 x 105 mm (2 kolonner);
                                   ENU=36 x 70 mm (3 columns),37 x 70 mm (3 columns),36 x 105 mm (2 columns),37 x 105 mm (2 columns)];
                  ApplicationArea=#Suite;
                  SourceExpr=LabelFormat }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      FormatAddr@1007 : Codeunit 365;
      LabelFormat@1000 : '36 x 70 mm (3 columns),37 x 70 mm (3 columns),36 x 105 mm (2 columns),37 x 105 mm (2 columns)';
      CustAddr@1001 : ARRAY [3,8] OF Text[50];
      NoOfRecords@1002 : Integer;
      RecordNo@1003 : Integer;
      NoOfColumns@1004 : Integer;
      ColumnNo@1005 : Integer;
      i@1006 : Integer;
      GroupNo@1008 : Integer;
      Counter@1009 : Integer;
      RecPerPageNum@1010 : Integer;

    PROCEDURE InitializeRequest@1(SetLabelFormat@1000 : Option);
    BEGIN
      LabelFormat := SetLabelFormat;
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
      <rd:DataSourceID>fb4f0fd2-80fd-417a-9b4b-e56687f17ce8</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="CustAddr_1__1_">
          <DataField>CustAddr_1__1_</DataField>
        </Field>
        <Field Name="CustAddr_1__2_">
          <DataField>CustAddr_1__2_</DataField>
        </Field>
        <Field Name="CustAddr_1__3_">
          <DataField>CustAddr_1__3_</DataField>
        </Field>
        <Field Name="CustAddr_1__4_">
          <DataField>CustAddr_1__4_</DataField>
        </Field>
        <Field Name="CustAddr_1__5_">
          <DataField>CustAddr_1__5_</DataField>
        </Field>
        <Field Name="CustAddr_1__6_">
          <DataField>CustAddr_1__6_</DataField>
        </Field>
        <Field Name="CustAddr_2__1_">
          <DataField>CustAddr_2__1_</DataField>
        </Field>
        <Field Name="CustAddr_2__2_">
          <DataField>CustAddr_2__2_</DataField>
        </Field>
        <Field Name="CustAddr_2__3_">
          <DataField>CustAddr_2__3_</DataField>
        </Field>
        <Field Name="CustAddr_2__4_">
          <DataField>CustAddr_2__4_</DataField>
        </Field>
        <Field Name="CustAddr_2__5_">
          <DataField>CustAddr_2__5_</DataField>
        </Field>
        <Field Name="CustAddr_2__6_">
          <DataField>CustAddr_2__6_</DataField>
        </Field>
        <Field Name="CustAddr_3__1_">
          <DataField>CustAddr_3__1_</DataField>
        </Field>
        <Field Name="CustAddr_3__2_">
          <DataField>CustAddr_3__2_</DataField>
        </Field>
        <Field Name="CustAddr_3__3_">
          <DataField>CustAddr_3__3_</DataField>
        </Field>
        <Field Name="CustAddr_3__4_">
          <DataField>CustAddr_3__4_</DataField>
        </Field>
        <Field Name="CustAddr_3__5_">
          <DataField>CustAddr_3__5_</DataField>
        </Field>
        <Field Name="CustAddr_3__6_">
          <DataField>CustAddr_3__6_</DataField>
        </Field>
        <Field Name="CustAddr_1__7_">
          <DataField>CustAddr_1__7_</DataField>
        </Field>
        <Field Name="CustAddr_1__8_">
          <DataField>CustAddr_1__8_</DataField>
        </Field>
        <Field Name="CustAddr_2__7_">
          <DataField>CustAddr_2__7_</DataField>
        </Field>
        <Field Name="CustAddr_2__8_">
          <DataField>CustAddr_2__8_</DataField>
        </Field>
        <Field Name="CustAddr_3__7_">
          <DataField>CustAddr_3__7_</DataField>
        </Field>
        <Field Name="CustAddr_3__8_">
          <DataField>CustAddr_3__8_</DataField>
        </Field>
        <Field Name="ShowBody1">
          <DataField>ShowBody1</DataField>
        </Field>
        <Field Name="GroupNo1">
          <DataField>GroupNo1</DataField>
        </Field>
        <Field Name="ShowBody2">
          <DataField>ShowBody2</DataField>
        </Field>
        <Field Name="ShowBody3">
          <DataField>ShowBody3</DataField>
        </Field>
        <Field Name="ShowBody4">
          <DataField>ShowBody4</DataField>
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
                  <Width>6.15cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>3.07cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>3.07cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>6.15cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox11">
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox11</rd:DefaultName>
                          <ZIndex>95</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.25cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox12">
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox12</rd:DefaultName>
                          <ZIndex>94</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.25cm</PaddingLeft>
                            <PaddingRight>0.15cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox13">
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox13</rd:DefaultName>
                          <ZIndex>93</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.25cm</PaddingLeft>
                            <PaddingRight>0.15cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value />
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox14</rd:DefaultName>
                          <ZIndex>92</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.025cm</PaddingLeft>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__1_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__1_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>91</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__1_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__1_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>90</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__1_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__1_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>89</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__2_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__2_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>88</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__2_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__2_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>87</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__2_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__2_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>86</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__3_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__3_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>85</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__3_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__3_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>84</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__3_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__3_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>83</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__4_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>82</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__4_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>81</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__4_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>80</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__5_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__5_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>79</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__5_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__5_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>78</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__5_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__5_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>77</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__6_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__6_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>76</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__6_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__6_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>75</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__6_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__6_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>74</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__7_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__7_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>73</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__7_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__7_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>72</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__7_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__7_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>71</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__8_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__8_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>70</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__8_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__8_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>69</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__8_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__8_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>68</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox10">
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox10</rd:DefaultName>
                          <ZIndex>67</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.25cm</PaddingRight>
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
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox15</rd:DefaultName>
                          <ZIndex>66</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.25cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox20</rd:DefaultName>
                          <ZIndex>65</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.25cm</PaddingLeft>
                            <PaddingRight>0.15cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value />
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox22</rd:DefaultName>
                          <ZIndex>64</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.025cm</PaddingLeft>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__1__Control19">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__1_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>63</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__1__Control25">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__1_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>62</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__1__Control31">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__1_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>61</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__2__Control20">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__2_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>60</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__2__Control26">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__2_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>59</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__2__Control32">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__2_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>58</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__3__Control21">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__3_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>57</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__3__Control27">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__3_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>56</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__3__Control33">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__3_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>55</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__4__Control22">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>54</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__4__Control28">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>53</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__4__Control34">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>52</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__5__Control23">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__5_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>51</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__5__Control29">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__5_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>50</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__5__Control35">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__5_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>49</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__6__Control24">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__6_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>48</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__6__Control30">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__6_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>47</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__6__Control36">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__6_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>46</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__7__Control67">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__7_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>45</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__7__Control69">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__7_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>44</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__7__Control71">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__7_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>43</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__8__Control68">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__8_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>42</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__8__Control70">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__8_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>41</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_3__8__Control72">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_3__8_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>40</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
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
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox2</rd:DefaultName>
                          <ZIndex>39</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.25cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox26</rd:DefaultName>
                          <ZIndex>38</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.25cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                    <FontSize>7pt</FontSize>
                                    <Color>#ffff00</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox3</rd:DefaultName>
                          <ZIndex>37</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.25cm</PaddingLeft>
                            <PaddingRight>0.15cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox5</rd:DefaultName>
                          <ZIndex>36</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__1__Control37">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__1_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>35</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__1__Control43">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__1_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>34</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__2__Control38">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__2_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>33</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__2__Control44">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__2_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>32</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__3__Control39">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__3_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>31</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__3__Control45">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__3_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>30</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__4__Control40">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>29</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__4__Control46">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>28</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__5__Control41">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__5_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>27</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__5__Control47">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__5_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>26</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__6__Control42">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__6_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>25</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__6__Control48">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__6_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>24</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__7__Control73">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__7_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>23</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__7__Control75">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__7_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>22</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__8__Control74">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__8_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>21</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__8__Control76">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__8_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>20</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox6</rd:DefaultName>
                          <ZIndex>19</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.25cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox35</rd:DefaultName>
                          <ZIndex>18</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.25cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                    <FontSize>7pt</FontSize>
                                    <Color>#ffff00</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox7</rd:DefaultName>
                          <ZIndex>17</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.25cm</PaddingLeft>
                            <PaddingRight>0.15cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>16</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingRight>0.025cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__1__Control49">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__1_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>15</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__1__Control55">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__1_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>14</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__2__Control50">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__2_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>13</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__2__Control56">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__2_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>12</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__3__Control51">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__3_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>11</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__3__Control57">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__3_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>10</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__4__Control52">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>9</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__4__Control58">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__4_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>8</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__5__Control53">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__5_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>7</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__5__Control59">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__5_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>6</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__6__Control54">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__6_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>5</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__6__Control60">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__6_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>4</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__7__Control77">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__7_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>3</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__7__Control79">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__7_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>2</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_1__8__Control78">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_1__8_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>1</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAddr_2__8__Control80">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAddr_2__8_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>1pt</PaddingTop>
                            <PaddingBottom>1pt</PaddingBottom>
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
                  <Group Name="Table1_Group1">
                    <GroupExpressions>
                      <GroupExpression>=Fields!GroupNo1.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>End</BreakLocation>
                    </PageBreak>
                  </Group>
                  <TablixMembers>
                    <TablixMember>
                      <Group Name="Table1_Details_Group">
                        <DataElementName>Detail</DataElementName>
                      </Group>
                      <TablixMembers>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody1.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody1.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody1.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody1.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody1.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody1.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody1.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody1.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody1.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody2.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody2.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody2.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody2.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody2.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody2.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody2.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody2.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody2.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody3.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody3.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody3.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody3.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody3.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody3.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody3.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody3.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody3.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody4.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody4.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody4.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody4.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody4.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody4.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody4.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody4.Value=true,false,true)</Hidden>
                          </Visibility>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!ShowBody4.Value=true,false,true)</Hidden>
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
            <DataSetName>DataSet_Result</DataSetName>
            <Width>18.44cm</Width>
          </Tablix>
        </ReportItems>
        <Height>15.228cm</Height>
      </Body>
      <Width>18.5cm</Width>
      <Page>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.5cm</LeftMargin>
        <TopMargin>2cm</TopMargin>
        <BottomMargin>2cm</BottomMargin>
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
</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Invalid</rd:ReportUnitType>
  <rd:ReportID>5b8511db-dd76-4069-affb-627518def95a</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

