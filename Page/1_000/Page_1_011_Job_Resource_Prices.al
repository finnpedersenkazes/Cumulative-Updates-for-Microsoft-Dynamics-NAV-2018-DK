OBJECT Page 1011 Job Resource Prices
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagsressourcepriser;
               ENU=Job Resource Prices];
    SourceTable=Table1012;
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
                ToolTipML=[DAN=Angiv nummeret p† sagsopgaven, hvis ressourceprisen kun skal g‘lde for en bestemt sagsopgave.;
                           ENU=Specifies the number of the job task if the resource price should only apply to a specific job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den pris, du opretter for sagen, skal g‘lde for en ressource, en ressourcegruppe eller alle ressourcer og ressourcegrupper.;
                           ENU=Specifies whether the price that you are setting up for the job should apply to a resource, to a resource group, or to all resources and resource groups.];
                ApplicationArea=#Jobs;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ressource eller ressourcegruppe, som prisen vedr›rer. Nummeret skal svare til det, du valgte i feltet Type.;
                           ENU=Specifies the resource or resource group that this price applies to. The No. must correspond to your selection in the Type field.];
                ApplicationArea=#Jobs;
                SourceExpr=Code }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen udlignes med. Priserne opdateres ud fra denne post.;
                           ENU=Specifies which work type the resource applies to. Prices are updated based on this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Work Type Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for salgsprisens valuta, hvis den pris, du har angivet p† linjen, er i en udenlandsk valuta. V‘lg feltet for at se de tilg‘ngelige valutakoder.;
                           ENU=Specifies the code for the currency of the sales price if the price that you have set up in this line is in a foreign currency. Choose the field to see the available currency codes.];
                ApplicationArea=#Jobs;
                SourceExpr="Currency Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisfaktoren. Hvis du har aftalt med debitoren, at vedkommende skal betale for forbrug af en bestemt ressource med kostv‘rdien plus en bestemt procentv‘rdi til d‘kning af omkostninger, kan du angive en kostprisfaktor i dette felt.;
                           ENU=Specifies the unit cost factor. If you have agreed with you customer that he should pay for certain resource usage by cost value plus a certain percent value to cover your overhead expenses, you can set up a unit cost factor in this field.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost Factor" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en linjerabatprocent, der g‘lder for denne ressource eller ressourcegruppe. Det er nyttigt, f.eks. hvis fakturalinjer for sagen skal vise en rabatprocent.;
                           ENU=Specifies a line discount percent that applies to this resource, or resource group. This is useful, for example if you want invoice lines for the job to show a discount percent.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Discount %" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den ressource eller ressourcegruppe, du har angivet i feltet Kode.;
                           ENU=Specifies the description of the resource, or resource group, you have entered in the Code field.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal anvendes en rabat til sagen. Mark‚r dette felt, hvis rabatprocenten for ressourcen eller ressourcegruppen skal g‘lde for sagen - ogs† selvom rabatprocenten er nul.;
                           ENU=Specifies whether to apply a discount to the job. Select this field if the discount percent for this resource or resource group should apply to the job, even if the discount percent is zero.];
                ApplicationArea=#Jobs;
                SourceExpr="Apply Job Discount";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om prisen for ressourcen eller ressourcegruppen skal g‘lde for sagen - ogs† selvom prisen er nul.;
                           ENU=Specifies whether the price for this resource, or resource group, should apply to the job, even if the price is zero.];
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

