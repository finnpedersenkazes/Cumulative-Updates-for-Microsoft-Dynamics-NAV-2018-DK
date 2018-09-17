OBJECT Page 6505 Lot No. Information Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lotnr.oplysningskort;
               ENU=Lot No. Information Card];
    SourceTable=Table6505;
    PopulateAllFields=Yes;
    PageType=Card;
    OnOpenPage=BEGIN
                 SETRANGE("Date Filter",DMY2DATE(1,1,0),WORKDATE);
                 IF ShowButtonFunctions THEN
                   ButtonFunctionsVisible := TRUE;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Lotnr.;
                                 ENU=&Lot No.];
                      Image=Lot }
      { 6500    ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingsposter;
                                 ENU=Item &Tracking Entries];
                      ToolTipML=[DAN=Vis serie- eller lotnumre, der er tildelt til varer.;
                                 ENU=View serial or lot numbers that are assigned to items.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLedger;
                      OnAction=VAR
                                 ItemTrackingDocMgt@1000 : Codeunit 6503;
                               BEGIN
                                 ItemTrackingDocMgt.ShowItemTrackingForMasterData(0,'',"Item No.","Variant Code",'',"Lot No.",'');
                               END;
                                }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Bem‘rkning;
                                 ENU=Comment];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Page 6506;
                      RunPageLink=Type=CONST(Lot No.),
                                  Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Serial/Lot No.=FIELD(Lot No.);
                      Image=ViewComments }
      { 28      ;2   ;Separator  }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=&Varesporing;
                                 ENU=&Item Tracing];
                      ToolTipML=[DAN=Spor, hvor en lot- eller et serienummer, som varen er blevet tildelt, blev anvendt, eksempelvis for at finde ud af, hvilket lot en defekt komponent stammer fra, eller for at finde alle de debitorer, som har modtaget varer, der indeholder den defekte komponent.;
                                 ENU=Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTracing;
                      OnAction=VAR
                                 ItemTracingBuffer@1002 : Record 6520;
                                 ItemTracing@1000 : Page 6520;
                               BEGIN
                                 CLEAR(ItemTracing);
                                 ItemTracingBuffer.SETRANGE("Item No.","Item No.");
                                 ItemTracingBuffer.SETRANGE("Variant Code","Variant Code");
                                 ItemTracingBuffer.SETRANGE("Lot No.","Lot No.");
                                 ItemTracing.InitFilters(ItemTracingBuffer);
                                 ItemTracing.FindRecords;
                                 ItemTracing.RUNMODAL;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 25      ;1   ;ActionGroup;
                      Name=ButtonFunctions;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Visible=ButtonFunctionsVisible;
                      Image=Action }
      { 26      ;2   ;Action    ;
                      Name=CopyInfo;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier &oplysninger;
                                 ENU=Copy &Info];
                      ToolTipML=[DAN=Kopi‚r recorden med oplysninger fra det gamle lotnummer.;
                                 ENU=Copy the information record from the old lot number.];
                      ApplicationArea=#ItemTracking;
                      Image=CopySerialNo;
                      OnAction=VAR
                                 SelectedRecord@1004 : Record 6505;
                                 ShowRecords@1005 : Record 6505;
                                 FocusOnRecord@1006 : Record 6505;
                                 ItemTrackingMgt@1001 : Codeunit 6500;
                                 LotNoInfoList@1000 : Page 6508;
                               BEGIN
                                 ShowRecords.SETRANGE("Item No.","Item No.");
                                 ShowRecords.SETRANGE("Variant Code","Variant Code");

                                 FocusOnRecord.COPY(ShowRecords);
                                 FocusOnRecord.SETRANGE("Lot No.",TrackingSpec."Lot No.");

                                 LotNoInfoList.SETTABLEVIEW(ShowRecords);

                                 IF FocusOnRecord.FINDFIRST THEN
                                   LotNoInfoList.SETRECORD(FocusOnRecord);
                                 IF LotNoInfoList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                   LotNoInfoList.GETRECORD(SelectedRecord);
                                   ItemTrackingMgt.CopyLotNoInformation(SelectedRecord,"Lot No.");
                                 END;
                               END;
                                }
      { 27      ;1   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Navigate@1000000000 : Page 344;
                               BEGIN
                                 Navigate.SetTracking('',"Lot No.");
                                 Navigate.RUN;
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
                ToolTipML=[DAN=Angiver dette nummer fra tabellen Sporingsspecifikation, n†r der oprettes en record med lotnummeroplysninger.;
                           ENU=Specifies this number from the Tracking Specification table when a lot number information record is created.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Item No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dette nummer fra tabellen Sporingsspecifikation, n†r der oprettes en record med lotnummeroplysninger.;
                           ENU=Specifies this number from the Tracking Specification table when a lot number information record is created.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af recorden med lotnummeroplysninger.;
                           ENU=Specifies a description of the lot no. information record.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Description }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kvaliteten af et bestemt lot, hvis du har kontrolleret varerne.;
                           ENU=Specifies the quality of a given lot if you have inspected the items.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Test Quality" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som leverand›ren har oplyst, for at anf›re, at partiet eller lottet lever op til de angivne specifikationer.;
                           ENU=Specifies the number provided by the supplier to indicate that the batch or lot meets the specified requirements.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Certificate Number" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Blocked }

    { 1904162201;1;Group  ;
                CaptionML=[DAN=Lager;
                           ENU=Inventory] }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lagerantallet for det angivne lotnummer.;
                           ENU=Specifies the inventory quantity of the specified lot number.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Inventory }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lagerbeholdningen for lotnummeret med en udl›bsdato f›r bogf›ringsdatoen p† det tilknyttede bilag.;
                           ENU=Specifies the inventory of the lot number with an expiration date before the posting date on the associated document.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expired Inventory" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                ApplicationArea=#ItemTracking;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                ApplicationArea=#ItemTracking;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      TrackingSpec@1002 : Record 336;
      ShowButtonFunctions@1000 : Boolean;
      ButtonFunctionsVisible@19001764 : Boolean INDATASET;

    [External]
    PROCEDURE Init@1(CurrentTrackingSpec@1004 : Record 336);
    BEGIN
      TrackingSpec := CurrentTrackingSpec;
      ShowButtonFunctions := TRUE;
    END;

    [External]
    PROCEDURE InitWhse@2(CurrentTrackingSpec@1000 : Record 6550);
    BEGIN
      TrackingSpec."Lot No." := CurrentTrackingSpec."Lot No.";
      ShowButtonFunctions := TRUE;
    END;

    BEGIN
    END.
  }
}

