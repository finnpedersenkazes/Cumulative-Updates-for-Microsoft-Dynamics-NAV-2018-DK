OBJECT Page 537 Dimension Values
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dimensionsv‘rdier;
               ENU=Dimension Values];
    SourceTable=Table349;
    DelayedInsert=Yes;
    DataCaptionFields=Dimension Code;
    PageType=List;
    OnOpenPage=VAR
                 DimensionCode@1000 : Code[20];
               BEGIN
                 IF GETFILTER("Dimension Code") <> '' THEN
                   DimensionCode := GETRANGEMIN("Dimension Code");
                 IF DimensionCode <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Dimension Code",DimensionCode);
                   FILTERGROUP(0);
                 END;
               END;

    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       FormatLine;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Indryk dimensionsv‘rdier;
                                 ENU=Indent Dimension Values];
                      ToolTipML=[DAN=Indryk dimensionsv‘rdierne mellem en Fra-sum og den tilh›rende Til-sum ‚t niveau for at g›re listen mere overskuelig.;
                                 ENU=Indent dimension values between a Begin-Total and the matching End-Total one level to make the list easier to read.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 409;
                      RunPageOnRec=Yes;
                      Image=Indent }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for dimensionsv‘rdien.;
                           ENU=Specifies the code for the dimension value.];
                ApplicationArea=#Suite;
                SourceExpr=Code;
                Style=Strong;
                StyleExpr=Emphasize }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et navn p† dimensionsv‘rdien.;
                           ENU=Specifies a descriptive name for the dimension value.];
                ApplicationArea=#Suite;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form†let med dimensionsv‘rdien.;
                           ENU=Specifies the purpose of the dimension value.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension Value Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment‘lles for at give en balancesum. Hvordan poster samment‘lles afh‘nger af v‘rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#Suite;
                SourceExpr=Totaling;
                OnLookup=VAR
                           DimVal@1002 : Record 349;
                           DimValList@1003 : Page 560;
                         BEGIN
                           DimVal := Rec;
                           DimVal.SETRANGE("Dimension Code","Dimension Code");
                           DimValList.SETTABLEVIEW(DimVal);
                           DimValList.LOOKUPMODE := TRUE;
                           IF DimValList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             DimValList.GETRECORD(DimVal);
                             Text := DimVal.Code;
                             EXIT(TRUE);
                           END;
                           EXIT(FALSE);
                         END;
                          }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Suite;
                SourceExpr=Blocked }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken IC-dimensionsv‘rdi der svarer til dimensionsv‘rdien p† linjen.;
                           ENU=Specifies which intercompany dimension value corresponds to the dimension value on the line.];
                ApplicationArea=#Dimensions;
                SourceExpr="Map-to IC Dimension Value Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
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
      Emphasize@19004235 : Boolean INDATASET;
      NameIndent@19079073 : Integer INDATASET;

    LOCAL PROCEDURE FormatLine@19039177();
    BEGIN
      Emphasize := "Dimension Value Type" <> "Dimension Value Type"::Standard;
      NameIndent := Indentation;
    END;

    BEGIN
    END.
  }
}

