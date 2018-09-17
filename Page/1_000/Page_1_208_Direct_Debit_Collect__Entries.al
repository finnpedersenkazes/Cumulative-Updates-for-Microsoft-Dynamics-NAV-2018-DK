OBJECT Page 1208 Direct Debit Collect. Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Poster i Direct Debit-opkr‘vning;
               ENU=Direct Debit Collect. Entries];
    SourceTable=Table1208;
    DelayedInsert=Yes;
    PageType=List;
    OnOpenPage=BEGIN
                 FILTERGROUP(2);
                 SETRANGE("Direct Debit Collection No.",GETRANGEMIN("Direct Debit Collection No."));
                 FILTERGROUP(0);
               END;

    OnAfterGetRecord=BEGIN
                       HasLineErrors := HasPaymentFileErrors;
                       LineIsEditable := Status = Status::New;
                     END;

    OnNewRecord=BEGIN
                  LineIsEditable := TRUE;
                  HasLineErrors := FALSE;
                END;

    OnInsertRecord=BEGIN
                     CALCFIELDS("Direct Debit Collection Status");
                     TESTFIELD("Direct Debit Collection Status","Direct Debit Collection Status"::New);
                   END;

    OnModifyRecord=BEGIN
                     TESTFIELD(Status,Status::New);
                     CALCFIELDS("Direct Debit Collection Status");
                     TESTFIELD("Direct Debit Collection Status","Direct Debit Collection Status"::New);
                     CODEUNIT.RUN(CODEUNIT::"SEPA DD-Check Line",Rec);
                     HasLineErrors := HasPaymentFileErrors;
                   END;

    OnDeleteRecord=BEGIN
                     TESTFIELD(Status,Status::New);
                     CALCFIELDS("Direct Debit Collection Status");
                     TESTFIELD("Direct Debit Collection Status","Direct Debit Collection Status"::New);
                   END;

    ActionList=ACTIONS
    {
      { 21      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 22      ;1   ;Action    ;
                      Name=Export;
                      CaptionML=[DAN=Udl‘s Direct Debit-fil;
                                 ENU=Export Direct Debit File];
                      ToolTipML=[DAN=Gem posterne for Direct Debit-opkr‘vningen i en fil, som du sender eller overf›rer til din elektroniske bank til behandling.;
                                 ENU=Save the entries for the direct debit collection to a file that you send or upload to your electronic bank for processing.];
                      ApplicationArea=#Suite;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      Image=ExportFile;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ExportSEPA;
                               END;
                                }
      { 23      ;1   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis post;
                                 ENU=Reject Entry];
                      ToolTipML=[DAN=Afvis en post til en Direct Debit-opkr‘vning. Det kan du normalt g›re, efter at betalingerne ikke kunne behandles af banken.;
                                 ENU=Reject a debit-collection entry. You will typically do this for payments that could not be processed by the bank.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Reject;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Reject;
                               END;
                                }
      { 24      ;1   ;Action    ;
                      Name=Close;
                      CaptionML=[DAN=Luk opkr‘vning;
                                 ENU=Close Collection];
                      ToolTipML=[DAN=Luk en Direct Debit-opkr‘vning, s† du kan begynde at bogf›re betalingskvitteringer til relaterede salgsfakturaer. N†r de er afsluttet, kan du ikke registrere betalinger for opkr‘vningen.;
                                 ENU=Close a direct-debit collection so you begin to post payment receipts for related sales invoices. Once closed, you cannot register payments for the collection.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Close;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DirectDebitCollection@1000 : Record 1207;
                               BEGIN
                                 DirectDebitCollection.GET("Direct Debit Collection No.");
                                 DirectDebitCollection.CloseCollection;
                               END;
                                }
      { 25      ;1   ;Action    ;
                      Name=Post;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r betalingskvitteringer;
                                 ENU=Post Payment Receipts];
                      ToolTipML=[DAN=Bogf›r betalingskvitteringer for salgsfakturaer. Det kan du g›re, efter at Direct Debit-opkr‘vningen er behandlet af banken.;
                                 ENU=Post receipts of a payment for sales invoices. You can this after the direct debit collection is successfully processed by the bank.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ReceivablesPayables;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DirectDebitCollection@1001 : Record 1207;
                                 PostDirectDebitCollection@1000 : Report 1201;
                               BEGIN
                                 TESTFIELD("Direct Debit Collection No.");
                                 DirectDebitCollection.GET("Direct Debit Collection No.");
                                 DirectDebitCollection.TESTFIELD(Status,DirectDebitCollection.Status::"File Created");
                                 PostDirectDebitCollection.SetCollectionEntry("Direct Debit Collection No.");
                                 PostDirectDebitCollection.SETTABLEVIEW(Rec);
                                 PostDirectDebitCollection.RUN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                Editable=LineIsEditable;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens nummer, som Direct Debit-betalingen opkr‘ves hos.;
                           ENU=Specifies the number of the customer that the direct-debit payment is collected from.];
                ApplicationArea=#Suite;
                SourceExpr="Customer No.";
                Style=Attention;
                StyleExpr=HasLineErrors }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens navn, som Direct Debit-betalingen opkr‘ves hos.;
                           ENU=Specifies the name of the customer that the direct-debit payment is collected from.];
                ApplicationArea=#Suite;
                SourceExpr="Customer Name";
                Style=Attention;
                StyleExpr=HasLineErrors }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† salgsfakturaen, som anvendes til debitorposten bag denne Direct Debit-opkr‘vning.;
                           ENU=Specifies the number of the sales invoice that the customer leger entry behind this direct-debit collection entry applies to.];
                ApplicationArea=#Suite;
                SourceExpr="Applies-to Entry No." }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† salgsfakturaen, som anvendes til debitorposten bag denne Direct Debit-opkr‘vning.;
                           ENU=Specifies the document number on the sales invoice that the customer leger entry behind this direct-debit collection entry applies to.];
                ApplicationArea=#Suite;
                SourceExpr="Applies-to Entry Document No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for, hvorn†r betalingen vil blive opkr‘vet p† debitors bankkonto.;
                           ENU=Specifies the date when the payment will be collected from the customer's bank account.];
                ApplicationArea=#Suite;
                SourceExpr="Transfer Date" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutaen for betalingsbel›bet, som opkr‘ves som Direct Debit.;
                           ENU=Specifies the currency of the payment amount that is being collected as a direct debit.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som vil blive opkr‘vet p† debitors bankkonto.;
                           ENU=Specifies the amount that will be collected from the customer's bank account.];
                ApplicationArea=#Suite;
                SourceExpr="Transfer Amount" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p† Direct Debit-opkr‘vningen. Den best†r af et tal i SEPA Direct Debit-meddelelsens nummerserie og v‘rdien i feltet Udlign.l›benr.;
                           ENU=Specifies the ID of the direct debit collection. It consist of a number in the SEPA direct-debit message number series and the value in the Applies-to Entry No. field.];
                ApplicationArea=#Suite;
                SourceExpr="Transaction ID";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p† den Direct Debit-betalingsaftale, som findes for den p†g‘ldende Direct Debit-opkr‘vning.;
                           ENU=Specifies the ID of the direct-debit mandate that exists for the direct debit collection in question.];
                ApplicationArea=#Suite;
                SourceExpr="Mandate ID" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten til Direct Debit-opkr‘vningen er for den f›rste eller sidste i en sekvens af tilbagevendende poster.;
                           ENU=Specifies if the direct-debit collection entry is the first or the last of a sequence of recurring entries.];
                ApplicationArea=#Suite;
                SourceExpr="Sequence Type" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for posten til Direct Debit-opkr‘vningen.;
                           ENU=Specifies the status of the direct-debit collection entry.];
                ApplicationArea=#Suite;
                SourceExpr=Status;
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den relaterede Direct Debit-betalingsaftale er oprettet for ‚n eller flere Direct Debit-opkr‘vninger.;
                           ENU=Specifies if the related direct-debit mandate is created for one or multiple direct debit collections.];
                ApplicationArea=#Advanced;
                SourceExpr="Mandate Type of Payment";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen p† salgsfakturaen, som anvendes til debitorposten bag denne Direct Debit-opkr‘vning.;
                           ENU=Specifies the description of the sales invoice that the customer leger entry behind this direct-debit collection entry applies to.];
                ApplicationArea=#Suite;
                SourceExpr="Applies-to Entry Description" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r salgsfakturaen, som anvendes til debitorposten bag denne Direct Debit-opkr‘vning, blev bogf›rt.;
                           ENU=Specifies when the sales invoice that the customer leger entry behind this direct-debit collection entry applies to was posted.];
                ApplicationArea=#Suite;
                SourceExpr="Applies-to Entry Posting Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutaen p† salgsfakturaen, som anvendes til debitorposten bag denne Direct Debit-opkr‘vning.;
                           ENU=Specifies the currency of the sales invoice that the customer leger entry behind this direct-debit collection entry applies to.];
                ApplicationArea=#Suite;
                SourceExpr="Applies-to Entry Currency Code" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingsbel›bet p† salgsfakturaen, som anvendes til debitorposten bag denne Direct Debit-opkr‘vning.;
                           ENU=Specifies the payment amount on the sales invoice that the customer leger entry behind this direct-debit collection entry applies to.];
                ApplicationArea=#Suite;
                SourceExpr="Applies-to Entry Amount" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet p† salgsfakturaen, der mangler at blive betalt, som anvendes til debitorposten bag denne Direct Debit-opkr‘vning.;
                           ENU=Specifies the amount that remains to be paid on the sales invoice that the customer leger entry behind this direct-debit collection entry applies to.];
                ApplicationArea=#Suite;
                SourceExpr="Applies-to Entry Rem. Amount" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om salgsfakturaen, som anvendes til debitorposten bag denne Direct Debit-opkr‘vning, er †ben.;
                           ENU=Specifies if the sales invoice that the customer leger entry behind this direct-debit collection entry applies to is open.];
                ApplicationArea=#Suite;
                SourceExpr="Applies-to Entry Open" }

    { 29  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 28  ;1   ;Part      ;
                CaptionML=[DAN=Fejl i filudl‘sning;
                           ENU=File Export Errors];
                ApplicationArea=#Suite;
                SubPageLink=Document No.=FIELD(FILTER(Direct Debit Collection No.)),
                            Journal Line No.=FIELD(Entry No.);
                PagePartID=Page1228;
                PartType=Page }

  }
  CODE
  {
    VAR
      HasLineErrors@1000 : Boolean INDATASET;
      LineIsEditable@1001 : Boolean;

    BEGIN
    END.
  }
}

