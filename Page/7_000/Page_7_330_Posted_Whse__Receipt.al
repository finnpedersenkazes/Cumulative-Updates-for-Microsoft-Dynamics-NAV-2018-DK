OBJECT Page 7330 Posted Whse. Receipt
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf›rt lagermodtagelse;
               ENU=Posted Whse. Receipt];
    InsertAllowed=No;
    SourceTable=Table7318;
    PageType=Document;
    RefreshOnActivate=Yes;
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
      { 100     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Modtagelse;
                                 ENU=&Receipt];
                      Image=Receipt }
      { 101     ;2   ;Action    ;
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
      { 32      ;2   ;Action    ;
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
      { 33      ;2   ;Action    ;
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
      { 34      ;2   ;Action    ;
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 35      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret l‘g-p†-lager;
                                 ENU=Create Put-away];
                      ToolTipML=[DAN="Opret l‘g-p†-lager for de modtagne varer. ";
                                 ENU="Create warehouse put-away for the received items. "];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CreatePutAway;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 CurrPage.PostedWhseRcptLines.PAGE.PutAwayCreate;
                               END;
                                }
      { 30      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WhseDocPrint.PrintPostedRcptHeader(Rec);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1903358206;1 ;Action    ;
                      CaptionML=[DAN=L‘g-p†-lager-oversigt;
                                 ENU=Put-away List];
                      ToolTipML=[DAN=F† vist eller udskriv en detaljeret liste over varer, som skal l‘gges p† lager.;
                                 ENU=View or print a detailed list of items that must be put away.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 5751;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No.";
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne blev registreret.;
                           ENU=Specifies the code of the location where the items were received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for zonen p† det bogf›rte modtagelseshoved.;
                           ENU=Specifies the code of the zone on this posted receipt header.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for den bogf›rte lagermodtagelse.;
                           ENU=Specifies the status of the posted warehouse receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr="Document Status";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for modtagelsen.;
                           ENU=Specifies the posting date of the receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens leverancenummer. Det inds‘ttes i det tilsvarende felt p† kildedokumentet ved bogf›ringen.;
                           ENU=Specifies the vendor's shipment number. It is inserted in the corresponding field on the source document during posting.];
                ApplicationArea=#Warehouse;
                SourceExpr="Vendor Shipment No.";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den lagermodtagelse, som den bogf›rte lagermodtagelse vedr›rer.;
                           ENU=Specifies the number of the warehouse receipt that the posted warehouse receipt concerns.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Receipt No.";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID";
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the date when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Date";
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the time when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Time";
                Editable=FALSE }

    { 97  ;1   ;Part      ;
                Name=PostedWhseRcptLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(No.,Line No.);
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page7331;
                PartType=Page }

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
      WhseDocPrint@1000 : Codeunit 5776;

    BEGIN
    END.
  }
}

