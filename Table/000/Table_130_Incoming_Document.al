OBJECT Table 130 Incoming Document
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    DataCaptionFields=Vendor Name,Vendor Invoice No.,Description;
    OnInsert=VAR
               OCRServiceSetup@1001 : Record 1270;
             BEGIN
               IF OCRServiceSetup.GET THEN;
               "Created Date-Time" := ROUNDDATETIME(CURRENTDATETIME,60000);
               "Created By User ID" := USERSECURITYID;
               IF "OCR Service Doc. Template Code" = '' THEN
                 "OCR Service Doc. Template Code" := OCRServiceSetup."Default OCR Doc. Template";
             END;

    OnModify=BEGIN
               "Last Date-Time Modified" := ROUNDDATETIME(CURRENTDATETIME,60000);
               "Last Modified By User ID" := USERSECURITYID;
             END;

    OnDelete=VAR
               IncomingDocumentAttachment@1000 : Record 133;
               ActivityLog@1001 : Record 710;
               ApprovalsMgmt@1002 : Codeunit 1535;
             BEGIN
               TESTFIELD(Posted,FALSE);

               ApprovalsMgmt.DeleteApprovalEntries(RECORDID);
               ClearRelatedRecords;

               IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
               IF NOT IncomingDocumentAttachment.ISEMPTY THEN
                 IncomingDocumentAttachment.DELETEALL;

               ActivityLog.SETRANGE("Record ID",RECORDID);
               IF NOT ActivityLog.ISEMPTY THEN
                 ActivityLog.DELETEALL;

               ClearErrorMessages;
             END;

    CaptionML=[DAN=Indg�ende bilag;
               ENU=Incoming Document];
    LookupPageID=Page190;
    DrillDownPageID=Page190;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Created Date-Time   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl�t;
                                                              ENU=Created Date-Time];
                                                   Editable=No }
    { 4   ;   ;Created By User ID  ;GUID          ;TableRelation=User;
                                                   DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Oprettet af bruger-id;
                                                              ENU=Created By User ID];
                                                   Editable=No }
    { 5   ;   ;Created By User Name;Code50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."User Name" WHERE (User Security ID=FIELD(Created By User ID)));
                                                   CaptionML=[DAN=Brugernavn for oprettelse;
                                                              ENU=Created By User Name];
                                                   Editable=No }
    { 6   ;   ;Released            ;Boolean       ;CaptionML=[DAN=Frigivet;
                                                              ENU=Released];
                                                   Editable=No }
    { 7   ;   ;Released Date-Time  ;DateTime      ;CaptionML=[DAN=Frigivet dato/klokkesl�t;
                                                              ENU=Released Date-Time];
                                                   Editable=No }
    { 8   ;   ;Released By User ID ;GUID          ;TableRelation=User;
                                                   DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Bruger-id for frigivelse;
                                                              ENU=Released By User ID];
                                                   Editable=No }
    { 9   ;   ;Released By User Name;Code50       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."User Name" WHERE (User Security ID=FIELD(Released By User ID)));
                                                   CaptionML=[DAN=Brugernavn for frigivelse;
                                                              ENU=Released By User Name];
                                                   Editable=No }
    { 10  ;   ;Last Date-Time Modified;DateTime   ;CaptionML=[DAN=Dato/tidspunkt for sidste �ndring;
                                                              ENU=Last Date-Time Modified];
                                                   Editable=No }
    { 11  ;   ;Last Modified By User ID;GUID      ;TableRelation=User;
                                                   DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Bruger-id for seneste �ndring;
                                                              ENU=Last Modified By User ID];
                                                   Editable=No }
    { 12  ;   ;Last Modified By User Name;Code50  ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."User Name" WHERE (User Security ID=FIELD(Last Modified By User ID)));
                                                   CaptionML=[DAN=Brugernavn for seneste �ndring;
                                                              ENU=Last Modified By User Name];
                                                   Editable=No }
    { 13  ;   ;Posted              ;Boolean       ;CaptionML=[DAN=Bogf�rt;
                                                              ENU=Posted];
                                                   Editable=No }
    { 14  ;   ;Posted Date-Time    ;DateTime      ;CaptionML=[DAN=Bogf�rt dato/klokkesl�t;
                                                              ENU=Posted Date-Time];
                                                   Editable=No }
    { 15  ;   ;Document Type       ;Option        ;InitValue=[ ];
                                                   CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN="Kladde,salgsfaktura,salgskreditnota,k�bsfaktura,k�bskreditnota, ";
                                                                    ENU="Journal,Sales Invoice,Sales Credit Memo,Purchase Invoice,Purchase Credit Memo, "];
                                                   OptionString=[Journal,Sales Invoice,Sales Credit Memo,Purchase Invoice,Purchase Credit Memo, ];
                                                   Editable=No }
    { 16  ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.];
                                                   Editable=No }
    { 17  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date];
                                                   ClosingDates=Yes;
                                                   Editable=No }
    { 18  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Ny,Frigivet,Afvist,Bogf�rt,Oprettet,Mislykkedes,Afventer godkendelse;
                                                                    ENU=New,Released,Rejected,Posted,Created,Failed,Pending Approval];
                                                   OptionString=New,Released,Rejected,Posted,Created,Failed,Pending Approval;
                                                   Editable=No }
    { 19  ;   ;URL1                ;Text250       ;CaptionML=[DAN=URL1;
                                                              ENU=URL1];
                                                   Editable=No }
    { 20  ;   ;URL2                ;Text250       ;CaptionML=[DAN=URL2;
                                                              ENU=URL2];
                                                   Editable=No }
    { 21  ;   ;URL3                ;Text250       ;CaptionML=[DAN=URL3;
                                                              ENU=URL3];
                                                   Editable=No }
    { 22  ;   ;URL4                ;Text250       ;CaptionML=[DAN=URL4;
                                                              ENU=URL4];
                                                   Editable=No }
    { 23  ;   ;Vendor Name         ;Text50        ;CaptionML=[DAN=Kreditornavn;
                                                              ENU=Vendor Name] }
    { 24  ;   ;Vendor VAT Registration No.;Text30 ;CaptionML=[DAN=Kreditors SE/CVR-nr.;
                                                              ENU=Vendor VAT Registration No.] }
    { 25  ;   ;Vendor IBAN         ;Code50        ;CaptionML=[DAN=Kreditors IBAN;
                                                              ENU=Vendor IBAN] }
    { 26  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 27  ;   ;Vendor Bank Branch No.;Text20      ;CaptionML=[DAN=Kreditors bankregistreringsnr.;
                                                              ENU=Vendor Bank Branch No.] }
    { 28  ;   ;Vendor Bank Account No.;Text30     ;CaptionML=[DAN=Kreditors bankkontonr.;
                                                              ENU=Vendor Bank Account No.] }
    { 29  ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Kreditornr.;
                                                              ENU=Vendor No.] }
    { 30  ;   ;Data Exchange Type  ;Code20        ;TableRelation="Data Exchange Type";
                                                   CaptionML=[DAN=Dataudvekslingstype;
                                                              ENU=Data Exchange Type] }
    { 31  ;   ;OCR Data Corrected  ;Boolean       ;InitValue=No;
                                                   CaptionML=[DAN=Dato for korrektion af OCR;
                                                              ENU=OCR Data Corrected] }
    { 32  ;   ;OCR Status          ;Option        ;CaptionML=[DAN=OCR-status;
                                                              ENU=OCR Status];
                                                   OptionCaptionML=[DAN=" ,Klar,Sendt,Fejl,Lykkedes,Afventer bekr�ftelse";
                                                                    ENU=" ,Ready,Sent,Error,Success,Awaiting Verification"];
                                                   OptionString=[ ,Ready,Sent,Error,Success,Awaiting Verification];
                                                   Editable=No }
    { 38  ;   ;OCR Service Doc. Template Code;Code20;
                                                   TableRelation="OCR Service Document Template";
                                                   OnValidate=BEGIN
                                                                CALCFIELDS("OCR Service Doc. Template Name");
                                                              END;

                                                   CaptionML=[DAN=Skabelonkode til OCR-servicedokument;
                                                              ENU=OCR Service Doc. Template Code] }
    { 39  ;   ;OCR Service Doc. Template Name;Text50;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Lookup("OCR Service Document Template".Name WHERE (Code=FIELD(OCR Service Doc. Template Code)));
                                                   CaptionML=[DAN=Navn p� skabelon til OCR-servicedokument;
                                                              ENU=OCR Service Doc. Template Name];
                                                   Editable=No }
    { 40  ;   ;OCR Process Finished;Boolean       ;CaptionML=[DAN=OCR-proces er afsluttet;
                                                              ENU=OCR Process Finished] }
    { 41  ;   ;Created Doc. Error Msg. Type;Option;InitValue=Error;
                                                   CaptionML=[DAN=Oprettet bilagsfejlmeddelelsestype;
                                                              ENU=Created Doc. Error Msg. Type];
                                                   OptionCaptionML=[DAN=" ,Fejl,Advarsel";
                                                                    ENU=" ,Error,Warning"];
                                                   OptionString=[ ,Error,Warning] }
    { 42  ;   ;Vendor Id           ;GUID          ;CaptionML=[DAN=Kreditor-id;
                                                              ENU=Vendor Id] }
    { 50  ;   ;Currency Code       ;Code10        ;OnValidate=VAR
                                                                GeneralLedgerSetup@1000 : Record 98;
                                                                Currency@1001 : Record 4;
                                                              BEGIN
                                                                GeneralLedgerSetup.GET;
                                                                IF (NOT Currency.GET("Currency Code")) AND ("Currency Code" <> '') AND ("Currency Code" <> GeneralLedgerSetup."LCY Code") THEN
                                                                  ERROR(InvalidCurrencyCodeErr);
                                                              END;

                                                   OnLookup=VAR
                                                              Currency@1000 : Record 4;
                                                            BEGIN
                                                              IF PAGE.RUNMODAL(PAGE::Currencies,Currency) = ACTION::LookupOK THEN
                                                                "Currency Code" := Currency.Code;
                                                            END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 51  ;   ;Amount Excl. VAT    ;Decimal       ;CaptionML=[DAN=Bel�b ekskl. moms;
                                                              ENU=Amount Excl. VAT];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 52  ;   ;Amount Incl. VAT    ;Decimal       ;CaptionML=[DAN=Bel�b inkl. moms;
                                                              ENU=Amount Incl. VAT];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 53  ;   ;VAT Amount          ;Decimal       ;CaptionML=[DAN=Momsbel�b;
                                                              ENU=VAT Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 54  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 55  ;   ;Vendor Invoice No.  ;Code35        ;CaptionML=[DAN=Kreditors fakturanr.;
                                                              ENU=Vendor Invoice No.] }
    { 56  ;   ;Order No.           ;Code20        ;CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.] }
    { 57  ;   ;Vendor Phone No.    ;Text30        ;CaptionML=[DAN=Kreditors telefonnr.;
                                                              ENU=Vendor Phone No.] }
    { 58  ;   ;Related Record ID   ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Relateret record-id;
                                                              ENU=Related Record ID] }
    { 160 ;   ;Job Queue Status    ;Option        ;OnLookup=VAR
                                                              JobQueueEntry@1000 : Record 472;
                                                            BEGIN
                                                              IF "Job Queue Status" = "Job Queue Status"::" " THEN
                                                                EXIT;
                                                              JobQueueEntry.ShowStatusMsg("Job Queue Entry ID");
                                                            END;

                                                   CaptionML=[DAN=Opgavek�status;
                                                              ENU=Job Queue Status];
                                                   OptionCaptionML=[DAN=" ,Tidsfastlagt,Fejl,Behandling";
                                                                    ENU=" ,Scheduled,Error,Processing"];
                                                   OptionString=[ ,Scheduled,Error,Processing];
                                                   Editable=No }
    { 161 ;   ;Job Queue Entry ID  ;GUID          ;CaptionML=[DAN=Opgavek�post-id;
                                                              ENU=Job Queue Entry ID];
                                                   Editable=No }
    { 162 ;   ;Processed           ;Boolean       ;CaptionML=[DAN=Behandlet;
                                                              ENU=Processed] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Status                                   }
    {    ;Document No.,Posting Date                }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Created Date-Time,Description,Amount Incl. VAT,Status,Currency Code }
  }
  CODE
  {
    VAR
      IncomingDocumentsSetup@1001 : Record 131;
      UrlTooLongErr@1003 : TextConst 'DAN=Kun URL-adresser p� maks. 1.000 tegn er tilladt.;ENU=Only URLs with a maximum 1000 characters are allowed.';
      TempErrorMessage@1011 : TEMPORARY Record 700;
      DocumentType@1005 : 'Invoice,Credit Memo';
      NoDocumentMsg@1008 : TextConst 'DAN=Der er ikke noget indg�ende bilag med denne kombination af bogf�ringsdato og bilagsnummer.;ENU=There is no incoming document for this combination of posting date and document number.';
      AlreadyUsedInJnlErr@1004 : TextConst '@@@="%1 = journal batch name, %2=line number.";DAN=Det indg�ende bilag er allerede tildelt til kladdenavnet %1, linjenummer. %2.;ENU=The incoming document has already been assigned to journal batch %1, line number. %2.';
      AlreadyUsedInDocHdrErr@1006 : TextConst '@@@="%1=document type, %2=document number, %3=table name, e.g. Sales Header.";DAN=Det indg�ende bilag er allerede tildelt til %1 %2 (%3).;ENU=The incoming document has already been assigned to %1 %2 (%3).';
      DocPostedErr@1009 : TextConst 'DAN=Det dokument, der vedr�rer dette indg�ende bilag, er bogf�rt.;ENU=The document related to this incoming document has been posted.';
      DocApprovedErr@1010 : TextConst 'DAN=Dette indg�ende bilag skal frigives.;ENU=This incoming document requires releasing.';
      DetachQst@1012 : TextConst 'DAN=Vil du fjerne referencen fra dette indg�ende bilag til det bogf�rte dokument %1 med bogf�ringsdatoen %2?;ENU=Do you want to remove the reference from this incoming document to posted document %1, posting date %2?';
      NotSupportedPurchErr@1013 : TextConst '@@@=%1 will be Sales/Purchase Header. %2 will be invoice, Credit Memo.;DAN=K�bsdokumenter af typen %1 underst�ttes ikke.;ENU=Purchase documents of type %1 are not supported.';
      NotSupportedSalesErr@1016 : TextConst '@@@=%1 will be Sales/Purchase Header. %2 will be invoice, Credit Memo.;DAN=Salgsdokumenter af typen %1 underst�ttes ikke.;ENU=Sales documents of type %1 are not supported.';
      EntityNotFoundErr@1014 : TextConst 'DAN=Bilaget kunne ikke oprettes. Kontroll�r, at dataudvekslingsdefinitionen er korrekt.;ENU=Cannot create the document. Make sure the data exchange definition is correct.';
      DocAlreadyCreatedErr@1015 : TextConst 'DAN=Bilaget er allerede oprettet.;ENU=The document has already been created.';
      DocNotCreatedMsg@1017 : TextConst 'DAN=Dokumentet blev ikke oprettet p� grund af fejl i konverteringsprocessen.;ENU=The document was not created due to errors in the conversion process.';
      DocCreatedMsg@1018 : TextConst '@@@=%1 can be Purchase Invoice, %2 is an ID (e.g. 1001);DAN=%1 %2 blev oprettet.;ENU=%1 %2 has been created.';
      DocCreatedWarningsMsg@1019 : TextConst '@@@=%1 can be Purchase Invoice, %2 is an ID (e.g. 1001);DAN=%1 %2 blev oprettet med advarsler.;ENU=%1 %2 has been created with warnings.';
      RemovePostedRecordManuallyMsg@1024 : TextConst 'DAN=Henvisningen til den bogf�rte record er blevet slettet.\\Husk, om n�dvendigt, at korrigere den bogf�rte record.;ENU=The reference to the posted record has been removed.\\Remember to correct the posted record if needed.';
      DeleteRecordQst@1025 : TextConst 'DAN=Henvisningen til den bogf�rte record er blevet slettet.\\Vil du slette recorden?;ENU=The reference to the record has been removed.\\Do you want to delete the record?';
      DocWhenApprovalIsCompleteErr@1026 : TextConst 'DAN=Bilaget kan kun oprettes, n�r godkendelsesprocessen er fuldf�rt.;ENU=The document can only be created when the approval process is complete.';
      InvalidCurrencyCodeErr@1000 : TextConst 'DAN=Du skal angive en gyldig valutakode.;ENU=You must enter a valid currency code.';
      ReplaceMainAttachmentQst@1002 : TextConst 'DAN=Er du sikker p�, at du vil erstatte den vedh�ftede fil?;ENU=Are you sure you want to replace the attached file?';
      PurchaseTxt@1031 : TextConst 'DAN=K�b;ENU=Purchase';
      SalesTxt@1030 : TextConst 'DAN=Salg;ENU=Sales';
      PurchaseInvoiceTxt@2002 : TextConst 'DAN=K�bsfaktura;ENU=Purchase Invoice';
      PurchaseCreditMemoTxt@1007 : TextConst 'DAN=K�bskreditnota;ENU=Purchase Credit Memo';
      SalesInvoiceTxt@1020 : TextConst 'DAN=Salgsfaktura;ENU=Sales Invoice';
      SalesCreditMemoTxt@1021 : TextConst 'DAN=Salgskreditnota;ENU=Sales Credit Memo';
      JournalTxt@1022 : TextConst 'DAN=Kladde;ENU=Journal';
      DoYouWantToRemoveReferenceQst@1023 : TextConst 'DAN=Vil du fjerne referencen?;ENU=Do you want to remove the reference?';
      DataExchangeTypeEmptyErr@1027 : TextConst 'DAN=Du skal v�lge en v�rdi i feltet Dataudvekslingstype i det indg�ende dokument.;ENU=You must select a value in the Data Exchange Type field on the incoming document.';
      NoDocAttachErr@1028 : TextConst 'DAN=Intet dokument er vedh�ftet.\\Vedh�ft et dokument, og pr�v igen.;ENU=No document is attached.\\Attach a document, and then try again.';
      GeneralLedgerEntriesTxt@1029 : TextConst 'DAN=Finansposter;ENU=General Ledger Entries';
      CannotReplaceMainAttachmentErr@1032 : TextConst 'DAN=Den prim�re vedh�ftede fil kan ikke udskiftes, da dokumentet allerede er blevet sendt til OCR.;ENU=Cannot replace the main attachment because the document has already been sent to OCR.';

    [External]
    PROCEDURE GetURL@1() : Text;
    BEGIN
      EXIT(URL1 + URL2 + URL3 + URL4);
    END;

    [External]
    PROCEDURE SetURL@2(URL@1000 : Text);
    BEGIN
      TESTFIELD(Status,Status::New);

      TESTFIELD(Posted,FALSE);
      IF STRLEN(URL) > 1000 THEN
        ERROR(UrlTooLongErr);
      URL2 := '';
      URL3 := '';
      URL4 := '';
      URL1 := COPYSTR(URL,1,250);
      IF STRLEN(URL) > 250 THEN
        URL2 := COPYSTR(URL,251,250);
      IF STRLEN(URL) > 500 THEN
        URL3 := COPYSTR(URL,501,250);
      IF STRLEN(URL) > 750 THEN
        URL4 := COPYSTR(URL,751,250);
    END;

    [Internal]
    PROCEDURE Release@3();
    VAR
      ReleaseIncomingDocument@1000 : Codeunit 132;
    BEGIN
      ReleaseIncomingDocument.PerformManualRelease(Rec);
    END;

    [External]
    PROCEDURE Reject@4();
    VAR
      ReleaseIncomingDocument@1000 : Codeunit 132;
    BEGIN
      ReleaseIncomingDocument.PerformManualReject(Rec);
    END;

    [External]
    PROCEDURE CheckNotCreated@122();
    BEGIN
      IF Status = Status::Created THEN
        ERROR(DocAlreadyCreatedErr);
    END;

    [External]
    PROCEDURE CreateDocumentWithDataExchange@126();
    VAR
      RelatedRecord@1000 : Variant;
    BEGIN
      IF GetNAVRecord(RelatedRecord) THEN
        ERROR(DocAlreadyCreatedErr);

      CreateWithDataExchange("Document Type"::" ")
    END;

    [External]
    PROCEDURE TryCreateDocumentWithDataExchange@73();
    BEGIN
      CreateDocumentWithDataExchange
    END;

    [External]
    PROCEDURE CreateReleasedDocumentWithDataExchange@72();
    VAR
      PurchaseHeader@1002 : Record 38;
      ReleasePurchaseDocument@1003 : Codeunit 415;
      Variant@1001 : Variant;
      RecordRef@1000 : RecordRef;
    BEGIN
      CreateWithDataExchange("Document Type"::" ");
      GetNAVRecord(Variant);
      RecordRef.GETTABLE(Variant);
      IF RecordRef.NUMBER <> DATABASE::"Purchase Header" THEN
        EXIT;
      RecordRef.SETTABLE(PurchaseHeader);
      ReleasePurchaseDocument.PerformManualRelease(PurchaseHeader);
    END;

    LOCAL PROCEDURE CreateWithDataExchange@51(DocumentType@1001 : Option);
    VAR
      ErrorMessage@1000 : Record 700;
      ApprovalsMgmt@1002 : Codeunit 1535;
      ReleaseIncomingDocument@1003 : Codeunit 132;
      OldStatus@1004 : Option;
    BEGIN
      FIND;

      IF ApprovalsMgmt.IsIncomingDocApprovalsWorkflowEnabled(Rec) AND (Status = Status::New) THEN
        ERROR(DocWhenApprovalIsCompleteErr);

      OnCheckIncomingDocCreateDocRestrictions;

      IF "Data Exchange Type" = '' THEN
        ERROR(DataExchangeTypeEmptyErr);

      "Document Type" := DocumentType;
      MODIFY;

      ClearErrorMessages;
      TestReadyForProcessing;

      CheckNotCreated;

      IF Status IN [Status::New,Status::Failed] THEN BEGIN
        OldStatus := Status;
        CODEUNIT.RUN(CODEUNIT::"Release Incoming Document",Rec);
        TESTFIELD(Status,Status::Released);
        Status := OldStatus;
        MODIFY;
      END;

      COMMIT;
      IF NOT CODEUNIT.RUN(CODEUNIT::"Incoming Doc. with Data. Exch.",Rec) THEN BEGIN
        ErrorMessage.CopyFromTemp(TempErrorMessage);
        SetProcessFailed('');
        EXIT;
      END;

      ErrorMessage.SetContext(RECORDID);
      IF ErrorMessage.HasErrors(FALSE) THEN BEGIN
        SetProcessFailed('');
        EXIT;
      END;

      // identify the created doc
      IF NOT UpdateDocumentFields THEN BEGIN
        SetProcessFailed('');
        EXIT;
      END;

      ReleaseIncomingDocument.Create(Rec);

      IF ErrorMessage.ErrorMessageCount(ErrorMessage."Message Type"::Warning) > 0 THEN
        MESSAGE(DocCreatedWarningsMsg,FORMAT("Document Type"),"Document No.")
      ELSE
        MESSAGE(DocCreatedMsg,FORMAT("Document Type"),"Document No.");
    END;

    [Internal]
    PROCEDURE CreateManually@271();
    VAR
      RelatedRecord@1002 : Variant;
      DocumentTypeOption@1000 : Integer;
    BEGIN
      IF GetNAVRecord(RelatedRecord) THEN
        ERROR(DocAlreadyCreatedErr);

      DocumentTypeOption :=
        STRMENU(
          STRSUBSTNO('%1,%2,%3,%4,%5',JournalTxt,SalesInvoiceTxt,SalesCreditMemoTxt,PurchaseInvoiceTxt,PurchaseCreditMemoTxt),1);

      IF DocumentTypeOption < 1 THEN
        EXIT;

      DocumentTypeOption -= 1;

      CASE DocumentTypeOption OF
        "Document Type"::"Purchase Invoice":
          CreatePurchInvoice;
        "Document Type"::"Purchase Credit Memo":
          CreatePurchCreditMemo;
        "Document Type"::"Sales Invoice":
          CreateSalesInvoice;
        "Document Type"::"Sales Credit Memo":
          CreateSalesCreditMemo;
        "Document Type"::Journal:
          CreateGenJnlLine;
      END;
    END;

    [Internal]
    PROCEDURE CreateGenJnlLine@5();
    VAR
      GenJnlLine@1000 : Record 81;
      LastGenJnlLine@1002 : Record 81;
      LineNo@1001 : Integer;
    BEGIN
      IF "Document Type" <> "Document Type"::Journal THEN
        TestIfAlreadyExists;
      TestReadyForProcessing;
      IncomingDocumentsSetup.TESTFIELD("General Journal Template Name");
      IncomingDocumentsSetup.TESTFIELD("General Journal Batch Name");
      GenJnlLine.SETRANGE("Journal Template Name",IncomingDocumentsSetup."General Journal Template Name");
      GenJnlLine.SETRANGE("Journal Batch Name",IncomingDocumentsSetup."General Journal Batch Name");
      GenJnlLine.SETRANGE("Incoming Document Entry No.","Entry No.");
      IF NOT GenJnlLine.ISEMPTY THEN
        EXIT; // instead; go to the document

      GenJnlLine.SETRANGE("Incoming Document Entry No.");

      "Document Type" := "Document Type"::Journal;

      IF GenJnlLine.FINDLAST THEN;
      LastGenJnlLine := GenJnlLine;
      LineNo := GenJnlLine."Line No." + 10000;
      GenJnlLine.INIT;
      GenJnlLine."Journal Template Name" := IncomingDocumentsSetup."General Journal Template Name";
      GenJnlLine."Journal Batch Name" := IncomingDocumentsSetup."General Journal Batch Name";
      GenJnlLine."Line No." := LineNo;
      GenJnlLine.SetUpNewLine(LastGenJnlLine,0,TRUE);
      GenJnlLine."Incoming Document Entry No." := "Entry No.";
      GenJnlLine.Description := COPYSTR(Description,1,MAXSTRLEN(GenJnlLine.Description));

      IF GenJnlLine.INSERT(TRUE) THEN
        OnAfterCreateGenJnlLineFromIncomingDocSuccess(Rec)
      ELSE
        OnAfterCreateGenJnlLineFromIncomingDocFail(Rec);

      IF GenJnlLine.HASLINKS THEN
        GenJnlLine.DELETELINKS;
      IF GetURL <> '' THEN
        GenJnlLine.ADDLINK(GetURL,Description);

      ShowNAVRecord;
    END;

    [Internal]
    PROCEDURE CreatePurchInvoice@6();
    BEGIN
      IF "Document Type" <> "Document Type"::"Purchase Invoice" THEN
        TestIfAlreadyExists;

      "Document Type" := "Document Type"::"Purchase Invoice";
      CreatePurchDoc(DocumentType::Invoice);
    END;

    [Internal]
    PROCEDURE CreatePurchCreditMemo@7();
    BEGIN
      IF "Document Type" <> "Document Type"::"Purchase Credit Memo" THEN
        TestIfAlreadyExists;

      "Document Type" := "Document Type"::"Purchase Credit Memo";
      CreatePurchDoc(DocumentType::"Credit Memo");
    END;

    [Internal]
    PROCEDURE CreateSalesInvoice@8();
    BEGIN
      IF "Document Type" <> "Document Type"::"Sales Invoice" THEN
        TestIfAlreadyExists;

      "Document Type" := "Document Type"::"Sales Invoice";
      CreateSalesDoc(DocumentType::Invoice);
    END;

    [Internal]
    PROCEDURE CreateSalesCreditMemo@9();
    BEGIN
      IF "Document Type" <> "Document Type"::"Sales Credit Memo" THEN
        TestIfAlreadyExists;

      "Document Type" := "Document Type"::"Sales Credit Memo";
      CreateSalesDoc(DocumentType::"Credit Memo");
    END;

    [External]
    PROCEDURE CreateGeneralJournalLineWithDataExchange@45();
    VAR
      ErrorMessage@1002 : Record 700;
      RelatedRecord@1000 : Variant;
    BEGIN
      IF GetNAVRecord(RelatedRecord) THEN
        ERROR(DocAlreadyCreatedErr);

      CreateWithDataExchange("Document Type"::Journal);

      ErrorMessage.SetContext(RECORDID);
      IF NOT ErrorMessage.HasErrors(FALSE) THEN
        OnAfterCreateGenJnlLineFromIncomingDocSuccess(Rec)
      ELSE
        OnAfterCreateGenJnlLineFromIncomingDocFail(Rec);
    END;

    [Internal]
    PROCEDURE TryCreateGeneralJournalLineWithDataExchange@272();
    BEGIN
      CreateGeneralJournalLineWithDataExchange
    END;

    [External]
    PROCEDURE RemoveReferenceToWorkingDocument@36(EntryNo@1000 : Integer);
    BEGIN
      IF EntryNo = 0 THEN
        EXIT;
      IF NOT GET(EntryNo) THEN
        EXIT;

      TESTFIELD(Posted,FALSE);

      "Document Type" := "Document Type"::" ";
      "Document No." := '';
      // To clear the filters and prevent the page from putting values back
      SETRANGE("Document Type");
      SETRANGE("Document No.");

      IF Released THEN
        Status := Status::Released
      ELSE
        Status := Status::New;

      ClearErrorMessages;
      "Created Doc. Error Msg. Type" := "Created Doc. Error Msg. Type"::Error;

      MODIFY;
    END;

    LOCAL PROCEDURE RemoveIncomingDocumentEntryNoFromUnpostedDocument@83();
    VAR
      SalesHeader@1004 : Record 36;
      DataTypeManagement@1003 : Codeunit 701;
      RelatedRecordRecordRef@1002 : RecordRef;
      RelatedRecordFieldRef@1001 : FieldRef;
      RelatedRecord@1000 : Variant;
    BEGIN
      IF NOT GetUnpostedNAVRecord(RelatedRecord) THEN
        EXIT;
      RelatedRecordRecordRef.GETTABLE(RelatedRecord);
      DataTypeManagement.FindFieldByName(
        RelatedRecordRecordRef,RelatedRecordFieldRef,SalesHeader.FIELDNAME("Incoming Document Entry No."));
      RelatedRecordFieldRef.VALUE := 0;
      RelatedRecordRecordRef.MODIFY(TRUE);
    END;

    [External]
    PROCEDURE CreateIncomingDocument@25(NewDescription@1003 : Text;NewURL@1002 : Text) : Integer;
    BEGIN
      RESET;
      CLEAR(Rec);
      INIT;
      Description := COPYSTR(NewDescription,1,MAXSTRLEN(Description));
      SetURL(NewURL);
      INSERT(TRUE);
      EXIT("Entry No.");
    END;

    [Internal]
    PROCEDURE CreateIncomingDocumentFromServerFile@40(FileName@1000 : Text;FilePath@1001 : Text);
    VAR
      IncomingDocument@1006 : Record 130;
    BEGIN
      IF (FileName = '') OR (FilePath = '') THEN
        EXIT;
      IncomingDocument.COPYFILTERS(Rec);
      CreateIncomingDocument(FileName,'');
      AddAttachmentFromServerFile(FileName,FilePath);
      COPYFILTERS(IncomingDocument);
    END;

    LOCAL PROCEDURE TestIfAlreadyExists@33();
    VAR
      GenJnlLine@1002 : Record 81;
      SalesHeader@1001 : Record 36;
      PurchaseHeader@1000 : Record 38;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Journal:
          BEGIN
            GenJnlLine.SETRANGE("Incoming Document Entry No.","Entry No.");
            IF GenJnlLine.FINDFIRST THEN
              ERROR(AlreadyUsedInJnlErr,GenJnlLine."Journal Batch Name",GenJnlLine."Line No.");
          END;
        "Document Type"::"Sales Invoice","Document Type"::"Sales Credit Memo":
          BEGIN
            SalesHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            IF SalesHeader.FINDFIRST THEN
              ERROR(AlreadyUsedInDocHdrErr,SalesHeader."Document Type",SalesHeader."No.",SalesHeader.TABLECAPTION);
          END;
        "Document Type"::"Purchase Invoice","Document Type"::"Purchase Credit Memo":
          BEGIN
            PurchaseHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            IF PurchaseHeader.FINDFIRST THEN
              ERROR(AlreadyUsedInDocHdrErr,PurchaseHeader."Document Type",PurchaseHeader."No.",PurchaseHeader.TABLECAPTION);
          END;
      END;
    END;

    [External]
    PROCEDURE TestReadyForProcessing@24();
    BEGIN
      TestReadyForProcessingForcePosted(FALSE);
    END;

    LOCAL PROCEDURE TestReadyForProcessingForcePosted@77(ForcePosted@1000 : Boolean);
    BEGIN
      IF NOT ForcePosted AND Posted THEN
        ERROR(DocPostedErr);

      IncomingDocumentsSetup.Fetch;
      IF IncomingDocumentsSetup."Require Approval To Create" AND (NOT Released) THEN
        ERROR(DocApprovedErr);
    END;

    [External]
    PROCEDURE PostedDocExists@35(DocumentNo@1000 : Code[20];PostingDate@1001 : Date) : Boolean;
    BEGIN
      SETRANGE(Posted,TRUE);
      SETRANGE("Document No.",DocumentNo);
      SETRANGE("Posting Date",PostingDate);
      EXIT(NOT ISEMPTY);
    END;

    [External]
    PROCEDURE GetPostedDocType@79(PostingDate@1000 : Date;DocNo@1001 : Code[20];VAR IsPosted@1003 : Boolean) : Integer;
    VAR
      SalesInvoiceHeader@1008 : Record 112;
      SalesCrMemoHeader@1007 : Record 114;
      PurchInvHeader@1006 : Record 122;
      PurchCrMemoHdr@1005 : Record 124;
      GLEntry@1002 : Record 17;
    BEGIN
      IsPosted := TRUE;
      CASE TRUE OF
        ((PostingDate = 0D) OR (DocNo = '')):
          EXIT("Document Type"::" ");
        PurchInvHeader.GET(DocNo):
          IF PurchInvHeader."Posting Date" = PostingDate THEN
            EXIT("Document Type"::"Purchase Invoice");
        PurchCrMemoHdr.GET(DocNo):
          IF PurchCrMemoHdr."Posting Date" = PostingDate THEN
            EXIT("Document Type"::"Purchase Credit Memo");
        SalesInvoiceHeader.GET(DocNo):
          IF SalesInvoiceHeader."Posting Date" = PostingDate THEN
            EXIT("Document Type"::"Sales Invoice");
        SalesCrMemoHeader.GET(DocNo):
          IF SalesCrMemoHeader."Posting Date" = PostingDate THEN
            EXIT("Document Type"::"Sales Credit Memo");
        ELSE
          GLEntry.SETRANGE("Posting Date",PostingDate);
          GLEntry.SETRANGE("Document No.",DocNo);
          IsPosted := NOT GLEntry.ISEMPTY;
          EXIT("Document Type"::Journal);
      END;
      IsPosted := FALSE;
      EXIT("Document Type"::" ");
    END;

    [External]
    PROCEDURE SetPostedDocFields@10(PostingDate@1000 : Date;DocNo@1001 : Code[20]);
    BEGIN
      SetPostedDocFieldsForcePosted(PostingDate,DocNo,FALSE);
    END;

    [External]
    PROCEDURE SetPostedDocFieldsForcePosted@82(PostingDate@1000 : Date;DocNo@1001 : Code[20];ForcePosted@1003 : Boolean);
    VAR
      IncomingDocumentAttachment@1002 : Record 133;
      RelatedRecord@1006 : Variant;
      RelatedRecordRef@1004 : RecordRef;
    BEGIN
      TestReadyForProcessingForcePosted(ForcePosted);
      Posted := TRUE;
      Status := Status::Posted;
      Processed := TRUE;
      "Posted Date-Time" := CURRENTDATETIME;
      "Document No." := DocNo;
      "Posting Date" := PostingDate;
      IF FindPostedNAVRecord(RelatedRecord) THEN BEGIN
        RelatedRecordRef.GETTABLE(RelatedRecord);
        "Related Record ID" := RelatedRecordRef.RECORDID;
      END;
      ClearErrorMessages;
      MODIFY(TRUE);
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.MODIFYALL("Document No.","Document No.");
      IncomingDocumentAttachment.MODIFYALL("Posting Date","Posting Date");
    END;

    [External]
    PROCEDURE UndoPostedDocFields@27();
    VAR
      IncomingDocumentAttachment@1002 : Record 133;
      DummyRecordID@1000 : RecordID;
    BEGIN
      IF "Entry No." = 0 THEN
        EXIT;
      IF NOT Posted THEN
        EXIT;
      IF NOT CONFIRM(STRSUBSTNO(DetachQst,"Document No.","Posting Date"),FALSE) THEN
        EXIT;
      Posted := FALSE;
      Processed := FALSE;
      Status := Status::Released;
      "Posted Date-Time" := 0DT;
      "Related Record ID" := DummyRecordID;
      "Document No." := '';
      "Document Type" := "Document Type"::" ";
      "Posting Date" := 0D;

      // To clear the filters and prevent the page from putting values back
      SETRANGE("Posted Date-Time");
      SETRANGE("Document No.");
      SETRANGE("Document Type");
      SETRANGE("Posting Date");

      MODIFY(TRUE);
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.MODIFYALL("Document No.","Document No.");
      IncomingDocumentAttachment.MODIFYALL("Posting Date","Posting Date");

      MESSAGE(RemovePostedRecordManuallyMsg);
    END;

    [External]
    PROCEDURE UpdateIncomingDocumentFromPosting@12(IncomingDocumentNo@1000 : Integer;PostingDate@1001 : Date;DocNo@1002 : Code[20]);
    VAR
      IncomingDocument@1003 : Record 130;
    BEGIN
      IF IncomingDocumentNo = 0 THEN
        EXIT;

      IF NOT IncomingDocument.GET(IncomingDocumentNo) THEN
        EXIT;

      IncomingDocument.SetPostedDocFieldsForcePosted(PostingDate,DocNo,TRUE);
      IncomingDocument.MODIFY;
    END;

    LOCAL PROCEDURE ClearRelatedRecords@21();
    VAR
      GenJnlLine@1002 : Record 81;
      SalesHeader@1001 : Record 36;
      PurchaseHeader@1000 : Record 38;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Journal:
          BEGIN
            GenJnlLine.SETRANGE("Incoming Document Entry No.","Entry No.");
            GenJnlLine.MODIFYALL("Incoming Document Entry No.",0,TRUE);
          END;
        "Document Type"::"Sales Invoice","Document Type"::"Sales Credit Memo":
          BEGIN
            SalesHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            SalesHeader.MODIFYALL("Incoming Document Entry No.",0,TRUE);
          END;
        "Document Type"::"Purchase Invoice","Document Type"::"Purchase Credit Memo":
          BEGIN
            PurchaseHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            PurchaseHeader.MODIFYALL("Incoming Document Entry No.",0,TRUE);
          END;
      END;
    END;

    LOCAL PROCEDURE CreateSalesDoc@14(DocType@1000 : Option);
    VAR
      SalesHeader@1001 : Record 36;
    BEGIN
      TestReadyForProcessing;
      SalesHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
      IF NOT SalesHeader.ISEMPTY THEN BEGIN
        ShowNAVRecord;
        EXIT;
      END;
      SalesHeader.RESET;
      SalesHeader.INIT;
      CASE DocType OF
        DocumentType::Invoice:
          SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        DocumentType::"Credit Memo":
          SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
      END;
      SalesHeader.INSERT(TRUE);
      OnAfterCreateSalesHeaderFromIncomingDoc(SalesHeader);
      IF GetURL <> '' THEN
        SalesHeader.ADDLINK(GetURL,Description);
      SalesHeader."Incoming Document Entry No." := "Entry No.";
      SalesHeader.MODIFY;
      "Document No." := SalesHeader."No.";
      MODIFY(TRUE);
      COMMIT;
      ShowNAVRecord;
    END;

    LOCAL PROCEDURE CreatePurchDoc@15(DocType@1000 : Option);
    VAR
      PurchHeader@1001 : Record 38;
    BEGIN
      TestReadyForProcessing;
      PurchHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
      IF NOT PurchHeader.ISEMPTY THEN BEGIN
        ShowNAVRecord;
        EXIT;
      END;
      PurchHeader.RESET;
      PurchHeader.INIT;
      CASE DocType OF
        DocumentType::Invoice:
          PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
        DocumentType::"Credit Memo":
          PurchHeader."Document Type" := PurchHeader."Document Type"::"Credit Memo";
      END;
      PurchHeader.INSERT(TRUE);
      OnAfterCreatePurchHeaderFromIncomingDoc(PurchHeader);
      IF GetURL <> '' THEN
        PurchHeader.ADDLINK(GetURL,Description);
      PurchHeader."Incoming Document Entry No." := "Entry No.";
      PurchHeader.MODIFY;
      "Document No." := PurchHeader."No.";
      MODIFY(TRUE);
      COMMIT;
      ShowNAVRecord;
    END;

    [Internal]
    PROCEDURE SetGenJournalLine@17(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      IF GenJnlLine."Incoming Document Entry No." = 0 THEN
        EXIT;
      GET(GenJnlLine."Incoming Document Entry No.");
      TestReadyForProcessing;
      TestIfAlreadyExists;
      "Document Type" := "Document Type"::Journal;
      MODIFY(TRUE);
      IF NOT DocLinkExists(GenJnlLine) THEN
        GenJnlLine.ADDLINK(GetURL,Description);
    END;

    [Internal]
    PROCEDURE SetSalesDoc@19(VAR SalesHeader@1000 : Record 36);
    BEGIN
      IF SalesHeader."Incoming Document Entry No." = 0 THEN
        EXIT;
      GET(SalesHeader."Incoming Document Entry No.");
      TestReadyForProcessing;
      TestIfAlreadyExists;
      CASE SalesHeader."Document Type" OF
        SalesHeader."Document Type"::Invoice:
          "Document Type" := "Document Type"::"Sales Invoice";
        SalesHeader."Document Type"::"Credit Memo":
          "Document Type" := "Document Type"::"Sales Credit Memo";
      END;
      MODIFY;
      IF NOT DocLinkExists(SalesHeader) THEN
        SalesHeader.ADDLINK(GetURL,Description);
    END;

    [Internal]
    PROCEDURE SetPurchDoc@23(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
      IF PurchaseHeader."Incoming Document Entry No." = 0 THEN
        EXIT;
      GET(PurchaseHeader."Incoming Document Entry No.");
      TestReadyForProcessing;
      TestIfAlreadyExists;
      CASE PurchaseHeader."Document Type" OF
        PurchaseHeader."Document Type"::Invoice:
          "Document Type" := "Document Type"::"Purchase Invoice";
        PurchaseHeader."Document Type"::"Credit Memo":
          "Document Type" := "Document Type"::"Purchase Credit Memo";
      END;
      MODIFY;
      IF NOT DocLinkExists(PurchaseHeader) THEN
        PurchaseHeader.ADDLINK(GetURL,Description);
    END;

    LOCAL PROCEDURE DocLinkExists@18(RecVar@1000 : Variant) : Boolean;
    VAR
      RecordLink@1002 : Record 2000000068;
      RecRef@1001 : RecordRef;
    BEGIN
      IF GetURL = '' THEN
        EXIT(TRUE);
      RecRef.GETTABLE(RecVar);
      RecordLink.SETRANGE("Record ID",RecRef.RECORDID);
      RecordLink.SETRANGE(URL1,URL1);
      RecordLink.SETRANGE(Description,Description);
      EXIT(NOT RecordLink.ISEMPTY);
    END;

    [Internal]
    PROCEDURE HyperlinkToDocument@20(DocumentNo@1000 : Code[20];PostingDate@1001 : Date);
    VAR
      IncomingDocumentAttachment@1002 : Record 133;
    BEGIN
      SETRANGE("Document No.",DocumentNo);
      SETRANGE("Posting Date",PostingDate);
      IF NOT FINDFIRST THEN BEGIN
        MESSAGE(NoDocumentMsg);
        EXIT;
      END;
      IF GetURL <> '' THEN BEGIN
        HYPERLINK(GetURL);
        EXIT;
      END;
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.SETFILTER(Type,'<>%1',IncomingDocumentAttachment.Type::XML);
      IF IncomingDocumentAttachment.FINDFIRST THEN
        IncomingDocumentAttachment.Export('',TRUE);
    END;

    [External]
    PROCEDURE ShowCard@26(DocumentNo@1000 : Code[20];PostingDate@1001 : Date);
    BEGIN
      SETRANGE("Document No.",DocumentNo);
      SETRANGE("Posting Date",PostingDate);
      IF NOT FINDFIRST THEN
        EXIT;
      SETRECFILTER;
      PAGE.RUN(PAGE::"Incoming Document",Rec);
    END;

    [External]
    PROCEDURE ShowCardFromEntryNo@32(EntryNo@1000 : Integer);
    BEGIN
      IF EntryNo = 0 THEN
        EXIT;
      GET(EntryNo);
      SETRECFILTER;
      PAGE.RUN(PAGE::"Incoming Document",Rec);
    END;

    [External]
    PROCEDURE ImportAttachment@13(VAR IncomingDocument@1001 : Record 130);
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.NewAttachment;
      IncomingDocument.GET(IncomingDocumentAttachment."Incoming Document Entry No.")
    END;

    [Internal]
    PROCEDURE AddXmlAttachmentFromXmlText@42(VAR IncomingDocumentAttachment@1002 : Record 133;OrgFileName@1000 : Text;XmlText@1001 : Text);
    VAR
      FileManagement@1004 : Codeunit 419;
      OutStr@1003 : OutStream;
    BEGIN
      TESTFIELD("Entry No.");
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IF NOT IncomingDocumentAttachment.FINDLAST THEN
        IncomingDocumentAttachment."Line No." := 10000
      ELSE
        IncomingDocumentAttachment."Line No." += 10000;
      IncomingDocumentAttachment."Incoming Document Entry No." := "Entry No.";
      IncomingDocumentAttachment.INIT;
      IncomingDocumentAttachment.Name :=
        COPYSTR(FileManagement.GetFileNameWithoutExtension(OrgFileName),1,MAXSTRLEN(IncomingDocumentAttachment.Name));
      IncomingDocumentAttachment.VALIDATE("File Extension",'xml');
      IncomingDocumentAttachment.Content.CREATEOUTSTREAM(OutStr,TEXTENCODING::UTF8);
      OutStr.WRITETEXT(XmlText);
      IncomingDocumentAttachment.INSERT(TRUE);
      IF IncomingDocumentAttachment.Type IN [IncomingDocumentAttachment.Type::Image,IncomingDocumentAttachment.Type::PDF] THEN
        IncomingDocumentAttachment.OnAttachBinaryFile;
    END;

    [Internal]
    PROCEDURE AddAttachmentFromStream@43(VAR IncomingDocumentAttachment@1002 : Record 133;OrgFileName@1000 : Text;FileExtension@1006 : Text;VAR InStr@1001 : InStream);
    VAR
      FileManagement@1004 : Codeunit 419;
      OutStr@1003 : OutStream;
    BEGIN
      TESTFIELD("Entry No.");
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IF NOT IncomingDocumentAttachment.FINDLAST THEN
        IncomingDocumentAttachment."Line No." := 10000
      ELSE
        IncomingDocumentAttachment."Line No." += 10000;
      IncomingDocumentAttachment."Incoming Document Entry No." := "Entry No.";
      IncomingDocumentAttachment.INIT;
      IncomingDocumentAttachment.Name :=
        COPYSTR(FileManagement.GetFileNameWithoutExtension(OrgFileName),1,MAXSTRLEN(IncomingDocumentAttachment.Name));
      IncomingDocumentAttachment.VALIDATE(
        "File Extension",COPYSTR(FileExtension,1,MAXSTRLEN(IncomingDocumentAttachment."File Extension")));
      IncomingDocumentAttachment.Content.CREATEOUTSTREAM(OutStr);
      COPYSTREAM(OutStr,InStr);
      IncomingDocumentAttachment.INSERT(TRUE);
    END;

    [Internal]
    PROCEDURE AddAttachmentFromServerFile@44(FileName@1000 : Text;FilePath@1001 : Text);
    VAR
      IncomingDocumentAttachment@1005 : Record 133;
      FileManagement@1004 : Codeunit 419;
      File@1003 : File;
      InStr@1002 : InStream;
    BEGIN
      IF (FileName = '') OR (FilePath = '') THEN
        EXIT;
      IF NOT File.OPEN(FilePath) THEN
        EXIT;
      File.CREATEINSTREAM(InStr);
      AddAttachmentFromStream(IncomingDocumentAttachment,FileName,FileManagement.GetExtension(FileName),InStr);
      File.CLOSE;
      IF ERASE(FilePath) THEN;
    END;

    LOCAL PROCEDURE SetProcessFailed@28(ErrorMsg@1000 : Text[250]);
    VAR
      ErrorMessage@1001 : Record 700;
      ReleaseIncomingDocument@1002 : Codeunit 132;
    BEGIN
      ReleaseIncomingDocument.Fail(Rec);

      IF ErrorMsg = '' THEN BEGIN
        ErrorMsg := COPYSTR(GETLASTERRORTEXT,1,MAXSTRLEN(ErrorMessage.Description));
        CLEARLASTERROR;
      END;

      IF ErrorMsg <> '' THEN BEGIN
        ErrorMessage.SetContext(RECORDID);
        ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error,ErrorMsg);
      END;

      IF GUIALLOWED THEN
        MESSAGE(DocNotCreatedMsg);
    END;

    [TryFunction]
    LOCAL PROCEDURE UpdateDocumentFields@30();
    VAR
      PurchaseHeader@1000 : Record 38;
      SalesHeader@1001 : Record 36;
      GenJournalLine@1002 : Record 81;
    BEGIN
      // If purchase
      PurchaseHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
      IF PurchaseHeader.FINDFIRST THEN BEGIN
        CASE PurchaseHeader."Document Type" OF
          PurchaseHeader."Document Type"::Invoice:
            "Document Type" := "Document Type"::"Purchase Invoice";
          PurchaseHeader."Document Type"::"Credit Memo":
            "Document Type" := "Document Type"::"Purchase Credit Memo";
          ELSE
            ERROR(NotSupportedPurchErr,FORMAT(PurchaseHeader."Document Type"));
        END;
        "Document No." := PurchaseHeader."No.";
        EXIT;
      END;

      // If sales
      SalesHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
      IF SalesHeader.FINDFIRST THEN BEGIN
        CASE SalesHeader."Document Type" OF
          SalesHeader."Document Type"::Invoice:
            "Document Type" := "Document Type"::"Sales Invoice";
          SalesHeader."Document Type"::"Credit Memo":
            "Document Type" := "Document Type"::"Sales Credit Memo";
          ELSE
            ERROR(NotSupportedSalesErr,FORMAT(SalesHeader."Document Type"));
        END;
        "Document No." := SalesHeader."No.";
        EXIT;
      END;

      // If general journal line
      GenJournalLine.SETRANGE("Incoming Document Entry No.","Entry No.");
      IF GenJournalLine.FINDFIRST THEN BEGIN
        "Document No." := GenJournalLine."Document No.";
        EXIT;
      END;

      ERROR(EntityNotFoundErr);
    END;

    LOCAL PROCEDURE ClearErrorMessages@38();
    VAR
      ErrorMessage@1000 : Record 700;
    BEGIN
      ErrorMessage.SETRANGE("Context Record ID",RECORDID);
      ErrorMessage.DELETEALL;
      TempErrorMessage.SETRANGE("Context Record ID",RECORDID);
      TempErrorMessage.DELETEALL;
    END;

    [External]
    PROCEDURE SelectIncomingDocument@29(EntryNo@1000 : Integer;RelatedRecordID@1004 : RecordID) : Integer;
    VAR
      IncomingDocumentsSetup@1003 : Record 131;
      IncomingDocument@1001 : Record 130;
      IncomingDocuments@1002 : Page 190;
    BEGIN
      IF EntryNo <> 0 THEN BEGIN
        IncomingDocument.GET(EntryNo);
        IncomingDocuments.SETRECORD(IncomingDocument);
      END;
      IF IncomingDocumentsSetup.GET THEN
        IF IncomingDocumentsSetup."Require Approval To Create" THEN
          IncomingDocument.SETRANGE(Released,TRUE);
      IncomingDocument.SETRANGE(Posted,FALSE);
      IncomingDocuments.SETTABLEVIEW(IncomingDocument);
      IncomingDocuments.LOOKUPMODE := TRUE;
      IF IncomingDocuments.RUNMODAL = ACTION::LookupOK THEN BEGIN
        IncomingDocuments.GETRECORD(IncomingDocument);
        IncomingDocument.VALIDATE("Related Record ID",RelatedRecordID);
        IncomingDocument.MODIFY;
        EXIT(IncomingDocument."Entry No.");
      END;
      EXIT(EntryNo);
    END;

    [External]
    PROCEDURE SelectIncomingDocumentForPostedDocument@34(DocumentNo@1000 : Code[20];PostingDate@1003 : Date;RelatedRecordID@1005 : RecordID);
    VAR
      IncomingDocument@1001 : Record 130;
      EntryNo@1002 : Integer;
      IsPosted@1004 : Boolean;
    BEGIN
      IF (DocumentNo = '') OR (PostingDate = 0D) THEN
        EXIT;
      EntryNo := SelectIncomingDocument(0,RelatedRecordID);
      IF EntryNo = 0 THEN
        EXIT;

      IncomingDocument.GET(EntryNo);
      IncomingDocument.SetPostedDocFields(PostingDate,DocumentNo);
      IncomingDocument."Document Type" := GetPostedDocType(PostingDate,DocumentNo,IsPosted);
    END;

    [Internal]
    PROCEDURE SendToJobQueue@55(ShowMessages@1001 : Boolean);
    VAR
      SendIncomingDocumentToOCR@1000 : Codeunit 133;
    BEGIN
      SendIncomingDocumentToOCR.SetShowMessages(ShowMessages);
      SendIncomingDocumentToOCR.SendToJobQueue(Rec);
    END;

    [Internal]
    PROCEDURE ResetOriginalOCRData@46();
    VAR
      OCRServiceMgt@1000 : Codeunit 1294;
      OriginalXMLRootNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      OCRServiceMgt.GetOriginalOCRXMLRootNode(Rec,OriginalXMLRootNode);
      OCRServiceMgt.UpdateIncomingDocWithOCRData(Rec,OriginalXMLRootNode);
    END;

    [Internal]
    PROCEDURE UploadCorrectedOCRData@49() : Boolean;
    VAR
      OCRServiceMgt@1000 : Codeunit 1294;
    BEGIN
      EXIT(OCRServiceMgt.UploadCorrectedOCRFile(Rec))
    END;

    [External]
    PROCEDURE SaveErrorMessages@39(VAR TempErrorMessageRef@1000 : TEMPORARY Record 700);
    BEGIN
      IF NOT TempErrorMessageRef.FINDSET THEN
        EXIT;

      REPEAT
        TempErrorMessage := TempErrorMessageRef;
        TempErrorMessage.INSERT;
      UNTIL TempErrorMessageRef.NEXT = 0;
    END;

    [External]
    PROCEDURE RemoveFromJobQueue@41(ShowMessages@1001 : Boolean);
    VAR
      SendIncomingDocumentToOCR@1000 : Codeunit 133;
    BEGIN
      SendIncomingDocumentToOCR.SetShowMessages(ShowMessages);
      SendIncomingDocumentToOCR.RemoveFromJobQueue(Rec);
    END;

    [Internal]
    PROCEDURE SendToOCR@31(ShowMessages@1001 : Boolean);
    VAR
      SendIncomingDocumentToOCR@1000 : Codeunit 133;
    BEGIN
      SendIncomingDocumentToOCR.SetShowMessages(ShowMessages);
      SendIncomingDocumentToOCR.SendDocToOCR(Rec);
      SendIncomingDocumentToOCR.ScheduleJobQueueReceive;
    END;

    [External]
    PROCEDURE SetStatus@66(NewStatus@1000 : Option);
    BEGIN
      Status := NewStatus;
      MODIFY;
    END;

    [Internal]
    PROCEDURE RetrieveFromOCR@37(ShowMessages@1001 : Boolean);
    VAR
      SendIncomingDocumentToOCR@1000 : Codeunit 133;
    BEGIN
      SendIncomingDocumentToOCR.SetShowMessages(ShowMessages);
      SendIncomingDocumentToOCR.RetrieveDocFromOCR(Rec);
    END;

    [External]
    PROCEDURE GetGeneratedFromOCRAttachment@57(VAR IncomingDocumentAttachment@1000 : Record 133) : Boolean;
    BEGIN
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.SETRANGE("Generated from OCR",TRUE);
      EXIT(IncomingDocumentAttachment.FINDFIRST)
    END;

    [External]
    PROCEDURE GetDataExchangePath@48(FieldNumber@1000 : Integer) : Text;
    VAR
      DataExchangeType@1001 : Record 1213;
      DataExchLineDef@1003 : Record 1227;
      PurchaseHeader@1002 : Record 38;
      VendorBankAccount@1004 : Record 288;
      Vendor@1005 : Record 23;
      GLEntry@1006 : Record 17;
      DataExchangePath@1007 : Text;
    BEGIN
      IF NOT DataExchangeType.GET("Data Exchange Type") THEN
        EXIT('');
      DataExchLineDef.SETRANGE("Data Exch. Def Code",DataExchangeType."Data Exch. Def. Code");
      DataExchLineDef.SETRANGE("Parent Code",'');
      IF NOT DataExchLineDef.FINDFIRST THEN
        EXIT('');
      CASE FieldNumber OF
        FIELDNO("Vendor Name"):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Buy-from Vendor Name")));
        FIELDNO("Vendor Id"):
          EXIT(DataExchLineDef.GetPath(DATABASE::Vendor,Vendor.FIELDNO(Id)));
        FIELDNO("Vendor VAT Registration No."):
          EXIT(DataExchLineDef.GetPath(DATABASE::Vendor,Vendor.FIELDNO("VAT Registration No.")));
        FIELDNO("Vendor IBAN"):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Vendor Bank Account",VendorBankAccount.FIELDNO(IBAN)));
        FIELDNO("Vendor Bank Branch No."):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Vendor Bank Account",VendorBankAccount.FIELDNO("Bank Branch No.")));
        FIELDNO("Vendor Bank Account No."):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Vendor Bank Account",VendorBankAccount.FIELDNO("Bank Account No.")));
        FIELDNO("Vendor Phone No."):
          EXIT(DataExchLineDef.GetPath(DATABASE::Vendor,Vendor.FIELDNO("Phone No.")));
        FIELDNO("Vendor Invoice No."):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Vendor Invoice No.")));
        FIELDNO("Document Date"):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Document Date")));
        FIELDNO("Due Date"):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Due Date")));
        FIELDNO("Currency Code"):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Currency Code")));
        FIELDNO("Amount Excl. VAT"):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO(Amount)));
        FIELDNO("Amount Incl. VAT"):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Amount Including VAT")));
        FIELDNO("Order No."):
          EXIT(DataExchLineDef.GetPath(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Vendor Order No.")));
        FIELDNO("VAT Amount"):
          EXIT(DataExchLineDef.GetPath(DATABASE::"G/L Entry",GLEntry.FIELDNO("VAT Amount")));
        ELSE BEGIN
          OnGetDataExchangePath(DataExchLineDef,FieldNumber,DataExchangePath);
          IF  DataExchangePath <> '' THEN
            EXIT(DataExchangePath);
        END;
      END;

      EXIT('');
    END;

    [Internal]
    PROCEDURE ShowNAVRecord@80();
    VAR
      PageManagement@1000 : Codeunit 700;
      DataTypeManagement@1003 : Codeunit 701;
      RecRef@1002 : RecordRef;
      RelatedRecord@1001 : Variant;
    BEGIN
      IF GetNAVRecord(RelatedRecord) THEN BEGIN
        DataTypeManagement.GetRecordRef(RelatedRecord,RecRef);
        PageManagement.PageRun(RecRef);
      END;
    END;

    [External]
    PROCEDURE GetNAVRecord@59(VAR RelatedRecord@1001 : Variant) : Boolean;
    BEGIN
      IF Posted THEN
        EXIT(GetPostedNAVRecord(RelatedRecord));
      EXIT(GetUnpostedNAVRecord(RelatedRecord));
    END;

    LOCAL PROCEDURE GetPostedNAVRecord@53(VAR RelatedRecord@1000 : Variant) : Boolean;
    VAR
      RelatedRecordRef@1001 : RecordRef;
    BEGIN
      IF GetRelatedRecord(RelatedRecordRef) THEN BEGIN
        RelatedRecord := RelatedRecordRef;
        EXIT(TRUE);
      END;
      EXIT(FindPostedNAVRecord(RelatedRecord));
    END;

    LOCAL PROCEDURE FindPostedNAVRecord@96(VAR RelatedRecord@1000 : Variant) : Boolean;
    VAR
      SalesInvoiceHeader@1004 : Record 112;
      SalesCrMemoHeader@1005 : Record 114;
      PurchInvHeader@1003 : Record 122;
      PurchCrMemoHdr@1006 : Record 124;
      GLEntry@1002 : Record 17;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Journal:
          BEGIN
            GLEntry.SETCURRENTKEY("Document No.","Posting Date");
            GLEntry.SETRANGE("Document No.","Document No.");
            GLEntry.SETRANGE("Posting Date","Posting Date");
            IF GLEntry.FINDFIRST THEN BEGIN
              RelatedRecord := GLEntry;
              EXIT(TRUE);
            END;
          END;
        "Document Type"::"Sales Invoice":
          IF SalesInvoiceHeader.GET("Document No.") THEN BEGIN
            RelatedRecord := SalesInvoiceHeader;
            EXIT(TRUE);
          END;
        "Document Type"::"Sales Credit Memo":
          IF SalesCrMemoHeader.GET("Document No.") THEN BEGIN
            RelatedRecord := SalesCrMemoHeader;
            EXIT(TRUE);
          END;
        "Document Type"::"Purchase Invoice":
          IF PurchInvHeader.GET("Document No.") THEN BEGIN
            RelatedRecord := PurchInvHeader;
            EXIT(TRUE);
          END;
        "Document Type"::"Purchase Credit Memo":
          IF PurchCrMemoHdr.GET("Document No.") THEN BEGIN
            RelatedRecord := PurchCrMemoHdr;
            EXIT(TRUE);
          END;
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetUnpostedNAVRecord@54(VAR RelatedRecord@1000 : Variant) : Boolean;
    VAR
      RelatedRecordRef@1001 : RecordRef;
    BEGIN
      IF GetRelatedRecord(RelatedRecordRef) THEN BEGIN
        RelatedRecord := RelatedRecordRef;
        EXIT(TRUE);
      END;
      EXIT(FindUnpostedNAVRecord(RelatedRecord));
    END;

    LOCAL PROCEDURE FindUnpostedNAVRecord@95(VAR RelatedRecord@1000 : Variant) : Boolean;
    VAR
      SalesHeader@1005 : Record 36;
      PurchaseHeader@1004 : Record 38;
      GenJournalLine@1003 : Record 81;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Journal:
          BEGIN
            GenJournalLine.SETRANGE("Incoming Document Entry No.","Entry No.");
            IF GenJournalLine.FINDFIRST THEN BEGIN
              GenJournalLine.SETRANGE("Journal Batch Name",GenJournalLine."Journal Batch Name");
              GenJournalLine.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
              RelatedRecord := GenJournalLine;
              EXIT(TRUE)
            END;
          END;
        "Document Type"::"Sales Invoice",
        "Document Type"::"Sales Credit Memo":
          BEGIN
            SalesHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            IF SalesHeader.FINDFIRST THEN BEGIN
              RelatedRecord := SalesHeader;
              EXIT(TRUE);
            END;
          END;
        "Document Type"::"Purchase Invoice",
        "Document Type"::"Purchase Credit Memo":
          BEGIN
            PurchaseHeader.SETRANGE("Incoming Document Entry No.","Entry No.");
            IF PurchaseHeader.FINDFIRST THEN BEGIN
              RelatedRecord := PurchaseHeader;
              EXIT(TRUE);
            END;
          END;
      END;
      EXIT(FALSE)
    END;

    LOCAL PROCEDURE GetRelatedRecord@92(VAR RelatedRecordRef@1000 : RecordRef) : Boolean;
    VAR
      RelatedRecordID@1001 : RecordID;
    BEGIN
      RelatedRecordID := "Related Record ID";
      IF RelatedRecordID.TABLENO = 0 THEN
        EXIT(FALSE);
      RelatedRecordRef := RelatedRecordID.GETRECORD;
      EXIT(RelatedRecordRef.GET(RelatedRecordID));
    END;

    [External]
    PROCEDURE RemoveLinkToRelatedRecord@84();
    VAR
      DummyRecordID@1000 : RecordID;
    BEGIN
      "Related Record ID" := DummyRecordID;
      "Document No." := '';
      "Document Type" := "Document Type"::" ";
      MODIFY(TRUE);
    END;

    [External]
    PROCEDURE RemoveReferencedRecords@11();
    VAR
      RecRef@1000 : RecordRef;
      NavRecordVariant@1001 : Variant;
    BEGIN
      IF Posted THEN
        UndoPostedDocFields
      ELSE BEGIN
        IF NOT CONFIRM(DoYouWantToRemoveReferenceQst) THEN
          EXIT;

        IF CONFIRM(DeleteRecordQst) THEN
          IF GetNAVRecord(NavRecordVariant) THEN BEGIN
            RecRef.GETTABLE(NavRecordVariant);
            RecRef.DELETE(TRUE);
            EXIT;
          END;

        RemoveIncomingDocumentEntryNoFromUnpostedDocument;
        RemoveReferenceToWorkingDocument("Entry No.");
      END;
    END;

    [Internal]
    PROCEDURE CreateFromAttachment@52();
    VAR
      IncomingDocumentAttachment@1001 : Record 133;
      IncomingDocument@1004 : Record 130;
    BEGIN
      IF IncomingDocumentAttachment.Import THEN BEGIN
        IncomingDocument.GET(IncomingDocumentAttachment."Incoming Document Entry No.");
        PAGE.RUN(PAGE::"Incoming Document",IncomingDocument);
      END;
    END;

    [External]
    PROCEDURE GetMainAttachment@16(VAR IncomingDocumentAttachment@1001 : Record 133) : Boolean;
    BEGIN
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.SETRANGE("Main Attachment",TRUE);
      EXIT(IncomingDocumentAttachment.FINDFIRST);
    END;

    [External]
    PROCEDURE GetMainAttachmentFileName@60() : Text;
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IF GetMainAttachment(IncomingDocumentAttachment) THEN
        EXIT(IncomingDocumentAttachment.GetFullName);

      EXIT('');
    END;

    [External]
    PROCEDURE GetRecordLinkText@50() : Text;
    VAR
      DataTypeManagement@1001 : Codeunit 701;
      RecRef@1000 : RecordRef;
      VariantRecord@1002 : Variant;
    BEGIN
      IF GetNAVRecord(VariantRecord) AND DataTypeManagement.GetRecordRef(VariantRecord,RecRef) THEN
        EXIT(GetRelatedRecordCaption(RecRef));
      EXIT('');
    END;

    LOCAL PROCEDURE GetRelatedRecordCaption@93(VAR RelatedRecordRef@1003 : RecordRef) : Text;
    VAR
      GenJournalLine@1001 : Record 81;
      RecCaption@1000 : Text;
    BEGIN
      IF RelatedRecordRef.ISEMPTY THEN
        EXIT('');

      CASE RelatedRecordRef.NUMBER OF
        DATABASE::"Sales Header":
          RecCaption := STRSUBSTNO('%1 %2',SalesTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"Sales Invoice Header":
          RecCaption := STRSUBSTNO('%1 - %2',SalesInvoiceTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"Sales Cr.Memo Header":
          RecCaption := STRSUBSTNO('%1 - %2',SalesCreditMemoTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"Purchase Header":
          RecCaption := STRSUBSTNO('%1 %2',PurchaseTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"Purch. Inv. Header":
          RecCaption := STRSUBSTNO('%1 - %2',PurchaseInvoiceTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"Purch. Cr. Memo Hdr.":
          RecCaption := STRSUBSTNO('%1 - %2',PurchaseCreditMemoTxt,GetRecordCaption(RelatedRecordRef));
        DATABASE::"G/L Entry":
          RecCaption := STRSUBSTNO('%1 - %2',"Document Type",GeneralLedgerEntriesTxt);
        DATABASE::"Gen. Journal Line":
          IF Posted THEN
            RecCaption := STRSUBSTNO('%1 - %2',"Document Type",GeneralLedgerEntriesTxt)
          ELSE BEGIN
            RelatedRecordRef.SETTABLE(GenJournalLine);
            IF GenJournalLine."Document Type" <> GenJournalLine."Document Type"::" " THEN
              RecCaption := STRSUBSTNO('%1 - %2',GenJournalLine."Document Type",GetRecordCaption(RelatedRecordRef))
            ELSE
              RecCaption := STRSUBSTNO('%1 - %2',JournalTxt,GetRecordCaption(RelatedRecordRef));
          END;
        ELSE
          RecCaption := STRSUBSTNO('%1 - %2',RelatedRecordRef.CAPTION,GetRecordCaption(RelatedRecordRef));
      END;
      EXIT(RecCaption)
    END;

    LOCAL PROCEDURE GetRecordCaption@81(VAR RecRef@1005 : RecordRef) : Text;
    VAR
      KeyRef@1003 : KeyRef;
      FieldRef@1001 : FieldRef;
      KeyNo@1006 : Integer;
      FieldNo@1007 : Integer;
      RecCaption@1000 : Text;
    BEGIN
      FOR KeyNo := 1 TO RecRef.KEYCOUNT DO BEGIN
        KeyRef := RecRef.KEYINDEX(KeyNo);
        IF KeyRef.ACTIVE THEN BEGIN
          FOR FieldNo := 1 TO KeyRef.FIELDCOUNT DO BEGIN
            FieldRef := KeyRef.FIELDINDEX(FieldNo);
            IF RecCaption <> '' THEN
              RecCaption := STRSUBSTNO('%1 - %2',RecCaption,FieldRef.VALUE)
            ELSE
              RecCaption := FORMAT(FieldRef.VALUE);
          END;
          BREAK;
        END
      END;
      EXIT(RecCaption);
    END;

    [External]
    PROCEDURE GetOCRResutlFileName@56() : Text;
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
      FileName@1001 : Text;
    BEGIN
      FileName := '';
      IF GetGeneratedFromOCRAttachment(IncomingDocumentAttachment) THEN
        FileName := IncomingDocumentAttachment.GetFullName;

      EXIT(FileName);
    END;

    [Internal]
    PROCEDURE MainAttachmentDrillDown@47();
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IF NOT GetMainAttachment(IncomingDocumentAttachment) THEN BEGIN
        IncomingDocumentAttachment.NewAttachment;
        EXIT;
      END;

      // Download
      IncomingDocumentAttachment.Export('',TRUE);
    END;

    [Internal]
    PROCEDURE ReplaceOrInsertMainAttachment@71();
    BEGIN
      ReplaceMainAttachment('');
    END;

    [Internal]
    PROCEDURE ReplaceMainAttachment@69(FilePath@1001 : Text);
    VAR
      MainIncomingDocumentAttachment@1002 : Record 133;
      NewIncomingDocumentAttachment@1004 : Record 133;
      ImportAttachmentIncDoc@1003 : Codeunit 134;
    BEGIN
      IF NOT CanReplaceMainAttachment THEN
        ERROR(CannotReplaceMainAttachmentErr);

      IF NOT GetMainAttachment(MainIncomingDocumentAttachment) THEN BEGIN
        MainIncomingDocumentAttachment.NewAttachment;
        EXIT;
      END;

      IF NOT CONFIRM(ReplaceMainAttachmentQst) THEN
        EXIT;

      IF FilePath = '' THEN
        ImportAttachmentIncDoc.UploadFile(NewIncomingDocumentAttachment,FilePath);

      IF FilePath = '' THEN
        EXIT;

      MainIncomingDocumentAttachment.DELETE;
      COMMIT;

      NewIncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      ImportAttachmentIncDoc.ImportAttachment(NewIncomingDocumentAttachment,FilePath);
    END;

    [Internal]
    PROCEDURE ShowMainAttachment@70();
    VAR
      IncomingDocumentAttachment@1001 : Record 133;
    BEGIN
      IF GetMainAttachment(IncomingDocumentAttachment) THEN
        IncomingDocumentAttachment.Export('',TRUE);
    END;

    [Internal]
    PROCEDURE OCRResultDrillDown@58();
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IF NOT GetGeneratedFromOCRAttachment(IncomingDocumentAttachment) THEN
        EXIT;

      IncomingDocumentAttachment.Export('',TRUE);
    END;

    [External]
    PROCEDURE GetAdditionalAttachments@61(VAR IncomingDocumentAttachment@1001 : Record 133) : Boolean;
    BEGIN
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.SETRANGE("Main Attachment",FALSE);
      IncomingDocumentAttachment.SETRANGE("Generated from OCR",FALSE);
      EXIT(IncomingDocumentAttachment.FINDSET);
    END;

    [External]
    PROCEDURE DefaultAttachmentIsXML@62() : Boolean;
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IncomingDocumentAttachment.SETRANGE(Default,TRUE);

      IF IncomingDocumentAttachment.FINDFIRST THEN
        EXIT(IncomingDocumentAttachment.Type = IncomingDocumentAttachment.Type::XML);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE FindByDocumentNoAndPostingDate@67(MainRecordRef@1003 : RecordRef;VAR IncomingDocument@1006 : Record 130) : Boolean;
    VAR
      SalesInvoiceHeader@1000 : Record 112;
      VATEntry@1002 : Record 254;
      DataTypeManagement@1001 : Codeunit 701;
      DocumentNoFieldRef@1004 : FieldRef;
      PostingDateFieldRef@1005 : FieldRef;
      PostingDate@1007 : Date;
    BEGIN
      IF NOT DataTypeManagement.FindFieldByName(MainRecordRef,DocumentNoFieldRef,SalesInvoiceHeader.FIELDNAME("No.")) THEN
        IF NOT DataTypeManagement.FindFieldByName(MainRecordRef,DocumentNoFieldRef,VATEntry.FIELDNAME("Document No.")) THEN
          EXIT(FALSE);

      IF NOT DataTypeManagement.FindFieldByName(MainRecordRef,PostingDateFieldRef,SalesInvoiceHeader.FIELDNAME("Posting Date")) THEN
        EXIT(FALSE);

      IncomingDocument.SETRANGE("Document No.",FORMAT(DocumentNoFieldRef.VALUE));
      EVALUATE(PostingDate,FORMAT(PostingDateFieldRef.VALUE));
      IncomingDocument.SETRANGE("Posting Date",PostingDate);
      IF (FORMAT(DocumentNoFieldRef.VALUE) = '') OR (PostingDate = 0D) THEN
        EXIT;
      EXIT(IncomingDocument.FINDFIRST);
    END;

    [External]
    PROCEDURE FindFromIncomingDocumentEntryNo@68(MainRecordRef@1001 : RecordRef;VAR IncomingDocument@1000 : Record 130) : Boolean;
    VAR
      SalesHeader@1008 : Record 36;
      DataTypeManagement@1006 : Codeunit 701;
      IncomingDocumentEntryNoFieldRef@1002 : FieldRef;
    BEGIN
      IF NOT DataTypeManagement.FindFieldByName(
           MainRecordRef,IncomingDocumentEntryNoFieldRef,SalesHeader.FIELDNAME("Incoming Document Entry No."))
      THEN
        EXIT(FALSE);

      EXIT(IncomingDocument.GET(FORMAT(IncomingDocumentEntryNoFieldRef.VALUE)));
    END;

    [External]
    PROCEDURE GetStatusStyleText@22() : Text;
    BEGIN
      CASE Status OF
        Status::Rejected,
        Status::Failed:
          EXIT('Unfavorable');
        ELSE
          EXIT('Standard');
      END;
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnCheckIncomingDocReleaseRestrictions@63();
    BEGIN
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnCheckIncomingDocCreateDocRestrictions@64();
    BEGIN
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnCheckIncomingDocSetForOCRRestrictions@65();
    BEGIN
    END;

    [External]
    PROCEDURE WaitingToReceiveFromOCR@74() : Boolean;
    BEGIN
      IF "OCR Status" IN ["OCR Status"::Sent,"OCR Status"::"Awaiting Verification"] THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE OCRIsEnabled@78() : Boolean;
    VAR
      OCRServiceSetup@1000 : Record 1270;
    BEGIN
      IF NOT OCRServiceSetup.GET THEN
        EXIT(FALSE);
      EXIT(OCRServiceSetup.Enabled);
    END;

    [Internal]
    PROCEDURE IsADocumentAttached@75() : Boolean;
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
      IF GetURL = '' THEN
        IF IncomingDocumentAttachment.ISEMPTY THEN
          EXIT(FALSE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE TestReadyForApproval@76();
    BEGIN
      IF IsADocumentAttached THEN
        EXIT;
      ERROR(NoDocAttachErr);
    END;

    [Integration]
    [External]
    PROCEDURE OnAfterCreateGenJnlLineFromIncomingDocSuccess@86(VAR IncomingDocument@1000 : Record 130);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnAfterCreateGenJnlLineFromIncomingDocFail@85(VAR IncomingDocument@1000 : Record 130);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnAfterCreateSalesHeaderFromIncomingDoc@90(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnAfterCreatePurchHeaderFromIncomingDoc@94(VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnGetDataExchangePath@89(DataExchLineDef@1000 : Record 1227;FieldNumber@1001 : Integer;VAR DataExchangePath@1002 : Text);
    BEGIN
    END;

    [External]
    PROCEDURE HasAttachment@88() : Boolean;
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      EXIT(GetMainAttachment(IncomingDocumentAttachment));
    END;

    [External]
    PROCEDURE CanReplaceMainAttachment@91() : Boolean;
    BEGIN
      IF NOT HasAttachment THEN
        EXIT(TRUE);
      EXIT(NOT WasSentToOCR);
    END;

    LOCAL PROCEDURE WasSentToOCR@87() : Boolean;
    BEGIN
      EXIT("OCR Status" <> "OCR Status"::" ");
    END;

    BEGIN
    END.
  }
}

