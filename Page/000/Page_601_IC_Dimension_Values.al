OBJECT Page 601 IC Dimension Values
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Koncerninterne dimensionsv‘rdier;
               ENU=Intercompany Dimension Values];
    SourceTable=Table412;
    DataCaptionFields=Dimension Code;
    PageType=List;
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
                      CaptionML=[DAN=Indryk IC-dimensionsv‘rdier;
                                 ENU=Indent IC Dimension Values];
                      ToolTipML=[DAN=Indryk navnene p† alle dimensionsv‘rdier, der ligger mellem et s‘t dimensionsv‘rdier med Fra-sum og Til-sum. Dette vil ogs† inds‘tte et samment‘llingsinterval for hver Til-sum-dimensionsv‘rdi.;
                                 ENU=Indent the names of all dimension values between each set of Begin-Total and End-Total dimension values. It will also enter a totaling interval for each End-Total dimension value.];
                      ApplicationArea=#Intercompany;
                      RunObject=Codeunit 429;
                      Promoted=Yes;
                      Image=Indent;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
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
                ApplicationArea=#Intercompany;
                SourceExpr=Code;
                Style=Strong;
                StyleExpr=Emphasize }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† dimensionskoden.;
                           ENU=Specifies the name of the dimension code.];
                ApplicationArea=#Intercompany;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionsv‘rdien.;
                           ENU=Specifies the dimension value.];
                ApplicationArea=#Intercompany;
                SourceExpr="Dimension Value Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Intercompany;
                SourceExpr=Blocked }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken koncerninterne dimensionsv‘rdi der svarer til dimensionsv‘rdien p† linjen.;
                           ENU=Specifies which intercompany dimension value corresponds to the dimension value on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="Map-to Dimension Value Code" }

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
      Emphasize@19018670 : Boolean INDATASET;
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

