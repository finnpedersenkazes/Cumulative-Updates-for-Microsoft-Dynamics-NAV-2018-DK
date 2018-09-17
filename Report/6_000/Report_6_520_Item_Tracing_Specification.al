OBJECT Report 6520 Item Tracing Specification
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Specifikation af varesporing;
               ENU=Item Tracing Specification];
    OnPreReport=BEGIN
                  IF TempTrackEntry.FIND THEN
                    NoOfRecords := TempTrackEntry.COUNT
                  ELSE
                    NoOfRecords := 0;
                END;

  }
  DATASET
  {
    { 5444;    ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,NoOfRecords);
                               CLEAR(TempTrackEntry);

                               HeaderTextCreated := FALSE;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF TempTrackEntry.NEXT = 0 THEN
                                    CurrReport.SKIP;

                                  TransactionDescription := PADSTR('',TempTrackEntry.Level,'*') + FORMAT(TempTrackEntry.Description);
                                  IF NOT Item.GET(TempTrackEntry."Item No.") THEN
                                    CLEAR(Item);

                                  CLEAR(RecRef);
                                  RecRef.OPEN(DATABASE::"Item Tracing Buffer",TRUE);
                                  RecRef.GETTABLE(TempTrackEntry);

                                  x := 0;
                                  CLEAR(BodyText);
                                  FOR i := 1 TO ARRAYLEN(HeaderText) DO
                                    IF FldNo[i] <> 0 THEN BEGIN
                                      FldRef := RecRef.FIELD(FldNo[i]);
                                      x += 1;
                                      IF NOT HeaderTextCreated THEN
                                        HeaderText[x] := FldRef.CAPTION;
                                      IF (i < 9) OR
                                         ((TempTrackEntry."Source Type" = TempTrackEntry."Source Type"::Customer) AND PrintCustomer) OR
                                         ((TempTrackEntry."Source Type" = TempTrackEntry."Source Type"::Vendor) AND PrintVendor)
                                      THEN
                                        BodyText[x] := FORMAT(FldRef);
                                    END;

                                  HeaderTextCreated := TRUE;
                                END;
                                 }

    { 20  ;1   ;Column  ;FormatToday         ;
               SourceExpr=FORMAT(TODAY,0,4) }

    { 19  ;1   ;Column  ;CompanyName         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 2   ;1   ;Column  ;HeaderText1         ;
               SourceExpr=HeaderText[1] }

    { 1   ;1   ;Column  ;HeaderText2         ;
               SourceExpr=HeaderText[2] }

    { 4   ;1   ;Column  ;HeaderText3         ;
               SourceExpr=HeaderText[3] }

    { 5   ;1   ;Column  ;HeaderText4         ;
               SourceExpr=HeaderText[4] }

    { 9   ;1   ;Column  ;HeaderText5         ;
               SourceExpr=HeaderText[5] }

    { 10  ;1   ;Column  ;HeaderText6         ;
               SourceExpr=HeaderText[6] }

    { 11  ;1   ;Column  ;HeaderText7         ;
               SourceExpr=HeaderText[7] }

    { 12  ;1   ;Column  ;HeaderText8         ;
               SourceExpr=HeaderText[8] }

    { 21  ;1   ;Column  ;GlobVarX            ;
               SourceExpr=x }

    { 22  ;1   ;Column  ;TransactionDescription;
               OptionString=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output;
               SourceExpr=TransactionDescription }

    { 3   ;1   ;Column  ;BodyText1           ;
               SourceExpr=BodyText[1] }

    { 6   ;1   ;Column  ;BodyText2           ;
               SourceExpr=BodyText[2] }

    { 7   ;1   ;Column  ;BodyText3           ;
               SourceExpr=BodyText[3] }

    { 8   ;1   ;Column  ;BodyText4           ;
               SourceExpr=BodyText[4] }

    { 13  ;1   ;Column  ;BodyText5           ;
               SourceExpr=BodyText[5] }

    { 14  ;1   ;Column  ;BodyText6           ;
               SourceExpr=BodyText[6] }

    { 16  ;1   ;Column  ;BodyText8           ;
               SourceExpr=BodyText[8] }

    { 27  ;1   ;Column  ;BodyText7           ;
               SourceExpr=BodyText[7] }

    { 26  ;1   ;Column  ;TempTrackEntrySourceType;
               OptionString=" ,Customer,Vendor,Item";
               SourceExpr=TempTrackEntry."Source Type" }

    { 25  ;1   ;Column  ;TempTrackEntrySourceNo;
               SourceExpr=TempTrackEntry."Source No." }

    { 24  ;1   ;Column  ;TempTrackEntrySourceName;
               SourceExpr=TempTrackEntry."Source Name" }

    { 23  ;1   ;Column  ;SecIntBody6ShowOutput;
               SourceExpr=(PrintCustomer AND (TempTrackEntry."Source Type" = TempTrackEntry."Source Type"::Customer)) OR (PrintVendor AND (TempTrackEntry."Source Type" = TempTrackEntry."Source Type"::Vendor)) }

    { 17  ;1   ;Column  ;ItemTracingSpecificationCaption;
               SourceExpr=ItemTracingSpecificationCaptionLbl }

    { 18  ;1   ;Column  ;PageCaption         ;
               SourceExpr=PageCaptionLbl }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
      { 8   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 5   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 4   ;2   ;Group     ;
                  CaptionML=[DAN=Udskriv kontaktoplysninger;
                             ENU=Print Contact Information] }

      { 17  ;3   ;Field     ;
                  Name=Customer;
                  CaptionML=[DAN=Debitor;
                             ENU=Customer];
                  ToolTipML=[DAN=Angiver navnet p� debitoren.;
                             ENU=Specifies the name of the customer.];
                  ApplicationArea=#ItemTracking;
                  SourceExpr=PrintCustomer }

      { 11  ;3   ;Field     ;
                  Name=Vendor;
                  CaptionML=[DAN=Kreditor;
                             ENU=Vendor];
                  ToolTipML=[DAN=Angiver, om du vil udskrive kreditorernes kontaktoplysninger i rapporten.;
                             ENU=Specifies whether to print the vendors' contact information in the report.];
                  ApplicationArea=#ItemTracking;
                  SourceExpr=PrintVendor }

      { 25  ;2   ;Group     ;
                  CaptionML=[DAN=Valg af kolonne;
                             ENU=Column Selection] }

      { 3   ;3   ;Field     ;
                  CaptionML=[DAN=Nr. 1;
                             ENU=No. 1];
                  ToolTipML=[DAN=Angiver det f�rste felt med kolonnevalg, som du vil se i rapporten.;
                             ENU=Specifies the first column selection field that you would like to see in the report.];
                  ApplicationArea=#ItemTracking;
                  BlankZero=Yes;
                  SourceExpr=FldNo[1];
                  OnValidate=BEGIN
                               GetFieldValue(1,FldNo[1]);
                             END;

                  OnLookup=BEGIN
                             LookupField(1);
                           END;
                            }

      { 2   ;3   ;Field     ;
                  CaptionML=[DAN=Nr. 2;
                             ENU=No. 2];
                  ToolTipML=[DAN=Angiver det andet felt med kolonnevalg, som du vil se i rapporten.;
                             ENU=Specifies the second column selection field that you would like to see in the report.];
                  ApplicationArea=#ItemTracking;
                  BlankZero=Yes;
                  SourceExpr=FldNo[2];
                  OnValidate=BEGIN
                               GetFieldValue(2,FldNo[2]);
                             END;

                  OnLookup=BEGIN
                             LookupField(2);
                           END;
                            }

      { 7   ;3   ;Field     ;
                  CaptionML=[DAN=Nr. 3;
                             ENU=No. 3];
                  ToolTipML=[DAN=Angiver det tredje felt med kolonnevalg, som du vil se i rapporten.;
                             ENU=Specifies the third column selection field that you would like to see in the report.];
                  ApplicationArea=#ItemTracking;
                  BlankZero=Yes;
                  SourceExpr=FldNo[3];
                  OnValidate=BEGIN
                               GetFieldValue(3,FldNo[3]);
                             END;

                  OnLookup=BEGIN
                             LookupField(3);
                           END;
                            }

      { 10  ;3   ;Field     ;
                  CaptionML=[DAN=Nr. 4;
                             ENU=No. 4];
                  ToolTipML=[DAN=Angiver det fjerde felt med kolonnevalg, som du vil se i rapporten.;
                             ENU=Specifies the fourth column selection field that you would like to see in the report.];
                  ApplicationArea=#ItemTracking;
                  BlankZero=Yes;
                  SourceExpr=FldNo[4];
                  OnValidate=BEGIN
                               GetFieldValue(4,FldNo[4]);
                             END;

                  OnLookup=BEGIN
                             LookupField(4);
                           END;
                            }

      { 15  ;3   ;Field     ;
                  CaptionML=[DAN=Nr. 5;
                             ENU=No. 5];
                  ToolTipML=[DAN=Angiver det femte felt med kolonnevalg, som du vil se i rapporten.;
                             ENU=Specifies the fifth column selection field that you would like to see in the report.];
                  ApplicationArea=#ItemTracking;
                  BlankZero=Yes;
                  SourceExpr=FldNo[5];
                  OnValidate=BEGIN
                               GetFieldValue(5,FldNo[5]);
                             END;

                  OnLookup=BEGIN
                             LookupField(5);
                           END;
                            }

      { 16  ;3   ;Field     ;
                  CaptionML=[DAN=Nr. 6;
                             ENU=No. 6];
                  ToolTipML=[DAN=Angiver det sjette felt med kolonnevalg, som du vil se i rapporten.;
                             ENU=Specifies the sixth column selection field that you would like to see in the report.];
                  ApplicationArea=#ItemTracking;
                  BlankZero=Yes;
                  SourceExpr=FldNo[6];
                  OnValidate=BEGIN
                               GetFieldValue(6,FldNo[6]);
                             END;

                  OnLookup=BEGIN
                             LookupField(6);
                           END;
                            }

      { 20  ;3   ;Field     ;
                  CaptionML=[DAN=Nr. 7;
                             ENU=No. 7];
                  ToolTipML=[DAN=Angiver det syvende felt med kolonnevalg, som du vil se i rapporten.;
                             ENU=Specifies the seventh column selection field that you would like to see in the report.];
                  ApplicationArea=#ItemTracking;
                  BlankZero=Yes;
                  SourceExpr=FldNo[7];
                  OnValidate=BEGIN
                               GetFieldValue(7,FldNo[7]);
                             END;

                  OnLookup=BEGIN
                             LookupField(7);
                           END;
                            }

      { 23  ;3   ;Field     ;
                  CaptionML=[DAN=Nr. 8;
                             ENU=No. 8];
                  ToolTipML=[DAN=Angiver det ottende felt med kolonnevalg, som du vil se i rapporten.;
                             ENU=Specifies the eighth column selection field that you would like to see in the report.];
                  ApplicationArea=#ItemTracking;
                  BlankZero=Yes;
                  SourceExpr=FldNo[8];
                  OnValidate=BEGIN
                               GetFieldValue(8,FldNo[8]);
                             END;

                  OnLookup=BEGIN
                             LookupField(8);
                           END;
                            }

      { 1   ;2   ;Field     ;
                  ApplicationArea=#ItemTracking;
                  SourceExpr=FieldCaption[1];
                  Editable=FALSE;
                  ShowCaption=No }

      { 6   ;2   ;Field     ;
                  ApplicationArea=#ItemTracking;
                  SourceExpr=FieldCaption[2];
                  Editable=FALSE;
                  ShowCaption=No }

      { 9   ;2   ;Field     ;
                  ApplicationArea=#ItemTracking;
                  SourceExpr=FieldCaption[3];
                  Editable=FALSE;
                  ShowCaption=No }

      { 12  ;2   ;Field     ;
                  ApplicationArea=#ItemTracking;
                  SourceExpr=FieldCaption[4];
                  Editable=FALSE;
                  ShowCaption=No }

      { 13  ;2   ;Field     ;
                  ApplicationArea=#ItemTracking;
                  SourceExpr=FieldCaption[5];
                  Editable=FALSE;
                  ShowCaption=No }

      { 14  ;2   ;Field     ;
                  ApplicationArea=#ItemTracking;
                  SourceExpr=FieldCaption[6];
                  Editable=FALSE;
                  ShowCaption=No }

      { 19  ;2   ;Field     ;
                  ApplicationArea=#ItemTracking;
                  SourceExpr=FieldCaption[7];
                  Editable=FALSE;
                  ShowCaption=No }

      { 22  ;2   ;Field     ;
                  ApplicationArea=#ItemTracking;
                  SourceExpr=FieldCaption[8];
                  Editable=FALSE;
                  ShowCaption=No }

    }
  }
  LABELS
  {
    { 28  ;DescriptionCaption  ;CaptionML=[DAN=Beskrivelse;
                                           ENU=Description] }
    { 29  ;EmptyStringCaption  ;CaptionML=[DAN=___________________________________________________________________________________________________________________________________________________________________________;
                                           ENU=___________________________________________________________________________________________________________________________________________________________________________] }
  }
  CODE
  {
    VAR
      Item@1000000002 : Record 27;
      TempTrackEntry@1002 : TEMPORARY Record 6520;
      TypeHelper@1008 : Codeunit 10;
      RecRef@1007 : RecordRef;
      FldRef@1006 : FieldRef;
      NoOfRecords@1000 : Integer;
      TransactionDescription@1000000001 : Text[100];
      PrintCustomer@1000000000 : Boolean;
      PrintVendor@1000000003 : Boolean;
      HeaderTextCreated@1010 : Boolean;
      HeaderText@1001 : ARRAY [11] OF Text[50];
      BodyText@1003 : ARRAY [11] OF Text[50];
      FieldCaption@1015 : ARRAY [11] OF Text[50];
      FldNo@1021 : ARRAY [11] OF Integer;
      i@1004 : Integer;
      x@1005 : Integer;
      ItemTracingSpecificationCaptionLbl@9707 : TextConst 'DAN=Specifikation af varesporing;ENU=Item Tracing Specification';
      PageCaptionLbl@6215 : TextConst 'DAN=Side;ENU=Page';

    PROCEDURE TransferEntries@1000000000(VAR ItemTrackingEntry@1000000000 : Record 6520);
    BEGIN
      ItemTrackingEntry.RESET;
      IF ItemTrackingEntry.FIND('-') THEN
        REPEAT
          TempTrackEntry := ItemTrackingEntry;
          TempTrackEntry.INSERT;
        UNTIL ItemTrackingEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE LookupField@1(FieldNumber@1000 : Integer);
    VAR
      Field@1001 : Record 2000000041;
    BEGIN
      Field.SETRANGE(TableNo,DATABASE::"Item Tracing Buffer");
      Field.SETFILTER(Type,
        '%1|%2|%3|%4|%5|%6|%7|%8',
        Field.Type::Text,
        Field.Type::Date,
        Field.Type::Decimal,
        Field.Type::Boolean,
        Field.Type::Code,
        Field.Type::Option,
        Field.Type::Integer,
        Field.Type::BigInteger);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      IF PAGE.RUNMODAL(PAGE::"Table Field List",Field,Field."No.") = ACTION::LookupOK THEN
        IF FldNo[FieldNumber] <> Field."No." THEN BEGIN
          FldNo[FieldNumber] := Field."No.";
          FieldCaption[FieldNumber] := Field."Field Caption";
        END;
    END;

    LOCAL PROCEDURE GetFieldValue@2(ArrayNo@1001 : Integer;FieldNumber@1000 : Integer);
    VAR
      Field@1002 : Record 2000000041;
    BEGIN
      FieldCaption[ArrayNo] := '';
      IF FieldNumber <> 0 THEN
        IF TypeHelper.GetField(DATABASE::"Item Tracing Buffer",FieldNumber,Field) THEN
          FieldCaption[ArrayNo] := Field."Field Caption";
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
      <rd:DataSourceID>f91d2c52-6efd-40f6-8159-d966ed74e059</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="FormatToday">
          <DataField>FormatToday</DataField>
        </Field>
        <Field Name="CompanyName">
          <DataField>CompanyName</DataField>
        </Field>
        <Field Name="HeaderText1">
          <DataField>HeaderText1</DataField>
        </Field>
        <Field Name="HeaderText2">
          <DataField>HeaderText2</DataField>
        </Field>
        <Field Name="HeaderText3">
          <DataField>HeaderText3</DataField>
        </Field>
        <Field Name="HeaderText4">
          <DataField>HeaderText4</DataField>
        </Field>
        <Field Name="HeaderText5">
          <DataField>HeaderText5</DataField>
        </Field>
        <Field Name="HeaderText6">
          <DataField>HeaderText6</DataField>
        </Field>
        <Field Name="HeaderText7">
          <DataField>HeaderText7</DataField>
        </Field>
        <Field Name="HeaderText8">
          <DataField>HeaderText8</DataField>
        </Field>
        <Field Name="GlobVarX">
          <DataField>GlobVarX</DataField>
        </Field>
        <Field Name="TransactionDescription">
          <DataField>TransactionDescription</DataField>
        </Field>
        <Field Name="BodyText1">
          <DataField>BodyText1</DataField>
        </Field>
        <Field Name="BodyText2">
          <DataField>BodyText2</DataField>
        </Field>
        <Field Name="BodyText3">
          <DataField>BodyText3</DataField>
        </Field>
        <Field Name="BodyText4">
          <DataField>BodyText4</DataField>
        </Field>
        <Field Name="BodyText5">
          <DataField>BodyText5</DataField>
        </Field>
        <Field Name="BodyText6">
          <DataField>BodyText6</DataField>
        </Field>
        <Field Name="BodyText8">
          <DataField>BodyText8</DataField>
        </Field>
        <Field Name="BodyText7">
          <DataField>BodyText7</DataField>
        </Field>
        <Field Name="TempTrackEntrySourceType">
          <DataField>TempTrackEntrySourceType</DataField>
        </Field>
        <Field Name="TempTrackEntrySourceNo">
          <DataField>TempTrackEntrySourceNo</DataField>
        </Field>
        <Field Name="TempTrackEntrySourceName">
          <DataField>TempTrackEntrySourceName</DataField>
        </Field>
        <Field Name="SecIntBody6ShowOutput">
          <DataField>SecIntBody6ShowOutput</DataField>
        </Field>
        <Field Name="ItemTracingSpecificationCaption">
          <DataField>ItemTracingSpecificationCaption</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
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
                  <Width>4.275cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.8cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.6cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.6cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.8cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.8cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.6cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.6cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.8cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.50239cm</Height>
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
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox10</rd:DefaultName>
                          <ZIndex>74</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>13</ColSpan>
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
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.846cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="DescriptionCaption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DescriptionCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>57</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText1.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>56</ZIndex>
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
                        <Textbox Name="HeaderText2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText2.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>55</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText3">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText3.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>54</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText4">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText4.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
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
                        <Textbox Name="HeaderText5">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText5.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
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
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText6">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText6.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
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
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText7">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText7.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>50</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText8">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText8.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>49</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.42301cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox17">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!EmptyStringCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>44</ZIndex>
                          <Style>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>13</ColSpan>
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
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.846cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="DescriptionCaptionControl17">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DescriptionCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>43</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText1Control19">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText1.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>42</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText2Control20">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText2.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>41</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText3Control21">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText3.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>40</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText4Control22">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText4.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>39</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText5Control23">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText5.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>38</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText6Control24">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!HeaderText6.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>37</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.42301cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="EmptyStringCaptionControl18">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!EmptyStringCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>32</ZIndex>
                          <Style>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>13</ColSpan>
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
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.42301cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TransactionDescription">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TransactionDescription.Value</Value>
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
                          <ZIndex>31</ZIndex>
                          <Style>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText1.Value</Value>
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
                          <ZIndex>30</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText2.Value</Value>
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
                          <ZIndex>29</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText3">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText3.Value</Value>
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
                          <ZIndex>28</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText4">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText4.Value</Value>
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
                          <ZIndex>27</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText5">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText5.Value</Value>
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
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText6">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText6.Value</Value>
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
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                        <rd:Selected>true</rd:Selected>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText7">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText7.Value</Value>
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
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText8">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText8.Value</Value>
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
                            <PaddingLeft>0.075cm</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.42301cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox45">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TransactionDescription.Value</Value>
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
                          <ZIndex>18</ZIndex>
                          <Style>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText11">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText1.Value</Value>
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
                          <rd:DefaultName>BodyText1_1</rd:DefaultName>
                          <ZIndex>17</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText21">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText2.Value</Value>
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
                          <rd:DefaultName>BodyText2_1</rd:DefaultName>
                          <ZIndex>16</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText31">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText3.Value</Value>
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
                          <rd:DefaultName>BodyText3_1</rd:DefaultName>
                          <ZIndex>15</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText41">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText4.Value</Value>
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
                          <rd:DefaultName>BodyText4_1</rd:DefaultName>
                          <ZIndex>14</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText51">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText5.Value</Value>
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
                          <rd:DefaultName>BodyText5_1</rd:DefaultName>
                          <ZIndex>13</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="BodyText61">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BodyText6.Value</Value>
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
                          <rd:DefaultName>BodyText6_1</rd:DefaultName>
                          <ZIndex>12</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.42301cm</Height>
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
                          <ZIndex>7</ZIndex>
                          <Style>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TempTrackEntrySourceType">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TempTrackEntrySourceType.Value</Value>
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
                          <ZIndex>6</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TempTrackEntrySourceNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TempTrackEntrySourceNo.Value</Value>
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
                          <ZIndex>5</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TempTrackEntrySourceName">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TempTrackEntrySourceName.Value</Value>
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
                          <ZIndex>4</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIf(Fields!GlobVarX.Value &gt; 6,False,True)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIf(Fields!GlobVarX.Value &gt; 6,False,True)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIf(Fields!GlobVarX.Value &lt;= 6,False,True)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIf(Fields!GlobVarX.Value &lt;= 6,False,True)</Hidden>
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
                        <Hidden>=IIf(Fields!GlobVarX.Value &gt; 6,False,True)</Hidden>
                      </Visibility>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIf(Fields!GlobVarX.Value &lt;= 6,False,True)</Hidden>
                      </Visibility>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIf(Fields!SecIntBody6ShowOutput.Value,False,True)</Hidden>
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
            <Height>4.30944cm</Height>
            <Width>18.67497cm</Width>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>4.30944cm</Height>
        <Style />
      </Body>
      <Width>18.67497cm</Width>
      <Page>
        <PageHeader>
          <Height>1.32158cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="PageCaption12">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!PageCaption.Value, "DataSet_Result")</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>17.4cm</Left>
              <Height>0.423cm</Height>
              <Width>0.75cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ItemTracingSpecificationCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!ItemTracingSpecificationCaption.Value, "DataSet_Result")</Value>
                      <Style>
                        <FontSize>8pt</FontSize>
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
            <Textbox Name="COMPANYNAME11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CompanyName.Value, "DataSet_Result")</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
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
                      <Value>=First(Fields!FormatToday.Value, "DataSet_Result")</Value>
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
              <Left>15.45cm</Left>
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
                      <Value>=User!UserID</Value>
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
              <Left>15.35cm</Left>
              <Height>0.423cm</Height>
              <Width>3.25cm</Width>
              <ZIndex>4</ZIndex>
              <Visibility>
                <Hidden>=IIf(First(Fields!PageCaption.Value, "DataSet_Result") = "",True,False)</Hidden>
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
                      <Value>=Globals!PageNumber</Value>
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
              <Left>18.15cm</Left>
              <Height>0.423cm</Height>
              <Width>0.45cm</Width>
              <ZIndex>5</ZIndex>
              <Visibility>
                <Hidden>=IIf(First(Fields!PageCaption.Value, "DataSet_Result")= "",True,False)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
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
        <LeftMargin>1cm</LeftMargin>
        <TopMargin>2cm</TopMargin>
        <BottomMargin>2cm</BottomMargin>
        <Style />
      </Page>
    </ReportSection>
  </ReportSections>
  <ReportParameters>
    <ReportParameter Name="DescriptionCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>DescriptionCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>DescriptionCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="EmptyStringCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>EmptyStringCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>EmptyStringCaption</Prompt>
    </ReportParameter>
  </ReportParameters>
  <ReportParametersLayout>
    <GridLayoutDefinition>
      <NumberOfColumns>1</NumberOfColumns>
      <NumberOfRows>2</NumberOfRows>
      <CellDefinitions>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>0</RowIndex>
          <ParameterName>DescriptionCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>1</RowIndex>
          <ParameterName>EmptyStringCaption</ParameterName>
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
  <rd:ReportID>419d1af5-ecd5-485b-8b86-4739ba5ec09e</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

