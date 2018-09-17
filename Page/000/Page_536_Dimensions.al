OBJECT Page 536 Dimensions
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dimensioner;
               ENU=Dimensions];
    SourceTable=Table348;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,Dimension;
                                ENU=New,Process,Report,Dimension];
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Dimension;
                                 ENU=&Dimension];
                      Image=Dimensions }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Dimensions&v‘rdier;
                                 ENU=Dimension &Values];
                      ToolTipML=[DAN=Se eller rediger dimensionsv‘rdierne for den aktuelle dimension.;
                                 ENU=View or edit the dimension values for the current dimension.];
                      ApplicationArea=#Suite;
                      RunObject=Page 537;
                      RunPageLink=Dimension Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Kontotype - stan&darddim.;
                                 ENU=Account Type De&fault Dim.];
                      ToolTipML=[DAN=Angiver indstillingerne for standarddimensionsv‘rdierne for de relevante kontotyper, f.eks. debitor, kreditor eller elementer. Du kan eksempelvis g›re en dimension obligatorisk.;
                                 ENU=Specify default dimension settings for the relevant account types such as customers, vendors, or items. For example, you can make a dimension required.];
                      ApplicationArea=#Suite;
                      RunObject=Page 541;
                      RunPageLink=Dimension Code=FIELD(Code),
                                  No.=CONST();
                      Promoted=Yes;
                      Image=DefaultDimension;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=Overs‘ttelser;
                                 ENU=Translations];
                      ToolTipML=[DAN=Vis eller rediger oversatte dimensioner. Oversatte varebeskrivelser inds‘ttes automatisk i dokumenter i overensstemmelse med sprogkoden.;
                                 ENU=View or edit translated dimensions. Translated item descriptions are automatically inserted on documents according to the language code.];
                      ApplicationArea=#Suite;
                      RunObject=Page 580;
                      RunPageLink=Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Translations;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 29      ;2   ;Action    ;
                      Name=MapToICDimWithSameCode;
                      CaptionML=[DAN=Knyt til IC-dim. med samme kode;
                                 ENU=Map to IC Dim. with Same Code];
                      ToolTipML=[DAN=Angiv, hvilken IC-dimension der svarer til dimensionen p† linjen. N†r du angiver en dimensionskode p† en IC-salgslinje eller IC-k›bslinje, inds‘ttes den tilsvarende IC-dimensionskode automatisk p† den linje, som sendes til din koncerninterne partner.;
                                 ENU=Specify which intercompany dimension corresponds to the dimension on the line. When you enter a dimension code on an intercompany sales or purchase line, the program will put the corresponding intercompany dimension code on the line that is sent to your intercompany partner.];
                      ApplicationArea=#Dimensions;
                      Image=MapDimensions;
                      OnAction=VAR
                                 Dimension@1000 : Record 348;
                                 ICMapping@1001 : Codeunit 428;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Dimension);
                                 IF Dimension.FIND('-') AND CONFIRM(Text000) THEN
                                   REPEAT
                                     ICMapping.MapOutgoingICDimensions(Dimension);
                                   UNTIL Dimension.NEXT = 0;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for dimensionen.;
                           ENU=Specifies the code for the dimension.];
                ApplicationArea=#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† dimensionskoden.;
                           ENU=Specifies the name of the dimension code.];
                ApplicationArea=#Suite;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver titlen p† dimensionskoden. Dette vises som navnet p† dimensionskodefelterne.;
                           ENU=Specifies the caption of the dimension code. This is displayed as the name of dimension code fields.];
                ApplicationArea=#Suite;
                SourceExpr="Code Caption" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver titlen p† dimensionskoden, n†r den anvendes som et filter. Dette vises som navnet p† dimensionsfilterfelterne.;
                           ENU=Specifies the caption of the dimension code when used as a filter. This is displayed as the name of dimension filter fields.];
                ApplicationArea=#Suite;
                SourceExpr="Filter Caption" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af standarddimensionskoden.;
                           ENU=Specifies a description of the dimension code.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Suite;
                SourceExpr=Blocked }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken IC-dimension der svarer til dimensionen p† linjen.;
                           ENU=Specifies which intercompany dimension corresponds to the dimension on the line.];
                ApplicationArea=#Dimensions;
                SourceExpr="Map-to IC Dimension Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, som anvendes til konsolideringen.;
                           ENU=Specifies the code that is used for consolidation.];
                ApplicationArea=#Suite;
                SourceExpr="Consolidation Code";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Er du sikker p†, at du vil koble de valgte linjer?;ENU=Are you sure you want to map the selected lines?';

    BEGIN
    END.
  }
}

