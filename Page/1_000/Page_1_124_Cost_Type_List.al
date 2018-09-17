OBJECT Page 1124 Cost Type List
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
    CaptionML=[DAN=Omkostningstypeoversigt;
               ENU=Cost Type List];
    SourceTable=Table1103;
    DataCaptionFields=Search Name;
    PageType=List;
    CardPageID=Cost Type Card;
    RefreshOnActivate=Yes;
    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                     END;

    ActionList=ACTIONS
    {
      { 39      ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 38      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Omkostningstype;
                                 ENU=&Cost Type];
                      Image=Costs }
      { 37      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Omkost&ningsposter;
                                 ENU=Cost E&ntries];
                      ToolTipML=[DAN=Vis omkostningsposter, som kan komme fra kilder s†som automatisk overf›rsel af finansposter til omkostningsposter, manuel bogf›ring for rene omkostningsposter, interne afgifter og manuelle allokeringer samt automatisk tildeling af bogf›ringer for faktiske omkostninger.;
                                 ENU=View cost entries, which can come from sources such as automatic transfer of general ledger entries to cost entries, manual posting for pure cost entries, internal charges, and manual allocations, and automatic allocation postings for actual costs.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1103;
                      RunPageLink=Cost Type No.=FIELD(No.);
                      Image=CostEntries }
      { 36      ;2   ;Action    ;
                      Name=CorrespondingGLAccounts;
                      CaptionML=[DAN=Tilknyttede &finanskonti;
                                 ENU=Corresponding &G/L Accounts];
                      ToolTipML=[DAN=Vis finanskontoen for den valgte linje.;
                                 ENU=View the G/L account for the selected line.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 16;
                      RunPageLink=No.=FIELD(FILTER(G/L Account Range));
                      Image=CompareCosttoCOA }
      { 35      ;2   ;Separator  }
      { 34      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=&Saldo;
                                 ENU=&Balance];
                      ToolTipML=[DAN=Vis en oversigt over saldoen til dato eller bev‘gelsen for forskellige tidsintervaller for de omkostningstyper, du v‘lger. Du kan v‘lge forskellige tidsintervaller og indstille filtre p† de omkostningssteder og omkostningsemner, som du vil se.;
                                 ENU=View a summary of the balance at date or the net change for different time periods for the cost types that you select. You can select different time intervals and set filters on the cost centers and cost objects that you want to see.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1110;
                      RunPageOnRec=Yes;
                      Image=Balance }
      { 33      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=I&ndryk omkostningstyper;
                                 ENU=I&ndent Cost Types];
                      ToolTipML=[DAN=Indryk de valgte linjer.;
                                 ENU=Indent the selected lines.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      Image=IndentChartofAccounts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CostAccMgt.ConfirmIndentCostTypes;
                               END;
                                }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Hent omkostningstyper fra &kontoplan;
                                 ENU=Get Cost Types from &Chart of Accounts];
                      ToolTipML=[DAN=Overf›r finanskontoplanen til diagrammet over omkostningstyper.;
                                 ENU=Transfer the general ledger chart of accounts to the chart of cost types.];
                      ApplicationArea=#CostAccounting;
                      Image=ChartOfAccounts;
                      OnAction=BEGIN
                                 CostAccMgt.GetCostTypesFromChartOfAccount;
                               END;
                                }
      { 29      ;2   ;Action    ;
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
      { 28      ;1   ;Action    ;
                      CaptionML=[DAN=Omkostningsjournaler;
                                 ENU=Cost Registers];
                      ToolTipML=[DAN=Vis alle de overf›rte, bogf›rte og allokerede poster. Et register oprettes hver gang, en post overf›res, bogf›res eller allokeres.;
                                 ENU=View all the transferred, posted, and allocated entries. A register is created every time that an entry is transferred, posted, or allocated.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1104;
                      Promoted=No;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 27      ;1   ;Action    ;
                      Name=GLAccount;
                      CaptionML=[DAN=Finanskonto;
                                 ENU=G/L Account];
                      ToolTipML=[DAN=Vis finanskontoen for den valgte omkostningstype.;
                                 ENU=View the G/L account for the select cost type.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 16;
                      Promoted=Yes;
                      Image=JobPrice;
                      PromotedCategory=Process }
      { 26      ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 24      ;1   ;Action    ;
                      CaptionML=[DAN=Resultatopg. i omk.regnskab;
                                 ENU=Cost Acctg. P/L Statement];
                      ToolTipML=[DAN=Vis kredit- og debetsaldi pr. omkostningstype sammen med diagrammet over omkostningstyper.;
                                 ENU=View the credit and debit balances per cost type, together with the chart of cost types.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1126;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 23      ;1   ;Action    ;
                      CaptionML=[DAN=Res.opg›relse i omk.regnskab pr. periode;
                                 ENU=Cost Acctg. P/L Statement per Period];
                      ToolTipML=[DAN=Vis resultatopg›relsen for omkostningstyper over to perioder med sammenligning som en procentdel.;
                                 ENU=View profit and loss for cost types over two periods with the comparison as a percentage.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1123;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=Res.opg›relse i omk.regnskab med budget;
                                 ENU=Cost Acctg. P/L Statement with Budget];
                      ToolTipML=[DAN=Vis en sammenligning af saldoen med budgettallene, som beregner varians og afvigelse i procent i den aktuelle regnskabsperiode, den akkumulerede regnskabsperiode og regnskabs†ret.;
                                 ENU=View a comparison of the balance to the budget figures and calculates the variance and the percent variance in the current accounting period, the accumulated accounting period, and the fiscal year.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1133;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=Omk.regnskabsanalyse;
                                 ENU=Cost Acctg. Analysis];
                      ToolTipML=[DAN=Vis saldi pr. omkostningstype med kolonner for syv felter for omkostningssteder og omkostningsemner. Det bruges som omkostningsfordelingsark i omkostningsregnskabet. Strukturen i linjerne er baseret p† diagrammet over omkostningstyper. Du kan angive op til syv omkostningssteder og omkostningsemner, der vises som kolonner i rapporten.;
                                 ENU=View balances per cost type with columns for seven fields for cost centers and cost objects. It is used as the cost distribution sheet in Cost accounting. The structure of the lines is based on the chart of cost types. You define up to seven cost centers and cost objects that appear as columns in the report.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1127;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 18      ;1   ;Action    ;
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
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#CostAccounting;
                SourceExpr="No." }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† omkostningstypen.;
                           ENU=Specifies the name of the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Name }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den omkostningstype, som er inkluderet i linjen.;
                           ENU=Specifies the cost type included in the line.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Type }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment‘lles for at give en balancesum. Hvordan poster samment‘lles afh‘nger af v‘rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Totaling }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningstype efter variabilitet.;
                           ENU=Specifies the cost type by variability.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Classification" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et finanskontoomr†de til definition af, hvilken finanskonto en omkostningstype tilh›rer.;
                           ENU=Specifies a general ledger account range to establish which general ledger account a cost type belongs to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="G/L Account Range" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bev‘gelsen p† kontosaldoen i den periode, der er indtastet i feltet Datofilter.;
                           ENU=Specifies the net change in the account balance during the time period in the Date Filter field.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Net Change" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsstedets kode. Koden fungerer som en standardv‘rdi for omkostningsbogf›ring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost center code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Center Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsemnets kode. Koden fungerer som en standardv‘rdi for omkostningsbogf›ring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost object code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Object Code" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indstillinger, der giver mulighed for, at finansposter kan bogf›res individuelt eller som en kombineret bogf›ring pr. eller m†ned.;
                           ENU=Specifies the option to allow for general ledger entries to be posted individually or as a combined posting per day or month.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Combine Entries" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enten omkostningstypens samlede budget, eller, hvis du har angivet et filter i feltet Budgetfilter, et filtreret budget. Indholdet af feltet beregnes ved at bruge posterne i feltet Bel›b i tabellen Omkostningsbudgetpost.;
                           ENU=Specifies either the cost type's total budget or, if you have specified a filter in the Budget Filter field, a filtered budget. The contents of the field are calculated by using the entries in the Amount field in the Cost Budget Entry table.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Budget Amount" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningstypens saldo.;
                           ENU=Specifies the balance of the cost type.];
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr=Balance;
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Blocked }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil starte en ny side direkte efter dette omkostningssted, n†r du udskriver diagrammet over pengestr›mskonti.;
                           ENU=Specifies if you want a new page to start immediately after this cost center when you print the chart of cash flow accounts.];
                ApplicationArea=#CostAccounting;
                SourceExpr="New Page" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal v‘re en tom linje umiddelbart efter dette omkostningssted, n†r du printer diagrammet over omkostningssteder. Felterne Ny side, Tom linje og Indrykning definerer layoutet af diagrammet over omkostningssteder.;
                           ENU=Specifies whether you want a blank line to appear immediately after this cost center when you print the chart of cost centers. The New Page, Blank Line, and Indentation fields define the layout of the chart of cost centers.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Blank Line" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobel›b, der stadig kan allokeres. Posten i feltet Allokeret i tabellen Omkostningspost bestemmer, om en omkostningspost er en del af dette felt.;
                           ENU=Specifies the net amount that can still be allocated. The entry in the Allocated field in the Cost Entry table determines whether a cost entry is a part of this field.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Balance to Allocate" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den omkostningstypesaldoen p† den sidste dag, der er inkluderet i feltet Datofilter. Indholdet af feltet beregnes ved at bruge posterne i feltet Bel›b i tabellen Omkostningspost.;
                           ENU=Specifies the cost type balance on the last date that is included in the Date Filter field. The contents of the field are calculated by using the entries in the Amount field in the Cost Entry table.];
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr="Balance at Date";
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
      CostAccMgt@1000 : Codeunit 1100;
      NameIndent@19079073 : Integer INDATASET;

    [External]
    PROCEDURE SetSelection@1(VAR CostType@1000 : Record 1103);
    BEGIN
      CurrPage.SETSELECTIONFILTER(CostType);
    END;

    [Internal]
    PROCEDURE GetSelectionFilter@6() : Text;
    VAR
      CostType@1001 : Record 1103;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(CostType);
      EXIT(SelectionFilterManagement.GetSelectionFilterForCostType(CostType));
    END;

    BEGIN
    END.
  }
}

