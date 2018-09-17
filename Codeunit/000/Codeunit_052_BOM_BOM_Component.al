OBJECT Codeunit 52 BOM-BOM Component
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    [EventSubscriber(Table,90,OnAfterInsertEvent)]
    LOCAL PROCEDURE UpdateParentItemReplenishmentSystemOnAfterInsertBOMComponent@2(VAR Rec@1000 : Record 90;RunTrigger@1001 : Boolean);
    BEGIN
      TryUpdateParentItemReplenishmentSystem(Rec);
    END;

    [EventSubscriber(Table,90,OnAfterDeleteEvent)]
    LOCAL PROCEDURE UpdateParentItemReplenishmentSystemOnAfterDeleteBOMComponent@3(VAR Rec@1000 : Record 90;RunTrigger@1001 : Boolean);
    BEGIN
      IF RunTrigger THEN
        TryUpdateParentItemReplenishmentSystem(Rec);
    END;

    [EventSubscriber(Table,90,OnAfterRenameEvent)]
    LOCAL PROCEDURE UpdateParentItemReplenishmentSystemOnAfterRenameBOMComponent@7(VAR Rec@1000 : Record 90;VAR xRec@1001 : Record 90;RunTrigger@1002 : Boolean);
    BEGIN
      IF Rec."Parent Item No." <> xRec."Parent Item No." THEN BEGIN
        TryUpdateParentItemReplenishmentSystem(Rec);
        TryUpdateParentItemReplenishmentSystem(xRec);
      END
    END;

    LOCAL PROCEDURE TryUpdateParentItemReplenishmentSystem@5(VAR BOMComponent@1000 : Record 90);
    VAR
      Item@1001 : Record 27;
    BEGIN
      IF Item.GET(BOMComponent."Parent Item No.") THEN
        IF Item.UpdateReplenishmentSystem THEN
          Item.MODIFY(TRUE);
    END;

    BEGIN
    END.
  }
}

