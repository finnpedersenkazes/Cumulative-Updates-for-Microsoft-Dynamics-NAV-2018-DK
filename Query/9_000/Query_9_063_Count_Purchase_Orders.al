OBJECT Query 9063 Count Purchase Orders
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Antal k›bsordrer;
               ENU=Count Purchase Orders];
  }
  ELEMENTS
  {
    { 1   ;    ;DataItem;                    ;
               DataItemTable=Table38;
               DataItemTableFilter=Document Type=CONST(Order) }

    { 2   ;1   ;Filter  ;                    ;
               DataSource=Completely Received }

    { 3   ;1   ;Filter  ;                    ;
               DataSource=Responsibility Center }

    { 4   ;1   ;Filter  ;                    ;
               DataSource=Status }

    { 5   ;1   ;Filter  ;                    ;
               DataSource=Partially Invoiced }

    { 6   ;1   ;Column  ;Count_Orders        ;
               MethodType=Totals;
               Method=Count }

  }
  CODE
  {

    BEGIN
    END.
  }
}

