OBJECT Page 790 G/L Account Categories
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finanskontokategorier;
               ENU=G/L Account Categories];
    InsertAllowed=No;
    SourceTable=Table570;
    SourceTableView=SORTING(Presentation Order,Sibling Sequence No.);
    PageType=List;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Generelt;
                                ENU=New,Process,Report,General];
    ShowFilter=No;
    OnOpenPage=BEGIN
                 IF ISEMPTY THEN
                   InitializeDataSet;
                 SETAUTOCALCFIELDS("Has Children");

                 PageEditable := CurrPage.EDITABLE;
               END;

    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Has Children");
                       GLAccTotaling := GetTotaling;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           PageEditable := CurrPage.EDITABLE;
                         END;

    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ActionContainerType=NewDocumentItems }
      { 7       ;1   ;Action    ;
                      Name=New;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ToolTipML=[DAN=Opret en ny finanskontokategori.;
                                 ENU=Create a new G/L account category.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=PageEditable;
                      PromotedIsBig=Yes;
                      Image=NewChartOfAccounts;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 SetRow(InsertRow);
                               END;
                                }
      { 14      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 15      ;1   ;Action    ;
                      Name=MoveUp;
                      CaptionML=[DAN=Flyt op;
                                 ENU=Move Up];
                      ToolTipML=[DAN=Skift sortering for kontokategorierne.;
                                 ENU=Change the sorting of the account categories.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=PageEditable;
                      Image=MoveUp;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 MoveUp;
                               END;
                                }
      { 16      ;1   ;Action    ;
                      Name=MoveDown;
                      CaptionML=[DAN=Flyt ned;
                                 ENU=Move Down];
                      ToolTipML=[DAN=Skift sortering for kontokategorierne.;
                                 ENU=Change the sorting of the account categories.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=PageEditable;
                      Image=MoveDown;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 MoveDown;
                               END;
                                }
      { 17      ;1   ;Action    ;
                      Name=Indent;
                      CaptionML=[DAN=Indryk;
                                 ENU=Indent];
                      ToolTipML=[DAN=Flyt kontokategorien til hõjre.;
                                 ENU=Move the account category to the right.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=PageEditable;
                      PromotedIsBig=Yes;
                      Image=Indent;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 MakeChildOfPreviousSibling;
                               END;
                                }
      { 18      ;1   ;Action    ;
                      Name=Outdent;
                      CaptionML=[DAN=Ryk ud;
                                 ENU=Outdent];
                      ToolTipML=[DAN=Flyt kontokategorien til venstre.;
                                 ENU=Move the account category to the left.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=PageEditable;
                      PromotedIsBig=Yes;
                      Image=DecreaseIndent;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 MakeSiblingOfParent;
                               END;
                                }
      { 28      ;1   ;Action    ;
                      Name=GenerateAccSched;
                      CaptionML=[DAN=Opret kontoskemaer;
                                 ENU=Generate Account Schedules];
                      ToolTipML=[DAN=Opret kontoskemaer.;
                                 ENU=Generate account schedules.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 571;
                      Promoted=Yes;
                      Enabled=PageEditable;
                      Image=CreateLinesFromJob;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 29      ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 30      ;1   ;Action    ;
                      Name=GLSetup;
                      CaptionML=[DAN=Opsëtning af Finans;
                                 ENU=General Ledger Setup];
                      ToolTipML=[DAN=FÜ vist eller rediger metoden til hÜndtering af bestemte regnskabsproblemer i din virksomhed.;
                                 ENU=View or edit the way to handle certain accounting issues in your company.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 118;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GeneralLedger;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 31      ;1   ;Action    ;
                      Name=AccSchedules;
                      CaptionML=[DAN=Kontoskemaer;
                                 ENU=Account Schedules];
                      ToolTipML=[DAN=èbn dine kontoskemaer for at analysere tal i finanskonti eller sammenligne finansposter med finansbudgetposter.;
                                 ENU=Open your account schedules to analyze figures in general ledger accounts or to compare general ledger entries with general ledger budget entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 103;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Accounts;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                IndentationColumnName=Indentation;
                IndentationControls=Description;
                ShowAsTree=Yes;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af recorden.;
                           ENU=Specifies a description of the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Style=Strong;
                StyleExpr="Has Children" OR (Indentation = 0) }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kategorien for finanskontoen.;
                           ENU=Specifies the category of the G/L account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Category" }

    { 23  ;2   ;Field     ;
                CaptionML=[DAN=Finanskonti i kategori;
                           ENU=G/L Accounts in Category];
                ToolTipML=[DAN=Angiver, hvilke finanskonti der er inkluderet i kontokategorien.;
                           ENU=Specifies which G/L accounts are included in the account category.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GLAccTotaling;
                TableRelation="G/L Account";
                OnValidate=BEGIN
                             ValidateTotaling(GLAccTotaling);
                           END;

                OnLookup=BEGIN
                           LookupTotaling;
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ekstra attributter, der er brugt til at oprette pengestrõmsopgõrelsen.;
                           ENU=Specifies additional attributes that are used to create the cash flow statement.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Additional Report Definition" }

    { 21  ;2   ;Field     ;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Angiver saldoen for finanskontoen.;
                           ENU=Specifies the balance of the G/L account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetBalance;
                Editable=FALSE;
                Style=Strong;
                StyleExpr="Has Children" OR (Indentation = 0) }

    { 10  ;    ;Container ;
                ContainerType=FactBoxArea }

    { 11  ;1   ;Part      ;
                CaptionML=[DAN=Finanskonti i kategori;
                           ENU=G/L Accounts in Category];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Account Subcategory Entry No.=FIELD(Entry No.);
                PagePartID=Page791;
                Editable=FALSE;
                PartType=Page }

    { 12  ;1   ;Part      ;
                CaptionML=[DAN=Finanskonti uden kategori;
                           ENU=G/L Accounts without Category];
                ApplicationArea=#Basic,#Suite;
                SubPageView=WHERE(Account Subcategory Entry No.=CONST(0));
                PagePartID=Page791;
                PartType=Page }

  }
  CODE
  {
    VAR
      GLAccTotaling@1001 : Code[250];
      PageEditable@1002 : Boolean;

    LOCAL PROCEDURE SetRow@1(EntryNo@1000 : Integer);
    BEGIN
      IF EntryNo = 0 THEN
        EXIT;
      IF GET(EntryNo) THEN;
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

