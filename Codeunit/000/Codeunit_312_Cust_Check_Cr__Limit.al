OBJECT Codeunit 312 Cust-Check Cr. Limit
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 1518=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      InstructionMgt@1003 : Codeunit 1330;
      NotificationLifecycleMgt@1000 : Codeunit 1511;
      CustCheckCreditLimit@1001 : Page 343;
      InstructionTypeTxt@1004 : TextConst 'DAN=Kontroll‚r kreditmaksimum;ENU=Check Cr. Limit';
      GetDetailsTxt@1006 : TextConst 'DAN=Vis detaljer;ENU=Show details';
      CreditLimitNotificationTxt@1012 : TextConst 'DAN=Debitor overskrider kreditmaksimum.;ENU=Customer exceeds credit limit.';
      CreditLimitNotificationDescriptionTxt@1011 : TextConst 'DAN=Viser en advarsel, n†r et salgsdokument overskrider debitorens kreditmaksimum.;ENU=Show warning when a sales document will exceed the customer''s credit limit.';
      OverdueBalanceNotificationTxt@1010 : TextConst 'DAN=Kunden har en forfalden saldo.;ENU=Customer has overdue balance.';
      OverdueBalanceNotificationDescriptionTxt@1009 : TextConst 'DAN=Viser en advarsel, n†r et salgsdokument vedr›rer en debitor, der har en forfalden saldo.;ENU=Show warning when a sales document is for a customer with an overdue balance.';

    [External]
    PROCEDURE GenJnlLineCheck@1(GenJnlLine@1000 : Record 81);
    VAR
      SalesHeader@1002 : Record 36;
      AdditionalContextId@1001 : GUID;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;

      IF NOT SalesHeader.GET(GenJnlLine."Document Type",GenJnlLine."Document No.") THEN
        SalesHeader.INIT;
      OnNewCheckRemoveCustomerNotifications(SalesHeader.RECORDID,TRUE);

      IF CustCheckCreditLimit.GenJnlLineShowWarningAndGetCause(GenJnlLine,AdditionalContextId) THEN
        CreateAndSendNotification(SalesHeader.RECORDID,AdditionalContextId,'');
    END;

    [External]
    PROCEDURE SalesHeaderCheck@2(SalesHeader@1000 : Record 36) CreditLimitExceeded : Boolean;
    VAR
      AdditionalContextId@1001 : GUID;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;

      OnNewCheckRemoveCustomerNotifications(SalesHeader.RECORDID,TRUE);

      IF NOT CustCheckCreditLimit.SalesHeaderShowWarningAndGetCause(SalesHeader,AdditionalContextId) THEN
        SalesHeader.OnCustomerCreditLimitNotExceeded
      ELSE
        IF InstructionMgt.IsEnabled(GetInstructionType(FORMAT(SalesHeader."Document Type"),SalesHeader."No.")) THEN BEGIN
          CreditLimitExceeded := TRUE;

          CreateAndSendNotification(SalesHeader.RECORDID,AdditionalContextId,'');
          SalesHeader.OnCustomerCreditLimitExceeded;
        END;
    END;

    [External]
    PROCEDURE SalesLineCheck@3(SalesLine@1000 : Record 37);
    VAR
      SalesHeader@1001 : Record 36;
      AdditionalContextId@1002 : GUID;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;

      IF NOT SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.") THEN
        SalesHeader.INIT;
      OnNewCheckRemoveCustomerNotifications(SalesHeader.RECORDID,FALSE);

      IF NOT CustCheckCreditLimit.SalesLineShowWarningAndGetCause(SalesLine,AdditionalContextId) THEN
        SalesHeader.OnCustomerCreditLimitNotExceeded
      ELSE
        IF InstructionMgt.IsEnabled(GetInstructionType(FORMAT(SalesLine."Document Type"),SalesLine."Document No.")) THEN BEGIN
          CreateAndSendNotification(SalesHeader.RECORDID,AdditionalContextId,'');
          SalesHeader.OnCustomerCreditLimitExceeded;
        END;
    END;

    [External]
    PROCEDURE ServiceHeaderCheck@5(ServiceHeader@1000 : Record 5900);
    VAR
      AdditionalContextId@1001 : GUID;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;

      OnNewCheckRemoveCustomerNotifications(ServiceHeader.RECORDID,TRUE);

      IF CustCheckCreditLimit.ServiceHeaderShowWarningAndGetCause(ServiceHeader,AdditionalContextId) THEN
        CreateAndSendNotification(ServiceHeader.RECORDID,AdditionalContextId,'');
    END;

    [External]
    PROCEDURE ServiceLineCheck@6(ServiceLine@1000 : Record 5902);
    VAR
      ServiceHeader@1002 : Record 5900;
      AdditionalContextId@1001 : GUID;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;

      IF NOT ServiceHeader.GET(ServiceLine."Document Type",ServiceLine."Document No.") THEN
        ServiceHeader.INIT;
      OnNewCheckRemoveCustomerNotifications(ServiceHeader.RECORDID,FALSE);

      IF CustCheckCreditLimit.ServiceLineShowWarningAndGetCause(ServiceLine,AdditionalContextId) THEN
        CreateAndSendNotification(ServiceHeader.RECORDID,AdditionalContextId,'');
    END;

    [External]
    PROCEDURE ServiceContractHeaderCheck@7(ServiceContractHeader@1001 : Record 5965);
    VAR
      AdditionalContextId@1000 : GUID;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;

      OnNewCheckRemoveCustomerNotifications(ServiceContractHeader.RECORDID,TRUE);

      IF CustCheckCreditLimit.ServiceContractHeaderShowWarningAndGetCause(ServiceContractHeader,AdditionalContextId) THEN
        CreateAndSendNotification(ServiceContractHeader.RECORDID,AdditionalContextId,'');
    END;

    [External]
    PROCEDURE GetInstructionType@32(DocumentType@1000 : Code[30];DocumentNumber@1001 : Code[20]) : Code[50];
    BEGIN
      EXIT(COPYSTR(STRSUBSTNO('%1 %2 %3',DocumentType,DocumentNumber,InstructionTypeTxt),1,50));
    END;

    [External]
    PROCEDURE BlanketSalesOrderToOrderCheck@4(SalesOrderHeader@1000 : Record 36);
    VAR
      AdditionalContextId@1001 : GUID;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;

      OnNewCheckRemoveCustomerNotifications(SalesOrderHeader.RECORDID,TRUE);

      IF CustCheckCreditLimit.SalesHeaderShowWarningAndGetCause(SalesOrderHeader,AdditionalContextId) THEN
        CreateAndSendNotification(SalesOrderHeader.RECORDID,AdditionalContextId,'');
    END;

    [External]
    PROCEDURE ShowNotificationDetails@10(CreditLimitNotification@1000 : Notification);
    VAR
      CreditLimitNotificationPage@1005 : Page 1870;
    BEGIN
      CreditLimitNotificationPage.SetHeading(CreditLimitNotification.MESSAGE);
      CreditLimitNotificationPage.InitializeFromNotificationVar(CreditLimitNotification);
      CreditLimitNotificationPage.RUNMODAL;
    END;

    LOCAL PROCEDURE CreateAndSendNotification@13(RecordId@1000 : RecordID;AdditionalContextId@1003 : GUID;Heading@1001 : Text[250]);
    VAR
      NotificationToSend@1002 : Notification;
    BEGIN
      IF AdditionalContextId = GetBothNotificationsId THEN BEGIN
        CreateAndSendNotification(RecordId,GetCreditLimitNotificationId,CustCheckCreditLimit.GetHeading);
        CreateAndSendNotification(RecordId,GetOverdueBalanceNotificationId,CustCheckCreditLimit.GetSecondHeading);
        EXIT;
      END;

      NotificationToSend.ID(CREATEGUID);
      IF Heading = '' THEN
        NotificationToSend.MESSAGE(CustCheckCreditLimit.GetHeading)
      ELSE
        NotificationToSend.MESSAGE(Heading);
      NotificationToSend.SCOPE(NOTIFICATIONSCOPE::LocalScope);
      NotificationToSend.ADDACTION(GetDetailsTxt,CODEUNIT::"Cust-Check Cr. Limit",'ShowNotificationDetails');
      CustCheckCreditLimit.PopulateDataOnNotification(NotificationToSend);
      NotificationLifecycleMgt.SendNotificationWithAdditionalContext(NotificationToSend,RecordId,AdditionalContextId);
    END;

    [External]
    PROCEDURE GetCreditLimitNotificationId@11() : GUID;
    BEGIN
      EXIT('C80FEEDA-802C-4879-B826-34A10FB77087');
    END;

    [External]
    PROCEDURE GetOverdueBalanceNotificationId@9() : GUID;
    BEGIN
      EXIT('EC8348CB-07C1-499A-9B70-B3B081A33C99');
    END;

    [External]
    PROCEDURE GetBothNotificationsId@16() : GUID;
    BEGIN
      EXIT('EC8348CB-07C1-499A-9B70-B3B081A33D00');
    END;

    [External]
    PROCEDURE IsCreditLimitNotificationEnabled@14(Customer@1000 : Record 18) : Boolean;
    VAR
      MyNotifications@1001 : Record 1518;
    BEGIN
      EXIT(MyNotifications.IsEnabledForRecord(GetCreditLimitNotificationId,Customer));
    END;

    [External]
    PROCEDURE IsOverdueBalanceNotificationEnabled@12(Customer@1000 : Record 18) : Boolean;
    VAR
      MyNotifications@1001 : Record 1518;
    BEGIN
      EXIT(MyNotifications.IsEnabledForRecord(GetOverdueBalanceNotificationId,Customer));
    END;

    [EventSubscriber(Page,1518,OnInitializingNotificationWithDefaultState)]
    LOCAL PROCEDURE OnInitializingNotificationWithDefaultState@15();
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      MyNotifications.InsertDefaultWithTableNum(GetCreditLimitNotificationId,
        CreditLimitNotificationTxt,
        CreditLimitNotificationDescriptionTxt,
        DATABASE::Customer);
      MyNotifications.InsertDefaultWithTableNum(GetOverdueBalanceNotificationId,
        OverdueBalanceNotificationTxt,
        OverdueBalanceNotificationDescriptionTxt,
        DATABASE::Customer);
    END;

    [Integration]
    [External]
    PROCEDURE OnNewCheckRemoveCustomerNotifications@20(RecId@1000 : RecordID;RecallCreditOverdueNotif@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

