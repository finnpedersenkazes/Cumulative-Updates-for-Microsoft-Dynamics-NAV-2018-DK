OBJECT Page 523 Item Application Entry History
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
    CaptionML=[DAN=Historik for vareudligning;
               ENU=Item Application Entry History];
    LinksAllowed=No;
    SourceTable=Table343;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et entydigt id-nummer for hver historisk vareudligningspost.;
                           ENU=Specifies a unique identifying number for each item application entry history record.];
                ApplicationArea=#Advanced;
                SourceExpr="Primary Entry No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den varepost, som vareudligningsposten blev registreret for.;
                           ENU=Specifies the entry number of the item ledger entry, for which the item application entry was recorded.];
                ApplicationArea=#Advanced;
                SourceExpr="Item Ledger Entry No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den varepost, der svarer til lagerfor›gelsen eller det positive antal p† lageret for denne post.;
                           ENU=Specifies the number of the item ledger entry corresponding to the inventory increase or positive quantity in inventory for this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Inbound Item Entry No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den varepost, der svarer til lagerreduktionen for posten.;
                           ENU=Specifies the number of the item ledger entry corresponding to the inventory decrease for this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Outbound Item Entry No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det vareantal, som lagerreduktionen udlignes med, i feltet Udg†ende varepostl›benr. til lagerfor›gelsen i feltet Indg†ende varepostl›benr.;
                           ENU=Specifies the item quantity being applied from the inventory decrease in the Outbound Item Entry No. field, to the inventory increase in the Inbound Item Entry No. field.];
                ApplicationArea=#Advanced;
                SourceExpr=Quantity }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en dato, der svarer til bogf›ringsdatoen for den varepost, som vareudligningsposten blev oprettet for.;
                           ENU=Specifies a date that corresponds to the posting date of the item ledger entry, for which this item application entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varepostnummeret for lagerfor›gelsen, hvis en vareudligningspost stammer fra en overflytning mellem varelokationer.;
                           ENU=Specifies the item ledger entry number of the inventory increase, if an item application entry originates from an item location transfer.];
                ApplicationArea=#Advanced;
                SourceExpr="Transferred-from Entry No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke udligningsposter der skal have kostprisen videresendt eller blot inkluderet i en gennemsnitlig beregning.;
                           ENU=Specifies which application entries should have the cost forwarded, or simply included, in an average cost calculation.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Application" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at de udg†ende vareposter er fuldt fakturerede.;
                           ENU=Specifies the outbound item entries have been completely invoiced.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Output Completely Invd. Date" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

