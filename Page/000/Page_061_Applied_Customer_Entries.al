OBJECT Page 61 Applied Customer Entries
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
    CaptionML=[DAN=Udlignede deb.poster;
               ENU=Applied Customer Entries];
    SourceTable=Table21;
    DataCaptionExpr=Heading;
    PageType=List;
    OnInit=BEGIN
             AmountVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 RESET;
                 SetConrolVisibility;

                 IF "Entry No." <> 0 THEN BEGIN
                   CreateCustLedgEntry := Rec;
                   IF CreateCustLedgEntry."Document Type" = 0 THEN
                     Heading := Text000
                   ELSE
                     Heading := FORMAT(CreateCustLedgEntry."Document Type");
                   Heading := Heading + ' ' + CreateCustLedgEntry."Document No.";

                   FindApplnEntriesDtldtLedgEntry;
                   SETCURRENTKEY("Entry No.");
                   SETRANGE("Entry No.");

                   IF CreateCustLedgEntry."Closed by Entry No." <> 0 THEN BEGIN
                     "Entry No." := CreateCustLedgEntry."Closed by Entry No.";
                     MARK(TRUE);
                   END;

                   SETCURRENTKEY("Closed by Entry No.");
                   SETRANGE("Closed by Entry No.",CreateCustLedgEntry."Entry No.");
                   IF FIND('-') THEN
                     REPEAT
                       MARK(TRUE);
                     UNTIL NEXT = 0;

                   SETCURRENTKEY("Entry No.");
                   SETRANGE("Closed by Entry No.");
                 END;

                 MARKEDONLY(TRUE);
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Rykker-/rentenotaposter;
                                 ENU=Reminder/Fin. Charge Entries];
                      ToolTipML=[DAN=Se de poster, der blev oprettet ved udstedelsen af rykkere og rentenotaer.;
                                 ENU=View entries that were created when reminders and finance charge memos were issued.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 444;
                      RunPageView=SORTING(Customer Entry No.);
                      RunPageLink=Customer Entry No.=FIELD(Entry No.);
                      Image=Reminder }
      { 32      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 35      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Detaljerede p&oster;
                                 ENU=Detailed &Ledger Entries];
                      ToolTipML=[DAN=Se en oversigt over alle bogf›rte poster og reguleringer relateret til en bestemt debitorpost.;
                                 ENU=View a summary of the all posted entries and adjustments related to a specific customer ledger entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 573;
                      RunPageView=SORTING(Cust. Ledger Entry No.,Posting Date);
                      RunPageLink=Cust. Ledger Entry No.=FIELD(Entry No.),
                                  Customer No.=FIELD(Customer No.);
                      Image=View }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte dokument.;
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorpostens bogf›ringsdato.;
                           ENU=Specifies the customer entry's posting date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken bilagstype debitorposten tilh›rer.;
                           ENU=Specifies the document type that the customer entry belongs to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bilagsnummer.;
                           ENU=Specifies the entry's document number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af debitorposten.;
                           ENU=Specifies a description of the customer entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, der er tilknyttet posten.;
                           ENU=Specifies the code for the salesperson whom the entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code";
                Visible=FALSE }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel›bet p† linjen.;
                           ENU=Specifies the currency code for the amount on the line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for den oprindelige post.;
                           ENU=Specifies the amount of the original entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Original Amount" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten.;
                           ENU=Specifies the amount of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                Visible=AmountVisible }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount";
                Visible=DebitCreditVisible }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Amount";
                Visible=DebitCreditVisible }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som posten blev endeligt udlignet (lukket) med.;
                           ENU=Specifies the amount that the entry was finally applied to (closed) with.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Closed by Amount" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden p† valutaen i den post, der blev brugt til at udligne (og lukke) denne debitorpost.;
                           ENU=Specifies the code of the currency of the entry that was applied to (and closed) this customer ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Closed by Currency Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b der til sidst blev brugt til at udligne (og lukke) denne debitorpost.;
                           ENU=Specifies the amount that was finally applied to (and closed) this customer ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Closed by Currency Amount";
                AutoFormatType=1;
                AutoFormatExpr="Closed by Currency Code";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
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
      Text000@1000 : TextConst 'DAN=Bilag;ENU=Document';
      CreateCustLedgEntry@1001 : Record 21;
      Navigate@1002 : Page 344;
      Heading@1003 : Text[50];
      AmountVisible@1005 : Boolean;
      DebitCreditVisible@1004 : Boolean;

    LOCAL PROCEDURE FindApplnEntriesDtldtLedgEntry@1();
    VAR
      DtldCustLedgEntry1@1001 : Record 379;
      DtldCustLedgEntry2@1000 : Record 379;
    BEGIN
      DtldCustLedgEntry1.SETCURRENTKEY("Cust. Ledger Entry No.");
      DtldCustLedgEntry1.SETRANGE("Cust. Ledger Entry No.",CreateCustLedgEntry."Entry No.");
      DtldCustLedgEntry1.SETRANGE(Unapplied,FALSE);
      IF DtldCustLedgEntry1.FIND('-') THEN
        REPEAT
          IF DtldCustLedgEntry1."Cust. Ledger Entry No." =
             DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
          THEN BEGIN
            DtldCustLedgEntry2.INIT;
            DtldCustLedgEntry2.SETCURRENTKEY("Applied Cust. Ledger Entry No.","Entry Type");
            DtldCustLedgEntry2.SETRANGE(
              "Applied Cust. Ledger Entry No.",DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
            DtldCustLedgEntry2.SETRANGE("Entry Type",DtldCustLedgEntry2."Entry Type"::Application);
            DtldCustLedgEntry2.SETRANGE(Unapplied,FALSE);
            IF DtldCustLedgEntry2.FIND('-') THEN
              REPEAT
                IF DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                   DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                THEN BEGIN
                  SETCURRENTKEY("Entry No.");
                  SETRANGE("Entry No.",DtldCustLedgEntry2."Cust. Ledger Entry No.");
                  IF FIND('-') THEN
                    MARK(TRUE);
                END;
              UNTIL DtldCustLedgEntry2.NEXT = 0;
          END ELSE BEGIN
            SETCURRENTKEY("Entry No.");
            SETRANGE("Entry No.",DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
            IF FIND('-') THEN
              MARK(TRUE);
          END;
        UNTIL DtldCustLedgEntry1.NEXT = 0;
    END;

    [External]
    PROCEDURE SetTempCustLedgEntry@2(NewTempCustLedgEntryNo@1102601000 : Integer);
    BEGIN
      IF NewTempCustLedgEntryNo <> 0 THEN BEGIN
        SETRANGE("Entry No.",NewTempCustLedgEntryNo);
        FIND('-');
      END;
    END;

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

