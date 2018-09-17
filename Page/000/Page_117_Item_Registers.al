OBJECT Page 117 Item Registers
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
    CaptionML=[DAN=Varejournaler;
               ENU=Item Registers];
    SourceTable=Table46;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Journal;
                                 ENU=&Register];
                      Image=Register }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Vareposter;
                                 ENU=Item Ledger];
                      ToolTipML=[DAN=Se de vareposter, der medf›rte den aktuelle kladdepost.;
                                 ENU=View the item ledger entries that resulted in the current register entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 245;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ItemLedger;
                      PromotedCategory=Process }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Lageropg›relsesp&oster;
                                 ENU=Phys. Invent&ory Ledger];
                      ToolTipML=[DAN=Se de lagerposter, der medf›rte den aktuelle kladdepost.;
                                 ENU=View the physical inventory ledger entries that resulted in the current register entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 390;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PhysicalInventoryLedger;
                      PromotedCategory=Process }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=V‘rdiposter;
                                 ENU=Value Entries];
                      ToolTipML=[DAN=Vis v‘rdiposterne for varen p† bilags- eller kladdelinjen.;
                                 ENU=View the value entries of the item on the document or journal line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 5800;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ValueLedger;
                      PromotedCategory=Process }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=&Kapacitetspost;
                                 ENU=&Capacity Ledger];
                      ToolTipML=[DAN=Se de kapacitetsposter, der medf›rte den aktuelle kladdepost.;
                                 ENU=View the capacity ledger entries that resulted in the current register entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 5835;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CapacityLedger;
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
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for bogf›ringen af posterne i journalen.;
                           ENU=Specifies the date when the entries in the register were posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Creation Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som posterne blev bogf›rt fra.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Journal Batch Name" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste varepostnummer i journalen.;
                           ENU=Specifies the first item entry number in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="From Entry No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste varepostnummer i journalen.;
                           ENU=Specifies the last item entry number in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="To Entry No." }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste postnummer for det fysiske lager i journalen.;
                           ENU=Specifies the first physical inventory ledger entry number in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="From Phys. Inventory Entry No." }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste postnummer for det fysiske lager i journalen.;
                           ENU=Specifies the last physical inventory ledger entry number in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="To Phys. Inventory Entry No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste v‘rdipostnummer i journalen.;
                           ENU=Specifies the first value entry number in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="From Value Entry No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste v‘rdipostnummer i denne journal.;
                           ENU=Specifies the last value entry number in this register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="To Value Entry No." }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste kapacitetspostnummer i journalen.;
                           ENU=Specifies the first capacity entry number in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="From Capacity Entry No." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste kapacitetspostnummer i denne journal.;
                           ENU=Specifies the last capacity ledger entry number in this register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="To Capacity Entry No." }

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

