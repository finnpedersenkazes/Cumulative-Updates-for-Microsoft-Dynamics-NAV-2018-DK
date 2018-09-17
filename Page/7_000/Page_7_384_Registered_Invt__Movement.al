OBJECT Page 7384 Registered Invt. Movement
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
    CaptionML=[DAN=Registreret flytning (lager);
               ENU=Registered Invt. Movement];
    SaveValues=Yes;
    SourceTable=Table7344;
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
                      CaptionML=[DAN=&Bev‘gelse;
                                 ENU=&Movement];
                      Image=CreateMovement }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Registered Invt. Movement),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
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
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Registreret lageraktivitetshoved.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                OptionCaptionML=[DAN=" ,,,,,,,,,,,Prod. Forbrug,,,,,,,,,Montageforbrug";
                                 ENU=" ,,,,,,,,,,,Prod. Consumption,,,,,,,,,Assembly Consumption"];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Registreret lageraktivitetshoved.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",0));
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† destinationen for den registrerede lagerflytning.;
                           ENU=Specifies the name of the destination for the registered inventory movement.];
                ApplicationArea=#Warehouse;
                SourceExpr=WMSMgt.GetDestinationName("Destination Type","Destination No.");
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",1));
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Registreret lageraktivitetshoved.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.];
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
                PagePartID=Page7385;
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

