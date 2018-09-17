OBJECT Table 1250 Bank Statement Matching Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Matchbuffer til bankkontoudtog;
               ENU=Bank Statement Matching Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 2   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;Quality             ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kvalitet;
                                                              ENU=Quality] }
    { 4   ;   ;Account Type        ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontotype;
                                                              ENU=Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account }
    { 5   ;   ;Account No.         ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 10  ;   ;One to Many Match   ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=En til mange-match;
                                                              ENU=One to Many Match] }
    { 11  ;   ;No. of Entries      ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal poster;
                                                              ENU=No. of Entries] }
    { 12  ;   ;Total Remaining Amount;Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Restbel›b i alt;
                                                              ENU=Total Remaining Amount] }
    { 13  ;   ;Related Party Matched;Option       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Relateret part er matchet;
                                                              ENU=Related Party Matched];
                                                   OptionCaptionML=[DAN=Ikke medregnet,Helt,Delvist,Nej;
                                                                    ENU=Not Considered,Fully,Partially,No];
                                                   OptionString=Not Considered,Fully,Partially,No }
  }
  KEYS
  {
    {    ;Line No.,Entry No.,Account Type,Account No.;
                                                   Clustered=Yes }
    {    ;Quality,No. of Entries                   }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE AddMatchCandidate@18(LineNo@1001 : Integer;EntryNo@1002 : Integer;NewQuality@1003 : Integer;Type@1005 : Option;AccountNo@1006 : Code[20]);
    VAR
      BankStatementMatchingBuffer@1004 : Record 1250;
    BEGIN
      BankStatementMatchingBuffer.INIT;
      BankStatementMatchingBuffer."Line No." := LineNo;
      BankStatementMatchingBuffer."Entry No." := EntryNo;
      BankStatementMatchingBuffer."Account No." := AccountNo;
      BankStatementMatchingBuffer."Account Type" := Type;
      BankStatementMatchingBuffer.Quality := NewQuality;
      IF GET(LineNo,EntryNo,Type,AccountNo) THEN BEGIN
        Rec := BankStatementMatchingBuffer;
        MODIFY
      END ELSE BEGIN
        Rec := BankStatementMatchingBuffer;
        INSERT
      END;
    END;

    [External]
    PROCEDURE InsertOrUpdateOneToManyRule@1(TempLedgerEntryMatchingBuffer@1003 : TEMPORARY Record 1248;LineNo@1004 : Integer;RelatedPartyMatched@1005 : Option;AccountType@1001 : Option;RemainingAmount@1002 : Decimal);
    BEGIN
      INIT;
      SETRANGE("Line No.",LineNo);
      SETRANGE("Account Type",AccountType);
      SETRANGE("Account No.",TempLedgerEntryMatchingBuffer."Account No.");
      SETRANGE("Entry No.",-1);
      SETRANGE("One to Many Match",TRUE);

      IF NOT FINDFIRST THEN BEGIN
        "Line No." := LineNo;
        "Account Type" := AccountType;
        "Account No." := TempLedgerEntryMatchingBuffer."Account No.";
        "Entry No." := -1;
        "One to Many Match" := TRUE;
        "No. of Entries" := 1;
        "Related Party Matched" := RelatedPartyMatched;
        INSERT;
      END ELSE
        "No. of Entries" += 1;

      "Total Remaining Amount" += RemainingAmount;
      MODIFY(TRUE);
    END;

    BEGIN
    END.
  }
}

