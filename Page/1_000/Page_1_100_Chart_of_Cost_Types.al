OBJECT Page 1100 Chart of Cost Types
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningstyper;
               ENU=Chart of Cost Types];
    SourceTable=Table1103;
    PageType=List;
    CardPageID=Cost Type Card;
    RefreshOnActivate=Yes;
    OnAfterGetRecord=BEGIN
                       SetEmphasis;
                       SetIndent;
                     END;

    ActionList=ACTIONS
    {
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Omkostningstype;
                                 ENU=&Cost Type];
                      Image=Costs }
      { 4       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Omkost&ningsposter;
                                 ENU=Cost E&ntries];
                      ToolTipML=[DAN=Vis omkostningsposter, som kan komme fra kilder s†som automatisk overf›rsel af finansposter til omkostningsposter, manuel bogf›ring for rene omkostningsposter, interne afgifter og manuelle allokeringer samt automatisk tildeling af bogf›ringer for faktiske omkostninger.;
                                 ENU=View cost entries, which can come from sources such as automatic transfer of general ledger entries to cost entries, manual posting for pure cost entries, internal charges, and manual allocations, and automatic allocation postings for actual costs.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1103;
                      RunPageLink=Cost Type No.=FIELD(No.);
                      Image=CostEntries }
      { 5       ;2   ;Action    ;
                      Name=CorrespondingGLAccounts;
                      CaptionML=[DAN=Tilknyttede &finanskonti;
                                 ENU=Corresponding &G/L Accounts];
                      ToolTipML=[DAN=Vis finanskontoen for den valgte linje.;
                                 ENU=View the G/L account for the selected line.];
                      ApplicationArea=#CostAccounting;
                      Image=CompareCosttoCOA;
                      OnAction=VAR
                                 GLAccount@1000 : Record 15;
                               BEGIN
                                 IF "G/L Account Range" <> '' THEN
                                   GLAccount.SETFILTER("No.","G/L Account Range")
                                 ELSE
                                   GLAccount.SETRANGE("No.",'');
                                 IF PAGE.RUNMODAL(PAGE::"Chart of Accounts",GLAccount) = ACTION::OK THEN;
                               END;
                                }
      { 6       ;2   ;Separator  }
      { 7       ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=&Saldo;
                                 ENU=&Balance];
                      ToolTipML=[DAN=Vis en oversigt over saldoen til dato eller bev‘gelsen for forskellige tidsintervaller for de omkostningstyper, du v‘lger. Du kan v‘lge forskellige tidsintervaller og indstille filtre p† de omkostningssteder og omkostningsemner, som du vil se.;
                                 ENU=View a summary of the balance at date or the net change for different time periods for the cost types that you select. You can select different time intervals and set filters on the cost centers and cost objects that you want to see.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1110;
                      RunPageOnRec=Yes;
                      Image=Balance }
      { 8       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 10      ;2   ;Action    ;
                      Name=IndentCostType;
                      CaptionML=[DAN=I&ndryk omkostningstyper;
                                 ENU=I&ndent Cost Types];
                      ToolTipML=[DAN=Indryk de valgte linjer.;
                                 ENU=Indent the selected lines.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      Image=IndentChartOfAccounts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CostAccMgt.ConfirmIndentCostTypes;
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=GetCostTypesFromChartOfAccounts;
                      CaptionML=[DAN=Hent omkostningstyper fra &kontoplan;
                                 ENU=Get Cost Types from &Chart of Accounts];
                      ToolTipML=[DAN=Overf›r alle resultatopg›relseskonti fra kontoplanen til diagrammet over omkostningstyper.;
                                 ENU=Transfer all income statement accounts from the chart of accounts to the chart of cost types.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      Image=CopyFromChartOfAccounts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CostAccMgt.GetCostTypesFromChartOfAccount;
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=RegCostTypeInChartOfCostType;
                      CaptionML=[DAN=&Registrer omkostningstyper i kontoplan;
                                 ENU=&Register Cost Types in Chart of Accounts];
                      ToolTipML=[DAN=Opdater relationen mellem kontoplanen og diagrammet over omkostningstyper. Funktionen k›res automatisk, f›r du overf›rer finansposter til omkostningsregnskabet.;
                                 ENU=Update the relationship between the chart of accounts and the chart of cost types. The function runs automatically before transferring general ledger entries to cost accounting.];
                      ApplicationArea=#CostAccounting;
                      Image=LinkAccount;
                      OnAction=BEGIN
                                 CostAccMgt.LinkCostTypesToGLAccountsYN;
                               END;
                                }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Omkostningsjournaler;
                                 ENU=Cost Registers];
                      ToolTipML=[DAN=Vis alle de overf›rte, bogf›rte og allokerede poster. Et register oprettes hver gang, en post overf›res, bogf›res eller allokeres.;
                                 ENU=View all the transferred, posted, and allocated entries. A register is created every time that an entry is transferred, posted, or allocated.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1104;
                      Promoted=No;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Finanskonto;
                                 ENU=G/L Account];
                      ToolTipML=[DAN=Vis finanskontoen for den valgte linje.;
                                 ENU=View the G/L account for the selected line.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 16;
                      Promoted=Yes;
                      Image=ChartOfAccounts;
                      PromotedCategory=Process }
      { 15      ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=Resultatopg. i omk.regnskab;
                                 ENU=Cost Acctg. P/L Statement];
                      ToolTipML=[DAN=Vis resultatopg›relsen for omkostningsregnskabet.;
                                 ENU=View the cost accounting P/L statement.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1126;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=Res.opg›relse i omk.regnskab pr. periode;
                                 ENU=Cost Acctg. P/L Statement per Period];
                      ToolTipML=[DAN=Vis resultatopg›relsen for omkostningstyper over to perioder med sammenligning som en procentdel.;
                                 ENU=View profit and loss for cost types over two periods with the comparison as a percentage.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1123;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=Res.opg›relse i omk.regnskab med budget;
                                 ENU=Cost Acctg. P/L Statement with Budget];
                      ToolTipML=[DAN=Vis en sammenligning af saldoen med budgettallene, som beregner varians og afvigelse i procent i den aktuelle regnskabsperiode, den akkumulerede regnskabsperiode og regnskabs†ret.;
                                 ENU=View a comparison of the balance to the budget figures and calculates the variance and the percent variance in the current accounting period, the accumulated accounting period, and the fiscal year.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1133;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Omk.regnskabsanalyse;
                                 ENU=Cost Acctg. Analysis];
                      ToolTipML=[DAN=Vis saldi pr. omkostningstype med kolonner for syv felter for omkostningssteder og omkostningsemner. Det bruges som omkostningsfordelingsark i omkostningsregnskabet. Strukturen i linjerne er baseret p† diagrammet over omkostningstyper. Du kan angive op til syv omkostningssteder og omkostningsemner, der vises som kolonner i rapporten.;
                                 ENU=View balances per cost type with columns for seven fields for cost centers and cost objects. It is used as the cost distribution sheet in Cost accounting. The structure of the lines is based on the chart of cost types. You define up to seven cost centers and cost objects that appear as columns in the report.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1127;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=Kontodetaljer;
                                 ENU=Account Details];
                      ToolTipML=[DAN=Vis omkostningsposter for hver omkostningstype. Du kan gennemse transaktionerne for hver omkostningstype.;
                                 ENU=View cost entries for each cost type. You can review the transactions for each cost type.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1125;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 23  ;0   ;Container ;
                ContainerType=ContentArea }

    { 24  ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#CostAccounting;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=Emphasize }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† omkostningstypen.;
                           ENU=Specifies the name of the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningstypen.;
                           ENU=Specifies the type of the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Type }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment‘lles for at give en balancesum. Hvordan poster samment‘lles afh‘nger af v‘rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Totaling }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningstype efter variabilitet.;
                           ENU=Specifies the cost type by variability.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Classification" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et finanskontoomr†de til definition af, hvilken finanskonto en omkostningstype tilh›rer.;
                           ENU=Specifies a general ledger account range to establish which general ledger account a cost type belongs to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="G/L Account Range" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bev‘gelsen p† kontosaldoen i den periode, der er indtastet i feltet Datofilter.;
                           ENU=Specifies the net change in the account balance during the time period in the Date Filter field.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Net Change" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsstedets kode. Koden fungerer som en standardv‘rdi for omkostningsbogf›ring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost center code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Center Code" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsemnets kode. Koden fungerer som en standardv‘rdi for omkostningsbogf›ring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost object code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Object Code" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indstillinger, der giver mulighed for, at finansposter kan bogf›res individuelt eller som en kombineret bogf›ring pr. eller m†ned.;
                           ENU=Specifies the option to allow for general ledger entries to be posted individually or as a combined posting per day or month.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Combine Entries" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enten omkostningstypens samlede budget, eller, hvis du har angivet et filter i feltet Budgetfilter, et filtreret budget. Indholdet af feltet beregnes ved at bruge posterne i feltet Bel›b i tabellen Omkostningsbudgetpost.;
                           ENU=Specifies either the cost type's total budget or, if you have specified a filter in the Budget Filter field, a filtered budget. The contents of the field are calculated by using the entries in the Amount field in the Cost Budget Entry table.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Budget Amount" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningstypens saldo.;
                           ENU=Specifies the balance of the cost type.];
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=Balance;
                Visible=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Blocked }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil starte en ny side direkte efter dette omkostningssted, n†r du udskriver diagrammet over pengestr›mskonti.;
                           ENU=Specifies if you want a new page to start immediately after this cost center when you print the chart of cash flow accounts.];
                ApplicationArea=#CostAccounting;
                SourceExpr="New Page" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal v‘re en tom linje umiddelbart efter dette omkostningssted, n†r du printer diagrammet over omkostningssteder. Felterne Ny side, Tom linje og Indrykning definerer layoutet af diagrammet over omkostningssteder.;
                           ENU=Specifies whether you want a blank line to appear immediately after this cost center when you print the chart of cost centers. The New Page, Blank Line, and Indentation fields define the layout of the chart of cost centers.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Blank Line" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobel›b, der stadig kan allokeres. Posten i feltet Allokeret i tabellen Omkostningspost bestemmer, om en omkostningspost er en del af dette felt.;
                           ENU=Specifies the net amount that can still be allocated. The entry in the Allocated field in the Cost Entry table determines whether a cost entry is a part of this field.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Balance to Allocate" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den omkostningstypesaldoen p† den sidste dag, der er inkluderet i feltet Datofilter. Indholdet af feltet beregnes ved at bruge posterne i feltet Bel›b i tabellen Omkostningspost.;
                           ENU=Specifies the cost type balance on the last date that is included in the Date Filter field. The contents of the field are calculated by using the entries in the Amount field in the Cost Entry table.];
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr="Balance at Date";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      CostAccMgt@1000 : Codeunit 1100;
      Emphasize@1001 : Boolean INDATASET;
      NameIndent@1003 : Integer INDATASET;

    LOCAL PROCEDURE SetEmphasis@1();
    BEGIN
      Emphasize := Type <> Type::"Cost Type";
    END;

    LOCAL PROCEDURE SetIndent@2();
    BEGIN
      NameIndent := Indentation;
    END;

    BEGIN
    END.
  }
}

