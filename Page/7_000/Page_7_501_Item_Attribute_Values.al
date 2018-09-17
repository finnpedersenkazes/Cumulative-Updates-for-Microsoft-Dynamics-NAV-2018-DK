OBJECT Page 7501 Item Attribute Values
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Vareattributvërdier;
               ENU=Item Attribute Values];
    SourceTable=Table7501;
    DataCaptionFields=Attribute ID;
    PageType=List;
    OnOpenPage=VAR
                 AttributeID@1000 : Integer;
               BEGIN
                 IF GETFILTER("Attribute ID") <> '' THEN
                   AttributeID := GETRANGEMIN("Attribute ID");
                 IF AttributeID <> 0 THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Attribute ID",AttributeID);
                   FILTERGROUP(0);
                 END;
               END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;ActionGroup;
                      Name=Process;
                      CaptionML=[DAN=Proces;
                                 ENU=Process] }
      { 7       ;2   ;Action    ;
                      Name=ItemAttributeValueTranslations;
                      CaptionML=[DAN=Oversëttelser;
                                 ENU=Translations];
                      ToolTipML=[DAN=èbner et vindue, hvor du kan angive oversëttelserne til den valgte vareattributvërdi.;
                                 ENU=Opens a window in which you can specify the translations of the selected item attribute value.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7505;
                      RunPageLink=Attribute ID=FIELD(Attribute ID),
                                  ID=FIELD(ID);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Translations;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver vërdien for vareattributten.;
                           ENU=Specifies the value of the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Value }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
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

