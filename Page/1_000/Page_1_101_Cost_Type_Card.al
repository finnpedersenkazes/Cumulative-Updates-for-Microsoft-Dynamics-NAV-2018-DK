OBJECT Page 1101 Cost Type Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningstypekort;
               ENU=Cost Type Card];
    SourceTable=Table1103;
    PageType=Card;
    RefreshOnActivate=Yes;
    OnAfterGetRecord=BEGIN
                       SETRANGE("No.");
                     END;

    ActionList=ACTIONS
    {
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Omkostningstype;
                                 ENU=&Cost Type];
                      Image=Costs }
      { 3       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=P&oster;
                                 ENU=E&ntries];
                      ToolTipML=[DAN=Vis omkostningsposter, der er relateret til omkostningstypen.;
                                 ENU=View cost entries related to the cost type.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1103;
                      RunPageView=SORTING(Cost Type No.,Posting Date);
                      RunPageLink=Cost Type No.=FIELD(No.);
                      Image=Entries }
      { 4       ;2   ;Separator  }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=&Saldo;
                                 ENU=&Balance];
                      ToolTipML=[DAN=Vis en oversigt over saldoen til dato eller bev�gelsen for forskellige tidsintervaller for de omkostningstyper, du v�lger. Du kan v�lge forskellige tidsintervaller og indstille filtre p� de omkostningssteder og omkostningsemner, som du vil se.;
                                 ENU=View a summary of the balance at date or the net change for different time periods for the cost types that you select. You can select different time intervals and set filters on the cost centers and cost objects that you want to see.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1110;
                      RunPageLink=No.=FIELD(No.),
                                  Cost Center Filter=FIELD(Cost Center Filter),
                                  Cost Object Filter=FIELD(Cost Object Filter);
                      Image=Balance }
      { 6       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Omkostningsjournaler;
                                 ENU=Cost Registers];
                      ToolTipML=[DAN=Vis alle de overf�rte, bogf�rte og allokerede poster. Et register oprettes hver gang, en post overf�res, bogf�res eller allokeres.;
                                 ENU=View all the transferred, posted, and allocated entries. A register is created every time that an entry is transferred, posted, or allocated.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1104;
                      Promoted=Yes;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Finanskonto;
                                 ENU=G/L Account];
                      ToolTipML=[DAN=Vis finanskontoen for den valgte omkostningstype.;
                                 ENU=View the G/L account for the select cost type.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 16;
                      Promoted=Yes;
                      Image=JobPrice;
                      PromotedCategory=Process }
      { 9       ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Resultatopg. i omk.regnskab;
                                 ENU=Cost Acctg. P/L Statement];
                      ToolTipML=[DAN=Vis kredit- og debetsaldi pr. omkostningstype sammen med diagrammet over omkostningstyper.;
                                 ENU=View the credit and debit balances per cost type, together with the chart of cost types.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1126;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Res.opg�relse i omk.regnskab pr. periode;
                                 ENU=Cost Acctg. P/L Statement per Period];
                      ToolTipML=[DAN=Vis resultatopg�relsen for omkostningstyper over to perioder med sammenligning som en procentdel.;
                                 ENU=View profit and loss for cost types over two periods with the comparison as a percentage.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1123;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Res.opg�relse i omk.regnskab med budget;
                                 ENU=Cost Acctg. P/L Statement with Budget];
                      ToolTipML=[DAN=Vis en sammenligning af saldoen med budgettallene, som beregner varians og afvigelse i procent i den aktuelle regnskabsperiode, den akkumulerede regnskabsperiode og regnskabs�ret.;
                                 ENU=View a comparison of the balance to the budget figures and calculates the variance and the percent variance in the current accounting period, the accumulated accounting period, and the fiscal year.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1133;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Omk.regnskabsanalyse;
                                 ENU=Cost Acctg. Analysis];
                      ToolTipML=[DAN=Vis saldi pr. omkostningstype med kolonner for syv felter for omkostningssteder og omkostningsemner. Det bruges som omkostningsfordelingsark i omkostningsregnskabet. Strukturen i linjerne er baseret p� diagrammet over omkostningstyper. Du kan angive op til syv omkostningssteder og omkostningsemner, der vises som kolonner i rapporten.;
                                 ENU=View balances per cost type with columns for seven fields for cost centers and cost objects. It is used as the cost distribution sheet in Cost accounting. The structure of the lines is based on the chart of cost types. You define up to seven cost centers and cost objects that appear as columns in the report.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1127;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 15      ;1   ;Action    ;
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
    { 16  ;0   ;Container ;
                ContainerType=ContentArea }

    { 17  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#CostAccounting;
                SourceExpr="No." }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� omkostningstypen.;
                           ENU=Specifies the name of the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Name }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningstypen.;
                           ENU=Specifies the type of the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Type }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment�lles for at give en balancesum. Hvordan poster samment�lles afh�nger af v�rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Totaling }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indstillinger, der giver mulighed for, at finansposter kan bogf�res individuelt eller som en kombineret bogf�ring pr. eller m�ned.;
                           ENU=Specifies the option to allow for general ledger entries to be posted individually or as a combined posting per day or month.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Combine Entries" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et finanskontoomr�de til definition af, hvilken finanskonto en omkostningstype tilh�rer.;
                           ENU=Specifies a general ledger account range to establish which general ledger account a cost type belongs to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="G/L Account Range" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsstedets kode. Koden fungerer som en standardv�rdi for omkostningsbogf�ring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost center code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Center Code" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsemnets kode. Koden fungerer som en standardv�rdi for omkostningsbogf�ring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost object code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Object Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s�ge efter den �nskede record, hvis du ikke kan huske v�rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Search Name" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningstypens saldo.;
                           ENU=Specifies the balance of the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Balance;
                Importance=Promoted }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobel�b, der stadig kan allokeres. Posten i feltet Allokeret i tabellen Omkostningspost bestemmer, om en omkostningspost er en del af dette felt.;
                           ENU=Specifies the net amount that can still be allocated. The entry in the Allocated field in the Cost Entry table determines whether a cost entry is a part of this field.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Balance to Allocate" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningstype efter variabilitet.;
                           ENU=Specifies the cost type by variability.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Classification" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en forklaring p� feltet Klassificering af omkostninger.;
                           ENU=Specifies an explanation of the Cost Classification field.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Fixed Share" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal v�re en tom linje umiddelbart efter dette omkostningssted, n�r du printer diagrammet over omkostningssteder. Felterne Ny side, Tom linje og Indrykning definerer layoutet af diagrammet over omkostningssteder.;
                           ENU=Specifies whether you want a blank line to appear immediately after this cost center when you print the chart of cost centers. The New Page, Blank Line, and Indentation fields define the layout of the chart of cost centers.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Blank Line" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil starte en ny side direkte efter dette omkostningssted, n�r du udskriver diagrammet over pengestr�mskonti.;
                           ENU=Specifies if you want a new page to start immediately after this cost center when you print the chart of cash flow accounts.];
                ApplicationArea=#CostAccounting;
                SourceExpr="New Page" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf�res under transaktioner - eksempelvis en debitor, som er erkl�ret insolvent, eller en vare, som er sat i karant�ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Blocked }

    { 34  ;1   ;Group     ;
                CaptionML=[DAN=Statistik;
                           ENU=Statistics] }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r omkostningsemnet sidst blev rettet.;
                           ENU=Specifies when the cost object was last modified.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Modified Date" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver brugeren, som sidst redigerede omkostningsemnet.;
                           ENU=Specifies the user who last modified the cost object.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Modified By" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse, der g�lder for omkostningstypen.;
                           ENU=Specifies a description that applies to the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Comment }

    { 14  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 39  ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 38  ;1   ;Part      ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

