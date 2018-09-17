OBJECT Page 374 Check Ledger Entries
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
    CaptionML=[DAN=Checkposter;
               ENU=Check Ledger Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table272;
    SourceTableView=SORTING(Bank Account No.,Check Date)
                    ORDER(Descending);
    DataCaptionFields=Bank Account No.;
    PageType=List;
    OnOpenPage=BEGIN
                 IF GETFILTERS <> '' THEN
                   IF FINDFIRST THEN;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 34      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Check;
                                 ENU=Chec&k];
                      Image=Check }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Annuller check;
                                 ENU=Void Check];
                      ToolTipML=[DAN=Annuller checken, hvis den f.eks. ikke indl›ses af banken.;
                                 ENU=Void the check if, for example, the check is not cashed by the bank.];
                      ApplicationArea=#Basic,#Suite;
                      Image=VoidCheck;
                      OnAction=VAR
                                 CheckManagement@1001 : Codeunit 367;
                               BEGIN
                                 CheckManagement.FinancialVoidCheck(Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 33      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og dokumenter, der findes for dokumentnummeret og bogf›ringsdatoen p† den valgte post eller det valgte dokument.;
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

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver checkdatoen, hvis en check udskrives.;
                           ENU=Specifies the check date if a check is printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Check Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver checknummeret, hvis en check udskrives.;
                           ENU=Specifies the check number if a check is printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Check No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den bankkonto, der benyttes til checkposten.;
                           ENU=Specifies the number of the bank account used for the check ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af checkposten.;
                           ENU=Specifies a printing description for the check ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for checkposten.;
                           ENU=Specifies the amount on the check ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf›res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account Type";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf›res til, f.eks. en kassekonto ved kontantk›b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account No.";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver checkpostens status for udskrivning (og bogf›ring).;
                           ENU=Specifies the printing (and posting) status of the check ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Status" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for posten, f›r du ‘ndrede den.;
                           ENU=Specifies the status of the entry before you changed it.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Original Entry Status";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den betalingstype, der skal bruges for posten p† kladdelinjen.;
                           ENU=Specifies the code for the payment type to be used for the entry on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Payment Type";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for checkposten.;
                           ENU=Specifies the posting date of the check ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dokumenttype, der er knyttet til checkposten, f.eks. Udbetaling.;
                           ENU=Specifies the document type linked to the check ledger entry. For example, Payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† checkposten.;
                           ENU=Specifies the document number on the check ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
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
      Navigate@1002 : Page 344;

    BEGIN
    END.
  }
}

