OBJECT Page 5627 FA Registers
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
    CaptionML=[DAN=Anl‘gsjournaler;
               ENU=FA Registers];
    SourceTable=Table5617;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Journal;
                                 ENU=&Register];
                      Image=Register }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=&Anl‘gsposter;
                                 ENU=F&A Ledger];
                      ToolTipML=[DAN=Vis de anl‘gsposter, der oprettes, n†r du posterer p† konti for anl‘g. Anl‘gsposter oprettes, n†r der posteres en k›bsordre, en faktura, en kreditnota eller en journallinje.;
                                 ENU=View the fixed asset ledger entries that are created when you post to fixed asset accounts. Fixed asset ledger entries are created by the posting of a purchase order, invoice, credit memo or journal line.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Codeunit 5620;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FixedAssetLedger;
                      PromotedCategory=Process }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Reparationsposter;
                                 ENU=Maintenance Ledger];
                      ToolTipML=[DAN=Vis reparationsposterne for det valgte anl‘g.;
                                 ENU=View the maintenance ledger entries for the selected fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Codeunit 5650;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=MaintenanceLedgerEntries;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No." }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kladdeart (Finans eller Anl‘g), som posterne blev bogf›rt fra.;
                           ENU=Specifies the type of journal (G/L or Fixed Asset) that the entries were posted from.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Journal Type" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finansjournal, der blev oprettet, da posterne blev bogf›rt.;
                           ENU=Specifies the number of the G/L register that was created when the entries were posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr="G/L Register No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for bogf›ringen af posterne i journalen.;
                           ENU=Specifies the date when the entries in the register were posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Creation Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#FixedAssets;
                SourceExpr="User ID" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Source Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som posterne blev bogf›rt fra.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Journal Batch Name" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste varepostnummer i journalen.;
                           ENU=Specifies the first item entry number in the register.];
                ApplicationArea=#FixedAssets;
                SourceExpr="From Entry No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste anl‘gspostnummer i journalen.;
                           ENU=Specifies the last FA entry number in the register.];
                ApplicationArea=#FixedAssets;
                SourceExpr="To Entry No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste reparationspostnummer i journalen.;
                           ENU=Specifies the first maintenance entry number in the register.];
                ApplicationArea=#FixedAssets;
                SourceExpr="From Maintenance Entry No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste reparationspostnummer i journalen.;
                           ENU=Specifies the last maintenance entry number in the register.];
                ApplicationArea=#FixedAssets;
                SourceExpr="To Maintenance Entry No." }

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

    BEGIN
    END.
  }
}

