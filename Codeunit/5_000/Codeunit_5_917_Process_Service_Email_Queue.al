OBJECT Codeunit 5917 Process Service Email Queue
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=472;
    OnRun=VAR
            ServEmailQueue@1003 : Record 5935;
            ServEmailQueue2@1002 : Record 5935;
            ServMailMgt@1001 : Codeunit 5916;
            RecRef@1000 : RecordRef;
            Success@1004 : Boolean;
          BEGIN
            IF RecRef.GET("Record ID to Process") THEN BEGIN
              RecRef.SETTABLE(ServEmailQueue);
              IF NOT ServEmailQueue.FIND THEN
                EXIT;
              ServEmailQueue.SETRECFILTER;
            END ELSE BEGIN
              ServEmailQueue.RESET;
              ServEmailQueue.SETCURRENTKEY(Status,"Sending Date","Document Type","Document No.");
              ServEmailQueue.SETRANGE(Status,ServEmailQueue.Status::" ");
            END;
            ServEmailQueue.LOCKTABLE;
            IF ServEmailQueue.FINDSET THEN
              REPEAT
                COMMIT;
                CLEAR(ServMailMgt);
                Success := ServMailMgt.RUN(ServEmailQueue);
                ServEmailQueue2.GET(ServEmailQueue."Entry No.");
                IF Success THEN
                  ServEmailQueue2.Status := ServEmailQueue2.Status::Processed
                ELSE
                  ServEmailQueue2.Status := ServEmailQueue2.Status::Error;
                ServEmailQueue2.MODIFY;
                SLEEP(200);
              UNTIL ServEmailQueue.NEXT = 0;
          END;

  }
  CODE
  {

    BEGIN
    END.
  }
}

