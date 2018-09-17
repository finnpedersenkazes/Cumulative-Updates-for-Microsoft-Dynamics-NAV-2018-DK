OBJECT Page 286 Recurring Item Jnl.
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varegentag.kladde;
               ENU=Recurring Item Jnl.];
    SaveValues=Yes;
    SourceTable=Table83;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 ItemJnlMgt.TemplateSelection(PAGE::"Recurring Item Jnl.",0,TRUE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                       ShowNewShortcutDimCode(NewShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                  CLEAR(ShortcutDimCode);
                  CLEAR(NewShortcutDimCode);
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
      { 103     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 104     ;2   ;Action    ;
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
      { 6500    ;2   ;Action    ;
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
      { 78      ;2   ;Action    ;
                      CaptionML=[DAN=Placeringsindh.;
                                 ENU=Bin Contents];
                      ToolTipML=[DAN=Vis varer i placeringen, hvis den valgte linje indeholder en placeringskode.;
                                 ENU=View items in the bin if the selected line contains a bin code.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7305;
                      RunPageView=SORTING(Location Code,Bin Code,Item No.,Variant Code);
                      RunPageLink=Location Code=FIELD(Location Code),
                                  Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code);
                      Image=BinContent }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 34      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Suite;
                      RunObject=Page 30;
                      RunPageLink=No.=FIELD(Item No.);
                      Image=EditLines }
      { 35      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 38;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(Item No.);
                      Promoted=No;
                      Image=ItemLedger;
                      PromotedCategory=Process }
      { 99      ;2   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikles over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Suite;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 100     ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller m†ned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Suite;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromItemJnlLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 101     ;3   ;Action    ;
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
      { 87      ;3   ;Action    ;
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
      { 3       ;3   ;Action    ;
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
      { 1900000004;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 90      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 92      ;2   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=&Udfold stykliste;
                                 ENU=E&xplode BOM];
                      ToolTipML=[DAN=Inds‘t nye linjer for komponenterne p† styklisten, f.eks. for at s‘lge den overordnede vare som en pakke. ADVARSEL! Linjen for den overordnede vare bliver slettet og kun repr‘senteret af en beskrivelse. Hvis du vil fortryde, skal du slette komponentlinjerne og tilf›je en linje igen for den overordnede vare.;
                                 ENU=Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.];
                      ApplicationArea=#Assembly;
                      RunObject=Codeunit 246;
                      Image=ExplodeBOM }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 37      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=F† vist en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Suite;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintItemJnlLine(Rec);
                               END;
                                }
      { 38      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 241;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process }
      { 39      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden, og forbered udskrivning. V‘rdierne og m‘ngderne bogf›res p† de relevante konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 242;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process }
      { 65      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du f†r vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Suite;
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
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 29  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som kladden er baseret p†.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Suite;
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
                ToolTipML=[DAN=Angiver et gentagelsesprincip, hvis du har angivet, at kladden gentages.;
                           ENU=Specifies a recurring method, if you have indicated that the journal is recurring.];
                ApplicationArea=#Suite;
                SourceExpr="Recurring Method" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et gentagelsesinterval, hvis du har angivet, at kladden gentages.;
                           ENU=Specifies a recurring frequency if you have indicated that the journal is recurring.];
                ApplicationArea=#Suite;
                SourceExpr="Recurring Frequency" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Suite;
                SourceExpr="Posting Date" }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion der skal bogf›res fra varekladdelinjen.;
                           ENU=Specifies the type of transaction that will be posted from the item journal line.];
                OptionCaptionML=[DAN=K›b,Salg,Opregulering,Nedregulering;
                                 ENU=Purchase,Sale,Positive Adjmt.,Negative Adjmt.];
                ApplicationArea=#Suite;
                SourceExpr="Entry Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Document No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nummer p† kladdelinjen.;
                           ENU=Specifies the number of the item on the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Item No.";
                OnValidate=BEGIN
                             ItemJnlMgt.GetItem("Item No.",ItemDescription);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p† kladdelinjen.;
                           ENU=Specifies a description of the item on the journal line.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nye dimensionsv‘rdikode, som varekladdelinjen vil blive tilknyttet.;
                           ENU=Specifies the new dimension value code that the item journal line will be linked to.];
                ApplicationArea=#Dimensions;
                SourceExpr="New Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nye dimensionsv‘rdikode, som varekladdelinjen vil blive tilknyttet.;
                           ENU=Specifies the new dimension value code that the item journal line will be linked to.];
                ApplicationArea=#Dimensions;
                SourceExpr="New Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
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

    { 312 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=NewShortcutDimCode[3];
                CaptionClass=Text001;
                Visible=FALSE;
                OnValidate=BEGIN
                             TESTFIELD("Entry Type","Entry Type"::Transfer);
                             ValidateNewShortcutDimCode(3,NewShortcutDimCode[3]);
                           END;

                OnLookup=BEGIN
                           LookupNewShortcutDimCode(3,NewShortcutDimCode[3]);
                         END;
                          }

    { 302 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
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

    { 314 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=NewShortcutDimCode[4];
                CaptionClass=Text002;
                Visible=FALSE;
                OnValidate=BEGIN
                             TESTFIELD("Entry Type","Entry Type"::Transfer);
                             ValidateNewShortcutDimCode(4,NewShortcutDimCode[4]);
                           END;

                OnLookup=BEGIN
                           LookupNewShortcutDimCode(4,NewShortcutDimCode[4]);
                         END;
                          }

    { 304 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
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

    { 316 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=NewShortcutDimCode[5];
                CaptionClass=Text003;
                Visible=FALSE;
                OnValidate=BEGIN
                             TESTFIELD("Entry Type","Entry Type"::Transfer);
                             ValidateNewShortcutDimCode(5,NewShortcutDimCode[5]);
                           END;

                OnLookup=BEGIN
                           LookupNewShortcutDimCode(5,NewShortcutDimCode[5]);
                         END;
                          }

    { 306 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
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

    { 318 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=NewShortcutDimCode[6];
                CaptionClass=Text004;
                Visible=FALSE;
                OnValidate=BEGIN
                             TESTFIELD("Entry Type","Entry Type"::Transfer);
                             ValidateNewShortcutDimCode(6,NewShortcutDimCode[6]);
                           END;

                OnLookup=BEGIN
                           LookupNewShortcutDimCode(6,NewShortcutDimCode[6]);
                         END;
                          }

    { 308 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
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

    { 320 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=NewShortcutDimCode[7];
                CaptionClass=Text005;
                Visible=FALSE;
                OnValidate=BEGIN
                             TESTFIELD("Entry Type","Entry Type"::Transfer);
                             ValidateNewShortcutDimCode(7,NewShortcutDimCode[7]);
                           END;

                OnLookup=BEGIN
                           LookupNewShortcutDimCode(7,NewShortcutDimCode[7]);
                         END;
                          }

    { 310 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
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

    { 322 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=NewShortcutDimCode[8];
                CaptionClass=Text006;
                Visible=FALSE;
                OnValidate=BEGIN
                             TESTFIELD("Entry Type","Entry Type"::Transfer);
                             ValidateNewShortcutDimCode(8,NewShortcutDimCode[8]);
                           END;

                OnLookup=BEGIN
                           LookupNewShortcutDimCode(8,NewShortcutDimCode[8]);
                         END;
                          }

    { 55  ;2   ;Field     ;
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

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nye lokation, der skal knyttes til varerne p† denne kladdelinje.;
                           ENU=Specifies the new location to link to the items on this journal line.];
                ApplicationArea=#Location;
                SourceExpr="New Location Code";
                Visible=FALSE;
                OnValidate=VAR
                             WMSManagement@1001 : Codeunit 7302;
                           BEGIN
                             WMSManagement.CheckItemJnlLineLocation(Rec,xRec);
                           END;
                            }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nye placeringskode, der skal knyttes til varerne p† kladdelinjen.;
                           ENU=Specifies the new bin code to link to the items on this journal line.];
                ApplicationArea=#Warehouse;
                SourceExpr="New Bin Code";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger eller indk›ber, der er knyttet til salget eller k›bet p† kladdelinjen.;
                           ENU=Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal angives p† linjen.;
                           ENU=Specifies the number of units of the item specified on the line.];
                ApplicationArea=#Suite;
                SourceExpr=Quantity }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Suite;
                SourceExpr="Unit of Measure Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen p† ‚n enhed af varen p† kladdelinjen.;
                           ENU=Specifies the price of one unit of the item on the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Unit Amount" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjens nettobel›b.;
                           ENU=Specifies the line's net amount.];
                ApplicationArea=#Suite;
                SourceExpr=Amount }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k›bspris, der omfatter indirekte omkostninger, s†som fragt, der er knyttet til k›bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Indirect Cost %";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Suite;
                SourceExpr="Unit Cost" }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om antallet p† kladdelinjen skal udlignes med en allerede bogf›rt post. Hvis det er tilf‘ldet, skal du angive det l›benummer, som antallet skal udlignes efter.;
                           ENU=Specifies if the quantity on the journal line must be applied to an already-posted entry. In that case, enter the entry number that the quantity will be applied to.];
                ApplicationArea=#Suite;
                SourceExpr="Applies-to Entry" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr‘senterer med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type";
                Visible=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm†den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste dato, hvor gentagelseskladden bliver bogf›rt, hvis du har angivet, at kladden gentages.;
                           ENU=Specifies the last date on which the recurring journal will be posted, if you have indicated that the journal is recurring.];
                ApplicationArea=#Suite;
                SourceExpr="Expiration Date" }

    { 26  ;1   ;Group      }

    { 1902454601;2;Group  ;
                GroupType=FixedLayout }

    { 1900295801;3;Group  ;
                CaptionML=[DAN=Varebeskrivelse;
                           ENU=Item Description] }

    { 27  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of the item.];
                ApplicationArea=#Suite;
                SourceExpr=ItemDescription;
                Editable=FALSE;
                ShowCaption=No }

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
      Text000@1000 : TextConst 'DAN=Du kan ikke bruge posttypen %1 i denne kladde.;ENU=You cannot use entry type %1 in this journal.';
      Text001@1001 : TextConst 'DAN="1,2,3,Ny ";ENU="1,2,3,New "';
      Text002@1002 : TextConst 'DAN="1,2,4,Ny ";ENU="1,2,4,New "';
      Text003@1003 : TextConst 'DAN="1,2,5,Ny ";ENU="1,2,5,New "';
      Text004@1004 : TextConst 'DAN="1,2,6,Ny ";ENU="1,2,6,New "';
      Text005@1005 : TextConst 'DAN="1,2,7,Ny ";ENU="1,2,7,New "';
      Text006@1006 : TextConst 'DAN="1,2,8,Ny ";ENU="1,2,8,New "';
      ItemJnlMgt@1007 : Codeunit 240;
      ReportPrint@1008 : Codeunit 228;
      ItemAvailFormsMgt@1014 : Codeunit 353;
      CurrentJnlBatchName@1009 : Code[10];
      ItemDescription@1010 : Text[50];
      ShortcutDimCode@1011 : ARRAY [8] OF Code[20];
      NewShortcutDimCode@1012 : ARRAY [8] OF Code[20];

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

