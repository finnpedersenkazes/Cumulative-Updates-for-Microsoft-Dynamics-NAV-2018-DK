OBJECT Report 99000763 Prod. Order - List
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Prod.ordre - oversigt;
               ENU=Prod. Order - List];
  }
  DATASET
  {
    { 4824;    ;DataItem;                    ;
               DataItemTable=Table5405;
               DataItemTableView=SORTING(Status,No.);
               OnPreDataItem=BEGIN
                               ProdOrderFilter := GETFILTERS;
                             END;

               ReqFilterFields=No.,Status,Source No. }

    { 2   ;1   ;Column  ;FORMAT_TODAY_0_4_   ;
               SourceExpr=FORMAT(TODAY,0,4) }

    { 3   ;1   ;Column  ;COMPANYNAME         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 4   ;1   ;Column  ;CurrReport_PAGENO   ;
               SourceExpr=CurrReport.PAGENO }

    { 7   ;1   ;Column  ;Production_Order__TABLECAPTION_________ProdOrderFilter;
               SourceExpr=TABLECAPTION + ':' + ProdOrderFilter }

    { 1000000000;1;Column;ProdOrderFilter    ;
               SourceExpr=ProdOrderFilter }

    { 11  ;1   ;Column  ;Production_Order__No__;
               SourceExpr="No." }

    { 14  ;1   ;Column  ;Production_Order_Description;
               SourceExpr=Description }

    { 17  ;1   ;Column  ;Production_Order__Source_No__;
               SourceExpr="Source No." }

    { 20  ;1   ;Column  ;Production_Order__Routing_No__;
               SourceExpr="Routing No." }

    { 23  ;1   ;Column  ;Production_Order__Starting_Date_;
               SourceExpr=FORMAT("Starting Date") }

    { 26  ;1   ;Column  ;Production_Order__Ending_Date_;
               SourceExpr=FORMAT("Ending Date") }

    { 29  ;1   ;Column  ;Production_Order__Due_Date_;
               SourceExpr=FORMAT("Due Date") }

    { 32  ;1   ;Column  ;Production_Order_Status;
               SourceExpr=Status }

    { 41  ;1   ;Column  ;Production_Order_Quantity;
               SourceExpr=Quantity }

    { 8   ;1   ;Column  ;Production_Order_Status_Control8;
               SourceExpr=Status }

    { 1   ;1   ;Column  ;Prod__Order___ListCaption;
               SourceExpr=Prod__Order___ListCaptionLbl }

    { 5   ;1   ;Column  ;CurrReport_PAGENOCaption;
               SourceExpr=CurrReport_PAGENOCaptionLbl }

    { 12  ;1   ;Column  ;Production_Order__No__Caption;
               SourceExpr=FIELDCAPTION("No.") }

    { 15  ;1   ;Column  ;Production_Order_DescriptionCaption;
               SourceExpr=FIELDCAPTION(Description) }

    { 18  ;1   ;Column  ;Production_Order__Source_No__Caption;
               SourceExpr=FIELDCAPTION("Source No.") }

    { 21  ;1   ;Column  ;Production_Order__Routing_No__Caption;
               SourceExpr=FIELDCAPTION("Routing No.") }

    { 24  ;1   ;Column  ;Production_Order__Starting_Date_Caption;
               SourceExpr=Production_Order__Starting_Date_CaptionLbl }

    { 27  ;1   ;Column  ;Production_Order__Ending_Date_Caption;
               SourceExpr=Production_Order__Ending_Date_CaptionLbl }

    { 30  ;1   ;Column  ;Production_Order__Due_Date_Caption;
               SourceExpr=Production_Order__Due_Date_CaptionLbl }

    { 33  ;1   ;Column  ;Production_Order_StatusCaption;
               SourceExpr=FIELDCAPTION(Status) }

    { 42  ;1   ;Column  ;Production_Order_QuantityCaption;
               SourceExpr=FIELDCAPTION(Quantity) }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
    }
    CONTROLS
    {
    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      ProdOrderFilter@1000 : Text;
      Prod__Order___ListCaptionLbl@3822 : TextConst 'DAN=Prod.ordre - oversigt;ENU=Prod. Order - List';
      CurrReport_PAGENOCaptionLbl@8565 : TextConst 'DAN=Side;ENU=Page';
      Production_Order__Starting_Date_CaptionLbl@5169 : TextConst 'DAN=Startdato;ENU=Starting Date';
      Production_Order__Ending_Date_CaptionLbl@7897 : TextConst 'DAN=Slutdato;ENU=Ending Date';
      Production_Order__Due_Date_CaptionLbl@3062 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';

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
      <rd:DataSourceID>b99c6d7a-a391-48f2-a58e-8d8d14118695</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="FORMAT_TODAY_0_4_">
          <DataField>FORMAT_TODAY_0_4_</DataField>
        </Field>
        <Field Name="COMPANYNAME">
          <DataField>COMPANYNAME</DataField>
        </Field>
        <Field Name="CurrReport_PAGENO">
          <DataField>CurrReport_PAGENO</DataField>
        </Field>
        <Field Name="Production_Order__TABLECAPTION_________ProdOrderFilter">
          <DataField>Production_Order__TABLECAPTION_________ProdOrderFilter</DataField>
        </Field>
        <Field Name="ProdOrderFilter">
          <DataField>ProdOrderFilter</DataField>
        </Field>
        <Field Name="Production_Order__No__">
          <DataField>Production_Order__No__</DataField>
        </Field>
        <Field Name="Production_Order_Description">
          <DataField>Production_Order_Description</DataField>
        </Field>
        <Field Name="Production_Order__Source_No__">
          <DataField>Production_Order__Source_No__</DataField>
        </Field>
        <Field Name="Production_Order__Routing_No__">
          <DataField>Production_Order__Routing_No__</DataField>
        </Field>
        <Field Name="Production_Order__Starting_Date_">
          <DataField>Production_Order__Starting_Date_</DataField>
        </Field>
        <Field Name="Production_Order__Ending_Date_">
          <DataField>Production_Order__Ending_Date_</DataField>
        </Field>
        <Field Name="Production_Order__Due_Date_">
          <DataField>Production_Order__Due_Date_</DataField>
        </Field>
        <Field Name="Production_Order_Status">
          <DataField>Production_Order_Status</DataField>
        </Field>
        <Field Name="Production_Order_Quantity">
          <DataField>Production_Order_Quantity</DataField>
        </Field>
        <Field Name="Production_Order_QuantityFormat">
          <DataField>Production_Order_QuantityFormat</DataField>
        </Field>
        <Field Name="Production_Order_Status_Control8">
          <DataField>Production_Order_Status_Control8</DataField>
        </Field>
        <Field Name="Prod__Order___ListCaption">
          <DataField>Prod__Order___ListCaption</DataField>
        </Field>
        <Field Name="CurrReport_PAGENOCaption">
          <DataField>CurrReport_PAGENOCaption</DataField>
        </Field>
        <Field Name="Production_Order__No__Caption">
          <DataField>Production_Order__No__Caption</DataField>
        </Field>
        <Field Name="Production_Order_DescriptionCaption">
          <DataField>Production_Order_DescriptionCaption</DataField>
        </Field>
        <Field Name="Production_Order__Source_No__Caption">
          <DataField>Production_Order__Source_No__Caption</DataField>
        </Field>
        <Field Name="Production_Order__Routing_No__Caption">
          <DataField>Production_Order__Routing_No__Caption</DataField>
        </Field>
        <Field Name="Production_Order__Starting_Date_Caption">
          <DataField>Production_Order__Starting_Date_Caption</DataField>
        </Field>
        <Field Name="Production_Order__Ending_Date_Caption">
          <DataField>Production_Order__Ending_Date_Caption</DataField>
        </Field>
        <Field Name="Production_Order__Due_Date_Caption">
          <DataField>Production_Order__Due_Date_Caption</DataField>
        </Field>
        <Field Name="Production_Order_StatusCaption">
          <DataField>Production_Order_StatusCaption</DataField>
        </Field>
        <Field Name="Production_Order_QuantityCaption">
          <DataField>Production_Order_QuantityCaption</DataField>
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
                  <Width>1.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.65cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>4.65cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.65cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.65cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.65cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.65cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.65cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.6cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.2cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order__TABLECAPTION_________ProdOrderFilter">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Production_Order__TABLECAPTION_________ProdOrderFilter.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>74</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>9</ColSpan>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="ProdOrderFilter">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!ProdOrderFilter.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>73</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox16</rd:DefaultName>
                          <ZIndex>72</ZIndex>
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
                        <Textbox Name="textbox17">
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
                          <rd:DefaultName>textbox17</rd:DefaultName>
                          <ZIndex>71</ZIndex>
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
                        <Textbox Name="textbox18">
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
                          <rd:DefaultName>textbox18</rd:DefaultName>
                          <ZIndex>70</ZIndex>
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
                        <Textbox Name="textbox5">
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox5</rd:DefaultName>
                          <ZIndex>69</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox6</rd:DefaultName>
                          <ZIndex>68</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox7</rd:DefaultName>
                          <ZIndex>67</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox8</rd:DefaultName>
                          <ZIndex>66</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox9</rd:DefaultName>
                          <ZIndex>65</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox10</rd:DefaultName>
                          <ZIndex>64</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox11</rd:DefaultName>
                          <ZIndex>63</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox12</rd:DefaultName>
                          <ZIndex>62</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox14</rd:DefaultName>
                          <ZIndex>60</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                                    <FontSize>7pt</FontSize>
                                    <Color>#ffff00</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox15</rd:DefaultName>
                          <ZIndex>59</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox19</rd:DefaultName>
                          <ZIndex>58</ZIndex>
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox20</rd:DefaultName>
                          <ZIndex>57</ZIndex>
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
                        <Textbox Name="textbox21">
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
                          <rd:DefaultName>textbox21</rd:DefaultName>
                          <ZIndex>56</ZIndex>
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
                  <Height>0.55cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order_Status_Control8Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Production_Order_StatusCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>55</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order__No__Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Production_Order__No__Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>54</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order_DescriptionCaption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Production_Order_DescriptionCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>53</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order__Source_No__Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Production_Order__Source_No__Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>52</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order__Routing_No__Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Production_Order__Routing_No__Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>51</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order__Starting_Date_Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Production_Order__Starting_Date_Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>50</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order__Ending_Date_Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Production_Order__Ending_Date_Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>49</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order__Due_Date_Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Production_Order__Due_Date_Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>48</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order_QuantityCaption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Production_Order_QuantityCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>46</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox1">
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
                          <ZIndex>45</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox2</rd:DefaultName>
                          <ZIndex>44</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox3</rd:DefaultName>
                          <ZIndex>43</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox4</rd:DefaultName>
                          <ZIndex>42</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
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
                        <Textbox Name="textbox22">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox22</rd:DefaultName>
                          <ZIndex>41</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
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
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox23</rd:DefaultName>
                          <ZIndex>40</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="textbox24">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox24</rd:DefaultName>
                          <ZIndex>39</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="textbox25">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox25</rd:DefaultName>
                          <ZIndex>38</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="textbox26">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox26</rd:DefaultName>
                          <ZIndex>37</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="textbox27">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox27</rd:DefaultName>
                          <ZIndex>36</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="textbox28">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox28</rd:DefaultName>
                          <ZIndex>35</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="textbox29">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox29</rd:DefaultName>
                          <ZIndex>34</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="textbox31">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox31</rd:DefaultName>
                          <ZIndex>32</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox32</rd:DefaultName>
                          <ZIndex>31</ZIndex>
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
                        <Textbox Name="textbox33">
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
                          <rd:DefaultName>textbox33</rd:DefaultName>
                          <ZIndex>30</ZIndex>
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
                        <Textbox Name="textbox34">
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
                          <rd:DefaultName>textbox34</rd:DefaultName>
                          <ZIndex>29</ZIndex>
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox35</rd:DefaultName>
                          <ZIndex>28</ZIndex>
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
                        <Textbox Name="Production_Order_Status_Control8">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Production_Order_Status.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>27</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order__No__">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Production_Order__No__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>26</ZIndex>
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
                        <Textbox Name="Production_Order_Description">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Production_Order_Description.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>25</ZIndex>
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
                        <Textbox Name="Production_Order__Source_No__">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Production_Order__Source_No__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
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
                        <Textbox Name="Production_Order__Routing_No__">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Production_Order__Routing_No__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
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
                        <Textbox Name="Production_Order__Starting_Date_">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Production_Order__Starting_Date_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Production_Order__Ending_Date_">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Production_Order__Ending_Date_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>21</ZIndex>
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
                        <Textbox Name="Production_Order__Due_Date_">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Production_Order__Due_Date_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>20</ZIndex>
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
                        <Textbox Name="Production_Order_Quantity">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Production_Order_Quantity.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!Production_Order_QuantityFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>18</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="COMPANYNAME">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!COMPANYNAME.Value</Value>
                                  <Style>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>17</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
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
                        <Textbox Name="Prod__Order___ListCaption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Prod__Order___ListCaption.Value</Value>
                                  <Style>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>16</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
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
                        <Textbox Name="CurrReport_PAGENOCaption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrReport_PAGENOCaption.Value</Value>
                                  <Style>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>15</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
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
                        <Textbox Name="FORMAT_TODAY_0_4_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!FORMAT_TODAY_0_4_.Value</Value>
                                  <Style>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>14</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
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
                        <Textbox Name="textbox36">
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox36</rd:DefaultName>
                          <ZIndex>13</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox37</rd:DefaultName>
                          <ZIndex>12</ZIndex>
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
                        <Textbox Name="textbox38">
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox38</rd:DefaultName>
                          <ZIndex>11</ZIndex>
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
                        <Textbox Name="textbox39">
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox39</rd:DefaultName>
                          <ZIndex>10</ZIndex>
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
                        <Textbox Name="textbox40">
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox40</rd:DefaultName>
                          <ZIndex>9</ZIndex>
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
                        <Textbox Name="textbox41">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox41</rd:DefaultName>
                          <ZIndex>8</ZIndex>
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
                        <Textbox Name="textbox42">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox42</rd:DefaultName>
                          <ZIndex>7</ZIndex>
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
                        <Textbox Name="textbox43">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox43</rd:DefaultName>
                          <ZIndex>6</ZIndex>
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
                        <Textbox Name="textbox45">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!Production_Order_QuantityFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox45</rd:DefaultName>
                          <ZIndex>4</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox46">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox46</rd:DefaultName>
                          <ZIndex>3</ZIndex>
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
                        <Textbox Name="textbox47">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox47</rd:DefaultName>
                          <ZIndex>2</ZIndex>
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
                        <Textbox Name="textbox48">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox48</rd:DefaultName>
                          <ZIndex>1</ZIndex>
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
                        <Textbox Name="textbox49">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox49</rd:DefaultName>
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
              </TablixMembers>
            </TablixColumnHierarchy>
            <TablixRowHierarchy>
              <TablixMembers>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIf(Fields!ProdOrderFilter.Value = "",True,False)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIf(Fields!ProdOrderFilter.Value = "",True,False)</Hidden>
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
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Group Name="Table1_Details_Group">
                    <DataElementName>Detail</DataElementName>
                  </Group>
                  <TablixMembers>
                    <TablixMember />
                    <TablixMember />
                  </TablixMembers>
                  <DataElementName>Detail_Collection</DataElementName>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Height>2.665cm</Height>
            <Width>18.15cm</Width>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>2.665cm</Height>
      </Body>
      <Width>18.325cm</Width>
      <Page>
        <PageHeader>
          <Height>1.692cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="CurrReport_PAGENOCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value EvaluationMode="Auto">=ReportItems!CurrReport_PAGENOCaption.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>16.95cm</Left>
              <Height>0.423cm</Height>
              <Width>0.75cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Prod__Order___ListCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value EvaluationMode="Auto">=ReportItems!Prod__Order___ListCaption.Value</Value>
                      <Style>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>1</ZIndex>
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
                      <Value EvaluationMode="Auto">=ReportItems!COMPANYNAME.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
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
                      <Value EvaluationMode="Auto">=ReportItems!FORMAT_TODAY_0_4_.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>g</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>15cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
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
                      <Value EvaluationMode="Auto">=User!UserID</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.846cm</Top>
              <Left>14.9cm</Left>
              <Height>0.423cm</Height>
              <Width>3.25cm</Width>
              <ZIndex>4</ZIndex>
              <Visibility>
                <Hidden>=IIf(ReportItems!CurrReport_PAGENOCaption.Value = "",True,False)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
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
                      <Value EvaluationMode="Auto">=Globals!PageNumber</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>17.7cm</Left>
              <Height>0.423cm</Height>
              <Width>0.45cm</Width>
              <ZIndex>5</ZIndex>
              <Visibility>
                <Hidden>=IIf(ReportItems!CurrReport_PAGENOCaption.Value = "",True,False)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
        </PageHeader>
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
  <rd:ReportID>de8436f8-8fca-4171-aca1-e0176f23daa4</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

