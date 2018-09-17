OBJECT Page 438 Issued Reminder
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udstedt rykker;
               ENU=Issued Reminder];
    InsertAllowed=No;
    DeleteAllowed=Yes;
    ModifyAllowed=No;
    SourceTable=Table297;
    PageType=Document;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Rykk&er;
                                 ENU=&Reminder];
                      Image=Reminder }
      { 34      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=Vis alle udstedte rykkere, der findes.;
                                 ENU=View all issued reminders that exist.];
                      ApplicationArea=#Basic,#Suite;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 IssuedReminderHeader.COPY(Rec);
                                 IF PAGE.RUNMODAL(0,IssuedReminderHeader) = ACTION::LookupOK THEN
                                   Rec := IssuedReminderHeader;
                               END;
                                }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 442;
                      RunPageLink=Type=CONST(Issued Reminder),
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
      { 47      ;2   ;Action    ;
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
                      RunObject=Page 441;
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
                      CaptionML=[DAN=Opret elektronisk rykker;
                                 ENU=Create Electronic Reminder];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=CreateElectronicReminder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IssuedReminderHeader := Rec;
                                 IssuedReminderHeader.SETRECFILTER;

                                 REPORT.RUNMODAL(REPORT::"Create Electronic Reminders",TRUE,FALSE,IssuedReminderHeader);
                               END;
                                }
      { 15      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(IssuedReminderHeader);
                                 IssuedReminderHeader.PrintRecords(TRUE,FALSE,FALSE);
                               END;
                                }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Send via &mail;
                                 ENU=Send by &Email];
                      ToolTipML=[DAN=Forbered at afsende bilaget via mail. Vinduet Send mail Übnes med debitorens oplysninger, sÜ du kan tilfõje eller redigere oplysninger, fõr du sender mailen.;
                                 ENU=Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Email;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IssuedReminderHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(IssuedReminderHeader);
                                 IssuedReminderHeader.PrintRecords(FALSE,TRUE,FALSE);
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
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitornummeret for rykkeren.;
                           ENU=Specifies the customer number the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer No." }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the name of the customer the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the address of the customer the reminder is for.];
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
                ToolTipML=[DAN=Angiver bynavnet pÜ den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the city name of the customer the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt kontakter hos den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the name of the person you regularly contact when you communicate with the customer the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 1101100002;2;Field  ;
                ToolTipML=[DAN="Angiver telefonnummeret pÜ kontaktpersonen hos debitoren. ";
                           ENU="Specifies the telephone number of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Phone No." }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN=Angiver faxnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the fax number of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Fax No." }

    { 1101100006;2;Field  ;
                ToolTipML=[DAN=Angiver mailadressen pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the email address of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact E-Mail" }

    { 1101100008;2;Field  ;
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Contact Role" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogfõringsdato, hvor rykkeren blev udstedt.;
                           ENU=Specifies the posting date that the reminder was issued on.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den rykker, hvorfra den udstedte rykker er oprettet.;
                           ENU=Specifies the number of the reminder from which the issued reminder was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pre-Assigned No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rykkerniveauet.;
                           ENU=Specifies the reminder's level.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reminder Level" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Printed" }

    { 29  ;1   ;Part      ;
                Name=ReminderLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Reminder No.=FIELD(No.);
                PagePartID=Page439;
                Editable=FALSE;
                PartType=Page }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Bogfõring;
                           ENU=Posting];
                Editable=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rykkerens rykkerbetingelseskode.;
                           ENU=Specifies the reminder terms code for the reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reminder Terms Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for de involverede renter i tilfëlde af sen betaling.;
                           ENU=Specifies the code for the involved finance charges in case of late payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fin. Charge Terms Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for, hvornÜr belõbet pÜ rykkeren er forfalden til betaling.;
                           ENU=Specifies the date when payment of the amount on the reminder is due.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for den udstedte rykker.;
                           ENU=Specifies the currency code of the issued reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Currency Code";
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

    { 1101100012;2;Field  ;
                ToolTipML=[DAN=Angiver EAN-lokationsnummeret for debitoren.;
                           ENU=Specifies the EAN location number for the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EAN No." }

    { 1101100014;2;Field  ;
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

    { 3   ;1   ;Part      ;
                ApplicationArea=#Advanced;
                SubPageLink=Entry No.=FIELD(Entry No.);
                PagePartID=Page9106;
                ProviderID=29;
                PartType=Page }

    { 1905767507;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      IssuedReminderHeader@1000 : Record 297;
      CurrExchRate@1001 : Record 330;
      ChangeExchangeRate@1002 : Page 511;

    BEGIN
    END.
  }
}

