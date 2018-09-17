OBJECT Page 167 Item Ledger Entries Preview
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
    CaptionML=[DAN=Vis vareposter;
               ENU=Item Ledger Entries Preview];
    SourceTable=Table32;
    DataCaptionFields=Item No.;
    PageType=List;
    SourceTableTemporary=Yes;
    OnAfterGetRecord=BEGIN
                       CalcAmounts;
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
      { 9       ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr‘ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Suite;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
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
      { 86      ;2   ;Action    ;
                      CaptionML=[DAN=Udligningskladde;
                                 ENU=Application Worksheet];
                      ToolTipML=[DAN=Se vareudligninger, der automatisk oprettes mellem vareposter under vareposteringer.;
                                 ENU=View item applications that are automatically created between item ledger entries during item transactions.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ApplicationWorksheet;
                      OnAction=VAR
                                 ApplicationWorksheet@1000 : Page 521;
                               BEGIN
                                 CLEAR(ApplicationWorksheet);
                                 ApplicationWorksheet.SetRecordToShow(Rec);
                                 ApplicationWorksheet.RUN;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&unktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 59      ;2   ;Action    ;
                      CaptionML=[DAN=&Ordresporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den tilsvarende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der oprettede en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#ItemTracking;
                      Image=OrderTracking;
                      OnAction=VAR
                                 OrderTrackingForm@1001 : Page 99000822;
                               BEGIN
                                 OrderTrackingForm.SetItemLedgEntry(Rec);
                                 OrderTrackingForm.RUNMODAL;
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
                           ENU=Specifies which type of transaction the entry is created from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Type" }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type bilag der blev bogf›rt for at oprette vareposten.;
                           ENU=Specifies what type of document was posted to create the item ledger entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† posten. Dokumentet er det regnskabsbilag, posten er baseret p†, f.eks. en kvittering.;
                           ENU=Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den linje i det bogf›rte bilag, der svarer til vareposten.;
                           ENU=Specifies the number of the line on the posted document that corresponds to the item ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Line No.";
                Visible=FALSE }

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

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

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

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dato, hvor varen p† linjen kan anvendes.;
                           ENU=Specifies the last date that the item on the line can be used.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expiration Date";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et serienummer, hvis den bogf›rte vare har et s†dant nummer.;
                           ENU=Specifies a serial number if the posted item carries such a number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et lotnummer, hvis den bogf›rte vare har et s†dant nummer.;
                           ENU=Specifies a lot number if the posted item carries such a number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som posten er tilknyttet.;
                           ENU=Specifies the code for the location that the entry is linked to.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal vareenheder, der indg†r i vareposten.;
                           ENU=Specifies the number of units of the item in the item entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Quantity }

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

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for denne varepost, som blev leveret, og som endnu ikke er blevet returneret.;
                           ENU=Specifies the quantity for this item ledger entry that was shipped and has not yet been returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipped Qty. Not Returned";
                Visible=FALSE }

    { 117 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet reserveret.;
                           ENU=Specifies how many units of the item on the line have been reserved.];
                ApplicationArea=#Advanced;
                SourceExpr="Reserved Quantity";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet pr. vareenhed.;
                           ENU=Specifies the quantity per item unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. per Unit of Measure";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Salgsbel›b (forventet);
                           ENU=Sales Amount (Expected)];
                ToolTipML=[DAN=Angiver den forventede salgspris i RV. V‘lg feltet for at se de v‘rdiposter, der udg›r bel›bet.;
                           ENU=Specifies the expected sales amount in LCY. Choose the field to see the value entries that make up this amount.];
                ApplicationArea=#Advanced;
                SourceExpr=SalesAmountExpected;
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Salgsbel›b (faktisk);
                           ENU=Sales Amount (Actual)];
                ToolTipML=[DAN=Angiver summen af de faktiske salgsbel›b, hvis du bogf›rer.;
                           ENU=Specifies the sum of the actual sales amounts if you post.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SalesAmountActual }

    { 31  ;2   ;Field     ;
                CaptionML=[DAN=Kostbel›b (forventet);
                           ENU=Cost Amount (Expected)];
                ToolTipML=[DAN=Angiver det forventede kostbel›b for varen. Forventede kostbel›b beregnes ud fra bilag, som endnu ikke er fakturerede.;
                           ENU=Specifies the expected cost amount of the item. Expected costs are calculated from yet non-invoiced documents.];
                ApplicationArea=#Advanced;
                SourceExpr=CostAmountExpected;
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                CaptionML=[DAN=Kostbel›b (faktisk);
                           ENU=Cost Amount (Actual)];
                ToolTipML=[DAN=Angiver summen af de faktiske kostbel›b, hvis du bogf›rer.;
                           ENU=Specifies the sum of the actual cost amounts if you post.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CostAmountActual }

    { 47  ;2   ;Field     ;
                CaptionML=[DAN=Kostbel›b (ikke-lager);
                           ENU=Cost Amount (Non-Invtbl.)];
                ToolTipML=[DAN=Angiver summen af de ikke-lagerm‘ssige kostbel›b, hvis du bogf›rer. Normalt stammer ikke-lagerm‘ssige kostbel›b fra varegebyrer.;
                           ENU=Specifies the sum of the non-inventoriable cost amounts if you post. Typical non-inventoriable costs come from item charges.];
                ApplicationArea=#ItemCharges;
                SourceExpr=CostAmountNonInvtbl }

    { 49  ;2   ;Field     ;
                Name=CostAmountExpectedACY;
                CaptionML=[DAN=Kostbel›b (forventet) (EV);
                           ENU=Cost Amount (Expected) (ACY)];
                ToolTipML=[DAN=Angiver det forventede kostbel›b for varen. Forventede kostbel›b beregnes ud fra bilag, som endnu ikke er fakturerede.;
                           ENU=Specifies the expected cost amount of the item. Expected costs are calculated from yet non-invoiced documents.];
                ApplicationArea=#Advanced;
                SourceExpr=CostAmountExpectedACY;
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                Name=CostAmountActualACY;
                CaptionML=[DAN=Kostbel›b (faktisk) (EV);
                           ENU=Cost Amount (Actual) (ACY)];
                ToolTipML=[DAN=Angiver det faktiske kostbel›b for varen.;
                           ENU=Specifies the actual cost amount of the item.];
                ApplicationArea=#Advanced;
                SourceExpr=CostAmountActualACY;
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                CaptionML=[DAN=Kostbel›b (ikke-lager) (EV);
                           ENU=Cost Amount (Non-Invtbl.) (ACY)];
                ToolTipML=[DAN=Angiver summen af de ikke-lagerm‘ssige kostbel›b, hvis du bogf›rer. Normalt stammer ikke-lagerm‘ssige kostbel›b fra varegebyrer.;
                           ENU=Specifies the sum of the non-inventoriable cost amounts if you post. Typical non-inventoriable costs come from item charges.];
                ApplicationArea=#Advanced;
                SourceExpr=CostAmountNonInvtblACY;
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er fuldt faktureret, eller om der forventes flere bogf›rte fakturaer. Kun fuldt fakturerede poster kan reguleres.;
                           ENU=Specifies if the entry has been fully invoiced or if more posted invoices are expected. Only completely invoiced entries can be revalued.];
                ApplicationArea=#Advanced;
                SourceExpr="Completely Invoiced";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er fuldt udlignet.;
                           ENU=Specifies if the entry has been fully applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Open }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om din kreditor sender varerne p† linjen direkte til din debitor.;
                           ENU=Specifies if your vendor ships the items directly to your customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Drop Shipment";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bogf›ringen repr‘senterer et ordremontagesalg.;
                           ENU=Specifies if the posting represents an assemble-to-order sale.];
                ApplicationArea=#Assembly;
                SourceExpr="Assemble to Order";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der er en eller flere udlignede poster, der skal reguleres.;
                           ENU=Specifies whether there is one or more applied entries, which need to be adjusted.];
                ApplicationArea=#Advanced;
                SourceExpr="Applied Entry to Adjust";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion posten er oprettet ud fra.;
                           ENU=Specifies which type of transaction the entry is created from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Type" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den ordre, hvor posten blev oprettet.;
                           ENU=Specifies the number of the order that created the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Order No.";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p† den ordre, som oprettede posten.;
                           ENU=Specifies the line number of the order that created the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Line No.";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret for produktionsordrekomponenten.;
                           ENU=Specifies the line number of the production order component.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order Comp. Line No.";
                Visible=FALSE }

    { 1000;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Advanced;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 1002;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Advanced;
                SourceExpr="Job Task No.";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv‘rdier. De faktiske v‘rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension Set ID";
                Visible=FALSE }

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
      TempValueEntry@1009 : TEMPORARY Record 5802;
      DimensionSetIDFilter@1008 : Page 481;
      SalesAmountExpected@1000 : Decimal;
      SalesAmountActual@1001 : Decimal;
      CostAmountExpected@1002 : Decimal;
      CostAmountActual@1003 : Decimal;
      CostAmountNonInvtbl@1004 : Decimal;
      CostAmountExpectedACY@1005 : Decimal;
      CostAmountActualACY@1006 : Decimal;
      CostAmountNonInvtblACY@1007 : Decimal;

    [External]
    PROCEDURE Set@3(VAR TempItemLedgerEntry2@1000 : TEMPORARY Record 32;VAR TempValueEntry2@1001 : TEMPORARY Record 5802);
    BEGIN
      IF TempItemLedgerEntry2.FINDSET THEN
        REPEAT
          Rec := TempItemLedgerEntry2;
          INSERT;
        UNTIL TempItemLedgerEntry2.NEXT = 0;

      IF TempValueEntry2.FINDSET THEN
        REPEAT
          TempValueEntry := TempValueEntry2;
          TempValueEntry.INSERT;
        UNTIL TempValueEntry2.NEXT = 0;
    END;

    LOCAL PROCEDURE CalcAmounts@5();
    BEGIN
      SalesAmountExpected := 0;
      SalesAmountActual := 0;
      CostAmountExpected := 0;
      CostAmountActual := 0;
      CostAmountNonInvtbl := 0;
      CostAmountExpectedACY := 0;
      CostAmountActualACY := 0;
      CostAmountNonInvtblACY := 0;

      TempValueEntry.SETFILTER("Item Ledger Entry No.",'%1',"Entry No.");
      IF TempValueEntry.FINDSET THEN
        REPEAT
          SalesAmountExpected += TempValueEntry."Sales Amount (Expected)";
          SalesAmountActual += TempValueEntry."Sales Amount (Actual)";
          CostAmountExpected += TempValueEntry."Cost Amount (Expected)";
          CostAmountActual += TempValueEntry."Cost Amount (Actual)";
          CostAmountNonInvtbl += TempValueEntry."Cost Amount (Non-Invtbl.)";
          CostAmountExpectedACY += TempValueEntry."Cost Amount (Expected) (ACY)";
          CostAmountActualACY += TempValueEntry."Cost Amount (Actual) (ACY)";
          CostAmountNonInvtblACY += TempValueEntry."Cost Amount (Non-Invtbl.)(ACY)";
        UNTIL TempValueEntry.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

