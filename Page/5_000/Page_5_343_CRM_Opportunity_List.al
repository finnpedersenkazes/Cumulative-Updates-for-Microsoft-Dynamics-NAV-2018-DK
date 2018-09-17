OBJECT Page 5343 CRM Opportunity List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Salgsmuligheder - Microsoft Dynamics 365 for Sales;
               ENU=Opportunities - Microsoft Dynamics 365 for Sales];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5343;
    SourceTableView=SORTING(Name);
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Dynamics 365 for Sales;
                                ENU=New,Process,Report,Dynamics 365 for Sales];
    OnInit=BEGIN
             CODEUNIT.RUN(CODEUNIT::"CRM Integration Management");
           END;

    OnAfterGetRecord=VAR
                       CRMIntegrationRecord@1001 : Record 5331;
                       RecordID@1000 : RecordID;
                     BEGIN
                       IF CRMIntegrationRecord.FindRecordIDFromID(OpportunityId,DATABASE::Opportunity,RecordID) THEN
                         IF CurrentlyCoupledCRMOpportunity.OpportunityId = OpportunityId THEN BEGIN
                           Coupled := 'Current';
                           FirstColumnStyle := 'Strong';
                         END ELSE BEGIN
                           Coupled := 'Yes';
                           FirstColumnStyle := 'Subordinate';
                         END
                       ELSE BEGIN
                         Coupled := 'No';
                         FirstColumnStyle := 'None';
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 13      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales] }
      { 14      ;2   ;Action    ;
                      Name=CRMGotoOpportunities;
                      CaptionML=[DAN=Salgsmulighed;
                                 ENU=Opportunity];
                      ToolTipML=[DAN=Angiver den salgsmulighed, der er sammenkëdet med Dynamics 365 for Sales-salgsmuligheden.;
                                 ENU=Specifies the sales opportunity that is coupled to this Dynamics 365 for Sales opportunity.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=CoupledOpportunity;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 HYPERLINK(CRMIntegrationManagement.GetCRMEntityUrlFromCRMID(DATABASE::"CRM Opportunity",OpportunityId));
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Status;
                           ENU=Status];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                OptionCaptionML=[DAN=èben,Vundet,Tabt;
                                 ENU=Open,Won,Lost];
                ApplicationArea=#Suite;
                SourceExpr=StateCode }

    { 16  ;2   ;Field     ;
                CaptionML=[DAN=StatusÜrsag;
                           ENU=Status Reason];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                OptionCaptionML=[DAN=" ,Igangvërende,Afvent,Vundet,Annulleret,Udsolgt";
                                 ENU=" ,In Progress,On Hold,Won,Canceled,Out-Sold"];
                ApplicationArea=#Suite;
                SourceExpr=StatusCode }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Emne;
                           ENU=Topic];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                ApplicationArea=#Suite;
                SourceExpr=Name;
                StyleExpr=FirstColumnStyle }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=AnslÜet ultimodato;
                           ENU=Est. Close Date];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                ApplicationArea=#Suite;
                SourceExpr=EstimatedCloseDate }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=AnslÜet omsëtning;
                           ENU=Est. Revenue];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                ApplicationArea=#Suite;
                SourceExpr=EstimatedValue }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Totale belõb;
                           ENU=Total Amount];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                ApplicationArea=#Suite;
                SourceExpr=TotalAmount }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontaktnavn;
                           ENU=Contact Name];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                ApplicationArea=#Suite;
                SourceExpr=ParentContactIdName }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Kontonavn;
                           ENU=Account Name];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                ApplicationArea=#Suite;
                SourceExpr=ParentAccountIdName }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Sandsynlighed;
                           ENU=Probability];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                ApplicationArea=#Suite;
                SourceExpr=CloseProbability }

    { 11  ;2   ;Field     ;
                CaptionML=[DAN=Vurdering;
                           ENU=Rating];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                OptionCaptionML=[DAN=Lovende,Varm,Kold;
                                 ENU=Hot,Warm,Cold];
                ApplicationArea=#Suite;
                SourceExpr=OpportunityRatingCode }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Behov;
                           ENU=Need];
                ToolTipML=[DAN=Angiver data fra et tilsvarende felt i en Dynamics 365 for Sales-enhed. Du kan finde flere oplysninger om Dynamics 365 for Sales i Dynamics 365 for Sales Hjëlp-center.;
                           ENU=Specifies data from a corresponding field in a Dynamics 365 for Sales entity. For more information about Dynamics 365 for Sales, see Dynamics 365 for Sales Help Center.];
                OptionCaptionML=[DAN=" ,Skal have,Bõr have,God at have,Ikke nõdvendig";
                                 ENU=" ,Must have,Should have,Good to have,No need"];
                ApplicationArea=#Suite;
                SourceExpr=Need }

    { 18  ;2   ;Field     ;
                Name=Coupled;
                CaptionML=[DAN=Sammenkëdet;
                           ENU=Coupled];
                ToolTipML=[DAN=Angiver, om Dynamics 365 for Sales-recorden er sammenkëdet med Dynamics NAV.;
                           ENU=Specifies if the Dynamics 365 for Sales record is coupled to Dynamics NAV.];
                ApplicationArea=#Suite;
                SourceExpr=Coupled }

  }
  CODE
  {
    VAR
      CurrentlyCoupledCRMOpportunity@1002 : Record 5343;
      Coupled@1001 : Text;
      FirstColumnStyle@1000 : Text;

    [External]
    PROCEDURE SetCurrentlyCoupledCRMOpportunity@2(CRMOpportunity@1000 : Record 5343);
    BEGIN
      CurrentlyCoupledCRMOpportunity := CRMOpportunity;
    END;

    BEGIN
    END.
  }
}

