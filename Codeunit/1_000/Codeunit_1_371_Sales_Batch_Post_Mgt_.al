OBJECT Codeunit 1371 Sales Batch Post Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=36;
    Permissions=TableData 52=rimd,
                TableData 53=rimd;
    EventSubscriberInstance=Manual;
    OnRun=VAR
            SalesHeader@1000 : Record 36;
            SalesBatchPostMgt@1003 : Codeunit 1371;
          BEGIN
            SalesHeader.COPY(Rec);

            BINDSUBSCRIPTION(SalesBatchPostMgt);
            SalesBatchPostMgt.SetPostingCodeunitId(PostingCodeunitId);
            SalesBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
            SalesBatchPostMgt.Code(SalesHeader);

            Rec := SalesHeader;
          END;

  }
  CODE
  {
    VAR
      BatchProcessingMgt@1001 : Codeunit 1380;
      PostingCodeunitId@1000 : Integer;
      PostingDateIsNotSetErr@1002 : TextConst 'DAN=Angiv bogf�ringsdatoen.;ENU=Enter the posting date.';

    PROCEDURE RunBatch@10(VAR SalesHeader@1009 : Record 36;ReplacePostingDate@1000 : Boolean;PostingDate@1001 : Date;ReplaceDocumentDate@1002 : Boolean;CalcInvoiceDiscount@1003 : Boolean;Ship@1004 : Boolean;Invoice@1005 : Boolean);
    VAR
      BatchPostParameterTypes@1006 : Codeunit 1370;
      SalesBatchPostMgt@1008 : Codeunit 1371;
    BEGIN
      IF ReplacePostingDate AND (PostingDate = 0D) THEN
        ERROR(PostingDateIsNotSetErr);

      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Invoice,Invoice);
      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Ship,Ship);
      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.CalcInvoiceDiscount,CalcInvoiceDiscount);
      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.PostingDate,PostingDate);
      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.ReplacePostingDate,ReplacePostingDate);
      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.ReplaceDocumentDate,ReplaceDocumentDate);

      SalesBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
      COMMIT;
      IF SalesBatchPostMgt.RUN(SalesHeader) THEN;
      BatchProcessingMgt.ResetBatchID;
    END;

    PROCEDURE RunWithUI@12(VAR SalesHeader@1000 : Record 36;TotalCount@1001 : Integer;Question@1002 : Text);
    VAR
      TempErrorMessage@1005 : TEMPORARY Record 700;
      SalesBatchPostMgt@1003 : Codeunit 1371;
      ErrorMessages@1004 : Page 700;
    BEGIN
      IF NOT CONFIRM(STRSUBSTNO(Question,SalesHeader.COUNT,TotalCount),TRUE) THEN
        EXIT;

      SalesBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
      COMMIT;
      IF SalesBatchPostMgt.RUN(SalesHeader) THEN;
      BatchProcessingMgt.ResetBatchID;
      BatchProcessingMgt.GetErrorMessages(TempErrorMessage);

      IF TempErrorMessage.FINDFIRST THEN BEGIN
        ErrorMessages.SetRecords(TempErrorMessage);
        ErrorMessages.RUN;
      END;
    END;

    PROCEDURE GetBatchProcessor@11(VAR ResultBatchProcessingMgt@1000 : Codeunit 1380);
    BEGIN
      ResultBatchProcessingMgt := BatchProcessingMgt;
    END;

    PROCEDURE SetBatchProcessor@5(NewBatchProcessingMgt@1000 : Codeunit 1380);
    BEGIN
      BatchProcessingMgt := NewBatchProcessingMgt;
    END;

    PROCEDURE Code@4(VAR SalesHeader@1000 : Record 36);
    VAR
      RecRef@1001 : RecordRef;
    BEGIN
      IF PostingCodeunitId = 0 THEN
        PostingCodeunitId := CODEUNIT::"Sales-Post";

      RecRef.GETTABLE(SalesHeader);

      BatchProcessingMgt.SetProcessingCodeunit(PostingCodeunitId);
      BatchProcessingMgt.BatchProcess(RecRef);

      RecRef.SETTABLE(SalesHeader);
    END;

    LOCAL PROCEDURE PrepareSalesHeader@6(VAR SalesHeader@1000 : Record 36;VAR BatchConfirm@1001 : Option);
    VAR
      BatchPostParameterTypes@1002 : Codeunit 1370;
      CalcInvoiceDiscont@1004 : Boolean;
      ReplacePostingDate@1005 : Boolean;
      PostingDate@1006 : Date;
    BEGIN
      BatchProcessingMgt.GetParameterBoolean(SalesHeader.RECORDID,BatchPostParameterTypes.CalcInvoiceDiscount,CalcInvoiceDiscont);
      BatchProcessingMgt.GetParameterBoolean(SalesHeader.RECORDID,BatchPostParameterTypes.ReplacePostingDate,ReplacePostingDate);
      BatchProcessingMgt.GetParameterDate(SalesHeader.RECORDID,BatchPostParameterTypes.PostingDate,PostingDate);

      IF CalcInvoiceDiscont THEN
        CalculateInvoiceDiscount(SalesHeader);

      SalesHeader.BatchConfirmUpdateDeferralDate(BatchConfirm,ReplacePostingDate,PostingDate);

      BatchProcessingMgt.GetParameterBoolean(SalesHeader.RECORDID,BatchPostParameterTypes.Ship,SalesHeader.Ship);
      BatchProcessingMgt.GetParameterBoolean(SalesHeader.RECORDID,BatchPostParameterTypes.Invoice,SalesHeader.Invoice);
      BatchProcessingMgt.GetParameterBoolean(SalesHeader.RECORDID,BatchPostParameterTypes.Receive,SalesHeader.Receive);

      SalesHeader."Print Posted Documents" := FALSE;
    END;

    PROCEDURE SetPostingCodeunitId@9(NewPostingCodeunitId@1000 : Integer);
    BEGIN
      PostingCodeunitId := NewPostingCodeunitId;
    END;

    LOCAL PROCEDURE CalculateInvoiceDiscount@7(VAR SalesHeader@1001 : Record 36);
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      SalesLine.RESET;
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      IF SalesLine.FINDFIRST THEN BEGIN
        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",SalesLine);
        COMMIT;
        SalesHeader.GET(SalesHeader."Document Type",SalesHeader."No.");
      END;
    END;

    LOCAL PROCEDURE CanPostDocument@8(VAR SalesHeader@1000 : Record 36) : Boolean;
    VAR
      ApprovalsMgmt@1001 : Codeunit 1535;
    BEGIN
      IF ApprovalsMgmt.IsSalesApprovalsWorkflowEnabled(SalesHeader) THEN
        EXIT(FALSE);

      IF SalesHeader.Status = SalesHeader.Status::"Pending Approval" THEN
        EXIT(FALSE);

      IF NOT SalesHeader.IsApprovedForPostingBatch THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    [EventSubscriber(Codeunit,1380,OnBeforeBatchProcessing)]
    LOCAL PROCEDURE PrepareSalesHeaderOnBeforeBatchProcessing@3(VAR RecRef@1000 : RecordRef;VAR BatchConfirm@1001 : Option);
    VAR
      SalesHeader@1002 : Record 36;
    BEGIN
      RecRef.SETTABLE(SalesHeader);
      PrepareSalesHeader(SalesHeader,BatchConfirm);
      RecRef.GETTABLE(SalesHeader);
    END;

    [EventSubscriber(Codeunit,1380,OnVerifyRecord)]
    LOCAL PROCEDURE CheckSalesHeaderOnVerifyRecord@1(VAR RecRef@1000 : RecordRef;VAR Result@1001 : Boolean);
    VAR
      SalesHeader@1002 : Record 36;
    BEGIN
      RecRef.SETTABLE(SalesHeader);
      Result := CanPostDocument(SalesHeader);
      RecRef.GETTABLE(SalesHeader);
    END;

    [EventSubscriber(Codeunit,1380,OnCustomProcessing)]
    LOCAL PROCEDURE HandleOnCustomProcessing@2(VAR RecRef@1000 : RecordRef;VAR Handled@1001 : Boolean);
    VAR
      SalesHeader@1003 : Record 36;
      SalesReceivablesSetup@1004 : Record 311;
      SalesPostViaJobQueue@1005 : Codeunit 88;
    BEGIN
      RecRef.SETTABLE(SalesHeader);

      SalesReceivablesSetup.GET;
      IF SalesReceivablesSetup."Post with Job Queue" THEN BEGIN
        SalesPostViaJobQueue.EnqueueSalesDocWithUI(SalesHeader,FALSE);
        IF NOT ISNULLGUID(SalesHeader."Job Queue Entry ID") THEN
          COMMIT;
        RecRef.GETTABLE(SalesHeader);
        Handled := TRUE;
      END;
    END;

    BEGIN
    END.
  }
}

