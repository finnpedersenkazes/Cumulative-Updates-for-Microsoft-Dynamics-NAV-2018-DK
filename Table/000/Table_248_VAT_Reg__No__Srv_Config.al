OBJECT Table 248 VAT Reg. No. Srv Config
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF NOT ISEMPTY THEN
                 ERROR(CannotInsertMultipleSettingsErr);
             END;

    CaptionML=[DAN=SE/CVR-nr. srv.konfig.;
               ENU=VAT Reg. No. Srv Config];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Enabled             ;Boolean       ;CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
    { 3   ;   ;Service Endpoint    ;Text250       ;CaptionML=[DAN=Slutpunkt for tjeneste;
                                                              ENU=Service Endpoint] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      VATRegNoVIESSettingIsNotEnabledErr@1000 : TextConst 'DAN=Indstilling af momsregistreringstjenesten er ikke aktiveret.;ENU=VAT Registration Service (VIES) Setting is not enabled.';
      CannotInsertMultipleSettingsErr@1001 : TextConst 'DAN=Du kan ikke inds‘tte flere indstillinger.;ENU=You cannot insert multiple settings.';

    [External]
    PROCEDURE VATRegNoSrvIsEnabled@43() : Boolean;
    VAR
      VATRegNoSrvConfig@1006 : Record 248;
    BEGIN
      VATRegNoSrvConfig.SETRANGE(Enabled,TRUE);
      EXIT(VATRegNoSrvConfig.FINDFIRST AND VATRegNoSrvConfig.Enabled);
    END;

    [External]
    PROCEDURE GetVATRegNoURL@1() : Text;
    VAR
      VATRegNoSrvConfig@1000 : Record 248;
    BEGIN
      VATRegNoSrvConfig.SETRANGE(Enabled,TRUE);
      IF NOT VATRegNoSrvConfig.FINDFIRST THEN
        ERROR(VATRegNoVIESSettingIsNotEnabledErr);

      VATRegNoSrvConfig.TESTFIELD("Service Endpoint");

      EXIT(VATRegNoSrvConfig."Service Endpoint");
    END;

    BEGIN
    END.
  }
}

