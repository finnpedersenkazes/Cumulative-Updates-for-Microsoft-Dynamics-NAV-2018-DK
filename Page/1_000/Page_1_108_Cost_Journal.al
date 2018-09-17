OBJECT Page 1108 Cost Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningskladde;
               ENU=Cost Journal];
    SaveValues=Yes;
    SourceTable=Table1101;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Template Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport�r,Side;
                                ENU=New,Process,Report,Page];
    OnInit=BEGIN
             BalanceVisible := TRUE;
             TotalBalanceVisible := TRUE;
             TotalBalance := 0;
           END;

    OnOpenPage=VAR
                 ServerConfigSettingHandler@1001 : Codeunit 6723;
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 IF IsOpenedFromBatch THEN BEGIN
                   CostJnlBatchName := "Journal Batch Name";
                   CostJnlMgt.OpenJnl(CostJnlBatchName,Rec);
                   EXIT;
                 END;
                 CostJnlMgt.TemplateSelection(Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 CostJnlMgt.OpenJnl(CostJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       xRec := Rec;
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                  xRec := Rec;
                  UpdateLineBalance;
                END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateLineBalance;
                         END;

    ActionList=ACTIONS
    {
      { 1       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&ost];
                      Image=PostOrder }
      { 3       ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Bogf�r oplysningerne i kladden til det relaterede omkostningsregister, eksempelvis rene omkostningsposter, interne afgifter mellem omkostningssteder, manuelle fordelinger og korrigerende poster mellem omkostningstyper, omkostningssteder og omkostningsemner.;
                                 ENU=Post information in the journal to the related cost register, such as pure cost entries, internal charges between cost centers, manual allocations, and corrective entries between cost types, cost centers, and cost objects.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"CA Jnl.-Post",Rec);
                                 CostJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 4       ;2   ;Action    ;
                      Name=TestReport;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s� du kan finde og rette eventuelle fejl, f�r du udf�rer den faktiske bogf�ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#CostAccounting;
                      Image=TestReport;
                      OnAction=BEGIN
                                 SETRANGE("Journal Template Name","Journal Template Name");
                                 SETRANGE("Journal Batch Name","Journal Batch Name");
                                 REPORT.RUN(REPORT::"Cost Acctg. Journal",TRUE,FALSE,Rec);
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Name=PostandPrint;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bogf�r eller udskriv oplysningerne i kladden til det relaterede omkostningsregister, eksempelvis rene omkostningsposter, interne afgifter mellem omkostningssteder, manuelle fordelinger og korrigerende poster mellem omkostningstyper, omkostningssteder og omkostningsemner.;
                                 ENU=Post or print information in the journal to the related cost register, such as pure cost entries, internal charges between cost centers, manual allocations, and corrective entries between cost types, cost centers, and cost objects.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"CA Jnl.-Post+Print",Rec);
                                 CostJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 35      ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 34      ;2   ;Action    ;
                      Name=EditInExcel;
                      CaptionML=[DAN=Rediger i Excel;
                                 ENU=Edit in Excel];
                      ToolTipML=[DAN=Send dataene i kladden til en Excel-fil til analyse eller redigering.;
                                 ENU=Send the data in the journal to an Excel file for analysis or editing.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      Visible=IsSaasExcelAddinEnabled;
                      PromotedIsBig=Yes;
                      Image=Excel;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ODataUtility@1000 : Codeunit 6710;
                               BEGIN
                                 ODataUtility.EditJournalWorksheetInExcel(CurrPage.CAPTION,CurrPage.OBJECTID(FALSE),"Journal Batch Name","Journal Template Name");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 5   ;0   ;Container ;
                ContainerType=ContentArea }

    { 6   ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p� den kladdek�rsel, et personligt kladdelayout, som kladden er baseret p�.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#CostAccounting;
                SourceExpr=CostJnlBatchName;
                OnValidate=BEGIN
                             CostJnlMgt.CheckName(CostJnlBatchName,Rec);

                             CurrPage.SAVERECORD;
                             CostJnlMgt.SetName(CostJnlBatchName,Rec);
                             CurrPage.UPDATE(FALSE);
                           END;

                OnLookup=BEGIN
                           CostJnlMgt.LookupName(CostJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 7   ;1   ;Group     ;
                GroupType=Repeater }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf�ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Posting Date" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det relaterede bilag.;
                           ENU=Specifies the number of the related document.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Document No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsstedets undertype. Dette er et oplysningsfelt og bruges ikke til nogen andre form�l. V�lg feltet for at v�lge omkostningsundertype.;
                           ENU=Specifies the subtype of the cost center. This is an information field and is not used for any other purposes. Choose the field to select the cost subtype.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Type No." }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsstedets kode. Koden fungerer som en standardv�rdi for omkostningsbogf�ring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost center code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Center Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsemnets kode. Koden fungerer som en standardv�rdi for omkostningsbogf�ring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost object code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Object Code" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af omkostningskladdeposten.;
                           ENU=Specifies a description of the cost journal entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel�bet for posten i omkostningskladden.;
                           ENU=Specifies the amount of the entry in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Amount }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den type, som en udlignende post for kladdelinjen bogf�res til.;
                           ENU=Specifies the number of the type that a balancing entry for the journal line is posted to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Bal. Cost Type No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det omkostningssted, som en udlignende post for kladdelinjen bogf�res til.;
                           ENU=Specifies the number of the cost center that a balancing entry for the journal line is posted to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Bal. Cost Center Code" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det omkostningssted, som en udlignende post for kladdelinjen bogf�res til.;
                           ENU=Specifies the number of the cost center that a balancing entry for the journal line is posted to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Bal. Cost Object Code" }

    { 18  ;2   ;Field     ;
                Name=LineBalance;
                ToolTipML=[DAN=Angiver omkostningstypens saldo.;
                           ENU=Specifies the balance of the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Balance;
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angivet postnummeret for den tilh�rende finanskontopost, der er knyttet til denne omkostningspost. For kombinerede poster g�lder det, at postnummeret for den seneste finanskontopost gemmes i feltet. Dette er den post, der har det h�jeste postnummer.;
                           ENU=Specifies the entry number of the corresponding general ledger entry that is associated with this cost entry. For combined entries, the entry number of the last general ledger entry is saved in the field. This is the entry with the highest entry number.];
                ApplicationArea=#CostAccounting;
                SourceExpr="G/L Entry No.";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 21  ;1   ;Group      }

    { 22  ;2   ;Group     ;
                GroupType=FixedLayout }

    { 23  ;3   ;Group     ;
                CaptionML=[DAN=Omkostningstypenavn;
                           ENU=Cost Type Name] }

    { 24  ;4   ;Field     ;
                ApplicationArea=#CostAccounting;
                SourceExpr=CostTypeName;
                Editable=FALSE;
                ShowCaption=No }

    { 25  ;3   ;Group     ;
                CaptionML=[DAN=Balanceomkostningstypenavn;
                           ENU=Bal. Cost Type Name] }

    { 26  ;4   ;Field     ;
                CaptionML=[DAN=Balanceomkostningstypenavn;
                           ENU=Bal. Cost Type Name];
                ToolTipML=[DAN=Angiver navnet p� balanceomkostningstypen p� omkostningskladden.;
                           ENU=Specifies the name of the balance cost type on the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr=BalCostTypeName;
                Editable=FALSE }

    { 27  ;3   ;Group     ;
                CaptionML=[DAN=Saldo;
                           ENU=Balance] }

    { 28  ;4   ;Field     ;
                Name=Balance;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Angiver saldoen p� omkostningskladdelinjen.;
                           ENU=Specifies the balance on the cost journal line.];
                ApplicationArea=#CostAccounting;
                SourceExpr=LineBalance + Balance - xRec.Balance;
                Visible=BalanceVisible;
                Editable=FALSE }

    { 29  ;3   ;Group     ;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance] }

    { 30  ;4   ;Field     ;
                Name=TotalBalance;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance];
                ToolTipML=[DAN=Angiver den totale saldo p� omkostningskladden.;
                           ENU=Specifies the total balance on the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr=TotalBalance + Balance - xRec.Balance;
                Visible=TotalBalanceVisible;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      CostType@1001 : Record 1103;
      CostJnlMgt@1010 : Codeunit 1106;
      ClientTypeManagement@1077 : Codeunit 4;
      CostJnlBatchName@1005 : Code[10];
      CostTypeName@1006 : Text[50];
      BalCostTypeName@1007 : Text[50];
      LineBalance@1012 : Decimal;
      TotalBalance@1008 : Decimal;
      ShowBalance@1000 : Boolean;
      ShowTotalBalance@1002 : Boolean;
      BalanceVisible@1011 : Boolean INDATASET;
      TotalBalanceVisible@1004 : Boolean INDATASET;
      IsSaasExcelAddinEnabled@1003 : Boolean;

    LOCAL PROCEDURE UpdateLineBalance@2();
    BEGIN
      // Update Balance
      CostJnlMgt.CalcBalance(Rec,xRec,LineBalance,TotalBalance,ShowBalance,ShowTotalBalance);
      BalanceVisible := ShowBalance;
      TotalBalanceVisible := ShowTotalBalance;

      // Cost type and bal. Cost Type
      IF CostType.GET("Cost Type No.") THEN
        CostTypeName := CostType.Name
      ELSE
        CostTypeName := '';

      IF CostType.GET("Bal. Cost Type No.") THEN
        BalCostTypeName := CostType.Name
      ELSE
        BalCostTypeName := '';
    END;

    BEGIN
    END.
  }
}

