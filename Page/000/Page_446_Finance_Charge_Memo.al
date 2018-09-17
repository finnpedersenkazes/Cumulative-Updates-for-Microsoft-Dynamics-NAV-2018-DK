OBJECT Page 446 Finance Charge Memo
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rentenota;
               ENU=Finance Charge Memo];
    SourceTable=Table302;
    PageType=Document;
    OnOpenPage=BEGIN
                 SetDocNoVisible;
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
                      CaptionML=[DAN=N&ota;
                                 ENU=&Memo];
                      Image=Notes }
      { 35      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=Vis alle de renter, der findes.;
                                 ENU=View all finance charges that exist.];
                      ApplicationArea=#Basic,#Suite;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 FinChrgMemoHeader.COPY(Rec);
                                 IF PAGE.RUNMODAL(0,FinChrgMemoHeader) = ACTION::LookupOK THEN
                                   Rec := FinChrgMemoHeader;
                               END;
                                }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 454;
                      RunPageLink=Type=CONST(Finance Charge Memo),
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
      { 27      ;2   ;Action    ;
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
                      RunObject=Page 449;
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
      { 24      ;2   ;Action    ;
                      Name=CreateFinanceChargeMemos;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret rentenotaer;
                                 ENU=Create Finance Charge Memos];
                      ToolTipML=[DAN=Opret rentenotaer for en eller flere debitorer med forfaldne betalinger.;
                                 ENU=Create finance charge memos for one or more customers with overdue payments.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=CreateFinanceChargememo;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Create Finance Charge Memos");
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Name=SuggestFinChargeMemoLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=ForeslÜ rentenotalinjer;
                                 ENU=Suggest Fin. Charge Memo Lines];
                      ToolTipML=[DAN=Opret rentenotalinjer i eksisterende rentenotaer for alle forfaldne betalinger, der er baseret pÜ oplysningerne i vinduet Rentenota.;
                                 ENU=Create finance charge memo lines in existing finance charge memos for any overdue payments based on information in the Finance Charge Memo window.];
                      ApplicationArea=#Basic,#Suite;
                      Image=SuggestLines;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(FinChrgMemoHeader);
                                 REPORT.RUNMODAL(REPORT::"Suggest Fin. Charge Memo Lines",TRUE,FALSE,FinChrgMemoHeader);
                               END;
                                }
      { 15      ;2   ;Action    ;
                      Name=UpdateFinChargeText;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opdater rentenotatekst;
                                 ENU=Update Finance Charge Text];
                      ToolTipML=[DAN=Erstat den start- og sluttekst, der er defineret for de relaterede rentebetingelser, med tekst fra andre betingelser.;
                                 ENU=Replace the beginning and ending text that has been defined for the related finance charge terms with those from different terms.];
                      ApplicationArea=#Basic,#Suite;
                      Image=RefreshText;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(FinChrgMemoHeader);
                                 REPORT.RUNMODAL(REPORT::"Update Finance Charge Text",TRUE,FALSE,FinChrgMemoHeader);
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
                      Image=TestReport;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(FinChrgMemoHeader);
                                 FinChrgMemoHeader.PrintRecords;
                               END;
                                }
      { 56      ;2   ;Action    ;
                      Name=Issue;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udsted;
                                 ENU=Issue];
                      ToolTipML=[DAN=Bogfõr de angivne rentenotaposter i overensstemmelse med dine specifikationer i vinduet Rentebetingelser. Denne specifikation bestemmer, om renter og/eller yderligere gebyrer skal bogfõres pÜ debitorens konto og i finansregnskabet.;
                                 ENU=Post the specified finance charge entries according to your specifications in the Finance Charge Terms window. This specification determines whether interest and/or additional fees are posted to the customer's account and the general ledger.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(FinChrgMemoHeader);
                                 REPORT.RUNMODAL(REPORT::"Issue Finance Charge Memos",TRUE,TRUE,FinChrgMemoHeader);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1902355906;1 ;Action    ;
                      CaptionML=[DAN=Rentenotanumre;
                                 ENU=Finance Charge Memo Nos.];
                      ToolTipML=[DAN="Vis eller rediger de rentenotanumre, der er oprettet. ";
                                 ENU="View or edit the finance charge memo numbers that are set up. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 127;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903158706;1 ;Action    ;
                      CaptionML=[DAN=Rentenota;
                                 ENU=Finance Charge Memo];
                      ToolTipML=[DAN=Opret en ny rentenota.;
                                 ENU=Create a new finance charge memo.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 118;
                      Promoted=No;
                      Image=FinChargeMemo;
                      PromotedCategory=Report }
      { 1902299006;1 ;Action    ;
                      CaptionML=[DAN=Debitor - saldo til dato;
                                 ENU=Customer - Balance to Date];
                      ToolTipML=[DAN=Vis en liste over debitorers betalingshistorik op til en bestemt dato. Du kan bruge rapporten til at udtrëkke oplysninger om din samlede salgsindkomst ved slutningen af en regnskabsperiode eller et regnskabsÜr.;
                                 ENU=View a list with customers' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 121;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906871306;1 ;Action    ;
                      CaptionML=[DAN=Debitor - kontokort;
                                 ENU=Customer - Detail Trial Bal.];
                      ToolTipML=[DAN=Vis saldi for debitorer med saldi pÜ en bestemt dato. Rapporten kan f.eks. bruges i slutningen af en regnskabsperiode eller i forbindelse med revision.;
                                 ENU=View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 104;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, der skal oprettes en rentenota til.;
                           ENU=Specifies the number of the customer you want to create a finance charge memo for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer No.";
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, rentenotaen er udstedt til.;
                           ENU=Specifies the name of the customer the finance charge memo is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Importance=Promoted }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, rentenotaen er udstedt til.;
                           ENU=Specifies the address of the customer the finance charge memo is for.];
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
                ToolTipML=[DAN=Angiver navnet pÜ den by, rentenotaen er udstedt til.;
                           ENU=Specifies the city name of the customer the finance charge memo is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt kontakter hos den debitor, rentenotaen er udstedt til.;
                           ENU=Specifies the name of the person you regularly contact when you communicate with the customer the finance charge memo is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN=Angiver telefonnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the telephone number of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Phone No." }

    { 1101100006;2;Field  ;
                ToolTipML=[DAN=Angiver faxnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the fax number of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Fax No." }

    { 1101100008;2;Field  ;
                ToolTipML=[DAN=Angiver mailadressen pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the email address of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact E-Mail" }

    { 1101100010;2;Field  ;
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Role" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, nÜr rentenotaen skal udstedes.;
                           ENU=Specifies the date when the finance charge memo should be issued.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Importance=Promoted }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Assigned User ID" }

    { 29  ;1   ;Part      ;
                Name=FinChrgMemoLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Finance Charge Memo No.=FIELD(No.);
                PagePartID=Page447;
                PartType=Page }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Bogfõring;
                           ENU=Posting] }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for de involverede renter i tilfëlde af sen betaling.;
                           ENU=Specifies the code for the involved finance charges in case of late payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fin. Charge Terms Code";
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr rentenotaen er forfalden til betaling.;
                           ENU=Specifies when payment of the amount on the finance charge memo is due.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for rentenotaen.;
                           ENU=Specifies the currency code of the finance charge memo.];
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

    { 1101100002;2;Field  ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code";
                OnValidate=BEGIN
                             AccountCodeOnAfterValidate;
                           END;
                            }

    { 1101100012;2;Field  ;
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

    { 1905767507;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      FinChrgMemoHeader@1000 : Record 302;
      CurrExchRate@1001 : Record 330;
      ChangeExchangeRate@1002 : Page 511;
      DocNoVisible@1003 : Boolean;

    LOCAL PROCEDURE AccountCodeOnAfterValidate@19007267();
    BEGIN
      CurrPage.FinChrgMemoLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
      DocType@1003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::FinChMemo,"No.");
    END;

    BEGIN
    END.
  }
}

