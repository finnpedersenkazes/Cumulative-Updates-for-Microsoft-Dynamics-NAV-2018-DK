OBJECT Page 414 G/L Balance
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finans - saldi;
               ENU=G/L Balance];
    SaveValues=Yes;
    SourceTable=Table15;
    PageType=Worksheet;
    OnOpenPage=BEGIN
                 FindPeriod('');
               END;

    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       IF DebitCreditTotals THEN
                         CALCFIELDS("Net Change","Debit Amount","Credit Amount")
                       ELSE BEGIN
                         CALCFIELDS("Net Change");
                         IF "Net Change" > 0 THEN BEGIN
                           "Debit Amount" := "Net Change";
                           "Credit Amount" := 0
                         END ELSE BEGIN
                           "Debit Amount" := 0;
                           "Credit Amount" := -"Net Change"
                         END
                       END;
                       FormatLine;
                     END;

    OnNewRecord=BEGIN
                  SetupNewGLAcc(xRec,BelowxRec);
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 33      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Se oplysninger om finanskonti, f.eks. kontonummer, kontonavn, og om kontoen er en del af resultatopgõrelsen eller balancen.;
                                 ENU=View information about general ledger accounts, such as the account number, account name, and whether the account is part of the income statement or balance sheet.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 17;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Budget Filter=FIELD(Budget Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter);
                      Image=EditLines }
      { 34      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 20;
                      RunPageView=SORTING(G/L Account No.);
                      RunPageLink=G/L Account No.=FIELD(No.);
                      Promoted=No;
                      Image=GLRegisters }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 184     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(15),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=&Udvidede tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=Se yderligere oplysninger om en finanskonto - det supplerer feltet Beskrivelse.;
                                 ENU=View additional information about a general ledger account, this supplements the Description field.];
                      ApplicationArea=#Suite;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=Text }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Likviditet;
                                 ENU=Receivables-Payables];
                      ToolTipML=[DAN=Vis en oversigt over tilgodehavender og skyldige belõb for kontoen, herunder skyldige belõb for debitor- og kreditorsaldi.;
                                 ENU=View a summary of the receivables and payables for the account, including customer and vendor balance due amounts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 159;
                      Image=ReceivablesPayables }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Forrige periode;
                                 ENU=Previous Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret pÜ den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen fõr.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 FindPeriod('<=');
                               END;
                                }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=Nëste periode;
                                 ENU=Next Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret pÜ den nëste periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen efter.;
                                 ENU=Show the information based on the next period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=NextRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 FindPeriod('>=');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 50  ;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options] }

    { 40  ;2   ;Field     ;
                CaptionML=[DAN=Ultimoposter;
                           ENU=Closing Entries];
                ToolTipML=[DAN=Angiver, om den viste saldo skal indeholde ultimoposter. Hvis du vil se belõbene pÜ resultatopgõrelseskontiene i afsluttede Ür, skal du udelukke ultimoposter.;
                           ENU=Specifies whether the balance shown will include closing entries. If you want to see the amounts on income statement accounts in closed years, you must exclude closing entries.];
                OptionCaptionML=[DAN=Medtag,Udelad;
                                 ENU=Include,Exclude];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ClosingEntryFilter;
                OnValidate=BEGIN
                             FindPeriod('');
                             ClosingEntryFilterOnAfterValid;
                           END;
                            }

    { 27  ;2   ;Field     ;
                CaptionML=[DAN=Debet- og kredittotaler;
                           ENU=Debit && Credit Totals];
                ToolTipML=[DAN=Angiver, at de samlede belõb for debet og kredit vises i matrixvinduet.;
                           ENU=Specifies that the totals for both debit and credit are displayed in the matrix window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DebitCreditTotals;
                OnValidate=BEGIN
                             DebitCreditTotalsOnAfterValida;
                           END;
                            }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode belõbene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             IF PeriodType = PeriodType::"Accounting Period" THEN
                               AccountingPerioPeriodTypeOnVal;
                             IF PeriodType = PeriodType::Year THEN
                               YearPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Quarter THEN
                               QuarterPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Month THEN
                               MonthPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Week THEN
                               WeekPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Day THEN
                               DayPeriodTypeOnValidate;
                           END;
                            }

    { 25  ;2   ;Field     ;
                CaptionML=[DAN=Vis som;
                           ENU=View as];
                ToolTipML=[DAN=Angiver, hvordan belõbene vises. Bevëgelse: Bevëgelsen i saldoen for den valgte periode. Saldo til dato: Saldoen pÜ den sidste dag i den valgte periode.;
                           ENU=Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.];
                OptionCaptionML=[DAN=Bevëgelse,Saldo til dato;
                                 ENU=Net Change,Balance at Date];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AmountType;
                OnValidate=BEGIN
                             IF AmountType = AmountType::"Balance at Date" THEN
                               BalanceatDateAmountTypeOnValid;
                             IF AmountType = AmountType::"Net Change" THEN
                               NetChangeAmountTypeOnValidate;
                           END;
                            }

    { 2   ;2   ;Field     ;
                Name=DateFilter;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver de datoer, der bruges til at filtrere belõbene i vinduet.;
                           ENU=Specifies the dates that will be used to filter the amounts in the window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DateFilter;
                Importance=Promoted;
                OnValidate=VAR
                             ApplicationManagement@1000 : Codeunit 1;
                           BEGIN
                             IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;
                             SETFILTER("Date Filter",DateFilter);
                             DateFilter := GETFILTER("Date Filter");
                             CurrPage.UPDATE;
                           END;
                            }

    { 5   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=Emphasize }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ finanskontoen.;
                           ENU=Specifies the name of the general ledger account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en finanskonto er en resultatopgõrelseskonto eller en balancekonto.;
                           ENU=Specifies whether a general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Income/Balance";
                Style=Strong;
                StyleExpr=Emphasize }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der reprësenterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                BlankNumbers=BlankZero;
                SourceExpr="Debit Amount";
                Style=Strong;
                StyleExpr=Emphasize }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der reprësenterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                BlankNumbers=BlankZero;
                SourceExpr="Credit Amount";
                Style=Strong;
                StyleExpr=Emphasize }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bevëgelsen pÜ kontosaldoen i den periode, der er indtastet i feltet Datofilter.;
                           ENU=Specifies the net change in the account balance during the time period in the Date Filter field.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Net Change";
                Visible=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

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
      PeriodType@1000 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      AmountType@1001 : 'Net Change,Balance at Date';
      ClosingEntryFilter@1002 : 'Include,Exclude';
      DebitCreditTotals@1003 : Boolean;
      Emphasize@19074284 : Boolean INDATASET;
      NameIndent@19079073 : Integer INDATASET;
      DateFilter@1004 : Text;

    LOCAL PROCEDURE FindPeriod@1(SearchText@1000 : Code[10]);
    VAR
      Calendar@1001 : Record 2000000007;
      AccountingPeriod@1002 : Record 50;
      PeriodFormMgt@1003 : Codeunit 359;
    BEGIN
      IF GETFILTER("Date Filter") <> '' THEN BEGIN
        Calendar.SETFILTER("Period Start",GETFILTER("Date Filter"));
        IF NOT PeriodFormMgt.FindDate('+',Calendar,PeriodType) THEN
          PeriodFormMgt.FindDate('+',Calendar,PeriodType::Day);
        Calendar.SETRANGE("Period Start");
      END;
      PeriodFormMgt.FindDate(SearchText,Calendar,PeriodType);
      IF AmountType = AmountType::"Net Change" THEN
        IF Calendar."Period Start" = Calendar."Period End" THEN
          SETRANGE("Date Filter",Calendar."Period Start")
        ELSE
          SETRANGE("Date Filter",Calendar."Period Start",Calendar."Period End")
      ELSE
        SETRANGE("Date Filter",0D,Calendar."Period End");
      IF ClosingEntryFilter = ClosingEntryFilter::Exclude THEN BEGIN
        AccountingPeriod.SETCURRENTKEY("New Fiscal Year");
        AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
        IF GETRANGEMIN("Date Filter") = 0D THEN
          AccountingPeriod.SETRANGE("Starting Date",0D,GETRANGEMAX("Date Filter"))
        ELSE BEGIN
          IF NOT (GETRANGEMIN("Date Filter") = NORMALDATE(GETRANGEMIN("Date Filter"))) THEN
            AccountingPeriod.SETRANGE(
              "Starting Date",
              GETRANGEMIN("Date Filter") + 1,
              GETRANGEMAX("Date Filter"))
          ELSE
            AccountingPeriod.SETRANGE(
              "Starting Date",0D,
              GETRANGEMIN("Date Filter") + 1);
        END;
        IF AccountingPeriod.FIND('-') THEN
          REPEAT
            SETFILTER(
              "Date Filter",GETFILTER("Date Filter") + '&<>%1',
              CLOSINGDATE(AccountingPeriod."Starting Date" - 1));
          UNTIL AccountingPeriod.NEXT = 0;
      END ELSE
        SETRANGE(
          "Date Filter",
          GETRANGEMIN("Date Filter"),
          CLOSINGDATE(GETRANGEMAX("Date Filter")));
      DateFilter := GETFILTER("Date Filter");
    END;

    LOCAL PROCEDURE ClosingEntryFilterOnAfterValid@19030533();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE DebitCreditTotalsOnAfterValida@19017628();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE DayPeriodTypeOnPush@19008851();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE WeekPeriodTypeOnPush@19046063();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE MonthPeriodTypeOnPush@19047374();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE QuarterPeriodTypeOnPush@19018850();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE YearPeriodTypeOnPush@19051042();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE AccountingPerioPeriodTypOnPush@19038761();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE BalanceatDateAmountTypeOnPush@19049003();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE NetChangeAmountTypeOnPush@19074855();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE FormatLine@19039177();
    BEGIN
      NameIndent := Indentation;
      Emphasize := "Account Type" <> "Account Type"::Posting;
    END;

    LOCAL PROCEDURE DayPeriodTypeOnValidate@19012979();
    BEGIN
      DayPeriodTypeOnPush;
    END;

    LOCAL PROCEDURE WeekPeriodTypeOnValidate@19058475();
    BEGIN
      WeekPeriodTypeOnPush;
    END;

    LOCAL PROCEDURE MonthPeriodTypeOnValidate@19021027();
    BEGIN
      MonthPeriodTypeOnPush;
    END;

    LOCAL PROCEDURE QuarterPeriodTypeOnValidate@19015346();
    BEGIN
      QuarterPeriodTypeOnPush;
    END;

    LOCAL PROCEDURE YearPeriodTypeOnValidate@19064743();
    BEGIN
      YearPeriodTypeOnPush;
    END;

    LOCAL PROCEDURE AccountingPerioPeriodTypeOnVal@19058901();
    BEGIN
      AccountingPerioPeriodTypOnPush;
    END;

    LOCAL PROCEDURE NetChangeAmountTypeOnValidate@19062218();
    BEGIN
      NetChangeAmountTypeOnPush;
    END;

    LOCAL PROCEDURE BalanceatDateAmountTypeOnValid@19007073();
    BEGIN
      BalanceatDateAmountTypeOnPush;
    END;

    BEGIN
    END.
  }
}

