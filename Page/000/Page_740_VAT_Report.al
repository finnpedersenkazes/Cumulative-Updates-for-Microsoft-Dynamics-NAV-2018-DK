OBJECT Page 740 VAT Report
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Momsangivelse;
               ENU=VAT Return];
    LinksAllowed=No;
    SourceTable=Table740;
    DataCaptionExpr="No.";
    SourceTableView=WHERE(VAT Report Config. Code=CONST(VAT Return));
    PageType=Document;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Momsafregning;
                                ENU=New,Process,Report,VAT Settlement];
    OnOpenPage=BEGIN
                 IF "No." <> '' THEN
                   InitPageControllers;
                 IsEditable := Status = Status::Open;
                 DeleteErrors;
               END;

    OnClosePage=BEGIN
                  DeleteErrors;
                END;

    OnAfterGetRecord=BEGIN
                       InitPageControllers;
                     END;

    OnInsertRecord=BEGIN
                     InitPageControllers;
                   END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 22      ;2   ;Action    ;
                      Name=SuggestLines;
                      CaptionML=[DAN=ForeslÜ linjer;
                                 ENU=Suggest Lines];
                      ToolTipML=[DAN="Opret momsrapportposter ud fra oplysninger fra salgs- og kõbsrelaterede bilag. ";
                                 ENU="Create VAT Report entries based on information gathered from documents related to sales and purchases. "];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=SuggestLinesControllerStatus;
                      Image=SuggestLines;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 VATReportMediator.GetLines(Rec);
                                 CurrPage.VATReportLines.PAGE.SelectFirst;
                                 CheckForErrors;
                               END;
                                }
      { 50      ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      ToolTipML=[DAN=KontrollÇr, at rapporten omfatter alle de nõdvendige oplysninger, og klargõr den til afsendelse.;
                                 ENU=Verify that the report includes all of the required information, and prepare it for submission.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=ReleaseControllerStatus;
                      Image=ReleaseDoc;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 VATReportMediator.Release(Rec);
                                 CheckForErrors;
                               END;
                                }
      { 27      ;2   ;Action    ;
                      Name=Submit;
                      CaptionML=[DAN=Send;
                                 ENU=Submit];
                      ToolTipML=[DAN=Sender momsrapporten til skattemyndighedernes indberetningstjeneste.;
                                 ENU=Submits the VAT Report to the tax authority's reporting service.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=SubmitControllerStatus;
                      Image=SendElectronicDocument;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 VATReportMediator.Export(Rec);
                                 IF NOT CheckForErrors THEN
                                   MESSAGE(ReportSubmittedMsg);
                               END;
                                }
      { 19      ;2   ;Action    ;
                      Name=Mark as Submitted;
                      CaptionML=[DAN=MarkÇr som sendt;
                                 ENU=Mark as Submitted];
                      ToolTipML=[DAN=Angiv, at du har sendt rapporten til skattemyndighederne manuelt.;
                                 ENU=Indicate that you submitted the report to the tax authority manually.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=MarkAsSubmitControllerStatus;
                      Image=Approve;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 VATReportMediator.Submit(Rec);
                                 IF NOT CheckForErrors THEN
                                   MESSAGE(MarkAsSubmittedMsg);
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Name=Cancel Submission;
                      CaptionML=[DAN=Annuller afsendelse;
                                 ENU=Cancel Submission];
                      ToolTipML=[DAN=Annullerer en tidligere sendt rapport.;
                                 ENU=Cancels previously submitted report.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Cancel;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 VATReportMediator.Reopen(Rec);
                                 MESSAGE(CancelReportSentMsg);
                               END;
                                }
      { 25      ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=èbn igen;
                                 ENU=Reopen];
                      ToolTipML=[DAN=èbn rapporten igen for at foretage ëndringer.;
                                 ENU=Open the report again to make changes.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=ReopenControllerStatus;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 VATReportMediator.Reopen(Rec);
                               END;
                                }
      { 20      ;2   ;Action    ;
                      Name=Download Submission Message;
                      CaptionML=[DAN=Download afsendelsesmeddelelse;
                                 ENU=Download Submission Message];
                      ToolTipML=[DAN=èbn rapporten igen for at foretage ëndringer.;
                                 ENU=Open the report again to make changes.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=FALSE;
                      Enabled=DownloadSubmissionControllerStatus;
                      Image=MoveDown;
                      OnAction=VAR
                                 VATReportArchive@1000 : Record 747;
                               BEGIN
                                 VATReportArchive.DownloadSubmissionMessage("VAT Report Config. Code","No.");
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=Download Response Message;
                      CaptionML=[DAN=Download svarmeddelelse;
                                 ENU=Download Response Message];
                      ToolTipML=[DAN=èbn rapporten igen for at foretage ëndringer.;
                                 ENU=Open the report again to make changes.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=FALSE;
                      Enabled=DownloadResponseControllerStatus;
                      Image=MoveDown;
                      OnAction=VAR
                                 VATReportArchive@1000 : Record 747;
                               BEGIN
                                 VATReportArchive.DownloadResponseMessage("VAT Report Config. Code","No.");
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=Calc. and Post VAT Settlement;
                      CaptionML=[DAN=Afregn moms;
                                 ENU=Calc. and Post VAT Settlement];
                      ToolTipML=[DAN=Luk Übne momsposter og overfõrer kõbs- og salgsmomsbelõb til momsafregningskontoen. For hver momsbogfõringsgruppe finder kõrslen alle momsposter i den momsposttabel, der er inkluderet i filtrene i definitionsvinduet.;
                                 ENU=Close open VAT entries and transfers purchase and sales VAT amounts to the VAT settlement account. For every VAT posting group, the batch job finds all the VAT entries in the VAT Entry table that are included in the filters in the definition window.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=CalcAndPostVATStatus;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CalcAndPostVATSettlement@1000 : Report 20;
                               BEGIN
                                 CalcAndPostVATSettlement.InitializeRequest("Start Date","End Date",WORKDATE,"No.",'',FALSE,FALSE);
                                 CalcAndPostVATSettlement.RUN;
                               END;
                                }
      { 33      ;1   ;Action    ;
                      Name=Print;
                      CaptionML=[DAN=Udskriv;
                                 ENU=Print];
                      ToolTipML=[DAN=Udskriv oplysningerne i vinduet. Du fÜr vist et anmodningsvindue for udskrivningen, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Print the information in the window. A print request window opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 VATReportMediator.Print(Rec);
                               END;
                                }
      { 12      ;1   ;Action    ;
                      Name=Report Setup;
                      CaptionML=[DAN=Rapportopsëtning;
                                 ENU=Report Setup];
                      ToolTipML=[DAN=Angiver den opsëtning, der skal bruges til afsendelse af momsrapporter.;
                                 ENU=Specifies the setup that will be used for the VAT reports submission.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 743;
                      Visible=FALSE;
                      Image=Setup }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                Editable=IsEditable }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens entydige id.;
                           ENU=Specifies the unique identifier for the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Version;
                           ENU=Version];
                ToolTipML=[DAN=Angiver rapportens version.;
                           ENU=Specifies version of the report.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="VAT Report Version" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om rapporten er i gang, er afsluttet eller indeholder fejl.;
                           ENU=Specifies whether the report is in progress, is completed, or contains errors.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status;
                Editable=FALSE;
                OnValidate=BEGIN
                             InitPageControllers;
                           END;
                            }

    { 23  ;2   ;Group     ;
                Editable=False;
                GroupType=Group }

    { 35  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver Üret for rapporteringsperioden.;
                           ENU=Specifies the year of the reporting period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Period Year";
                LookupPageID=Date Lookup }

    { 34  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver rapporteringsperiodens lëngde.;
                           ENU=Specifies the length of the reporting period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Period Type" }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den specifikke rapporteringsperiode, som skal bruges.;
                           ENU=Specifies the specific reporting period to use.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Period No." }

    { 8   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver rapporteringsperiodens fõrste dato.;
                           ENU=Specifies the first date of the reporting period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Start Date";
                Importance=Additional }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver rapporteringsperiodens sidste dato.;
                           ENU=Specifies the last date of the reporting period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="End Date";
                Importance=Additional }

    { 13  ;1   ;Part      ;
                Name=VATReportLines;
                CaptionML=[DAN=Rapportlinjer;
                           ENU=Report Lines];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=VAT Report No.=FIELD(No.),
                            VAT Report Config. Code=FIELD(VAT Report Config. Code);
                PagePartID=Page742;
                PartType=Page }

    { 7   ;1   ;Part      ;
                Name=ErrorMessagesPart;
                CaptionML=[DAN=Meddelelser;
                           ENU=Messages];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page701;
                Visible=ErrorsExist;
                PartType=Page }

  }
  CODE
  {
    VAR
      DummyCompanyInformation@1090 : Record 79;
      VATReportMediator@1000 : Codeunit 740;
      ErrorsExist@1001 : Boolean;
      ReportSubmittedMsg@1006 : TextConst 'DAN=Rapporten er sendt.;ENU=The report has been successfully submitted.';
      CancelReportSentMsg@1005 : TextConst 'DAN=Anmodningen om annullering er blevet sendt.;ENU=The cancel request has been sent.';
      MarkAsSubmittedMsg@1004 : TextConst 'DAN=Rapporten er markeret som sendt.;ENU=The report has been marked as submitted.';
      SuggestLinesControllerStatus@1015 : Boolean;
      SubmitControllerStatus@1014 : Boolean;
      MarkAsSubmitControllerStatus@1013 : Boolean;
      ReleaseControllerStatus@1012 : Boolean;
      ReopenControllerStatus@1011 : Boolean;
      IsEditable@1009 : Boolean;
      DownloadSubmissionControllerStatus@1008 : Boolean;
      DownloadResponseControllerStatus@1007 : Boolean;
      CalcAndPostVATStatus@1010 : Boolean;

    LOCAL PROCEDURE InitPageControllers@5();
    BEGIN
      SuggestLinesControllerStatus := Status = Status::Open;
      ReleaseControllerStatus := Status = Status::Open;
      SubmitControllerStatus := Status = Status::Released;
      MarkAsSubmitControllerStatus := Status = Status::Released;
      DownloadSubmissionControllerStatus := (Status = Status::Submitted) OR
        (Status = Status::Rejected) OR
        (Status = Status::Accepted) OR
        (Status = Status::Closed);
      DownloadResponseControllerStatus := (Status = Status::Rejected) OR
        (Status = Status::Accepted) OR
        (Status = Status::Closed);
      CalcAndPostVATStatus := Status = Status::Accepted;
      ReopenControllerStatus := Status = Status::Released;
    END;

    LOCAL PROCEDURE CheckForErrors@1096() : Boolean;
    VAR
      ErrorMessage@1001 : Record 700;
      TempErrorMessage@1000 : TEMPORARY Record 700;
    BEGIN
      ErrorMessage.SETRANGE("Context Record ID",DummyCompanyInformation.RECORDID);
      ErrorMessage.CopyToTemp(TempErrorMessage);
      ErrorMessage.SETRANGE("Context Record ID",RECORDID);
      ErrorMessage.CopyToTemp(TempErrorMessage);

      CurrPage.ErrorMessagesPart.PAGE.SetRecords(TempErrorMessage);
      CurrPage.ErrorMessagesPart.PAGE.UPDATE;
      ErrorsExist := NOT TempErrorMessage.ISEMPTY;

      EXIT(ErrorsExist);
    END;

    LOCAL PROCEDURE DeleteErrors@11();
    VAR
      ErrorMessage@1001 : Record 700;
    BEGIN
      ErrorMessage.SETRANGE("Context Record ID",DummyCompanyInformation.RECORDID);
      IF ErrorMessage.FINDFIRST THEN
        ErrorMessage.DELETEALL(TRUE);
      COMMIT;
    END;

    BEGIN
    END.
  }
}

