OBJECT Page 5609 FA Journal Setup
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl‘gskladdeops‘tning;
               ENU=FA Journal Setup];
    SourceTable=Table5605;
    DataCaptionFields=Depreciation Book Code;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf›res til, hvis du har valgt Anl‘gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Book Code";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#FixedAssets;
                SourceExpr="User ID" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en anl‘gskladdetype.;
                           ENU=Specifies an FA journal template.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Jnl. Template Name" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det relevante anl‘gskladdenavn.;
                           ENU=Specifies the relevant FA journal batch name.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Jnl. Batch Name" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en finanskladdetype.;
                           ENU=Specifies a general journal template.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Gen. Jnl. Template Name" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det relevante finanskladdenavn.;
                           ENU=Specifies the relevant general journal batch name.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Gen. Jnl. Batch Name" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en forsikringskladdetype.;
                           ENU=Specifies an insurance journal template.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Insurance Jnl. Template Name" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det relevante forsikringskladdenavn.;
                           ENU=Specifies the relevant insurance journal batch name.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Insurance Jnl. Batch Name" }

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

