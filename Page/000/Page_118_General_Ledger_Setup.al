OBJECT Page 118 General Ledger Setup
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572,NAVDK11.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ops�tning af Finans;
               ENU=General Ledger Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table98;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Generelt,Bogf�ring,Moms,Bank,Kladdetyper;
                                ENU=New,Process,Report,General,Posting,VAT,Bank,Journal Templates];
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 42      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 44      ;2   ;Action    ;
                      Name=ChangeGlobalDimensions;
                      AccessByPermission=TableData 348=M;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Rediger globale dimensioner;
                                 ENU=Change Global Dimensions];
                      ToolTipML=[DAN=Rediger �n eller begge globale dimensioner.;
                                 ENU=Change one or both of the global dimensions.];
                      ApplicationArea=#Suite;
                      RunObject=Page 577;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ChangeDimensions;
                      PromotedCategory=Category4 }
      { 2       ;2   ;Action    ;
                      CaptionML=[DAN=&Skift betalingstolerance;
                                 ENU=Change Payment &Tolerance];
                      ToolTipML=[DAN=Rediger den maksimale betalingstolerance og/eller betalingstoleranceprocenten.;
                                 ENU=Change the maximum payment tolerance and/or the payment tolerance percentage.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ChangePaymentTolerance;
                      OnAction=VAR
                                 Currency@1002 : Record 4;
                                 ChangePmtTol@1000 : Report 34;
                               BEGIN
                                 Currency.INIT;
                                 ChangePmtTol.SetCurrency(Currency);
                                 ChangePmtTol.RUNMODAL;
                               END;
                                }
      { 13      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 53      ;1   ;Action    ;
                      CaptionML=[DAN=Regnskabsperioder;
                                 ENU=Accounting Periods];
                      ToolTipML=[DAN=Angiv antal regnskabsperioder, f.eks. 12 m�nedsperioder, i regnskabs�ret, og angiv, hvilken periode der er starten p� det nye regnskabs�r.;
                                 ENU=Set up the number of accounting periods, such as 12 monthly periods, within the fiscal year and specify which period is the start of the new fiscal year.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 100;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AccountingPeriods;
                      PromotedCategory=Category4 }
      { 52      ;1   ;Action    ;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Konfigurer dimensioner s�som omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=Set up dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 536;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4 }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=Brugerops�tning;
                                 ENU=User Setup];
                      ToolTipML=[DAN=Opret brugere for at begr�nse adgang til bogf�ring i finansmodulet.;
                                 ENU=Set up users to restrict access to post to the general ledger.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 119;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=UserSetup;
                      PromotedCategory=Category4 }
      { 48      ;1   ;Action    ;
                      CaptionML=[DAN=Pengestr�mskonfiguration;
                                 ENU=Cash Flow Setup];
                      ToolTipML=[DAN=Konfigurer de konti, hvor pengestr�mstal for salgs-, k�bs- og anl�gsposter gemmes.;
                                 ENU=Set up the accounts where cash flow figures for sales, purchase, and fixed-asset transactions are stored.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 846;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CashFlowSetup;
                      PromotedCategory=Category4 }
      { 46      ;1   ;Action    ;
                      CaptionML=[DAN=Ops�tning af bankimport/-eksport;
                                 ENU=Bank Export/Import Setup];
                      ToolTipML=[DAN=Opret formater for eksport af kreditorbetalinger og import af bankkontoudtog.;
                                 ENU=Set up the formats for exporting vendor payments and for importing bank statements.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1200;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ImportExport;
                      PromotedCategory=Category7 }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=Finansbogf�ring;
                                 ENU=General Ledger Posting] }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�ringsops�tning;
                                 ENU=General Posting Setup];
                      ToolTipML=[DAN=Konfigurer kombinationer af generelle virksomheds- og generelle produktbogf�ringsgrupper ved at angive kontonumre til bogf�ring af salgs- og k�bstransaktioner.;
                                 ENU=Set up combinations of general business and general product posting groups by specifying account numbers for posting of sales and purchase transactions.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 314;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GeneralPostingSetup;
                      PromotedCategory=Category5 }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Virksomhedsbogf�ringsgrupper;
                                 ENU=Gen. Business Posting Groups];
                      ToolTipML=[DAN=Konfigurer de handelstypebogf�ringsgrupper, du tildeler til kreditor- og debitorkort, for at knytte transaktioner til den relevante finanskonto.;
                                 ENU=Set up the trade-type posting groups that you assign to customer and vendor cards to link transactions with the appropriate general ledger account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 312;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GeneralPostingSetup;
                      PromotedCategory=Category5 }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Produktbogf�ringsgrupper;
                                 ENU=Gen. Product Posting Groups];
                      ToolTipML=[DAN=Konfigurer de varetypebogf�ringsgrupper, du tildeler til kreditor- og debitorkort, for at knytte transaktioner til den relevante finanskonto.;
                                 ENU=Set up the item-type posting groups that you assign to customer and vendor cards to link transactions with the appropriate general ledger account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 313;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GeneralPostingSetup;
                      PromotedCategory=Category5 }
      { 35      ;1   ;ActionGroup;
                      CaptionML=[DAN=Momsbogf�ring;
                                 ENU=VAT Posting] }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Ops�tning af momsbogf.;
                                 ENU=VAT Posting Setup];
                      ToolTipML=[DAN=Angiv, hvordan moms skal bogf�res i finansregnskabet.;
                                 ENU=Set up how tax must be posted to the general ledger.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 472;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=VATPostingSetup;
                      PromotedCategory=Category6 }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Momsvirksomhedsbogf.grupper;
                                 ENU=VAT Business Posting Groups];
                      ToolTipML=[DAN=Konfigurer de handelstypebogf�ringsgrupper, du tildeler til kreditor- og debitorkort, for at knytte momsbel�b til den relevante finanskonto.;
                                 ENU=Set up the trade-type posting groups that you assign to customer and vendor cards to link VAT amounts with the appropriate general ledger account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 470;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=VATPostingSetup;
                      PromotedCategory=Category6 }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Momsproduktbogf.grupper;
                                 ENU=VAT Product Posting Groups];
                      ToolTipML=[DAN=Konfigurer de varetypebogf�ringsgrupper, du tildeler til kreditor- og debitorkort, for at knytte momsbel�b til den relevante finanskonto.;
                                 ENU=Set up the item-type posting groups that you assign to customer and vendor cards to link VAT amounts with the appropriate general ledger account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 471;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=VATPostingSetup;
                      PromotedCategory=Category6 }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Momsrapportkonfiguration;
                                 ENU=VAT Report Setup];
                      ToolTipML=[DAN=Konfigurer nummerserier og indstillinger for den rapport, du sender til myndighederne med j�vne mellemrum i forbindelse med momsindberetningen.;
                                 ENU=Set up number series and options for the report that you periodically send to the authorities to declare your VAT.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 743;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=VATPostingSetup;
                      PromotedCategory=Category6 }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bankbogf�ring;
                                 ENU=Bank Posting] }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkontobogf�ringsgrupper;
                                 ENU=Bank Account Posting Groups];
                      ToolTipML=[DAN=Opret bogf�ringsgrupper, s� betalinger til og fra de enkelte bankkonti bogf�res p� den angivne finanskonto.;
                                 ENU=Set up posting groups, so that payments in and out of each bank account are posted to the specified general ledger account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 373;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=BankAccount;
                      PromotedCategory=Category7 }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladdetyper;
                                 ENU=Journal Templates] }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Finanskladdetyper;
                                 ENU=General Journal Templates];
                      ToolTipML=[DAN=Opret skabeloner for de kladder, du bruger til bogf�ring. Med skabeloner kan du arbejde i et kladdevindue, som er designet til et bestemt form�l.;
                                 ENU=Set up templates for the journals that you use for bookkeeping tasks. Templates allow you to work in a journal window that is designed for a specific purpose.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 101;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=JournalSetup;
                      PromotedCategory=Category8 }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Momsangivelsestyper;
                                 ENU=VAT Statement Templates];
                      ToolTipML=[DAN=Konfigurer de rapporter, du bruger til at afregne moms og til indberetninger til SKAT.;
                                 ENU=Set up the reports that you use to settle VAT and report to the customs and tax authorities.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 318;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=VATStatement;
                      PromotedCategory=Category8 }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Intrastattyper;
                                 ENU=Intrastat Templates];
                      ToolTipML=[DAN=Angiv, hvordan du vil oprette og holde styr p� kladder i forbindelse med Intrastat-rapportering.;
                                 ENU=Define how you want to set up and keep track of journals to report Intrastat.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 325;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Template;
                      PromotedCategory=Category8 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tidligste dato, hvor det er tilladt at bogf�re i regnskabet.;
                           ENU=Specifies the earliest date on which posting to the company is allowed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow Posting From" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste dato, hvor det er tilladt at bogf�re i regnskabet.;
                           ENU=Specifies the last date on which posting to the company is allowed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow Posting To" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om programmet ogs� skal registrere tidsforbrug for brugeren. Mark�r afkrydsningsfeltet, hvis programmet skal registrere hver brugers tidsforbrug.;
                           ENU=Specifies whether the program will register the user's time usage. Place a check mark in the field if you want the program to register time for each user.];
                ApplicationArea=#Jobs;
                SourceExpr="Register Time";
                Importance=Additional }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket format adresserne skal vises i p� udskrifterne.;
                           ENU=Specifies the format in which addresses must appear on printouts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Local Address Format" }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor kontaktpersonens navn skal placeres i adresser.;
                           ENU=Specifies where you want the contact name to appear in mailing addresses.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Local Cont. Addr. Format";
                Importance=Additional }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver st�rrelsen p� det interval, der skal bruges til afrunding af bel�b i din lokale valuta. Du kan ogs� angive en fakturaafrunding for hver valuta i valutatabellen.;
                           ENU=Specifies the size of the interval to be used when rounding amounts in your local currency. You can also specify invoice rounding for each currency in the Currency table.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Rounding Precision (LCY)" }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om et fakturabel�b skal rundes op eller ned. Oplysningerne sammenholdes med oplysningerne om afrundingsintervallet, der er angivet i feltet Fakturaafrundingspr�cision-RV.;
                           ENU=Specifies whether an invoice amount will be rounded up or down. The program uses this information together with the interval for rounding that you have specified in the Inv. Rounding Precision (LCY) field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Rounding Type (LCY)" }

    { 66  ;2   ;Field     ;
                Name=AmountRoundingPrecision;
                CaptionML=[DAN=Pr�cision ved afrunding af bel�b (RV);
                           ENU=Amount Rounding Precision (LCY)];
                ToolTipML=[DAN=Angiver st�rrelsen p� intervallet, der bruges til afrunding af bel�b i regnskabsvalutaen. Bel�b afrundes til n�rmeste hele tal.;
                           ENU=Specifies the size of the interval to be used when rounding amounts in LCY. Amounts will be rounded to the nearest digit.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Rounding Precision" }

    { 68  ;2   ;Field     ;
                Name=AmountDecimalPlaces;
                CaptionML=[DAN=Decimalplaceringer for bel�b (RV);
                           ENU=Amount Decimal Places (LCY)];
                ToolTipML=[DAN=Angiver det antal decimaler, som programmet skal bruge til at vise bel�b i RV, f.eks. p� fakturaer og i rapporter. Standardindstillingen 2:2 angiver, at bel�bene i RV vises med to decimaler.;
                           ENU=Specifies the number of decimal places the program will display (for example, on invoices and in reports) for amounts in LCY. The default setting, 2:2, specifies that amounts in LCY will be shown with two decimal places.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Decimal Places" }

    { 69  ;2   ;Field     ;
                Name=UnitAmountRoundingPrecision;
                CaptionML=[DAN=Pr�cision ved afrunding af enheder eller bel�b (RV);
                           ENU=Unit-Amount Rounding Precision (LCY)];
                ToolTipML=[DAN=Angiver st�rrelsen p� det interval, der skal bruges til afrunding af priser (dvs. vare- eller ressourcepris pr. enhed) i RV.;
                           ENU=Specifies the size of the interval to be used when rounding unit amounts (that is, item or resource prices per unit) in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit-Amount Rounding Precision" }

    { 71  ;2   ;Field     ;
                Name=UnitAmountDecimalPlaces;
                CaptionML=[DAN=Decimalplaceringer for enheder eller bel�b (RV);
                           ENU=Unit-Amount Decimal Places (LCY)];
                ToolTipML=[DAN=Angiver det antal decimaler, der bliver vist f.eks. p� fakturaer og i rapporter, for salgs- og k�bspriser p� varer og for salgspriser p� ressourcer i RV. Standardv�rdien 2:5 angiver, at salgs- og k�bspriserne i RV vises med mindst to decimaler og h�jst fem decimaler.;
                           ENU=Specifies the number of decimal places the program will display (for example, on invoices and in reports) for sales and purchase prices for items, and for sales prices for resources in LCY. The default setting, 2:5, specifies that sales and purchase prices in LCY will be shown with a minimum of two decimal places and a maximum of five decimal places.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit-Amount Decimal Places" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om og hvorn�r finanskonti kan slettes. Hvis du skriver en dato, kan finanskonti, der indeholder poster pr. eller efter denne dato, ikke slettes.;
                           ENU=Specifies if and when general ledger accounts can be deleted. If you enter a date, G/L accounts with entries on or after this date cannot be deleted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow G/L Acc. Deletion Before";
                Importance=Additional }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at de finanskonti, der bruges i ops�tningstabeller, skal beskyttes mod at blive slettet.;
                           ENU=Specifies that you want the program to protect G/L accounts that are used in setup tables from being deleted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Check G/L Account Usage";
                Importance=Additional }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om LV er en �MU-valuta.;
                           ENU=Specifies whether LCY is an EMU currency.];
                ApplicationArea=#Suite;
                SourceExpr="EMU Currency";
                Importance=Additional }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for RV.;
                           ENU=Specifies the currency code for LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="LCY Code" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver symbolet for denne valuta, som du vil have vist p� checks og diagrammer, f.eks. $ for USD, CAD eller MXP.;
                           ENU=Specifies the symbol for this currency that you wish to appear on checks and charts, $ for USD, CAD or MXP for example.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Local Currency Symbol" }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af valutaen.;
                           ENU=Specifies the description of the currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Local Currency Description" }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kontantrabatten beregnes ud fra bel�b inkl. eller ekskl. moms.;
                           ENU=Specifies whether the payment discount is calculated based on amounts including or excluding VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Disc. Excl. VAT";
                Importance=Additional }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil genberegne momsbel�b, n�r du bogf�rer betalinger, der udl�ser kontantrabatter.;
                           ENU=Specifies whether to recalculate tax amounts when you post payments that trigger payment discounts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Adjust for Payment Disc.";
                Importance=Additional }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om ikke-realiseret moms skal behandles.;
                           ENU=Specifies whether to handle unrealized VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unrealized VAT";
                Importance=Additional }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan du vil h�ndtere ikke-realiseret moms p� forudbetalinger.;
                           ENU=Specifies how you want to handle unrealized VAT on prepayments.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepayment Unrealized VAT";
                Importance=Additional }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimale momskorrektionsbel�b, der er tilladt for den lokale valuta.;
                           ENU=Specifies the maximum VAT correction amount allowed for the local currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Max. VAT Difference Allowed";
                Importance=Additional }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan programmet afrunder moms, n�r den beregnes for den lokale valuta.;
                           ENU=Specifies how the program will round VAT when calculated for the local currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Rounding Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til bankkonti.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to bank accounts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account Nos." }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor koden Momsvirk.bogf.gruppe i en ordre eller faktura er kopieret fra.;
                           ENU=Specifies where the VAT Bus. Posting Group code on an order or invoice is copied from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to/Sell-to VAT Calc.";
                Importance=Additional }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der medtages en ekstra momsspecifikation i lokal valuta p� dokumenter i en udenlandsk valuta.;
                           ENU=Specifies that an extra VAT specification in local currency will be included on documents in a foreign currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Print VAT specification in LCY";
                Importance=Additional }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r tabellen Finanspost skal v�re l�st under bogf�ring af salg, k�b og service.;
                           ENU=Specifies when the G/L Entry table should be locked during sales, purchase and service posting.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Use Legacy G/L Entry Locking";
                Importance=Additional }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hvilken bel�b, programmet viser i kladder og p� sider med finansposter.;
                           ENU=Specifies which amounts the program show in journals and ledger entries pages.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Show Amounts";
                Importance=Additional }

    { 1900309501;1;Group  ;
                CaptionML=[DAN=Dimensioner;
                           ENU=Dimensions] }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Importance=Additional }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Importance=Additional }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 3.;
                           ENU=Specifies the code for Shortcut Dimension 3.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 3 Code";
                Importance=Additional }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 4.;
                           ENU=Specifies the code for Shortcut Dimension 4.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 4 Code";
                Importance=Additional }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 5.;
                           ENU=Specifies the code for Shortcut Dimension 5.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 5 Code";
                Importance=Additional }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 6.;
                           ENU=Specifies the code for Shortcut Dimension 6.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 6 Code";
                Importance=Additional }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 7.;
                           ENU=Specifies the code for Shortcut Dimension 7.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 7 Code";
                Importance=Additional }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 8.;
                           ENU=Specifies the code for Shortcut Dimension 8.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 8 Code";
                Importance=Additional }

    { 1904488501;1;Group  ;
                CaptionML=[DAN=Rapportering;
                           ENU=Reporting] }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket kontoskemanavn der bruges til oprettelse af balancerapporten.;
                           ENU=Specifies which account schedule name is used to generate the Balance Sheet report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Acc. Sched. for Balance Sheet" }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket kontoskemanavn der bruges til oprettelse af resultatopg�relsesrapporten.;
                           ENU=Specifies which account schedule name is used to generate the Income Statement report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Acc. Sched. for Income Stmt." }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket kontoskemanavn der bruges til oprettelse af pengestr�msopg�relsesrapporten.;
                           ENU=Specifies which account schedule name is used to generate the Cash Flow Statement report.];
                ApplicationArea=#Advanced;
                SourceExpr="Acc. Sched. for Cash Flow Stmt" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket kontoskemanavn der bruges til oprettelse af rapporten over overf�rt resultat.;
                           ENU=Specifies which account schedule name is used to generate the Retained Earnings report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Acc. Sched. for Retained Earn." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken valuta der skal bruges som ekstra rapporteringsvaluta i finansmodulets funktionalitetsomr�de.;
                           ENU=Specifies the currency that will be used as an additional reporting currency in the general ledger application area.];
                ApplicationArea=#Advanced;
                SourceExpr="Additional Reporting Currency";
                OnValidate=VAR
                             Confirmed@1001 : Boolean;
                           BEGIN
                             IF "Additional Reporting Currency" <> xRec."Additional Reporting Currency" THEN BEGIN
                               IF "Additional Reporting Currency" = '' THEN
                                 Confirmed := CONFIRM(Text002,FALSE)
                               ELSE
                                 Confirmed := CONFIRM(Text003,FALSE);
                               IF NOT Confirmed THEN
                                 ERROR('');
                             END;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan de konti, der er oprettet til momspostering i tabellen Ops�tning af momsbogf., reguleres for kursudsving.;
                           ENU=Specifies how the accounts set up for VAT posting in the VAT Posting Setup table will be adjusted for exchange rate fluctuations.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Exchange Rate Adjustment" }

    { 1904409301;1;Group  ;
                CaptionML=[DAN=Udligning;
                           ENU=Application] }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den afrundingsdifference, der er tilladt ved udligning af poster i RV p� poster i en anden valuta.;
                           ENU=Specifies the rounding difference that will be allowed when you apply entries in LCY to entries in a different currency.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Appln. Rounding Precision" }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der vises en advarsel, hver gang der forekommer en udligning mellem de datoer, der er angivet i feltet Kont.rabatdato og feltet Kontantrabattolerancedato i tabellen Ops�tning af Finans.;
                           ENU=Specifies a warning will appear every time an application occurs between the dates specified in the Payment Discount Date field and the Pmt. Disc. Tolerance Date field in the General Ledger Setup table.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Disc. Tolerance Warning" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf�ringsmetode, som anvendes til bogf�ring af en betalingstolerance.;
                           ENU=Specifies the posting method, which the program follows when posting a payment tolerance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Disc. Tolerance Posting" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange dage som en betaling eller refusion kan overskride forfaldsdatoen for kontantrabatten med, uden at kontantrabatten mistes.;
                           ENU=Specifies the number of days that a payment or refund can pass the payment discount due date and still receive payment discount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Discount Grace Period";
                OnValidate=VAR
                             PaymentToleranceMgt@1000 : Codeunit 426;
                           BEGIN
                             IF CONFIRM(Text001,TRUE) THEN
                               PaymentToleranceMgt.CalcGracePeriodCVLedgEntry("Payment Discount Grace Period");
                           END;
                            }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver at der vises en advarsel, hvis en udligning indeholder en saldo inden for den tolerance, der er angivet i feltet Maks. betalingstolerance i tabellen Ops�tning af Finans.;
                           ENU=Specifies a warning will appear when an application has a balance within the tolerance specified in the Max. Payment Tolerance field in the General Ledger Setup table.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance Warning" }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf�ringsmetoderne for bogf�ring af en betalingstolerance.;
                           ENU=Specifies the posting methods when posting a payment tolerance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance Posting" }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel, som betalingen eller refusionen kan afvige fra det bel�b, der st�r p� fakturaen eller kreditnotaen.;
                           ENU=Specifies the percentage that the payment or refund is allowed to be less than the amount on the invoice or credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Tolerance %" }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimalt tilladte bel�b, som betalingen eller refusionen kan afvige fra det bel�b, der er angivet p� fakturaen eller kreditnotaen.;
                           ENU=Specifies the maximum allowed amount that the payment or refund can differ from the amount on the invoice or credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Max. Payment Tolerance Amount" }

    { 7   ;1   ;Group     ;
                CaptionML=[DAN=Import af l�ntransaktion;
                           ENU=Payroll Transaction Import];
                GroupType=Group }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver formatet p� filen med l�ntransaktioner, der kan importeres i vinduet Finanskladde.;
                           ENU=Specifies the format of the payroll transaction file that can be imported into the General Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payroll Trans. Import Format" }

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
      Text001@1000 : TextConst 'DAN=Vil du �ndre alle �bne poster for hver debitor og kreditor, som ikke er sp�rret?;ENU=Do you want to change all open entries for every customer and vendor that are not blocked?';
      Text002@1002 : TextConst 'DAN=Hvis du sletter den ekstra rapporteringsvaluta, vil fremtidige finansposter kun blive bogf�rt i RV. Hvis du sletter den ekstra rapporteringsvaluta, vil det ikke have nogen effekt p� allerede bogf�rte finansposter.\\Er du sikker p�, du vil slette den ekstra rapporteringsvaluta?;ENU=If you delete the additional reporting currency, future general ledger entries are posted in LCY only. Deleting the additional reporting currency does not affect already posted general ledger entries.\\Are you sure that you want to delete the additional reporting currency?';
      Text003@1001 : TextConst 'DAN=Hvis du �ndrer den ekstra rapporteringsvaluta, vil fremtidige finansposter blive bogf�rt i den nye rapporteringsvaluta og i RV. Hvis du �ndrer den ekstra rapporteringsvaluta, vil der komme en k�rsel frem p� sk�rmen.Hvis du udf�rer denne k�rsel, vil allerede bogf�rte finansposter blive genberegnet automatisk i den nye ekstra rapporteringsvaluta.\Poster i analysevisningen slettes, hvis sp�rring fjernes. En opdatering vil v�re n�dvendig.\\Er du sikker p�, du vil �ndre den ekstra rapporteringsvaluta?;ENU=If you change the additional reporting currency, future general ledger entries are posted in the new reporting currency and in LCY. To enable the additional reporting currency, a batch job opens, and running the batch job recalculates already posted general ledger entries in the new additional reporting currency.\Entries will be deleted in the Analysis View if it is unblocked, and an update will be necessary.\\Are you sure that you want to change the additional reporting currency?';

    BEGIN
    END.
  }
}

