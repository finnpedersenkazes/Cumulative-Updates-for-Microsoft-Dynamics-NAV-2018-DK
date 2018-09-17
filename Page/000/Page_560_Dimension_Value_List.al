OBJECT Page 560 Dimension Value List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Dimensionsv‘rdioversigt;
               ENU=Dimension Value List];
    SourceTable=Table349;
    DataCaptionExpr=GetFormCaption;
    PageType=List;
    OnOpenPage=BEGIN
                 GLSetup.GET;
               END;

    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       FormatLines;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for dimensionsv‘rdien.;
                           ENU=Specifies the code for the dimension value.];
                ApplicationArea=#Suite;
                SourceExpr=Code;
                Style=Strong;
                StyleExpr=Emphasize }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et navn p† dimensionsv‘rdien.;
                           ENU=Specifies a descriptive name for the dimension value.];
                ApplicationArea=#Suite;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form†let med dimensionsv‘rdien.;
                           ENU=Specifies the purpose of the dimension value.];
                ApplicationArea=#Dimensions;
                SourceExpr="Dimension Value Type";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment‘lles for at give en balancesum. Hvordan poster samment‘lles afh‘nger af v‘rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#Advanced;
                SourceExpr=Totaling;
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Advanced;
                SourceExpr=Blocked;
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, som anvendes til konsolideringen.;
                           ENU=Specifies the code that is used for consolidation.];
                ApplicationArea=#Advanced;
                SourceExpr="Consolidation Code";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      GLSetup@1000 : Record 98;
      Text000@1001 : TextConst 'DAN=Genvejsdimension %1;ENU=Shortcut Dimension %1';
      Emphasize@19004235 : Boolean INDATASET;
      NameIndent@19079073 : Integer INDATASET;

    [External]
    PROCEDURE GetSelectionFilter@4() : Text;
    VAR
      DimVal@1004 : Record 349;
      SelectionFilterManagement@1001 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(DimVal);
      EXIT(SelectionFilterManagement.GetSelectionFilterForDimensionValue(DimVal));
    END;

    [External]
    PROCEDURE SetSelection@3(VAR DimVal@1001 : Record 349);
    BEGIN
      CurrPage.SETSELECTIONFILTER(DimVal);
    END;

    LOCAL PROCEDURE GetFormCaption@1() : Text[250];
    BEGIN
      IF GETFILTER("Dimension Code") <> '' THEN
        EXIT(GETFILTER("Dimension Code"));

      IF GETFILTER("Global Dimension No.") = '1' THEN
        EXIT(GLSetup."Global Dimension 1 Code");

      IF GETFILTER("Global Dimension No.") = '2' THEN
        EXIT(GLSetup."Global Dimension 2 Code");

      EXIT(STRSUBSTNO(Text000,"Global Dimension No."));
    END;

    LOCAL PROCEDURE FormatLines@19039177();
    BEGIN
      Emphasize := "Dimension Value Type" <> "Dimension Value Type"::Standard;
      NameIndent := Indentation;
    END;

    BEGIN
    END.
  }
}

