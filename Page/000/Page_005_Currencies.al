OBJECT Page 5 Currencies
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572,NAVDK11.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Valutaer;
               ENU=Currencies];
    SourceTable=Table4;
    PageType=List;
    CardPageID=Currency Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Valutakurstjeneste;
                                ENU=New,Process,Report,Exchange Rate Service];
    OnOpenPage=VAR
                 CRMIntegrationManagement@1000 : Codeunit 5330;
               BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
               END;

    OnAfterGetRecord=VAR
                       CurrencyExchangeRate@1000 : Record 330;
                     BEGIN
                       CurrencyFactor := CurrencyExchangeRate.GetCurrentCurrencyFactor(Code);
                       CurrencyExchangeRate.GetLastestExchangeRate(Code,ExchangeRateDate,ExchangeRateAmt);
                     END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1001 : Codeunit 5331;
                         BEGIN
                           CRMIsCoupledToRecord := CRMIntegrationEnabled AND CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 60      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 61      ;2   ;Action    ;
                      CaptionML=[DAN=Skift betalings&tolerance;
                                 ENU=Change Payment &Tolerance];
                      ToolTipML=[DAN=Rediger den maksimale betalingstolerance og/eller betalingstoleranceprocenten og valutafiltre.;
                                 ENU=Change either or both the maximum payment tolerance and the payment tolerance percentage and filters by currency.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ChangePaymentTolerance;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ChangePmtTol@1001 : Report 34;
                               BEGIN
                                 ChangePmtTol.SetCurrency(Rec);
                                 ChangePmtTol.RUNMODAL;
                               END;
                                }
      { 26      ;2   ;Action    ;
                      Name=SuggestAccounts;
                      CaptionML=[DAN=ForeslÜ konti;
                                 ENU=Suggest Accounts];
                      ToolTipML=[DAN=ForeslÜ finanskonti for den valgte valuta.;
                                 ENU=Suggest G/L Accounts for selected currency.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Default;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 SuggestSetupAccounts;
                               END;
                                }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=Kur&ser;
                                 ENU=Exch. &Rates];
                      ToolTipML=[DAN=Vis opdaterede kurser for de valutaer, som du vil bruge.;
                                 ENU=View updated exchange rates for the currencies that you use.];
                      ApplicationArea=#Suite;
                      RunObject=Page 483;
                      RunPageLink=Currency Code=FIELD(Code);
                      Promoted=Yes;
                      Image=CurrencyExchangeRates;
                      PromotedCategory=Process }
      { 1904035104;1 ;Action    ;
                      CaptionML=[DAN=Reguler valutakurs;
                                 ENU=Adjust Exchange Rate];
                      ToolTipML=[DAN=Reguler finans-, debitor-, kreditor- og bankkontoposter, sÜ de svarer til den opdaterede saldo i situationer, hvor kursen har ëndret sig siden bogfõringen.;
                                 ENU=Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.];
                      ApplicationArea=#Suite;
                      RunObject=Report 595;
                      Promoted=Yes;
                      Image=AdjustExchangeRates;
                      PromotedCategory=Process }
      { 1900169904;1 ;Action    ;
                      CaptionML=[DAN=Valutakursreguleringsjournal;
                                 ENU=Exchange Rate Adjust. Register];
                      ToolTipML=[DAN=Vis resultaterne af at udfõre kõrslen Kursreguler valutabeholdninger. Der oprettes Çn linje for hver valuta eller valutakombination og bogfõringsgruppe, der indgÜr i reguleringen.;
                                 ENU=View the results of running the Adjust Exchange Rates batch job. One line is created for each currency or each combination of currency and posting group that is included in the adjustment.];
                      ApplicationArea=#Suite;
                      RunObject=Page 106;
                      RunPageLink=Currency Code=FIELD(Code);
                      Promoted=Yes;
                      Image=ExchangeRateAdjustRegister;
                      PromotedCategory=Process }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Valutakurstjenester;
                                 ENU=Exchange Rate Services];
                      ToolTipML=[DAN=Vis eller rediger konfigurationen af de tjenester, der er konfigureret til at hente opdaterede valutakurser, nÜr du vëlger handlingen Opdater valutakurser.;
                                 ENU=View or edit the setup of the services that are set up to fetch updated currency exchange rates when you choose the Update Exchange Rates action.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1650;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Web;
                      PromotedCategory=Category4 }
      { 3       ;1   ;Action    ;
                      Name=UpdateExchangeRates;
                      CaptionML=[DAN=Opdater valutakurser;
                                 ENU=Update Exchange Rates];
                      ToolTipML=[DAN=Brug de seneste valutakurser fra en tjenesteudbyder.;
                                 ENU=Get the latest currency exchange rates from a service provider.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 1281;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=UpdateXML;
                      PromotedCategory=Category4 }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1901143306;1 ;Action    ;
                      CaptionML=[DAN=Valutaopgõrelse;
                                 ENU=Foreign Currency Balance];
                      ToolTipML=[DAN=Vis saldi for alle debitorer og kreditorer i sÜvel udenlandsk valuta som i den lokale valuta (RV). Rapporten indeholder to RV-saldi: Den ene er det udenlandske valutabelõb omregnet til den relevante regnskabsvaluta vha. den valutakurs, der var gëldende pÜ tidspunktet for transaktionen. Den anden er det udenlandske valutabelõb omregnet til den relevante regnskabsvaluta vha. valutakursen pÜ arbejdsdatoen.;
                                 ENU=View the balances for all customers and vendors in both foreign currencies and in local currency (LCY). The report displays two LCY balances. One is the foreign currency balance converted to LCY by using the exchange rate at the time of the transaction. The other is the foreign currency balance converted to LCY by using the exchange rate of the work date.];
                      ApplicationArea=#Suite;
                      RunObject=Report 503;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 17      ;0   ;ActionContainer;
                      Name=NavigateTab;
                      ActionContainerType=RelatedInformation }
      { 20      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled;
                      Image=Administration }
      { 22      ;2   ;Action    ;
                      Name=CRMGotoTransactionCurrency;
                      CaptionML=[DAN=Transaktionsvaluta;
                                 ENU=Transaction Currency];
                      ToolTipML=[DAN=èbn den sammenkëdede Dynamics 365 for Sales-transaktionsvaluta.;
                                 ENU=Open the coupled Dynamics 365 for Sales transaction currency.];
                      ApplicationArea=#Suite;
                      Image=CoupledCurrency;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Synkroniser;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send de opdaterede data til Dynamics 365 for Sales.;
                                 ENU=Send updated data to Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Image=Refresh;
                      OnAction=VAR
                                 Currency@1000 : Record 4;
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                                 CurrencyRecordRef@1002 : RecordRef;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Currency);
                                 Currency.NEXT;

                                 IF Currency.COUNT = 1 THEN
                                   CRMIntegrationManagement.UpdateOneNow(Currency.RECORDID)
                                 ELSE BEGIN
                                   CurrencyRecordRef.GETTABLE(Currency);
                                   CRMIntegrationManagement.UpdateMultipleNow(CurrencyRecordRef);
                                 END
                               END;
                                }
      { 15      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenkëdning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenkëdning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 14      ;3   ;Action    ;
                      Name=ManageCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Konfigurer sammenkëdning;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Opret eller rediger sammenkëdningen med en Dynamics 365 for Sales-transaktionsvaluta.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales Transaction Currency.];
                      ApplicationArea=#Suite;
                      Image=LinkAccount;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.DefineCoupling(RECORDID);
                               END;
                                }
      { 11      ;3   ;Action    ;
                      Name=DeleteCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Slet sammenkëdning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenkëdningen med en Dynamics 365 for Sales-transaktionsvaluta.;
                                 ENU=Delete the coupling to a Dynamics 365 for Sales Transaction Currency.];
                      ApplicationArea=#Suite;
                      Enabled=CRMIsCoupledToRecord;
                      Image=UnLinkAccount;
                      OnAction=VAR
                                 CRMCouplingManagement@1000 : Codeunit 5331;
                               BEGIN
                                 CRMCouplingManagement.RemoveCoupling(RECORDID);
                               END;
                                }
      { 24      ;2   ;Action    ;
                      Name=ShowLog;
                      CaptionML=[DAN=Synkroniseringslog;
                                 ENU=Synchronization Log];
                      ToolTipML=[DAN=Vis integrationssynkroniseringsjobs for valutatabellen.;
                                 ENU=View integration synchronization jobs for the currency table.];
                      ApplicationArea=#Suite;
                      Image=Log;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowLog(RECORDID);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en valutakode, du kan vëlge. Koden skal overholde ISO 4217.;
                           ENU=Specifies a currency code that you can select. The code must comply with ISO 4217.];
                ApplicationArea=#Suite;
                SourceExpr=Code }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en tekst, der beskriver valutakoden.;
                           ENU=Specifies a text to describe the currency code.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Valutakursdato;
                           ENU=Exchange Rate Date];
                ToolTipML=[DAN=Angiver datoen for valutakursen i feltet Valutakurs. Du kan opdatere kursen ved at vëlge knappen Opdater valutakurser.;
                           ENU=Specifies the date of the exchange rate in the Exchange Rate field. You can update the rate by choosing the Update Exchange Rates button.];
                ApplicationArea=#Suite;
                SourceExpr=ExchangeRateDate;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrillDownActionOnPage;
                            END;
                             }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Valutakurs;
                           ENU=Exchange Rate];
                ToolTipML=[DAN=Angiver valutakursen. Du kan opdatere kursen ved at vëlge knappen Opdater valutakurser.;
                           ENU=Specifies the currency exchange rate. You can update the rate by choosing the Update Exchange Rates button.];
                ApplicationArea=#Suite;
                DecimalPlaces=0:7;
                SourceExpr=ExchangeRateAmt;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrillDownActionOnPage;
                            END;
                             }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om valutaen er en ùMU-valuta, for eksempel DEM eller EUR.;
                           ENU=Specifies whether the currency is an EMU currency, for example DEM or EUR.];
                ApplicationArea=#Suite;
                SourceExpr="EMU Currency" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskontonummer, som de realiserede kursgevinster skal bogfõres pÜ.;
                           ENU=Specifies the general ledger account number to which realized exchange rate gains will be posted.];
                ApplicationArea=#Suite;
                SourceExpr="Realized Gains Acc." }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskontonummer, som de realiserede kurstab skal bogfõres pÜ.;
                           ENU=Specifies the general ledger account number to which realized exchange rate losses will be posted.];
                ApplicationArea=#Suite;
                SourceExpr="Realized Losses Acc." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskontonummer, som de ikke-realiserede kursgevinster skal bogfõres pÜ, nÜr kõrslen Kursreguler valutabeholdninger kõres.;
                           ENU=Specifies the general ledger account number to which unrealized exchange rate gains will be posted when the Adjust Exchange Rates batch job is run.];
                ApplicationArea=#Suite;
                SourceExpr="Unrealized Gains Acc." }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskontonummer, som de ikke-realiserede kurstab skal bogfõres pÜ, nÜr kõrslen Kursreguler valutabeholdninger kõres.;
                           ENU=Specifies the general ledger account number to which unrealized exchange rate losses will be posted when the Adjust Exchange Rates batch job is run.];
                ApplicationArea=#Suite;
                SourceExpr="Unrealized Losses Acc." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, hvor kursgevinster skal bogfõres for kursreguleringer mellem regnskabsvalutaen og den ekstra rapporteringsvaluta.;
                           ENU=Specifies the general ledger account to post exchange rate gains to for currency adjustments between LCY and the additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Realized G/L Gains Account";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, hvor kursgevinster skal bogfõres for kursreguleringer mellem regnskabsvalutaen og den ekstra rapporteringsvaluta.;
                           ENU=Specifies the general ledger account to post exchange rate gains to for currency adjustments between LCY and the additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Realized G/L Losses Account";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, hvor resterende belõb (gevinst) skal bogfõres pÜ, hvis du bogfõrer i funktionalitetsomrÜdet i finansmodulet i bÜde RV og en ekstra rapporteringsvaluta.;
                           ENU=Specifies the general ledger account to post residual amount gains to, if you post in the general ledger application area in both LCY and an additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Residual Gains Account";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, hvor resterende belõb (gevinst) skal bogfõres pÜ, hvis du bogfõrer i funktionalitetsomrÜdet i finansmodulet i bÜde RV og en ekstra rapporteringsvaluta.;
                           ENU=Specifies the general ledger account to post residual amount losses to, if you post in the general ledger application area in both LCY and an additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Residual Losses Account";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver stõrrelsen pÜ det interval, der skal bruges til afrunding af belõb i denne valuta.;
                           ENU=Specifies the size of the interval to be used when rounding amounts in this currency.];
                ApplicationArea=#Suite;
                SourceExpr="Amount Rounding Precision" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antal decimaler, der bliver vist for belõb i denne valuta.;
                           ENU=Specifies the number of decimal places the program will display for amounts in this currency.];
                ApplicationArea=#Suite;
                SourceExpr="Amount Decimal Places" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver stõrrelsen pÜ det interval, der skal bruges til afrunding af belõb i denne valuta. Du kan angive en fakturaafrunding for hver valuta i valutatabellen.;
                           ENU=Specifies the size of the interval to be used when rounding amounts in this currency. You can specify invoice rounding for each currency in the Currency table.];
                ApplicationArea=#Suite;
                SourceExpr="Invoice Rounding Precision" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om et fakturabelõb skal rundes op eller ned. Oplysningerne sammenholdes med oplysningerne om afrundingsintervallet, der er angivet i feltet Fakturaafrundingsprëcision.;
                           ENU=Specifies whether an invoice amount will be rounded up or down. The program uses this information together with the interval for rounding that you have specified in the Invoice Rounding Precision field.];
                ApplicationArea=#Suite;
                SourceExpr="Invoice Rounding Type" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver stõrrelsen pÜ det interval, der skal bruges til afrunding af priser (dvs. varepris pr. enhed) i denne valuta.;
                           ENU=Specifies the size of the interval to be used when rounding unit amounts (that is, item prices per unit) in this currency.];
                ApplicationArea=#Suite;
                SourceExpr="Unit-Amount Rounding Precision" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antal decimaler, der bliver vist for belõb i denne valuta.;
                           ENU=Specifies the number of decimal places the program will display for amounts in this currency.];
                ApplicationArea=#Suite;
                SourceExpr="Unit-Amount Decimal Places" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det interval, der skal gëlde som afrundingsdifference, nÜr du udligner poster i forskellige valutaer.;
                           ENU=Specifies the size of the interval that will be allowed as a rounding difference when you apply entries in different currencies to one another.];
                ApplicationArea=#Suite;
                SourceExpr="Appln. Rounding Precision" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konverteringsoplysninger, der ogsÜ skal indeholde en debetkonto, hvis du vil indsëtte rettelseslinjer til afrundingsdifferencer i finanskladden vha. funktionen Indsët konv. RV-afrund.linjer.;
                           ENU=Specifies conversion information that must also contain a debit account if you wish to insert correction lines for rounding differences in the general journals using the Insert Conv. LCY Rndg. Lines function.];
                ApplicationArea=#Suite;
                SourceExpr="Conv. LCY Rndg. Debit Acc." }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konverteringsoplysninger, der ogsÜ skal indeholde en kreditkonto, hvis du vil indsëtte rettelseslinjer til afrundingsdifferencer i finanskladden vha. funktionen Indsët konv. RV-afrund.linjer.;
                           ENU=Specifies conversion information that must also contain a credit account if you wish to insert correction lines for rounding differences in the general journals using the Insert Conv. LCY Rndg. Lines function.];
                ApplicationArea=#Suite;
                SourceExpr="Conv. LCY Rndg. Credit Acc." }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimale momskorrektionsbelõb, der er tilladt for valutaen.;
                           ENU=Specifies the maximum VAT correction amount allowed for the currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Max. VAT Difference Allowed";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan programmet afrunder moms, nÜr den beregnes for denne valuta.;
                           ENU=Specifies how the program will round VAT when calculated for this currency.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Rounding Type";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den seneste kursjustering blev udfõrt, dvs. hvornÜr kõrslen Kursreguler valutabeholdninger sidst blev udfõrt.;
                           ENU=Specifies when the exchange rates were last adjusted, that is, the last date on which the Adjust Exchange Rates batch job was run.];
                ApplicationArea=#Suite;
                SourceExpr="Last Date Adjusted" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor oplysningerne i tabellen Valuta sidst blev ëndret.;
                           ENU=Specifies the last date on which any information in the Currency table was modified.];
                ApplicationArea=#Suite;
                SourceExpr="Last Date Modified" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel, som betalingen eller refusionen kan afvige fra det belõb, der stÜr pÜ fakturaen eller kreditnotaen.;
                           ENU=Specifies the percentage that the payment or refund is allowed to be, less than the amount on the invoice or credit memo.];
                ApplicationArea=#Suite;
                SourceExpr="Payment Tolerance %" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimalt tilladte belõb, som betalingen eller refusionen kan afvige fra det belõb, der er angivet pÜ fakturaen eller kreditnotaen.;
                           ENU=Specifies the maximum allowed amount that the payment or refund can differ from the amount on the invoice or credit memo.];
                ApplicationArea=#Suite;
                SourceExpr="Max. Payment Tolerance Amount" }

    { 62  ;2   ;Field     ;
                CaptionML=[DAN=Valutafaktor;
                           ENU=Currency Factor];
                ToolTipML=[DAN=Angiver relationen mellem den ekstra rapporteringsvaluta og den lokale valuta. Belõb registreres automatisk i bÜde RV og den ekstra rapporteringsvaluta vha. den relevante valutakurs og valutafaktoren.;
                           ENU=Specifies the relationship between the additional reporting currency and the local currency. Amounts are recorded in both LCY and the additional reporting currency, using the relevant exchange rate and the currency factor.];
                ApplicationArea=#Suite;
                DecimalPlaces=1:6;
                SourceExpr=CurrencyFactor;
                OnValidate=VAR
                             CurrencyExchangeRate@1000 : Record 330;
                           BEGIN
                             CurrencyExchangeRate.SetCurrentCurrencyFactor(Code,CurrencyFactor);
                           END;
                            }

    { 1101100000;2;Field  ;
                ToolTipML=[DAN=Angiver den valutakode pÜ tre tegn, der krëves for valutaer, som bruges pÜ elektroniske fakturaer.;
                           ENU=Specifies the three character currency code that is required for currencies that are used in electronic invoices.];
                ApplicationArea=#Suite;
                SourceExpr="OIOUBL Currency Code" }

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
      CurrencyFactor@1000 : Decimal;
      ExchangeRateAmt@1001 : Decimal;
      ExchangeRateDate@1002 : Date;
      CRMIntegrationEnabled@1004 : Boolean;
      CRMIsCoupledToRecord@1003 : Boolean;

    [External]
    PROCEDURE GetSelectionFilter@2() : Text;
    VAR
      Currency@1001 : Record 4;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(Currency);
      EXIT(SelectionFilterManagement.GetSelectionFilterForCurrency(Currency));
    END;

    [External]
    PROCEDURE GetCurrency@1(VAR CurrencyCode@1000 : Code[10]);
    BEGIN
      CurrencyCode := Code;
    END;

    LOCAL PROCEDURE DrillDownActionOnPage@4();
    VAR
      CurrExchRate@1000 : Record 330;
    BEGIN
      CurrExchRate.SETRANGE("Currency Code",Code);
      PAGE.RUNMODAL(0,CurrExchRate);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

