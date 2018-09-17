OBJECT Page 7356 Whse. Internal Put-away List
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
    CaptionML=[DAN=Intern lëg-pÜ-lager-ov. (log.);
               ENU=Whse. Internal Put-away List];
    SourceTable=Table7331;
    DataCaptionFields=No.;
    PageType=List;
    CardPageID=Whse. Internal Put-away;
    OnFindRecord=BEGIN
                   IF FIND(Which) THEN BEGIN
                     WhseInternalPutawayHeader := Rec;
                     WHILE TRUE DO BEGIN
                       IF WMSMgt.LocationIsAllowed("Location Code") THEN
                         EXIT(TRUE);
                       IF NEXT(1) = 0 THEN BEGIN
                         Rec := WhseInternalPutawayHeader;
                         IF FIND(Which) THEN
                           WHILE TRUE DO BEGIN
                             IF WMSMgt.LocationIsAllowed("Location Code") THEN
                               EXIT(TRUE);
                             IF NEXT(-1) = 0 THEN
                               EXIT(FALSE);
                           END;
                       END;
                     END;
                   END;
                   EXIT(FALSE);
                 END;

    OnNextRecord=VAR
                   Nextsteps@1001 : Integer;
                   Realsteps@1002 : Integer;
                 BEGIN
                   IF Steps = 0 THEN
                     EXIT;

                   WhseInternalPutawayHeader := Rec;
                   REPEAT
                     Nextsteps := NEXT(Steps / ABS(Steps));
                     IF WMSMgt.LocationIsAllowed("Location Code") THEN BEGIN
                       Realsteps := Realsteps + Nextsteps;
                       WhseInternalPutawayHeader := Rec;
                     END;
                   UNTIL (Nextsteps = 0) OR (Realsteps = Steps);
                   Rec := WhseInternalPutawayHeader;
                   FIND;
                   EXIT(Realsteps);
                 END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601007;1 ;ActionGroup;
                      CaptionML=[DAN=L&ëg-pÜ-lager;
                                 ENU=&Put-away];
                      Image=CreatePutAway }
      { 1102601008;2 ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=FÜ vist alle eksisterende lagerdokumenter af denne type.;
                                 ENU=View all warehouse documents of this type that exist.];
                      ApplicationArea=#Warehouse;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 LookupInternalPutAwayHeader(Rec);
                               END;
                                }
      { 1102601009;2 ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Internal Put-away),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601010;2 ;Action    ;
                      CaptionML=[DAN=Lëg-pÜ-lager-linjer;
                                 ENU=Put-away Lines];
                      ToolTipML=[DAN=" Vis de relaterede lëg-pÜ-lager-aktiviteter.";
                                 ENU=" View the related put-aways."];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5785;
                      RunPageView=SORTING(Whse. Document No.,Whse. Document Type,Activity Type)
                                  WHERE(Activity Type=CONST(Put-away));
                      RunPageLink=Whse. Document Type=CONST(Internal Put-away),
                                  Whse. Document No.=FIELD(No.);
                      Image=PutawayLines }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 18      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den pÜgëldende record pÜ bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Warehouse;
                      Image=EditLines;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"Whse. Internal Put-away",Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1102601001;2 ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Warehouse;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleaseWhseInternalPutAway@1000 : Codeunit 7316;
                               BEGIN
                                 IF Status = Status::Open THEN
                                   ReleaseWhseInternalPutAway.Release(Rec);
                               END;
                                }
      { 1102601002;2 ;Action    ;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen ved ekstra lageraktivitet.;
                                 ENU=Reopen the document for additional warehouse activity.];
                      ApplicationArea=#Warehouse;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleaseWhseInternalPutaway@1000 : Codeunit 7316;
                               BEGIN
                                 ReleaseWhseInternalPutaway.Reopen(Rec);
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
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor den interne lëg-pÜ-lager-aktivitet udfõres.;
                           ENU=Specifies the code of the location where the internal put-away is being performed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken metode lagerstedets interne lëg-pÜ-lager-aktiviteter sorteres med.;
                           ENU=Specifies the method by which the warehouse internal put-always are sorted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method" }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver den zone, hvorfra de varer, der skal lëgges pÜ lager, skal hentes.;
                           ENU=Specifies the zone from which the items to be put away should be taken.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Zone Code";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver den placering, hvorfra de varer, der skal lëgges pÜ lager, skal hentes.;
                           ENU=Specifies the bin from which the items to be put away should be taken.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Bin Code";
                Visible=FALSE }

    { 1102601011;2;Field  ;
                ToolTipML=[DAN=Angiver status for den interne lëg-pÜ-lager-aktivitet.;
                           ENU=Specifies the status of the internal put-away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Document Status";
                Visible=FALSE }

    { 1102601013;2;Field  ;
                ToolTipML=[DAN=Angiver status for den interne lëg-pÜ-lager-aktivitet.;
                           ENU=Specifies the status of the internal put-away.];
                ApplicationArea=#Warehouse;
                SourceExpr=Status;
                Visible=FALSE }

    { 1102601015;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal vëre afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 1102601017;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the date when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Date";
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
    VAR
      WhseInternalPutawayHeader@1000 : Record 7331;
      WMSMgt@1001 : Codeunit 7302;

    BEGIN
    END.
  }
}

