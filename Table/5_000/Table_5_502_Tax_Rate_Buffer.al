OBJECT Table 5502 Tax Rate Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Skattesatsbuffer;
               ENU=Tax Rate Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Tax Area ID         ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skatteomr�de-id;
                                                              ENU=Tax Area ID];
                                                   Editable=No }
    { 2   ;   ;Tax Group ID        ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattegruppe-id;
                                                              ENU=Tax Group ID];
                                                   Editable=No }
    { 3   ;   ;Tax Rate            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattesats;
                                                              ENU=Tax Rate];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Tax Area ID,Tax Group ID                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      RecordMustBeTemporaryErr@1000 : TextConst 'DAN=Skattesatsbufferenhed skal bruges som en midlertidig record.;ENU=Tax Rate Buffer Entity must be used as a temporary record.';

    PROCEDURE LoadRecords@1();
    VAR
      GeneralLedgerSetup@1002 : Record 98;
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(RecordMustBeTemporaryErr);

      IF GeneralLedgerSetup.UseVat THEN
        LoadVATRates
      ELSE
        LoadSalesTaxRates;
    END;

    LOCAL PROCEDURE LoadVATRates@7();
    VAR
      TempTaxAreaBuffer@1002 : TEMPORARY Record 5504;
      TempTaxGroupBuffer@1001 : TEMPORARY Record 5480;
      VATPostingSetup@1000 : Record 325;
    BEGIN
      IF NOT VATPostingSetup.FINDSET THEN
        EXIT;

      TempTaxGroupBuffer.LoadRecords;
      TempTaxAreaBuffer.LoadRecords;

      REPEAT
        InsertTaxRate(
          VATPostingSetup."VAT Prod. Posting Group",VATPostingSetup."VAT Bus. Posting Group",VATPostingSetup."VAT %",
          TempTaxAreaBuffer,TempTaxGroupBuffer);
      UNTIL VATPostingSetup.NEXT = 0;
    END;

    LOCAL PROCEDURE LoadSalesTaxRates@8();
    VAR
      TempTaxAreaBuffer@1001 : TEMPORARY Record 5504;
      TempSearchTaxAreaBuffer@1004 : TEMPORARY Record 5504;
      TempTaxGroupBuffer@1000 : TEMPORARY Record 5480;
      DummyTaxDetail@1002 : Record 322;
      TaxGroupsForTaxAreas@1005 : Query 5502;
      TaxRate@1003 : Decimal;
    BEGIN
      TempTaxAreaBuffer.LoadRecords;
      IF NOT TempTaxAreaBuffer.FIND('-') THEN
        EXIT;

      TempSearchTaxAreaBuffer.COPY(TempTaxAreaBuffer,TRUE);
      TempTaxGroupBuffer.LoadRecords;

      REPEAT
        TaxGroupsForTaxAreas.SETRANGE(Tax_Area_Code,TempTaxAreaBuffer.Code);
        IF NOT TaxGroupsForTaxAreas.OPEN THEN
          EXIT;

        IF NOT TaxGroupsForTaxAreas.READ THEN
          EXIT;

        REPEAT
          TaxRate := DummyTaxDetail.GetSalesTaxRate(TempTaxAreaBuffer.Code,TaxGroupsForTaxAreas.Tax_Group_Code,WORKDATE,TRUE);
          InsertTaxRate(
            TaxGroupsForTaxAreas.Tax_Group_Code,TempTaxAreaBuffer.Code,TaxRate,TempSearchTaxAreaBuffer,TempTaxGroupBuffer);
        UNTIL NOT TaxGroupsForTaxAreas.READ;
      UNTIL TempTaxAreaBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE FindTaxGroupByCode@17(TaxGroupCode@1001 : Code[20];VAR TempTaxGroupBuffer@1000 : TEMPORARY Record 5480) : Boolean;
    BEGIN
      TempTaxGroupBuffer.SETRANGE(Code,TaxGroupCode);
      EXIT(TempTaxGroupBuffer.FINDFIRST);
    END;

    LOCAL PROCEDURE FindTaxAreaByCode@18(TaxAreaCode@1001 : Code[20];VAR TempTaxAreaBuffer@1000 : TEMPORARY Record 5504) : Boolean;
    BEGIN
      TempTaxAreaBuffer.SETRANGE(Code,TaxAreaCode);
      EXIT(TempTaxAreaBuffer.FINDFIRST);
    END;

    LOCAL PROCEDURE InsertTaxRate@2(TaxGroupCode@1000 : Code[20];TaxAreaCode@1001 : Code[20];TaxRate@1004 : Decimal;VAR TempTaxAreaBuffer@1002 : TEMPORARY Record 5504;VAR TempTaxGroupBuffer@1003 : TEMPORARY Record 5480);
    BEGIN
      CLEAR(Rec);
      IF TaxGroupCode <> '' THEN
        IF FindTaxGroupByCode(TaxGroupCode,TempTaxGroupBuffer) THEN
          VALIDATE("Tax Group ID",TempTaxGroupBuffer.Id)
        ELSE
          EXIT;

      IF TaxAreaCode <> '' THEN
        IF FindTaxAreaByCode(TaxAreaCode,TempTaxAreaBuffer) THEN
          VALIDATE("Tax Area ID",TempTaxAreaBuffer.Id)
        ELSE
          EXIT;

      VALIDATE("Tax Rate",TaxRate);
      IF NOT INSERT(TRUE) THEN
        MODIFY(TRUE);
    END;

    BEGIN
    END.
  }
}

