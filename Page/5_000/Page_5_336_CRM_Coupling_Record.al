OBJECT Page 5336 CRM Coupling Record
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=CRM-sammenk‘dningsrecord;
               ENU=CRM Coupling Record];
    SourceTable=Table5332;
    PageType=StandardDialog;
    SourceTableTemporary=Yes;
    OnAfterGetRecord=BEGIN
                       RefreshFields
                     END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 11  ;1   ;Group     ;
                GroupType=Group }

    { 2   ;2   ;Group     ;
                CaptionML=[DAN=Sammenk‘dning;
                           ENU=Coupling];
                GroupType=GridLayout;
                Layout=Columns }

    { 3   ;3   ;Group     ;
                CaptionML=[DAN=Dynamics NAV;
                           ENU=Dynamics NAV];
                GroupType=Group }

    { 4   ;4   ;Field     ;
                Name=NAVName;
                CaptionML=[DAN=Dynamics NAV-navn;
                           ENU=Dynamics NAV Name];
                ToolTipML=[DAN=Angiver navnet p† recorden i Dynamics NAV for at sammenk‘de med en eksisterende Dynamics 365 for Sales-record.;
                           ENU=Specifies the name of the record in Dynamics NAV to couple to an existing Dynamics 365 for Sales record.];
                ApplicationArea=#Suite;
                SourceExpr="NAV Name";
                Editable=FALSE;
                ShowCaption=No }

    { 13  ;4   ;Group     ;
                GroupType=Group }

    { 5   ;5   ;Field     ;
                Name=SyncActionControl;
                CaptionML=[DAN=Synkroniser efter sammenk‘dning;
                           ENU=Synchronize After Coupling];
                ToolTipML=[DAN=Angiver, om data skal synkroniseres i kontakten i recorden i Dynamics NAV og recorden i Dynamics 365 for Sales.;
                           ENU=Specifies whether to synchronize the data in the record in Dynamics NAV and the record in Dynamics 365 for Sales.];
                OptionCaptionML=[DAN=Nej,Ja - Brug Dynamics NAV-dataene,Ja - Brug Dynamics 365 for Sales-dataene;
                                 ENU=No,Yes - Use the Dynamics NAV data,Yes - Use the Dynamics 365 for Sales data];
                ApplicationArea=#Suite;
                SourceExpr="Sync Action";
                Enabled=NOT "Create New" }

    { 6   ;3   ;Group     ;
                CaptionML=[DAN=Dynamics 365 for Sales;
                           ENU=Dynamics 365 for Sales];
                GroupType=Group }

    { 7   ;4   ;Field     ;
                Name=CRMName;
                CaptionML=[DAN=Dynamics 365 for Sales-navn;
                           ENU=Dynamics 365 for Sales Name];
                ToolTipML=[DAN=Angiver navnet p† recorden i Dynamics 365 for Sales, som er sammenk‘det med recorden i Dynamics NAV.;
                           ENU=Specifies the name of the record in Dynamics 365 for Sales that is coupled to the record in Dynamics NAV.];
                ApplicationArea=#Suite;
                SourceExpr="CRM Name";
                Enabled=NOT "Create New";
                OnValidate=BEGIN
                             RefreshFields
                           END;

                OnLookup=BEGIN
                           LookUpCRMName;
                           RefreshFields;
                         END;

                ShowCaption=No }

    { 15  ;4   ;Group     ;
                GroupType=Group }

    { 8   ;5   ;Field     ;
                Name=CreateNewControl;
                CaptionML=[DAN=Opret ny;
                           ENU=Create New];
                ToolTipML=[DAN=Angiver, om en ny record i Dynamics 365 for Sales automatisk oprettes og sammenk‘des med den relaterede record i Dynamics NAV.;
                           ENU=Specifies if a new record in Dynamics 365 for Sales is automatically created and coupled to the related record in Dynamics NAV.];
                ApplicationArea=#Suite;
                SourceExpr="Create New";
                Enabled=EnableCreateNew }

    { 12  ;1   ;Part      ;
                Name=CoupledFields;
                CaptionML=[DAN=Felter;
                           ENU=Fields];
                ApplicationArea=#Suite;
                PagePartID=Page5337;
                PartType=Page;
                ShowFilter=No }

  }
  CODE
  {
    VAR
      EnableCreateNew@1000 : Boolean;

    [External]
    PROCEDURE GetCRMId@1() : GUID;
    BEGIN
      EXIT("CRM ID");
    END;

    [External]
    PROCEDURE GetPerformInitialSynchronization@2() : Boolean;
    BEGIN
      EXIT(Rec.GetPerformInitialSynchronization);
    END;

    [External]
    PROCEDURE GetInitialSynchronizationDirection@3() : Integer;
    BEGIN
      EXIT(Rec.GetInitialSynchronizationDirection);
    END;

    LOCAL PROCEDURE RefreshFields@5();
    BEGIN
      CurrPage.CoupledFields.PAGE.SetSourceRecord(Rec);
    END;

    [External]
    PROCEDURE SetSourceRecordID@4(RecordID@1001 : RecordID);
    BEGIN
      Initialize(RecordID);
      INSERT;
      EnableCreateNew := "Sync Action" = "Sync Action"::"To Integration Table";
    END;

    BEGIN
    END.
  }
}

