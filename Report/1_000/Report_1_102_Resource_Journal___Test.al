OBJECT Report 1102 Resource Journal - Test
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressourcekladde - kontrol;
               ENU=Resource Journal - Test];
    OnPreReport=BEGIN
                  ResJnlLineFilter := "Res. Journal Line".GETFILTERS;
                END;

  }
  DATASET
  {
    { 5830;    ;DataItem;                    ;
               DataItemTable=Table236;
               DataItemTableView=SORTING(Journal Template Name,Name);
               OnAfterGetRecord=BEGIN
                                  GetTotalCost := 0;
                                  GetTotalPrice := 0;
                                END;

               ReqFilterFields=Journal Template Name,Name }

    { 51  ;1   ;Column  ;JnlTemplateName_ResJnlBatch;
               SourceExpr="Journal Template Name" }

    { 52  ;1   ;Column  ;Name_ResJnlBatch    ;
               SourceExpr=Name }

    { 6948;1   ;DataItem;                    ;
               DataItemTable=Table207;
               DataItemTableView=SORTING(Journal Template Name,Journal Batch Name,Line No.);
               OnPreDataItem=BEGIN
                               ResJnlTemplate.GET("Res. Journal Batch"."Journal Template Name");
                               IF ResJnlTemplate.Recurring THEN BEGIN
                                 IF GETFILTER("Posting Date") <> '' THEN
                                   AddError(
                                     STRSUBSTNO(
                                       Text000,FIELDCAPTION("Posting Date")));
                                 SETRANGE("Posting Date",0D,WORKDATE);
                                 IF GETFILTER("Expiration Date") <> '' THEN
                                   AddError(
                                     STRSUBSTNO(
                                       Text000,
                                       FIELDCAPTION("Expiration Date")));
                                 SETFILTER("Expiration Date",'%1 | %2..',0D,WORKDATE);
                               END;
                               IF "Res. Journal Batch"."No. Series" <> '' THEN
                                 NoSeries.GET("Res. Journal Batch"."No. Series");
                               LastPostingDate := 0D;
                               LastDocNo := '';
                             END;

               OnAfterGetRecord=BEGIN
                                  IF EmptyLine THEN
                                    EXIT;

                                  MakeRecurringTexts("Res. Journal Line");

                                  IF "Resource No." = '' THEN
                                    AddError(STRSUBSTNO(Text001,FIELDCAPTION("Resource No.")))
                                  ELSE
                                    IF NOT Res.GET("Resource No.") THEN
                                      AddError(
                                        STRSUBSTNO(
                                          Text002,
                                          Res.TABLECAPTION,"Resource No."))
                                    ELSE BEGIN
                                      IF Res."Privacy Blocked" THEN
                                        AddError(STRSUBSTNO(Text003,Res.FIELDCAPTION("Privacy Blocked"),FALSE,Res.TABLECAPTION,"Resource No."));
                                      IF Res.Blocked THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text003,
                                            Res.FIELDCAPTION(Blocked),FALSE,Res.TABLECAPTION,"Resource No."));
                                    END;

                                  IF "Gen. Prod. Posting Group" = '' THEN
                                    AddError(STRSUBSTNO(Text001,FIELDCAPTION("Gen. Prod. Posting Group")))
                                  ELSE
                                    IF NOT GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group") THEN
                                      AddError(
                                        STRSUBSTNO(
                                          Text004,GenPostingSetup.TABLECAPTION,
                                          "Gen. Bus. Posting Group","Gen. Prod. Posting Group"));

                                  CheckRecurringLine("Res. Journal Line");

                                  IF "Posting Date" = 0D THEN
                                    AddError(STRSUBSTNO(Text001,FIELDCAPTION("Posting Date")))
                                  ELSE BEGIN
                                    IF "Posting Date" <> NORMALDATE("Posting Date") THEN
                                      AddError(STRSUBSTNO(Text005,FIELDCAPTION("Posting Date")));

                                    IF "Res. Journal Batch"."No. Series" <> '' THEN
                                      IF NoSeries."Date Order" AND ("Posting Date" < LastPostingDate) THEN
                                        AddError(Text006);
                                    LastPostingDate := "Posting Date";

                                    IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                                      IF USERID <> '' THEN
                                        IF UserSetup.GET(USERID) THEN BEGIN
                                          AllowPostingFrom := UserSetup."Allow Posting From";
                                          AllowPostingTo := UserSetup."Allow Posting To";
                                        END;
                                      IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                                        GLSetup.GET;
                                        AllowPostingFrom := GLSetup."Allow Posting From";
                                        AllowPostingTo := GLSetup."Allow Posting To";
                                      END;
                                      IF AllowPostingTo = 0D THEN
                                        AllowPostingTo := DMY2DATE(31,12,9999);
                                    END;

                                    IF ("Posting Date" < AllowPostingFrom) OR ("Posting Date" > AllowPostingTo) THEN
                                      AddError(
                                        STRSUBSTNO(
                                          Text007,FORMAT("Posting Date")));
                                  END;

                                  IF "Document Date" <> 0D THEN
                                    IF "Document Date" <> NORMALDATE("Document Date") THEN
                                      AddError(STRSUBSTNO(Text005,FIELDCAPTION("Document Date")));

                                  IF "Res. Journal Batch"."No. Series" <> '' THEN BEGIN
                                    IF LastDocNo <> '' THEN
                                      IF ("Document No." <> LastDocNo) AND ("Document No." <> INCSTR(LastDocNo)) THEN
                                        AddError(Text008);
                                    LastDocNo := "Document No.";
                                  END;

                                  IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                                    AddError(DimMgt.GetDimCombErr);

                                  TableID[1] := DATABASE::Resource;
                                  No[1] := "Resource No.";
                                  TableID[2] := DATABASE::"Resource Group";
                                  No[2] := "Resource Group No.";
                                  TableID[3] := DATABASE::Job;
                                  No[3] := "Job No.";
                                  IF NOT DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") THEN
                                    AddError(DimMgt.GetDimValuePostingErr);

                                  GetTotalCost += "Total Cost";
                                  GetTotalPrice += "Total Price";
                                END;

               ReqFilterFields=Posting Date;
               DataItemLink=Journal Template Name=FIELD(Journal Template Name),
                            Journal Batch Name=FIELD(Name) }

    { 35  ;2   ;Column  ;CompName            ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 40  ;2   ;Column  ;ResJnlLineTableCaption;
               SourceExpr=TABLECAPTION + ': ' + ResJnlLineFilter }

    { 44  ;2   ;Column  ;ResJnlLineFilter    ;
               SourceExpr=ResJnlLineFilter }

    { 46  ;2   ;Column  ;LineNo_ResJnlLine   ;
               SourceExpr="Line No." }

    { 1   ;2   ;Column  ;EntryType_ResJnlLine;
               SourceExpr="Entry Type" }

    { 3   ;2   ;Column  ;DocNo_ResJnlLine    ;
               SourceExpr="Document No." }

    { 7   ;2   ;Column  ;ResNo_ResJnlLine    ;
               SourceExpr="Resource No." }

    { 9   ;2   ;Column  ;WorkTypeCode_ResJnlLine;
               SourceExpr="Work Type Code" }

    { 11  ;2   ;Column  ;UOMCode_ResJnlLine  ;
               SourceExpr="Unit of Measure Code" }

    { 13  ;2   ;Column  ;Qty_ResJnlLine      ;
               SourceExpr=Quantity }

    { 15  ;2   ;Column  ;UnitCost_ResJnlLine ;
               SourceExpr="Unit Cost" }

    { 17  ;2   ;Column  ;TotalCost_ResJnlLine;
               SourceExpr="Total Cost" }

    { 19  ;2   ;Column  ;UnitPrice_ResJnlLine;
               SourceExpr="Unit Price" }

    { 21  ;2   ;Column  ;TotalPrice_ResJnlLine;
               SourceExpr="Total Price" }

    { 5   ;2   ;Column  ;PostingDateFormatted_ResJnlLine;
               SourceExpr=FORMAT("Posting Date") }

    { 48  ;2   ;Column  ;GetTotalPrice       ;
               SourceExpr=GetTotalPrice }

    { 47  ;2   ;Column  ;GetTotalCost        ;
               SourceExpr=GetTotalCost }

    { 33  ;2   ;Column  ;PageCaption         ;
               SourceExpr=PageCaptionLbl }

    { 34  ;2   ;Column  ;ResJnlTestCaption   ;
               SourceExpr=ResJnlTestCaptionLbl }

    { 38  ;2   ;Column  ;JnlTemplateNameCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Journal Template Name") }

    { 39  ;2   ;Column  ;JnlBatchNameCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Journal Batch Name") }

    { 20  ;2   ;Column  ;UnitPriceCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Unit Price") }

    { 22  ;2   ;Column  ;TotalPriceCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Total Price") }

    { 16  ;2   ;Column  ;UnitCostCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Unit Cost") }

    { 18  ;2   ;Column  ;TotalCostCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Total Cost") }

    { 14  ;2   ;Column  ;QtyCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION(Quantity) }

    { 12  ;2   ;Column  ;UOMCodeCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Unit of Measure Code") }

    { 10  ;2   ;Column  ;WorkTypeCodeCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Work Type Code") }

    { 8   ;2   ;Column  ;ResNoCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Resource No.") }

    { 4   ;2   ;Column  ;DocNoCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Document No.") }

    { 2   ;2   ;Column  ;EntryTypeCaption_ResJnlLine;
               SourceExpr=FIELDCAPTION("Entry Type") }

    { 6   ;2   ;Column  ;PostingDateCaption  ;
               SourceExpr=PostingDateCaptionLbl }

    { 23  ;2   ;Column  ;TotalCaption        ;
               SourceExpr=TotalCaptionLbl }

    { 9775;2   ;DataItem;DimensionLoop       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowDim THEN
                                 CurrReport.BREAK;
                               DimSetEntry.SETRANGE("Dimension Set ID","Res. Journal Line"."Dimension Set ID");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry.FINDSET THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;

                                  CLEAR(DimText);
                                  Continue := FALSE;
                                  REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                      DimText := STRSUBSTNO('%1 - %2',DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")
                                    ELSE
                                      DimText :=
                                        STRSUBSTNO(
                                          '%1; %2 - %3',DimText,DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                      DimText := OldDimText;
                                      Continue := TRUE;
                                      EXIT;
                                    END;
                                  UNTIL (DimSetEntry.NEXT = 0);
                                END;
                                 }

    { 41  ;3   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 45  ;3   ;Column  ;DimLoopNumber       ;
               SourceExpr=Number }

    { 42  ;3   ;Column  ;DimCaption          ;
               SourceExpr=DimCaptionLbl }

    { 1162;2   ;DataItem;ErrorLoop           ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,ErrorCounter);
                             END;

               OnPostDataItem=BEGIN
                                ErrorCounter := 0;
                              END;
                               }

    { 28  ;3   ;Column  ;ErrorTextNumber     ;
               SourceExpr=ErrorText[Number] }

    { 29  ;3   ;Column  ;WarningCaption      ;
               SourceExpr=WarningCaptionLbl }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
      { 3   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 2   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Vis dimensioner;
                             ENU=Show Dimensions];
                  ToolTipML=[DAN=Angiver, at dimensionerne for hver post eller bogf�ringsgruppe h�rer med.;
                             ENU=Specifies that the dimensions for each entry or posting group are included.];
                  ApplicationArea=#Jobs;
                  SourceExpr=ShowDim }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Der kan ikke s�ttes filter p� %1, n�r man bogf�rer gentagelseskladder.;ENU=%1 cannot be filtered when you post recurring journals.';
      Text001@1001 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be specified.';
      Text002@1002 : TextConst 'DAN=%1 %2 findes ikke.;ENU=%1 %2 does not exist.';
      Text003@1003 : TextConst 'DAN=%1 skal v�re %2 for %3 %4.;ENU=%1 must be %2 for %3 %4.';
      Text004@1004 : TextConst 'DAN=%1 %2 %3 findes ikke.;ENU=%1 %2 %3 does not exist.';
      Text005@1005 : TextConst 'DAN=%1 m� ikke v�re en ultimodato.;ENU=%1 must not be a closing date.';
      Text006@1006 : TextConst 'DAN=Linjerne er ikke sorteret efter bogf�ringsdato, fordi de ikke blev indtastet i den r�kkef�lge.;ENU=The lines are not listed according to Posting Date because they were not entered in that order.';
      Text007@1007 : TextConst 'DAN=%1 er ikke inden for den tilladte bogf�ringsperiode.;ENU=%1 is not within your allowed range of posting dates.';
      Text008@1008 : TextConst 'DAN=Der er et hul i nummerserien.;ENU=There is a gap in the number series.';
      Text009@1009 : TextConst 'DAN=%1 kan ikke indtastes.;ENU=%1 cannot be specified.';
      Text010@1010 : TextConst 'DAN=<Month Text>;ENU=<Month Text>';
      UserSetup@1011 : Record 91;
      GLSetup@1012 : Record 98;
      AccountingPeriod@1013 : Record 50;
      Res@1014 : Record 156;
      ResJnlTemplate@1015 : Record 206;
      GenPostingSetup@1016 : Record 252;
      NoSeries@1017 : Record 308;
      DimSetEntry@1018 : Record 480;
      DimMgt@1019 : Codeunit 408;
      ResJnlLineFilter@1020 : Text;
      AllowPostingFrom@1021 : Date;
      AllowPostingTo@1022 : Date;
      Day@1023 : Integer;
      Week@1024 : Integer;
      Month@1025 : Integer;
      MonthText@1026 : Text[30];
      ErrorCounter@1027 : Integer;
      ErrorText@1028 : ARRAY [30] OF Text[250];
      LastPostingDate@1029 : Date;
      LastDocNo@1030 : Code[20];
      TableID@1031 : ARRAY [10] OF Integer;
      No@1032 : ARRAY [10] OF Code[20];
      DimText@1033 : Text[120];
      OldDimText@1034 : Text[75];
      ShowDim@1035 : Boolean;
      Continue@1036 : Boolean;
      GetTotalCost@1037 : Decimal;
      GetTotalPrice@1038 : Decimal;
      PageCaptionLbl@8565 : TextConst 'DAN=Side;ENU=Page';
      ResJnlTestCaptionLbl@9273 : TextConst 'DAN=Ressourcekladde - kontrol;ENU=Resource Journal - Test';
      PostingDateCaptionLbl@5787 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      DimCaptionLbl@2995 : TextConst 'DAN=Dimensioner;ENU=Dimensions';
      WarningCaptionLbl@5070 : TextConst 'DAN=Advarsel!;ENU=Warning!';
      TotalCaptionLbl@1039 : TextConst 'DAN=I alt;ENU=Total';

    LOCAL PROCEDURE CheckRecurringLine@2(ResJnlLine2@1000 : Record 207);
    BEGIN
      WITH ResJnlLine2 DO
        IF ResJnlTemplate.Recurring THEN BEGIN
          IF "Recurring Method" = 0 THEN
            AddError(STRSUBSTNO(Text001,FIELDCAPTION("Recurring Method")));
          IF FORMAT("Recurring Frequency") = '' THEN
            AddError(STRSUBSTNO(Text001,FIELDCAPTION("Recurring Frequency")));
          IF "Recurring Method" = "Recurring Method"::Variable THEN
            IF Quantity = 0 THEN
              AddError(STRSUBSTNO(Text001,FIELDCAPTION(Quantity)));
        END ELSE BEGIN
          IF "Recurring Method" <> 0 THEN
            AddError(STRSUBSTNO(Text009,FIELDCAPTION("Recurring Method")));
          IF FORMAT("Recurring Frequency") <> '' THEN
            AddError(STRSUBSTNO(Text009,FIELDCAPTION("Recurring Frequency")));
        END;
    END;

    LOCAL PROCEDURE MakeRecurringTexts@3(VAR ResJnlLine2@1000 : Record 207);
    BEGIN
      WITH ResJnlLine2 DO
        IF ("Posting Date" <> 0D) AND ("Resource No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN
          Day := DATE2DMY("Posting Date",1);
          Week := DATE2DWY("Posting Date",2);
          Month := DATE2DMY("Posting Date",2);
          MonthText := FORMAT("Posting Date",0,Text010);
          AccountingPeriod.SETRANGE("Starting Date",0D,"Posting Date");
          IF NOT AccountingPeriod.FINDLAST THEN
            AccountingPeriod.Name := '';
          "Document No." :=
            DELCHR(
              PADSTR(
                STRSUBSTNO("Document No.",Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN("Document No.")),
              '>');
          Description :=
            DELCHR(
              PADSTR(
                STRSUBSTNO(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN(Description)),
              '>');
        END;
    END;

    LOCAL PROCEDURE AddError@1(Text@1000 : Text[250]);
    BEGIN
      ErrorCounter := ErrorCounter + 1;
      ErrorText[ErrorCounter] := Text;
    END;

    PROCEDURE InitializeRequest@4(ShowDimFrom@1000 : Boolean);
    BEGIN
      ShowDim := ShowDimFrom;
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
      <rd:DataSourceID>85bf1609-18cd-4193-823f-0c90926efc7d</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="JnlTemplateName_ResJnlBatch">
          <DataField>JnlTemplateName_ResJnlBatch</DataField>
        </Field>
        <Field Name="Name_ResJnlBatch">
          <DataField>Name_ResJnlBatch</DataField>
        </Field>
        <Field Name="CompName">
          <DataField>CompName</DataField>
        </Field>
        <Field Name="ResJnlLineTableCaption">
          <DataField>ResJnlLineTableCaption</DataField>
        </Field>
        <Field Name="ResJnlLineFilter">
          <DataField>ResJnlLineFilter</DataField>
        </Field>
        <Field Name="LineNo_ResJnlLine">
          <DataField>LineNo_ResJnlLine</DataField>
        </Field>
        <Field Name="EntryType_ResJnlLine">
          <DataField>EntryType_ResJnlLine</DataField>
        </Field>
        <Field Name="DocNo_ResJnlLine">
          <DataField>DocNo_ResJnlLine</DataField>
        </Field>
        <Field Name="ResNo_ResJnlLine">
          <DataField>ResNo_ResJnlLine</DataField>
        </Field>
        <Field Name="WorkTypeCode_ResJnlLine">
          <DataField>WorkTypeCode_ResJnlLine</DataField>
        </Field>
        <Field Name="UOMCode_ResJnlLine">
          <DataField>UOMCode_ResJnlLine</DataField>
        </Field>
        <Field Name="Qty_ResJnlLine">
          <DataField>Qty_ResJnlLine</DataField>
        </Field>
        <Field Name="Qty_ResJnlLineFormat">
          <DataField>Qty_ResJnlLineFormat</DataField>
        </Field>
        <Field Name="UnitCost_ResJnlLine">
          <DataField>UnitCost_ResJnlLine</DataField>
        </Field>
        <Field Name="UnitCost_ResJnlLineFormat">
          <DataField>UnitCost_ResJnlLineFormat</DataField>
        </Field>
        <Field Name="TotalCost_ResJnlLine">
          <DataField>TotalCost_ResJnlLine</DataField>
        </Field>
        <Field Name="TotalCost_ResJnlLineFormat">
          <DataField>TotalCost_ResJnlLineFormat</DataField>
        </Field>
        <Field Name="UnitPrice_ResJnlLine">
          <DataField>UnitPrice_ResJnlLine</DataField>
        </Field>
        <Field Name="UnitPrice_ResJnlLineFormat">
          <DataField>UnitPrice_ResJnlLineFormat</DataField>
        </Field>
        <Field Name="TotalPrice_ResJnlLine">
          <DataField>TotalPrice_ResJnlLine</DataField>
        </Field>
        <Field Name="TotalPrice_ResJnlLineFormat">
          <DataField>TotalPrice_ResJnlLineFormat</DataField>
        </Field>
        <Field Name="PostingDateFormatted_ResJnlLine">
          <DataField>PostingDateFormatted_ResJnlLine</DataField>
        </Field>
        <Field Name="GetTotalPrice">
          <DataField>GetTotalPrice</DataField>
        </Field>
        <Field Name="GetTotalPriceFormat">
          <DataField>GetTotalPriceFormat</DataField>
        </Field>
        <Field Name="GetTotalCost">
          <DataField>GetTotalCost</DataField>
        </Field>
        <Field Name="GetTotalCostFormat">
          <DataField>GetTotalCostFormat</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="ResJnlTestCaption">
          <DataField>ResJnlTestCaption</DataField>
        </Field>
        <Field Name="JnlTemplateNameCaption_ResJnlLine">
          <DataField>JnlTemplateNameCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="JnlBatchNameCaption_ResJnlLine">
          <DataField>JnlBatchNameCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="UnitPriceCaption_ResJnlLine">
          <DataField>UnitPriceCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="TotalPriceCaption_ResJnlLine">
          <DataField>TotalPriceCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="UnitCostCaption_ResJnlLine">
          <DataField>UnitCostCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="TotalCostCaption_ResJnlLine">
          <DataField>TotalCostCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="QtyCaption_ResJnlLine">
          <DataField>QtyCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="UOMCodeCaption_ResJnlLine">
          <DataField>UOMCodeCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="WorkTypeCodeCaption_ResJnlLine">
          <DataField>WorkTypeCodeCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="ResNoCaption_ResJnlLine">
          <DataField>ResNoCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="DocNoCaption_ResJnlLine">
          <DataField>DocNoCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="EntryTypeCaption_ResJnlLine">
          <DataField>EntryTypeCaption_ResJnlLine</DataField>
        </Field>
        <Field Name="PostingDateCaption">
          <DataField>PostingDateCaption</DataField>
        </Field>
        <Field Name="TotalCaption">
          <DataField>TotalCaption</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="DimLoopNumber">
          <DataField>DimLoopNumber</DataField>
        </Field>
        <Field Name="DimCaption">
          <DataField>DimCaption</DataField>
        </Field>
        <Field Name="ErrorTextNumber">
          <DataField>ErrorTextNumber</DataField>
        </Field>
        <Field Name="WarningCaption">
          <DataField>WarningCaption</DataField>
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
                  <Width>7.08755in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>1.52051in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="ResJnlLineCaption">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>6.99913in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox7">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ResJnlLineTableCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox7</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox6</rd:DefaultName>
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
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF(Fields!ResJnlLineFilter.Value="",True,False)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF(Fields!ResJnlLineFilter.Value="",True,False)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Top>0.31746cm</Top>
                              <Height>0.84602cm</Height>
                              <Width>17.77779cm</Width>
                              <Style />
                            </Tablix>
                            <Tablix Name="ResJnlLine">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.62992in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.41339in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.59055in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.59055in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.59055in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.37495in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.70866in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.70866in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.70866in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.70866in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.73819in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.35433in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PostingDateResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!PostingDateCaption.Value)</Value>
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
                                            <ZIndex>51</ZIndex>
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
                                          <Textbox Name="EntryTypeResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!EntryTypeCaption_ResJnlLine.Value)</Value>
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
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="DocNoResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!DocNoCaption_ResJnlLine.Value)</Value>
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
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ResourceNoResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!ResNoCaption_ResJnlLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>48</ZIndex>
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
                                          <Textbox Name="WorkTypeCodeResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!WorkTypeCodeCaption_ResJnlLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
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
                                          <Textbox Name="UOMCodeResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!UOMCodeCaption_ResJnlLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>46</ZIndex>
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
                                          <Textbox Name="QuantityResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!QtyCaption_ResJnlLine.Value)</Value>
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
                                            <ZIndex>45</ZIndex>
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
                                          <Textbox Name="UnitCostResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!UnitCostCaption_ResJnlLine.Value)</Value>
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
                                            <ZIndex>44</ZIndex>
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
                                          <Textbox Name="TotalCostResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!TotalCostCaption_ResJnlLine.Value)</Value>
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
                                            <ZIndex>43</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="UnitPriceResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!UnitPriceCaption_ResJnlLine.Value)</Value>
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
                                            <ZIndex>42</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalPriceResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!TotalPriceCaption_ResJnlLine.Value)</Value>
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
                                            <ZIndex>41</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PostingDateResJnlLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PostingDateFormatted_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
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
                                          <Textbox Name="EntryTypeResJnlLine">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!EntryType_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
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
                                          <Textbox Name="DocNoResJnlLine">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocNo_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
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
                                          <Textbox Name="ResourceNoResJnlLine">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ResNo_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
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
                                          <Textbox Name="WorkTypeCodeResJnlLine">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!WorkTypeCode_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
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
                                          <Textbox Name="UOMCodeResJnlLine">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UOMCode_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>22</ZIndex>
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
                                          <Textbox Name="QuantityResJnlLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Qty_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>#,##0</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>21</ZIndex>
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
                                          <Textbox Name="UnitCostResJnlLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitCost_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!UnitCost_ResJnlLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>20</ZIndex>
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
                                          <Textbox Name="TotalCostResJnlLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalCost_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!TotalCost_ResJnlLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
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
                                          <Textbox Name="UnitPriceResJnlLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitPrice_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!UnitPrice_ResJnlLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>18</ZIndex>
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
                                          <Textbox Name="TotalPriceResJnlLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalPrice_ResJnlLine.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!TotalPrice_ResJnlLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>17</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
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
                                                    <Value>=Fields!DimCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox2</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox4">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox4</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox3">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!WarningCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox3</rd:DefaultName>
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
                                          <Textbox Name="textbox5">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorTextNumber.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox5</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                  <TablixRow>
                                    <Height>0.16654in</Height>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>13</ZIndex>
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
                                            <ZIndex>12</ZIndex>
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
                                          <Textbox Name="TextBox12">
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
                                            <ZIndex>11</ZIndex>
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
                                          <Textbox Name="TextBox13">
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
                                            <ZIndex>10</ZIndex>
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
                                            <ZIndex>9</ZIndex>
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>8</ZIndex>
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>7</ZIndex>
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
                                          <Textbox Name="SumTotalCostResJnlLineCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!TotalCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
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
                                          <Textbox Name="SumTotalCostResJnlLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!GetTotalCost.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!TotalCost_ResJnlLineFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
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
                                          <Textbox Name="Textbox23">
                                            <CanGrow>true</CanGrow>
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
                                            <rd:DefaultName>Textbox23</rd:DefaultName>
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
                                          <Textbox Name="SumTotalPriceResJnlLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!GetTotalPrice.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!TotalPrice_ResJnlLineFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
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
                                    <Group Name="Table1_Group">
                                      <GroupExpressions>
                                        <GroupExpression>1</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="Table1_Group2">
                                          <GroupExpressions>
                                            <GroupExpression>=Fields!LineNo_ResJnlLine.Value</GroupExpression>
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
                                                  <Hidden>=IIF(Fields!DimLoopNumber.Value&gt;0,False,True)</Hidden>
                                                </Visibility>
                                              </TablixMember>
                                              <TablixMember>
                                                <Visibility>
                                                  <Hidden>=IIF(Fields!WarningCaption.Value="",True,False)</Hidden>
                                                </Visibility>
                                              </TablixMember>
                                            </TablixMembers>
                                            <DataElementName>Detail_Collection</DataElementName>
                                            <DataElementOutput>Output</DataElementOutput>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                        </TablixMembers>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>1.26984cm</Top>
                              <Height>2.59204cm</Height>
                              <Width>17.17736cm</Width>
                              <ZIndex>1</ZIndex>
                              <Style />
                            </Tablix>
                            <Textbox Name="NewPage">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=IIF(Code.ResetPageNumber(),True,False)</Value>
                                      <Style />
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Left>1.26984cm</Left>
                              <Height>0.31746cm</Height>
                              <Width>0.31746cm</Width>
                              <ZIndex>2</ZIndex>
                              <Visibility>
                                <Hidden>true</Hidden>
                              </Visibility>
                              <Style>
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
                      <GroupExpression>=Fields!JnlTemplateName_ResJnlBatch.Value</GroupExpression>
                      <GroupExpression>=Fields!Name_ResJnlBatch.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <Visibility>
                    <Hidden>=IIF(Fields!PostingDateCaption.Value="",True,False)</Hidden>
                  </Visibility>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <Height>3.86209cm</Height>
            <Width>18.00238cm</Width>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>3.86209cm</Height>
        <Style />
      </Body>
      <Width>18.00238cm</Width>
      <Page>
        <PageHeader>
          <Height>2.538cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="ResourceJnlTestCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!ResJnlTestCaption.Value</Value>
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
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CurrReportPageNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!PageCaption.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>16.79127cm</Left>
              <Height>0.423cm</Height>
              <Width>0.75cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyName">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!CompName.Value</Value>
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
                      <Value>=Globals!ExecutionTime</Value>
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
              <Left>11.90476cm</Left>
              <Height>0.423cm</Height>
              <Width>6.09762cm</Width>
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
              <Left>14.74127cm</Left>
              <Height>0.423cm</Height>
              <Width>3.26111cm</Width>
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
                      <Value>=Code.GetPageNumber(ReportItems!NewPage.Value,Globals!PageNumber)</Value>
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
              <Left>17.54127cm</Left>
              <Height>0.423cm</Height>
              <Width>0.46111cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="JnlBatchNameResJnlLineCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!JnlBatchNameCaption_ResJnlLine.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>1.90476cm</Top>
              <Height>0.423cm</Height>
              <Width>2.25cm</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="JnlTempNamesJnlLineCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!JnlTemplateNameCaption_ResJnlLine.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>1.48176cm</Top>
              <Height>0.423cm</Height>
              <Width>2.25cm</Width>
              <ZIndex>7</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="JnlBatchNameResJnlLine">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!Name_ResJnlBatch.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>1.90476cm</Top>
              <Left>2.4cm</Left>
              <Height>0.423cm</Height>
              <Width>2.04444cm</Width>
              <ZIndex>8</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="JnlTempNameResJnlLine">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!JnlTemplateName_ResJnlBatch.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>1.48176cm</Top>
              <Left>2.4cm</Left>
              <Height>0.423cm</Height>
              <Width>2.04444cm</Width>
              <ZIndex>9</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingBottom>2pt</PaddingBottom>
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

Public Function GetPageNumber(NewPage as Boolean, pagenumber as Integer) as Object
  If NewPage
    offset = pagenumber - 1
    NewPage = FALSE
  End If
  Return pagenumber - offset
End Function

Public Function ResetPageNumber() as Boolean
  NewPage = TRUE
  Return NewPage
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>3f6019eb-cc40-4b5a-8aee-2e012fbd2285</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

