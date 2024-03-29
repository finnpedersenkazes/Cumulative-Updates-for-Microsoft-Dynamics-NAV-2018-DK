OBJECT Codeunit 1372 Purchase Batch Post Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=38;
    Permissions=TableData 52=rimd,
                TableData 53=rimd;
    EventSubscriberInstance=Manual;
    OnRun=VAR
            PurchaseHeader@1000 : Record 38;
            PurchaseBatchPostMgt@1001 : Codeunit 1372;
          BEGIN
            PurchaseHeader.COPY(Rec);

            BINDSUBSCRIPTION(PurchaseBatchPostMgt);
            PurchaseBatchPostMgt.SetPostingCodeunitId(PostingCodeunitId);
            PurchaseBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
            PurchaseBatchPostMgt.Code(PurchaseHeader);

            Rec := PurchaseHeader;
          END;

  }
  CODE
  {
    VAR
      BatchProcessingMgt@1001 : Codeunit 1380;
      PostingCodeunitId@1000 : Integer;
      PostingDateIsNotSetErr@1002 : TextConst 'DAN=Angiv bogf�ringsdatoen.;ENU=Enter the posting date.';

    PROCEDURE RunBatch@10(VAR PurchaseHeader@1009 : Record 38;ReplacePostingDate@1000 : Boolean;PostingDate@1001 : Date;ReplaceDocumentDate@1002 : Boolean;CalcInvoiceDiscount@1003 : Boolean;Receive@1004 : Boolean;Invoice@1005 : Boolean);
    VAR
      BatchPostParameterTypes@1006 : Codeunit 1370;
      PurchaseBatchPostMgt@1008 : Codeunit 1372;
    BEGIN
      IF ReplacePostingDate AND (PostingDate = 0D) THEN
        ERROR(PostingDateIsNotSetErr);

      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Invoice,Invoice);
      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Receive,Receive);
      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.CalcInvoiceDiscount,CalcInvoiceDiscount);
      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.PostingDate,PostingDate);
      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.ReplacePostingDate,ReplacePostingDate);
      BatchProcessingMgt.AddParameter(BatchPostParameterTypes.ReplaceDocumentDate,ReplaceDocumentDate);

      PurchaseBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
      COMMIT;
      IF PurchaseBatchPostMgt.RUN(PurchaseHeader) THEN;
      BatchProcessingMgt.ResetBatchID;
    END;

    PROCEDURE RunWithUI@14(VAR PurchaseHeader@1000 : Record 38;TotalCount@1001 : Integer;Question@1002 : Text);
    VAR
      TempErrorMessage@1005 : TEMPORARY Record 700;
      PurchaseBatchPostMgt@1003 : Codeunit 1372;
      ErrorMessages@1004 : Page 700;
    BEGIN
      IF NOT CONFIRM(STRSUBSTNO(Question,PurchaseHeader.COUNT,TotalCount),TRUE) THEN
        EXIT;

      PurchaseBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
      COMMIT;
      IF PurchaseBatchPostMgt.RUN(PurchaseHeader) THEN;
      BatchProcessingMgt.ResetBatchID;
      BatchProcessingMgt.GetErrorMessages(TempErrorMessage);

      IF TempErrorMessage.FINDFIRST THEN BEGIN
        ErrorMessages.SetRecords(TempErrorMessage);
        ErrorMessages.RUN;
      END;
    END;

    PROCEDURE GetBatchProcessor@13(VAR ResultBatchProcessingMgt@1000 : Codeunit 1380);
    BEGIN
      ResultBatchProcessingMgt := BatchProcessingMgt;
    END;

    PROCEDURE SetBatchProcessor@12(NewBatchProcessingMgt@1000 : Codeunit 1380);
    BEGIN
      BatchProcessingMgt := NewBatchProcessingMgt;
    END;

    PROCEDURE Code@4(VAR PurchaseHeader@1000 : Record 38);
    VAR
      RecRef@1001 : RecordRef;
    BEGIN
      IF PostingCodeunitId = 0 THEN
        PostingCodeunitId := CODEUNIT::"Purch.-Post";

      RecRef.GETTABLE(PurchaseHeader);

      BatchProcessingMgt.SetProcessingCodeunit(PostingCodeunitId);
      BatchProcessingMgt.BatchProcess(RecRef);

      RecRef.SETTABLE(PurchaseHeader);
    END;

    LOCAL PROCEDURE PrepareSalesHeader@6(VAR PurchaseHeader@1000 : Record 38;VAR BatchConfirm@1001 : Option);
    VAR
      BatchPostParameterTypes@1002 : Codeunit 1370;
      CalcInvoiceDiscont@1004 : Boolean;
      ReplacePostingDate@1005 : Boolean;
      PostingDate@1006 : Date;
    BEGIN
      BatchProcessingMgt.GetParameterBoolean(PurchaseHeader.RECORDID,BatchPostParameterTypes.CalcInvoiceDiscount,CalcInvoiceDiscont);
      BatchProcessingMgt.GetParameterBoolean(PurchaseHeader.RECORDID,BatchPostParameterTypes.ReplacePostingDate,ReplacePostingDate);
      BatchProcessingMgt.GetParameterDate(PurchaseHeader.RECORDID,BatchPostParameterTypes.PostingDate,PostingDate);

      IF CalcInvoiceDiscont THEN
        CalculateInvoiceDiscount(PurchaseHeader);

      PurchaseHeader.BatchConfirmUpdateDeferralDate(BatchConfirm,ReplacePostingDate,PostingDate);

      BatchProcessingMgt.GetParameterBoolean(PurchaseHeader.RECORDID,BatchPostParameterTypes.Receive,PurchaseHeader.Receive);
      BatchProcessingMgt.GetParameterBoolean(PurchaseHeader.RECORDID,BatchPostParameterTypes.Invoice,PurchaseHeader.Invoice);
      BatchProcessingMgt.GetParameterBoolean(PurchaseHeader.RECORDID,BatchPostParameterTypes.Ship,PurchaseHeader.Ship);

      PurchaseHeader."Print Posted Documents" := FALSE;
    END;

    PROCEDURE SetPostingCodeunitId@9(NewPostingCodeunitId@1000 : Integer);
    BEGIN
      PostingCodeunitId := NewPostingCodeunitId;
    END;

    LOCAL PROCEDURE CalculateInvoiceDiscount@7(VAR PurchaseHeader@1001 : Record 38);
    VAR
      PurchaseLine@1000 : Record 39;
    BEGIN
      PurchaseLine.RESET;
      PurchaseLine.SETRANGE("Document Type",PurchaseHeader."Document Type");
      PurchaseLine.SETRANGE("Document No.",PurchaseHeader."No.");
      IF PurchaseLine.FINDFIRST THEN BEGIN
        CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",PurchaseLine);
        COMMIT;
        PurchaseHeader.GET(PurchaseHeader."Document Type",PurchaseHeader."No.");
      END;
    END;

    LOCAL PROCEDURE CanPostDocument@8(VAR PurchaseHeader@1000 : Record 38) : Boolean;
    VAR
      ApprovalsMgmt@1001 : Codeunit 1535;
    BEGIN
      IF ApprovalsMgmt.IsPurchaseApprovalsWorkflowEnabled(PurchaseHeader) THEN
        EXIT(FALSE);

      IF PurchaseHeader.Status = PurchaseHeader.Status::"Pending Approval" THEN
        EXIT(FALSE);

      IF NOT PurchaseHeader.IsApprovedForPostingBatch THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    [EventSubscriber(Codeunit,1380,OnBeforeBatchProcessing)]
    LOCAL PROCEDURE PrepareSalesHeaderOnBeforeBatchProcessing@3(VAR RecRef@1000 : RecordRef;VAR BatchConfirm@1001 : Option);
    VAR
      PurchaseHeader@1002 : Record 38;
    BEGIN
      RecRef.SETTABLE(PurchaseHeader);
      PrepareSalesHeader(PurchaseHeader,BatchConfirm);
      RecRef.GETTABLE(PurchaseHeader);
    END;

    [EventSubscriber(Codeunit,1380,OnVerifyRecord)]
    LOCAL PROCEDURE CheckPurchaseHeaderOnVerifyRecord@1(VAR RecRef@1000 : RecordRef;VAR Result@1001 : Boolean);
    VAR
      PurchaseHeader@1002 : Record 38;
    BEGIN
      RecRef.SETTABLE(PurchaseHeader);
      Result := CanPostDocument(PurchaseHeader);
      RecRef.GETTABLE(PurchaseHeader);
    END;

    [EventSubscriber(Codeunit,1380,OnCustomProcessing)]
    LOCAL PROCEDURE HandleOnCustomProcessing@2(VAR RecRef@1000 : RecordRef;VAR Handled@1001 : Boolean);
    VAR
      PurchaseHeader@1003 : Record 38;
      PurchasesPayablesSetup@1004 : Record 312;
      PurchasePostViaJobQueue@1005 : Codeunit 98;
    BEGIN
      RecRef.SETTABLE(PurchaseHeader);

      PurchasesPayablesSetup.GET;
      IF PurchasesPayablesSetup."Post with Job Queue" THEN BEGIN
        PurchasePostViaJobQueue.EnqueuePurchDocWithUI(PurchaseHeader,FALSE);
        IF NOT ISNULLGUID(PurchaseHeader."Job Queue Entry ID") THEN
          COMMIT;
        RecRef.GETTABLE(PurchaseHeader);
        Handled := TRUE;
      END;
    END;

    BEGIN
    END.
  }
}

