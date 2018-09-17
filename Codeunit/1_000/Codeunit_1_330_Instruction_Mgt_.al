OBJECT Codeunit 1330 Instruction Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
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
      WarnUnpostedDocumentsTxt@1006 : TextConst 'DAN=Advar om ikke-bogf›rte bilag.;ENU=Warn about unposted documents.';
      WarnUnpostedDocumentsDescriptionTxt@1005 : TextConst 'DAN=Vis en advarsel, n†r du lukker et bilag, som du ikke har bogf›rt.;ENU=Show warning when you close a document that you have not posted.';
      ConfirmAfterPostingDocumentsTxt@1004 : TextConst 'DAN=Bekr‘ft efter bogf›ring af bilag.;ENU=Confirm after posting documents.';
      ConfirmAfterPostingDocumentsDescriptionTxt@1003 : TextConst 'DAN=Vis advarsel, n†r du bogf›rer et bilag, hvor du kan v‘lge at f† vist det bogf›rte bilag.;ENU=Show warning when you post a document where you can choose to view the posted document.';
      ConfirmPostingAfterCurrentFiscalYearTxt@1002 : TextConst 'DAN=Confirm posting after the current fiscal year.;ENU=Confirm posting after the current fiscal year.';
      ConfirmPostingAfterCurrentFiscalYearDescriptionTxt@1001 : TextConst 'DAN=Show warning when you post entries where the posting date is after the current fiscal year.;ENU=Show warning when you post entries where the posting date is after the current fiscal year.';
      MarkBookingAsInvoicedWarningTxt@1007 : TextConst 'DAN=Bekr‘ft, at booking er markeret som faktureret.;ENU=Confirm marking booking as invoiced.';
      MarkBookingAsInvoicedWarningDescriptionTxt@1008 : TextConst 'DAN=Vis advarsel, n†r du markerer en bookingaftale som faktureret.;ENU=Show warning when you mark a Booking appointment as invoiced.';
      OfficeUpdateNotificationTxt@1009 : TextConst 'DAN=Underret bruger om opdatering til Outlook-tilf›jelsesprogram.;ENU=Notify user of Outlook add-in update.';
      OfficeUpdateNotificationDescriptionTxt@1010 : TextConst 'DAN=Bed bruger opdatere sit Outlook-tilf›jelsesprogram, n†r en opdatering er tilg‘ngelig.;ENU=Ask user to update their Outlook add-in when an update is available.';
      AutomaticLineItemsDialogNotificationTxt@1011 : TextConst 'DAN=Find linjevarer i Outlook-tilf›jelsesprogram;ENU=Discover line items in Outlook add-in';
      AutomaticLineItemsDialogNotificationDescriptionTxt@1012 : TextConst 'DAN=Scan br›dteksten i mail for potentielle linjevarer, n†r du opretter dokumenter i Outlook-tilf›jelsesprogrammet.;ENU=Scan the email body for potential line items when you create documents in the Outlook add-in.';

    [External]
    PROCEDURE ShowConfirm@8(ConfirmQst@1000 : Text;InstructionType@1001 : Code[50]) : Boolean;
    BEGIN
      IF GUIALLOWED AND IsEnabled(InstructionType) THEN
        EXIT(CONFIRM(ConfirmQst));

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE DisableMessageForCurrentUser@4(InstructionType@1002 : Code[50]);
    VAR
      UserPreference@1000 : Record 1306;
    BEGIN
      UserPreference.DisableInstruction(InstructionType);
    END;

    [External]
    PROCEDURE EnableMessageForCurrentUser@10(InstructionType@1002 : Code[50]);
    VAR
      UserPreference@1000 : Record 1306;
    BEGIN
      UserPreference.EnableInstruction(InstructionType);
    END;

    [External]
    PROCEDURE IsEnabled@1(InstructionType@1003 : Code[50]) : Boolean;
    VAR
      UserPreference@1000 : Record 1306;
    BEGIN
      EXIT(NOT UserPreference.GET(USERID,InstructionType));
    END;

    [External]
    PROCEDURE IsMyNotificationEnabled@91(NotificationID@1001 : GUID) : Boolean;
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      IF NOT MyNotifications.GET(USERID,NotificationID) THEN
        EXIT(FALSE);

      EXIT(MyNotifications.Enabled);
    END;

    [External]
    PROCEDURE ShowPostedConfirmationMessageCode@6() : Code[50];
    BEGIN
      EXIT(UPPERCASE('ShowPostedConfirmationMessage'));
    END;

    [External]
    PROCEDURE QueryPostOnCloseCode@2() : Code[50];
    BEGIN
      EXIT(UPPERCASE('QueryPostOnClose'));
    END;

    [External]
    PROCEDURE OfficeUpdateNotificationCode@3() : Code[50];
    BEGIN
      EXIT(UPPERCASE('OfficeUpdateNotification'));
    END;

    [External]
    PROCEDURE PostingAfterCurrentFiscalYearNotAllowedCode@5() : Code[50];
    BEGIN
      EXIT(UPPERCASE('PostingAfterCurrentFiscalYearNotAllowed'));
    END;

    [External]
    PROCEDURE MarkBookingAsInvoicedWarningCode@15() : Code[50];
    BEGIN
      EXIT(UPPERCASE('MarkBookingAsInvoicedWarning'));
    END;

    [External]
    PROCEDURE AutomaticLineItemsDialogCode@7() : Code[50];
    BEGIN
      EXIT(UPPERCASE('AutomaticallyCreateLineItemsFromOutlook'));
    END;

    [External]
    PROCEDURE GetClosingUnpostedDocumentNotificationId@16() : GUID;
    BEGIN
      EXIT('612A2701-4BBB-4C5B-B4C0-629D96B60644');
    END;

    [External]
    PROCEDURE GetOpeningPostedDocumentNotificationId@17() : GUID;
    BEGIN
      EXIT('0C6ED8F1-7408-4352-8DD1-B9F17332607D');
    END;

    [External]
    PROCEDURE GetMarkBookingAsInvoicedWarningNotificationId@18() : GUID;
    BEGIN
      EXIT('413A3221-D47F-4FBF-8822-0029AB41F9A6');
    END;

    [External]
    PROCEDURE GetOfficeUpdateNotificationId@25() : GUID;
    BEGIN
      EXIT('882980DE-C2F6-4D4F-BF39-BB3A9FE3D7DA');
    END;

    [External]
    PROCEDURE GetPostingAfterCurrentFiscalYeartNotificationId@14() : GUID;
    BEGIN
      EXIT('F76D6004-5EC5-4DEA-B14D-71B2AEB53ACF');
    END;

    [External]
    PROCEDURE GetAutomaticLineItemsDialogNotificationId@20() : GUID;
    BEGIN
      EXIT('7FFD2619-BCEF-48F1-B5D1-469DCE5E6631');
    END;

    [EventSubscriber(Page,1518,OnInitializingNotificationWithDefaultState)]
    LOCAL PROCEDURE OnInitializingNotificationWithDefaultState@13();
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      MyNotifications.InsertDefault(GetClosingUnpostedDocumentNotificationId,
        WarnUnpostedDocumentsTxt,
        WarnUnpostedDocumentsDescriptionTxt,
        IsEnabled(QueryPostOnCloseCode));
      MyNotifications.InsertDefault(GetOpeningPostedDocumentNotificationId,
        ConfirmAfterPostingDocumentsTxt,
        ConfirmAfterPostingDocumentsDescriptionTxt,
        IsEnabled(ShowPostedConfirmationMessageCode));
      MyNotifications.InsertDefault(GetPostingAfterCurrentFiscalYeartNotificationId,
        ConfirmPostingAfterCurrentFiscalYearTxt,
        ConfirmPostingAfterCurrentFiscalYearDescriptionTxt,
        IsEnabled(PostingAfterCurrentFiscalYearNotAllowedCode));
      MyNotifications.InsertDefault(GetMarkBookingAsInvoicedWarningNotificationId,
        MarkBookingAsInvoicedWarningTxt,
        MarkBookingAsInvoicedWarningDescriptionTxt,
        IsEnabled(MarkBookingAsInvoicedWarningCode));
      MyNotifications.InsertDefault(GetAutomaticLineItemsDialogNotificationId,
        AutomaticLineItemsDialogNotificationTxt,
        AutomaticLineItemsDialogNotificationDescriptionTxt,
        IsEnabled(AutomaticLineItemsDialogCode));
      MyNotifications.InsertDefault(GetOfficeUpdateNotificationId,
        OfficeUpdateNotificationTxt,
        OfficeUpdateNotificationDescriptionTxt,
        IsEnabled(OfficeUpdateNotificationCode));
    END;

    [EventSubscriber(Table,1518,OnStateChanged)]
    LOCAL PROCEDURE OnStateChanged@12(NotificationId@1000 : GUID;NewEnabledState@1001 : Boolean);
    BEGIN
      CASE NotificationId OF
        GetClosingUnpostedDocumentNotificationId:
          IF NewEnabledState THEN
            EnableMessageForCurrentUser(QueryPostOnCloseCode)
          ELSE
            DisableMessageForCurrentUser(QueryPostOnCloseCode);
        GetOpeningPostedDocumentNotificationId:
          IF NewEnabledState THEN
            EnableMessageForCurrentUser(ShowPostedConfirmationMessageCode)
          ELSE
            DisableMessageForCurrentUser(ShowPostedConfirmationMessageCode);
        GetAutomaticLineItemsDialogNotificationId:
          IF NewEnabledState THEN
            EnableMessageForCurrentUser(AutomaticLineItemsDialogCode)
          ELSE
            DisableMessageForCurrentUser(AutomaticLineItemsDialogCode);
        GetPostingAfterCurrentFiscalYeartNotificationId:
          IF NewEnabledState THEN
            EnableMessageForCurrentUser(PostingAfterCurrentFiscalYearNotAllowedCode)
          ELSE
            DisableMessageForCurrentUser(PostingAfterCurrentFiscalYearNotAllowedCode);
      END;
    END;

    BEGIN
    END.
  }
}

