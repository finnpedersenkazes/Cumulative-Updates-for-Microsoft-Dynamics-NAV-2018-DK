OBJECT Page 128 Vend. Ledg. Entries Preview
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Vis kreditorposter;
               ENU=Vendor Entries Preview];
    SourceTable=Table25;
    DataCaptionFields=Vendor No.;
    PageType=List;
    SourceTableTemporary=Yes;
    OnAfterGetRecord=BEGIN
                       StyleTxt := SetStyle;
                       CalcAmounts(AmountFCY,AmountLCY,RemainingAmountFCY,RemainingAmountLCY,OriginalAmountFCY,OriginalAmountLCY);
                     END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 5       ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 GenJnlPostPreview@1000 : Codeunit 19;
                               BEGIN
                                 GenJnlPostPreview.ShowDimensions(DATABASE::"Vendor Ledger Entry","Entry No.","Dimension Set ID");
                               END;
                                }
      { 25      ;2   ;Action    ;
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

    { 9   ;2   ;Field     ;
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
                SourceExpr="Currency Code" }

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
                CaptionML=[DAN=Oprindeligt bel›b;
                           ENU=Original Amount];
                ToolTipML=[DAN=Angiver bel›bet p† kreditorposten, f›r du bogf›rer.;
                           ENU=Specifies the amount on the vendor ledger entry before you post.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=OriginalAmountFCY;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrilldownAmounts(2);
                            END;
                             }

    { 56  ;2   ;Field     ;
                CaptionML=[DAN=Oprindeligt bel›b (RV);
                           ENU=Original Amount (LCY)];
                ToolTipML=[DAN=Angiver det oprindelige bel›b, som er knyttet til kreditorposten, i den lokale valuta.;
                           ENU=Specifies the original amount linked to the vendor ledger entry, in local currency.];
                ApplicationArea=#Advanced;
                SourceExpr=OriginalAmountLCY;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrilldownAmounts(2);
                            END;
                             }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Bel›b;
                           ENU=Amount];
                ToolTipML=[DAN=Angiver nettobel›bet for alle linjer i kreditorposten.;
                           ENU=Specifies the net amount of all the lines in the vendor entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AmountFCY;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrilldownAmounts(0);
                            END;
                             }

    { 47  ;2   ;Field     ;
                CaptionML=[DAN=Bel›b (RV);
                           ENU=Amount (LCY)];
                ToolTipML=[DAN=Angiver bel›bet i finansposten i den lokale valuta.;
                           ENU=Specifies the amount of the ledger entry, in the local currency.];
                ApplicationArea=#Advanced;
                SourceExpr=AmountLCY;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrilldownAmounts(0);
                            END;
                             }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent debits, expressed in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Debit Amount (LCY)";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent credits, expressed in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Credit Amount (LCY)";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Restbel›b;
                           ENU=Remaining Amount];
                ToolTipML=[DAN=Angiver det resterende bel›b p† kreditorposten, f›r du bogf›rer.;
                           ENU=Specifies the remaining amount on the vendor ledger entry before you post.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=RemainingAmountFCY;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrilldownAmounts(1);
                            END;
                             }

    { 49  ;2   ;Field     ;
                CaptionML=[DAN=Restbel›b (RV);
                           ENU=Remaining Amount (LCY)];
                ToolTipML=[DAN="Angiver det resterende bel›b, som er knyttet til kreditorposten p† linjen, i den lokale valuta. ";
                           ENU="Specifies the remaining amount linked to the vendor ledger entry on the line, in local currency. "];
                ApplicationArea=#Advanced;
                SourceExpr=RemainingAmountLCY;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrilldownAmounts(1);
                            END;
                             }

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

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er helt afregnet, eller om der stadig mangler at blive udlignet et bel›b.;
                           ENU=Specifies whether the amount on the entry has been fully paid or there is still a remaining amount that must be applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Open }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den tilknyttede post repr‘senterer en ubetalt faktura, som der findes et betalingsforslag, en rykker eller en rentenota til.;
                           ENU=Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="On Hold" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at posten blev oprettet ved eksport af en betalingskladdelinje.;
                           ENU=Specifies that the entry was created as a result of exporting a payment journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Exported to Payment File" }

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

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv‘rdier. De faktiske v‘rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension Set ID";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      TempDetailedVendLedgEntry@1002 : TEMPORARY Record 380;
      DimensionSetIDFilter@1008 : Page 481;
      StyleTxt@1001 : Text;
      AmountFCY@1007 : Decimal;
      AmountLCY@1006 : Decimal;
      RemainingAmountFCY@1005 : Decimal;
      RemainingAmountLCY@1004 : Decimal;
      OriginalAmountLCY@1003 : Decimal;
      OriginalAmountFCY@1000 : Decimal;

    [External]
    PROCEDURE Set@4(VAR TempVendLedgerEntry@1000 : TEMPORARY Record 25;VAR TempDetailedVendLedgEntry2@1001 : TEMPORARY Record 380);
    BEGIN
      IF TempVendLedgerEntry.FINDSET THEN
        REPEAT
          Rec := TempVendLedgerEntry;
          INSERT;
        UNTIL TempVendLedgerEntry.NEXT = 0;

      IF TempDetailedVendLedgEntry2.FINDSET THEN
        REPEAT
          TempDetailedVendLedgEntry := TempDetailedVendLedgEntry2;
          TempDetailedVendLedgEntry.INSERT;
        UNTIL TempDetailedVendLedgEntry2.NEXT = 0;
    END;

    LOCAL PROCEDURE CalcAmounts@2(VAR AmountFCY@1000 : Decimal;VAR AmountLCY@1001 : Decimal;VAR RemainingAmountFCY@1002 : Decimal;VAR RemainingAmountLCY@1003 : Decimal;VAR OriginalAmountFCY@1004 : Decimal;VAR OriginalAmountLCY@1005 : Decimal);
    BEGIN
      AmountFCY := 0;
      AmountLCY := 0;
      RemainingAmountLCY := 0;
      RemainingAmountFCY := 0;
      OriginalAmountLCY := 0;
      OriginalAmountFCY := 0;

      TempDetailedVendLedgEntry.SETRANGE("Vendor Ledger Entry No.","Entry No.");
      IF TempDetailedVendLedgEntry.FINDSET THEN
        REPEAT
          IF TempDetailedVendLedgEntry."Entry Type" = TempDetailedVendLedgEntry."Entry Type"::"Initial Entry" THEN BEGIN
            OriginalAmountFCY += TempDetailedVendLedgEntry.Amount;
            OriginalAmountLCY += TempDetailedVendLedgEntry."Amount (LCY)";
          END;
          IF NOT (TempDetailedVendLedgEntry."Entry Type" IN [TempDetailedVendLedgEntry."Entry Type"::Application,
                                                             TempDetailedVendLedgEntry."Entry Type"::"Appln. Rounding"])
          THEN BEGIN
            AmountFCY += TempDetailedVendLedgEntry.Amount;
            AmountLCY += TempDetailedVendLedgEntry."Amount (LCY)";
          END;
          RemainingAmountFCY += TempDetailedVendLedgEntry.Amount;
          RemainingAmountLCY += TempDetailedVendLedgEntry."Amount (LCY)";
        UNTIL TempDetailedVendLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE DrilldownAmounts@3(AmountType@1000 : 'Amount,Remaining Amount,Original Amount');
    VAR
      DetailedVendEntriesPreview@1001 : Page 129;
    BEGIN
      CASE AmountType OF
        AmountType::Amount:
          TempDetailedVendLedgEntry.SETFILTER("Entry Type",'<>%1&<>%2',
            TempDetailedVendLedgEntry."Entry Type"::Application,TempDetailedVendLedgEntry."Entry Type"::"Appln. Rounding");
        AmountType::"Original Amount":
          TempDetailedVendLedgEntry.SETRANGE("Entry Type",TempDetailedVendLedgEntry."Entry Type"::"Initial Entry");
        AmountType::"Remaining Amount":
          TempDetailedVendLedgEntry.SETRANGE("Entry Type");
      END;
      DetailedVendEntriesPreview.Set(TempDetailedVendLedgEntry);
      DetailedVendEntriesPreview.RUNMODAL;
      CLEAR(DetailedVendEntriesPreview);
    END;

    BEGIN
    END.
  }
}

