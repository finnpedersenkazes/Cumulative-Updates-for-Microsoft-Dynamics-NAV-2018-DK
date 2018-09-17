OBJECT Page 5932 Report Selection - Service
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rapportvalg - service;
               ENU=Report Selection - Service];
    SaveValues=Yes;
    SourceTable=Table77;
    PageType=Worksheet;
    OnOpenPage=BEGIN
                 SetUsageFilter(FALSE);
               END;

    OnNewRecord=BEGIN
                  NewRecord;
                END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 11  ;1   ;Field     ;
                CaptionML=[DAN=Rapporttype;
                           ENU=Usage];
                ToolTipML=[DAN=Angiver den dokumenttype, som rapporten anvendes til.;
                           ENU=Specifies which type of document the report is used for.];
                OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Kontrakttilbud,Kontrakt,Servicedokument - test,Leverance;
                                 ENU=Quote,Order,Invoice,Credit Memo,Contract Quote,Contract,Service Document - Test,Shipment];
                ApplicationArea=#Service;
                SourceExpr=ReportUsage2;
                OnValidate=BEGIN
                             SetUsageFilter(TRUE);
                           END;
                            }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver r‘kkef›lgenummeret p† momsrapporten.;
                           ENU=Specifies the sequence number for the report.];
                ApplicationArea=#Service;
                SourceExpr=Sequence }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens objekt-id.;
                           ENU=Specifies the object ID of the report.];
                ApplicationArea=#Service;
                SourceExpr="Report ID";
                LookupPageID=Objects }

    { 4   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver rapportens viste navn.;
                           ENU=Specifies the display name of the report.];
                ApplicationArea=#Service;
                SourceExpr="Report Caption";
                LookupPageID=Objects }

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
      ReportUsage2@1000 : 'Quote,Order,Invoice,Credit Memo,Contract Quote,Contract,Service Document - Test,Shipment';

    LOCAL PROCEDURE SetUsageFilter@1(ModifyRec@1000 : Boolean);
    BEGIN
      IF ModifyRec THEN
        IF MODIFY THEN;
      FILTERGROUP(2);
      CASE ReportUsage2 OF
        ReportUsage2::Quote:
          SETRANGE(Usage,Usage::"SM.Quote");
        ReportUsage2::Order:
          SETRANGE(Usage,Usage::"SM.Order");
        ReportUsage2::Shipment:
          SETRANGE(Usage,Usage::"SM.Shipment");
        ReportUsage2::Invoice:
          SETRANGE(Usage,Usage::"SM.Invoice");
        ReportUsage2::"Credit Memo":
          SETRANGE(Usage,Usage::"SM.Credit Memo");
        ReportUsage2::"Contract Quote":
          SETRANGE(Usage,Usage::"SM.Contract Quote");
        ReportUsage2::Contract:
          SETRANGE(Usage,Usage::"SM.Contract");
        ReportUsage2::"Service Document - Test":
          SETRANGE(Usage,Usage::"SM.Test");
      END;
      FILTERGROUP(0);
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

