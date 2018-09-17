OBJECT Page 9125 Item Application FactBox
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
    CaptionML=[DAN=Faktaboks for vareudligning;
               ENU=Item Application FactBox];
    SourceTable=Table32;
    PageType=CardPart;
    OnFindRecord=BEGIN
                   Available := 0;
                   Applied := 0;
                   CLEAR(Item);

                   EXIT(FIND(Which));
                 END;

    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Reserved Quantity");
                       Available := Quantity - "Reserved Quantity";
                       Applied := ItemApplnEntry.OutboundApplied("Entry No.",FALSE) - ItemApplnEntry.InboundApplied("Entry No.",FALSE);

                       IF NOT Item.GET("Item No.") THEN
                         Item.RESET;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 9   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No." }

    { 11  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† varen i posten.;
                           ENU=Specifies the number of the item in the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No." }

    { 3   ;1   ;Field     ;
                CaptionML=[DAN=Kostprisberegningsmetode;
                           ENU=Costing Method];
                ToolTipML=[DAN=Angiver, hvilken kostmetode der g‘lder for varenummeret.;
                           ENU=Specifies which costing method applies to the item number.];
                ApplicationArea=#Advanced;
                SourceExpr=Item."Costing Method" }

    { 13  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 15  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion posten er oprettet ud fra.;
                           ENU=Specifies which type of transaction that the entry is created from.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Type" }

    { 17  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver det antal vareenheder, der indg†r i vareposten.;
                           ENU=Specifies the number of units of the item in the item entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Quantity }

    { 20  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet reserveret.;
                           ENU=Specifies how many units of the item on the line have been reserved.];
                ApplicationArea=#Advanced;
                SourceExpr="Reserved Quantity" }

    { 4   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i feltet Antal, der mangler at blive behandlet.;
                           ENU=Specifies the quantity in the Quantity field that remains to be processed.];
                ApplicationArea=#Advanced;
                SourceExpr="Remaining Quantity" }

    { 22  ;1   ;Field     ;
                CaptionML=[DAN=Disponible;
                           ENU=Available];
                ToolTipML=[DAN=Angiver det tilg‘ngelige nummer for den relevante post.;
                           ENU=Specifies the number available for the relevant entry.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=Available }

    { 24  ;1   ;Field     ;
                CaptionML=[DAN=Udlignet;
                           ENU=Applied];
                ToolTipML=[DAN=Angiver det nummer, der g‘lder for den relevante post.;
                           ENU=Specifies the number applied to the relevant entry.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=Applied }

  }
  CODE
  {
    VAR
      Item@1102601000 : Record 27;
      ItemApplnEntry@1102601001 : Record 339;
      Available@1000 : Decimal;
      Applied@1001 : Decimal;

    BEGIN
    END.
  }
}

