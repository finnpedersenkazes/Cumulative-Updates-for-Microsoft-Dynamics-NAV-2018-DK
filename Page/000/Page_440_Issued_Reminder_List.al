OBJECT Page 440 Issued Reminder List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udstedt rykker - oversigt;
               ENU=Issued Reminder List];
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table297;
    DataCaptionFields=Customer No.;
    PageType=List;
    CardPageID=Issued Reminder;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=Rykk&er;
                                 ENU=&Reminder];
                      Image=Reminder }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 442;
                      RunPageLink=Type=CONST(Issued Reminder),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=&Debitor;
                                 ENU=C&ustomer];
                      ToolTipML=[DAN="�bn kortet for den debitor, som rykkeren eller renten vedr�rer. ";
                                 ENU="Open the card of the customer that the reminder or finance charge applies to. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 22;
                      RunPageLink=No.=FIELD(Customer No.);
                      Image=Customer }
      { 27      ;2   ;Separator  }
      { 28      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om recorden, f.eks. v�rdien af bogf�rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 441;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 16      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du f�r vist anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 IssuedReminderHeader@1001 : Record 297;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(IssuedReminderHeader);
                                 IssuedReminderHeader.PrintRecords(TRUE,FALSE,FALSE);
                               END;
                                }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Send via &mail;
                                 ENU=Send by &Email];
                      ToolTipML=[DAN=Forbered at afsende bilaget via mail. Vinduet Send mail �bnes med debitorens oplysninger, s� du kan tilf�je eller redigere oplysninger, f�r du sender mailen.;
                                 ENU=Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Email;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 IssuedReminderHeader@1000 : Record 297;
                                 IssuedReminderHeader2@1001 : Record 297;
                                 PrevCustomerNo@1002 : Code[20];
                               BEGIN
                                 IssuedReminderHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(IssuedReminderHeader);
                                 CurrPage.SETSELECTIONFILTER(IssuedReminderHeader2);
                                 IssuedReminderHeader.SETCURRENTKEY("Customer No.");
                                 IF IssuedReminderHeader.FINDSET THEN
                                   REPEAT
                                     IF IssuedReminderHeader."Customer No." <> PrevCustomerNo THEN BEGIN
                                       IssuedReminderHeader2.SETRANGE("Customer No.",IssuedReminderHeader."Customer No.");
                                       IssuedReminderHeader2.PrintRecords(FALSE,TRUE,FALSE);
                                     END;
                                     PrevCustomerNo := IssuedReminderHeader."Customer No.";
                                   UNTIL IssuedReminderHeader.NEXT = 0;
                               END;
                                }
      { 55      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf�ringsdatoen p� den valgte post eller det valgte bilag.;
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
      { 1904202406;1 ;Action    ;
                      CaptionML=[DAN=Rykkernumre;
                                 ENU=Reminder Nos.];
                      ToolTipML=[DAN="Vis eller rediger de rykkernumre, der er oprettet. ";
                                 ENU="View or edit the reminder numbers that are set up. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 126;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902299006;1 ;Action    ;
                      CaptionML=[DAN=Debitor - saldo til dato;
                                 ENU=Customer - Balance to Date];
                      ToolTipML=[DAN=Vis en liste over debitorers betalingshistorik op til en bestemt dato. Du kan bruge rapporten til at udtr�kke oplysninger om din samlede salgsindkomst ved slutningen af en regnskabsperiode eller et regnskabs�r.;
                                 ENU=View a list with customers' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 121;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906871306;1 ;Action    ;
                      CaptionML=[DAN=Debitor - kontokort;
                                 ENU=Customer - Detail Trial Bal.];
                      ToolTipML=[DAN=Vis saldi for debitorer med saldi p� en bestemt dato. Rapporten kan f.eks. bruges i slutningen af en regnskabsperiode eller i forbindelse med revision.;
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitornummeret for rykkeren.;
                           ENU=Specifies the customer number the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the name of the customer the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for den udstedte rykker.;
                           ENU=Specifies the currency code of the issued reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Currency Code" }

    { 21  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver det totale restbel�b p� rykkerlinjerne.;
                           ENU=Specifies the total of the remaining amounts on the reminder lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Printed";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bynavnet p� den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the city name of the customer the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City;
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

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

    BEGIN
    END.
  }
}

