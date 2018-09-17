OBJECT Page 1753 Field Content Buffer
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Feltindhold;
               ENU=Field Contents];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table1754;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=Value }

  }
  CODE
  {

    BEGIN
    END.
  }
}

