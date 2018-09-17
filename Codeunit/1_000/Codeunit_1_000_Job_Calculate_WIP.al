OBJECT Codeunit 1000 Job Calculate WIP
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    Permissions=TableData 169=rm,
                TableData 1001=rimd,
                TableData 1003=r,
                TableData 1004=rimd,
                TableData 1005=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      TempJobWIPBuffer@1002 : ARRAY [2] OF TEMPORARY Record 1018;
      GLSetup@1013 : Record 98;
      GenJnPostLine@1004 : Codeunit 12;
      DimMgt@1005 : Codeunit 408;
      WIPPostingDate@1001 : Date;
      DocNo@1006 : Code[20];
      Text001@1000 : TextConst '@@@=WIP GUILDFORD, 10 CR;DAN=WIP %1;ENU=WIP %1';
      Text002@1007 : TextConst '@@@=Recognition GUILDFORD, 10 CR;DAN=Registrering %1;ENU=Recognition %1';
      Text003@1008 : TextConst '@@@=Completion GUILDFORD, 10 CR;DAN=F�rdigg�relse %1;ENU=Completion %1';
      JobComplete@1010 : Boolean;
      Text004@1011 : TextConst 'DAN=VIA-poster, som er bogf�rt for sagen %1, kan ikke tilbagef�res p� en tidligere dato end %2.;ENU=WIP G/L entries posted for Job %1 cannot be reversed at an earlier date than %2.';
      Text005@1003 : TextConst 'DAN=..%1;ENU=..%1';
      HasGotGLSetup@1014 : Boolean;
      JobWIPTotalChanged@1015 : Boolean;
      WIPAmount@1017 : Decimal;
      RecognizedAllocationPercentage@1016 : Decimal;
      CannotModifyAssociatedEntriesErr@1009 : TextConst '@@@="%1=The job task table name.";DAN=%1 kan ikke redigeres, da sagen har tilknyttede poster for igangv�rende arbejde for sagen.;ENU=The %1 cannot be modified because the job has associated job WIP entries.';

    [Internal]
    PROCEDURE JobCalcWIP@8(VAR Job@1000 : Record 167;WIPPostingDate2@1007 : Date;DocNo2@1009 : Code[20]);
    VAR
      JobTask@1002 : Record 1001;
      JobLedgEntry@1010 : Record 169;
      JobPlanningLine@1011 : Record 1003;
      JobWIPEntry@1012 : Record 1004;
      JobWIPGLEntry@1003 : Record 1005;
      FromJobTask@1005 : Code[20];
      First@1006 : Boolean;
    BEGIN
      CLEARALL;
      TempJobWIPBuffer[1].DELETEALL;

      JobPlanningLine.LOCKTABLE;
      JobLedgEntry.LOCKTABLE;
      JobWIPEntry.LOCKTABLE;
      JobTask.LOCKTABLE;
      Job.LOCKTABLE;

      JobWIPGLEntry.SETCURRENTKEY("Job No.",Reversed,"Job Complete");
      JobWIPGLEntry.SETRANGE("Job No.",Job."No.");
      JobWIPGLEntry.SETRANGE("Job Complete",TRUE);
      IF JobWIPGLEntry.FINDFIRST THEN BEGIN
        JobWIPEntry.DeleteEntriesForJob(Job);
        EXIT;
      END;

      IF WIPPostingDate2 = 0D THEN
        WIPPostingDate := WORKDATE
      ELSE
        WIPPostingDate := WIPPostingDate2;
      DocNo := DocNo2;

      Job.TestBlocked;
      Job.TESTFIELD("WIP Method");
      Job."WIP Posting Date" := WIPPostingDate;
      IF (Job."Ending Date" = 0D) AND Job.Complete THEN
        Job.VALIDATE("Ending Date",WIPPostingDate);
      JobComplete := Job.Complete AND (WIPPostingDate >= Job."Ending Date");
      Job.MODIFY;

      DeleteWIP(Job);

      WITH JobTask DO BEGIN
        SETRANGE("Job No.",Job."No.");
        SETRANGE("WIP-Total","WIP-Total"::Total);
        IF NOT FINDFIRST THEN BEGIN
          SETFILTER("WIP-Total",'<> %1',"WIP-Total"::Excluded);
          IF FINDLAST THEN BEGIN
            VALIDATE("WIP-Total","WIP-Total"::Total);
            MODIFY;
          END;
        END;

        SETRANGE("WIP-Total","WIP-Total"::Total);
        SETRANGE("WIP Method",'');
        IF FINDFIRST THEN
          MODIFYALL("WIP Method",Job."WIP Method");

        SETRANGE("WIP-Total");
        SETRANGE("WIP Method");
      END;

      First := TRUE;
      IF JobTask.FIND('-') THEN
        REPEAT
          IF First THEN
            FromJobTask := JobTask."Job Task No.";
          First := FALSE;
          IF JobTask."WIP-Total" = JobTask."WIP-Total"::Total THEN BEGIN
            JobTaskCalcWIP(Job,FromJobTask,JobTask."Job Task No.");
            First := TRUE;
          END;
        UNTIL JobTask.NEXT = 0;
      CreateWIPEntries(Job."No.");
    END;

    [External]
    PROCEDURE DeleteWIP@2(Job@1000 : Record 167);
    VAR
      JobTask@1001 : Record 1001;
      JobWIPEntry@1002 : Record 1004;
      JobLedgerEntry@1004 : Record 169;
    BEGIN
      JobTask.SETRANGE("Job No.",Job."No.");
      IF JobTask.FIND('-') THEN
        REPEAT
          JobTask.InitWIPFields;
        UNTIL JobTask.NEXT = 0;

      JobWIPEntry.DeleteEntriesForJob(Job);

      JobLedgerEntry.SETRANGE("Job No.",Job."No.");
      JobLedgerEntry.MODIFYALL("Amt. to Post to G/L",0);
    END;

    LOCAL PROCEDURE JobTaskCalcWIP@23(VAR Job@1000 : Record 167;FromJobTask@1001 : Code[20];ToJobTask@1002 : Code[20]);
    VAR
      JobTask@1005 : Record 1001;
      JobWIPTotal@1006 : Record 1021;
      JobWIPWarning@1007 : Record 1007;
    BEGIN
      JobTask.SETRANGE("Job No.",Job."No.");
      JobTask.SETRANGE("Job Task No.",FromJobTask,ToJobTask);
      JobTask.SETFILTER("WIP-Total",'<> %1',JobTask."WIP-Total"::Excluded);

      IF Job.GETFILTER("Posting Date Filter") <> '' THEN
        JobTask.SETFILTER("Posting Date Filter",Job.GETFILTER("Posting Date Filter"))
      ELSE
        JobTask.SETFILTER("Posting Date Filter",STRSUBSTNO(Text005,WIPPostingDate));

      JobTask.SETFILTER("Planning Date Filter",Job.GETFILTER("Planning Date Filter"));

      CreateJobWIPTotal(JobTask,JobWIPTotal);

      IF JobTask.FIND('-') THEN
        REPEAT
          IF JobTask."Job Task Type" = JobTask."Job Task Type"::Posting THEN BEGIN
            JobTask.CALCFIELDS(
              "Schedule (Total Cost)",
              "Schedule (Total Price)",
              "Usage (Total Cost)",
              "Usage (Total Price)",
              "Contract (Total Cost)",
              "Contract (Total Price)",
              "Contract (Invoiced Price)",
              "Contract (Invoiced Cost)");

            CalcWIP(JobTask,JobWIPTotal);
            JobTask.MODIFY;

            JobWIPTotal."Calc. Recog. Costs Amount" += JobTask."Recognized Costs Amount";
            JobWIPTotal."Calc. Recog. Sales Amount" += JobTask."Recognized Sales Amount";

            CreateTempJobWIPBuffers(JobTask,JobWIPTotal);
            JobWIPTotalChanged := FALSE;
            WIPAmount := 0;
          END;
        UNTIL JobTask.NEXT = 0;

      CalcCostInvoicePercentage(JobWIPTotal);
      JobWIPTotal.MODIFY;
      JobWIPWarning.CreateEntries(JobWIPTotal);
    END;

    LOCAL PROCEDURE CreateJobWIPTotal@16(VAR JobTask@1000 : Record 1001;VAR JobWIPTotal@1001 : Record 1021);
    BEGIN
      JobWIPTotalChanged := TRUE;
      WIPAmount := 0;
      RecognizedAllocationPercentage := 0;

      JobWIPTotal.INIT;

      IF JobTask.FIND('-') THEN
        REPEAT
          IF JobTask."Job Task Type" = JobTask."Job Task Type"::Posting THEN BEGIN
            JobTask.CALCFIELDS(
              "Schedule (Total Cost)",
              "Schedule (Total Price)",
              "Usage (Total Cost)",
              "Usage (Total Price)",
              "Contract (Total Cost)",
              "Contract (Total Price)",
              "Contract (Invoiced Price)",
              "Contract (Invoiced Cost)");

            JobWIPTotal."Schedule (Total Cost)" += JobTask."Schedule (Total Cost)";
            JobWIPTotal."Schedule (Total Price)" += JobTask."Schedule (Total Price)";
            JobWIPTotal."Usage (Total Cost)" += JobTask."Usage (Total Cost)";
            JobWIPTotal."Usage (Total Price)" += JobTask."Usage (Total Price)";
            JobWIPTotal."Contract (Total Cost)" += JobTask."Contract (Total Cost)";
            JobWIPTotal."Contract (Total Price)" += JobTask."Contract (Total Price)";
            JobWIPTotal."Contract (Invoiced Price)" += JobTask."Contract (Invoiced Price)";
            JobWIPTotal."Contract (Invoiced Cost)" += JobTask."Contract (Invoiced Cost)";
          END;
        UNTIL JobTask.NEXT = 0;

      // Get values from the "WIP-Total"::Total Job Task, which always is the last entry in the range:
      JobWIPTotal."Job No." := JobTask."Job No.";
      JobWIPTotal."Job Task No." := JobTask."Job Task No.";
      JobWIPTotal."WIP Posting Date" := WIPPostingDate;
      JobWIPTotal."WIP Posting Date Filter" :=
        COPYSTR(JobTask.GETFILTER("Posting Date Filter"),1,MAXSTRLEN(JobWIPTotal."WIP Posting Date Filter"));
      JobWIPTotal."WIP Planning Date Filter" :=
        COPYSTR(JobTask.GETFILTER("Planning Date Filter"),1,MAXSTRLEN(JobWIPTotal."WIP Planning Date Filter"));
      JobWIPTotal."WIP Method" := JobTask."WIP Method";
      JobWIPTotal.INSERT;
    END;

    LOCAL PROCEDURE CalcWIP@22(VAR JobTask@1000 : Record 1001;JobWIPTotal@1001 : Record 1021);
    VAR
      JobWIPMethod@1003 : Record 1006;
    BEGIN
      IF JobComplete THEN BEGIN
        JobTask."Recognized Sales Amount" := JobTask."Contract (Invoiced Price)";
        JobTask."Recognized Costs Amount" := JobTask."Usage (Total Cost)";
        EXIT;
      END;

      WITH JobWIPMethod DO BEGIN
        GET(JobWIPTotal."WIP Method");
        CASE "Recognized Costs" OF
          "Recognized Costs"::"Cost of Sales":
            CalcCostOfSales(JobTask,JobWIPTotal);
          "Recognized Costs"::"Cost Value":
            CalcCostValue(JobTask,JobWIPTotal);
          "Recognized Costs"::"Contract (Invoiced Cost)":
            CalcContractInvoicedCost(JobTask);
          "Recognized Costs"::"Usage (Total Cost)":
            CalcUsageTotalCostCosts(JobTask);
        END;
        CASE "Recognized Sales" OF
          "Recognized Sales"::"Contract (Invoiced Price)":
            CalcContractInvoicedPrice(JobTask);
          "Recognized Sales"::"Usage (Total Cost)":
            CalcUsageTotalCostSales(JobTask);
          "Recognized Sales"::"Usage (Total Price)":
            CalcUsageTotalPrice(JobTask);
          "Recognized Sales"::"Percentage of Completion":
            CalcPercentageofCompletion(JobTask,JobWIPTotal);
          "Recognized Sales"::"Sales Value":
            CalcSalesValue(JobTask,JobWIPTotal);
        END;
      END;
    END;

    LOCAL PROCEDURE CalcCostOfSales@14(VAR JobTask@1001 : Record 1001;JobWIPTotal@1000 : Record 1021);
    BEGIN
      IF JobWIPTotal."Contract (Total Price)" = 0 THEN
        EXIT;

      IF JobWIPTotalChanged THEN BEGIN
        WIPAmount := JobWIPTotal."Usage (Total Cost)" -
          ((JobWIPTotal."Contract (Invoiced Price)" / JobWIPTotal."Contract (Total Price)") *
           JobWIPTotal."Schedule (Total Cost)");
        IF JobWIPTotal."Usage (Total Cost)" <> 0 THEN
          RecognizedAllocationPercentage := WIPAmount / JobWIPTotal."Usage (Total Cost)";
      END;

      WITH JobTask DO BEGIN
        IF RecognizedAllocationPercentage <> 0 THEN
          WIPAmount := ROUND("Usage (Total Cost)" * RecognizedAllocationPercentage);
        "Recognized Costs Amount" := "Usage (Total Cost)" - WIPAmount;
      END;
    END;

    LOCAL PROCEDURE CalcCostValue@19(VAR JobTask@1001 : Record 1001;JobWIPTotal@1000 : Record 1021);
    BEGIN
      IF JobWIPTotal."Schedule (Total Price)" = 0 THEN
        EXIT;

      IF JobWIPTotalChanged THEN BEGIN
        WIPAmount :=
          (JobWIPTotal."Usage (Total Cost)" *
           JobWIPTotal."Contract (Total Price)" /
           JobWIPTotal."Schedule (Total Price)") -
          JobWIPTotal."Schedule (Total Cost)" *
          JobWIPTotal."Contract (Invoiced Price)" /
          JobWIPTotal."Schedule (Total Price)";
        IF JobWIPTotal."Usage (Total Cost)" <> 0 THEN
          RecognizedAllocationPercentage := WIPAmount / JobWIPTotal."Usage (Total Cost)";
      END;

      WITH JobTask DO BEGIN
        IF RecognizedAllocationPercentage <> 0 THEN
          WIPAmount := ROUND("Usage (Total Cost)" * RecognizedAllocationPercentage);
        "Recognized Costs Amount" := "Usage (Total Cost)" - WIPAmount;
      END;
    END;

    LOCAL PROCEDURE CalcContractInvoicedCost@20(VAR JobTask@1001 : Record 1001);
    BEGIN
      JobTask."Recognized Costs Amount" := JobTask."Contract (Invoiced Cost)";
    END;

    LOCAL PROCEDURE CalcUsageTotalCostCosts@30(VAR JobTask@1001 : Record 1001);
    BEGIN
      JobTask."Recognized Costs Amount" := JobTask."Usage (Total Cost)";
    END;

    LOCAL PROCEDURE CalcContractInvoicedPrice@24(VAR JobTask@1001 : Record 1001);
    BEGIN
      JobTask."Recognized Sales Amount" := JobTask."Contract (Invoiced Price)";
    END;

    LOCAL PROCEDURE CalcUsageTotalCostSales@25(VAR JobTask@1001 : Record 1001);
    BEGIN
      JobTask."Recognized Sales Amount" := JobTask."Usage (Total Cost)";
    END;

    LOCAL PROCEDURE CalcUsageTotalPrice@26(VAR JobTask@1001 : Record 1001);
    BEGIN
      JobTask."Recognized Sales Amount" := JobTask."Usage (Total Price)";
    END;

    LOCAL PROCEDURE CalcPercentageofCompletion@27(VAR JobTask@1001 : Record 1001;JobWIPTotal@1000 : Record 1021);
    BEGIN
      IF JobWIPTotal."Schedule (Total Cost)" = 0 THEN
        EXIT;

      IF JobWIPTotalChanged THEN BEGIN
        IF JobWIPTotal."Usage (Total Cost)" <= JobWIPTotal."Schedule (Total Cost)" THEN
          WIPAmount :=
            (JobWIPTotal."Usage (Total Cost)" / JobWIPTotal."Schedule (Total Cost)") *
            JobWIPTotal."Contract (Total Price)"
        ELSE
          WIPAmount := JobWIPTotal."Contract (Total Price)";
        IF JobWIPTotal."Contract (Total Price)" <> 0 THEN
          RecognizedAllocationPercentage := WIPAmount / JobWIPTotal."Contract (Total Price)";
      END;

      WITH JobTask DO BEGIN
        IF RecognizedAllocationPercentage <> 0 THEN
          WIPAmount := ROUND("Contract (Total Price)" * RecognizedAllocationPercentage);
        "Recognized Sales Amount" := WIPAmount;
      END;
    END;

    LOCAL PROCEDURE CalcSalesValue@28(VAR JobTask@1001 : Record 1001;JobWIPTotal@1000 : Record 1021);
    BEGIN
      IF JobWIPTotal."Schedule (Total Price)" = 0 THEN
        EXIT;

      IF JobWIPTotalChanged THEN BEGIN
        WIPAmount :=
          (JobWIPTotal."Usage (Total Price)" *
           JobWIPTotal."Contract (Total Price)" /
           JobWIPTotal."Schedule (Total Price)") -
          JobWIPTotal."Contract (Invoiced Price)";
        IF JobWIPTotal."Usage (Total Price)" <> 0 THEN
          RecognizedAllocationPercentage := WIPAmount / JobWIPTotal."Usage (Total Price)";
      END;

      WITH JobTask DO BEGIN
        IF RecognizedAllocationPercentage <> 0 THEN
          WIPAmount := ROUND("Usage (Total Price)" * RecognizedAllocationPercentage);
        "Recognized Sales Amount" := ("Contract (Invoiced Price)" + WIPAmount);
      END;
    END;

    LOCAL PROCEDURE CalcCostInvoicePercentage@38(VAR JobWIPTotal@1000 : Record 1021);
    BEGIN
      WITH JobWIPTotal DO BEGIN
        IF "Schedule (Total Cost)" <> 0 THEN
          "Cost Completion %" := ROUND(100 * "Usage (Total Cost)" / "Schedule (Total Cost)",0.00001)
        ELSE
          "Cost Completion %" := 0;
        IF "Contract (Total Price)" <> 0 THEN
          "Invoiced %" := ROUND(100 * "Contract (Invoiced Price)" / "Contract (Total Price)",0.00001)
        ELSE
          "Invoiced %" := 0;
      END;
    END;

    LOCAL PROCEDURE CreateTempJobWIPBuffers@11(VAR JobTask@1000 : Record 1001;VAR JobWIPTotal@1003 : Record 1021);
    VAR
      Job@1004 : Record 167;
      JobWIPMethod@1002 : Record 1006;
      BufferType@1001 : 'Applied Costs,Applied Sales,Recognized Costs,Recognized Sales,Accrued Costs,Accrued Sales';
    BEGIN
      Job.GET(JobTask."Job No.");
      JobWIPMethod.GET(JobWIPTotal."WIP Method");
      WITH JobTask DO BEGIN
        IF NOT JobComplete THEN BEGIN
          IF "Recognized Costs Amount" <> 0 THEN BEGIN
            CreateWIPBufferEntryFromTask(JobTask,JobWIPTotal,BufferType::"Recognized Costs",FALSE);
            IF Job."WIP Posting Method" = Job."WIP Posting Method"::"Per Job" THEN
              CreateWIPBufferEntryFromTask(JobTask,JobWIPTotal,BufferType::"Applied Costs",FALSE)
            ELSE
              FindJobLedgerEntriesByJobTask(JobTask,JobWIPTotal,BufferType::"Applied Costs");
            IF "Recognized Costs Amount" > "Usage (Total Cost)" THEN BEGIN
              CreateWIPBufferEntryFromTask(JobTask,JobWIPTotal,BufferType::"Accrued Costs",FALSE);
              IF Job."WIP Posting Method" = Job."WIP Posting Method"::"Per Job Ledger Entry" THEN
                CreateWIPBufferEntryFromTask(JobTask,JobWIPTotal,BufferType::"Applied Costs",TRUE);
            END;
          END;
          IF "Recognized Sales Amount" <> 0 THEN BEGIN
            CreateWIPBufferEntryFromTask(JobTask,JobWIPTotal,BufferType::"Recognized Sales",FALSE);
            IF (Job."WIP Posting Method" = Job."WIP Posting Method"::"Per Job") OR
               (JobWIPMethod."Recognized Sales" = JobWIPMethod."Recognized Sales"::"Percentage of Completion")
            THEN
              CreateWIPBufferEntryFromTask(
                JobTask,JobWIPTotal,BufferType::"Applied Sales",
                (("Contract (Invoiced Price)" > "Recognized Sales Amount") AND
                 (JobWIPMethod."Recognized Sales" = JobWIPMethod."Recognized Sales"::"Percentage of Completion")))
            ELSE
              FindJobLedgerEntriesByJobTask(JobTask,JobWIPTotal,BufferType::"Applied Sales");
            IF "Recognized Sales Amount" > "Contract (Invoiced Price)" THEN
              CreateWIPBufferEntryFromTask(JobTask,JobWIPTotal,BufferType::"Accrued Sales",FALSE);
          END;
          IF ("Recognized Costs Amount" = 0) AND ("Usage (Total Cost)" <> 0) THEN BEGIN
            IF Job."WIP Posting Method" = Job."WIP Posting Method"::"Per Job" THEN
              CreateWIPBufferEntryFromTask(JobTask,JobWIPTotal,BufferType::"Applied Costs",FALSE)
            ELSE
              FindJobLedgerEntriesByJobTask(JobTask,JobWIPTotal,BufferType::"Applied Costs");
          END;
          IF ("Recognized Sales Amount" = 0) AND ("Contract (Invoiced Price)" <> 0) THEN BEGIN
            IF Job."WIP Posting Method" = Job."WIP Posting Method"::"Per Job" THEN
              CreateWIPBufferEntryFromTask(JobTask,JobWIPTotal,BufferType::"Applied Sales",FALSE)
            ELSE
              FindJobLedgerEntriesByJobTask(JobTask,JobWIPTotal,BufferType::"Applied Sales");
          END;
        END ELSE BEGIN
          IF Job."WIP Posting Method" = Job."WIP Posting Method"::"Per Job Ledger Entry" THEN BEGIN
            FindJobLedgerEntriesByJobTask(JobTask,JobWIPTotal,BufferType::"Applied Costs");
            FindJobLedgerEntriesByJobTask(JobTask,JobWIPTotal,BufferType::"Applied Sales");
          END;

          IF "Recognized Costs Amount" <> 0 THEN
            CreateWIPBufferEntryFromTask(JobTask,JobWIPTotal,BufferType::"Recognized Costs",FALSE);
          IF "Recognized Sales Amount" <> 0 THEN
            CreateWIPBufferEntryFromTask(JobTask,JobWIPTotal,BufferType::"Recognized Sales",FALSE);
        END;
      END;
    END;

    LOCAL PROCEDURE CreateWIPBufferEntryFromTask@15(VAR JobTask@1000 : Record 1001;VAR JobWIPTotal@1002 : Record 1021;BufferType@1001 : 'Applied Costs,Applied Sales,Recognized Costs,Recognized Sales,Accrued Costs,Accrued Sales';AppliedAccrued@1007 : Boolean);
    VAR
      JobTaskDimension@1003 : Record 1002;
      TempDimensionBuffer@1004 : TEMPORARY Record 360;
      Job@1006 : Record 167;
      JobPostingGroup@1005 : Record 208;
      JobWIPMethod@1008 : Record 1006;
    BEGIN
      CLEAR(TempJobWIPBuffer);
      TempDimensionBuffer.RESET;
      TempDimensionBuffer.DELETEALL;

      JobTaskDimension.SETRANGE("Job No.",JobTask."Job No.");
      JobTaskDimension.SETRANGE("Job Task No.",JobTask."Job Task No.");
      IF JobTaskDimension.FINDSET THEN
        REPEAT
          TempDimensionBuffer."Dimension Code" := JobTaskDimension."Dimension Code";
          TempDimensionBuffer."Dimension Value Code" := JobTaskDimension."Dimension Value Code";
          TempDimensionBuffer.INSERT;
        UNTIL JobTaskDimension.NEXT = 0;
      IF NOT DimMgt.CheckDimBuffer(TempDimensionBuffer) THEN
        ERROR(DimMgt.GetDimCombErr);
      TempJobWIPBuffer[1]."Dim Combination ID" := DimMgt.CreateDimSetIDFromDimBuf(TempDimensionBuffer);

      Job.GET(JobTask."Job No.");
      IF JobTask."Job Posting Group" = '' THEN BEGIN
        Job.TESTFIELD("Job Posting Group");
        JobTask."Job Posting Group" := Job."Job Posting Group";
      END;
      JobPostingGroup.GET(JobTask."Job Posting Group");
      JobWIPMethod.GET(JobWIPTotal."WIP Method");

      CASE BufferType OF
        BufferType::"Applied Costs":
          BEGIN
            TempJobWIPBuffer[1].Type := TempJobWIPBuffer[1].Type::"Applied Costs";
            TempJobWIPBuffer[1]."G/L Account No." := JobPostingGroup.GetJobCostsAppliedAccount;
            TempJobWIPBuffer[1]."Bal. G/L Account No." := JobPostingGroup.GetWIPCostsAccount;
            TempJobWIPBuffer[1]."WIP Entry Amount" := GetAppliedCostsWIPEntryAmount(JobTask,JobWIPMethod,AppliedAccrued);
          END;
        BufferType::"Applied Sales":
          BEGIN
            TempJobWIPBuffer[1].Type := TempJobWIPBuffer[1].Type::"Applied Sales";
            TempJobWIPBuffer[1]."G/L Account No." := JobPostingGroup.GetJobSalesAppliedAccount;
            TempJobWIPBuffer[1]."Bal. G/L Account No." := JobPostingGroup.GetWIPInvoicedSalesAccount;
            TempJobWIPBuffer[1]."WIP Entry Amount" := GetAppliedSalesWIPEntryAmount(JobTask,JobWIPMethod,AppliedAccrued);
          END;
        BufferType::"Recognized Costs":
          BEGIN
            TempJobWIPBuffer[1].Type := TempJobWIPBuffer[1].Type::"Recognized Costs";
            TempJobWIPBuffer[1]."G/L Account No." := JobPostingGroup.GetRecognizedCostsAccount;
            TempJobWIPBuffer[1]."Bal. G/L Account No." := GetRecognizedCostsBalGLAccountNo(Job,JobPostingGroup);
            TempJobWIPBuffer[1]."Job Complete" := JobComplete;
            TempJobWIPBuffer[1]."WIP Entry Amount" := JobTask."Recognized Costs Amount";
          END;
        BufferType::"Recognized Sales":
          BEGIN
            TempJobWIPBuffer[1].Type := TempJobWIPBuffer[1].Type::"Recognized Sales";
            TempJobWIPBuffer[1]."G/L Account No." := JobPostingGroup.GetRecognizedSalesAccount;
            TempJobWIPBuffer[1]."Bal. G/L Account No." := GetRecognizedSalesBalGLAccountNo(Job,JobPostingGroup,JobWIPMethod);
            TempJobWIPBuffer[1]."Job Complete" := JobComplete;
            TempJobWIPBuffer[1]."WIP Entry Amount" := -JobTask."Recognized Sales Amount";
          END;
        BufferType::"Accrued Costs":
          BEGIN
            TempJobWIPBuffer[1].Type := TempJobWIPBuffer[1].Type::"Accrued Costs";
            TempJobWIPBuffer[1]."G/L Account No." := JobPostingGroup.GetJobCostsAdjustmentAccount;
            TempJobWIPBuffer[1]."Bal. G/L Account No." := JobPostingGroup.GetWIPAccruedCostsAccount;
            TempJobWIPBuffer[1]."WIP Entry Amount" := GetAccruedCostsWIPEntryAmount(JobTask,JobWIPMethod);
          END;
        BufferType::"Accrued Sales":
          BEGIN
            TempJobWIPBuffer[1].Type := TempJobWIPBuffer[1].Type::"Accrued Sales";
            TempJobWIPBuffer[1]."G/L Account No." := JobPostingGroup.GetJobSalesAdjustmentAccount;
            TempJobWIPBuffer[1]."Bal. G/L Account No." := JobPostingGroup.GetWIPAccruedSalesAccount;
            TempJobWIPBuffer[1]."WIP Entry Amount" := GetAccruedSalesWIPEntryAmount(JobTask,JobWIPMethod);
          END;
      END;

      IF TempJobWIPBuffer[1]."WIP Entry Amount" <> 0 THEN BEGIN
        TempJobWIPBuffer[1].Reverse := TRUE;
        TransferJobTaskToTempJobWIPBuf(JobTask,JobWIPTotal);
        UpdateTempJobWIPBufferEntry;
      END;
    END;

    LOCAL PROCEDURE FindJobLedgerEntriesByJobTask@37(VAR JobTask@1000 : Record 1001;VAR JobWIPTotal@1002 : Record 1021;BufferType@1001 : 'Applied Costs,Applied Sales,Recognized Costs,Recognized Sales,Accrued Costs,Accrued Sales');
    VAR
      JobLedgerEntry@1003 : Record 169;
    BEGIN
      JobLedgerEntry.SETRANGE("Job No.",JobTask."Job No.");
      JobLedgerEntry.SETRANGE("Job Task No.",JobTask."Job Task No.");
      JobLedgerEntry.SETFILTER("Posting Date",JobTask.GETFILTER("Posting Date Filter"));
      IF BufferType = BufferType::"Applied Costs" THEN
        JobLedgerEntry.SETRANGE("Entry Type",JobLedgerEntry."Entry Type"::Usage);
      IF BufferType = BufferType::"Applied Sales" THEN
        JobLedgerEntry.SETRANGE("Entry Type",JobLedgerEntry."Entry Type"::Sale);

      IF JobLedgerEntry.FINDSET THEN
        REPEAT
          CreateWIPBufferEntryFromLedger(JobLedgerEntry,JobTask,JobWIPTotal,BufferType)
        UNTIL JobLedgerEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateWIPBufferEntryFromLedger@33(VAR JobLedgerEntry@1000 : Record 169;VAR JobTask@1008 : Record 1001;VAR JobWIPTotal@1002 : Record 1021;BufferType@1001 : 'Applied Costs,Applied Sales,Recognized Costs,Recognized Sales,Accrued Costs,Accrued Sales');
    VAR
      Job@1006 : Record 167;
      JobPostingGroup@1005 : Record 208;
    BEGIN
      CLEAR(TempJobWIPBuffer);
      TempJobWIPBuffer[1]."Dim Combination ID" := JobLedgerEntry."Dimension Set ID";
      TempJobWIPBuffer[1]."Job Complete" := JobComplete;
      IF JobTask."Job Posting Group" = '' THEN BEGIN
        Job.GET(JobTask."Job No.");
        Job.TESTFIELD("Job Posting Group");
        JobTask."Job Posting Group" := Job."Job Posting Group";
      END;
      JobPostingGroup.GET(JobTask."Job Posting Group");

      CASE BufferType OF
        BufferType::"Applied Costs":
          BEGIN
            TempJobWIPBuffer[1].Type := TempJobWIPBuffer[1].Type::"Applied Costs";
            CASE JobLedgerEntry.Type OF
              JobLedgerEntry.Type::Item:
                TempJobWIPBuffer[1]."G/L Account No." := JobPostingGroup.GetItemCostsAppliedAccount;
              JobLedgerEntry.Type::Resource:
                TempJobWIPBuffer[1]."G/L Account No." := JobPostingGroup.GetResourceCostsAppliedAccount;
              JobLedgerEntry.Type::"G/L Account":
                TempJobWIPBuffer[1]."G/L Account No." := JobPostingGroup.GetGLCostsAppliedAccount;
            END;
            TempJobWIPBuffer[1]."Bal. G/L Account No." := JobPostingGroup.GetWIPCostsAccount;
            TempJobWIPBuffer[1]."WIP Entry Amount" := -JobLedgerEntry."Total Cost (LCY)";
            JobLedgerEntry."Amt. to Post to G/L" := JobLedgerEntry."Total Cost (LCY)" - JobLedgerEntry."Amt. Posted to G/L";
          END;
        BufferType::"Applied Sales":
          BEGIN
            TempJobWIPBuffer[1].Type := TempJobWIPBuffer[1].Type::"Applied Sales";
            TempJobWIPBuffer[1]."G/L Account No." := JobPostingGroup.GetJobSalesAppliedAccount;
            TempJobWIPBuffer[1]."Bal. G/L Account No." := JobPostingGroup.GetWIPInvoicedSalesAccount;
            TempJobWIPBuffer[1]."WIP Entry Amount" := -JobLedgerEntry."Line Amount (LCY)";
            JobLedgerEntry."Amt. to Post to G/L" := JobLedgerEntry."Line Amount (LCY)" - JobLedgerEntry."Amt. Posted to G/L";
          END;
      END;

      JobLedgerEntry.MODIFY;

      IF TempJobWIPBuffer[1]."WIP Entry Amount" <> 0 THEN BEGIN
        TempJobWIPBuffer[1].Reverse := TRUE;
        TransferJobTaskToTempJobWIPBuf(JobTask,JobWIPTotal);
        UpdateTempJobWIPBufferEntry;
      END;
    END;

    LOCAL PROCEDURE TransferJobTaskToTempJobWIPBuf@6(JobTask@1000 : Record 1001;JobWIPTotal@1001 : Record 1021);
    VAR
      Job@1002 : Record 167;
    BEGIN
      WITH Job DO BEGIN
        GET(JobTask."Job No.");
        TempJobWIPBuffer[1]."WIP Posting Method Used" := "WIP Posting Method";
      END;

      WITH JobTask DO BEGIN
        TempJobWIPBuffer[1]."Job No." := "Job No.";
        TempJobWIPBuffer[1]."Posting Group" := "Job Posting Group";
      END;

      WITH JobWIPTotal DO BEGIN
        TempJobWIPBuffer[1]."WIP Method" := "WIP Method";
        TempJobWIPBuffer[1]."Job WIP Total Entry No." := "Entry No.";
      END;
    END;

    LOCAL PROCEDURE UpdateTempJobWIPBufferEntry@29();
    BEGIN
      TempJobWIPBuffer[2] := TempJobWIPBuffer[1];
      IF TempJobWIPBuffer[2].FIND THEN BEGIN
        TempJobWIPBuffer[2]."WIP Entry Amount" += TempJobWIPBuffer[1]."WIP Entry Amount";
        TempJobWIPBuffer[2].MODIFY;
      END ELSE
        TempJobWIPBuffer[1].INSERT;
    END;

    LOCAL PROCEDURE CreateWIPEntries@1(JobNo@1000 : Code[20]);
    VAR
      JobWIPEntry@1001 : Record 1004;
      JobWIPMethod@1006 : Record 1006;
      NextEntryNo@1003 : Integer;
      CreateEntry@1005 : Boolean;
    BEGIN
      IF JobWIPEntry.FINDLAST THEN
        NextEntryNo := JobWIPEntry."Entry No." + 1
      ELSE
        NextEntryNo := 1;

      GetGLSetup;
      IF TempJobWIPBuffer[1].FIND('-') THEN
        REPEAT
          CreateEntry := TRUE;

          JobWIPMethod.GET(TempJobWIPBuffer[1]."WIP Method");
          IF NOT JobWIPMethod."WIP Cost" AND
             ((TempJobWIPBuffer[1].Type = TempJobWIPBuffer[1].Type::"Recognized Costs") OR
              (TempJobWIPBuffer[1].Type = TempJobWIPBuffer[1].Type::"Applied Costs"))
          THEN
            CreateEntry := FALSE;

          IF NOT JobWIPMethod."WIP Sales" AND
             ((TempJobWIPBuffer[1].Type = TempJobWIPBuffer[1].Type::"Recognized Sales") OR
              (TempJobWIPBuffer[1].Type = TempJobWIPBuffer[1].Type::"Applied Sales"))
          THEN
            CreateEntry := FALSE;

          IF TempJobWIPBuffer[1]."WIP Entry Amount" = 0 THEN
            CreateEntry := FALSE;

          IF CreateEntry THEN BEGIN
            CLEAR(JobWIPEntry);
            JobWIPEntry."Job No." := JobNo;
            JobWIPEntry."WIP Posting Date" := WIPPostingDate;
            JobWIPEntry."Document No." := DocNo;
            JobWIPEntry.Type := TempJobWIPBuffer[1].Type;
            JobWIPEntry."Job Posting Group" := TempJobWIPBuffer[1]."Posting Group";
            JobWIPEntry."G/L Account No." := TempJobWIPBuffer[1]."G/L Account No.";
            JobWIPEntry."G/L Bal. Account No." := TempJobWIPBuffer[1]."Bal. G/L Account No.";
            JobWIPEntry."WIP Method Used" := TempJobWIPBuffer[1]."WIP Method";
            JobWIPEntry."Job Complete" := TempJobWIPBuffer[1]."Job Complete";
            JobWIPEntry."Job WIP Total Entry No." := TempJobWIPBuffer[1]."Job WIP Total Entry No.";
            JobWIPEntry."WIP Entry Amount" := ROUND(TempJobWIPBuffer[1]."WIP Entry Amount");
            JobWIPEntry.Reverse := TempJobWIPBuffer[1].Reverse;
            JobWIPEntry."WIP Posting Method Used" := TempJobWIPBuffer[1]."WIP Posting Method Used";
            JobWIPEntry."Entry No." := NextEntryNo;
            JobWIPEntry."Dimension Set ID" := TempJobWIPBuffer[1]."Dim Combination ID";
            DimMgt.UpdateGlobalDimFromDimSetID(JobWIPEntry."Dimension Set ID",JobWIPEntry."Global Dimension 1 Code",
              JobWIPEntry."Global Dimension 2 Code");
            JobWIPEntry.INSERT(TRUE);
            NextEntryNo := NextEntryNo + 1;
          END;
        UNTIL TempJobWIPBuffer[1].NEXT = 0;
    END;

    [Internal]
    PROCEDURE CalcGLWIP@3(JobNo@1000 : Code[20];JustReverse@1001 : Boolean;DocNo@1007 : Code[20];PostingDate@1008 : Date;NewPostDate@1012 : Boolean);
    VAR
      SourceCodeSetup@1009 : Record 242;
      GLEntry@1004 : Record 17;
      Job@1010 : Record 167;
      JobWIPEntry@1003 : Record 1004;
      JobWIPGLEntry@1002 : Record 1005;
      JobWIPTotal@1011 : Record 1021;
      JobLedgerEntry@1014 : Record 169;
      JobTask@1015 : Record 1001;
      NextEntryNo@1005 : Integer;
      NextTransactionNo@1006 : Integer;
    BEGIN
      JobWIPGLEntry.LOCKTABLE;
      JobWIPEntry.LOCKTABLE;
      Job.LOCKTABLE;

      JobWIPGLEntry.SETCURRENTKEY("Job No.",Reversed,"Job Complete");
      JobWIPGLEntry.SETRANGE("Job No.",JobNo);
      JobWIPGLEntry.SETRANGE("Job Complete",TRUE);
      IF NOT JobWIPGLEntry.ISEMPTY THEN
        EXIT;
      JobWIPGLEntry.RESET;

      Job.GET(JobNo);
      Job.TestBlocked;
      IF NewPostDate THEN
        Job."WIP G/L Posting Date" := PostingDate;
      IF JustReverse THEN
        Job."WIP G/L Posting Date" := 0D;
      Job.MODIFY;

      IF JobWIPGLEntry.FINDLAST THEN
        NextEntryNo := JobWIPGLEntry."Entry No." + 1
      ELSE
        NextEntryNo := 1;

      JobWIPGLEntry.SETCURRENTKEY("WIP Transaction No.");
      IF JobWIPGLEntry.FINDLAST THEN
        NextTransactionNo := JobWIPGLEntry."WIP Transaction No." + 1
      ELSE
        NextTransactionNo := 1;

      SourceCodeSetup.GET;

      // Reverse Entries
      JobWIPGLEntry.SETCURRENTKEY("Job No.",Reversed);
      JobWIPGLEntry.SETRANGE("Job No.",JobNo);
      JobWIPGLEntry.SETRANGE(Reverse,TRUE);
      JobWIPGLEntry.SETRANGE(Reversed,FALSE);
      IF JobWIPGLEntry.FIND('-') THEN
        REPEAT
          IF JobWIPGLEntry."Posting Date" > PostingDate THEN
            ERROR(Text004,JobWIPGLEntry."Job No.",JobWIPGLEntry."Posting Date");
        UNTIL JobWIPGLEntry.NEXT = 0;
      IF JobWIPGLEntry.FIND('-') THEN
        REPEAT
          PostWIPGL(JobWIPGLEntry,TRUE,DocNo,SourceCodeSetup."Job G/L WIP",PostingDate);
        UNTIL JobWIPGLEntry.NEXT = 0;
      JobWIPGLEntry.MODIFYALL("Reverse Date",PostingDate);
      JobWIPGLEntry.MODIFYALL(Reversed,TRUE);
      IF JustReverse THEN
        EXIT;

      JobWIPEntry.SETRANGE("Job No.",JobNo);
      IF JobWIPEntry.FIND('-') THEN
        REPEAT
          CLEAR(JobWIPGLEntry);
          JobWIPGLEntry."Job No." := JobWIPEntry."Job No.";
          JobWIPGLEntry."Document No." := JobWIPEntry."Document No.";
          JobWIPGLEntry."G/L Account No." := JobWIPEntry."G/L Account No.";
          JobWIPGLEntry."G/L Bal. Account No." := JobWIPEntry."G/L Bal. Account No.";
          JobWIPGLEntry.Type := JobWIPEntry.Type;
          JobWIPGLEntry."WIP Posting Date" := JobWIPEntry."WIP Posting Date";
          IF NewPostDate THEN
            JobWIPGLEntry."Posting Date" := PostingDate
          ELSE
            JobWIPGLEntry."Posting Date" := JobWIPEntry."WIP Posting Date";
          JobWIPGLEntry."Job Posting Group" := JobWIPEntry."Job Posting Group";
          JobWIPGLEntry."WIP Method Used" := JobWIPEntry."WIP Method Used";
          IF NOT NewPostDate THEN BEGIN
            Job."WIP G/L Posting Date" := JobWIPEntry."WIP Posting Date";
            Job.MODIFY;
          END;
          JobWIPGLEntry.Reversed := FALSE;
          JobWIPGLEntry."Job Complete" := JobWIPEntry."Job Complete";
          JobWIPGLEntry."WIP Transaction No." := NextTransactionNo;
          IF JobWIPGLEntry.Type IN [JobWIPGLEntry.Type::"Recognized Costs",JobWIPGLEntry.Type::"Recognized Sales"] THEN BEGIN
            IF JobWIPGLEntry."Job Complete" THEN
              JobWIPGLEntry.Description := STRSUBSTNO(Text003,JobNo)
            ELSE
              JobWIPGLEntry.Description := STRSUBSTNO(Text002,JobNo);
          END ELSE
            JobWIPGLEntry.Description := STRSUBSTNO(Text001,JobNo);
          JobWIPGLEntry."WIP Entry Amount" := JobWIPEntry."WIP Entry Amount";
          JobWIPGLEntry.Reverse := JobWIPEntry.Reverse;
          JobWIPGLEntry."WIP Posting Method Used" := JobWIPEntry."WIP Posting Method Used";
          JobWIPGLEntry."Job WIP Total Entry No." := JobWIPEntry."Job WIP Total Entry No.";
          JobWIPGLEntry."Global Dimension 1 Code" := JobWIPEntry."Global Dimension 1 Code";
          JobWIPGLEntry."Global Dimension 2 Code" := JobWIPEntry."Global Dimension 2 Code";
          JobWIPGLEntry."Dimension Set ID" := JobWIPEntry."Dimension Set ID";
          JobWIPGLEntry."Entry No." := NextEntryNo;
          NextEntryNo := NextEntryNo + 1;
          PostWIPGL(JobWIPGLEntry,
            FALSE,
            JobWIPGLEntry."Document No.",
            SourceCodeSetup."Job G/L WIP",
            JobWIPGLEntry."Posting Date");
          GLEntry.FINDLAST;
          JobWIPGLEntry."G/L Entry No." := GLEntry."Entry No.";
          JobWIPGLEntry.INSERT;
          JobWIPTotal.GET(JobWIPGLEntry."Job WIP Total Entry No.");
          JobWIPTotal."Posted to G/L" := TRUE;
          JobWIPTotal.MODIFY;
        UNTIL JobWIPEntry.NEXT = 0;

      WITH JobTask DO BEGIN
        SETRANGE("Job No.",Job."No.");
        IF FINDSET THEN
          REPEAT
            BEGIN
              "Recognized Sales G/L Amount" := "Recognized Sales Amount";
              "Recognized Costs G/L Amount" := "Recognized Costs Amount";
              MODIFY;
            END;
          UNTIL NEXT = 0;
      END;

      WITH JobLedgerEntry DO BEGIN
        SETRANGE("Job No.",Job."No.");
        SETFILTER("Amt. to Post to G/L",'<>%1',0);
        IF FINDSET THEN
          REPEAT
            BEGIN
              "Amt. Posted to G/L" += "Amt. to Post to G/L";
              MODIFY;
            END;
          UNTIL NEXT = 0;
      END;

      DeleteWIP(Job);
    END;

    LOCAL PROCEDURE PostWIPGL@10(JobWIPGLEntry@1000 : Record 1005;Reversed@1002 : Boolean;JnlDocNo@1005 : Code[20];SourceCode@1006 : Code[10];JnlPostingDate@1004 : Date);
    VAR
      GLAmount@1003 : Decimal;
    BEGIN
      CheckJobGLAcc(JobWIPGLEntry."G/L Account No.");
      CheckJobGLAcc(JobWIPGLEntry."G/L Bal. Account No.");
      GLAmount := JobWIPGLEntry."WIP Entry Amount";
      IF Reversed THEN
        GLAmount := -GLAmount;

      InsertWIPGL(JobWIPGLEntry."G/L Account No.",JobWIPGLEntry."G/L Bal. Account No.",JnlPostingDate,JnlDocNo,SourceCode,
        GLAmount,JobWIPGLEntry.Description,JobWIPGLEntry."Job No.",JobWIPGLEntry."Dimension Set ID");
    END;

    LOCAL PROCEDURE InsertWIPGL@7(AccNo@1005 : Code[20];BalAccNo@1009 : Code[20];JnlPostingDate@1000 : Date;JnlDocNo@1001 : Code[20];SourceCode@1002 : Code[10];GLAmount@1003 : Decimal;JnlDescription@1010 : Text[50];JobNo@1007 : Code[20];JobWIPGLEntryDimSetID@1008 : Integer);
    VAR
      GenJnlLine@1004 : Record 81;
      GLAcc@1006 : Record 15;
    BEGIN
      GLAcc.GET(AccNo);
      WITH GenJnlLine DO BEGIN
        INIT;
        "Posting Date" := JnlPostingDate;
        "Account No." := AccNo;
        "Bal. Account No." := BalAccNo;
        "Tax Area Code" := GLAcc."Tax Area Code";
        "Tax Liable" := GLAcc."Tax Liable";
        "Tax Group Code" := GLAcc."Tax Group Code";
        Amount := GLAmount;
        "Document No." := JnlDocNo;
        "Source Code" := SourceCode;
        Description := JnlDescription;
        "Job No." := JobNo;
        "System-Created Entry" := TRUE;
        "Dimension Set ID" := JobWIPGLEntryDimSetID;
      END;
      CLEAR(DimMgt);
      DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID",GenJnlLine."Shortcut Dimension 1 Code",
        GenJnlLine."Shortcut Dimension 2 Code");
      GenJnPostLine.RunWithCheck(GenJnlLine);
    END;

    LOCAL PROCEDURE CheckJobGLAcc@9(AccNo@1000 : Code[20]);
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      GLAcc.GET(AccNo);
      GLAcc.CheckGLAcc;
      GLAcc.TESTFIELD("Gen. Posting Type",GLAcc."Gen. Posting Type"::" ");
      GLAcc.TESTFIELD("Gen. Bus. Posting Group",'');
      GLAcc.TESTFIELD("Gen. Prod. Posting Group",'');
      GLAcc.TESTFIELD("VAT Bus. Posting Group",'');
      GLAcc.TESTFIELD("VAT Prod. Posting Group",'');
    END;

    LOCAL PROCEDURE GetGLSetup@12();
    BEGIN
      IF NOT HasGotGLSetup THEN BEGIN
        GLSetup.GET;
        HasGotGLSetup := TRUE;
      END;
    END;

    [External]
    PROCEDURE ReOpenJob@13(JobNo@1000 : Code[20]);
    VAR
      Job@1002 : Record 167;
      JobWIPGLEntry@1001 : Record 1005;
    BEGIN
      Job.GET(JobNo);
      DeleteWIP(Job);
      JobWIPGLEntry.SETCURRENTKEY("Job No.",Reversed,"Job Complete");
      JobWIPGLEntry.SETRANGE("Job No.",JobNo);
      JobWIPGLEntry.MODIFYALL("Job Complete",FALSE);
    END;

    LOCAL PROCEDURE GetRecognizedCostsBalGLAccountNo@47(Job@1002 : Record 167;JobPostingGroup@1000 : Record 208) : Code[20];
    BEGIN
      IF NOT JobComplete OR (Job."WIP Posting Method" = Job."WIP Posting Method"::"Per Job Ledger Entry") THEN
        EXIT(JobPostingGroup.GetWIPCostsAccount);

      EXIT(JobPostingGroup.GetJobCostsAppliedAccount);
    END;

    LOCAL PROCEDURE GetRecognizedSalesBalGLAccountNo@4(Job@1000 : Record 167;JobPostingGroup@1001 : Record 208;JobWIPMethod@1002 : Record 1006) : Code[20];
    BEGIN
      CASE TRUE OF
        NOT JobComplete AND
        (JobWIPMethod."Recognized Sales" = JobWIPMethod."Recognized Sales"::"Percentage of Completion"):
          EXIT(JobPostingGroup.GetWIPAccruedSalesAccount);
        NOT JobComplete OR (Job."WIP Posting Method" = Job."WIP Posting Method"::"Per Job Ledger Entry"):
          EXIT(JobPostingGroup.GetWIPInvoicedSalesAccount);
        ELSE
          EXIT(JobPostingGroup.GetJobSalesAppliedAccount);
      END;
    END;

    LOCAL PROCEDURE GetAppliedCostsWIPEntryAmount@31(JobTask@1000 : Record 1001;JobWIPMethod@1002 : Record 1006;AppliedAccrued@1001 : Boolean) : Decimal;
    BEGIN
      IF AppliedAccrued THEN
        EXIT(JobTask."Usage (Total Cost)" - JobTask."Recognized Costs Amount");

      IF IsAccruedCostsWIPMethod(JobWIPMethod) AND (JobTask."Recognized Costs Amount" <> 0) THEN
        EXIT(-GetMAX(JobTask."Recognized Costs Amount",JobTask."Usage (Total Cost)"));

      EXIT(-JobTask."Usage (Total Cost)");
    END;

    LOCAL PROCEDURE GetAppliedSalesWIPEntryAmount@32(JobTask@1001 : Record 1001;JobWIPMethod@1002 : Record 1006;AppliedAccrued@1000 : Boolean) SalesAmount : Decimal;
    BEGIN
      IF AppliedAccrued THEN BEGIN
        SalesAmount := JobTask."Recognized Sales Amount" - JobTask."Contract (Invoiced Price)";
        IF SalesAmount < 0 THEN
          EXIT(JobTask."Contract (Invoiced Price)");
        EXIT(SalesAmount);
      END;

      IF IsAccruedSalesWIPMethod(JobWIPMethod) THEN
        EXIT(GetMAX(JobTask."Recognized Sales Amount",JobTask."Contract (Invoiced Price)"));

      EXIT(JobTask."Contract (Invoiced Price)");
    END;

    LOCAL PROCEDURE GetAccruedCostsWIPEntryAmount@45(JobTask@1001 : Record 1001;JobWIPMethod@1000 : Record 1006) : Decimal;
    BEGIN
      IF IsAccruedCostsWIPMethod(JobWIPMethod) THEN
        EXIT(JobTask."Recognized Costs Amount" - JobTask."Usage (Total Cost)");
      EXIT(0);
    END;

    LOCAL PROCEDURE GetAccruedSalesWIPEntryAmount@46(JobTask@1001 : Record 1001;JobWIPMethod@1000 : Record 1006) : Decimal;
    BEGIN
      IF IsAccruedSalesWIPMethod(JobWIPMethod) THEN
        EXIT(-JobTask."Recognized Sales Amount" + JobTask."Contract (Invoiced Price)");
      EXIT(0);
    END;

    LOCAL PROCEDURE GetMAX@35(Value1@1000 : Decimal;Value2@1001 : Decimal) : Decimal;
    BEGIN
      IF Value1 > Value2 THEN
        EXIT(Value1);
      EXIT(Value2);
    END;

    LOCAL PROCEDURE IsAccruedCostsWIPMethod@34(JobWIPMethod@1000 : Record 1006) : Boolean;
    BEGIN
      EXIT(
        JobWIPMethod."Recognized Costs" IN
        [JobWIPMethod."Recognized Costs"::"Cost Value",
         JobWIPMethod."Recognized Costs"::"Cost of Sales",
         JobWIPMethod."Recognized Costs"::"Contract (Invoiced Cost)"]);
    END;

    LOCAL PROCEDURE IsAccruedSalesWIPMethod@39(JobWIPMethod@1000 : Record 1006) : Boolean;
    BEGIN
      EXIT(
        JobWIPMethod."Recognized Sales" IN
        [JobWIPMethod."Recognized Sales"::"Sales Value",
         JobWIPMethod."Recognized Sales"::"Usage (Total Price)"]);
    END;

    [EventSubscriber(Table,1001,OnBeforeModifyEvent)]
    PROCEDURE VerifyJobWIPEntryOnBeforeModify@5(VAR Rec@1000 : Record 1001;VAR xRec@1001 : Record 1001;RunTrigger@1002 : Boolean);
    BEGIN
      IF Rec.ISTEMPORARY THEN
        EXIT;

      IF JobTaskWIPRelatedFieldsAreModified(Rec) THEN
        VerifyJobWIPEntryIsEmpty(Rec."Job No.");
    END;

    [EventSubscriber(Table,1001,OnBeforeRenameEvent)]
    PROCEDURE VerifyJobWIPEntryOnBeforeRename@41(VAR Rec@1000 : Record 1001;VAR xRec@1001 : Record 1001;RunTrigger@1002 : Boolean);
    BEGIN
      IF NOT Rec.ISTEMPORARY THEN
        VerifyJobWIPEntryIsEmpty(Rec."Job No.");
    END;

    LOCAL PROCEDURE JobTaskWIPRelatedFieldsAreModified@17(JobTask@1001 : Record 1001) : Boolean;
    VAR
      OldJobTask@1000 : Record 1001;
    BEGIN
      OldJobTask.GET(JobTask."Job No.",JobTask."Job Task No.");
      EXIT(
        (OldJobTask."Job Task Type" <> JobTask."Job Task Type") OR
        (OldJobTask."WIP-Total" <> JobTask."WIP-Total") OR
        (OldJobTask."Job Posting Group" <> JobTask."Job Posting Group") OR
        (OldJobTask."WIP Method" <> JobTask."WIP Method") OR
        (OldJobTask.Totaling <> JobTask.Totaling));
    END;

    LOCAL PROCEDURE VerifyJobWIPEntryIsEmpty@40(JobNo@1001 : Code[20]);
    VAR
      JobWIPEntry@1000 : Record 1004;
      JobTask@1002 : Record 1001;
    BEGIN
      JobWIPEntry.SETRANGE("Job No.",JobNo);
      IF NOT JobWIPEntry.ISEMPTY THEN
        ERROR(CannotModifyAssociatedEntriesErr,JobTask.TABLECAPTION);
    END;

    BEGIN
    END.
  }
}

