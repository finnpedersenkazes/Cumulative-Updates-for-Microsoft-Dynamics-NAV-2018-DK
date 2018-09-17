OBJECT Page 744 VAT Report List
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
    CaptionML=[DAN=Momsangivelser;
               ENU=VAT Returns];
    DeleteAllowed=No;
    SourceTable=Table740;
    SourceTableView=WHERE(VAT Report Config. Code=CONST(VAT Return));
    PageType=List;
    CardPageID=VAT Report;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 18      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Basic,#Suite;
                      Image=EditLines;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"VAT Report",Rec);
                               END;
                                }
      { 3       ;1   ;Action    ;
                      Name=Report Setup;
                      CaptionML=[DAN=Rapportops‘tning;
                                 ENU=Report Setup];
                      ToolTipML=[DAN=Angiver den ops‘tning, der skal bruges til afsendelse af momsrapporter.;
                                 ENU=Specifies the setup that will be used for the VAT reports submission.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 743;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Setup }
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
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante konfigurationskode.;
                           ENU=Specifies the appropriate configuration code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Report Config. Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om momsrapporten er en standardrapport, eller hvis den er relateret til en tidligere afsendt momsrapport.;
                           ENU=Specifies if the VAT report is a standard report, or if it is related to a previously submitted VAT report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Report Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for rapportperioden i momsrapporten.;
                           ENU=Specifies the start date of the report period for the VAT report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Start Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for rapportperioden i momsrapporten.;
                           ENU=Specifies the end date of the report period for the VAT report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="End Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for momsrapporten.;
                           ENU=Specifies the status of the VAT report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status }

  }
  CODE
  {

    BEGIN
    END.
  }
}

