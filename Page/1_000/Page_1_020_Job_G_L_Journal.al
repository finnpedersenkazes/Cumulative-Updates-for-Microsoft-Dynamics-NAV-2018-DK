OBJECT Page 1020 Job G/L Journal
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagsfinanskladde;
               ENU=Job G/L Journal];
    SaveValues=Yes;
    SourceTable=Table81;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Side;
                                ENU=New,Process,Report,Page];
    OnInit=BEGIN
             TotalBalanceVisible := TRUE;
             BalanceVisible := TRUE;
             AmountVisible := TRUE;
           END;

    OnOpenPage=VAR
                 ServerConfigSettingHandler@1001 : Codeunit 6723;
                 JnlSelected@1000 : Boolean;
               BEGIN
                 PreviewGuid := CREATEGUID;

                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 GenJnlManagement.TemplateSelection(PAGE::"Job G/L Journal",7,FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);

                 ShowAmounts;
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  UpdateBalance;
                  SetUpNewLine(xRec,Balance,BelowxRec);
                  CLEAR(ShortcutDimCode);
                  CLEAR(AccName);
                END;

    OnInsertRecord=BEGIN
                     PreviewGuid := CREATEGUID;
                   END;

    OnModifyRecord=BEGIN
                     PreviewGuid := CREATEGUID;
                   END;

    OnDeleteRecord=BEGIN
                     PreviewGuid := CREATEGUID;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                           UpdateBalance;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 75      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 76      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Jobs;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 43      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 44      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Jobs;
                      RunObject=Codeunit 15;
                      Image=EditLines }
      { 45      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Fi&nansposter;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Codeunit 14;
                      Promoted=No;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions] }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Renummerer bilagsnumre;
                                 ENU=Renumber Document Numbers];
                      ToolTipML=[DAN=Omsorter tallene i kolonnen Bilagsnr. for at undg† bogf›ringsfejl, der skyldes, at bilagsnumrene ikke st†r i korrekt r‘kkef›lge. Efterudligninger og linjegrupperinger fastholdes.;
                                 ENU=Resort the numbers in the Document No. column to avoid posting errors because the document numbers are not in sequence. Entry applications and line groupings are preserved.];
                      ApplicationArea=#Jobs;
                      Image=EditLines;
                      OnAction=BEGIN
                                 RenumberDocumentNo
                               END;
                                }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 48      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F11;
                      CaptionML=[DAN=Afstem;
                                 ENU=Reconcile];
                      ToolTipML=[DAN=Vis, hvad der er afstemt for sagen, Vinduet viser det anf›rte antal p† sagskladdelinjerne, med totaler for enhed og for arbejdstype.;
                                 ENU=View what has been reconciled for the job. The window shows the quantity entered on the job journal lines, totaled by unit of measure and by work type.];
                      ApplicationArea=#Jobs;
                      Image=Reconcile;
                      OnAction=BEGIN
                                 GLReconcile.SetGenJnlLine(Rec);
                                 GLReconcile.RUN;
                               END;
                                }
      { 49      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=F† vist en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Jobs;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintGenJnlLine(Rec);
                               END;
                                }
      { 50      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=B&ogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer dokumentet eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Jobs;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 GenJnlPost@1001 : Codeunit 231;
                               BEGIN
                                 GenJnlPost.Preview(Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 51      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden, og forbered udskrivning. V‘rdierne og m‘ngderne bogf›res p† de relevante konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 17      ;2   ;Action    ;
                      Name=EditInExcel;
                      CaptionML=[DAN=Rediger i Excel;
                                 ENU=Edit in Excel];
                      ToolTipML=[DAN=Send dataene i kladden til en Excel-fil til analyse eller redigering.;
                                 ENU=Send the data in the journal to an Excel file for analysis or editing.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaasExcelAddinEnabled;
                      PromotedIsBig=Yes;
                      Image=Excel;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ODataUtility@1000 : Codeunit 6710;
                               BEGIN
                                 ODataUtility.EditJournalWorksheetInExcel(CurrPage.CAPTION,CurrPage.OBJECTID(FALSE),"Journal Batch Name","Journal Template Name");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 39  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som kladden er baseret p†.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Jobs;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             PreviewGuid := CREATEGUID;
                             GenJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           PreviewGuid := CREATEGUID;
                           CurrPage.SAVERECORD;
                           GenJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Date" }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type bilag posten p† kladdelinjen er.;
                           ENU=Specifies the type of document that the entry on the journal line is.];
                ApplicationArea=#Jobs;
                SourceExpr="Document Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Document No." }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Jobs;
                SourceExpr="External Document No.";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som posten i kladdelinjen skal inds‘ttes p†.;
                           ENU=Specifies the type of account that the entry on the journal line will be posted to.];
                ApplicationArea=#Jobs;
                SourceExpr="Account Type";
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer, som posten i kladdelinjen skal inds‘ttes p†.;
                           ENU=Specifies the account number that the entry on the journal line will be posted to.];
                ApplicationArea=#Jobs;
                SourceExpr="Account No.";
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den koncernvirksomhedskode, som sagsposten er tilknyttet.;
                           ENU=Specifies the code for the business unit that the job entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Business Unit Code";
                Visible=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den s‘lger eller indk›ber, der er tilknyttet kladdelinjen.;
                           ENU=Specifies the salesperson or purchaser who is linked to the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som kladdelinjen er tilknyttet.;
                           ENU=Specifies the number of the campaign that the journal line is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 67  ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver valutakoden for bel›bene p† kladdelinjen.;
                           ENU=Specifies the code of the currency for the amounts on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Currency Code";
                Visible=FALSE;
                OnAssistEdit=BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);

                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionstypen.;
                           ENU=Specifies the type of transaction.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Posting Type" }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Bus. Posting Group" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Prod. Posting Group" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den momssats, der g‘lder for den aktuelle kombination af momsvirksomhedsbogf›ringsgruppe og momsproduktbogf›ringsgruppe. Brug ikke procenttegn, n†r du indtaster momsprocenten, kun tal. Hvis momssatsen f.eks. er 25 %, skal du indtaste 25 i feltet.;
                           ENU=Specifies the relevant VAT rate for the particular combination of VAT business posting group and VAT product posting group. Do not enter the percent sign, only the number. For example, if the VAT rate is 25 %, enter 25 in this field.];
                ApplicationArea=#Jobs;
                SourceExpr="VAT %";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b (bel›b inkl. moms), der er indeholdt i kladdelinjen.;
                           ENU=Specifies the total amount (including VAT) that the journal line consists of.];
                ApplicationArea=#Jobs;
                SourceExpr=Amount;
                Visible=AmountVisible }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b i lokal valuta (bel›b inkl. moms), der er indeholdt i kladdelinjen.;
                           ENU=Specifies the total amount in local currency (including VAT) that the journal line consists of.];
                ApplicationArea=#Jobs;
                SourceExpr="Amount (LCY)";
                Visible=AmountVisible }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Jobs;
                SourceExpr="Debit Amount";
                Visible=DebitCreditVisible }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Jobs;
                SourceExpr="Credit Amount";
                Visible=DebitCreditVisible }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsbel›bet, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of VAT that is included in the total amount.];
                ApplicationArea=#Jobs;
                SourceExpr="VAT Amount";
                Visible=FALSE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og et momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculated VAT amount and a VAT amount that you have entered manually.];
                ApplicationArea=#Jobs;
                SourceExpr="VAT Difference";
                Visible=FALSE }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for modkontomoms, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of Bal. VAT included in the total amount.];
                ApplicationArea=#Jobs;
                SourceExpr="Bal. VAT Amount";
                Visible=FALSE }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og det momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.];
                ApplicationArea=#Jobs;
                SourceExpr="Bal. VAT Difference";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf›res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Jobs;
                SourceExpr="Bal. Account Type" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf›res til, f.eks. en kassekonto ved kontantk›b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Jobs;
                SourceExpr="Bal. Account No.";
                OnValidate=BEGIN
                             GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringstype, der er knyttet til den modkonto, som vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Bal. Gen. Posting Type" }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den virksomhedsbogf›ringsgruppe, der er knyttet til den modkonto, som vil blive brugt, n†r du bogf›rer posten.;
                           ENU=Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Bal. Gen. Bus. Posting Group" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den produktbogf›ringsgruppe, der er knyttet til den modkonto, der vil blive brugt, n†r du bogf›rer posten.;
                           ENU=Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Bal. Gen. Prod. Posting Group" }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for momsvirksomhedsbogf›ringsgruppen, som vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Bal. VAT Bus. Posting Group";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den momsproduktbogf›ringsgruppe, der vil blive brugt, n†r du bogf›rer posten p† kladdelinjen.;
                           ENU=Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Bal. VAT Prod. Posting Group";
                Visible=FALSE }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den faktureringsdebitor eller -kreditor, som posten er tilknyttet.;
                           ENU=Specifies the number of the bill-to customer or pay-to vendor that the entry is linked to.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to/Pay-to No.";
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressekoden for leveringen til debitoren eller ordren fra kreditoren, som posten er tilknyttet.;
                           ENU=Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.];
                ApplicationArea=#Jobs;
                SourceExpr="Ship-to/Order Address Code";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Jobs;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Jobs;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Jobs;
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
                ApplicationArea=#Jobs;
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
                ApplicationArea=#Jobs;
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
                ApplicationArea=#Jobs;
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
                ApplicationArea=#Jobs;
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
                ApplicationArea=#Jobs;
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

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Jobs;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogf›rt bilag, som dette bilag eller denne kladdelinje udlignes med, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Jobs;
                SourceExpr="Applies-to Doc. Type";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bogf›rte bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Jobs;
                SourceExpr="Applies-to Doc. No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, n†r du v‘lger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#Jobs;
                SourceExpr="Applies-to ID";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kladdelinjen er faktureret, og om du udf›rer k›rslen betalingsforslag eller opretter en rentenota eller en rykker.;
                           ENU=Specifies if the journal line has been invoiced, and you execute the payment suggestions batch job, or you create a finance charge memo or reminder.];
                ApplicationArea=#Jobs;
                SourceExpr="On Hold";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den betalingstype, der skal bruges for posten p† kladdelinjen.;
                           ENU=Specifies the code for the payment type to be used for the entry on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Bank Payment Type";
                Visible=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No.";
                OnValidate=BEGIN
                             IF JobTaskIsSet THEN
                               ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sagsplanl‘gningslinjenummer, som forbruget skal knyttes til, n†r sagskladden bogf›res. Du kan kun knytte til sagsplanl‘gningslinjer, hvor indstillingen Anvend anvendelseslink er aktiveret.;
                           ENU=Specifies the job planning line number to which the usage should be linked when the Job Journal is posted. You can only link to Job Planning Lines that have the Apply Usage Link option enabled.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Planning Line No.";
                Visible=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type planl‘gningslinje der blev oprettet, da sagsposten blev bogf›rt. Hvis feltet er tomt, er der ikke oprettet planl‘gningslinjer for denne post.;
                           ENU=Specifies the type of planning line that was created when the job ledger entry is posted. If the field is empty, no planning lines were created for this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Type" }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den enhedskode, der anvendes til fasts‘ttelse af enhedsprisen. Denne kode angiver, hvordan antallet m†les, f.eks. i kasser eller stykker. Programmet henter denne kode fra den tilsvarende vare eller ressourcekortet.;
                           ENU=Specifies the unit of measure code that is used to determine the unit price. This code specifies how the quantity is measured, for example, by the box or by the piece. The application retrieves this code from the corresponding item or resource card.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Unit Of Measure Code";
                Visible=FALSE }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for den sagspost, der er afledt fra bogf›ringen af kladdelinjen. Hvis Antal sager er 0, vil det samlede bel›b i sagsposten ogs† v‘re 0.;
                           ENU=Specifies the quantity for the job ledger entry that is derived from posting the journal line. If the Job Quantity is 0, the total amount on the job ledger entry will also be 0.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Quantity" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sagsomkostningerne for en enhed af varen eller ressourcen p† kladdelinjen. V‘rdien beregnes p† f›lgende m†de: Kostbel›b for sag (RV)/Antal sager.;
                           ENU=Specifies the job cost of one unit of the item or resource on the journal line. The value is calculated as follows: Job Total Cost (LCY) / Job Quantity.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Unit Cost" }

    { 117 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sagsomkostningerne for en enhed af varen eller ressourcen p† kladdelinjen i den lokale valuta. V‘rdien beregnes p† f›lgende m†de: Kostbel›b for sag (RV)/Antal sager.;
                           ENU=Specifies the job cost of one unit of the item or resource on the journal line, in the local currency. The value is calculated as follows: Job Total Cost (LCY) / Job Quantity.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Unit Cost (LCY)" }

    { 126 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du har tildelt et sagsnummer og et sagsopgavenummer til kladdelinjen. Det viser bel›bet uden moms, divideret med antallet af sager for kladdelinjen. Bel›bet vises i den valuta, der er angivet for sagen. V‘rdifeltet beregnes p† f›lgende m†de: (Bel›b - momsbel›b) x (Sagsvalutakurs/valutakurs).;
                           ENU=Specifies if you have assigned a job number and a job task number to the journal line. It shows the amount excluding VAT divided by the job quantity for the journal line. The amount is shown in the currency specified for the job. The value field is calculated as follows: (Amount - VAT Amount) x (Job Currency Rate/Currency Rate).];
                ApplicationArea=#Jobs;
                SourceExpr="Job Total Cost" }

    { 141 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel›bet for sag, hvis du har tildelt et sagsnummer og et sagsopgavenummer til kladdelinjen. Feltet indeholder Bel›b (RV) eksklusive Momsbel›b (RV) for kladdelinjen.;
                           ENU=Specifies the job total cost if you have assigned a job number and a job task number to the journal line. It shows the Amount (LCY) excluding VAT Amount (LCY)for the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Total Cost (LCY)" }

    { 129 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedsprisen for den valgte kontotype og det valgte kontonummer p† kladdelinjen.;
                           ENU=Specifies the unit price for the selected account type and account number on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Unit Price" }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedsprisen i den lokale valuta for den valgte kontotype og det valgte kontonummer p† kladdelinjen.;
                           ENU=Specifies the unit price, in the local currency, for the selected account type and account number on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Unit Price (LCY)";
                Visible=FALSE }

    { 139 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjebel›bet for sagsposten.;
                           ENU=Specifies the line amount of the job ledger entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Amount" }

    { 134 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjebel›bet for sagsposten.;
                           ENU=Specifies the line amount of the job ledger entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Amount (LCY)" }

    { 137 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatbel›bet for sagsposten.;
                           ENU=Specifies the line discount amount of the job ledger entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Discount Amount" }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatprocentdelen for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line discount percentage of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Discount %" }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsbel›bet for kladdelinjen. V‘rdien beregnes p† f›lgende m†de: Antal x Enhedspris (RV).;
                           ENU=Specifies the total price for the journal line. The value is calculated as follows: Quantity x Unit Price (LCY).];
                ApplicationArea=#Jobs;
                SourceExpr="Job Total Price";
                Visible=FALSE }

    { 128 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsbel›bet for kladdelinjen i den lokale valuta. V‘rdien beregnes p† f›lgende m†de: Antal x Enhedspris (RV).;
                           ENU=Specifies the total price for the journal line, in the local currency. The value is calculated as follows: Quantity x Unit Price (LCY).];
                ApplicationArea=#Jobs;
                SourceExpr="Job Total Price (LCY)" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler for at afslutte en sag.;
                           ENU=Specifies the quantity that remains to complete a job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Remaining Qty.";
                Visible=FALSE }

    { 30  ;1   ;Group      }

    { 1901776101;2;Group  ;
                GroupType=FixedLayout }

    { 1900545301;3;Group  ;
                CaptionML=[DAN=Kontonavn;
                           ENU=Account Name] }

    { 35  ;4   ;Field     ;
                ApplicationArea=#Jobs;
                SourceExpr=AccName;
                Editable=FALSE;
                ShowCaption=No }

    { 1900295701;3;Group  ;
                CaptionML=[DAN=Modkontonavn;
                           ENU=Bal. Account Name] }

    { 37  ;4   ;Field     ;
                CaptionML=[DAN=Modkontonavn;
                           ENU=Bal. Account Name];
                ToolTipML=[DAN=Angiver navnet p† den modkonto, der er indtastet p† kladdelinjen.;
                           ENU=Specifies the name of the balancing account that has been entered on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr=BalAccName;
                Editable=FALSE }

    { 1902759701;3;Group  ;
                CaptionML=[DAN=Saldo;
                           ENU=Balance] }

    { 31  ;4   ;Field     ;
                Name=Balance;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Angiver den saldo, der er akkumuleret i kladden p† den linje, du har valgt.;
                           ENU=Specifies the balance that has accumulated in the journal on the line that you selected.];
                ApplicationArea=#All;
                SourceExpr=Balance + "Balance (LCY)" - xRec."Balance (LCY)";
                AutoFormatType=1;
                Visible=BalanceVisible;
                Editable=FALSE }

    { 1901652501;3;Group  ;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance] }

    { 33  ;4   ;Field     ;
                Name=TotalBalance;
                CaptionML=[DAN=Total balance;
                           ENU=Total Balance];
                ToolTipML=[DAN=Angiver den totale saldo i kladden.;
                           ENU=Specifies the total balance in the journal.];
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
      GenJnlManagement@1002 : Codeunit 230;
      ReportPrint@1003 : Codeunit 228;
      ClientTypeManagement@1077 : Codeunit 4;
      ChangeExchangeRate@1001 : Page 511;
      GLReconcile@1000 : Page 345;
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
      AmountVisible@1015 : Boolean;
      DebitCreditVisible@1014 : Boolean;
      PreviewGuid@1013 : GUID;
      IsSaasExcelAddinEnabled@1012 : Boolean;

    LOCAL PROCEDURE UpdateBalance@1();
    BEGIN
      GenJnlManagement.CalcBalance(Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
      BalanceVisible := ShowBalance;
      TotalBalanceVisible := ShowTotalBalance;
    END;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ShowAmounts@8();
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

