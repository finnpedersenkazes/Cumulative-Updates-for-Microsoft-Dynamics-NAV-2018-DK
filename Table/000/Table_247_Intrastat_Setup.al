OBJECT Table 247 Intrastat Setup
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Intrastat, Ops‘tning;
               ENU=Intrastat Setup];
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=[DAN=Kode;
                                                              ENU=Code] }
    { 2   ;   ;Report Receipts     ;Boolean       ;CaptionML=[DAN=Rapport‚r modtagelser;
                                                              ENU=Report Receipts] }
    { 3   ;   ;Report Shipments    ;Boolean       ;CaptionML=[DAN=Rapport‚r leverancer;
                                                              ENU=Report Shipments] }
    { 4   ;   ;Default Trans. - Purchase;Code10   ;TableRelation="Transaction Type";
                                                   CaptionML=[DAN=Standardoverflyt. - k›b;
                                                              ENU=Default Trans. - Purchase] }
    { 5   ;   ;Default Trans. - Return;Code10     ;TableRelation="Transaction Type";
                                                   CaptionML=[DAN=Standardoverflyt. - retur;
                                                              ENU=Default Trans. - Return] }
    { 6   ;   ;Intrastat Contact Type;Option      ;OnValidate=BEGIN
                                                                IF "Intrastat Contact Type" <> xRec."Intrastat Contact Type" THEN
                                                                  VALIDATE("Intrastat Contact No.",'');
                                                              END;

                                                   CaptionML=[DAN=Intrastat-kontakttype;
                                                              ENU=Intrastat Contact Type];
                                                   OptionCaptionML=[DAN=" ,Kontakt,Kreditor";
                                                                    ENU=" ,Contact,Vendor"];
                                                   OptionString=[ ,Contact,Vendor] }
    { 7   ;   ;Intrastat Contact No.;Code20       ;TableRelation=IF (Intrastat Contact Type=CONST(Contact)) Contact.No.
                                                                 ELSE IF (Intrastat Contact Type=CONST(Vendor)) Vendor.No.;
                                                   CaptionML=[DAN=Intrastat-kontaktnr.;
                                                              ENU=Intrastat Contact No.] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      OnDelIntrastatContactErr@1008 : TextConst '@@@=1 - Contact No;DAN=Du kan ikke slette kontaktnummeret %1 fordi det er konfigureret som en Intrastat-kontakt i vinduet Intrastat-ops‘tning.;ENU=You cannot delete contact number %1 because it is set up as an Intrastat contact in the Intrastat Setup window.';
      OnDelVendorIntrastatContactErr@1009 : TextConst '@@@=1 - Vendor No;DAN=Du kan ikke slette kreditornummeret %1 fordi det er konfigureret som en Intrastat-kontakt i vinduet Intrastat-ops‘tning.;ENU=You cannot delete vendor number %1 because it is set up as an Intrastat contact in the Intrastat Setup window.';

    [External]
    PROCEDURE CheckDeleteIntrastatContact@21(ContactType@1000 : Option;ContactNo@1001 : Code[20]);
    BEGIN
      IF (ContactNo = '') OR (ContactType = "Intrastat Contact Type"::" ") THEN
        EXIT;

      IF GET THEN
        IF (ContactNo = "Intrastat Contact No.") AND (ContactType = "Intrastat Contact Type") THEN BEGIN
          IF ContactType = "Intrastat Contact Type"::Contact THEN
            ERROR(STRSUBSTNO(OnDelIntrastatContactErr,ContactNo));
          ERROR(STRSUBSTNO(OnDelVendorIntrastatContactErr,ContactNo));
        END;
    END;

    BEGIN
    END.
  }
}

