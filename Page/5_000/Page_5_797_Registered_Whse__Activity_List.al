OBJECT Page 5797 Registered Whse. Activity List
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
    CaptionML=[DAN=Reg. lageraktivitetsoversigt;
               ENU=Registered Whse. Activity List];
    SourceTable=Table5772;
    PageType=List;
    OnFindRecord=BEGIN
                   IF FIND(Which) THEN BEGIN
                     RegisteredWhseActivHeader := Rec;
                     WHILE TRUE DO BEGIN
                       IF WMSManagement.LocationIsAllowed("Location Code") THEN
                         EXIT(TRUE);
                       IF NEXT(1) = 0 THEN BEGIN
                         Rec := RegisteredWhseActivHeader;
                         IF FIND(Which) THEN
                           WHILE TRUE DO BEGIN
                             IF WMSManagement.LocationIsAllowed("Location Code") THEN
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

                   RegisteredWhseActivHeader := Rec;
                   REPEAT
                     NextSteps := NEXT(Steps / ABS(Steps));
                     IF WMSManagement.LocationIsAllowed("Location Code") THEN BEGIN
                       RealSteps := RealSteps + NextSteps;
                       RegisteredWhseActivHeader := Rec;
                     END;
                   UNTIL (NextSteps = 0) OR (RealSteps = Steps);
                   Rec := RegisteredWhseActivHeader;
                   FIND;
                   EXIT(RealSteps);
                 END;

    OnAfterGetCurrRecord=BEGIN
                           CurrPage.CAPTION := FormCaption;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 19      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Warehouse;
                      Image=EditLines;
                      OnAction=BEGIN
                                 CASE Type OF
                                   Type::"Put-away":
                                     PAGE.RUN(PAGE::"Registered Put-away",Rec);
                                   Type::Pick:
                                     PAGE.RUN(PAGE::"Registered Pick",Rec);
                                   Type::Movement:
                                     PAGE.RUN(PAGE::"Registered Movement",Rec);
                                 END;
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

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type aktivitet, eksempelvis l‘g-p†-lager, pluk eller bev‘gelse, som lagerstedet udf›rte for de linjer, der er knyttet til hovedet.;
                           ENU=Specifies the type of activity that the warehouse performed on the lines attached to the header, such as put-away, pick or movement.];
                ApplicationArea=#Warehouse;
                SourceExpr=Type;
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det lageraktivitetsnummer, som aktiviteten blev registreret under.;
                           ENU=Specifies the warehouse activity number from which the activity was registered.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Activity No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor den registrerede lageraktivitet forekom.;
                           ENU=Specifies the code of the location in which the registered warehouse activity occurred.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan linjerne blev sorteret i lagerhovedet, f.eks. efter vare eller placeringskode.;
                           ENU=Specifies the method by which the lines were sorted on the warehouse header, such as by item, or bin code.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Warehouse;
                SourceExpr="No. Series" }

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
      RegisteredWhseActivHeader@1001 : Record 5772;
      WMSManagement@1000 : Codeunit 7302;
      Text000@1003 : TextConst 'DAN=Reg. l‘g-p†-lager-oversigt (log.);ENU=Registered Whse. Put-away List';
      Text001@1002 : TextConst 'DAN=Reg. plukliste (logistik);ENU=Registered Whse. Pick List';
      Text002@1004 : TextConst 'DAN=Reg. bev‘gelsesoversigt (logistik);ENU=Registered Whse. Movement List';
      Text003@1005 : TextConst 'DAN=Reg. lageraktivitetsoversigt;ENU=Registered Whse. Activity List';

    LOCAL PROCEDURE FormCaption@1() : Text[250];
    BEGIN
      CASE Type OF
        Type::"Put-away":
          EXIT(Text000);
        Type::Pick:
          EXIT(Text001);
        Type::Movement:
          EXIT(Text002);
        ELSE
          EXIT(Text003);
      END;
    END;

    BEGIN
    END.
  }
}

