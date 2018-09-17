OBJECT Codeunit 5708 Release Transfer Document
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    TableNo=5740;
    OnRun=VAR
            TransLine@1000 : Record 5741;
          BEGIN
            IF Status = Status::Released THEN
              EXIT;

            OnBeforeReleaseTransferDoc(Rec);
            TESTFIELD("Transfer-from Code");
            TESTFIELD("Transfer-to Code");
            IF "Transfer-from Code" = "Transfer-to Code" THEN
              ERROR(Text001,"No.",FIELDCAPTION("Transfer-from Code"),FIELDCAPTION("Transfer-to Code"));
            IF NOT "Direct Transfer" THEN
              TESTFIELD("In-Transit Code")
            ELSE BEGIN
              VerifyNoOutboundWhseHandlingOnLocation("Transfer-from Code");
              VerifyNoInboundWhseHandlingOnLocation("Transfer-to Code");
            END;

            TESTFIELD(Status,Status::Open);

            TransLine.SETRANGE("Document No.","No.");
            TransLine.SETFILTER(Quantity,'<>0');
            IF TransLine.ISEMPTY THEN
              ERROR(Text002,"No.");

            VALIDATE(Status,Status::Released);
            MODIFY;

            WhseTransferRelease.SetCallFromTransferOrder(TRUE);
            WhseTransferRelease.Release(Rec);

            OnAfterReleaseTransferDoc(Rec);
          END;

  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Overflytningsordren %1 kan ikke frigives, fordi %2 og %3 er identiske.;ENU=The transfer order %1 cannot be released because %2 and %3 are the same.';
      Text002@1002 : TextConst 'DAN=Der er ikke noget at frigive for overflytningsordre %1.;ENU=There is nothing to release for transfer order %1.';
      WhseTransferRelease@1005 : Codeunit 5773;

    [External]
    PROCEDURE Reopen@1(VAR TransHeader@1000 : Record 5740);
    BEGIN
      WITH TransHeader DO BEGIN
        IF Status = Status::Open THEN
          EXIT;
        WhseTransferRelease.Reopen(TransHeader);
        VALIDATE(Status,Status::Open);
        MODIFY;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeReleaseTransferDoc@2(VAR TransferHeader@1000 : Record 5740);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterReleaseTransferDoc@3(VAR TransferHeader@1000 : Record 5740);
    BEGIN
    END;

    BEGIN
    END.
  }
}

