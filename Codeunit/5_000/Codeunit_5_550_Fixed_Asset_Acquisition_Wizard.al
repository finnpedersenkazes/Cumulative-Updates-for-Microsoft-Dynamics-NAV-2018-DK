OBJECT Codeunit 5550 Fixed Asset Acquisition Wizard
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      GenJournalBatchNameTxt@1000 : TextConst '@@@=Translate normally and keep the upper case;DAN=AUTOMATISK;ENU=AUTOMATIC';
      SimpleJnlDescriptionTxt@1001 : TextConst 'DAN=Anl�gsanskaffelse;ENU=Fixed Asset Acquisition';

    [External]
    PROCEDURE RunAcquisitionWizard@7(FixedAssetNo@1001 : Code[20]);
    VAR
      TempGenJournalLine@1003 : TEMPORARY Record 81;
    BEGIN
      TempGenJournalLine.SETRANGE("Account No.",FixedAssetNo);
      PAGE.RUNMODAL(PAGE::"Fixed Asset Acquisition Wizard",TempGenJournalLine);
    END;

    [External]
    PROCEDURE RunAcquisitionWizardFromNotification@2(FixedAssetAcquisitionNotification@1001 : Notification);
    VAR
      FixedAssetNo@1002 : Code[20];
    BEGIN
      InitializeFromNotification(FixedAssetAcquisitionNotification,FixedAssetNo);
      RunAcquisitionWizard(FixedAssetNo);
    END;

    [External]
    PROCEDURE PopulateDataOnNotification@1(VAR FixedAssetAcquisitionNotification@1000 : Notification;FixedAssetNo@1012 : Code[20]);
    BEGIN
      FixedAssetAcquisitionNotification.SETDATA(GetNotificationFANoDataItemID,FixedAssetNo);
    END;

    [External]
    PROCEDURE InitializeFromNotification@4(FixedAssetAcquisitionNotification@1000 : Notification;VAR FixedAssetNo@1008 : Code[20]);
    BEGIN
      FixedAssetNo := FixedAssetAcquisitionNotification.GETDATA(GetNotificationFANoDataItemID);
    END;

    [External]
    PROCEDURE GetAutogenJournalBatch@214() : Code[10];
    VAR
      GenJournalBatch@1000 : Record 232;
    BEGIN
      IF NOT GenJournalBatch.GET(SelectFATemplate,GenJournalBatchNameTxt) THEN BEGIN
        GenJournalBatch.INIT;
        GenJournalBatch."Journal Template Name" := SelectFATemplate;
        GenJournalBatch.Name := GenJournalBatchNameTxt;
        GenJournalBatch.Description := SimpleJnlDescriptionTxt;
        GenJournalBatch.SetupNewBatch;
        GenJournalBatch.INSERT;
      END;

      EXIT(GenJournalBatch.Name);
    END;

    [External]
    PROCEDURE SelectFATemplate@215() ReturnValue : Code[10];
    VAR
      FAJournalLine@1170000001 : Record 5621;
      FAJnlManagement@1003 : Codeunit 5638;
      JnlSelected@1000 : Boolean;
    BEGIN
      FAJnlManagement.TemplateSelection(PAGE::"Fixed Asset Journal",FALSE,FAJournalLine,JnlSelected);

      IF JnlSelected THEN BEGIN
        FAJournalLine.FILTERGROUP := 2;
        ReturnValue := COPYSTR(FAJournalLine.GETFILTER("Journal Template Name"),1,MAXSTRLEN(FAJournalLine."Journal Template Name"));
        FAJournalLine.FILTERGROUP := 0;
      END;
    END;

    PROCEDURE HideNotificationForCurrentUser@5(Notification@1001 : Notification);
    VAR
      FixedAsset@1000 : Record 5600;
    BEGIN
      IF Notification.ID = FixedAsset.GetNotificationID THEN
        FixedAsset.DontNotifyCurrentUserAgain;
    END;

    PROCEDURE GetNotificationFANoDataItemID@3() : Text;
    BEGIN
      EXIT('FixedAssetNo');
    END;

    [EventSubscriber(Page,5600,OnClosePageEvent)]
    PROCEDURE RecallNotificationAboutFAAcquisitionWizardOnFixedAssetCard@8(VAR Rec@1000 : Record 5600);
    VAR
      FixedAsset@1001 : Record 5600;
    BEGIN
      FixedAsset.RecallNotificationForCurrentUser;
    END;

    [EventSubscriber(Page,1518,OnInitializingNotificationWithDefaultState)]
    PROCEDURE EnableSaaSNotificationPreferenceSetupOnInitializingNotificationWithDefaultState@9();
    VAR
      FixedAsset@1000 : Record 5600;
    BEGIN
      FixedAsset.SetNotificationDefaultState;
    END;

    BEGIN
    END.
  }
}

