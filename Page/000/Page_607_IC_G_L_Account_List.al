OBJECT Page 607 IC G/L Account List
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
    CaptionML=[DAN=Koncernintern finanskontoliste;
               ENU=Intercompany G/L Account List];
    SourceTable=Table410;
    PageType=List;
    CardPageID=IC G/L Account Card;
    OnInit=BEGIN
             CurrPage.LOOKUPMODE := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       FormatLine;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Intercompany;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=Emphasize }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den koncerninterne finanskonto.;
                           ENU=Specifies the name of the IC general ledger account.];
                ApplicationArea=#Intercompany;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en finanskonto er en resultatopg�relseskonto eller en balancekonto.;
                           ENU=Specifies whether a general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Intercompany;
                SourceExpr="Income/Balance" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form�let med kontoen. I alt: Bruges til at samment�lle en r�kke saldi p� konti fra mange forskellige grupper. Lad feltet st� tomt, hvis du vil bruge I alt. Fra-Sum: En markering af begyndelsen af en r�kke konti, der skal samment�lles og slutter med en Til-sum-konto. Til-sum: Det samlede antal konti, der starter med den foreg�ende Fra-sum-konto. Det samlede antal er defineret i feltet Samment�lling.;
                           ENU=Specifies the purpose of the account. Total: Used to total a series of balances on accounts from many different account groupings. To use Total, leave this field blank. Begin-Total: A marker for the beginning of a series of accounts to be totaled that ends with an End-Total account. End-Total: A total of a series of accounts that starts with the preceding Begin-Total account. The total is defined in the Totaling field.];
                ApplicationArea=#Intercompany;
                SourceExpr="Account Type" }

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
      Emphasize@19018670 : Boolean INDATASET;
      NameIndent@19079073 : Integer INDATASET;

    LOCAL PROCEDURE FormatLine@19039177();
    BEGIN
      NameIndent := Indentation;
      Emphasize := "Account Type" <> "Account Type"::Posting;
    END;

    BEGIN
    END.
  }
}

