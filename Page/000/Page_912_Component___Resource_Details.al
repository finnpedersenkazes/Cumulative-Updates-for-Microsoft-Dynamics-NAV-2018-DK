OBJECT Page 912 Component - Resource Details
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Komponent - ressourcedetaljer;
               ENU=Component - Resource Details];
    SourceTable=Table156;
    PageType=CardPart;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Field     ;
                CaptionML=[DAN=Ressourcenr.;
                           ENU=Resource No.];
                ToolTipML=[DAN=Angiver et nummer til ressourcen.;
                           ENU=Specifies a number for the resource.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 3   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, om ressourcen er en person eller en maskine.;
                           ENU=Specifies whether the resource is a person or a machine.];
                ApplicationArea=#Assembly;
                SourceExpr=Type }

    { 4   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver personens stilling.;
                           ENU=Specifies the person's job title.];
                ApplicationArea=#Assembly;
                SourceExpr="Job Title" }

    { 5   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den basisenhed, der bruges til at m†le ressourcen, som f.eks. time, stk. eller kilometer Basism†leenheden fungerer ogs† som konverteringsbasis for alternative m†leenheder.;
                           ENU=Specifies the base unit used to measure the resource, such as hour, piece, or kilometer. The base unit of measure also serves as the conversion basis for alternate units of measure.];
                ApplicationArea=#Assembly;
                SourceExpr="Base Unit of Measure" }

    { 6   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

