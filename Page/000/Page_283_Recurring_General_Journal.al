OBJECT Page 283 Recurring General Journal
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finansgentagelseskladde;
               ENU=Recurring General Journal];
    SaveValues=Yes;
    SourceTable=Table81;
    DataCaptionExpr=DataCaption;
    DelayedInsert=Yes;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnInit=BEGIN
             TotalBalanceVisible := TRUE;
             BalanceVisible := TRUE;
             AmountVisible := TRUE;
           END;

    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 SetConrolVisibility;

                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 GenJnlManagement.TemplateSelection(PAGE::"Recurring General Journal",0,TRUE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  UpdateBalance;
                  SetUpNewLine(xRec,Balance,BelowxRec);
                  CLEAR(ShortcutDimCode);
                END;

    OnAfterGetCurrRecord=BEGIN
                           GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                           UpdateBalance;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 56      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 84      ;2   ;Action    ;
                      CaptionML=[DAN=Fordelinger;
                                 ENU=Allocations];
                      ToolTipML=[DAN=Alloker bel›bet p† den valgte kladdelinje til de angivne konti.;
                                 ENU=Allocate the amount on the selected journal line to the accounts that you specify.];
                      ApplicationArea=#Suite;
                      RunObject=Page 284;
                      RunPageLink=Journal Template Name=FIELD(Journal Template Name),
                                  Journal Batch Name=FIELD(Journal Batch Name),
                                  Journal Line No.=FIELD(Line No.);
                      Promoted=Yes;
                      Image=Allocations;
                      PromotedCategory=Process }
      { 57      ;2   ;Action    ;
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
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 41      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 42      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 15;
                      Image=EditLines }
      { 43      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 14;
                      Promoted=No;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 85      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 87      ;2   ;Action    ;
                      CaptionML=[DAN=Inds‘t konv. RV-afrund.linjer;
                                 ENU=Insert Conv. LCY Rndg. Lines];
                      ToolTipML=[DAN=Inds‘t en afrundingslinjer i kladden. Denne afrundingslinjer afstemmes i RV, hvis bel›b i den udenlandske valuta og afstemmes. Derefter kan du bogf›re kladden.;
                                 ENU=Insert a rounding correction line in the journal. This rounding correction line will balance in LCY when amounts in the foreign currency also balance. You can then post the journal.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 407;
                      Image=InsertCurrency }
      { 44      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 45      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=F† vist en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Suite;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintGenJnlLine(Rec);
                               END;
                                }
      { 46      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 231;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process }
      { 5       ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Suite;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 GenJnlPost@1001 : Codeunit 231;
                               BEGIN
                                 GenJnlPost.Preview(Rec);
                               END;
                                }
      { 47      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden, og forbered udskrivning. V‘rdierne og m‘ngderne bogf›res p† de relevante konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 232;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 37  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som kladden er baseret p†.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Suite;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             GenJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           GenJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et gentagelsesprincip, hvis feltet Gentagelse i tabellen Finanskladdetype angiver, at kladden er en gentagelseskladde.;
                           ENU=Specifies a recurring method if the Recurring field of the General Journal Template table indicates the journal is recurring.];
                ApplicationArea=#Suite;
                SourceExpr="Recurring Method" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et gentagelsesinterval, hvis feltet Gentagelse i tabellen Finanskladdetype angiver, at kladden er en gentagelseskladde.;
                           ENU=Specifies a recurring frequency if the Recurring field of the General Journal Template table indicates the journal is recurring.];
                ApplicationArea=#Suite;
                SourceExpr="Recurring Frequency" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Suite;
                SourceExpr="Posting Date" }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Suite;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type bilag posten p† kladdelinjen er.;
                           ENU=Specifies the type of document that the entry on the journal line is.];
                ApplicationArea=#Suite;
                SourceExpr="Document Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Document No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som posten i kladdelinjen skal inds‘ttes p†.;
                           ENU=Specifies the type of account that the entry on the journal line will be posted to.];
                ApplicationArea=#Suite;
                SourceExpr="Account Type";
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                           END;
                            }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer, som posten i kladdelinjen skal inds‘ttes p†.;
                           ENU=Specifies the account number that the entry on the journal line will be posted to.];
                ApplicationArea=#Suite;
                SourceExpr="Account No.";
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf›res til, hvis du har valgt Anl‘gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#Advanced;
                SourceExpr="Depreciation Book Code";
                Visible=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringstypen, hvis feltet Kontotype indeholder Anl‘gsaktiv.;
                           ENU=Specifies the posting type, if Account Type field contains Fixed Asset.];
                ApplicationArea=#Advanced;
                SourceExpr="FA Posting Type";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncernvirksomhed, som posten er afledt fra i en konsolideret virksomhed.;
                           ENU=Specifies the code of the business unit that the entry derives from in a consolidated company.];
                ApplicationArea=#Advanced;
                SourceExpr="Business Unit Code";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den s‘lger eller indk›ber, der er tilknyttet kladdelinjen.;
                           ENU=Specifies the salesperson or purchaser who is linked to the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som kladdelinjen er tilknyttet.;
                           ENU=Specifies the number of the campaign that the journal line is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver valutakoden for bel›bene p† kladdelinjen.;
                           ENU=Specifies the code of the currency for the amounts on the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Visible=FALSE;
                OnAssistEdit=BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);

                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionstypen.;
                           ENU=Specifies the type of transaction.];
                ApplicationArea=#Suite;
                SourceExpr="Gen. Posting Type" }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne kreditoren, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Suite;
                SourceExpr="Gen. Bus. Posting Group" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b (bel›b inkl. moms), der er indeholdt i kladdelinjen.;
                           ENU=Specifies the total amount (including VAT) that the journal line consists of.];
                ApplicationArea=#Suite;
                SourceExpr=Amount;
                Visible=AmountVisible }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b i lokal valuta (bel›b inkl. moms), der er indeholdt i kladdelinjen.;
                           ENU=Specifies the total amount in local currency (including VAT) that the journal line consists of.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount (LCY)";
                Visible=AmountVisible }

    { 1000;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Suite;
                SourceExpr="Debit Amount";
                Visible=DebitCreditVisible }

    { 1001;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Suite;
                SourceExpr="Credit Amount";
                Visible=DebitCreditVisible }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsbel›bet, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of VAT that is included in the total amount.];
                ApplicationArea=#Suite;
                SourceExpr="VAT Amount";
                Visible=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og et momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculated VAT amount and a VAT amount that you have entered manually.];
                ApplicationArea=#Suite;
                SourceExpr="VAT Difference";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                           END;
                            }

    { 302 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                           END;
                            }

    { 304 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                           END;
                            }

    { 306 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                           END;
                            }

    { 308 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                           END;
                            }

    { 310 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                           END;
                            }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Suite;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogf›rt bilag, som dette bilag eller denne kladdelinje udlignes med, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to Doc. Type";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bogf›rte bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to Doc. No.";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, n†r du v‘lger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to ID";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den tilknyttede post repr‘senterer en ubetalt faktura, som der findes et betalingsforslag, en rykker eller en rentenota til.;
                           ENU=Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.];
                ApplicationArea=#Advanced;
                SourceExpr="On Hold";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den betalingstype, der skal bruges for posten p† kladdelinjen.;
                           ENU=Specifies the code for the payment type to be used for the entry on the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Bank Payment Type";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Suite;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, der er blevet fordelt, n†r du har brugt funktionen fordelinger i tabellen Fordeling.;
                           ENU=Specifies the amount that has been allocated when you have used the Allocations function in the Gen. Jnl. Allocation table.];
                ApplicationArea=#Suite;
                SourceExpr="Allocated Amt. (LCY)";
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              COMMIT;
                              GenJnlAlloc.RESET;
                              GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
                              GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
                              GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
                              PAGE.RUNMODAL(PAGE::Allocations,GenJnlAlloc);
                              CurrPage.UPDATE(FALSE);
                            END;
                             }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den faktureringsdebitor eller -kreditor, som posten er tilknyttet.;
                           ENU=Specifies the number of the bill-to customer or pay-to vendor that the entry is linked to.];
                ApplicationArea=#Suite;
                SourceExpr="Bill-to/Pay-to No.";
                Visible=FALSE }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressekoden for leveringen til debitoren eller ordren fra kreditoren, som posten er tilknyttet.;
                           ENU=Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to/Order Address Code";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste dato for bogf›ring af gentagelseskladden, hvis du har angivet, at kladden er en gentagelseskladde.;
                           ENU=Specifies the last date the recurring journal will be posted, if you have indicated in the journal is recurring.];
                ApplicationArea=#Suite;
                SourceExpr="Expiration Date" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kommentar, der er relateret til registrering af en betaling.;
                           ENU=Specifies a comment related to registering a payment.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment;
                Visible=FALSE }

    { 28  ;1   ;Group      }

    { 1902205001;2;Group  ;
                GroupType=FixedLayout }

    { 1901652501;3;Group  ;
                CaptionML=[DAN=Kontonavn;
                           ENU=Account Name] }

    { 33  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontoen.;
                           ENU=Specifies the name of the account.];
                ApplicationArea=#Suite;
                SourceExpr=AccName;
                Editable=FALSE;
                ShowCaption=No }

    { 1903866901;3;Group  ;
                CaptionML=[DAN=Saldo;
                           ENU=Balance] }

    { 29  ;4   ;Field     ;
                Name=Balance;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Angiver den saldo, der er akkumuleret i finansgentagelseskladden p† den linje, hvor mark›ren er placeret.;
                           ENU=Specifies the balance that has accumulated in the recurring general journal on the line where the cursor is.];
                ApplicationArea=#All;
                SourceExpr=Balance + "Balance (LCY)" - xRec."Balance (LCY)";
                AutoFormatType=1;
                Visible=BalanceVisible;
                Editable=FALSE }

    { 1902759701;3;Group  ;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance] }

    { 31  ;4   ;Field     ;
                Name=TotalBalance;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance];
                ToolTipML=[DAN=Angiver den totale saldo i finansgentagelseskladden.;
                           ENU=Specifies the total balance in the recurring general journal.];
                ApplicationArea=#All;
                SourceExpr=TotalBalance + "Balance (LCY)" - xRec."Balance (LCY)";
                AutoFormatType=1;
                Visible=TotalBalanceVisible;
                Editable=FALSE }

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
      GenJnlAlloc@1001 : Record 221;
      GenJnlManagement@1002 : Codeunit 230;
      ReportPrint@1003 : Codeunit 228;
      ChangeExchangeRate@1000 : Page 511;
      CurrentJnlBatchName@1004 : Code[10];
      AccName@1005 : Text[50];
      BalAccName@1006 : Text[50];
      Balance@1007 : Decimal;
      TotalBalance@1008 : Decimal;
      ShowBalance@1009 : Boolean;
      ShowTotalBalance@1010 : Boolean;
      ShortcutDimCode@1011 : ARRAY [8] OF Code[20];
      BalanceVisible@19073040 : Boolean INDATASET;
      TotalBalanceVisible@19063333 : Boolean INDATASET;
      AmountVisible@1013 : Boolean;
      DebitCreditVisible@1012 : Boolean;

    LOCAL PROCEDURE UpdateBalance@1();
    BEGIN
      GenJnlManagement.CalcBalance(
        Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
      BalanceVisible := ShowBalance;
      TotalBalanceVisible := ShowTotalBalance;
    END;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
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

