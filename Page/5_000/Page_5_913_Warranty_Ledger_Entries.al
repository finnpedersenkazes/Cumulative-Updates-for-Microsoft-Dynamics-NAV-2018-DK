OBJECT Page 5913 Warranty Ledger Entries
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
    CaptionML=[DAN=Garantiposter;
               ENU=Warranty Ledger Entries];
    SourceTable=Table5908;
    DataCaptionFields=Service Order No.,Service Item No. (Serviced),Service Contract No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=&Entry];
                      Image=Entry }
      { 3       ;2   ;Action    ;
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
      { 6       ;2   ;Action    ;
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 95      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Service;
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

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Service;
                SourceExpr="Entry No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for posten.;
                           ENU=Specifies the document number of this entry.];
                ApplicationArea=#Service;
                SourceExpr="Document No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen p† den servicelinje, der er knyttet til posten.;
                           ENU=Specifies the posting date on the service line linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitoren p† den serviceordre, der er knyttet til posten.;
                           ENU=Specifies the number of the customer on the service order linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den reparerede serviceartikel, som er knyttet til posten.;
                           ENU=Specifies the number of the serviced item linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Item No. (Serviced)" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p† den reparerede serviceartikel, som er knyttet til posten.;
                           ENU=Specifies the serial number of the serviced item linked to this entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No. (Serviced)" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver gruppekoden for den reparerede serviceartikel, der er knyttet til posten.;
                           ENU=Specifies the service item group code of the serviced item linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Group (Serviced)" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceordre, som er knyttet til posten.;
                           ENU=Specifies the number of the service order linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Service Order No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den servicekontrakt, som er knyttet til posten.;
                           ENU=Specifies the number of the service contract linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Service Contract No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fejl†rsagskoden for den servicelinje, der er knyttet til posten.;
                           ENU=Specifies the fault reason code of the service line linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Fault Reason Code" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fejlkoden for den servicelinje, der er knyttet til posten.;
                           ENU=Specifies the fault code of the service line linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Fault Code" }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver symptomkoden for den servicelinje, der er knyttet til posten.;
                           ENU=Specifies the symptom code of the service line linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Symptom Code" }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l›sningskoden for den servicelinje, der er knyttet til posten.;
                           ENU=Specifies the resolution code of the service line linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Resolution Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for den servicelinje, der er knyttet til posten.;
                           ENU=Specifies the type of the service line linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer eller omkostninger for den servicelinje, der er knyttet til posten.;
                           ENU=Specifies the number of item units, resource hours, or cost of the service line linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr=Quantity }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdstypekoden for den servicelinje, der er knyttet til posten.;
                           ENU=Specifies the work type code of the service line linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Work Type Code" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver garantirabatbel›bet for den servicelinje, der er knyttet til posten.;
                           ENU=Specifies the warranty discount amount of the service line linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr=Amount }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen p† linjen.;
                           ENU=Specifies the description of the item on this line.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at garantipost er †ben.;
                           ENU=Specifies that the warranty ledger entry is open.];
                ApplicationArea=#Service;
                SourceExpr=Open }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditornummeret p† den reparerede serviceartikel, som er knyttet til posten.;
                           ENU=Specifies the vendor number of the serviced item linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Vendor No." }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Service;
                SourceExpr="Vendor Item No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv‘rdier. De faktiske v‘rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Dimensions;
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

    BEGIN
    END.
  }
}

