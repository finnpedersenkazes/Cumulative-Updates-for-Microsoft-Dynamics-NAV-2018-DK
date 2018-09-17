OBJECT Page 6003 Cancelled Allocation Entries
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
    CaptionML=[DAN=Annullerede allokeringsposter;
               ENU=Canceled Allocation Entries];
    SourceTable=Table5950;
    DataCaptionFields=Document Type,Document No.;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Service;
                SourceExpr="Reason Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type dokument (Ordre eller Tilbud), som allokeringen er oprettet fra.;
                           ENU=Specifies the type of the document (Order or Quote) from which the allocation entry was created.];
                ApplicationArea=#Service;
                SourceExpr="Document Type" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceordre, som er knyttet til posten.;
                           ENU=Specifies the number of the service order associated with this entry.];
                ApplicationArea=#Service;
                SourceExpr="Document No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceartikel, der er knyttet til posten.;
                           ENU=Specifies the number of the service item line linked to this entry.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Line No." }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† serviceartiklen.;
                           ENU=Specifies the number of the service item.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ressourceallokeringen skal begynde.;
                           ENU=Specifies the date when the resource allocation should start.];
                ApplicationArea=#Service;
                SourceExpr="Allocation Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den ressource, der er allokeret til serviceopgaven i posten.;
                           ENU=Specifies the number of the resource allocated to the service task in this entry.];
                ApplicationArea=#Service;
                SourceExpr="Resource No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den ressourcegruppe, der er allokeret til serviceopgaven i posten.;
                           ENU=Specifies the number of the resource group allocated to the service task in this entry.];
                ApplicationArea=#Service;
                SourceExpr="Resource Group No.";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de timer, der er allokeret til ressourcen eller ressourcegruppen for serviceopgaven i posten.;
                           ENU=Specifies the hours allocated to the resource or resource group for the service task in this entry.];
                ApplicationArea=#Service;
                SourceExpr="Allocated Hours" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor allokeringen skal starte.;
                           ENU=Specifies the time when you want the allocation to start.];
                ApplicationArea=#Service;
                SourceExpr="Starting Time" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor allokeringen skal slutte.;
                           ENU=Specifies the time when you want the allocation to finish.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Time" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af serviceordreallokeringen.;
                           ENU=Specifies a description for the service order allocation.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Service;
                SourceExpr="Entry No.";
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

