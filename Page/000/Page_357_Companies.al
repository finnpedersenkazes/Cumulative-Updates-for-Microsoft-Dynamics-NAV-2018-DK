OBJECT Page 357 Companies
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783,NAVDK11.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Regnskabsoversigt;
               ENU=Companies];
    SourceTable=Table2000000006;
    PageType=List;
    RefreshOnActivate=Yes;
    OnInit=VAR
             ApplicationAreaSetup@1001 : Record 9178;
             PermissionManager@1000 : Codeunit 9002;
           BEGIN
             SoftwareAsAService := PermissionManager.SoftwareAsAService;
             IsFoundation := ApplicationAreaSetup.IsFoundationEnabled;
           END;

    OnAfterGetRecord=VAR
                       AssistedCompanySetupStatus@1000 : Record 1802;
                     BEGIN
                       IF AssistedCompanySetupStatus.GET(Name) THEN
                         EnableAssistedCompanySetup := AssistedCompanySetupStatus.Enabled
                       ELSE
                         EnableAssistedCompanySetup := FALSE;
                       SetupStatus := AssistedCompanySetupStatus.GetCompanySetupStatus(Name);
                     END;

    OnNewRecord=BEGIN
                  EnableAssistedCompanySetup := FALSE;
                END;

    OnInsertRecord=BEGIN
                     IF SoftwareAsAService THEN
                       ERROR(InsertNotAllowedErr);
                   END;

    OnDeleteRecord=VAR
                     AssistedCompanySetupStatus@1000 : Record 1802;
                   BEGIN
                     IF SoftwareAsAService AND (COUNT = 1) THEN BEGIN
                       MESSAGE(DeleteLastCompanyMsg);
                       ERROR('');
                     END;

                     IF NOT CONFIRM(DeleteCompanyQst,FALSE) THEN
                       EXIT(FALSE);

                     IF AssistedCompanySetupStatus.GET(Name) THEN
                       AssistedCompanySetupStatus.DELETE;

                     EXIT(TRUE);
                   END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;Action    ;
                      Name=Create New Company;
                      AccessByPermission=TableData 2000000006=I;
                      CaptionML=[DAN=Opret ny virksomhed;
                                 ENU=Create New Company];
                      ToolTipML=[DAN=F† hj‘lp til at oprette en ny virksomhed.;
                                 ENU=Get assistance with creating a new company.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=SoftwareAsAService;
                      PromotedIsBig=Yes;
                      Image=Company;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 // Action invoked through event subscriber to avoid hard coupling to other objects,
                                 // as this page is part of the Cloud Manager.
                               END;
                                }
      { 4       ;1   ;Action    ;
                      Name=CopyCompany;
                      CaptionML=[DAN=Kopi‚r;
                                 ENU=Copy];
                      ToolTipML=[DAN=Kopierer en eksisterende virksomhed til en ny virksomhed.;
                                 ENU=Copy an existing company to a new company.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=No;
                      Image=Copy;
                      OnAction=VAR
                                 Company@1000 : Record 2000000006;
                                 CopyCompany@1001 : Report 357;
                               BEGIN
                                 Company.SETRANGE(Name,Name);
                                 CopyCompany.SETTABLEVIEW(Company);
                                 CopyCompany.RUNMODAL;

                                 IF GET(CopyCompany.GetCompanyName) THEN;
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
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† en virksomhed, der er oprettet i den aktuelle database.;
                           ENU=Specifies the name of a company that has been created in the current database.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet, der skal vises for virksomheden i brugergr‘nsefladen i stedet for den tekst, der er angivet i feltet Navn.;
                           ENU=Specifies the name to display for the company in the user interface instead of the text that is specified in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Display Name" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver, at virksomheden kun er beregnet til pr›vebrug, og at der ikke er k›bt et abonnement. ";
                           ENU="Specifies that the company is for trial purposes only, and that a subscription has not been purchased. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Evaluation Company";
                Visible=IsFoundation;
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                Name=SetupStatus;
                CaptionML=[DAN=Status for ops‘tning;
                           ENU=Setup Status];
                ToolTipML=[DAN=Angiver statussen for ops‘tning af virksomheden.;
                           ENU=Specifies the setup status of the company.];
                OptionCaptionML=[DAN=" ,Afsluttet,Igangv‘rende,Fejl,Manglende rettighed";
                                 ENU=" ,Completed,In Progress,Error,Missing Permission"];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SetupStatus;
                Editable=FALSE;
                OnDrillDown=VAR
                              AssistedCompanySetupStatus@1000 : Record 1802;
                            BEGIN
                              AssistedCompanySetupStatus.DrillDownSetupStatus(Name);
                            END;
                             }

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
      DeleteCompanyQst@1000 : TextConst 'DAN=Vil du slette virksomheden?\Alle virksomhedsdata bliver slettet.\\Vil du forts‘tte?;ENU=Do you want to delete the company?\All company data will be deleted.\\Do you want to continue?';
      SetupStatus@1004 : ' ,Completed,In Progress,Error,Missing Permission';
      EnableAssistedCompanySetup@1001 : Boolean;
      SoftwareAsAService@1002 : Boolean;
      InsertNotAllowedErr@1003 : TextConst 'DAN=Hvis du vil oprette en ny virksomhed, skal du v‘lge knappen Opret ny virksomhed. En assisteret ops‘tningsguide sikrer, at du f†r alt, hvad du skal bruge, for at komme i gang.;ENU=To create a new company, choose the Create New Company button. An assisted setup guide will make sure you get everything you need to get started.';
      DeleteLastCompanyMsg@1005 : TextConst 'DAN=Kan ikke slette denne virksomhed. Det er den eneste virksomhed, du har, og du skal have mindst ‚n.;ENU=Cannot delete this company. It''s the only company you have, and you must have at least one.';
      IsFoundation@1006 : Boolean;

    BEGIN
    END.
  }
}

