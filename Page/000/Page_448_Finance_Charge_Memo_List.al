OBJECT Page 448 Finance Charge Memo List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rentenotaliste;
               ENU=Finance Charge Memo List];
    InsertAllowed=No;
    SourceTable=Table302;
    PageType=List;
    CardPageID=Finance Charge Memo;
    RefreshOnActivate=Yes;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=N&ota;
                                 ENU=&Memo];
                      Image=Notes }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 454;
                      RunPageLink=Type=CONST(Finance Charge Memo),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=&Debitor;
                                 ENU=C&ustomer];
                      ToolTipML=[DAN="èbn kortet for den debitor, som rykkeren eller renten vedrõrer. ";
                                 ENU="Open the card of the customer that the reminder or finance charge applies to. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 22;
                      RunPageLink=No.=FIELD(Customer No.);
                      Image=Customer }
      { 8       ;2   ;Separator  }
      { 9       ;2   ;Action    ;
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
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 21      ;2   ;Action    ;
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
      { 26      ;2   ;Action    ;
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
                                 FinChrgMemoHeader.RESET;
                               END;
                                }
      { 20      ;2   ;Action    ;
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
                                 FinChrgMemoHeader.RESET;
                               END;
                                }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dstedelse;
                                 ENU=&Issuing];
                      Image=Add }
      { 28      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=FÜ vist en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=TestReport;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(FinChrgMemoHeader);
                                 FinChrgMemoHeader.PrintRecords;
                                 FinChrgMemoHeader.RESET;
                               END;
                                }
      { 29      ;2   ;Action    ;
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
                                 FinChrgMemoHeader.RESET;
                                 CurrPage.UPDATE(FALSE);
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
      { 1900427306;1 ;Action    ;
                      CaptionML=[DAN=Rentenota - kontrol;
                                 ENU=Finance Charge Memo Test];
                      ToolTipML=[DAN=Vis rentenotateksten, fõr du udsteder rentenotaen og sender den til debitoren.;
                                 ENU=Preview the finance charge text before you issue the finance charge memo and send it to the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 123;
                      Promoted=Yes;
                      Image=Report;
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, der skal oprettes en rentenota til.;
                           ENU=Specifies the number of the customer you want to create a finance charge memo for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, rentenotaen er udstedt til.;
                           ENU=Specifies the name of the customer the finance charge memo is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for rentenotaen.;
                           ENU=Specifies the currency code of the finance charge memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Currency Code" }

    { 11  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver det totale rentebelõb pÜ rentenotalinjerne.;
                           ENU=Specifies the total of the interest amounts on the finance charge memo lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Interest Amount" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den by, rentenotaen er udstedt til.;
                           ENU=Specifies the city name of the customer the finance charge memo is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City;
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE;
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE;
                Editable=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Assigned User ID" }

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

    BEGIN
    END.
  }
}

