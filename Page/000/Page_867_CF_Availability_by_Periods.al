OBJECT Page 867 CF Availability by Periods
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Pengestr�m pr. periode;
               ENU=CF Availability by Periods];
    SaveValues=Yes;
    InsertAllowed=No;
    SourceTable=Table840;
    PageType=ListPlus;
    OnAfterGetRecord=BEGIN
                       UpdateSubForm;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1010;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options] }

    { 1011;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Editable=FALSE }

    { 1015;2   ;Field     ;
                ToolTipML=[DAN=Angiver en startdato, fra hvilken manuelle betalinger skal medtages i pengestr�msprognosen.;
                           ENU=Specifies a starting date from which manual payments should be included in cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Manual Payments From";
                Editable=FALSE }

    { 1017;2   ;Field     ;
                CaptionML=[DAN=Til;
                           ENU=To];
                ToolTipML=[DAN=Angiver en startdato, hvortil manuelle betalinger skal medtages i pengestr�msprognosen.;
                           ENU=Specifies a starting date to which manual payments should be included in cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Manual Payments To";
                Editable=FALSE }

    { 1021;2   ;Field     ;
                CaptionML=[DAN=Likvide midler;
                           ENU=Liquid Funds];
                ToolTipML=[DAN=Angiver, om pengestr�msprognosen skal indeholde likvide midler i finansregnskabet.;
                           ENU=Specifies if the cash flow forecast must include liquid funds in the general ledger.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=LiquidFunds;
                AutoFormatType=10;
                AutoFormatExpr=MatrixMgt.GetFormatString(RoundingFactor,FALSE);
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrillDownEntriesFromSource("Source Type Filter"::"Liquid Funds");
                            END;
                             }

    { 1013;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor prognosen blev oprettet.;
                           ENU=Specifies the date that the forecast was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Creation Date";
                Editable=FALSE }

    { 1019;2   ;Field     ;
                CaptionML=[DAN=Afrundingsfaktor;
                           ENU=Rounding Factor];
                ToolTipML=[DAN=Angiver afrundingsfaktoren for bel�b.;
                           ENU=Specifies the factor that is used to round the amounts.];
                OptionCaptionML=[DAN=Ingen,1,1000,1000000;
                                 ENU=None,1,1000,1000000];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=RoundingFactor;
                OnValidate=BEGIN
                             UpdateSubForm;
                           END;
                            }

    { 1001;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode bel�bene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,M�ned,Kvartal,�r,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Period];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             UpdateSubForm;
                           END;
                            }

    { 1009;2   ;Field     ;
                CaptionML=[DAN=Vis som;
                           ENU=View as];
                ToolTipML=[DAN=Angiver, hvordan bel�bene vises. Bev�gelse: Bev�gelsen i saldoen for den valgte periode. Saldo til dato: Saldoen p� den sidste dag i den valgte periode.;
                           ENU=Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.];
                OptionCaptionML=[DAN=Bev�gelse,Saldo til dato;
                                 ENU=Net Change,Balance at Date];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AmountType;
                OnValidate=BEGIN
                             UpdateSubForm;
                           END;
                            }

    { 1000;1   ;Part      ;
                Name=CFAvailabLines;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page866;
                PartType=Page }

  }
  CODE
  {
    VAR
      MatrixMgt@1000 : Codeunit 9200;
      PeriodType@1002 : 'Day,Week,Month,Quarter,Year,Period';
      AmountType@1003 : 'Net Change,Balance at Date';
      RoundingFactor@1004 : 'None,1,1000,1000000';
      LiquidFunds@1006 : Decimal;

    LOCAL PROCEDURE UpdateSubForm@1000();
    BEGIN
      CurrPage.CFAvailabLines.PAGE.Set(Rec,PeriodType,AmountType,RoundingFactor);
      LiquidFunds := MatrixMgt.RoundValue(CalcAmountFromSource("Source Type Filter"::"Liquid Funds"),RoundingFactor);
    END;

    BEGIN
    END.
  }
}

