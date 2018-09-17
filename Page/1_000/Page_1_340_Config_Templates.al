OBJECT Page 1340 Config Templates
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Skabeloner;
               ENU=Templates];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table8618;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Administrer;
                                ENU=New,Process,Report,Manage];
    OnOpenPage=VAR
                 FilterValue@1000 : Text;
               BEGIN
                 FilterValue := GETFILTER("Table ID");

                 IF NOT EVALUATE(FilteredTableId,FilterValue) THEN
                   FilteredTableId := 0;

                 UpdateActionsVisibility;
                 UpdatePageCaption;

                 IF NewMode THEN
                   UpdateSelection;
               END;

    OnDeleteRecord=BEGIN
                     CASE "Table ID" OF
                       DATABASE::Customer,
                       DATABASE::Item:
                         ConfigTemplateManagement.DeleteRelatedTemplates(Code,DATABASE::"Default Dimension");
                     END;
                   END;

    OnQueryClosePage=BEGIN
                       IF NewMode AND (CloseAction = ACTION::LookupOK) THEN
                         SaveSelection;
                     END;

    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      Name=NewDocumentItems;
                      ActionContainerType=NewDocumentItems }
      { 6       ;1   ;Action    ;
                      Name=NewCustomerTemplate;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ToolTipML=[DAN=Opret en ny skabelon til et debitorkort.;
                                 ENU=Create a new template for a customer card.];
                      ApplicationArea=#All;
                      RunObject=Page 1341;
                      Visible=CreateCustomerActionVisible;
                      Image=NewDocument;
                      RunPageMode=Create }
      { 3       ;1   ;Action    ;
                      Name=NewVendorTemplate;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ToolTipML=[DAN=Opret en ny skabelon til et kreditorkort.;
                                 ENU=Create a new template for a vendor card.];
                      ApplicationArea=#All;
                      RunObject=Page 1344;
                      Visible=CreateVendorActionVisible;
                      Image=NewDocument;
                      RunPageMode=Create }
      { 8       ;1   ;Action    ;
                      Name=NewItemTemplate;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ToolTipML=[DAN=Opret en ny skabelon til et varekort.;
                                 ENU=Create a new template for an item card.];
                      ApplicationArea=#All;
                      RunObject=Page 1342;
                      Visible=CreateItemActionVisible;
                      Image=NewDocument;
                      RunPageMode=Create }
      { 9       ;1   ;Action    ;
                      Name=NewConfigTemplate;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ToolTipML=[DAN=Opret en ny konfigurationsskabelon.;
                                 ENU=Create a new configuration template.];
                      ApplicationArea=#All;
                      RunObject=Page 8618;
                      Visible=CreateConfigurationTemplateActionVisible;
                      Image=NewDocument;
                      RunPageMode=Create }
      { 7       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 10      ;1   ;Action    ;
                      Name=Edit Template;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Rediger;
                                 ENU=Edit];
                      ToolTipML=[DAN=Rediger den valgte skabelon.;
                                 ENU=Edit the selected template.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Image=Edit;
                      Scope=Repeater;
                      OnAction=VAR
                                 TempMiniCustomerTemplate@1000 : TEMPORARY Record 1300;
                                 TempItemTemplate@1001 : TEMPORARY Record 1301;
                                 TempMiniVendorTemplate@1002 : TEMPORARY Record 1303;
                               BEGIN
                                 CASE "Table ID" OF
                                   DATABASE::Customer:
                                     BEGIN
                                       TempMiniCustomerTemplate.InitializeTempRecordFromConfigTemplate(TempMiniCustomerTemplate,Rec);
                                       PAGE.RUN(PAGE::"Cust. Template Card",TempMiniCustomerTemplate);
                                     END;
                                   DATABASE::Item:
                                     BEGIN
                                       TempItemTemplate.InitializeTempRecordFromConfigTemplate(TempItemTemplate,Rec);
                                       PAGE.RUN(PAGE::"Item Template Card",TempItemTemplate);
                                     END;
                                   DATABASE::Vendor:
                                     BEGIN
                                       TempMiniVendorTemplate.InitializeTempRecordFromConfigTemplate(TempMiniVendorTemplate,Rec);
                                       PAGE.RUN(PAGE::"Vendor Template Card",TempMiniVendorTemplate);
                                     END;
                                   ELSE
                                     PAGE.RUN(PAGE::"Config. Template Header",Rec);
                                 END;
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=Delete;
                      CaptionML=[DAN=Slet;
                                 ENU=Delete];
                      ToolTipML=[DAN=Slet recorden.;
                                 ENU=Delete the record.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Image=Delete;
                      OnAction=BEGIN
                                 IF CONFIRM(STRSUBSTNO(DeleteQst,Code)) THEN
                                   DELETE(TRUE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Repeater;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                Name=Template Name;
                ToolTipML=[DAN=Angiver en beskrivelse af skabelonen.;
                           ENU=Specifies a description of the template.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om skabelonen er klar til at blive brugt;
                           ENU=Specifies if the template is ready to be used];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Enabled;
                Visible=NOT NewMode }

  }
  CODE
  {
    VAR
      ConfigTemplateManagement@1007 : Codeunit 8612;
      CreateCustomerActionVisible@1000 : Boolean;
      CreateVendorActionVisible@1011 : Boolean;
      CreateItemActionVisible@1001 : Boolean;
      CreateConfigurationTemplateActionVisible@1002 : Boolean;
      NewMode@1014 : Boolean;
      FilteredTableId@1003 : Integer;
      ConfigurationTemplatesCap@1006 : TextConst 'DAN=Konfigurationsskabeloner;ENU=Configuration Templates';
      CustomerTemplatesCap@1005 : TextConst 'DAN=Debitorskabeloner;ENU=Customer Templates';
      VendorTemplatesCap@1013 : TextConst 'DAN=Kreditorskabeloner;ENU=Vendor Templates';
      ItemTemplatesCap@1004 : TextConst 'DAN=Vareskabeloner;ENU=Item Templates';
      SelectConfigurationTemplatesCap@1010 : TextConst 'DAN=V�lg en skabelon;ENU=Select a template';
      SelectCustomerTemplatesCap@1009 : TextConst 'DAN=V�lg en skabelon til en ny debitor;ENU=Select a template for a new customer';
      SelectVendorTemplatesCap@1012 : TextConst 'DAN=V�lg en skabelon til en ny kreditor;ENU=Select a template for a new vendor';
      SelectItemTemplatesCap@1008 : TextConst 'DAN=V�lg en skabelon til en ny vare;ENU=Select a template for a new item';
      DeleteQst@1015 : TextConst '@@@=%1 - configuration template code;DAN=Skal %1 slettes?;ENU=Delete %1?';

    LOCAL PROCEDURE UpdateActionsVisibility@3();
    BEGIN
      CreateCustomerActionVisible := FALSE;
      CreateItemActionVisible := FALSE;
      CreateConfigurationTemplateActionVisible := FALSE;
      CreateVendorActionVisible := FALSE;

      CASE FilteredTableId OF
        DATABASE::Customer:
          CreateCustomerActionVisible := TRUE;
        DATABASE::Item:
          CreateItemActionVisible := TRUE;
        DATABASE::Vendor:
          CreateVendorActionVisible := TRUE;
        ELSE
          CreateConfigurationTemplateActionVisible := TRUE;
      END;
    END;

    LOCAL PROCEDURE UpdatePageCaption@1();
    VAR
      PageCaption@1000 : Text;
    BEGIN
      IF NOT NewMode THEN
        CASE FilteredTableId OF
          DATABASE::Customer:
            PageCaption := CustomerTemplatesCap;
          DATABASE::Vendor:
            PageCaption := VendorTemplatesCap;
          DATABASE::Item:
            PageCaption := ItemTemplatesCap;
          ELSE
            PageCaption := ConfigurationTemplatesCap;
        END
      ELSE
        CASE FilteredTableId OF
          DATABASE::Customer:
            PageCaption := SelectCustomerTemplatesCap;
          DATABASE::Vendor:
            PageCaption := SelectVendorTemplatesCap;
          DATABASE::Item:
            PageCaption := SelectItemTemplatesCap;
          ELSE
            PageCaption := SelectConfigurationTemplatesCap;
        END;

      CurrPage.CAPTION(PageCaption);
    END;

    LOCAL PROCEDURE UpdateSelection@2();
    VAR
      ConfigTemplateHeader@1002 : Record 8618;
      TemplateSelectionMgt@1000 : Codeunit 1900;
      TemplateCode@1001 : Code[10];
    BEGIN
      CASE FilteredTableId OF
        DATABASE::Customer:
          TemplateSelectionMgt.GetLastCustTemplateSelection(TemplateCode);
        DATABASE::Vendor:
          TemplateSelectionMgt.GetLastVendorTemplateSelection(TemplateCode);
        DATABASE::Item:
          TemplateSelectionMgt.GetLastItemTemplateSelection(TemplateCode);
      END;

      IF NOT (TemplateCode = '') THEN
        IF ConfigTemplateHeader.GET(TemplateCode) THEN
          SETPOSITION(ConfigTemplateHeader.GETPOSITION);
    END;

    LOCAL PROCEDURE SaveSelection@4();
    VAR
      TemplateSelectionMgt@1000 : Codeunit 1900;
    BEGIN
      CASE FilteredTableId OF
        DATABASE::Customer:
          TemplateSelectionMgt.SaveCustTemplateSelectionForCurrentUser(Code);
        DATABASE::Vendor:
          TemplateSelectionMgt.SaveVendorTemplateSelectionForCurrentUser(Code);
        DATABASE::Item:
          TemplateSelectionMgt.SaveItemTemplateSelectionForCurrentUser(Code);
      END;
    END;

    [External]
    PROCEDURE SetNewMode@5();
    BEGIN
      NewMode := TRUE;
    END;

    BEGIN
    END.
  }
}

