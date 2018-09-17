OBJECT Codeunit 48 PostingSetupManagement
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      MyNotifications@1000 : Record 1518;
      MissingAccountTxt@1005 : TextConst '@@@="%1 = Field caption, %2 = Table caption";DAN=%1 mangler i %2.;ENU=%1 is missing in %2.';
      SetupMissingAccountTxt@1004 : TextConst 'DAN=Opret manglende konto;ENU=Set up missing account';
      MissingAccountNotificationTxt@1006 : TextConst 'DAN=Finanskontoen mangler i bogf�ringsgruppen eller ops�tningen.;ENU=G/L Account is missing in posting group or setup.';
      MissingAccountNotificationDescriptionTxt@1002 : TextConst 'DAN=Vis en advarsel, n�r en p�kr�vet finanskonto mangler i en bogf�ringsgruppe eller ops�tning.;ENU=Show a warning when required G/L Account is missing in posting group or setup.';
      NotAllowedToPostAfterCurrentFiscalYearErr@1001 : TextConst 'DAN=Cannot post because one or more transactions have dates after the current fiscal year.;ENU=Cannot post because one or more transactions have dates after the current fiscal year.';

    [External]
    PROCEDURE CheckCustPostingGroupReceivablesAccount@26(PostingGroup@1000 : Code[20]);
    VAR
      CustomerPostingGroup@1001 : Record 92;
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      IF NOT CustomerPostingGroup.GET(PostingGroup) THEN
        EXIT;

      IF CustomerPostingGroup."Receivables Account" = '' THEN
        SendCustPostingGroupNotification(CustomerPostingGroup,CustomerPostingGroup.FIELDCAPTION("Receivables Account"));
    END;

    [External]
    PROCEDURE CheckVendPostingGroupPayablesAccount@28(PostingGroup@1000 : Code[20]);
    VAR
      VendorPostingGroup@1001 : Record 93;
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      IF NOT VendorPostingGroup.GET(PostingGroup) THEN
        EXIT;

      IF VendorPostingGroup."Payables Account" = '' THEN
        SendVendPostingGroupNotification(VendorPostingGroup,VendorPostingGroup.FIELDCAPTION("Payables Account"));
    END;

    [External]
    PROCEDURE CheckGenPostingSetupSalesAccount@6(GenBusGroupCode@1001 : Code[20];GenProdGroupCode@1002 : Code[20]);
    VAR
      GenPostingSetup@1000 : Record 252;
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      IF NOT GenPostingSetup.GET(GenBusGroupCode,GenProdGroupCode) THEN
        CreateGenPostingSetup(GenBusGroupCode,GenProdGroupCode);

      IF GenPostingSetup."Sales Account" = '' THEN
        SendGenPostingSetupNotification(GenPostingSetup,GenPostingSetup.FIELDCAPTION("Sales Account"));
    END;

    [External]
    PROCEDURE CheckGenPostingSetupPurchAccount@14(GenBusGroupCode@1001 : Code[20];GenProdGroupCode@1002 : Code[20]);
    VAR
      GenPostingSetup@1000 : Record 252;
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      IF NOT GenPostingSetup.GET(GenBusGroupCode,GenProdGroupCode) THEN
        CreateGenPostingSetup(GenBusGroupCode,GenProdGroupCode);

      IF GenPostingSetup."Purch. Account" = '' THEN
        SendGenPostingSetupNotification(GenPostingSetup,GenPostingSetup.FIELDCAPTION("Purch. Account"));
    END;

    [External]
    PROCEDURE CheckGenPostingSetupCOGSAccount@19(GenBusGroupCode@1001 : Code[20];GenProdGroupCode@1002 : Code[20]);
    VAR
      GenPostingSetup@1000 : Record 252;
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      IF NOT GenPostingSetup.GET(GenBusGroupCode,GenProdGroupCode) THEN
        CreateGenPostingSetup(GenBusGroupCode,GenProdGroupCode);

      IF GenPostingSetup."COGS Account" = '' THEN
        SendGenPostingSetupNotification(GenPostingSetup,GenPostingSetup.FIELDCAPTION("COGS Account"));
    END;

    [External]
    PROCEDURE CheckVATPostingSetupSalesAccount@8(VATBusGroupCode@1001 : Code[20];VATProdGroupCode@1000 : Code[20]);
    VAR
      VATPostingSetup@1002 : Record 325;
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      IF NOT VATPostingSetup.GET(VATBusGroupCode,VATProdGroupCode) THEN
        CreateVATPostingSetup(VATBusGroupCode,VATProdGroupCode);

      IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Sales Tax" THEN
        EXIT;

      IF VATPostingSetup."Sales VAT Account" = '' THEN
        SendVATPostingSetupNotification(VATPostingSetup,VATPostingSetup.FIELDCAPTION("Sales VAT Account"));
    END;

    [External]
    PROCEDURE CheckVATPostingSetupPurchAccount@29(VATBusGroupCode@1001 : Code[20];VATProdGroupCode@1000 : Code[20]);
    VAR
      VATPostingSetup@1002 : Record 325;
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      IF NOT VATPostingSetup.GET(VATBusGroupCode,VATProdGroupCode) THEN
        CreateVATPostingSetup(VATBusGroupCode,VATProdGroupCode);

      IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Sales Tax" THEN
        EXIT;

      IF VATPostingSetup."Purchase VAT Account" = '' THEN
        SendVATPostingSetupNotification(VATPostingSetup,VATPostingSetup.FIELDCAPTION("Purchase VAT Account"));
    END;

    [External]
    PROCEDURE CheckInvtPostingSetupInventoryAccount@21(LocationCode@1000 : Code[10];PostingGroup@1001 : Code[20]);
    VAR
      InventoryPostingSetup@1003 : Record 5813;
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      IF NOT InventoryPostingSetup.GET(LocationCode,PostingGroup) THEN
        CreateInvtPostingSetup(LocationCode,PostingGroup);

      IF InventoryPostingSetup."Inventory Account" = '' THEN
        SendInvtPostingSetupNotification(InventoryPostingSetup,InventoryPostingSetup.FIELDCAPTION("Inventory Account"));
    END;

    LOCAL PROCEDURE FindNextFYStartingDate@11(VAR AccountingPeriod@1000 : Record 50);
    BEGIN
      AccountingPeriod.SETRANGE(Closed,FALSE);
      AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
      AccountingPeriod.FINDSET;
      // Try to get starting period of next opened fiscal year
      IF AccountingPeriod.NEXT = 0 THEN BEGIN
        // If not exists then get the day after the last period of opened fiscal year
        AccountingPeriod.SETRANGE("New Fiscal Year");
        AccountingPeriod.FINDLAST;
        AccountingPeriod."Starting Date" := CALCDATE('<CM+1D>',AccountingPeriod."Starting Date");
      END;
    END;

    PROCEDURE GetPostingSetupNotificationID@15() : GUID;
    BEGIN
      EXIT('7c2a2ca8-bdf7-4428-b520-ed17887ff30c');
    END;

    [External]
    PROCEDURE ConfirmPostingAfterCurrentFiscalYear@18(ConfirmQst@1003 : Text;PostingDate@1001 : Date) : Boolean;
    VAR
      AccountingPeriod@1002 : Record 50;
      InstructionMgt@1000 : Codeunit 1330;
    BEGIN
      IF GUIALLOWED AND
         InstructionMgt.IsMyNotificationEnabled(InstructionMgt.GetPostingAfterCurrentFiscalYeartNotificationId)
      THEN BEGIN
        FindNextFYStartingDate(AccountingPeriod);
        IF PostingDate >= AccountingPeriod."Starting Date" THEN BEGIN
          IF CONFIRM(ConfirmQst,FALSE) THEN
            EXIT(TRUE);
          ERROR(NotAllowedToPostAfterCurrentFiscalYearErr);
        END;
      END;
    END;

    LOCAL PROCEDURE CreateGenPostingSetup@101(GenBusGroupCode@1001 : Code[20];GenProdGroupCode@1002 : Code[20]);
    VAR
      GenPostingSetup@1000 : Record 252;
    BEGIN
      GenPostingSetup.INIT;
      GenPostingSetup.VALIDATE("Gen. Bus. Posting Group",GenBusGroupCode);
      GenPostingSetup.VALIDATE("Gen. Prod. Posting Group",GenProdGroupCode);
      GenPostingSetup.INSERT;
    END;

    LOCAL PROCEDURE CreateVATPostingSetup@102(VATBusGroupCode@1001 : Code[20];VATProdGroupCode@1002 : Code[20]);
    VAR
      VATPostingSetup@1000 : Record 325;
    BEGIN
      VATPostingSetup.INIT;
      VATPostingSetup.VALIDATE("VAT Bus. Posting Group",VATBusGroupCode);
      VATPostingSetup.VALIDATE("VAT Prod. Posting Group",VATProdGroupCode);
      VATPostingSetup.INSERT;
    END;

    LOCAL PROCEDURE CreateInvtPostingSetup@103(LocationCode@1001 : Code[10];PostingGroupCode@1002 : Code[20]);
    VAR
      InventoryPostingSetup@1000 : Record 5813;
    BEGIN
      InventoryPostingSetup.INIT;
      InventoryPostingSetup.VALIDATE("Location Code",LocationCode);
      InventoryPostingSetup.VALIDATE("Invt. Posting Group Code",PostingGroupCode);
      InventoryPostingSetup.INSERT;
    END;

    PROCEDURE IsPostingSetupNotificationEnabled@16() : Boolean;
    VAR
      InstructionMgt@1000 : Codeunit 1330;
    BEGIN
      EXIT(InstructionMgt.IsMyNotificationEnabled(GetPostingSetupNotificationID));
    END;

    LOCAL PROCEDURE SendPostingSetupNotification@100(NotificationMsg@1000 : Text;ActionMsg@1002 : Text;ActionName@1003 : Text;GroupCode1@1004 : Code[20];GroupCode2@1005 : Code[20]);
    VAR
      SendNotification@1001 : Notification;
    BEGIN
      SendNotification.ID := CREATEGUID;
      SendNotification.MESSAGE(NotificationMsg);
      SendNotification.SCOPE(NOTIFICATIONSCOPE::LocalScope);
      SendNotification.SETDATA('GroupCode1',GroupCode1);
      IF GroupCode2 <> '' THEN
        SendNotification.SETDATA('GroupCode2',GroupCode2);
      SendNotification.ADDACTION(ActionMsg,CODEUNIT::PostingSetupManagement,ActionName);
      SendNotification.SEND;
    END;

    [External]
    PROCEDURE SendCustPostingGroupNotification@7(CustomerPostingGroup@1001 : Record 92;FieldCaption@1000 : Text);
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      SendPostingSetupNotification(
        STRSUBSTNO(MissingAccountTxt,FieldCaption,CustomerPostingGroup.TABLECAPTION),
        SetupMissingAccountTxt,'ShowCustomerPostingGroups',CustomerPostingGroup.Code,'');
    END;

    [External]
    PROCEDURE SendVendPostingGroupNotification@9(VendorPostingGroup@1001 : Record 93;FieldCaption@1000 : Text);
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      SendPostingSetupNotification(
        STRSUBSTNO(MissingAccountTxt,FieldCaption,VendorPostingGroup.TABLECAPTION),
        SetupMissingAccountTxt,'ShowVendorPostingGroups',VendorPostingGroup.Code,'');
    END;

    [External]
    PROCEDURE SendInvtPostingSetupNotification@40(InvtPostingSetup@1001 : Record 5813;FieldCaption@1000 : Text);
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      SendPostingSetupNotification(
        STRSUBSTNO(MissingAccountTxt,FieldCaption,InvtPostingSetup.TABLECAPTION),
        SetupMissingAccountTxt,'ShowInventoryPostingSetup',
        InvtPostingSetup."Invt. Posting Group Code",InvtPostingSetup."Location Code");
    END;

    [External]
    PROCEDURE SendGenPostingSetupNotification@44(GenPostingSetup@1000 : Record 252;FieldCaption@1001 : Text);
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      SendPostingSetupNotification(
        STRSUBSTNO(MissingAccountTxt,FieldCaption,GenPostingSetup.TABLECAPTION),
        SetupMissingAccountTxt,'ShowGenPostingSetup',
        GenPostingSetup."Gen. Bus. Posting Group",GenPostingSetup."Gen. Prod. Posting Group");
    END;

    [External]
    PROCEDURE SendVATPostingSetupNotification@13(VATPostingSetup@1000 : Record 325;FieldCaption@1001 : Text);
    BEGIN
      IF NOT IsPostingSetupNotificationEnabled THEN
        EXIT;

      SendPostingSetupNotification(
        STRSUBSTNO(MissingAccountTxt,FieldCaption,VATPostingSetup.TABLECAPTION),
        SetupMissingAccountTxt,'ShowVATPostingSetup',
        VATPostingSetup."VAT Bus. Posting Group",VATPostingSetup."VAT Prod. Posting Group");
    END;

    PROCEDURE ShowCustomerPostingGroups@1(SetupNotification@1000 : Notification);
    VAR
      CustomerPostingGroup@1002 : Record 92;
      CustomerPostingGroups@1003 : Page 110;
      PostingGroupCode@1001 : Code[20];
    BEGIN
      CLEAR(CustomerPostingGroups);
      PostingGroupCode := SetupNotification.GETDATA('GroupCode1');
      IF PostingGroupCode <> '' THEN BEGIN
        CustomerPostingGroup.GET(PostingGroupCode);
        CustomerPostingGroups.SETRECORD(CustomerPostingGroup);
      END;
      CustomerPostingGroups.SETTABLEVIEW(CustomerPostingGroup);
      CustomerPostingGroups.RUNMODAL;
    END;

    PROCEDURE ShowVendorPostingGroups@2(SetupNotification@1000 : Notification);
    VAR
      VendorPostingGroup@1001 : Record 93;
      VendorPostingGroups@1002 : Page 111;
      PostingGroupCode@1003 : Code[20];
    BEGIN
      CLEAR(VendorPostingGroups);
      PostingGroupCode := SetupNotification.GETDATA('GroupCode1');
      IF PostingGroupCode <> '' THEN BEGIN
        VendorPostingGroup.GET(PostingGroupCode);
        VendorPostingGroups.SETRECORD(VendorPostingGroup);
      END;
      VendorPostingGroups.SETTABLEVIEW(VendorPostingGroup);
      VendorPostingGroups.RUNMODAL;
    END;

    PROCEDURE ShowInventoryPostingSetup@5(SetupNotification@1000 : Notification);
    VAR
      InventoryPostingSetupRec@1001 : Record 5813;
      InventoryPostingSetupPage@1002 : Page 5826;
      PostingGroupCode@1003 : Code[20];
      LocationCode@1004 : Code[10];
    BEGIN
      CLEAR(InventoryPostingSetupPage);
      PostingGroupCode := SetupNotification.GETDATA('GroupCode1');
      LocationCode := SetupNotification.GETDATA('GroupCode2');
      IF PostingGroupCode <> '' THEN BEGIN
        InventoryPostingSetupRec.GET(LocationCode,PostingGroupCode);
        InventoryPostingSetupPage.SETRECORD(InventoryPostingSetupRec);
      END;
      InventoryPostingSetupPage.SETTABLEVIEW(InventoryPostingSetupRec);
      InventoryPostingSetupPage.RUNMODAL;
    END;

    PROCEDURE ShowGenPostingSetup@3(SetupNotification@1000 : Notification);
    VAR
      GenPostingSetupRec@1001 : Record 252;
      GenPostingSetupPage@1002 : Page 314;
      BusPostingGroupCode@1003 : Code[20];
      ProdPostingGroupCode@1004 : Code[20];
    BEGIN
      CLEAR(GenPostingSetupPage);
      BusPostingGroupCode := SetupNotification.GETDATA('GroupCode1');
      ProdPostingGroupCode := SetupNotification.GETDATA('GroupCode2');
      IF ProdPostingGroupCode <> '' THEN BEGIN
        GenPostingSetupRec.GET(BusPostingGroupCode,ProdPostingGroupCode);
        GenPostingSetupPage.SETRECORD(GenPostingSetupRec);
      END;
      GenPostingSetupPage.SETTABLEVIEW(GenPostingSetupRec);
      GenPostingSetupPage.RUNMODAL;
    END;

    PROCEDURE ShowVATPostingSetup@4(SetupNotification@1000 : Notification);
    VAR
      VATPostingSetupRec@1004 : Record 325;
      VATPostingSetupPage@1003 : Page 472;
      BusPostingGroupCode@1002 : Code[20];
      ProdPostingGroupCode@1001 : Code[20];
    BEGIN
      CLEAR(VATPostingSetupPage);
      BusPostingGroupCode := SetupNotification.GETDATA('GroupCode1');
      ProdPostingGroupCode := SetupNotification.GETDATA('GroupCode2');
      IF ProdPostingGroupCode <> '' THEN BEGIN
        VATPostingSetupRec.GET(BusPostingGroupCode,ProdPostingGroupCode);
        VATPostingSetupPage.SETRECORD(VATPostingSetupRec);
      END;
      VATPostingSetupPage.SETTABLEVIEW(VATPostingSetupRec);
      VATPostingSetupPage.RUNMODAL;
    END;

    [EventSubscriber(Page,1518,OnInitializingNotificationWithDefaultState)]
    LOCAL PROCEDURE OnInitializingNotificationWithDefaultState@17();
    BEGIN
      MyNotifications.InsertDefault(
        GetPostingSetupNotificationID,MissingAccountNotificationTxt,MissingAccountNotificationDescriptionTxt,FALSE);
    END;

    BEGIN
    END.
  }
}

