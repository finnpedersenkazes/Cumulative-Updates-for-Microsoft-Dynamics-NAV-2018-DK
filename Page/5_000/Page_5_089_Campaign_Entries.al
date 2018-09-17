OBJECT Page 5089 Campaign Entries
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
    CaptionML=[DAN=Kampagneposter;
               ENU=Campaign Entries];
    SourceTable=Table5072;
    DataCaptionFields=Campaign No.,Description;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 18      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Interaktionslogp&ost;
                                 ENU=Interaction Log E&ntry];
                      ToolTipML=[DAN=Vis en liste med de interaktioner, som du har gemt, f.eks. hvis du vil oprette en interaktion, udskrive en f›lgeseddel en salgsordre osv.;
                                 ENU=View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5076;
                      RunPageView=SORTING(Campaign No.,Campaign Entry No.);
                      RunPageLink=Campaign No.=FIELD(Campaign No.),
                                  Campaign Entry No.=FIELD(Entry No.);
                      Image=Interaction }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Skift &markering i Annulleret;
                                 ENU=Switch Check&mark in Canceled];
                      ToolTipML=[DAN=Skift records, der har en markering i Annulleret.;
                                 ENU=Change records that have a checkmark in Canceled.];
                      ApplicationArea=#Advanced;
                      Image=ReopenCancelled;
                      OnAction=BEGIN
                                 ToggleCanceledCheckmark;
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

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Entry No." }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at posten er blevet annulleret.;
                           ENU=Specifies that the entry has been canceled.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Canceled }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for registreringen af kampagneposten. Feltet kan ikke redigeres.;
                           ENU=Specifies the date the campaign entry was recorded. The field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Date }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af kampagneposten.;
                           ENU=Specifies the description of the campaign entry.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel›bet p† kampagneposten. Feltet kan ikke redigeres.;
                           ENU=Specifies the cost of the campaign entry. The field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Cost (LCY)" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varigheden af den handling, som er knyttet til kampagneposten. Feltet kan ikke redigeres.;
                           ENU=Specifies the duration of the action linked to the campaign entry. The field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Duration (Min.)" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af interaktioner, der er oprettet som en del af kampagneposten. Feltet kan ikke redigeres.;
                           ENU=Specifies the number of interactions created as part of the campaign entry. The field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="No. of Interactions" }

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

