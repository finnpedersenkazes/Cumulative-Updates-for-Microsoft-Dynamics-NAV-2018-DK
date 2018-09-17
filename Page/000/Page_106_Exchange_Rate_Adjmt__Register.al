OBJECT Page 106 Exchange Rate Adjmt. Register
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
    CaptionML=[DAN=Kursregul.journal;
               ENU=Exchange Rate Adjmt. Register];
    SourceTable=Table86;
    PageType=List;
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
                ApplicationArea=#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for kursreguleringsjournalen.;
                           ENU=Specifies the posting date for the exchange rate adjustment register.];
                ApplicationArea=#Suite;
                SourceExpr="Creation Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken kontotype der blev reguleret for kursudsving ved k›rslen Kursreguler valutabeholdninger.;
                           ENU=Specifies the account type that was adjusted for exchange rate fluctuations when you ran the Adjust Exchange Rates batch job.];
                ApplicationArea=#Suite;
                SourceExpr="Account Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsgruppen for kursreguleringsjournalen p† linjen.;
                           ENU=Specifies the posting group of the exchange rate adjustment register on this line.];
                ApplicationArea=#Suite;
                SourceExpr="Posting Group" }

    { 10  ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver koden for den valuta, hvis kurs er blevet reguleret.;
                           ENU=Specifies the code for the currency whose exchange rate was adjusted.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, der blev reguleret ved k›rslen af posterne for debitor, kreditor og/eller bank.;
                           ENU=Specifies the amount that was adjusted by the batch job for customer, vendor and/or bank ledger entries.];
                ApplicationArea=#Suite;
                SourceExpr="Adjusted Base" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b i RV, der blev reguleret ved k›rslen af posterne for finans, debitor, kreditor og/eller bank.;
                           ENU=Specifies the amount in LCY that was adjusted by the batch job for G/L, customer, vendor and/or bank ledger entries.];
                ApplicationArea=#Suite;
                SourceExpr="Adjusted Base (LCY)" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som kursudsving blev reguleret med ved k›rslen af posterne for finans, debitor, kreditor og/eller bank.;
                           ENU=Specifies the amount by which the batch job has adjusted G/L, customer, vendor and/or bank ledger entries for exchange rate fluctuations.];
                ApplicationArea=#Suite;
                SourceExpr="Adjusted Amt. (LCY)" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for ekstra rapporteringsvaluta, som kursudsving blev reguleret med ved k›rslen af posterne for finans, debitor og andet.;
                           ENU=Specifies the additional-reporting-currency amount the batch job has adjusted G/L, customer, and other entries for exchange rate fluctuations.];
                ApplicationArea=#Advanced;
                SourceExpr="Adjusted Base (Add.-Curr.)";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for ekstra rapporteringsvaluta, som kursudsving blev reguleret med ved k›rslen af posterne for finans, debitor og andet.;
                           ENU=Specifies the additional-reporting-currency amount the batch job has adjusted G/L, customer, and other entries for exchange rate fluctuations.];
                ApplicationArea=#Advanced;
                SourceExpr="Adjusted Amt. (Add.-Curr.)";
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

    BEGIN
    END.
  }
}

