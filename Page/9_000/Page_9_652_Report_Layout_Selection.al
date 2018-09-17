OBJECT Page 9652 Report Layout Selection
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Valg af rapportlayout;
               ENU=Report Layout Selection];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table9651;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 SelectedCompany := COMPANYNAME;
               END;

    OnFindRecord=BEGIN
                   IF NOT IsInitialized THEN
                     InitializeData;
                   EXIT(FIND(Which));
                 END;

    OnAfterGetRecord=BEGIN
                       GetRec;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           GetRec;
                         END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 4       ;1   ;Action    ;
                      Name=Customizations;
                      CaptionML=[DAN=Brugerdefinerede layout;
                                 ENU=Custom Layouts];
                      ToolTipML=[DAN=Vis eller rediger de brugerdefinerede layout, der er tilg�ngelige for en rapport.;
                                 ENU=View or edit the custom layouts that are available for a report.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9650;
                      RunPageLink=Report ID=FIELD(Report ID);
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process }
      { 9       ;1   ;Action    ;
                      Name=RunReport;
                      CaptionML=[DAN=K�r rapport;
                                 ENU=Run Report];
                      ToolTipML=[DAN=K�r en testrapport.;
                                 ENU=Run a test report.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 REPORT.RUN("Report ID");
                               END;
                                }
      { 14      ;1   ;Action    ;
                      Name=BulkUpdate;
                      CaptionML=[DAN=Opdater alle layout;
                                 ENU=Update All layouts];
                      ToolTipML=[DAN=Opdater specifikke rapportlayout eller alle tilpassede rapportlayout, der kunne blive p�virket af datas�t�ndringer.;
                                 ENU=Update specific report layouts or all custom report layouts that might be affected by dataset changes.];
                      ApplicationArea=#Basic,#Suite;
                      Image=UpdateXML;
                      OnAction=VAR
                                 DocumentReportMgt@1000 : Codeunit 9651;
                               BEGIN
                                 DocumentReportMgt.BulkUpgrade(FALSE);
                               END;
                                }
      { 16      ;1   ;Action    ;
                      Name=TestUpdate;
                      CaptionML=[DAN=Opdateringer af testlayout;
                                 ENU=Test Layout Updates];
                      ToolTipML=[DAN=Kontroll�r, om der er registreret nogen opdateringer.;
                                 ENU=Check if there are any updates detected.];
                      ApplicationArea=#Basic,#Suite;
                      Image=TestReport;
                      OnAction=VAR
                                 DocumentReportMgt@1000 : Codeunit 9651;
                               BEGIN
                                 DocumentReportMgt.BulkUpgrade(TRUE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 11  ;0   ;Container ;
                ContainerType=ContentArea }

    { 10  ;1   ;Group     ;
                CaptionML=[DAN=Virksomhed;
                           ENU=Company];
                GroupType=Group }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Virksomhedsnavn;
                           ENU=Company Name];
                ToolTipML=[DAN=Angiver det virksomhedsnavn, der bruges til rapporten.;
                           ENU=Specifies the name of the company that is used for the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SelectedCompany;
                TableRelation=Company;
                Importance=Promoted;
                OnValidate=BEGIN
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens objekt-id.;
                           ENU=Specifies the object ID of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report ID";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� rapporten.;
                           ENU=Specifies the name of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Name";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Valgt layout;
                           ENU=Selected Layout];
                ToolTipML=[DAN=Angiver det rapportlayout, der aktuelt bruges p� rapporten.;
                           ENU=Specifies the report layout that is currently used on the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type;
                OnValidate=BEGIN
                             UpdateRec;
                             COMMIT;
                             LookupCustomLayout;
                           END;
                            }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det brugerdefinerede rapportlayout.;
                           ENU=Specifies the custom report layout.];
                ApplicationArea=#Advanced;
                SourceExpr="Custom Report Layout Code";
                TableRelation="Custom Report Layout" WHERE (Report ID=FIELD(Report ID));
                Visible=FALSE;
                OnValidate=BEGIN
                             ReportLayoutSelection.VALIDATE("Custom Report Layout Code",ReportLayoutSelection."Custom Report Layout Code");
                             UpdateRec;
                           END;
                            }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Beskrivelse af brugerdefineret layout;
                           ENU=Custom Layout Description];
                ToolTipML=[DAN=Angiver beskrivelsen af et brugerdefineret layout, der bruges af rapporten, n�r feltet Valgt layout er angivet til Brugerdefineret.;
                           ENU=Specifies the description for a custom layout that is used by the report when the Selected Layout field is set to Custom.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CustomLayoutDescription;
                OnValidate=VAR
                             CustomReportLayout2@1000 : Record 9650;
                           BEGIN
                             CustomReportLayout2.SETCURRENTKEY("Report ID","Company Name",Type);
                             CustomReportLayout2.SETRANGE("Report ID",ReportLayoutSelection."Report ID");
                             CustomReportLayout2.SETFILTER("Company Name",'%1|%2','',SelectedCompany);
                             CustomReportLayout2.SETFILTER(
                               Description,STRSUBSTNO('@*%1*',CustomLayoutDescription));
                             IF NOT CustomReportLayout2.FINDFIRST THEN
                               ERROR(CouldNotFindCustomReportLayoutErr,CustomLayoutDescription);

                             IF CustomReportLayout2.Code <> "Custom Report Layout Code" THEN BEGIN
                               VALIDATE("Custom Report Layout Code",CustomReportLayout2.Code);
                               UpdateRec;
                             END;
                             CurrPage.UPDATE(FALSE);
                           END;

                OnLookup=BEGIN
                           LookupCustomLayout;
                         END;
                          }

    { 8   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 7   ;1   ;Part      ;
                CaptionML=[DAN=Brugerdefinerede layout;
                           ENU=Custom Layouts];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Report ID=FIELD(Report ID);
                PagePartID=Page9653;
                PartType=Page;
                ShowFilter=No;
                UpdatePropagation=Both }

  }
  CODE
  {
    VAR
      ReportLayoutSelection@1000 : Record 9651;
      SelectedCompany@1004 : Text[30];
      WrongCompanyErr@1005 : TextConst 'DAN=Du kan ikke v�lge et layout, der g�lder specifikt for en anden virksomhed.;ENU=You cannot select a layout that is specific to another company.';
      CustomLayoutDescription@1002 : Text;
      IsInitialized@1001 : Boolean;
      CouldNotFindCustomReportLayoutErr@1003 : TextConst '@@@=%1 Description of custom report layout;DAN=Der er intet brugerdefineret rapportlayout med %1 i beskrivelsen.;ENU=There is no custom report layout with %1 in the description.';

    LOCAL PROCEDURE UpdateRec@18();
    BEGIN
      IF ReportLayoutSelection.GET("Report ID",SelectedCompany) THEN BEGIN
        ReportLayoutSelection := Rec;
        ReportLayoutSelection."Report Name" := '';
        ReportLayoutSelection."Company Name" := SelectedCompany;
        ReportLayoutSelection.MODIFY;
      END ELSE BEGIN
        CLEAR(ReportLayoutSelection);
        ReportLayoutSelection := Rec;
        ReportLayoutSelection."Report Name" := '';
        ReportLayoutSelection."Company Name" := SelectedCompany;
        ReportLayoutSelection.INSERT(TRUE);
      END;
    END;

    LOCAL PROCEDURE GetRec@2();
    BEGIN
      IF NOT GET("Report ID",'') THEN
        EXIT;
      IF NOT ReportLayoutSelection.GET("Report ID",SelectedCompany) THEN BEGIN
        ReportLayoutSelection.INIT;
        ReportLayoutSelection.Type := GetDefaultType("Report ID");
      END;
      Type := ReportLayoutSelection.Type;
      "Custom Report Layout Code" := ReportLayoutSelection."Custom Report Layout Code";
      CALCFIELDS("Report Layout Description");
      CustomLayoutDescription := "Report Layout Description";
      MODIFY;
    END;

    LOCAL PROCEDURE LookupCustomLayout@5();
    BEGIN
      IF Type <> Type::"Custom Layout" THEN
        EXIT;

      IF NOT SelectReportLayout THEN
        EXIT;

      GetRec;
      IF (Type = Type::"Custom Layout") AND
         ("Custom Report Layout Code" = '')
      THEN BEGIN
        VALIDATE(Type,GetDefaultType("Report ID"));
        UpdateRec;
      END;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE SelectReportLayout@3() : Boolean;
    VAR
      CustomReportLayout2@1000 : Record 9650;
      OK@1001 : Boolean;
    BEGIN
      CustomReportLayout2.FILTERGROUP(4);
      CustomReportLayout2.SETRANGE("Report ID","Report ID");
      CustomReportLayout2.FILTERGROUP(0);
      CustomReportLayout2.SETFILTER("Company Name",'%1|%2',SelectedCompany,'');
      OK := PAGE.RUNMODAL(PAGE::"Custom Report Layouts",CustomReportLayout2) = ACTION::LookupOK;
      IF OK THEN BEGIN
        IF CustomReportLayout2.FIND THEN BEGIN
          IF NOT (CustomReportLayout2."Company Name" IN [SelectedCompany,'']) THEN
            ERROR(WrongCompanyErr);
          "Custom Report Layout Code" := CustomReportLayout2.Code;
          Type := Type::"Custom Layout";
          UpdateRec;
        END
      END ELSE
        IF Type = Type::"Custom Layout" THEN
          IF CustomReportLayout2.ISEMPTY THEN BEGIN
            Type := GetDefaultType("Report ID");
            "Custom Report Layout Code" := '';
            UpdateRec;
          END;
      EXIT(OK);
    END;

    LOCAL PROCEDURE InitializeData@1();
    VAR
      ReportMetadata@1000 : Record 2000000139;
    BEGIN
      ReportMetadata.SETRANGE(ProcessingOnly,FALSE);
      IF ReportMetadata.FINDSET THEN
        REPEAT
          INIT;
          "Report ID" := ReportMetadata.ID;
          "Report Name" := ReportMetadata.Caption;
          INSERT;
        UNTIL ReportMetadata.NEXT = 0;
      IF FINDFIRST THEN;
      IsInitialized := TRUE;
    END;

    BEGIN
    END.
  }
}

