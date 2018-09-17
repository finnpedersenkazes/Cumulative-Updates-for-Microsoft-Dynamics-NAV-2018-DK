OBJECT Table 1207 Direct Debit Collection
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Identifier,Created Date-Time;
    CaptionML=[DAN=Direct Debit-opkr‘vning;
               ENU=Direct Debit Collection];
    LookupPageID=Page1207;
    DrillDownPageID=Page1207;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Identifier          ;Code20        ;CaptionML=[DAN=Id;
                                                              ENU=Identifier] }
    { 3   ;   ;Created Date-Time   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl‘t;
                                                              ENU=Created Date-Time] }
    { 4   ;   ;Created by User     ;Code50        ;TableRelation=User."User Name";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af bruger;
                                                              ENU=Created by User] }
    { 5   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Ny,Annulleret,Fil oprettet,Bogf›rt,Lukket;
                                                                    ENU=New,Canceled,File Created,Posted,Closed];
                                                   OptionString=New,Canceled,File Created,Posted,Closed }
    { 6   ;   ;No. of Transfers    ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Direct Debit Collection Entry" WHERE (Direct Debit Collection No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal overflytninger;
                                                              ENU=No. of Transfers] }
    { 7   ;   ;To Bank Account No. ;Code20        ;TableRelation="Bank Account";
                                                   CaptionML=[DAN=Til bankkontonr.;
                                                              ENU=To Bank Account No.] }
    { 8   ;   ;To Bank Account Name;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Bank Account".Name WHERE (No.=FIELD(To Bank Account No.)));
                                                   CaptionML=[DAN=Til bankkontonavn;
                                                              ENU=To Bank Account Name] }
    { 9   ;   ;Message ID          ;Code35        ;CaptionML=[DAN=Meddelelses-id;
                                                              ENU=Message ID] }
    { 10  ;   ;Partner Type        ;Option        ;CaptionML=[DAN=Partnertype;
                                                              ENU=Partner Type];
                                                   OptionCaptionML=[DAN=" ,Virksomhed,Person";
                                                                    ENU=" ,Company,Person"];
                                                   OptionString=[ ,Company,Person];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CloseQst@1000 : TextConst 'DAN=Hvis du lukker opkr‘vningen, kan du ikke registrere betalingerne fra opkr‘vningen. Vil du lukke opkr‘vningen alligevel?;ENU=If you close the collection, you will not be able to register the payments from the collection. Do you want to close the collection anyway?';

    [External]
    PROCEDURE CreateNew@1(NewIdentifier@1000 : Code[20];NewBankAccountNo@1001 : Code[20];PartnerType@1002 : Option);
    BEGIN
      RESET;
      LOCKTABLE;
      IF FINDLAST THEN;
      INIT;
      "No." += 1;
      Identifier := NewIdentifier;
      "Message ID" := Identifier;
      "Created Date-Time" := CURRENTDATETIME;
      "Created by User" := USERID;
      "To Bank Account No." := NewBankAccountNo;
      "Partner Type" := PartnerType;
      INSERT;
    END;

    [External]
    PROCEDURE CloseCollection@2();
    VAR
      DirectDebitCollectionEntry@1000 : Record 1208;
    BEGIN
      IF Status IN [Status::Closed,Status::Canceled] THEN
        EXIT;
      IF NOT CONFIRM(CloseQst) THEN
        EXIT;

      IF Status = Status::New THEN
        Status := Status::Canceled
      ELSE
        Status := Status::Closed;
      MODIFY;

      DirectDebitCollectionEntry.SETRANGE("Direct Debit Collection No.","No.");
      DirectDebitCollectionEntry.SETRANGE(Status,DirectDebitCollectionEntry.Status::New);
      DirectDebitCollectionEntry.MODIFYALL(Status,DirectDebitCollectionEntry.Status::Rejected);
    END;

    [Internal]
    PROCEDURE Export@5();
    VAR
      DirectDebitCollectionEntry@1000 : Record 1208;
    BEGIN
      DirectDebitCollectionEntry.SETRANGE("Direct Debit Collection No.","No.");
      IF DirectDebitCollectionEntry.FINDFIRST THEN
        DirectDebitCollectionEntry.ExportSEPA;
    END;

    [External]
    PROCEDURE HasPaymentFileErrors@4() : Boolean;
    VAR
      GenJnlLine@1000 : Record 81;
    BEGIN
      GenJnlLine."Document No." := COPYSTR(FORMAT("No."),1,MAXSTRLEN(GenJnlLine."Document No."));
      EXIT(GenJnlLine.HasPaymentFileErrorsInBatch);
    END;

    [External]
    PROCEDURE SetStatus@3(NewStatus@1000 : Option);
    BEGIN
      LOCKTABLE;
      FIND;
      Status := NewStatus;
      MODIFY;
    END;

    [External]
    PROCEDURE DeletePaymentFileErrors@6();
    VAR
      DirectDebitCollectionEntry@1000 : Record 1208;
    BEGIN
      DirectDebitCollectionEntry.SETRANGE("Direct Debit Collection No.","No.");
      IF DirectDebitCollectionEntry.FINDSET THEN
        REPEAT
          DirectDebitCollectionEntry.DeletePaymentFileErrors;
        UNTIL DirectDebitCollectionEntry.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

