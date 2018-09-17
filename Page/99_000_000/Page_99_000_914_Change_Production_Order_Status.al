OBJECT Page 99000914 Change Production Order Status
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Skift prod.ordrestatus;
               ENU=Change Production Order Status];
    SourceTable=Table5405;
    PageType=Worksheet;
    OnOpenPage=BEGIN
                 BuildForm;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=Pro&d.ordre;
                                 ENU=Pro&d. Order];
                      Image=Order }
      { 49      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Poster;
                                 ENU=E&ntries];
                      Image=Entries }
      { 50      ;3   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Vareposter;
                                 ENU=Item Ledger E&ntries];
                      ToolTipML=[DAN=Vis vareposterne for varen p† bilaget eller kladdelinjen.;
                                 ENU=View the item ledger entries of the item on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      Image=ItemLedger;
                      OnAction=VAR
                                 ItemLedgEntry@1000 : Record 32;
                               BEGIN
                                 IF Status <> Status::Released THEN
                                   EXIT;

                                 ItemLedgEntry.RESET;
                                 ItemLedgEntry.SETCURRENTKEY("Order Type","Order No.");
                                 ItemLedgEntry.SETRANGE("Order Type",ItemLedgEntry."Order Type"::Production);
                                 ItemLedgEntry.SETRANGE("Order No.","No.");
                                 PAGE.RUNMODAL(0,ItemLedgEntry);
                               END;
                                }
      { 51      ;3   ;Action    ;
                      CaptionML=[DAN=Kapacitetsposter;
                                 ENU=Capacity Ledger Entries];
                      ToolTipML=[DAN=Vis kapacitetsposterne for den involverede produktionsordre. Kapaciteten registreres enten som tid (operationstid, stoptid eller opstillingstid) eller som antal (spildantal eller afgangsantal).;
                                 ENU=View the capacity ledger entries of the involved production order. Capacity is recorded either as time (run time, stop time, or setup time) or as quantity (scrap quantity or output quantity).];
                      ApplicationArea=#Manufacturing;
                      Image=CapacityLedger;
                      OnAction=VAR
                                 CapLedgEntry@1000 : Record 5832;
                               BEGIN
                                 IF Status <> Status::Released THEN
                                   EXIT;

                                 CapLedgEntry.RESET;
                                 CapLedgEntry.SETCURRENTKEY("Order Type","Order No.");
                                 CapLedgEntry.SETRANGE("Order Type",CapLedgEntry."Order Type"::Production);
                                 CapLedgEntry.SETRANGE("Order No.","No.");
                                 PAGE.RUNMODAL(0,CapLedgEntry);
                               END;
                                }
      { 52      ;3   ;Action    ;
                      CaptionML=[DAN=V‘rdiposter;
                                 ENU=Value Entries];
                      ToolTipML=[DAN=Vis v‘rdiposterne for varen p† bilags- eller kladdelinjen.;
                                 ENU=View the value entries of the item on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      Image=ValueLedger;
                      OnAction=VAR
                                 ValueEntry@1000 : Record 5802;
                               BEGIN
                                 IF Status <> Status::Released THEN
                                   EXIT;

                                 ValueEntry.RESET;
                                 ValueEntry.SETCURRENTKEY("Order Type","Order No.");
                                 ValueEntry.SETRANGE("Order Type",ValueEntry."Order Type"::Production);
                                 ValueEntry.SETRANGE("Order No.","No.");
                                 PAGE.RUNMODAL(0,ValueEntry);
                               END;
                                }
      { 53      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000838;
                      RunPageLink=Status=FIELD(Status),
                                  Prod. Order No.=FIELD(No.);
                      Image=ViewComments }
      { 54      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 56      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000816;
                      RunPageLink=Status=FIELD(Status),
                                  No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 40      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 41      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Skift &status;
                                 ENU=Change &Status];
                      ToolTipML=[DAN=Skift produktionsordren til en anden status, f.eks. frigivet.;
                                 ENU=Change the production order to another status, such as Released.];
                      ApplicationArea=#Manufacturing;
                      Image=ChangeStatus;
                      OnAction=VAR
                                 ProdOrderStatusMgt@1004 : Codeunit 5407;
                                 ChangeStatusForm@1000 : Page 99000882;
                                 Window@1005 : Dialog;
                                 NewStatus@1006 : 'Simulated,Planned,Firm Planned,Released,Finished';
                                 NewPostingDate@1007 : Date;
                                 NewUpdateUnitCost@1008 : Boolean;
                                 NoOfRecords@1009 : Integer;
                                 POCount@1010 : Integer;
                                 LocalText000@1011 : TextConst 'DAN=Simuleret,Planlagt,Fastlagt,Frigivet,Udf›rt;ENU=Simulated,Planned,Firm Planned,Released,Finished';
                               BEGIN
                                 ChangeStatusForm.Set(Rec);

                                 IF ChangeStatusForm.RUNMODAL <> ACTION::Yes THEN
                                   EXIT;

                                 ChangeStatusForm.ReturnPostingInfo(NewStatus,NewPostingDate,NewUpdateUnitCost);

                                 NoOfRecords := COUNT;

                                 Window.OPEN(
                                   STRSUBSTNO(Text000,SELECTSTR(NewStatus + 1,LocalText000)) +
                                   Text001);

                                 POCount := 0;

                                 IF FIND('-') THEN
                                   REPEAT
                                     POCount := POCount + 1;
                                     Window.UPDATE(1,"No.");
                                     Window.UPDATE(2,ROUND(POCount / NoOfRecords * 10000,1));
                                     ProdOrderStatusMgt.ChangeStatusOnProdOrder(
                                       Rec,NewStatus,NewPostingDate,NewUpdateUnitCost);
                                     COMMIT;
                                   UNTIL NEXT = 0;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 29  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Statusfilter;
                           ENU=Status Filter];
                ToolTipML=[DAN=Angiver status for produktionsordrerne for at definere et filter p† linjerne.;
                           ENU=Specifies the status of the production orders to define a filter on the lines.];
                OptionCaptionML=[DAN=Simuleret,Planlagt,Fastlagt,Frigivet;
                                 ENU=Simulated,Planned,Firm Planned,Released];
                ApplicationArea=#Manufacturing;
                SourceExpr=ProdOrderStatus;
                OnValidate=BEGIN
                             ProdOrderStatusOnAfterValidate;
                           END;
                            }

    { 32  ;2   ;Field     ;
                CaptionML=[DAN=Skal starte f›r;
                           ENU=Must Start Before];
                ToolTipML=[DAN=Angiver en dato for at definere et filter p† linjerne.;
                           ENU=Specifies a date to define a filter on the lines.];
                ApplicationArea=#Manufacturing;
                SourceExpr=StartingDate;
                OnValidate=BEGIN
                             StartingDateOnAfterValidate;
                           END;
                            }

    { 46  ;2   ;Field     ;
                CaptionML=[DAN=Slutter f›r;
                           ENU=Ends Before];
                ToolTipML=[DAN=Angiver en dato for at definere et filter p† linjerne.;
                           ENU=Specifies a date to define a filter on the lines.];
                ApplicationArea=#Manufacturing;
                SourceExpr=EndingDate;
                OnValidate=BEGIN
                             EndingDateOnAfterValidate;
                           END;
                            }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af produktionsordren.;
                           ENU=Specifies the description of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du oprettede produktionsordren.;
                           ENU=Specifies the date on which you created the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Creation Date" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kildetypen for produktionsordren.;
                           ENU=Specifies the source type of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Source Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Source No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for produktionsordren.;
                           ENU=Specifies the starting time of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for produktionsordren.;
                           ENU=Specifies the starting date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl‘ttet for produktionsordren.;
                           ENU=Specifies the ending time of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for produktionsordren.;
                           ENU=Specifies the ending date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for produktionsordren.;
                           ENU=Specifies the due date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Due Date" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den faktiske f‘rdigg›relsesdato for en produktionsordre.;
                           ENU=Specifies the actual finishing date of a finished production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Finished Date" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Skifter status til %1...\\;ENU=Changing status to %1...\\';
      Text001@1001 : TextConst 'DAN=Prod.ordre  #1###### @2@@@@@@@@@@@@@;ENU=Prod. Order #1###### @2@@@@@@@@@@@@@';
      ProdOrderStatus@1002 : 'Simulated,Planned,Firm Planned,Released';
      StartingDate@1003 : Date;
      EndingDate@1004 : Date;

    LOCAL PROCEDURE BuildForm@1();
    BEGIN
      FILTERGROUP(2);
      SETRANGE(Status,ProdOrderStatus);
      FILTERGROUP(0);

      IF StartingDate <> 0D THEN
        SETFILTER("Starting Date",'..%1',StartingDate)
      ELSE
        SETRANGE("Starting Date");

      IF EndingDate <> 0D THEN
        SETFILTER("Ending Date",'..%1',EndingDate)
      ELSE
        SETRANGE("Ending Date");

      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ProdOrderStatusOnAfterValidate@19066920();
    BEGIN
      BuildForm;
    END;

    LOCAL PROCEDURE StartingDateOnAfterValidate@19020273();
    BEGIN
      BuildForm;
    END;

    LOCAL PROCEDURE EndingDateOnAfterValidate@19076447();
    BEGIN
      BuildForm;
    END;

    BEGIN
    END.
  }
}

