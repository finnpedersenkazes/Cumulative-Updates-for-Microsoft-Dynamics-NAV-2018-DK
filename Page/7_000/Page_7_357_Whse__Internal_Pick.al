OBJECT Page 7357 Whse. Internal Pick
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Internt pluk (logistik);
               ENU=Whse. Internal Pick];
    SourceTable=Table7333;
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
                      CaptionML=[DAN=&Pluk;
                                 ENU=&Pick];
                      Image=CreateInventoryPickup }
      { 101     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=FÜ vist alle eksisterende lagerdokumenter af denne type.;
                                 ENU=View all warehouse documents of this type that exist.];
                      ApplicationArea=#Warehouse;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 LookupWhseInternalPickHeader(Rec);
                               END;
                                }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Internal Pick),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 16      ;2   ;Action    ;
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 45      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
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
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen ved ekstra lageraktivitet.;
                                 ENU=Reopen the document for additional warehouse activity.];
                      ApplicationArea=#Warehouse;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleaseWhseInternalPick@1000 : Codeunit 7315;
                               BEGIN
                                 ReleaseWhseInternalPick.Reopen(Rec);
                               END;
                                }
      { 24      ;2   ;Action    ;
                      Name=CreatePick;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret pluk;
                                 ENU=Create Pick];
                      ToolTipML=[DAN=Opret et lagerplukbilag.;
                                 ENU=Create a warehouse pick document.];
                      ApplicationArea=#Warehouse;
                      Image=CreateInventoryPickup;
                      OnAction=BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 CurrPage.WhseInternalPickLines.PAGE.PickCreate;
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
                ToolTipML=[DAN=Angiver koden for den lokation, hvor den interne pluk udfõres.;
                           ENU=Specifies the code of the location where the internal pick is being performed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           LookupLocation(Rec);
                           CurrPage.UPDATE(TRUE);
                         END;
                          }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den zone, hvor varerne skal lëgges, efter de er blevet plukket.;
                           ENU=Specifies the zone in which you want the items to be placed when they are picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Zone Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne skal lëgges, efter de er blevet plukket.;
                           ENU=Specifies the bin in which you want the items to be placed when they are picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Bin Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsstatus for det indgÜende pluk.;
                           ENU=Specifies the document status of the internal pick.];
                ApplicationArea=#Warehouse;
                SourceExpr="Document Status" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om det interne pluk er Übent eller frigivet.;
                           ENU=Specifies whether the internal pick is open or released.];
                ApplicationArea=#Warehouse;
                SourceExpr=Status }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal vëre afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the date when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Date";
                Editable=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkeslët, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the time when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Time";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken metode lagerstedets interne pluklinjer sorteres med.;
                           ENU=Specifies the method by which the warehouse internal pick lines are sorted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method";
                OnValidate=BEGIN
                             SortingMethodOnAfterValidate;
                           END;
                            }

    { 97  ;1   ;Part      ;
                Name=WhseInternalPickLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(No.,Sorting Sequence No.);
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page7358;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 6   ;1   ;Part      ;
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

