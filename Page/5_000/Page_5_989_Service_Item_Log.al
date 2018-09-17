OBJECT Page 5989 Service Item Log
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
    CaptionML=[DAN=Serviceartikellog;
               ENU=Service Item Log];
    SourceTable=Table5942;
    DataCaptionExpr=GetCaptionHeader;
    SourceTableView=ORDER(Descending);
    PageType=List;
    OnInit=BEGIN
             ServiceItemNoVisible := TRUE;
           END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 20      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Slet serviceartikellog;
                                 ENU=Delete Service Item Log];
                      ToolTipML=[DAN=Slet logfilen over serviceaktiviteter.;
                                 ENU=Delete the log of service activities.];
                      ApplicationArea=#Service;
                      Image=Delete;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Delete Service Item Log",TRUE,FALSE,Rec);
                                 CurrPage.UPDATE;
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
                ToolTipML=[DAN=Angiver nummeret p† den h‘ndelse, som er knyttet til serviceartiklen.;
                           ENU=Specifies the number of the event associated with the service item.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No.";
                Visible=ServiceItemNoVisible;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Service;
                SourceExpr="Entry No.";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver beskrivelsen af den h‘ndelse, der vedr›rer serviceartiklen.;
                           ENU=Specifies the description of the event regarding service item that has taken place.];
                ApplicationArea=#Service;
                SourceExpr=ServLogMgt.ServItemEventDescription("Event No.");
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘rdien i det ‘ndrede felt, efter h‘ndelsen har fundet sted.;
                           ENU=Specifies the value of the field modified after the event takes place.];
                ApplicationArea=#Service;
                SourceExpr=After }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forrige v‘rdi i feltet, som blev ‘ndret efter h‘ndelsen fandt sted.;
                           ENU=Specifies the previous value of the field, modified after the event takes place.];
                ApplicationArea=#Service;
                SourceExpr=Before }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dokumenttypen for den serviceartikel, der er knyttet til h‘ndelsen, f.eks. servicekontrakten, -ordren eller -tilbuddet.;
                           ENU=Specifies the document type of the service item associated with the event, such as contract, order, or quote.];
                ApplicationArea=#Service;
                SourceExpr="Document Type" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† den h‘ndelse, som er knyttet til serviceartiklen.;
                           ENU=Specifies the document number of the event associated with the service item.];
                ApplicationArea=#Service;
                SourceExpr="Document No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for h‘ndelsen.;
                           ENU=Specifies the date of the event.];
                ApplicationArea=#Service;
                SourceExpr="Change Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver klokkesl‘ttet for h‘ndelsen.;
                           ENU=Specifies the time of the event.];
                ApplicationArea=#Service;
                SourceExpr="Change Time" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Service;
                SourceExpr="User ID" }

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
    VAR
      ServLogMgt@1000 : Codeunit 5906;
      ServiceItemNoVisible@19053939 : Boolean INDATASET;

    LOCAL PROCEDURE GetCaptionHeader@1() : Text[250];
    VAR
      ServItem@1000 : Record 5940;
    BEGIN
      IF GETFILTER("Service Item No.") <> '' THEN BEGIN
        ServiceItemNoVisible := FALSE;
        IF ServItem.GET("Service Item No.") THEN
          EXIT("Service Item No." + ' ' + ServItem.Description);

        EXIT("Service Item No.");
      END;

      ServiceItemNoVisible := TRUE;
      EXIT('');
    END;

    BEGIN
    END.
  }
}

