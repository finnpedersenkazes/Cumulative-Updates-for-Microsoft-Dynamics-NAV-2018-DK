OBJECT Page 127 Det. Cust. Ledg. Entr. Preview
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
    CaptionML=[DAN=Vis detaljerede debitorposter;
               ENU=Detailed Cust. Ledg. Entries Preview];
    SourceTable=Table379;
    DataCaptionFields=Cust. Ledger Entry No.,Customer No.;
    PageType=List;
    SourceTableTemporary=Yes;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for den detaljerede debitorpost.;
                           ENU=Specifies the posting date of the detailed customer ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver posttypen for den detaljerede debitorpost.;
                           ENU=Specifies the entry type of the detailed customer ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagstypen for den detaljerede debitorpost.;
                           ENU=Specifies the document type of the detailed customer ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for den transaktion, der oprettede posten.;
                           ENU=Specifies the document number of the transaction that created the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitorkonto, som posten er bogf›rt p†.;
                           ENU=Specifies the customer account number to which the entry is posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer No." }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Global Dimension 1-koden for startdebitorposten.;
                           ENU=Specifies the Global Dimension 1 code of the initial customer ledger entry.];
                ApplicationArea=#Dimensions;
                SourceExpr="Initial Entry Global Dim. 1";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Global Dimension 2-koden for startdebitorposten.;
                           ENU=Specifies the Global Dimension 2 code of the initial customer ledger entry.];
                ApplicationArea=#Dimensions;
                SourceExpr="Initial Entry Global Dim. 2";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for valutaen, hvis bel›bet er i udenlandsk valuta.;
                           ENU=Specifies the code for the currency if the amount is in a foreign currency.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for den detaljerede debitorpost.;
                           ENU=Specifies the amount of the detailed customer ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten i regnskabsvalutaen.;
                           ENU=Specifies the amount of the entry in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount (LCY)" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent debits, expressed in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount (LCY)";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent credits, expressed in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount (LCY)";
                Visible=FALSE }

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

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om udligningen af posten er blevet annulleret fra vinduet Annuller udligning af debitorposter ved hj‘lp af postnummeret i feltet Udlign. annulleret af l›benr.;
                           ENU=Specifies whether the entry has been unapplied (undone) from the Unapply Customer Entries window by the entry no. shown in the Unapplied by Entry No. field.];
                ApplicationArea=#Advanced;
                SourceExpr=Unapplied;
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for korrektionsposten, hvis udligningen af den oprindelige post er blevet fortrudt fra vinduet Annuller udligning af debitorposter.;
                           ENU=Specifies the number of the correcting entry, if the original entry has been unapplied (undone) from the Unapply Customer Entries window.];
                ApplicationArea=#Advanced;
                SourceExpr="Unapplied by Entry No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l›benummeret p† den debitorpost, som den detaljerede debitorpostlinje er oprettet for.;
                           ENU=Specifies the entry number of the customer ledger entry that the detailed customer ledger entry line was created for.];
                ApplicationArea=#Advanced;
                SourceExpr="Cust. Ledger Entry No.";
                Visible=FALSE }

  }
  CODE
  {

    [External]
    PROCEDURE Set@1(VAR TempDtldCustLedgEntry@1001 : TEMPORARY Record 379);
    BEGIN
      IF TempDtldCustLedgEntry.FINDSET THEN
        REPEAT
          Rec := TempDtldCustLedgEntry;
          INSERT;
        UNTIL TempDtldCustLedgEntry.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

