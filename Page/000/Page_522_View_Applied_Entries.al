OBJECT Page 522 View Applied Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Permissions=TableData 339=rimd;
    CaptionML=[DAN=Vis udlignede poster;
               ENU=View Applied Entries];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table32;
    DataCaptionExpr=CaptionExpr;
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             RemoveAppButtonVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 CurrPage.LOOKUPMODE := NOT ShowApplied;
                 RemoveAppButtonVisible := ShowApplied;
                 Show;
               END;

    OnFindRecord=BEGIN
                   EXIT(FIND(Which));
                 END;

    OnAfterGetRecord=BEGIN
                       GetApplQty;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 37      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 48      ;2   ;Action    ;
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
      { 38      ;2   ;Action    ;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=Reservationsposter;
                                 ENU=Reservation Entries];
                      ToolTipML=[DAN=Vis posterne for hver reservation, der er foretaget, enten manuelt eller automatisk.;
                                 ENU=View the entries for every reservation that is made, either manually or automatically.];
                      ApplicationArea=#Advanced;
                      Image=ReservationLedger;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1       ;1   ;Action    ;
                      Name=RemoveAppButton;
                      CaptionML=[DAN=Fjern udl&igning;
                                 ENU=Re&move Application];
                      ToolTipML=[DAN=Fjern vareudligninger.;
                                 ENU=Remove item applications.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Visible=RemoveAppButtonVisible;
                      Image=Cancel;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 UnapplyRec;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion posten er oprettet ud fra.;
                           ENU=Specifies which type of transaction that the entry is created from.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Type" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type bilag der blev bogf›rt for at oprette vareposten.;
                           ENU=Specifies what type of document was posted to create the item ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Type" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† posten. Dokumentet er det regnskabsbilag, posten er baseret p†, f.eks. en kvittering.;
                           ENU=Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No." }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den linje i det bogf›rte bilag, der svarer til vareposten.;
                           ENU=Specifies the number of the line on the posted document that corresponds to the item ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Line No.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† varen i posten.;
                           ENU=Specifies the number of the item in the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No.";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et serienummer, hvis den bogf›rte vare har et s†dant nummer.;
                           ENU=Specifies a serial number if the posted item carries such a number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et lotnummer, hvis den bogf›rte vare har et s†dant nummer.;
                           ENU=Specifies a lot number if the posted item carries such a number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Description;
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som posten er tilknyttet.;
                           ENU=Specifies the code for the location that the entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                CaptionML=[DAN=Udlignet antal;
                           ENU=Applied Quantity];
                ToolTipML=[DAN=Angiver antallet for den varepost, der er blevet knyttet til en lagerreduktion eller lagerfor›gelse, alt efter hvad der er relevant.;
                           ENU=Specifies the quantity of the item ledger entry linked to an inventory decrease, or increase, as appropriate.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=ApplQty }

    { 35  ;2   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver antallet for vareposten.;
                           ENU=Specifies the quantity of the item ledger entry.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=Qty }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den regulerede kostpris i RV for antalsbogf›ringen.;
                           ENU=Specifies the adjusted cost, in LCY, of the quantity posting.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Actual)" }

    { 42  ;2   ;Field     ;
                CaptionML=[DAN=Kostpris (RV);
                           ENU=Unit Cost(LCY)];
                ToolTipML=[DAN=Angiver k›bsprisen p† varen i vareposten.;
                           ENU=Specifies the unit cost of the item in the item ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr=GetUnitCostLCY;
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet faktureret.;
                           ENU=Specifies how many units of the item on the line have been invoiced.];
                ApplicationArea=#Advanced;
                SourceExpr="Invoiced Quantity";
                Visible=TRUE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet faktureret.;
                           ENU=Specifies how many units of the item on the line have been reserved.];
                ApplicationArea=#Advanced;
                SourceExpr="Reserved Quantity" }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i feltet Antal, der mangler at blive behandlet.;
                           ENU=Specifies the quantity in the Quantity field that remains to be processed.];
                ApplicationArea=#Advanced;
                SourceExpr="Remaining Quantity";
                Visible=TRUE }

    { 1102601000;2;Field  ;
                CaptionML=[DAN=Disponibelt antal til kostprisudligning;
                           ENU=Quantity Available for Cost Applications];
                ToolTipML=[DAN=Angiver antallet for den varepost, der kan omkostningsudlignes.;
                           ENU=Specifies the quantity of the item ledger entry that can be cost applied.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=CostAvailable(Rec) }

    { 51  ;2   ;Field     ;
                CaptionML=[DAN=Disponibel til kostprisudligning;
                           ENU=Available for Quantity Application];
                ToolTipML=[DAN=Angiver antallet for den varepost, der kan udlignes.;
                           ENU=Specifies the quantity of the item ledger entry that can be applied.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=QuantityAvailable(Rec) }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for denne varepost, som blev leveret, og som endnu ikke er blevet returneret.;
                           ENU=Specifies the quantity for this item ledger entry that was shipped and has not yet been returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipped Qty. Not Returned" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er fuldt udlignet.;
                           ENU=Specifies whether the entry has been fully applied to.];
                ApplicationArea=#Advanced;
                SourceExpr=Open }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet pr. vareenhed.;
                           ENU=Specifies the quantity per item unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. per Unit of Measure";
                Visible=FALSE }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om din kreditor sender varerne p† linjen direkte til din debitor.;
                           ENU=Specifies if your vendor ships the items directly to your customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Drop Shipment";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om antallet p† kladdelinjen skal udlignes med en allerede bogf›rt post. Hvis det er tilf‘ldet, skal du angive det l›benummer, som antallet skal udlignes efter.;
                           ENU=Specifies if the quantity on the journal line must be applied to an already-posted entry. In that case, enter the entry number that the quantity will be applied to.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to Entry";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der er en eller flere udlignede poster, der skal reguleres.;
                           ENU=Specifies whether there is one or more applied entries, which need to be adjusted.];
                ApplicationArea=#Advanced;
                SourceExpr="Applied Entry to Adjust";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type ordre posten er oprettet i.;
                           ENU=Specifies which type of order that the entry was created in.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Type" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den ordre, hvor posten blev oprettet.;
                           ENU=Specifies the number of the order that created the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Order No.";
                Visible=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No." }

  }
  CODE
  {
    VAR
      RecordToShow@1008 : Record 32;
      TempItemLedgEntry@1001 : TEMPORARY Record 32;
      Apply@1003 : Codeunit 22;
      ShowApplied@1002 : Boolean;
      ShowQuantity@1007 : Boolean;
      MaxToApply@1004 : Decimal;
      ApplQty@1005 : Decimal;
      Qty@1006 : Decimal;
      TotalApplied@1015 : Decimal;
      Text001@1000 : TextConst 'DAN=Udlignede poster;ENU=Applied Entries';
      Text002@1009 : TextConst 'DAN=Ikke-udlignede poster;ENU=Unapplied Entries';
      RemoveAppButtonVisible@19026324 : Boolean INDATASET;

    [External]
    PROCEDURE SetRecordToShow@7(VAR RecordToSet@1000 : Record 32;VAR ApplyCodeunit@1001 : Codeunit 22;newShowApplied@1002 : Boolean);
    BEGIN
      RecordToShow.COPY(RecordToSet);
      Apply := ApplyCodeunit;
      ShowApplied := newShowApplied;
    END;

    LOCAL PROCEDURE Show@8();
    VAR
      ItemLedgEntry@1000 : Record 32;
      Apprec@1102601000 : Record 339;
    BEGIN
      WITH ItemLedgEntry DO BEGIN
        GET(RecordToShow."Entry No.");
        ShowQuantity := NOT (("Entry Type" IN ["Entry Type"::Sale,"Entry Type"::Consumption,"Entry Type"::Output]) AND Positive);

        MaxToApply := 0;
        IF NOT ShowQuantity THEN
          MaxToApply := Quantity + Apprec.Returned("Entry No.");
      END;
      SetMyView(RecordToShow,ShowApplied,ShowQuantity,MaxToApply);
    END;

    LOCAL PROCEDURE SetMyView@22(ItemLedgEntry@1000 : Record 32;ShowApplied@1002 : Boolean;ShowQuantity@1004 : Boolean;MaxToApply@1005 : Decimal);
    BEGIN
      InitView;
      CASE ShowQuantity OF
        TRUE:
          CASE ShowApplied OF
            TRUE:
              ShowQuantityApplied(ItemLedgEntry);
            FALSE:
              BEGIN
                ShowQuantityOpen(ItemLedgEntry);
                ShowCostOpen(ItemLedgEntry,MaxToApply);
              END;
          END;
        FALSE:
          CASE ShowApplied OF
            TRUE:
              ShowCostApplied(ItemLedgEntry);
            FALSE:
              ShowCostOpen(ItemLedgEntry,MaxToApply);
          END;
      END;

      IF TempItemLedgEntry.FINDSET THEN
        REPEAT
          Rec := TempItemLedgEntry;
          INSERT;
        UNTIL TempItemLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE InitView@23();
    BEGIN
      DELETEALL;
      TempItemLedgEntry.RESET;
      TempItemLedgEntry.DELETEALL;
    END;

    LOCAL PROCEDURE ShowQuantityApplied@20(ItemLedgEntry@1000 : Record 32);
    VAR
      ItemApplnEntry@1002 : Record 339;
    BEGIN
      InitApplied;
      WITH ItemLedgEntry DO
        IF Positive THEN BEGIN
          ItemApplnEntry.RESET;
          ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.","Outbound Item Entry No.","Cost Application");
          ItemApplnEntry.SETRANGE("Inbound Item Entry No.","Entry No.");
          ItemApplnEntry.SETFILTER("Outbound Item Entry No.",'<>%1&<>%2',"Entry No.",0);
          IF ItemApplnEntry.FIND('-') THEN
            REPEAT
              InsertTempEntry(ItemApplnEntry."Outbound Item Entry No.",ItemApplnEntry.Quantity,TRUE);
            UNTIL ItemApplnEntry.NEXT = 0;
        END ELSE BEGIN
          ItemApplnEntry.RESET;
          ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
          ItemApplnEntry.SETRANGE("Outbound Item Entry No.","Entry No.");
          ItemApplnEntry.SETRANGE("Item Ledger Entry No.","Entry No.");
          IF ItemApplnEntry.FIND('-') THEN
            REPEAT
              InsertTempEntry(ItemApplnEntry."Inbound Item Entry No.",-ItemApplnEntry.Quantity,TRUE);
            UNTIL ItemApplnEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE ShowQuantityOpen@19(ItemLedgEntry@1000 : Record 32);
    VAR
      ItemApplnEntry@1002 : Record 339;
      ItemLedgEntry2@1001 : Record 32;
    BEGIN
      WITH ItemLedgEntry DO
        IF "Remaining Quantity" <> 0 THEN BEGIN
          ItemLedgEntry2.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
          ItemLedgEntry2.SETRANGE("Item No.","Item No.");
          ItemLedgEntry2.SETRANGE("Location Code" ,"Location Code");
          ItemLedgEntry2.SETRANGE(Positive,NOT Positive);
          ItemLedgEntry2.SETRANGE(Open,TRUE);
          IF ItemLedgEntry2.FIND('-') THEN
            REPEAT
              IF (QuantityAvailable(ItemLedgEntry2) <> 0) AND
                 NOT ItemApplnEntry.ExistsBetween("Entry No.",ItemLedgEntry2."Entry No.")
              THEN
                InsertTempEntry(ItemLedgEntry2."Entry No.",0,TRUE);
            UNTIL ItemLedgEntry2.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE ShowCostApplied@18(ItemLedgEntry@1000 : Record 32);
    VAR
      ItemApplnEntry@1002 : Record 339;
    BEGIN
      InitApplied;
      WITH ItemLedgEntry DO
        IF Positive THEN BEGIN
          ItemApplnEntry.RESET;
          ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.","Outbound Item Entry No.","Cost Application");
          ItemApplnEntry.SETRANGE("Inbound Item Entry No.","Entry No.");
          ItemApplnEntry.SETFILTER("Item Ledger Entry No.",'<>%1',"Entry No.");
          ItemApplnEntry.SETFILTER("Outbound Item Entry No.",'<>%1',0);
          ItemApplnEntry.SETRANGE("Cost Application",TRUE); // we want to show even average cost application
          IF ItemApplnEntry.FIND('-') THEN
            REPEAT
              InsertTempEntry(ItemApplnEntry."Outbound Item Entry No.",ItemApplnEntry.Quantity,FALSE);
            UNTIL ItemApplnEntry.NEXT = 0;
        END ELSE BEGIN
          ItemApplnEntry.RESET;
          ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
          ItemApplnEntry.SETRANGE("Outbound Item Entry No.","Entry No.");
          ItemApplnEntry.SETFILTER("Item Ledger Entry No.",'<>%1',"Entry No.");
          ItemApplnEntry.SETRANGE("Cost Application",TRUE); // we want to show even average cost application
          IF ItemApplnEntry.FIND('-') THEN
            REPEAT
              InsertTempEntry(ItemApplnEntry."Inbound Item Entry No.",-ItemApplnEntry.Quantity,FALSE);
            UNTIL ItemApplnEntry.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE ShowCostOpen@17(ItemLedgEntry@1000 : Record 32;MaxToApply@1003 : Decimal);
    VAR
      ItemApplnEntry@1002 : Record 339;
      ItemLedgEntry2@1001 : Record 32;
    BEGIN
      WITH ItemLedgEntry DO BEGIN
        ItemLedgEntry2.SETCURRENTKEY("Item No.",Positive,"Location Code","Variant Code");
        ItemLedgEntry2.SETRANGE("Item No.","Item No.");
        ItemLedgEntry2.SETRANGE("Location Code","Location Code");
        ItemLedgEntry2.SETRANGE(Positive,NOT Positive);
        ItemLedgEntry2.SETFILTER("Shipped Qty. Not Returned",'<%1&>=%2',0,-MaxToApply);
        IF (MaxToApply <> 0) AND Positive THEN
          ItemLedgEntry2.SETFILTER("Shipped Qty. Not Returned",'<=%1',-MaxToApply);
        IF ItemLedgEntry2.FIND('-') THEN
          REPEAT
            IF (CostAvailable(ItemLedgEntry2) <> 0) AND
               NOT ItemApplnEntry.ExistsBetween("Entry No.",ItemLedgEntry2."Entry No.")
            THEN
              InsertTempEntry(ItemLedgEntry2."Entry No.",0,TRUE);
          UNTIL ItemLedgEntry2.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE InsertTempEntry@21(EntryNo@1000 : Integer;AppliedQty@1001 : Decimal;ShowQuantity@1003 : Boolean);
    VAR
      ItemLedgEntry@1002 : Record 32;
    BEGIN
      ItemLedgEntry.GET(EntryNo);

      IF ShowQuantity THEN
        IF AppliedQty * ItemLedgEntry.Quantity < 0 THEN
          EXIT;

      IF NOT TempItemLedgEntry.GET(EntryNo) THEN BEGIN
        TempItemLedgEntry.RESET;
        TempItemLedgEntry := ItemLedgEntry;
        TempItemLedgEntry.CALCFIELDS("Reserved Quantity");
        TempItemLedgEntry.Quantity := AppliedQty;
        TempItemLedgEntry.INSERT;
      END ELSE BEGIN
        TempItemLedgEntry.Quantity := TempItemLedgEntry.Quantity + AppliedQty;
        TempItemLedgEntry.MODIFY;
      END;

      TotalApplied := TotalApplied + AppliedQty;
    END;

    LOCAL PROCEDURE InitApplied@13();
    BEGIN
      CLEAR(TotalApplied);
    END;

    LOCAL PROCEDURE RemoveApplications@1(Inbound@1000 : Integer;OutBound@1001 : Integer);
    VAR
      Application@1003 : Record 339;
    BEGIN
      Application.SETCURRENTKEY("Inbound Item Entry No.","Outbound Item Entry No.");
      Application.SETRANGE("Inbound Item Entry No.",Inbound);
      Application.SETRANGE("Outbound Item Entry No.",OutBound);
      IF Application.FINDSET THEN
        REPEAT
          Apply.UnApply(Application);
          Apply.LogUnapply(Application);
        UNTIL Application.NEXT = 0;
    END;

    LOCAL PROCEDURE UnapplyRec@3();
    VAR
      Applyrec@1001 : Record 32;
      AppliedItemLedgEntry@1002 : Record 32;
    BEGIN
      Applyrec.GET(RecordToShow."Entry No.");
      CurrPage.SETSELECTIONFILTER(TempItemLedgEntry);
      IF TempItemLedgEntry.FINDSET THEN
        REPEAT
          AppliedItemLedgEntry.GET(TempItemLedgEntry."Entry No.");
          IF AppliedItemLedgEntry."Entry No." <> 0 THEN BEGIN
            IF Applyrec.Positive THEN
              RemoveApplications(Applyrec."Entry No.",AppliedItemLedgEntry."Entry No.")
            ELSE
              RemoveApplications(AppliedItemLedgEntry."Entry No.",Applyrec."Entry No.");
          END;
        UNTIL TempItemLedgEntry.NEXT = 0;

      BlockItem(Applyrec."Item No.");
      Show;
    END;

    [Internal]
    PROCEDURE ApplyRec@5();
    VAR
      Applyrec@1000 : Record 32;
      AppliedItemLedgEntry@1002 : Record 32;
    BEGIN
      Applyrec.GET(RecordToShow."Entry No.");
      CurrPage.SETSELECTIONFILTER(TempItemLedgEntry);
      IF TempItemLedgEntry.FINDSET THEN
        REPEAT
          AppliedItemLedgEntry.GET(TempItemLedgEntry."Entry No.");
          IF AppliedItemLedgEntry."Entry No." <> 0 THEN BEGIN
            Apply.ReApply(Applyrec,AppliedItemLedgEntry."Entry No.");
            Apply.LogApply(Applyrec,AppliedItemLedgEntry);
          END;
        UNTIL TempItemLedgEntry.NEXT = 0;

      IF Applyrec.Positive THEN
        RemoveDuplicateApplication(Applyrec."Entry No.");

      Show;
    END;

    LOCAL PROCEDURE RemoveDuplicateApplication@4(ItemLedgerEntryNo@1000 : Integer);
    VAR
      ItemApplicationEntry@1001 : Record 339;
    BEGIN
      WITH ItemApplicationEntry DO BEGIN
        SETCURRENTKEY("Inbound Item Entry No.","Item Ledger Entry No.","Outbound Item Entry No.","Cost Application");
        SETRANGE("Inbound Item Entry No.",ItemLedgerEntryNo);
        SETRANGE("Item Ledger Entry No.",ItemLedgerEntryNo);
        SETFILTER("Outbound Item Entry No.",'<>0');
        IF NOT ISEMPTY THEN BEGIN
          SETRANGE("Outbound Item Entry No.",0);
          DELETEALL;
        END
      END;
    END;

    LOCAL PROCEDURE BlockItem@9(ItemNo@1000 : Code[20]);
    VAR
      Item@1001 : Record 27;
    BEGIN
      Item.GET(ItemNo);
      IF Item."Application Wksh. User ID" <> UPPERCASE(USERID) THEN
        Item.CheckBlockedByApplWorksheet;

      Item."Application Wksh. User ID" := USERID;
      Item.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE GetApplQty@10();
    VAR
      ItemLedgEntry@1000 : Record 32;
    BEGIN
      ItemLedgEntry.GET("Entry No.");
      ApplQty := Quantity;
      Qty := ItemLedgEntry.Quantity;
    END;

    LOCAL PROCEDURE QuantityAvailable@11(ILE@1000 : Record 32) : Decimal;
    BEGIN
      WITH ILE DO BEGIN
        CALCFIELDS("Reserved Quantity");
        EXIT("Remaining Quantity" - "Reserved Quantity");
      END;
    END;

    LOCAL PROCEDURE CostAvailable@1102601000(ILE@1000 : Record 32) : Decimal;
    VAR
      Apprec@1102601000 : Record 339;
    BEGIN
      WITH ILE DO BEGIN
        IF "Shipped Qty. Not Returned" <> 0 THEN
          EXIT(-"Shipped Qty. Not Returned");

        EXIT("Remaining Quantity" + Apprec.Returned("Entry No."));
      END;
    END;

    LOCAL PROCEDURE CaptionExpr@2() : Text[250];
    BEGIN
      IF ShowApplied THEN
        EXIT(Text001);

      EXIT(Text002);
    END;

    BEGIN
    END.
  }
}

