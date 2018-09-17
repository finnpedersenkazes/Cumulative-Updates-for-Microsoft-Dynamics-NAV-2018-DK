OBJECT Report 1496 Suggest Bank Acc. Recon. Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Foresl† bankkto.afstemn.linjer;
               ENU=Suggest Bank Acc. Recon. Lines];
    ProcessingOnly=Yes;
  }
  DATASET
  {
    { 4558;    ;DataItem;                    ;
               DataItemTable=Table270;
               DataItemTableView=SORTING(No.);
               OnPreDataItem=BEGIN
                               OnPreDataItem(ExcludeReversedEntries);

                               IF EndDate = 0D THEN
                                 ERROR(Text000);

                               BankAccReconLine.FilterBankRecLines(BankAccRecon);
                               IF NOT BankAccReconLine.FINDLAST THEN BEGIN
                                 BankAccReconLine."Statement Type" := BankAccRecon."Statement Type";
                                 BankAccReconLine."Bank Account No." := BankAccRecon."Bank Account No.";
                                 BankAccReconLine."Statement No." := BankAccRecon."Statement No.";
                                 BankAccReconLine."Statement Line No." := 0;
                               END;

                               SETRANGE("No.",BankAccRecon."Bank Account No.");
                             END;

               OnAfterGetRecord=BEGIN
                                  BankAccLedgEntry.RESET;
                                  BankAccLedgEntry.SETCURRENTKEY("Bank Account No.","Posting Date");
                                  BankAccLedgEntry.SETRANGE("Bank Account No.","No.");
                                  BankAccLedgEntry.SETRANGE("Posting Date",StartDate,EndDate);
                                  BankAccLedgEntry.SETRANGE(Open,TRUE);
                                  BankAccLedgEntry.SETRANGE("Statement Status",BankAccLedgEntry."Statement Status"::Open);
                                  IF ExcludeReversedEntries THEN
                                    BankAccLedgEntry.SETRANGE(Reversed,FALSE);
                                  EOFBankAccLedgEntries := NOT BankAccLedgEntry.FIND('-');

                                  IF IncludeChecks THEN BEGIN
                                    CheckLedgEntry.RESET;
                                    CheckLedgEntry.SETCURRENTKEY("Bank Account No.","Check Date");
                                    CheckLedgEntry.SETRANGE("Bank Account No.","No.");
                                    CheckLedgEntry.SETRANGE("Check Date",StartDate,EndDate);
                                    CheckLedgEntry.SETFILTER(
                                      "Entry Status",'%1|%2',CheckLedgEntry."Entry Status"::Posted,
                                      CheckLedgEntry."Entry Status"::"Financially Voided");
                                    CheckLedgEntry.SETRANGE(Open,TRUE);
                                    CheckLedgEntry.SETRANGE("Statement Status",BankAccLedgEntry."Statement Status"::Open);
                                    EOFCheckLedgEntries := NOT CheckLedgEntry.FIND('-');
                                  END;

                                  WHILE (NOT EOFBankAccLedgEntries) OR (IncludeChecks AND (NOT EOFCheckLedgEntries)) DO
                                    CASE TRUE OF
                                      NOT IncludeChecks:
                                        BEGIN
                                          EnterBankAccLine(BankAccLedgEntry);
                                          EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                                        END;
                                      (NOT EOFBankAccLedgEntries) AND (NOT EOFCheckLedgEntries) AND
                                      (BankAccLedgEntry."Posting Date" <= CheckLedgEntry."Check Date"):
                                        BEGIN
                                          CheckLedgEntry2.RESET;
                                          CheckLedgEntry2.SETCURRENTKEY("Bank Account Ledger Entry No.");
                                          CheckLedgEntry2.SETRANGE("Bank Account Ledger Entry No.",BankAccLedgEntry."Entry No.");
                                          CheckLedgEntry2.SETRANGE(Open,TRUE);
                                          IF NOT CheckLedgEntry2.FINDFIRST THEN
                                            EnterBankAccLine(BankAccLedgEntry);
                                          EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                                        END;
                                      (NOT EOFBankAccLedgEntries) AND (NOT EOFCheckLedgEntries) AND
                                      (BankAccLedgEntry."Posting Date" > CheckLedgEntry."Check Date"):
                                        BEGIN
                                          EnterCheckLine(CheckLedgEntry);
                                          EOFCheckLedgEntries := CheckLedgEntry.NEXT = 0;
                                        END;
                                      (NOT EOFBankAccLedgEntries) AND EOFCheckLedgEntries:
                                        BEGIN
                                          CheckLedgEntry2.RESET;
                                          CheckLedgEntry2.SETCURRENTKEY("Bank Account Ledger Entry No.");
                                          CheckLedgEntry2.SETRANGE("Bank Account Ledger Entry No.",BankAccLedgEntry."Entry No.");
                                          CheckLedgEntry2.SETRANGE(Open,TRUE);
                                          IF NOT CheckLedgEntry2.FINDFIRST THEN
                                            EnterBankAccLine(BankAccLedgEntry);
                                          EOFBankAccLedgEntries := BankAccLedgEntry.NEXT = 0;
                                        END;
                                      EOFBankAccLedgEntries AND (NOT EOFCheckLedgEntries):
                                        BEGIN
                                          EnterCheckLine(CheckLedgEntry);
                                          EOFCheckLedgEntries := CheckLedgEntry.NEXT = 0;
                                        END;
                                    END;
                                END;
                                 }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 5   ;2   ;Group     ;
                  CaptionML=[DAN=Kontoudtogsperiode;
                             ENU=Statement Period] }

      { 1   ;3   ;Field     ;
                  Name=StartingDate;
                  CaptionML=[DAN=Startdato;
                             ENU=Starting Date];
                  ToolTipML=[DAN=Angiver den dato, som rapporten eller k›rslen behandler oplysninger fra.;
                             ENU=Specifies the date from which the report or batch job processes information.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=StartDate }

      { 3   ;3   ;Field     ;
                  Name=EndingDate;
                  CaptionML=[DAN=Slutdato;
                             ENU=Ending Date];
                  ToolTipML=[DAN=Angiver den dato, som rapporten eller k›rslen behandler oplysninger frem til.;
                             ENU=Specifies the date to which the report or batch job processes information.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=EndDate }

      { 8   ;2   ;Field     ;
                  CaptionML=[DAN=Medtag check;
                             ENU=Include Checks];
                  ToolTipML=[DAN=Angiver, om du vil inkludere checkposter i rapporten. Hvis du v‘lger denne mulighed, vil der automatisk blive foresl†et checkposter i stedet for de tilsvarende bankkontoposter.;
                             ENU=Specifies if you want the report to include check ledger entries. If you choose this option, check ledger entries are suggested instead of the corresponding bank account ledger entries.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=IncludeChecks }

      { 2   ;2   ;Field     ;
                  Name=ExcludeReversedEntries;
                  CaptionML=[DAN=Udelad tilbagef›rte poster;
                             ENU=Exclude Reversed Entries];
                  ToolTipML=[DAN=Angiver, om du vil udelade tilbagef›rte poster fra rapporten.;
                             ENU=Specifies if you want to exclude reversed entries from the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ExcludeReversedEntries }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Angiv slutdatoen.;ENU=Enter the Ending Date.';
      BankAccLedgEntry@1001 : Record 271;
      CheckLedgEntry@1002 : Record 272;
      CheckLedgEntry2@1003 : Record 272;
      BankAccRecon@1004 : Record 273;
      BankAccReconLine@1005 : Record 274;
      BankAccSetStmtNo@1006 : Codeunit 375;
      CheckSetStmtNo@1007 : Codeunit 376;
      StartDate@1008 : Date;
      EndDate@1009 : Date;
      IncludeChecks@1010 : Boolean;
      EOFBankAccLedgEntries@1011 : Boolean;
      EOFCheckLedgEntries@1012 : Boolean;
      ExcludeReversedEntries@1013 : Boolean;

    PROCEDURE SetStmt@1(VAR BankAccRecon2@1000 : Record 273);
    BEGIN
      BankAccRecon := BankAccRecon2;
      EndDate := BankAccRecon."Statement Date";
    END;

    LOCAL PROCEDURE EnterBankAccLine@2(VAR BankAccLedgEntry2@1000 : Record 271);
    BEGIN
      BankAccReconLine.INIT;
      BankAccReconLine."Statement Line No." := BankAccReconLine."Statement Line No." + 10000;
      BankAccReconLine."Transaction Date" := BankAccLedgEntry2."Posting Date";
      BankAccReconLine.Description := BankAccLedgEntry2.Description;
      BankAccReconLine."Document No." := BankAccLedgEntry2."Document No.";
      BankAccReconLine."Statement Amount" := BankAccLedgEntry2."Remaining Amount";
      BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
      BankAccReconLine.Type := BankAccReconLine.Type::"Bank Account Ledger Entry";
      BankAccReconLine."Applied Entries" := 1;
      BankAccSetStmtNo.SetReconNo(BankAccLedgEntry2,BankAccReconLine);
      BankAccReconLine.INSERT;
    END;

    LOCAL PROCEDURE EnterCheckLine@3(VAR CheckLedgEntry3@1000 : Record 272);
    BEGIN
      BankAccReconLine.INIT;
      BankAccReconLine."Statement Line No." := BankAccReconLine."Statement Line No." + 10000;
      BankAccReconLine."Transaction Date" := CheckLedgEntry3."Check Date";
      BankAccReconLine.Description := CheckLedgEntry3.Description;
      BankAccReconLine."Statement Amount" := -CheckLedgEntry3.Amount;
      BankAccReconLine."Applied Amount" := BankAccReconLine."Statement Amount";
      BankAccReconLine.Type := BankAccReconLine.Type::"Check Ledger Entry";
      BankAccReconLine."Check No." := CheckLedgEntry3."Check No.";
      BankAccReconLine."Applied Entries" := 1;
      CheckSetStmtNo.SetReconNo(CheckLedgEntry3,BankAccReconLine);
      BankAccReconLine.INSERT;
    END;

    PROCEDURE InitializeRequest@4(NewStartDate@1000 : Date;NewEndDate@1001 : Date;NewIncludeChecks@1002 : Boolean);
    BEGIN
      StartDate := NewStartDate;
      EndDate := NewEndDate;
      IncludeChecks := NewIncludeChecks;
      ExcludeReversedEntries := FALSE;
    END;

    [Integration]
    PROCEDURE OnPreDataItem@5(VAR ExcludeReversedEntries@1000 : Boolean);
    BEGIN
      // ExcludeReversedEntries = FALSE by default
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

