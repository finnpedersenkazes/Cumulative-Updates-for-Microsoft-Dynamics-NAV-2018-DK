OBJECT Page 569 Chart of Accs. (Analysis View)
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Kontoplan (analysevisning);
               ENU=Chart of Accs. (Analysis View)];
    SourceTable=Table376;
    PageType=List;
    SourceTableTemporary=Yes;
    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       FormatLine;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 24      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Suite;
                      RunObject=Page 17;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Budget Filter=FIELD(Budget Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter);
                      Image=EditLines }
      { 28      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 20;
                      RunPageView=SORTING(G/L Account No.);
                      RunPageLink=G/L Account No.=FIELD(No.);
                      Promoted=No;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 52      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 84      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=F† vist eller rediger de enkelte s‘t af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(15),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 33      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Suite;
                      Image=DimensionSets;
                      OnAction=VAR
                                 GLAcc@1001 : Record 15;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(GLAcc);
                                 DefaultDimMultiple.SetMultiGLAcc(GLAcc);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=&Udvidede tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=Vis yderligere oplysninger om en finanskonto - det supplerer feltet Beskrivelse.;
                                 ENU=View additional information about a general ledger account, this supplements the Description field.];
                      ApplicationArea=#Suite;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=Text }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Likviditet;
                                 ENU=Receivables-Payables];
                      ToolTipML=[DAN=Vis en oversigt over tilgodehavender og skyldige bel›b for kontoen, herunder skyldige bel›b for debitor- og kreditorsaldi.;
                                 ENU=View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 159;
                      Image=ReceivablesPayables }
      { 123     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Saldo;
                                 ENU=&Balance];
                      Image=Balance }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Finans&konto - saldo;
                                 ENU=G/L &Account Balance];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi for forskellige tidsintervaller for den konto, du har valgt i kontoplanen.;
                                 ENU=View a summary of the debit and credit balances for different time periods, for the account that you select in the chart of accounts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 415;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter);
                      Image=GLAccountBalance }
      { 132     ;2   ;Action    ;
                      CaptionML=[DAN=&Finans - saldi;
                                 ENU=G/L &Balance];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi p† alle konti i kontoplanen for det valgte tidsinterval.;
                                 ENU=View a summary of the debit and credit balances for all the accounts in the chart of accounts, for the time period that you select.];
                      ApplicationArea=#Suite;
                      RunObject=Page 414;
                      RunPageOnRec=Yes;
                      Image=GLBalance }
      { 126     ;2   ;Action    ;
                      CaptionML=[DAN=Finans - saldi pr. &dimension;
                                 ENU=G/L Balance by &Dimension];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi efter dimensioner for den aktuelle konto.;
                                 ENU=View a summary of the debit and credit balances by dimensions for the current account.];
                      ApplicationArea=#Suite;
                      RunObject=Page 408;
                      Image=GLBalanceDimension }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 122     ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Indryk kontoplan;
                                 ENU=Indent Chart of Accounts];
                      ToolTipML=[DAN=Indryk konti mellem en Fra-sum og den tilh›rende Til-sum ‚t niveau for at g›re kontoplanen mere overskuelig.;
                                 ENU=Indent accounts between a Begin-Total and the matching End-Total one level to make the chart of accounts easier to read.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 3;
                      Image=IndentChartofAccounts }
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=Emphasize }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† finanskontoen.;
                           ENU=Specifies the name of the general ledger account.];
                ApplicationArea=#Suite;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en finanskonto er en resultatopg›relseskonto eller en balancekonto.;
                           ENU=Specifies whether a general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Suite;
                SourceExpr="Income/Balance" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form†let med kontoen. I alt: Bruges til at samment‘lle en r‘kke saldi p† konti fra mange forskellige grupper. Lad feltet st† tomt, hvis du vil bruge I alt. Fra-Sum: En markering af begyndelsen af en r‘kke konti, der skal samment‘lles og slutter med en Til-sum-konto. Til-sum: Det samlede antal konti, der starter med den foreg†ende Fra-sum-konto. Det samlede antal er defineret i feltet Samment‘lling.;
                           ENU=Specifies the purpose of the account. Total: Used to total a series of balances on accounts from many different account groupings. To use Total, leave this field blank. Begin-Total: A marker for the beginning of a series of accounts to be totaled that ends with an End-Total account. End-Total: A total of a series of accounts that starts with the preceding Begin-Total account. The total is defined in the Totaling field.];
                ApplicationArea=#Suite;
                SourceExpr="Account Type" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der m† bogf›res direkte eller kun indirekte p† denne finanskonto.;
                           ENU=Specifies whether you will be able to post directly or only indirectly to this general ledger account.];
                ApplicationArea=#Suite;
                SourceExpr="Direct Posting";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment‘lles for at give en balancesum. Hvordan poster samment‘lles afh‘nger af v‘rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#Suite;
                SourceExpr=Totaling }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionstypen.;
                           ENU=Specifies the type of transaction.];
                ApplicationArea=#Suite;
                SourceExpr="Gen. Posting Type" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Suite;
                SourceExpr="Gen. Bus. Posting Group" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Suite;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Suite;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bev‘gelsen p† kontosaldoen i den periode, der er indtastet i feltet Datofilter.;
                           ENU=Specifies the net change in the account balance during the time period in the Date Filter field.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Net Change";
                LookupPageID=Analysis View Entries;
                DrillDownPageID=Analysis View Entries }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver finanskontoens saldo p† den sidste dato i feltet Datofilter.;
                           ENU=Specifies the G/L account balance on the last date included in the Date Filter field.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Balance at Date";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver saldoen p† denne konto.;
                           ENU=Specifies the balance on this account.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=Balance;
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bev‘gelsen p† kontosaldoen.;
                           ENU=Specifies the net change in the account balance.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Additional-Currency Net Change";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver finanskontoens saldo (i den ekstra rapporteringsvaluta) p† den sidste dato i feltet Datofilter.;
                           ENU=Specifies the G/L account balance, in the additional reporting currency, on the last date included in the Date Filter field.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Add.-Currency Balance at Date";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver saldoen p† kontoen i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the balance on this account, in the additional reporting currency.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Additional-Currency Balance";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enten finanskontoens samlede budget, eller et bestemt budget, hvis du har angivet et navn i feltet Budgetnavn.;
                           ENU=Specifies either the G/L account's total budget or, if you have specified a name in the Budget Name field, a specific budget.];
                ApplicationArea=#Suite;
                SourceExpr="Budgeted Amount";
                LookupPageID=Analysis View Budget Entries;
                DrillDownPageID=Analysis View Budget Entries }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontonummeret i et konsolideret regnskab, som kreditsaldi skal overf›res til.;
                           ENU=Specifies the account number in a consolidated company to transfer credit balances.];
                ApplicationArea=#Suite;
                SourceExpr="Consol. Debit Acc.";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontonummeret i et konsolideret regnskab, som kreditsaldi skal overf›res til.;
                           ENU=Specifies the account number in a consolidated company to transfer credit balances.];
                ApplicationArea=#Suite;
                SourceExpr="Consol. Credit Acc.";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      Emphasize@19018670 : Boolean INDATASET;
      NameIndent@19079073 : Integer INDATASET;

    [External]
    PROCEDURE InsertTempGLAccAnalysisViews@1(VAR GLAcc@1000 : Record 15);
    BEGIN
      IF GLAcc.FIND('-') THEN
        REPEAT
          INIT;
          TRANSFERFIELDS(GLAcc,TRUE);
          "Account Source" := "Account Source"::"G/L Account";
          INSERT;
        UNTIL GLAcc.NEXT = 0;
    END;

    [External]
    PROCEDURE InsertTempCFAccountAnalysisVie@2(VAR CFAccount@1000 : Record 841);
    BEGIN
      IF CFAccount.FIND('-') THEN
        REPEAT
          INIT;
          "No." := CFAccount."No.";
          Name := CFAccount.Name;
          "Account Type" := CFAccount."Account Type";
          Blocked := CFAccount.Blocked;
          "New Page" := CFAccount."New Page";
          "No. of Blank Lines" := CFAccount."No. of Blank Lines";
          Indentation := CFAccount.Indentation;
          "Last Date Modified" := CFAccount."Last Date Modified";
          Totaling := CFAccount.Totaling;
          Comment := CFAccount.Comment;
          "Account Source" := "Account Source"::"Cash Flow Account";
          INSERT;
        UNTIL CFAccount.NEXT = 0;
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

