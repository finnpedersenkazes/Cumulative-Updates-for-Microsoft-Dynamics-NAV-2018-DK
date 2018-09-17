OBJECT Report 6032 Post Prepaid Contract Entries
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 5907=rm;
    CaptionML=[DAN=Bogf�r forudbet. kontraktposter;
               ENU=Post Prepaid Contract Entries];
    ProcessingOnly=Yes;
    OnInitReport=BEGIN
                   PostingDate := WORKDATE;
                   CLEAR(GenJnlPostLine);
                 END;

    OnPostReport=BEGIN
                   IF PostPrepaidContracts = PostPrepaidContracts::"Post Prepaid Transactions" THEN
                     Window.CLOSE;
                 END;

  }
  DATASET
  {
    { 1141;    ;DataItem;                    ;
               DataItemTable=Table5907;
               DataItemTableView=SORTING(Service Contract No.)
                                 WHERE(Type=CONST(Service Contract),
                                       Moved from Prepaid Acc.=CONST(No),
                                       Open=CONST(No));
               OnPreDataItem=BEGIN
                               IF PostPrepaidContracts = PostPrepaidContracts::"Print Only" THEN BEGIN
                                 CLEAR(PrepaidContractEntriesTest);
                                 PrepaidContractEntriesTest.InitVariables(UntilDate,PostingDate);
                                 PrepaidContractEntriesTest.SETTABLEVIEW("Service Ledger Entry");
                                 PrepaidContractEntriesTest.RUNMODAL;
                                 CurrReport.BREAK;
                               END;

                               IF PostPrepaidContracts = PostPrepaidContracts::"Post Prepaid Transactions" THEN BEGIN
                                 ServContractHdr.SETFILTER("Contract No.",GETFILTER("Service Contract No."));
                                 IF ServContractHdr.FIND('-') THEN BEGIN
                                   REPEAT
                                     ServContractHdr.CALCFIELDS("No. of Unposted Credit Memos");
                                     IF ServContractHdr."No. of Unposted Credit Memos" <> 0 THEN
                                       ERROR(Text005,Text007,Text008,ServContractHdr."Contract No.",Text006);
                                   UNTIL ServContractHdr.NEXT = 0;
                                 END;
                               END;

                               LastContract := '';
                               IF UntilDate = 0D THEN
                                 ERROR(Text000);
                               IF PostingDate = 0D THEN
                                 ERROR(Text001);

                               SETRANGE("Posting Date",0D,UntilDate);

                               NoOfContracts := COUNT;

                               Window.OPEN(
                                 Text002 +
                                 Text003 +
                                 '@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                               ServMgtSetup.GET;
                               ServMgtSetup.TESTFIELD("Prepaid Posting Document Nos.");
                               SourceCodeSetup.GET;
                               SourceCodeSetup.TESTFIELD("Service Management");
                               SalesSetup.GET;
                             END;

               OnAfterGetRecord=BEGIN
                                  Counter := Counter + 1;
                                  Window.UPDATE(1,"Service Contract No.");
                                  Window.UPDATE(2,ROUND(Counter / NoOfContracts * 10000,1));

                                  ServLedgEntry.GET("Entry No.");
                                  ServLedgEntry."Moved from Prepaid Acc." := TRUE;
                                  ServLedgEntry.MODIFY;

                                  IF NOT (LastContract IN ['',"Service Contract No."]) THEN BEGIN
                                    TempServLedgEntry.RESET;
                                    TempServLedgEntry.SETRANGE("Service Contract No.",LastContract);
                                    TempServLedgEntry.CALCSUMS("Amount (LCY)");
                                    IF TempServLedgEntry."Amount (LCY)" <> 0 THEN
                                      PostGenJnlLine
                                    ELSE
                                      TempServLedgEntry.DELETEALL;
                                    TempServLedgEntry.SETRANGE("Service Contract No.","Service Contract No.");
                                  END;

                                  LastContract := "Service Contract No.";

                                  IF SalesSetup."Discount Posting" IN
                                     [SalesSetup."Discount Posting"::"Line Discounts",SalesSetup."Discount Posting"::"All Discounts"]
                                  THEN
                                    AmtInclDisc := ROUND(("Amount (LCY)" / (1 - ("Discount %" / 100))))
                                  ELSE
                                    AmtInclDisc := "Amount (LCY)";

                                  TempServLedgEntry.SETRANGE("Dimension Set ID","Dimension Set ID");
                                  IF TempServLedgEntry.FINDFIRST THEN BEGIN
                                    TempServLedgEntry."Amount (LCY)" += AmtInclDisc;
                                    TempServLedgEntry.MODIFY;
                                  END ELSE BEGIN
                                    TempServLedgEntry := "Service Ledger Entry";
                                    TempServLedgEntry."Amount (LCY)" := AmtInclDisc;
                                    TempServLedgEntry.INSERT;
                                  END;
                                END;

               OnPostDataItem=VAR
                                UpdateAnalysisView@1000 : Codeunit 410;
                              BEGIN
                                IF PostPrepaidContracts = PostPrepaidContracts::"Post Prepaid Transactions" THEN BEGIN
                                  TempServLedgEntry.SETRANGE("Dimension Set ID");
                                  TempServLedgEntry.CALCSUMS("Amount (LCY)");
                                  IF TempServLedgEntry."Amount (LCY)" <> 0 THEN BEGIN
                                    PostGenJnlLine;
                                    UpdateAnalysisView.UpdateAll(0,TRUE);
                                  END;
                                END;
                              END;

               ReqFilterFields=Service Contract No. }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf�r indtil dato;
                             ENU=Post until Date];
                  ToolTipML=[DAN=Angiver den dato, indtil hvilken du vil bogf�re forudbetalte poster. K�rslen omfatter de serviceposter, hvor bogf�ringsdatoen er p� eller inden denne dato.;
                             ENU=Specifies the date up to which you want to post prepaid entries. The batch job includes service ledger entries with posting dates on or before this date.];
                  ApplicationArea=#Service;
                  SourceExpr=UntilDate;
                  MultiLine=Yes }

      { 4   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf�ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver den dato, du vil bruge som bogf�ringsdato p� serviceposterne.;
                             ENU=Specifies the date that you want to use as the posting date on the service ledger entries.];
                  ApplicationArea=#Service;
                  SourceExpr=PostingDate;
                  MultiLine=Yes }

      { 5   ;2   ;Field     ;
                  CaptionML=[DAN=Handling;
                             ENU=Action];
                  ToolTipML=[DAN=Angiver den �nskede handling til forudbetalte kontraktposter.;
                             ENU=Specifies the desired action relating to prepaid contract entries.];
                  OptionCaptionML=[DAN=Bogf�r forudbet. transaktioner,Kun udskrift;
                                   ENU=Post Prepaid Transactions,Print Only];
                  ApplicationArea=#Service;
                  SourceExpr=PostPrepaidContracts }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Feltet Bogf�r indtil dato skal udfyldes.;ENU=You must fill in the Post Until Date field.';
      Text001@1001 : TextConst 'DAN=Feltet Bogf�ringsdato skal udfyldes.;ENU=You must fill in the Posting Date field.';
      Text002@1002 : TextConst 'DAN=Bogf�rer forudbetalte kontraktposter...\;ENU=Posting prepaid contract entries...\';
      Text003@1003 : TextConst 'DAN=Servicekontrakt:  #1###############\\;ENU=Service Contract: #1###############\\';
      Text004@1004 : TextConst 'DAN=Servicekontrakt;ENU=Service Contract';
      GenJnlLine@1005 : Record 81;
      ServLedgEntry@1006 : Record 5907;
      TempServLedgEntry@1011 : TEMPORARY Record 5907;
      ServContractAccGr@1028 : Record 5973;
      ServMgtSetup@1008 : Record 5911;
      SourceCodeSetup@1009 : Record 242;
      ServContractHdr@1029 : Record 5965;
      SalesSetup@1010 : Record 311;
      PrepaidContractEntriesTest@1007 : Report 5986;
      NoSeriesMgt@1012 : Codeunit 396;
      GenJnlPostLine@1014 : Codeunit 12;
      Window@1015 : Dialog;
      PostPrepaidContracts@1016 : 'Post Prepaid Transactions,Print Only';
      DocNo@1017 : Code[20];
      UntilDate@1019 : Date;
      PostingDate@1020 : Date;
      NoOfContracts@1021 : Integer;
      Counter@1022 : Integer;
      AmtInclDisc@1023 : Decimal;
      LastContract@1024 : Code[20];
      Text005@1030 : TextConst 'DAN=Du kan ikke bogf�re %1, fordi %2 %3 har tilknyttet mindst �n %4.;ENU=You cannot post %1 because %2 %3 has at least one %4 linked to it.';
      Text006@1102601000 : TextConst 'DAN=Ikke-bogf�rt kreditnota;ENU=Unposted Credit Memo';
      Text007@1102601001 : TextConst 'DAN=Forudbetalte kontraktposter;ENU=Prepaid Contract Entries';
      Text008@1102601002 : TextConst 'DAN=Servicekontrakt;ENU=Service Contract';

    LOCAL PROCEDURE PostGenJnlLine@1();
    BEGIN
      TempServLedgEntry.RESET;
      IF NOT TempServLedgEntry.FINDSET THEN
        EXIT;

      DocNo := NoSeriesMgt.GetNextNo(ServMgtSetup."Prepaid Posting Document Nos.",WORKDATE,TRUE);

      REPEAT
        GenJnlLine.RESET;
        GenJnlLine.INIT;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
        ServContractAccGr.GET(TempServLedgEntry."Serv. Contract Acc. Gr. Code");
        ServContractAccGr.TESTFIELD("Non-Prepaid Contract Acc.");
        GenJnlLine.VALIDATE("Account No.",ServContractAccGr."Non-Prepaid Contract Acc.");
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine.Description := Text004;
        GenJnlLine."External Document No." := TempServLedgEntry."Service Contract No.";
        GenJnlLine.VALIDATE(Amount,TempServLedgEntry."Amount (LCY)");
        GenJnlLine."Shortcut Dimension 1 Code" := TempServLedgEntry."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := TempServLedgEntry."Global Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := TempServLedgEntry."Dimension Set ID";
        GenJnlLine."Source Code" := SourceCodeSetup."Service Management";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlPostLine.RUN(GenJnlLine);

        ServContractAccGr.GET(TempServLedgEntry."Serv. Contract Acc. Gr. Code");
        ServContractAccGr.TESTFIELD("Prepaid Contract Acc.");
        GenJnlLine.VALIDATE("Account No.",ServContractAccGr."Prepaid Contract Acc.");
        GenJnlLine.VALIDATE(Amount,-TempServLedgEntry."Amount (LCY)");
        GenJnlLine."Shortcut Dimension 1 Code" := TempServLedgEntry."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := TempServLedgEntry."Global Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := TempServLedgEntry."Dimension Set ID";
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine."Gen. Bus. Posting Group" := '';
        GenJnlLine."Gen. Prod. Posting Group" := '';
        GenJnlLine."VAT Bus. Posting Group" := '';
        GenJnlLine."VAT Prod. Posting Group" := '';
        GenJnlPostLine.RUN(GenJnlLine);
      UNTIL TempServLedgEntry.NEXT = 0;

      TempServLedgEntry.RESET;
      TempServLedgEntry.DELETEALL;
    END;

    PROCEDURE InitializeRequest@2(UntilDateFrom@1000 : Date;PostingDateFrom@1001 : Date;PostPrepaidContractsFrom@1002 : 'Post Prepaid Transactions,Print Only');
    BEGIN
      UntilDate := UntilDateFrom;
      PostingDate := PostingDateFrom;
      PostPrepaidContracts := PostPrepaidContractsFrom;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

