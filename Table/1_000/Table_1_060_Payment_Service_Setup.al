OBJECT Table 1060 Payment Service Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 112=rimd;
    OnDelete=BEGIN
               DeletePaymentServiceSetup(TRUE);
             END;

    CaptionML=[DAN=Konfiguration af betalingstjeneste;
               ENU=Payment Service Setup];
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Text250       ;CaptionML=[DAN=Nr.;
                                                              ENU=No.] }
    { 2   ;   ;Name                ;Text250       ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   NotBlank=Yes }
    { 4   ;   ;Enabled             ;Boolean       ;CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
    { 5   ;   ;Always Include on Documents;Boolean;OnValidate=VAR
                                                                SalesHeader@1000 : Record 36;
                                                              BEGIN
                                                                IF CONFIRM(UpdateExistingInvoicesQst) THEN BEGIN
                                                                  SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Invoice);
                                                                  IF  SalesHeader.FINDSET(TRUE,FALSE) THEN
                                                                    REPEAT
                                                                      SalesHeader.SetDefaultPaymentServices;
                                                                      SalesHeader.MODIFY
                                                                    UNTIL SalesHeader.NEXT = 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Medtag altid p� dokumenter;
                                                              ENU=Always Include on Documents] }
    { 6   ;   ;Setup Record ID     ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Konfigurationsrecord-id;
                                                              ENU=Setup Record ID] }
    { 7   ;   ;Setup Page ID       ;Integer       ;CaptionML=[DAN=Konfigurationsside-id;
                                                              ENU=Setup Page ID] }
    { 8   ;   ;Terms of Service    ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=Servicevilk�r;
                                                              ENU=Terms of Service];
                                                   Editable=No }
    { 100 ;   ;Available           ;Boolean       ;CaptionML=[DAN=Tilg�ngelig;
                                                              ENU=Available] }
    { 101 ;   ;Management Codeunit ID;Integer     ;CaptionML=[DAN=Id for administrations-codeunit;
                                                              ENU=Management Codeunit ID] }
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
      NoPaymentMethodsSelectedTxt@1003 : TextConst 'DAN=Ingen betalingstjeneste er gjort tilg�ngelig.;ENU=No payment service is made available.';
      SetupPaymentServicesQst@1000 : TextConst 'DAN=Ingen betalingstjenester er konfigureret.\\Vil du konfigurere en betalingstjeneste?;ENU=No payment services have been set up.\\Do you want to set up a payment service?';
      SetupExistingServicesOrCreateNewQst@1001 : TextConst 'DAN=En eller flere betalingstjenester er konfigureret, men ingen er aktiveret.\\Vil du:;ENU=One or more payment services are set up, but none are enabled.\\Do you want to:';
      CreateOrUpdateOptionQst@1002 : TextConst 'DAN=Konfigurer en betalingstjeneste,Opret en ny betalingstjeneste;ENU=Set Up a Payment Service,Create a New Payment Service';
      UpdateExistingInvoicesQst@1004 : TextConst 'DAN=Vil du opdatere de l�bende salgsfakturaer med oplysningerne fra betalingstjenesten?;ENU=Do you want to update the ongoing Sales Invoices with this Payment Service information?';
      ReminderToSendAgainMsg@1005 : TextConst 'DAN=Betalingstjenesten er blevet �ndret.\\Fakturamodtageren f�r vist �ndringen, n�r du sender eller gensender fakturaen.;ENU=The payment service was successfully changed.\\The invoice recipient will see the change when you send, or resend, the invoice.';

    [External]
    PROCEDURE OpenSetupCard@14();
    VAR
      DataTypeManagement@1001 : Codeunit 701;
      SetupRecordRef@1000 : RecordRef;
      SetupRecordVariant@1002 : Variant;
    BEGIN
      IF NOT DataTypeManagement.GetRecordRef("Setup Record ID",SetupRecordRef) THEN
        EXIT;

      SetupRecordVariant := SetupRecordRef;
      PAGE.RUNMODAL("Setup Page ID",SetupRecordVariant);
    END;

    [External]
    PROCEDURE CreateReportingArgs@11(VAR PaymentReportingArgument@1000 : Record 1062;DocumentRecordVariant@1001 : Variant);
    VAR
      DummySalesHeader@1006 : Record 36;
      TempPaymentServiceSetup@1007 : TEMPORARY Record 1060;
      DataTypeMgt@1003 : Codeunit 701;
      DocumentRecordRef@1004 : RecordRef;
      PaymentServiceFieldRef@1005 : FieldRef;
      SetID@1008 : Integer;
      LastKey@1010 : Integer;
    BEGIN
      PaymentReportingArgument.RESET;
      PaymentReportingArgument.DELETEALL;

      DataTypeMgt.GetRecordRef(DocumentRecordVariant,DocumentRecordRef);
      DataTypeMgt.FindFieldByName(DocumentRecordRef,PaymentServiceFieldRef,DummySalesHeader.FIELDNAME("Payment Service Set ID"));

      SetID := PaymentServiceFieldRef.VALUE;

      GetEnabledPaymentServices(TempPaymentServiceSetup);
      LoadSet(TempPaymentServiceSetup,SetID);
      TempPaymentServiceSetup.SETRANGE(Available,TRUE);

      IF NOT TempPaymentServiceSetup.FINDFIRST THEN
        EXIT;

      REPEAT
        LastKey := PaymentReportingArgument.Key;
        CLEAR(PaymentReportingArgument);
        PaymentReportingArgument.Key := LastKey + 1;
        PaymentReportingArgument.VALIDATE("Document Record ID",DocumentRecordRef.RECORDID);
        PaymentReportingArgument.VALIDATE("Setup Record ID",TempPaymentServiceSetup."Setup Record ID");
        PaymentReportingArgument.INSERT(TRUE);
        CODEUNIT.RUN(TempPaymentServiceSetup."Management Codeunit ID",PaymentReportingArgument);
      UNTIL TempPaymentServiceSetup.NEXT = 0;
    END;

    [External]
    PROCEDURE GetDefaultPaymentServices@15(VAR SetID@1001 : Integer) : Boolean;
    VAR
      TempPaymentServiceSetup@1000 : TEMPORARY Record 1060;
      TempRecordSetBuffer@1002 : TEMPORARY Record 8402;
      RecordSetManagement@1003 : Codeunit 8400;
    BEGIN
      OnRegisterPaymentServices(TempPaymentServiceSetup);
      TempPaymentServiceSetup.SETRANGE("Always Include on Documents",TRUE);
      TempPaymentServiceSetup.SETRANGE(Enabled,TRUE);

      IF NOT TempPaymentServiceSetup.FINDFIRST THEN
        EXIT(FALSE);

      TransferToRecordSetBuffer(TempPaymentServiceSetup,TempRecordSetBuffer);
      RecordSetManagement.GetSet(TempRecordSetBuffer,SetID);
      IF SetID = 0 THEN
        SetID := RecordSetManagement.SaveSet(TempRecordSetBuffer);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE SelectPaymentService@13(VAR SetID@1004 : Integer) : Boolean;
    VAR
      TempPaymentServiceSetup@1003 : TEMPORARY Record 1060;
    BEGIN
      IF NOT GetEnabledPaymentServices(TempPaymentServiceSetup) THEN BEGIN
        IF NOT AskUserToSetupNewPaymentService(TempPaymentServiceSetup) THEN
          EXIT(FALSE);

        // If user has setup the service then just select that one
        IF TempPaymentServiceSetup.COUNT = 1 THEN BEGIN
          TempPaymentServiceSetup.FINDFIRST;
          SetID := SaveSet(TempPaymentServiceSetup);
          EXIT(TRUE);
        END;
      END;

      IF SetID <> 0 THEN
        LoadSet(TempPaymentServiceSetup,SetID);

      TempPaymentServiceSetup.RESET;
      TempPaymentServiceSetup.SETRANGE(Enabled,TRUE);

      IF NOT (PAGE.RUNMODAL(PAGE::"Select Payment Service",TempPaymentServiceSetup) = ACTION::LookupOK) THEN
        EXIT(FALSE);

      TempPaymentServiceSetup.SETRANGE(Available,TRUE);
      IF TempPaymentServiceSetup.FINDFIRST THEN
        SetID := SaveSet(TempPaymentServiceSetup)
      ELSE
        CLEAR(SetID);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetEnabledPaymentServices@16(VAR TempPaymentServiceSetup@1000 : TEMPORARY Record 1060) : Boolean;
    BEGIN
      TempPaymentServiceSetup.RESET;
      TempPaymentServiceSetup.DELETEALL;
      OnRegisterPaymentServices(TempPaymentServiceSetup);
      TempPaymentServiceSetup.SETRANGE(Enabled,TRUE);
      EXIT(TempPaymentServiceSetup.FINDSET);
    END;

    LOCAL PROCEDURE TransferToRecordSetBuffer@18(VAR TempPaymentServiceSetup@1000 : TEMPORARY Record 1060;VAR TempRecordSetBuffer@1002 : TEMPORARY Record 8402);
    VAR
      CurrentKey@1003 : Integer;
    BEGIN
      TempPaymentServiceSetup.FINDFIRST;

      REPEAT
        CurrentKey := TempRecordSetBuffer.No;
        CLEAR(TempRecordSetBuffer);
        TempRecordSetBuffer.No := CurrentKey + 1;
        TempRecordSetBuffer."Value RecordID" := TempPaymentServiceSetup."Setup Record ID";
        TempRecordSetBuffer.INSERT;
      UNTIL TempPaymentServiceSetup.NEXT = 0;
    END;

    LOCAL PROCEDURE SaveSet@21(VAR TempPaymentServiceSetup@1000 : TEMPORARY Record 1060) : Integer;
    VAR
      TempRecordSetBuffer@1002 : TEMPORARY Record 8402;
      RecordSetManagement@1003 : Codeunit 8400;
    BEGIN
      TransferToRecordSetBuffer(TempPaymentServiceSetup,TempRecordSetBuffer);
      EXIT(RecordSetManagement.SaveSet(TempRecordSetBuffer));
    END;

    LOCAL PROCEDURE LoadSet@20(VAR TempPaymentServiceSetup@1001 : TEMPORARY Record 1060;SetID@1000 : Integer);
    VAR
      TempRecordSetBuffer@1004 : TEMPORARY Record 8402;
      RecordSetManagement@1003 : Codeunit 8400;
    BEGIN
      IF NOT TempPaymentServiceSetup.FINDFIRST THEN
        EXIT;

      RecordSetManagement.GetSet(TempRecordSetBuffer,SetID);

      IF NOT TempRecordSetBuffer.FINDFIRST THEN BEGIN
        TempPaymentServiceSetup.MODIFYALL(Available,FALSE);
        EXIT;
      END;

      REPEAT
        TempRecordSetBuffer.SETRANGE("Value RecordID",TempPaymentServiceSetup."Setup Record ID");
        IF TempRecordSetBuffer.FINDFIRST THEN BEGIN
          TempPaymentServiceSetup.Available := TRUE;
          TempPaymentServiceSetup.MODIFY;
        END;
      UNTIL TempPaymentServiceSetup.NEXT = 0;
    END;

    [External]
    PROCEDURE GetSelectedPaymentsText@4(SetID@1000 : Integer) SelectedPaymentServices : Text;
    VAR
      TempPaymentServiceSetup@1001 : TEMPORARY Record 1060;
    BEGIN
      SelectedPaymentServices := NoPaymentMethodsSelectedTxt;

      IF SetID = 0 THEN
        EXIT;

      OnRegisterPaymentServices(TempPaymentServiceSetup);
      LoadSet(TempPaymentServiceSetup,SetID);

      TempPaymentServiceSetup.SETRANGE(Available,TRUE);
      IF NOT TempPaymentServiceSetup.FINDSET THEN
        EXIT;

      CLEAR(SelectedPaymentServices);
      REPEAT
        SelectedPaymentServices += STRSUBSTNO(',%1',TempPaymentServiceSetup.Name);
      UNTIL TempPaymentServiceSetup.NEXT = 0;

      SelectedPaymentServices := COPYSTR(SelectedPaymentServices,2);
    END;

    [External]
    PROCEDURE CanChangePaymentService@6(DocumentVariant@1000 : Variant) : Boolean;
    VAR
      SalesInvoiceHeader@1003 : Record 112;
      DataTypeManagement@1001 : Codeunit 701;
      DocumentRecordRef@1002 : RecordRef;
      PaymentMethodCodeFieldRef@1004 : FieldRef;
    BEGIN
      DataTypeManagement.GetRecordRef(DocumentVariant,DocumentRecordRef);
      CASE DocumentRecordRef.NUMBER OF
        DATABASE::"Sales Invoice Header":
          BEGIN
            SalesInvoiceHeader.COPY(DocumentVariant);
            SalesInvoiceHeader.CALCFIELDS(Closed,"Remaining Amount");
            IF SalesInvoiceHeader.Closed OR (SalesInvoiceHeader."Remaining Amount" = 0) THEN
              EXIT(FALSE);
          END
        ELSE BEGIN
          IF DataTypeManagement.FindFieldByName(
               DocumentRecordRef,PaymentMethodCodeFieldRef,SalesInvoiceHeader.FIELDNAME("Payment Method Code"))
          THEN
            IF NOT CanUsePaymentMethod(FORMAT(PaymentMethodCodeFieldRef.VALUE)) THEN
              EXIT(FALSE);
        END
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CanUsePaymentMethod@10(PaymentMethodCode@1000 : Code[10]) : Boolean;
    VAR
      PaymentMethod@1001 : Record 289;
    BEGIN
      IF NOT PaymentMethod.GET(PaymentMethodCode) THEN
        EXIT(TRUE);

      EXIT(PaymentMethod."Bal. Account No." = '');
    END;

    [External]
    PROCEDURE ChangePaymentServicePostedInvoice@19(VAR SalesInvoiceHeader@1000 : Record 112);
    VAR
      PaymentServiceSetup@1002 : Record 1060;
      SetID@1001 : Integer;
    BEGIN
      SetID := SalesInvoiceHeader."Payment Service Set ID";
      IF PaymentServiceSetup.SelectPaymentService(SetID) THEN BEGIN
        SalesInvoiceHeader.VALIDATE("Payment Service Set ID",SetID);
        SalesInvoiceHeader.MODIFY(TRUE);
        IF GUIALLOWED AND (FORMAT(SalesInvoiceHeader."Payment Service Set ID") <> '') THEN
          MESSAGE(ReminderToSendAgainMsg);
      END;
    END;

    LOCAL PROCEDURE AskUserToSetupNewPaymentService@12(VAR TempPaymentServiceSetup@1000 : TEMPORARY Record 1060) : Boolean;
    VAR
      TempNotEnabledPaymentServiceSetupProviders@1006 : TEMPORARY Record 1060;
      TempPaymentServiceSetupProviders@1002 : TEMPORARY Record 1060;
      SetupOrCreatePaymentService@1004 : ',Setup Payment Services,Create New';
      SelectedOption@1003 : Integer;
      DefinedPaymentServiceExist@1001 : Boolean;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT(FALSE);

      OnRegisterPaymentServiceProviders(TempPaymentServiceSetupProviders);
      IF NOT TempPaymentServiceSetupProviders.FINDFIRST THEN
        EXIT(FALSE);

      // Check if there are payment services that are not enabled
      OnRegisterPaymentServices(TempNotEnabledPaymentServiceSetupProviders);
      DefinedPaymentServiceExist := TempNotEnabledPaymentServiceSetupProviders.FINDFIRST;

      IF DefinedPaymentServiceExist THEN BEGIN
        SelectedOption := STRMENU(CreateOrUpdateOptionQst,1,SetupExistingServicesOrCreateNewQst);
        CASE SelectedOption OF
          SetupOrCreatePaymentService::"Setup Payment Services":
            PAGE.RUNMODAL(PAGE::"Payment Services");
          SetupOrCreatePaymentService::"Create New":
            NewPaymentService;
          ELSE
            EXIT(FALSE);
        END;
        EXIT(GetEnabledPaymentServices(TempPaymentServiceSetup));
      END;

      // Ask to create a new service
      IF CONFIRM(SetupPaymentServicesQst) THEN BEGIN
        NewPaymentService;
        EXIT(GetEnabledPaymentServices(TempPaymentServiceSetup));
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IsPaymentServiceVisible@7() : Boolean;
    VAR
      TempPaymentServiceSetup@1000 : TEMPORARY Record 1060;
    BEGIN
      OnRegisterPaymentServiceProviders(TempPaymentServiceSetup);
      EXIT(NOT TempPaymentServiceSetup.ISEMPTY);
    END;

    [External]
    PROCEDURE NewPaymentService@1() : Boolean;
    VAR
      TempPaymentServiceSetup@1000 : TEMPORARY Record 1060;
      TempPaymentServiceSetupProviders@1001 : TEMPORARY Record 1060;
    BEGIN
      OnRegisterPaymentServiceProviders(TempPaymentServiceSetupProviders);
      CASE TempPaymentServiceSetupProviders.COUNT OF
        0:
          EXIT(FALSE);
        1:
          BEGIN
            TempPaymentServiceSetupProviders.FINDFIRST;
            OnCreatePaymentService(TempPaymentServiceSetupProviders);
            EXIT(TRUE);
          END;
        ELSE BEGIN
          IF PAGE.RUNMODAL(PAGE::"Select Payment Service Type",TempPaymentServiceSetup) = ACTION::LookupOK THEN BEGIN
            OnCreatePaymentService(TempPaymentServiceSetup);
            EXIT(TRUE);
          END;
          EXIT(FALSE);
        END;
      END;
    END;

    [External]
    PROCEDURE AssignPrimaryKey@9(VAR PaymentServiceSetup@1000 : Record 1060);
    BEGIN
      PaymentServiceSetup."No." := FORMAT(PaymentServiceSetup."Setup Record ID");
    END;

    [External]
    PROCEDURE DeletePaymentServiceSetup@5(RunTrigger@1000 : Boolean);
    VAR
      DataTypeManagement@1001 : Codeunit 701;
      SetupRecordRef@1002 : RecordRef;
    BEGIN
      DataTypeManagement.GetRecordRef("Setup Record ID",SetupRecordRef);
      SetupRecordRef.DELETE(RunTrigger);
    END;

    [External]
    PROCEDURE TermsOfServiceDrillDown@17();
    BEGIN
      IF "Terms of Service" <> '' THEN
        HYPERLINK("Terms of Service");
    END;

    [Integration]
    [External]
    PROCEDURE OnRegisterPaymentServices@8(VAR PaymentServiceSetup@1000 : Record 1060);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnRegisterPaymentServiceProviders@2(VAR PaymentServiceSetup@1000 : Record 1060);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCreatePaymentService@3(VAR PaymentServiceSetup@1000 : Record 1060);
    BEGIN
    END;

    BEGIN
    END.
  }
}

