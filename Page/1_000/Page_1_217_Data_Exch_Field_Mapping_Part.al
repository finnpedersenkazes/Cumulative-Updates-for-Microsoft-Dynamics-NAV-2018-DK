OBJECT Page 1217 Data Exch Field Mapping Part
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kobling af feltet Dataudveksling;
               ENU=Data Exchange Field Mapping];
    SourceTable=Table1225;
    DelayedInsert=Yes;
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                       ColumnCaptionText := GetColumnCaption;
                       FieldCaptionText := GetFieldCaption;
                     END;

    OnNewRecord=BEGIN
                  ColumnCaptionText := '';
                  FieldCaptionText := '';
                END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kolonnen i den eksterne fil, der er tilknyttet feltet i feltet M†ltabel-id, n†r du bruger en midlertidig tabel til dataimport.;
                           ENU=Specifies the number of the column in the external file that is mapped to the field in the Target Table ID field, when you are using an intermediate table for data import.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Column No.";
                OnValidate=BEGIN
                             ColumnCaptionText := GetColumnCaption;
                           END;
                            }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Kolonnetitel;
                           ENU=Column Caption];
                ToolTipML=[DAN=Angiver titlen p† kolonnen i den eksterne fil, der er tilknyttet feltet i feltet M†ltabel-id, n†r du bruger en midlertidig tabel til dataimport.;
                           ENU=Specifies the caption of the column in the external file that is mapped to the field in the Target Table ID field, when you are using an intermediate table for data import.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ColumnCaptionText;
                Editable=false }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† feltet i den eksterne fil, der er tilknyttet feltet i feltet M†ltabel-id, n†r du bruger en midlertidig tabel til dataimport.;
                           ENU=Specifies the number of the field in the external file that is mapped to the field in the Target Table ID field, when you are using an intermediate table for data import.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Field ID";
                OnValidate=BEGIN
                             FieldCaptionText := GetFieldCaption;
                           END;

                OnLookup=VAR
                           Field@1001 : Record 2000000041;
                           TableFilter@1003 : Record 9805;
                           FieldsLookup@1000 : Page 9806;
                         BEGIN
                           Field.SETRANGE(TableNo,"Table ID");
                           Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
                           FieldsLookup.SETTABLEVIEW(Field);
                           FieldsLookup.LOOKUPMODE(TRUE);

                           IF FieldsLookup.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             FieldsLookup.GETRECORD(Field);
                             IF Field."No." = "Field ID" THEN
                               EXIT;
                             TableFilter.CheckDuplicateField(Field);
                             FillSourceRecord(Field);
                             FieldCaptionText := GetFieldCaption;
                           END;
                         END;

                ShowMandatory=TRUE }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Felttitel;
                           ENU=Field Caption];
                ToolTipML=[DAN=Angiver titlen p† feltet i den eksterne fil, der er tilknyttet feltet i feltet M†ltabel-id, n†r du bruger en midlertidig tabel til dataimport.;
                           ENU=Specifies the caption of the field in the external file that is mapped to the field in the Target Table ID field, when you are using an intermediate table for data import.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=FieldCaptionText;
                Editable=false }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at tilknytningen vil blive sprunget over, hvis feltet er tomt. Hvis du ikke markerer dette afkrydsningsfelt, vil der opst† en eksportfejl. N†r afkrydsningsfeltet Brug som midlertidig tabel er markeret, angiver afkrydsningsfeltet Valid‚r kun, at tilknytningen mellem element og felt ikke bruges til at konvertere data, men kun til at validere data.;
                           ENU=Specifies that the map will be skipped if the field is empty. If you do not select this check box, then an export error will occur if the field is empty. When the Use as Intermediate Table check box is selected, the Validate Only check box specifies that the element-to-field map is not used to convert data, but only to validate data.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Optional }

    { 6   ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Multiplier;
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den regel, der transformerer importeret tekst til en underst›ttet v‘rdi, f›r den kan knyttes til et angivet felt i Microsoft Dynamics NAV. N†r du v‘lger en v‘rdi i dette felt, angives den samme v‘rdi i feltet Transformationsregel og tabellen Koblingsbuffer for feltet Dataudveksling.;
                           ENU=Specifies the rule that transforms imported text to a supported value before it can be mapped to a specified field in Microsoft Dynamics NAV. When you choose a value in this field, the same value is entered in the Transformation Rule field in the Data Exch. Field Mapping Buf. table and vice versa.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transformation Rule" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den aktuelle v‘rdi overskrives af en ny v‘rdi.;
                           ENU=Specifies that the current value will be overwritten by a new value.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Overwrite Value" }

  }
  CODE
  {
    VAR
      ColumnCaptionText@1000 : Text INDATASET;
      FieldCaptionText@1001 : Text INDATASET;

    BEGIN
    END.
  }
}

