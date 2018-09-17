OBJECT Page 7325 Warehouse Registers
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
    CaptionML=[DAN=Lagerjournaler;
               ENU=Warehouse Registers];
    SourceTable=Table7313;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Journal;
                                 ENU=&Register];
                      Image=Register }
      { 20      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Lagerposter;
                                 ENU=&Warehouse Entries];
                      ToolTipML=[DAN="F† vist historikken over antal, der er registreret for varen under lageraktiviteter. ";
                                 ENU="View the history of quantities that are registered for the item in warehouse activities. "];
                      ApplicationArea=#Warehouse;
                      Image=BinLedger;
                      OnAction=VAR
                                 WhseEntry@1000 : Record 7312;
                               BEGIN
                                 WhseEntry.SETRANGE("Entry No.","From Entry No.","To Entry No.");
                                 PAGE.RUN(PAGE::"Warehouse Entries",WhseEntry);
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste varepostnummer i journalen.;
                           ENU=Specifies the first item entry number in the register.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Entry No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste lagerpostnummer i journalen.;
                           ENU=Specifies the last warehouse entry number in the register.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Entry No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor posterne i journalen blev bogf›rt.;
                           ENU=Specifies the date on which the entries in the register were posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Creation Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Warehouse;
                SourceExpr="User ID" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som posterne blev bogf›rt fra.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Journal Batch Name" }

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

