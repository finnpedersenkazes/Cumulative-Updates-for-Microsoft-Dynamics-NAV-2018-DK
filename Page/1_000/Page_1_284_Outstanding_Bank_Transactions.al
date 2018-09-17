OBJECT Page 1284 Outstanding Bank Transactions
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
    CaptionML=[DAN=Udest†ende banktransaktioner;
               ENU=Outstanding Bank Transactions];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table1284;
    PageType=List;
    SourceTableTemporary=Yes;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for det bilag, hvor posten blev genereret.;
                           ENU=Specifies the type of document that generated the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bilag, hvor posten blev genereret.;
                           ENU=Specifies the number of the document that generated the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af posten.;
                           ENU=Specifies the description of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Bel›b;
                           ENU=Amount];
                ToolTipML=[DAN=Angiver bel›bet for posten.;
                           ENU=Specifies the amount of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for posten.;
                           ENU=Specifies the type of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er blevet udlignet.;
                           ENU=Specifies if the entry has been applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Applied;
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No." }

  }
  CODE
  {
    VAR
      OutstandingBankTrxTxt@1001 : TextConst 'DAN=Udest†ende banktransaktioner;ENU=Outstanding Bank Transactions';
      OutstandingPaymentTrxTxt@1000 : TextConst 'DAN=Udest†ende betalingstransaktioner;ENU=Outstanding Payment Transactions';

    [External]
    PROCEDURE SetRecords@2(VAR TempOutstandingBankTransaction@1006 : TEMPORARY Record 1284);
    BEGIN
      COPY(TempOutstandingBankTransaction,TRUE);
    END;

    [External]
    PROCEDURE SetPageCaption@3(TransactionType@1003 : Option);
    BEGIN
      IF TransactionType = Type::"Bank Account Ledger Entry" THEN
        CurrPage.CAPTION(OutstandingBankTrxTxt)
      ELSE
        CurrPage.CAPTION(OutstandingPaymentTrxTxt);
    END;

    BEGIN
    END.
  }
}

