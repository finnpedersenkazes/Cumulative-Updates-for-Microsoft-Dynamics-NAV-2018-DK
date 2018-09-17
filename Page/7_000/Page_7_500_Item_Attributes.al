OBJECT Page 7500 Item Attributes
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Vareattributter;
               ENU=Item Attributes];
    SourceTable=Table7500;
    PageType=List;
    CardPageID=Item Attribute;
    RefreshOnActivate=Yes;
    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Attribut;
                                 ENU=&Attribute];
                      Image=Attributes }
      { 20      ;2   ;Action    ;
                      Name=ItemAttributeValues;
                      CaptionML=[DAN=Vareattribut&v�rdier;
                                 ENU=Item Attribute &Values];
                      ToolTipML=[DAN=�bner et vindue, hvor du kan definere v�rdierne for den valgte vareattribut.;
                                 ENU=Opens a window in which you can define the values for the selected item attribute.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7501;
                      RunPageLink=Attribute ID=FIELD(ID);
                      Promoted=Yes;
                      Enabled=(Type = Type::Option);
                      PromotedIsBig=Yes;
                      Image=CalculateInventory;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 22      ;2   ;Action    ;
                      Name=ItemAttributeTranslations;
                      CaptionML=[DAN=Overs�ttelser;
                                 ENU=Translations];
                      ToolTipML=[DAN=�bner et vindue, hvor du kan definere overs�ttelserne til den valgte vareattribut.;
                                 ENU=Opens a window in which you can define the translations for the selected item attribute.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7502;
                      RunPageLink=Attribute ID=FIELD(ID);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Translations;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� vareattributten.;
                           ENU=Specifies the name of the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af vareattributten.;
                           ENU=Specifies the type of the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 2   ;2   ;Field     ;
                Name=Values;
                CaptionML=[DAN=V�rdier;
                           ENU=Values];
                ToolTipML=[DAN=Angiver v�rdierne for vareattributten.;
                           ENU=Specifies the values of the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetValues;
                OnDrillDown=BEGIN
                              OpenItemAttributeValues;
                            END;
                             }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf�res under transaktioner - eksempelvis en debitor, som er erkl�ret insolvent, eller en vare, som er sat i karant�ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked }

  }
  CODE
  {

    BEGIN
    END.
  }
}

