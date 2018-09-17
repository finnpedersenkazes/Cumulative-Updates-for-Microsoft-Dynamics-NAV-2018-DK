OBJECT Page 2379 BC O365 Contact Lookup
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=V‘lg;
               ENU=Select];
    InsertAllowed=No;
    SourceTable=Table5050;
    SourceTableView=SORTING(Name);
    PageType=List;
    CardPageID=BC O365 Sales Customer Card;
    RefreshOnActivate=Yes;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="No.";
                Visible=FALSE;
                Enabled=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet.;
                           ENU=Specifies the name.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Type;
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Phone No." }

    { 5   ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="E-Mail" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

