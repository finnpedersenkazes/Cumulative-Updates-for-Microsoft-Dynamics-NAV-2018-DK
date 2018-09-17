OBJECT Page 232 Apply Customer Entries
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udlign debitorposter;
               ENU=Apply Customer Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table21;
    DataCaptionFields=Customer No.;
    PageType=Worksheet;
    OnInit=BEGIN
             AppliesToIDVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 IF CalcType = CalcType::Direct THEN BEGIN
                   Cust.GET("Customer No.");
                   ApplnCurrencyCode := Cust."Currency Code";
                   FindApplyingEntry;
                 END;

                 AppliesToIDVisible := ApplnType <> ApplnType::"Applies-to Doc. No.";

                 GLSetup.GET;

                 IF ApplnType = ApplnType::"Applies-to Doc. No." THEN
                   CalcApplnAmount;
                 PostingDone := FALSE;
               END;

    OnAfterGetRecord=BEGIN
                       StyleTxt := SetStyle;
                     END;

    OnModifyRecord=BEGIN
                     CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
                     IF "Applies-to ID" <> xRec."Applies-to ID" THEN
                       CalcApplnAmount;
                     EXIT(FALSE);
                   END;

    OnQueryClosePage=BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                         LookupOKOnPush;
                       IF ApplnType = ApplnType::"Applies-to Doc. No." THEN BEGIN
                         IF OK AND (ApplyingCustLedgEntry."Posting Date" < "Posting Date") THEN BEGIN
                           OK := FALSE;
                           ERROR(
                             EarlierPostingDateErr,ApplyingCustLedgEntry."Document Type",ApplyingCustLedgEntry."Document No.",
                             "Document Type","Document No.");
                         END;
                         IF OK THEN BEGIN
                           IF "Amount to Apply" = 0 THEN
                             "Amount to Apply" := "Remaining Amount";
                           CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
                         END;
                       END;
                       IF (CalcType = CalcType::Direct) AND NOT OK AND NOT PostingDone THEN BEGIN
                         Rec := ApplyingCustLedgEntry;
                         "Applying Entry" := FALSE;
                         "Applies-to ID" := '';
                         "Amount to Apply" := 0;
                         CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
                       END;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           IF ApplnType = ApplnType::"Applies-to Doc. No." THEN
                             CalcApplnAmount;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Rykker-/rentenotaposter;
                                 ENU=Reminder/Fin. Charge Entries];
                      ToolTipML=[DAN=Se de rykkere og rentenotaposter, du har angivet for debitoren.;
                                 ENU=View the reminders and finance charge entries that you have entered for the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 444;
                      RunPageView=SORTING(Customer Entry No.);
                      RunPageLink=Customer Entry No.=FIELD(Entry No.);
                      Image=Reminder }
      { 95      ;2   ;Action    ;
                      CaptionML=[DAN=Udlignede &poster;
                                 ENU=Applied E&ntries];
                      ToolTipML=[DAN=Se finansposter, der er godkendt for denne record.;
                                 ENU=View the ledger entries that have been applied to this record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 61;
                      RunPageOnRec=Yes;
                      Image=Approve }
      { 53      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 62      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Detaljerede p&oster;
                                 ENU=Detailed &Ledger Entries];
                      ToolTipML=[DAN=Se en oversigt over alle bogf›rte poster og reguleringer relateret til en bestemt debitorpost.;
                                 ENU=View a summary of the all posted entries and adjustments related to a specific customer ledger entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 573;
                      RunPageView=SORTING(Cust. Ledger Entry No.,Posting Date);
                      RunPageLink=Cust. Ledger Entry No.=FIELD(Entry No.);
                      Image=View }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Navigate;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dligning;
                                 ENU=&Application];
                      Image=Apply }
      { 11      ;2   ;Action    ;
                      Name=Set Applies-to ID;
                      ShortCutKey=Shift+F11;
                      CaptionML=[DAN=S‘t udlignings-id;
                                 ENU=Set Applies-to ID];
                      ToolTipML=[DAN=Indstil feltet Udlignings-id p† den bogf›rte post til automatisk at blive udfyldt med bilagsnummeret fra posten i kladden.;
                                 ENU=Set the Applies-to ID field on the posted entry to automatically be filled in with the document number of the entry in the journal.];
                      ApplicationArea=#Basic,#Suite;
                      Image=SelectLineToApply;
                      OnAction=BEGIN
                                 IF (CalcType = CalcType::GenJnlLine) AND (ApplnType = ApplnType::"Applies-to Doc. No.") THEN
                                   ERROR(CannotSetAppliesToIDErr);

                                 SetCustApplId;
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=Post Application;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r udligning;
                                 ENU=Post Application];
                      ToolTipML=[DAN=Definer bilagsnummeret for den post, der skal bruges til udligningen. Desuden skal du angive bogf›ringsdatoen for udligningen.;
                                 ENU=Define the document number of the ledger entry to use to perform the application. In addition, you specify the Posting Date for the application.];
                      ApplicationArea=#Basic,#Suite;
                      Image=PostApplication;
                      OnAction=BEGIN
                                 PostDirectApplication(FALSE);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      OnAction=BEGIN
                                 PostDirectApplication(TRUE);
                               END;
                                }
      { 5       ;2   ;Separator ;
                      CaptionML=[DAN=-;
                                 ENU=-] }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Vis kun de valgte poster, der skal udlignes;
                                 ENU=Show Only Selected Entries to Be Applied];
                      ToolTipML=[DAN=Se de valgte finansposter, der udlignes med den angivne record.;
                                 ENU=View the selected ledger entries that will be applied to the specified record.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ShowSelected;
                      OnAction=BEGIN
                                 ShowAppliedEntries := NOT ShowAppliedEntries;
                                 IF ShowAppliedEntries THEN
                                   IF CalcType = CalcType::GenJnlLine THEN
                                     SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID")
                                   ELSE BEGIN
                                     CustEntryApplID := USERID;
                                     IF CustEntryApplID = '' THEN
                                       CustEntryApplID := '***';
                                     SETRANGE("Applies-to ID",CustEntryApplID);
                                   END
                                 ELSE
                                   SETRANGE("Applies-to ID");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 70  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 73  ;2   ;Field     ;
                CaptionML=[DAN=Bogf›ringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for den post, der skal udlignes.;
                           ENU=Specifies the posting date of the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingCustLedgEntry."Posting Date";
                Editable=FALSE }

    { 75  ;2   ;Field     ;
                CaptionML=[DAN=Bilagstype;
                           ENU=Document Type];
                ToolTipML=[DAN=Angiver dokumenttypen for den post, der skal udlignes.;
                           ENU=Specifies the document type of the entry to be applied.];
                OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                 ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingCustLedgEntry."Document Type";
                Editable=FALSE }

    { 77  ;2   ;Field     ;
                CaptionML=[DAN=Bilagsnr.;
                           ENU=Document No.];
                ToolTipML=[DAN=Angiver bilagsnummeret for den post, der skal udlignes.;
                           ENU=Specifies the document number of the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingCustLedgEntry."Document No.";
                Editable=FALSE }

    { 71  ;2   ;Field     ;
                Name=ApplyingCustomerNo;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver debitornummeret for den post, der skal udlignes.;
                           ENU=Specifies the customer number of the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingCustLedgEntry."Customer No.";
                Visible=FALSE;
                Editable=FALSE }

    { 85  ;2   ;Field     ;
                Name=ApplyingDescription;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver en beskrivelse af den post, der skal udlignes.;
                           ENU=Specifies the description of the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingCustLedgEntry.Description;
                Visible=FALSE;
                Editable=FALSE }

    { 79  ;2   ;Field     ;
                CaptionML=[DAN=Valutakode;
                           ENU=Currency Code];
                ToolTipML=[DAN=Angiver koden for den valuta, som bel›bene vises i.;
                           ENU=Specifies the code for the currency that amounts are shown in.];
                ApplicationArea=#Suite;
                SourceExpr=ApplyingCustLedgEntry."Currency Code";
                Editable=FALSE }

    { 81  ;2   ;Field     ;
                CaptionML=[DAN=Bel›b;
                           ENU=Amount];
                ToolTipML=[DAN=Angiver bel›bet i den post, der skal udlignes.;
                           ENU=Specifies the amount on the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingCustLedgEntry.Amount;
                Editable=FALSE }

    { 83  ;2   ;Field     ;
                CaptionML=[DAN=Restbel›b;
                           ENU=Remaining Amount];
                ToolTipML=[DAN=Angiver bel›bet i den post, der skal udlignes.;
                           ENU=Specifies the amount on the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingCustLedgEntry."Remaining Amount";
                Editable=FALSE }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 22  ;2   ;Field     ;
                Name=AppliesToID;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, n†r du v‘lger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#All;
                SourceExpr="Applies-to ID";
                Visible=AppliesToIDVisible;
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE);
                           END;
                            }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorpostens bogf›ringsdato.;
                           ENU=Specifies the customer entry's posting date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken bilagstype debitorposten tilh›rer.;
                           ENU=Specifies the document type that the customer entry belongs to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type";
                Editable=FALSE;
                StyleExpr=StyleTxt }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bilagsnummer.;
                           ENU=Specifies the entry's document number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                Editable=FALSE;
                StyleExpr=StyleTxt }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitorkonto som posten er tilknyttet.;
                           ENU=Specifies the customer account number that the entry is linked to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer No.";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af debitorposten.;
                           ENU=Specifies a description of the customer entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Editable=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel›bet p† linjen.;
                           ENU=Specifies the currency code for the amount on the line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for den oprindelige post.;
                           ENU=Specifies the amount of the original entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Original Amount";
                Visible=FALSE;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten.;
                           ENU=Specifies the amount of the entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Amount;
                Visible=FALSE;
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som mangler at blive udlignet, f›r posten er helt udlignet.;
                           ENU=Specifies the amount that remains to be applied to before the entry has been completely applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount";
                Editable=FALSE }

    { 33  ;2   ;Field     ;
                CaptionML=[DAN=Udlign. restbel›b;
                           ENU=Appln. Remaining Amount];
                ToolTipML=[DAN=Angiver det bel›b, som mangler at blive udlignet, inden posten udlignes fuldst‘ndigt.;
                           ENU=Specifies the amount that remains to be applied to before the entry is totally applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcApplnRemainingAmount("Remaining Amount");
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, der skal udlignes.;
                           ENU=Specifies the amount to apply.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount to Apply";
                OnValidate=BEGIN
                             CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);

                             IF (xRec."Amount to Apply" = 0) OR ("Amount to Apply" = 0) AND
                                ((ApplnType = ApplnType::"Applies-to ID") OR (CalcType = CalcType::Direct))
                             THEN
                               SetCustApplId;
                             GET("Entry No.");
                             AmounttoApplyOnAfterValidate;
                           END;
                            }

    { 93  ;2   ;Field     ;
                CaptionML=[DAN=Bel›b til udligning;
                           ENU=Appln. Amount to Apply];
                ToolTipML=[DAN=Angiver det bel›b, der skal udlignes.;
                           ENU=Specifies the amount to apply.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcApplnAmounttoApply("Amount to Apply");
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens forfaldsdato.;
                           ENU=Specifies the due date on the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                StyleExpr=StyleTxt }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bel›bet i posten skal v‘re betalt, for at der kan opn†s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Discount Date";
                OnValidate=BEGIN
                             RecalcApplnAmount;
                           END;
                            }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste dato, hvor bel›bet i posten skal v‘re betalt, for at der kan opn†s kontantrabattolerance.;
                           ENU=Specifies the last date the amount in the entry must be paid in order for a payment discount tolerance to be granted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Disc. Tolerance Date" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabat, som debitoren kan opn†, hvis posten bliver udlignet inden kontantrabatdatoen.;
                           ENU=Specifies the discount that the customer can obtain if the entry is applied to before the payment discount date.];
                ApplicationArea=#Advanced;
                SourceExpr="Original Pmt. Disc. Possible";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tilbagev‘rende kontantrabat, som kan opn†s, hvis betalingen finder sted inden forfaldsdatoen for kontantrabatten.;
                           ENU=Specifies the remaining payment discount which can be received if the payment is made before the payment discount date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Pmt. Disc. Possible";
                OnValidate=BEGIN
                             RecalcApplnAmount;
                           END;
                            }

    { 51  ;2   ;Field     ;
                CaptionML=[DAN=Udlign. mulig kontantrabat;
                           ENU=Appln. Pmt. Disc. Possible];
                ToolTipML=[DAN=Angiver den rabat, som debitoren kan opn†, hvis posten bliver udlignet inden kontantrabatdatoen.;
                           ENU=Specifies the discount that the customer can obtain if the entry is applied to before the payment discount date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcApplnRemainingAmount("Remaining Pmt. Disc. Possible");
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimalt tilladte bel›b, som posten kan afvige fra det bel›b, der er angivet p† fakturaen eller kreditnotaen.;
                           ENU=Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Max. Payment Tolerance" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er helt afregnet, eller om der stadig mangler at blive udlignet et bel›b.;
                           ENU=Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Open;
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den post, der skal udlignes, er et positivt tal.;
                           ENU=Specifies if the entry to be applied is positive.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Positive;
                Editable=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code" }

    { 41  ;1   ;Group      }

    { 1903222401;2;Group  ;
                GroupType=FixedLayout }

    { 1901742001;3;Group  ;
                CaptionML=[DAN=Udligningsvaluta;
                           ENU=Appln. Currency] }

    { 48  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, som bel›bet udlignes i i forbindelse med forskellige valutaer.;
                           ENU=Specifies the currency code that the amount will be applied in, in case of different currencies.];
                ApplicationArea=#Suite;
                SourceExpr=ApplnCurrencyCode;
                TableRelation=Currency;
                Editable=FALSE;
                ShowCaption=No }

    { 1903098801;3;Group  ;
                CaptionML=[DAN=Bel›b, der skal udlignes;
                           ENU=Amount to Apply] }

    { 44  ;4   ;Field     ;
                Name=AmountToApply;
                CaptionML=[DAN=Bel›b, der skal udlignes;
                           ENU=Amount to Apply];
                ToolTipML=[DAN=Angiver summen af bel›bene p† alle de valgte debitorposter, der skal udlignes med den post, som vises i feltet Bel›b til r†dighed. Bel›bet er i den valuta, som repr‘senteres af koden i feltet Valutakode.;
                           ENU=Specifies the sum of the amounts on all the selected customer ledger entries that will be applied by the entry shown in the Available Amount field. The amount is in the currency represented by the code in the Currency Code field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedAmount;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1902760701;3;Group  ;
                CaptionML=[DAN=Kontantrabatbel›b;
                           ENU=Pmt. Disc. Amount] }

    { 91  ;4   ;Field     ;
                Name=PmtDiscAmount;
                CaptionML=[DAN=Kontantrabatbel›b;
                           ENU=Pmt. Disc. Amount];
                ToolTipML=[DAN=Angiver summen af kontantrabatbel›b p† alle de valgte debitorposter, der skal udlignes med den post, som vises i feltet Bel›b til r†dighed. Bel›bet er i den valuta, som repr‘senteres af koden i feltet Valutakode.;
                           ENU=Specifies the sum of the payment discount amounts granted on all the selected customer ledger entries that will be applied by the entry shown in the Available Amount field. The amount is in the currency represented by the code in the Currency Code field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=-PmtDiscAmount;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1901741901;3;Group  ;
                CaptionML=[DAN=Afrunding;
                           ENU=Rounding] }

    { 58  ;4   ;Field     ;
                CaptionML=[DAN=Afrunding;
                           ENU=Rounding];
                ToolTipML=[DAN=Angiver afrundingsdifferencen, n†r poster i forskellige valutaer udlignes med hinanden. Bel›bet er i den valuta, der er repr‘senteret af koden i feltet Valutakode.;
                           ENU=Specifies the rounding difference when you apply entries in different currencies to one another. The amount is in the currency represented by the code in the Currency Code field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplnRounding;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1900546301;3;Group  ;
                CaptionML=[DAN=Udligningsbel›b;
                           ENU=Applied Amount] }

    { 97  ;4   ;Field     ;
                Name=AppliedAmount;
                CaptionML=[DAN=Udligningsbel›b;
                           ENU=Applied Amount];
                ToolTipML=[DAN=Angiver summen af bel›bene i feltet Bel›b, der skal udlignes, feltet Kontantrabatbel›b og feltet Afrunding. Bel›bet er i den valuta, som koden i feltet Valutakode repr‘senterer.;
                           ENU=Specifies the sum of the amounts in the Amount to Apply field, Pmt. Disc. Amount field, and the Rounding. The amount is in the currency represented by the code in the Currency Code field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedAmount + (-PmtDiscAmount) + ApplnRounding;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1901991601;3;Group  ;
                CaptionML=[DAN=Bel›b til r†dighed;
                           ENU=Available Amount] }

    { 46  ;4   ;Field     ;
                CaptionML=[DAN=Bel›b til r†dighed;
                           ENU=Available Amount];
                ToolTipML=[DAN=Angiver bel›bet i kladdeposten, salgskreditnotaen eller den aktuelle debitorpost, som skal udlignes med andre poster.;
                           ENU=Specifies the amount of the journal entry, sales credit memo, or current customer ledger entry that you have selected as the applying entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingAmount;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1900206001;3;Group  ;
                CaptionML=[DAN=Saldo;
                           ENU=Balance] }

    { 42  ;4   ;Field     ;
                Name=ControlBalance;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Viser et eventuelt overskydende bel›b efter udligning.;
                           ENU=Specifies any extra amount that will remain after the application.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedAmount + (-PmtDiscAmount) + ApplyingAmount + ApplnRounding;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1903096107;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Entry No.=FIELD(Entry No.);
                PagePartID=Page9106;
                Visible=TRUE;
                PartType=Page }

  }
  CODE
  {
    VAR
      ApplyingCustLedgEntry@1035 : TEMPORARY Record 21;
      AppliedCustLedgEntry@1001 : Record 21;
      Currency@1002 : Record 4;
      CurrExchRate@1003 : Record 330;
      GenJnlLine@1004 : Record 81;
      GenJnlLine2@1005 : Record 81;
      SalesHeader@1006 : Record 36;
      ServHeader@1045 : Record 5900;
      Cust@1007 : Record 18;
      CustLedgEntry@1008 : Record 21;
      GLSetup@1009 : Record 98;
      TotalSalesLine@1010 : Record 37;
      TotalSalesLineLCY@1011 : Record 37;
      TotalServLine@1046 : Record 5902;
      TotalServLineLCY@1047 : Record 5902;
      CustEntrySetApplID@1013 : Codeunit 101;
      GenJnlApply@1014 : Codeunit 225;
      SalesPost@1015 : Codeunit 80;
      PaymentToleranceMgt@1048 : Codeunit 426;
      Navigate@1012 : Page 344;
      AppliedAmount@1017 : Decimal;
      ApplyingAmount@1018 : Decimal;
      PmtDiscAmount@1041 : Decimal;
      ApplnDate@1019 : Date;
      ApplnCurrencyCode@1020 : Code[10];
      ApplnRoundingPrecision@1021 : Decimal;
      ApplnRounding@1022 : Decimal;
      ApplnType@1023 : ' ,Applies-to Doc. No.,Applies-to ID';
      AmountRoundingPrecision@1024 : Decimal;
      VATAmount@1025 : Decimal;
      VATAmountText@1026 : Text[30];
      StyleTxt@1016 : Text;
      ProfitLCY@1027 : Decimal;
      ProfitPct@1028 : Decimal;
      CalcType@1029 : 'Direct,GenJnlLine,SalesHeader,ServHeader';
      CustEntryApplID@1031 : Code[50];
      ValidExchRate@1032 : Boolean;
      DifferentCurrenciesInAppln@1034 : Boolean;
      Text002@1037 : TextConst 'DAN=Du skal v‘lge en udlignende post, f›r du kan sende udligningen.;ENU=You must select an applying entry before you can post the application.';
      ShowAppliedEntries@1038 : Boolean;
      Text003@1039 : TextConst 'DAN=Du skal sende udligningen fra det vindue, hvor du har angivet den udlignende post.;ENU=You must post the application from the window where you entered the applying entry.';
      CannotSetAppliesToIDErr@1030 : TextConst 'DAN=Du kan ikke angive udlignings-id, mens du v‘lger udligningsbilagsnr.;ENU=You cannot set Applies-to ID while selecting Applies-to Doc. No.';
      OK@1043 : Boolean;
      EarlierPostingDateErr@1044 : TextConst 'DAN=Du kan ikke udligne og bogf›re en post p† en post med en tidligere bogf›ringsdato.\\Du skal i stedet bogf›re dokumentet af type %1 med nummer %2 og derefter udligne det med dokumentet af type %3 med nummer %4.;ENU=You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.';
      PostingDone@1000 : Boolean;
      AppliesToIDVisible@19043506 : Boolean INDATASET;
      Text012@1036 : TextConst 'DAN=Udligningen er bogf›rt.;ENU=The application was successfully posted.';
      Text013@1033 : TextConst 'DAN=Det %1, som du har angivet, m† ikke v‘re f›r %1 p† %2.;ENU=The %1 entered must not be before the %1 on the %2.';
      Text019@1040 : TextConst 'DAN=Efterudligningsprocessen er blevet annulleret.;ENU=Post application process has been canceled.';

    [External]
    PROCEDURE SetGenJnlLine@1(NewGenJnlLine@1000 : Record 81;ApplnTypeSelect@1001 : Integer);
    BEGIN
      GenJnlLine := NewGenJnlLine;

      IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
        ApplyingAmount := GenJnlLine.Amount;
      IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer THEN
        ApplyingAmount := -GenJnlLine.Amount;
      ApplnDate := GenJnlLine."Posting Date";
      ApplnCurrencyCode := GenJnlLine."Currency Code";
      CalcType := CalcType::GenJnlLine;

      CASE ApplnTypeSelect OF
        GenJnlLine.FIELDNO("Applies-to Doc. No."):
          ApplnType := ApplnType::"Applies-to Doc. No.";
        GenJnlLine.FIELDNO("Applies-to ID"):
          ApplnType := ApplnType::"Applies-to ID";
      END;

      SetApplyingCustLedgEntry;
    END;

    [Internal]
    PROCEDURE SetSales@2(NewSalesHeader@1000 : Record 36;VAR NewCustLedgEntry@1001 : Record 21;ApplnTypeSelect@1002 : Integer);
    VAR
      TotalAdjCostLCY@1003 : Decimal;
    BEGIN
      SalesHeader := NewSalesHeader;
      COPYFILTERS(NewCustLedgEntry);

      SalesPost.SumSalesLines(
        SalesHeader,0,TotalSalesLine,TotalSalesLineLCY,
        VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);

      CASE SalesHeader."Document Type" OF
        SalesHeader."Document Type"::"Return Order",
        SalesHeader."Document Type"::"Credit Memo":
          ApplyingAmount := -TotalSalesLine."Amount Including VAT"
        ELSE
          ApplyingAmount := TotalSalesLine."Amount Including VAT";
      END;

      ApplnDate := SalesHeader."Posting Date";
      ApplnCurrencyCode := SalesHeader."Currency Code";
      CalcType := CalcType::SalesHeader;

      CASE ApplnTypeSelect OF
        SalesHeader.FIELDNO("Applies-to Doc. No."):
          ApplnType := ApplnType::"Applies-to Doc. No.";
        SalesHeader.FIELDNO("Applies-to ID"):
          ApplnType := ApplnType::"Applies-to ID";
      END;

      SetApplyingCustLedgEntry;
    END;

    [Internal]
    PROCEDURE SetService@8(NewServHeader@1000 : Record 5900;VAR NewCustLedgEntry@1001 : Record 21;ApplnTypeSelect@1002 : Integer);
    VAR
      ServAmountsMgt@1003 : Codeunit 5986;
      TotalAdjCostLCY@1004 : Decimal;
    BEGIN
      ServHeader := NewServHeader;
      COPYFILTERS(NewCustLedgEntry);

      ServAmountsMgt.SumServiceLines(
        ServHeader,0,TotalServLine,TotalServLineLCY,
        VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);

      CASE ServHeader."Document Type" OF
        ServHeader."Document Type"::"Credit Memo":
          ApplyingAmount := -TotalServLine."Amount Including VAT"
        ELSE
          ApplyingAmount := TotalServLine."Amount Including VAT";
      END;

      ApplnDate := ServHeader."Posting Date";
      ApplnCurrencyCode := ServHeader."Currency Code";
      CalcType := CalcType::ServHeader;

      CASE ApplnTypeSelect OF
        ServHeader.FIELDNO("Applies-to Doc. No."):
          ApplnType := ApplnType::"Applies-to Doc. No.";
        ServHeader.FIELDNO("Applies-to ID"):
          ApplnType := ApplnType::"Applies-to ID";
      END;

      SetApplyingCustLedgEntry;
    END;

    [External]
    PROCEDURE SetCustLedgEntry@13(NewCustLedgEntry@1000 : Record 21);
    BEGIN
      Rec := NewCustLedgEntry;
    END;

    [Internal]
    PROCEDURE SetApplyingCustLedgEntry@9();
    VAR
      Customer@1001 : Record 18;
    BEGIN
      CASE CalcType OF
        CalcType::SalesHeader:
          BEGIN
            ApplyingCustLedgEntry."Entry No." := 1;
            ApplyingCustLedgEntry."Posting Date" := SalesHeader."Posting Date";
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order" THEN
              ApplyingCustLedgEntry."Document Type" := SalesHeader."Document Type"::"Credit Memo"
            ELSE
              ApplyingCustLedgEntry."Document Type" := SalesHeader."Document Type";
            ApplyingCustLedgEntry."Document No." := SalesHeader."No.";
            ApplyingCustLedgEntry."Customer No." := SalesHeader."Bill-to Customer No.";
            ApplyingCustLedgEntry.Description := SalesHeader."Posting Description";
            ApplyingCustLedgEntry."Currency Code" := SalesHeader."Currency Code";
            IF ApplyingCustLedgEntry."Document Type" = ApplyingCustLedgEntry."Document Type"::"Credit Memo" THEN  BEGIN
              ApplyingCustLedgEntry.Amount := -TotalSalesLine."Amount Including VAT";
              ApplyingCustLedgEntry."Remaining Amount" := -TotalSalesLine."Amount Including VAT";
            END ELSE BEGIN
              ApplyingCustLedgEntry.Amount := TotalSalesLine."Amount Including VAT";
              ApplyingCustLedgEntry."Remaining Amount" := TotalSalesLine."Amount Including VAT";
            END;
            CalcApplnAmount;
          END;
        CalcType::ServHeader:
          BEGIN
            ApplyingCustLedgEntry."Entry No." := 1;
            ApplyingCustLedgEntry."Posting Date" := ServHeader."Posting Date";
            ApplyingCustLedgEntry."Document Type" := ServHeader."Document Type";
            ApplyingCustLedgEntry."Document No." := ServHeader."No.";
            ApplyingCustLedgEntry."Customer No." := ServHeader."Bill-to Customer No.";
            ApplyingCustLedgEntry.Description := ServHeader."Posting Description";
            ApplyingCustLedgEntry."Currency Code" := ServHeader."Currency Code";
            IF ApplyingCustLedgEntry."Document Type" = ApplyingCustLedgEntry."Document Type"::"Credit Memo" THEN  BEGIN
              ApplyingCustLedgEntry.Amount := -TotalServLine."Amount Including VAT";
              ApplyingCustLedgEntry."Remaining Amount" := -TotalServLine."Amount Including VAT";
            END ELSE BEGIN
              ApplyingCustLedgEntry.Amount := TotalServLine."Amount Including VAT";
              ApplyingCustLedgEntry."Remaining Amount" := TotalServLine."Amount Including VAT";
            END;
            CalcApplnAmount;
          END;
        CalcType::Direct:
          BEGIN
            IF "Applying Entry" THEN BEGIN
              IF ApplyingCustLedgEntry."Entry No." <> 0 THEN
                CustLedgEntry := ApplyingCustLedgEntry;
              CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
              IF "Applies-to ID" = '' THEN
                SetCustApplId;
              CALCFIELDS(Amount);
              ApplyingCustLedgEntry := Rec;
              IF CustLedgEntry."Entry No." <> 0 THEN BEGIN
                Rec := CustLedgEntry;
                "Applying Entry" := FALSE;
                SetCustApplId;
              END;
              SETFILTER("Entry No.",'<> %1',ApplyingCustLedgEntry."Entry No.");
              ApplyingAmount := ApplyingCustLedgEntry."Remaining Amount";
              ApplnDate := ApplyingCustLedgEntry."Posting Date";
              ApplnCurrencyCode := ApplyingCustLedgEntry."Currency Code";
            END;
            CalcApplnAmount;
          END;
        CalcType::GenJnlLine:
          BEGIN
            ApplyingCustLedgEntry."Entry No." := 1;
            ApplyingCustLedgEntry."Posting Date" := GenJnlLine."Posting Date";
            ApplyingCustLedgEntry."Document Type" := GenJnlLine."Document Type";
            ApplyingCustLedgEntry."Document No." := GenJnlLine."Document No.";
            IF GenJnlLine."Bal. Account Type" = GenJnlLine."Account Type"::Customer THEN BEGIN
              ApplyingCustLedgEntry."Customer No." := GenJnlLine."Bal. Account No.";
              Customer.GET(ApplyingCustLedgEntry."Customer No.");
              ApplyingCustLedgEntry.Description := Customer.Name;
            END ELSE BEGIN
              ApplyingCustLedgEntry."Customer No." := GenJnlLine."Account No.";
              ApplyingCustLedgEntry.Description := GenJnlLine.Description;
            END;
            ApplyingCustLedgEntry."Currency Code" := GenJnlLine."Currency Code";
            ApplyingCustLedgEntry.Amount := GenJnlLine.Amount;
            ApplyingCustLedgEntry."Remaining Amount" := GenJnlLine.Amount;
            CalcApplnAmount;
          END;
      END;
    END;

    [Internal]
    PROCEDURE SetCustApplId@11();
    BEGIN
      IF (CalcType = CalcType::GenJnlLine) AND (ApplyingCustLedgEntry."Posting Date" < "Posting Date") THEN
        ERROR(
          EarlierPostingDateErr,ApplyingCustLedgEntry."Document Type",ApplyingCustLedgEntry."Document No.",
          "Document Type","Document No.");

      IF ApplyingCustLedgEntry."Entry No." <> 0 THEN
        GenJnlApply.CheckAgainstApplnCurrency(
          ApplnCurrencyCode,"Currency Code",GenJnlLine."Account Type"::Customer,TRUE);

      CustLedgEntry.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(CustLedgEntry);

      CustEntrySetApplID.SetApplId(CustLedgEntry,ApplyingCustLedgEntry,GetAppliesToID);

      CalcApplnAmount;
    END;

    LOCAL PROCEDURE GetAppliesToID@16() AppliesToID : Code[50];
    BEGIN
      CASE CalcType OF
        CalcType::GenJnlLine:
          AppliesToID := GenJnlLine."Applies-to ID";
        CalcType::SalesHeader:
          AppliesToID := SalesHeader."Applies-to ID";
        CalcType::ServHeader:
          AppliesToID := ServHeader."Applies-to ID";
      END;
    END;

    [Internal]
    PROCEDURE CalcApplnAmount@4();
    BEGIN
      AppliedAmount := 0;
      PmtDiscAmount := 0;
      DifferentCurrenciesInAppln := FALSE;

      CASE CalcType OF
        CalcType::Direct:
          BEGIN
            FindAmountRounding;
            CustEntryApplID := USERID;
            IF CustEntryApplID = '' THEN
              CustEntryApplID := '***';

            CustLedgEntry := ApplyingCustLedgEntry;

            AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
            AppliedCustLedgEntry.SETRANGE("Customer No.","Customer No.");
            AppliedCustLedgEntry.SETRANGE(Open,TRUE);
            AppliedCustLedgEntry.SETRANGE("Applies-to ID",CustEntryApplID);

            IF ApplyingCustLedgEntry."Entry No." <> 0 THEN BEGIN
              CustLedgEntry.CALCFIELDS("Remaining Amount");
              AppliedCustLedgEntry.SETFILTER("Entry No.",'<>%1',ApplyingCustLedgEntry."Entry No.");
            END;

            HandlChosenEntries(0,
              CustLedgEntry."Remaining Amount",
              CustLedgEntry."Currency Code",
              CustLedgEntry."Posting Date");
          END;
        CalcType::GenJnlLine:
          BEGIN
            FindAmountRounding;
            IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer THEN
              CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",GenJnlLine);

            CASE ApplnType OF
              ApplnType::"Applies-to Doc. No.":
                BEGIN
                  AppliedCustLedgEntry := Rec;
                  WITH AppliedCustLedgEntry DO BEGIN
                    CALCFIELDS("Remaining Amount");
                    IF "Currency Code" <> ApplnCurrencyCode THEN BEGIN
                      "Remaining Amount" :=
                        CurrExchRate.ExchangeAmtFCYToFCY(
                          ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Amount");
                      "Remaining Pmt. Disc. Possible" :=
                        CurrExchRate.ExchangeAmtFCYToFCY(
                          ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Pmt. Disc. Possible");
                      "Amount to Apply" :=
                        CurrExchRate.ExchangeAmtFCYToFCY(
                          ApplnDate,"Currency Code",ApplnCurrencyCode,"Amount to Apply");
                    END;

                    IF "Amount to Apply" <> 0 THEN
                      AppliedAmount := ROUND("Amount to Apply",AmountRoundingPrecision)
                    ELSE
                      AppliedAmount := ROUND("Remaining Amount",AmountRoundingPrecision);

                    IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(
                         GenJnlLine,AppliedCustLedgEntry,0,FALSE) AND
                       ((ABS(GenJnlLine.Amount) + ApplnRoundingPrecision >=
                         ABS(AppliedAmount - "Remaining Pmt. Disc. Possible")) OR
                        (GenJnlLine.Amount = 0))
                    THEN
                      PmtDiscAmount := "Remaining Pmt. Disc. Possible";

                    IF NOT DifferentCurrenciesInAppln THEN
                      DifferentCurrenciesInAppln := ApplnCurrencyCode <> "Currency Code";
                  END;
                  CheckRounding;
                END;
              ApplnType::"Applies-to ID":
                BEGIN
                  GenJnlLine2 := GenJnlLine;
                  AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
                  AppliedCustLedgEntry.SETRANGE("Customer No.",GenJnlLine."Account No.");
                  AppliedCustLedgEntry.SETRANGE(Open,TRUE);
                  AppliedCustLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");

                  HandlChosenEntries(1,
                    GenJnlLine2.Amount,
                    GenJnlLine2."Currency Code",
                    GenJnlLine2."Posting Date");
                END;
            END;
          END;
        CalcType::SalesHeader,CalcType::ServHeader:
          BEGIN
            FindAmountRounding;

            CASE ApplnType OF
              ApplnType::"Applies-to Doc. No.":
                BEGIN
                  AppliedCustLedgEntry := Rec;
                  WITH AppliedCustLedgEntry DO BEGIN
                    CALCFIELDS("Remaining Amount");

                    IF "Currency Code" <> ApplnCurrencyCode THEN
                      "Remaining Amount" :=
                        CurrExchRate.ExchangeAmtFCYToFCY(
                          ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Amount");

                    AppliedAmount := ROUND("Remaining Amount",AmountRoundingPrecision);

                    IF NOT DifferentCurrenciesInAppln THEN
                      DifferentCurrenciesInAppln := ApplnCurrencyCode <> "Currency Code";
                  END;
                  CheckRounding;
                END;
              ApplnType::"Applies-to ID":
                BEGIN
                  AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
                  IF CalcType = CalcType::SalesHeader THEN
                    AppliedCustLedgEntry.SETRANGE("Customer No.",SalesHeader."Bill-to Customer No.")
                  ELSE
                    AppliedCustLedgEntry.SETRANGE("Customer No.",ServHeader."Bill-to Customer No.");
                  AppliedCustLedgEntry.SETRANGE(Open,TRUE);
                  AppliedCustLedgEntry.SETRANGE("Applies-to ID",GetAppliesToID);

                  HandlChosenEntries(2,
                    ApplyingAmount,
                    ApplnCurrencyCode,
                    ApplnDate);
                END;
            END;
          END;
      END;
    END;

    LOCAL PROCEDURE CalcApplnRemainingAmount@6(Amount@1000 : Decimal) : Decimal;
    VAR
      ApplnRemainingAmount@1001 : Decimal;
    BEGIN
      ValidExchRate := TRUE;
      IF ApplnCurrencyCode = "Currency Code" THEN
        EXIT(Amount);

      IF ApplnDate = 0D THEN
        ApplnDate := "Posting Date";
      ApplnRemainingAmount :=
        CurrExchRate.ApplnExchangeAmtFCYToFCY(
          ApplnDate,"Currency Code",ApplnCurrencyCode,Amount,ValidExchRate);
      EXIT(ApplnRemainingAmount);
    END;

    LOCAL PROCEDURE CalcApplnAmounttoApply@10(AmounttoApply@1000 : Decimal) : Decimal;
    VAR
      ApplnAmounttoApply@1001 : Decimal;
    BEGIN
      ValidExchRate := TRUE;

      IF ApplnCurrencyCode = "Currency Code" THEN
        EXIT(AmounttoApply);

      IF ApplnDate = 0D THEN
        ApplnDate := "Posting Date";
      ApplnAmounttoApply :=
        CurrExchRate.ApplnExchangeAmtFCYToFCY(
          ApplnDate,"Currency Code",ApplnCurrencyCode,AmounttoApply,ValidExchRate);
      EXIT(ApplnAmounttoApply);
    END;

    LOCAL PROCEDURE FindAmountRounding@7();
    BEGIN
      IF ApplnCurrencyCode = '' THEN BEGIN
        Currency.INIT;
        Currency.Code := '';
        Currency.InitRoundingPrecision;
      END ELSE
        IF ApplnCurrencyCode <> Currency.Code THEN
          Currency.GET(ApplnCurrencyCode);

      AmountRoundingPrecision := Currency."Amount Rounding Precision";
    END;

    LOCAL PROCEDURE CheckRounding@3();
    BEGIN
      ApplnRounding := 0;

      CASE CalcType OF
        CalcType::SalesHeader,CalcType::ServHeader:
          EXIT;
        CalcType::GenJnlLine:
          IF (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Payment) AND
             (GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Refund)
          THEN
            EXIT;
      END;

      IF ApplnCurrencyCode = '' THEN
        ApplnRoundingPrecision := GLSetup."Appln. Rounding Precision"
      ELSE BEGIN
        IF ApplnCurrencyCode <> "Currency Code" THEN
          Currency.GET(ApplnCurrencyCode);
        ApplnRoundingPrecision := Currency."Appln. Rounding Precision";
      END;

      IF (ABS((AppliedAmount - PmtDiscAmount) + ApplyingAmount) <= ApplnRoundingPrecision) AND DifferentCurrenciesInAppln THEN
        ApplnRounding := -((AppliedAmount - PmtDiscAmount) + ApplyingAmount);
    END;

    [External]
    PROCEDURE GetCustLedgEntry@5(VAR CustLedgEntry@1000 : Record 21);
    BEGIN
      CustLedgEntry := Rec;
    END;

    LOCAL PROCEDURE FindApplyingEntry@12();
    BEGIN
      IF CalcType = CalcType::Direct THEN BEGIN
        CustEntryApplID := USERID;
        IF CustEntryApplID = '' THEN
          CustEntryApplID := '***';

        CustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open);
        CustLedgEntry.SETRANGE("Customer No.","Customer No.");
        CustLedgEntry.SETRANGE("Applies-to ID",CustEntryApplID);
        CustLedgEntry.SETRANGE(Open,TRUE);
        CustLedgEntry.SETRANGE("Applying Entry",TRUE);
        IF CustLedgEntry.FINDFIRST THEN BEGIN
          CustLedgEntry.CALCFIELDS(Amount,"Remaining Amount");
          ApplyingCustLedgEntry := CustLedgEntry;
          SETFILTER("Entry No.",'<>%1',CustLedgEntry."Entry No.");
          ApplyingAmount := CustLedgEntry."Remaining Amount";
          ApplnDate := CustLedgEntry."Posting Date";
          ApplnCurrencyCode := CustLedgEntry."Currency Code";
        END;
        CalcApplnAmount;
      END;
    END;

    LOCAL PROCEDURE HandlChosenEntries@14(Type@1000 : 'Direct,GenJnlLine,SalesHeader';CurrentAmount@1001 : Decimal;CurrencyCode@1002 : Code[10];PostingDate@1003 : Date);
    VAR
      AppliedCustLedgEntryTemp@1004 : TEMPORARY Record 21;
      PossiblePmtDisc@1007 : Decimal;
      OldPmtDisc@1008 : Decimal;
      CorrectionAmount@1009 : Decimal;
      RemainingAmountExclDiscounts@1012 : Decimal;
      CanUseDisc@1005 : Boolean;
      FromZeroGenJnl@1010 : Boolean;
    BEGIN
      IF AppliedCustLedgEntry.FINDSET(FALSE,FALSE) THEN BEGIN
        REPEAT
          AppliedCustLedgEntryTemp := AppliedCustLedgEntry;
          AppliedCustLedgEntryTemp.INSERT;
        UNTIL AppliedCustLedgEntry.NEXT = 0;
      END ELSE
        EXIT;

      FromZeroGenJnl := (CurrentAmount = 0) AND (Type = Type::GenJnlLine);

      REPEAT
        IF NOT FromZeroGenJnl THEN
          AppliedCustLedgEntryTemp.SETRANGE(Positive,CurrentAmount < 0);
        IF AppliedCustLedgEntryTemp.FINDFIRST THEN BEGIN
          ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,AppliedCustLedgEntryTemp,PostingDate);

          CASE Type OF
            Type::Direct:
              CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscCust(CustLedgEntry,AppliedCustLedgEntryTemp,0,FALSE,FALSE);
            Type::GenJnlLine:
              CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine2,AppliedCustLedgEntryTemp,0,FALSE)
            ELSE
              CanUseDisc := FALSE;
          END;

          IF CanUseDisc AND
             (ABS(AppliedCustLedgEntryTemp."Amount to Apply") >= ABS(AppliedCustLedgEntryTemp."Remaining Amount" -
                AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
          THEN BEGIN
            IF (ABS(CurrentAmount) > ABS(AppliedCustLedgEntryTemp."Remaining Amount" -
                  AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
            THEN BEGIN
              PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
              CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
                AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
            END ELSE
              IF (ABS(CurrentAmount) = ABS(AppliedCustLedgEntryTemp."Remaining Amount" -
                    AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible"))
              THEN BEGIN
                PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
                  AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                AppliedAmount := AppliedAmount + CorrectionAmount;
              END ELSE
                IF FromZeroGenJnl THEN BEGIN
                  PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  CurrentAmount := CurrentAmount +
                    AppliedCustLedgEntryTemp."Remaining Amount" - AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                END ELSE BEGIN
                  PossiblePmtDisc := AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  RemainingAmountExclDiscounts := AppliedCustLedgEntryTemp."Remaining Amount" - PossiblePmtDisc -
                    AppliedCustLedgEntryTemp."Max. Payment Tolerance";
                  IF ABS(CurrentAmount) + ABS(CalcOppositeEntriesAmount(AppliedCustLedgEntryTemp)) >= ABS(RemainingAmountExclDiscounts)
                  THEN BEGIN
                    PmtDiscAmount := PmtDiscAmount + PossiblePmtDisc;
                    AppliedAmount := AppliedAmount + CorrectionAmount;
                  END;
                  CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Remaining Amount" -
                    AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                END;
          END ELSE BEGIN
            IF ((CurrentAmount + AppliedCustLedgEntryTemp."Amount to Apply") * CurrentAmount) <= 0 THEN
              AppliedAmount := AppliedAmount + CorrectionAmount;
            CurrentAmount := CurrentAmount + AppliedCustLedgEntryTemp."Amount to Apply";
          END;
        END ELSE BEGIN
          AppliedCustLedgEntryTemp.SETRANGE(Positive);
          AppliedCustLedgEntryTemp.FINDFIRST;
          ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,AppliedCustLedgEntryTemp,PostingDate);
        END;

        IF OldPmtDisc <> PmtDiscAmount THEN
          AppliedAmount := AppliedAmount + AppliedCustLedgEntryTemp."Remaining Amount"
        ELSE
          AppliedAmount := AppliedAmount + AppliedCustLedgEntryTemp."Amount to Apply";
        OldPmtDisc := PmtDiscAmount;

        IF PossiblePmtDisc <> 0 THEN
          CorrectionAmount := AppliedCustLedgEntryTemp."Remaining Amount" - AppliedCustLedgEntryTemp."Amount to Apply"
        ELSE
          CorrectionAmount := 0;

        IF NOT DifferentCurrenciesInAppln THEN
          DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedCustLedgEntryTemp."Currency Code";

        AppliedCustLedgEntryTemp.DELETE;
        AppliedCustLedgEntryTemp.SETRANGE(Positive);

      UNTIL NOT AppliedCustLedgEntryTemp.FINDFIRST;
      CheckRounding;
    END;

    LOCAL PROCEDURE AmounttoApplyOnAfterValidate@19038179();
    BEGIN
      IF ApplnType <> ApplnType::"Applies-to Doc. No." THEN BEGIN
        CalcApplnAmount;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE RecalcApplnAmount@19051222();
    BEGIN
      CurrPage.UPDATE(TRUE);
      CalcApplnAmount;
    END;

    LOCAL PROCEDURE LookupOKOnPush@19031339();
    BEGIN
      OK := TRUE;
    END;

    LOCAL PROCEDURE PostDirectApplication@15(PreviewMode@1005 : Boolean);
    VAR
      CustEntryApplyPostedEntries@1000 : Codeunit 226;
      PostApplication@1002 : Page 579;
      Applied@1006 : Boolean;
      ApplicationDate@1001 : Date;
      NewApplicationDate@1003 : Date;
      NewDocumentNo@1004 : Code[20];
    BEGIN
      IF CalcType = CalcType::Direct THEN BEGIN
        IF ApplyingCustLedgEntry."Entry No." <> 0 THEN BEGIN
          Rec := ApplyingCustLedgEntry;
          ApplicationDate := CustEntryApplyPostedEntries.GetApplicationDate(Rec);

          PostApplication.SetValues("Document No.",ApplicationDate);
          IF ACTION::OK = PostApplication.RUNMODAL THEN BEGIN
            PostApplication.GetValues(NewDocumentNo,NewApplicationDate);
            IF NewApplicationDate < ApplicationDate THEN
              ERROR(Text013,FIELDCAPTION("Posting Date"),TABLECAPTION);
          END ELSE
            ERROR(Text019);

          IF PreviewMode THEN
            CustEntryApplyPostedEntries.PreviewApply(Rec,NewDocumentNo,NewApplicationDate)
          ELSE
            Applied := CustEntryApplyPostedEntries.Apply(Rec,NewDocumentNo,NewApplicationDate);

          IF (NOT PreviewMode) AND Applied THEN BEGIN
            MESSAGE(Text012);
            PostingDone := TRUE;
            CurrPage.CLOSE;
          END;
        END ELSE
          ERROR(Text002);
      END ELSE
        ERROR(Text003);
    END;

    LOCAL PROCEDURE ExchangeAmountsOnLedgerEntry@20(Type@1003 : 'Direct,GenJnlLine,SalesHeader';CurrencyCode@1000 : Code[10];VAR CalcCustLedgEntry@1001 : Record 21;PostingDate@1004 : Date);
    VAR
      CalculateCurrency@1002 : Boolean;
    BEGIN
      CalcCustLedgEntry.CALCFIELDS("Remaining Amount");

      IF Type = Type::Direct THEN
        CalculateCurrency := ApplyingCustLedgEntry."Entry No." <> 0
      ELSE
        CalculateCurrency := TRUE;

      IF (CurrencyCode <> CalcCustLedgEntry."Currency Code") AND CalculateCurrency THEN BEGIN
        CalcCustLedgEntry."Remaining Amount" :=
          CurrExchRate.ExchangeAmount(
            CalcCustLedgEntry."Remaining Amount",
            CalcCustLedgEntry."Currency Code",
            CurrencyCode,PostingDate);
        CalcCustLedgEntry."Remaining Pmt. Disc. Possible" :=
          CurrExchRate.ExchangeAmount(
            CalcCustLedgEntry."Remaining Pmt. Disc. Possible",
            CalcCustLedgEntry."Currency Code",
            CurrencyCode,PostingDate);
        CalcCustLedgEntry."Amount to Apply" :=
          CurrExchRate.ExchangeAmount(
            CalcCustLedgEntry."Amount to Apply",
            CalcCustLedgEntry."Currency Code",
            CurrencyCode,PostingDate);
      END;
    END;

    LOCAL PROCEDURE CalcOppositeEntriesAmount@17(VAR TempAppliedCustLedgerEntry@1000 : TEMPORARY Record 21) Result : Decimal;
    VAR
      SavedAppliedCustLedgerEntry@1002 : Record 21;
      CurrPosFilter@1001 : Text;
    BEGIN
      WITH TempAppliedCustLedgerEntry DO BEGIN
        CurrPosFilter := GETFILTER(Positive);
        IF CurrPosFilter <> '' THEN BEGIN
          SavedAppliedCustLedgerEntry := TempAppliedCustLedgerEntry;
          SETRANGE(Positive,NOT Positive);
          IF FINDSET THEN
            REPEAT
              CALCFIELDS("Remaining Amount");
              Result += "Remaining Amount";
            UNTIL NEXT = 0;
          SETFILTER(Positive,CurrPosFilter);
          TempAppliedCustLedgerEntry := SavedAppliedCustLedgerEntry;
        END;
      END;
    END;

    BEGIN
    END.
  }
}

