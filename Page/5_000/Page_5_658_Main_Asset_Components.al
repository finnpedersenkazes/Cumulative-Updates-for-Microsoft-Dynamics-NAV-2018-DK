OBJECT Page 5658 Main Asset Components
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Hovedanl組;
               ENU=Main Asset Components];
    SourceTable=Table5640;
    DataCaptionFields=Main Asset No.;
    PageType=List;
    AutoSplitKey=No;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� hovedanl組get. Det er det anl組, som du kan konfigurere komponenter for.;
                           ENU=Specifies the number of the main asset. This is the asset for which components can be set up.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Main Asset No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver nummeret for det relaterede anl組. ";
                           ENU="Specifies the number of the related fixed asset. "];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af anl組get med det anl組snummer, du har angivet i feltet Anl組snr.;
                           ENU=Specifies the description linked to the fixed asset for the fixed asset number you entered in FA No. field.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

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

