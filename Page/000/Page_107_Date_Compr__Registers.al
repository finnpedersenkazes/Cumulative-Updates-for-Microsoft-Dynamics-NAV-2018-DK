OBJECT Page 107 Date Compr. Registers
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
    CaptionML=[DAN=Datokompr.journaler;
               ENU=Date Compr. Registers];
    SourceTable=Table87;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor komprimeringen blev foretaget.;
                           ENU=Specifies the date that the date compression took place.];
                ApplicationArea=#Suite;
                SourceExpr="Creation Date" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tabel, der blev komprimeret.;
                           ENU=Specifies the number of the table that was compressed.];
                ApplicationArea=#Suite;
                SourceExpr="Table ID";
                LookupPageID=Objects }

    { 29  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den tabel, der blev komprimeret.;
                           ENU=Specifies the name of the table that was compressed.];
                ApplicationArea=#Suite;
                SourceExpr="Table Caption";
                DrillDownPageID=Objects }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for den periode, der blev komprimeret poster fra.;
                           ENU=Specifies the first date in the period for which entries were compressed.];
                ApplicationArea=#Suite;
                SourceExpr="Starting Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for den periode, der blev komprimeret poster fra.;
                           ENU=Specifies the last date in the period for which entries were compressed.];
                ApplicationArea=#Suite;
                SourceExpr="Ending Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den journal, der blev oprettet i forbindelse med datokomprimeringen, og som indeholder de komprimerede poster.;
                           ENU=Specifies the number of the register that was created by the date compression and that contains the compressed entries.];
                ApplicationArea=#Suite;
                SourceExpr="Register No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange nye poster der er blevet oprettet ved datokomprimeringen.;
                           ENU=Specifies the number of new entries that were created by the date compression.];
                ApplicationArea=#Suite;
                SourceExpr="No. of New Records" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange poster der blev slettet i forbindelse med datokomprimeringen.;
                           ENU=Specifies the number of entries that were deleted during the date compression.];
                ApplicationArea=#Suite;
                SourceExpr="No. Records Deleted" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke filtre der er brugt ved datokomprimeringen.;
                           ENU=Specifies the filters that were placed on the date compression.];
                ApplicationArea=#Suite;
                SourceExpr=Filter }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tidsinterval, hvor posterne blev komprimeret i ‚n post i k›rslen, s†dan som det er defineret i felterne Startdato og Slutdato.;
                           ENU=Specifies the time interval of entries combined into one for the period defined in the Starting Date and Ending Date fields in the batch job.];
                ApplicationArea=#Suite;
                SourceExpr="Period Length" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en liste over de felter, hvis indhold brugeren valgte at bevare ved datokomprimeringen.;
                           ENU=Specifies a list of the fields whose contents the user chose to retain in the date compression.];
                ApplicationArea=#Suite;
                SourceExpr="Retain Field Contents" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en liste over de antalsfelter, som brugeren valgte at bevare ved datokomprimeringen.;
                           ENU=Specifies a list of the quantity fields that the user chose to retain when they ran the date compression batch job.];
                ApplicationArea=#Suite;
                SourceExpr="Retain Totals" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
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

