OBJECT Page 5802 Value Entries
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
    CaptionML=[DAN=Vërdiposter;
               ENU=Value Entries];
    SourceTable=Table5802;
    DataCaptionExpr=GetCaption;
    PageType=List;
    OnOpenPage=BEGIN
                 FilterGroupNo := FILTERGROUP; // Trick: FILTERGROUP is used to transfer an integer value
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 80      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 81      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begrëns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Suite;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                               END;
                                }
      { 108     ;2   ;Action    ;
                      CaptionML=[DAN=Finans;
                                 ENU=General Ledger];
                      ToolTipML=[DAN=èbn finans.;
                                 ENU=Open the general ledger.];
                      ApplicationArea=#Advanced;
                      Image=GLRegisters;
                      OnAction=BEGIN
                                 ShowGL;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 79      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Advanced;
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

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogfõringsdatoen for denne post.;
                           ENU=Specifies the posting date of this entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver vërdiansëttelsesdatoen, hvorfra posten medtages i beregningen af den gennemsnitlige kostpris.;
                           ENU=Specifies the valuation date from which the entry is included in the average cost calculation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Valuation Date";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type varepost, der har resulteret i vërdiposten.;
                           ENU=Specifies the type of item ledger entry that caused this value entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Ledger Entry Type" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken vërditype der er beskrevet i denne post.;
                           ENU=Specifies the type of value described in this entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Type" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type afvigelse der er beskrevet i denne post.;
                           ENU=Specifies the type of variance described in this entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Variance Type";
                Visible=FALSE }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at dette felt er indsat af kõrslen Juster kostpris - vareposter, hvis den indeholder en markering.;
                           ENU=Specifies this field was inserted by the Adjust Cost - Item Entries batch job, if it contains a check mark.];
                ApplicationArea=#Advanced;
                SourceExpr=Adjustment }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type salgsdokument der blev bogfõrt for at oprette vërdiposten.;
                           ENU=Specifies what type of document was posted to create the value entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for posten.;
                           ENU=Specifies the document number of the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret pÜ den linje i det bogfõrte salgsdokument, der svarer til vërdiposten.;
                           ENU=Specifies the line number of the line on the posted document that corresponds to the value entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Line No.";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varegebyrnummeret for vërdiposten.;
                           ENU=Specifies the item charge number of the value entry.];
                ApplicationArea=#Basic,#Suite;
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
                ToolTipML=[DAN=Angiver den forventede pris pÜ varen for en salgspost, dvs. at den ikke er faktureret endnu.;
                           ENU=Specifies the expected price of the item for a sales entry, which means that it has not been invoiced yet.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Amount (Expected)";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen pÜ varen for en salgspost.;
                           ENU=Specifies the price of the item for a sales entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Amount (Actual)" }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varernes forventede kostbelõb, som beregnes ved at gange Kostvërdi pr. enhed med Vërdiansat antal.;
                           ENU=Specifies the expected cost of the items, which is calculated by multiplying the Cost per Unit by the Valued Quantity.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Expected)" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningerne for fakturerede varer.;
                           ENU=Specifies the cost of invoiced items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost Amount (Actual)" }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kostbelõb vedr. ikke-lager, der er et varegebyr, tildelt til en udgÜende post.;
                           ENU=Specifies the non-inventoriable cost, that is an item charge assigned to an outbound entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost Amount (Non-Invtbl.)" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, som er blevet bogfõrt i finansregnskabet.;
                           ENU=Specifies the amount that has been posted to the general ledger.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost Posted to G/L" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forventede kostbelõb, der er blevet bogfõrt pÜ mellemregningskontoen i finansregnskabet.;
                           ENU=Specifies the expected cost amount that has been posted to the interim account in the general ledger.];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Cost Posted to G/L";
                Visible=FALSE }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forventede kostvërdi for varer i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the expected cost of the items in the additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Expected) (ACY)";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostvërdien for de varer, der er blevet faktureret, hvis du bogfõrer i en ekstra rapporteringsvaluta.;
                           ENU=Specifies the cost of the items that have been invoiced, if you post in an additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Actual) (ACY)";
                Visible=FALSE }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kostbelõb vedr. ikke-lager, der er et varegebyr, tildelt til en udgÜende post. i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the non-inventoriable cost, that is an item charge assigned to an outbound entry in the additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Non-Invtbl.)(ACY)";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der er blevet bogfõrt i finansregnskabet, hvis du bogfõrer i en ekstra rapporteringsvaluta.;
                           ENU=Specifies the amount that has been posted to the general ledger if you post in an additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Posted to G/L (ACY)";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beregningen af den gennemsnitlige kostpris.;
                           ENU=Specifies the average cost calculation.];
                ApplicationArea=#Advanced;
                SourceExpr="Item Ledger Entry Quantity" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, som den regulerede kostpris og belõbet i posten tilhõrer.;
                           ENU=Specifies the quantity that the adjusted cost and the amount of the entry belongs to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Valued Quantity" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der faktureres ved bogfõring, som vërdipostlinjen reprësenterer.;
                           ENU=Specifies how many units of the item are invoiced by the posting that the value entry line represents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoiced Quantity" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for Çn basisenhed af varen i posten.;
                           ENU=Specifies the cost for one base unit of the item in the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost per Unit" }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for Çn enhed af varen i posten.;
                           ENU=Specifies the cost of one unit of the item in the entry.];
                ApplicationArea=#Suite;
                SourceExpr="Cost per Unit (ACY)" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, som vërdiposten er tilknyttet.;
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
                ToolTipML=[DAN=Angiver typen af vërdipost, nÜr det vedrõrer en kapacitetspost.;
                           ENU=Specifies the type of value entry when it relates to a capacity entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type;
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede rabatbelõb for vërdiposten.;
                           ENU=Specifies the total discount amount of this value entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Discount Amount";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken sëlger eller indkõber der er knyttet til posten.;
                           ENU=Specifies which salesperson or purchaser is linked to the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogfõrt posten, der skal bruges, f.eks. i ëndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogfõringsgruppen for den vare, debitor eller kreditor for den varepost, som denne vërdipost er tilknyttet.;
                           ENU=Specifies the posting group for the item, customer, or vendor for the item entry that this value entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Posting Group";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik pÜ analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilgëngelige pÜ alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik pÜ analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilgëngelige pÜ alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kildetype, der gëlder for det kildenummer, som vises i feltet Kildenr.;
                           ENU=Specifies the source type that applies to the source number that is shown in the Source No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Type" }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source No." }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No." }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type ordre posten er oprettet i.;
                           ENU=Specifies which type of order that the entry was created in.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Type" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den ordre, hvor posten blev oprettet.;
                           ENU=Specifies the number of the order that created the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order No.";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den regulerede kostpris for lagerreduktionen beregnes ud fra varens gennemsnitlige kostpris pÜ vërdiansëttelsesdatoen.;
                           ENU=Specifies if the adjusted cost for the inventory decrease is calculated by the average cost of the item at the valuation date.];
                ApplicationArea=#Advanced;
                SourceExpr="Valued By Average Cost" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den varepost, som vërdiposten er tilknyttet.;
                           ENU=Specifies the number of the item ledger entry that this value entry is linked to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Ledger Entry No." }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lõbenummeret pÜ den varepost, som vërdiposten er tilknyttet.;
                           ENU=Specifies the entry number of the item ledger entry that this value entry is linked to.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Capacity Ledger Entry No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No." }

    { 1000;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den sag, som vërdiposten relaterer til.;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den sagspost, som vërdiposten relaterer til.;
                           ENU=Specifies the number of the job ledger entry that the value entry relates to.];
                ApplicationArea=#Advanced;
                SourceExpr="Job Ledger Entry No.";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsvërdier. De faktiske vërdier gemmes i tabellen Dimensionsgruppepost.;
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
      DimensionSetIDFilter@1002 : Page 481;
      FilterGroupNo@1001 : Integer;

    LOCAL PROCEDURE GetCaption@3() : Text[250];
    VAR
      GLSetup@1010 : Record 98;
      ObjTransl@1009 : Record 377;
      Item@1008 : Record 27;
      ProdOrder@1007 : Record 5405;
      Cust@1006 : Record 18;
      Vend@1005 : Record 23;
      Dimension@1004 : Record 348;
      DimValue@1003 : Record 349;
      SourceTableName@1002 : Text[100];
      SourceFilter@1001 : Text;
      Description@1000 : Text[100];
    BEGIN
      Description := '';

      CASE TRUE OF
        GETFILTER("Item Ledger Entry No.") <> '':
          BEGIN
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,32);
            SourceFilter := GETFILTER("Item Ledger Entry No.");
          END;
        GETFILTER("Capacity Ledger Entry No.") <> '':
          BEGIN
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5832);
            SourceFilter := GETFILTER("Capacity Ledger Entry No.");
          END;
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
        FilterGroupNo = DATABASE::"Item Analysis View Entry":
          BEGIN
            IF Item."No." <> "Item No." THEN
              IF NOT Item.GET("Item No.") THEN
                CLEAR(Item);
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DATABASE::"Item Analysis View Entry");
            SourceFilter := Item."No.";
            Description := Item.Description;
          END;
      END;

      EXIT(STRSUBSTNO('%1 %2 %3',SourceTableName,SourceFilter,Description));
    END;

    BEGIN
    END.
  }
}

