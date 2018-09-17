OBJECT Page 224 Res. Capacity Entries
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
    CaptionML=[DAN=Ressourcekapc.poster;
               ENU=Res. Capacity Entries];
    SourceTable=Table160;
    DataCaptionFields=Resource No.,Resource Group No.;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kapacitetsposten er gyldig.;
                           ENU=Specifies the date for which the capacity entry is valid.];
                ApplicationArea=#Jobs;
                SourceExpr=Date }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilsvarende ressource.;
                           ENU=Specifies the number of the corresponding resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Resource No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilsvarende ressourcegruppe, som er tildelt ressourcen.;
                           ENU=Specifies the number of the corresponding resource group assigned to the resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Resource Group No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kapacitet, der er beregnet og registreret. Kapaciteten er angivet i enheden.;
                           ENU=Specifies the capacity that is calculated and recorded. The capacity is in the unit of measure.];
                ApplicationArea=#Jobs;
                SourceExpr=Capacity }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Jobs;
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

