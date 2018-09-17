OBJECT Page 558 Analysis View Entries
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
    CaptionML=[DAN=Analysevisningsposter;
               ENU=Analysis View Entries];
    SourceTable=Table365;
    PageType=List;
    OnNewRecord=BEGIN
                  IF "Analysis View Code" <> xRec."Analysis View Code" THEN;
                END;

    OnAfterGetCurrRecord=BEGIN
                           IF "Analysis View Code" <> xRec."Analysis View Code" THEN;
                         END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver analysevisningen.;
                           ENU=Specifies the analysis view.];
                ApplicationArea=#Suite;
                SourceExpr="Analysis View Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den koncernvirksomhedskode, som analysevisningen er baseret p†.;
                           ENU=Specifies the code for the business unit that the analysis view is based on.];
                ApplicationArea=#Suite;
                SourceExpr="Business Unit Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den konto, som analyseposten kommer fra.;
                           ENU=Specifies the account that the analysis entry comes from.];
                ApplicationArea=#Suite;
                SourceExpr="Account No." }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en konto, du kan bruge som et filter til at definere, hvad der vises i vinduet Dimensionsanalyse. ";
                           ENU="Specifies an account that you can use as a filter to define what is displayed in the Analysis by Dimensions window. "];
                ApplicationArea=#Suite;
                SourceExpr="Account Source" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nummer p† pengestr›msprognosen.;
                           ENU=Specifies a number for the cash flow forecast.];
                ApplicationArea=#Suite;
                SourceExpr="Cash Flow Forecast No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valgte dimensionsv‘rdi for den analysevisningsdimension, som du definerede som Dimension 1 p† analysevisningskortet.;
                           ENU=Specifies the dimension value you selected for the analysis view dimension that you defined as Dimension 1 on the analysis view card.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 1 Value Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valgte dimensionsv‘rdi for den analysevisningsdimension, som du definerede som Dimension 2 p† analysevisningskortet.;
                           ENU=Specifies the dimension value you selected for the analysis view dimension that you defined as Dimension 2 on the analysis view card.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 2 Value Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valgte dimensionsv‘rdi for den analysevisningsdimension, som du definerede som Dimension 3 p† analysevisningskortet.;
                           ENU=Specifies the dimension value you selected for the analysis view dimension that you defined as Dimension 3 on the analysis view card.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 3 Value Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valgte dimensionsv‘rdi for den analysevisningsdimension, som du definerede som Dimension 4 p† analysevisningskortet.;
                           ENU=Specifies the dimension value you selected for the analysis view dimension that you defined as Dimension 4 on the analysis view card.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 4 Value Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Suite;
                SourceExpr="Posting Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for analysevisningsbudgetposten.;
                           ENU=Specifies the amount of the analysis view budget entry.];
                ApplicationArea=#Suite;
                SourceExpr=Amount }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Suite;
                SourceExpr="Debit Amount" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Suite;
                SourceExpr="Credit Amount" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver (i den ekstra rapporteringsvaluta) den momsdifference, der opst†r, n†r du retter et momsbel›b p† et salgs- eller k›bsbilag.;
                           ENU=Specifies (in the additional reporting currency) the VAT difference that arises when you make a correction to a VAT amount on a sales or purchase document.];
                ApplicationArea=#Advanced;
                SourceExpr="Add.-Curr. Amount";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet af debetposten i den ekstra rapporteringsvaluta.;
                           ENU=Specifies, in the additional reporting currency, the amount of the debit entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Add.-Curr. Debit Amount";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ekstra rapporteringsvaluta, bel›bet af kreditposten.;
                           ENU=Specifies, in the additional reporting currency, the amount of the credit entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Add.-Curr. Credit Amount";
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

