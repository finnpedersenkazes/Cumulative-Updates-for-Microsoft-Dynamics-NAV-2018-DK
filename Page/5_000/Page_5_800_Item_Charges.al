OBJECT Page 5800 Item Charges
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varegebyrer;
               ENU=Item Charges];
    SourceTable=Table5800;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,Varegebyr;
                                ENU=New,Process,Report,Item Charge];
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vare&gebyr;
                                 ENU=&Item Charge];
                      Image=Add }
      { 17      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=V‘rdip&oster;
                                 ENU=Value E&ntries];
                      ToolTipML=[DAN=F† vist de bel›b, der er relateret til vare- eller kapacitetsposter for recorden, i bilaget eller p† kladdelinjen.;
                                 ENU=View the amounts related to item or capacity ledger entries for the record on the document or journal line.];
                      ApplicationArea=#ItemCharges;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Item Charge No.);
                      RunPageLink=Entry Type=CONST(Direct Cost),
                                  Item Charge No.=FIELD(No.);
                      Promoted=Yes;
                      Image=ValueLedger;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 19      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#ItemCharges;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5800),
                                  No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
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
                ApplicationArea=#ItemCharges;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af det varegebyrnummer, du opretter.;
                           ENU=Specifies a description of the item charge number that you are setting up.];
                ApplicationArea=#ItemCharges;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varegebyrets produkttype for at knytte transaktioner, der er foretaget for dette varegebyr, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item charge's product type to link transactions made for this item charge with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Gen. Prod. Posting Group" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den momsgruppekode, som varegebyret tilh›rer.;
                           ENU=Specifies the sales tax group code that this item charge belongs to.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Tax Group Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#ItemCharges;
                SourceExpr="VAT Prod. Posting Group" }

    { 1060000;2;Field     ;
                ToolTipML=[DAN=Angiver typen for varegebyr.;
                           ENU=Specifies the type of item charge.];
                SourceExpr="Charge Category" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tekst, der skal s›ges efter, n†r du ikke kender nummeret p† varegebyret.;
                           ENU=Specifies text to search for when you do not know the number of the item charge.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Description" }

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

