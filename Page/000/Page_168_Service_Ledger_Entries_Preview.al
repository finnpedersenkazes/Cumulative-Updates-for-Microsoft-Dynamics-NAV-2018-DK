OBJECT Page 168 Service Ledger Entries Preview
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
    CaptionML=[DAN=Vis serviceposter;
               ENU=Service Ledger Entries Preview];
    SourceTable=Table5907;
    DataCaptionFields=Service Contract No.,Service Item No. (Serviced),Service Order No.;
    PageType=List;
    SourceTableTemporary=Yes;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 96      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=&Entry];
                      Image=Entry }
      { 97      ;2   ;Action    ;
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
      { 3       ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr‘ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Dimensions;
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

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor posten blev bogf›rt.;
                           ENU=Specifies the date when this entry was posted.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for posten.;
                           ENU=Specifies the type for this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Type" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serviceordretypen, hvis posten blev oprettet til en serviceordre.;
                           ENU=Specifies the type of the service order if this entry was created for a service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† servicekontrakten, hvis posten er knyttet til en servicekontrakt.;
                           ENU=Specifies the number of the service contract, if this entry is linked to a service contract.];
                ApplicationArea=#Service;
                SourceExpr="Service Contract No." }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† serviceordren, hvis posten blev oprettet til en serviceordre.;
                           ENU=Specifies the number of the service order, if this entry was created for a service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Order No." }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Advanced;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Advanced;
                SourceExpr="Job Task No.";
                Visible=FALSE }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kladdelinjetype, der oprettes i tabellen Sagsplanl‘gningslinje, og som er knyttet til sagsposten.;
                           ENU=Specifies the journal line type that is created in the Job Planning Line table and linked to this job ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Job Line Type";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dokumenttypen for serviceposten.;
                           ENU=Specifies the document type of the service ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bilag, hvorfra posten blev oprettet.;
                           ENU=Specifies the number of the document from which this entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No." }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, der er knyttet til posten.;
                           ENU=Specifies the number of the customer related to this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Customer No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den reparerede serviceartikel, som er knyttet til posten.;
                           ENU=Specifies the number of the serviced item associated with this entry.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No. (Serviced)" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den reparerede serviceartikel, som er knyttet til posten.;
                           ENU=Specifies the number of the serviced item associated with this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No. (Serviced)" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p† den reparerede serviceartikel, som er knyttet til posten.;
                           ENU=Specifies the serial number of the serviced item associated with this entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No. (Serviced)" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturaperioden for den p†g‘ldende kontrakt, hvis posten stammer fra en servicekontrakt.;
                           ENU=Specifies the invoice period of that contract, if this entry originates from a service contract.];
                ApplicationArea=#Advanced;
                SourceExpr="Contract Invoice Period";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Code" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Code" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontraktgruppekoden for den servicekontrakt, som posten er tilknyttet.;
                           ENU=Specifies the contract group code of the service contract to which this entry is associated.];
                ApplicationArea=#Advanced;
                SourceExpr="Contract Group Code";
                Visible=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oprindelsestypen for posten.;
                           ENU=Specifies the type of origin of this entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Type }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den totale pris p† linjen ved at multiplicere kostprisen med antallet.;
                           ENU=Specifies the total cost on the line by multiplying the unit cost by the quantity.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede rabatbel›b for posten.;
                           ENU=Specifies the total discount amount on this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Discount Amount" }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af enheder for posten.;
                           ENU=Specifies the number of units in this entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Quantity }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal enheder i posten, som skal faktureres.;
                           ENU=Specifies the number of units in this entry that should be invoiced.];
                ApplicationArea=#Service;
                SourceExpr="Charged Qty." }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Price" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rabatprocenten for posten.;
                           ENU=Specifies the discount percentage of this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Discount %" }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede kontraktrabatbel›b for posten.;
                           ENU=Specifies the total contract discount amount of this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Contract Disc. Amount";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten i regnskabsvalutaen.;
                           ENU=Specifies the amount of the entry in LCY.];
                ApplicationArea=#Advanced;
                SourceExpr="Amount (LCY)" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at denne post ikke er en forudbetalt post fra en servicekontrakt.;
                           ENU=Specifies that this entry is not a prepaid entry from a service contract.];
                ApplicationArea=#Advanced;
                SourceExpr="Moved from Prepaid Acc." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den servicekontraktkontogruppe, som servicekontrakten er tilknyttet, hvis posten er omfattet af en servicekontrakt.;
                           ENU=Specifies the service contract account group code the service contract is associated with, if this entry is included in a service contract.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Contract Acc. Gr. Code" }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fejl†rsagskoden for posten.;
                           ENU=Specifies the fault reason code for this entry.];
                ApplicationArea=#Service;
                SourceExpr="Fault Reason Code" }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af ressourcen, varen, omkostningen, standardteksten, finanskontoen eller servicekontrakten for denne post.;
                           ENU=Specifies a description of the resource, item, cost, standard text, general ledger account, or service contract associated with this entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Bus. Posting Group" }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Prod. Posting Group" }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som er knyttet til posten.;
                           ENU=Specifies the code for the location associated with this entry.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om servicekontrakten eller den kontraktrelaterede serviceordre er forudbetalt.;
                           ENU=Specifies whether the service contract or contract-related service order was prepaid.];
                ApplicationArea=#Advanced;
                SourceExpr=Prepaid;
                Visible=FALSE }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontraktrelaterede serviceposter.;
                           ENU=Specifies contract-related service ledger entries.];
                ApplicationArea=#Advanced;
                SourceExpr=Open }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID" }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet p† posten.;
                           ENU=Specifies the amount on this entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Amount }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv‘rdier. De faktiske v‘rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Dimensions;
                SourceExpr="Dimension Set ID";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      DimensionSetIDFilter@1000 : Page 481;

    BEGIN
    END.
  }
}

