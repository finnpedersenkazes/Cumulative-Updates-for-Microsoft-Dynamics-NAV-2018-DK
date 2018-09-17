OBJECT Page 40 Item Journal
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varekladde;
               ENU=Item Journal];
    SaveValues=Yes;
    SourceTable=Table83;
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
                   ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 ItemJnlMgt.TemplateSelection(PAGE::"Item Journal",0,FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                  CLEAR(ShortcutDimCode);
                END;

    OnInsertRecord=BEGIN
                     IF "Entry Type" > "Entry Type"::"Negative Adjmt." THEN
                       ERROR(Text000,"Entry Type");
                   END;

    OnDeleteRecord=VAR
                     ReserveItemJnlLine@1000 : Codeunit 99000835;
                   BEGIN
                     COMMIT;
                     IF NOT ReserveItemJnlLine.DeleteLineConfirm(Rec) THEN
                       EXIT(FALSE);
                     ReserveItemJnlLine.DeleteLine(Rec);
                   END;

    OnAfterGetCurrRecord=BEGIN
                           ItemJnlMgt.GetItem("Item No.",ItemDescription);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 81      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 82      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 6500    ;2   ;Action    ;
                      Name=ItemTrackingLines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=F† vist eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      Image=ItemTrackingLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenItemTrackingLines(FALSE);
                               END;
                                }
      { 69      ;2   ;Action    ;
                      CaptionML=[DAN=Placeringsindh.;
                                 ENU=Bin Contents];
                      ToolTipML=[DAN=Vis varer i placeringen, hvis den valgte linje indeholder en placeringskode.;
                                 ENU=View items in the bin if the selected line contains a bin code.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7305;
                      RunPageView=SORTING(Location Code,Item No.,Variant Code);
                      RunPageLink=Location Code=FIELD(Location Code),
                                  Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code);
                      Image=BinContent }
      { 83      ;2   ;Action    ;
                      CaptionML=[DAN=Genbe&regn pris;
                                 ENU=&Recalculate Unit Amount];
                      ToolTipML=[DAN=Nulstil enhedsbel›bet til det bel›b, der er angivet p† varekortet.;
                                 ENU=Reset the unit amount to the amount specified on the item card.];
                      ApplicationArea=#Basic,#Suite;
                      Image=UpdateUnitCost;
                      OnAction=BEGIN
                                 RecalculateUnitAmount;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 30      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 30;
                      RunPageLink=No.=FIELD(Item No.);
                      Image=EditLines }
      { 31      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Post&er;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 38;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(Item No.);
                      Promoted=No;
                      Image=ItemLedger;
                      PromotedCategory=Process }
      { 77      ;2   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikles over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 78      ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller m†ned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 79      ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at oprette hver varefarve som en separat vare kan du n›jes med ‚n vare i forskellige farvevarianter.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByVariant)
                               END;
                                }
      { 76      ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Advanced;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByLocation)
                               END;
                                }
      { 5       ;3   ;Action    ;
                      AccessByPermission=TableData 5870=R;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByBOM)
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 71      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 72      ;2   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=&Udfold stykliste;
                                 ENU=E&xplode BOM];
                      ToolTipML=[DAN=Inds‘t nye linjer for komponenterne p† styklisten, f.eks. for at s‘lge den overordnede vare som en pakke. ADVARSEL! Linjen for den overordnede vare bliver slettet og kun repr‘senteret af en beskrivelse. Hvis du vil fortryde, skal du slette komponentlinjerne og tilf›je en linje igen for den overordnede vare.;
                                 ENU=Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.];
                      ApplicationArea=#Advanced;
                      RunObject=Codeunit 246;
                      Promoted=Yes;
                      Image=ExplodeBOM;
                      PromotedCategory=Process }
      { 7300    ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Beregn regulering (logistik);
                                 ENU=&Calculate Whse. Adjustment];
                      ToolTipML=[DAN=Beregn reguleringer i antal baseret p† lagerreguleringsplacering for hver vare i kladden. Der tilf›jes nye linjer for negative og positive antal.;
                                 ENU=Calculate adjustments in quantity based on the warehouse adjustment bin for each item in the journal. New lines are added for negative and positive quantities.];
                      ApplicationArea=#Warehouse;
                      Image=CalculateWarehouseAdjustment;
                      OnAction=BEGIN
                                 CalcWhseAdjmt.SetItemJnlLine(Rec);
                                 CalcWhseAdjmt.RUNMODAL;
                                 CLEAR(CalcWhseAdjmt);
                               END;
                                }
      { 74      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent standardkladder;
                                 ENU=&Get Standard Journals];
                      ToolTipML=[DAN=Import‚r kladdelinjer fra en standardkladde, der allerede er oprettet.;
                                 ENU=Import journal lines from a standard journal that already exists.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=GetStandardJournal;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 StdItemJnl@1001 : Record 752;
                               BEGIN
                                 StdItemJnl.FILTERGROUP := 2;
                                 StdItemJnl.SETRANGE("Journal Template Name","Journal Template Name");
                                 StdItemJnl.FILTERGROUP := 0;
                                 IF PAGE.RUNMODAL(PAGE::"Standard Item Journals",StdItemJnl) = ACTION::LookupOK THEN BEGIN
                                   StdItemJnl.CreateItemJnlFromStdJnl(StdItemJnl,CurrentJnlBatchName);
                                   MESSAGE(Text001,StdItemJnl.Code);
                                 END
                               END;
                                }
      { 75      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Gem &som standardkladde;
                                 ENU=&Save as Standard Journal];
                      ToolTipML=[DAN=Gem kladdelinjerne som en standardkladde, du kan genbruge p† et senere tidspunkt.;
                                 ENU=Save the journal lines as a standard journal that you can later reuse.];
                      ApplicationArea=#Suite;
                      Image=SaveasStandardJournal;
                      OnAction=VAR
                                 ItemJnlBatch@1007 : Record 233;
                                 ItemJnlLines@1006 : Record 83;
                                 StdItemJnl@1005 : Record 752;
                                 SaveAsStdItemJnl@1004 : Report 751;
                               BEGIN
                                 ItemJnlLines.SETFILTER("Journal Template Name","Journal Template Name");
                                 ItemJnlLines.SETFILTER("Journal Batch Name",CurrentJnlBatchName);
                                 CurrPage.SETSELECTIONFILTER(ItemJnlLines);
                                 ItemJnlLines.COPYFILTERS(Rec);

                                 ItemJnlBatch.GET("Journal Template Name",CurrentJnlBatchName);
                                 SaveAsStdItemJnl.Initialise(ItemJnlLines,ItemJnlBatch);
                                 SaveAsStdItemJnl.RUNMODAL;
                                 IF NOT SaveAsStdItemJnl.GetStdItemJournal(StdItemJnl) THEN
                                   EXIT;

                                 MESSAGE(Text002,StdItemJnl.Code);
                               END;
                                }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 33      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=F† vist en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintItemJnlLine(Rec);
                               END;
                                }
      { 34      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=B&ogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 35      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden, og forbered udskrivning. V‘rdierne og m‘ngderne bogf›res p† de relevante konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 70      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du f†r vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ItemJnlLine@1001 : Record 83;
                               BEGIN
                                 ItemJnlLine.COPY(Rec);
                                 ItemJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
                                 ItemJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
                                 REPORT.RUNMODAL(REPORT::"Inventory Movement",TRUE,TRUE,ItemJnlLine);
                               END;
                                }
      { 150     ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 151     ;2   ;Action    ;
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

    { 25  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som kladden er baseret p†.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             ItemJnlMgt.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           ItemJnlMgt.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion der skal bogf›res fra varekladdelinjen.;
                           ENU=Specifies the type of transaction that will be posted from the item journal line.];
                OptionCaptionML=[DAN=K›b,Salg,Opregulering,Nedregulering;
                                 ENU=Purchase,Sale,Positive Adjmt.,Negative Adjmt.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nummer p† kladdelinjen.;
                           ENU=Specifies the number of the item on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No.";
                OnValidate=BEGIN
                             ItemJnlMgt.GetItem("Item No.",ItemDescription);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p† kladdelinjen.;
                           ENU=Specifies a description of the item on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 43  ;2   ;Field     ;
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

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lagerlokation, hvor varen p† kladdelinjen skal registreres.;
                           ENU=Specifies the code for the inventory location where the item on the journal line will be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=TRUE;
                OnValidate=VAR
                             WMSManagement@1001 : Codeunit 7302;
                           BEGIN
                             WMSManagement.CheckItemJnlLineLocation(Rec,xRec);
                           END;
                            }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger eller indk›ber, der er knyttet til salget eller k›bet p† kladdelinjen.;
                           ENU=Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal indg† i linjen.;
                           ENU=Specifies the number of units of the item to be included on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Quantity }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen p† ‚n enhed af varen p† kladdelinjen.;
                           ENU=Specifies the price of one unit of the item on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Amount" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjens nettobel›b.;
                           ENU=Specifies the line's net amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rabatbel›bet for denne post p† linjen.;
                           ENU=Specifies the discount amount of this entry on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Discount Amount" }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k›bspris, der omfatter indirekte omkostninger, s†som fragt, der er knyttet til k›bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Indirect Cost %";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om antallet p† kladdelinjen skal udlignes med en allerede bogf›rt post. Hvis det er tilf‘ldet, skal du angive det l›benummer, som antallet skal udlignes efter.;
                           ENU=Specifies if the quantity on the journal line must be applied to an already-posted entry. In that case, enter the entry number that the quantity will be applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Entry" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den udg†ende varepost, hvis kostpris overf›res til den indg†ende varepost.;
                           ENU=Specifies the number of the outbound item ledger entry, whose cost is forwarded to the inbound item ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-from Entry";
                Visible=FALSE }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr‘senterer med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm†den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method";
                Visible=FALSE }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 22  ;1   ;Group      }

    { 1900669001;2;Group  ;
                GroupType=FixedLayout }

    { 1901652601;3;Group  ;
                CaptionML=[DAN=Varebeskrivelse;
                           ENU=Item Description] }

    { 23  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ItemDescription;
                Editable=FALSE;
                ShowCaption=No }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1903326807;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Item No.);
                PagePartID=Page9090;
                Visible=FALSE;
                PartType=Page }

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
      Text000@1000 : TextConst 'DAN=Du kan ikke bruge posttypen %1 i denne kladde.;ENU=You cannot use entry type %1 in this journal.';
      CalcWhseAdjmt@1006 : Report 7315;
      ItemJnlMgt@1001 : Codeunit 240;
      ReportPrint@1002 : Codeunit 228;
      ItemAvailFormsMgt@1010 : Codeunit 353;
      ClientTypeManagement@1011 : Codeunit 4;
      CurrentJnlBatchName@1003 : Code[10];
      ItemDescription@1004 : Text[50];
      ShortcutDimCode@1005 : ARRAY [8] OF Code[20];
      Text001@1007 : TextConst 'DAN=Der er indsat varekladdelinjer fra standardvarekladden %1.;ENU=Item Journal lines have been successfully inserted from Standard Item Journal %1.';
      Text002@1008 : TextConst 'DAN=Standardvarekladden %1 er oprettet.;ENU=Standard Item Journal %1 has been successfully created.';
      IsSaasExcelAddinEnabled@1009 : Boolean;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      ItemJnlMgt.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

