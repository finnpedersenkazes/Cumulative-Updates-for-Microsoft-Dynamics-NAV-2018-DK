OBJECT Page 130405 CAL Test Results
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=CAL Test Results;
               ENU=CAL Test Results];
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table130405;
    PageType=List;
    PromotedActionCategoriesML=[DAN=New,Process,Report,Call Stack;
                                ENU=New,Process,Report,Call Stack];
    OnAfterGetRecord=BEGIN
                       Style := GetStyle;
                     END;

    ActionList=ACTIONS
    {
      { 17      ;    ;ActionContainer;
                      Name=Container;
                      CaptionML=[DAN=Container;
                                 ENU=Container];
                      ActionContainerType=NewDocumentItems }
      { 18      ;1   ;Action    ;
                      Name=Call Stack;
                      CaptionML=[DAN=Call Stack;
                                 ENU=Call Stack];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=DesignCodeBehind;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 InStr@1001 : InStream;
                                 CallStack@1000 : Text;
                               BEGIN
                                 IF "Call Stack".HASVALUE THEN BEGIN
                                   CALCFIELDS("Call Stack");
                                   "Call Stack".CREATEINSTREAM(InStr);
                                   InStr.READTEXT(CallStack);
                                   MESSAGE(CallStack)
                                 END;
                               END;
                                }
      { 19      ;1   ;Action    ;
                      Name=Export;
                      CaptionML=[DAN=E&xport;
                                 ENU=E&xport];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Export;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CALExportTestResult@1000 : XMLport 130403;
                               BEGIN
                                 CALExportTestResult.SETTABLEVIEW(Rec);
                                 CALExportTestResult.RUN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                Name=ContentArea;
                CaptionML=[DAN=ContentArea;
                           ENU=ContentArea];
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                CaptionML=[DAN=Repeater;
                           ENU=Repeater];
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Specifies the number of the involved entry or record, according to the specified number series.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Test Run No." }

    { 5   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Codeunit ID" }

    { 6   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Codeunit Name";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Function Name" }

    { 8   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=Platform;
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=Result;
                StyleExpr=Style }

    { 10  ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=Restore;
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Start Time" }

    { 11  ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Execution Time" }

    { 12  ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Error Message";
                Style=Unfavorable;
                StyleExpr=TRUE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#All;
                SourceExpr="User ID" }

    { 13  ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=File;
                Visible=FALSE }

  }
  CODE
  {
    VAR
      Style@1000 : Text;

    LOCAL PROCEDURE GetStyle@1() : Text;
    BEGIN
      CASE Result OF
        Result::Passed:
          EXIT('Favorable');
        Result::Failed:
          EXIT('Unfavorable');
        Result::Inconclusive:
          EXIT('Ambiguous');
        ELSE
          EXIT('Standard');
      END;
    END;

    BEGIN
    END.
  }
}

