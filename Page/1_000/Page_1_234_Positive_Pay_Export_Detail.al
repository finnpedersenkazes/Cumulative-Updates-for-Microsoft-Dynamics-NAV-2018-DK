OBJECT Page 1234 Positive Pay Export Detail
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
    CaptionML=[DAN=Oplysninger om Positive Pay-betalingsposter;
               ENU=Positive Pay Export Detail];
    SourceTable=Table272;
    DelayedInsert=Yes;
    PageType=ListPart;
    ShowFilter=No;
    OnAfterGetRecord=BEGIN
                       SetFilters;
                     END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Suite;
                SourceExpr="Entry No." }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver checkdatoen, hvis en check udskrives.;
                           ENU=Specifies the check date if a check is printed.];
                ApplicationArea=#Suite;
                SourceExpr="Check Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver checknummeret, hvis en check udskrives.;
                           ENU=Specifies the check number if a check is printed.];
                ApplicationArea=#Suite;
                SourceExpr="Check No." }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af checkposten.;
                           ENU=Specifies a printing description for the check ledger entry.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for checkposten.;
                           ENU=Specifies the amount on the check ledger entry.];
                ApplicationArea=#Suite;
                SourceExpr=Amount }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver checkpostens status for udskrivning (og bogf›ring).;
                           ENU=Specifies the printing (and posting) status of the check ledger entry.];
                ApplicationArea=#Suite;
                SourceExpr="Entry Status" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den betalingstype, der skal bruges for posten p† kladdelinjen.;
                           ENU=Specifies the code for the payment type to be used for the entry on the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Bank Payment Type";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l›benummeret p† den bankpost, som checkposten er oprettet fra.;
                           ENU=Specifies the entry number of the bank account ledger entry from which the check ledger entry was created.];
                ApplicationArea=#Suite;
                SourceExpr="Bank Account Ledger Entry No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for checkposten.;
                           ENU=Specifies the posting date of the check ledger entry.];
                ApplicationArea=#Suite;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dokumenttype, der er knyttet til checkposten, f.eks. Udbetaling.;
                           ENU=Specifies the document type linked to the check ledger entry. For example, Payment.];
                ApplicationArea=#Suite;
                SourceExpr="Document Type";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† checkposten.;
                           ENU=Specifies the document number on the check ledger entry.];
                ApplicationArea=#Suite;
                SourceExpr="Document No.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for posten, f›r du ‘ndrede den.;
                           ENU=Specifies the status of the entry before you changed it.];
                ApplicationArea=#Suite;
                SourceExpr="Original Entry Status";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den bankkonto, der benyttes til checkposten.;
                           ENU=Specifies the number of the bank account used for the check ledger entry.];
                ApplicationArea=#Suite;
                SourceExpr="Bank Account No.";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf›res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Suite;
                SourceExpr="Bal. Account Type";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf›res til, f.eks. en kassekonto ved kontantk›b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Suite;
                SourceExpr="Bal. Account No.";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er fuldt udlignet.;
                           ENU=Specifies whether the entry has been fully applied to.];
                ApplicationArea=#Suite;
                SourceExpr=Open;
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Suite;
                SourceExpr="User ID";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Suite;
                SourceExpr="External Document No.";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      LastUploadDate@1001 : Date;
      UploadCutoffDate@1002 : Date;

    [External]
    PROCEDURE Set@2(NewLastUploadDate@1000 : Date;NewUploadCutoffDate@1001 : Date;NewBankAcctNo@1002 : Code[20]);
    BEGIN
      LastUploadDate := NewLastUploadDate;
      UploadCutoffDate := NewUploadCutoffDate;
      SETRANGE("Bank Account No.",NewBankAcctNo);
      SetFilters;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE SetFilters@3();
    BEGIN
      SETRANGE("Check Date",LastUploadDate,UploadCutoffDate);
      SETRANGE("Positive Pay Exported",FALSE);
    END;

    BEGIN
    END.
  }
}

