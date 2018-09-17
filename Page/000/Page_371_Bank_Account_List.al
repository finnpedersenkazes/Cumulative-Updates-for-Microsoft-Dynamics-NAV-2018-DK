OBJECT Page 371 Bank Account List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Bankkontooversigt;
               ENU=Bank Account List];
    SourceTable=Table270;
    PageType=List;
    CardPageID=Bank Account Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Tjeneste til bankkontoudtog;
                                ENU=New,Process,Report,Bank Statement Service];
    OnOpenPage=BEGIN
                 ShowBankLinkingActions := StatementProvidersExist;
               END;

    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Check Report Name");
                       GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
                           ShowBankLinkingActions := StatementProvidersExist;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bankkonto;
                                 ENU=&Bank Acc.];
                      Image=Bank }
      { 17      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger s†som v‘rdien for bogf›rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 375;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Bank Account),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 9       ;2   ;Action    ;
                      Name=PositivePayExport;
                      CaptionML=[DAN=Eksport af Positive Pay-betalingsposter;
                                 ENU=Positive Pay Export];
                      ToolTipML=[DAN=Eksport‚r Positive Pay-fil med relevante betalingsoplysninger, som du derefter kan sende til banken som reference ved behandling af betalinger, for at sikre, at din bank kun rydder validerede checks og bel›b.;
                                 ENU=Export a Positive Pay file with relevant payment information that you then send to the bank for reference when you process payments to make sure that your bank only clears validated checks and amounts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1233;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Export;
                      PromotedCategory=Process }
      { 22      ;2   ;ActionGroup;
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
                      RunPageLink=Table ID=CONST(270),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 21      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Suite;
                      Image=DimensionSets;
                      OnAction=VAR
                                 BankAcc@1001 : Record 270;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(BankAcc);
                                 DefaultDimMultiple.SetMultiBankAcc(BankAcc);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 6       ;2   ;Action    ;
                      CaptionML=[DAN=Saldo;
                                 ENU=Balance];
                      ToolTipML=[DAN=Se en oversigt over kontosaldoen i forskellige perioder.;
                                 ENU=View a summary of the bank account balance in different periods.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 377;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Balance;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 7       ;2   ;Action    ;
                      Name=Statements;
                      CaptionML=[DAN=Konto&udtog;
                                 ENU=St&atements];
                      ToolTipML=[DAN=Se bogf›rte bankkontoudtog og afstemninger.;
                                 ENU=View posted bank statements and reconciliations.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 389;
                      RunPageLink=Bank Account No.=FIELD(No.);
                      Image=List }
      { 19      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 372;
                      RunPageView=SORTING(Bank Account No.)
                                  ORDER(Descending);
                      RunPageLink=Bank Account No.=FIELD(No.);
                      Promoted=No;
                      Image=BankAccountLedger;
                      PromotedCategory=Process }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=&Checkposter;
                                 ENU=Chec&k Ledger Entries];
                      ToolTipML=[DAN=Se checkposter, der stammer fra bogf›ringen af transaktioner i en betalingskladde for den relevante bankkonto.;
                                 ENU=View check ledger entries that result from posting transactions in a payment journal for the relevant bank account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 374;
                      RunPageView=SORTING(Bank Account No.)
                                  ORDER(Descending);
                      RunPageLink=Bank Account No.=FIELD(No.);
                      Image=CheckLedger }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=K&ontakt;
                                 ENU=C&ontact];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kontaktpersonen i banken.;
                                 ENU=View or edit detailed information about the contact person at the bank.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ContactPerson;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowContact;
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=CreateNewLinkedBankAccount;
                      CaptionML=[DAN=Opret ny tilknyttet bankkonto;
                                 ENU=Create New Linked Bank Account];
                      ToolTipML=[DAN=Opret en ny onlinebankkonto, der linker til den udvalgte bankkonto.;
                                 ENU=Create a new online bank account to link to the selected bank account.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=ShowBankLinkingActions;
                      PromotedIsBig=Yes;
                      Image=NewBank;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 BankAccount@1001 : Record 270;
                               BEGIN
                                 BankAccount.INIT;
                                 BankAccount.LinkStatementProvider(BankAccount);
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=LinkToOnlineBankAccount;
                      CaptionML=[DAN=Tilknyt til onlinebankkonto;
                                 ENU=Link to Online Bank Account];
                      ToolTipML=[DAN=Opretter et link til en online bankkonto i den udvalgte bankkonto.;
                                 ENU=Create a link to an online bank account from the selected bank account.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=ShowBankLinkingActions;
                      Enabled=NOT Linked;
                      PromotedIsBig=Yes;
                      Image=LinkAccount;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 VerifySingleSelection;
                                 LinkStatementProvider(Rec);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=UnlinkOnlineBankAccount;
                      CaptionML=[DAN=Fjern tilknytning til onlinebankkonto;
                                 ENU=Unlink Online Bank Account];
                      ToolTipML=[DAN=Fjerner et link til en online bankkonto i den udvalgte bankkonto.;
                                 ENU=Remove a link to an online bank account from the selected bank account.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=ShowBankLinkingActions;
                      Enabled=Linked;
                      PromotedIsBig=Yes;
                      Image=UnLinkAccount;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 VerifySingleSelection;
                                 UnlinkStatementProvider;
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Name=UpdateBankAccountLinking;
                      CaptionML=[DAN=Opdater tilknytning af bankkonto;
                                 ENU=Update Bank Account Linking];
                      ToolTipML=[DAN=Knyt alle bankkonti, der ikke er tilknyttede, til deres relaterede bankkonti.;
                                 ENU=Link any non-linked bank accounts to their related bank accounts.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=ShowBankLinkingActions;
                      PromotedIsBig=Yes;
                      Image=MapAccounts;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 UpdateBankAccountLinking;
                               END;
                                }
      { 24      ;2   ;Action    ;
                      Name=AutomaticBankStatementImportSetup;
                      CaptionML=[DAN=Ops‘tning af automatisk import af bankkontoudtog;
                                 ENU=Automatic Bank Statement Import Setup];
                      ToolTipML=[DAN=Angiver oplysninger til indl‘sning af bankkontoudtogsfilerne.;
                                 ENU=Set up the information for importing bank statement files.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1269;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      Visible=ShowBankLinkingActions;
                      Enabled=Linked;
                      PromotedIsBig=Yes;
                      Image=ElectronicBanking;
                      PromotedCategory=Category4 }
      { 5       ;2   ;Action    ;
                      Name=PagePosPayEntries;
                      CaptionML=[DAN=Positive Pay-betalingsposter;
                                 ENU=Positive Pay Entries];
                      ToolTipML=[DAN=Vis de bankkontoposter, der er relateret til Positive Pay-transaktioner.;
                                 ENU=View the bank ledger entries that are related to Positive Pay transactions.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1231;
                      RunPageView=SORTING(Bank Account No.,Upload Date-Time)
                                  ORDER(Descending);
                      RunPageLink=Bank Account No.=FIELD(No.);
                      Visible=FALSE;
                      Image=CheckLedger }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1900670506;1 ;Action    ;
                      CaptionML=[DAN=Detaljeret r†balance;
                                 ENU=Detail Trial Balance];
                      ToolTipML=[DAN=Vis en detaljeret r†balance for udvalgte checks.;
                                 ENU=View a detailed trial balance for selected checks.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 1404;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
      { 1904208406;1 ;Action    ;
                      CaptionML=[DAN=Checkoplysninger;
                                 ENU=Check Details];
                      ToolTipML=[DAN=Vis en detaljeret r†balance for udvalgte checks.;
                                 ENU=View a detailed trial balance for selected checks.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 1406;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902174606;1 ;Action    ;
                      CaptionML=[DAN=R†balance efter periode;
                                 ENU=Trial Balance by Period];
                      ToolTipML=[DAN=Vis en detaljeret r†balance for udvalgte checks inden for en valgt periode.;
                                 ENU=View a detailed trial balance for selected checks within a selected period.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 38;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
      { 29      ;1   ;Action    ;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=Vis en liste med generelle oplysninger om bankkonti, f.eks. bogf›ringsgruppe, valutakode, min. saldo og saldo.;
                                 ENU=View a list of general information about bank accounts, such as posting group, currency code, minimum balance, and balance.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 1402;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
      { 27      ;1   ;Action    ;
                      CaptionML=[DAN=Likviditet;
                                 ENU=Receivables-Payables];
                      ToolTipML=[DAN=Vis en oversigt over tilgodehavender og skyldige bel›b for kontoen, herunder skyldige bel›b for debitor- og kreditorsaldi.;
                                 ENU=View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 5;
                      Image=Report;
                      PromotedCategory=Report }
      { 1904082706;1 ;Action    ;
                      CaptionML=[DAN=Balance;
                                 ENU=Trial Balance];
                      ToolTipML=[DAN=Vis en detaljeret r†balance for den udvalgte bankkonto.;
                                 ENU=View a detailed trial balance for the selected bank account.];
                      ApplicationArea=#Suite;
                      RunObject=Report 6;
                      Image=Report;
                      PromotedCategory=Report }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Bankkontoudtog;
                                 ENU=Bank Account Statements];
                      ToolTipML=[DAN=Vis kontoudtog for de valgte bankkonti. For hver banktransaktion viser rapporten en beskrivelse, et udlignet bel›b, et kontoudtogsbel›b og andre oplysninger.;
                                 ENU=View statements for selected bank accounts. For each bank transaction, the report shows a description, an applied amount, a statement amount, and other information.];
                      ApplicationArea=#Suite;
                      RunObject=Report 1407;
                      Image=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† din bank.;
                           ENU=Specifies the name of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Status for tilknytning af bankkonto;
                           ENU=Bank Account Linking Status];
                ToolTipML=[DAN=Angiver, om bankkontoen er knyttet til en onlinebankkonto via bankkontoudtogstjenesten.;
                           ENU=Specifies if the bank account is linked to an online bank account through the bank statement service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=OnlineFeedStatementStatus;
                Visible=ShowBankLinkingActions;
                Editable=FALSE }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankens telefonnummer.;
                           ENU=Specifies the telephone number of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det faxnummer, der er tilknyttet adressen.;
                           ENU=Specifies the fax number associated with the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Fax No.";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den person i banken, der som regel kontaktes i forbindelse med denne konto.;
                           ENU=Specifies the name of the bank employee regularly contacted in connection with this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den bankkonto, der benyttes af banken.;
                           ENU=Specifies the number used by the bank for the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No.";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver SWIFT-koden (internationalt bank-id) p† den bank, hvor du har bankkontoen.;
                           ENU=Specifies the international bank identifier code (SWIFT) of the bank where you have the account.];
                ApplicationArea=#Advanced;
                SourceExpr="SWIFT Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontoens internationale bankkontonummer.;
                           ENU=Specifies the bank account's international bank account number.];
                ApplicationArea=#Advanced;
                SourceExpr=IBAN;
                Visible=FALSE }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den person i virksomheden, der er ansvarlig for bankkontoen.;
                           ENU=Specifies a code to specify the employee who is responsible for this bank account.];
                ApplicationArea=#Advanced;
                SourceExpr="Our Contact Code";
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for bankkontobogf›ringsgruppe for bankkontoen.;
                           ENU=Specifies a code for the bank account posting group for the bank account.];
                ApplicationArea=#Advanced;
                SourceExpr="Bank Acc. Posting Group";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante valutakode til bankkontoen.;
                           ENU=Specifies the relevant currency code for the bank account.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s›ge efter den ›nskede record, hvis du ikke kan huske v‘rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Search Name";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1905532107;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=Table ID=CONST(270),
                            No.=FIELD(No.);
                PagePartID=Page9083;
                Visible=FALSE;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      MultiselectNotSupportedErr@1001 : TextConst 'DAN=Du kan kun tilknytte ‚n onlinebankkonto ad gangen.;ENU=You can only link to one online bank account at a time.';
      Linked@1000 : Boolean;
      ShowBankLinkingActions@1002 : Boolean;
      OnlineFeedStatementStatus@1003 : 'Not Linked,Linked,Linked and Auto. Bank Statement Enabled';

    LOCAL PROCEDURE VerifySingleSelection@1();
    VAR
      BankAccount@1000 : Record 270;
    BEGIN
      CurrPage.SETSELECTIONFILTER(BankAccount);

      IF BankAccount.COUNT > 1 THEN
        ERROR(MultiselectNotSupportedErr);
    END;

    BEGIN
    END.
  }
}

