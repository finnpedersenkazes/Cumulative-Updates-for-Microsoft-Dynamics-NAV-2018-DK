OBJECT Page 7503 Item Attribute
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Vareattribut;
               ENU=Item Attribute];
    SourceTable=Table7500;
    PageType=Card;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 UpdateControlVisibility;
               END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateControlVisibility;
                         END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;Action    ;
                      Name=ItemAttributeValues;
                      CaptionML=[DAN=Vareattribut&vërdier;
                                 ENU=Item Attribute &Values];
                      ToolTipML=[DAN=èbner et vindue, hvor du kan definere vërdierne for den valgte vareattribut.;
                                 ENU=Opens a window in which you can define the values for the selected item attribute.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7501;
                      RunPageLink=Attribute ID=FIELD(ID);
                      Promoted=Yes;
                      Enabled=ValuesDrillDownVisible;
                      PromotedIsBig=Yes;
                      Image=CalculateInventory;
                      PromotedCategory=Process }
      { 7       ;1   ;Action    ;
                      Name=ItemAttributeTranslations;
                      CaptionML=[DAN=Oversëttelser;
                                 ENU=Translations];
                      ToolTipML=[DAN=èbner et vindue, hvor du kan definere oversëttelserne til den valgte vareattribut.;
                                 ENU=Opens a window in which you can define the translations for the selected item attribute.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7502;
                      RunPageLink=Attribute ID=FIELD(ID);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Translations;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 9   ;1   ;Group     ;
                GroupType=Group }

    { 2   ;2   ;Group     ;
                GroupType=Group }

    { 3   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ vareattributten.;
                           ENU=Specifies the name of the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver typen for vareattributten.;
                           ENU=Specifies the type of the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type;
                OnValidate=BEGIN
                             UpdateControlVisibility;
                           END;
                            }

    { 5   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked }

    { 11  ;2   ;Group     ;
                Visible=ValuesDrillDownVisible;
                GroupType=Group }

    { 12  ;3   ;Field     ;
                Name=Values;
                CaptionML=[DAN=Vërdier;
                           ENU=Values];
                ToolTipML=[DAN=Angiver vërdierne for vareattributten.;
                           ENU=Specifies the values of the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetValues;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              OpenItemAttributeValues;
                            END;
                             }

    { 13  ;2   ;Group     ;
                Visible=UnitOfMeasureVisible;
                GroupType=Group }

    { 4   ;3   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure";
                OnDrillDown=BEGIN
                              OpenItemAttributeValues;
                            END;
                             }

  }
  CODE
  {
    VAR
      ValuesDrillDownVisible@1000 : Boolean;
      UnitOfMeasureVisible@1001 : Boolean;

    LOCAL PROCEDURE UpdateControlVisibility@2();
    BEGIN
      ValuesDrillDownVisible := (Type = Type::Option);
      UnitOfMeasureVisible := (Type = Type::Decimal) OR (Type = Type::Integer);
    END;

    BEGIN
    END.
  }
}

