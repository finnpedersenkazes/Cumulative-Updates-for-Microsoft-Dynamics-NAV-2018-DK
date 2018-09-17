OBJECT Page 5608 FA Posting Type Setup
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl‘gsbogf.typeops‘tning;
               ENU=FA Posting Type Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5604;
    DataCaptionFields=Depreciation Book Code;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf›res til, hvis du har valgt Anl‘gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Book Code";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringstypen, hvis feltet Kontotype indeholder Anl‘gsaktiv.;
                           ENU=Specifies the posting type, if Account Type field contains Fixed Asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Posting Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at de poster, der er bogf›rt med feltet Anl‘gsbogf›ringstype, indg†r i den bogf›rte v‘rdi.;
                           ENU=Specifies that entries posted with the FA Posting Type field will be part of the book value.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Part of Book Value" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at de poster, der er bogf›rt med feltet Anl‘gsbogf›ringstype, indg†r i afskrivningsgrundlaget.;
                           ENU=Specifies that entries posted with the FA Posting Type field will be part of the depreciable basis.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Part of Depreciable Basis" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at de poster, der er bogf›rt med feltet Anl‘gsbogf›ringstype, skal inkluderes i den periodiske afskrivningsberegning.;
                           ENU=Specifies that entries posted with the FA Posting Type field must be included in periodic depreciation calculations.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Include in Depr. Calculation" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at poster, der er bogf›rt med feltet Anl‘gsbogf›ringstype, skal inkluderes i beregningen af gevinst eller tab p† et solgt anl‘g.;
                           ENU=Specifies that entries posted with the FA Posting Type field must be included in the calculation of gain or loss for a sold asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Include in Gain/Loss Calc." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at de poster, der er bogf›rt med feltet Anl‘gsbogf›ringstype, skal tilbagef›res (dvs. nulstilles) inden salg.;
                           ENU=Specifies that entries posted with the FA Posting Type field must be reversed (that is, set to zero) before disposal.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reverse before Disposal" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at poster, der er bogf›rt med Anl‘gsbogf›ringstype, skal indg† i den samlede anskaffelse for anl‘gget i rapporten Anl‘g - bogf›rt v‘rdi 01.;
                           ENU=Specifies that entries posted with the FA Posting Type must be part of the total acquisition for the fixed asset in the Fixed Asset - Book Value 01 report.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Acquisition Type" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at poster, der er bogf›rt med feltet Anl‘gsbogf›ringstype, skal indg† i den samlede afskrivning p† anl‘gget.;
                           ENU=Specifies that entries posted with the FA Posting Type field will be regarded as part of the total depreciation for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Type" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om typen i feltet Anl‘gsbogf›ringstype skal v‘re debet eller kredit.;
                           ENU=Specifies whether the type in the FA Posting Type field should be a debit or a credit.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Sign }

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

