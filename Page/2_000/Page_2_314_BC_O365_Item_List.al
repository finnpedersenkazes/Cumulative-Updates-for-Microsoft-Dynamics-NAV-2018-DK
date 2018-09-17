OBJECT Page 2314 BC O365 Item List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Priser;
               ENU=Prices];
    ModifyAllowed=No;
    SourceTable=Table27;
    DataCaptionExpr=Description;
    SourceTableView=SORTING(Description);
    PageType=List;
    CardPageID=BC O365 Item Card;
    RefreshOnActivate=Yes;
    OnInit=VAR
             O365SalesInitialSetup@6115 : Record 2110;
           BEGIN
             IsUsingVAT := O365SalesInitialSetup.IsUsingVAT;
           END;

    OnAfterGetRecord=VAR
                       VATProductPostingGroup@1001 : Record 324;
                       UnitOfMeasure@1000 : Record 204;
                     BEGIN
                       IF VATProductPostingGroup.GET("VAT Prod. Posting Group") THEN
                         VATProductPostingGroupDescription := VATProductPostingGroup.Description;
                       IF UnitOfMeasure.GET("Base Unit of Measure") THEN
                         UnitOfMeasureDescription := UnitOfMeasure.GetDescriptionInCurrentLanguage;
                     END;

    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;Action    ;
                      Name=Edit;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Rediger;
                                 ENU=Edit];
                      ToolTipML=[DAN=èbner priskortet;
                                 ENU=Opens the Price Card];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"BC O365 Item Card",Rec);
                               END;
                                }
      { 9       ;1   ;Action    ;
                      Name=New;
                      CaptionML=[DAN=Ny pris;
                                 ENU=New price];
                      ToolTipML=[DAN=Opret en ny pris;
                                 ENU=Create a new price];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      RunObject=Page 2317;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Invoicing-MDL-New;
                      RunPageMode=Create }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Item;
                CaptionML=[DAN=Pris;
                           ENU=Price];
                GroupType=Repeater }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="No.";
                Visible=FALSE;
                Enabled=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det, du sëlger.;
                           ENU=Specifies what you are selling.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Description;
                OnDrillDown=BEGIN
                              PAGE.RUNMODAL(PAGE::"BC O365 Item Card",Rec);
                            END;
                             }

    { 38  ;2   ;Field     ;
                CaptionML=[DAN=Pris;
                           ENU=Price];
                ToolTipML=[DAN=Angiver prisen for en enhed.;
                           ENU=Specifies the price for one unit.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit Price";
                AutoFormatType=10;
                AutoFormatExpr='2' }

    { 6   ;2   ;Field     ;
                Name=<Unit Price>;
                CaptionML=[DAN=Pris er pr.;
                           ENU=Price is per];
                ToolTipML=[DAN=Angiver prisen for en enhed.;
                           ENU=Specifies the price for one unit.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=UnitOfMeasureDescription;
                QuickEntry=FALSE }

    { 10  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Base Unit of Measure";
                Visible=FALSE;
                Enabled=FALSE }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Skattegruppe;
                           ENU=Tax Group];
                ToolTipML=[DAN=Angiver skattegruppekoden for indtastning af skatteoplysninger.;
                           ENU=Specifies the tax group code for the tax-detail entry.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                NotBlank=Yes;
                SourceExpr="Tax Group Code";
                Visible=NOT IsUsingVAT }

    { 13  ;2   ;Field     ;
                CaptionML=[DAN=Moms;
                           ENU=VAT];
                ToolTipML=[DAN=Angiver momssatsen for denne pris.;
                           ENU=Specifies the VAT rate for this price.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                NotBlank=Yes;
                SourceExpr=VATProductPostingGroupDescription;
                Visible=IsUsingVAT;
                QuickEntry=FALSE }

  }
  CODE
  {
    VAR
      VATProductPostingGroupDescription@1027 : Text[50];
      IsUsingVAT@6115 : Boolean;
      UnitOfMeasureDescription@1004 : Text[10];

    BEGIN
    END.
  }
}

