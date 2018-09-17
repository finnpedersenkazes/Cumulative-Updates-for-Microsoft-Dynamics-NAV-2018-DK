OBJECT Table 5504 Tax Area Buffer
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

    CaptionML=[DAN=Skatteomr�debuffer;
               ENU=Tax Area Buffer];
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
    { 10  ;   ;Last Modified Date Time;DateTime   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato/klokkesl�t for seneste �ndring;
                                                              ENU=Last Modified Date Time];
                                                   Editable=No }
    { 8000;   ;Id                  ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 9600;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN="@@@={Locked};ENU=Sales Tax,VAT";
                                                                    ENU="@@@={Locked};ENU=Sales Tax,VAT"];
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
      VATBusinessPostingGroup@1002 : Record 323;
      TaxArea@1003 : Record 318;
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(RecordMustBeTemporaryErr);

      IF GeneralLedgerSetup.UseVat THEN BEGIN
        IF Insert THEN BEGIN
          VATBusinessPostingGroup.TRANSFERFIELDS(Rec,TRUE);
          VATBusinessPostingGroup.INSERT(TRUE)
        END ELSE BEGIN
          IF xRec.Code <> Code THEN BEGIN
            VATBusinessPostingGroup.GET(xRec.Code);
            VATBusinessPostingGroup.RENAME(Code)
          END;

          VATBusinessPostingGroup.TRANSFERFIELDS(Rec,TRUE);
          VATBusinessPostingGroup.MODIFY(TRUE);
        END;

        UpdateFromVATBusinessPostingGroup(VATBusinessPostingGroup);
      END ELSE BEGIN
        IF Insert THEN BEGIN
          TaxArea.TRANSFERFIELDS(Rec,TRUE);
          TaxArea.INSERT(TRUE)
        END ELSE BEGIN
          IF xRec.Code <> Code THEN BEGIN
            TaxArea.GET(xRec.Code);
            TaxArea.RENAME(Code);
          END;

          TaxArea.TRANSFERFIELDS(Rec,TRUE);
          TaxArea.MODIFY(TRUE);
        END;

        UpdateFromTaxArea(TaxArea);
      END;
    END;

    PROCEDURE PropagateDelete@3();
    VAR
      GeneralLedgerSetup@1002 : Record 98;
      VATBusinessPostingGroup@1000 : Record 323;
      TaxArea@1001 : Record 318;
    BEGIN
      IF GeneralLedgerSetup.UseVat THEN BEGIN
        VATBusinessPostingGroup.GET(Code);
        VATBusinessPostingGroup.DELETE(TRUE);
      END ELSE BEGIN
        TaxArea.GET(Code);
        TaxArea.DELETE(TRUE);
      END;
    END;

    PROCEDURE LoadRecords@7() : Boolean;
    VAR
      GeneralLedgerSetup@1000 : Record 98;
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(RecordMustBeTemporaryErr);

      IF GeneralLedgerSetup.UseVat THEN
        LoadFromVATBusinessPostingGroup
      ELSE
        LoadFromTaxArea;

      EXIT(FINDFIRST);
    END;

    LOCAL PROCEDURE LoadFromTaxArea@18();
    VAR
      TaxArea@1000 : Record 318;
    BEGIN
      IF NOT TaxArea.FINDSET THEN
        EXIT;

      REPEAT
        UpdateFromTaxArea(TaxArea);
        INSERT;
      UNTIL TaxArea.NEXT = 0;
    END;

    LOCAL PROCEDURE LoadFromVATBusinessPostingGroup@19();
    VAR
      VATBusinessPostingGroup@1000 : Record 323;
    BEGIN
      IF NOT VATBusinessPostingGroup.FINDSET THEN
        EXIT;

      REPEAT
        UpdateFromVATBusinessPostingGroup(VATBusinessPostingGroup);
        INSERT;
      UNTIL VATBusinessPostingGroup.NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateFromVATBusinessPostingGroup@5(VAR VATBusinessPostingGroup@1000 : Record 323);
    BEGIN
      TRANSFERFIELDS(VATBusinessPostingGroup,TRUE);
      Type := Type::VAT;
    END;

    LOCAL PROCEDURE UpdateFromTaxArea@6(VAR TaxArea@1000 : Record 318);
    BEGIN
      TRANSFERFIELDS(TaxArea,TRUE);
      Type := Type::"Sales Tax";
      Description := TaxArea.GetDescriptionInCurrentLanguage;
    END;

    PROCEDURE GetTaxAreaDisplayName@8(TaxAreaId@1003 : GUID) : Text;
    VAR
      GeneralLedgerSetup@1000 : Record 98;
      VATBusinessPostingGroup@1001 : Record 323;
      TaxArea@1002 : Record 318;
    BEGIN
      IF GeneralLedgerSetup.UseVat THEN BEGIN
        VATBusinessPostingGroup.SETRANGE(Id,TaxAreaId);
        IF VATBusinessPostingGroup.FINDFIRST THEN
          EXIT(VATBusinessPostingGroup.Description);
      END ELSE BEGIN
        TaxArea.SETRANGE(Id,TaxAreaId);
        IF TaxArea.FINDFIRST THEN
          EXIT(TaxArea.GetDescriptionInCurrentLanguage);
      END;

      EXIT('');
    END;

    BEGIN
    END.
  }
}

