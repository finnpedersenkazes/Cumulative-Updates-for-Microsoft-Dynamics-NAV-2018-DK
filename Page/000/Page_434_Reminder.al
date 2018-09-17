OBJECT Page 434 Reminder
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rykkermeddelelse;
               ENU=Reminder];
    SourceTable=Table295;
    PageType=Document;
    OnOpenPage=VAR
                 OfficeMgt@1000 : Codeunit 1630;
               BEGIN
                 SetDocNoVisible;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
               END;

    OnNewRecord=BEGIN
                  IF (NOT DocNoVisible) AND ("No." = '') THEN
                    SetCustomerFromFilter;
                END;

    OnDeleteRecord=BEGIN
                     CurrPage.SAVERECORD;
                     EXIT(ConfirmDeletion);
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Rykk&er;
                                 ENU=&Reminder];
                      Image=Reminder }
      { 35      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=Vis alle rykkere, der findes.;
                                 ENU=View all reminders that exist.];
                      ApplicationArea=#Basic,#Suite;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 ReminderHeader.COPY(Rec);
                                 IF PAGE.RUNMODAL(0,ReminderHeader) = ACTION::LookupOK THEN
                                   Rec := ReminderHeader;
                               END;
                                }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 442;
                      RunPageLink=Type=CONST(Reminder),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=D&ebitor;
                                 ENU=C&ustomer];
                      ToolTipML=[DAN="èbn kortet for den debitor, som rykkeren eller renten vedrõrer. ";
                                 ENU="Open the card of the customer that the reminder or finance charge applies to. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 22;
                      RunPageLink=No.=FIELD(Customer No.);
                      Image=Customer }
      { 3       ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled="No." <> '';
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 32      ;2   ;Separator  }
      { 25      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 437;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 15      ;2   ;Action    ;
                      Name=CreateReminders;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret rykkere;
                                 ENU=Create Reminders];
                      ToolTipML=[DAN=Opret rykkere for en eller flere debitorer med forfaldne betalinger.;
                                 ENU=Create reminders for one or more customers with overdue payments.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=CreateReminders;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Create Reminders");
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Name=SuggestReminderLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=ForeslÜ rykkerlinjer;
                                 ENU=Suggest Reminder Lines];
                      ToolTipML=[DAN=Opret rykkerlinjer i eksisterende rykkere for alle forfaldne betalinger, der er baseret pÜ oplysningerne i vinduet Rykker.;
                                 ENU=Create reminder lines in existing reminders for any overdue payments based on information in the Reminder window.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=SuggestReminderLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ReminderHeader);
                                 REPORT.RUNMODAL(REPORT::"Suggest Reminder Lines",TRUE,FALSE,ReminderHeader);
                               END;
                                }
      { 24      ;2   ;Action    ;
                      Name=UpdateReminderText;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opdater rykkertekst;
                                 ENU=Update Reminder Text];
                      ToolTipML=[DAN=Erstat start- og sluttekst, der er defineret for det relaterede rykkerniveau med poster fra et andet niveau.;
                                 ENU=Replace the beginning and ending text that has been defined for the related reminder level with those from a different level.];
                      ApplicationArea=#Basic,#Suite;
                      Image=RefreshText;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ReminderHeader);
                                 REPORT.RUNMODAL(REPORT::"Update Reminder Text",TRUE,FALSE,ReminderHeader);
                               END;
                                }
      { 48      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dstedelse;
                                 ENU=&Issuing];
                      Image=Add }
      { 50      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=TestReport;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ReminderHeader);
                                 ReminderHeader.PrintRecords;
                               END;
                                }
      { 56      ;2   ;Action    ;
                      Name=Issue;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udsted;
                                 ENU=Issue];
                      ToolTipML=[DAN=Bogfõr de angivne rykkerposter i overensstemmelse med dine specifikationer i vinduet Rykkerbetingelser. Denne specifikation bestemmer, om renter og/eller yderligere gebyrer skal bogfõres pÜ debitorens konto og i finansregnskabet.;
                                 ENU=Post the specified reminder entries according to your specifications in the Reminder Terms window. This specification determines whether interest and/or additional fees are posted to the customer's account and the general ledger.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ReminderHeader);
                                 REPORT.RUNMODAL(REPORT::"Issue Reminders",TRUE,TRUE,ReminderHeader);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      Image=Report }
      { 1906768606;2 ;Action    ;
                      Name=Report Statement;
                      CaptionML=[DAN=Kontoudtog;
                                 ENU=Statement];
                      ToolTipML=[DAN=Vis en liste over en debitors transaktioner i en bestemt periode, f.eks. for at sende udskriften til debitor i slutningen af en regnskabsperiode. Du kan vëlge at fÜ vist samtlige forfaldne saldi, uafhëngigt af den angivne periode, eller du kan vëlge at inkludere et aldersfordelingsinterval.;
                                 ENU=View a list of a customer's transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 Customer@1000 : Record 18;
                               BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Customer Layout - Statement",Customer);
                               END;
                                }
      { 1906813206;2 ;Action    ;
                      CaptionML=[DAN=Forfaldne debitorposter;
                                 ENU=Customer Detailed Aging];
                      ToolTipML=[DAN=Vis en detaljeret liste over hver debitors samlede forfaldne betalinger, opdelt i tre tidsperioder. Rapporten kan bruges til at bestemme, hvornÜr der skal udstedes rykkere, til at vurdere en debitors kreditvërdighed eller til at udarbejde likviditetsanalyser.;
                                 ENU=View a detailed list of each customer's total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer's creditworthiness, or to prepare liquidity analyses.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 106;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1905727106;2 ;Action    ;
                      CaptionML=[DAN=Debitor - ordreoversigt;
                                 ENU=Customer - Order Summary];
                      ToolTipML=[DAN=Vis ordrebeholdningen (den ikke-leverede beholdning) pr. debitor i tre perioder Ö 30 dage med udgangspunkt i en valgt dato. Der vises desuden kolonner med ordrer, der skal leveres fõr og efter de tre perioder, og en kolonne med ordrebeholdningen pr. debitor i alt. Rapporten kan f.eks. bruges til at analysere virksomhedens forventede salgsomsëtning.;
                                 ENU=View the order detail (the quantity not yet shipped) for each customer in three periods of 30 days each, starting from a selected date. There are also columns with orders to be shipped before and after the three periods and a column with the total order detail for each customer. The report can be used to analyze a company's expected sales volume.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 107;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906871306;2 ;Action    ;
                      CaptionML=[DAN=Debitor - kontokort;
                                 ENU=Customer - Detail Trial Bal.];
                      ToolTipML=[DAN=Vis saldi for debitorer med saldi pÜ en bestemt dato. Rapporten kan f.eks. bruges i slutningen af en regnskabsperiode eller i forbindelse med revision.;
                                 ENU=View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 104;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900711606;2 ;Action    ;
                      CaptionML=[DAN=Aldersfordelte tilgodehavender;
                                 ENU=Aged Accounts Receivable];
                      ToolTipML=[DAN=Vis en oversigt over, hvornÜr debitorers betalinger skal betales eller rykkes for, opdelt i fire perioder. Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 120;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902299006;2 ;Action    ;
                      CaptionML=[DAN=Debitor - saldo til dato;
                                 ENU=Customer - Balance to Date];
                      ToolTipML=[DAN=Vis en liste over debitorers betalingshistorik op til en bestemt dato. Du kan bruge rapporten til at udtrëkke oplysninger om din samlede salgsindkomst ved slutningen af en regnskabsperiode eller et regnskabsÜr.;
                                 ENU=View a list with customers' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 121;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906359306;2 ;Action    ;
                      CaptionML=[DAN=Debitor - balance;
                                 ENU=Customer - Trial Balance];
                      ToolTipML=[DAN=Vis start- og slutsaldi for debitorer med poster i en bestemt periode. Rapporten kan bruges til at bekrëfte, at saldoen for en debitorbogfõringsgruppe svarer til saldoen pÜ den tilsvarende finanskonto pÜ en bestemt dato.;
                                 ENU=View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 129;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1904039606;2 ;Action    ;
                      CaptionML=[DAN=Debitor - betalingskvittering;
                                 ENU=Customer - Payment Receipt];
                      ToolTipML=[DAN=Vis et bilag med de debitorposter, som en betaling er tildelt. Denne rapport kan anvendes som den betalingskvittering, du sender til debitor.;
                                 ENU=View a document showing which customer ledger entries that a payment has been applied to. This report can be used as a payment receipt that you send to the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 211;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Importance=Promoted;
                Visible=DocNoVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, hvortil rykkeren skal bogfõres.;
                           ENU=Specifies the number of the customer you want to post a reminder for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer No.";
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the name of the customer the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Importance=Promoted }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the address of the customer the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bynavnet pÜ den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the city name of the customer the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt kontakter hos den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the name of the person you regularly contact when you communicate with the customer the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN=Angiver telefonnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the telephone number of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Phone No." }

    { 1101100005;2;Field  ;
                ToolTipML=[DAN="Angiver faxnummeret pÜ kontaktpersonen hos debitoren. ";
                           ENU="Specifies the fax number of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Fax No." }

    { 1101100002;2;Field  ;
                ToolTipML=[DAN=Angiver mailadressen pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the email address of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact E-Mail" }

    { 1101100006;2;Field  ;
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Role" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor rykkeren skal udstedes.;
                           ENU=Specifies the date when the reminder should be issued.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rykkerniveauet.;
                           ENU=Specifies the reminder's level.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reminder Level";
                Importance=Promoted;
                Editable=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at betingelsen for niveauet for feltet Rykkerniveau anvendes til alle foreslÜede rykkerlinjer.;
                           ENU=Specifies that the condition of the level for the Reminder Level field is applied to all suggested reminder lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Use Header Level" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Assigned User ID" }

    { 29  ;1   ;Part      ;
                Name=ReminderLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Reminder No.=FIELD(No.);
                PagePartID=Page435;
                PartType=Page }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Bogfõring;
                           ENU=Posting] }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan rykkere om forfaldne betalinger hÜndteres for denne debitor.;
                           ENU=Specifies how reminders about late payments are handled for this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reminder Terms Code";
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for de involverede renter i tilfëlde af sen betaling.;
                           ENU=Specifies the code for the involved finance charges in case of late payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fin. Charge Terms Code";
                Importance=Promoted }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr belõbet pÜ rykkeren er forfalden til betaling.;
                           ENU=Specifies when payment of the amount on the reminder is due.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for rykkeren.;
                           ENU=Specifies the currency code of the reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               TESTFIELD("Posting Date");
                               ChangeExchangeRate.SetParameter(
                                 "Currency Code",
                                 CurrExchRate.ExchangeRate("Posting Date","Currency Code"),
                                 "Posting Date");
                               ChangeExchangeRate.EDITABLE(FALSE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 1101100000;2;Field  ;
                ToolTipML=[DAN=Angiver EAN-lokationsnummeret for debitoren.;
                           ENU=Specifies the EAN location number for the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EAN No." }

    { 1101100012;2;Field  ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code";
                OnValidate=BEGIN
                             AccountCodeOnAfterValidate;
                           END;
                            }

    { 1101100014;2;Field  ;
                ToolTipML=[DAN=Angiver betalingsmetoden Offentlig Information Online UBL (OIOUBL) for bilaget.;
                           ENU=Specifies the Offentlig Information Online UBL (OIOUBL) payment method for the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Channel" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 9   ;1   ;Part      ;
                ApplicationArea=#Advanced;
                SubPageLink=Entry No.=FIELD(Entry No.);
                PagePartID=Page9106;
                ProviderID=29;
                PartType=Page }

    { 1905767507;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ReminderHeader@1000 : Record 295;
      CurrExchRate@1001 : Record 330;
      ChangeExchangeRate@1002 : Page 511;
      DocNoVisible@1003 : Boolean;
      IsOfficeAddin@1004 : Boolean;

    LOCAL PROCEDURE AccountCodeOnAfterValidate@19007267();
    BEGIN
      CurrPage.ReminderLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
      DocType@1003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Reminder,"No.");
    END;

    BEGIN
    END.
  }
}

