OBJECT Page 6710 OData Column Choose SubForm
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=OData-kolonne - v�lg underformular;
               ENU=OData Column Choose SubForm];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table6711;
    PageType=ListPart;
    SourceTableTemporary=Yes;
    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det feltnavn, der er valgt i datas�ttet.;
                           ENU=Specifies the field name that is selected in the data set.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Include;
                OnValidate=BEGIN
                             IF CalledForExcelExport THEN
                               CheckFieldFilter;
                             IsDirty := TRUE;
                           END;
                            }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver feltnavnene i et datas�t.;
                           ENU=Specifies the field names in a data set.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Field Name";
                Editable=false }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Felttitel;
                           ENU=Field Caption];
                ToolTipML=[DAN=Angiver felttitlerne i et datas�t.;
                           ENU=Specifies the Field Captions in a data set.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Field Caption";
                Editable=false }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Kildetabel;
                           ENU=Source Table];
                ToolTipML=[DAN=Angiver kildetabellen for feltnavnet.;
                           ENU=Specifies the Source Table for the Field Name.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Data Item Caption";
                Editable=FALSE }

  }
  CODE
  {
    VAR
      LoadingXMLErr@1000 : TextConst 'DAN=Der opstod en fejl under indl�sning af objektet.;ENU=There was an error loading the object.';
      TypeHelper@1010 : Codeunit 10;
      RecRef@1004 : RecordRef;
      ColumnList@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.List`1";
      SourceObjectType@1007 : ',,,,,,,,Page,Query';
      ActionType@1001 : 'Create a new data set,Create a copy of an existing data set,Edit an existing data set';
      SourceServiceName@1003 : Text;
      SourceObjectID@1002 : Integer;
      IsDirty@1006 : Boolean;
      CheckFieldErr@1008 : TextConst 'DAN=Du kan ikke udelade dette felt i markeringen p� grund af et anvendt filter.;ENU=You cannot exclude field from selection because of applied filter for it.';
      CalledForExcelExport@1009 : Boolean;

    PROCEDURE InitColumns@1(ObjectType@1000 : ',,,,,,,,Page,Query';ObjectID@1005 : Integer;InActionType@1003 : 'Create a new data set,Create a copy of an existing data set,Edit an existing data set';InSourceServiceName@1004 : Text;DestinationServiceName@1006 : Text);
    VAR
      ObjectMetadata@1001 : Record 2000000071;
      inStream@1002 : InStream;
    BEGIN
      IF FINDFIRST THEN
        EXIT;

      ActionType := InActionType;
      SourceObjectType := ObjectType;
      SourceServiceName := InSourceServiceName;
      SourceObjectID := ObjectID;
      DestinationServiceName := DestinationServiceName;

      IF NOT ObjectMetadata.GET(SourceObjectType,SourceObjectID) THEN
        EXIT;
      IF NOT ObjectMetadata.Metadata.HASVALUE THEN
        EXIT;

      ObjectMetadata.CALCFIELDS(Metadata);
      ObjectMetadata.Metadata.CREATEINSTREAM(inStream,TEXTENCODING::Windows);
      IF SourceObjectType = SourceObjectType::Query THEN
        InitColumnsForQuery(inStream)
      ELSE
        IF SourceObjectType = SourceObjectType::Page THEN
          InitColumnsForPage(inStream);

      CLEAR(Rec);
      CurrPage.UPDATE;
    END;

    PROCEDURE GetColumns@2(VAR TempTenantWebServiceColumns@1000 : TEMPORARY Record 6711);
    BEGIN
      SETRANGE(Include,TRUE);
      IF FINDFIRST THEN
        REPEAT
          TempTenantWebServiceColumns.TRANSFERFIELDS(Rec);
          TempTenantWebServiceColumns.INSERT;

        UNTIL NEXT = 0;
      RESET;
    END;

    LOCAL PROCEDURE InitColumnsForQuery@3(queryStream@1000 : InStream);
    VAR
      queryField@1003 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.QueryFields";
      metaData@1002 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.QueryMetadataReader";
      i@1001 : Integer;
      OldTableNo@1004 : Integer;
    BEGIN
      // Load into Query Metadata Reader and retrieve values
      metaData := metaData.FromStream(queryStream);
      IF metaData.Fields.Count = 0 THEN
        EXIT;
      FOR i := 0 TO metaData.Fields.Count - 1 DO BEGIN
        queryField := metaData.Fields.Item(i);
        IF OldTableNo <> queryField.TableNo THEN
          ColumnList := ColumnList.List;
        OldTableNo := queryField.TableNo;
        CLEAR(Rec);
        IF NOT queryField.IsFilterOnly THEN
          InsertRecord(queryField.TableNo,queryField.FieldNo,queryField.FieldName,FALSE);
      END;
    END;

    LOCAL PROCEDURE InitColumnsForPage@4(pageStream@1000 : InStream);
    VAR
      FieldsTable@1017 : Record 2000000041;
      XMLDOMManagement@1001 : Codeunit 6224;
      ODataUtility@1018 : Codeunit 6710;
      XmlDocument@1002 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      XmlNodeList@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNodeList";
      XmlNode@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      XmlAttribute@1006 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlAttribute";
      AttributesCollection@1009 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlAttributeCollection";
      NodeListEnum@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      CollectionAttributeEnum@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      PageStreamText@1011 : Text;
      XmlText@1012 : Text;
      SourceTableText@1010 : Text;
      FieldIDText@1013 : Text;
      FieldNameText@1015 : Text;
      ValidTag@1016 : Boolean;
      ColumnVisible@1019 : Boolean;
    BEGIN
      WHILE NOT pageStream.EOS DO BEGIN
        CLEAR(PageStreamText);
        pageStream.READTEXT(PageStreamText);
        XmlText := XmlText + PageStreamText;
      END;

      XmlDocument := XmlDocument.XmlDocument;
      IF NOT XMLDOMManagement.LoadXMLDocumentFromText(XmlText,XmlDocument)THEN
        ERROR(LoadingXMLErr);

      XmlNodeList := XmlDocument.GetElementsByTagName('SourceObject');
      IF XmlNodeList.Count <> 1 THEN
        ERROR(LoadingXMLErr);

      NodeListEnum := XmlNodeList.GetEnumerator;
      NodeListEnum.MoveNext;
      XmlNode := NodeListEnum.Current;
      AttributesCollection := XmlNode.Attributes;
      CollectionAttributeEnum := AttributesCollection.GetEnumerator;
      WHILE CollectionAttributeEnum.MoveNext DO BEGIN
        XmlAttribute := CollectionAttributeEnum.Current;
        IF XmlAttribute.Name = 'SourceTable' THEN
          SourceTableText := XmlAttribute.Value;
      END;

      XmlNodeList := XmlDocument.GetElementsByTagName('Controls');
      NodeListEnum := XmlNodeList.GetEnumerator;
      ColumnList := ColumnList.List;
      WHILE NodeListEnum.MoveNext DO BEGIN
        ValidTag := FALSE;
        FieldIDText := '';
        FieldNameText := '';
        ColumnVisible := TRUE;

        XmlNode := NodeListEnum.Current;
        AttributesCollection := XmlNode.Attributes;
        CollectionAttributeEnum := AttributesCollection.GetEnumerator;
        WHILE CollectionAttributeEnum.MoveNext DO BEGIN
          XmlAttribute := CollectionAttributeEnum.Current;

          IF (XmlAttribute.Name = 'xsi:type') AND (XmlAttribute.Value = 'ControlDefinition') THEN
            ValidTag := TRUE;

          IF XmlAttribute.Name = 'Name' THEN
            FieldNameText := XmlAttribute.Value;

          IF XmlAttribute.Name = 'DataColumnName' THEN
            FieldIDText := XmlAttribute.Value;

          IF ActionType = ActionType::"Create a new data set" THEN
            IF (XmlAttribute.Name = 'Visible') AND (XmlAttribute.Value = 'FALSE') THEN
              ColumnVisible := FALSE;

          IF STRPOS(FieldIDText,'Control') > 0 THEN
            ValidTag := FALSE;
        END;

        IF ValidTag THEN BEGIN
          EVALUATE(FieldsTable.TableNo,SourceTableText);
          EVALUATE(FieldsTable."No.",FieldIDText);
          IF TypeHelper.GetField(FieldsTable.TableNo,FieldsTable."No.",FieldsTable) THEN BEGIN
            IF FieldNameText = '' THEN
              FieldNameText := FieldsTable.FieldName;

            // Convert to OData compatible name.
            FieldNameText := ODataUtility.ConvertNavFieldNameToOdataName(FieldNameText);
            InsertRecord(FieldsTable.TableNo,FieldsTable."No.",FieldNameText,ColumnVisible);
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE InsertRecord@7(TableNo@1000 : Integer;FieldNo@1001 : Integer;FieldName@1002 : Text;IncludeParam@1003 : Boolean);
    BEGIN
      IF ColumnList.Contains(FieldNo) THEN
        EXIT;

      INIT;
      VALIDATE("Data Item",TableNo);
      VALIDATE("Field Number",FieldNo);
      VALIDATE("Field Name",COPYSTR(FieldName,1));
      IF (ActionType = ActionType::"Create a copy of an existing data set") OR
         (ActionType = ActionType::"Edit an existing data set")
      THEN BEGIN
        IF SourceColumnExists(TableNo,FieldNo) THEN
          Include := TRUE;
      END ELSE
        Include := IncludeParam;
      REPEAT
        "Entry ID" := "Entry ID" + 1;
      UNTIL INSERT(TRUE);

      ColumnList.Add(FieldNo);
    END;

    PROCEDURE DeleteColumns@5();
    BEGIN
      CLEAR(Rec);
      DELETEALL;
    END;

    LOCAL PROCEDURE SourceColumnExists@9(TableNo@1000 : Integer;FieldNumber@1001 : Integer) : Boolean;
    VAR
      TenantWebService@1002 : Record 2000000168;
      TenantWebServiceColumns@1003 : Record 6711;
    BEGIN
      TenantWebService.INIT;
      IF TenantWebService.GET(SourceObjectType,SourceServiceName) THEN BEGIN
        TenantWebServiceColumns.INIT;
        TenantWebServiceColumns.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
        TenantWebServiceColumns.SETRANGE("Field Number",FieldNumber);
        TenantWebServiceColumns.SETRANGE("Data Item",TableNo);
        IF TenantWebServiceColumns.FINDFIRST THEN
          EXIT(TRUE);
      END;
    END;

    PROCEDURE IncludeIsChanged@8() : Boolean;
    VAR
      LocalDirty@1000 : Boolean;
    BEGIN
      LocalDirty := IsDirty;
      CLEAR(IsDirty);
      EXIT(LocalDirty);
    END;

    PROCEDURE SetCalledForExcelExport@6(VAR SourceRecRef@1000 : RecordRef);
    BEGIN
      CalledForExcelExport := TRUE;
      RecRef := SourceRecRef;
    END;

    LOCAL PROCEDURE CheckFieldFilter@12();
    VAR
      FieldRef@1000 : FieldRef;
    BEGIN
      IF NOT Include THEN BEGIN
        FieldRef := RecRef.FIELD("Field Number");
        IF FieldRef.GETFILTER <> '' THEN
          ERROR(CheckFieldErr);
      END;
    END;

    BEGIN
    END.
  }
}

