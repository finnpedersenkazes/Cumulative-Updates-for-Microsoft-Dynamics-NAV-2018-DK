OBJECT Page 981 Payment Registration
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Betalingsregistrering;
               ENU=Payment Registration];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table981;
    DataCaptionExpr=BalAccCaption;
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Bogfõr,Naviger,Sõg,Konfigurer;
                                ENU=New,Process,Report,Post,Navigate,Search,Setup];
    OnOpenPage=BEGIN
                 PaymentRegistrationMgt.RunSetup;
                 FormatPageCaption;
               END;

    OnFindRecord=BEGIN
                   Reload;
                   PaymentRegistrationMgt.CalculateBalance(PostedBalance,UnpostedBalance);
                   TotalBalance := PostedBalance + UnpostedBalance;
                   EXIT(FIND(Which));
                 END;

    OnAfterGetRecord=BEGIN
                       SetUserInteractions;
                     END;

    OnQueryClosePage=BEGIN
                       EXIT(PaymentRegistrationMgt.ConfirmClose(Rec));
                     END;

    ActionList=ACTIONS
    {
      { 37      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=Relaterede oplysninger;
                                 ENU=Related Information];
                      Image=Navigate }
      { 30      ;2   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=Naviger;
                                 ENU=Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Navigate;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 28      ;2   ;Action    ;
                      Name=Details;
                      CaptionML=[DAN=Detaljer;
                                 ENU=Details];
                      ToolTipML=[DAN=FÜ vist yderligere oplysninger om bilaget pÜ den valgte linje, og sammenkëd med det dertilhõrende debitorkort.;
                                 ENU=View additional information about the document on the selected line and link to the related customer card.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewDetails;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"Payment Registration Details",Rec);
                               END;
                                }
      { 46      ;1   ;ActionGroup;
                      CaptionML=[DAN=Sõg;
                                 ENU=Search] }
      { 16      ;2   ;Action    ;
                      Name=SearchCustomer;
                      CaptionML=[DAN=Sõg efter debitorer;
                                 ENU=Search Customers];
                      ToolTipML=[DAN=èbn listen over debitorer, f.eks. for at kontrollere for manglende betalinger fra en bestemt debitor.;
                                 ENU=Open the list of customers, for example, to check for missing payments from a specific customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 22;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Navigate;
                      PromotedCategory=Category6 }
      { 17      ;2   ;Action    ;
                      Name=SearchDocument;
                      CaptionML=[DAN=Sõg i dokumenter;
                                 ENU=Search Documents];
                      ToolTipML=[DAN=Sõg efter bilag, der ikke er fuldt fakturerede, for eksempel for at bogfõre en faktura, sÜ den modtagne betaling kan behandles.;
                                 ENU=Find documents that are not fully invoiced, for example, to post an invoice so that the received payment can be processed.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 985;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Navigate;
                      PromotedCategory=Category6 }
      { 13      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogfõr;
                                 ENU=Post];
                      Image=Post }
      { 15      ;2   ;Action    ;
                      Name=PostPayments;
                      ShortCutKey=F9;
                      CaptionML=[DAN=Bogfõr betalinger;
                                 ENU=Post Payments];
                      ToolTipML=[DAN=Bogfõr betalingen af belõb pÜ de linjer, hvor feltet Betaling foretaget er markeret.;
                                 ENU=Post payment of amounts on the lines where the Payment Made check box is selected.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PaymentRegistrationMgt.ConfirmPost(Rec);
                               END;
                                }
      { 22      ;2   ;Action    ;
                      Name=PostAsLump;
                      CaptionML=[DAN=Bogfõr som engangsbetaling;
                                 ENU=Post as Lump Payment];
                      ToolTipML=[DAN=Bogfõr betalingen som engangsbetaling af belõb pÜ linjer, hvor feltet Betaling foretaget er afkrydset.;
                                 ENU=Post payment as a lump sum of amounts on lines where the Payment Made check box is selected.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PaymentRegistrationMgt.ConfirmPostLumpPayment(Rec);
                               END;
                                }
      { 25      ;2   ;Action    ;
                      Name=PreviewPayments;
                      CaptionML=[DAN=Vis bogfõring af betalinger;
                                 ENU=Preview Posting Payments];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, nÜr du bogfõrer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 PaymentRegistrationMgt@1000 : Codeunit 980;
                               BEGIN
                                 PaymentRegistrationMgt.Preview(Rec,FALSE);
                               END;
                                }
      { 39      ;2   ;Action    ;
                      Name=PreviewLump;
                      CaptionML=[DAN=Vis bogfõring af engangsbetalinger;
                                 ENU=Preview Posting Payments as Lump];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, nÜr du bogfõrer bilaget eller kladden som et engangsbelõb.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal as a lump sum of amounts.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 PaymentRegistrationMgt@1000 : Codeunit 980;
                               BEGIN
                                 PaymentRegistrationMgt.Preview(Rec,TRUE);
                               END;
                                }
      { 38      ;1   ;ActionGroup;
                      CaptionML=[DAN=Nye dokumenter;
                                 ENU=New Documents] }
      { 19      ;2   ;Action    ;
                      Name=OpenGenJnl;
                      CaptionML=[DAN=Finanskladde;
                                 ENU=General Journal];
                      ToolTipML=[DAN=èbn finanskladden, for eksempel for at registrere eller bogfõre en betaling, der ikke har et tilknyttet bilag.;
                                 ENU=Open the general journal, for example, to record or post a payment that has no related document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GLRegisters;
                      OnAction=BEGIN
                                 PaymentRegistrationMgt.OpenGenJnl
                               END;
                                }
      { 18      ;2   ;Action    ;
                      Name=FinanceChargeMemo;
                      CaptionML=[DAN=Rentenota;
                                 ENU=Finance Charge Memo];
                      ToolTipML=[DAN=Opret en rentenota til kunden pÜ den valgte linje, for eksempel for at udstede en rentenota for sen betaling.;
                                 ENU=Create a finance charge memo for the customer on the selected line, for example, to issue a finance charge for late payment.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 446;
                      RunPageLink=Customer No.=FIELD(Source No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FinChargeMemo;
                      RunPageMode=Create;
                      Scope=Repeater }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Setup];
                      Image=Setup }
      { 31      ;2   ;Action    ;
                      Name=Setup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Setup];
                      ToolTipML=[DAN=Reguler mÜden, hvorpÜ betalingerne bogfõres, og modkontoen, der skal anvendes.;
                                 ENU=Adjust how payments are posted and which balancing account to use.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Setup;
                      PromotedCategory=Category7;
                      OnAction=BEGIN
                                 IF PAGE.RUNMODAL(PAGE::"Payment Registration Setup") = ACTION::LookupOK THEN
                                   FormatPageCaption
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Source No.";
                Visible=FALSE;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                DrillDown=Yes;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor eller kreditor, som betalingen relaterer til.;
                           ENU=Specifies the name of the customer or vendor that the payment relates to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Editable=FALSE;
                OnDrillDown=VAR
                              Customer@1000 : Record 18;
                            BEGIN
                              Customer.GET("Source No.");
                              PAGE.RUN(PAGE::"Customer Card",Customer);
                            END;
                             }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det bilag, som betalingen relaterer til.;
                           ENU=Specifies the number of the document that the payment relates to.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              Navigate;
                            END;
                             }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for det bilag, som betalingen relaterer til.;
                           ENU=Specifies the type of document that the payment relates to.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Type";
                Visible=FALSE;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den fakturatransaktion, som betalingen relaterer til.;
                           ENU=Specifies the invoice transaction that the payment relates to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for betalingen pÜ det tilknyttede bilag.;
                           ENU=Specifies the payment due date on the related document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Editable=FALSE;
                StyleExpr=DueDateStyle }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der mangler at blive betalt pÜ bilaget.;
                           ENU=Specifies the amount that remains to be paid on the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount";
                Editable=FALSE;
                StyleExpr=PmtDiscStyle }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du har modtaget eller foretaget en betaling for bilaget.;
                           ENU=Specifies if you have received or made payment for the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Made";
                OnValidate=BEGIN
                             SetUserInteractions;
                           END;
                            }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor betalingen blev foretaget.;
                           ENU=Specifies the date when the payment was made.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Date Received";
                StyleExpr=DueDateStyle;
                OnValidate=BEGIN
                             SetUserInteractions;
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der er betalt pÜ bankkontoen.;
                           ENU=Specifies the amount that is paid in the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Received";
                OnValidate=BEGIN
                             SetUserInteractions;
                           END;
                            }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Discount Date";
                AutoFormatType=1;
                Visible=FALSE;
                StyleExpr=PmtDiscStyle;
                OnValidate=BEGIN
                             SetUserInteractions
                           END;
                            }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Restbelõb inkl. rabat;
                           ENU=Rem Amount Incl. Discount];
                ToolTipML=[DAN=Angiver restbelõbet, efter kontantrabatten er fratrukket.;
                           ENU=Specifies the remaining amount after the payment discount is deducted.];
                ApplicationArea=#Advanced;
                SourceExpr="Rem. Amt. after Discount";
                Visible=FALSE;
                Editable=FALSE }

    { 32  ;1   ;Group     ;
                CaptionML=[DAN=Oplysninger om saldokonto;
                           ENU=Bal. Account Details];
                GroupType=GridLayout }

    { 33  ;2   ;Field     ;
                Name=PostedBalance;
                CaptionML=[DAN=Bogfõrt saldo;
                           ENU=Posted Balance];
                ToolTipML=[DAN=Angiver saldoen for betalinger, der er bogfõrt pÜ den modkonto, der bruges i vinduet Betalingsregistrering.;
                           ENU=Specifies the balance of payments posted to the balancing account that is being used in the Payment Registration window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=PostedBalance;
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                Name=UnpostedBalance;
                CaptionML=[DAN=Ikke-bogfõrt saldo;
                           ENU=Unposted Balance];
                ToolTipML=[DAN=Angiver det belõb, der findes pÜ ikke-bogfõrte kladdelinjer med samme modkonto som den, der bruges i vinduet Betalingsregistrering.;
                           ENU=Specifies the amount that exists on unposted journal lines with the same balancing account as the one used in the Payment Registration window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=UnpostedBalance;
                Editable=FALSE }

    { 35  ;2   ;Field     ;
                Name=TotalBalance;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance];
                ToolTipML=[DAN=Angiver summen af bogfõrte belõb og ikke-bogfõrte kladdelinjebelõb for den modkonto, der bruges pÜ siden Betalingsregistrering. Vërdien i dette felt er summen af vërdierne i felterne Bogfõrt saldo og Ikke-bogfõrt saldo.;
                           ENU=Specifies the sum of posted amounts and unposted journal line amounts for the balancing account that is being used on the Payment Registration page. The value in this field is the sum of values in the Posted Balance and the Unposted Balance fields.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalBalance;
                Importance=Promoted;
                Editable=FALSE }

    { 27  ;1   ;Group      }

    { 26  ;2   ;Group     ;
                GroupType=FixedLayout }

    { 24  ;3   ;Group     ;
                GroupType=Group }

    { 23  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en advarsel om betalingen, f.eks. overskredet forfaldsdato.;
                           ENU=Specifies a warning about the payment, such as past due date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Warning;
                Editable=FALSE;
                Style=Unfavorable;
                StyleExpr=TRUE }

  }
  CODE
  {
    VAR
      PaymentRegistrationMgt@1001 : Codeunit 980;
      BalAccCaption@1002 : Text;
      PmtDiscStyle@1000 : Text;
      DueDateStyle@1004 : Text;
      Warning@1003 : Text;
      PostedBalance@1005 : Decimal;
      UnpostedBalance@1006 : Decimal;
      TotalBalance@1007 : Decimal;

    LOCAL PROCEDURE FormatPageCaption@1();
    VAR
      PaymentRegistrationSetup@1000 : Record 980;
    BEGIN
      PaymentRegistrationSetup.GET(USERID);
      BalAccCaption := FORMAT(PaymentRegistrationSetup."Bal. Account Type") + ' - ' + PaymentRegistrationSetup."Bal. Account No.";
    END;

    LOCAL PROCEDURE SetUserInteractions@2();
    BEGIN
      PmtDiscStyle := GetPmtDiscStyle;
      DueDateStyle := GetDueDateStyle;
      Warning := GetWarning;
    END;

    BEGIN
    END.
  }
}

