OBJECT Page 5237 Employee Ledger Entries
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 5222=m;
    CaptionML=[DAN=Medarbejderposter;
               ENU=Employee Ledger Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5222;
    PageType=List;
    ActionList=ACTIONS
    {
      { 22      ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Udlignede &poster;
                                 ENU=Applied E&ntries];
                      ToolTipML=[DAN=Se finansposter, der er godkendt for denne record.;
                                 ENU=View the ledger entries that have been applied to this record.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 63;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Process;
                      Scope=Repeater }
      { 17      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#BasicHR;
                      Image=Dimensions;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 15      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Detaljerede p&oster;
                                 ENU=Detailed &Ledger Entries];
                      ToolTipML=[DAN=Se en oversigt over alle bogf›rte poster og reguleringer relateret til en bestemt medarbejderpost;
                                 ENU=View a summary of the all posted entries and adjustments related to a specific employee ledger entry];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5238;
                      RunPageView=SORTING(Employee Ledger Entry No.,Posting Date);
                      RunPageLink=Employee Ledger Entry No.=FIELD(Entry No.),
                                  Employee No.=FIELD(Employee No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      Scope=Repeater }
      { 30      ;2   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og dokumenter, der findes for dokumentnummeret og bogf›ringsdatoen p† den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#BasicHR;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Navigate@1000 : Page 344;
                               BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
                               END;
                                }
      { 14      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Funk&tioner;
                                 ENU=F&unctions];
                      Image=Action }
      { 12      ;2   ;Action    ;
                      Name=ActionApplyEntries;
                      ShortCutKey=Shift+F11;
                      CaptionML=[DAN=Udlign poster;
                                 ENU=Apply Entries];
                      ToolTipML=[DAN=V‘lg en eller flere finansposter, denne record skal anvendes p†, s† de relaterede, bogf›rte dokumenter lukkes som betalte eller refunderede.;
                                 ENU=Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.];
                      ApplicationArea=#BasicHR;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ApplyEntries;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=VAR
                                 EmployeeLedgerEntry@1001 : Record 5222;
                                 EmplEntryApplyPostedEntries@1000 : Codeunit 224;
                               BEGIN
                                 EmployeeLedgerEntry.COPY(Rec);
                                 EmplEntryApplyPostedEntries.ApplyEmplEntryFormEntry(EmployeeLedgerEntry);
                                 Rec := EmployeeLedgerEntry;
                                 GET("Entry No.");
                                 CurrPage.UPDATE;
                               END;
                                }
      { 9       ;2   ;Separator  }
      { 8       ;2   ;Action    ;
                      Name=UnapplyEntries;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Annuller udligning;
                                 ENU=Unapply Entries];
                      ToolTipML=[DAN=Frav‘lg en eller flere finansposter, der ikke skal udlignes p† denne record.;
                                 ENU=Unselect one or more ledger entries that you want to unapply this record.];
                      ApplicationArea=#BasicHR;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=UnApply;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=VAR
                                 EmplEntryApplyPostedEntries@1000 : Codeunit 224;
                               BEGIN
                                 EmplEntryApplyPostedEntries.UnApplyEmplLedgEntry("Entry No.");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderpostens bogf›ringsdato.;
                           ENU=Specifies the employee entry's posting date.];
                ApplicationArea=#BasicHR;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken dokumenttype medarbejderposten tilh›rer.;
                           ENU=Specifies the document type that the employee entry belongs to.];
                ApplicationArea=#BasicHR;
                SourceExpr="Document Type";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderpostens bilagsnummer.;
                           ENU=Specifies the employee entry's document number.];
                ApplicationArea=#BasicHR;
                SourceExpr="Document No.";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den medarbejder, som posten er tilknyttet.;
                           ENU=Specifies the number of the employee that the entry is linked to.];
                ApplicationArea=#BasicHR;
                SourceExpr="Employee No.";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den meddelelse, der eksporteres til betalingsfilen, n†r du bruger funktionen Eksport‚r betalinger til fil i vinduet Udbetalingskladde.;
                           ENU=Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.];
                ApplicationArea=#BasicHR;
                SourceExpr="Message to Recipient" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af medarbejderposten.;
                           ENU=Specifies a description of the employee entry.];
                ApplicationArea=#BasicHR;
                SourceExpr=Description;
                Editable=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den betalingsform, der blev brugt til at foretage betalingen, der resulterede i posten.;
                           ENU=Specifies the payment method that was used to make the payment that resulted in the entry.];
                ApplicationArea=#BasicHR;
                SourceExpr="Payment Method Code" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for den oprindelige post.;
                           ENU=Specifies the amount of the original entry.];
                ApplicationArea=#BasicHR;
                SourceExpr="Original Amount" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, posten oprindeligt bestod af, i RV.;
                           ENU=Specifies the amount that the entry originally consisted of, in LCY.];
                ApplicationArea=#BasicHR;
                SourceExpr="Original Amt. (LCY)";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten.;
                           ENU=Specifies the amount of the entry.];
                ApplicationArea=#BasicHR;
                SourceExpr=Amount }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten i regnskabsvalutaen.;
                           ENU=Specifies the amount of the entry in LCY.];
                ApplicationArea=#BasicHR;
                SourceExpr="Amount (LCY)";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som mangler at blive udlignet, inden posten udlignes fuldst‘ndigt.;
                           ENU=Specifies the amount that remains to be applied to before the entry is totally applied to.];
                ApplicationArea=#BasicHR;
                SourceExpr="Remaining Amount" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som mangler at blive udlignet, inden posten udlignes fuldst‘ndigt.;
                           ENU=Specifies the amount that remains to be applied to before the entry is totally applied to.];
                ApplicationArea=#BasicHR;
                SourceExpr="Remaining Amt. (LCY)" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type modkonto der benyttes til posten.;
                           ENU=Specifies the type of balancing account that is used for the entry.];
                ApplicationArea=#BasicHR;
                SourceExpr="Bal. Account Type";
                Visible=FALSE;
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den modkonto, der er brugt til posten.;
                           ENU=Specifies the number of the balancing account that is used for the entry.];
                ApplicationArea=#BasicHR;
                SourceExpr="Bal. Account No.";
                Visible=FALSE;
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er helt afregnet, eller om der stadig mangler at blive udlignet et bel›b.;
                           ENU=Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.];
                ApplicationArea=#BasicHR;
                SourceExpr=Open;
                Editable=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, der skal udlignes.;
                           ENU=Specifies the amount to apply.];
                ApplicationArea=#BasicHR;
                SourceExpr="Amount to Apply";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, n†r du v‘lger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#BasicHR;
                SourceExpr="Applies-to ID";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten skal udlignes, n†r du v‘lger handlingen Udlign poster.;
                           ENU=Specifies whether the entry will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#BasicHR;
                SourceExpr="Applying Entry";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at posten blev oprettet ved eksport af en betalingskladdelinje.;
                           ENU=Specifies that the entry was created as a result of exporting a payment journal line.];
                ApplicationArea=#BasicHR;
                SourceExpr="Exported to Payment File";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kreditor, som har sendt medarbejderbilaget.;
                           ENU=Specifies the creditor who sent the employee document.];
                ApplicationArea=#BasicHR;
                SourceExpr="Creditor No.";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingen af medarbejderbilaget.;
                           ENU=Specifies the payment of the employee document.];
                ApplicationArea=#BasicHR;
                SourceExpr="Payment Reference";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det l›benummer, der tildeles posten.;
                           ENU=Specifies the entry number that is assigned to the entry.];
                ApplicationArea=#BasicHR;
                SourceExpr="Entry No.";
                Editable=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

