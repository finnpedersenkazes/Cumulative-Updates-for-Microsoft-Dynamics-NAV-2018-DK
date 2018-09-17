OBJECT Page 1750 Field Data Classification
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Field Data Classification;
               ENU=Field Data Classification];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table2000000041;
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
                SourceExpr=TableNo }

    { 4   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="No." }

    { 5   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=TableName }

    { 6   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=FieldName }

    { 7   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=Class }

    { 9   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Type Name" }

    { 10  ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=RelationTableNo }

    { 11  ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=OptionString }

    { 12  ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=DataClassification }

  }
  CODE
  {

    BEGIN
    END.
  }
}

