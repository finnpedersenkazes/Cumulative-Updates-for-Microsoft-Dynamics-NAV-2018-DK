OBJECT Page 7386 Registered Invt. Movement List
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
    CaptionML=[DAN=Reg. oversigt over flytning (lager);
               ENU=Registered Invt. Movement List];
    SourceTable=Table7344;
    PageType=List;
    CardPageID=Registered Invt. Movement;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bev‘gelse;
                                 ENU=&Movement];
                      Image=CreateMovement }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Registered Invt. Movement),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 22      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7384;
                      RunPageOnRec=Yes;
                      Image=EditLines }
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
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Registreret lageraktivitetshoved.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den lagerflytning, hvorfra aktiviteten blev registreret.;
                           ENU=Specifies the number of the inventory movement from which the activity was registered.];
                ApplicationArea=#Warehouse;
                SourceExpr="Invt. Movement No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Registreret lageraktivitetshoved.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Hdr. table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 7   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 5   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 3   ;1   ;Part      ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

