OBJECT Page 5807 Value Entries Preview
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
    CaptionML=[DAN=Vis v�rdiposter;
               ENU=Value Entries Preview];
    SourceTable=Table5802;
    PageType=List;
    SourceTableTemporary=Yes;
    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 7       ;1   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr�ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Suite;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
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

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for denne post.;
                           ENU=Specifies the posting date of this entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v�rdians�ttelsesdatoen, hvorfra posten medtages i beregningen af den gennemsnitlige kostpris.;
                           ENU=Specifies the valuation date from which the entry is included in the average cost calculation.];
                ApplicationArea=#Advanced;
                SourceExpr="Valuation Date";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type varepost, der har resulteret i v�rdiposten.;
                           ENU=Specifies the type of item ledger entry that caused this value entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Ledger Entry Type" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken v�rditype der er beskrevet i denne post.;
                           ENU=Specifies the type of value described in this entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Type" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type afvigelse der er beskrevet i denne post.;
                           ENU=Specifies the type of variance described in this entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Variance Type";
                Visible=FALSE }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om denne post har reguleret kostpris.;
                           ENU=Specifies if this entry has been cost adjusted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Adjustment }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type salgsdokument der blev bogf�rt for at oprette v�rdiposten.;
                           ENU=Specifies what type of document was posted to create the value entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for posten.;
                           ENU=Specifies the document number of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p� den linje i det bogf�rte salgsdokument, der svarer til v�rdiposten.;
                           ENU=Specifies the line number of the line on the posted document that corresponds to the value entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Line No.";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varegebyrnummeret for v�rdiposten.;
                           ENU=Specifies the item charge number of the value entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Item Charge No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forventede pris p� varen for en salgspost, dvs. at den ikke er faktureret endnu.;
                           ENU=Specifies the expected price of the item for a sales entry, which means that it has not been invoiced yet.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Amount (Expected)";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen p� varen for en salgspost.;
                           ENU=Specifies the price of the item for a sales entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Amount (Actual)" }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varernes forventede kostbel�b, som beregnes ved at gange Kostv�rdi pr. enhed med V�rdiansat antal.;
                           ENU=Specifies the expected cost of the items, which is calculated by multiplying the Cost per Unit by the Valued Quantity.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost Amount (Expected)" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningerne for fakturerede varer.;
                           ENU=Specifies the cost of invoiced items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost Amount (Actual)" }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kostbel�b vedr. ikke-lager, der er et varegebyr, tildelt til en udg�ende post.;
                           ENU=Specifies the non-inventoriable cost, that is an item charge assigned to an outbound entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost Amount (Non-Invtbl.)" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel�b, som er blevet bogf�rt i finansregnskabet.;
                           ENU=Specifies the amount that has been posted to the general ledger.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost Posted to G/L" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forventede kostbel�b, der er blevet bogf�rt p� mellemregningskontoen i finansregnskabet.;
                           ENU=Specifies the expected cost amount that has been posted to the interim account in the general ledger.];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Cost Posted to G/L";
                Visible=FALSE }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forventede kostv�rdi for varer i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the expected cost of the items in the additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Expected) (ACY)";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostv�rdien for de varer, der er blevet faktureret, hvis du bogf�rer i en ekstra rapporteringsvaluta.;
                           ENU=Specifies the cost of the items that have been invoiced, if you post in an additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Actual) (ACY)";
                Visible=FALSE }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kostbel�b vedr. ikke-lager, der er et varegebyr, tildelt til en udg�ende post. i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the non-inventoriable cost, that is an item charge assigned to an outbound entry in the additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Non-Invtbl.)(ACY)";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel�b, der er blevet bogf�rt i finansregnskabet, hvis du bogf�rer i en ekstra rapporteringsvaluta.;
                           ENU=Specifies the amount that has been posted to the general ledger if you post in an additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Posted to G/L (ACY)";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beregningen af den gennemsnitlige kostpris.;
                           ENU=Specifies the average cost calculation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Ledger Entry Quantity" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, som den regulerede kostpris og bel�bet i posten tilh�rer.;
                           ENU=Specifies the quantity that the adjusted cost and the amount of the entry belongs to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Valued Quantity" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der faktureres ved bogf�ring, som v�rdipostlinjen repr�senterer.;
                           ENU=Specifies how many units of the item are invoiced by the posting that the value entry line represents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoiced Quantity" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for �n basisenhed af varen i posten.;
                           ENU=Specifies the cost for one base unit of the item in the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost per Unit" }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for �n enhed af varen i posten.;
                           ENU=Specifies the cost of one unit of the item in the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost per Unit (ACY)" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den vare, som v�rdiposten er tilknyttet.;
                           ENU=Specifies the number of the item that this value entry is linked to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationskoden for den vare, posten er tilknyttet.;
                           ENU=Specifies the code for the location of the item that the entry is linked to.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af v�rdipost, n�r det vedr�rer en kapacitetspost.;
                           ENU=Specifies the type of value entry when it relates to a capacity entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Type;
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No.";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede rabatbel�b for v�rdiposten.;
                           ENU=Specifies the total discount amount of this value entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Discount Amount";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken s�lger eller indk�ber der er knyttet til posten.;
                           ENU=Specifies which salesperson or purchaser is linked to the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf�rt posten, der skal bruges, f.eks. i �ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf�ringsgruppen for den vare, debitor eller kreditor for den varepost, som denne v�rdipost er tilknyttet.;
                           ENU=Specifies the posting group for the item, customer, or vendor for the item entry that this value entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Posting Group";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kildetype, der g�lder for det kildenummer, som vises i feltet Kildenr.;
                           ENU=Specifies the source type that applies to the source number that is shown in the Source No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Type" }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source No." }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No." }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion posten er oprettet ud fra.;
                           ENU=Specifies which type of transaction the entry is created from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Type" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den ordre, hvor posten blev oprettet.;
                           ENU=Specifies the number of the order that created the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Order No.";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den regulerede kostpris for lagerreduktionen beregnes ud fra varens gennemsnitlige kostpris p� v�rdians�ttelsesdatoen.;
                           ENU=Specifies if the adjusted cost for the inventory decrease is calculated by the average cost of the item at the valuation date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Valued By Average Cost" }

    { 1000;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den sag, som v�rdiposten relaterer til.;
                           ENU=Specifies the number of the job that the value entry relates to.];
                ApplicationArea=#Advanced;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 1002;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Advanced;
                SourceExpr="Job Task No.";
                Visible=FALSE }

    { 1004;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den sagspost, som v�rdiposten relaterer til.;
                           ENU=Specifies the number of the job ledger entry that the value entry relates to.];
                ApplicationArea=#Advanced;
                SourceExpr="Job Ledger Entry No.";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv�rdier. De faktiske v�rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension Set ID";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      DimensionSetIDFilter@1000 : Page 481;

    [External]
    PROCEDURE Set@1(VAR TempValueEntry@1000 : TEMPORARY Record 5802);
    BEGIN
      IF TempValueEntry.FIND('-') THEN
        REPEAT
          Rec := TempValueEntry;
          INSERT;
        UNTIL TempValueEntry.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

