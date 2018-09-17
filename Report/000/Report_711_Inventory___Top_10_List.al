OBJECT Report 711 Inventory - Top 10 List
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Vare - top 10-liste;
               ENU=Inventory - Top 10 List];
    OnPreReport=BEGIN
                  ItemFilter := Item.GETFILTERS;
                  ItemDateFilter := Item.GETFILTER("Date Filter");
                  Sequence := LOWERCASE(FORMAT(SELECTSTR(ShowSorting + 1,Text004)));
                  Heading := FORMAT(SELECTSTR(ShowType + 1,Text005));
                END;

  }
  DATASET
  {
    { 8129;    ;DataItem;                    ;
               DataItemTable=Table27;
               DataItemTableView=SORTING(No.);
               OnPreDataItem=BEGIN
                               Window.OPEN(Text000);
                               ItemAmount.DELETEALL;
                               i := 0;
                               CurrReport.CREATETOTALS("Sales (LCY)",Inventory);
                             END;

               OnAfterGetRecord=BEGIN
                                  Window.UPDATE(1,"No.");
                                  CALCFIELDS("Sales (LCY)",Inventory);
                                  IF ("Sales (LCY)" = 0) AND (Inventory = 0) AND NOT PrintAlsoIfZero THEN
                                    CurrReport.SKIP;

                                  ItemAmount.INIT;
                                  ItemAmount."Item No." := "No.";
                                  IF ShowType = ShowType::"Sales (LCY)" THEN BEGIN
                                    ItemAmount.Amount := "Sales (LCY)";
                                    ItemAmount."Amount 2" := Inventory;
                                  END ELSE BEGIN
                                    ItemAmount.Amount := Inventory;
                                    ItemAmount."Amount 2" := "Sales (LCY)";
                                  END;
                                  IF ShowSorting = ShowSorting::Largest THEN BEGIN
                                    ItemAmount.Amount := -ItemAmount.Amount;
                                    ItemAmount."Amount 2" := -ItemAmount."Amount 2";
                                  END;
                                  ItemAmount.INSERT;
                                  IF (NoOfRecordsToPrint = 0) OR (i < NoOfRecordsToPrint) THEN
                                    i := i + 1
                                  ELSE BEGIN
                                    ItemAmount.FIND('+');
                                    ItemAmount.DELETE;
                                  END;

                                  TotalItemSales += "Sales (LCY)";
                                  TotalItemBalance += Inventory;
                                END;

               ReqFilterFields=No.,Inventory Posting Group,Statistics Group,Date Filter }

    { 5444;    ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               Window.CLOSE;
                               ItemSales := Item."Sales (LCY)";
                               QtyOnHand := Item.Inventory;
                               CurrReport.CREATETOTALS(Item."Sales (LCY)",Item.Inventory);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT ItemAmount.FIND('-') THEN
                                      CurrReport.BREAK;
                                    IF ShowSorting = ShowSorting::Largest THEN
                                      MaxAmount := -ItemAmount.Amount
                                    ELSE BEGIN
                                      ItemAmount2 := ItemAmount;
                                      IF ItemAmount.NEXT(NoOfRecordsToPrint - 1) > 0 THEN;
                                      MaxAmount := ItemAmount.Amount;
                                      ItemAmount := ItemAmount2;
                                    END;
                                  END ELSE
                                    IF ItemAmount.NEXT = 0 THEN
                                      CurrReport.BREAK;
                                  Item.GET(ItemAmount."Item No.");
                                  Item.CALCFIELDS("Sales (LCY)",Inventory);
                                  IF ShowSorting = ShowSorting::Largest THEN BEGIN
                                    ItemAmount.Amount := -ItemAmount.Amount;
                                    ItemAmount."Amount 2" := -ItemAmount."Amount 2";
                                  END;
                                  IF (MaxAmount > 0) AND (ItemAmount.Amount > 0) THEN
                                    BarText := PADSTR('',ROUND(ItemAmount.Amount / MaxAmount * 45,1),'*')
                                  ELSE
                                    BarText := '';
                                  IF ShowSorting = ShowSorting::Largest THEN BEGIN
                                    ItemAmount.Amount := -ItemAmount.Amount;
                                    ItemAmount."Amount 2" := -ItemAmount."Amount 2";
                                  END;
                                END;
                                 }

    { 3   ;1   ;Column  ;STRSUBSTNO_Text001_ItemDateFilter_;
               SourceExpr=STRSUBSTNO(Text001,ItemDateFilter) }

    { 5   ;1   ;Column  ;CurrReport_PAGENO   ;
               SourceExpr=CurrReport.PAGENO }

    { 6   ;1   ;Column  ;COMPANYNAME         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 8   ;1   ;Column  ;STRSUBSTNO_Text002_Sequence_Heading_;
               SourceExpr=STRSUBSTNO(Text002,Sequence,Heading) }

    { 33  ;1   ;Column  ;PrintAlsoIfZero     ;
               SourceExpr=PrintAlsoIfZero }

    { 10  ;1   ;Column  ;STRSUBSTNO___1___2__Item_TABLECAPTION_ItemFilter_;
               SourceExpr=STRSUBSTNO('%1: %2',Item.TABLECAPTION,ItemFilter) }

    { 32  ;1   ;Column  ;ItemFilter          ;
               SourceExpr=ItemFilter }

    { 16  ;1   ;Column  ;STRSUBSTNO_Text003_Heading_;
               SourceExpr=STRSUBSTNO(Text003,Heading) }

    { 17  ;1   ;Column  ;Integer_Number      ;
               SourceExpr=Number }

    { 18  ;1   ;Column  ;Item__No__          ;
               SourceExpr=Item."No." }

    { 19  ;1   ;Column  ;Item_Description    ;
               SourceExpr=Item.Description }

    { 20  ;1   ;Column  ;Item__Sales__LCY__  ;
               SourceExpr=Item."Sales (LCY)";
               AutoFormatType=1 }

    { 21  ;1   ;Column  ;Item_Inventory      ;
               DecimalPlaces=0:5;
               SourceExpr=Item.Inventory }

    { 22  ;1   ;Column  ;BarText             ;
               SourceExpr=BarText }

    { 24  ;1   ;Column  ;Item__Sales__LCY___Control24;
               SourceExpr=Item."Sales (LCY)";
               AutoFormatType=1 }

    { 27  ;1   ;Column  ;ItemSales           ;
               SourceExpr=ItemSales;
               AutoFormatType=1 }

    { 28  ;1   ;Column  ;QtyOnHand           ;
               DecimalPlaces=0:5;
               SourceExpr=QtyOnHand }

    { 30  ;1   ;Column  ;SalesAmountPct      ;
               DecimalPlaces=1:1;
               SourceExpr=SalesAmountPct;
               AutoFormatType=1 }

    { 31  ;1   ;Column  ;QtyOnHandPct        ;
               DecimalPlaces=1:1;
               SourceExpr=QtyOnHandPct }

    { 39  ;1   ;Column  ;TotalItemBalance    ;
               SourceExpr=TotalItemBalance }

    { 40  ;1   ;Column  ;TotalItemSales      ;
               SourceExpr=TotalItemSales }

    { 1   ;1   ;Column  ;Inventory___Top_10_ListCaption;
               SourceExpr=Inventory___Top_10_ListCaptionLbl }

    { 4   ;1   ;Column  ;CurrReport_PAGENOCaption;
               SourceExpr=CurrReport_PAGENOCaptionLbl }

    { 9   ;1   ;Column  ;This_report_also_includes_items_not_on_inventory_or_that_are_not_sold_Caption;
               SourceExpr=This_report_also_includes_items_not_on_inventory_or_that_are_not_sold_CaptionLbl }

    { 11  ;1   ;Column  ;Integer_NumberCaption;
               SourceExpr=Integer_NumberCaptionLbl }

    { 12  ;1   ;Column  ;Item__No__Caption   ;
               SourceExpr=Item.FIELDCAPTION("No.") }

    { 13  ;1   ;Column  ;Item_DescriptionCaption;
               SourceExpr=Item.FIELDCAPTION(Description) }

    { 14  ;1   ;Column  ;Item__Sales__LCY__Caption;
               SourceExpr=Item.FIELDCAPTION("Sales (LCY)") }

    { 15  ;1   ;Column  ;Item_InventoryCaption;
               SourceExpr=Item_InventoryCaptionLbl }

    { 23  ;1   ;Column  ;Item__Sales__LCY___Control24Caption;
               SourceExpr=Item__Sales__LCY___Control24CaptionLbl }

    { 26  ;1   ;Column  ;ItemSalesCaption    ;
               SourceExpr=ItemSalesCaptionLbl }

    { 29  ;1   ;Column  ;SalesAmountPctCaption;
               SourceExpr=SalesAmountPctCaptionLbl }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
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
                  CaptionML=[DAN=Vis;
                             ENU=Show];
                  ToolTipML=[DAN=Angiver, om rapporten skal omhandle de varer, der s�lger bedst, ellers klik p� indstillingen Mindste, hvis en rapport skal omhandle de varer, der s�lges f�rrest af.;
                             ENU="Specifies if you want a report on the items that have the highest sales; select the Smallest option if you want a report on the items that have the lowest sales."];
                  OptionCaptionML=[DAN=St�rste,Mindste;
                                   ENU=Largest,Smallest];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ShowSorting }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Vis;
                             ENU=Show];
                  ToolTipML=[DAN="Angiver, om rapporten skal omhandle varesalg; klik p� indstillingen Lager, hvis du vil have en rapport over varernes lager.";
                             ENU="Specifies if you want a report on item sales; select the Inventory option if you want a report on the items' inventory."];
                  OptionCaptionML=[DAN=Salg (RV),Lager;
                                   ENU=Sales (LCY),Inventory];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ShowType }

      { 5   ;2   ;Field     ;
                  CaptionML=[DAN=Antal;
                             ENU=Quantity];
                  ToolTipML=[DAN=Angiver, hvor mange varer der skal medtages i rapporten.;
                             ENU=Specifies the number of items to be shown in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=NoOfRecordsToPrint }

      { 6   ;2   ;Field     ;
                  CaptionML=[DAN=Medtag ogs� varer uden beholdning eller varer, som ikke er solgt;
                             ENU=Include Items Not on Inventory or Not Sold];
                  ToolTipML=[DAN=Angiver, om du �nsker, at varer, der ikke er p� lager eller ikke er blevet solgt, skal medtages i rapporten.;
                             ENU=Specifies if you want items that are not on hand or have not been sold to be included in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintAlsoIfZero;
                  MultiLine=Yes }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Varerne sorteres #1##########;ENU=Sorting items    #1##########';
      Text001@1001 : TextConst 'DAN=Periode: %1;ENU=Period: %1';
      Text002@1002 : TextConst 'DAN=R�kkef�lge efter %1 %2;ENU=Ranked according to %1 %2';
      Text003@1003 : TextConst 'DAN=Andel af %1;ENU=Portion of %1';
      ItemAmount@1005 : TEMPORARY Record 268;
      ItemAmount2@1006 : Record 268;
      Window@1004 : Dialog;
      ItemFilter@1007 : Text;
      ItemDateFilter@1008 : Text;
      Sequence@1009 : Text[30];
      Heading@1010 : Text[30];
      ShowSorting@1011 : 'Largest,Smallest';
      ShowType@1012 : 'Sales (LCY),Inventory';
      NoOfRecordsToPrint@1013 : Integer;
      PrintAlsoIfZero@1014 : Boolean;
      ItemSales@1015 : Decimal;
      QtyOnHand@1016 : Decimal;
      SalesAmountPct@1017 : Decimal;
      QtyOnHandPct@1018 : Decimal;
      MaxAmount@1019 : Decimal;
      BarText@1020 : Text[50];
      i@1021 : Integer;
      Text004@1022 : TextConst 'DAN=St�rste,Mindste;ENU=Largest,Smallest';
      Text005@1023 : TextConst 'DAN=Salg (RV),Lager;ENU=Sales (LCY),Inventory';
      TotalItemSales@1024 : Decimal;
      TotalItemBalance@1025 : Decimal;
      Inventory___Top_10_ListCaptionLbl@6689 : TextConst 'DAN=Vare - top 10-liste;ENU=Inventory - Top 10 List';
      CurrReport_PAGENOCaptionLbl@8565 : TextConst 'DAN=Side;ENU=Page';
      This_report_also_includes_items_not_on_inventory_or_that_are_not_sold_CaptionLbl@6177 : TextConst 'DAN=Rapporten indeholder ogs� varer uden beholdning eller varer, som ikke er solgt.;ENU=This report also includes items not on inventory or that are not sold.';
      Integer_NumberCaptionLbl@9037 : TextConst 'DAN=Rangering;ENU=Rank';
      Item_InventoryCaptionLbl@2490 : TextConst 'DAN=Lager;ENU=Inventory';
      Item__Sales__LCY___Control24CaptionLbl@8384 : TextConst 'DAN=I alt;ENU=Total';
      ItemSalesCaptionLbl@4045 : TextConst 'DAN=Salg i alt;ENU=Total Sales';
      SalesAmountPctCaptionLbl@2665 : TextConst 'DAN=% af salg i alt;ENU=% of Total Sales';

    [External]
    PROCEDURE InitializeRequest@15(NewShowSorting@1000 : Option;NewShowType@1001 : Option;NewNoOfRecordsToPrint@1002 : Integer;NewPrintAlsoIfZero@1003 : Boolean);
    BEGIN
      ShowSorting := NewShowSorting;
      ShowType := NewShowType;
      NoOfRecordsToPrint := NewNoOfRecordsToPrint;
      PrintAlsoIfZero := NewPrintAlsoIfZero;
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
      <rd:DataSourceID>5d7057e7-579c-497c-ae37-f8980e576759</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="STRSUBSTNO_Text001_ItemDateFilter_">
          <DataField>STRSUBSTNO_Text001_ItemDateFilter_</DataField>
        </Field>
        <Field Name="CurrReport_PAGENO">
          <DataField>CurrReport_PAGENO</DataField>
        </Field>
        <Field Name="COMPANYNAME">
          <DataField>COMPANYNAME</DataField>
        </Field>
        <Field Name="STRSUBSTNO_Text002_Sequence_Heading_">
          <DataField>STRSUBSTNO_Text002_Sequence_Heading_</DataField>
        </Field>
        <Field Name="PrintAlsoIfZero">
          <DataField>PrintAlsoIfZero</DataField>
        </Field>
        <Field Name="STRSUBSTNO___1___2__Item_TABLECAPTION_ItemFilter_">
          <DataField>STRSUBSTNO___1___2__Item_TABLECAPTION_ItemFilter_</DataField>
        </Field>
        <Field Name="ItemFilter">
          <DataField>ItemFilter</DataField>
        </Field>
        <Field Name="STRSUBSTNO_Text003_Heading_">
          <DataField>STRSUBSTNO_Text003_Heading_</DataField>
        </Field>
        <Field Name="Integer_Number">
          <DataField>Integer_Number</DataField>
        </Field>
        <Field Name="Item__No__">
          <DataField>Item__No__</DataField>
        </Field>
        <Field Name="Item_Description">
          <DataField>Item_Description</DataField>
        </Field>
        <Field Name="Item__Sales__LCY__">
          <DataField>Item__Sales__LCY__</DataField>
        </Field>
        <Field Name="Item__Sales__LCY__Format">
          <DataField>Item__Sales__LCY__Format</DataField>
        </Field>
        <Field Name="Item_Inventory">
          <DataField>Item_Inventory</DataField>
        </Field>
        <Field Name="Item_InventoryFormat">
          <DataField>Item_InventoryFormat</DataField>
        </Field>
        <Field Name="BarText">
          <DataField>BarText</DataField>
        </Field>
        <Field Name="Item__Sales__LCY___Control24">
          <DataField>Item__Sales__LCY___Control24</DataField>
        </Field>
        <Field Name="Item__Sales__LCY___Control24Format">
          <DataField>Item__Sales__LCY___Control24Format</DataField>
        </Field>
        <Field Name="ItemSales">
          <DataField>ItemSales</DataField>
        </Field>
        <Field Name="ItemSalesFormat">
          <DataField>ItemSalesFormat</DataField>
        </Field>
        <Field Name="QtyOnHand">
          <DataField>QtyOnHand</DataField>
        </Field>
        <Field Name="QtyOnHandFormat">
          <DataField>QtyOnHandFormat</DataField>
        </Field>
        <Field Name="SalesAmountPct">
          <DataField>SalesAmountPct</DataField>
        </Field>
        <Field Name="SalesAmountPctFormat">
          <DataField>SalesAmountPctFormat</DataField>
        </Field>
        <Field Name="QtyOnHandPct">
          <DataField>QtyOnHandPct</DataField>
        </Field>
        <Field Name="QtyOnHandPctFormat">
          <DataField>QtyOnHandPctFormat</DataField>
        </Field>
        <Field Name="TotalItemBalance">
          <DataField>TotalItemBalance</DataField>
        </Field>
        <Field Name="TotalItemBalanceFormat">
          <DataField>TotalItemBalanceFormat</DataField>
        </Field>
        <Field Name="TotalItemSales">
          <DataField>TotalItemSales</DataField>
        </Field>
        <Field Name="TotalItemSalesFormat">
          <DataField>TotalItemSalesFormat</DataField>
        </Field>
        <Field Name="Inventory___Top_10_ListCaption">
          <DataField>Inventory___Top_10_ListCaption</DataField>
        </Field>
        <Field Name="CurrReport_PAGENOCaption">
          <DataField>CurrReport_PAGENOCaption</DataField>
        </Field>
        <Field Name="This_report_also_includes_items_not_on_inventory_or_that_are_not_sold_Caption">
          <DataField>This_report_also_includes_items_not_on_inventory_or_that_are_not_sold_Caption</DataField>
        </Field>
        <Field Name="Integer_NumberCaption">
          <DataField>Integer_NumberCaption</DataField>
        </Field>
        <Field Name="Item__No__Caption">
          <DataField>Item__No__Caption</DataField>
        </Field>
        <Field Name="Item_DescriptionCaption">
          <DataField>Item_DescriptionCaption</DataField>
        </Field>
        <Field Name="Item__Sales__LCY__Caption">
          <DataField>Item__Sales__LCY__Caption</DataField>
        </Field>
        <Field Name="Item_InventoryCaption">
          <DataField>Item_InventoryCaption</DataField>
        </Field>
        <Field Name="Item__Sales__LCY___Control24Caption">
          <DataField>Item__Sales__LCY___Control24Caption</DataField>
        </Field>
        <Field Name="ItemSalesCaption">
          <DataField>ItemSalesCaption</DataField>
        </Field>
        <Field Name="SalesAmountPctCaption">
          <DataField>SalesAmountPctCaption</DataField>
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
                  <Width>1.125cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.65cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>4.44444cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.95cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.5873cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>6.98413cm</Width>
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
                  <Height>1.269cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Integer_NumberCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Integer_NumberCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>37</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Item__No__Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Item__No__Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>36</ZIndex>
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
                        <Textbox Name="Item_DescriptionCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Item_DescriptionCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>35</ZIndex>
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
                        <Textbox Name="Item__Sales__LCY__Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Item__Sales__LCY__Caption.Value)</Value>
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
                          <ZIndex>34</ZIndex>
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
                        <Textbox Name="Item_InventoryCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Item_InventoryCaption.Value)</Value>
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
                          <ZIndex>33</ZIndex>
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
                        <Textbox Name="STRSUBSTNO_Text003_Heading_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!STRSUBSTNO_Text003_Heading_.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>32</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox113">
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
                          <ZIndex>31</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Integer_Number">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Integer_Number.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>9</ZIndex>
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
                        <Textbox Name="Item__No__">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Item__No__.Value</Value>
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
                        <Textbox Name="Item_Description">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Item_Description.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
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
                        <Textbox Name="Item__Sales__LCY__">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Item__Sales__LCY__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!Item__Sales__LCY__Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
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
                        <Textbox Name="Item_Inventory">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Item_Inventory.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>5</ZIndex>
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
                        <Textbox Name="BarText">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!BarText.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
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
                        <Textbox Name="STRSUBSTNO_Text001_ItemDateFilter_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!STRSUBSTNO_Text001_ItemDateFilter_.Value</Value>
                                  <Style>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>3</ZIndex>
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
                          <ZIndex>2</ZIndex>
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
                        <Textbox Name="Inventory___Top_10_ListCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Inventory___Top_10_ListCaption.Value</Value>
                                  <Style>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>1</ZIndex>
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
                  <Height>0.846cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox15">
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
                          <ZIndex>16</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>8pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox16">
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
                          <ZIndex>15</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>8pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Item__Sales__LCY___Control24Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Item__Sales__LCY___Control24Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>14</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2.5cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>8pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Item__Sales__LCY___Control24">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!Item__Sales__LCY__.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!Item__Sales__LCY__Format.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>13</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>8pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Item_Inventory_Control25">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!Item_Inventory.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>12</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>8pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TotalItemSales">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalItemSales.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!TotalItemSalesFormat.Value)</Format>
                                    <Color>#ffff00</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>11</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>8pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox115">
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
                          <ZIndex>10</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>8pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                  <Height>0.423cm</Height>
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
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>23</ZIndex>
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
                        <Textbox Name="TextBox18">
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
                          <ZIndex>22</ZIndex>
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
                        <Textbox Name="ItemSalesCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!ItemSalesCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>21</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2.5cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox19">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalItemSales.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>20</ZIndex>
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
                        <Textbox Name="textbox2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalItemBalance.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>19</ZIndex>
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
                        <Textbox Name="TotalItemBalance">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalItemBalance.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!TotalItemBalanceFormat.Value)</Format>
                                    <Color>#ffff00</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>18</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
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
                        <Textbox Name="TextBox116">
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
                          <ZIndex>17</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox110">
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
                        <Textbox Name="TextBox111">
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
                        <Textbox Name="SalesAmountPctCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!SalesAmountPctCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>28</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2.5cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="SalesAmountPct">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcPct(Sum(Fields!Item__Sales__LCY__.Value),Fields!TotalItemSales.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!SalesAmountPctFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>27</ZIndex>
                          <Visibility>
                            <Hidden>=IIF(RowNumber("DataSet_Result")&lt;1,TRUE,FALSE)</Hidden>
                          </Visibility>
                          <DataElementOutput>NoOutput</DataElementOutput>
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
                        <Textbox Name="QtyOnHandPct">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcPct(Sum(Fields!Item_Inventory.Value),Fields!TotalItemBalance.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!QtyOnHandPctFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>26</ZIndex>
                          <Visibility>
                            <Hidden>=IIF(RowNumber("DataSet_Result")&lt;1,TRUE,FALSE)</Hidden>
                          </Visibility>
                          <DataElementOutput>NoOutput</DataElementOutput>
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
                          <ZIndex>24</ZIndex>
                          <Style>
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
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>1.90476cm</Top>
            <ZIndex>3</ZIndex>
          </Tablix>
          <Textbox Name="textbox14">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!STRSUBSTNO_Text002_Sequence_Heading_.Value</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
              </Paragraph>
            </Paragraphs>
            <Top>0.31746cm</Top>
            <Height>0.423cm</Height>
            <Width>12.69841cm</Width>
            <ZIndex>2</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="textbox6">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!This_report_also_includes_items_not_on_inventory_or_that_are_not_sold_Caption.Value</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
              </Paragraph>
            </Paragraphs>
            <Top>0.74074cm</Top>
            <Height>0.423cm</Height>
            <Width>12.69841cm</Width>
            <ZIndex>1</ZIndex>
            <Visibility>
              <Hidden>=IIF(Fields!PrintAlsoIfZero.Value = FALSE,TRUE,FALSE)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="textbox11">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!STRSUBSTNO___1___2__Item_TABLECAPTION_ItemFilter_.Value</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
              </Paragraph>
            </Paragraphs>
            <Top>1.16402cm</Top>
            <Height>0.42328cm</Height>
            <Width>12.69841cm</Width>
            <Visibility>
              <Hidden>=IIF(Fields!ItemFilter.Value = "",TRUE,FALSE)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
        </ReportItems>
        <Height>5.28876cm</Height>
      </Body>
      <Width>18.54087cm</Width>
      <Page>
        <PageHeader>
          <Height>1.5873cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
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
              <Left>17.7cm</Left>
              <Height>0.423cm</Height>
              <Width>0.45cm</Width>
              <ZIndex>6</ZIndex>
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
              <Left>14.9cm</Left>
              <Height>0.423cm</Height>
              <Width>3.25cm</Width>
              <ZIndex>5</ZIndex>
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
                      <Value EvaluationMode="Auto">=Globals!ExecutionTime</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>D</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>12.56583cm</Left>
              <Height>0.423cm</Height>
              <Width>5.58417cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="STRSUBSTNO_Text001_ItemDateFilter_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!STRSUBSTNO_Text001_ItemDateFilter_.Value</Value>
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
              <ZIndex>3</ZIndex>
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
                      <Value>=ReportItems!COMPANYNAME.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.846cm</Top>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Inventory___Top_10_ListCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!Inventory___Top_10_ListCaption.Value</Value>
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
            <Textbox Name="CurrReport_PAGENOCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!CurrReport_PAGENOCaption.Value</Value>
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


Shared Pct as Decimal
Public Function CalcPct(Numeral1 as Decimal, Numeral2 as Decimal) as Decimal
    if Numeral2 &lt;&gt; 0 then
       Pct = 100*Numeral1/Numeral2
    else
       Pct = 0
    end if
Return ROUND(10*Pct)/10
End Function
</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Invalid</rd:ReportUnitType>
  <rd:ReportID>8282cca1-6d50-40b2-a448-0a1ef3485f0d</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

