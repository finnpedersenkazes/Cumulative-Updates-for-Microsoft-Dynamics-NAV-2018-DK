OBJECT Page 5950 Posted Shpt. Item Line List
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
    CaptionML=[DAN=Bogf. servicelev.linjeoversigt;
               ENU=Posted Service Shpt. Item Line List];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table5989;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† linjen.;
                           ENU=Specifies the number of this line.];
                ApplicationArea=#Service;
                SourceExpr="Line No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† serviceartiklen, som er registreret i tabellen Serviceartikel og knyttet til debitoren.;
                           ENU=Specifies the number of the service item registered in the Service Item table and associated with the customer.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, som denne bogf›rte serviceartikel vedr›rer.;
                           ENU=Specifies the number of the item to which this posted service item is related.];
                ApplicationArea=#Service;
                SourceExpr="Item No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p† serviceartiklen.;
                           ENU=Specifies the serial number of this service item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor reservedelsgarantien udl›ber for serviceartiklen.;
                           ENU=Specifies the date when the spare parts warranty expires for this service item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Ending Date (Parts)" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den udl†nsvare, der er l†nt ud til debitoren som erstatning for serviceartiklen.;
                           ENU=Specifies the number of the loaner that has been lent to the customer to replace this service item.];
                ApplicationArea=#Service;
                SourceExpr="Loaner No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der er garanti p† reservedele eller arbejde for servicerartiklen.;
                           ENU=Specifies that there is a warranty on either parts or labor for this service item.];
                ApplicationArea=#Service;
                SourceExpr=Warranty }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor arbejdsgarantien udl›ber for den bogf›rte serviceartikel.;
                           ENU=Specifies the date when the labor warranty expires on the posted service item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Ending Date (Labor)" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor garantien tr‘der i kraft for reservedele til serviceartiklen.;
                           ENU=Specifies the date when the warranty starts on the service item spare parts.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Starting Date (Parts)" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor arbejdsgarantien for den bogf›rte serviceartikel tr‘der i kraft.;
                           ENU=Specifies the date when the labor warranty for the posted service item starts.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Starting Date (Labor)" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontrakt, som er knyttet til den bogf›rte serviceartikel.;
                           ENU=Specifies the number of the contract associated with the posted service item.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

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

    BEGIN
    END.
  }
}

