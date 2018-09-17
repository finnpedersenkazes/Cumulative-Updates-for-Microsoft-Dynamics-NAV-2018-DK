OBJECT Page 17 G/L Account Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finanskontokort;
               ENU=G/L Account Card];
    SourceTable=Table15;
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,Konto,Saldo;
                                ENU=New,Process,Report,Account,Balance];
    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Account Subcategory Descript.");
                       SubCategoryDescription := "Account Subcategory Descript.";
                     END;

    OnNewRecord=BEGIN
                  SetupNewGLAcc(xRec,BelowxRec);
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 41      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Post&er;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 20;
                      RunPageView=SORTING(G/L Account No.)
                                  ORDER(Descending);
                      RunPageLink=G/L Account No.=FIELD(No.);
                      Promoted=Yes;
                      Image=GLRegisters;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 84      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(15),
                                  No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 166     ;2   ;Action    ;
                      CaptionML=[DAN=Udvidede &tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=Vis yderligere oplysninger om en finanskonto - det supplerer feltet Beskrivelse.;
                                 ENU=View additional information about a general ledger account, this supplements the Description field.];
                      ApplicationArea=#Suite;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Text;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Likviditet;
                                 ENU=Receivables-Payables];
                      ToolTipML=[DAN=Se en oversigt over tilgodehavender og skyldige bel›b for kontoen, herunder skyldige bel›b for debitor- og kreditorsaldi.;
                                 ENU=View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 159;
                      Promoted=Yes;
                      Image=ReceivablesPayables;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 47      ;2   ;Action    ;
                      CaptionML=[DAN=Indg†r-i-liste;
                                 ENU=Where-Used List];
                      ToolTipML=[DAN=Se de ops‘tningstabeller, hvor der bruges en finanskonto.;
                                 ENU=View setup tables where a general ledger account is used.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Track;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CalcGLAccWhereUsed@1000 : Codeunit 100;
                               BEGIN
                                 CalcGLAccWhereUsed.CheckGLAcc("No.");
                               END;
                                }
      { 136     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Saldo;
                                 ENU=&Balance];
                      Image=Balance }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=Finans&konto - saldo;
                                 ENU=G/L &Account Balance];
                      ToolTipML=[DAN=Se en oversigt over debet- og kreditsaldi for forskellige tidsintervaller for den konto, du har valgt i kontoplanen.;
                                 ENU=View a summary of the debit and credit balances for different time periods, for the account that you select in the chart of accounts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 415;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter);
                      Promoted=Yes;
                      Image=GLAccountBalance;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 154     ;2   ;Action    ;
                      CaptionML=[DAN=Finans - &saldi;
                                 ENU=G/L &Balance];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi p† alle konti i kontoplanen for det valgte tidsinterval.;
                                 ENU=View a summary of the debit and credit balances for all the accounts in the chart of accounts, for the time period that you select.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 414;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      Image=GLBalance;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 138     ;2   ;Action    ;
                      CaptionML=[DAN=Finans - saldi pr. &dimension;
                                 ENU=G/L Balance by &Dimension];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi efter dimensioner for den aktuelle konto.;
                                 ENU=View a summary of the debit and credit balances by dimensions for the current account.];
                      ApplicationArea=#Suite;
                      RunObject=Page 408;
                      Promoted=Yes;
                      Image=GLBalanceDimension;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 1906497203;1 ;Action    ;
                      CaptionML=[DAN=Bogf›ringsops‘tning;
                                 ENU=General Posting Setup];
                      ToolTipML=[DAN=Se eller rediger, hvordan du vil oprette kombinationer af virksomheds- og produktbogf›ringsgrupper.;
                                 ENU=View or edit how you want to set up combinations of general business and general product posting groups.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 314;
                      Promoted=Yes;
                      Image=GeneralPostingSetup;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 1900660103;1 ;Action    ;
                      CaptionML=[DAN=Ops‘tning af momsbogf.;
                                 ENU=VAT Posting Setup];
                      ToolTipML=[DAN=Se eller rediger kombinationer af momsvirksomhedsbogf›ringsgrupper og momsproduktbogf›ringsgrupper.;
                                 ENU=View or edit combinations of Tax business posting groups and Tax product posting groups.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 472;
                      Promoted=Yes;
                      Image=VATPostingSetup;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 1900210203;1 ;Action    ;
                      CaptionML=[DAN=Finansjournal;
                                 ENU=G/L Register];
                      ToolTipML=[DAN=Vis bogf›rte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 116;
                      Promoted=Yes;
                      Image=GLRegisters;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 15      ;1   ;Action    ;
                      Name=DocsWithoutIC;
                      CaptionML=[DAN=Bogf›rte bilag uden indg†ende bilag;
                                 ENU=Posted Documents without Incoming Document];
                      ToolTipML=[DAN=Se en liste over bogf›rte k›bs- og salgsbilag under finanskontoen, som ikke har relaterede indg†ende bilagsrecords.;
                                 ENU=Show a list of posted purchase and sales documents under the G/L account that do not have related incoming document records.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Documents;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 PostedDocsWithNoIncBuf@1001 : Record 134;
                               BEGIN
                                 IF "Account Type" = "Account Type"::Posting THEN
                                   PostedDocsWithNoIncBuf.SETRANGE("G/L Account No. Filter","No.")
                                 ELSE
                                   IF Totaling <> '' THEN
                                     PostedDocsWithNoIncBuf.SETFILTER("G/L Account No. Filter",Totaling)
                                   ELSE
                                     EXIT;
                                 PAGE.RUN(PAGE::"Posted Docs. With No Inc. Doc.",PostedDocsWithNoIncBuf);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1900670506;1 ;Action    ;
                      CaptionML=[DAN=Detaljeret r†balance;
                                 ENU=Detail Trial Balance];
                      ToolTipML=[DAN=Vis detaljerede finanskontosaldi og aktiviteter for alle valgte konti med ‚n transaktion pr. linje.;
                                 ENU=View detail general ledger account balances and activities for all the selected accounts, one transaction per line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 4;
                      Image=Report;
                      PromotedCategory=Report }
      { 1904082706;1 ;Action    ;
                      CaptionML=[DAN=Balance;
                                 ENU=Trial Balance];
                      ToolTipML=[DAN=Vis finanskontosaldi og aktiviteter for alle valgte konti med ‚n transaktion pr. linje.;
                                 ENU=View general ledger account balances and activities for all the selected accounts, one transaction per line.];
                      ApplicationArea=#Suite;
                      RunObject=Report 6;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902174606;1 ;Action    ;
                      CaptionML=[DAN=R†balance efter periode;
                                 ENU=Trial Balance by Period];
                      ToolTipML=[DAN=Vis finanskontosaldi og aktiviteter for alle valgte konti med ‚n transaktion pr. linje for en valgt periode.;
                                 ENU=View general ledger account balances and activities for all the selected accounts, one transaction per line for a selected period.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 38;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900210206;1 ;Action    ;
                      CaptionML=[DAN=Finansjournal;
                                 ENU=G/L Register];
                      ToolTipML=[DAN=Vis bogf›rte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Suite;
                      RunObject=Report 3;
                      Image=GLRegisters;
                      PromotedCategory=Report }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 61      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 62      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Anvend skabelon;
                                 ENU=Apply Template];
                      ToolTipML=[DAN=V‘lg en konfigurationsskabelon for hurtigt at oprette en finanskonto.;
                                 ENU=Select a configuration template to quickly create a general ledger account.];
                      ApplicationArea=#Advanced;
                      Image=ApplyTemplate;
                      OnAction=VAR
                                 ConfigTemplateMgt@1000 : Codeunit 8612;
                                 RecRef@1001 : RecordRef;
                               BEGIN
                                 RecRef.GETTABLE(Rec);
                                 ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Importance=Promoted }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† finanskontoen.;
                           ENU=Specifies the name of the general ledger account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Importance=Promoted }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en finanskonto er en resultatopg›relseskonto eller en balancekonto.;
                           ENU=Specifies whether a general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Income/Balance";
                Importance=Promoted }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kategorien for finanskontoen.;
                           ENU=Specifies the category of the G/L account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Category";
                OnLookup=BEGIN
                           CurrPage.UPDATE;
                         END;
                          }

    { 13  ;2   ;Field     ;
                Name=SubCategoryDescription;
                CaptionML=[DAN=Kontounderkategori;
                           ENU=Account Subcategory];
                ToolTipML=[DAN=Angiver underkategorien for finanskontoens kontokategori.;
                           ENU=Specifies the subcategory of the account category of the G/L account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SubCategoryDescription;
                OnValidate=BEGIN
                             ValidateAccountSubCategory(SubCategoryDescription);
                             CurrPage.UPDATE;
                           END;

                OnLookup=BEGIN
                           LookupAccountSubCategory;
                           CurrPage.UPDATE;
                         END;
                          }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type poster der normalt bogf›res p† denne finanskonto.;
                           ENU=Specifies the type of entries that will normally be posted to this general ledger account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit/Credit" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form†let med kontoen. I alt: Bruges til at samment‘lle en r‘kke saldi p† konti fra mange forskellige grupper. Lad feltet st† tomt, hvis du vil bruge I alt. Fra-Sum: En markering af begyndelsen af en r‘kke konti, der skal samment‘lles og slutter med en Til-sum-konto. Til-sum: Det samlede antal konti, der starter med den foreg†ende Fra-sum-konto. Det samlede antal er defineret i feltet Samment‘lling.;
                           ENU=Specifies the purpose of the account. Total: Used to total a series of balances on accounts from many different account groupings. To use Total, leave this field blank. Begin-Total: A marker for the beginning of a series of accounts to be totaled that ends with an End-Total account. End-Total: A total of a series of accounts that starts with the preceding Begin-Total account. The total is defined in the Totaling field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment‘lles for at give en balancesum. Hvordan poster samment‘lles afh‘nger af v‘rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Totaling;
                OnLookup=VAR
                           GLAccountList@1000 : Page 18;
                           OldText@1002 : Text;
                         BEGIN
                           OldText := Text;
                           GLAccountList.LOOKUPMODE(TRUE);
                           IF NOT (GLAccountList.RUNMODAL = ACTION::LookupOK) THEN
                             EXIT(FALSE);

                           Text := OldText + GLAccountList.GetSelectionFilter;
                           EXIT(TRUE);
                         END;
                          }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal tomme linjer, der skal inds‘ttes i kontoplanen, f›r denne konto.;
                           ENU=Specifies the number of blank lines that you want inserted before this account in the chart of accounts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Blank Lines";
                Importance=Additional }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal starte en ny side umiddelbart efter denne finanskonto ved udskrivning af kontoplanen. V‘lg dette felt for at starte en ny side efter finanskontoen.;
                           ENU=Specifies whether you want a new page to start immediately after this general ledger account when you print the chart of accounts. Select this field toÿstart a new page after thisÿgeneral ledgerÿaccount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="New Page";
                Importance=Additional }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s›ge efter den ›nskede record, hvis du ikke kan huske v‘rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Search Name";
                Importance=Additional }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver saldoen p† denne konto.;
                           ENU=Specifies the balance on this account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Balance;
                Importance=Promoted }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om denne finanskonto skal med i vinduet Afstemning i kassekladden. Mark‚r afkrydsningsfeltet, hvis finanskontoen skal med i vinduet. Vinduet Afstemning †bnes ved at klikke p† knappen Handlinger, Bogf›ring i vinduet Finanskladde.;
                           ENU=Specifies whether this general ledger account will be included in the Reconciliation window in the general journal. To have the G/L account included in the window, place a check mark in the check box. You can find the Reconciliation window by clicking Actions, Posting in the General Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reconciliation Account" }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en udvidet tekst tilf›jes automatisk p† kontoen.;
                           ENU=Specifies that an extended text will be added automatically to the account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Automatic Ext. Texts" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der m† bogf›res direkte p† finanskontoen eller kun indirekte. Mark‚r afkrydsningsfeltet, hvis der m† bogf›res direkte p† finanskontoen.;
                           ENU=Specifies whether you will be able to post directly or only indirectly to this general ledger account. To allow Direct Posting to the G/L account, place a check mark in the check box.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Direct Posting" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r der sidst blev rettet i den p†g‘ldende finanskonto.;
                           ENU=Specifies when the G/L account was last modified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date Modified" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om standardbeskrivelsen inds‘ttes automatisk i feltet Beskrivelse p† kladdelinjer, der er oprettet til denne finanskonto.;
                           ENU=Specifies if the default description is automatically inserted in the Description field on journal lines created for this general ledger account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Omit Default Descr. in Jnl." }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Bogf›ring;
                           ENU=Posting] }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringstype, der skal bruges ved bogf›ring p† denne konto.;
                           ENU=Specifies the general posting type to use when posting to this account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Posting Type" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group";
                Importance=Promoted }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Prod. Posting Group";
                Importance=Promoted }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                Importance=Promoted }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group";
                Importance=Promoted }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de konti, som du ofte angiver i feltet Modkontonr. p† IC-kladde- eller -dokumentlinjer.;
                           ENU=Specifies accounts that you often enter in the Bal. Account No. field on intercompany journal or document lines.];
                ApplicationArea=#Intercompany;
                SourceExpr="Default IC Partner G/L Acc. No" }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Standardperiodiseringsskabelon;
                           ENU=Default Deferral Template];
                ToolTipML=[DAN=Angiver standardperiodiseringsskabelonen, der styrer, hvordan indtjening og udgifter skal periodiseres til perioderne, n†r de indtr‘ffer.;
                           ENU=Specifies the default deferral template that governs how to defer revenues and expenses to the periods when they occurred.];
                ApplicationArea=#Suite;
                SourceExpr="Default Deferral Template Code" }

    { 1904602201;1;Group  ;
                CaptionML=[DAN=Konsolidering;
                           ENU=Consolidation] }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer i et konsolideret regnskab, som kontoens debetsaldi skal overf›res til.;
                           ENU=Specifies the number of the account in a consolidated company to which to transfer debit balances on this account.];
                ApplicationArea=#Suite;
                SourceExpr="Consol. Debit Acc.";
                Importance=Promoted }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer i et konsolideret regnskab, som kontoens kreditsaldi skal overf›res til.;
                           ENU=Specifies the number of the account in a consolidated company to which to transfer credit balances on this account.];
                ApplicationArea=#Suite;
                SourceExpr="Consol. Credit Acc.";
                Importance=Promoted }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontoens metode til konsolideringsomregning, som identificerer den valutaomregningskurs, der skal anvendes til kontoen.;
                           ENU=Specifies the account's consolidation translation method, which identifies the currency translation rate to be applied to the account.];
                ApplicationArea=#Suite;
                SourceExpr="Consol. Translation Method";
                Importance=Promoted }

    { 1904488501;1;Group  ;
                CaptionML=[DAN=Rapportering;
                           ENU=Reporting] }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan finanskontoen skal reguleres for kursudsving mellem regnskabsvalutaen og den ekstra rapporteringsvaluta.;
                           ENU=Specifies how general ledger accounts will be adjusted for exchange rate fluctuations between LCY and the additional reporting currency.];
                ApplicationArea=#Suite;
                SourceExpr="Exchange Rate Adjustment";
                Importance=Promoted }

    { 3   ;1   ;Group     ;
                CaptionML=[DAN=Omkostningsregnskab;
                           ENU=Cost Accounting];
                GroupType=Group }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et omkostningstypenummer til definition af, hvilken omkostningstype en finanskonto tilh›rer.;
                           ENU=Specifies a cost type number to establish which cost type a general ledger account belongs to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Type No.";
                Importance=Promoted }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1905532107;1;Part   ;
                ApplicationArea=#Dimensions;
                SubPageLink=Table ID=CONST(15),
                            No.=FIELD(No.);
                PagePartID=Page9083;
                Visible=FALSE;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      SubCategoryDescription@1000 : Text[80];

    BEGIN
    END.
  }
}

