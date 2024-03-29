OBJECT Page 9345 Registered Whse. Movements
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
    CaptionML=[DAN=Reg. bev�gelsesoversigt (logistik);
               ENU=Registered Whse. Movement List];
    SourceTable=Table5772;
    SourceTableView=WHERE(Type=CONST(Movement));
    PageType=List;
    CardPageID=Registered Movement;
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

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=&Bev�gelse;
                                 ENU=&Movement];
                      Image=CreateMovement }
      { 1102601002;2 ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Rgstrd. Whse. Activity Header),
                                  Type=FIELD(Type),
                                  No.=FIELD(No.);
                      Image=ViewComments }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type aktivitet, eksempelvis l�g-p�-lager, pluk eller bev�gelse, som lagerstedet udf�rte for de linjer, der er knyttet til hovedet.;
                           ENU=Specifies the type of activity that the warehouse performed on the lines attached to the header, such as put-away, pick or movement.];
                ApplicationArea=#Warehouse;
                SourceExpr=Type;
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
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

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor linjen blev registreret.;
                           ENU=Specifies the date the line is registered.];
                ApplicationArea=#Warehouse;
                SourceExpr="Registering Date";
                Visible=FALSE }

    { 1102601004;2;Field  ;
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
      RegisteredWhseActivHeader@1001 : Record 5772;
      WMSManagement@1000 : Codeunit 7302;

    BEGIN
    END.
  }
}

