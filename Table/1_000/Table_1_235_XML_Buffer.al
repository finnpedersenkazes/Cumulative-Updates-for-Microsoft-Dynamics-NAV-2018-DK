OBJECT Table 1235 XML Buffer
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=XML-buffer;
               ENU=XML Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Element,Attribut";
                                                                    ENU=" ,Element,Attribute"];
                                                   OptionString=[ ,Element,Attribute] }
    { 3   ;   ;Name                ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 4   ;   ;Path                ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sti;
                                                              ENU=Path] }
    { 5   ;   ;Value               ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V�rdi;
                                                              ENU=Value] }
    { 6   ;   ;Depth               ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dybde;
                                                              ENU=Depth] }
    { 7   ;   ;Parent Entry No.    ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Overordnet posteringsnr.;
                                                              ENU=Parent Entry No.] }
    { 8   ;   ;Is Parent           ;Boolean       ;ObsoleteState=Pending;
                                                   ObsoleteReason=Is not used anomore;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Er overordnet;
                                                              ENU=Is Parent] }
    { 9   ;   ;Data Type           ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Datatype;
                                                              ENU=Data Type];
                                                   OptionCaptionML=[DAN=Tekst,Dato,Decimal,Dato/klokkesl�t;
                                                                    ENU=Text,Date,Decimal,DateTime];
                                                   OptionString=Text,Date,Decimal,DateTime }
    { 10  ;   ;Code                ;Code20        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Is not used anymore;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code] }
    { 11  ;   ;Node Name           ;Text250       ;ObsoleteState=Pending;
                                                   ObsoleteReason=Is not used anymore;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nodenavn;
                                                              ENU=Node Name] }
    { 12  ;   ;Has Attributes      ;Boolean       ;ObsoleteState=Pending;
                                                   ObsoleteReason=Is not used anymore;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Har attributter;
                                                              ENU=Has Attributes];
                                                   Editable=No }
    { 13  ;   ;Node Number         ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nodenummer;
                                                              ENU=Node Number] }
    { 14  ;   ;Namespace           ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Navneomr�de;
                                                              ENU=Namespace] }
    { 15  ;   ;Import ID           ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indl�s id;
                                                              ENU=Import ID] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Parent Entry No.,Type,Node Number        }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [Internal]
    PROCEDURE Load@1(StreamOrServerFile@1002 : Variant);
    VAR
      XMLBufferWriter@1000 : Codeunit 1235;
    BEGIN
      XMLBufferWriter.InitializeXMLBufferFrom(Rec,StreamOrServerFile);
    END;

    [Internal]
    PROCEDURE LoadFromText@10(XmlText@1001 : Text);
    VAR
      XMLBufferWriter@1000 : Codeunit 1235;
    BEGIN
      XMLBufferWriter.InitializeXMLBufferFromText(Rec,XmlText);
    END;

    [Internal]
    PROCEDURE Upload@12() : Boolean;
    VAR
      FileManagement@1000 : Codeunit 419;
      ServerTempFileName@1001 : Text;
    BEGIN
      ServerTempFileName := FileManagement.UploadFile('','*.xml');
      IF ServerTempFileName = '' THEN
        EXIT(FALSE);
      Load(ServerTempFileName);
      FileManagement.DeleteServerFile(ServerTempFileName);
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE Save@38(ServerFilePath@1000 : Text) : Boolean;
    VAR
      XMLBufferReader@1002 : Codeunit 1239;
    BEGIN
      EXIT(XMLBufferReader.SaveToFile(ServerFilePath,Rec));
    END;

    [Internal]
    PROCEDURE Download@13() Success : Boolean;
    VAR
      FileManagement@1000 : Codeunit 419;
      ServerTempFileName@1001 : Text;
    BEGIN
      ServerTempFileName := FileManagement.ServerTempFileName('xml');
      Save(ServerTempFileName);
      Success := FileManagement.DownloadHandler(ServerTempFileName,'','','','temp.xml');
      FileManagement.DeleteServerFile(ServerTempFileName);
    END;

    [External]
    PROCEDURE CreateRootElement@23(ElementName@1000 : Text[250]);
    VAR
      XMLBufferWriter@1001 : Codeunit 1235;
    BEGIN
      XMLBufferWriter.InsertElement(Rec,Rec,1,1,ElementName,'');
    END;

    [External]
    PROCEDURE AddNamespace@14(NamespacePrefix@1000 : Text[244];NamespacePath@1001 : Text[250]);
    BEGIN
      IF NamespacePrefix = '' THEN
        AddAttribute('xmlns',NamespacePath)
      ELSE
        AddAttribute('xmlns:' + NamespacePrefix,NamespacePath);
    END;

    [External]
    PROCEDURE AddAttribute@7(AttributeName@1001 : Text[250];AttributeValue@1000 : Text[250]);
    VAR
      XMLBufferWriter@1002 : Codeunit 1235;
    BEGIN
      XMLBufferWriter.InsertAttribute(Rec,Rec,CountAttributes + 1,Depth + 1,AttributeName,AttributeValue);
      GetParent;
    END;

    [External]
    PROCEDURE AddGroupElement@3(ElementNameWithNamespace@1001 : Text[250]) : Integer;
    VAR
      XMLBufferWriter@1000 : Codeunit 1235;
    BEGIN
      XMLBufferWriter.InsertElement(Rec,Rec,CountChildElements + 1,Depth + 1,ElementNameWithNamespace,'');
      EXIT("Entry No.");
    END;

    [External]
    PROCEDURE AddGroupElementAt@18(ElementNameWithNamespace@1003 : Text[250];EntryNo@1000 : Integer) : Integer;
    VAR
      XMLBufferWriter@1002 : Codeunit 1235;
      CurrentView@1004 : Text;
      ElementNo@1001 : Integer;
    BEGIN
      CurrentView := GETVIEW;
      GET(EntryNo);
      ElementNo := "Node Number";
      RESET;
      SETRANGE("Parent Entry No.","Parent Entry No.");
      SETFILTER("Node Number",'>=%1',ElementNo);
      IF FINDSET(TRUE) THEN
        REPEAT
          "Node Number" += 1;
          MODIFY;
        UNTIL NEXT = 0;
      GET("Parent Entry No.");
      XMLBufferWriter.InsertElement(Rec,Rec,ElementNo,Depth + 1,ElementNameWithNamespace,'');
      SETVIEW(CurrentView);
      EXIT("Entry No.");
    END;

    [External]
    PROCEDURE AddElement@5(ElementNameWithNamespace@1007 : Text[250];ElementValue@1006 : Text[250]) ElementEntryNo : Integer;
    BEGIN
      ElementEntryNo := AddGroupElement(ElementNameWithNamespace);
      Value := ElementValue;
      MODIFY(TRUE);
      GetParent;
    END;

    [External]
    PROCEDURE AddLastElement@6(ElementNameWithNamespace@1001 : Text[250];ElementValue@1000 : Text[250]) ElementEntryNo : Integer;
    BEGIN
      ElementEntryNo := AddElement(ElementNameWithNamespace,ElementValue);
      GetParent;
    END;

    [External]
    PROCEDURE AddNonEmptyElement@15(ElementNameWithNamespace@1007 : Text[250];ElementValue@1006 : Text[250]) ElementEntryNo : Integer;
    BEGIN
      IF ElementValue = '' THEN
        EXIT;
      ElementEntryNo := AddElement(ElementNameWithNamespace,ElementValue);
    END;

    [External]
    PROCEDURE AddNonEmptyLastElement@17(ElementNameWithNamespace@1007 : Text[250];ElementValue@1006 : Text[250]) ElementEntryNo : Integer;
    BEGIN
      ElementEntryNo := AddNonEmptyElement(ElementNameWithNamespace,ElementValue);
      GetParent;
    END;

    [External]
    PROCEDURE CopyImportFrom@9(VAR TempXMLBuffer@1001 : TEMPORARY Record 1235);
    VAR
      XMLBuffer@1000 : Record 1235;
    BEGIN
      IF TempXMLBuffer.ISTEMPORARY THEN
        COPY(TempXMLBuffer,TRUE)
      ELSE BEGIN
        XMLBuffer.SETRANGE("Import ID",TempXMLBuffer."Import ID");
        IF XMLBuffer.FINDSET THEN
          REPEAT
            Rec := XMLBuffer;
            INSERT;
          UNTIL XMLBuffer.NEXT = 0;
        SETVIEW(TempXMLBuffer.GETVIEW);
      END;
    END;

    [External]
    PROCEDURE CountChildElements@37() NumElements : Integer;
    VAR
      CurrentView@1002 : Text;
    BEGIN
      CurrentView := GETVIEW;
      RESET;
      SETRANGE("Parent Entry No.","Entry No.");
      SETRANGE(Type,Type::Element);
      NumElements := COUNT;
      SETVIEW(CurrentView);
    END;

    [External]
    PROCEDURE CountAttributes@43() NumAttributes : Integer;
    VAR
      CurrentView@1002 : Text;
    BEGIN
      CurrentView := GETVIEW;
      RESET;
      SETRANGE("Parent Entry No.","Entry No.");
      SETRANGE(Type,Type::Attribute);
      NumAttributes := COUNT;
      SETVIEW(CurrentView);
    END;

    [External]
    PROCEDURE FindAttributes@19(VAR TempResultAttributeXMLBuffer@1000 : TEMPORARY Record 1235) : Boolean;
    BEGIN
      EXIT(FindChildNodes(TempResultAttributeXMLBuffer,Type::Attribute,''));
    END;

    [External]
    PROCEDURE FindChildElements@16(VAR TempResultElementXMLBuffer@1000 : TEMPORARY Record 1235) : Boolean;
    BEGIN
      EXIT(FindChildNodes(TempResultElementXMLBuffer,Type::Element,''));
    END;

    [External]
    PROCEDURE FindNodesByXPath@2(VAR TempResultElementXMLBuffer@1000 : TEMPORARY Record 1235;XPath@1002 : Text) : Boolean;
    BEGIN
      TempResultElementXMLBuffer.CopyImportFrom(Rec);

      TempResultElementXMLBuffer.SETRANGE("Import ID","Import ID");
      TempResultElementXMLBuffer.SETRANGE("Parent Entry No.");
      TempResultElementXMLBuffer.SETFILTER(Path,'*' + XPath);
      EXIT(TempResultElementXMLBuffer.FINDSET);
    END;

    [External]
    PROCEDURE GetAttributeValue@50(AttributeName@1000 : Text) : Text[250];
    VAR
      TempXMLBuffer@1002 : TEMPORARY Record 1235;
    BEGIN
      IF FindChildNodes(TempXMLBuffer,Type::Attribute,AttributeName) THEN
        EXIT(TempXMLBuffer.Value);
    END;

    [External]
    PROCEDURE GetElementName@68() : Text;
    BEGIN
      IF Namespace = '' THEN
        EXIT(Name);
      EXIT(Namespace + ':' + Name);
    END;

    [External]
    PROCEDURE GetParent@8() : Boolean;
    BEGIN
      EXIT(GET("Parent Entry No."))
    END;

    [External]
    PROCEDURE HasChildNodes@4() ChildNodesExists : Boolean;
    VAR
      CurrentView@1002 : Text;
    BEGIN
      CurrentView := GETVIEW;
      RESET;
      SETRANGE("Parent Entry No.","Entry No.");
      ChildNodesExists := NOT ISEMPTY;
      SETVIEW(CurrentView);
    END;

    LOCAL PROCEDURE FindChildNodes@11(VAR TempResultXMLBuffer@1003 : TEMPORARY Record 1235;NodeType@1000 : Option;NodeName@1001 : Text) : Boolean;
    BEGIN
      TempResultXMLBuffer.CopyImportFrom(Rec);

      TempResultXMLBuffer.SETRANGE("Parent Entry No.","Entry No.");
      TempResultXMLBuffer.SETRANGE(Path);
      TempResultXMLBuffer.SETRANGE(Type,NodeType);
      IF NodeName <> '' THEN
        TempResultXMLBuffer.SETRANGE(Name,NodeName);
      EXIT(TempResultXMLBuffer.FINDSET);
    END;

    BEGIN
    END.
  }
}

