OBJECT Codeunit 88 Sales Post via Job Queue
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
            SalesHeader@1000 : Record 36;
            SalesPostPrint@1002 : Codeunit 82;
            RecRef@1001 : RecordRef;
          BEGIN
            TESTFIELD("Record ID to Process");
            RecRef.GET("Record ID to Process");
            RecRef.SETTABLE(SalesHeader);
            SalesHeader.FIND;

            SetJobQueueStatus(SalesHeader,SalesHeader."Job Queue Status"::Posting);
            IF NOT CODEUNIT.RUN(CODEUNIT::"Sales-Post",SalesHeader) THEN BEGIN
              SetJobQueueStatus(SalesHeader,SalesHeader."Job Queue Status"::Error);
              ERROR(GETLASTERRORTEXT);
            END;
            IF SalesHeader."Print Posted Documents" THEN
              SalesPostPrint.GetReport(SalesHeader);

            SetJobQueueStatus(SalesHeader,SalesHeader."Job Queue Status"::" ");
          END;

  }
  CODE
  {
    VAR
      PostDescription@1000 : TextConst '@@@="%1 = document type, %2 = document number. Example: Post Sales Order 1234.";DAN=Bogf›r salg %1 %2.;ENU=Post Sales %1 %2.';
      PostAndPrintDescription@1002 : TextConst '@@@="%1 = document type, %2 = document number. Example: Post Sales Order 1234.";DAN=Bogf›r og udskriv salg %1 %2.;ENU=Post and Print Sales %1 %2.';
      Confirmation@1001 : TextConst '@@@="%1=document type, %2=number, e.g. Order 123  or Invoice 234.";DAN=%1 %2 er blevet planlagt til bogf›ring.;ENU=%1 %2 has been scheduled for posting.';
      WrongJobQueueStatus@1003 : TextConst '@@@="%1 = document type, %2 = document number. Example: Sales Order 1234 or Invoice 1234.";DAN=%1 %2 kan ikke bogf›res, da den allerede er planlagt til bogf›ring. V‘lg handlingen Fjern fra opgavek› for at nulstille statussen for opgavek›en, og bogf›r derefter igen.;ENU=%1 %2 cannot be posted because it has already been scheduled for posting. Choose the Remove from Job Queue action to reset the job queue status and then post again.';

    LOCAL PROCEDURE SetJobQueueStatus@5(VAR SalesHeader@1001 : Record 36;NewStatus@1000 : Option);
    BEGIN
      SalesHeader.LOCKTABLE;
      IF SalesHeader.FIND THEN BEGIN
        SalesHeader."Job Queue Status" := NewStatus;
        SalesHeader.MODIFY;
        COMMIT;
      END;
    END;

    [External]
    PROCEDURE EnqueueSalesDoc@1(VAR SalesHeader@1000 : Record 36);
    BEGIN
      EnqueueSalesDocWithUI(SalesHeader,TRUE);
    END;

    [External]
    PROCEDURE EnqueueSalesDocWithUI@9(VAR SalesHeader@1000 : Record 36;WithUI@1002 : Boolean);
    VAR
      TempInvoice@1006 : Boolean;
      TempRcpt@1005 : Boolean;
      TempShip@1004 : Boolean;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF NOT ("Job Queue Status" IN ["Job Queue Status"::" ","Job Queue Status"::Error]) THEN
          ERROR(WrongJobQueueStatus,"Document Type","No.");
        TempInvoice := Invoice;
        TempRcpt := Receive;
        TempShip := Ship;
        IF Status = Status::Open THEN
          CODEUNIT.RUN(CODEUNIT::"Release Sales Document",SalesHeader);
        Invoice := TempInvoice;
        Receive := TempRcpt;
        Ship := TempShip;
        "Job Queue Status" := "Job Queue Status"::"Scheduled for Posting";
        "Job Queue Entry ID" := EnqueueJobEntry(SalesHeader);
        MODIFY;

        IF GUIALLOWED THEN
          IF WithUI THEN
            MESSAGE(Confirmation,"Document Type","No.");
      END;
    END;

    LOCAL PROCEDURE EnqueueJobEntry@3(SalesHeader@1000 : Record 36) : GUID;
    VAR
      JobQueueEntry@1001 : Record 472;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        CLEAR(ID);
        "Object Type to Run" := "Object Type to Run"::Codeunit;
        "Object ID to Run" := CODEUNIT::"Sales Post via Job Queue";
        "Record ID to Process" := SalesHeader.RECORDID;
        FillJobEntryFromSalesSetup(JobQueueEntry,SalesHeader."Print Posted Documents");
        FillJobEntrySalesDescription(JobQueueEntry,SalesHeader);
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry);
        EXIT(ID)
      END;
    END;

    LOCAL PROCEDURE FillJobEntryFromSalesSetup@4(VAR JobQueueEntry@1001 : Record 472;PostAndPrint@1000 : Boolean);
    VAR
      SalesSetup@1002 : Record 311;
    BEGIN
      SalesSetup.GET;
      WITH JobQueueEntry DO BEGIN
        "Notify On Success" := SalesSetup."Notify On Success";
        "Job Queue Category Code" := SalesSetup."Job Queue Category Code";
        IF PostAndPrint THEN
          Priority := SalesSetup."Job Q. Prio. for Post & Print"
        ELSE
          Priority := SalesSetup."Job Queue Priority for Post";
      END;
    END;

    LOCAL PROCEDURE FillJobEntrySalesDescription@6(VAR JobQueueEntry@1000 : Record 472;SalesHeader@1001 : Record 36);
    BEGIN
      WITH JobQueueEntry DO BEGIN
        IF SalesHeader."Print Posted Documents" THEN
          Description := PostAndPrintDescription
        ELSE
          Description := PostDescription;
        Description :=
          COPYSTR(STRSUBSTNO(Description,SalesHeader."Document Type",SalesHeader."No."),1,MAXSTRLEN(Description));
      END;
    END;

    [External]
    PROCEDURE CancelQueueEntry@2(VAR SalesHeader@1000 : Record 36);
    BEGIN
      WITH SalesHeader DO
        IF "Job Queue Status" <> "Job Queue Status"::" " THEN BEGIN
          DeleteJobs(SalesHeader);
          "Job Queue Status" := "Job Queue Status"::" ";
          MODIFY;
        END;
    END;

    LOCAL PROCEDURE DeleteJobs@8(SalesHeader@1000 : Record 36);
    VAR
      JobQueueEntry@1001 : Record 472;
    BEGIN
      WITH SalesHeader DO BEGIN
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

