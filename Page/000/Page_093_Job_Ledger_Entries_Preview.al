OBJECT Page 93 Job Ledger Entries Preview
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
    CaptionML=[DAN=Vis sagsposter;
               ENU=Job Ledger Entries Preview];
    SourceTable=Table169;
    DataCaptionFields=Job No.;
    PageType=List;
    OnOpenPage=BEGIN
                 IF ActiveField = 1 THEN;
                 IF ActiveField = 2 THEN;
                 IF ActiveField = 3 THEN;
                 IF ActiveField = 4 THEN;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 71      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 72      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Jobs;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 xRec.ShowDimensions;
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr‘ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Suite;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=<Action28>;
                      CaptionML=[DAN=Vis tilknyttede sagsplanl‘gningslinjer;
                                 ENU=Show Linked Job Planning Lines];
                      ToolTipML=[DAN=Vi de planl‘gningslinjer, der er tilknyttet sagskladdeposter, der er bogf›rt til sagsposten. Dette kr‘ver, at afkrydsningsfeltet Anvend anvendelseslink er markeret for sagen, eller er standardindstillingen for alle sager i din organisation.;
                                 ENU=View the planning lines that are associated with job journal entries that have been posted to the job ledger. This requires that the Apply Usage Link check box has been selected for the job, or is the default setting for all jobs in your organization.];
                      ApplicationArea=#Jobs;
                      Image=JobLines;
                      OnAction=VAR
                                 JobUsageLink@1000 : Record 1020;
                                 JobPlanningLine@1001 : Record 1003;
                               BEGIN
                                 JobUsageLink.SETRANGE("Entry No.","Entry No.");

                                 IF JobUsageLink.FINDSET THEN
                                   REPEAT
                                     JobPlanningLine.GET(JobUsageLink."Job No.",JobUsageLink."Job Task No.",JobUsageLink."Line No.");
                                     JobPlanningLine.MARK := TRUE;
                                   UNTIL JobUsageLink.NEXT = 0;

                                 JobPlanningLine.MARKEDONLY(TRUE);
                                 PAGE.RUN(PAGE::"Job Planning Lines",JobPlanningLine);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver posttypen. Der findes to posttyper:;
                           ENU=Specifies the type of the entry. There are two types of entries:];
                ApplicationArea=#Jobs;
                SourceExpr="Entry Type";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† sagsposten.;
                           ENU=Specifies the document number on the job ledger entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Document No.";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† sagen.;
                           ENU=Specifies the number of the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                Editable=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som sagsposten bogf›res p†.;
                           ENU=Specifies the type of account to which the job ledger entry is posted.];
                ApplicationArea=#Jobs;
                SourceExpr=Type }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Jobs;
                SourceExpr="No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af sagsposten.;
                           ENU=Specifies the description of the job ledger entry.];
                ApplicationArea=#Jobs;
                SourceExpr=Description;
                Editable=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den sagsbogf›ringsgruppe, der blev anvendt, da posten blev bogf›rt.;
                           ENU=Specifies the code for the Job posting group that was used when the entry was posted.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Posting Group";
                Visible=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante lokationskode, hvis en vare er blevet bogf›rt.;
                           ENU=Specifies the relevant location code if an item is posted.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Editable=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen udlignes med. Priserne opdateres ud fra denne post.;
                           ENU=Specifies which work type the resource applies to. Prices are updated based on this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Work Type Code" }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit of Measure Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er bogf›rt p† posten.;
                           ENU=Specifies the quantity that was posted on the entry.];
                ApplicationArea=#Jobs;
                SourceExpr=Quantity }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen i den lokale valuta for en enhed af den vare eller ressource, der er valgt.;
                           ENU=Specifies the cost, in the local currency, of one unit of the selected item or resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Direct Unit Cost (LCY)";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost";
                Editable=FALSE }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost (LCY)" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver totalomkostninger for den bogf›rte post. Bel›bet er i den valuta, der er angivet for sagen.;
                           ENU=Specifies the total cost for the posted entry, in the currency specified for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Cost";
                Editable=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kostbel›bet i lokal valuta i den bogf›rte post. Hvis du opdaterer sagspostomkostningerne for kostreguleringer af vareposter, bliver feltet automatisk ‘ndret til at omfatter vareprisreguleringer.;
                           ENU=Specifies the total cost of the posted entry in local currency. If you update the job ledger costs for item ledger cost adjustments, this field will be adjusted to include the item cost adjustments.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Cost (LCY)" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price" }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen i RV. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price, in LCY, of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price (LCY)";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘rdien af produkter i posten.;
                           ENU=Specifies the value of products on the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Amount" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatbel›bet for den bogf›rte post i den valuta, der er angivet for sagen.;
                           ENU=Specifies the line discount amount for the posted entry, in the currency specified for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Discount Amount" }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatprocenten for den bogf›rte post.;
                           ENU=Specifies the line discount percent of the posted entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Discount %" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsbel›bet for den bogf›rte post i den valuta, der er angivet for sagen.;
                           ENU=Specifies the total price for the posted entry, in the currency specified for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Price";
                Visible=FALSE;
                Editable=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede pris (i lokal valuta) for den bogf›rte post.;
                           ENU=Specifies the total price (in local currency) of the posted entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Price (LCY)";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘rdien i den lokale valuta for produkterne i posten.;
                           ENU=Specifies the value in the local currency of products on the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Amount (LCY)";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som vil blive bogf›rt i finansregnskabet.;
                           ENU=Specifies the amount that will be posted to the general ledger.];
                ApplicationArea=#Jobs;
                SourceExpr="Amt. to Post to G/L";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som er blevet bogf›rt i finansregnskabet.;
                           ENU=Specifies the amount that has been posted to the general ledger.];
                ApplicationArea=#Jobs;
                SourceExpr="Amt. Posted to G/L";
                Visible=FALSE }

    { 1008;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for den bogf›rte post p† bogf›ringstidspunktet i den valuta, der er angivet for sagen. Bel›bet omfatter ikke vareprisreguleringer.;
                           ENU=Specifies the unit cost for the posted entry at the time of posting, in the currency specified for the job. No item cost adjustments are included.];
                ApplicationArea=#Jobs;
                SourceExpr="Original Unit Cost";
                Visible=FALSE }

    { 1004;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for den bogf›rte post i den lokale valuta p† det tidspunkt, hvor posten blev bogf›rt. Bel›bet omfatter ikke vareprisreguleringer.;
                           ENU=Specifies the unit cost of the posted entry in local currency at the time the entry was posted. It does not include any item cost adjustments.];
                ApplicationArea=#Jobs;
                SourceExpr="Original Unit Cost (LCY)";
                Visible=FALSE }

    { 1010;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel›bet for den bogf›rte post p† bogf›ringstidspunktet i den valuta, der er angivet for sagen. Bel›bet omfatter ikke vareprisreguleringer.;
                           ENU=Specifies the total cost for the posted entry at the time of posting, in the currency specified for the job. No item cost adjustments are included.];
                ApplicationArea=#Jobs;
                SourceExpr="Original Total Cost";
                Visible=FALSE }

    { 1006;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel›bet for den bogf›rte post i den lokale valuta p† det tidspunkt, hvor posten blev bogf›rt. Bel›bet omfatter ikke vareprisreguleringer.;
                           ENU=Specifies the total cost of the posted entry in local currency at the time the entry was posted. It does not include any item cost adjustments.];
                ApplicationArea=#Jobs;
                SourceExpr="Original Total Cost (LCY)";
                Visible=FALSE }

    { 1012;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel›bet for den bogf›rte post i den ekstra rapporteringsvaluta p† bogf›ringstidspunktet. Bel›bet omfatter ikke vareprisreguleringer.;
                           ENU=Specifies the total cost of the posted entry in the additional reporting currency at the time of posting. No item cost adjustments are included.];
                ApplicationArea=#Jobs;
                SourceExpr="Original Total Cost (ACY)";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Jobs;
                SourceExpr="User ID";
                Visible=FALSE;
                Editable=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Source Code";
                Visible=FALSE;
                Editable=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Reason Code";
                Visible=FALSE;
                Editable=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret, hvis sagsposten angiver et vareforbrug, der blev bogf›rt med serienummersporing.;
                           ENU=Specifies the serial number if the job ledger entry Specifies an item usage that was posted with serial number tracking.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lotnummeret, hvis sagsposten angiver et vareforbrug, der blev bogf›rt med lotnummersporing.;
                           ENU=Specifies the lot number if the job ledger entry Specifies an item usage that was posted with lot number tracking.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE;
                Editable=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den posttype, som sagsposten er tilknyttet.;
                           ENU=Specifies the entry type that the job ledger entry is linked to.];
                ApplicationArea=#Jobs;
                SourceExpr="Ledger Entry Type" }

    { 1000;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en sagspost er blevet ‘ndret eller reguleret. V‘rdien i dette felt inds‘ttes af k›rslen Juster kostpris - vareposter. Afkrydsningsfeltet Reguleret er markeret, hvis det er relevant.;
                           ENU=Specifies whether a job ledger entry has been modified or adjusted. The value in this field is inserted by the Adjust Cost - Item Entries batch job. The Adjusted check box is selected if applicable.];
                ApplicationArea=#Jobs;
                SourceExpr=Adjusted }

    { 1002;2   ;Field     ;
                ToolTipML=[DAN=Angiver tidsstemplet for regulering eller modifikation af en sagspost.;
                           ENU=Specifies the time stamp of a job ledger entry adjustment or modification.];
                ApplicationArea=#Jobs;
                SourceExpr="DateTime Adjusted" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv‘rdier. De faktiske v‘rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Jobs;
                SourceExpr="Dimension Set ID";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      DimensionSetIDFilter@1000 : Page 481;
      ActiveField@1007 : ' ,Cost,CostLCY,PriceLCY,Price';

    [External]
    PROCEDURE SetActiveField@3(ActiveField2@1000 : Integer);
    BEGIN
      ActiveField := ActiveField2;
    END;

    BEGIN
    END.
  }
}

