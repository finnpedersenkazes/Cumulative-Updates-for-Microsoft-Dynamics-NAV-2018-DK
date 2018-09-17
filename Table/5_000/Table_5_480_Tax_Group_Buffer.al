OBJECT Table 5480 Tax Group Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnRename=BEGIN
               ERROR(CannotChangeIDErr);
             END;

    CaptionML=[DAN=Skattegruppebuffer;
               ENU=Tax Group Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 8000;   ;Id                  ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 8005;   ;Last Modified DateTime;DateTime    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato/klokkesl�t for seneste �ndring;
                                                              ENU=Last Modified DateTime] }
    { 9600;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[@@@={Locked};
                                                                    DAN=Sales Tax,VAT;
                                                                    ENU=Sales Tax,VAT];
                                                   OptionString=Sales Tax,VAT }
  }
  KEYS
  {
    {    ;Id                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CannotChangeIDErr@1001 : TextConst '@@@={Locked};DAN=The id cannot be changed.;ENU=The id cannot be changed.';
      RecordMustBeTemporaryErr@1000 : TextConst 'DAN=Skattegruppeenhed skal bruges som en midlertidig record.;ENU=Tax Group Entity must be used as a temporary record.';

    PROCEDURE PropagateInsert@1();
    BEGIN
      PropagateUpdate(TRUE);
    END;

    PROCEDURE PropagateModify@2();
    BEGIN
      PropagateUpdate(FALSE);
    END;

    LOCAL PROCEDURE PropagateUpdate@4(Insert@1000 : Boolean);
    VAR
      GeneralLedgerSetup@1001 : Record 98;
      VATProductPostingGroup@1002 : Record 324;
      TaxGroup@1003 : Record 321;
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(RecordMustBeTemporaryErr);

      IF GeneralLedgerSetup.UseVat THEN BEGIN
        IF Insert THEN BEGIN
          VATProductPostingGroup.TRANSFERFIELDS(Rec,TRUE);
          VATProductPostingGroup.INSERT(TRUE)
        END ELSE BEGIN
          IF xRec.Code <> Code THEN BEGIN
            VATProductPostingGroup.GET(xRec.Code);
            VATProductPostingGroup.RENAME(Code);
          END;

          VATProductPostingGroup.TRANSFERFIELDS(Rec,TRUE);
          VATProductPostingGroup.MODIFY(TRUE);
        END;

        UpdateFromVATProductPostingGroup(VATProductPostingGroup);
      END ELSE BEGIN
        IF Insert THEN BEGIN
          TaxGroup.TRANSFERFIELDS(Rec,TRUE);
          TaxGroup.INSERT(TRUE)
        END ELSE BEGIN
          IF xRec.Code <> Code THEN BEGIN
            TaxGroup.GET(xRec.Code);
            TaxGroup.RENAME(TRUE)
          END;

          TaxGroup.TRANSFERFIELDS(Rec,TRUE);
          TaxGroup.MODIFY(TRUE);
        END;

        UpdateFromTaxGroup(TaxGroup);
      END;
    END;

    PROCEDURE PropagateDelete@3();
    VAR
      GeneralLedgerSetup@1002 : Record 98;
      VATProductPostingGroup@1000 : Record 324;
      TaxGroup@1001 : Record 321;
    BEGIN
      IF GeneralLedgerSetup.UseVat THEN BEGIN
        VATProductPostingGroup.GET(Code);
        VATProductPostingGroup.DELETE(TRUE);
      END ELSE BEGIN
        TaxGroup.GET(Code);
        TaxGroup.DELETE(TRUE);
      END;
    END;

    PROCEDURE LoadRecords@7() : Boolean;
    VAR
      GeneralLedgerSetup@1000 : Record 98;
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(RecordMustBeTemporaryErr);

      IF GeneralLedgerSetup.UseVat THEN
        LoadFromVATProductPostingGroup
      ELSE
        LoadFromTaxGroup;

      EXIT(FINDFIRST);
    END;

    LOCAL PROCEDURE LoadFromTaxGroup@18();
    VAR
      TaxGroup@1000 : Record 321;
    BEGIN
      IF NOT TaxGroup.FINDSET THEN
        EXIT;

      REPEAT
        UpdateFromTaxGroup(TaxGroup);
        INSERT;
      UNTIL TaxGroup.NEXT = 0;
    END;

    LOCAL PROCEDURE LoadFromVATProductPostingGroup@19();
    VAR
      VATProductPostingGroup@1000 : Record 324;
    BEGIN
      IF NOT VATProductPostingGroup.FINDSET THEN
        EXIT;

      REPEAT
        UpdateFromVATProductPostingGroup(VATProductPostingGroup);
        INSERT;
      UNTIL VATProductPostingGroup.NEXT = 0;
    END;

    PROCEDURE GetCodesFromTaxGroupId@8(TaxGroupID@1000 : GUID;VAR SalesTaxGroupCode@1001 : Code[20];VAR VATProductPostingGroupCode@1002 : Code[20]);
    VAR
      GeneralLedgerSetup@1003 : Record 98;
      VATProductPostingGroup@1004 : Record 324;
      TaxGroup@1005 : Record 321;
    BEGIN
      CLEAR(SalesTaxGroupCode);
      CLEAR(VATProductPostingGroupCode);

      IF ISNULLGUID(TaxGroupID) THEN
        EXIT;

      IF GeneralLedgerSetup.UseVat THEN BEGIN
        VATProductPostingGroup.SETRANGE(Id,TaxGroupID);
        IF VATProductPostingGroup.FINDFIRST THEN
          VATProductPostingGroupCode := VATProductPostingGroup.Code;

        EXIT;
      END;

      TaxGroup.SETRANGE(Id,TaxGroupID);
      IF TaxGroup.FINDFIRST THEN
        SalesTaxGroupCode := TaxGroup.Code;
    END;

    LOCAL PROCEDURE UpdateFromVATProductPostingGroup@5(VAR VATProductPostingGroup@1000 : Record 324);
    BEGIN
      TRANSFERFIELDS(VATProductPostingGroup,TRUE);
      Type := Type::VAT;
    END;

    LOCAL PROCEDURE UpdateFromTaxGroup@6(VAR TaxGroup@1000 : Record 321);
    BEGIN
      TRANSFERFIELDS(TaxGroup,TRUE);
      Type := Type::"Sales Tax";
    END;

    BEGIN
    END.
  }
}

