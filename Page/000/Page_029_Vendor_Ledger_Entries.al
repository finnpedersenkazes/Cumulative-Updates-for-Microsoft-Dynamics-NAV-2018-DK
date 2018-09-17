OBJECT Page 29 Vendor Ledger Entries
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditorposter;
               ENU=Vendor Ledger Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table25;
    SourceTableView=SORTING(Entry No.)
                    ORDER(Descending);
    DataCaptionFields=Vendor No.;
    PageType=List;
    OnInit=BEGIN
             AmountVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 IF GETFILTERS <> '' THEN
                   IF FINDFIRST THEN;

                 ShowAmounts;
               END;

    OnAfterGetRecord=BEGIN
                       StyleTxt := SetStyle;
                     END;

    OnModifyRecord=BEGIN
                     CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",Rec);
                     EXIT(FALSE);
                   END;

    OnAfterGetCurrRecord=VAR
                           IncomingDocument@1000 : Record 130;
                         BEGIN
                           HasIncomingDocument := IncomingDocument.PostedDocExists("Document No.","Posting Date");
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 53      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 72      ;2   ;Action    ;
                      CaptionML=[DAN=Udlignede &poster;
                                 ENU=Applied E&ntries];
                      ToolTipML=[DAN=Se finansposter, der er godkendt for denne record.;
                                 ENU=View the ledger entries that have been applied to this record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 62;
                      RunPageOnRec=Yes;
                      Image=Approve;
                      Scope=Repeater }
      { 55      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 29      ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr‘ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Suite;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                               END;
                                }
      { 54      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Detaljerede p&oster;
                                 ENU=Detailed &Ledger Entries];
                      ToolTipML=[DAN=Se en oversigt over alle bogf›rte poster og reguleringer relateret til en bestemt kreditorpost;
                                 ENU=View a summary of the all posted entries and adjustments related to a specific vendor ledger entry];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 574;
                      RunPageView=SORTING(Vendor Ledger Entry No.,Posting Date);
                      RunPageLink=Vendor Ledger Entry No.=FIELD(Entry No.),
                                  Vendor No.=FIELD(Vendor No.);
                      Image=View;
                      Scope=Repeater }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 34      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 36      ;2   ;Action    ;
                      Name=ActionApplyEntries;
                      ShortCutKey=Shift+F11;
                      CaptionML=[DAN=Udlign;
                                 ENU=Apply Entries];
                      ToolTipML=[DAN=V‘lg en eller flere finansposter, denne record skal anvendes p†, s† de relaterede, bogf›rte dokumenter lukkes som betalt eller refunderet.;
                                 ENU=Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ApplyEntries;
                      Scope=Repeater;
                      OnAction=VAR
                                 VendLedgEntry@1001 : Record 25;
                                 VendEntryApplyPostEntries@1000 : Codeunit 227;
                               BEGIN
                                 VendLedgEntry.COPY(Rec);
                                 VendEntryApplyPostEntries.ApplyVendEntryFormEntry(VendLedgEntry);
                                 Rec := VendLedgEntry;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 66      ;2   ;Separator  }
      { 67      ;2   ;Action    ;
                      Name=UnapplyEntries;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Annuller udligning;
                                 ENU=Unapply Entries];
                      ToolTipML=[DAN=Frav‘lg en eller flere finansposter, der ikke skal anvendes p† denne record.;
                                 ENU=Unselect one or more ledger entries that you want to unapply this record.];
                      ApplicationArea=#Basic,#Suite;
                      Image=UnApply;
                      Scope=Repeater;
                      OnAction=VAR
                                 VendEntryApplyPostedEntries@1000 : Codeunit 227;
                               BEGIN
                                 VendEntryApplyPostedEntries.UnApplyVendLedgEntry("Entry No.");
                               END;
                                }
      { 68      ;2   ;Separator  }
      { 69      ;2   ;Action    ;
                      Name=ReverseTransaction;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Tilbagef›r transaktion;
                                 ENU=Reverse Transaction];
                      ToolTipML=[DAN=Tilbagef›r en fejlbeh‘ftet kreditorpost.;
                                 ENU=Reverse an erroneous vendor ledger entry.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ReverseRegister;
                      Scope=Repeater;
                      OnAction=VAR
                                 ReversalEntry@1000 : Record 179;
                               BEGIN
                                 CLEAR(ReversalEntry);
                                 IF Reversed THEN
                                   ReversalEntry.AlreadyReversedEntry(TABLECAPTION,"Entry No.");
                                 IF "Journal Batch Name" = '' THEN
                                   ReversalEntry.TestFieldError;
                                 TESTFIELD("Transaction No.");
                                 ReversalEntry.ReverseTransaction("Transaction No.");
                               END;
                                }
      { 17      ;2   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=Indg†ende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 19      ;3   ;Action    ;
                      Name=IncomingDocCard;
                      CaptionML=[DAN=Vis indg†ende bilag;
                                 ENU=View Incoming Document];
                      ToolTipML=[DAN=Se alle indg†ende bilagsrecords og vedh‘ftede filer, der findes for posten eller bilaget.;
                                 ENU=View any incoming document records and file attachments that exist for the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=HasIncomingDocument;
                      Image=ViewOrder;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCard("Document No.","Posting Date");
                               END;
                                }
      { 11      ;3   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=V‘lg indg†ende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=V‘lg en indg†ende bilagsrecord og vedh‘ftet fil, der skal knyttes til posten eller bilaget.;
                                 ENU=Select an incoming document record and file attachment that you want to link to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT HasIncomingDocument;
                      Image=SelectLineToApply;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.SelectIncomingDocumentForPostedDocument("Document No.","Posting Date",RECORDID);
                               END;
                                }
      { 15      ;3   ;Action    ;
                      Name=IncomingDocAttachFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret indg†ende bilag ud fra fil;
                                 ENU=Create Incoming Document from File];
                      ToolTipML=[DAN=Opret en indg†ende bilagsrecord ved at v‘lge en fil, der skal vedh‘ftes, og knyt derefter den indg†ende bilagsrecord til posten eller bilaget.;
                                 ENU=Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT HasIncomingDocument;
                      Image=Attach;
                      OnAction=VAR
                                 IncomingDocumentAttachment@1000 : Record 133;
                               BEGIN
                                 IncomingDocumentAttachment.NewAttachmentFromPostedDocument("Document No.","Posting Date");
                               END;
                                }
      { 37      ;1   ;Action    ;
                      CaptionML=[DAN=N&aviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
                               END;
                                }
      { 13      ;1   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis bogf›rt dokument;
                                 ENU=Show Posted Document];
                      ToolTipML=[DAN=Se oplysninger om bogf›rt betaling, faktura eller kreditnota.;
                                 ENU=Show details for the posted payment, invoice, or credit memo.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Document;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowDoc
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorpostens bogf›ringsdato.;
                           ENU=Specifies the vendor entry's posting date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken dokumenttype kreditorposten tilh›rer.;
                           ENU=Specifies the document type that the vendor entry belongs to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type";
                Editable=FALSE;
                StyleExpr=StyleTxt }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorpostens bilagsnummer.;
                           ENU=Specifies the vendor entry's document number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                Editable=FALSE;
                StyleExpr=StyleTxt }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditorkonto, som posten er tilknyttet.;
                           ENU=Specifies the number of the vendor account that the entry is linked to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor No.";
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den meddelelse, der eksporteres til betalingsfilen, n†r du bruger funktionen Eksport‚r betalinger til fil i vinduet Udbetalingskladde.;
                           ENU=Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Message to Recipient" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af kreditorposten.;
                           ENU=Specifies a description of the vendor entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Editable=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE;
                Editable=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE;
                Editable=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncerninterne partner, som transaktionen er relateret til, hvis posten blev oprettet fra en koncernintern transaktion.;
                           ENU=Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Visible=FALSE;
                Editable=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indk›ber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchaser Code";
                Visible=FALSE;
                Editable=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel›bet p† linjen.;
                           ENU=Specifies the currency code for the amount on the line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Editable=FALSE }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code" }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingen for k›bsfakturaen.;
                           ENU=Specifies the payment of the purchase invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Reference" }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kreditor, som har sendt k›bsfakturaen.;
                           ENU=Specifies the vendor who sent the purchase invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Creditor No." }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for den oprindelige post.;
                           ENU=Specifies the amount of the original entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Original Amount";
                Editable=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, posten oprindeligt bestod af, i RV.;
                           ENU=Specifies the amount that the entry originally consisted of, in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Original Amt. (LCY)";
                Visible=FALSE;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten.;
                           ENU=Specifies the amount of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                Visible=AmountVisible;
                Editable=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten i regnskabsvalutaen.;
                           ENU=Specifies the amount of the entry in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Amount (LCY)";
                Visible=AmountVisible;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=DebitCreditVisible }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent debits, expressed in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Debit Amount (LCY)";
                Visible=DebitCreditVisible }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=DebitCreditVisible }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent credits, expressed in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Credit Amount (LCY)";
                Visible=DebitCreditVisible }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som mangler at blive udlignet, inden posten udlignes fuldst‘ndigt.;
                           ENU=Specifies the amount that remains to be applied to before the entry is totally applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount";
                Editable=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som mangler at blive udlignet, inden posten udlignes fuldst‘ndigt.;
                           ENU=Specifies the amount that remains to be applied to before the entry is totally applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amt. (LCY)";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf›res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. Account Type";
                Visible=FALSE;
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf›res til, f.eks. en kassekonto ved kontantk›b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Advanced;
                SourceExpr="Bal. Account No.";
                Visible=FALSE;
                Editable=FALSE }

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
                SourceExpr="Pmt. Discount Date" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste dato, hvor bel›bet i posten skal v‘re betalt, for at der kan opn†s kontantrabattolerance.;
                           ENU=Specifies the latest date the amount in the entry must be paid in order for payment discount tolerance to be granted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Disc. Tolerance Date" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabat, som du kan opn†, hvis posten bliver udlignet inden kontantrabatdatoen.;
                           ENU=Specifies the discount that you can obtain if the entry is applied to before the payment discount date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Original Pmt. Disc. Possible" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tilbagev‘rende kontantrabat, som kan opn†s, hvis betalingen finder sted inden forfaldsdatoen for kontantrabatten.;
                           ENU=Specifies the remaining payment discount which can be received if the payment is made before the payment discount date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Pmt. Disc. Possible" }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimalt tilladte bel›b, som posten kan afvige fra det bel›b, der er angivet p† fakturaen eller kreditnotaen.;
                           ENU=Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Max. Payment Tolerance" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er helt afregnet, eller om der stadig mangler at blive udlignet et bel›b.;
                           ENU=Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Open;
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den tilknyttede post repr‘senterer en ubetalt faktura, som der findes et betalingsforslag, en rykker eller en rentenota til.;
                           ENU=Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="On Hold" }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE;
                Editable=FALSE }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE;
                Editable=FALSE }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Reason Code";
                Visible=FALSE;
                Editable=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten har v‘ret en del af en tilbagef›rt transaktion.;
                           ENU=Specifies if the entry has been part of a reverse transaction.];
                ApplicationArea=#Advanced;
                SourceExpr=Reversed;
                Visible=FALSE;
                Editable=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den korrigerende post, der erstattede den oprindelige post i den tilbagef›rte transaktion.;
                           ENU=Specifies the number of the correcting entry that replaced the original entry in the reverse transaction.];
                ApplicationArea=#Advanced;
                SourceExpr="Reversed by Entry No.";
                Visible=FALSE;
                Editable=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den oprindelige post, der blev annulleret ved tilbagef›rselstransaktionen.;
                           ENU=Specifies the number of the original entry that was undone by the reverse transaction.];
                ApplicationArea=#Advanced;
                SourceExpr="Reversed Entry No.";
                Visible=FALSE;
                Editable=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No.";
                Editable=FALSE }

    { 290 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at posten blev oprettet ved eksport af en betalingskladdelinje.;
                           ENU=Specifies that the entry was created as a result of exporting a payment journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Exported to Payment File" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv‘rdier. De faktiske v‘rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension Set ID";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 3   ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page193;
                PartType=Page;
                ShowFilter=No }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Navigate@1000 : Page 344;
      DimensionSetIDFilter@1003 : Page 481;
      StyleTxt@1001 : Text;
      HasIncomingDocument@1002 : Boolean;
      AmountVisible@1005 : Boolean;
      DebitCreditVisible@1004 : Boolean;

    LOCAL PROCEDURE ShowAmounts@8();
    VAR
      GLSetup@1000 : Record 98;
    BEGIN
      GLSetup.GET;
      AmountVisible := NOT (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
      DebitCreditVisible := NOT (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
    END;

    BEGIN
    END.
  }
}

