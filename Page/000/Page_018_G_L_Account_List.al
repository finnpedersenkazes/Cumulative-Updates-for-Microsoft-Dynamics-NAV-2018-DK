OBJECT Page 18 G/L Account List
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
    CaptionML=[DAN=Finanskontooversigt;
               ENU=G/L Account List];
    SourceTable=Table15;
    DataCaptionFields=Search Name;
    PageType=List;
    CardPageID=G/L Account Card;
    RefreshOnActivate=Yes;
    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       FormatLine;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 23      ;2   ;Action    ;
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
                      Image=CustomerLedger }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=ViewComments }
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
                      Image=Dimensions }
      { 132     ;2   ;Action    ;
                      CaptionML=[DAN=Udvidede &tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=Vis yderligere oplysninger om en finanskonto - det supplerer feltet Beskrivelse.;
                                 ENU=View additional information about a general ledger account, this supplements the Description field.];
                      ApplicationArea=#Suite;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=Text }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=Likviditet;
                                 ENU=Receivables-Payables];
                      ToolTipML=[DAN=Se en oversigt over tilgodehavender og skyldige bel›b for kontoen, herunder skyldige bel›b for debitor- og kreditorsaldi.;
                                 ENU=View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 159;
                      Image=ReceivablesPayables }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Indg†r-i-liste;
                                 ENU=Where-Used List];
                      ToolTipML=[DAN=Se de ops‘tningstabeller, hvor der bruges en finanskonto.;
                                 ENU=View setup tables where a general ledger account is used.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Track;
                      OnAction=VAR
                                 CalcGLAccWhereUsed@1000 : Codeunit 100;
                               BEGIN
                                 CalcGLAccWhereUsed.CheckGLAcc("No.");
                               END;
                                }
      { 118     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Saldo;
                                 ENU=&Balance];
                      Image=Balance }
      { 32      ;2   ;Action    ;
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
                      PromotedCategory=Process }
      { 126     ;2   ;Action    ;
                      CaptionML=[DAN=Finans - &saldi;
                                 ENU=G/L &Balance];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi p† alle konti i kontoplanen for det valgte tidsinterval.;
                                 ENU=View a summary of the debit and credit balances for all the accounts in the chart of accounts, for the time period that you select.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 414;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      Image=GLBalance;
                      PromotedCategory=Process }
      { 120     ;2   ;Action    ;
                      CaptionML=[DAN=Finans - saldi pr. &dimension;
                                 ENU=G/L Balance by &Dimension];
                      ToolTipML=[DAN=Vis en oversigt over debet- og kreditsaldi efter dimensioner for den aktuelle konto.;
                                 ENU=View a summary of the debit and credit balances by dimensions for the current account.];
                      ApplicationArea=#Suite;
                      RunObject=Page 408;
                      Promoted=Yes;
                      Image=GLBalanceDimension;
                      PromotedCategory=Process }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1904082706;1 ;Action    ;
                      CaptionML=[DAN=Balance;
                                 ENU=Trial Balance];
                      ToolTipML=[DAN=Vis finanskontosaldi og aktiviteter for alle valgte konti med ‚n transaktion pr. linje.;
                                 ENU=View general ledger account balances and activities for all the selected accounts, one transaction per line.];
                      ApplicationArea=#Suite;
                      RunObject=Report 6;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902174606;1 ;Action    ;
                      CaptionML=[DAN=R†balance efter periode;
                                 ENU=Trial Balance by Period];
                      ToolTipML=[DAN=Vis finanskontosaldi og aktiviteter for alle valgte konti med ‚n transaktion pr. linje for en valgt periode.;
                                 ENU=View general ledger account balances and activities for all the selected accounts, one transaction per line for a selected period.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 38;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900670506;1 ;Action    ;
                      CaptionML=[DAN=Detaljeret r†balance;
                                 ENU=Detail Trial Balance];
                      ToolTipML=[DAN=Vis detaljerede finanskontosaldi og aktiviteter for alle valgte konti med ‚n transaktion pr. linje.;
                                 ENU=View detail general ledger account balances and activities for all the selected accounts, one transaction per line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 4;
                      Promoted=Yes;
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=Emphasize }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† finanskontoen.;
                           ENU=Specifies the name of the general ledger account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en finanskonto er en resultatopg›relseskonto eller en balancekonto.;
                           ENU=Specifies whether a general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Income/Balance" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kategorien for finanskontoen.;
                           ENU=Specifies the category of the G/L account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Category" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form†let med kontoen. I alt: Bruges til at samment‘lle en r‘kke saldi p† konti fra mange forskellige grupper. Lad feltet st† tomt, hvis du vil bruge I alt. Fra-Sum: En markering af begyndelsen af en r‘kke konti, der skal samment‘lles og slutter med en Til-sum-konto. Til-sum: Det samlede antal konti, der starter med den foreg†ende Fra-sum-konto. Det samlede antal er defineret i feltet Samment‘lling.;
                           ENU=Specifies the purpose of the account. Total: Used to total a series of balances on accounts from many different account groupings. To use Total, leave this field blank. Begin-Total: A marker for the beginning of a series of accounts to be totaled that ends with an End-Total account. End-Total: A total of a series of accounts that starts with the preceding Begin-Total account. The total is defined in the Totaling field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringstype, der skal bruges ved bogf›ring p† denne konto.;
                           ENU=Specifies the general posting type to use when posting to this account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Posting Type" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der m† bogf›res direkte p† finanskontoen eller kun indirekte. Mark‚r afkrydsningsfeltet, hvis der m† bogf›res direkte p† finanskontoen.;
                           ENU=Specifies whether you will be able to post directly or only indirectly to this general ledger account. To allow Direct Posting to the G/L account, place a check mark in the check box.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Direct Posting" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om denne finanskonto skal med i vinduet Afstemning i kassekladden. Mark‚r afkrydsningsfeltet, hvis finanskontoen skal med i vinduet. Vinduet Afstemning †bnes ved at klikke p† knappen Handlinger, Bogf›ring i vinduet Finanskladde.;
                           ENU=Specifies whether this general ledger account will be included in the Reconciliation window in the general journal. To have the G/L account included in the window, place a check mark in the check box. You can find the Reconciliation window by clicking Actions, Posting in the General Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reconciliation Account" }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Standardperiodiseringsskabelon;
                           ENU=Default Deferral Template];
                ToolTipML=[DAN=Angiver standardperiodiseringsskabelonen, der styrer, hvordan indtjening og udgifter skal periodiseres til perioderne, n†r de indtr‘ffer.;
                           ENU=Specifies the default deferral template that governs how to defer revenues and expenses to the periods when they occurred.];
                ApplicationArea=#Suite;
                SourceExpr="Default Deferral Template Code" }

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
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Emphasize@19018670 : Boolean INDATASET;
      NameIndent@19079073 : Integer INDATASET;

    [External]
    PROCEDURE SetSelection@1(VAR GLAcc@1000 : Record 15);
    BEGIN
      CurrPage.SETSELECTIONFILTER(GLAcc);
    END;

    [External]
    PROCEDURE GetSelectionFilter@3() : Text;
    VAR
      GLAcc@1001 : Record 15;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(GLAcc);
      EXIT(SelectionFilterManagement.GetSelectionFilterForGLAccount(GLAcc));
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

