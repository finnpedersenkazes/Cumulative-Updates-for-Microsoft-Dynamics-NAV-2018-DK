OBJECT Page 251 General Journal Batches
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finanskladdenavne;
               ENU=General Journal Batches];
    SourceTable=Table232;
    DataCaptionExpr=DataCaption;
    PageType=List;
    OnOpenPage=BEGIN
                 GenJnlManagement.OpenJnlBatch(Rec);
                 ShowAllowPaymentExportForPaymentTemplate;
               END;

    OnNewRecord=BEGIN
                  SetupNewBatch;
                END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 29      ;1   ;Action    ;
                      Name=EditJournal;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Rediger kladde;
                                 ENU=Edit Journal];
                      ToolTipML=[DAN=�bn en kladde baseret p� kladdenavnet.;
                                 ENU=Open a journal based on the journal batch.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=OpenJournal;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 GenJnlManagement.TemplateSelectionFromBatch(Rec);
                               END;
                                }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&osting];
                      Image=Post }
      { 16      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=F� vist en testrapport, s� du kan finde og rette eventuelle fejl, f�r du udf�rer den faktiske bogf�ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintGenJnlBatch(Rec);
                               END;
                                }
      { 17      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf�r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 233;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process }
      { 18      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden, og forbered udskrivning. V�rdierne og m�ngderne bogf�res p� de relevante konti. Du f�r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 234;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process }
      { 26      ;2   ;Action    ;
                      Name=MarkedOnOff;
                      CaptionML=[DAN=Afm�rkning til/fra;
                                 ENU=Marked On/Off];
                      ToolTipML=[DAN=Vis alle kladdenavne eller kun markerede kladdenavne. Et kladdenavn er markeret, hvis fors�g p� bogf�ring af finanskladden mislykkes.;
                                 ENU=View all journal batches or only marked journal batches. A journal batch is marked if an attempt to post the general journal fails.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Change;
                      OnAction=BEGIN
                                 MARKEDONLY(NOT MARKEDONLY);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=Periodiske aktiviteter;
                                 ENU=Periodic Activities] }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Finansgentagelseskladde;
                                 ENU=Recurring General Journal];
                      ToolTipML=[DAN=Definer, hvordan transaktioner, der gentages med f� eller ingen �ndringer, skal bogf�res p� finanskonti, bankkonti, debitor- og kreditorkonti og anl�gskonti.;
                                 ENU=Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, and fixed assets accounts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 283;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Journal;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Finansjournal;
                                 ENU=G/L Register];
                      ToolTipML=[DAN=Vis bogf�rte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 116;
                      Image=GLRegisters }
      { 22      ;    ;ActionContainer;
                      ActionContainerType=Reports }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Detaljeret r�balance;
                                 ENU=Detail Trial Balance];
                      ToolTipML=[DAN=Vis detaljerede finanskontosaldi og -aktiviteter.;
                                 ENU=View detail general ledger account balances and activities.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 4;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Balance;
                                 ENU=Trial Balance];
                      ToolTipML=[DAN=Vis finanskontosaldi og -aktiviteter.;
                                 ENU=View general ledger account balances and activities.];
                      ApplicationArea=#Suite;
                      RunObject=Report 6;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=R�balance efter periode;
                                 ENU=Trial Balance by Period];
                      ToolTipML=[DAN=Vis finanskontosaldi og aktiviteter inden for en valgt periode.;
                                 ENU=View general ledger account balances and activities within a selected period.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 38;
                      Image=Report;
                      PromotedCategory=Report }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Finansjournal;
                                 ENU=G/L Register];
                      ToolTipML=[DAN=Vis bogf�rte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Suite;
                      RunObject=Report 3;
                      Image=GLRegisters }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kladde, du er ved at oprette.;
                           ENU=Specifies the name of the journal you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af det kladdenavn, du er ved at oprette.;
                           ENU=Specifies a brief description of the journal batch you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf�res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account Type" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf�res til, f.eks. en kassekonto ved kontantk�b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account No." }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Series" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der bruges til at tildele bilagsnumre til finansposter, der er bogf�rt fra kladdek�rslen.;
                           ENU=Specifies the code for the number series that will be used to assign document numbers to ledger entries that are posted from this journal batch.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting No. Series" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �rsagskoden som et supplerende kildespor, der hj�lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reason Code" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om programmet skal beregne moms af konti og modkonti p� kladdelinjen for det valgte kladdenavn.;
                           ENU=Specifies whether the program to calculate VAT for accounts and balancing accounts on the journal line of the selected journal batch.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Copy VAT Setup to Jnl. Lines" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om manuel regulering af momsbel�b i kladdetyper skal tillades.;
                           ENU=Specifies whether to allow the manual adjustment of VAT amounts in journal templates.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow VAT Difference" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du kan eksportere bankbetalingsfiler fra udbetalingskladdens linjer ved hj�lp af dette finanskladdenavn.;
                           ENU=Specifies if you can export bank payment files from payment journal lines using this general journal batch.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow Payment Export";
                Visible=IsPaymentTemplate }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om feltet Bel�b p� kladdelinjer for det samme bilagsnummer, hvor den v�rdi, der er p�kr�vet for at udligne bilaget, automatisk er udfyldt.;
                           ENU=Specifies if the Amount field on journal lines for the same document number is automatically prefilled with the value that is required to balance the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Suggest Balancing Amount" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver formatet p� bankkontoudtogsfilen, der kan importeres til dette finanskladdenavn.;
                           ENU=Specifies the format of the bank statement file that can be imported into this general journal batch.];
                ApplicationArea=#Advanced;
                SourceExpr="Bank Statement Import Format";
                Visible=FALSE }

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
      ReportPrint@1000 : Codeunit 228;
      GenJnlManagement@1003 : Codeunit 230;
      IsPaymentTemplate@1001 : Boolean;

    LOCAL PROCEDURE DataCaption@1() : Text[250];
    VAR
      GenJnlTemplate@1000 : Record 80;
    BEGIN
      IF NOT CurrPage.LOOKUPMODE THEN
        IF GETFILTER("Journal Template Name") <> '' THEN BEGIN
          GenJnlTemplate.SETFILTER(Name,GETFILTER("Journal Template Name"));
          IF GenJnlTemplate.FINDSET THEN
            IF GenJnlTemplate.NEXT = 0 THEN
              EXIT(GenJnlTemplate.Name + ' ' + GenJnlTemplate.Description);
        END;
    END;

    LOCAL PROCEDURE ShowAllowPaymentExportForPaymentTemplate@2();
    VAR
      GenJournalTemplate@1000 : Record 80;
    BEGIN
      IF GenJournalTemplate.GET("Journal Template Name") THEN
        IsPaymentTemplate := GenJournalTemplate.Type = GenJournalTemplate.Type::Payments;
    END;

    BEGIN
    END.
  }
}

