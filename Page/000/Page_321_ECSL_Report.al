OBJECT Page 321 ECSL Report
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rapport med oversigt over EU-salg;
               ENU=EC Sales List Report];
    Description=EC Sales List Report;
    LinksAllowed=No;
    SourceTable=Table740;
    DataCaptionExpr='';
    SourceTableView=WHERE(VAT Report Config. Code=FILTER(EC Sales List));
    PageType=Document;
    ShowFilter=No;
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
                       CheckForErrors;
                     END;

    OnInsertRecord=BEGIN
                     InitPageControllers;
                   END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&unktioner;
                                 ENU=F&unctions];
                      Image=Action }
      { 22      ;2   ;Action    ;
                      Name=SuggestLines;
                      CaptionML=[DAN=ForeslÜ linjer;
                                 ENU=Suggest Lines];
                      ToolTipML=[DAN=Opret oversigt over EU-salgsposter ud fra oplysninger fra salgsrelaterede bilag.;
                                 ENU=Create EC Sales List entries based on information gathered from sales-related documents.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=SuggestLinesControllerStatus;
                      Image=SuggestLines;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ECSLVATReportLine@1040 : Record 362;
                               BEGIN
                                 VATReportMediator.GetLines(Rec);
                                 UpdateSubForm;
                                 CheckForErrors;
                                 ECSLVATReportLine.SETRANGE("Report No.","No.");
                                 IF ECSLVATReportLine.COUNT = 0 THEN
                                   MESSAGE(NoLineGeneratedMsg);
                               END;
                                }
      { 29      ;2   ;Action    ;
                      Name=Release;
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
                                 IF NOT CheckForErrors THEN
                                   MESSAGE(ReportReleasedMsg);
                               END;
                                }
      { 28      ;2   ;Action    ;
                      Name=Submit;
                      CaptionML=[DAN=Send;
                                 ENU=Submit];
                      ToolTipML=[DAN=Sender rapporten Oversigt over EU-salg til skattemyndighedernes indberetningstjeneste.;
                                 ENU=Submits the EC Sales List report to the tax authority's reporting service.];
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
                      CaptionML=[DAN=MarkÇr som &sendt;
                                 ENU=Mark as Su&bmitted];
                      ToolTipML=[DAN=Angiv, at skattemyndighederne har godkendt og returneret rapporten.;
                                 ENU=Indicate that the tax authority has approved and returned the report.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Approve;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 VATReportMediator.Submit(Rec);
                                 MESSAGE(MarkAsSubmittedMsg);
                               END;
                                }
      { 25      ;2   ;Action    ;
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
      { 31      ;2   ;Action    ;
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
      { 33      ;1   ;Action    ;
                      Name=Print;
                      CaptionML=[DAN=&Udskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered rapporten til udskrivning ved at angive de oplysninger, der medtages.;
                                 ENU=Prepare the report for printing by specifying the information it will include.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 VATReportMediator.Print(Rec);
                               END;
                                }
      { 7       ;1   ;Action    ;
                      Name=Report Setup;
                      CaptionML=[DAN=Rapportopsëtning;
                                 ENU=Report Setup];
                      ToolTipML=[DAN=Angiver den opsëtning, der skal bruges til afsendelse af momsrapporter.;
                                 ENU=Specifies the setup that will be used for the VAT reports submission.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 743;
                      Visible=FALSE;
                      Image=Setup }
      { 1040    ;1   ;Action    ;
                      Name=Log Entries;
                      CaptionML=[DAN=&Logposter;
                                 ENU=&Log Entries];
                      ToolTipML=[DAN=FÜ vist logposterne for denne rapport.;
                                 ENU=View the log entries for this report.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Log;
                      OnAction=VAR
                                 VATReportLog@1040 : Page 739;
                               BEGIN
                                 VATReportLog.SetReport(Rec);
                                 VATReportLog.RUNMODAL;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                Enabled=IsEditable }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens version.;
                           ENU=Specifies version of the report.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="VAT Report Version";
                Enabled=IsEditable }

    { 14  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver, om rapporten er i gang, er afsluttet eller indeholder fejl.;
                           ENU=Specifies whether the report is in progress, is completed, or contains errors.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status;
                Enabled=False;
                OnValidate=BEGIN
                             InitPageControllers;
                           END;
                            }

    { 3   ;2   ;Group     ;
                GroupType=Group }

    { 20  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver Üret for rapporteringsperioden.;
                           ENU=Specifies the year of the reporting period.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Period Year";
                LookupPageID=Date Lookup;
                OnValidate=VAR
                             ECSLVATReportLine@1040 : Record 362;
                           BEGIN
                             ECSLVATReportLine.ClearLines(Rec);
                           END;
                            }

    { 38  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver rapporteringsperiodens lëngde.;
                           ENU=Specifies the length of the reporting period.];
                OptionCaptionML=[DAN=,,MÜned,Kvartal;
                                 ENU=,,Month,Quarter];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Period Type";
                OnValidate=VAR
                             ECSLVATReportLine@1040 : Record 362;
                           BEGIN
                             ECSLVATReportLine.ClearLines(Rec);
                           END;
                            }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den specifikke rapporteringsperiode, som skal bruges.;
                           ENU=Specifies the specific reporting period to use.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Period No.";
                OnValidate=VAR
                             ECSLVATReportLine@1040 : Record 362;
                           BEGIN
                             ECSLVATReportLine.ClearLines(Rec);
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapporteringsperiodens fõrste dato.;
                           ENU=Specifies the first date of the reporting period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Start Date";
                Importance=Additional;
                Editable=FALSE;
                OnValidate=BEGIN
                             ClearPeriod;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapporteringsperiodens sidste dato.;
                           ENU=Specifies the last date of the reporting period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="End Date";
                Importance=Additional;
                Editable=FALSE;
                OnValidate=BEGIN
                             ClearPeriod;
                           END;
                            }

    { 13  ;1   ;Part      ;
                Name=ECSLReportLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Report No.=FIELD(No.);
                PagePartID=Page322 }

    { 5   ;1   ;Part      ;
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
      ReportSubmittedMsg@1002 : TextConst 'DAN=Rapporten er sendt.;ENU=The report has been successfully submitted.';
      CancelReportSentMsg@1005 : TextConst 'DAN=Anmodningen om annullering er blevet sendt.;ENU=The cancel request has been sent.';
      MarkAsSubmittedMsg@1006 : TextConst 'DAN=Rapporten er markeret som sendt.;ENU=The report has been marked as submitted.';
      SuggestLinesControllerStatus@1014 : Boolean;
      SubmitControllerStatus@1013 : Boolean;
      ReleaseControllerStatus@1011 : Boolean;
      ReopenControllerStatus@1010 : Boolean;
      IsEditable@1008 : Boolean;
      ReportReleasedMsg@1040 : TextConst 'DAN=Rapporten er markeret som frigivet.;ENU=The report has been marked as released.';
      NoLineGeneratedMsg@1042 : TextConst 'DAN=Der er ingen momsposter i den valgte periode.;ENU=Ther are no VAT entries in the specified period.';
      ErrorsExist@1003 : Boolean;

    LOCAL PROCEDURE UpdateSubForm@3();
    BEGIN
      CurrPage.ECSLReportLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE ClearPeriod@99();
    BEGIN
      "Period No." := 0;
      "Period Type" := "Period Type"::" ";
    END;

    LOCAL PROCEDURE InitPageControllers@5();
    BEGIN
      SuggestLinesControllerStatus := Status = Status::Open;
      ReleaseControllerStatus := Status = Status::Open;
      SubmitControllerStatus := Status = Status::Released;
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
      CurrPage.ErrorMessagesPart.PAGE.DisableActions;
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

