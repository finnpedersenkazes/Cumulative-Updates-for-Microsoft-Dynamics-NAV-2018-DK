OBJECT Page 1012 Job Item Prices
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagsvarepriser;
               ENU=Job Item Prices];
    SourceTable=Table1013;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiv nummeret p† sagsopgaven, hvis vareprisen kun skal g‘lde for en bestemt sagsopgave.;
                           ENU=Specifies the number of the job task if the item price should only apply to a specific job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den vare, som denne pris g‘lder for. V‘lg feltet for at se de tilg‘ngelige varer.;
                           ENU=Specifies the item that this price applies to. Choose the field to see the available items.];
                ApplicationArea=#Jobs;
                SourceExpr="Item No." }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver variantkoden, hvis den pris, du angiver, skal g‘lde for en bestemt variant af varen.;
                           ENU=Specifies the variant code if the price that you are setting up should apply to a specific variant of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit of Measure Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den standardvalutakode, der er defineret for en sag. Sagsvarepriser anvendes kun, hvis valutakoden for sagsvaren er den samme som den valutakode, der er angivet for sagen.;
                           ENU=Specifies the default currency code that is defined for a job. Job item prices will only be used if the currency code for the job item is the same as the currency code set for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Currency Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisfaktoren, hvis du har aftalt med debitoren, at vedkommende skal betale for forbrug af en bestemt vare med kostv‘rdien plus en procentv‘rdi til d‘kning af omkostninger.;
                           ENU=Specifies the unit cost factor, if you have agreed with your customer that he should pay certain item usage by cost value plus a certain percent value to cover your overhead expenses.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost Factor" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en jobspecifik linjerabatprocent, der g‘lder for denne linje. Det er nyttigt, f.eks. hvis fakturalinjer for sagen skal vise en rabatprocent.;
                           ENU=Specifies a job-specific line discount percent that applies to this line. This is useful, for example, if you want invoice lines for the job to show a discount percent.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Discount %" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den vare, du har angivet i feltet Varenr.;
                           ENU=Specifies the description of the item you have entered in the Item No. field.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afkrydsningsfeltet for dette felt, hvis den jobspecifikke rabatprocent for denne vare skal g‘lde for sagen. Standardlinjerabatten for den definerede linje inkluderes, n†r sagsposter oprettes, men du kan ‘ndre denne v‘rdi.;
                           ENU=Specifies the check box for this field if the job-specific discount percent for this item should apply to the job. The default line discount for the line that is defined is included when job entries are created, but you can modify this value.];
                ApplicationArea=#Jobs;
                SourceExpr="Apply Job Discount";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den jobspecifikke pris eller kostprisfaktor for denne vare skal g‘lde for sagen. Standardsagsrabatten for den definerede linje inkluderes, n†r sagsrelaterede poster oprettes, men du kan ‘ndre denne v‘rdi.;
                           ENU=Specifies whether the job-specific price or unit cost factor for this item should apply to the job. The default job price that is defined is included when job-related entries are created, but you can modify this value.];
                ApplicationArea=#Jobs;
                SourceExpr="Apply Job Price";
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

