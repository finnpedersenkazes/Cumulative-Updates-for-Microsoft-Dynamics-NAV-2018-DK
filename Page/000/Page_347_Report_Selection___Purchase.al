OBJECT Page 347 Report Selection - Purchase
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rapportvalg - k�b;
               ENU=Report Selection - Purchase];
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
                ToolTipML=[DAN=Angiver dokumenttypen, hvortil rapporten anvendes.;
                           ENU=Specifies which type of document the report is used for.];
                OptionCaptionML=[DAN=Tilbud,Rammeordre,Ordre,Faktura,Returvareordre,Kreditnota,Modtagelse,Returvareleverance,K�bsdokument - kontrol,Forudbetalingsdokument - kontrol,K.ark.tilbud,K.ark.ordre,K.ark.ret.ordre;
                                 ENU=Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Receipt,Return Shipment,Purchase Document - Test,Prepayment Document - Test,P.Arch. Quote,P.Arch. Order,P. Arch. Return Order];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ReportUsage2;
                OnValidate=BEGIN
                             SetUsageFilter(TRUE);
                           END;
                            }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket nummer i udskrivningsr�kkef�lgen den aktuelle rapport har.;
                           ENU=Specifies a number that indicates where this report is in the printing order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Sequence }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens objekt-id.;
                           ENU=Specifies the object ID of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report ID";
                LookupPageID=Objects }

    { 4   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver rapportens viste navn.;
                           ENU=Specifies the display name of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Caption" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opsummerede oplysninger, f.eks. fakturanummer, forfaldsdato og tilknytning til betalingstjeneste, inds�ttes i meddelelsesteksten p� den mail, som du sender.;
                           ENU=Specifies that summarized information, such as invoice number, due date, and payment service link, will be inserted in the body of the email that you send.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Use for Email Body" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at det relaterede bilag vedh�ftes mailen.;
                           ENU=Specifies that the related document will be attached to the email.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Use for Email Attachment" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver layout-id for br�dtekst i mail, som anvendes.;
                           ENU=Specifies the ID of the email body layout that is used.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Email Body Layout Code";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af layout for br�dtekst i mail, som anvendes.;
                           ENU=Specifies a description of the email body layout that is used.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Email Body Layout Description";
                OnDrillDown=VAR
                              CustomReportLayout@1000 : Record 9650;
                            BEGIN
                              IF CustomReportLayout.LookupLayoutOK("Report ID") THEN
                                VALIDATE("Email Body Layout Code",CustomReportLayout.Code);
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
      ReportUsage2@1000 : 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Receipt,Return Shipment,Purchase Document - Test,Prepayment Document - Test,P.Arch. Quote,P.Arch. Order,P. Arch. Return Order';

    LOCAL PROCEDURE SetUsageFilter@1(ModifyRec@1000 : Boolean);
    BEGIN
      IF ModifyRec THEN
        IF MODIFY THEN;
      FILTERGROUP(2);
      CASE ReportUsage2 OF
        ReportUsage2::Quote:
          SETRANGE(Usage,Usage::"P.Quote");
        ReportUsage2::"Blanket Order":
          SETRANGE(Usage,Usage::"P.Blanket");
        ReportUsage2::Order:
          SETRANGE(Usage,Usage::"P.Order");
        ReportUsage2::Invoice:
          SETRANGE(Usage,Usage::"P.Invoice");
        ReportUsage2::"Return Order":
          SETRANGE(Usage,Usage::"P.Return");
        ReportUsage2::"Credit Memo":
          SETRANGE(Usage,Usage::"P.Cr.Memo");
        ReportUsage2::Receipt:
          SETRANGE(Usage,Usage::"P.Receipt");
        ReportUsage2::"Return Shipment":
          SETRANGE(Usage,Usage::"P.Ret.Shpt.");
        ReportUsage2::"Purchase Document - Test":
          SETRANGE(Usage,Usage::"P.Test");
        ReportUsage2::"Prepayment Document - Test":
          SETRANGE(Usage,Usage::"P.Test Prepmt.");
        ReportUsage2::"P.Arch. Quote":
          SETRANGE(Usage,Usage::"P.Arch. Quote");
        ReportUsage2::"P.Arch. Order":
          SETRANGE(Usage,Usage::"P.Arch. Order");
        ReportUsage2::"P. Arch. Return Order":
          SETRANGE(Usage,Usage::"P. Arch. Return Order");
      END;
      FILTERGROUP(0);
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

