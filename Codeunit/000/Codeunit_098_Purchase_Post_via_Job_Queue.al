OBJECT Codeunit 98 Purchase Post via Job Queue
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    TableNo=472;
    OnRun=VAR
            PurchHeader@1000 : Record 38;
            PurchPostPrint@1002 : Codeunit 92;
            RecRef@1001 : RecordRef;
          BEGIN
            TESTFIELD("Record ID to Process");
            RecRef.GET("Record ID to Process");
            RecRef.SETTABLE(PurchHeader);
            PurchHeader.FIND;
            SetJobQueueStatus(PurchHeader,PurchHeader."Job Queue Status"::Posting);
            IF NOT CODEUNIT.RUN(CODEUNIT::"Purch.-Post",PurchHeader) THEN BEGIN
              SetJobQueueStatus(PurchHeader,PurchHeader."Job Queue Status"::Error);
              ERROR(GETLASTERRORTEXT);
            END;
            IF PurchHeader."Print Posted Documents" THEN
              PurchPostPrint.GetReport(PurchHeader);
            SetJobQueueStatus(PurchHeader,PurchHeader."Job Queue Status"::" ");
          END;

  }
  CODE
  {
    VAR
      PostDescription@1000 : TextConst '@@@="%1 = document type, %2 = document number. Example: Post Purchase Order 1234.";DAN=Bogf�r k�b %1 %2.;ENU=Post Purchase %1 %2.';
      PostAndPrintDescription@1002 : TextConst '@@@="%1 = document type, %2 = document number. Example: Post Purchase Order 1234.";DAN=Bogf�r og udskriv k�b %1 %2.;ENU=Post and Print Purchase %1 %2.';
      Confirmation@1001 : TextConst '@@@="%1=document type, %2=number, e.g. Order 123  or Invoice 234.";DAN=%1 %2 er blevet planlagt til bogf�ring.;ENU=%1 %2 has been scheduled for posting.';
      WrongJobQueueStatus@1003 : TextConst '@@@="%1 = document type, %2 = document number. Example: Purchase Order 1234 or Invoice 1234.";DAN=%1 %2 kan ikke bogf�res, da den allerede er planlagt til bogf�ring. V�lg handlingen Fjern fra opgavek� for at nulstille statussen for opgavek�en, og bogf�r derefter igen.;ENU=%1 %2 cannot be posted because it has already been scheduled for posting. Choose the Remove from Job Queue action to reset the job queue status and then post again.';

    LOCAL PROCEDURE SetJobQueueStatus@5(VAR PurchHeader@1001 : Record 38;NewStatus@1000 : Option);
    BEGIN
      PurchHeader.LOCKTABLE;
      IF PurchHeader.FIND THEN BEGIN
        PurchHeader."Job Queue Status" := NewStatus;
        PurchHeader.MODIFY;
        COMMIT;
      END;
    END;

    [External]
    PROCEDURE EnqueuePurchDoc@1(VAR PurchHeader@1000 : Record 38);
    BEGIN
      EnqueuePurchDocWithUI(PurchHeader,TRUE);
    END;

    [External]
    PROCEDURE EnqueuePurchDocWithUI@8(VAR PurchHeader@1000 : Record 38;WithUI@1002 : Boolean);
    VAR
      TempInvoice@1004 : Boolean;
      TempRcpt@1005 : Boolean;
      TempShip@1006 : Boolean;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF NOT ("Job Queue Status" IN ["Job Queue Status"::" ","Job Queue Status"::Error]) THEN
          ERROR(WrongJobQueueStatus,"Document Type","No.");
        TempInvoice := Invoice;
        TempRcpt := Receive;
        TempShip := Ship;
        IF Status = Status::Open THEN
          CODEUNIT.RUN(CODEUNIT::"Release Purchase Document",PurchHeader);
        Invoice := TempInvoice;
        Receive := TempRcpt;
        Ship := TempShip;
        "Job Queue Status" := "Job Queue Status"::"Scheduled for Posting";
        "Job Queue Entry ID" := EnqueueJobEntry(PurchHeader);
        MODIFY;

        IF GUIALLOWED THEN
          IF WithUI THEN
            MESSAGE(Confirmation,"Document Type","No.");
      END;
    END;

    LOCAL PROCEDURE EnqueueJobEntry@3(PurchHeader@1000 : Record 38) : GUID;
    VAR
      JobQueueEntry@1001 : Record 472;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        CLEAR(ID);
        "Object Type to Run" := "Object Type to Run"::Codeunit;
        "Object ID to Run" := CODEUNIT::"Purchase Post via Job Queue";
        "Record ID to Process" := PurchHeader.RECORDID;
        FillJobEntryFromPurchSetup(JobQueueEntry,PurchHeader."Print Posted Documents");
        FillJobEntryPurchDescription(JobQueueEntry,PurchHeader);
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry);
        EXIT(ID);
      END;
    END;

    LOCAL PROCEDURE FillJobEntryFromPurchSetup@4(VAR JobQueueEntry@1001 : Record 472;PostAndPrint@1000 : Boolean);
    VAR
      PurchSetup@1002 : Record 312;
    BEGIN
      PurchSetup.GET;
      WITH JobQueueEntry DO BEGIN
        "Notify On Success" := PurchSetup."Notify On Success";
        "Job Queue Category Code" := PurchSetup."Job Queue Category Code";
        IF PostAndPrint THEN
          Priority := PurchSetup."Job Q. Prio. for Post & Print"
        ELSE
          Priority := PurchSetup."Job Queue Priority for Post";
      END;
    END;

    LOCAL PROCEDURE FillJobEntryPurchDescription@6(VAR JobQueueEntry@1001 : Record 472;PurchHeader@1000 : Record 38);
    BEGIN
      WITH JobQueueEntry DO BEGIN
        IF PurchHeader."Print Posted Documents" THEN
          Description := PostAndPrintDescription
        ELSE
          Description := PostDescription;
        Description :=
          COPYSTR(STRSUBSTNO(Description,PurchHeader."Document Type",PurchHeader."No."),1,MAXSTRLEN(Description));
      END;
    END;

    [External]
    PROCEDURE CancelQueueEntry@2(VAR PurchHeader@1000 : Record 38);
    BEGIN
      WITH PurchHeader DO
        IF "Job Queue Status" <> "Job Queue Status"::" " THEN BEGIN
          DeleteJobs(PurchHeader);
          "Job Queue Status" := "Job Queue Status"::" ";
          MODIFY;
        END;
    END;

    LOCAL PROCEDURE DeleteJobs@9(PurchHeader@1001 : Record 38);
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF NOT ISNULLGUID("Job Queue Entry ID") THEN
          JobQueueEntry.SETRANGE(ID,"Job Queue Entry ID");
        JobQueueEntry.SETRANGE("Record ID to Process",RECORDID);
        IF NOT JobQueueEntry.ISEMPTY THEN
          JobQueueEntry.DELETEALL(TRUE);
      END;
    END;

    BEGIN
    END.
  }
}

