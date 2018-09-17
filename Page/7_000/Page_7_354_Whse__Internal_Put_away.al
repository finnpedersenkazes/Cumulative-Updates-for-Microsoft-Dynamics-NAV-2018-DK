OBJECT Page 7354 Whse. Internal Put-away
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Intern lëg-pÜ-lager (logistik);
               ENU=Whse. Internal Put-away];
    SourceTable=Table7331;
    PopulateAllFields=Yes;
    PageType=Document;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 SetWhseLocationFilter;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 100     ;1   ;ActionGroup;
                      CaptionML=[DAN=L&ëg-pÜ-lager;
                                 ENU=&Put-away];
                      Image=CreatePutAway }
      { 101     ;2   ;Action    ;
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
      { 31      ;2   ;Action    ;
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
      { 29      ;2   ;Action    ;
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 7       ;2   ;Action    ;
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
      { 10      ;2   ;Action    ;
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
      { 35      ;2   ;Action    ;
                      AccessByPermission=TableData 7302=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent placeringsindh.;
                                 ENU=Get Bin Content];
                      ToolTipML=[DAN=Brug en funktion til oprettelse af overflytningslinjer med varer, der skal lëgges pÜ lager eller plukkes, baseret pÜ det faktiske indhold pÜ den angivne placering.;
                                 ENU=Use a function to create transfer lines with items to put away or pick based on the actual content in the specified bin.];
                      ApplicationArea=#Warehouse;
                      Image=GetBinContent;
                      OnAction=VAR
                                 DummyRec@1001 : Record 7326;
                                 BinContent@1000 : Record 7302;
                                 GetBinContent@1002 : Report 7391;
                               BEGIN
                                 BinContent.SETRANGE("Location Code","Location Code");
                                 GetBinContent.SETTABLEVIEW(BinContent);
                                 GetBinContent.InitializeReport(DummyRec,Rec,1);
                                 GetBinContent.RUN;
                               END;
                                }
      { 28      ;2   ;Action    ;
                      Name=CreatePutAway;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret lëg-pÜ-lager;
                                 ENU=Create Put-away];
                      ToolTipML=[DAN=Opret et lëg-pÜ-lager-bilag.;
                                 ENU=Create a warehouse put-away document.];
                      ApplicationArea=#Warehouse;
                      Image=CreatePutAway;
                      OnAction=BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 CurrPage.WhseInternalPutAwayLines.PAGE.PutAwayCreate;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor den interne lëg-pÜ-lager-aktivitet udfõres.;
                           ENU=Specifies the code of the location where the internal put-away is being performed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           LookupLocation(Rec);
                           CurrPage.UPDATE(TRUE);
                         END;
                          }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den zone, hvorfra de varer, der skal lëgges pÜ lager, skal hentes.;
                           ENU=Specifies the zone from which the items to be put away should be taken.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Zone Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvorfra de varer, der skal lëgges pÜ lager, skal hentes.;
                           ENU=Specifies the bin from which the items to be put away should be taken.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Bin Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for den interne lëg-pÜ-lager-aktivitet.;
                           ENU=Specifies the status of the internal put-away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Document Status" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for den interne lëg-pÜ-lager-aktivitet.;
                           ENU=Specifies the status of the internal put-away.];
                ApplicationArea=#Warehouse;
                SourceExpr=Status }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal vëre afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the date when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Date";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkeslët, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the time when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Time";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken metode lagerstedets interne lëg-pÜ-lager-aktiviteter sorteres med.;
                           ENU=Specifies the method by which the warehouse internal put-always are sorted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method";
                OnValidate=BEGIN
                             SortingMethodOnAfterValidate;
                           END;
                            }

    { 97  ;1   ;Part      ;
                Name=WhseInternalPutAwayLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(No.,Sorting Sequence No.);
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page7355;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 5   ;1   ;Part      ;
                ApplicationArea=#ItemTracking;
                SubPageLink=Item No.=FIELD(Item No.),
                            Variant Code=FIELD(Variant Code),
                            Location Code=FIELD(Location Code);
                PagePartID=Page9126;
                ProviderID=97;
                Visible=false;
                PartType=Page }

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

    LOCAL PROCEDURE SortingMethodOnAfterValidate@19063061();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

