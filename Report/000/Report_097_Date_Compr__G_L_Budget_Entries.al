OBJECT Report 97 Date Compr. G/L Budget Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Permissions=TableData 87=rimd;
    CaptionML=[DAN=Datokomprimer fin.budgetposter;
               ENU=Date Compr. G/L Budget Entries];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  DimSelectionBuf.CompareDimText(
                    3,REPORT::"Date Compr. G/L Budget Entries",'',RetainDimText,Text009);
                END;

  }
  DATASET
  {
    { 3459;    ;DataItem;                    ;
               DataItemTable=Table96;
               DataItemTableView=SORTING(Budget Name,G/L Account No.,Date);
               OnPreDataItem=VAR
                               GLSetup@1000 : Record 98;
                             BEGIN
                               IF NOT
                                  CONFIRM(
                                    Text000 +
                                    Text001,FALSE)
                               THEN
                                 CurrReport.BREAK;

                               IF EntrdDateComprReg."Ending Date" = 0D THEN
                                 ERROR(
                                   Text002,
                                   EntrdDateComprReg.FIELDCAPTION("Ending Date"));

                               DateComprReg.INIT;
                               DateComprReg."Creation Date" := TODAY;
                               DateComprReg."Starting Date" := EntrdDateComprReg."Starting Date";
                               DateComprReg."Ending Date" := EntrdDateComprReg."Ending Date";
                               DateComprReg."Period Length" := EntrdDateComprReg."Period Length";
                               DateComprReg."User ID" := USERID;
                               DateComprReg."Table ID" := DATABASE::"G/L Budget Entry";
                               DateComprReg.Filter := COPYSTR(GETFILTERS,1,MAXSTRLEN(DateComprReg.Filter));

                               IF AnalysisView.FINDFIRST THEN BEGIN
                                 AnalysisView.CheckDimensionsAreRetained(3,REPORT::"Date Compr. G/L Budget Entries",TRUE);
                                 AnalysisView.CheckViewsAreUpdated;
                                 COMMIT;
                               END;

                               SelectedDim.GetSelectedDim(
                                 USERID,3,REPORT::"Date Compr. G/L Budget Entries",'',TempSelectedDim);
                               GLSetup.GET;
                               Retain[2] :=
                                 TempSelectedDim.GET(
                                   USERID,3,REPORT::"Date Compr. G/L Budget Entries",'',GLSetup."Global Dimension 1 Code");
                               Retain[3] :=
                                 TempSelectedDim.GET(
                                   USERID,3,REPORT::"Date Compr. G/L Budget Entries",'',GLSetup."Global Dimension 2 Code");

                               GLBudgetEntry2.LOCKTABLE;
                               IF GLBudgetEntry2.FIND('+') THEN;
                               LastEntryNo := GLBudgetEntry2."Entry No.";
                               LowestEntryNo := 2147483647;

                               Window.OPEN(
                                 Text003 +
                                 Text004 +
                                 Text005 +
                                 Text006 +
                                 Text007 +
                                 Text008);

                               SETRANGE("Entry No.",0,LastEntryNo);
                               SETRANGE(Date,EntrdDateComprReg."Starting Date",EntrdDateComprReg."Ending Date");
                             END;

               OnAfterGetRecord=BEGIN
                                  GLBudgetEntry2 := "G/L Budget Entry";
                                  WITH GLBudgetEntry2 DO BEGIN
                                    SETCURRENTKEY("Budget Name","G/L Account No.",Date);
                                    COPYFILTERS("G/L Budget Entry");
                                    SETFILTER(Date,DateComprMgt.GetDateFilter(Date,EntrdDateComprReg,FALSE));
                                    SETRANGE("Budget Name","Budget Name");
                                    SETRANGE("G/L Account No.","G/L Account No.");

                                    LastEntryNo := LastEntryNo + 1;

                                    IF RetainNo(FIELDNO("Business Unit Code")) THEN
                                      SETRANGE("Business Unit Code","Business Unit Code");
                                    IF RetainNo(FIELDNO("Global Dimension 1 Code")) THEN
                                      SETRANGE("Global Dimension 1 Code","Global Dimension 1 Code");
                                    IF RetainNo(FIELDNO("Global Dimension 2 Code")) THEN
                                      SETRANGE("Global Dimension 2 Code","Global Dimension 2 Code");
                                    IF Amount >= 0 THEN
                                      SETFILTER(Amount,'>=0')
                                    ELSE
                                      SETFILTER(Amount,'<0');

                                    InitNewEntry(NewGLBudgetEntry);

                                    DimBufMgt.CollectDimEntryNo(
                                      TempSelectedDim,"Dimension Set ID","Entry No.",0,FALSE,DimEntryNo);
                                    ComprDimEntryNo := DimEntryNo;
                                    SummarizeEntry(NewGLBudgetEntry,GLBudgetEntry2);
                                    WHILE NEXT <> 0 DO BEGIN
                                      DimBufMgt.CollectDimEntryNo(
                                        TempSelectedDim,"Dimension Set ID","Entry No.",ComprDimEntryNo,TRUE,DimEntryNo);
                                      IF DimEntryNo = ComprDimEntryNo THEN
                                        SummarizeEntry(NewGLBudgetEntry,GLBudgetEntry2);
                                    END;

                                    InsertNewEntry(NewGLBudgetEntry,ComprDimEntryNo);

                                    ComprCollectedEntries;
                                  END;

                                  IF DateComprReg."No. Records Deleted" >= NoOfDeleted + 10 THEN BEGIN
                                    NoOfDeleted := DateComprReg."No. Records Deleted";
                                    InsertRegister;
                                    COMMIT;
                                    GLBudgetEntry2.LOCKTABLE;
                                    GLBudgetEntry2.RESET;
                                    IF GLBudgetEntry2.FIND('+') THEN;
                                    LastEntryNo := GLBudgetEntry2."Entry No.";
                                  END;
                                END;

               OnPostDataItem=VAR
                                UpdateAnalysisView@1000 : Codeunit 410;
                              BEGIN
                                InsertRegister;
                                IF AnalysisView.FINDFIRST THEN
                                  IF LowestEntryNo < 2147483647 THEN
                                    UpdateAnalysisView.SetLastBudgetEntryNo(LowestEntryNo - 1);
                              END;

               ReqFilterFields=Budget Name,G/L Account No. }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   InitializeParameter;
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Startdato;
                             ENU=Starting Date];
                  ToolTipML=[DAN=Angiver den dato, som rapporten eller k�rslen behandler oplysninger fra.;
                             ENU=Specifies the date from which the report or batch job processes information.];
                  ApplicationArea=#Suite;
                  ClosingDates=Yes;
                  SourceExpr=EntrdDateComprReg."Starting Date" }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Slutdato;
                             ENU=Ending Date];
                  ToolTipML=[DAN=Angiver den dato, som rapporten eller k�rslen behandler oplysninger frem til.;
                             ENU=Specifies the date to which the report or batch job processes information.];
                  ApplicationArea=#Suite;
                  ClosingDates=Yes;
                  SourceExpr=EntrdDateComprReg."Ending Date" }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Periodel�ngde;
                             ENU=Period Length];
                  ToolTipML=[DAN=Angiver den periode, der vises data for i rapporten. Angiv f.eks. "1M" for �n m�ned, "30D" for 30 dage, "3K" for tre kvartaler eller "5�" for fem �r.;
                             ENU=Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.];
                  OptionCaptionML=[DAN=Dag,Uge,M�ned,Kvartal,�r,Regnskabsperiode;
                                   ENU=Day,Week,Month,Quarter,Year,Period];
                  ApplicationArea=#Suite;
                  SourceExpr=EntrdDateComprReg."Period Length" }

      { 4   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf�ringsbeskrivelse;
                             ENU=Posting Description];
                  ToolTipML=[DAN=Angiver en beskrivelse af de poster, der oprettes som f�lge af komprimeringen. Standardbeskrivelsen er Datokomprimeret.;
                             ENU=Specifies a text that accompanies the entries that result from the compression. The default description is Date Compressed.];
                  ApplicationArea=#Suite;
                  SourceExpr=EntrdGLBudgetEntry.Description }

      { 1907651001;2;Group  ;
                  CaptionML=[DAN=Bevar feltindhold;
                             ENU=Retain Field Contents] }

      { 5   ;3   ;Field     ;
                  CaptionML=[DAN=Konc.virksomhedskode;
                             ENU=Business Unit Code];
                  ToolTipML=[DAN=Angiver koden for koncernvirksomheden i en virksomhedsstruktur.;
                             ENU=Specifies the code for the business unit, in a company group structure.];
                  ApplicationArea=#Advanced;
                  SourceExpr=Retain[1] }

      { 6   ;2   ;Field     ;
                  CaptionML=[DAN=Bevar dimensioner;
                             ENU=Retain Dimensions];
                  ToolTipML=[DAN=Angiver, hvilke dimensionsoplysninger du vil bevare, n�r posterne komprimeres. Jo flere dimensionsoplysninger du angiver, desto mere detaljerede er de komprimerede poster.;
                             ENU=Specifies which dimension information you want to retain when the entries are compressed. The more dimension information that you choose to retain, the more detailed the compressed entries are.];
                  ApplicationArea=#Suite;
                  SourceExpr=RetainDimText;
                  Editable=FALSE;
                  OnAssistEdit=BEGIN
                                 DimSelectionBuf.SetDimSelectionMultiple(3,REPORT::"Date Compr. G/L Budget Entries",RetainDimText);
                               END;
                                }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Denne k�rsel sletter poster.\\;ENU=This batch job deletes entries.\\';
      Text001@1001 : TextConst 'DAN=Skal posterne datokomprimeres?;ENU=Do you want to date compress the entries?';
      Text002@1002 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be specified.';
      Text003@1003 : TextConst 'DAN=Finansbudgetposter datokomprimeres...\\;ENU=Date compressing G/L budget entries...\\';
      Text004@1004 : TextConst 'DAN=Budgetnavn           #1##########\;ENU=Budget Name          #1##########\';
      Text005@1005 : TextConst 'DAN=Finanskontonr.       #2##########\;ENU=G/L Account No.      #2##########\';
      Text006@1006 : TextConst 'DAN=Dato                 #3######\\;ENU=Date                 #3######\\';
      Text007@1007 : TextConst 'DAN=Antal nye poster     #4######\;ENU=No. of new entries   #4######\';
      Text008@1008 : TextConst 'DAN=Antal slet. poster   #5######;ENU=No. of entries del.  #5######';
      Text009@1009 : TextConst 'DAN=Bevar dimensioner;ENU=Retain Dimensions';
      DateComprReg@1010 : Record 87;
      EntrdDateComprReg@1011 : Record 87;
      EntrdGLBudgetEntry@1012 : Record 96;
      NewGLBudgetEntry@1013 : Record 96;
      GLBudgetEntry2@1014 : Record 96;
      SelectedDim@1015 : Record 369;
      TempSelectedDim@1016 : TEMPORARY Record 369;
      DimSelectionBuf@1017 : Record 368;
      AnalysisView@1018 : Record 363;
      DateComprMgt@1019 : Codeunit 356;
      DimBufMgt@1020 : Codeunit 411;
      DimMgt@1021 : Codeunit 408;
      Window@1022 : Dialog;
      NoOfFields@1023 : Integer;
      Retain@1024 : ARRAY [10] OF Boolean;
      FieldNumber@1025 : ARRAY [10] OF Integer;
      LastEntryNo@1027 : Integer;
      LowestEntryNo@1028 : Integer;
      NoOfDeleted@1029 : Integer;
      i@1030 : Integer;
      ComprDimEntryNo@1031 : Integer;
      DimEntryNo@1032 : Integer;
      RetainDimText@1033 : Text[250];
      RegExists@1034 : Boolean;

    LOCAL PROCEDURE InsertField@2(Number@1000 : Integer);
    BEGIN
      NoOfFields := NoOfFields + 1;
      FieldNumber[NoOfFields] := Number;
    END;

    LOCAL PROCEDURE RetainNo@3(Number@1000 : Integer) : Boolean;
    BEGIN
      EXIT(Retain[Index(Number)]);
    END;

    LOCAL PROCEDURE Index@6(Number@1000 : Integer) : Integer;
    BEGIN
      FOR i := 1 TO NoOfFields DO
        IF Number = FieldNumber[i] THEN
          EXIT(i);
    END;

    LOCAL PROCEDURE SummarizeEntry@5(VAR NewGLBudgetEntry@1000 : Record 96;GLBudgetEntry@1001 : Record 96);
    BEGIN
      WITH GLBudgetEntry DO BEGIN
        NewGLBudgetEntry.Amount := NewGLBudgetEntry.Amount + Amount;
        DELETE;
        IF "Entry No." < LowestEntryNo THEN
          LowestEntryNo := "Entry No.";
        DateComprReg."No. Records Deleted" := DateComprReg."No. Records Deleted" + 1;
        Window.UPDATE(5,DateComprReg."No. Records Deleted");
      END;
    END;

    [External]
    PROCEDURE ComprCollectedEntries@12();
    VAR
      GLBudgetEntry@1000 : Record 96;
      OldDimEntryNo@1001 : Integer;
      Found@1002 : Boolean;
      GLBudgetEntryNo@1003 : Integer;
    BEGIN
      OldDimEntryNo := 0;
      IF DimBufMgt.FindFirstDimEntryNo(DimEntryNo,GLBudgetEntryNo) THEN BEGIN
        InitNewEntry(NewGLBudgetEntry);
        REPEAT
          GLBudgetEntry.GET(GLBudgetEntryNo);
          SummarizeEntry(NewGLBudgetEntry,GLBudgetEntry);
          OldDimEntryNo := DimEntryNo;
          Found := DimBufMgt.NextDimEntryNo(DimEntryNo,GLBudgetEntryNo);
          IF (OldDimEntryNo <> DimEntryNo) OR NOT Found THEN BEGIN
            InsertNewEntry(NewGLBudgetEntry,OldDimEntryNo);
            IF Found THEN
              InitNewEntry(NewGLBudgetEntry);
          END;
          OldDimEntryNo := DimEntryNo;
        UNTIL NOT Found;
      END;
      DimBufMgt.DeleteAllDimEntryNo;
    END;

    [External]
    PROCEDURE InitNewEntry@7(VAR NewGLBudgetEntry@1000 : Record 96);
    BEGIN
      LastEntryNo := LastEntryNo + 1;

      WITH GLBudgetEntry2 DO BEGIN
        NewGLBudgetEntry.INIT;
        NewGLBudgetEntry."Entry No." := LastEntryNo;
        NewGLBudgetEntry."Budget Name" := "Budget Name";
        NewGLBudgetEntry."G/L Account No." := "G/L Account No.";
        NewGLBudgetEntry.Date := GETRANGEMIN(Date);
        NewGLBudgetEntry.Description := EntrdGLBudgetEntry.Description;
        NewGLBudgetEntry."User ID" := USERID;

        IF RetainNo(FIELDNO("Business Unit Code")) THEN
          NewGLBudgetEntry."Business Unit Code" := "Business Unit Code";
        IF RetainNo(FIELDNO("Global Dimension 1 Code")) THEN
          NewGLBudgetEntry."Global Dimension 1 Code" := "Global Dimension 1 Code";
        IF RetainNo(FIELDNO("Global Dimension 2 Code")) THEN
          NewGLBudgetEntry."Global Dimension 2 Code" := "Global Dimension 2 Code";

        Window.UPDATE(1,NewGLBudgetEntry."Budget Name");
        Window.UPDATE(2,NewGLBudgetEntry."G/L Account No.");
        Window.UPDATE(3,NewGLBudgetEntry.Date);
        DateComprReg."No. of New Records" := DateComprReg."No. of New Records" + 1;
        Window.UPDATE(4,DateComprReg."No. of New Records");
      END;
    END;

    LOCAL PROCEDURE InsertNewEntry@23(VAR NewGLBudgetEntry@1000 : Record 96;DimEntryNo@1001 : Integer);
    VAR
      TempDimBuf@1002 : TEMPORARY Record 360;
      TempDimSetEntry@1005 : TEMPORARY Record 480;
    BEGIN
      TempDimBuf.DELETEALL;
      DimBufMgt.GetDimensions(DimEntryNo,TempDimBuf);
      DimMgt.CopyDimBufToDimSetEntry(TempDimBuf,TempDimSetEntry);
      NewGLBudgetEntry."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
      NewGLBudgetEntry.INSERT;
    END;

    LOCAL PROCEDURE InsertRegister@1();
    VAR
      DateComprReg2@1000 : Record 87;
    BEGIN
      IF RegExists THEN
        DateComprReg.MODIFY
      ELSE BEGIN
        DateComprReg2.LOCKTABLE;
        IF DateComprReg2.FINDLAST THEN;
        DateComprReg."No." := DateComprReg2."No." + 1;
        DateComprReg.INSERT;
        RegExists := TRUE;
      END;
    END;

    LOCAL PROCEDURE InitializeParameter@9();
    BEGIN
      IF EntrdDateComprReg."Ending Date" = 0D THEN
        EntrdDateComprReg."Ending Date" := TODAY;

      WITH "G/L Budget Entry" DO BEGIN
        InsertField(FIELDNO("Business Unit Code"));
        InsertField(FIELDNO("Global Dimension 1 Code"));
        InsertField(FIELDNO("Global Dimension 2 Code"));
      END;

      RetainDimText := DimSelectionBuf.GetDimSelectionText(3,REPORT::"Date Compr. G/L Budget Entries",'');
    END;

    [External]
    PROCEDURE InitializeRequest@4(StartingDate@1009 : Date;EndingDate@1008 : Date;PeriodLength@1007 : Option;Description@1006 : Text[50];RetainBusinessUnitCode@1005 : Boolean;RetainDimensionText@1000 : Text[250]);
    BEGIN
      InitializeParameter;
      EntrdDateComprReg."Starting Date" := StartingDate;
      EntrdDateComprReg."Ending Date" := EndingDate;
      EntrdDateComprReg."Period Length" := PeriodLength;
      EntrdGLBudgetEntry.Description := Description;
      Retain[1] := RetainBusinessUnitCode;
      RetainDimText := RetainDimensionText;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

