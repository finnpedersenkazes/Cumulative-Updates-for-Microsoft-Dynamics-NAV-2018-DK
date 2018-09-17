OBJECT Page 6509 Serial No. Information List
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
    CaptionML=[DAN=Oversigt over serienr.oplysninger;
               ENU=Serial No. Information List];
    SourceTable=Table6504;
    PageType=List;
    CardPageID=Serial No. Information Card;
    OnInit=BEGIN
             CurrPage.LOOKUPMODE := TRUE;
           END;

    OnOpenPage=BEGIN
                 SETRANGE("Date Filter",DMY2DATE(1,1,0),WORKDATE);
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601001;1 ;ActionGroup;
                      CaptionML=[DAN=&Serienr.;
                                 ENU=&Serial No.];
                      Image=SerialNo }
      { 1102601002;2 ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Varesporingspos&ter;
                                 ENU=Item &Tracking Entries];
                      ToolTipML=[DAN=Vis serie- eller lotnumre, der er tildelt til varer.;
                                 ENU=View serial or lot numbers that are assigned to items.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLedger;
                      OnAction=VAR
                                 ItemTrackingDocMgt@1000 : Codeunit 6503;
                               BEGIN
                                 ItemTrackingDocMgt.ShowItemTrackingForMasterData(0,'',"Item No.","Variant Code","Serial No.",'','');
                               END;
                                }
      { 1102601003;2 ;Action    ;
                      CaptionML=[DAN=Bem‘rkning;
                                 ENU=Comment];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Page 6506;
                      RunPageLink=Type=CONST(Serial No.),
                                  Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Serial/Lot No.=FIELD(Serial No.);
                      Image=ViewComments }
      { 1102601004;2 ;Separator  }
      { 1102601005;2 ;Action    ;
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
                                 ItemTracingBuffer.SETRANGE("Serial No.","Serial No.");
                                 ItemTracing.InitFilters(ItemTracingBuffer);
                                 ItemTracing.FindRecords;
                                 ItemTracing.RUNMODAL;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102601006;1 ;Action    ;
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
                                 Navigate.SetTracking("Serial No.",'');
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, der kopieres fra tabellen Sporingsspecifikation, n†r der oprettes en record med serienummeroplysninger.;
                           ENU=Specifies the number that is copied from the Tracking Specification table, when a serial number information record is created.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Item No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dette nummer fra tabellen Sporingsspecifikation, n†r der oprettes en record med serienummeroplysninger.;
                           ENU=Specifies this number from the Tracking Specification table when a serial number information record is created.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af recorden med serienummeroplysninger.;
                           ENU=Specifies a description of the serial no. information record.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Description;
                Editable=TRUE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Blocked }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en bem‘rkning er blevet registreret for serienummeret.;
                           ENU=Specifies that a comment has been recorded for the serial number.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Comment }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lagerantallet for det angivne serienummer.;
                           ENU=Specifies the inventory quantity of the specified serial number.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Inventory;
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lagerbeholdningen for serienummeret med en udl›bsdato f›r bogf›ringsdatoen p† det tilknyttede bilag.;
                           ENU=Specifies the inventory of the serial number with an expiration date before the posting date on the associated document.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expired Inventory";
                Visible=FALSE }

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

    [Internal]
    PROCEDURE GetSelectionFilter@4() : Text;
    VAR
      SerialNoInfo@1001 : Record 6504;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(SerialNoInfo);
      EXIT(SelectionFilterManagement.GetSelectionFilterForSerialNoInformation(SerialNoInfo));
    END;

    BEGIN
    END.
  }
}

