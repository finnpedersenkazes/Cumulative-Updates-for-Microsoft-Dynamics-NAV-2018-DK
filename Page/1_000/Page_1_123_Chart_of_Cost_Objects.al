OBJECT Page 1123 Chart of Cost Objects
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningsemner;
               ENU=Chart of Cost Objects];
    SourceTable=Table1113;
    DelayedInsert=Yes;
    SourceTableView=SORTING(Sorting Order);
    PageType=List;
    CardPageID=Cost Object Card;
    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       CodeOnFormat;
                       NameOnFormat;
                       BalanceatDateOnFormat;
                       NetChangeOnFormat;
                     END;

    OnDeleteRecord=BEGIN
                     CurrPage.SETSELECTIONFILTER(Rec);
                     ConfirmDeleteIfEntriesExist(Rec,FALSE);
                     RESET;
                   END;

    ActionList=ACTIONS
    {
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Omkostningsemne;
                                 ENU=&Cost Object];
                      Image=Costs }
      { 3       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Omkost&ningsposter;
                                 ENU=Cost E&ntries];
                      ToolTipML=[DAN=Vis omkostningsposter, som kan komme fra kilder s�som automatisk overf�rsel af finansposter til omkostningsposter, manuel bogf�ring for rene omkostningsposter, interne afgifter og manuelle allokeringer samt automatisk tildeling af bogf�ringer for faktiske omkostninger.;
                                 ENU=View cost entries, which can come from sources such as automatic transfer of general ledger entries to cost entries, manual posting for pure cost entries, internal charges, and manual allocations, and automatic allocation postings for actual costs.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1103;
                      RunPageView=SORTING(Cost Object Code,Cost Type No.,Allocated,Posting Date);
                      RunPageLink=Cost Object Code=FIELD(Code);
                      Image=CostEntries }
      { 4       ;2   ;Separator  }
      { 5       ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=&Saldo;
                                 ENU=&Balance];
                      ToolTipML=[DAN=Vis en oversigt over saldoen til dato eller bev�gelsen for forskellige tidsintervaller for det omkostningsemne, du v�lger. Du kan v�lge forskellige tidsintervaller og indstille filtre p� de omkostningssteder og omkostningsemner, som du vil se.;
                                 ENU=View a summary of the balance at date or the net change for different time periods for the cost object that you select. You can select different time intervals and set filters on the cost centers and cost objects that you want to see.];
                      ApplicationArea=#CostAccounting;
                      Image=Balance;
                      OnAction=BEGIN
                                 IF Totaling = '' THEN
                                   CostType.SETFILTER("Cost Object Filter",Code)
                                 ELSE
                                   CostType.SETFILTER("Cost Object Filter",Totaling);

                                 PAGE.RUN(PAGE::"Cost Type Balance",CostType);
                               END;
                                }
      { 6       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 8       ;2   ;Action    ;
                      CaptionML=[DAN=I&ndryk omkostningsemner;
                                 ENU=I&ndent Cost Objects];
                      ToolTipML=[DAN=Indryk de valgte linjer.;
                                 ENU=Indent the selected lines.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      Image=IndentChartOfAccounts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CostAccountMgt.IndentCostObjectsYN;
                               END;
                                }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Hent omkostningsemner fra dimensionen;
                                 ENU=Get Cost Objects From Dimension];
                      ToolTipML=[DAN=Overf�r dimensionsv�rdier til diagrammet over omkostningssteder.;
                                 ENU=Transfer dimension values to the chart of cost centers.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      Image=ChangeTo;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CostAccountMgt.CreateCostObjects;
                               END;
                                }
      { 11      ;1   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensionsv�rdier;
                                 ENU=Dimension Values];
                      ToolTipML=[DAN=Vis eller rediger dimensionsv�rdierne for den aktuelle dimension.;
                                 ENU=View or edit the dimension values for the current dimension.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DimValue@1000 : Record 349;
                               BEGIN
                                 CostAccSetup.GET;
                                 DimValue.SETRANGE("Dimension Code",CostAccSetup."Cost Object Dimension");
                                 PAGE.RUN(0,DimValue);
                               END;
                                }
      { 12      ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Omkostningsemne med budget;
                                 ENU=Cost Object with Budget];
                      ToolTipML=[DAN=Vis en sammenligning af saldoen med budgettallene, som beregner varians og afvigelse i procent i den aktuelle regnskabsperiode, den akkumulerede regnskabsperiode og regnskabs�ret.;
                                 ENU=View a comparison of the balance to the budget figures and calculates the variance and the percent variance in the current accounting period, the accumulated accounting period, and the fiscal year.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1138;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 15  ;0   ;Container ;
                ContainerType=ContentArea }

    { 16  ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for omkostningsemnet.;
                           ENU=Specifies the code for the cost object.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Code;
                Style=Strong;
                StyleExpr=Emphasize }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� omkostningsemnet.;
                           ENU=Specifies the name of the cost object.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form�let med omkostningsemnet, f.eks. Omkostningsemne, Overskrift eller Fra-sum. De nyoprettede omkostningsemner tildeles automatisk typen Omkostningsemne, men dette kan �ndres.;
                           ENU=Specifies the purpose of the cost object, such as Cost Object, Heading, or Begin-Total. Newly created cost objects are automatically assigned the Cost Object type, but you can change this.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Line Type" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment�lles for at give en balancesum. Hvordan poster samment�lles afh�nger af v�rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Totaling }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsemnernes sorteringsr�kkef�lge.;
                           ENU=Specifies the sorting order of the cost objects.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Sorting Order" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den omkostningstypesaldoen p� den sidste dag, der er inkluderet i feltet Datofilter. Indholdet af feltet beregnes ved at bruge posterne i feltet Bel�b i tabellen Omkostningspost.;
                           ENU=Specifies the cost type balance on the last date that is included in the Date Filter field. The contents of the field are calculated by using the entries in the Amount field in the Cost Entry table.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Balance at Date";
                Style=Strong;
                StyleExpr=Emphasize }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bev�gelsen p� kontosaldoen i den periode, der er indtastet i feltet Datofilter.;
                           ENU=Specifies the net change in the account balance during the time period in the Date Filter field.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Net Change";
                Style=Strong;
                StyleExpr=Emphasize }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse, der g�lder.;
                           ENU=Specifies a description that applies.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Comment }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf�res under transaktioner - eksempelvis en debitor, som er erkl�ret insolvent, eller en vare, som er sat i karant�ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Blocked }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil starte en ny side direkte efter dette omkostningssted, n�r du udskriver diagrammet over pengestr�mskonti.;
                           ENU=Specifies if you want a new page to start immediately after this cost center when you print the chart of cash flow accounts.];
                ApplicationArea=#CostAccounting;
                SourceExpr="New Page" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal v�re en tom linje umiddelbart efter dette omkostningssted, n�r du printer diagrammet over omkostningssteder. Felterne Ny side, Tom linje og Indrykning definerer layoutet af diagrammet over omkostningssteder.;
                           ENU=Specifies whether you want a blank line to appear immediately after this cost center when you print the chart of cost centers. The New Page, Blank Line, and Indentation fields define the layout of the chart of cost centers.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Blank Line" }

  }
  CODE
  {
    VAR
      CostType@1000 : Record 1103;
      CostAccSetup@1007 : Record 1108;
      CostAccountMgt@1001 : Codeunit 1100;
      Emphasize@1002 : Boolean INDATASET;
      NameIndent@1004 : Integer INDATASET;

    LOCAL PROCEDURE CodeOnFormat@1();
    BEGIN
      Emphasize := "Line Type" <> "Line Type"::"Cost Object";
    END;

    LOCAL PROCEDURE NameOnFormat@2();
    BEGIN
      NameIndent := Indentation;
      Emphasize := "Line Type" <> "Line Type"::"Cost Object";
    END;

    LOCAL PROCEDURE BalanceatDateOnFormat@3();
    BEGIN
      Emphasize := "Line Type" <> "Line Type"::"Cost Object";
    END;

    LOCAL PROCEDURE NetChangeOnFormat@4();
    BEGIN
      Emphasize := "Line Type" <> "Line Type"::"Cost Object";
    END;

    [Internal]
    PROCEDURE GetSelectionFilter@6() : Text;
    VAR
      CostObject@1001 : Record 1113;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(CostObject);
      EXIT(SelectionFilterManagement.GetSelectionFilterForCostObject(CostObject));
    END;

    BEGIN
    END.
  }
}

