OBJECT Page 233 Apply Vendor Entries
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udlign kred.poster;
               ENU=Apply Vendor Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table25;
    DataCaptionFields=Vendor No.;
    PageType=Worksheet;
    OnInit=BEGIN
             AppliesToIDVisible := TRUE;
           END;

    OnOpenPage=VAR
                 OfficeMgt@1000 : Codeunit 1630;
               BEGIN
                 IF CalcType = CalcType::Direct THEN BEGIN
                   Vend.GET("Vendor No.");
                   ApplnCurrencyCode := Vend."Currency Code";
                   FindApplyingEntry;
                 END;

                 AppliesToIDVisible := ApplnType <> ApplnType::"Applies-to Doc. No.";

                 GLSetup.GET;

                 IF CalcType = CalcType::GenJnlLine THEN
                   CalcApplnAmount;
                 PostingDone := FALSE;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
               END;

    OnAfterGetRecord=BEGIN
                       StyleTxt := SetStyle;
                     END;

    OnModifyRecord=BEGIN
                     CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",Rec);
                     IF "Applies-to ID" <> xRec."Applies-to ID" THEN
                       CalcApplnAmount;
                     EXIT(FALSE);
                   END;

    OnQueryClosePage=BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                         LookupOKOnPush;
                       IF ApplnType = ApplnType::"Applies-to Doc. No." THEN BEGIN
                         IF OK AND (ApplyingVendLedgEntry."Posting Date" < "Posting Date") THEN BEGIN
                           OK := FALSE;
                           ERROR(
                             EarlierPostingDateErr,ApplyingVendLedgEntry."Document Type",ApplyingVendLedgEntry."Document No.",
                             "Document Type","Document No.");
                         END;
                         IF OK THEN BEGIN
                           IF "Amount to Apply" = 0 THEN
                             "Amount to Apply" := "Remaining Amount";
                           CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",Rec);
                         END;
                       END;

                       IF CheckActionPerformed THEN BEGIN
                         Rec := ApplyingVendLedgEntry;
                         "Applying Entry" := FALSE;
                         IF AppliesToID = '' THEN BEGIN
                           "Applies-to ID" := '';
                           "Amount to Apply" := 0;
                         END;
                         CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",Rec);
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
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Udlignede &poster;
                                 ENU=Applied E&ntries];
                      ToolTipML=[DAN=Se finansposter, der er godkendt for denne record.;
                                 ENU=View the ledger entries that have been applied to this record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 62;
                      RunPageOnRec=Yes;
                      Image=Approve }
      { 57      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 63      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Detaljerede p&oster;
                                 ENU=Detailed &Ledger Entries];
                      ToolTipML=[DAN=Se en oversigt over alle bogf�rte poster og reguleringer relateret til en bestemt kreditorpost.;
                                 ENU=View a summary of the all posted entries and adjustments related to a specific vendor ledger entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 574;
                      RunPageView=SORTING(Vendor Ledger Entry No.,Posting Date);
                      RunPageLink=Vendor Ledger Entry No.=FIELD(Entry No.);
                      Image=View }
      { 17      ;2   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf�ringsdatoen p� den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsOfficeAddin;
                      Image=Navigate;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dligning;
                                 ENU=&Application];
                      Image=Apply }
      { 13      ;2   ;Action    ;
                      Name=ActionSetAppliesToID;
                      ShortCutKey=Shift+F11;
                      CaptionML=[DAN=S�t udlignings-id;
                                 ENU=Set Applies-to ID];
                      ToolTipML=[DAN=Indstil feltet Udlignings-id p� den bogf�rte post til automatisk at blive udfyldt med bilagsnummeret fra posten i kladden.;
                                 ENU=Set the Applies-to ID field on the posted entry to automatically be filled in with the document number of the entry in the journal.];
                      ApplicationArea=#Basic,#Suite;
                      Image=SelectLineToApply;
                      OnAction=BEGIN
                                 IF (CalcType = CalcType::GenJnlLine) AND (ApplnType = ApplnType::"Applies-to Doc. No.") THEN
                                   ERROR(CannotSetAppliesToIDErr);

                                 SetVendApplId;
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=ActionPostApplication;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf�r udligning;
                                 ENU=Post Application];
                      ToolTipML=[DAN=Definer bilagsnummeret for den post, der skal bruges til udligningen. Desuden skal du angive bogf�ringsdatoen for udligningen.;
                                 ENU=Define the document number of the ledger entry to use to perform the application. In addition, you specify the Posting Date for the application.];
                      ApplicationArea=#Basic,#Suite;
                      Image=PostApplication;
                      OnAction=BEGIN
                                 PostDirectApplication(FALSE);
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf�ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n�r du bogf�rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      OnAction=BEGIN
                                 PostDirectApplication(TRUE);
                               END;
                                }
      { 7       ;2   ;Separator ;
                      CaptionML=[DAN=-;
                                 ENU=-] }
      { 5       ;2   ;Action    ;
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
                                     VendEntryApplID := USERID;
                                     IF VendEntryApplID = '' THEN
                                       VendEntryApplID := '***';
                                     SETRANGE("Applies-to ID",VendEntryApplID);
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
                CaptionML=[DAN=Bogf�ringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for den post, der skal udlignes.;
                           ENU=Specifies the posting date of the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingVendLedgEntry."Posting Date";
                Editable=FALSE }

    { 75  ;2   ;Field     ;
                CaptionML=[DAN=Bilagstype;
                           ENU=Document Type];
                ToolTipML=[DAN=Angiver dokumenttypen for den post, der skal udlignes.;
                           ENU=Specifies the document type of the entry to be applied.];
                OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                 ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingVendLedgEntry."Document Type";
                Editable=FALSE }

    { 77  ;2   ;Field     ;
                CaptionML=[DAN=Bilagsnr.;
                           ENU=Document No.];
                ToolTipML=[DAN=Angiver bilagsnummeret for den post, der skal udlignes.;
                           ENU=Specifies the document number of the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingVendLedgEntry."Document No.";
                Editable=FALSE }

    { 71  ;2   ;Field     ;
                Name=ApplyingVendorNo;
                CaptionML=[DAN=Kreditornr.;
                           ENU=Vendor No.];
                ToolTipML=[DAN=Angiver kreditornummeret for den post, der skal udlignes.;
                           ENU=Specifies the vendor number of the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingVendLedgEntry."Vendor No.";
                Visible=FALSE;
                Editable=FALSE }

    { 85  ;2   ;Field     ;
                Name=ApplyingDescription;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver en beskrivelse af den post, der skal udlignes.;
                           ENU=Specifies the description of the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingVendLedgEntry.Description;
                Visible=FALSE;
                Editable=FALSE }

    { 79  ;2   ;Field     ;
                CaptionML=[DAN=Valutakode;
                           ENU=Currency Code];
                ToolTipML=[DAN=Angiver koden for den valuta, som bel�bene vises i.;
                           ENU=Specifies the code for the currency that amounts are shown in.];
                ApplicationArea=#Suite;
                SourceExpr=ApplyingVendLedgEntry."Currency Code";
                Editable=FALSE }

    { 81  ;2   ;Field     ;
                CaptionML=[DAN=Bel�b;
                           ENU=Amount];
                ToolTipML=[DAN=Angiver bel�bet i den post, der skal udlignes.;
                           ENU=Specifies the amount on the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingVendLedgEntry.Amount;
                Editable=FALSE }

    { 83  ;2   ;Field     ;
                CaptionML=[DAN=Restbel�b;
                           ENU=Remaining Amount];
                ToolTipML=[DAN=Angiver bel�bet i den post, der skal udlignes.;
                           ENU=Specifies the amount on the entry to be applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingVendLedgEntry."Remaining Amount";
                Editable=FALSE }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 22  ;2   ;Field     ;
                Name=AppliesToID;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, n�r du v�lger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#All;
                SourceExpr="Applies-to ID";
                Visible=AppliesToIDVisible;
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE);
                           END;
                            }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorpostens bogf�ringsdato.;
                           ENU=Specifies the vendor entry's posting date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken dokumenttype kreditorposten tilh�rer.;
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

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kreditorkonto, som posten er tilknyttet.;
                           ENU=Specifies the number of the vendor account that the entry is linked to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor No.";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af kreditorposten.;
                           ENU=Specifies a description of the vendor entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Editable=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel�bet p� linjen.;
                           ENU=Specifies the currency code for the amount on the line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel�bet for den oprindelige post.;
                           ENU=Specifies the amount of the original entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Original Amount";
                Visible=FALSE;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel�bet for posten.;
                           ENU=Specifies the amount of the entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Amount;
                Visible=FALSE;
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel�b, som mangler at blive udlignet, inden posten udlignes fuldst�ndigt.;
                           ENU=Specifies the amount that remains to be applied to before the entry is totally applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount";
                Editable=FALSE }

    { 33  ;2   ;Field     ;
                CaptionML=[DAN=Udlign. restbel�b;
                           ENU=Appln. Remaining Amount];
                ToolTipML=[DAN=Angiver det bel�b, som mangler at blive udlignet, inden posten udlignes fuldst�ndigt.;
                           ENU=Specifies the amount that remains to be applied to before the entry is totally applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcApplnRemainingAmount("Remaining Amount");
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel�b, der skal udlignes.;
                           ENU=Specifies the amount to apply.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount to Apply";
                OnValidate=BEGIN
                             CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",Rec);

                             IF (xRec."Amount to Apply" = 0) OR ("Amount to Apply" = 0) AND
                                ((ApplnType = ApplnType::"Applies-to ID") OR (CalcType = CalcType::Direct))
                             THEN
                               SetVendApplId;
                             GET("Entry No.");
                             AmounttoApplyOnAfterValidate;
                           END;
                            }

    { 92  ;2   ;Field     ;
                CaptionML=[DAN=Bel�b til udligning;
                           ENU=Appln. Amount to Apply];
                ToolTipML=[DAN=Angiver det bel�b, der skal udlignes.;
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
                ToolTipML=[DAN=Angiver den dato, hvor bel�bet i posten skal v�re betalt, for at der kan opn�s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Discount Date";
                OnValidate=BEGIN
                             RecalcApplnAmount;
                           END;
                            }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste dato, hvor bel�bet i posten skal v�re betalt, for at der kan opn�s kontantrabattolerance.;
                           ENU=Specifies the latest date the amount in the entry must be paid in order for payment discount tolerance to be granted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Disc. Tolerance Date" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingen for k�bsfakturaen.;
                           ENU=Specifies the payment of the purchase invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Reference" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabat, som du kan opn�, hvis posten bliver udlignet inden kontantrabatdatoen.;
                           ENU=Specifies the discount that you can obtain if the entry is applied to before the payment discount date.];
                ApplicationArea=#Advanced;
                SourceExpr="Original Pmt. Disc. Possible";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tilbagev�rende kontantrabat, som kan opn�s, hvis betalingen finder sted inden forfaldsdatoen for kontantrabatten.;
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
                ToolTipML=[DAN=Angiver den rabat, som du kan opn�, hvis posten bliver udlignet inden kontantrabatdatoen.;
                           ENU=Specifies the discount that you can obtain if the entry is applied to before the payment discount date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcApplnRemainingAmount("Remaining Pmt. Disc. Possible");
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimalt tilladte bel�b, som posten kan afvige fra det bel�b, der er angivet p� fakturaen eller kreditnotaen.;
                           ENU=Specifies the maximum tolerated amount the entry can differ from the amount on the invoice or credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Max. Payment Tolerance" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er helt afregnet, eller om der stadig mangler at blive udlignet et bel�b.;
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

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code" }

    { 41  ;1   ;Group      }

    { 1903222401;2;Group  ;
                GroupType=FixedLayout }

    { 1903866701;3;Group  ;
                CaptionML=[DAN=Udligningsvaluta;
                           ENU=Appln. Currency] }

    { 49  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, som bel�bet udlignes i i forbindelse med forskellige valutaer.;
                           ENU=Specifies the currency code that the amount will be applied in, in case of different currencies.];
                ApplicationArea=#Suite;
                SourceExpr=ApplnCurrencyCode;
                TableRelation=Currency;
                Editable=FALSE;
                ShowCaption=No }

    { 1900545201;3;Group  ;
                CaptionML=[DAN=Bel�b, der skal udlignes;
                           ENU=Amount to Apply] }

    { 45  ;4   ;Field     ;
                Name=AmountToApply;
                CaptionML=[DAN=Bel�b, der skal udlignes;
                           ENU=Amount to Apply];
                ToolTipML=[DAN=Angiver summen af bel�bene p� alle de valgte kreditorposter, der skal udlignes med den post, som vises i feltet Bel�b til r�dighed. Bel�bet er i den valuta, som repr�senteres af koden i feltet Valutakode.;
                           ENU=Specifies the sum of the amounts on all the selected vendor ledger entries that will be applied by the entry shown in the Available Amount field. The amount is in the currency represented by the code in the Currency Code field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedAmount;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1903099901;3;Group  ;
                CaptionML=[DAN=Kontantrabatbel�b;
                           ENU=Pmt. Disc. Amount] }

    { 94  ;4   ;Field     ;
                Name=PmtDiscAmount;
                CaptionML=[DAN=Kontantrabatbel�b;
                           ENU=Pmt. Disc. Amount];
                ToolTipML=[DAN=Angiver summen af kontantrabatbel�b p� alle de valgte kreditorposter, der skal udlignes med den post, som vises i feltet Bel�b til r�dighed. Bel�bet er i den valuta, som repr�senteres af koden i feltet Valutakode.;
                           ENU=Specifies the sum of the payment discount amounts granted on all the selected vendor ledger entries that will be applied by the entry shown in the Available Amount field. The amount is in the currency represented by the code in the Currency Code field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=-PmtDiscAmount;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1901652301;3;Group  ;
                CaptionML=[DAN=Afrunding;
                           ENU=Rounding] }

    { 53  ;4   ;Field     ;
                CaptionML=[DAN=Afrunding;
                           ENU=Rounding];
                ToolTipML=[DAN=Angiver afrundingsdifferencen, n�r poster i forskellige valutaer udlignes med hinanden. Bel�bet er i den valuta, der er repr�senteret af koden i feltet Valutakode.;
                           ENU=Specifies the rounding difference when you apply entries in different currencies to one another. The amount is in the currency represented by the code in the Currency Code field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplnRounding;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1901992701;3;Group  ;
                CaptionML=[DAN=Udligningsbel�b;
                           ENU=Applied Amount] }

    { 98  ;4   ;Field     ;
                Name=AppliedAmount;
                CaptionML=[DAN=Udligningsbel�b;
                           ENU=Applied Amount];
                ToolTipML=[DAN=Angiver summen af bel�bene i feltet Bel�b, der skal udlignes, feltet Kontantrabatbel�b og feltet Afrunding. Bel�bet er i den valuta, som koden i feltet Valutakode repr�senterer.;
                           ENU=Specifies the sum of the amounts in the Amount to Apply field, Pmt. Disc. Amount field, and the Rounding. The amount is in the currency represented by the code in the Currency Code field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedAmount + (-PmtDiscAmount) + ApplnRounding;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1900295601;3;Group  ;
                CaptionML=[DAN=Bel�b til r�dighed;
                           ENU=Available Amount] }

    { 47  ;4   ;Field     ;
                CaptionML=[DAN=Bel�b til r�dighed;
                           ENU=Available Amount];
                ToolTipML=[DAN=Angiver bel�bet i kladdeposten, k�bskreditnotaen eller den aktuelle kreditorpost, som skal udlignes med andre poster.;
                           ENU=Specifies the amount of the journal entry, purchase credit memo, or current vendor ledger entry that you have selected as the applying entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingAmount;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

    { 1901652401;3;Group  ;
                CaptionML=[DAN=Saldo;
                           ENU=Balance] }

    { 43  ;4   ;Field     ;
                Name=ControlBalance;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Viser et eventuelt overskydende bel�b efter udligning.;
                           ENU=Specifies any extra amount that will remain after the application.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedAmount + (-PmtDiscAmount) + ApplyingAmount + ApplnRounding;
                AutoFormatType=1;
                AutoFormatExpr=ApplnCurrencyCode;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      ApplyingVendLedgEntry@1033 : TEMPORARY Record 25;
      AppliedVendLedgEntry@1001 : Record 25;
      Currency@1002 : Record 4;
      CurrExchRate@1003 : Record 330;
      GenJnlLine@1004 : Record 81;
      GenJnlLine2@1005 : Record 81;
      PurchHeader@1006 : Record 38;
      Vend@1007 : Record 23;
      VendLedgEntry@1008 : Record 25;
      GLSetup@1009 : Record 98;
      TotalPurchLine@1010 : Record 39;
      TotalPurchLineLCY@1011 : Record 39;
      VendEntrySetApplID@1013 : Codeunit 111;
      GenJnlApply@1014 : Codeunit 225;
      PurchPost@1015 : Codeunit 90;
      PaymentToleranceMgt@1037 : Codeunit 426;
      Navigate@1012 : Page 344;
      GenJnlLineApply@1016 : Boolean;
      AppliedAmount@1017 : Decimal;
      ApplyingAmount@1018 : Decimal;
      PmtDiscAmount@1040 : Decimal;
      ApplnDate@1019 : Date;
      ApplnCurrencyCode@1020 : Code[10];
      ApplnRoundingPrecision@1021 : Decimal;
      ApplnRounding@1022 : Decimal;
      ApplnType@1023 : ' ,Applies-to Doc. No.,Applies-to ID';
      AmountRoundingPrecision@1024 : Decimal;
      VATAmount@1025 : Decimal;
      VATAmountText@1026 : Text[30];
      StyleTxt@1031 : Text;
      CalcType@1027 : 'Direct,GenJnlLine,PurchHeader';
      VendEntryApplID@1029 : Code[50];
      AppliesToID@1042 : Code[50];
      ValidExchRate@1030 : Boolean;
      DifferentCurrenciesInAppln@1032 : Boolean;
      Text002@1036 : TextConst 'DAN=Du skal v�lge en udlignende post, f�r du kan sende udligningen.;ENU=You must select an applying entry before you can post the application.';
      Text003@1035 : TextConst 'DAN=Du skal sende udligningen fra det vindue, hvor du har angivet den udlignende post.;ENU=You must post the application from the window where you entered the applying entry.';
      CannotSetAppliesToIDErr@1038 : TextConst 'DAN=Du kan ikke angive udlignings-id, mens du v�lger udligningsbilagsnr.;ENU=You cannot set Applies-to ID while selecting Applies-to Doc. No.';
      ShowAppliedEntries@1039 : Boolean;
      OK@1028 : Boolean;
      EarlierPostingDateErr@1034 : TextConst 'DAN=Du kan ikke udligne og bogf�re en post p� en post med en tidligere bogf�ringsdato.\\Du skal i stedet bogf�re dokumentet af type %1 med nummer %2 og derefter udligne det med dokumentet af type %3 med nummer %4.;ENU=You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.';
      PostingDone@1000 : Boolean;
      AppliesToIDVisible@19043506 : Boolean INDATASET;
      ActionPerformed@1104 : Boolean;
      Text012@1043 : TextConst 'DAN=Udligningen er bogf�rt.;ENU=The application was successfully posted.';
      Text013@1044 : TextConst 'DAN=Det %1, som du har angivet, m� ikke v�re f�r %1 p� %2.;ENU=The %1 entered must not be before the %1 on the %2.';
      Text019@1045 : TextConst 'DAN=Efterudligningsprocessen er blevet annulleret.;ENU=Post application process has been canceled.';
      IsOfficeAddin@1041 : Boolean;

    [Internal]
    PROCEDURE SetGenJnlLine@1(NewGenJnlLine@1000 : Record 81;ApplnTypeSelect@1001 : Integer);
    BEGIN
      GenJnlLine := NewGenJnlLine;
      GenJnlLineApply := TRUE;

      IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
        ApplyingAmount := GenJnlLine.Amount;
      IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
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

      SetApplyingVendLedgEntry;
    END;

    [Internal]
    PROCEDURE SetPurch@2(NewPurchHeader@1000 : Record 38;VAR NewVendLedgEntry@1001 : Record 25;ApplnTypeSelect@1002 : Integer);
    BEGIN
      PurchHeader := NewPurchHeader;
      COPYFILTERS(NewVendLedgEntry);

      PurchPost.SumPurchLines(
        PurchHeader,0,TotalPurchLine,TotalPurchLineLCY,
        VATAmount,VATAmountText);

      CASE PurchHeader."Document Type" OF
        PurchHeader."Document Type"::"Return Order",
        PurchHeader."Document Type"::"Credit Memo":
          ApplyingAmount := TotalPurchLine."Amount Including VAT"
        ELSE
          ApplyingAmount := -TotalPurchLine."Amount Including VAT";
      END;

      ApplnDate := PurchHeader."Posting Date";
      ApplnCurrencyCode := PurchHeader."Currency Code";
      CalcType := CalcType::PurchHeader;

      CASE ApplnTypeSelect OF
        PurchHeader.FIELDNO("Applies-to Doc. No."):
          ApplnType := ApplnType::"Applies-to Doc. No.";
        PurchHeader.FIELDNO("Applies-to ID"):
          ApplnType := ApplnType::"Applies-to ID";
      END;

      SetApplyingVendLedgEntry;
    END;

    [External]
    PROCEDURE SetVendLedgEntry@13(NewVendLedgEntry@1000 : Record 25);
    BEGIN
      Rec := NewVendLedgEntry;
    END;

    [Internal]
    PROCEDURE SetApplyingVendLedgEntry@9();
    VAR
      Vendor@1001 : Record 23;
    BEGIN
      CASE CalcType OF
        CalcType::PurchHeader:
          BEGIN
            ApplyingVendLedgEntry."Posting Date" := PurchHeader."Posting Date";
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Return Order" THEN
              ApplyingVendLedgEntry."Document Type" := PurchHeader."Document Type"::"Credit Memo"
            ELSE
              ApplyingVendLedgEntry."Document Type" := PurchHeader."Document Type";
            ApplyingVendLedgEntry."Document No." := PurchHeader."No.";
            ApplyingVendLedgEntry."Vendor No." := PurchHeader."Pay-to Vendor No.";
            ApplyingVendLedgEntry.Description := PurchHeader."Posting Description";
            ApplyingVendLedgEntry."Currency Code" := PurchHeader."Currency Code";
            IF ApplyingVendLedgEntry."Document Type" = ApplyingVendLedgEntry."Document Type"::"Credit Memo" THEN  BEGIN
              ApplyingVendLedgEntry.Amount := TotalPurchLine."Amount Including VAT";
              ApplyingVendLedgEntry."Remaining Amount" := TotalPurchLine."Amount Including VAT";
            END ELSE BEGIN
              ApplyingVendLedgEntry.Amount := -TotalPurchLine."Amount Including VAT";
              ApplyingVendLedgEntry."Remaining Amount" := -TotalPurchLine."Amount Including VAT";
            END;
            CalcApplnAmount;
          END;
        CalcType::Direct:
          BEGIN
            IF "Applying Entry" THEN BEGIN
              IF ApplyingVendLedgEntry."Entry No." <> 0 THEN
                VendLedgEntry := ApplyingVendLedgEntry;
              CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",Rec);
              IF "Applies-to ID" = '' THEN
                SetVendApplId;
              CALCFIELDS(Amount);
              ApplyingVendLedgEntry := Rec;
              IF VendLedgEntry."Entry No." <> 0 THEN BEGIN
                Rec := VendLedgEntry;
                "Applying Entry" := FALSE;
                SetVendApplId;
              END;
              SETFILTER("Entry No.",'<> %1',ApplyingVendLedgEntry."Entry No.");
              ApplyingAmount := ApplyingVendLedgEntry."Remaining Amount";
              ApplnDate := ApplyingVendLedgEntry."Posting Date";
              ApplnCurrencyCode := ApplyingVendLedgEntry."Currency Code";
            END;
            CalcApplnAmount;
          END;
        CalcType::GenJnlLine:
          BEGIN
            ApplyingVendLedgEntry."Posting Date" := GenJnlLine."Posting Date";
            ApplyingVendLedgEntry."Document Type" := GenJnlLine."Document Type";
            ApplyingVendLedgEntry."Document No." := GenJnlLine."Document No.";
            IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN BEGIN
              ApplyingVendLedgEntry."Vendor No." := GenJnlLine."Bal. Account No.";
              Vendor.GET(ApplyingVendLedgEntry."Vendor No.");
              ApplyingVendLedgEntry.Description := Vendor.Name;
            END ELSE BEGIN
              ApplyingVendLedgEntry."Vendor No." := GenJnlLine."Account No.";
              ApplyingVendLedgEntry.Description := GenJnlLine.Description;
            END;
            ApplyingVendLedgEntry."Currency Code" := GenJnlLine."Currency Code";
            ApplyingVendLedgEntry.Amount := GenJnlLine.Amount;
            ApplyingVendLedgEntry."Remaining Amount" := GenJnlLine.Amount;
            CalcApplnAmount;
          END;
      END;
    END;

    [Internal]
    PROCEDURE SetVendApplId@10();
    BEGIN
      IF (CalcType = CalcType::GenJnlLine) AND (ApplyingVendLedgEntry."Posting Date" < "Posting Date") THEN
        ERROR(
          EarlierPostingDateErr,ApplyingVendLedgEntry."Document Type",ApplyingVendLedgEntry."Document No.",
          "Document Type","Document No.");

      IF ApplyingVendLedgEntry."Entry No." <> 0 THEN
        GenJnlApply.CheckAgainstApplnCurrency(
          ApplnCurrencyCode,"Currency Code",GenJnlLine."Account Type"::Vendor,TRUE);

      VendLedgEntry.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(VendLedgEntry);
      IF GenJnlLineApply THEN
        VendEntrySetApplID.SetApplId(VendLedgEntry,ApplyingVendLedgEntry,GenJnlLine."Applies-to ID")
      ELSE
        VendEntrySetApplID.SetApplId(VendLedgEntry,ApplyingVendLedgEntry,PurchHeader."Applies-to ID");

      ActionPerformed := VendLedgEntry."Applies-to ID" <> '';
      CalcApplnAmount;
    END;

    LOCAL PROCEDURE CalcApplnAmount@7();
    BEGIN
      AppliedAmount := 0;
      PmtDiscAmount := 0;
      DifferentCurrenciesInAppln := FALSE;

      CASE CalcType OF
        CalcType::Direct:
          BEGIN
            FindAmountRounding;
            VendEntryApplID := USERID;
            IF VendEntryApplID = '' THEN
              VendEntryApplID := '***';

            VendLedgEntry := ApplyingVendLedgEntry;

            AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
            AppliedVendLedgEntry.SETRANGE("Vendor No.","Vendor No.");
            AppliedVendLedgEntry.SETRANGE(Open,TRUE);
            IF AppliesToID = '' THEN
              AppliedVendLedgEntry.SETRANGE("Applies-to ID",VendEntryApplID)
            ELSE
              AppliedVendLedgEntry.SETRANGE("Applies-to ID",AppliesToID);

            IF ApplyingVendLedgEntry."Entry No." <> 0 THEN BEGIN
              VendLedgEntry.CALCFIELDS("Remaining Amount");
              AppliedVendLedgEntry.SETFILTER("Entry No.",'<>%1',VendLedgEntry."Entry No.");
            END;

            HandlChosenEntries(0,
              VendLedgEntry."Remaining Amount",
              VendLedgEntry."Currency Code",
              VendLedgEntry."Posting Date");
          END;
        CalcType::GenJnlLine:
          BEGIN
            FindAmountRounding;
            IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
              CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",GenJnlLine);

            CASE ApplnType OF
              ApplnType::"Applies-to Doc. No.":
                BEGIN
                  AppliedVendLedgEntry := Rec;
                  WITH AppliedVendLedgEntry DO BEGIN
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

                    IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(
                         GenJnlLine,AppliedVendLedgEntry,0,FALSE) AND
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
                  AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
                  AppliedVendLedgEntry.SETRANGE("Vendor No.",GenJnlLine."Account No.");
                  AppliedVendLedgEntry.SETRANGE(Open,TRUE);
                  AppliedVendLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");

                  HandlChosenEntries(1,
                    GenJnlLine2.Amount,
                    GenJnlLine2."Currency Code",
                    GenJnlLine2."Posting Date");
                END;
            END;
          END;
        CalcType::PurchHeader:
          BEGIN
            FindAmountRounding;

            CASE ApplnType OF
              ApplnType::"Applies-to Doc. No.":
                BEGIN
                  AppliedVendLedgEntry := Rec;
                  WITH AppliedVendLedgEntry DO BEGIN
                    CALCFIELDS("Remaining Amount");

                    IF "Currency Code" <> ApplnCurrencyCode THEN
                      "Remaining Amount" :=
                        CurrExchRate.ExchangeAmtFCYToFCY(
                          ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Amount");

                    AppliedAmount := AppliedAmount + ROUND("Remaining Amount",AmountRoundingPrecision);

                    IF NOT DifferentCurrenciesInAppln THEN
                      DifferentCurrenciesInAppln := ApplnCurrencyCode <> "Currency Code";
                  END;
                  CheckRounding;
                END;
              ApplnType::"Applies-to ID":
                WITH VendLedgEntry DO BEGIN
                  AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
                  AppliedVendLedgEntry.SETRANGE("Vendor No.",PurchHeader."Pay-to Vendor No.");
                  AppliedVendLedgEntry.SETRANGE(Open,TRUE);
                  AppliedVendLedgEntry.SETRANGE("Applies-to ID",PurchHeader."Applies-to ID");

                  HandlChosenEntries(2,
                    ApplyingAmount,
                    ApplnCurrencyCode,
                    ApplnDate);
                END;
            END;
          END;
      END;
    END;

    LOCAL PROCEDURE CalcApplnRemainingAmount@4(Amount@1000 : Decimal) : Decimal;
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

    LOCAL PROCEDURE CalcApplnAmounttoApply@11(AmounttoApply@1000 : Decimal) : Decimal;
    VAR
      ApplnAmountToApply@1001 : Decimal;
    BEGIN
      ValidExchRate := TRUE;

      IF ApplnCurrencyCode = "Currency Code" THEN
        EXIT(AmounttoApply);

      IF ApplnDate = 0D THEN
        ApplnDate := "Posting Date";
      ApplnAmountToApply :=
        CurrExchRate.ApplnExchangeAmtFCYToFCY(
          ApplnDate,"Currency Code",ApplnCurrencyCode,AmounttoApply,ValidExchRate);
      EXIT(ApplnAmountToApply);
    END;

    LOCAL PROCEDURE FindAmountRounding@6();
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
        CalcType::PurchHeader:
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
    PROCEDURE GetVendLedgEntry@5(VAR VendLedgEntry@1000 : Record 25);
    BEGIN
      VendLedgEntry := Rec;
    END;

    LOCAL PROCEDURE FindApplyingEntry@12();
    BEGIN
      IF CalcType = CalcType::Direct THEN BEGIN
        VendEntryApplID := USERID;
        IF VendEntryApplID = '' THEN
          VendEntryApplID := '***';

        VendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open);
        VendLedgEntry.SETRANGE("Vendor No.","Vendor No.");
        IF AppliesToID = '' THEN
          VendLedgEntry.SETRANGE("Applies-to ID",VendEntryApplID)
        ELSE
          VendLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
        VendLedgEntry.SETRANGE(Open,TRUE);
        VendLedgEntry.SETRANGE("Applying Entry",TRUE);
        IF VendLedgEntry.FINDFIRST THEN BEGIN
          VendLedgEntry.CALCFIELDS(Amount,"Remaining Amount");
          ApplyingVendLedgEntry := VendLedgEntry;
          SETFILTER("Entry No.",'<>%1',VendLedgEntry."Entry No.");
          ApplyingAmount := VendLedgEntry."Remaining Amount";
          ApplnDate := VendLedgEntry."Posting Date";
          ApplnCurrencyCode := VendLedgEntry."Currency Code";
        END;
        CalcApplnAmount;
      END;
    END;

    LOCAL PROCEDURE HandlChosenEntries@8(Type@1000 : 'Direct,GenJnlLine,PurchHeader';CurrentAmount@1001 : Decimal;CurrencyCode@1002 : Code[10];PostingDate@1003 : Date);
    VAR
      AppliedVendLedgEntryTemp@1004 : TEMPORARY Record 25;
      PossiblePmtdisc@1007 : Decimal;
      OldPmtdisc@1008 : Decimal;
      CorrectionAmount@1009 : Decimal;
      RemainingAmountExclDiscounts@1012 : Decimal;
      CanUseDisc@1005 : Boolean;
      FromZeroGenJnl@1010 : Boolean;
    BEGIN
      IF AppliedVendLedgEntry.FINDSET(FALSE,FALSE) THEN BEGIN
        REPEAT
          AppliedVendLedgEntryTemp := AppliedVendLedgEntry;
          AppliedVendLedgEntryTemp.INSERT;
        UNTIL AppliedVendLedgEntry.NEXT = 0;
      END ELSE
        EXIT;

      FromZeroGenJnl := (CurrentAmount = 0) AND (Type = Type::GenJnlLine);

      REPEAT
        IF NOT FromZeroGenJnl THEN
          AppliedVendLedgEntryTemp.SETRANGE(Positive,CurrentAmount < 0);
        IF AppliedVendLedgEntryTemp.FINDFIRST THEN BEGIN
          ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,AppliedVendLedgEntryTemp,PostingDate);

          CASE Type OF
            Type::Direct:
              CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscVend(VendLedgEntry,AppliedVendLedgEntryTemp,0,FALSE,FALSE);
            Type::GenJnlLine:
              CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine2,AppliedVendLedgEntryTemp,0,FALSE)
            ELSE
              CanUseDisc := FALSE;
          END;

          IF CanUseDisc AND
             (ABS(AppliedVendLedgEntryTemp."Amount to Apply") >= ABS(AppliedVendLedgEntryTemp."Remaining Amount" -
                AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
          THEN BEGIN
            IF (ABS(CurrentAmount) > ABS(AppliedVendLedgEntryTemp."Remaining Amount" -
                  AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
            THEN BEGIN
              PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
              CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
            END ELSE
              IF (ABS(CurrentAmount) = ABS(AppliedVendLedgEntryTemp."Remaining Amount" -
                    AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible"))
              THEN BEGIN
                PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible" ;
                CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                  AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                AppliedAmount := AppliedAmount + CorrectionAmount;
              END ELSE
                IF FromZeroGenJnl THEN BEGIN
                  PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  CurrentAmount := CurrentAmount +
                    AppliedVendLedgEntryTemp."Remaining Amount" - AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                END ELSE BEGIN
                  PossiblePmtdisc := AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                  RemainingAmountExclDiscounts := AppliedVendLedgEntryTemp."Remaining Amount" - PossiblePmtdisc -
                    AppliedVendLedgEntryTemp."Max. Payment Tolerance";
                  IF ABS(CurrentAmount) + ABS(CalcOppositeEntriesAmount(AppliedVendLedgEntryTemp)) >= ABS(RemainingAmountExclDiscounts)
                  THEN BEGIN
                    PmtDiscAmount := PmtDiscAmount + PossiblePmtdisc;
                    AppliedAmount := AppliedAmount + CorrectionAmount;
                  END;
                  CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Remaining Amount" -
                    AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                END;
          END ELSE BEGIN
            IF ((CurrentAmount + AppliedVendLedgEntryTemp."Amount to Apply") * CurrentAmount) >= 0 THEN
              AppliedAmount := AppliedAmount + CorrectionAmount;
            CurrentAmount := CurrentAmount + AppliedVendLedgEntryTemp."Amount to Apply";
          END;
        END ELSE BEGIN
          AppliedVendLedgEntryTemp.SETRANGE(Positive);
          AppliedVendLedgEntryTemp.FINDFIRST;
          ExchangeAmountsOnLedgerEntry(Type,CurrencyCode,AppliedVendLedgEntryTemp,PostingDate);
        END;

        IF OldPmtdisc <> PmtDiscAmount THEN
          AppliedAmount := AppliedAmount + AppliedVendLedgEntryTemp."Remaining Amount"
        ELSE
          AppliedAmount := AppliedAmount + AppliedVendLedgEntryTemp."Amount to Apply";
        OldPmtdisc := PmtDiscAmount;

        IF PossiblePmtdisc <> 0 THEN
          CorrectionAmount := AppliedVendLedgEntryTemp."Remaining Amount" - AppliedVendLedgEntryTemp."Amount to Apply"
        ELSE
          CorrectionAmount := 0;

        IF NOT DifferentCurrenciesInAppln THEN
          DifferentCurrenciesInAppln := ApplnCurrencyCode <> AppliedVendLedgEntryTemp."Currency Code";

        AppliedVendLedgEntryTemp.DELETE;
        AppliedVendLedgEntryTemp.SETRANGE(Positive);

      UNTIL NOT AppliedVendLedgEntryTemp.FINDFIRST;
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
      VendEntryApplyPostedEntries@1000 : Codeunit 227;
      PostApplication@1002 : Page 579;
      Applied@1006 : Boolean;
      ApplicationDate@1001 : Date;
      NewApplicationDate@1003 : Date;
      NewDocumentNo@1004 : Code[20];
    BEGIN
      IF CalcType = CalcType::Direct THEN BEGIN
        IF ApplyingVendLedgEntry."Entry No." <> 0 THEN BEGIN
          Rec := ApplyingVendLedgEntry;
          ApplicationDate := VendEntryApplyPostedEntries.GetApplicationDate(Rec);

          PostApplication.SetValues("Document No.",ApplicationDate);
          IF ACTION::OK = PostApplication.RUNMODAL THEN BEGIN
            PostApplication.GetValues(NewDocumentNo,NewApplicationDate);
            IF NewApplicationDate < ApplicationDate THEN
              ERROR(Text013,FIELDCAPTION("Posting Date"),TABLECAPTION);
          END ELSE
            ERROR(Text019);

          IF PreviewMode THEN
            VendEntryApplyPostedEntries.PreviewApply(Rec,NewDocumentNo,NewApplicationDate)
          ELSE
            Applied := VendEntryApplyPostedEntries.Apply(Rec,NewDocumentNo,NewApplicationDate);

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

    LOCAL PROCEDURE CheckActionPerformed@1011() : Boolean;
    BEGIN
      IF ActionPerformed THEN
        EXIT(FALSE);
      IF (NOT (CalcType = CalcType::Direct) AND NOT OK AND NOT PostingDone) OR
         (ApplnType = ApplnType::"Applies-to Doc. No.")
      THEN
        EXIT(FALSE);
      EXIT((CalcType = CalcType::Direct) AND NOT OK AND NOT PostingDone);
    END;

    [External]
    PROCEDURE SetAppliesToID@1031(AppliesToID2@1043 : Code[50]);
    BEGIN
      AppliesToID := AppliesToID2;
    END;

    LOCAL PROCEDURE ExchangeAmountsOnLedgerEntry@14(Type@1000 : 'Direct,GenJnlLine,PurchHeader';CurrencyCode@1001 : Code[10];VAR CalcVendLedgEntry@1002 : Record 25;PostingDate@1004 : Date);
    VAR
      CalculateCurrency@1003 : Boolean;
    BEGIN
      CalcVendLedgEntry.CALCFIELDS("Remaining Amount");

      IF Type = Type::Direct THEN
        CalculateCurrency := ApplyingVendLedgEntry."Entry No." <> 0
      ELSE
        CalculateCurrency := TRUE;

      IF (CurrencyCode <> CalcVendLedgEntry."Currency Code") AND CalculateCurrency THEN BEGIN
        CalcVendLedgEntry."Remaining Amount" :=
          CurrExchRate.ExchangeAmount(
            CalcVendLedgEntry."Remaining Amount",
            CalcVendLedgEntry."Currency Code",
            CurrencyCode,PostingDate);
        CalcVendLedgEntry."Remaining Pmt. Disc. Possible" :=
          CurrExchRate.ExchangeAmount(
            CalcVendLedgEntry."Remaining Pmt. Disc. Possible",
            CalcVendLedgEntry."Currency Code",
            CurrencyCode,PostingDate);
        CalcVendLedgEntry."Amount to Apply" :=
          CurrExchRate.ExchangeAmount(
            CalcVendLedgEntry."Amount to Apply",
            CalcVendLedgEntry."Currency Code",
            CurrencyCode,PostingDate);
      END;
    END;

    LOCAL PROCEDURE CalcOppositeEntriesAmount@17(VAR TempAppliedVendorLedgerEntry@1000 : TEMPORARY Record 25) Result : Decimal;
    VAR
      SavedAppliedVendorLedgerEntry@1002 : Record 25;
      CurrPosFilter@1001 : Text;
    BEGIN
      WITH TempAppliedVendorLedgerEntry DO BEGIN
        CurrPosFilter := GETFILTER(Positive);
        IF CurrPosFilter <> '' THEN BEGIN
          SavedAppliedVendorLedgerEntry := TempAppliedVendorLedgerEntry;
          SETRANGE(Positive,NOT Positive);
          IF FINDSET THEN
            REPEAT
              CALCFIELDS("Remaining Amount");
              Result += "Remaining Amount";
            UNTIL NEXT = 0;
          SETFILTER(Positive,CurrPosFilter);
          TempAppliedVendorLedgerEntry := SavedAppliedVendorLedgerEntry;
        END;
      END;
    END;

    BEGIN
    END.
  }
}

