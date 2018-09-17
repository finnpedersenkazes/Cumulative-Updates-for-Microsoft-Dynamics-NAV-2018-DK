OBJECT Page 6083 Serv. Price Adjmt. Detail
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Serviceprisregul. - detaljer;
               ENU=Serv. Price Adjmt. Detail];
    SourceTable=Table6083;
    DataCaptionExpr=FormCaption;
    PageType=List;
    OnInit=BEGIN
             ServPriceAdjmtGrCodeVisible := TRUE;
           END;

    OnOpenPage=VAR
                 ServPriceAdjmtGroup@1001 : Record 6082;
                 ShowColumn@1000 : Boolean;
               BEGIN
                 ShowColumn := TRUE;
                 IF GETFILTER("Serv. Price Adjmt. Gr. Code") <> '' THEN
                   IF ServPriceAdjmtGroup.GET("Serv. Price Adjmt. Gr. Code") THEN
                     ShowColumn := FALSE
                   ELSE
                     RESET;
                 ServPriceAdjmtGrCodeVisible := ShowColumn;
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den prisreguleringsgruppe, der er knyttet til den bogf�rte servicelinje.;
                           ENU=Specifies the code of the service price adjustment group that applies to the posted service line.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Price Adjmt. Gr. Code";
                Visible=ServPriceAdjmtGrCodeVisible }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for den serviceartikellinje, der skal reguleres.;
                           ENU=Specifies the type for the service item line to be adjusted.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdstypen for ressourcen.;
                           ENU=Specifies the work type of the resource.];
                ApplicationArea=#Service;
                SourceExpr="Work Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Service;
                SourceExpr="Gen. Prod. Posting Group" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den serviceartikel, ressource, ressourcegruppe eller serviceomkostning, som prisen vil blive reguleret for, ud fra den v�rdi der er valgt i feltet Type.;
                           ENU=Specifies the service item, resource, resource group, or service cost, of which the price will be adjusted, based on the value selected in the Type field.];
                ApplicationArea=#Service;
                SourceExpr=Description }

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
      ServPriceAdjmtGrCodeVisible@19029165 : Boolean INDATASET;

    LOCAL PROCEDURE FormCaption@1() : Text[180];
    VAR
      ServPriceAdjmtGrp@1000 : Record 6082;
    BEGIN
      IF GETFILTER("Serv. Price Adjmt. Gr. Code") <> '' THEN
        IF ServPriceAdjmtGrp.GET("Serv. Price Adjmt. Gr. Code") THEN
          EXIT(STRSUBSTNO('%1 %2',"Serv. Price Adjmt. Gr. Code",ServPriceAdjmtGrp.Description));
    END;

    BEGIN
    END.
  }
}

