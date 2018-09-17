OBJECT Page 179 Reverse Entries
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tilbagef›r poster;
               ENU=Reverse Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table179;
    DataCaptionExpr=Caption;
    PageType=List;
    OnInit=BEGIN
             DescriptionEditable := TRUE;
           END;

    OnOpenPage=BEGIN
                 InitializeFilter;
               END;

    OnAfterGetCurrRecord=BEGIN
                           DescriptionEditable := "Entry Type" <> "Entry Type"::VAT;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 48      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 49      ;2   ;Action    ;
                      CaptionML=[DAN=Finansposter;
                                 ENU=General Ledger];
                      ToolTipML=[DAN=F† vist poteringer, du har foretaget i finansmodulet.;
                                 ENU=View postings that you have made in general ledger.];
                      ApplicationArea=#Basic,#Suite;
                      Image=GLRegisters;
                      OnAction=BEGIN
                                 ReversalEntry.ShowGLEntries;
                               END;
                                }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=Debitorposter;
                                 ENU=Customer Ledger];
                      ToolTipML=[DAN=F† vist poteringer, du har foretaget i debitormodulet.;
                                 ENU=View postings that you have made in customer ledger.];
                      ApplicationArea=#Basic,#Suite;
                      Image=CustomerLedger;
                      OnAction=BEGIN
                                 ReversalEntry.ShowCustLedgEntries;
                               END;
                                }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=Kreditorposter;
                                 ENU=Vendor Ledger];
                      ToolTipML=[DAN=F† vist poteringer, du har foretaget i kreditormodulet.;
                                 ENU=View postings that you have made in vendor ledger.];
                      ApplicationArea=#Basic,#Suite;
                      Image=VendorLedger;
                      OnAction=BEGIN
                                 ReversalEntry.ShowVendLedgEntries;
                               END;
                                }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkontoposter;
                                 ENU=Bank Account Ledger];
                      ToolTipML=[DAN=F† vist poteringer, du har foretaget i bankmodulet.;
                                 ENU=View postings that you have made in bank account ledger.];
                      ApplicationArea=#Basic,#Suite;
                      Image=BankAccountLedger;
                      OnAction=BEGIN
                                 ReversalEntry.ShowBankAccLedgEntries;
                               END;
                                }
      { 53      ;2   ;Action    ;
                      CaptionML=[DAN=Anl‘gsposter;
                                 ENU=Fixed Asset Ledger];
                      ToolTipML=[DAN=Vis tilbagef›rsler, du har foretaget vedr›rende anl‘g.;
                                 ENU=View reversal postings that you have made involving fixed assets.];
                      ApplicationArea=#FixedAssets;
                      Image=FixedAssetLedger;
                      OnAction=BEGIN
                                 ReversalEntry.ShowFALedgEntries;
                               END;
                                }
      { 54      ;2   ;Action    ;
                      CaptionML=[DAN=Reparationsposter;
                                 ENU=Maintenance Ledger];
                      ToolTipML=[DAN=F† vist poteringer, du har foretaget i vedligeholdelsesmodulet.;
                                 ENU=View postings that you have made in maintenance ledger.];
                      ApplicationArea=#Basic,#Suite;
                      Image=MaintenanceLedgerEntries;
                      OnAction=BEGIN
                                 ReversalEntry.ShowMaintenanceLedgEntries;
                               END;
                                }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=Momsposter;
                                 ENU=VAT Ledger];
                      ToolTipML=[DAN=F† vist poteringer, du har foretaget i momsmodulet.;
                                 ENU=View postings that you have made in Tax ledger.];
                      ApplicationArea=#Basic,#Suite;
                      Image=VATLedger;
                      OnAction=BEGIN
                                 ReversalEntry.ShowVATEntries;
                               END;
                                }
      { 3       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Tilbagef›rsel;
                                 ENU=Re&versing];
                      Image=Restore }
      { 46      ;2   ;Action    ;
                      Name=Reverse;
                      ShortCutKey=F9;
                      CaptionML=[DAN=Tilbagef›r;
                                 ENU=Reverse];
                      ToolTipML=[DAN=Tilbagef›r de valgte poster.;
                                 ENU=Reverse selected entries.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Undo;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Post(FALSE);
                               END;
                                }
      { 58      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Tilbagef›r og &udskriv;
                                 ENU=Reverse and &Print];
                      ToolTipML=[DAN=Tilbagef›r og udskriv de valgte poster.;
                                 ENU=Reverse and print selected entries.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Undo;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Post(TRUE);
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

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilbagef›rte transaktion.;
                           ENU=Specifies the number of the transaction that was reversed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction No.";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetEntryTypeText;
                CaptionClass=FIELDCAPTION("Entry Type");
                Editable=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer, den tilbagef›rte poste var bogf›rt p†.;
                           ENU=Specifies the account number that the reversal was posted to.];
                ApplicationArea=#Advanced;
                SourceExpr="Account No.";
                Editable=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forkerte posteringer, som du gerne vil fortryde ved hj‘lp af funktionen Tilbagef›r.;
                           ENU=Specifies erroneous postings that you want to undo by using the Reverse function.];
                ApplicationArea=#Advanced;
                SourceExpr="Account Name";
                Visible=FALSE;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No.";
                Editable=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af recorden.;
                           ENU=Specifies a description of the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Editable=DescriptionEditable }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken bilagstype posten tilh›rer.;
                           ENU=Specifies the document type that the entry belongs to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type";
                Editable=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for den transaktion, der oprettede posten.;
                           ENU=Specifies the document number of the transaction that created the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten i regnskabsvalutaen.;
                           ENU=Specifies the amount of the entry in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount (LCY)";
                Editable=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsbel›bet, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of VAT that is included in the total amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Amount";
                Editable=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent debits, expressed in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Debit Amount (LCY)";
                Visible=FALSE;
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent credits, expressed in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Credit Amount (LCY)";
                Visible=FALSE;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finansjournal, hvor finansposten i denne record blev bogf›rt.;
                           ENU=Specifies the number of the general ledger register, where the general ledger entry in this record was posted.];
                ApplicationArea=#Advanced;
                SourceExpr="G/L Register No.";
                Visible=FALSE;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som posterne blev bogf›rt fra.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Journal Batch Name";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kildetype, der g‘lder for det kildenummer, som vises i feltet Kildenr.;
                           ENU=Specifies the source type that applies to the source number that is shown in the Source No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Type";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor posten stammer fra.;
                           ENU=Specifies where the entry originated.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source No.";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel›bet p† linjen.;
                           ENU=Specifies the currency code for the amount on the line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Editable=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf›res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account Type";
                Editable=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf›res til, f.eks. en kassekonto ved kontantk›b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account No.";
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet i den post, der skal tilbagef›res.;
                           ENU=Specifies the amount on the entry to be reversed.];
                ApplicationArea=#Advanced;
                SourceExpr=Amount;
                Visible=FALSE;
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Advanced;
                SourceExpr="Debit Amount";
                Visible=FALSE;
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Advanced;
                SourceExpr="Credit Amount";
                Visible=FALSE;
                Editable=FALSE }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringskategori, der bruges til anl‘gsaktiver.;
                           ENU=Specifies the posting category that is used for fixed assets.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="FA Posting Category";
                Editable=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringstypen, hvis feltet Kontotype indeholder Anl‘gsaktiv.;
                           ENU=Specifies the posting type, if Account Type field contains Fixed Asset.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="FA Posting Type";
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

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
      Text000@1005 : TextConst 'DAN=Tilbagef›r transaktionsposter;ENU=Reverse Transaction Entries';
      Text001@1006 : TextConst 'DAN=Tilbagef›r journalposter;ENU=Reverse Register Entries';
      ReversalEntry@1002 : Record 179;
      DescriptionEditable@19061412 : Boolean INDATASET;

    LOCAL PROCEDURE Post@2(PrintRegister@1000 : Boolean);
    VAR
      ReversalPost@1001 : Codeunit 179;
    BEGIN
      ReversalPost.SetPrint(PrintRegister);
      ReversalPost.RUN(Rec);
      CurrPage.UPDATE(FALSE);
      CurrPage.CLOSE;
    END;

    LOCAL PROCEDURE GetEntryTypeText@3() : Text[1024];
    VAR
      GLEntry@1008 : Record 17;
      CustLedgEntry@1007 : Record 21;
      VendLedgEntry@1006 : Record 25;
      EmployeeLedgerEntry@1000 : Record 5222;
      BankAccLedgEntry@1005 : Record 271;
      FALedgEntry@1004 : Record 5601;
      MaintenanceLedgEntry@1003 : Record 5625;
      VATEntry@1002 : Record 254;
    BEGIN
      CASE "Entry Type" OF
        "Entry Type"::"G/L Account":
          EXIT(GLEntry.TABLECAPTION);
        "Entry Type"::Customer:
          EXIT(CustLedgEntry.TABLECAPTION);
        "Entry Type"::Vendor:
          EXIT(VendLedgEntry.TABLECAPTION);
        "Entry Type"::Employee:
          EXIT(EmployeeLedgerEntry.TABLECAPTION);
        "Entry Type"::"Bank Account":
          EXIT(BankAccLedgEntry.TABLECAPTION);
        "Entry Type"::"Fixed Asset":
          EXIT(FALedgEntry.TABLECAPTION);
        "Entry Type"::Maintenance:
          EXIT(MaintenanceLedgEntry.TABLECAPTION);
        "Entry Type"::VAT:
          EXIT(VATEntry.TABLECAPTION);
        ELSE
          EXIT(FORMAT("Entry Type"));
      END;
    END;

    LOCAL PROCEDURE InitializeFilter@1();
    BEGIN
      FINDFIRST;
      ReversalEntry := Rec;
      IF "Reversal Type" = "Reversal Type"::Transaction THEN BEGIN
        CurrPage.CAPTION := Text000;
        ReversalEntry.SetReverseFilter("Transaction No.","Reversal Type");
      END ELSE BEGIN
        CurrPage.CAPTION := Text001;
        ReversalEntry.SetReverseFilter("G/L Register No.","Reversal Type");
      END;
    END;

    BEGIN
    END.
  }
}

