OBJECT Page 634 Chart of Accounts Overview
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Oversigt over kontoplan;
               ENU=Chart of Accounts Overview];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table15;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 ExpandAll
               END;

    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       FormatLine;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                ShowAsTree=Yes;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Editable=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� finanskontoen.;
                           ENU=Specifies the name of the general ledger account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Editable=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en finanskonto er en resultatopg�relseskonto eller en balancekonto.;
                           ENU=Specifies whether a general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Income/Balance";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form�let med kontoen. I alt: Bruges til at samment�lle en r�kke saldi p� konti fra mange forskellige grupper. Lad feltet st� tomt, hvis du vil bruge I alt. Fra-Sum: En markering af begyndelsen af en r�kke konti, der skal samment�lles og slutter med en Til-sum-konto. Til-sum: Det samlede antal konti, der starter med den foreg�ende Fra-sum-konto. Det samlede antal er defineret i feltet Samment�lling.;
                           ENU=Specifies the purpose of the account. Total: Used to total a series of balances on accounts from many different account groupings. To use Total, leave this field blank. Begin-Total: A marker for the beginning of a series of accounts to be totaled that ends with an End-Total account. End-Total: A total of a series of accounts that starts with the preceding Begin-Total account. The total is defined in the Totaling field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bev�gelsen p� kontosaldoen i den periode, der er indtastet i feltet Datofilter.;
                           ENU=Specifies the net change in the account balance during the time period in the Date Filter field.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Net Change" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver finanskontoens saldo p� den sidste dato i feltet Datofilter.;
                           ENU=Specifies the G/L account balance on the last date included in the Date Filter field.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Balance at Date";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver saldoen p� denne konto.;
                           ENU=Specifies the balance on this account.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=Balance }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bev�gelsen p� kontosaldoen.;
                           ENU=Specifies the net change in the account balance.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Additional-Currency Net Change";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver finanskontoens saldo (i den ekstra rapporteringsvaluta) p� den sidste dato i feltet Datofilter.;
                           ENU=Specifies the G/L account balance, in the additional reporting currency, on the last date included in the Date Filter field.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Add.-Currency Balance at Date";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver saldoen p� kontoen i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the balance on this account, in the additional reporting currency.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Additional-Currency Balance";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enten finanskontoens samlede budget, eller et bestemt budget, hvis du har angivet et navn i feltet Budgetnavn.;
                           ENU=Specifies either the G/L account's total budget or, if you have specified a name in the Budget Name field, a specific budget.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Budgeted Amount";
                Visible=FALSE;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      Emphasize@19018670 : Boolean INDATASET;
      NameIndent@19079073 : Integer INDATASET;

    LOCAL PROCEDURE ExpandAll@12();
    BEGIN
      CopyGLAccToTemp(FALSE);
    END;

    LOCAL PROCEDURE CopyGLAccToTemp@3(OnlyRoot@1000 : Boolean);
    VAR
      GLAcc@1002 : Record 15;
    BEGIN
      RESET;
      DELETEALL;
      SETCURRENTKEY("No.");

      IF OnlyRoot THEN
        GLAcc.SETRANGE(Indentation,0);
      GLAcc.SETFILTER("Account Type",'<>%1',GLAcc."Account Type"::"End-Total");
      IF GLAcc.FIND('-') THEN
        REPEAT
          Rec := GLAcc;
          IF GLAcc."Account Type" = GLAcc."Account Type"::"Begin-Total" THEN
            Totaling := GetEndTotal(GLAcc);
          INSERT;
        UNTIL GLAcc.NEXT = 0;

      IF FINDFIRST THEN;
    END;

    LOCAL PROCEDURE GetEndTotal@7(VAR GLAcc@1000 : Record 15) : Text[250];
    VAR
      GLAcc2@1001 : Record 15;
    BEGIN
      GLAcc2.SETFILTER("No.",'>%1',GLAcc."No.");
      GLAcc2.SETRANGE(Indentation,GLAcc.Indentation);
      GLAcc2.SETRANGE("Account Type",GLAcc2."Account Type"::"End-Total");
      IF GLAcc2.FINDFIRST THEN
        EXIT(GLAcc2.Totaling);

      EXIT('');
    END;

    LOCAL PROCEDURE FormatLine@19039177();
    BEGIN
      NameIndent := Indentation;
      Emphasize := "Account Type" <> "Account Type"::Posting;
    END;

    BEGIN
    END.
  }
}

