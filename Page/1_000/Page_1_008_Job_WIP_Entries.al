OBJECT Page 1008 Job WIP Entries
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
    CaptionML=[DAN=VIA-poster for sag;
               ENU=Job WIP Entries];
    SourceTable=Table1004;
    DataCaptionFields=Job No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 57      ;2   ;Action    ;
                      Name=<Action57>;
                      CaptionML=[DAN=VIA-totaler;
                                 ENU=WIP Totals];
                      ToolTipML=[DAN=Vis sagens totaler for igangv‘rende arbejde.;
                                 ENU=View the job's WIP totals.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1028;
                      RunPageLink=Entry No.=FIELD(Job WIP Total Entry No.);
                      Promoted=Yes;
                      Image=EntriesList;
                      PromotedCategory=Process }
      { 50      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Jobs;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 102     ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr‘ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Jobs;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
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

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringsdato, du har angivet i feltet Bogf›ringsdato i oversigtspanelet Indstillinger i k›rslen Beregn VIA - finansafstemning.;
                           ENU=Specifies the posting date you entered in the Posting Date field on the Options FastTab in the Job Calculate WIP batch job.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Posting Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bilagsnummer, du har angivet i feltet Bilagsnr. i oversigtspanelet Indstillinger i k›rslen Beregn VIA - finansafstemning.;
                           ENU=Specifies the document number you entered in the Document No. field on the Options FastTab in the Job Calculate WIP batch job.];
                ApplicationArea=#Jobs;
                SourceExpr="Document No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvis VIA-sagsposten blev oprettet for en sag med statussen Afsluttet.;
                           ENU=Specifies whether the Job WIP Entry was created for a job with a Completed status.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Complete" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for igangv‘rende arbejde i alt.;
                           ENU=Specifies the entry number of the WIP total.];
                ApplicationArea=#Jobs;
                SourceExpr="Job WIP Total Entry No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskontonummer, hvor VIA i denne post bogf›res, hvis du udf›rer k›rslen Bogf›r VIA - finansafstemning.;
                           ENU=Specifies the general ledger account number to which the WIP on this entry will be posted, if you run the Job Post WIP to the general ledger batch job.];
                ApplicationArea=#Jobs;
                SourceExpr="G/L Account No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finansmodkontonummer, hvor VIA i denne post bogf›res, hvis du udf›rer k›rslen Bogf›r VIA - finansafstemning.;
                           ENU=Specifies the general ledger balancing account number that WIP on this entry will be posted to, if you run the Job Post WIP to general ledger batch job.];
                ApplicationArea=#Jobs;
                SourceExpr="G/L Bal. Account No." }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den VIA-metode, der blev angivet for sagen under k›rslen af Beregn VIA - finansafstemning.;
                           ENU=Specifies the WIP method that was specified for the job when you ran the Job Calculate WIP batch job.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Method Used" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den anvendte VIA-bogf›ringsmetode. Oplysningerne i dette felt hentes fra den indstilling, du har angivet p† jobkortet.;
                           ENU=Specifies the WIP posting method used. The information in this field comes from the setting you have specified on the job card.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Posting Method Used" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver VIA-typen for posten.;
                           ENU=Specifies the WIP type for this entry.];
                ApplicationArea=#Jobs;
                SourceExpr=Type }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det VIA-bel›b, der bogf›res for posten, hvis du udf›rer k›rslen Bogf›r VIA - finansafstemning.;
                           ENU=Specifies the WIP amount that will be posted for this entry, if you run the Job Post WIP to G/L batch job.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Entry Amount" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringsgruppe, der vedr›rer posten.;
                           ENU=Specifies the posting group related to this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Posting Group" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er indg†et i en tilbagef›ringstransaktion (rettelse) foretaget med funktionen Tilbagef›r.;
                           ENU=Specifies whether the entry has been part of a reverse transaction (correction) made by the reverse function.];
                ApplicationArea=#Jobs;
                SourceExpr=Reverse }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Jobs;
                SourceExpr="Global Dimension 1 Code" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Jobs;
                SourceExpr="Global Dimension 2 Code" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Entry No." }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv‘rdier. De faktiske v‘rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Jobs;
                SourceExpr="Dimension Set ID";
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
    VAR
      DimensionSetIDFilter@1000 : Page 481;

    BEGIN
    END.
  }
}

