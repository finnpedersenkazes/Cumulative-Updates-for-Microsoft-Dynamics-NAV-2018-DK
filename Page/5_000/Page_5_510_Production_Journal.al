OBJECT Page 5510 Production Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Produktionskladde;
               ENU=Production Journal];
    InsertAllowed=No;
    SourceTable=Table83;
    DataCaptionExpr=GetCaption;
    PageType=Worksheet;
    OnInit=BEGIN
             AppliesFromEntryEditable := TRUE;
             QuantityEditable := TRUE;
             OutputQuantityEditable := TRUE;
             ScrapQuantityEditable := TRUE;
             ScrapCodeEditable := TRUE;
             FinishedEditable := TRUE;
             WorkShiftCodeEditable := TRUE;
             RunTimeEditable := TRUE;
             SetupTimeEditable := TRUE;
             CapUnitofMeasureCodeEditable := TRUE;
             ConcurrentCapacityEditable := TRUE;
             EndingTimeEditable := TRUE;
             StartingTimeEditable := TRUE;
           END;

    OnOpenPage=BEGIN
                 SetFilterGroup;

                 IF ProdOrderLineNo <> 0 THEN
                   ProdOrderLine.GET(ProdOrder.Status,ProdOrder."No.",ProdOrderLineNo);
               END;

    OnAfterGetRecord=BEGIN
                       ActualScrapQtyHideValue := FALSE;
                       ActualOutputQtyHideValue := FALSE;
                       ActualRunTimeHideValue := FALSE;
                       ActualSetupTimeHideValue := FALSE;
                       ActualConsumpQtyHideValue := FALSE;
                       ScrapQuantityHideValue := FALSE;
                       OutputQuantityHideValue := FALSE;
                       RunTimeHideValue := FALSE;
                       SetupTimeHideValue := FALSE;
                       QuantityHideValue := FALSE;
                       DescriptionIndent := 0;
                       ShowShortcutDimCode(ShortcutDimCode);
                       DescriptionOnFormat;
                       QuantityOnFormat;
                       SetupTimeOnFormat;
                       RunTimeOnFormat;
                       OutputQuantityOnFormat;
                       ScrapQuantityOnFormat;
                       ActualConsumpQtyOnFormat;
                       ActualSetupTimeOnFormat;
                       ActualRunTimeOnFormat;
                       ActualOutputQtyOnFormat;
                       ActualScrapQtyOnFormat;
                     END;

    OnModifyRecord=BEGIN
                     "Changed by User" := TRUE;
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
                           GetActTimeAndQtyBase;

                           ControlsMngt;
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
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 45      ;2   ;Action    ;
                      Name=ItemTrackingLines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
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
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p�g�ldende record p� bilaget eller kladdelinjen.;
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
                      ToolTipML=[DAN=Vis vareposterne for varen p� bilaget eller kladdelinjen.;
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
                      Image=CapacityLedger }
      { 25      ;3   ;Action    ;
                      CaptionML=[DAN=V�rdiposter;
                                 ENU=Value Entries];
                      ToolTipML=[DAN=Vis v�rdiposterne for varen p� bilags- eller kladdelinjen.;
                                 ENU=View the value entries of the item on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Production),
                                  Order No.=FIELD(Order No.);
                      Image=ValueLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&osting];
                      Image=Post }
      { 41      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s� du kan finde og rette eventuelle fejl, f�r du udf�rer den faktiske bogf�ring af kladden eller bilaget.;
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
                      CaptionML=[DAN=&Bogf�r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DeleteRecTemp;

                                 PostingItemJnlFromProduction(FALSE);

                                 InsertTempRec;

                                 SetFilterGroup;
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 57      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f�rdigg�res og forberedes til udskrivning. V�rdierne og antallene bogf�res p� de relaterede konti. Du f�r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DeleteRecTemp;

                                 PostingItemJnlFromProduction(TRUE);

                                 InsertTempRec;

                                 SetFilterGroup;
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 31      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G�r dig klar til at udskrive bilaget. Der �bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p� udskriften.;
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

    { 61  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 48  ;2   ;Field     ;
                CaptionML=[DAN=Bogf�ringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver en bogf�ringsdato, der vil g�lde for alle linjerne i produktionskladden.;
                           ENU=Specifies a posting date that will apply to all the lines in the production journal.];
                ApplicationArea=#Manufacturing;
                SourceExpr=PostingDate;
                OnValidate=BEGIN
                             PostingDateOnAfterValidate;
                           END;
                            }

    { 60  ;2   ;Field     ;
                CaptionML=[DAN=Filter for tr�kmetode;
                           ENU=Flushing Method Filter];
                ToolTipML=[DAN=Angiver, hvilke komponenter der skal vises og h�ndteres i kladden i overensstemmelse med deres tr�kmetode.;
                           ENU=Specifies which components to view and handle in the journal, according to their flushing method.];
                OptionCaptionML=[DAN=Manuelt,Forl�ns,Bagl�ns,Pluk + Forl�ns,Pluk + Bagl�ns,Alle metoder;
                                 ENU=Manual,Forward,Backward,Pick + Forward,Pick + Backward,All Methods];
                ApplicationArea=#Manufacturing;
                SourceExpr=FlushingFilter;
                OnValidate=BEGIN
                             FlushingFilterOnAfterValidate;
                           END;
                            }

    { 1   ;1   ;Group     ;
                IndentationColumnName=DescriptionIndent;
                IndentationControls=Description;
                GroupType=Repeater }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion der skal bogf�res fra varekladdelinjen.;
                           ENU=Specifies the type of transaction that will be posted from the item journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Entry Type";
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p� den ordre, som oprettede posten.;
                           ENU=Specifies the line number of the order that created the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Order Line No.";
                Visible=FALSE;
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Document No.";
                Visible=FALSE;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nummer p� kladdelinjen.;
                           ENU=Specifies the number of the item on the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Item No.";
                Editable=FALSE;
                OnLookup=BEGIN
                           IF Item.GET("Item No.") THEN
                             PAGE.RUNMODAL(PAGE::"Item List",Item);
                         END;
                          }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� produktionsoperationen p� varekladdelinjen, n�r kladden fungerer som en afgangskladde.;
                           ENU=Specifies the number of the production operation on the item journal line when the journal functions as an output journal.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Operation No.";
                Editable=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kladdetype, som enten er Arbejdscenter eller Produktionsressource.;
                           ENU=Specifies the journal type, which is either Work Center or Machine Center.];
                OptionCaptionML=[DAN="Arbejdscenter,Produktionsressource, ";
                                 ENU="Work Center,Machine Center, "];
                ApplicationArea=#Manufacturing;
                SourceExpr=Type;
                Visible=TRUE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan forbruget af varen (komponenten) beregnes og h�ndteres i produktionsprocesserne. Manuelt: Angiv og bogf�r forbrug i forbrugskladden manuelt. Fremad: Bogf�rer automatisk forbrug if�lge produktionsordrekomponentlinjerne, n�r den f�rste handling starter. Bagl�ns: Beregner og bogf�rer automatisk forbrug if�lge produktionsordrekomponentlinjerne, n�r produktionsordren er f�rdig. Pluk + Fremad / Pluk + Bagl�ns: Variationer med lagersted.;
                           ENU=Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Flushing Method";
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p� kladdelinjen.;
                           ENU=Specifies a description of the item on the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description;
                Editable=FALSE;
                StyleExpr=DescriptionEmphasize }

    { 23  ;2   ;Field     ;
                CaptionML=[DAN=Forbrugsantal;
                           ENU=Consumption Quantity];
                ToolTipML=[DAN=Angiver det antal komponenter, der vil blive bogf�rt som forbrugt.;
                           ENU=Specifies the quantity of the component that will be posted as consumed.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Quantity;
                Editable=QuantityEditable;
                HideValue=QuantityHideValue }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code";
                Visible=FALSE }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lagerlokation, hvor varen p� kladdelinjen skal registreres.;
                           ENU=Specifies the code for the inventory location where the item on the journal line will be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l�gges p� lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdsskiftskoden for kladdelinjen.;
                           ENU=Specifies the work shift code for this Journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Shift Code";
                Visible=FALSE;
                Editable=WorkShiftCodeEditable }

    { 118 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 120 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
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
                ToolTipML=[DAN=Angiver starttidspunktet for operationen p� varekladdelinjen.;
                           ENU=Specifies the starting time of the operation on the item journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Visible=FALSE;
                Editable=StartingTimeEditable }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sluttidspunktet for operationen p� varekladdelinjen.;
                           ENU=Specifies the ending time of the operation on the item journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time";
                Visible=FALSE;
                Editable=EndingTimeEditable }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samtidige kapacitet.;
                           ENU=Specifies the concurrent capacity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Concurrent Capacity";
                Visible=FALSE;
                Editable=ConcurrentCapacityEditable }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det kr�vede at konfigurere maskinerne til kladdelinjen.;
                           ENU=Specifies the time required to set up the machines for this journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Setup Time";
                Editable=SetupTimeEditable;
                HideValue=SetupTimeHideValue }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationstiden for de operationer, der er repr�senteret af kladdelinjen.;
                           ENU=Specifies the run time of the operations represented by this journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Run Time";
                Editable=RunTimeEditable;
                HideValue=RunTimeHideValue }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedskoden for kapacitetsforbruget.;
                           ENU=Specifies the unit of measure code for the capacity usage.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Cap. Unit of Measure Code";
                Visible=FALSE;
                Editable=CapUnitofMeasureCodeEditable }

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorfor en vare er blevet kasseret.;
                           ENU=Specifies why an item has been scrapped.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Code";
                Visible=FALSE;
                Editable=ScrapCodeEditable }

    { 126 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af den producerede vare, der kan bogf�res som afgang p� kladdelinjen.;
                           ENU=Specifies the quantity of the produced item that can be posted as output on the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Output Quantity";
                Editable=OutputQuantityEditable;
                HideValue=OutputQuantityHideValue }

    { 128 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal enheder, der blev produceret forkert og derfor er uanvendelige.;
                           ENU=Specifies the number of units produced incorrectly, and therefore cannot be used.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Quantity";
                Editable=ScrapQuantityEditable;
                HideValue=ScrapQuantityHideValue }

    { 122 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den operation, der er repr�senteret af afgangskladdelinjen, er fuldf�rt.;
                           ENU=Specifies that the operation represented by the output journal line is finished.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Finished;
                Editable=FinishedEditable }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om antallet p� kladdelinjen skal udlignes med en allerede bogf�rt post. Hvis det er tilf�ldet, skal du angive det l�benummer, som antallet skal udlignes efter.;
                           ENU=Specifies if the quantity on the journal line must be applied to an already-posted entry. In that case, enter the entry number that the quantity will be applied to.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Applies-to Entry";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den udg�ende varepost, hvis kostpris overf�res til den indg�ende varepost.;
                           ENU=Specifies the number of the outbound item ledger entry, whose cost is forwarded to the inbound item ledger entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Applies-from Entry";
                Visible=FALSE;
                Editable=AppliesFromEntryEditable }

    { 134 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Document Date";
                Visible=FALSE;
                Editable=FALSE }

    { 136 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Manufacturing;
                SourceExpr="External Document No.";
                Visible=FALSE }

    { 73  ;1   ;Group     ;
                CaptionML=[DAN=Faktisk;
                           ENU=Actual] }

    { 1902114901;2;Group  ;
                GroupType=FixedLayout }

    { 1901742001;3;Group  ;
                CaptionML=[DAN=Forbrugsantal;
                           ENU=Consump. Qty.] }

    { 55  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=ActualConsumpQty;
                Editable=FALSE;
                HideValue=ActualConsumpQtyHideValue;
                ShowCaption=No }

    { 1901741901;3;Group  ;
                CaptionML=[DAN=Opstillingstid;
                           ENU=Setup Time] }

    { 50  ;4   ;Field     ;
                CaptionML=[DAN=Opstillingstid;
                           ENU=Setup Time];
                ToolTipML=[DAN=Angiver den tid, det kr�ver at konfigurere maskinerne til denne kladdelinje. Opstillingstiden er den tid, det tager at klarg�re en maskine eller et arbejdscenter til at udf�re en operation. Opstillingstiden varierer efter den enkelte operation.;
                           ENU=Specifies the time required to set up the machines for this journal line. Setup time is the time it takes to prepare a machine or work center to perform an operation. Each operation can have a different setup time.];
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=ActualSetupTime;
                Editable=FALSE;
                HideValue=ActualSetupTimeHideValue }

    { 1902759401;3;Group  ;
                CaptionML=[DAN=Operationstid;
                           ENU=Run Time] }

    { 52  ;4   ;Field     ;
                CaptionML=[DAN=Operationstid;
                           ENU=Run Time];
                ToolTipML=[DAN=Angiver operationstiden for de operationer, der er repr�senteret af denne kladdelinje. Operationstid er den tid, det tager at fuldf�re en operation. Operationstiden omfatter ikke opstillingstid.;
                           ENU=Specifies the run time of the operations represented by this journal line. Run time is the time it takes to complete an operation. Run time does not include setup time.];
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=ActualRunTime;
                Editable=FALSE;
                HideValue=ActualRunTimeHideValue }

    { 1900205801;3;Group  ;
                CaptionML=[DAN=Afgangsantal;
                           ENU=Output Qty.] }

    { 54  ;4   ;Field     ;
                CaptionML=[DAN=Afgangsantal;
                           ENU=Output Qty.];
                ToolTipML=[DAN=Angiver det antal af den producerede vare, der kan bogf�res som afgang p� kladdelinjen. Bem�rk, at det kun er afgangsantallet p� den sidste kladdelinje af posttypen Afgang, der regulerer lagerniveauet, n�r du bogf�rer kladden.;
                           ENU=Specifies the quantity of the produced item that can be posted as output on the journal line. Note that only the output quantity on the last journal line of entry type Output will adjust the inventory level when posting the journal.];
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=ActualOutputQty;
                Editable=FALSE;
                HideValue=ActualOutputQtyHideValue }

    { 1900205901;3;Group  ;
                CaptionML=[DAN=Spildantal;
                           ENU=Scrap Qty.] }

    { 58  ;4   ;Field     ;
                CaptionML=[DAN=Spildantal;
                           ENU=Scrap Qty.];
                ToolTipML=[DAN=Angiver det antal enheder af varen, der blev produceret forkert og derfor er uanvendelige. Hvis varenummeret �ndres senere, bevares dette tal p� linjen.;
                           ENU=Specifies the number of units of the item that were produced incorrectly and therefore cannot be used. Even if the item number is later changed, this figure will remain on the line.];
                ApplicationArea=#Manufacturing;
                DecimalPlaces=0:5;
                SourceExpr=ActualScrapQty;
                Editable=FALSE;
                HideValue=ActualScrapQtyHideValue }

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
      Item@1019 : Record 27;
      ProdOrder@1009 : Record 5405;
      ProdOrderLine@1012 : Record 5406;
      ProdOrderComp@1017 : Record 5407;
      TempItemJrnlLine@1002 : TEMPORARY Record 83;
      CostCalcMgt@1021 : Codeunit 5836;
      ReportPrint@1001 : Codeunit 228;
      PostingDate@1008 : Date;
      xPostingDate@1007 : Date;
      ProdOrderLineNo@1006 : Integer;
      ShortcutDimCode@1005 : ARRAY [8] OF Code[20];
      ToTemplateName@1011 : Code[10];
      ToBatchName@1010 : Code[10];
      ActualRunTime@1013 : Decimal;
      ActualSetupTime@1014 : Decimal;
      ActualOutputQty@1015 : Decimal;
      ActualScrapQty@1020 : Decimal;
      ActualConsumpQty@1016 : Decimal;
      FlushingFilter@1003 : 'Manual,Forward,Backward,Pick + Forward,Pick + Backward,All Methods';
      DescriptionIndent@19057867 : Integer INDATASET;
      QuantityHideValue@19060207 : Boolean INDATASET;
      SetupTimeHideValue@19037416 : Boolean INDATASET;
      RunTimeHideValue@19073369 : Boolean INDATASET;
      OutputQuantityHideValue@19005396 : Boolean INDATASET;
      ScrapQuantityHideValue@19076632 : Boolean INDATASET;
      ActualConsumpQtyHideValue@19061616 : Boolean INDATASET;
      ActualSetupTimeHideValue@19068503 : Boolean INDATASET;
      ActualRunTimeHideValue@19010265 : Boolean INDATASET;
      ActualOutputQtyHideValue@19030556 : Boolean INDATASET;
      ActualScrapQtyHideValue@19001037 : Boolean INDATASET;
      StartingTimeEditable@19033885 : Boolean INDATASET;
      EndingTimeEditable@19072097 : Boolean INDATASET;
      ConcurrentCapacityEditable@19033053 : Boolean INDATASET;
      CapUnitofMeasureCodeEditable@19008712 : Boolean INDATASET;
      SetupTimeEditable@19005706 : Boolean INDATASET;
      RunTimeEditable@19034139 : Boolean INDATASET;
      WorkShiftCodeEditable@19055238 : Boolean INDATASET;
      FinishedEditable@19037742 : Boolean INDATASET;
      ScrapCodeEditable@19021735 : Boolean INDATASET;
      ScrapQuantityEditable@19061944 : Boolean INDATASET;
      OutputQuantityEditable@19056726 : Boolean INDATASET;
      QuantityEditable@19013162 : Boolean INDATASET;
      AppliesFromEntryEditable@19013746 : Boolean INDATASET;
      DescriptionEmphasize@19013747 : Text INDATASET;

    [External]
    PROCEDURE Setup@2(TemplateName@1003 : Code[10];BatchName@1002 : Code[10];ProductionOrder@1001 : Record 5405;ProdLineNo@1000 : Integer;PostDate@1004 : Date);
    BEGIN
      ToTemplateName := TemplateName;
      ToBatchName := BatchName;
      ProdOrder := ProductionOrder;
      ProdOrderLineNo := ProdLineNo;
      PostingDate := PostDate;
      xPostingDate := PostingDate;

      FlushingFilter := FlushingFilter::Manual;
    END;

    LOCAL PROCEDURE GetActTimeAndQtyBase@4();
    BEGIN
      ActualSetupTime := 0;
      ActualRunTime := 0;
      ActualOutputQty := 0;
      ActualScrapQty := 0;
      ActualConsumpQty := 0;

      IF "Qty. per Unit of Measure" = 0 THEN
        "Qty. per Unit of Measure" := 1;
      IF "Qty. per Cap. Unit of Measure" = 0 THEN
        "Qty. per Cap. Unit of Measure" := 1;

      IF Item.GET("Item No.") THEN
        CASE "Entry Type" OF
          "Entry Type"::Consumption:
            IF ProdOrderComp.GET(
                 ProdOrder.Status,
                 "Order No.",
                 "Order Line No.",
                 "Prod. Order Comp. Line No.")
            THEN BEGIN
              ProdOrderComp.CALCFIELDS("Act. Consumption (Qty)"); // Base Unit
              ActualConsumpQty :=
                ProdOrderComp."Act. Consumption (Qty)" / "Qty. per Unit of Measure";
              IF Item."Rounding Precision" > 0 THEN
                ActualConsumpQty := ROUND(ActualConsumpQty,Item."Rounding Precision",'>')
              ELSE
                ActualConsumpQty := ROUND(ActualConsumpQty,0.00001);
            END;
          "Entry Type"::Output:
            BEGIN
              IF ProdOrderLineNo = 0 THEN
                IF NOT ProdOrderLine.GET(ProdOrder.Status,ProdOrder."No.","Order Line No.") THEN
                  CLEAR(ProdOrderLine);
              IF ProdOrderLine."Prod. Order No." <> '' THEN BEGIN
                CostCalcMgt.CalcActTimeAndQtyBase(
                  ProdOrderLine,"Operation No.",ActualRunTime,ActualSetupTime,ActualOutputQty,ActualScrapQty);
                ActualSetupTime :=
                  ROUND(ActualSetupTime / "Qty. per Cap. Unit of Measure",0.00001);
                ActualRunTime :=
                  ROUND(ActualRunTime / "Qty. per Cap. Unit of Measure",0.00001);

                ActualOutputQty := ActualOutputQty / "Qty. per Unit of Measure";
                ActualScrapQty := ActualScrapQty / "Qty. per Unit of Measure";
                IF Item."Rounding Precision" > 0 THEN BEGIN
                  ActualOutputQty := ROUND(ActualOutputQty,Item."Rounding Precision",'>');
                  ActualScrapQty := ROUND(ActualScrapQty,Item."Rounding Precision",'>');
                END ELSE BEGIN
                  ActualOutputQty := ROUND(ActualOutputQty,0.00001);
                  ActualScrapQty := ROUND(ActualScrapQty,0.00001);
                END;
              END;
            END;
        END;
    END;

    LOCAL PROCEDURE ControlsMngt@1();
    VAR
      OperationExist@1000 : Boolean;
    BEGIN
      IF ("Entry Type" = "Entry Type"::Output) AND
         ("Operation No." <> '')
      THEN
        OperationExist := TRUE
      ELSE
        OperationExist := FALSE;

      StartingTimeEditable := OperationExist;
      EndingTimeEditable := OperationExist;
      ConcurrentCapacityEditable := OperationExist;
      CapUnitofMeasureCodeEditable := OperationExist;
      SetupTimeEditable := OperationExist;
      RunTimeEditable := OperationExist;
      WorkShiftCodeEditable := OperationExist;

      FinishedEditable := "Entry Type" = "Entry Type"::Output;
      ScrapCodeEditable := "Entry Type" = "Entry Type"::Output;
      ScrapQuantityEditable := "Entry Type" = "Entry Type"::Output;
      OutputQuantityEditable := "Entry Type" = "Entry Type"::Output;

      QuantityEditable := "Entry Type" = "Entry Type"::Consumption;
      AppliesFromEntryEditable := "Entry Type" = "Entry Type"::Consumption;
    END;

    LOCAL PROCEDURE DeleteRecTemp@6();
    BEGIN
      TempItemJrnlLine.DELETEALL;

      IF FIND('-') THEN
        REPEAT
          CASE "Entry Type" OF
            "Entry Type"::Consumption:
              IF "Quantity (Base)" = 0 THEN BEGIN
                TempItemJrnlLine := Rec;
                TempItemJrnlLine.INSERT;

                DELETE;
              END;
            "Entry Type"::Output:
              IF TimeIsEmpty AND
                 ("Output Quantity (Base)" = 0) AND ("Scrap Quantity (Base)" = 0)
              THEN BEGIN
                TempItemJrnlLine := Rec;
                TempItemJrnlLine.INSERT;

                DELETE;
              END;
          END;
        UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE InsertTempRec@7();
    BEGIN
      IF TempItemJrnlLine.FIND('-') THEN
        REPEAT
          Rec := TempItemJrnlLine;
          "Changed by User" := FALSE;
          INSERT;
        UNTIL TempItemJrnlLine.NEXT = 0;
      TempItemJrnlLine.DELETEALL;
    END;

    [External]
    PROCEDURE SetFilterGroup@5();
    BEGIN
      FILTERGROUP(2);
      SETRANGE("Journal Template Name",ToTemplateName);
      SETRANGE("Journal Batch Name",ToBatchName);
      SETRANGE("Order Type","Order Type"::Production);
      SETRANGE("Order No.",ProdOrder."No.");
      IF ProdOrderLineNo <> 0 THEN
        SETRANGE("Order Line No.",ProdOrderLineNo);
      SetFlushingFilter;
      FILTERGROUP(0);
    END;

    [External]
    PROCEDURE SetFlushingFilter@8();
    BEGIN
      IF FlushingFilter <> FlushingFilter::"All Methods" THEN
        SETRANGE("Flushing Method",FlushingFilter)
      ELSE
        SETRANGE("Flushing Method");
    END;

    LOCAL PROCEDURE GetCaption@3() : Text[250];
    VAR
      ObjTransl@1000 : Record 377;
      SourceTableName@1002 : Text[100];
      Descrip@1001 : Text[100];
    BEGIN
      SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5405);
      IF ProdOrderLineNo <> 0 THEN
        Descrip := ProdOrderLine.Description
      ELSE
        Descrip := ProdOrder.Description;

      EXIT(STRSUBSTNO('%1 %2 %3',SourceTableName,ProdOrder."No.",Descrip));
    END;

    LOCAL PROCEDURE PostingDateOnAfterValidate@19003005();
    BEGIN
      IF PostingDate = 0D THEN
        PostingDate := xPostingDate;

      IF PostingDate <> xPostingDate THEN BEGIN
        MODIFYALL("Posting Date",PostingDate);
        xPostingDate := PostingDate;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE FlushingFilterOnAfterValidate@19064520();
    BEGIN
      SetFilterGroup;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE DescriptionOnFormat@19023855();
    BEGIN
      DescriptionIndent := Level;
      IF "Entry Type" = "Entry Type"::Output THEN
        DescriptionEmphasize := 'Strong'
      ELSE
        DescriptionEmphasize := '';
    END;

    LOCAL PROCEDURE QuantityOnFormat@19071269();
    BEGIN
      IF "Entry Type" = "Entry Type"::Output THEN
        QuantityHideValue := TRUE;
    END;

    LOCAL PROCEDURE SetupTimeOnFormat@19007490();
    BEGIN
      IF ("Entry Type" = "Entry Type"::Consumption) OR
         ("Operation No." = '')
      THEN
        SetupTimeHideValue := TRUE;
    END;

    LOCAL PROCEDURE RunTimeOnFormat@19059514();
    BEGIN
      IF ("Entry Type" = "Entry Type"::Consumption) OR
         ("Operation No." = '')
      THEN
        RunTimeHideValue := TRUE;
    END;

    LOCAL PROCEDURE OutputQuantityOnFormat@19003029();
    BEGIN
      IF "Entry Type" = "Entry Type"::Consumption THEN
        OutputQuantityHideValue := TRUE;
    END;

    LOCAL PROCEDURE ScrapQuantityOnFormat@19017313();
    BEGIN
      IF "Entry Type" = "Entry Type"::Consumption THEN
        ScrapQuantityHideValue := TRUE;
    END;

    LOCAL PROCEDURE ActualConsumpQtyOnFormat@19012702();
    BEGIN
      IF "Entry Type" = "Entry Type"::Output THEN
        ActualConsumpQtyHideValue := TRUE;
    END;

    LOCAL PROCEDURE ActualSetupTimeOnFormat@19031665();
    BEGIN
      IF ("Entry Type" = "Entry Type"::Consumption) OR
         ("Operation No." = '')
      THEN
        ActualSetupTimeHideValue := TRUE;
    END;

    LOCAL PROCEDURE ActualRunTimeOnFormat@19024131();
    BEGIN
      IF ("Entry Type" = "Entry Type"::Consumption) OR
         ("Operation No." = '')
      THEN
        ActualRunTimeHideValue := TRUE;
    END;

    LOCAL PROCEDURE ActualOutputQtyOnFormat@19059076();
    BEGIN
      IF "Entry Type" = "Entry Type"::Consumption THEN
        ActualOutputQtyHideValue := TRUE;
    END;

    LOCAL PROCEDURE ActualScrapQtyOnFormat@19036240();
    BEGIN
      IF "Entry Type" = "Entry Type"::Consumption THEN
        ActualScrapQtyHideValue := TRUE;
    END;

    BEGIN
    END.
  }
}

