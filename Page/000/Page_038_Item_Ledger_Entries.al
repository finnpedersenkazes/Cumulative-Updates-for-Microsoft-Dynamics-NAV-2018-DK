OBJECT Page 38 Item Ledger Entries
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
    CaptionML=[DAN=Vareposter;
               ENU=Item Ledger Entries];
    SourceTable=Table32;
    DataCaptionExpr=GetCaption;
    SourceTableView=SORTING(Entry No.)
                    ORDER(Descending);
    DataCaptionFields=Item No.;
    PageType=List;
    OnOpenPage=BEGIN
                 IF GETFILTERS <> '' THEN
                   IF FINDFIRST THEN;
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
                      ToolTipML=[DAN=Se posterne for hver reservation, der er foretaget, enten manuelt eller automatisk.;
                                 ENU=View the entries for every reservation that is made, either manually or automatically.];
                      ApplicationArea=#Advanced;
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
                      ApplicationArea=#Advanced;
                      Image=ApplicationWorksheet;
                      OnAction=VAR
                                 Worksheet@1000 : Page 521;
                               BEGIN
                                 CLEAR(Worksheet);
                                 Worksheet.SetRecordToShow(Rec);
                                 Worksheet.RUN;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
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
                      CaptionML=[DAN=N&aviger;
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
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion posten er oprettet ud fra.;
                           ENU=Specifies which type of transaction that the entry is created from.];
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
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet faktureret.;
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
                ToolTipML=[DAN=Angiver den forventede salgspris i RV.;
                           ENU=Specifies the expected sales amount, in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Amount (Expected)";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsbel›bet i RV.;
                           ENU=Specifies the sales amount, in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Amount (Actual)" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forventede kostpris i RV for antalsbogf›ringen.;
                           ENU=Specifies the expected cost, in LCY, of the quantity posting.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Expected)";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den regulerede kostpris i RV for antalsbogf›ringen.;
                           ENU=Specifies the adjusted cost, in LCY, of the quantity posting.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost Amount (Actual)" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den regulerede, ikke-lagerm‘ssige kostpris, som er et varegebyr, der er knyttet til en udg†ende post.;
                           ENU=Specifies the adjusted non-inventoriable cost, that is an item charge assigned to an outbound entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost Amount (Non-Invtbl.)" }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forventede kostpris i EV for antalsbogf›ringen.;
                           ENU=Specifies the expected cost, in ACY, of the quantity posting.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Expected) (ACY)";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den regulerede kostpris for posten i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the adjusted cost of the entry, in the additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Actual) (ACY)";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den regulerede, ikke-lagerm‘ssige kostpris, som er et varegebyr, der er knyttet til en udg†ende post i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the adjusted non-inventoriable cost, that is, an item charge assigned to an outbound entry in the additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Non-Invtbl.)(ACY)";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er fuldt faktureret, eller om der forventes flere bogf›rte fakturaer. Kun fuldt fakturerede poster kan reguleres.;
                           ENU=Specifies if the entry has been fully invoiced or if more posted invoices are expected. Only completely invoiced entries can be revalued.];
                ApplicationArea=#Advanced;
                SourceExpr="Completely Invoiced";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er fuldt udlignet.;
                           ENU=Specifies whether the entry has been fully applied to.];
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

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No." }

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
      Navigate@1000 : Page 344;
      DimensionSetIDFilter@1001 : Page 481;

    LOCAL PROCEDURE GetCaption@3() : Text;
    VAR
      GLSetup@1010 : Record 98;
      ObjTransl@1009 : Record 377;
      Item@1008 : Record 27;
      ProdOrder@1007 : Record 5405;
      Cust@1006 : Record 18;
      Vend@1005 : Record 23;
      Dimension@1004 : Record 348;
      DimValue@1003 : Record 349;
      SourceTableName@1002 : Text;
      SourceFilter@1001 : Text;
      Description@1000 : Text[100];
    BEGIN
      Description := '';

      CASE TRUE OF
        GETFILTER("Item No.") <> '':
          BEGIN
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,27);
            SourceFilter := GETFILTER("Item No.");
            IF MAXSTRLEN(Item."No.") >= STRLEN(SourceFilter) THEN
              IF Item.GET(SourceFilter) THEN
                Description := Item.Description;
          END;
        (GETFILTER("Order No.") <> '') AND ("Order Type" = "Order Type"::Production):
          BEGIN
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5405);
            SourceFilter := GETFILTER("Order No.");
            IF MAXSTRLEN(ProdOrder."No.") >= STRLEN(SourceFilter) THEN
              IF ProdOrder.GET(ProdOrder.Status::Released,SourceFilter) OR
                 ProdOrder.GET(ProdOrder.Status::Finished,SourceFilter)
              THEN BEGIN
                SourceTableName := STRSUBSTNO('%1 %2',ProdOrder.Status,SourceTableName);
                Description := ProdOrder.Description;
              END;
          END;
        GETFILTER("Source No.") <> '':
          CASE "Source Type" OF
            "Source Type"::Customer:
              BEGIN
                SourceTableName :=
                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,18);
                SourceFilter := GETFILTER("Source No.");
                IF MAXSTRLEN(Cust."No.") >= STRLEN(SourceFilter) THEN
                  IF Cust.GET(SourceFilter) THEN
                    Description := Cust.Name;
              END;
            "Source Type"::Vendor:
              BEGIN
                SourceTableName :=
                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,23);
                SourceFilter := GETFILTER("Source No.");
                IF MAXSTRLEN(Vend."No.") >= STRLEN(SourceFilter) THEN
                  IF Vend.GET(SourceFilter) THEN
                    Description := Vend.Name;
              END;
          END;
        GETFILTER("Global Dimension 1 Code") <> '':
          BEGIN
            GLSetup.GET;
            Dimension.Code := GLSetup."Global Dimension 1 Code";
            SourceFilter := GETFILTER("Global Dimension 1 Code");
            SourceTableName := Dimension.GetMLName(GLOBALLANGUAGE);
            IF MAXSTRLEN(DimValue.Code) >= STRLEN(SourceFilter) THEN
              IF DimValue.GET(GLSetup."Global Dimension 1 Code",SourceFilter) THEN
                Description := DimValue.Name;
          END;
        GETFILTER("Global Dimension 2 Code") <> '':
          BEGIN
            GLSetup.GET;
            Dimension.Code := GLSetup."Global Dimension 2 Code";
            SourceFilter := GETFILTER("Global Dimension 2 Code");
            SourceTableName := Dimension.GetMLName(GLOBALLANGUAGE);
            IF MAXSTRLEN(DimValue.Code) >= STRLEN(SourceFilter) THEN
              IF DimValue.GET(GLSetup."Global Dimension 2 Code",SourceFilter) THEN
                Description := DimValue.Name;
          END;
        GETFILTER("Document Type") <> '':
          BEGIN
            SourceTableName := GETFILTER("Document Type");
            SourceFilter := GETFILTER("Document No.");
            Description := GETFILTER("Document Line No.");
          END;
      END;
      EXIT(STRSUBSTNO('%1 %2 %3',SourceTableName,SourceFilter,Description));
    END;

    BEGIN
    END.
  }
}

