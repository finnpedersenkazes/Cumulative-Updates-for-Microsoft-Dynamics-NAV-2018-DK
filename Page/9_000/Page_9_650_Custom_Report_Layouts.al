OBJECT Page 9650 Custom Report Layouts
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tilpassede rapportlayouts;
               ENU=Custom Report Layouts];
    InsertAllowed=No;
    SourceTable=Table9650;
    SourceTableView=SORTING(Report ID,Company Name,Type);
    PageType=List;
    OnOpenPage=VAR
                 FileMgt@1000 : Codeunit 419;
               BEGIN
                 IsWindowsClient := FileMgt.IsWindowsClient;
                 PageName := CurrPage.CAPTION;
                 CurrPage.CAPTION := GetPageCaption;
               END;

    OnClosePage=VAR
                  ReportLayoutSelection@1000 : Record 9651;
                BEGIN
                  ReportLayoutSelection.SetTempLayoutSelected('');
                END;

    OnAfterGetRecord=BEGIN
                       CanEdit := IsWindowsClient;
                     END;

    OnAfterGetCurrRecord=VAR
                           ReportLayoutSelection@1000 : Record 9651;
                         BEGIN
                           CurrPage.CAPTION := GetPageCaption;
                           ReportLayoutSelection.SetTempLayoutSelected('');
                           IsNotBuiltIn := NOT "Built-In";
                         END;

    ActionList=ACTIONS
    {
      { 14      ;    ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 25      ;1   ;Action    ;
                      Name=NewLayout;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ToolTipML=[DAN=Opret et nyt indbygget layout til rapporter.;
                                 ENU=Create a new built-in layout for reports.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=NewDocument;
                      OnAction=BEGIN
                                 CopyBuiltInLayout;
                               END;
                                }
      { 15      ;1   ;Action    ;
                      Name=CopyRec;
                      CaptionML=[DAN=Kopi‚r;
                                 ENU=Copy];
                      ToolTipML=[DAN=Tag en kopi af et indbygget layout til rapporter.;
                                 ENU=Make a copy of a built-in layout for reports.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=CopyDocument;
                      OnAction=BEGIN
                                 CopyRecord;
                               END;
                                }
      { 17      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 23      ;1   ;Action    ;
                      Name=ExportWordXMLPart;
                      CaptionML=[DAN=Eksport‚r Word XML-del;
                                 ENU=Export Word XML Part];
                      ToolTipML=[DAN=Eksport‚r Word XML-fil.;
                                 ENU=Export to a Word XML file.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Export;
                      OnAction=BEGIN
                                 ExportSchema('',TRUE);
                               END;
                                }
      { 16      ;1   ;Action    ;
                      Name=ImportLayout;
                      CaptionML=[DAN=Import‚r layout;
                                 ENU=Import Layout];
                      ToolTipML=[DAN=Import‚r en Word-fil.;
                                 ENU=Import a Word file.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Import;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ImportLayout('');
                               END;
                                }
      { 19      ;1   ;Action    ;
                      Name=ExportLayout;
                      CaptionML=[DAN=Eksport‚r layout;
                                 ENU=Export Layout];
                      ToolTipML=[DAN=Eksport‚r en Word-fil.;
                                 ENU=Export a Word file.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Export;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ExportLayout('',TRUE);
                               END;
                                }
      { 24      ;1   ;Action    ;
                      Name=EditLayout;
                      CaptionML=[DAN=Rediger layout;
                                 ENU=Edit Layout];
                      ToolTipML=[DAN=Rediger rapportlayoutet i Word, foretag ‘ndringer i filen, og luk Word for at forts‘tte.;
                                 ENU=Edit the report layout in Word, make changes to the file, and close Word to continue.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=CanEdit;
                      Image=EditReminder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 EditLayout;
                               END;
                                }
      { 20      ;1   ;Action    ;
                      Name=UpdateWordLayout;
                      CaptionML=[DAN=Opdater layout;
                                 ENU=Update Layout];
                      ToolTipML=[DAN=Opdater specifikke rapportlayout eller alle tilpassede rapportlayout, der kunne blive p†virket af datas‘t‘ndringer.;
                                 ENU=Update specific report layouts or all custom report layouts that might be affected by dataset changes.];
                      ApplicationArea=#Basic,#Suite;
                      Image=UpdateXML;
                      OnAction=BEGIN
                                 IF CanBeModified THEN
                                   IF UpdateLayout(FALSE,FALSE) THEN
                                     MESSAGE(UpdateSuccesMsg,FORMAT(Type))
                                   ELSE
                                     MESSAGE(UpdateNotRequiredMsg,FORMAT(Type));
                               END;
                                }
      { 13      ;    ;ActionContainer;
                      ActionContainerType=Reports }
      { 21      ;1   ;Action    ;
                      Name=RunReport;
                      CaptionML=[DAN=K›r rapport;
                                 ENU=Run Report];
                      ToolTipML=[DAN=K›r en testrapport.;
                                 ENU=Run a test report.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 RunCustomReport;
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

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden.;
                           ENU=Specifies the Code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code;
                Visible=FALSE;
                Editable=IsNotBuiltIn }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens objekt-id.;
                           ENU=Specifies the object ID of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report ID";
                Enabled=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† rapporten.;
                           ENU=Specifies the name of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Name";
                Enabled=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af rapportlayoutet.;
                           ENU=Specifies a description of the report layout.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den Dynamics NAV-virksomhed, som rapportlayoutet vedr›rer. Du kan oprette rapportlayout, der kun kan bruges i rapporter, n†r de k›res for en bestemt virksomhed. Hvis feltet er tomt, vil layoutet kunne bruges i alle virksomheder.;
                           ENU=Specifies the Dynamics NAV company that the report layout applies to. You to create report layouts that can only be used on reports when they are run for a specific to a company. If the field is blank, then the layout will be available for use in all companies.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Company Name" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om rapportlayoutet er indbygget eller ej.;
                           ENU=Specifies if the report layout is built-in or not.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Built-In";
                Enabled=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportlayoutets filtype. Den f›lgende tabel omfatter de typer, der er tilg‘ngelige.;
                           ENU=Specifies the file type of the report layout. The following table includes the types that are available:];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dato og klokkesl‘t for den seneste ‘ndring af rapportlayoutposten.;
                           ENU=Specifies the date and time of the last change to the report layout entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Modified";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bruger, som foretog den sidste ‘ndring i rapportlayoutposten.;
                           ENU=Specifies the user who made the last change to the report layout entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Modified by User";
                Visible=FALSE }

    { 10  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 11  ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

    { 12  ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      IsWindowsClient@1001 : Boolean;
      CanEdit@1002 : Boolean;
      UpdateSuccesMsg@1004 : TextConst 'DAN=%1-layoutet er opdateret til at bruge det aktuelle rapportdesign.;ENU=The %1 layout has been updated to use the current report design.';
      UpdateNotRequiredMsg@1005 : TextConst 'DAN=%1-layoutet er opdateret. Der kr‘ves ingen yderligere opdateringer.;ENU=The %1 layout is up-to-date. No further updates are required.';
      PageName@1000 : Text;
      CaptionTxt@1003 : TextConst '@@@={Locked};DAN=%1 - %2 %3;ENU=%1 - %2 %3';
      IsNotBuiltIn@1006 : Boolean;

    LOCAL PROCEDURE GetPageCaption@2() : Text;
    VAR
      AllObjWithCaption@1000 : Record 2000000058;
      FilterText@1001 : Text;
      ReportID@1002 : Integer;
    BEGIN
      IF "Report ID" <> 0 THEN
        EXIT(STRSUBSTNO(CaptionTxt,PageName,"Report ID","Report Name"));
      FILTERGROUP(4);
      FilterText := GETFILTER("Report ID");
      FILTERGROUP(0);
      IF EVALUATE(ReportID,FilterText) THEN
        IF AllObjWithCaption.GET(AllObjWithCaption."Object Type"::Report,ReportID) THEN
          EXIT(STRSUBSTNO(CaptionTxt,PageName,ReportID,AllObjWithCaption."Object Caption"));
      EXIT(PageName);
    END;

    BEGIN
    END.
  }
}

