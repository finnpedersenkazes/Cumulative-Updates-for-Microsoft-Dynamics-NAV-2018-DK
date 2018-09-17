OBJECT Page 5804 Applied Item Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Udlignede vareposter;
               ENU=Applied Item Entries];
    SourceTable=Table32;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       GetApplQty;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 60      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 61      ;2   ;Action    ;
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
                               END;
                                }
      { 64      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&V‘rdiposter;
                                 ENU=&Value Entries];
                      ToolTipML=[DAN=F† vist historikken over bogf›rte bel›b, der p†virker v‘rdien af varen. V‘rdiposter oprettes for hver transaktion med varen.;
                                 ENU=View the history of posted amounts that affect the value of the item. Value entries are created for every transaction with the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Item Ledger Entry No.);
                      RunPageLink=Item Ledger Entry No.=FIELD(Entry No.);
                      Image=ValueLedger }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dligning;
                                 ENU=&Application];
                      Image=Apply }
      { 58      ;2   ;Action    ;
                      CaptionML=[DAN=Udlignede &poster;
                                 ENU=Applied E&ntries];
                      ToolTipML=[DAN=Se finansposter, der er godkendt for denne record.;
                                 ENU=View the ledger entries that have been applied to this record.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Approve;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Show Applied Entries",Rec);
                               END;
                                }
      { 56      ;2   ;Action    ;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=Reservationsposter;
                                 ENU=Reservation Entries];
                      ToolTipML=[DAN=Vis posterne for hver reservation, der er foretaget, enten manuelt eller automatisk.;
                                 ENU=View the entries for every reservation that is made, either manually or automatically.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ReservationLedger;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=Funk&tion;
                                 ENU=F&unctions];
                      Image=Action }
      { 59      ;2   ;Action    ;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den tilsvarende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der oprettede en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#ItemTracking;
                      Image=OrderTracking;
                      OnAction=VAR
                                 TrackingForm@1001 : Page 99000822;
                               BEGIN
                                 TrackingForm.SetItemLedgEntry(Rec);
                                 TrackingForm.RUNMODAL;
                               END;
                                }
      { 32      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion posten er oprettet ud fra.;
                           ENU=Specifies which type of transaction that the entry is created from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† posten. Dokumentet er det regnskabsbilag, posten er baseret p†, f.eks. en kvittering.;
                           ENU=Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† varen i posten.;
                           ENU=Specifies the number of the item in the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som posten er tilknyttet.;
                           ENU=Specifies the code for the location that the entry is linked to.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Udlignet antal;
                           ENU=Applied Quantity];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er anvendt.;
                           ENU=Specifies how many units of the item that have been applied.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=ApplQty }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver det samlede antal anvendte enheder.;
                           ENU=Specifies the total quantity of items that have been applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Qty }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet faktureret.;
                           ENU=Specifies how many units of the item on the line have been invoiced.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoiced Quantity";
                Visible=TRUE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i feltet Antal, der mangler at blive behandlet.;
                           ENU=Specifies the quantity in the Quantity field that remains to be processed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Quantity";
                Visible=TRUE }

    { 117 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet reserveret.;
                           ENU=Specifies how many units of the item on the line have been reserved.];
                ApplicationArea=#Advanced;
                SourceExpr="Reserved Quantity";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              ShowReservationEntries(TRUE);
                            END;
                             }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er fuldt udlignet.;
                           ENU=Specifies whether the entry has been fully applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Open }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet pr. vareenhed.;
                           ENU=Specifies the quantity per item unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. per Unit of Measure";
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om din kreditor sender varerne p† linjen direkte til din debitor.;
                           ENU=Specifies if your vendor ships the items directly to your customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Drop Shipment";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der er en eller flere udlignede poster, der skal reguleres.;
                           ENU=Specifies whether there is one or more applied entries, which need to be adjusted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applied Entry to Adjust" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type ordre posten er oprettet i.;
                           ENU=Specifies which type of order that the entry was created in.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Type" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den ordre, hvor posten blev oprettet.;
                           ENU=Specifies the number of the order that created the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Order No.";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No." }

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
      Navigate@1000 : Page 344;
      ApplQty@1001 : Decimal;
      Qty@1002 : Decimal;

    LOCAL PROCEDURE GetApplQty@1();
    VAR
      ItemLedgEntry@1000 : Record 32;
    BEGIN
      ItemLedgEntry.GET("Entry No.");
      ApplQty := Quantity;
      Qty := ItemLedgEntry.Quantity;
    END;

    BEGIN
    END.
  }
}

