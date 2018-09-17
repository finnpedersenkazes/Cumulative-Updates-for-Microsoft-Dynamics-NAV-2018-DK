OBJECT Page 16 Chart of Accounts
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontoplan;
               ENU=Chart of Accounts];
    SourceTable=Table15;
    PageType=List;
    CardPageID=G/L Account Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Periodiske aktiviteter;
                                ENU=New,Process,Report,Periodic Activities];
    OnInit=BEGIN
             AmountVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 ShowAmounts;
               END;

    OnAfterGetRecord=BEGIN
                       NoEmphasize := "Account Type" <> "Account Type"::Posting;
                       NameIndent := Indentation;
                       NameEmphasize := "Account Type" <> "Account Type"::Posting;
                     END;

    OnNewRecord=BEGIN
                  SetupNewGLAcc(xRec,BelowxRec);
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 28      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Post&er;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 20;
                      RunPageView=SORTING(G/L Account No.);
                      RunPageLink=G/L Account No.=FIELD(No.);
                      Promoted=No;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 34      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 84      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=FÜ vist eller rediger de enkelte sët af dimensioner, der er oprettet for den valgte record.;
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
      { 13      ;3   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begrëns totalerne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the totals according to dimension filters that you specify.];
                      ApplicationArea=#Suite;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID Filter",DimensionSetIDFilter.LookupFilter);
                               END;
                                }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Udvidede &tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=Vis yderligere oplysninger, der er blevet fõjet til beskrivelsen for den aktuelle konto.;
                                 ENU=View additional information that has been added to the description for the current account.];
                      ApplicationArea=#Suite;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=Text }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Likviditet;
                                 ENU=Receivables-Payables];
                      ToolTipML=[DAN=Vis en oversigt over tilgodehavender og skyldige belõb for kontoen, herunder skyldige belõb for debitor- og kreditorsaldi.;
                                 ENU=View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 159;
                      Image=ReceivablesPayables }
      { 54      ;2   ;Action    ;
                      CaptionML=[DAN=IndgÜr-i-liste;
                                 ENU=Where-Used List];
                      ToolTipML=[DAN=Se opsëtningstabeller, hvor den aktuelle konto bruges.;
                                 ENU=Show setup tables where the current account is used.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Track;
                      OnAction=VAR
                                 CalcGLAccWhereUsed@1000 : Codeunit 100;
                               BEGIN
                                 CalcGLAccWhereUsed.CheckGLAcc("No.");
                               END;
                                }
      { 123     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Saldo;
                                 ENU=&Balance];
                      Image=Balance }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Finans&konto - saldo;
                                 ENU=G/L &Account Balance];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi for forskellige tidsintervaller for den konto, du har valgt i kontoplanen.;
                                 ENU=View a summary of the debit and credit balances for different time periods, for the account that you select in the chart of accounts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 415;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter);
                      Image=GLAccountBalance }
      { 132     ;2   ;Action    ;
                      CaptionML=[DAN=Finans - &saldi;
                                 ENU=G/L &Balance];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi pÜ alle konti i kontoplanen for det valgte tidsinterval.;
                                 ENU=View a summary of the debit and credit balances for all the accounts in the chart of accounts, for the time period that you select.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 414;
                      RunPageOnRec=Yes;
                      RunPageLink=Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter);
                      Image=GLBalance }
      { 126     ;2   ;Action    ;
                      CaptionML=[DAN=Finans - saldi pr. &dimension;
                                 ENU=G/L Balance by &Dimension];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi efter dimensioner for den aktuelle konto.;
                                 ENU=View a summary of the debit and credit balances by dimensions for the current account.];
                      ApplicationArea=#Suite;
                      RunObject=Page 408;
                      Image=GLBalanceDimension }
      { 53      ;2   ;Action    ;
                      CaptionML=[DAN=Finanskonto - saldo/bud&get;
                                 ENU=G/L Account Balance/Bud&get];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi og budgetterede belõb for forskellige tidsintervaller for den aktuelle konto.;
                                 ENU=View a summary of the debit and credit balances and the budgeted amounts for different time periods for the current account.];
                      ApplicationArea=#Suite;
                      RunObject=Page 154;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter),
                                  Budget Filter=FIELD(Budget Filter);
                      Image=Period }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Finans - saldi/b&udget;
                                 ENU=G/L Balance/B&udget];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi og budgetterede belõb for forskellige tidsintervaller for den aktuelle konto.;
                                 ENU=View a summary of the debit and credit balances and the budgeted amounts for different time periods for the current account.];
                      ApplicationArea=#Suite;
                      RunObject=Page 422;
                      RunPageOnRec=Yes;
                      RunPageLink=Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter),
                                  Budget Filter=FIELD(Budget Filter);
                      Image=ChartOfAccounts }
      { 56      ;2   ;Action    ;
                      CaptionML=[DAN=&Oversigt over kontoplan;
                                 ENU=Chart of Accounts &Overview];
                      ToolTipML=[DAN=Vis kontoplanen med forskellige detaljeniveauer, hvor du kan udvide eller skjule en del af kontoplanen.;
                                 ENU=View the chart of accounts with different levels of detail where you can expand or collapse a section of the chart of accounts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 634;
                      Image=Accounts }
      { 1900210203;1 ;Action    ;
                      CaptionML=[DAN=Finansjournal;
                                 ENU=G/L Register];
                      ToolTipML=[DAN=Vis bogfõrte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 116;
                      Promoted=Yes;
                      Image=GLRegisters;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 122     ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 30      ;2   ;Action    ;
                      Name=IndentChartOfAccounts;
                      CaptionML=[DAN=Indryk kontoplan;
                                 ENU=Indent Chart of Accounts];
                      ToolTipML=[DAN=Indryk konti mellem en Fra-sum og den tilhõrende Til-sum Çt niveau for at gõre kontoplanen mere overskuelig.;
                                 ENU=Indent accounts between a Begin-Total and the matching End-Total one level to make the chart of accounts easier to read.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 3;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=IndentChartOfAccounts;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 40      ;1   ;ActionGroup;
                      CaptionML=[DAN=Periodiske aktiviteter;
                                 ENU=Periodic Activities] }
      { 70      ;2   ;Action    ;
                      CaptionML=[DAN=Finanskladde;
                                 ENU=General Journal];
                      ToolTipML=[DAN=èbn finanskladden, for eksempel for at registrere eller bogfõre en betaling, der ikke har et tilknyttet bilag.;
                                 ENU=Open the general journal, for example, to record or post a payment that has no related document.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 39;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Journal;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Nulstil resultatopgõrelse;
                                 ENU=Close Income Statement];
                      ToolTipML=[DAN=Start overfõrslen af Ürets resultat til en konto i balancen, og resultatopgõrelseskonti.;
                                 ENU=Start the transfer of the year's result to an account in the balance sheet and close the income statement accounts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 94;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CloseYear;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 5       ;2   ;Action    ;
                      Name=DocsWithoutIC;
                      CaptionML=[DAN=Bogfõrte dokumenter uden indgÜende bilag;
                                 ENU=Posted Documents without Incoming Document];
                      ToolTipML=[DAN=Se en liste over bogfõrte kõbs- og salgsdokumenter under finanskontoen, som ikke har relaterede indgÜende bilagsrecords.;
                                 ENU=Show a list of posted purchase and sales documents under the G/L account that do not have related incoming document records.];
                      ApplicationArea=#Advanced;
                      Image=Documents;
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
      { 1900000006;  ;ActionContainer;
                      ActionContainerType=Reports }
      { 1900670506;1 ;Action    ;
                      CaptionML=[DAN=Detaljeret rÜbalance;
                                 ENU=Detail Trial Balance];
                      ToolTipML=[DAN=Vis eller gem en detaljeret rÜbalance for de finanskonti, du angiver.;
                                 ENU=View a detail trial balance for the general ledger accounts that you specify.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 4;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
      { 1904082706;1 ;Action    ;
                      CaptionML=[DAN=Balance;
                                 ENU=Trial Balance];
                      ToolTipML=[DAN=Vis kontoplanen med saldi og bevëgelser.;
                                 ENU=View the chart of accounts that have balances and net changes.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 6;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
      { 1902174606;1 ;Action    ;
                      CaptionML=[DAN=RÜbalance efter periode;
                                 ENU=Trial Balance by Period];
                      ToolTipML=[DAN=Vis primosaldoen efter finanskonto, bevëgelserne i den valgte periode for mÜned, kvartal eller Ür og den resulterende ultimosaldo.;
                                 ENU=View the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 38;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900210206;1 ;Action    ;
                      CaptionML=[DAN=Finansjournal;
                                 ENU=G/L Register];
                      ToolTipML=[DAN=Vis bogfõrte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 3;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
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
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=NoEmphasize }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ finanskontoen.;
                           ENU=Specifies the name of the general ledger account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=NameEmphasize }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en finanskonto er en resultatopgõrelseskonto eller en balancekonto.;
                           ENU=Specifies whether a general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Income/Balance" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kategorien for finanskontoen.;
                           ENU=Specifies the category of the G/L account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Category";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                DrillDown=No;
                CaptionML=[DAN=Kontounderkategori;
                           ENU=Account Subcategory];
                ToolTipML=[DAN=Angiver underkategorien for finanskontoens kontokategori.;
                           ENU=Specifies the subcategory of the account category of the G/L account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Subcategory Descript." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver formÜlet med kontoen. I alt: Bruges til at sammentëlle en rëkke saldi pÜ konti fra mange forskellige grupper. Lad feltet stÜ tomt, hvis du vil bruge I alt. Fra-Sum: En markering af begyndelsen af en rëkke konti, der skal sammentëlles og slutter med en Til-sum-konto. Til-sum: Det samlede antal konti, der starter med den foregÜende Fra-sum-konto. Det samlede antal er defineret i feltet Sammentëlling.;
                           ENU=Specifies the purpose of the account. Total: Used to total a series of balances on accounts from many different account groupings. To use Total, leave this field blank. Begin-Total: A marker for the beginning of a series of accounts to be totaled that ends with an End-Total account. End-Total: A total of a series of accounts that starts with the preceding Begin-Total account. The total is defined in the Totaling field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der mÜ bogfõres direkte eller kun indirekte pÜ denne finanskonto.;
                           ENU=Specifies whether you will be able to post directly or only indirectly to this general ledger account.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Posting";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen sammentëlles for at give en balancesum. Hvordan poster sammentëlles afhënger af vërdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Totaling;
                OnLookup=VAR
                           GLaccList@1000 : Page 18;
                         BEGIN
                           GLaccList.LOOKUPMODE(TRUE);
                           IF NOT (GLaccList.RUNMODAL = ACTION::LookupOK) THEN
                             EXIT(FALSE);

                           Text := GLaccList.GetSelectionFilter;
                           EXIT(TRUE);
                         END;
                          }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogfõringstype, der skal bruges ved bogfõring pÜ denne konto.;
                           ENU=Specifies the general posting type to use when posting to this account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Posting Type" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bevëgelsen pÜ kontosaldoen i den periode, der er indtastet i feltet Datofilter.;
                           ENU=Specifies the net change in the account balance during the time period in the Date Filter field.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Net Change";
                Visible=AmountVisible }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der reprësenterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=DebitCreditVisible }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der reprësenterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=DebitCreditVisible }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver finanskontoens saldo pÜ den sidste dato i feltet Datofilter.;
                           ENU=Specifies the G/L account balance on the last date included in the Date Filter field.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Balance at Date";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver saldoen pÜ denne konto.;
                           ENU=Specifies the balance on this account.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=Balance }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bevëgelsen pÜ kontosaldoen.;
                           ENU=Specifies the net change in the account balance.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Additional-Currency Net Change";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver finanskontoens saldo (i den ekstra rapporteringsvaluta) pÜ den sidste dato i feltet Datofilter.;
                           ENU=Specifies the G/L account balance, in the additional reporting currency, on the last date included in the Date Filter field.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Add.-Currency Balance at Date";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver saldoen pÜ kontoen i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the balance on this account, in the additional reporting currency.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Additional-Currency Balance";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontonummeret i et konsolideret regnskab, som kreditsaldi skal overfõres til.;
                           ENU=Specifies the account number in a consolidated company to transfer credit balances.];
                ApplicationArea=#Advanced;
                SourceExpr="Consol. Debit Acc.";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der bruges belõb uden nogen betalingstolerancebelõb fra debitor- og kreditorposterne.;
                           ENU=Specifies if amounts without any payment tolerance amount from the customer and vendor ledger entries are used.];
                ApplicationArea=#Advanced;
                SourceExpr="Consol. Credit Acc.";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et omkostningstypenummer til definition af, hvilken omkostningstype en finanskonto tilhõrer.;
                           ENU=Specifies a cost type number to establish which cost type a general ledger account belongs to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Type No." }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den metode til konsolideringsomregning, som bruges til kontoen.;
                           ENU=Specifies the consolidation translation method that will be used for the account.];
                ApplicationArea=#Advanced;
                SourceExpr="Consol. Translation Method";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de konti, som du ofte angiver i feltet Modkontonr. pÜ IC-kladde- eller -dokumentlinjer.;
                           ENU=Specifies accounts that you often enter in the Bal. Account No. field on intercompany journal or document lines.];
                ApplicationArea=#Intercompany;
                SourceExpr="Default IC Partner G/L Acc. No";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Standardperiodiseringsskabelon;
                           ENU=Default Deferral Template];
                ToolTipML=[DAN=Angiver standardperiodiseringsskabelonen, der styrer, hvordan indtjening og udgifter skal periodiseres til perioderne, nÜr de indtrëffer.;
                           ENU=Specifies the default deferral template that governs how to defer revenues and expenses to the periods when they occurred.];
                ApplicationArea=#Suite;
                SourceExpr="Default Deferral Template Code" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1905532107;1;Part   ;
                ApplicationArea=#Advanced;
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
      DimensionSetIDFilter@1003 : Page 481;
      NoEmphasize@1000 : Boolean INDATASET;
      NameEmphasize@1001 : Boolean INDATASET;
      NameIndent@1002 : Integer INDATASET;
      AmountVisible@1004 : Boolean;
      DebitCreditVisible@1005 : Boolean;

    LOCAL PROCEDURE ShowAmounts@8();
    VAR
      GLSetup@1000 : Record 98;
    BEGIN
      GLSetup.GET;
      AmountVisible := NOT (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
      DebitCreditVisible := NOT (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
    END;

    BEGIN
    END.
  }
}

