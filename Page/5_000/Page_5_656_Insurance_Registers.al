OBJECT Page 5656 Insurance Registers
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
    CaptionML=[DAN=Forsikringsjournaler;
               ENU=Insurance Registers];
    SourceTable=Table5636;
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
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Forsikringsposter;
                                 ENU=Ins&urance Coverage Ledger];
                      ToolTipML=[DAN=Vis de forsikringsposter, der bliver dannet, n�r du posterer til en forsikringskonto fra en k�bsfaktura, en kreditnota eller en kladdelinje.;
                                 ENU=View insurance ledger entries that were created when you post to an insurance account from a purchase invoice, credit memo or journal line.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Codeunit 5658;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=InsuranceLedger;
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for bogf�ringen af posterne i journalen.;
                           ENU=Specifies the date when the entries in the register were posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Creation Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf�rt posten, der skal bruges, f.eks. i �ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#FixedAssets;
                SourceExpr="User ID" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Source Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kladdek�rsel, et personligt kladdelayout, som posterne blev bogf�rt fra.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Journal Batch Name" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f�rste varepostnummer i journalen.;
                           ENU=Specifies the first item entry number in the register.];
                ApplicationArea=#FixedAssets;
                SourceExpr="From Entry No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste forsikringspostnummer i journalen.;
                           ENU=Specifies the last insurance entry number in the register.];
                ApplicationArea=#FixedAssets;
                SourceExpr="To Entry No." }

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

