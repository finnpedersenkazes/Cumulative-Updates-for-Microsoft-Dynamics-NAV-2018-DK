OBJECT Page 7399 Internal Movement
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Intern flytning;
               ENU=Internal Movement];
    SourceTable=Table7346;
    PopulateAllFields=Yes;
    PageType=Document;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 OpenInternalMovementHeader(Rec);
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 100     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Intern flytning;
                                 ENU=&Internal Movement];
                      Image=CreateMovement }
      { 101     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=F† vist alle eksisterende lagerdokumenter af denne type.;
                                 ENU=View all warehouse documents of this type that exist.];
                      ApplicationArea=#Warehouse;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 LookupInternalMovementHeader(Rec);
                               END;
                                }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Internal Movement),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 35      ;2   ;Action    ;
                      AccessByPermission=TableData 7302=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent placeringsindh.;
                                 ENU=Get Bin Content];
                      ToolTipML=[DAN=Brug en funktion til oprettelse af overflytningslinjer med varer, der skal l‘gges p† lager eller plukkes, baseret p† det faktiske indhold p† den angivne placering.;
                                 ENU=Use a function to create transfer lines with items to put away or pick based on the actual content in the specified bin.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=GetBinContent;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 BinContent@1000 : Record 7302;
                                 WhseGetBinContent@1001 : Report 7391;
                               BEGIN
                                 TESTFIELD("No.");
                                 TESTFIELD("Location Code");
                                 BinContent.SETRANGE("Location Code","Location Code");
                                 WhseGetBinContent.SETTABLEVIEW(BinContent);
                                 WhseGetBinContent.InitializeInternalMovement(Rec);
                                 WhseGetBinContent.RUN;
                               END;
                                }
      { 39      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret flytning (lager);
                                 ENU=Create Inventory Movement];
                      ToolTipML=[DAN=Opret en flytning (lager) for at h†ndtere varerne i bilaget i henhold til en grundl‘ggende lagerops‘tning.;
                                 ENU=Create an inventory movement to handle items on the document according to a basic warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=CreatePutAway;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CreateInvtPickMovement@1000 : Codeunit 7322;
                               BEGIN
                                 CreateInvtPickMovement.CreateInvtMvntWithoutSource(Rec);
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
                OnAssistEdit=BEGIN
                               IF AssistEdit THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor den interne flytning udf›res.;
                           ENU=Specifies the code of the location where the internal movement is being performed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne i den interne flytning skal placeres, n†r de er blevet plukket.;
                           ENU=Specifies the bin where you want items on this internal movement to be placed when they are picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Bin Code" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re afsluttet.;
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
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the time when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Time";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken metode de interne flytninger sorteres med.;
                           ENU=Specifies the method by which the internal movements are sorted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method";
                OnValidate=BEGIN
                             SortingMethodOnAfterValidate;
                           END;
                            }

    { 97  ;1   ;Part      ;
                Name=InternalMovementLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(No.,Sorting Sequence No.);
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page7398;
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

