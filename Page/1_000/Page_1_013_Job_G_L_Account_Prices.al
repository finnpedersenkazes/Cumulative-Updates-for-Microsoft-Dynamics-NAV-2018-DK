OBJECT Page 1013 Job G/L Account Prices
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagsfinanskontopriser;
               ENU=Job G/L Account Prices];
    SourceTable=Table1014;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiv nummeret p� sagsopgaven, hvis finansprisen kun skal g�lde for en bestemt sagsopgave.;
                           ENU=Specifies the number of the job task if the general ledger price should only apply to a specific job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, som denne pris g�lder for. V�lg feltet for at se de tilg�ngelige varer.;
                           ENU=Specifies the G/L Account that this price applies to. Choose the field to see the available items.];
                ApplicationArea=#Jobs;
                SourceExpr="G/L Account No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for salgsprisens valuta, hvis den pris, du har angivet p� linjen, er i en udenlandsk valuta. V�lg feltet for at se de tilg�ngelige valutakoder.;
                           ENU=Specifies tithe code for the sales price currency if the price that you have set up in this line is in a foreign currency. Choose the field to see the available currency codes.];
                ApplicationArea=#Jobs;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for �n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f� den angivet i henhold til feltet Avancepct.beregning p� det dertilh�rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisfaktoren, hvis du har aftalt med debitoren, at vedkommende skal betale for bestemte udgifter med kostv�rdien plus en procentv�rdi til d�kning af omkostninger.;
                           ENU=Specifies the unit cost factor, if you have agreed with your customer that he should pay certain expenses by cost value plus a certain percent, to cover your overhead expenses.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost Factor" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en linjerabatprocent, der g�lder for udgifter i relation til denne finanskonto. Det er nyttigt, f.eks. hvis fakturalinjer for sagen skal vise en rabatprocent.;
                           ENU=Specifies a line discount percent that applies to expenses related to this general ledger account. This is useful, for example if you want invoice lines for the job to show a discount percent.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Discount %" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af det finanskontonummer, du har angivet i feltet Finanskontonr.;
                           ENU=Specifies the description of the G/L Account No. you have entered in the G/L Account No. field.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

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

