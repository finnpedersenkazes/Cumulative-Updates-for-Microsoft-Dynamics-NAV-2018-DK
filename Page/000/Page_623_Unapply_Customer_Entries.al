OBJECT Page 623 Unapply Customer Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Annuller udligning af debitorposter;
               ENU=Unapply Customer Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table379;
    DataCaptionExpr=Caption;
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 InsertEntries;
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 42      ;1   ;Action    ;
                      Name=Unapply;
                      CaptionML=[DAN=Ann&uller udligning;
                                 ENU=&Unapply];
                      ToolTipML=[DAN=Frav‘lg en eller flere finansposter, der ikke skal anvendes p† denne record.;
                                 ENU=Unselect one or more ledger entries that you want to unapply this record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=UnApply;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CustEntryApplyPostedEntries@1000 : Codeunit 226;
                               BEGIN
                                 IF ISEMPTY THEN
                                   ERROR(Text010);
                                 IF NOT CONFIRM(Text011,FALSE) THEN
                                   EXIT;

                                 CustEntryApplyPostedEntries.PostUnApplyCustomer(DtldCustLedgEntry2,DocNo,PostingDate);
                                 PostingDate := 0D;
                                 DocNo := '';
                                 DELETEALL;
                                 MESSAGE(Text009);

                                 CurrPage.CLOSE;
                               END;
                                }
      { 3       ;1   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis annulleret udligning;
                                 ENU=Preview Unapply];
                      ToolTipML=[DAN=Se et eksempel p† annullering af udligningen af en eller flere poster.;
                                 ENU=Preview how unapplying one or more ledger entries will look like.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ViewPostedOrder;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CustEntryApplyPostedEntries@1000 : Codeunit 226;
                               BEGIN
                                 IF ISEMPTY THEN
                                   ERROR(Text010);

                                 CustEntryApplyPostedEntries.PreviewUnapply(DtldCustLedgEntry2,DocNo,PostingDate);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 33  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 34  ;2   ;Field     ;
                Name=DocuNo;
                CaptionML=[DAN=Bilagsnr.;
                           ENU=Document No.];
                ToolTipML=[DAN=Angiver bilagsnummeret for den post, hvor udligningen skal annulleres.;
                           ENU=Specifies the document number of the entry to be unapplied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DocNo }

    { 35  ;2   ;Field     ;
                Name=PostDate;
                CaptionML=[DAN=Bogf›ringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for den post, hvor udligningen skal annulleres.;
                           ENU=Specifies the posting date of the entry to be unapplied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=PostingDate }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for den detaljerede debitorpost.;
                           ENU=Specifies the posting date of the detailed customer ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver posttypen for den detaljerede debitorpost.;
                           ENU=Specifies the entry type of the detailed customer ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagstypen for den detaljerede debitorpost.;
                           ENU=Specifies the document type of the detailed customer ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for den transaktion, der oprettede posten.;
                           ENU=Specifies the document number of the transaction that created the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitorkonto, som posten er bogf›rt p†.;
                           ENU=Specifies the customer account number to which the entry is posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer No." }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som startdebitorposten er oprettet med.;
                           ENU=Specifies the document type that the initial customer ledger entry was created with.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Initial Document Type" }

    { 43  ;2   ;Field     ;
                DrillDown=No;
                CaptionML=[DAN=Oprindeligt bilagsnr.;
                           ENU=Initial Document No.];
                ToolTipML=[DAN=Angiver bilagsnummeret p† det bilag, hvor udligningen af posten er annulleret.;
                           ENU=Specifies the number of the document for which the entry is unapplied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetDocumentNo }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Global Dimension 1-koden for startdebitorposten.;
                           ENU=Specifies the Global Dimension 1 code of the initial customer ledger entry.];
                ApplicationArea=#Dimensions;
                SourceExpr="Initial Entry Global Dim. 1";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Global Dimension 2-koden for startdebitorposten.;
                           ENU=Specifies the Global Dimension 2 code of the initial customer ledger entry.];
                ApplicationArea=#Dimensions;
                SourceExpr="Initial Entry Global Dim. 2";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for valutaen, hvis bel›bet er i udenlandsk valuta.;
                           ENU=Specifies the code for the currency if the amount is in a foreign currency.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for den detaljerede debitorpost.;
                           ENU=Specifies the amount of the detailed customer ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten i regnskabsvalutaen.;
                           ENU=Specifies the amount of the entry in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount (LCY)" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent debits, expressed in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount (LCY)";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer, i RV.;
                           ENU=Specifies the total of the ledger entries that represent credits, expressed in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount (LCY)";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor startposten er forfalden til betaling.;
                           ENU=Specifies the date on which the initial entry is due for payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Initial Entry Due Date" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l›benummeret p† den debitorpost, som den detaljerede debitorpostlinje er oprettet for.;
                           ENU=Specifies the entry number of the customer ledger entry that the detailed customer ledger entry line was created for.];
                ApplicationArea=#Advanced;
                SourceExpr="Cust. Ledger Entry No.";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No." }

  }
  CODE
  {
    VAR
      DtldCustLedgEntry2@1004 : Record 379;
      Cust@1005 : Record 18;
      DocNo@1000 : Code[20];
      PostingDate@1001 : Date;
      CustLedgEntryNo@1002 : Integer;
      Text009@1008 : TextConst 'DAN=Udligningen af posterne blev annulleret.;ENU=The entries were successfully unapplied.';
      Text010@1003 : TextConst 'DAN=Der er ingen udligning, der kan annulleres.;ENU=There is nothing to unapply.';
      Text011@1006 : TextConst 'DAN=Ved annullering af udligning bogf›res korrigerende poster.\Vil du annullere udligningen?;ENU=To unapply these entries, correcting entries will be posted.\Do you want to unapply the entries?';

    [External]
    PROCEDURE SetDtldCustLedgEntry@4(EntryNo@1001 : Integer);
    BEGIN
      DtldCustLedgEntry2.GET(EntryNo);
      CustLedgEntryNo := DtldCustLedgEntry2."Cust. Ledger Entry No.";
      PostingDate := DtldCustLedgEntry2."Posting Date";
      DocNo := DtldCustLedgEntry2."Document No.";
      Cust.GET(DtldCustLedgEntry2."Customer No.");
    END;

    LOCAL PROCEDURE InsertEntries@1();
    VAR
      DtldCustLedgEntry@1005 : Record 379;
    BEGIN
      IF DtldCustLedgEntry2."Transaction No." = 0 THEN BEGIN
        DtldCustLedgEntry.SETCURRENTKEY("Application No.","Customer No.","Entry Type");
        DtldCustLedgEntry.SETRANGE("Application No.",DtldCustLedgEntry2."Application No.");
      END ELSE BEGIN
        DtldCustLedgEntry.SETCURRENTKEY("Transaction No.","Customer No.","Entry Type");
        DtldCustLedgEntry.SETRANGE("Transaction No.",DtldCustLedgEntry2."Transaction No.");
      END;
      DtldCustLedgEntry.SETRANGE("Customer No.",DtldCustLedgEntry2."Customer No.");
      DELETEALL;
      IF DtldCustLedgEntry.FINDSET THEN
        REPEAT
          IF (DtldCustLedgEntry."Entry Type" <> DtldCustLedgEntry."Entry Type"::"Initial Entry") AND
             NOT DtldCustLedgEntry.Unapplied
          THEN BEGIN
            Rec := DtldCustLedgEntry;
            INSERT;
          END;
        UNTIL DtldCustLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE GetDocumentNo@7() : Code[20];
    VAR
      CustLedgEntry@1000 : Record 21;
    BEGIN
      IF CustLedgEntry.GET("Cust. Ledger Entry No.") THEN;
      EXIT(CustLedgEntry."Document No.");
    END;

    LOCAL PROCEDURE Caption@5() : Text[100];
    VAR
      CustLedgEntry@1000 : Record 21;
    BEGIN
      EXIT(STRSUBSTNO(
          '%1 %2 %3 %4',
          Cust."No.",
          Cust.Name,
          CustLedgEntry.FIELDCAPTION("Entry No."),
          CustLedgEntryNo));
    END;

    BEGIN
    END.
  }
}

