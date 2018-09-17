OBJECT Page 7332 Warehouse Receipts
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
    CaptionML=[DAN=Lagermodtagelser;
               ENU=Warehouse Receipts];
    SourceTable=Table7316;
    DataCaptionFields=No.;
    PageType=List;
    CardPageID=Warehouse Receipt;
    OnOpenPage=BEGIN
                 ErrorIfUserIsNotWhseEmployee;
               END;

    OnFindRecord=BEGIN
                   EXIT(FindFirstAllowedRec(Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(FindNextAllowedRec(Steps));
                 END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=&Lagermodtagelse;
                                 ENU=&Receipt];
                      Image=Receipt }
      { 1102601002;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Whse. Receipt),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601003;2 ;Action    ;
                      CaptionML=[DAN=&Bogf›rte lagermodtagelser;
                                 ENU=Posted &Whse. Receipts];
                      ToolTipML=[DAN=F† vist det antal, der er bogf›rt som modtaget.;
                                 ENU=View the quantity that has been posted as received.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7333;
                      RunPageView=SORTING(Whse. Receipt No.);
                      RunPageLink=Whse. Receipt No.=FIELD(No.);
                      Image=PostedReceipts }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 18      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Warehouse;
                      Image=EditLines;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"Warehouse Receipt",Rec);
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
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne modtages.;
                           ENU=Specifies the code of the location in which the items are being received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken metode modtagelserne sorteres med.;
                           ENU=Specifies the method by which the receipts are sorted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method" }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den zone, hvor varerne modtages, hvis du bruger styret l‘g-p†-lager og pluk.;
                           ENU=Specifies the zone in which the items are being received if you are using directed put-away and pick.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver status for lagermodtagelsen.;
                           ENU=Specifies the status of the warehouse receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr="Document Status";
                Visible=FALSE }

    { 1102601009;2;Field  ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for lagermodtagelsen.;
                           ENU=Specifies the posting date of the warehouse receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 1102601011;2;Field  ;
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

    BEGIN
    END.
  }
}

