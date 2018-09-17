OBJECT Page 2317 BC O365 Item Card
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Pris;
               ENU=Price];
    SourceTable=Table27;
    DataCaptionExpr=Description;
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Vare,Oversigt,Specialpriser og -rabatter,Godkend,Anmod om godkendelse,Detaljer;
                                ENU=New,Process,Report,Item,History,Special Prices & Discounts,Approve,Request Approval,Details];
    OnInit=VAR
             O365SalesInitialSetup@6115 : Record 2110;
           BEGIN
             IsUsingVAT := O365SalesInitialSetup.IsUsingVAT;
           END;

    OnOpenPage=BEGIN
                 IF Description = '' THEN
                   ItemCardStatus := ItemCardStatus::Delete
                 ELSE
                   ItemCardStatus := ItemCardStatus::Keep;
               END;

    OnNewRecord=BEGIN
                  OnNewRec;
                END;

    OnInsertRecord=BEGIN
                     IF Description = '' THEN
                       ItemCardStatus := ItemCardStatus::Delete
                     ELSE
                       ItemCardStatus := ItemCardStatus::Keep;

                     EXIT(TRUE);
                   END;

    OnModifyRecord=BEGIN
                     IF Description = '' THEN
                       ItemCardStatus := ItemCardStatus::Prompt
                     ELSE
                       ItemCardStatus := ItemCardStatus::Keep;

                     EXIT(TRUE);
                   END;

    OnQueryClosePage=BEGIN
                       EXIT(CanExitAfterProcessingItem);
                     END;

    OnAfterGetCurrRecord=VAR
                           VATProductPostingGroup@1000 : Record 324;
                           UnitOfMeasure@1001 : Record 204;
                         BEGIN
                           CreateItemFromTemplate;
                           IF VATProductPostingGroup.GET("VAT Prod. Posting Group") THEN
                             VATProductPostingGroupDescription := VATProductPostingGroup.Description;
                           IF UnitOfMeasure.GET("Base Unit of Measure") THEN
                             UnitOfMeasureDescription := UnitOfMeasure.GetDescriptionInCurrentLanguage;
                           IsPageEditable := CurrPage.EDITABLE;
                         END;

    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      Name=Delete;
                      CaptionML=[DAN=Slet;
                                 ENU=Delete];
                      ToolTipML=[DAN=Slet recorden.;
                                 ENU=Delete the record.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Invoicing-MDL-Delete;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(DeleteQst,FALSE) THEN
                                   EXIT;
                                 DELETE(TRUE);
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 3   ;0   ;Container ;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Name=Item;
                CaptionML=[DAN=Produkt/service;
                           ENU=Product/Service];
                GroupType=Group }

    { 4   ;2   ;Field     ;
                Name=Description;
                ToolTipML=[DAN=Angiver det, du s‘lger.;
                           ENU=Specifies what you are selling.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Description;
                Importance=Promoted }

    { 38  ;2   ;Field     ;
                CaptionML=[DAN=Pris;
                           ENU=Price];
                ToolTipML=[DAN=Angiver prisen for en enhed.;
                           ENU=Specifies the price for one unit.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit Price";
                Importance=Promoted }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Pris er pr.;
                           ENU=Price is per];
                ToolTipML=[DAN=Angiver prisen for en enhed.;
                           ENU=Specifies the price for one unit.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=UnitOfMeasureDescription;
                Editable=FALSE;
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE);
                           END;

                OnAssistEdit=VAR
                               TempUnitOfMeasure@1000 : TEMPORARY Record 204;
                             BEGIN
                               TempUnitOfMeasure.CreateListInCurrentLangauage(TempUnitOfMeasure);
                               IF TempUnitOfMeasure.GET("Base Unit of Measure") THEN;
                               IF PAGE.RUNMODAL(PAGE::"O365 Units of Measure",TempUnitOfMeasure) = ACTION::LookupOK THEN BEGIN
                                 VALIDATE("Base Unit of Measure",TempUnitOfMeasure.Code);
                                 UnitOfMeasureDescription := TempUnitOfMeasure.Description;
                               END;
                             END;

                QuickEntry=FALSE }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Skattegruppe;
                           ENU=Tax Group];
                ToolTipML=[DAN=Angiver skattegruppekoden for indtastning af skatteoplysninger.;
                           ENU=Specifies the tax group code for the tax-detail entry.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                NotBlank=Yes;
                SourceExpr="Tax Group Code";
                Visible=NOT IsUsingVAT;
                Editable=IsPageEditable }

    { 13  ;2   ;Field     ;
                CaptionML=[DAN=Moms;
                           ENU=VAT];
                ToolTipML=[DAN=Angiver momssatsen for denne pris.;
                           ENU=Specifies the VAT rate for this price.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                NotBlank=Yes;
                SourceExpr=VATProductPostingGroupDescription;
                Visible=IsUsingVAT;
                Editable=FALSE;
                OnAssistEdit=VAR
                               VATProductPostingGroup@1000 : Record 324;
                             BEGIN
                               IF PAGE.RUNMODAL(PAGE::"O365 VAT Product Posting Gr.",VATProductPostingGroup) = ACTION::LookupOK THEN BEGIN
                                 VALIDATE("VAT Prod. Posting Group",VATProductPostingGroup.Code);
                                 VATProductPostingGroupDescription := VATProductPostingGroup.Description;
                               END;
                             END;

                QuickEntry=FALSE }

  }
  CODE
  {
    VAR
      ItemCardStatus@1000 : 'Keep,Delete,Prompt';
      ProcessNewItemOptionQst@1002 : TextConst 'DAN=Forts‘t redigering,Kass‚r;ENU=Keep editing,Discard';
      ProcessNewItemInstructionTxt@1001 : TextConst 'DAN=Beskrivelse mangler. Vil du bevare prisen?;ENU=Description is missing. Keep the price?';
      VATProductPostingGroupDescription@1027 : Text[50];
      NewMode@1006 : Boolean;
      IsUsingVAT@6115 : Boolean;
      IsPageEditable@1003 : Boolean;
      UnitOfMeasureDescription@1004 : Text[10];
      DeleteQst@1007 : TextConst 'DAN=Er du sikker?;ENU=Are you sure?';

    LOCAL PROCEDURE OnNewRec@16();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      IF GUIALLOWED AND DocumentNoVisibility.ItemNoSeriesIsDefault THEN
        NewMode := TRUE;
    END;

    LOCAL PROCEDURE CanExitAfterProcessingItem@2() : Boolean;
    VAR
      Response@1000 : ',KeepEditing,Discard';
    BEGIN
      IF "No." = '' THEN
        EXIT(TRUE);

      IF ItemCardStatus = ItemCardStatus::Delete THEN BEGIN
        // workaround for bug: delete for new empty record returns false
        IF DELETE(TRUE) THEN;
        EXIT(TRUE);
      END;

      IF GUIALLOWED AND (ItemCardStatus = ItemCardStatus::Prompt) THEN
        CASE STRMENU(ProcessNewItemOptionQst,Response::KeepEditing,ProcessNewItemInstructionTxt) OF
          Response::Discard:
            EXIT(DELETE(TRUE));
          ELSE
            EXIT(FALSE);
        END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateItemFromTemplate@3();
    VAR
      ItemTemplate@1001 : Record 1301;
      Item@1000 : Record 27;
      O365SalesManagement@1002 : Codeunit 2107;
    BEGIN
      IF NewMode THEN BEGIN
        IF ItemTemplate.NewItemFromTemplate(Item) THEN BEGIN
          COPY(Item);
          O365SalesManagement.SetItemDefaultValues(Item);
          CurrPage.UPDATE;
        END;
        ItemCardStatus := ItemCardStatus::Delete;
        NewMode := FALSE;
      END;
    END;

    BEGIN
    END.
  }
}

