OBJECT Page 9062 User Security Activities
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Brugersikkerhedsaktiviteter;
               ENU=User Security Activities];
    SourceTable=Table9062;
    PageType=CardPart;
    RefreshOnActivate=Yes;
    OnOpenPage=VAR
                 UserSecurityStatus@1000 : Record 9062;
                 DataSensitivity@1003 : Record 2000000159;
                 PermissionManager@1001 : Codeunit 9002;
                 RoleCenterNotificationMgt@1002 : Codeunit 1430;
               BEGIN
                 SoftwareAsAService := PermissionManager.SoftwareAsAService;
                 IF SoftwareAsAService THEN
                   NumberOfPlans := GetNumberOfPlans;
                 UserSecurityStatus.LoadUsers;
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;

                 DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                 DataSensitivity.SETRANGE("Data Sensitivity",DataSensitivity."Data Sensitivity"::Unclassified);
                 UnclassifiedFields := DataSensitivity.COUNT;

                 RoleCenterNotificationMgt.ShowNotifications;

                 IF PageNotifier.IsAvailable THEN BEGIN
                   PageNotifier := PageNotifier.Create;
                   PageNotifier.NotifyPageReady;
                 END;
               END;

    OnAfterGetCurrRecord=VAR
                           RoleCenterNotificationMgt@1000 : Codeunit 1430;
                         BEGIN
                           RoleCenterNotificationMgt.HideEvaluationNotificationAfterStartingTrial;
                         END;

  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                CaptionML=[DAN=CueContainer;
                           ENU=CueContainer];
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Brugersikkerhed;
                           ENU=User Security];
                GroupType=CueGroup }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Brugere - til gennemsyn;
                           ENU=Users - To review];
                ToolTipML=[DAN=Angiver nye brugere, som endnu ikke er gennemset af en administrator.;
                           ENU=Specifies new users who have not yet been reviewed by an administrator.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Users - To review";
                Editable=FALSE;
                DrillDownPageID=User Security Status List }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Brugere - uden abonnementsplaner;
                           ENU=Users - Without Subscription Plans];
                ToolTipML=[DAN=Angiver, at brugere uden abonnement skal bruge Dynamics NAV.;
                           ENU=Specifies users without subscription to use Dynamics NAV.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Users - Without Subscriptions";
                Visible=SoftwareAsAService;
                Editable=FALSE;
                DrillDownPageID=User Security Status List }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Brugere - ikke gruppemedlemmer;
                           ENU=Users - Not Group Members];
                ToolTipML=[DAN=Angiver brugere, som endnu ikke er gennemset af en administrator.;
                           ENU=Specifies users who have not yet been reviewed by an administrator.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Users - Not Group Members";
                Visible=SoftwareAsAService;
                Editable=FALSE;
                DrillDownPageID=User Security Status List }

    { 6   ;2   ;Field     ;
                Name=NumberOfPlans;
                CaptionML=[DAN=Antal planer;
                           ENU=Number of plans];
                ToolTipML=[DAN=Angiver antallet af planer.;
                           ENU=Specifies the number of plans.];
                ApplicationArea=#Advanced;
                SourceExpr=NumberOfPlans;
                Visible=SoftwareAsAService;
                OnDrillDown=VAR
                              Plan@1000 : Record 9004;
                            BEGIN
                              IF NOT SoftwareAsAService THEN
                                EXIT;
                              PAGE.RUN(PAGE::Plans,Plan)
                            END;
                             }

    { 9   ;1   ;Group     ;
                CaptionML=[DAN=Beskyttelse af data;
                           ENU=Data Privacy];
                GroupType=CueGroup }

    { 7   ;2   ;Field     ;
                Name=UnclassifiedFields;
                CaptionML=[DAN=Felter uden dataf›lsomhed;
                           ENU=Fields Missing Data Sensitivity];
                ToolTipML=[DAN=Angiver nummerfelterne, hvor dataf›lsomheden er angivet som ikke-klassificeret.;
                           ENU=Specifies the number fields with Data Sensitivity set to unclassified.];
                ApplicationArea=#All;
                SourceExpr=UnclassifiedFields;
                OnDrillDown=VAR
                              DataSensitivity@1000 : Record 2000000159;
                            BEGIN
                              DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                              DataSensitivity.SETRANGE("Data Sensitivity",DataSensitivity."Data Sensitivity"::Unclassified);
                              PAGE.RUN(PAGE::"Data Classification Worksheet",DataSensitivity);
                            END;
                             }

  }
  CODE
  {
    VAR
      PageNotifier@1002 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.PageNotifier" WITHEVENTS RUNONCLIENT;
      SoftwareAsAService@1000 : Boolean;
      NumberOfPlans@1001 : Integer;
      UnclassifiedFields@1003 : Integer;

    LOCAL PROCEDURE GetNumberOfPlans@9() : Integer;
    VAR
      Plan@1001 : Record 9004;
    BEGIN
      IF NOT SoftwareAsAService THEN
        EXIT(0);
      EXIT(Plan.COUNT);
    END;

    EVENT PageNotifier@1002::PageReady@9();
    VAR
      NetPromoterScoreMgt@1000 : Codeunit 1432;
    BEGIN
      NetPromoterScoreMgt.ShowNpsDialog;
    END;

    BEGIN
    END.
  }
}

