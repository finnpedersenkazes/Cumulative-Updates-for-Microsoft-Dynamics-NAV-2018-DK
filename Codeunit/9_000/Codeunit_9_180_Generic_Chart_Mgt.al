OBJECT Codeunit 9180 Generic Chart Mgt
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text001@1018 : TextConst 'DAN=Du skal v�lge %1.;ENU=You must select the %1.';
      Text002@1000 : TextConst 'DAN=(Ingen filtre valgt);ENU=(No filters selected)';
      Text003@1001 : TextConst 'DAN=Du kan ikke v�lge flere end %1 m�l, n�r du bruger indstillingen Tilpas diagram.;ENU=You cannot select more than %1 measures when using the Customize Chart option.';
      Text004@1002 : TextConst 'DAN=Du kan ikke v�lge antal for dette diagram, da kildeforesp�rgslen ikke underst�tter denne summeringsmetode.;ENU=You cannot select Count for this chart because the source query does not support this aggregation method.';
      Text005@1003 : TextConst 'DAN=Summeringstypen %1 kan kun v�lges for kolonner af typen Decimal.;ENU=The aggregation type %1 can only be selected for columns of type Decimal.';
      DescriptionTok@1004 : TextConst '@@@=DESCR.;DAN=BESKR.;ENU=DESCR.';
      XAxisTitleTok@1005 : TextConst '@@@=X-AXIS;DAN=X-TITEL;ENU=X-TITLE';
      YAxisTitleTok@1006 : TextConst '@@@=Y-AXIS;DAN=Y-TITEL;ENU=Y-TITLE';
      ZAxisTitleTok@1015 : TextConst '@@@=Y-AXIS;DAN=Z-TITEL;ENU=Z-TITLE';
      XAxisCaptionTok@1014 : TextConst '@@@=X-AXIS;DAN=X-TITEL;ENU=X-CAPTION';
      ZAxisCaptionTok@1013 : TextConst '@@@=Y-AXIS;DAN=Z-TITEL;ENU=Z-CAPTION';
      RequiredTok@1007 : TextConst '@@@=REQUIRED;DAN=OBLIGAT.;ENU=REQUIRED';
      Optional1Tok@1008 : TextConst '@@@=OPTIONAL1;DAN=VALGFRIT1;ENU=OPTIONAL1';
      Optional2Tok@1009 : TextConst '@@@=OPTIONAL2;DAN=VALGFRIT2;ENU=OPTIONAL2';
      Optional3Tok@1010 : TextConst '@@@=OPTIONAL3;DAN=VALGFRIT3;ENU=OPTIONAL3';
      Optional4Tok@1011 : TextConst '@@@=OPTIONAL4;DAN=VALGFRIT4;ENU=OPTIONAL4';
      Optional5Tok@1012 : TextConst '@@@=OPTIONAL5;DAN=VALGFRIT5;ENU=OPTIONAL5';
      AggregationTxt@1016 : TextConst 'DAN=Ingen,Antal,Sum,Min,Maks,Gns;ENU=None,Count,Sum,Min,Max,Avg';

    [Internal]
    PROCEDURE RetrieveXML@2(VAR Chart@1003 : Record 2000000078;VAR TempGenericChartSetup@1007 : TEMPORARY Record 9180;VAR TempGenericChartYAxis@1008 : TEMPORARY Record 9182;VAR TempGenericChartCaptionsBuf@1004 : TEMPORARY Record 9185;VAR TempGenericChartMemoBuf@1001 : TEMPORARY Record 9186;VAR TempGenericChartFilter@1009 : TEMPORARY Record 9181);
    VAR
      chartBuilder@1000 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartBuilder";
      i@1006 : Integer;
      FilterText@1002 : Text[250];
      CaptionCode@1005 : Code[10];
    BEGIN
      TempGenericChartSetup.DELETEALL;
      CLEAR(TempGenericChartSetup);
      TempGenericChartCaptionsBuf.DELETEALL;
      CLEAR(TempGenericChartCaptionsBuf);
      TempGenericChartMemoBuf.DELETEALL;
      CLEAR(TempGenericChartMemoBuf);
      IF NOT GetChartBuilder(Chart,chartBuilder) THEN
        EXIT;

      WITH TempGenericChartSetup DO BEGIN
        IF chartBuilder.TableId > 0 THEN BEGIN
          "Source Type" := "Source Type"::Table;
          "Source ID" := chartBuilder.TableId;
          "Object Name" := chartBuilder.TableName;
        END ELSE BEGIN
          "Source Type" := "Source Type"::Query;
          "Source ID" := chartBuilder.QueryId;
          "Object Name" := chartBuilder.QueryName;
        END;
        GetSourceIDName("Source Type","Source ID","Object Name");
      END;

      BuildMemoBuf(TempGenericChartMemoBuf,DescriptionCode,chartBuilder.GetMultilanguageDescription);

      // Filters:
      CLEAR(FilterText);
      BuildTempGenericChartFilter(TempGenericChartSetup,TempGenericChartFilter,chartBuilder,FilterText);
      TempGenericChartSetup."Filter Text" := FilterText;
      FinalizeFilterText(TempGenericChartSetup."Filter Text");

      // X, Y and Z axes:
      WITH TempGenericChartSetup DO BEGIN
        "X-Axis Field ID" := chartBuilder.XDimensionId;      // Number of field
        "X-Axis Field Name" := chartBuilder.XDimensionName;  // Name of field
        GetFieldColumnNoName("Source Type","Source ID","X-Axis Field ID","X-Axis Field Name",FALSE);
        "X-Axis Show Title" := chartBuilder.ShowXDimensionTitle;
        BuildCaptionBuf(TempGenericChartCaptionsBuf,XAxisTitleCode,chartBuilder.GetXDimensionMultilanguageTitle);
        BuildCaptionBuf(TempGenericChartCaptionsBuf,XAxisCaptionCode,chartBuilder.GetXDimensionMultilanguageCaption);
        "Y-Axis Show Title" := chartBuilder.ShowYAxisTitle;
        BuildCaptionBuf(TempGenericChartCaptionsBuf,YAxisTitleCode,chartBuilder.GetYAxisMultilanguageTitle);

        IF chartBuilder.HasZDimension THEN BEGIN
          "Z-Axis Field ID" := chartBuilder.ZDimensionId;
          "Z-Axis Field Name" := chartBuilder.ZDimensionName;
          GetFieldColumnNoName("Source Type","Source ID","Z-Axis Field ID","Z-Axis Field Name",FALSE);
          "Z-Axis Show Title" := chartBuilder.ShowZDimensionTitle;
          BuildCaptionBuf(TempGenericChartCaptionsBuf,ZAxisTitleCode,chartBuilder.GetZDimensionMultilanguageTitle);
          BuildCaptionBuf(TempGenericChartCaptionsBuf,ZAxisCaptionCode,chartBuilder.GetZDimensionMultilanguageCaption);
        END;
      END;

      // Measures:
      WITH TempGenericChartYAxis DO BEGIN
        DELETEALL;
        CaptionCode := RequiredMeasureCode;
        FOR i := 0 TO chartBuilder.MeasureCount - 1 DO BEGIN
          INIT;
          ID := Chart.ID;
          "Line No." := 10000 * (i + 1);
          IF chartBuilder.HasMeasureField(i) THEN BEGIN
            "Y-Axis Measure Field ID" := chartBuilder.GetMeasureId(i);
            "Y-Axis Measure Field Name" := chartBuilder.GetMeasureName(i);
            BuildCaptionBuf(TempGenericChartCaptionsBuf,CaptionCode,chartBuilder.GetMultilanguageMeasureCaption(i));
            GetFieldColumnNoName(
              TempGenericChartSetup."Source Type",TempGenericChartSetup."Source ID","Y-Axis Measure Field ID",
              "Y-Axis Measure Field Name",FALSE);

            IF CaptionCode = RequiredMeasureCode THEN
              CaptionCode := OptionalMeasure1Code
            ELSE
              CaptionCode := INCSTR(CaptionCode)
          END;
          "Chart Type" := ChartType2GraphType(chartBuilder.GetMeasureChartType(i));
          Aggregation := Operator2Aggregation(chartBuilder.GetMeasureOperator(i));
          INSERT;
        END;
      END;
    END;

    [Internal]
    PROCEDURE FillChartHelper@6(VAR chartBuilder@1003 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartBuilder";TempGenericChartSetup@1002 : TEMPORARY Record 9180;VAR TempGenericChartYAxis@1012 : TEMPORARY Record 9182;VAR TempGenericChartFilter@1000 : TEMPORARY Record 9181;VAR TempGenericChartCaptionsBuf@1001 : TEMPORARY Record 9185;VAR TempGenericChartMemoBuf@1005 : TEMPORARY Record 9186);
    VAR
      DataMeasureType@1004 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.DataMeasureType";
      DataAggregationType@1006 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.DataAggregationType";
      MultilanguageText@1011 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartMultiLanguageText";
      CaptionCode@1007 : Code[10];
    BEGIN
      ValidateChart(TempGenericChartSetup,TempGenericChartYAxis,TempGenericChartFilter);
      CASE TempGenericChartSetup."Source Type" OF
        TempGenericChartSetup."Source Type"::Table:
          BEGIN
            chartBuilder.TableId(TempGenericChartSetup."Source ID");
            chartBuilder.TableName(TempGenericChartSetup."Object Name");
          END;
        TempGenericChartSetup."Source Type"::Query:
          BEGIN
            chartBuilder.QueryId(TempGenericChartSetup."Source ID");
            chartBuilder.QueryName(TempGenericChartSetup."Object Name");
          END;
      END;
      BuildMemoMultilanguageText(TempGenericChartMemoBuf,DescriptionCode,MultilanguageText);
      chartBuilder.SetMultilanguageDescription(MultilanguageText);
      chartBuilder.XDimensionId := TempGenericChartSetup."X-Axis Field ID";
      chartBuilder.XDimensionName := TempGenericChartSetup."X-Axis Field Name";
      chartBuilder.ShowXDimensionTitle := TempGenericChartSetup."X-Axis Show Title";
      BuildMultilanguageText(TempGenericChartCaptionsBuf,XAxisTitleCode,MultilanguageText);
      chartBuilder.SetXDimensionMultilanguageTitle(MultilanguageText);
      BuildMultilanguageText(TempGenericChartCaptionsBuf,XAxisCaptionCode,MultilanguageText);
      chartBuilder.SetXDimensionMultilanguageCaption(MultilanguageText);
      chartBuilder.ZDimensionId := TempGenericChartSetup."Z-Axis Field ID";
      chartBuilder.ZDimensionName := TempGenericChartSetup."Z-Axis Field Name";
      chartBuilder.ShowZDimensionTitle := TempGenericChartSetup."Z-Axis Show Title";
      BuildMultilanguageText(TempGenericChartCaptionsBuf,ZAxisTitleCode,MultilanguageText);
      chartBuilder.SetZDimensionMultilanguageTitle(MultilanguageText);
      BuildMultilanguageText(TempGenericChartCaptionsBuf,ZAxisCaptionCode,MultilanguageText);
      chartBuilder.SetZDimensionMultilanguageCaption(MultilanguageText);

      // Y-Axis
      chartBuilder.ShowYAxisTitle := TempGenericChartSetup."Y-Axis Show Title";
      BuildMultilanguageText(TempGenericChartCaptionsBuf,YAxisTitleCode,MultilanguageText);
      chartBuilder.SetYAxisMultilanguageTitle(MultilanguageText);

      WITH TempGenericChartYAxis DO
        IF FIND('-') THEN BEGIN
          CaptionCode := RequiredMeasureCode;
          REPEAT
            BuildMultilanguageText(TempGenericChartCaptionsBuf,CaptionCode,MultilanguageText);
            DataMeasureType := GraphType2ChartType("Chart Type");
            DataAggregationType := Aggregation2Operator(Aggregation);
            chartBuilder.AddMeasure(
              "Y-Axis Measure Field ID","Y-Axis Measure Field Name",MultilanguageText,DataMeasureType,DataAggregationType);
            IF CaptionCode = RequiredMeasureCode THEN
              CaptionCode := OptionalMeasure1Code
            ELSE
              CaptionCode := INCSTR(CaptionCode)
          UNTIL NEXT = 0
        END;

      // Filters:
      WITH TempGenericChartFilter DO
        IF FIND('-') THEN
          REPEAT
            GetFieldColumnNoName(
              TempGenericChartSetup."Source Type",TempGenericChartSetup."Source ID","Filter Field ID","Filter Field Name",TRUE);
            IF "Filter Field ID" > 0 THEN
              CASE TempGenericChartSetup."Source Type" OF
                TempGenericChartSetup."Source Type"::Table:
                  chartBuilder.AddTableFilter("Filter Field ID","Filter Field Name","Filter Value");
                TempGenericChartSetup."Source Type"::Query:
                  chartBuilder.AddQueryFilter("Filter Field ID","Filter Field Name","Filter Value");
              END;
          UNTIL NEXT = 0;
    END;

    [Internal]
    PROCEDURE SaveChanges@8(VAR Chart@1001 : Record 2000000078;TempGenericChartSetup@1004 : TEMPORARY Record 9180;VAR TempGenericChartYAxis@1003 : TEMPORARY Record 9182;VAR TempGenericChartFilter@1013 : TEMPORARY Record 9181;VAR TempGenericChartCaptionsBuf@1002 : TEMPORARY Record 9185;VAR TempGenericChartMemoBuf@1000 : TEMPORARY Record 9186);
    VAR
      chartBuilder@1008 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartBuilder";
      OutStream@1006 : OutStream;
    BEGIN
      chartBuilder := chartBuilder.Empty;
      FillChartHelper(chartBuilder,TempGenericChartSetup,TempGenericChartYAxis,TempGenericChartFilter,
        TempGenericChartCaptionsBuf,TempGenericChartMemoBuf);
      CLEAR(Chart.BLOB);
      Chart.BLOB.CREATEOUTSTREAM(OutStream);
      COPYSTREAM(OutStream,chartBuilder.GetAsStream);
      CLEAR(chartBuilder);
    END;

    [Internal]
    PROCEDURE LookUpObjectId@11(ObjType@1001 : ' ,Table,Query';VAR ObjID@1000 : Integer;VAR ObjName@1003 : Text[50]);
    VAR
      AllObjWithCaption@1002 : Record 2000000058;
    BEGIN
      SetObjTypeRange(ObjType,AllObjWithCaption);
      IF PAGE.RUNMODAL(PAGE::Objects,AllObjWithCaption) = ACTION::LookupOK THEN BEGIN
        ObjID := AllObjWithCaption."Object ID";
        ValidateObjectID(ObjType,ObjID,ObjName);
      END;
    END;

    [Internal]
    PROCEDURE ValidateObjectID@12(ObjType@1001 : ' ,Table,Query';VAR ObjID@1000 : Integer;VAR ObjName@1002 : Text[50]);
    VAR
      AllObjWithCaption@1003 : Record 2000000058;
    BEGIN
      ObjName := '';
      IF ObjType = ObjType::" " THEN BEGIN
        ObjID := 0;
        EXIT;
      END;
      SetObjTypeRange(ObjType,AllObjWithCaption);
      AllObjWithCaption.SETRANGE("Object ID",ObjID);
      IF AllObjWithCaption.FINDFIRST THEN
        ObjName := AllObjWithCaption."Object Name";
    END;

    [Internal]
    PROCEDURE ValidateFieldColumn@1(TempGenericChartSetup@1008 : TEMPORARY Record 9180;VAR FieldColumnNo@1005 : Integer;FieldColumnName@1000 : Text[80];VAR FieldCaption@1007 : Text[250];Category@1006 : Integer;FilteringLookup@1009 : Boolean;VAR Aggregation@1002 : 'None,Count,Sum,Min,Max,Avg');
    VAR
      Field@1004 : Record 2000000041;
      TempGenericChartQueryColumn@1001 : TEMPORARY Record 9183;
    BEGIN
      // Category: 0: All, 1: Not integer and decimal, 2: Only integer and decimal
      CheckSourceTypeID(TempGenericChartSetup,TRUE);
      FieldColumnNo := 0;
      FieldCaption := '';
      IF FieldColumnName = '' THEN BEGIN
        Aggregation := Aggregation::None;
        EXIT;
      END;

      CASE TempGenericChartSetup."Source Type" OF
        TempGenericChartSetup."Source Type"::Table:
          BEGIN
            Field.SETRANGE(TableNo,TempGenericChartSetup."Source ID");
            Field.SETRANGE(FieldName,FieldColumnName);
            Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
            FilterFieldCategory(Field,Category,FilteringLookup);
            Field.FINDFIRST;
            FieldColumnNo := Field."No.";
          END;
        TempGenericChartSetup."Source Type"::Query:
          BEGIN
            GetQueryColumnList(TempGenericChartQueryColumn,TempGenericChartSetup."Source ID",Category,FilteringLookup);
            TempGenericChartQueryColumn.SETRANGE("Query No.",TempGenericChartSetup."Source ID");
            TempGenericChartQueryColumn.SETRANGE("Column Name",FieldColumnName);
            TempGenericChartQueryColumn.FINDFIRST;
            FieldColumnNo := TempGenericChartQueryColumn."Query Column No.";
            FieldColumnName := TempGenericChartQueryColumn."Column Name";
            Aggregation := TempGenericChartQueryColumn."Aggregation Type";
          END;
      END;
      FieldCaption := FieldColumnName;
    END;

    [Internal]
    PROCEDURE RetrieveFieldColumn@15(TempGenericChartSetup@1003 : TEMPORARY Record 9180;VAR No@1005 : Integer;VAR Name@1006 : Text[80];VAR Capt@1008 : Text[250];Category@1007 : Integer;FilteringLookup@1009 : Boolean);
    VAR
      Field@1002 : Record 2000000041;
      TempGenericChartQueryColumn@1001 : TEMPORARY Record 9183;
    BEGIN
      // Category: 0: All, 1: Not integer and decimal, 2: Only integer and decimal
      CheckSourceTypeID(TempGenericChartSetup,TRUE);
      CASE TempGenericChartSetup."Source Type" OF
        TempGenericChartSetup."Source Type"::Table:
          BEGIN
            Field.SETRANGE(TableNo,TempGenericChartSetup."Source ID");
            Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
            FilterFieldCategory(Field,Category,FilteringLookup);
            IF PAGE.RUNMODAL(PAGE::"Field List",Field) = ACTION::LookupOK THEN BEGIN
              No := Field."No.";
              Name := Field.FieldName;
              Capt := Name;
            END;
          END;
        TempGenericChartSetup."Source Type"::Query:
          BEGIN
            GetQueryColumnList(TempGenericChartQueryColumn,TempGenericChartSetup."Source ID",Category,FilteringLookup);
            TempGenericChartQueryColumn.SETRANGE("Query No.",TempGenericChartSetup."Source ID");
            IF PAGE.RUNMODAL(PAGE::"Generic Chart Query Columns",TempGenericChartQueryColumn) = ACTION::LookupOK THEN BEGIN
              No := TempGenericChartQueryColumn."Query Column No.";
              Name := TempGenericChartQueryColumn."Column Name";
              Capt := Name;
            END;
          END;
      END;
    END;

    [Internal]
    PROCEDURE RetrieveFieldColumnIDFromName@19(ObjType@1003 : ' ,Table,Query';ObjID@1002 : Integer;VAR No@1001 : Integer;Name@1000 : Text[50]);
    VAR
      Field@1004 : Record 2000000041;
      TempGenericChartQueryColumn@1005 : TEMPORARY Record 9183;
    BEGIN
      No := 0;
      CASE ObjType OF
        ObjType::Table:
          BEGIN
            Field.SETRANGE(TableNo,ObjID);
            Field.SETRANGE(FieldName,Name);
            Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
            IF Field.FINDFIRST THEN
              No := Field."No.";
          END;
        ObjType::Query:
          BEGIN
            GetQueryColumnList(TempGenericChartQueryColumn,ObjID,0,TRUE);
            TempGenericChartQueryColumn.SETRANGE("Query No.",ObjID);
            TempGenericChartQueryColumn.SETRANGE("Column Name",Name);
            IF TempGenericChartQueryColumn.FINDFIRST THEN
              No := TempGenericChartQueryColumn."Query Column No.";
          END;
      END;
    END;

    [Internal]
    PROCEDURE SetObjTypeRange@13(ObjType@1000 : ' ,Table,Query';VAR AllObjWithCaption@1001 : Record 2000000058);
    BEGIN
      CLEAR(AllObjWithCaption);
      CASE ObjType OF
        ObjType::Table:
          AllObjWithCaption.SETRANGE("Object Type",AllObjWithCaption."Object Type"::Table);
        ObjType::Query:
          AllObjWithCaption.SETRANGE("Object Type",AllObjWithCaption."Object Type"::Query);
      END;
    END;

    LOCAL PROCEDURE ChartType2GraphType@3(DataMeasureType@1002 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.DataMeasureType") : Integer;
    VAR
      i@1000 : Integer;
    BEGIN
      i := DataMeasureType;
      CASE i OF
        10: // Column
          EXIT(0);
        0:
          EXIT(1);
        3:
          EXIT(2);
        11:
          EXIT(3);
        12:
          EXIT(4);
        13:
          EXIT(5);
        15:
          EXIT(6);
        16:
          EXIT(7);
        5:
          EXIT(8);
        17:
          EXIT(9);
        18:
          EXIT(10);
        21:
          EXIT(11);
        25:
          EXIT(12);
        33:
          EXIT(13);
      END;
    END;

    LOCAL PROCEDURE GraphType2ChartType@21(GraphType@1000 : Integer) : Integer;
    BEGIN
      // Save function:
      // Aggregation var on page 9183:
      // Column,Point,Line,ColumnStacked,ColumnStacked100,Area,AreaStacked,AreaStacked100,StepLine,Pie,Doughnut,Range,Radar,Funnel
      // option in TAB485:
      // Point,1,Bubble,Line,4,StepLine,6,7,8,9,Column,StackedColumn,StackedColumn100,Area,14,StackedArea,StackedArea100,Pie,Doughnut,19,20,Range,22,23,24,Radar,26,27,28,29,30,31,32,Funnel}

      CASE GraphType OF
        0:
          EXIT(10); // Column
        1:
          EXIT(0);  // Point
        2:
          EXIT(3);  // Line
        3:
          EXIT(11); // ColumnStacked
        4:
          EXIT(12); // ColumnStacked100
        5:
          EXIT(13); // Area
        6:
          EXIT(15); // AreaStacked
        7:
          EXIT(16); // AreaStacked100
        8:
          EXIT(5);  // StepLine
        9:
          EXIT(17); // Pie
        10:
          EXIT(18); // Doughnut
        11:
          EXIT(21); // Range
        12:
          EXIT(25); // Radar
        13:
          EXIT(33); // Funnel
        ELSE
          EXIT(GraphType);
      END;
    END;

    LOCAL PROCEDURE Aggregation2Operator@23(Aggregation@1000 : Integer) : Integer;
    BEGIN
      // From Rec (BLOB) to XML File - i.e. when saving
      // Aggregation:
      EXIT(Aggregation);
    END;

    LOCAL PROCEDURE Operator2Aggregation@24(Operator@1000 : Integer) : Integer;
    BEGIN
      // Retrieve from XML (BLOB) to rec
      EXIT(Operator);
    END;

    [Internal]
    PROCEDURE GetQueryColumnList@37(VAR TempGenericChartQueryColumn@1000 : TEMPORARY Record 9183;ObjID@1017 : Integer;ColFilter@1020 : Integer;FilteringLookup@1001 : Boolean);
    VAR
      ObjectMetadata@1013 : Record 2000000071;
      metaData@1016 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.QueryMetadataReader";
      inStream@1014 : InStream;
    BEGIN
      // Colfilter: = 0: All, 1: Only text etc (X- and Z-Axis), 2: Only decimal and integer (Y-axis)
      CLEAR(TempGenericChartQueryColumn);
      TempGenericChartQueryColumn.DELETEALL;
      IF NOT ObjectMetadata.GET(ObjectMetadata."Object Type"::Query,ObjID) THEN
        EXIT;
      IF NOT ObjectMetadata.Metadata.HASVALUE THEN
        EXIT;
      ObjectMetadata.CALCFIELDS(Metadata);
      ObjectMetadata.Metadata.CREATEINSTREAM(inStream);
      // Load into Query Metadata Reader and retrieve values
      metaData := metaData.FromStream(inStream);
      LoadQueryColumns(metaData,TempGenericChartQueryColumn,ObjID,ColFilter,FilteringLookup);
    END;

    LOCAL PROCEDURE FilterFieldCategory@4(VAR Field@1000 : Record 2000000041;Category@1001 : Integer;FilteringLookup@1002 : Boolean);
    BEGIN
      WITH Field DO BEGIN
        CASE Category OF
          0:
            SETRANGE(Type);
          1,2:
            SETFILTER(Type,TypeFilterText(Category));
        END;
        SETRANGE(Class);
        IF NOT FilteringLookup THEN
          SETFILTER(Class,'<>%1',Class::FlowFilter);
      END;
    END;

    LOCAL PROCEDURE ValidateChart@14(TempGenericChartSetup@1002 : TEMPORARY Record 9180;VAR TempGenericChartYAxis@1001 : TEMPORARY Record 9182;VAR TempGenericChartFilter@1000 : TEMPORARY Record 9181);
    VAR
      Object@1004 : Record 2000000001;
      DummyAggregation@1003 : 'None,Count,Sum,Min,Max,Avg';
      DummyCaption@1005 : Text[250];
      DummyInt@1006 : Integer;
    BEGIN
      WITH TempGenericChartSetup DO BEGIN
        CASE "Source Type" OF
          "Source Type"::Table:
            Object.SETRANGE(Type,Object.Type::Table);
          "Source Type"::Query:
            Object.SETRANGE(Type,Object.Type::Query);
        END;
        Object.SETRANGE(ID,"Source ID");
        Object.FINDFIRST;
        IF TempGenericChartYAxis.FINDSET THEN
          REPEAT
            ValidateFieldColumn(
              TempGenericChartSetup,DummyInt,TempGenericChartYAxis."Y-Axis Measure Field Name",DummyCaption,2,FALSE,DummyAggregation);
          UNTIL TempGenericChartYAxis.NEXT = 0;
        IF TempGenericChartFilter.FINDSET THEN
          REPEAT
            ValidateFieldColumn(
              TempGenericChartSetup,DummyInt,TempGenericChartFilter."Filter Field Name",DummyCaption,0,TRUE,DummyAggregation);
          UNTIL TempGenericChartFilter.NEXT = 0;
        ValidateFieldColumn(TempGenericChartSetup,DummyInt,"X-Axis Field Name","X-Axis Title",0,FALSE,DummyAggregation);
        ValidateFieldColumn(TempGenericChartSetup,DummyInt,"Z-Axis Field Name","Z-Axis Title",0,FALSE,DummyAggregation);
      END;
    END;

    LOCAL PROCEDURE LoadQueryColumns@16(VAR MetaData@1000 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.QueryMetadataReader";VAR TempGenericChartQueryColumn@1001 : TEMPORARY Record 9183;ObjID@1004 : Integer;FieldTypeFilter@1008 : Integer;FilteringLookup@1006 : Boolean);
    VAR
      FieldParam@1009 : Record 2000000041;
      queryField@1002 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.QueryFields";
      i@1003 : Integer;
      j@1005 : Integer;
      InclInColumns@1007 : Boolean;
    BEGIN
      // Field Type:
      // Category:  0: All, 1: Not integer and decimal, 2: Only integer and decimal
      // String,Integer,Decimal,DateTime
      IF MetaData.Fields.Count = 0 THEN
        EXIT;
      FOR i := 0 TO MetaData.Fields.Count - 1 DO BEGIN
        j := 0;
        queryField := MetaData.Fields.Item(i);
        InclInColumns := FALSE;
        IF FilteringLookup OR NOT queryField.IsFilterOnly THEN
          InclInColumns := SetInclInColumns(FieldTypeFilter,queryField.TableNo,queryField.FieldNo,FieldParam);
        IF InclInColumns THEN BEGIN
          CLEAR(TempGenericChartQueryColumn);
          TempGenericChartQueryColumn."Query No." := ObjID;
          TempGenericChartQueryColumn."Query Column No." := queryField.ColumnId;
          TempGenericChartQueryColumn."Column Name" := queryField.FieldName;
          TempGenericChartQueryColumn.SetAggregationType(queryField.AggregationType);
          TempGenericChartQueryColumn.SetColumnDataType(FieldParam.Type);
          REPEAT
            j += 1;
            TempGenericChartQueryColumn."Entry No." := j;
          UNTIL TempGenericChartQueryColumn.INSERT;
        END;
      END;
    END;

    [Internal]
    PROCEDURE CopyChart@5(VAR SourceChart@1000 : Record 2000000078;TargetChartID@1001 : Code[20];TargetChartTitle@1002 : Text[50]);
    VAR
      TargetChart@1003 : Record 2000000078;
    BEGIN
      CLEAR(TargetChart);
      TargetChart := SourceChart;
      TargetChart.VALIDATE(ID,TargetChartID);
      IF TargetChartTitle <> '' THEN
        TargetChart.VALIDATE(Name,TargetChartTitle)
      ELSE
        TargetChart.VALIDATE(Name,SourceChart.Name);
      TargetChart.INSERT(TRUE);
    END;

    LOCAL PROCEDURE GetChartBuilder@10(VAR Chart@1000 : Record 2000000078;VAR chartBuilder@1001 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartBuilder") : Boolean;
    VAR
      InStream@1002 : InStream;
    BEGIN
      IF NOT Chart.BLOB.HASVALUE THEN
        EXIT(FALSE);
      Chart.CALCFIELDS(BLOB);
      Chart.BLOB.CREATEINSTREAM(InStream);
      chartBuilder := chartBuilder.FromStream(InStream);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE BuildFilterText@17(VAR FilterText@1000 : Text[250];Inp@1001 : Text[100]);
    BEGIN
      IF FilterText <> '' THEN
        AddToFilterText(FilterText,COPYSTR(' ; ' + Inp,1,MAXSTRLEN(FilterText)))
      ELSE
        AddToFilterText(FilterText,COPYSTR(Inp,1,MAXSTRLEN(FilterText)));
    END;

    LOCAL PROCEDURE AddToFilterText@18(VAR FText@1000 : Text[250];Inp@1001 : Text[100]);
    VAR
      RemLgth@1002 : Integer;
    BEGIN
      IF STRLEN(FText + Inp) <= MAXSTRLEN(FText) THEN BEGIN
        FText := FText + Inp;
        EXIT;
      END;
      RemLgth := MAXSTRLEN(FText) - STRLEN(FText);
      IF RemLgth > 3 THEN
        FText := FText + ',...'
      ELSE
        FText := PADSTR(FText,MAXSTRLEN(FText),'.');
    END;

    [External]
    PROCEDURE FinalizeFilterText@9(VAR InTxt@1000 : Text[250]);
    BEGIN
      IF InTxt = '' THEN
        InTxt := Text002;
    END;

    [Internal]
    PROCEDURE GetDescription@7(Chart@1000 : Record 2000000078) : Text;
    VAR
      chartBuilder@1001 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartBuilder";
    BEGIN
      IF NOT GetChartBuilder(Chart,chartBuilder) THEN
        EXIT('');
      EXIT(chartBuilder.Description);
    END;

    [Internal]
    PROCEDURE ChartCustomization@20(VAR TempChart@1000 : TEMPORARY Record 2000000078) : Boolean;
    BEGIN
      TempChart.INSERT;
      IF NoOfMeasuresApplied(TempChart) > GetMaxNoOfMeasures THEN BEGIN
        MESSAGE(Text003,GetMaxNoOfMeasures);
        EXIT(FALSE);
      END;
      EXIT(PAGE.RUNMODAL(PAGE::"Generic Chart Customization",TempChart) = ACTION::LookupOK);
    END;

    LOCAL PROCEDURE NoOfMeasuresApplied@32(VAR TempChart@1000 : Record 2000000078) : Integer;
    VAR
      chartBuilder@1001 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartBuilder";
    BEGIN
      IF NOT GetChartBuilder(TempChart,chartBuilder) THEN
        EXIT(0);
      EXIT(chartBuilder.MeasureCount);
    END;

    LOCAL PROCEDURE GetMaxNoOfMeasures@27() : Integer;
    BEGIN
      EXIT(6); // Max number of measures allowed when using the Chart Design pages 9183, 9188
    END;

    LOCAL PROCEDURE GetFieldColumnNoName@28(SourceType@1004 : ' ,Table,Query';SourceNo@1000 : Integer;VAR FieldColNo@1001 : Integer;VAR FieldColName@1003 : Text;FilteringLookup@1007 : Boolean);
    VAR
      TempGenericChartQueryColumn@1006 : TEMPORARY Record 9183;
      Field@1002 : Record 2000000041;
      Found@1005 : Boolean;
    BEGIN
      CASE SourceType OF
        SourceType::Table:
          WITH Field DO
            IF FieldColNo > 0 THEN BEGIN
              FieldColName := '';
              IF GET(SourceNo,FieldColNo) THEN
                FieldColName := FieldName;
            END ELSE BEGIN
              SETRANGE(TableNo,SourceNo);
              IF FINDSET THEN
                REPEAT
                  IF UPPERCASE(FieldName) = UPPERCASE(FieldColName) THEN BEGIN
                    Found := TRUE;
                    FieldColNo := "No.";
                  END;
                UNTIL (NEXT = 0) OR Found;
            END;
        SourceType::Query:
          BEGIN
            GetQueryColumnList(TempGenericChartQueryColumn,SourceNo,0,FilteringLookup);
            WITH TempGenericChartQueryColumn DO
              IF FieldColNo > 0 THEN BEGIN
                FieldColName := '';
                SETRANGE("Query Column No.",FieldColNo);
                IF FINDFIRST THEN
                  FieldColName := "Column Name";
              END ELSE BEGIN
                IF FINDSET THEN
                  REPEAT
                    IF UPPERCASE("Column Name") = UPPERCASE(FieldColName) THEN BEGIN
                      Found := TRUE;
                      FieldColNo := "Query Column No.";
                    END;
                  UNTIL (NEXT = 0) OR Found;
              END;
          END;
      END;
    END;

    LOCAL PROCEDURE GetSourceIDName@31(SourceType@1000 : ' ,Table,Query';VAR SourceID@1001 : Integer;VAR SourceName@1002 : Text);
    VAR
      Object@1003 : Record 2000000001;
    BEGIN
      WITH Object DO BEGIN
        CASE SourceType OF
          SourceType::Table:
            SETRANGE(Type,Type::Table);
          SourceType::Query:
            SETRANGE(Type,Type::Query);
        END;
        IF SourceID > 0 THEN BEGIN
          SETRANGE(ID,SourceID);
          FINDFIRST;
          SourceName := Name;
          EXIT;
        END;
        IF SourceName <> '' THEN BEGIN
          SETRANGE(Name,SourceName);
          FINDFIRST;
          SourceID := ID;
        END;
      END;
    END;

    LOCAL PROCEDURE BuildTempGenericChartFilter@29(TempGenericChartSetup@1001 : TEMPORARY Record 9180;VAR TempGenericChartFilter@1000 : TEMPORARY Record 9181;VAR chartBuilder@1003 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartBuilder";VAR FilterText@1004 : Text[250]);
    VAR
      i@1002 : Integer;
    BEGIN
      WITH TempGenericChartFilter DO BEGIN
        DELETEALL;
        CASE TempGenericChartSetup."Source Type" OF
          TempGenericChartSetup."Source Type"::Table:
            FOR i := 0 TO chartBuilder.TableFilterCount - 1 DO BEGIN
              INIT;
              ID := TempGenericChartSetup.ID;
              "Line No." := i + 1;
              "Filter Field ID" := chartBuilder.GetTableFilterFieldId(i);
              "Filter Field Name" := chartBuilder.GetTableFilterFieldName(i);
              GetFieldColumnNoName(
                TempGenericChartSetup."Source Type",TempGenericChartSetup."Source ID","Filter Field ID","Filter Field Name",TRUE);
              "Filter Value" := chartBuilder.GetTableFilterValue(i);
              IF "Filter Value" <> '' THEN
                BuildFilterText(FilterText,
                  COPYSTR("Filter Field Name" + ' : ' + "Filter Value",1,MAXSTRLEN(FilterText)));
              INSERT;
            END;
          TempGenericChartSetup."Source Type"::Query:
            FOR i := 0 TO chartBuilder.QueryFilterCount - 1 DO BEGIN
              INIT;
              ID := TempGenericChartSetup.ID;
              "Line No." := i + 1;
              "Filter Field ID" := chartBuilder.GetQueryFilterFieldId(i);
              "Filter Field Name" := chartBuilder.GetQueryFilterFieldName(i);
              GetFieldColumnNoName(
                TempGenericChartSetup."Source Type",TempGenericChartSetup."Source ID","Filter Field ID","Filter Field Name",TRUE);
              "Filter Value" := chartBuilder.GetQueryFilterValue(i);
              IF "Filter Value" <> '' THEN
                BuildFilterText(FilterText,
                  COPYSTR("Filter Field Name" + ' : ' + "Filter Value",1,MAXSTRLEN(FilterText)));
              INSERT;
            END;
        END;
      END;
    END;

    LOCAL PROCEDURE SetInclInColumns@30(FilterType@1000 : Integer;TableNumber@1001 : Integer;FieldNumber@1002 : Integer;VAR FieldType@1004 : Record 2000000041) : Boolean;
    VAR
      Field@1003 : Record 2000000041;
    BEGIN
      IF FieldNumber < 0 THEN
        EXIT(FALSE);
      IF FieldNumber = 0 THEN
        EXIT(FilterType IN [0,2]); // The column method is Count which is a numeral
      WITH Field DO BEGIN
        SETRANGE(TableNo,TableNumber);
        SETRANGE("No.",FieldNumber);
        IF FilterType > 0 THEN
          SETFILTER(Type,TypeFilterText(FilterType));
        IF FINDFIRST THEN BEGIN
          FieldType.Type := Type;
          EXIT(TRUE);
        END;
        EXIT(FALSE);
      END;
    END;

    LOCAL PROCEDURE TypeFilterText@26(Category@1000 : Integer) : Text;
    VAR
      DummyField@1001 : Record 2000000041;
    BEGIN
      WITH DummyField DO
        CASE Category OF
          1:
            EXIT(
              STRSUBSTNO(
                '%1|%2|%3|%4|%5|%6|%7',Type::Date,Type::Time,Type::DateFormula,Type::Text,Type::Code,Type::Option,Type::DateTime));
          2:
            EXIT(STRSUBSTNO('%1|%2|%3|%4|%5',Type::Decimal,Type::Binary,Type::Integer,Type::BigInteger,Type::Duration));
        END;
    END;

    [External]
    PROCEDURE CheckSourceTypeID@25(TempGenericChartSetup@1000 : TEMPORARY Record 9180;CheckSourceID@1001 : Boolean);
    BEGIN
      WITH TempGenericChartSetup DO BEGIN
        IF "Source Type" = "Source Type"::" " THEN
          ERROR(Text001,FIELDCAPTION("Source Type"));
        IF CheckSourceID THEN
          IF "Source ID" = 0 THEN
            ERROR(Text001,FIELDCAPTION("Source ID"));
      END;
    END;

    [Internal]
    PROCEDURE GetQueryCountColumnName@33(VAR TempGenericChartSetup@1000 : TEMPORARY Record 9180) : Text[50];
    VAR
      TempGenericChartQueryColumn@1001 : TEMPORARY Record 9183;
    BEGIN
      IF TempGenericChartSetup."Source Type" <> TempGenericChartSetup."Source Type"::Query THEN
        EXIT('');
      GetQueryColumnList(TempGenericChartQueryColumn,TempGenericChartSetup."Source ID",0,TRUE);
      TempGenericChartQueryColumn.SETRANGE("Aggregation Type",TempGenericChartQueryColumn."Aggregation Type"::Count);
      IF NOT TempGenericChartQueryColumn.FINDFIRST THEN
        ERROR(Text004);
      EXIT(TempGenericChartQueryColumn."Column Name");
    END;

    [Internal]
    PROCEDURE CheckDataTypeAggregationCompliance@34(TempGenericChartSetup@1002 : TEMPORARY Record 9180;ColumnName@1000 : Text[50];Aggregation@1001 : 'None,Count,Sum,Min,Max,Avg');
    VAR
      TempGenericChartQueryColumn@1003 : TEMPORARY Record 9183;
    BEGIN
      WITH TempGenericChartSetup DO BEGIN
        IF "Source Type" <> "Source Type"::Query THEN
          EXIT;
        IF ColumnName = '' THEN
          EXIT;
        IF Aggregation IN [Aggregation::None,Aggregation::Count] THEN
          EXIT;
        GetQueryColumnList(TempGenericChartQueryColumn,"Source ID",0,FALSE);
        TempGenericChartQueryColumn.SETRANGE("Column Name",ColumnName);
        IF NOT TempGenericChartQueryColumn.FINDFIRST THEN
          EXIT;
        ValidateCompliance(TempGenericChartQueryColumn."Column Data Type",Aggregation);
      END;
    END;

    LOCAL PROCEDURE ValidateCompliance@35(ColumnDataType@1000 : 'Date,Time,DateFormula,Decimal,Text,Code,Binary,Boolean,Integer,Option,BigInteger,DateTime';Aggregation@1001 : 'None,Count,Sum,Min,Max,Avg');
    BEGIN
      IF NOT (Aggregation IN [Aggregation::Sum,Aggregation::Min,Aggregation::Max,Aggregation::Avg]) THEN
        EXIT;
      IF ColumnDataType <> ColumnDataType::Decimal THEN
        ERROR(Text005,SELECTSTR(Aggregation + 1,AggregationTxt));
    END;

    [External]
    PROCEDURE TextMLAssistEdit@36(VAR TempGenericChartCaptionsBuf@1000 : TEMPORARY Record 9185;CaptionCode@1003 : Code[10]) : Text[250];
    VAR
      GenericChartTextEditor@1002 : Page 9185;
    BEGIN
      EXIT(GenericChartTextEditor.AssistEdit(TempGenericChartCaptionsBuf,CaptionCode))
    END;

    [External]
    PROCEDURE MemoMLAssistEdit@48(VAR TempGenericChartMemoBuf@1000 : TEMPORARY Record 9186;MemoCode@1003 : Code[10]) : Text;
    VAR
      GenericChartMemoEditor@1002 : Page 9189;
    BEGIN
      EXIT(GenericChartMemoEditor.AssistEdit(TempGenericChartMemoBuf,MemoCode))
    END;

    LOCAL PROCEDURE BuildMultilanguageText@38(VAR TempGenericChartCaptionsBuf@1000 : TEMPORARY Record 9185;CaptionCode@1004 : Code[10];VAR MultilanguageText@1001 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartMultiLanguageText");
    VAR
      Language@1003 : Record 8;
    BEGIN
      MultilanguageText := MultilanguageText.BusinessChartMultiLanguageText;
      TempGenericChartCaptionsBuf.SETRANGE(Code,CaptionCode);
      IF TempGenericChartCaptionsBuf.FINDSET THEN
        REPEAT
          Language.SETRANGE(Code,TempGenericChartCaptionsBuf."Language Code");
          IF Language.FINDFIRST THEN
            MultilanguageText.SetText(Language."Windows Language ID",TempGenericChartCaptionsBuf.Caption);
        UNTIL TempGenericChartCaptionsBuf.NEXT = 0;
      TempGenericChartCaptionsBuf.SETRANGE(Code)
    END;

    LOCAL PROCEDURE BuildCaptionBuf@49(VAR TempGenericChartCaptionsBuf@1000 : TEMPORARY Record 9185;CaptionCode@1004 : Code[10];MultilanguageText@1001 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartMultiLanguageText");
    VAR
      Language@1006 : Record 8;
      Index@1005 : Integer;
    BEGIN
      TempGenericChartCaptionsBuf.SETRANGE(Code,CaptionCode);
      TempGenericChartCaptionsBuf.DELETEALL;
      TempGenericChartCaptionsBuf.Code := CaptionCode;
      FOR Index := 0 TO MultilanguageText.Count - 1 DO BEGIN
        Language.SETRANGE("Windows Language ID",MultilanguageText.GetWindowsLanguageIdAt(Index));
        IF Language.FINDFIRST THEN BEGIN
          TempGenericChartCaptionsBuf."Language Code" := Language.Code;
          TempGenericChartCaptionsBuf.Caption := MultilanguageText.GetTextAt(Index);
          IF TempGenericChartCaptionsBuf.INSERT THEN;
        END;
      END;
      TempGenericChartCaptionsBuf.SETRANGE(Code)
    END;

    LOCAL PROCEDURE BuildMemoMultilanguageText@52(VAR TempGenericChartMemoBuf@1000 : TEMPORARY Record 9186;MemoCode@1004 : Code[10];VAR MultilanguageText@1001 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartMultiLanguageText");
    VAR
      Language@1002 : Record 8;
    BEGIN
      MultilanguageText := MultilanguageText.BusinessChartMultiLanguageText;
      TempGenericChartMemoBuf.SETRANGE(Code,MemoCode);
      IF TempGenericChartMemoBuf.FINDSET THEN
        REPEAT
          Language.SETRANGE(Code,TempGenericChartMemoBuf."Language Code");
          IF Language.FINDFIRST THEN
            MultilanguageText.SetText(Language."Windows Language ID",TempGenericChartMemoBuf.GetMemoText);
        UNTIL TempGenericChartMemoBuf.NEXT = 0;
      TempGenericChartMemoBuf.SETRANGE(Code)
    END;

    LOCAL PROCEDURE BuildMemoBuf@50(VAR TempGenericChartMemoBuf@1000 : TEMPORARY Record 9186;MemoCode@1004 : Code[10];MultilanguageText@1001 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartMultiLanguageText");
    VAR
      Language@1006 : Record 8;
      Index@1005 : Integer;
    BEGIN
      TempGenericChartMemoBuf.SETRANGE(Code,MemoCode);
      TempGenericChartMemoBuf.DELETEALL;
      TempGenericChartMemoBuf.Code := MemoCode;
      FOR Index := 0 TO MultilanguageText.Count - 1 DO BEGIN
        Language.SETRANGE("Windows Language ID",MultilanguageText.GetWindowsLanguageIdAt(Index));
        IF Language.FINDFIRST THEN BEGIN
          TempGenericChartMemoBuf."Language Code" := Language.Code;
          TempGenericChartMemoBuf.SetMemoText(MultilanguageText.GetTextAt(Index));
          IF TempGenericChartMemoBuf.INSERT THEN;
        END;
      END;
      TempGenericChartMemoBuf.SETRANGE(Code);
    END;

    [External]
    PROCEDURE GetUserLanguage@22() : Code[10];
    VAR
      Language@1000 : Record 8;
    BEGIN
      EXIT(Language.GetUserLanguage)
    END;

    [External]
    PROCEDURE DescriptionCode@39() : Code[10];
    BEGIN
      EXIT(DescriptionTok)
    END;

    [External]
    PROCEDURE XAxisTitleCode@40() : Code[10];
    BEGIN
      EXIT(XAxisTitleTok)
    END;

    [External]
    PROCEDURE YAxisTitleCode@41() : Code[10];
    BEGIN
      EXIT(YAxisTitleTok)
    END;

    LOCAL PROCEDURE ZAxisTitleCode@58() : Code[10];
    BEGIN
      EXIT(ZAxisTitleTok)
    END;

    [External]
    PROCEDURE XAxisCaptionCode@53() : Code[10];
    BEGIN
      EXIT(XAxisCaptionTok)
    END;

    [External]
    PROCEDURE ZAxisCaptionCode@51() : Code[10];
    BEGIN
      EXIT(ZAxisCaptionTok)
    END;

    [External]
    PROCEDURE RequiredMeasureCode@42() : Code[10];
    BEGIN
      EXIT(RequiredTok)
    END;

    [External]
    PROCEDURE OptionalMeasure1Code@47() : Code[10];
    BEGIN
      EXIT(Optional1Tok)
    END;

    [External]
    PROCEDURE OptionalMeasure2Code@46() : Code[10];
    BEGIN
      EXIT(Optional2Tok)
    END;

    [External]
    PROCEDURE OptionalMeasure3Code@45() : Code[10];
    BEGIN
      EXIT(Optional3Tok)
    END;

    [External]
    PROCEDURE OptionalMeasure4Code@44() : Code[10];
    BEGIN
      EXIT(Optional4Tok)
    END;

    [External]
    PROCEDURE OptionalMeasure5Code@43() : Code[10];
    BEGIN
      EXIT(Optional5Tok)
    END;

    BEGIN
    END.
  }
}

