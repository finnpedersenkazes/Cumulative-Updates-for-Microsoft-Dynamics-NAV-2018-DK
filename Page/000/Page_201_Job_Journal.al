OBJECT Page 201 Job Journal
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagskladde;
               ENU=Job Journal];
    SaveValues=Yes;
    SourceTable=Table210;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Side;
                                ENU=New,Process,Report,Page];
    OnOpenPage=VAR
                 ServerConfigSettingHandler@1001 : Codeunit 6723;
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   JobJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 JobJnlManagement.TemplateSelection(PAGE::"Job Journal",FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 JobJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                  CLEAR(ShortcutDimCode);
                END;

    OnDeleteRecord=VAR
                     ReserveJobJnlLine@1000 : Codeunit 99000844;
                   BEGIN
                     COMMIT;
                     IF NOT ReserveJobJnlLine.DeleteLineConfirm(Rec) THEN
                       EXIT(FALSE);
                     ReserveJobJnlLine.DeleteLine(Rec);
                   END;

    OnAfterGetCurrRecord=BEGIN
                           JobJnlManagement.GetNames(Rec,JobDescription,AccName);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 90      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 91      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 92      ;2   ;Action    ;
                      Name=ItemTrackingLines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines(FALSE);
                               END;
                                }
      { 28      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Sag;
                                 ENU=&Job];
                      Image=Job }
      { 37      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 88;
                      RunPageLink=No.=FIELD(Job No.);
                      Image=EditLines }
      { 38      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 92;
                      RunPageView=SORTING(Job No.,Posting Date);
                      RunPageLink=Job No.=FIELD(Job No.);
                      Image=CustomerLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 93      ;2   ;Action    ;
                      Name=CalcRemainingUsage;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn resterede forbrug;
                                 ENU=Calc. Remaining Usage];
                      ToolTipML=[DAN=Beregn det resterende forbrug for sagen. K›rslen beregner forskellen mellem planlagt forbrug af varer, ressourcer og finansudgifter og det faktiske forbrug, der er bogf›rt i finansposterne, for hver sagsopgave. Det resterende forbrug vises derefter i den sagskladde, hvor du kan bogf›re det.;
                                 ENU=Calculate the remaining usage for the job. The batch job calculates, for each job task, the difference between scheduled usage of items, resources, and expenses and actual usage posted in job ledger entries. The remaining usage is then displayed in the job journal from where you can post it.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=CalculateRemainingUsage;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 JobCalcRemainingUsage@1001 : Report 1090;
                               BEGIN
                                 TESTFIELD("Journal Template Name");
                                 TESTFIELD("Journal Batch Name");
                                 CLEAR(JobCalcRemainingUsage);
                                 JobCalcRemainingUsage.SetBatch("Journal Template Name","Journal Batch Name");
                                 JobCalcRemainingUsage.SetDocNo("Document No.");
                                 JobCalcRemainingUsage.RUNMODAL;
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=SuggestLinesFromTimeSheets;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Foresl† linjer fra timesedler;
                                 ENU=Suggest Lines from Time Sheets];
                      ToolTipML=[DAN=Udfyld kladden med linjer, der findes p† timesedlerne.;
                                 ENU=Fill the journal with lines that exist in the time sheets.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=SuggestLines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SuggestJobJnlLines@1000 : Report 952;
                               BEGIN
                                 SuggestJobJnlLines.SetJobJnlLine(Rec);
                                 SuggestJobJnlLines.RUNMODAL;
                               END;
                                }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 40      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F11;
                      CaptionML=[DAN=Afstem;
                                 ENU=Reconcile];
                      ToolTipML=[DAN=Vis, hvad der er afstemt for sagen, Vinduet viser det anf›rte antal p† sagskladdelinjerne, med totaler for enhed og for arbejdstype.;
                                 ENU=View what has been reconciled for the job. The window shows the quantity entered on the job journal lines, totaled by unit of measure and by work type.];
                      ApplicationArea=#Jobs;
                      Image=Reconcile;
                      OnAction=BEGIN
                                 JobJnlReconcile.SetJobJnlLine(Rec);
                                 JobJnlReconcile.RUN;
                               END;
                                }
      { 41      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=F† vist en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Jobs;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintJobJnlLine(Rec);
                               END;
                                }
      { 56      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 57      ;2   ;Action    ;
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
                                 CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post+Print",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 13      ;2   ;Action    ;
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

    { 78  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som kladden er baseret p†.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Jobs;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             JobJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           JobJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen for en sagsplanl‘gningslinje i forbindelse med bogf›ringen af en sagspost. De forskellige indstillinger er beskrevet i den f›lgende tabel.;
                           ENU=Specifies the line type of a job planning line in the context of posting of a job ledger entry. The options are described in the following table.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringsdato, du vil tildele den enkelte kladdelinje. Se Angive datoer og klokkesl‘t for at f† flere oplysninger.;
                           ENU=Specifies the posting date you want to assign to each journal line. For more information, see Entering Dates and Times.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Date" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Document No." }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Jobs;
                SourceExpr="External Document No.";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† sagen.;
                           ENU=Specifies the number of the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                OnValidate=BEGIN
                             JobJnlManagement.GetNames(Rec,JobDescription,AccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kontotype for det sagsforbrug, der skal bogf›res i sagskladden. Du kan v‘lge mellem disse indstillinger:;
                           ENU=Specifies an account type for job usage to be posted in the job journal. You can choose from the following options:];
                ApplicationArea=#Jobs;
                SourceExpr=Type;
                OnValidate=BEGIN
                             JobJnlManagement.GetNames(Rec,JobDescription,AccName);
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Jobs;
                SourceExpr="No.";
                OnValidate=BEGIN
                             JobJnlManagement.GetNames(Rec,JobDescription,AccName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den ressource, vare eller finanskonto, som posten vedr›rer. Du kan ‘ndre beskrivelsen.;
                           ENU=Specifies the name of the resource, item, or general ledger account to which this entry applies. You can change the description.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sagsplanl‘gningslinjenummer, som forbruget skal knyttes til, n†r sagskladden bogf›res. Du kan kun knytte til sagsplanl‘gningslinjer, hvor indstillingen Anvend anvendelseslink er aktiveret.;
                           ENU=Specifies the job planning line number to which the usage should be linked when the Job Journal is posted. You can only link to Job Planning Lines that have the Apply Usage Link option enabled.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Planning Line No.";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Jobs;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
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

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en lokationskode for en vare.;
                           ENU=Specifies a location code for an item.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen udlignes med. Priserne opdateres ud fra denne post.;
                           ENU=Specifies which work type the resource applies to. Prices are updated based on this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Work Type Code" }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sagens valutakode, der er angivet i feltet Valutakode p† jobkortet. Du kan kun oprette en sagskladde med brug af denne valutakode.;
                           ENU=Specifies the job's currency code that listed in the Currency Code field in the Job Card. You can only create a Job Journal using this currency code.];
                ApplicationArea=#Jobs;
                SourceExpr="Currency Code";
                Visible=FALSE;
                OnAssistEdit=VAR
                               ChangeExchangeRate@1000 : Page 511;
                             BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);

                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit of Measure Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af enheder i sagskladdens Nummer-felt, dvs. enten ressource-, vare- eller finanskontonummeret, som g‘lder. Hvis du senere ‘ndrer v‘rdien i feltet Nummer, ‘ndres antallet p† kladdelinjen ikke.;
                           ENU=Specifies the number of units of the job journal's No. field, that is, either the resource, item, or G/L account number, that applies. If you later change the value in the No. field, the quantity does not change on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr=Quantity }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af ressourcen eller varen, der mangler i fuldf›relsen af en sag. Det resterende antal beregnes som differencen mellem Antal og Bogf. antal. Du kan ‘ndre dette felt for at angive det antal, der skal forblive p† sagsplanl‘gningslinjen, n†r du har bogf›rt forbruget.;
                           ENU=Specifies the quantity of the resource or item that remains to complete a job. The remaining quantity is calculated as the difference between Quantity and Qty. Posted. You can modify this field to indicate the quantity you want to remain on the job planning line after you post usage.];
                ApplicationArea=#Jobs;
                SourceExpr="Remaining Qty.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen i den lokale valuta for en enhed af den vare eller ressource, der er valgt.;
                           ENU=Specifies the cost, in the local currency, of one unit of the selected item or resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Direct Unit Cost (LCY)";
                Visible=FALSE }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost" }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost (LCY)" }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel›bet for kladdelinjen. Kostbel›bet beregnes i sagens valuta, som stammer fra feltet Valutakode p† jobkortet.;
                           ENU=Specifies the total cost for the journal line. The total cost is calculated based on the job currency, which comes from the Currency Code field on the Job card.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Cost" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel›bet for denne kladdelinje. Bel›bet vises i den lokale valuta.;
                           ENU=Specifies the total cost for this journal line. The amount is in the local currency.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Cost (LCY)" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen i RV. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price, in LCY, of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price (LCY)";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som vil blive bogf›rt for sagsposten.;
                           ENU=Specifies the amount that will be posted to the job ledger.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Amount" }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b i den lokale valuta, som vil blive bogf›rt for sagsposten.;
                           ENU=Specifies the amount in the local currency that will be posted to the job ledger.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Amount (LCY)";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel›b, der ydes p† varen, p† linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Discount Amount" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatprocenten.;
                           ENU=Specifies the line discount percentage.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Discount %" }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsbel›bet i sagens valuta p† kladdelinjen.;
                           ENU=Specifies the total price in the job currency on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Price";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsbel›bet for kladdelinjen. Bel›bet vises i den lokale valuta.;
                           ENU=Specifies the total price for the journal line. The amount is in the local currency.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Price (LCY)";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvis sagskladdelinjen har typen Vare, og forbruget af varen anvendes p† en allerede bogf›rt varepost. Hvis det er tilf‘ldet, skal du angive det postnummer, som forbruget anvendes p†.;
                           ENU=Specifies if the job journal line has of type Item and the usage of the item will be applied to an already-posted item ledger entry. If this is the case, enter the entry number that the usage will be applied to.];
                ApplicationArea=#Jobs;
                SourceExpr="Applies-to Entry" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† vareposten, som kladdelinjeomkostningerne er udlignet fra. Dette b›r g›res, n†r du tilbagef›rer forbruget af en vare i en sag, og du vil returnere varen til lageret med den samme omkostning, som f›r den blev brugt i sagen.;
                           ENU=Specifies the number of the item ledger entry that the journal line costs have been applied from. This should be done when you reverse the usage of an item in a job and you want to return the item to inventory at the same cost as before it was used in the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Applies-from Entry";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Jobs;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr‘senterer med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Jobs;
                SourceExpr="Transaction Type";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm†den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Jobs;
                SourceExpr="Transport Method";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† en timeseddel. Der tildeles et nummer til hver timeseddel ved oprettelse. Nummeret kan ikke ‘ndres.;
                           ENU=Specifies the number of a time sheet. A number is assigned to each time sheet when it is created. You cannot edit the number.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet No.";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret for en timeseddel.;
                           ENU=Specifies the line number for a time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet Line No.";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor der er oprettet en timeseddel.;
                           ENU=Specifies the date that a time sheet is created.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet Date";
                Visible=FALSE }

    { 73  ;1   ;Group      }

    { 1902114901;2;Group  ;
                GroupType=FixedLayout }

    { 1903098501;3;Group  ;
                CaptionML=[DAN=Sagsbeskrivelse;
                           ENU=Job Description] }

    { 74  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af sagen.;
                           ENU=Specifies a description of the job.];
                ApplicationArea=#Jobs;
                SourceExpr=JobDescription;
                Editable=FALSE;
                ShowCaption=No }

    { 1901991301;3;Group  ;
                CaptionML=[DAN=Kontonavn;
                           ENU=Account Name] }

    { 76  ;4   ;Field     ;
                CaptionML=[DAN=Kontonavn;
                           ENU=Account Name];
                ToolTipML=[DAN=Angiver navnet p† den debitor eller kreditor, som sagen er relateret til.;
                           ENU=Specifies the name of the customer or vendor that the job is related to.];
                ApplicationArea=#Jobs;
                SourceExpr=AccName;
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
      JobJnlManagement@1001 : Codeunit 1020;
      ReportPrint@1002 : Codeunit 228;
      ClientTypeManagement@1008 : Codeunit 4;
      JobJnlReconcile@1000 : Page 376;
      JobDescription@1003 : Text[50];
      AccName@1004 : Text[50];
      CurrentJnlBatchName@1005 : Code[10];
      ShortcutDimCode@1006 : ARRAY [8] OF Code[20];
      IsSaasExcelAddinEnabled@1007 : Boolean;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      JobJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

