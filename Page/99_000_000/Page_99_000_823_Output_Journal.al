OBJECT Page 99000823 Output Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Afgangskladde;
               ENU=Output Journal];
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
                 ItemJnlMgt.TemplateSelection(PAGE::"Output Journal",5,FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                  VALIDATE("Entry Type","Entry Type"::Output);
                  CLEAR(ShortcutDimCode);
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
                           ItemJnlMgt.GetOutput(Rec,ProdOrderDescription,OperationName);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 35      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 44      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 45      ;2   ;Action    ;
                      Name=Item Tracking Lines;
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
      { 46      ;2   ;Action    ;
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
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=Pro&d.ordre;
                                 ENU=Pro&d. Order];
                      Image=Order }
      { 19      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000831;
                      RunPageLink=No.=FIELD(Order No.);
                      Image=EditLines }
      { 20      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      Image=Entries }
      { 21      ;3   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Vareposter;
                                 ENU=Item Ledger E&ntries];
                      ToolTipML=[DAN=Vis vareposterne for varen p† bilaget eller kladdelinjen.;
                                 ENU=View the item ledger entries of the item on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 38;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Production),
                                  Order No.=FIELD(Order No.);
                      Image=ItemLedger }
      { 22      ;3   ;Action    ;
                      CaptionML=[DAN=Kapacitetsposter;
                                 ENU=Capacity Ledger Entries];
                      ToolTipML=[DAN=Vis kapacitetsposterne for den involverede produktionsordre. Kapaciteten registreres enten som tid (operationstid, stoptid eller opstillingstid) eller som antal (spildantal eller afgangsantal).;
                                 ENU=View the capacity ledger entries of the involved production order. Capacity is recorded either as time (run time, stop time, or setup time) or as quantity (scrap quantity or output quantity).];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5832;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Production),
                                  Order No.=FIELD(Order No.);
                      Promoted=No;
                      Image=CapacityLedger;
                      PromotedCategory=Process }
      { 25      ;3   ;Action    ;
                      CaptionML=[DAN=V‘rdiposter;
                                 ENU=Value Entries];
                      ToolTipML=[DAN=Vis v‘rdiposterne for varen p† bilags- eller kladdelinjen.;
                                 ENU=View the value entries of the item on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Production),
                                  Order No.=FIELD(Order No.);
                      Image=ValueLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Udfold &rute;
                                 ENU=Explode &Routing];
                      ToolTipML=[DAN=Inds‘t udfyldte kladdelinjer i henhold til produktionsordreruten.;
                                 ENU=Insert prefilled journal lines according to the production order routing.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Codeunit 5406;
                      Promoted=Yes;
                      Image=ExplodeRouting;
                      PromotedCategory=Process }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 41      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Manufacturing;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintItemJnlLine(Rec);
                               END;
                                }
      { 56      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TrySetApplyToEntries;
                                 PostingItemJnlFromProduction(FALSE);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 57      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f‘rdigg›res og forberedes til udskrivning. V‘rdierne og antallene bogf›res p† de relaterede konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TrySetApplyToEntries;
                                 PostingItemJnlFromProduction(TRUE);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 31      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Manufacturing;
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

    { 78  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som kladden er baseret p†.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Manufacturing;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             ItemJnlMgt.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           ItemJnlMgt.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                           ItemJnlMgt.CheckName(CurrentJnlBatchName,Rec);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Posting Date" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den ordre, hvor posten blev oprettet.;
                           ENU=Specifies the number of the order that created the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Order No.";
                OnValidate=BEGIN
                             ItemJnlMgt.GetOutput(Rec,ProdOrderDescription,OperationName);
                           END;
                            }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Document No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nummer p† kladdelinjen.;
                           ENU=Specifies the number of the item on the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Item No.";
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;

                OnLookup=BEGIN
                           LookupItemNo;
                           ShowShortcutDimCode(ShortcutDimCode);
                         END;
                          }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† produktionsoperationen p† varekladdelinjen, n†r kladden fungerer som en afgangskladde.;
                           ENU=Specifies the number of the production operation on the item journal line when the journal functions as an output journal.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Operation No.";
                OnValidate=BEGIN
                             ItemJnlMgt.GetOutput(Rec,ProdOrderDescription,OperationName);
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p† den ordre, som oprettede posten.;
                           ENU=Specifies the line number of the order that created the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Order Line No." }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kladdetype, som enten er Arbejdscenter eller Produktionsressource.;
                           ENU=Specifies the journal type, which is either Work Center or Machine Center.];
                OptionCaptionML=[DAN=Arbejdscenter,Produktionsressource;
                                 ENU=Work Center,Machine Center];
                ApplicationArea=#Manufacturing;
                SourceExpr=Type }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p† kladdelinjen.;
                           ENU=Specifies a description of the item on the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdsskiftskoden for kladdelinjen.;
                           ENU=Specifies the work shift code for this Journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Shift Code";
                Visible=FALSE }

    { 118 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 120 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
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

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver starttidspunktet for operationen p† varekladdelinjen.;
                           ENU=Specifies the starting time of the operation on the item journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sluttidspunktet for operationen p† varekladdelinjen.;
                           ENU=Specifies the ending time of the operation on the item journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time";
                Visible=FALSE }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samtidige kapacitet.;
                           ENU=Specifies the concurrent capacity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Concurrent Capacity";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det kr‘vede at konfigurere maskinerne til kladdelinjen.;
                           ENU=Specifies the time required to set up the machines for this journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Setup Time";
                Visible=FALSE }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationstiden for de operationer, der er repr‘senteret af kladdelinjen.;
                           ENU=Specifies the run time of the operations represented by this journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Run Time" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedskoden for kapacitetsforbruget.;
                           ENU=Specifies the unit of measure code for the capacity usage.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Cap. Unit of Measure Code" }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost";
                Visible=FALSE }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lagerlokation, hvor varen p† kladdelinjen skal registreres.;
                           ENU=Specifies the code for the inventory location where the item on the journal line will be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en placeringskode for varen.;
                           ENU=Specifies a bin code for the item.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spildkoden.;
                           ENU=Specifies the scrap code.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Code";
                Visible=FALSE }

    { 126 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af den producerede vare, der kan bogf›res som afgang p† kladdelinjen.;
                           ENU=Specifies the quantity of the produced item that can be posted as output on the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Output Quantity" }

    { 128 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal enheder, der blev produceret forkert og derfor er uanvendelige.;
                           ENU=Specifies the number of units produced incorrectly, and therefore cannot be used.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Quantity" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code" }

    { 122 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den operation, der er repr‘senteret af afgangskladdelinjen, er fuldf›rt.;
                           ENU=Specifies that the operation represented by the output journal line is finished.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Finished }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om antallet p† kladdelinjen skal udlignes med en allerede bogf›rt post. Hvis det er tilf‘ldet, skal du angive det l›benummer, som antallet skal udlignes efter.;
                           ENU=Specifies if the quantity on the journal line must be applied to an already-posted entry. In that case, enter the entry number that the quantity will be applied to.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Applies-to Entry" }

    { 134 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 136 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Manufacturing;
                SourceExpr="External Document No.";
                Visible=FALSE }

    { 73  ;1   ;Group      }

    { 1902114901;2;Group  ;
                GroupType=FixedLayout }

    { 1903098501;3;Group  ;
                CaptionML=[DAN=Prod.ordrenavn;
                           ENU=Prod. Order Name] }

    { 74  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=ProdOrderDescription;
                Editable=FALSE;
                ShowCaption=No }

    { 1901991301;3;Group  ;
                CaptionML=[DAN=Operation;
                           ENU=Operation] }

    { 76  ;4   ;Field     ;
                CaptionML=[DAN=Operation;
                           ENU=Operation];
                ToolTipML=[DAN=Angiver den forkortede opgavebeskrivelse.;
                           ENU=Specifies the abbreviated task description.];
                ApplicationArea=#Manufacturing;
                SourceExpr=OperationName;
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
      ItemJnlMgt@1000 : Codeunit 240;
      ReportPrint@1001 : Codeunit 228;
      ProdOrderDescription@1002 : Text[50];
      OperationName@1003 : Text[50];
      CurrentJnlBatchName@1004 : Code[10];
      ShortcutDimCode@1005 : ARRAY [8] OF Code[20];

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      ItemJnlMgt.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE TrySetApplyToEntries@101();
    VAR
      ItemLedgerEntry@1005 : Record 32;
      ItemJournalLine2@1001 : Record 83;
      ReservationEntry@1002 : Record 337;
    BEGIN
      ItemJournalLine2.COPY(Rec);
      IF ItemJournalLine2.FINDSET THEN
        REPEAT
          IF FindReservationsReverseOutput(ReservationEntry,ItemJournalLine2) THEN
            REPEAT
              IF FindILEFromReservation(ItemLedgerEntry,ItemJournalLine2,ReservationEntry,"Order No.") THEN BEGIN
                ReservationEntry.VALIDATE("Appl.-to Item Entry",ItemLedgerEntry."Entry No.");
                ReservationEntry.MODIFY(TRUE);
              END;
            UNTIL ReservationEntry.NEXT = 0;

        UNTIL ItemJournalLine2.NEXT = 0;
    END;

    LOCAL PROCEDURE FindReservationsReverseOutput@19(VAR ReservationEntry@1001 : Record 337;ItemJnlLine@1000 : Record 83) : Boolean;
    BEGIN
      IF ItemJnlLine.Quantity >= 0 THEN
        EXIT(FALSE);

      ReservationEntry.SETCURRENTKEY(
        "Source ID","Source Ref. No.","Source Type","Source Subtype",
        "Source Batch Name","Source Prod. Order Line");
      ReservationEntry.SETRANGE("Source ID",ItemJnlLine."Journal Template Name");
      ReservationEntry.SETRANGE("Source Ref. No.",ItemJnlLine."Line No.");
      ReservationEntry.SETRANGE("Source Type",DATABASE::"Item Journal Line");
      ReservationEntry.SETRANGE("Source Subtype",ItemJnlLine."Entry Type");
      ReservationEntry.SETRANGE("Source Batch Name",ItemJnlLine."Journal Batch Name");

      ReservationEntry.SETFILTER("Serial No.",'<>%1','');
      ReservationEntry.SETRANGE("Qty. to Handle (Base)",-1);
      ReservationEntry.SETRANGE("Appl.-to Item Entry",0);

      EXIT(ReservationEntry.FINDSET);
    END;

    LOCAL PROCEDURE FindILEFromReservation@20(VAR ItemLedgerEntry@1000 : Record 32;ItemJnlLine@1001 : Record 83;ReservationEntry@1002 : Record 337;ProductionOrderNo@1003 : Code[20]) : Boolean;
    BEGIN
      ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,
        "Location Code","Posting Date","Expiration Date","Lot No.","Serial No.");

      ItemLedgerEntry.SETRANGE("Item No.",ItemJnlLine."Item No.");
      ItemLedgerEntry.SETRANGE(Open,TRUE);
      ItemLedgerEntry.SETRANGE("Variant Code",ItemJnlLine."Variant Code");
      ItemLedgerEntry.SETRANGE(Positive,TRUE);
      ItemLedgerEntry.SETRANGE("Location Code",ItemJnlLine."Location Code");
      ItemLedgerEntry.SETRANGE("Serial No.",ReservationEntry."Lot No.");
      ItemLedgerEntry.SETRANGE("Serial No.",ReservationEntry."Serial No.");
      ItemLedgerEntry.SETRANGE("Document No.",ProductionOrderNo);

      EXIT(ItemLedgerEntry.FINDSET);
    END;

    BEGIN
    END.
  }
}

