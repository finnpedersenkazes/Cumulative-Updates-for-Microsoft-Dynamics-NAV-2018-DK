OBJECT Page 5602 Fixed Asset Statistics
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
    CaptionML=[DAN=Anl‘gsstatistik;
               ENU=Fixed Asset Statistics];
    LinksAllowed=No;
    SourceTable=Table5612;
    DataCaptionExpr=Caption;
    PageType=Card;
    RefreshOnActivate=Yes;
    OnInit=BEGIN
             DisposalDateVisible := TRUE;
             GainLossVisible := TRUE;
             ProceedsOnDisposalVisible := TRUE;
             DisposalValueVisible := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       Disposed := "Disposal Date" > 0D;
                       DisposalValueVisible := Disposed;
                       ProceedsOnDisposalVisible := Disposed;
                       GainLossVisible := Disposed;
                       DisposalDateVisible := Disposed;
                       CalcBookValue;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 59  ;2   ;Field     ;
                CaptionML=[DAN=Anskaffelsesdato;
                           ENU=Acquisition Date];
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for anl‘gget for den f›rste bogf›rte anskaffelse.;
                           ENU=Specifies the FA posting date of the first posted acquisition cost.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Acquisition Date" }

    { 60  ;2   ;Field     ;
                CaptionML=[DAN=Anskaffelsesdato (finans);
                           ENU=G/L Acquisition Date];
                ToolTipML=[DAN=Angiver finansbogf›ringsdatoen for den f›rste bogf›rte anskaffelse.;
                           ENU=Specifies the G/L posting date of the first posted acquisition cost.];
                ApplicationArea=#FixedAssets;
                SourceExpr="G/L Acquisition Date" }

    { 62  ;2   ;Field     ;
                CaptionML=[DAN=Solgt;
                           ENU=Disposed Of];
                ToolTipML=[DAN=Angiver, om anl‘gget er blevet solgt.;
                           ENU=Specifies whether the fixed asset has been disposed of.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Disposed }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for anl‘g for det f›rste bogf›rte salgsbel›b.;
                           ENU=Specifies the FA posting date of the first posted disposal amount.];
                ApplicationArea=#All;
                SourceExpr="Disposal Date";
                Visible=DisposalDateVisible }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede salgspris for anl‘gget.;
                           ENU=Specifies the total proceeds on disposal for the fixed asset.];
                ApplicationArea=#All;
                SourceExpr="Proceeds on Disposal";
                Visible=ProceedsOnDisposalVisible }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede gevinst (kredit) eller det samlede tab (debet) for anl‘gget.;
                           ENU=Specifies the total gain (credit) or loss (debit) for the fixed asset.];
                ApplicationArea=#All;
                SourceExpr="Gain/Loss";
                Visible=GainLossVisible }

    { 4   ;2   ;Field     ;
                Name=DisposalValue;
                CaptionML=[DAN=Bogf›rt v‘rdi efter afgang;
                           ENU=Book Value after Disposal];
                ToolTipML=[DAN=Angiver den samlede v‘rdi i RV af poster, der er blevet bogf›rt under bogf›ringstypen Bogf›rt v‘rdi ved salg. Denne type poster oprettes, n†r du bogf›rer salget af et anl‘gsaktiv p† en afskrivningsprofil, hvor bruttometoden er valgt i feltet Beregningsmetode ved salg.;
                           ENU=Specifies the total LCY amount of entries posted with the Book Value on Disposal posting type. Entries of this kind are created when you post disposal of a fixed asset to a depreciation book where the Gross method has been selected in the Disposal Calculation Method field.];
                ApplicationArea=#All;
                SourceExpr=BookValueAfterDisposal;
                AutoFormatType=1;
                Visible=DisposalValueVisible;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              ShowBookValueAfterDisposal;
                            END;
                             }

    { 1903895301;2;Group  ;
                GroupType=FixedLayout }

    { 1900206201;3;Group  ;
                CaptionML=[DAN=Sidste bogf›ringsdato for anl‘g;
                           ENU=Last FA Posting Date] }

    { 17  ;4   ;Field     ;
                CaptionML=[DAN=Anskaffelse;
                           ENU=Acquisition Cost];
                ToolTipML=[DAN=Angiver den samlede procentdel af anskaffelsen, som kan allokeres, n†r anskaffelsen bogf›res.;
                           ENU=Specifies the total percentage of acquisition cost that can be allocated when acquisition cost is posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Last Acquisition Cost Date" }

    { 19  ;4   ;Field     ;
                CaptionML=[DAN=Afskrivning;
                           ENU=Depreciation];
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for anl‘gget for den sidste bogf›rte afskrivning.;
                           ENU=Specifies the FA posting date of the last posted depreciation.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Last Depreciation Date" }

    { 20  ;4   ;Field     ;
                CaptionML=[DAN=Nedskrivning;
                           ENU=Write-Down];
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for anl‘gget for den sidste bogf›rte nedskrivning.;
                           ENU=Specifies the FA posting date of the last posted write-down.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Last Write-Down Date" }

    { 21  ;4   ;Field     ;
                CaptionML=[DAN=Opskrivning;
                           ENU=Appreciation];
                ToolTipML=[DAN=Angiver den sum, der udlignes med afskrivninger.;
                           ENU=Specifies the sum that applies to appreciations.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Last Appreciation Date" }

    { 22  ;4   ;Field     ;
                CaptionML=[DAN=Bruger 1;
                           ENU=Custom 1];
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for anl‘gget for den sidste bogf›rte Bruger 1-post.;
                           ENU=Specifies the FA posting date of the last posted custom 1 entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Last Custom 1 Date" }

    { 40  ;4   ;Field     ;
                CaptionML=[DAN=Skrapv‘rdi;
                           ENU=Salvage Value];
                ToolTipML=[DAN=Angiver, om relaterede skrapv‘rdiposter er inkluderet i k›rslen.;
                           ENU=Specifies if related salvage value entries are included in the batch job .];
                ApplicationArea=#FixedAssets;
                SourceExpr="Last Salvage Value Date" }

    { 45  ;4   ;Field     ;
                CaptionML=[DAN=Bruger 2;
                           ENU=Custom 2];
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for anl‘gget for den sidste bogf›rte Bruger 2-post.;
                           ENU=Specifies the FA posting date of the last posted custom 2 entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Last Custom 2 Date" }

    { 1900295901;3;Group  ;
                CaptionML=[DAN=Bel›b;
                           ENU=Amount] }

    { 24  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede anskaffelsespris for anl‘gget.;
                           ENU=Specifies the total acquisition cost for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Acquisition Cost" }

    { 26  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede afskrivning for anl‘gget.;
                           ENU=Specifies the total depreciation for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Depreciation }

    { 28  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede nedskrivningsbel›b i RV for anl‘gget.;
                           ENU=Specifies the total LCY amount of write-down entries for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Write-Down" }

    { 30  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede opskrivning for anl‘gget.;
                           ENU=Specifies the total appreciation for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Appreciation }

    { 32  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede bel›b i RV for Bruger 1-poster for anl‘gget.;
                           ENU=Specifies the total LCY amount for custom 1 entries for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Custom 1" }

    { 34  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver anl‘ggets bogf›rte v‘rdi.;
                           ENU=Specifies the book value for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Book Value" }

    { 36  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den ansl†ede restv‘rdi af et anl‘gsaktiv, n†r det ikke l‘ngere kan bruges.;
                           ENU=Specifies the estimated residual value of a fixed asset when it can no longer be used.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Salvage Value" }

    { 38  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver afskrivningsgrundlaget for anl‘gget.;
                           ENU=Specifies the depreciable basis amount for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciable Basis" }

    { 41  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede bel›b i RV for Bruger 2-poster for anl‘gget.;
                           ENU=Specifies the total LCY amount for custom 2 entries for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Custom 2" }

    { 43  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede vedligeholdelsespris for anl‘gget.;
                           ENU=Specifies the total maintenance cost for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Maintenance }

  }
  CODE
  {
    VAR
      Disposed@1000 : Boolean;
      BookValueAfterDisposal@1001 : Decimal;
      DisposalValueVisible@19039552 : Boolean INDATASET;
      ProceedsOnDisposalVisible@19043726 : Boolean INDATASET;
      GainLossVisible@19008122 : Boolean INDATASET;
      DisposalDateVisible@19073611 : Boolean INDATASET;

    BEGIN
    END.
  }
}

