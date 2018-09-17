OBJECT Page 7333 Posted Whse. Receipt List
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
    CaptionML=[DAN=Bogf. lagermodt.oversigt;
               ENU=Posted Whse. Receipt List];
    SourceTable=Table7318;
    DataCaptionFields=No.;
    PageType=List;
    CardPageID=Posted Whse. Receipt;
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
      { 1102601002;1 ;ActionGroup;
                      CaptionML=[DAN=&Lagermodtagelse;
                                 ENU=&Receipt];
                      Image=Receipt }
      { 1102601003;2 ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=F† vist alle eksisterende lagerdokumenter af denne type.;
                                 ENU=View all warehouse documents of this type that exist.];
                      ApplicationArea=#Warehouse;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 LookupPostedWhseRcptHeader(Rec);
                               END;
                                }
      { 1102601004;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Posted Whse. Receipt),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601005;2 ;Action    ;
                      CaptionML=[DAN=L‘g-p†-lager-linjer;
                                 ENU=Put-away Lines];
                      ToolTipML=[DAN=" Vis de relaterede l‘g-p†-lager-aktiviteter.";
                                 ENU=" View the related put-aways."];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5785;
                      RunPageView=SORTING(Whse. Document No.,Whse. Document Type,Activity Type)
                                  WHERE(Activity Type=CONST(Put-away));
                      RunPageLink=Whse. Document Type=CONST(Receipt),
                                  Whse. Document No.=FIELD(No.);
                      Image=PutawayLines }
      { 1102601006;2 ;Action    ;
                      CaptionML=[DAN=Reg. l‘g-p†-lager-linjer;
                                 ENU=Registered Put-away Lines];
                      ToolTipML=[DAN=Vis listen over afsluttede l‘g-p†-lager-aktiviteter.;
                                 ENU=View the list of completed put-away activities.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7364;
                      RunPageView=SORTING(Whse. Document Type,Whse. Document No.,Whse. Document Line No.)
                                  WHERE(Activity Type=CONST(Put-away));
                      RunPageLink=Whse. Document Type=CONST(Receipt),
                                  Whse. Document No.=FIELD(No.);
                      Image=RegisteredDocs }
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
                                 PAGE.RUN(PAGE::"Posted Whse. Receipt",Rec);
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

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne blev registreret.;
                           ENU=Specifies the code of the location where the items were received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Warehouse;
                SourceExpr="No. Series" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den lagermodtagelse, som den bogf›rte lagermodtagelse vedr›rer.;
                           ENU=Specifies the number of the warehouse receipt that the posted warehouse receipt concerns.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Receipt No." }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver koden for zonen p† det bogf›rte modtagelseshoved.;
                           ENU=Specifies the code of the zone on this posted receipt header.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 1102601009;2;Field  ;
                ToolTipML=[DAN=Angiver status for den bogf›rte lagermodtagelse.;
                           ENU=Specifies the status of the posted warehouse receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr="Document Status";
                Visible=FALSE }

    { 1102601011;2;Field  ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for modtagelsen.;
                           ENU=Specifies the posting date of the receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 1102601013;2;Field  ;
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

