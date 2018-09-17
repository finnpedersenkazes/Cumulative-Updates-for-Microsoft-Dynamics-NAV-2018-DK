OBJECT Page 7365 Whse. Reclassification Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lageromposteringskladde;
               ENU=Whse. Reclassification Journal];
    SaveValues=Yes;
    SourceTable=Table7311;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   CurrentLocationCode := "Location Code";
                   OpenJnl(CurrentJnlBatchName,CurrentLocationCode,Rec);
                   EXIT;
                 END;
                 TemplateSelection(PAGE::"Whse. Reclassification Journal",2,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 OpenJnl(CurrentJnlBatchName,CurrentLocationCode,Rec);
               END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                END;

    OnAfterGetCurrRecord=BEGIN
                           GetItem("Item No.",ItemDescription);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 17      ;2   ;Action    ;
                      Name=ItemTrackingLines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen pÜ bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
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
                      RunPageView=SORTING(Item No.,Location Code,Variant Code);
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
                      Name=Register;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Registrer;
                                 ENU=&Register];
                      ToolTipML=[DAN="Registrer den pÜgëldende lagerpost, f.eks. en ëndring af placeringskoden. ";
                                 ENU="Register the warehouse entry in question, such as a bin code change. "];
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
                ToolTipML=[DAN="Angiver den lokation, hvor lageraktiviteten finder sted. ";
                           ENU="Specifies the location where the warehouse activity takes place. "];
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

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, som varen pÜ kladdelinjen hentes fra.;
                           ENU=Specifies the code of the zone from which the item on the journal line is taken.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Zone Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, som varen pÜ kladdelinjen hentes fra.;
                           ENU=Specifies the code of the bin from which the item on the journal line is taken.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Bin Code" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, som varen pÜ kladdelinjen skal flyttes til.;
                           ENU=Specifies the code of the zone to which the item on the journal line will be moved.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Zone Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, som varen pÜ kladdelinjen skal flyttes til.;
                           ENU=Specifies the code of the bin to which the item on the journal line will be moved.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Bin Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder i reguleringen (opregulering eller nedregulering) eller omposteringen.;
                           ENU=Specifies the number of units of the item in the adjustment (positive or negative) or the reclassification.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity;
                MinValue=0 }

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
      ReportPrint@1002 : Codeunit 228;
      CurrentJnlBatchName@1003 : Code[10];
      CurrentLocationCode@1006 : Code[10];
      ItemDescription@1004 : Text[50];

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

