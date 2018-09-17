OBJECT Page 5156 Customer Template List
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
    CaptionML=[DAN=Debitorskabelon - oversigt;
               ENU=Customer Template List];
    SourceTable=Table5105;
    PageType=List;
    CardPageID=Customer Template Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Debitorskabelon;
                                 ENU=&Customer Template];
                      Image=Template }
      { 18      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 19      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=F† vist eller rediger de enkelte s‘t af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5105),
                                  No.=FIELD(Code);
                      Image=Dimensions }
      { 20      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Dimensions;
                      Image=DimensionSets;
                      OnAction=VAR
                                 CustTemplate@1001 : Record 5105;
                                 DefaultDimMultiple@1000 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(CustTemplate);
                                 DefaultDimMultiple.SetMultiCustTemplate(CustTemplate);
                                 DefaultDimMultiple.RUNMODAL;
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
                ToolTipML=[DAN=Angiver koden for debitorskabelonen. Du kan oprette et ubegr‘nset antal koder. Koden skal v‘re entydig. Det vil sige, at du ikke kan bruge den samme kode to gange i samme tabel.;
                           ENU=Specifies the code for the customer template. You can set up as many codes as you want. The code must be unique. You cannot have the same code twice in one table.];
                ApplicationArea=#All;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af debitorskabelonen.;
                           ENU=Specifies the description of the customer template.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontakttypen for debitorskabelonen.;
                           ENU=Specifies the contact type of the customer template.];
                ApplicationArea=#All;
                SourceExpr="Contact Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver distriktskoden for debitorskabelonen.;
                           ENU=Specifies the territory code for the customer template.];
                ApplicationArea=#Advanced;
                SourceExpr="Territory Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for debitorskabelonen.;
                           ENU=Specifies the currency code for the customer template.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

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

    BEGIN
    END.
  }
}

