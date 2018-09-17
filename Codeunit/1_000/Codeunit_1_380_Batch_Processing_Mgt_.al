OBJECT Codeunit 1380 Batch Processing Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    Permissions=TableData 52=rimd,
                TableData 53=rimd;
    OnRun=BEGIN
            RunCustomProcessing;
          END;

  }
  CODE
  {
    VAR
      PostingTemplateMsg@1007 : TextConst '@@@=1 - overall progress;DAN=Behandler: @1@@@@@@@;ENU=Processing: @1@@@@@@@';
      TempErrorMessage@1001 : TEMPORARY Record 700;
      RecRefCustomerProcessing@1005 : RecordRef;
      ProcessingCodeunitID@1008 : Integer;
      BatchID@1010 : GUID;
      ProcessingCodeunitNotSetErr@1000 : TextConst 'DAN=Der er ikke valgt en behandlings-codeunit.;ENU=A processing codeunit has not been selected.';
      BatchCompletedMsg@1002 : TextConst 'DAN=Alle bilagene er blevet bogf�rt.;ENU=All the documents were posted.';
      BatchCompletedWithErrorsMsg@1003 : TextConst 'DAN=�t eller flere af bilagene kunne ikke bogf�res.;ENU=One or more of the documents could not be posted.';
      IsCustomProcessingHandled@1004 : Boolean;

    PROCEDURE BatchProcess@2(VAR RecRef@1000 : RecordRef);
    VAR
      Window@1003 : Dialog;
      CounterTotal@1001 : Integer;
      CounterToPost@1002 : Integer;
      CounterPosted@1006 : Integer;
      BatchConfirm@1005 : ' ,Skip,Update';
    BEGIN
      IF ProcessingCodeunitID = 0 THEN
        ERROR(ProcessingCodeunitNotSetErr);

      WITH RecRef DO BEGIN
        IF ISEMPTY THEN
          EXIT;

        TempErrorMessage.DELETEALL;

        FillBatchProcessingMap(RecRef);
        COMMIT;

        FINDSET;

        IF GUIALLOWED THEN BEGIN
          Window.OPEN(PostingTemplateMsg);
          CounterTotal := COUNT;
        END;

        REPEAT
          IF GUIALLOWED THEN BEGIN
            CounterToPost += 1;
            Window.UPDATE(1,ROUND(CounterToPost / CounterTotal * 10000,1));
          END;

          IF CanProcessRecord(RecRef) THEN
            IF ProcessRecord(RecRef,BatchConfirm) THEN
              CounterPosted += 1;
        UNTIL NEXT = 0;

        ResetBatchID;

        IF GUIALLOWED THEN BEGIN
          Window.CLOSE;
          IF CounterPosted <> CounterTotal THEN
            MESSAGE(BatchCompletedWithErrorsMsg)
          ELSE
            MESSAGE(BatchCompletedMsg);
        END;
      END;
    END;

    LOCAL PROCEDURE CanProcessRecord@8(VAR RecRef@1000 : RecordRef) : Boolean;
    VAR
      Result@1001 : Boolean;
    BEGIN
      Result := TRUE;
      OnVerifyRecord(RecRef,Result);

      EXIT(Result);
    END;

    LOCAL PROCEDURE FillBatchProcessingMap@12(VAR RecRef@1000 : RecordRef);
    BEGIN
      WITH RecRef DO BEGIN
        FINDSET;
        REPEAT
          InsertBatchParameterMapEntry(RecRef);
        UNTIL NEXT = 0;
      END;
    END;

    PROCEDURE GetErrorMessages@10(VAR TempErrorMessageResult@1000 : TEMPORARY Record 700);
    BEGIN
      TempErrorMessageResult.COPY(TempErrorMessage,TRUE);
    END;

    LOCAL PROCEDURE InsertBatchParameterMapEntry@20(RecRef@1000 : RecordRef);
    VAR
      BatchProcessingParameterMap@1002 : Record 53;
    BEGIN
      IF ISNULLGUID(BatchID) THEN
        EXIT;

      BatchProcessingParameterMap.INIT;
      BatchProcessingParameterMap."Record ID" := RecRef.RECORDID;
      BatchProcessingParameterMap."Batch ID" := BatchID;
      BatchProcessingParameterMap.INSERT;
    END;

    LOCAL PROCEDURE InvokeProcessing@28(VAR RecRef@1001 : RecordRef) : Boolean;
    VAR
      BatchProcessingMgt@1000 : Codeunit 1380;
      RecVar@1007 : Variant;
      Result@1005 : Boolean;
    BEGIN
      CLEARLASTERROR;

      BatchProcessingMgt.SetRecRefForCustomProcessing(RecRef);
      Result := BatchProcessingMgt.RUN;
      BatchProcessingMgt.GetRecRefForCustomProcessing(RecRef);

      RecVar := RecRef;

      IF (GETLASTERRORCALLSTACK = '') AND Result AND NOT BatchProcessingMgt.GetIsCustomProcessingHandled THEN
        Result := CODEUNIT.RUN(ProcessingCodeunitID,RecVar);

      LogError(RecVar,Result);

      RecRef.GETTABLE(RecVar);

      EXIT(Result);
    END;

    LOCAL PROCEDURE RunCustomProcessing@7();
    VAR
      Handled@1000 : Boolean;
    BEGIN
      OnCustomProcessing(RecRefCustomerProcessing,Handled);
      IsCustomProcessingHandled := Handled;
    END;

    LOCAL PROCEDURE InitBatchID@4();
    BEGIN
      IF ISNULLGUID(BatchID) THEN
        BatchID := CREATEGUID;
    END;

    LOCAL PROCEDURE LogError@1(RecVar@1000 : Variant;RunResult@1001 : Boolean);
    BEGIN
      IF NOT RunResult THEN
        TempErrorMessage.LogMessage(RecVar,0,TempErrorMessage."Message Type"::Error,GETLASTERRORTEXT);
    END;

    LOCAL PROCEDURE ProcessRecord@6(VAR RecRef@1000 : RecordRef;VAR BatchConfirm@1001 : Option) : Boolean;
    VAR
      ProcessingResult@1002 : Boolean;
    BEGIN
      OnBeforeBatchProcessing(RecRef,BatchConfirm);

      ProcessingResult := InvokeProcessing(RecRef);

      OnAfterBatchProcessing(RecRef,ProcessingResult);

      EXIT(ProcessingResult);
    END;

    PROCEDURE ResetBatchID@30();
    VAR
      BatchProcessingParameter@1000 : Record 52;
      BatchProcessingParameterMap@1001 : Record 53;
    BEGIN
      BatchProcessingParameter.SETRANGE("Batch ID",BatchID);
      BatchProcessingParameter.DELETEALL;

      BatchProcessingParameterMap.SETRANGE("Batch ID",BatchID);
      BatchProcessingParameterMap.DELETEALL;

      CLEAR(BatchID);

      COMMIT;
    END;

    PROCEDURE AddParameter@38(ParameterId@1000 : Integer;Value@1003 : Variant);
    VAR
      BatchProcessingParameter@1002 : Record 52;
    BEGIN
      InitBatchID;

      BatchProcessingParameter.INIT;
      BatchProcessingParameter."Batch ID" := BatchID;
      BatchProcessingParameter."Parameter Id" := ParameterId;
      BatchProcessingParameter."Parameter Value" := FORMAT(Value);
      BatchProcessingParameter.INSERT;
    END;

    PROCEDURE GetParameterText@34(RecordID@1000 : RecordID;ParameterId@1001 : Integer;VAR ParameterValue@1003 : Text[250]) : Boolean;
    VAR
      BatchProcessingParameter@1002 : Record 52;
      BatchProcessingParameterMap@1004 : Record 53;
    BEGIN
      BatchProcessingParameterMap.SETRANGE("Record ID",RecordID);
      IF NOT BatchProcessingParameterMap.FINDFIRST THEN
        EXIT(FALSE);

      IF NOT BatchProcessingParameter.GET(BatchProcessingParameterMap."Batch ID",ParameterId) THEN
        EXIT(FALSE);

      ParameterValue := BatchProcessingParameter."Parameter Value";
      EXIT(TRUE);
    END;

    PROCEDURE GetParameterBoolean@44(RecordID@1000 : RecordID;ParameterId@1001 : Integer;VAR ParameterValue@1003 : Boolean) : Boolean;
    VAR
      Result@1005 : Boolean;
      Value@1002 : Text[250];
    BEGIN
      IF NOT GetParameterText(RecordID,ParameterId,Value) THEN
        EXIT(FALSE);

      IF NOT EVALUATE(Result,Value) THEN
        EXIT(FALSE);

      ParameterValue := Result;
      EXIT(TRUE);
    END;

    PROCEDURE GetParameterInteger@45(RecordID@1000 : RecordID;ParameterId@1005 : Integer;VAR ParameterValue@1003 : Integer) : Boolean;
    VAR
      Result@1002 : Integer;
      Value@1004 : Text[250];
    BEGIN
      IF NOT GetParameterText(RecordID,ParameterId,Value) THEN
        EXIT(FALSE);

      IF NOT EVALUATE(Result,Value) THEN
        EXIT(FALSE);

      ParameterValue := Result;
      EXIT(TRUE);
    END;

    PROCEDURE GetParameterDate@46(RecordID@1000 : RecordID;ParameterId@1004 : Integer;VAR ParameterValue@1003 : Date) : Boolean;
    VAR
      Result@1005 : Date;
      Value@1002 : Text[250];
    BEGIN
      IF NOT GetParameterText(RecordID,ParameterId,Value) THEN
        EXIT(FALSE);

      IF NOT EVALUATE(Result,Value) THEN
        EXIT(FALSE);

      ParameterValue := Result;
      EXIT(TRUE);
    END;

    PROCEDURE GetIsCustomProcessingHandled@21() : Boolean;
    BEGIN
      EXIT(IsCustomProcessingHandled);
    END;

    PROCEDURE GetRecRefForCustomProcessing@31(VAR RecRef@1000 : RecordRef);
    BEGIN
      RecRef := RecRefCustomerProcessing;
    END;

    PROCEDURE SetRecRefForCustomProcessing@18(RecRef@1000 : RecordRef);
    BEGIN
      RecRefCustomerProcessing := RecRef;
    END;

    PROCEDURE SetProcessingCodeunit@9(NewProcessingCodeunitID@1000 : Integer);
    BEGIN
      ProcessingCodeunitID := NewProcessingCodeunitID;
    END;

    [Integration]
    LOCAL PROCEDURE OnVerifyRecord@16(VAR RecRef@1000 : RecordRef;VAR Result@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeBatchProcessing@15(VAR RecRef@1000 : RecordRef;VAR BatchConfirm@1001 : Option);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterBatchProcessing@14(VAR RecRef@1000 : RecordRef;PostingResult@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnCustomProcessing@17(VAR RecRef@1000 : RecordRef;VAR Handled@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

