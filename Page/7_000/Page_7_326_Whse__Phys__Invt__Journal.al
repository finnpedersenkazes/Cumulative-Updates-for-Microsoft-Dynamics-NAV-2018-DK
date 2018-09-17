OBJECT Page 7326 Whse. Phys. Invt. Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagersted - fysisk lagerkladde;
               ENU=Whse. Phys. Invt. Journal];
    SaveValues=Yes;
    SourceTable=Table7311;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnInit=BEGIN
             LotNoEditable := TRUE;
             SerialNoEditable := TRUE;
           END;

    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   CurrentLocationCode := "Location Code";
                   OpenJnl(CurrentJnlBatchName,CurrentLocationCode,Rec);
                   EXIT;
                 END;
                 TemplateSelection(PAGE::"Whse. Phys. Invt. Journal",1,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 OpenJnl(CurrentJnlBatchName,CurrentLocationCode,Rec);
               END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                END;

    OnAfterGetCurrRecord=BEGIN
                           GetItem("Item No.",ItemDescription);
                           SetControls;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 30      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den pÜgëldende record pÜ bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 30;
                      RunPageLink=No.=FIELD(Item No.);
                      Image=EditLines }
      { 4       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Lagerposter;
                                 ENU=Warehouse Entries];
                      ToolTipML=[DAN=Vis afsluttede lageraktiviteter, der er knyttet til bilaget.;
                                 ENU=View completed warehouse activities related to the document.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7318;
                      RunPageView=SORTING(Item No.,Location Code,Variant Code,Bin Type Code,Unit of Measure Code,Lot No.,Serial No.);
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Location Code=FIELD(Location Code);
                      Image=BinLedger }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 38;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Location Code=FIELD(Location Code);
                      Promoted=No;
                      Image=ItemLedger;
                      PromotedCategory=Process }
      { 44      ;2   ;Action    ;
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 17      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Beregn beholdning;
                                 ENU=Calculate &Inventory];
                      ToolTipML=[DAN=Start lageroptëllingen ved at udfylde kladden med kendte antal.;
                                 ENU=Start the process of counting inventory by filling the journal with known quantities.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=CalculateInventory;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 BinContent@1002 : Record 7302;
                                 WhseCalcInventory@1001 : Report 7390;
                               BEGIN
                                 BinContent.SETRANGE("Location Code","Location Code");
                                 WhseCalcInventory.SetWhseJnlLine(Rec);
                                 WhseCalcInventory.SETTABLEVIEW(BinContent);
                                 WhseCalcInventory.SetProposalMode(TRUE);
                                 WhseCalcInventory.RUNMODAL;
                                 CLEAR(WhseCalcInventory);
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=B&eregn optëllingsperiode;
                                 ENU=&Calculate Counting Period];
                      ToolTipML=[DAN=Vis alle varer, som en optëllingsperiode er blevet tildelt til, i henhold til optëllingsperioden, den seneste optëllingsperiodeopdatering og den aktuelle arbejdsdato.;
                                 ENU=Show all items that a counting period has been assigned to, according to the counting period, the last counting period update, and the current work date.];
                      ApplicationArea=#Warehouse;
                      Image=CalculateCalendar;
                      OnAction=VAR
                                 PhysInvtCountMgt@1000 : Codeunit 7380;
                                 SortingMethod@1002 : ' ,Item,Bin';
                               BEGIN
                                 PhysInvtCountMgt.InitFromWhseJnl(Rec);
                                 PhysInvtCountMgt.RUN;

                                 PhysInvtCountMgt.GetSortingMethod(SortingMethod);
                                 CASE SortingMethod OF
                                   SortingMethod::Item:
                                     SETCURRENTKEY("Location Code","Item No.","Variant Code");
                                   SortingMethod::Bin:
                                     SETCURRENTKEY("Location Code","Bin Code");
                                 END;

                                 CLEAR(PhysInvtCountMgt);
                               END;
                                }
      { 50      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Gõr dig klar til at udskrive bilaget. Der Übnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages pÜ udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WhseJournalBatch.SETRANGE("Journal Template Name","Journal Template Name");
                                 WhseJournalBatch.SETRANGE(Name,"Journal Batch Name");
                                 WhseJournalBatch.SETRANGE("Location Code",CurrentLocationCode);
                                 WhsePhysInventoryList.SETTABLEVIEW(WhseJournalBatch);
                                 WhsePhysInventoryList.RUNMODAL;
                                 CLEAR(WhsePhysInventoryList);
                               END;
                                }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&egistrering;
                                 ENU=&Registering];
                      Image=PostOrder }
      { 33      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Warehouse;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintWhseJnlLine(Rec);
                               END;
                                }
      { 34      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Registrer;
                                 ENU=&Register];
                      ToolTipML=[DAN="Registrer den pÜgëldende lagerpost, f.eks. en opregulering. ";
                                 ENU="Register the warehouse entry in question, such as a positive adjustment. "];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=Confirm;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Whse. Jnl.-Register",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 35      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Registrer og &udskriv;
                                 ENU=Register and &Print];
                      ToolTipML=[DAN="Registrer lagerreguleringsposterne, og udskriv en oversigt over ëndringerne. ";
                                 ENU="Register the warehouse entry adjustments and print an overview of the changes. "];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=ConfirmAndPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Whse. Jnl.-Register+Print",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
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
                ToolTipML=[DAN=Angiver navnet pÜ den kladdekõrsel, et personligt kladdelayout, som kladden er baseret pÜ.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Warehouse;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             CheckName(CurrentJnlBatchName,CurrentLocationCode,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           LookupName(CurrentJnlBatchName,CurrentLocationCode,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 9   ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Lokationskode;
                           ENU=Location Code];
                ToolTipML=[DAN=Angiver koden for den lokation, hvor lageraktiviteten finder sted.;
                           ENU=Specifies the code for the location where the warehouse activity takes place.];
                ApplicationArea=#Warehouse;
                SourceExpr=CurrentLocationCode;
                TableRelation=Location;
                Editable=FALSE }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor linjen blev registreret.;
                           ENU=Specifies the date the line is registered.];
                ApplicationArea=#Warehouse;
                SourceExpr="Registering Date" }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Lagerdokumentnr.;
                           ENU=Whse. Document No.];
                ToolTipML=[DAN=Angiver lagerdokumentnummeret for kladdelinjen.;
                           ENU=Specifies the warehouse document number of the journal line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document No." }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nummer pÜ kladdelinjen.;
                           ENU=Specifies the number of the item on the journal line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No.";
                OnValidate=BEGIN
                             GetItem("Item No.",ItemDescription);
                           END;
                            }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen.;
                           ENU=Specifies the description of the item.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som for feltet i vinduet Varekladde.;
                           ENU=Specifies the same as for the field in the Item Journal window.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE;
                Editable=SerialNoEditable }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som for feltet i vinduet Varekladde.;
                           ENU=Specifies the same as for the field in the Item Journal window.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE;
                Editable=LotNoEditable }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen pÜ linjen findes.;
                           ENU=Specifies the zone code where the bin on this line is located.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Zone Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller lëgges pÜ lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som for feltet i vinduet Varekladde.;
                           ENU=Specifies the same as for the field in the Item Journal window.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Calculated) (Base)";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som for feltet i vinduet Varekladde.;
                           ENU=Specifies the same as for the field in the Item Journal window.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Phys. Inventory) (Base)";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af placeringens vare, som beregnes med funktionen Beregn beholdning i Lagerplacering - opg.kladde.;
                           ENU=Specifies the quantity of the bin item that is calculated when you use the function, Calculate Inventory, in the Whse. Physical Inventory Journal.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Calculated)" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varer i placeringen, som du har optalt.;
                           ENU=Specifies the quantity of items in the bin that you have counted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Phys. Inventory)" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder i reguleringen (opregulering eller nedregulering) eller omposteringen.;
                           ENU=Specifies the number of units of the item in the adjustment (positive or negative) or the reclassification.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=èrsagskode;
                           ENU=Reason Code];
                ToolTipML=[DAN=Angiver Ürsagskoden for lagerkladdelinjen.;
                           ENU=Specifies the reason code for the warehouse journal line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om optëllingsperioden for lageropgõrelsen er tildelt en lagervare eller en vare.;
                           ENU=Specifies whether the physical inventory counting period was assigned to a stockkeeping unit or an item.];
                ApplicationArea=#Warehouse;
                SourceExpr="Phys Invt Counting Period Type";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for optëllingsperioden for lageropgõrelsen, hvis der blev anvendt optëllingsperioder, da linjen blev oprettet.;
                           ENU=Specifies a code for the physical inventory counting period, if the counting period functionality was used when the line was created.];
                ApplicationArea=#Warehouse;
                SourceExpr="Phys Invt Counting Period Code";
                Visible=FALSE }

    { 22  ;1   ;Group      }

    { 1900669001;2;Group  ;
                GroupType=FixedLayout }

    { 1901652601;3;Group  ;
                CaptionML=[DAN=Varebeskrivelse;
                           ENU=Item Description] }

    { 23  ;4   ;Field     ;
                ApplicationArea=#Warehouse;
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
      WhseJournalBatch@1000 : Record 7310;
      WhsePhysInventoryList@1001 : Report 7307;
      ReportPrint@1002 : Codeunit 228;
      CurrentJnlBatchName@1003 : Code[10];
      CurrentLocationCode@1006 : Code[10];
      ItemDescription@1004 : Text[50];
      SerialNoEditable@19056272 : Boolean INDATASET;
      LotNoEditable@19059315 : Boolean INDATASET;

    [External]
    PROCEDURE SetControls@1();
    BEGIN
      SerialNoEditable := NOT "Phys. Inventory";
      LotNoEditable := NOT "Phys. Inventory";
    END;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      SetName(CurrentJnlBatchName,CurrentLocationCode,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

