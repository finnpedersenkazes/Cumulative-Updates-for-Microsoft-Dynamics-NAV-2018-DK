OBJECT Page 5779 Warehouse Pick
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Pluk (logistik);
               ENU=Warehouse Pick];
    SaveValues=Yes;
    InsertAllowed=No;
    SourceTable=Table5766;
    SourceTableView=WHERE(Type=CONST(Pick));
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

    OnAfterGetRecord=BEGIN
                       CurrentLocationCode := "Location Code";
                     END;

    OnDeleteRecord=BEGIN
                     CurrPage.UPDATE;
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 100     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Pluk;
                                 ENU=P&ick];
                      Image=CreateInventoryPickup }
      { 101     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=F† vist alle eksisterende lagerdokumenter af denne type.;
                                 ENU=View all warehouse documents of this type that exist.];
                      ApplicationArea=#Advanced;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 LookupActivityHeader(CurrentLocationCode,Rec);
                               END;
                                }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Whse. Activity Header),
                                  Type=FIELD(Type),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Registrerede pluk;
                                 ENU=Registered Picks];
                      ToolTipML=[DAN=Vis de m‘ngder, der allerede er blevet plukket.;
                                 ENU=View the quantities that have already been picked.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5797;
                      RunPageView=SORTING(Whse. Activity No.);
                      RunPageLink=Type=FIELD(Type),
                                  Whse. Activity No.=FIELD(No.);
                      Promoted=Yes;
                      Image=RegisteredDocs;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Autofyld h†ndteringsantal;
                                 ENU=Autofill Qty. to Handle];
                      ToolTipML=[DAN=F† systemet til at angive det udest†ende antal i feltet H†ndteringsantal.;
                                 ENU=Have the system enter the outstanding quantity in the Qty. to Handle field.];
                      ApplicationArea=#Warehouse;
                      Image=AutofillQtyToHandle;
                      OnAction=BEGIN
                                 AutofillQtyToHandle;
                               END;
                                }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Slet h†ndteringsantal;
                                 ENU=Delete Qty. to Handle];
                      ToolTipML=[DAN=F† systemet til at slette v‘rdien i feltet H†ndteringsantal.;
                                 ENU="Have the system clear the value in the Qty. To Handle field. "];
                      ApplicationArea=#Advanced;
                      Image=DeleteQtyToHandle;
                      OnAction=BEGIN
                                 DeleteQtyToHandle;
                               END;
                                }
      { 32      ;2   ;Separator  }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&egistrering;
                                 ENU=&Registering];
                      Image=PostOrder }
      { 17      ;2   ;Action    ;
                      Name=RegisterPick;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Registrer pluk;
                                 ENU=&Register Pick];
                      ToolTipML=[DAN=Registrer, at varerne er blevet plukket.;
                                 ENU=Record that the items have been picked.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=RegisterPick;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 RegisterActivityYesNo;
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WhseActPrint.PrintPickHeader(Rec);
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
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No.";
                Editable=FALSE;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 28  ;2   ;Field     ;
                Lookup=No;
                CaptionML=[DAN=Lokationskode;
                           ENU=Location Code];
                ToolTipML=[DAN="Angiver den lokation, hvor lageraktiviteten finder sted. ";
                           ENU="Specifies the location where the warehouse activity takes place. "];
                ApplicationArea=#Warehouse;
                SourceExpr=CurrentLocationCode;
                Editable=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at de midlertidige Hent- og Placer-linjer, ikke vises som l‘g-p†-lager-, pluk- eller flytningslinjer, n†r antallet i den st›rre enhed l‘gges p† lager, plukkes eller flyttes helt.;
                           ENU=Specifies that the intermediate Take and Place lines will not show as put-away, pick, or movement lines, when the quantity in the larger unit of measure is being put-away, picked or moved completely.];
                ApplicationArea=#Warehouse;
                SourceExpr="Breakbulk Filter";
                OnValidate=BEGIN
                             BreakbulkFilterOnAfterValidate;
                           END;
                            }

    { 8   ;2   ;Field     ;
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

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the time when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Time";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan linjerne sorteres i lagerhovedet, f.eks. efter Vare eller Bilag.;
                           ENU=Specifies the method by which the lines are sorted on the warehouse header, such as Item or Document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method";
                OnValidate=BEGIN
                             SortingMethodOnAfterValidate;
                           END;
                            }

    { 97  ;1   ;Part      ;
                Name=WhseActivityLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(Activity Type,No.,Sorting Sequence No.)
                            WHERE(Breakbulk=CONST(No));
                SubPageLink=Activity Type=FIELD(Type),
                            No.=FIELD(No.);
                PagePartID=Page5780;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1901796907;1;Part   ;
                ApplicationArea=#Warehouse;
                SubPageLink=No.=FIELD(Item No.);
                PagePartID=Page9109;
                ProviderID=97;
                Visible=TRUE;
                PartType=Page }

    { 4   ;1   ;Part      ;
                ApplicationArea=#Warehouse;
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
    VAR
      WhseActPrint@1000 : Codeunit 5776;
      CurrentLocationCode@1001 : Code[10];

    LOCAL PROCEDURE AutofillQtyToHandle@1();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.AutofillQtyToHandle;
    END;

    LOCAL PROCEDURE DeleteQtyToHandle@2();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.DeleteQtyToHandle;
    END;

    LOCAL PROCEDURE RegisterActivityYesNo@3();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.RegisterActivityYesNo;
    END;

    LOCAL PROCEDURE SortingMethodOnAfterValidate@19063061();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE BreakbulkFilterOnAfterValidate@19055352();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

