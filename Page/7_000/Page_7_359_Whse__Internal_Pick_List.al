OBJECT Page 7359 Whse. Internal Pick List
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
    CaptionML=[DAN=Intern plukliste (logistik);
               ENU=Whse. Internal Pick List];
    SourceTable=Table7333;
    DataCaptionFields=No.;
    PageType=List;
    CardPageID=Whse. Internal Pick;
    OnFindRecord=BEGIN
                   IF FIND(Which) THEN BEGIN
                     WhseInternalPickHeader := Rec;
                     WHILE TRUE DO BEGIN
                       IF WMSMgt.LocationIsAllowed("Location Code") THEN
                         EXIT(TRUE);
                       IF NEXT(1) = 0 THEN BEGIN
                         Rec := WhseInternalPickHeader;
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
                   RealSteps@1001 : Integer;
                   NextSteps@1000 : Integer;
                 BEGIN
                   IF Steps = 0 THEN
                     EXIT;

                   WhseInternalPickHeader := Rec;
                   REPEAT
                     NextSteps := NEXT(Steps / ABS(Steps));
                     IF WMSMgt.LocationIsAllowed("Location Code") THEN BEGIN
                       RealSteps := RealSteps + NextSteps;
                       WhseInternalPickHeader := Rec;
                     END;
                   UNTIL (NextSteps = 0) OR (RealSteps = Steps);
                   Rec := WhseInternalPickHeader;
                   FIND;
                   EXIT(RealSteps);
                 END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601005;1 ;ActionGroup;
                      CaptionML=[DAN=&Pluk;
                                 ENU=&Pick];
                      Image=CreateInventoryPickup }
      { 1102601007;2 ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Internal Pick),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601008;2 ;Action    ;
                      CaptionML=[DAN=Pluklinjer;
                                 ENU=Pick Lines];
                      ToolTipML=[DAN=Vis de relaterede pluk.;
                                 ENU=View the related picks.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5785;
                      RunPageView=SORTING(Whse. Document No.,Whse. Document Type,Activity Type)
                                  WHERE(Activity Type=CONST(Pick));
                      RunPageLink=Whse. Document Type=CONST(Internal Pick),
                                  Whse. Document No.=FIELD(No.);
                      Image=PickLines }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 18      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p�g�ldende record p� bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Warehouse;
                      Image=EditLines;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"Whse. Internal Pick",Rec);
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
                      ToolTipML=[DAN=Frigiv bilaget til n�ste behandlingstrin. N�r et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal gen�bne bilaget, f�r du kan foretage �ndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Warehouse;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleaseWhseInternalPick@1000 : Codeunit 7315;
                               BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 IF Status = Status::Open THEN
                                   ReleaseWhseInternalPick.Release(Rec);
                               END;
                                }
      { 1102601002;2 ;Action    ;
                      CaptionML=[DAN=&�bn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=�bn bilaget igen ved ekstra lageraktivitet.;
                                 ENU=Reopen the document for additional warehouse activity.];
                      ApplicationArea=#Warehouse;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleaseWhseInternalPick@1000 : Codeunit 7315;
                               BEGIN
                                 ReleaseWhseInternalPick.Reopen(Rec);
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor den interne pluk udf�res.;
                           ENU=Specifies the code of the location where the internal pick is being performed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken metode lagerstedets interne pluklinjer sorteres med.;
                           ENU=Specifies the method by which the warehouse internal pick lines are sorted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om det interne pluk er �bent eller frigivet.;
                           ENU=Specifies whether the internal pick is open or released.];
                ApplicationArea=#Warehouse;
                SourceExpr=Status }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver den zone, hvor varerne skal l�gges, efter de er blevet plukket.;
                           ENU=Specifies the zone in which you want the items to be placed when they are picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Zone Code";
                Visible=FALSE }

    { 1102601006;2;Field  ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne skal l�gges, efter de er blevet plukket.;
                           ENU=Specifies the bin in which you want the items to be placed when they are picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Bin Code";
                Visible=FALSE }

    { 1102601010;2;Field  ;
                ToolTipML=[DAN=Angiver bilagsstatus for det indg�ende pluk.;
                           ENU=Specifies the document status of the internal pick.];
                ApplicationArea=#Warehouse;
                SourceExpr="Document Status";
                Visible=FALSE }

    { 1102601012;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v�re afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 1102601014;2;Field  ;
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
      WhseInternalPickHeader@1000 : Record 7333;
      WMSMgt@1001 : Codeunit 7302;

    BEGIN
    END.
  }
}

