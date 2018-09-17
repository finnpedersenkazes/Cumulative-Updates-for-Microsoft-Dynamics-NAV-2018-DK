OBJECT Page 9072 IT Operations Activities
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Aktiviteter;
               ENU=Activities];
    SourceTable=Table9059;
    PageType=CardPart;
    RefreshOnActivate=Yes;
    OnOpenPage=VAR
                 DataSensitivity@1000 : Record 2000000159;
                 DataClassificationMgt@1001 : Codeunit 1750;
               BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;

                 DataClassificationMgt.ShowNotifications;

                 DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                 DataSensitivity.SETRANGE("Data Sensitivity",DataSensitivity."Data Sensitivity"::Unclassified);
                 UnclassifiedFields := DataSensitivity.COUNT;

                 SETFILTER("Date Filter2",'<=%1',CREATEDATETIME(TODAY,0T));
                 SETFILTER("Date Filter3",'>%1',CREATEDATETIME(TODAY,0T));
                 SETFILTER("User ID Filter",USERID);
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Ops‘tning;
                           ENU=Administration];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 12      ;0   ;Action    ;
                                  CaptionML=[DAN=Rediger kort til opgavek›poster;
                                             ENU=Edit Job Queue Entry Card];
                                  ToolTipML=[DAN=Skift indstillinger for sagsk›posten.;
                                             ENU=Change the settings for the job queue entry.];
                                  ApplicationArea=#Advanced;
                                  RunObject=Page 673 }
                  { 13      ;0   ;Action    ;
                                  CaptionML=[DAN=Rediger brugerops‘tning;
                                             ENU=Edit User Setup];
                                  ToolTipML=[DAN=Administrer brugere og deres rettigheder.;
                                             ENU=Manage users and their permissions.];
                                  ApplicationArea=#Advanced;
                                  RunObject=Page 119 }
                  { 14      ;0   ;Action    ;
                                  CaptionML=[DAN=Rediger overflytningsoversigt;
                                             ENU=Edit Migration Overview];
                                  ToolTipML=[DAN=F† et overblik over dataoverflytningsopgaver.;
                                             ENU=Get an overview of data migration tasks.];
                                  ApplicationArea=#Advanced;
                                  RunObject=Page 8614 }
                }
                 }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af poster til jobk›en, der vises i administrationsk›indikatoren i Rollecenter. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the number of job queue entries that are displayed in the Administration Cue on the Role Center. The documents are filtered by today's date.];
                ApplicationArea=#Advanced;
                SourceExpr="Job Queue Entries Until Today";
                DrillDownPageID=Job Queue Entries }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver periodenummeret p† de dokumenter, der vises i administrationsk›indikatoren i Rollecenter.;
                           ENU=Specifies the period number of the documents that are displayed in the Administration Cue on the Role Center.];
                ApplicationArea=#Advanced;
                SourceExpr="User Posting Period";
                DrillDownPageID=User Setup }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver periodenummeret i nummerserien for de dokumenter, der vises i administrationsk›indikatoren i Rollecenter. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the period number of the number series for the documents that are displayed in the Administration Cue on the Role Center. The documents are filtered by today's date.];
                ApplicationArea=#Advanced;
                SourceExpr="No. Series Period";
                DrillDownPageID=No. Series Lines }

    { 3   ;1   ;Group     ;
                CaptionML=[DAN=Mine brugeropgaver;
                           ENU=My User Tasks];
                GroupType=CueGroup }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Ventende brugeropgaver;
                           ENU=Pending User Tasks];
                ToolTipML=[DAN=Angiver det antal ventende opgaver, som du er blevet tildelt.;
                           ENU=Specifies the number of pending tasks that are assigned to you.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pending Tasks";
                DrillDownPageID=User Task List;
                Image=Checklist }

    { 4   ;1   ;Group     ;
                CaptionML=[DAN=Beskyttelse af data;
                           ENU=Data Privacy];
                GroupType=CueGroup }

    { 5   ;2   ;Field     ;
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
      UnclassifiedFields@1000 : Integer;

    BEGIN
    END.
  }
}

