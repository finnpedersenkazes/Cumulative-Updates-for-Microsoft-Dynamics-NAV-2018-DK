OBJECT Page 574 Detailed Vendor Ledg. Entries
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Detaljerede kreditorposter;
               ENU=Detailed Vendor Ledg. Entries];
    InsertAllowed=No;
    SourceTable=Table380;
    DataCaptionFields=Vendor Ledger Entry No.,Vendor No.;
    PageType=List;
    OnInit=BEGIN
             AmountVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 SetConrolVisibility;
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 29      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Annuller udligning;
                                 ENU=Unapply Entries];
                      ToolTipML=[DAN=Frav‘lg en eller flere finansposter, der ikke skal anvendes p† denne record.;
                                 ENU=Unselect one or more ledger entries that you want to unapply this record.];
                      ApplicationArea=#Basic,#Suite;
                      Image=UnApply;
                      OnAction=VAR
                                 VendEntryApplyPostedEntries@1000 : Codeunit 227;
                               BEGIN
                                 VendEntryApplyPostedEntries.UnApplyDtldVendLedgEntry(Rec);
                               END;
                                }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=N&aviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
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

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for den detaljerede kreditorpost.;
                           ENU=Specifies the posting date of the detailed vendor ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver posttypen for den detaljerede kreditorpost.;
                           ENU=Specifies the entry type of the detailed vendor ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagstypen for den detaljerede kreditorpost.;
                           ENU=Specifies the document type of the detailed vendor ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for den transaktion, der oprettede posten.;
                           ENU=Specifies the document number of the transaction that created the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditorkonto, som posten er bogf›rt p†.;
                           ENU=Specifies the number of the vendor account to which the entry is posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor No." }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Global Dimension 1-koden for startkreditorposten.;
                           ENU=Specifies the Global Dimension 1 code of the initial vendor ledger entry.];
                ApplicationArea=#Dimensions;
                SourceExpr="Initial Entry Global Dim. 1";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Global Dimension 2-koden for startkreditorposten.;
                           ENU=Specifies the Global Dimension 2 code of the initial vendor ledger entry.];
                ApplicationArea=#Dimensions;
                SourceExpr="Initial Entry Global Dim. 2";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for valutaen, hvis bel›bet er i udenlandsk valuta.;
                           ENU=Specifies the code for the currency if the amount is in a foreign currency.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for den detaljerede kreditorpost.;
                           ENU=Specifies the amount of the detailed vendor ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                Visible=AmountVisible;
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten i regnskabsvalutaen.;
                           ENU=Specifies the amount of the entry in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount (LCY)";
                Visible=AmountVisible }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=DebitCreditVisible }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent debits, expressed in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount (LCY)";
                Visible=DebitCreditVisible }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=DebitCreditVisible }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent credits, expressed in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount (LCY)";
                Visible=DebitCreditVisible }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor startposten er forfalden til betaling.;
                           ENU=Specifies the date on which the initial entry is due for payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Initial Entry Due Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om udligningen af posten er blevet annulleret fra vinduet Annuller udlign. af kred.poster ved hj‘lp af postnummeret i feltet Udlign. annulleret af l›benr.;
                           ENU=Specifies whether the entry has been unapplied (undone) from the Unapply Vendor Entries window by the entry no. shown in the Unapplied by Entry No. field.];
                ApplicationArea=#Advanced;
                SourceExpr=Unapplied;
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for korrektionsposten, hvis udligningen af den oprindelige post er blevet fortrudt fra vinduet Annuller udlign. af kred.poster.;
                           ENU=Specifies the number of the correcting entry, if the original entry has been unapplied (undone) from the Unapply Vendor Entries window.];
                ApplicationArea=#Advanced;
                SourceExpr="Unapplied by Entry No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l›benummeret p† den kreditorpost, som den detaljerede kreditorpost er oprettet for.;
                           ENU=Specifies the entry number of the vendor ledger entry that the detailed vendor ledger entry line was created for.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Ledger Entry No.";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No." }

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
      Navigate@1000 : Page 344;
      AmountVisible@1002 : Boolean;
      DebitCreditVisible@1001 : Boolean;

    LOCAL PROCEDURE SetConrolVisibility@8();
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

