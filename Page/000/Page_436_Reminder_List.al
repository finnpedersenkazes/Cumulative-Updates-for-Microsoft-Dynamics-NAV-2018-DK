OBJECT Page 436 Reminder List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rykkeroversigt;
               ENU=Reminder List];
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table295;
    PageType=List;
    CardPageID=Reminder;
    OnDeleteRecord=BEGIN
                     EXIT(ConfirmDeletion);
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Rykk&er;
                                 ENU=&Reminder];
                      Image=Reminder }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 442;
                      RunPageLink=Type=CONST(Reminder),
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
                      RunObject=Page 437;
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
      { 20      ;2   ;Action    ;
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
      { 26      ;2   ;Action    ;
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
      { 11      ;2   ;Action    ;
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
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dstedelse;
                                 ENU=&Issuing];
                      Image=Add }
      { 28      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=FÜ vist en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=TestReport;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ReminderHeader);
                                 ReminderHeader.PrintRecords;
                               END;
                                }
      { 29      ;2   ;Action    ;
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
                                 CurrPage.UPDATE(FALSE);
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
      { 1905203206;1 ;Action    ;
                      CaptionML=[DAN=Rykker - kontrol;
                                 ENU=Reminder Test];
                      ToolTipML=[DAN=Vis rykkerteksten, fõr du udsteder rykkeren og sender den til debitoren.;
                                 ENU=Preview the reminder text before you issue the reminder and send it to the customer.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ReminderHeader);
                                 REPORT.RUNMODAL(REPORT::"Reminder - Test",TRUE,TRUE,ReminderHeader);
                               END;
                                }
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
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, hvortil rykkeren skal bogfõres.;
                           ENU=Specifies the number of the customer you want to post a reminder for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the name of the customer the reminder is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for rykkeren.;
                           ENU=Specifies the currency code of the reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Currency Code" }

    { 40  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver det totale restbelõb pÜ rykkerlinjerne.;
                           ENU=Specifies the total of the remaining amounts on the reminder lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bynavnet pÜ den debitor, rykkeren er udstedt til.;
                           ENU=Specifies the city name of the customer the reminder is for.];
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

    { 27  ;2   ;Field     ;
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
      ReminderHeader@1000 : Record 295;

    [Internal]
    PROCEDURE GetSelectionFilter@3() : Text;
    VAR
      ReminderHeader@1001 : Record 295;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(ReminderHeader);
      EXIT(SelectionFilterManagement.GetSelectionFilterForIssueReminder(ReminderHeader));
    END;

    BEGIN
    END.
  }
}

