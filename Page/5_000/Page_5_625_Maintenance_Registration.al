OBJECT Page 5625 Maintenance Registration
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Reparationsregistrering;
               ENU=Maintenance Registration];
    SourceTable=Table5616;
    DataCaptionFields=FA No.;
    PageType=List;
    AutoSplitKey=Yes;
    OnInsertRecord=VAR
                     FixedAsset@1000 : Record 5600;
                   BEGIN
                     FixedAsset.GET("FA No.");
                     "Maintenance Vendor No." := FixedAsset."Maintenance Vendor No.";
                   END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver nummeret for det relaterede anl�g. ";
                           ENU="Specifies the number of the related fixed asset. "];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA No.";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor anl�gget blev repareret.;
                           ENU=Specifies the date when the fixed asset is being serviced.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Service Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kreditor, der reparerede anl�gget for denne post.;
                           ENU=Specifies the number of the vendor who services the fixed asset for this entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Maintenance Vendor No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en bem�rkning om service, reparationer eller vedligeholdelse, der skal foretages p� anl�gget.;
                           ENU=Specifies a comment for the service, repairs or maintenance to be performed on the fixed asset.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den reparat�r, som vedligeholder anl�gget.;
                           ENU=Specifies the name of the service agent who is servicing the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Service Agent Name" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telefonnummeret p� den reparat�r, som vedligeholder anl�gget.;
                           ENU=Specifies the phone number of the service agent who is servicing the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Service Agent Phone No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver mobiltelefonnummeret p� den reparat�r, som vedligeholder anl�gget.;
                           ENU=Specifies the mobile phone number of the service agent who is servicing the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Service Agent Mobile Phone";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

