OBJECT Page 445 Finance Charge Text
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rentenotatekst;
               ENU=Finance Charge Text];
    SaveValues=Yes;
    MultipleNewLines=Yes;
    SourceTable=Table301;
    DelayedInsert=Yes;
    DataCaptionFields=Fin. Charge Terms Code,Position;
    PageType=List;
    AutoSplitKey=Yes;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for de involverede renter i tilf‘lde af sen betaling.;
                           ENU=Specifies the code for the involved finance charges in case of late payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fin. Charge Terms Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten kommer til at st† i begyndelsen eller i slutningen af rentenotaen.;
                           ENU=Specifies whether the text will appear at the beginning or the end of the finance charge memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Position;
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tekst, som du vil inds‘tte i rentenotaen.;
                           ENU=Specifies the text that you want to insert in the finance charge memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Text }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                ApplicationArea=#Basic,#Suite;
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

