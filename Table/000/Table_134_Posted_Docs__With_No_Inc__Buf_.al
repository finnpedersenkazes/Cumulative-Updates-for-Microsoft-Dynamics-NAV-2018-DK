OBJECT Table 134 Posted Docs. With No Inc. Buf.
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf�rte dokumenter med nummer - indg�ende buffer;
               ENU=Posted Docs. With No Inc. Buf.];
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 2   ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 3   ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 4   ;   ;First Posting Description;Text50   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse af f�rste bogf�ring;
                                                              ENU=First Posting Description] }
    { 5   ;   ;Incoming Document No.;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Incoming Document"."Entry No." WHERE (Document No.=FIELD(Document No.),
                                                                                                             Posting Date=FIELD(Posting Date)));
                                                   CaptionML=[DAN=Indg�ende bilagsnr.;
                                                              ENU=Incoming Document No.] }
    { 8   ;   ;External Document No.;Code35       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 9   ;   ;Debit Amount        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debetbel�b;
                                                              ENU=Debit Amount] }
    { 10  ;   ;Credit Amount       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditbel�b;
                                                              ENU=Credit Amount] }
    { 11  ;   ;G/L Account No. Filter;Code20      ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter for finanskontonr.;
                                                              ENU=G/L Account No. Filter] }
  }
  KEYS
  {
    {    ;Line No.                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      OnlyFirst1000Msg@1000 : TextConst 'DAN=Der er mere end 1.000 dokumentnumre i filteret. Kun de f�rste 1.000 vises. Begr�ns filteret for at hente f�rre dokumentnumre.;ENU=There are more than 1000 document numbers within the filter. Only the first 1000 are shown. Narrow your filter to get fewer document numbers.';
      AlreadyAssignedIncomingDocErr@1002 : TextConst 'DAN=Dette dokumentnr. og denne dato har allerede et indg�ende bilag.;ENU=This document no. and date already has an incoming document.';
      AlreadyIncomingDocErr@1003 : TextConst '@@@="%1=document type, %2=document no., e.g. Invoice 1234.";DAN=Det angivne indg�ende bilagsnummer er allerede anvendt til %1 %2.;ENU=The specified incoming document no. has already been used for %1 %2.';

    [External]
    PROCEDURE GetDocNosWithoutIncomingDoc@1(VAR PostedDocsWithNoIncBuf@1000 : Record 134;DateFilter@1007 : Text;DocNoFilter@1006 : Code[250];GLAccFilter@1003 : Code[250];ExternalDocNoFilter@1008 : Code[250]);
    VAR
      PostedDocsWithNoIncDocQry@1001 : Query 130;
      NextNo@1002 : Integer;
      TableFilters@1004 : Text;
    BEGIN
      TableFilters := PostedDocsWithNoIncBuf.GETVIEW;
      PostedDocsWithNoIncBuf.RESET;
      PostedDocsWithNoIncBuf.DELETEALL;
      PostedDocsWithNoIncBuf.INIT;
      IF DateFilter <> '' THEN
        PostedDocsWithNoIncDocQry.SETFILTER(PostingDate,DateFilter);

      IF DocNoFilter <> '' THEN
        PostedDocsWithNoIncDocQry.SETFILTER(DocumentNo,DocNoFilter);

      IF GLAccFilter <> '' THEN
        PostedDocsWithNoIncDocQry.SETFILTER(GLAccount,GLAccFilter);

      IF ExternalDocNoFilter <> '' THEN
        PostedDocsWithNoIncDocQry.SETFILTER(ExternalDocumentNo,ExternalDocNoFilter);

      IF PostedDocsWithNoIncDocQry.OPEN THEN
        WHILE PostedDocsWithNoIncDocQry.READ DO BEGIN
          NextNo += 1;
          IF NextNo >= 1000 THEN BEGIN
            MESSAGE(OnlyFirst1000Msg);
            EXIT;
          END;
          PostedDocsWithNoIncBuf."Line No." := NextNo;
          PostedDocsWithNoIncBuf."Document No." := PostedDocsWithNoIncDocQry.DocumentNo;
          PostedDocsWithNoIncBuf."Posting Date" := PostedDocsWithNoIncDocQry.PostingDate;
          PostedDocsWithNoIncBuf."First Posting Description" :=
            GetFirstPostingDescription(PostedDocsWithNoIncBuf."Document No.",PostedDocsWithNoIncBuf."Posting Date",GLAccFilter);
          PostedDocsWithNoIncBuf."External Document No." := PostedDocsWithNoIncDocQry.ExternalDocumentNo;
          PostedDocsWithNoIncBuf."Debit Amount" := PostedDocsWithNoIncDocQry.DebitAmount;
          PostedDocsWithNoIncBuf."Credit Amount" := PostedDocsWithNoIncDocQry.CreditAmount;
          PostedDocsWithNoIncBuf.INSERT;
        END;
      PostedDocsWithNoIncBuf.RESET;
      PostedDocsWithNoIncBuf.SETVIEW(TableFilters);
    END;

    [External]
    PROCEDURE UpdateIncomingDocuments@2();
    VAR
      IncomingDocument@1000 : Record 130;
      PostedDocsWithNoIncBuf@1001 : Record 134;
      IncomingDocuments@1002 : Page 190;
      IsPosted@1003 : Boolean;
    BEGIN
      CALCFIELDS("Incoming Document No.");
      IF "Incoming Document No." > 0 THEN
        ERROR(AlreadyAssignedIncomingDocErr);
      PostedDocsWithNoIncBuf := Rec;
      IncomingDocument.SETRANGE(Posted,FALSE);
      IncomingDocuments.SETTABLEVIEW(IncomingDocument);
      IncomingDocuments.LOOKUPMODE(TRUE);
      IF IncomingDocuments.RUNMODAL = ACTION::LookupOK THEN BEGIN
        IncomingDocuments.GETRECORD(IncomingDocument);
        CheckIfAssignedToUnpostedDoc(IncomingDocument."Entry No.");
        CODEUNIT.RUN(CODEUNIT::"Release Incoming Document",IncomingDocument);
        IncomingDocument.SetPostedDocFields("Posting Date","Document No.");
        IncomingDocument."Document Type" := IncomingDocument.GetPostedDocType("Posting Date","Document No.",IsPosted);
      END;
      Rec := PostedDocsWithNoIncBuf;
      IF FIND('=<>') THEN;
    END;

    LOCAL PROCEDURE GetFirstPostingDescription@3(DocumentNo@1000 : Code[20];PostingDate@1001 : Date;GLAccFilter@1003 : Text) : Text[50];
    VAR
      GLEntry@1002 : Record 17;
    BEGIN
      IF GLAccFilter <> '' THEN
        GLEntry.SETFILTER("G/L Account No.",GLAccFilter);
      GLEntry.SETRANGE("Document No.",DocumentNo);
      GLEntry.SETRANGE("Posting Date",PostingDate);
      GLEntry.SETFILTER(Description,'<>%1','');
      IF GLEntry.FINDFIRST THEN
        EXIT(GLEntry.Description);
      EXIT('');
    END;

    LOCAL PROCEDURE CheckIfAssignedToUnpostedDoc@5(IncomingDocEntryNo@1000 : Integer);
    VAR
      SalesHeader@1001 : Record 36;
      PurchaseHeader@1002 : Record 38;
      GenJournalLine@1003 : Record 81;
    BEGIN
      PurchaseHeader.SETRANGE("Incoming Document Entry No.",IncomingDocEntryNo);
      IF PurchaseHeader.FINDFIRST THEN
        ERROR(AlreadyIncomingDocErr,PurchaseHeader."Document Type",PurchaseHeader."No.");
      SalesHeader.SETRANGE("Incoming Document Entry No.",IncomingDocEntryNo);
      IF SalesHeader.FINDFIRST THEN
        ERROR(AlreadyIncomingDocErr,SalesHeader."Document Type",SalesHeader."No.");
      GenJournalLine.SETRANGE("Incoming Document Entry No.",IncomingDocEntryNo);
      IF GenJournalLine.FINDFIRST THEN
        ERROR(AlreadyIncomingDocErr,GenJournalLine.FIELDCAPTION("Journal Batch Name"),GenJournalLine."Journal Batch Name");
    END;

    BEGIN
    END.
  }
}

