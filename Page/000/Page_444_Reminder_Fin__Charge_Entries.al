OBJECT Page 444 Reminder/Fin. Charge Entries
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
    CaptionML=[DAN=Rykker-/rentenotaposter;
               ENU=Reminder/Fin. Charge Entries];
    SourceTable=Table300;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 29      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
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

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor rykkeren eller rentenotaen er blevet bogf›rt.;
                           ENU=Specifies the posting date of the reminder or finance charge memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten stammer fra en rykker eller en rentenota.;
                           ENU=Specifies whether the entry comes from a reminder or a finance charge memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitorposten p† rykkerlinjen eller rentenotalinjen.;
                           ENU=Specifies the number of the customer ledger entry on the reminder line or finance charge memo line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Entry No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dokumenttypen p† debitorposten p† rykkerlinjen eller rentenotalinjen.;
                           ENU=Specifies the document type of the customer entry on the reminder line or finance charge memo line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† debitorposten p† rykkerlinjen eller rentenotalinjen.;
                           ENU=Specifies the document number of the customer entry on the reminder line or finance charge memo line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der blev bogf›rt rente p† debitorkontoen og p† en finanskonto, da rykkeren eller rentenotaen blev udstedt.;
                           ENU=Specifies whether or not interest was posted to the customer account and a general ledger account when the reminder or finance charge memo was issued.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Interest Posted" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver restbel›bet i den debitorpost, rykker- eller rentenotaposterne vedr›rer.;
                           ENU=Specifies the remaining amount of the customer ledger entry this reminder or finance charge memo entry is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rykkerniveauet, hvis feltet Type er Rykker.;
                           ENU=Specifies the reminder level if the Type field contains Reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reminder Level" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No." }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

