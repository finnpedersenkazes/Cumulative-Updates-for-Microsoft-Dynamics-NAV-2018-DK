OBJECT Page 450 Issued Finance Charge Memo
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Udstedt rentenota;
               ENU=Issued Finance Charge Memo];
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table304;
    PageType=Document;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=N&ota;
                                 ENU=&Memo];
                      Image=Notes }
      { 34      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=Vis alle de udstedte renter, der findes.;
                                 ENU=View all issued finance charges that exist.];
                      ApplicationArea=#Basic,#Suite;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 IssuedFinChrgMemoHeader.COPY(Rec);
                                 IF PAGE.RUNMODAL(0,IssuedFinChrgMemoHeader) = ACTION::LookupOK THEN
                                   Rec := IssuedFinChrgMemoHeader;
                               END;
                                }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 454;
                      RunPageLink=Type=CONST(Issued Finance Charge Memo),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=D&ebitor;
                                 ENU=C&ustomer];
                      ToolTipML=[DAN="èbn kortet for den debitor, som rykkeren eller renten vedrõrer. ";
                                 ENU="Open the card of the customer that the reminder or finance charge applies to. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 22;
                      RunPageLink=No.=FIELD(Customer No.);
                      Image=Customer }
      { 26      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 6       ;2   ;Separator  }
      { 7       ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 453;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1101100000;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1101100001;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret elektronisk rentenota;
                                 ENU=Create Electronic Finance Charge Memo];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ElectronicDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IssuedFinChrgMemoHeader := Rec;
                                 IssuedFinChrgMemoHeader.SETRECFILTER;

                                 REPORT.RUNMODAL(REPORT::"Create Elec. Fin. Chrg. Memos",TRUE,FALSE,IssuedFinChrgMemoHeader);
                               END;
                                }
      { 15      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(IssuedFinChrgMemoHeader);
                                 IssuedFinChrgMemoHeader.PrintRecords(TRUE,FALSE,FALSE);
                               END;
                                }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Send via &mail;
                                 ENU=Send by &Email];
                      ToolTipML=[DAN=Forbered at afsende bilaget via mail. Vinduet Send mail Übnes med debitorens oplysninger, sÜ du kan tilfõje eller redigere oplysninger, fõr du sender mailen.;
                                 ENU=Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Email;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IssuedFinChrgMemoHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(IssuedFinChrgMemoHeader);
                                 IssuedFinChrgMemoHeader.PrintRecords(FALSE,TRUE,FALSE);
                               END;
                                }
      { 30      ;1   ;Action    ;
                      CaptionML=[DAN=N&aviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
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
                      Promoted=Yes;
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Importance=Promoted }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det debitornummer, som rentenotaen er udstedt til.;
                           ENU=Specifies the customer number the finance charge memo is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer No.";
                Importance=Promoted }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, rentenotaen er udstedt til.;
                           ENU=Specifies the name of the customer the finance charge memo is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Importance=Promoted }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, rentenotaen er udstedt til.;
                           ENU=Specifies the address of the customer the finance charge memo is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den by, rentenotaen er udstedt til.;
                           ENU=Specifies the city name of the customer the finance charge memo is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt kontakter hos den debitor, rentenotaen er udstedt til.;
                           ENU=Specifies the name of the person you regularly contact when you communicate with the customer the finance charge memo is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 1101100002;2;Field  ;
                ToolTipML=[DAN=Angiver rollen for telefonnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the telephone number role of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Phone No." }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN="Angiver faxnummeret pÜ kontaktpersonen hos debitoren. ";
                           ENU="Specifies the fax number of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Fax No." }

    { 1101100006;2;Field  ;
                ToolTipML=[DAN="Angiver mailadressen pÜ kontaktpersonen hos debitoren. ";
                           ENU="Specifies the email address of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact E-Mail" }

    { 1101100008;2;Field  ;
                ToolTipML=[DAN="Angiver rollen for kontaktpersonen hos debitoren. ";
                           ENU="Specifies the role of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Role" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogfõringsdato, hvor rentenotaen blev udstedt.;
                           ENU=Specifies the posting date that the finance charge memo was issued on.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Importance=Promoted }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ rentenotaen.;
                           ENU=Specifies the number of the finance charge memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pre-Assigned No." }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Printed" }

    { 29  ;1   ;Part      ;
                Name=FinChrgMemoLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Finance Charge Memo No.=FIELD(No.);
                PagePartID=Page451;
                PartType=Page }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Bogfõring;
                           ENU=Posting] }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for de involverede renter i tilfëlde af sen betaling.;
                           ENU=Specifies the code for the involved finance charges in case of late payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fin. Charge Terms Code";
                Importance=Promoted }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for, hvornÜr rentenotaen er forfalden til betaling.;
                           ENU=Specifies the date when payment of the finance charge memo is due.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den valuta, den udstedte rentenota er udstedt i.;
                           ENU=Specifies the code of the currency that the issued finance charge memo is in.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               ChangeExchangeRate.SetParameter(
                                 "Currency Code",
                                 CurrExchRate.ExchangeRate("Posting Date","Currency Code"),
                                 "Posting Date");
                               ChangeExchangeRate.EDITABLE(FALSE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 1101100010;2;Field  ;
                ToolTipML=[DAN="Angiver EAN-lokationsnummeret for debitoren. ";
                           ENU="Specifies the EAN location number for the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EAN No." }

    { 1101100012;2;Field  ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code" }

    { 1101100016;2;Field  ;
                ToolTipML=[DAN=Angiver betalingsmetoden Offentlig Information Online UBL (OIOUBL) for bilaget.;
                           ENU=Specifies the Offentlig Information Online UBL (OIOUBL) payment method for the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Channel" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 57  ;2   ;Field     ;
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
      IssuedFinChrgMemoHeader@1000 : Record 304;
      CurrExchRate@1001 : Record 330;
      ChangeExchangeRate@1002 : Page 511;

    BEGIN
    END.
  }
}

