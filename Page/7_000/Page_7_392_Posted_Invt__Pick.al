OBJECT Page 7392 Posted Invt. Pick
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
    CaptionML=[DAN=Bogf›rt pluk (lager);
               ENU=Posted Invt. Pick];
    SaveValues=Yes;
    SourceTable=Table7342;
    PageType=Document;
    RefreshOnActivate=Yes;
    OnDeleteRecord=BEGIN
                     CurrPage.UPDATE;
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 100     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Pluk;
                                 ENU=P&ick];
                      Image=CreateInventoryPickup }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Posted Invt. Pick),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor det bogf›rte lagerpluk forekom.;
                           ENU=Specifies the location code for where the posted inventory pick occurred.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret eller koden for den debitor, kreditor, lokation, vare, familie eller salgsordre, som er knyttet til det bogf›rte lagerpluk.;
                           ENU=Specifies the number or the code of the customer, vendor, location, item, family, or sales order linked to the posted inventory pick.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",0));
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† det bogf›rte lagerpluk.;
                           ENU=Specifies the name of the inventory pick that has been posted.];
                ApplicationArea=#Warehouse;
                SourceExpr=WMSMgt.GetDestinationName("Destination Type","Destination No.");
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",1));
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen fra lagerplukket.;
                           ENU=Specifies the posting date from the inventory pick.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Date" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No.";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",2)) }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af det bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies an additional part of the document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No.2";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",3)) }

    { 97  ;1   ;Part      ;
                Name=WhseActivityLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(No.,Sorting Sequence No.);
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page7393;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      WMSMgt@1001 : Codeunit 7302;

    BEGIN
    END.
  }
}

