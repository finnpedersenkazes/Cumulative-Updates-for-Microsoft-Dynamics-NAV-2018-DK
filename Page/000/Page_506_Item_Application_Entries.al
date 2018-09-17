OBJECT Page 506 Item Application Entries
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
    CaptionML=[DAN=Vareudligningsposter;
               ENU=Item Application Entries];
    SourceTable=Table339;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringsdato, der svarer til bogf›ringsdatoen for den varepost, som vareudligningsposten blev oprettet for.;
                           ENU=Specifies the posting date that corresponds to the posting date of the item ledger entry, for which this item application entry was created.];
                ApplicationArea=#Suite;
                SourceExpr="Posting Date" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en eller flere vareudligningsposter for hver lagertransaktion, der bogf›res.;
                           ENU=Specifies one or more item application entries for each inventory transaction that is posted.];
                ApplicationArea=#Suite;
                SourceExpr="Item Ledger Entry No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den varepost, der svarer til lagerfor›gelsen eller det positive lagerantal p† lageret.;
                           ENU=Specifies the number of the item ledger entry corresponding to the inventory increase or positive quantity in inventory.];
                ApplicationArea=#Suite;
                SourceExpr="Inbound Item Entry No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den varepost, der svarer til lagerreduktionen for posten.;
                           ENU=Specifies the number of the item ledger entry corresponding to the inventory decrease for this entry.];
                ApplicationArea=#Suite;
                SourceExpr="Outbound Item Entry No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, som lagerreduktionen udlignes med, i feltet Udg†ende varepostl›benr. til lagerfor›gelsen i feltet Indg†ende varepostl›benr.;
                           ENU=Specifies the quantity of the item that is being applied from the inventory decrease in the Outbound Item Entry No. field, to the inventory increase in the Inbound Item Entry No. field.];
                ApplicationArea=#Suite;
                SourceExpr=Quantity }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Suite;
                SourceExpr="Entry No." }

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

