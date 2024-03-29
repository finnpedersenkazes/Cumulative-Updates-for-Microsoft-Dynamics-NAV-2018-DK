OBJECT Page 5631 FA Journal Template List
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
    CaptionML=[DAN=Anl�gskld.typeover.;
               ENU=FA Journal Template List];
    SourceTable=Table5619;
    PageType=List;
    RefreshOnActivate=Yes;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kladdetype, du er ved at oprette.;
                           ENU=Specifies the name of the journal template you are creating.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kladdetype, du vil oprette.;
                           ENU=Specifies the journal template you are creating.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kladdetypen skal v�re a gentagelseskladde.;
                           ENU=Specifies whether the journal template will be a recurring journal.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Recurring;
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �rsagskoden som et supplerende kildespor, der hj�lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Page ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rapport, der udskrives, hvis du v�lger at udskrive en kontrolrapport fra en kladdek�rsel.;
                           ENU=Specifies the report that will be printed if you choose to print a test report from a journal batch.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Test Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rapport, der udskrives, n�r du klikker p� Bogf�r og udskriv fra en kladde.;
                           ENU=Specifies the report that is printed when you click Post and Print from a journal batch.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Posting Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en rapport udskrives automatisk ved bogf�ring.;
                           ENU=Specifies whether a report is printed automatically when you post.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Force Posting Report";
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

