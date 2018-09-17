OBJECT Page 381 Apply Bank Acc. Ledger Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udlign bankposter;
               ENU=Apply Bank Acc. Ledger Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table271;
    PageType=ListPart;
    OnInit=BEGIN
             AmountVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 ShowAmounts;
               END;

    OnAfterGetRecord=BEGIN
                       LineApplied := IsApplied;
                       SetUserInteractions;
                       CalcBalance;
                     END;

    OnModifyRecord=BEGIN
                     SetUserInteractions;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           LineApplied := IsApplied;
                           SetUserInteractions;
                           CalcBalance;
                         END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                Name=LineApplied;
                CaptionML=[DAN=Udlignet;
                           ENU=Applied];
                ToolTipML=[DAN=Angiver, om bankkontoposten er blevet udlignet den relaterede banktransaktion.;
                           ENU=Specifies if the bank account ledger entry has been applied to its related bank transaction.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=LineApplied;
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Editable=FALSE;
                StyleExpr=StyleTxt }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Dokumenttypen p† bankposten. dokumenttypen er Indbetaling eller Refusion, eller feltet er tomt.;
                           ENU=Specifies the document type on the bank account entry. The document type will be Payment, Refund, or the field will be blank.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for bankposten.;
                           ENU=Specifies the document number on the bank account entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af bankposten.;
                           ENU=Specifies the description of the bank account entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Editable=FALSE;
                StyleExpr=StyleTxt }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten, angivet i den relevante udenlandske valuta.;
                           ENU=Specifies the amount of the entry denominated in the applicable foreign currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                Visible=AmountVisible;
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=DebitCreditVisible }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=DebitCreditVisible }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, der mangler at blive udlignet. Bel›bet er angivet i den relevante udenlandske valuta.;
                           ENU=Specifies the amount that remains to be applied to. The amount is denominated in the applicable foreign currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount";
                Editable=FALSE;
                StyleExpr=StyleTxt }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bel›bet i bankposten er helt udlignet, eller om der er et udest†ende bel›b, som skal udlignes.;
                           ENU=Specifies whether the amount on the bank account entry has been fully applied to, or if there is a remaining amount that must be applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Open;
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bankposten er positiv.;
                           ENU=Specifies if the bank ledger entry is positive.];
                ApplicationArea=#Advanced;
                SourceExpr=Positive;
                Visible=FALSE;
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf›res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. Account Type";
                Visible=FALSE;
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf›res til, f.eks. en kassekonto ved kontantk›b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. Account No.";
                Visible=FALSE;
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontoudtogsstatus for bankkontoposten.;
                           ENU=Specifies the statement status of the bank account ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Statement Status";
                Visible=FALSE;
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bankkontoudtog, som posten er udlignet med, hvis Kontoudtogsstatus er sat til Udlignet med bankpost.;
                           ENU=Specifies the bank account statement that the ledger entry has been applied to, if the Statement Status is Bank Account Ledger Applied.];
                ApplicationArea=#Advanced;
                SourceExpr="Statement No.";
                Visible=FALSE;
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† linjen i kontoudtoget, der er blevet udlignet med denne finanspostlinje.;
                           ENU=Specifies the number of the statement line that has been applied to by this ledger entry line.];
                ApplicationArea=#Advanced;
                SourceExpr="Statement Line No.";
                Visible=FALSE;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de checkposter, der er knyttet til bankkontoposten.;
                           ENU=Specifies the check ledger entries that are associated with the bank account ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Check Ledger Entries" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE;
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE;
                Editable=FALSE }

    { 7   ;1   ;Group     ;
                GroupType=Group }

    { 15  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite }

    { 9   ;2   ;Field     ;
                Name=Balance;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Angiver saldoen p† bankkontoen siden den seneste bogf›ring, inklusive eventuelle bel›b i feltet I alt i udest†ende checks.;
                           ENU=Specifies the balance of the bank account since the last posting, including any amount in the Total on Outstanding Checks field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Balance;
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                Name=CheckBalance;
                CaptionML=[DAN=I alt i udest†ende checks;
                           ENU=Total on Outstanding Checks];
                ToolTipML=[DAN=Angiver den del af bankkontosaldoen, der best†r af bogf›rte checkposter. Bel›bet i dette felt er et unders‘t af bel›bet i feltet Saldo neden under den h›jre rude i vinduet Bankkontoafstemning.;
                           ENU=Specifies the part of the bank account balance that consists of posted check ledger entries. The amount in this field is a subset of the amount in the Balance field under the right pane in the Bank Acc. Reconciliation window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CheckBalance;
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                Name=BalanceToReconcile;
                CaptionML=[DAN=Saldo til afstemning;
                           ENU=Balance To Reconcile];
                ToolTipML=[DAN=Angiver saldoen p† bankkontoen siden den seneste bogf›ring, uden eventuelle bel›b i feltet I alt i udest†ende checks.;
                           ENU=Specifies the balance of the bank account since the last posting, excluding any amount in the Total on Outstanding Checks field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BalanceToReconcile;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      BankAccount@1001 : Record 270;
      StyleTxt@1000 : Text;
      LineApplied@1004 : Boolean;
      Balance@1002 : Decimal;
      CheckBalance@1003 : Decimal;
      BalanceToReconcile@1005 : Decimal;
      AmountVisible@1007 : Boolean;
      DebitCreditVisible@1006 : Boolean;

    [External]
    PROCEDURE GetSelectedRecords@2(VAR TempBankAccLedgerEntry@1000 : TEMPORARY Record 271);
    VAR
      BankAccLedgerEntry@1001 : Record 271;
    BEGIN
      CurrPage.SETSELECTIONFILTER(BankAccLedgerEntry);
      IF BankAccLedgerEntry.FINDSET THEN
        REPEAT
          TempBankAccLedgerEntry := BankAccLedgerEntry;
          TempBankAccLedgerEntry.INSERT;
        UNTIL BankAccLedgerEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE SetUserInteractions@3();
    BEGIN
      StyleTxt := SetStyle;
    END;

    LOCAL PROCEDURE CalcBalance@4();
    BEGIN
      IF BankAccount.GET("Bank Account No.") THEN BEGIN
        BankAccount.CALCFIELDS(Balance,"Total on Checks");
        Balance := BankAccount.Balance;
        CheckBalance := BankAccount."Total on Checks";
        BalanceToReconcile := CalcBalanceToReconcile;
      END;
    END;

    [External]
    PROCEDURE ToggleMatchedFilter@5(SetFilterOn@1000 : Boolean);
    BEGIN
      IF SetFilterOn THEN BEGIN
        SETRANGE("Statement Status","Statement Status"::Open);
        SETRANGE("Statement No.",'');
        SETRANGE("Statement Line No.",0);
      END ELSE
        RESET;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE CalcBalanceToReconcile@1() : Decimal;
    VAR
      BankAccountLedgerEntry@1000 : Record 271;
    BEGIN
      BankAccountLedgerEntry.COPYFILTERS(Rec);
      BankAccountLedgerEntry.CALCSUMS(Amount);
      EXIT(BankAccountLedgerEntry.Amount);
    END;

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

