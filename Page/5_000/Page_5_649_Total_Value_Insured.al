OBJECT Page 5649 Total Value Insured
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
    CaptionML=[DAN=Forsikret i alt;
               ENU=Total Value Insured];
    SourceTable=Table5600;
    PageType=Document;
    OnAfterGetCurrRecord=BEGIN
                           CurrPage.TotalValue.PAGE.CreateTotalValue("No.");
                           FASetup.GET;
                           FADeprBook.INIT;
                           IF FASetup."Insurance Depr. Book" <> '' THEN
                             IF FADeprBook.GET("No.",FASetup."Insurance Depr. Book") THEN
                               FADeprBook.CALCFIELDS("Acquisition Cost");
                         END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af anl‘gget.;
                           ENU=Specifies a description of the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Forsikring tilknyttet profil;
                           ENU=Insurance Depr. Book];
                ToolTipML=[DAN=Angiver afskrivningsprofilkoden, der er angivet i vinduet Anl‘gsops‘tning.;
                           ENU=Specifies the depreciation book code that is specified in the Fixed Asset Setup window.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FASetup."Insurance Depr. Book" }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Anskaffelse;
                           ENU=Acquisition Cost];
                ToolTipML=[DAN=Angiver den samlede procentdel af anskaffelsen, som kan allokeres, n†r anskaffelsen bogf›res.;
                           ENU=Specifies the total percentage of acquisition cost that can be allocated when acquisition cost is posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADeprBook."Acquisition Cost" }

    { 7   ;1   ;Part      ;
                Name=TotalValue;
                ApplicationArea=#FixedAssets;
                PagePartID=Page5650 }

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
      FASetup@1000 : Record 5603;
      FADeprBook@1002 : Record 5612;

    BEGIN
    END.
  }
}

