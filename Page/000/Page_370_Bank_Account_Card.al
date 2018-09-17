OBJECT Page 370 Bank Account Card
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bankkontokort;
               ENU=Bank Account Card];
    SourceTable=Table270;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Tjeneste til bankkontoudtog,Bankkonto;
                                ENU=New,Process,Report,Bank Statement Service,Bank Account];
    OnOpenPage=VAR
                 Contact@1001 : Record 5050;
               BEGIN
                 ContactActionVisible := Contact.READPERMISSION;
                 SetNoFieldVisible;
               END;

    OnAfterGetRecord=BEGIN
                       GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
                       CALCFIELDS("Check Report Name");
                     END;

    OnAfterGetCurrRecord=BEGIN
                           GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
                           ShowBankLinkingActions := StatementProvidersExist;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 40      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bankkonto;
                                 ENU=&Bank Acc.];
                      Image=Bank }
      { 42      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger sÜsom vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 375;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Statistics;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Bank Account),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 84      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(270),
                                  No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=Saldo;
                                 ENU=Balance];
                      ToolTipML=[DAN=Se en oversigt over kontosaldoen i forskellige perioder.;
                                 ENU=View a summary of the bank account balance in different periods.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 377;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Balance;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 53      ;2   ;Action    ;
                      Name=Statements;
                      CaptionML=[DAN=Konto&udtog;
                                 ENU=St&atements];
                      ToolTipML=[DAN=Se bogfõrte bankkontoudtog og afstemninger.;
                                 ENU=View posted bank statements and reconciliations.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 389;
                      RunPageLink=Bank Account No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 44      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 372;
                      RunPageView=SORTING(Bank Account No.)
                                  ORDER(Descending);
                      RunPageLink=Bank Account No.=FIELD(No.);
                      Image=BankAccountLedger;
                      PromotedCategory=Process }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=&Checkposter;
                                 ENU=Chec&k Ledger Entries];
                      ToolTipML=[DAN=Se checkposter, der stammer fra bogfõringen af transaktioner i en betalingskladde for den relevante bankkonto.;
                                 ENU=View check ledger entries that result from posting transactions in a payment journal for the relevant bank account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 374;
                      RunPageView=SORTING(Bank Account No.)
                                  ORDER(Descending);
                      RunPageLink=Bank Account No.=FIELD(No.);
                      Image=CheckLedger }
      { 56      ;2   ;Action    ;
                      CaptionML=[DAN=&Kontakt;
                                 ENU=C&ontact];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kontaktpersonen i banken.;
                                 ENU=View or edit detailed information about the contact person at the bank.];
                      ApplicationArea=#All;
                      Visible=ContactActionVisible;
                      Image=ContactPerson;
                      OnAction=BEGIN
                                 ShowContact;
                               END;
                                }
      { 81      ;2   ;Separator  }
      { 86      ;2   ;Action    ;
                      CaptionML=[DAN=Online Map;
                                 ENU=Online Map];
                      ToolTipML=[DAN=Vis adressen pÜ et onlinekort.;
                                 ENU=View the address on an online map.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Map;
                      OnAction=BEGIN
                                 DisplayMap;
                               END;
                                }
      { 35      ;2   ;Action    ;
                      Name=PagePositivePayEntries;
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
      { 1905334303;1 ;Action    ;
                      Name=BankAccountReconciliations;
                      CaptionML=[DAN=Betalingsudligningskladder;
                                 ENU=Payment Reconciliation Journals];
                      ToolTipML=[DAN=Afstem din bankkonto ved at importere transaktioner. Anvend dem, enten automatisk eller manuelt, pÜ Übne debitorposter, Übne kreditorposter eller Übne bankkontoposter.;
                                 ENU=Reconcile your bank account by importing transactions and applying them, automatically or manually, to open customer ledger entries, open vendor ledger entries, or open bank account ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1294;
                      RunPageView=SORTING(Bank Account No.);
                      RunPageLink=Bank Account No.=FIELD(No.);
                      Image=BankAccountRec }
      { 1906306803;1 ;Action    ;
                      CaptionML=[DAN=Likviditet;
                                 ENU=Receivables-Payables];
                      ToolTipML=[DAN=Vis en oversigt over tilgodehavender og skyldige belõb for kontoen, herunder skyldige belõb for debitor- og kreditorsaldi.;
                                 ENU=View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 355;
                      Promoted=Yes;
                      Image=ReceivablesPayables;
                      PromotedCategory=Process }
      { 39      ;1   ;Action    ;
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
                                 LinkStatementProvider(Rec);
                               END;
                                }
      { 38      ;1   ;Action    ;
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
                                 UnlinkStatementProvider;
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 41      ;1   ;Action    ;
                      Name=AutomaticBankStatementImportSetup;
                      CaptionML=[DAN=Opsëtning af automatisk import af bankkontoudtog;
                                 ENU=Automatic Bank Statement Import Setup];
                      ToolTipML=[DAN=Angiver oplysninger til indlësning af bankkontoudtogsfilerne.;
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1903941404;1 ;Action    ;
                      CaptionML=[DAN=Indbetalingskladder;
                                 ENU=Cash Receipt Journals];
                      ToolTipML=[DAN=Opret en indbetalingskladdelinje for bankkontoen, eksempelvis for at bogfõre en betalingskvittering.;
                                 ENU=Create a cash receipt journal line for the bank account, for example, to post a payment receipt.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 255;
                      Promoted=Yes;
                      Image=Journals;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 1906045504;1 ;Action    ;
                      CaptionML=[DAN=Udbetalingskladder;
                                 ENU=Payment Journals];
                      ToolTipML=[DAN=èbn listen med betalingskladder, hvor du kan registrere betalinger til kreditorer.;
                                 ENU=Open the list of payment journals where you can register payments to vendors.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 256;
                      Promoted=Yes;
                      Image=Journals;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 37      ;1   ;Action    ;
                      Name=PagePosPayExport;
                      CaptionML=[DAN=Eksport af Positive Pay-betalingsposter;
                                 ENU=Positive Pay Export];
                      ToolTipML=[DAN=EksportÇr Positive Pay-fil med relevante betalingsoplysninger, som du derefter kan sende til banken som reference ved behandling af betalinger, for at sikre, at din bank kun rydder validerede checks og belõb.;
                                 ENU=Export a Positive Pay file with relevant payment information that you then send to the bank for reference when you process payments to make sure that your bank only clears validated checks and amounts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1233;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Export;
                      PromotedCategory=Process }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1900084706;1 ;Action    ;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=Vis en liste med generelle oplysninger om bankkonti, f.eks. bogfõringsgruppe, valutakode, min. saldo og saldo.;
                                 ENU=View a list of general information about bank accounts, such as posting group, currency code, minimum balance, and balance.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1402;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
      { 1900670506;1 ;Action    ;
                      CaptionML=[DAN=Detaljeret rÜbalance;
                                 ENU=Detail Trial Balance];
                      ToolTipML=[DAN=Vis en detaljeret rÜbalance for udvalgte checks.;
                                 ENU=View a detailed trial balance for selected checks.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1404;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
      { 1906306806;1 ;Action    ;
                      CaptionML=[DAN=Likviditet;
                                 ENU=Receivables-Payables];
                      ToolTipML=[DAN=Vis en oversigt over tilgodehavender og skyldige belõb for kontoen, herunder skyldige belõb for debitor- og kreditorsaldi.;
                                 ENU=View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5;
                      Image=Report;
                      PromotedCategory=Report }
      { 1904208406;1 ;Action    ;
                      CaptionML=[DAN=Checkoplysninger;
                                 ENU=Check Details];
                      ToolTipML=[DAN=Vis en detaljeret rÜbalance for udvalgte checks.;
                                 ENU=View a detailed trial balance for selected checks.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1406;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
    }
  }
  CONTROLS
  {
    { 1900000001;;Container;
                Name=;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Additional;
                Visible=NoFieldVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ din bank.;
                           ENU=Specifies the name of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Importance=Promoted }

    { 64  ;2   ;Field     ;
                CaptionML=[DAN=Bankregistreringsnr.;
                           ENU=Bank Branch No.];
                ToolTipML=[DAN=Angiver bankens registreringsnummer.;
                           ENU=Specifies a number of the bank branch.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Branch No." }

    { 36  ;2   ;Field     ;
                CaptionML=[DAN=Bankkontonr.;
                           ENU=Bank Account No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den bankkonto, der benyttes af banken.;
                           ENU=Specifies the number used by the bank for the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No.";
                Importance=Promoted }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at sõge efter den õnskede record, hvis du ikke kan huske vërdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Search Name";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontoens aktuelle saldo i den relevante udenlandske valuta.;
                           ENU=Specifies the bank account's current balance denominated in the applicable foreign currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Balance;
                Importance=Promoted }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontoens aktuelle saldo i regnskabsvalutaen.;
                           ENU=Specifies the bank account's current balance in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance (LCY)";
                Importance=Additional }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en min. saldo til bankkontoen.;
                           ENU=Specifies a minimum balance for the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Min. Balance";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den person i virksomheden, der er ansvarlig for bankkontoen.;
                           ENU=Specifies a code to specify the employee who is responsible for this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Our Contact Code";
                Importance=Additional }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver SEPA-formatet pÜ den bankfil, der skal udlëses nÜr du vëlger knappen Opret fil til direkte debitering i vinduet Poster i Direct Debit-opkrëvning.;
                           ENU=Specifies the SEPA format of the bank file that will be exported when you choose the Create Direct Debit File button in the Direct Debit Collect. Entries window.];
                ApplicationArea=#Suite;
                SourceExpr="SEPA Direct Debit Exp. Format";
                Importance=Additional }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie til bankvejledningsmeddelelser, der oprettes med den eksportfil, som oprettes i vinduet Poster i Direct Debit-opkrëvning.;
                           ENU=Specifies the number series for bank instruction messages that are created with the export file that you create from the Direct Debit Collect. Entries window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Transfer Msg. Nos.";
                Importance=Additional }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, der bruges i den Direct Debit-fil, der udlëses til en Direct Debit-opkrëvningspost i vinduet Poster i Direct Debit-opkrëvning.;
                           ENU=Specifies the number series that will be used on the direct debit file that you export for a direct-debit collection entry in the Direct Debit Collect. Entries window.];
                ApplicationArea=#Suite;
                SourceExpr="Direct Debit Msg. Nos.";
                Importance=Additional }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver din virksomhed som kreditor i forbindelse med opkrëvning af betalinger fra debitorer, der bruger SEPA Direct Debit.;
                           ENU=Specifies your company as the creditor in connection with payment collection from customers using SEPA Direct Debit.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Creditor No.";
                Importance=Additional }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver din banks dataformat til aktivering af bankdatakonvertering af en tjenesteudbyder, nÜr du importerer og eksporterer bankfiler.;
                           ENU=Specifies your bank's data format to enable conversion of bank data by a service provider when you import and export bank files.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Name - Data Conversion";
                Importance=Additional }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den formatstandard, der skal bruges til bankoverfõrsler, hvis du bruger feltet Kode for bankclearing for at angive dig som afsender.;
                           ENU=Specifies the format standard to be used in bank transfers if you use the Bank Clearing Code field to identify you as the sender.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Clearing Standard";
                Importance=Additional }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for bankclearing, der er pÜkrëvet i henhold til den formatstandard, som du valgte i feltet Bankclearingsstandard.;
                           ENU=Specifies the code for bank clearing that is required according to the format standard you selected in the Bank Clearing Standard field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Clearing Code";
                Importance=Additional }

    { 45  ;2   ;Group     ;
                Visible=ShowBankLinkingActions;
                GroupType=Group }

    { 33  ;3   ;Field     ;
                CaptionML=[DAN=Status for tilknytning af bankkonto;
                           ENU=Bank Account Linking Status];
                ToolTipML=[DAN=Angiver, om bankkontoen er knyttet til en onlinebankkonto via bankkontoudtogstjenesten.;
                           ENU=Specifies if the bank account is linked to an online bank account through the bank statement service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=OnlineFeedStatementStatus;
                Editable=false;
                OnValidate=BEGIN
                             IF NOT Linked THEN
                               UnlinkStatementProvider
                             ELSE
                               ERROR(OnlineBankAccountLinkingErr);
                           END;
                            }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bankkontokortet sidst blev ëndret.;
                           ENU=Specifies the date when the Bank Account card was last modified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date Modified";
                Importance=Additional }

    { 27  ;2   ;Group     ;
                CaptionML=[DAN=Tolerance for betalingsmatch;
                           ENU=Payment Match Tolerance];
                GroupType=Group }

    { 23  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, med hvilken tolerance den automatiske betalingsudligningsfunktion indregner reglen Belõb inkl. tolerance er matchet for denne bankkonto.;
                           ENU=Specifies by which tolerance the automatic payment application function will apply the Amount Incl. Tolerance Matched rule for this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Match Tolerance Type";
                Importance=Additional }

    { 25  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om den automatiske betalingsudligningsfunktion indregner reglen Belõb inkl. tolerance er matchet i procent eller belõb.;
                           ENU=Specifies if the automatic payment application function will apply the Amount Incl. Tolerance Matched rule by Percentage or Amount.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:2;
                SourceExpr="Match Tolerance Value";
                Importance=Additional }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Kommunikation;
                           ENU=Communication] }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ din bank.;
                           ENU=Specifies the address of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den bank, hvor du har din bankkonto.;
                           ENU=Specifies the city of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omrÜde.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankens telefonnummer.;
                           ENU=Specifies the telephone number of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den person i banken, der som regel kontaktes i forbindelse med denne konto.;
                           ENU=Specifies the name of the bank employee regularly contacted in connection with this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 16  ;2   ;Field     ;
                Name=Phone No.2;
                CaptionML=[DAN=Telefonnr.;
                           ENU=Phone No.];
                ToolTipML=[DAN=Angiver bankens telefonnummer.;
                           ENU=Specifies the telephone number of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No.";
                Importance=Promoted;
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankens faxnummer.;
                           ENU=Specifies the fax number of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No." }

    { 68  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver bankkontoens mailadresse.;
                           ENU=Specifies the email address associated with the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail";
                Importance=Promoted }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankens websted.;
                           ENU=Specifies the bank web site.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page" }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Bogfõring;
                           ENU=Posting] }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante valutakode til bankkontoen.;
                           ENU=Specifies the relevant currency code for the bank account.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den seneste check, der er udskrevet fra denne bankkonto.;
                           ENU=Specifies the check number of the last check issued from the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Check No." }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dit eget bank-id-nummer.;
                           ENU=Specifies a bank identification number of your own choice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transit No." }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det seneste kontoudtog, der er blevet afstemt med denne bankkonto.;
                           ENU=Specifies the number of the last bank account statement that was reconciled with this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Statement No.";
                Importance=Promoted }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det seneste bankkontoudtog, der blev importeret.;
                           ENU=Specifies the last bank statement that was imported.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Payment Statement No." }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver saldoen pÜ den seneste afstemning af bankkontoen.;
                           ENU=Specifies the balance amount of the last statement reconciliation on the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance Last Statement";
                Importance=Promoted;
                OnValidate=BEGIN
                             IF "Balance Last Statement" <> xRec."Balance Last Statement" THEN
                               IF NOT CONFIRM(Text001,FALSE,"No.") THEN
                                 ERROR(Text002);
                           END;
                            }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for bankkontobogfõringsgruppe for bankkontoen.;
                           ENU=Specifies a code for the bank account posting group for the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Acc. Posting Group";
                Importance=Promoted }

    { 1905090301;1;Group  ;
                CaptionML=[DAN=Overfõrsel;
                           ENU=Transfer] }

    { 59  ;2   ;Field     ;
                Name=Bank Branch No.2;
                CaptionML=[DAN=Bankregistreringsnr.;
                           ENU=Bank Branch No.];
                ToolTipML=[DAN=Angiver bankens registreringsnummer.;
                           ENU=Specifies a number of the bank branch.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Branch No.";
                Importance=Promoted;
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                Name=Bank Account No.2;
                CaptionML=[DAN=Bankkontonr.;
                           ENU=Bank Account No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den bankkonto, der benyttes af banken.;
                           ENU=Specifies the number used by the bank for the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No.";
                Importance=Promoted;
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                Name=Transit No.2;
                CaptionML=[DAN=Transitnr.;
                           ENU=Transit No.];
                ToolTipML=[DAN=Angiver dit eget bank-id-nummer.;
                           ENU=Specifies a bank identification number of your own choice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transit No." }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver SWIFT-koden (internationalt bank-id) pÜ den bank, hvor du har bankkontoen.;
                           ENU=Specifies the international bank identifier code (SWIFT) of the bank where you have the account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="SWIFT Code";
                Importance=Promoted }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontoens internationale bankkontonummer.;
                           ENU=Specifies the bank account's international bank account number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=IBAN;
                Importance=Promoted }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver formatet pÜ bankkontoudtogsfilen, der kan importeres til denne bankkonto.;
                           ENU=Specifies the format of the bank statement file that can be imported into this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Statement Import Format" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver formatet pÜ bankfilen, der skal udlëses nÜr du vëlger knappen EksportÇr betalinger til fil i vinduet Udbetalingskladde.;
                           ENU=Specifies the format of the bank file that will be exported when you choose the Export Payments to File button in the Payment Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Export Format" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode til den dataudvekslingsdefinition, der administrerer eksport af Positive Pay-filer.;
                           ENU=Specifies a code for the data exchange definition that manages the export of positive-pay files.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Positive Pay Export Code";
                Visible=FALSE;
                LookupPageID=Bank Export/Import Setup }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

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
      Text001@1000 : TextConst 'DAN=Der kan vëre et kontoudtog, der bruger %1.\\Vil du ëndre Sidste kontoudtog - saldo?;ENU=There may be a statement using the %1.\\Do you want to change Balance Last Statement?';
      Text002@1001 : TextConst 'DAN=Annulleret.;ENU=Canceled.';
      ContactActionVisible@1002 : Boolean INDATASET;
      Linked@1004 : Boolean;
      OnlineBankAccountLinkingErr@1003 : TextConst 'DAN=Du skal knytte bankkontoen til en onlinebankkonto.\\Vëlg handlingen Tilknyt til onlinebankkonto.;ENU=You must link the bank account to an online bank account.\\Choose the Link to Online Bank Account action.';
      ShowBankLinkingActions@1005 : Boolean;
      NoFieldVisible@1007 : Boolean;
      OnlineFeedStatementStatus@1006 : 'Not Linked,Linked,Linked and Auto. Bank Statement Enabled';

    LOCAL PROCEDURE SetNoFieldVisible@13();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      NoFieldVisible := DocumentNoVisibility.BankAccountNoIsVisible;
    END;

    BEGIN
    END.
  }
}

