OBJECT Page 6058 Contract/Service Discounts
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontrakt/servicerabatter;
               ENU=Contract/Service Discounts];
    SourceTable=Table5972;
    DelayedInsert=Yes;
    DataCaptionFields=Contract No.;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for kontrakt- eller servicerabatten.;
                           ENU=Specifies the type of the contract/service discount.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor rabatten er g‘ldende i kontrakten eller tilbuddet.;
                           ENU=Specifies the date when the discount becomes applicable to the contract or quote.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rabatprocenten.;
                           ENU=Specifies the discount percentage.];
                ApplicationArea=#Service;
                SourceExpr="Discount %" }

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

