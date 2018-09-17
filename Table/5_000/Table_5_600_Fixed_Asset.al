OBJECT Table 5600 Fixed Asset
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 5629=r;
    DataCaptionFields=No.,Description;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 FASetup.GET;
                 FASetup.TESTFIELD("Fixed Asset Nos.");
                 NoSeriesMgt.InitSeries(FASetup."Fixed Asset Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;

               "Main Asset/Component" := "Main Asset/Component"::" ";
               "Component of Main Asset" := '';

               DimMgt.UpdateDefaultDim(
                 DATABASE::"Fixed Asset","No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
             END;

    OnModify=BEGIN
               "Last Date Modified" := TODAY;
             END;

    OnDelete=VAR
               FADeprBook@1000 : Record 5612;
             BEGIN
               LOCKTABLE;
               MainAssetComp.LOCKTABLE;
               InsCoverageLedgEntry.LOCKTABLE;
               IF "Main Asset/Component" = "Main Asset/Component"::"Main Asset" THEN
                 ERROR(Text000);
               FAMoveEntries.MoveFAInsuranceEntries("No.");
               FADeprBook.SETRANGE("FA No.","No.");
               FADeprBook.DELETEALL(TRUE);
               IF NOT FADeprBook.ISEMPTY THEN
                 ERROR(Text001,TABLECAPTION,"No.");

               MainAssetComp.SETCURRENTKEY("FA No.");
               MainAssetComp.SETRANGE("FA No.","No.");
               MainAssetComp.DELETEALL;
               IF "Main Asset/Component" = "Main Asset/Component"::Component THEN BEGIN
                 MainAssetComp.RESET;
                 MainAssetComp.SETRANGE("Main Asset No.","Component of Main Asset");
                 MainAssetComp.SETRANGE("FA No.",'');
                 MainAssetComp.DELETEALL;
                 MainAssetComp.SETRANGE("FA No.");
                 IF NOT MainAssetComp.FINDFIRST THEN BEGIN
                   FA.GET("Component of Main Asset");
                   FA."Main Asset/Component" := FA."Main Asset/Component"::" ";
                   FA."Component of Main Asset" := '';
                   FA.MODIFY;
                 END;
               END;

               MaintenanceRegistration.SETRANGE("FA No.","No.");
               MaintenanceRegistration.DELETEALL;

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::"Fixed Asset");
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               DimMgt.DeleteDefaultDim(DATABASE::"Fixed Asset","No.");
             END;

    OnRename=VAR
               SalesLine@1000 : Record 37;
               PurchaseLine@1001 : Record 39;
             BEGIN
               SalesLine.RenameNo(SalesLine.Type::"Fixed Asset",xRec."No.","No.");
               PurchaseLine.RenameNo(PurchaseLine.Type::"Fixed Asset",xRec."No.","No.");

               "Last Date Modified" := TODAY;
             END;

    CaptionML=[DAN=Anl‘g;
               ENU=Fixed Asset];
    LookupPageID=Page5601;
    DrillDownPageID=Page5601;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  FASetup.GET;
                                                                  NoSeriesMgt.TestManual(FASetup."Fixed Asset Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   AltSearchField=Search Description;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Description         ;Text50        ;OnValidate=VAR
                                                                FADeprBook@1000 : Record 5612;
                                                              BEGIN
                                                                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                                                                  "Search Description" := Description;
                                                                IF Description <> xRec.Description THEN BEGIN
                                                                  FADeprBook.SETCURRENTKEY("FA No.");
                                                                  FADeprBook.SETRANGE("FA No.","No.");
                                                                  FADeprBook.MODIFYALL(Description,Description);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Search Description  ;Code50        ;CaptionML=[DAN=S›gebeskrivelse;
                                                              ENU=Search Description] }
    { 4   ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 5   ;   ;FA Class Code       ;Code10        ;TableRelation="FA Class";
                                                   OnValidate=VAR
                                                                FASubclass@1000 : Record 5608;
                                                              BEGIN
                                                                IF "FA Subclass Code" = '' THEN
                                                                  EXIT;

                                                                FASubclass.GET("FA Subclass Code");
                                                                IF NOT (FASubclass."FA Class Code" IN ['',"FA Class Code"]) THEN
                                                                  "FA Subclass Code" := '';
                                                              END;

                                                   CaptionML=[DAN=Anl‘gsartskode;
                                                              ENU=FA Class Code] }
    { 6   ;   ;FA Subclass Code    ;Code10        ;TableRelation="FA Subclass";
                                                   OnValidate=VAR
                                                                FASubclass@1000 : Record 5608;
                                                              BEGIN
                                                                IF "FA Subclass Code" = '' THEN
                                                                  EXIT;

                                                                FASubclass.GET("FA Subclass Code");
                                                                IF "FA Class Code" <> '' THEN BEGIN
                                                                  IF FASubclass."FA Class Code" IN ['',"FA Class Code"] THEN
                                                                    EXIT;

                                                                  ERROR(UnexpctedSubclassErr);
                                                                END;

                                                                VALIDATE("FA Class Code",FASubclass."FA Class Code");
                                                              END;

                                                   CaptionML=[DAN=Anl‘gsgruppekode;
                                                              ENU=FA Subclass Code] }
    { 7   ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 8   ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 9   ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 10  ;   ;FA Location Code    ;Code10        ;TableRelation="FA Location";
                                                   CaptionML=[DAN=Anl‘gslokationskode;
                                                              ENU=FA Location Code] }
    { 11  ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Kreditornr. (k›b);
                                                              ENU=Vendor No.] }
    { 12  ;   ;Main Asset/Component;Option        ;CaptionML=[DAN=Hovedanl‘g/underanl.;
                                                              ENU=Main Asset/Component];
                                                   OptionCaptionML=[DAN=" ,Hovedanl‘g,Underanl‘g";
                                                                    ENU=" ,Main Asset,Component"];
                                                   OptionString=[ ,Main Asset,Component];
                                                   Editable=No }
    { 13  ;   ;Component of Main Asset;Code20     ;TableRelation="Fixed Asset";
                                                   CaptionML=[DAN=Del af hovedanl‘g;
                                                              ENU=Component of Main Asset];
                                                   Editable=No }
    { 14  ;   ;Budgeted Asset      ;Boolean       ;OnValidate=BEGIN
                                                                FAMoveEntries.ChangeBudget(Rec);
                                                              END;

                                                   CaptionML=[DAN=Budgetanl‘g;
                                                              ENU=Budgeted Asset] }
    { 15  ;   ;Warranty Date       ;Date          ;CaptionML=[DAN=Garantioph›r den;
                                                              ENU=Warranty Date] }
    { 16  ;   ;Responsible Employee;Code20        ;TableRelation=Employee;
                                                   CaptionML=[DAN=Ansvarlig medarbejder;
                                                              ENU=Responsible Employee] }
    { 17  ;   ;Serial No.          ;Text30        ;CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
    { 18  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 19  ;   ;Insured             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Ins. Coverage Ledger Entry" WHERE (FA No.=FIELD(No.),
                                                                                                         Disposed FA=CONST(No)));
                                                   CaptionML=[DAN=Forsikret;
                                                              ENU=Insured];
                                                   Editable=No }
    { 20  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(Fixed Asset),
                                                                                           No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 21  ;   ;Blocked             ;Boolean       ;CaptionML=[DAN=Sp‘rret;
                                                              ENU=Blocked] }
    { 22  ;   ;Picture             ;BLOB          ;CaptionML=[DAN=Billede;
                                                              ENU=Picture];
                                                   SubType=Bitmap }
    { 23  ;   ;Maintenance Vendor No.;Code20      ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Kreditornr. (reparation);
                                                              ENU=Maintenance Vendor No.] }
    { 24  ;   ;Under Maintenance   ;Boolean       ;CaptionML=[DAN=Under reparation;
                                                              ENU=Under Maintenance] }
    { 25  ;   ;Next Service Date   ;Date          ;CaptionML=[DAN=N‘ste servicedato;
                                                              ENU=Next Service Date] }
    { 26  ;   ;Inactive            ;Boolean       ;CaptionML=[DAN=Inaktiv;
                                                              ENU=Inactive] }
    { 27  ;   ;FA Posting Date Filter;Date        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter til bogf›ringsdato for anl‘g;
                                                              ENU=FA Posting Date Filter] }
    { 28  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 29  ;   ;FA Posting Group    ;Code20        ;TableRelation="FA Posting Group";
                                                   CaptionML=[DAN=Anl‘gsbogf›ringsgruppe;
                                                              ENU=FA Posting Group] }
    { 30  ;   ;Acquired            ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("FA Depreciation Book" WHERE (FA No.=FIELD(No.),
                                                                                                   Acquisition Date=FILTER(<>'')));
                                                   CaptionML=[DAN=Anskaffet;
                                                              ENU=Acquired] }
    { 140 ;   ;Image               ;Media         ;CaptionML=[DAN=Grafik;
                                                              ENU=Image] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Description                       }
    {    ;FA Class Code                            }
    {    ;FA Subclass Code                         }
    {    ;Component of Main Asset,Main Asset/Component }
    {    ;FA Location Code                         }
    {    ;Global Dimension 1 Code                  }
    {    ;Global Dimension 2 Code                  }
    {    ;FA Posting Group                         }
    {    ;Description                              }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Description,FA Class Code            }
    { 2   ;Brick               ;No.,Description,FA Class Code,Image      }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke slette et hovedanl‘g.;ENU=A main asset cannot be deleted.';
      Text001@1001 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi anl‘gget har tilknyttede afskrivningsprofiler.;ENU=You cannot delete %1 %2 because it has associated depreciation books.';
      CommentLine@1002 : Record 97;
      FA@1003 : Record 5600;
      FASetup@1004 : Record 5603;
      MaintenanceRegistration@1005 : Record 5616;
      MainAssetComp@1007 : Record 5640;
      InsCoverageLedgEntry@1008 : Record 5629;
      FAMoveEntries@1009 : Codeunit 5623;
      NoSeriesMgt@1010 : Codeunit 396;
      DimMgt@1011 : Codeunit 408;
      UnexpctedSubclassErr@1006 : TextConst 'DAN=Denne anl‘gsgruppe tilh›rer en anden anl‘gsart.;ENU=This fixed asset subclass belongs to a different fixed asset class.';
      DontAskAgainActionTxt@1018 : TextConst 'DAN=Sp›rg mig ikke igen;ENU=Don''t ask again';
      NotificationNameTxt@1016 : TextConst '@@@={Locked};DAN=Fixed Asset Acquisition Wizard;ENU=Fixed Asset Acquisition Wizard';
      NotificationDescriptionTxt@1015 : TextConst '@@@={Locked};DAN=Notify when ready to acquire the fixed asset.;ENU=Notify when ready to acquire the fixed asset.';
      ReadyToAcquireMsg@1014 : TextConst 'DAN=Du er klar til at k›be anl‘gget.;ENU=You are ready to acquire the fixed asset.';
      AcquireActionTxt@1013 : TextConst 'DAN=Anskaf;ENU=Acquire';

    [External]
    PROCEDURE AssistEdit@2(OldFA@1000 : Record 5600) : Boolean;
    BEGIN
      WITH FA DO BEGIN
        FA := Rec;
        FASetup.GET;
        FASetup.TESTFIELD("Fixed Asset Nos.");
        IF NoSeriesMgt.SelectSeries(FASetup."Fixed Asset Nos.",OldFA."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          Rec := FA;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::"Fixed Asset","No.",FieldNumber,ShortcutDimCode);
      MODIFY(TRUE);
    END;

    [External]
    PROCEDURE FieldsForAcquitionInGeneralGroupAreCompleted@30() : Boolean;
    BEGIN
      EXIT(("No." <> '') AND (Description <> '') AND ("FA Subclass Code" <> ''));
    END;

    [External]
    PROCEDURE ShowAcquireWizardNotification@3();
    VAR
      NotificationLifecycleMgt@1002 : Codeunit 1511;
      FixedAssetAcquisitionWizard@1001 : Codeunit 5550;
      FAAcquireWizardNotification@1000 : Notification;
    BEGIN
      IF IsNotificationEnabledForCurrentUser THEN BEGIN
        FAAcquireWizardNotification.ID(GetNotificationID);
        FAAcquireWizardNotification.MESSAGE(ReadyToAcquireMsg);
        FAAcquireWizardNotification.SCOPE(NOTIFICATIONSCOPE::LocalScope);
        FAAcquireWizardNotification.ADDACTION(
          AcquireActionTxt,CODEUNIT::"Fixed Asset Acquisition Wizard",'RunAcquisitionWizardFromNotification');
        FAAcquireWizardNotification.ADDACTION(
          DontAskAgainActionTxt,CODEUNIT::"Fixed Asset Acquisition Wizard",'HideNotificationForCurrentUser');
        FAAcquireWizardNotification.SETDATA(FixedAssetAcquisitionWizard.GetNotificationFANoDataItemID,"No.");
        NotificationLifecycleMgt.SendNotification(FAAcquireWizardNotification,RECORDID);
      END
    END;

    PROCEDURE GetNotificationID@4() : GUID;
    BEGIN
      EXIT('3d5c2f86-cfb9-4407-97c3-9df74c7696c9');
    END;

    PROCEDURE SetNotificationDefaultState@10();
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      MyNotifications.InsertDefault(GetNotificationID,NotificationNameTxt,NotificationDescriptionTxt,TRUE);
    END;

    LOCAL PROCEDURE IsNotificationEnabledForCurrentUser@1() : Boolean;
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      EXIT(MyNotifications.IsEnabled(GetNotificationID));
    END;

    PROCEDURE DontNotifyCurrentUserAgain@6();
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      IF NOT MyNotifications.Disable(GetNotificationID) THEN
        MyNotifications.InsertDefault(GetNotificationID,NotificationNameTxt,NotificationDescriptionTxt,FALSE);
    END;

    PROCEDURE RecallNotificationForCurrentUser@9();
    VAR
      NotificationLifecycleMgt@1000 : Codeunit 1511;
    BEGIN
      NotificationLifecycleMgt.RecallNotificationsForRecord(RECORDID,FALSE);
    END;

    BEGIN
    END.
  }
}

