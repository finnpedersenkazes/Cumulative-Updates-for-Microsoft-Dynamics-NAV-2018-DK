OBJECT Page 1009 Job WIP G/L Entries
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
    CaptionML=[DAN=VIA-finansposter for sag;
               ENU=Job WIP G/L Entries];
    SourceTable=Table1005;
    DataCaptionFields=Job No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 52      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 9       ;2   ;Action    ;
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
      { 53      ;2   ;Action    ;
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
      { 19      ;2   ;Action    ;
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 37      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
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

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten skal tilbagef›res. Hvis afkrydsningsfeltet er markeret, tilbagef›res posten fra finansregnskabet.;
                           ENU=Specifies whether the entry has been reversed. If the check box is selected, the entry has been reversed from the G/L.];
                ApplicationArea=#Jobs;
                SourceExpr=Reversed }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringsdato, du har angivet i feltet Bogf›ringsdato i oversigtspanelet Indstillinger under k›rslen Bogf›r VIA - finansafstemning.;
                           ENU=Specifies the posting date you entered in the Posting Date field, on the Options FastTab, in the Job Post WIP to G/L batch job.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Date" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringsdato, du har angivet i feltet Bogf›ringsdato i oversigtspanelet Indstillinger under k›rslen Beregn VIA - finansafstemning.;
                           ENU=Specifies the posting date you entered in the Posting Date field, on the Options FastTab, in the Job Calculate WIP batch job.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Posting Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bilagsnummer, du har angivet i feltet Bilagsnr. i oversigtspanelet Indstillinger under k›rslen Bogf›r VIA - finansafstemning.;
                           ENU=Specifies the document number you entered in the Document No. field on the Options FastTab in the Job Post WIP to G/L batch job.];
                ApplicationArea=#Jobs;
                SourceExpr="Document No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No." }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en sag er fuldf›rt. Dette afkrydsningsfelt er markeret, hvis VIA-sagens finanspost blev oprettet for en sag med statussen Afsluttet.;
                           ENU=Specifies whether a job is complete. This check box is selected if the Job WIP G/L Entry was created for a Job with a Completed status.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Complete" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret fra den tilknyttede total for sagens igangv‘rende arbejde.;
                           ENU=Specifies the entry number from the associated job WIP total.];
                ApplicationArea=#Jobs;
                SourceExpr="Job WIP Total Entry No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskontonummer, hvor VIA bogf›res for denne post.;
                           ENU=Specifies the general ledger account number to which the WIP, on this entry, is posted.];
                ApplicationArea=#Jobs;
                SourceExpr="G/L Account No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finansmodkontonummer, hvor VIA for posten blev bogf›rt.;
                           ENU=Specifies the general ledger balancing account number that WIP on this entry was posted to.];
                ApplicationArea=#Jobs;
                SourceExpr="G/L Bal. Account No." }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tilbagef›rselsdatoen. Hvis VIA for denne post tilbagef›res, kan du se datoen for tilbagef›rslen i feltet Tilbagef›r dato.;
                           ENU=Specifies the reverse date. If the WIP on this entry is reversed, you can see the date of the reversal in the Reverse Date field.];
                ApplicationArea=#Jobs;
                SourceExpr="Reverse Date" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den VIA-metode, der blev angivet for sagen under k›rslen af Beregn VIA - finansafstemning.;
                           ENU=Specifies the WIP method that was specified for the job when you ran the Job Calculate WIP batch job.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Method Used" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den VIA-bogf›ringsmetode, der blev anvendt i forbindelse med finansregnskabet. Oplysningerne i dette felt hentes fra den indstilling, du har angivet p† jobkortet.;
                           ENU=Specifies the WIP posting method used in the context of the general ledger. The information in this field comes from the setting you have specified on the job card.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Posting Method Used" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver VIA-typen for posten.;
                           ENU=Specifies the WIP type for this entry.];
                ApplicationArea=#Jobs;
                SourceExpr=Type }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det VIA-bel›b, der blev bogf›rt i finansregnskabet for denne post.;
                           ENU=Specifies the WIP amount that was posted in the general ledger for this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Entry Amount" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringsgruppe, der vedr›rer posten.;
                           ENU=Specifies the posting group related to this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Posting Group" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det transaktionsnummer, der tildeles alle poster, der er omfattet af transaktionen.;
                           ENU=Specifies the transaction number assigned to all the entries involved in the same transaction.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Transaction No." }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er indg†et i en tilbagef›ringstransaktion (rettelse) foretaget med funktionen Tilbagef›r.;
                           ENU=Specifies whether the entry has been part of a reverse transaction (correction) made by the reverse function.];
                ApplicationArea=#Jobs;
                SourceExpr=Reverse }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Jobs;
                SourceExpr="Global Dimension 1 Code" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Jobs;
                SourceExpr="Global Dimension 2 Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finansl›benummer, som posten er tilknyttet.;
                           ENU=Specifies the G/L Entry No. to which this entry is linked.];
                ApplicationArea=#Jobs;
                SourceExpr="G/L Entry No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Entry No." }

    { 17  ;2   ;Field     ;
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
      Navigate@1000 : Page 344;
      DimensionSetIDFilter@1001 : Page 481;

    BEGIN
    END.
  }
}

