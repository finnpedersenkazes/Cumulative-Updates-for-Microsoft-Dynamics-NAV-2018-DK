OBJECT Page 9621 Add Page Fields
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[DAN=Nyt felt;
               ENU=New Field];
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table2000000171;
    PageType=NavigatePage;
    SourceTableTemporary=Yes;
    OnOpenPage=VAR
                 DesignerPageId@1000 : Codeunit 9621;
               BEGIN
                 InitializeVariables;
                 PageId := DesignerPageId.GetPageId;
                 RelatedFieldType := RelatedFieldType::"Computed value";
                 CurrentNavigationPage := CurrentNavigationPage::FieldSelectionPage;
               END;

    ActionList=ACTIONS
    {
      { 20      ;    ;ActionContainer;
                      Name=ActionItems;
                      CaptionML=[DAN=ActionItems;
                                 ENU=ActionItems];
                      ActionContainerType=ActionItems }
      { 21      ;1   ;Action    ;
                      Name=Next;
                      CaptionML=[DAN=N�ste;
                                 ENU=Next];
                      ApplicationArea=#Basic,#Suite;
                      Visible=IsNextVisible;
                      InFooterBar=Yes;
                      Image=NextRecord;
                      OnAction=BEGIN
                                 CASE CurrentNavigationPage OF
                                   CurrentNavigationPage::FieldBasicDefinitionPage:
                                     BEGIN
                                       IF NewFieldName = '' THEN
                                         ERROR(MandateFieldNameErr);
                                       LoadRequestedPage(CurrentNavigationPage::FieldAdvancedDefinitionPage);
                                     END;
                                 END;
                               END;
                                }
      { 22      ;1   ;Action    ;
                      Name=Previous;
                      CaptionML=[DAN=Forrige;
                                 ENU=Previous];
                      ApplicationArea=#Basic,#Suite;
                      Visible=IsBackVisible;
                      InFooterBar=Yes;
                      Image=PreviousRecord;
                      OnAction=BEGIN
                                 CASE CurrentNavigationPage OF
                                   CurrentNavigationPage::FieldBasicDefinitionPage:
                                     LoadRequestedPage(CurrentNavigationPage::FieldSelectionPage);
                                   CurrentNavigationPage::FieldAdvancedDefinitionPage:
                                     LoadRequestedPage(CurrentNavigationPage::FieldBasicDefinitionPage);
                                 END;
                               END;
                                }
      { 23      ;1   ;Action    ;
                      Name=Create;
                      CaptionML=[DAN=Opret;
                                 ENU=Create];
                      ApplicationArea=#Basic,#Suite;
                      Visible=IsCreateBtnVisible;
                      InFooterBar=Yes;
                      Image=NextRecord;
                      OnAction=VAR
                                 FieldTypeOptions@1000 : 'Number,Text,Boolean,DateTime,RelatedData,Option';
                               BEGIN
                                 ClearAllDynamicFieldsVisibility;
                                 EVALUATE(FieldTypeOptions,CurrPage.FieldTypes.PAGE.GetSelectedRecType);
                                 CASE FieldTypeOptions OF
                                   FieldTypeOptions::Number:
                                     BEGIN
                                       NewFieldType := 'Integer';
                                       IsNumberFieldTypeVisible := TRUE;
                                       FieldTypeEnumValue := NavDesignerFieldType.Integer;
                                     END;
                                   FieldTypeOptions::Text:
                                     BEGIN
                                       NewFieldType := 'Text';
                                       TextFieldTypeDataLength := 30;
                                       IsTextFieldTypeVisible := TRUE;
                                       FieldTypeEnumValue := NavDesignerFieldType.Text;
                                     END;
                                   FieldTypeOptions::Boolean:
                                     BEGIN
                                       NewFieldType := 'Boolean';
                                       IsFinishBtnVisible := TRUE;
                                       IsNextVisible := FALSE;
                                       FieldTypeEnumValue := NavDesignerFieldType.Boolean;
                                     END;
                                   FieldTypeOptions::DateTime:
                                     BEGIN
                                       NewFieldType := 'Date';
                                       IsDateTimeFieldTypeVisible := TRUE;
                                       FieldTypeEnumValue := NavDesignerFieldType.Date;
                                     END;
                                   FieldTypeOptions::RelatedData:
                                     BEGIN
                                       NewFieldType := 'Related Data Field';
                                       RelatedFieldType := RelatedFieldType::"Linked value";
                                       FilterType := FilterType::FIELD;
                                     END;
                                   FieldTypeOptions::Option:
                                     BEGIN
                                       NewFieldType := 'Option';
                                       IsOptionDetailsVisible := TRUE;
                                       FieldTypeEnumValue := NavDesignerFieldType.Option;
                                     END;
                                 END;
                                 LoadRequestedPage(CurrentNavigationPage::FieldBasicDefinitionPage);
                               END;
                                }
      { 24      ;1   ;Action    ;
                      Name=Finish;
                      CaptionML=[DAN=Udf�r;
                                 ENU=Finish];
                      ApplicationArea=#Basic,#Suite;
                      Visible=IsFinishBtnVisible;
                      InFooterBar=Yes;
                      Image=Approve;
                      OnAction=BEGIN
                                 SaveNewFieldDefinition;
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                Name=PageControl;
                CaptionML=[DAN=Sidestyring;
                           ENU=Page Control];
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=V�lg type;
                           ENU=Select Type];
                Visible=CurrentNavigationPage = CurrentNavigationPage::FieldSelectionPage;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                Name=NewFieldDescription;
                CaptionML=[DAN=N�r du tilf�jer et nyt felt i tabellen, kan du gemme og vise yderligere oplysninger om en datapost.;
                           ENU=By adding a new field to the table you can store and display additional information about a data entry.];
                ApplicationArea=#Basic,#Suite }

    { 4   ;2   ;Part      ;
                Name=FieldTypes;
                CaptionML=[DAN=V�lg feltets type;
                           ENU=Choose type of field];
                ApplicationArea=#Basic,#Suite;
                Description=Choose type of field';
                PagePartID=Page9622;
                Editable=FALSE;
                PartType=Page }

    { 7   ;1   ;Group     ;
                CaptionML=[DAN=Trindetaljer;
                           ENU=Step details];
                Visible=(CurrentNavigationPage = CurrentNavigationPage::FieldBasicDefinitionPage) AND (NewFieldType <> 'Boolean');
                GroupType=Group }

    { 8   ;2   ;Group     ;
                CaptionML=[DAN=Trin 1 af 2;
                           ENU=Step 1 of 2];
                GroupType=Group }

    { 9   ;3   ;Group     ;
                Name=Step1Header;
                CaptionML=[DAN=DEFINITION AF FELT;
                           ENU=FIELD DEFINITION];
                GroupType=Group;
                InstructionalTextML=[DAN=Udfyld oplysninger om det nye felt. Du kan �ndre feltoplysningerne senere, hvis det er n�dvendigt.;
                                     ENU=Fill in information about the new field. You can change the field information later if you need to.] }

    { 10  ;4   ;Field     ;
                Name=NewFieldName;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NewFieldName;
                OnValidate=BEGIN
                             NewFieldCaption := NewFieldName;
                           END;

                ShowMandatory=True }

    { 11  ;4   ;Field     ;
                Name=NewFieldCaption;
                CaptionML=[DAN=Titel;
                           ENU=Caption];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NewFieldCaption }

    { 12  ;4   ;Field     ;
                Name=NewDescription;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NewFieldDescr;
                MultiLine=Yes }

    { 47  ;4   ;Group     ;
                Visible=NewFieldType = 'Related Data Field';
                GroupType=Group }

    { 44  ;5   ;Field     ;
                Name=RelatedFieldType;
                CaptionML=[DAN=Type med tilknyttet v�rdi;
                           ENU=Linked value Type];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=RelatedFieldType;
                OnValidate=BEGIN
                             IF RelatedFieldType = RelatedFieldType::"Linked value" THEN
                               FilterType := FilterType::FIELD;
                           END;
                            }

    { 13  ;1   ;Group     ;
                CaptionML=[DAN=Trin 2;
                           ENU=Step 2];
                Visible=CurrentNavigationPage = CurrentNavigationPage::FieldAdvancedDefinitionPage;
                GroupType=Group }

    { 30  ;2   ;Group     ;
                CaptionML=[DAN=Trin 2 af 2;
                           ENU=Step 2 of 2];
                GroupType=Group;
                InstructionalTextML=[DAN=V�lg, hvordan systemet initialiserer og validere den tekst, der skrives eller inds�ttes i feltet.;
                                     ENU=Choose how the system initializes and validates the text that is typed or pasted into the field.] }

    { 14  ;3   ;Group     ;
                Visible=NewFieldType <> 'Related Data Field';
                GroupType=Group }

    { 19  ;4   ;Group     ;
                Visible=IsNumberFieldTypeVisible;
                GroupType=Group }

    { 5   ;5   ;Field     ;
                Name=NumberFieldType;
                CaptionML=[DAN=Feltdatatype;
                           ENU=Field data type];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NumberFieldTypes;
                OnValidate=BEGIN
                             CASE NumberFieldTypes OF
                               NumberFieldTypes::BigInteger:
                                 BEGIN
                                   NewFieldType := 'BigInteger';
                                   FieldTypeEnumValue := NavDesignerFieldType.BigInteger;
                                 END;
                               NumberFieldTypes::Decimal:
                                 BEGIN
                                   NewFieldType := 'Decimal';
                                   FieldTypeEnumValue := NavDesignerFieldType.Decimal;
                                 END;
                               NumberFieldTypes::Integer:
                                 BEGIN
                                   NewFieldType := 'Integer';
                                   FieldTypeEnumValue := NavDesignerFieldType.Integer;
                                 END;
                             END;
                           END;
                            }

    { 36  ;5   ;Group     ;
                Visible=NumberFieldTypes = NumberFieldTypes::"Decimal";
                GroupType=Group }

    { 37  ;6   ;Field     ;
                Name=Field_NoOfDecimalPlaces;
                CaptionML=[DAN=Antal decimalplaceringer;
                           ENU=Number of decimal places];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                BlankZero=Yes;
                SourceExpr=Field_NoOfDecimalPlaces }

    { 28  ;5   ;Field     ;
                Name=Editable;
                CaptionML=[DAN=Redigerbar;
                           ENU=Editable];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=IsFieldEditable }

    { 29  ;5   ;Field     ;
                Name=IsBlankZero;
                CaptionML=[DAN=Hvis nul vises som tom;
                           ENU=If zero show blank];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=IsBlankZero }

    { 25  ;4   ;Group     ;
                Visible=IsTextFieldTypeVisible;
                GroupType=Group }

    { 6   ;5   ;Field     ;
                Name=TextFieldType;
                CaptionML=[DAN=Feltdatatype;
                           ENU=Field data type];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TextFieldType;
                OnValidate=BEGIN
                             CASE TextFieldType OF
                               TextFieldType::Code:
                                 BEGIN
                                   NewFieldType := 'Code';
                                   FieldTypeEnumValue := NavDesignerFieldType.Code;
                                   TextFieldTypeDataLength := 10;
                                 END;
                               TextFieldType::Text:
                                 BEGIN
                                   NewFieldType := 'Text';
                                   FieldTypeEnumValue := NavDesignerFieldType.Text;
                                   TextFieldTypeDataLength := 30;
                                 END;
                             END;
                           END;
                            }

    { 33  ;5   ;Field     ;
                Name=DataLength;
                CaptionML=[DAN=Tekstl�ngde;
                           ENU=Text Length];
                ApplicationArea=#Basic,#Suite;
                BlankNumbers=BlankZero;
                SourceExpr=TextFieldTypeDataLength }

    { 53  ;5   ;Group     ;
                Visible=TextFieldType = TextFieldType::"Text";
                GroupType=Group }

    { 34  ;5   ;Field     ;
                Name=Editable_text;
                CaptionML=[DAN=Redigerbar;
                           ENU=Editable];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=IsFieldEditable }

    { 26  ;4   ;Group     ;
                Visible=IsDateTimeFieldTypeVisible;
                GroupType=Group }

    { 27  ;5   ;Field     ;
                Name=DateTimeFieldType;
                CaptionML=[DAN=Feltdatatype;
                           ENU=Field data type];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DateTimeFieldType;
                OnValidate=BEGIN
                             CASE DateTimeFieldType OF
                               DateTimeFieldType::Time:
                                 BEGIN
                                   NewFieldType := 'Time';
                                   FieldTypeMessage := TimeFieldDescMsg;
                                   FieldTypeEnumValue := NavDesignerFieldType.Time;
                                 END;
                               DateTimeFieldType::Date:
                                 BEGIN
                                   NewFieldType := 'Date';
                                   FieldTypeMessage := DateFieldDescMsg;
                                   FieldTypeEnumValue := NavDesignerFieldType.Date;
                                 END;
                               DateTimeFieldType::DateTime:
                                 BEGIN
                                   NewFieldType := 'DateTime';
                                   FieldTypeMessage := DateTimeFieldDescMsg;
                                   FieldTypeEnumValue := NavDesignerFieldType.DateTime;
                                 END
                             END;
                           END;
                            }

    { 32  ;5   ;Field     ;
                Name=typeDesc;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=FieldTypeMessage;
                Editable=False;
                MultiLine=Yes;
                ShowCaption=No }

    { 15  ;4   ;Group     ;
                Visible=IsOptionDetailsVisible;
                Editable=True;
                GroupType=Group }

    { 16  ;5   ;Field     ;
                Name=OptionsValue;
                CaptionML=[DAN=Indstillingsv�rdi;
                           ENU=Options Value];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NewOptionsFieldValues }

    { 17  ;5   ;Field     ;
                Name=InitialValue;
                CaptionML=[DAN=Oprindelig v�rdi;
                           ENU=Initial Value];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NewFieldInitialValue }

    { 39  ;3   ;Group     ;
                Visible=NewFieldType = 'Related Data Field';
                GroupType=Group }

    { 42  ;4   ;Group     ;
                CaptionML=[DAN=V�lg den relaterede tabel og derefter det tilh�rende felt.;
                           ENU=Please select the related table and then the corresponding field.];
                GroupType=Group }

    { 41  ;5   ;Field     ;
                Name=TableSearch;
                CaptionML=[DAN=Tabel;
                           ENU=Table];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=RelatedTableName;
                OnValidate=VAR
                             AvailableTables@1000 : Record 2000000136;
                             IsNumber@1001 : Integer;
                           BEGIN
                             IF EVALUATE(IsNumber,RelatedTableName) THEN
                               AvailableTables.SETRANGE(ID,IsNumber)
                             ELSE
                               AvailableTables.SETRANGE(Name,RelatedTableName);

                             IF AvailableTables.FINDFIRST THEN BEGIN
                               RelatedTableNumber := AvailableTables.ID;
                               RelatedTableName := AvailableTables.Name;
                               RelatedTableFilterFieldName := '';
                               RelatedTableFieldName := '';
                             END ELSE
                               IF RelatedTableName = '' THEN BEGIN
                                 RelatedTableFilterFieldName := '';
                                 RelatedTableFieldName := '';
                               END ELSE
                                 ERROR(InvalidTableNumberOrNameErr,RelatedTableName);
                           END;

                OnLookup=VAR
                           AvailableTables@1001 : Record 2000000136;
                         BEGIN
                           IF PAGE.RUNMODAL(PAGE::"Available Table Selection List",AvailableTables) = ACTION::LookupOK THEN BEGIN
                             RelatedTableName := AvailableTables.Name;
                             RelatedTableNumber := AvailableTables.ID;
                             RelatedTableFilterFieldName := '';
                             RelatedTableFieldName := '';
                           END;
                         END;
                          }

    { 43  ;5   ;Field     ;
                Name=FieldName;
                CaptionML=[DAN=Felt;
                           ENU=Field];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=RelatedTableFieldName;
                Editable=RelatedTableName <> '';
                OnValidate=VAR
                             FieldTable@1000 : Record 2000000041;
                           BEGIN
                             FieldTable.SETRANGE("Field Caption",RelatedTableFieldName);
                             FieldTable.SETFILTER(TableNo,FORMAT(RelatedTableNumber));
                             FieldTable.SETFILTER(ObsoleteState,'<>%1',FieldTable.ObsoleteState::Removed);

                             IF FieldTable.FINDFIRST THEN
                               RelatedTableFieldName := FieldTable."Field Caption"
                             ELSE
                               IF RelatedTableFieldName <> '' THEN
                                 ERROR(InvalidRelatedFieldNameErr,RelatedTableFieldName);
                           END;

                OnLookup=VAR
                           FieldTable@1000 : Record 2000000041;
                         BEGIN
                           FieldTable.SETFILTER(TableNo,FORMAT(RelatedTableNumber));
                           FieldTable.SETFILTER(ObsoleteState,'<>%1',FieldTable.ObsoleteState::Removed);
                           IF PAGE.RUNMODAL(PAGE::"Available Field Selection Page",FieldTable) = ACTION::LookupOK THEN
                             RelatedTableFieldName := FieldTable."Field Caption";
                         END;
                          }

    { 40  ;4   ;Group     ;
                Visible=RelatedFieldType = RelatedFieldType::"Computed value";
                GroupType=Group }

    { 45  ;5   ;Field     ;
                Name=Method;
                CaptionML=[DAN=Metode;
                           ENU=Method];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=RelatedFieldMethod }

    { 38  ;5   ;Field     ;
                Name=ReverseSign;
                CaptionML=[DAN=Modsat fortegn;
                           ENU=Reverse Sign];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=RelatedFieldFormulaCalc_ReverseSign }

    { 58  ;4   ;Group     ;
                Name=FilterSection;
                CaptionML=[DAN=RELATEREDE FILTRERINGSKRITERIER FOR TABEL;
                           ENU=RELATED TABLE FILTER CRITERIA];
                Enabled=(RelatedTableName <> '') AND (RelatedTableFieldName <> '');
                GroupType=Group }

    { 56  ;5   ;Field     ;
                Name=RelatedTableFilterField;
                CaptionML=[DAN=Filtreret felt;
                           ENU=Filtered field];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=RelatedTableFilterFieldName;
                OnValidate=VAR
                             FieldTable@1000 : Record 2000000041;
                           BEGIN
                             FieldTable.SETRANGE("Field Caption",RelatedTableFilterFieldName);
                             FieldTable.SETFILTER(TableNo,FORMAT(RelatedTableNumber));
                             FieldTable.SETFILTER(ObsoleteState,'<>%1',FieldTable.ObsoleteState::Removed);
                             IF FieldTable.FINDFIRST THEN
                               FieldType := FORMAT(FieldTable.Type)
                             ELSE
                               IF RelatedTableFilterFieldName <> '' THEN
                                 ERROR(InvalidRelatedFieldNameErr,RelatedTableFilterFieldName);
                           END;

                OnLookup=VAR
                           FieldTable@1000 : Record 2000000041;
                         BEGIN
                           FieldTable.SETFILTER(TableNo,FORMAT(RelatedTableNumber));
                           FieldTable.SETFILTER(ObsoleteState,'<>%1',FieldTable.ObsoleteState::Removed);
                           IF PAGE.RUNMODAL(PAGE::"Available Field Selection Page",FieldTable) = ACTION::LookupOK THEN BEGIN
                             RelatedTableFilterFieldName := FieldTable."Field Caption";
                             FieldType := FORMAT(FieldTable.Type);
                           END;
                         END;
                          }

    { 48  ;5   ;Group     ;
                Visible=RelatedFieldType = RelatedFieldType::"Computed value";
                GroupType=Group }

    { 54  ;6   ;Field     ;
                Name=Filter Type;
                CaptionML=[DAN=Filtertype;
                           ENU=Filter Type];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=FilterType }

    { 59  ;5   ;Group     ;
                Visible=FilterType = FilterType::"FIELD";
                GroupType=Group }

    { 57  ;6   ;Field     ;
                Name=CurrentTableFilterField;
                CaptionML=[DAN=Filterv�rdi fra felt;
                           ENU=Filter Value From field];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrentTableFilterFieldName;
                OnValidate=VAR
                             PageTableField@1000 : Record 2000000171;
                           BEGIN
                             PageTableField.SETRANGE(Caption,CurrentTableFilterFieldName);
                             IF PageTableField.FINDFIRST THEN
                               RelatedTableFilterFieldName := PageTableField.Caption
                             ELSE
                               IF RelatedTableFilterFieldName <> '' THEN
                                 ERROR(InvalidRelatedFieldNameErr,CurrentTableFilterFieldName);
                           END;

                OnLookup=VAR
                           PageTableField@1000 : Record 2000000171;
                         BEGIN
                           PageTableField.SETFILTER("Page ID",FORMAT(PageId));

                           CASE FieldType OF
                             'Text','Code':
                               PageTableField.SETFILTER(Type,'%1|%2',PageTableField.Type::Text,PageTableField.Type::Code);
                             'Integer':
                               PageTableField.SETFILTER(Type,'%1',PageTableField.Type::Integer);
                             'Date':
                               PageTableField.SETFILTER(Type,'%1',PageTableField.Type::Date);
                           END;

                           IF PAGE.RUNMODAL(PAGE::"Page Fields Selection List",PageTableField) = ACTION::LookupOK THEN
                             CurrentTableFilterFieldName := PageTableField.Caption;
                         END;
                          }

    { 60  ;5   ;Group     ;
                Visible=FilterType <> FilterType::"FIELD";
                GroupType=Group }

    { 61  ;6   ;Field     ;
                Name=Value;
                CaptionML=[DAN=V�rdi;
                           ENU=Value];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=FilterValue }

    { 52  ;1   ;Group     ;
                CaptionML=[DAN=Trindetaljer;
                           ENU=Step details];
                Visible=(CurrentNavigationPage = CurrentNavigationPage::FieldBasicDefinitionPage) AND (NewFieldType = 'Boolean');
                GroupType=Group }

    { 51  ;2   ;Group     ;
                Name=Step1Header_Boolean;
                CaptionML=[DAN=DEFINITION AF FELT;
                           ENU=FIELD DEFINITION];
                GroupType=Group;
                InstructionalTextML=[DAN=Udfyld oplysninger om det nye felt. Du kan �ndre feltoplysningerne senere, hvis det er n�dvendigt.;
                                     ENU=Fill in information about the new field. You can change the field information later if you need to.] }

    { 50  ;3   ;Field     ;
                Name=NewFieldName_Boolean;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NewFieldName;
                OnValidate=BEGIN
                             NewFieldCaption := NewFieldName;
                           END;

                ShowMandatory=True }

    { 49  ;3   ;Field     ;
                Name=NewFieldCaption_Boolean;
                CaptionML=[DAN=Titel;
                           ENU=Caption];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NewFieldCaption }

    { 46  ;3   ;Field     ;
                Name=NewDescription_Boolean;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NewFieldDescr;
                MultiLine=Yes }

  }
  CODE
  {
    VAR
      NavDesignerProperty@1017 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.Designer.DesignerFieldProperty";
      NavDesignerFieldType@1050 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.Designer.DesignerFieldType";
      NavDesigner@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.Designer.NavDesignerALFunctions";
      PropertyDictionary@1037 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2";
      IsNextVisible@1001 : Boolean;
      IsBackVisible@1004 : Boolean;
      IsCreateBtnVisible@1005 : Boolean;
      IsFinishBtnVisible@1007 : Boolean;
      NewFieldName@1008 : Text;
      NewFieldDescr@1009 : Text;
      NewFieldCaption@1010 : Text;
      NewOptionsFieldValues@1011 : Text;
      NewFieldInitialValue@1012 : Text;
      PageId@1014 : Integer;
      NewFieldId@1015 : Integer;
      NewFieldType@1016 : Text;
      NumberFieldTypes@1019 : 'Integer,Decimal,BigInteger';
      TextFieldType@1021 : 'Text,Code';
      IsTextFieldTypeVisible@1022 : Boolean;
      IsNumberFieldTypeVisible@1023 : Boolean;
      DateTimeFieldType@1024 : 'Date,DateTime,Time';
      IsDateTimeFieldTypeVisible@1025 : Boolean;
      TextFieldTypeDataLength@1032 : Integer;
      Field_NoOfDecimalPlaces@1035 : Text;
      IsOptionDetailsVisible@1026 : Boolean;
      IsFieldEditable@1027 : Boolean;
      IsBlankZero@1028 : Boolean;
      RelatedTableFieldName@1038 : Text;
      RelatedTableName@1039 : Text;
      RelatedFieldMethod@1041 : 'Sum,Average,Count';
      FilterType@1052 : 'CONST,FILTER,FIELD';
      RelatedTableNumber@1053 : Integer;
      RelatedTableFilterFieldName@1056 : Text;
      CurrentTableFilterFieldName@1058 : Text;
      FilterValue@1059 : Text;
      RelatedFieldFormulaCalc_ReverseSign@1029 : Boolean;
      RelatedFieldType@1033 : 'Linked value,Computed value';
      FieldType@1002 : Text;
      MandateFieldNameErr@1003 : TextConst 'DAN=Feltnavn er p�kr�vet.;ENU=Field name is required.';
      RelatedFieldValidationErrorErr@1006 : TextConst 'DAN=Tabel- og feltv�rdier er p�kr�vet.;ENU=Table and Field values are required.';
      FieldCreationErrorErr@1018 : TextConst 'DAN=Fejl opstod under oprettelse af feltet. Kontroll�r, at inputv�rdierne er korrekte, og at feltnavnet er entydigt.;ENU=Error occurred while creating the field. Please validate the input values are correct and field name is unique.';
      InvalidRelatedFieldNameErr@1020 : TextConst '@@@="%1 = Field name";DAN=Feltet %1 blev ikke fundet.;ENU=%1 field not found.';
      InvalidTableNumberOrNameErr@1034 : TextConst '@@@="%1 = Table name";DAN=Tabellen %1 blev ikke fundet.;ENU=%1 table not found.';
      CurrentNavigationPage@1036 : 'FieldSelectionPage,FieldBasicDefinitionPage,FieldAdvancedDefinitionPage';
      DateFieldDescMsg@1046 : TextConst 'DAN=Lager dato for en h�ndelse;ENU=Stores date of an event';
      FieldTypeMessage@1047 : Text;
      TimeFieldDescMsg@1048 : TextConst 'DAN=Lager tidspunkt for en h�ndelse;ENU=Stores time of an event';
      DateTimeFieldDescMsg@1049 : TextConst 'DAN=Lager dato og tidspunkt for en h�ndelse;ENU=Stores Date and Time of an event';
      FieldTypeEnumValue@1042 : Integer;
      PageIdNotFoundErr@1013 : TextConst 'DAN=G� til en side med kortdetaljer, og begynd processen til feltoprettelse.;ENU=Please navigate to a card details page and begin process for field creation.';

    LOCAL PROCEDURE SaveNewFieldDefinition@2();
    VAR
      FieldDetails@1001 : Record 2000000041;
    BEGIN
      FieldType := NewFieldType;
      IF NewFieldType = 'Related Data Field' THEN BEGIN
        IF (RelatedTableName = '') OR (RelatedTableFieldName = '') THEN
          ERROR(RelatedFieldValidationErrorErr);

        FieldDetails.SETFILTER(TableNo,FORMAT(RelatedTableNumber));
        FieldDetails.SETFILTER(FieldName,RelatedTableFieldName);
        IF FieldDetails.FINDFIRST THEN BEGIN
          FieldType := FORMAT(FieldDetails.Type);
          TextFieldTypeDataLength := 0;
          IF (FieldType = 'Text') OR (FieldType = 'Code') THEN
            TextFieldTypeDataLength := FieldDetails.Len;
        END;
      END;

      PropertyDictionary := PropertyDictionary.Dictionary;
      PropertyDictionary.Add(NavDesignerProperty.Description,NewFieldDescr);
      PropertyDictionary.Add(NavDesignerProperty.Caption,NewFieldCaption);

      CASE NewFieldType OF
        'Text','Code':
          PropertyDictionary.Add(NavDesignerProperty.Editable,ConvertToBooleanText(IsFieldEditable));
        'Decimal':
          BEGIN
            PropertyDictionary.Add(NavDesignerProperty.DecimalPlaces,FORMAT(Field_NoOfDecimalPlaces));
            PropertyDictionary.Add(NavDesignerProperty.BlankZero,ConvertToBooleanText(IsBlankZero));
          END;
        'Integer','BigInteger':
          PropertyDictionary.Add(NavDesignerProperty.BlankZero,ConvertToBooleanText(IsBlankZero));
        'Option':
          BEGIN
            PropertyDictionary.Add(NavDesignerProperty.OptionString,NewOptionsFieldValues);
            PropertyDictionary.Add(NavDesignerProperty.InitValue,NewFieldInitialValue);
          END;
      END;

      IF PageId > 0 THEN
        NewFieldId := NavDesigner.CreateTableField(PageId,NewFieldName,FieldTypeEnumValue,TextFieldTypeDataLength,PropertyDictionary)
      ELSE
        ERROR(PageIdNotFoundErr);

      IF NewFieldId = 0 THEN
        ERROR(FieldCreationErrorErr);
    END;

    LOCAL PROCEDURE InitializeVariables@4();
    BEGIN
      IsCreateBtnVisible := TRUE;
      IsBackVisible := FALSE;
      IsNextVisible := FALSE;
      IsFinishBtnVisible := FALSE;

      ClearAllDynamicFieldsVisibility;

      NewFieldName := '';
      NewFieldDescr := '';
      NewFieldCaption := '';
      NewFieldInitialValue := '';
      RelatedTableFieldName := '';
      RelatedTableName := '';
      FilterValue := '';
      FieldTypeMessage := DateFieldDescMsg;
    END;

    LOCAL PROCEDURE ClearAllDynamicFieldsVisibility@6();
    BEGIN
      IsNumberFieldTypeVisible := FALSE;
      IsTextFieldTypeVisible := FALSE;
      IsDateTimeFieldTypeVisible := FALSE;
      IsOptionDetailsVisible := FALSE;
    END;

    LOCAL PROCEDURE LoadRequestedPage@7(Page@1000 : Option);
    BEGIN
      IsBackVisible := TRUE;
      IsNextVisible := TRUE;
      IsFinishBtnVisible := FALSE;
      IsCreateBtnVisible := FALSE;

      CASE Page OF
        CurrentNavigationPage::FieldSelectionPage:
          BEGIN
            CurrentNavigationPage := CurrentNavigationPage::FieldSelectionPage;
            InitializeVariables;
          END;
        CurrentNavigationPage::FieldBasicDefinitionPage:
          BEGIN
            CurrentNavigationPage := CurrentNavigationPage::FieldBasicDefinitionPage;
            IF NewFieldType = 'Boolean' THEN BEGIN
              IsNextVisible := FALSE;
              IsFinishBtnVisible := TRUE;
            END;
          END;
        CurrentNavigationPage::FieldAdvancedDefinitionPage:
          BEGIN
            CurrentNavigationPage := CurrentNavigationPage::FieldAdvancedDefinitionPage;
            IsNextVisible := FALSE;
            IsFinishBtnVisible := TRUE;
          END;
        ELSE
          LoadRequestedPage(CurrentNavigationPage::FieldSelectionPage);
      END;
    END;

    LOCAL PROCEDURE ConvertToBooleanText@5(Value@1000 : Boolean) : Text;
    VAR
      Result@1001 : Text;
    BEGIN
      Result := 'True';
      IF NOT Value THEN
        Result := 'False';
      EXIT(Result);
    END;

    BEGIN
    END.
  }
}

