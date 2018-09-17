OBJECT Page 2822 Native - Export Invoices
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[@@@={Locked};
               DAN=nativeInvoicingExportInvoices;
               ENU=nativeInvoicingExportInvoices];
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table2822;
    DelayedInsert=Yes;
    PageType=List;
    SourceTableTemporary=Yes;
    OnInsertRecord=VAR
                     O365ExportInvoicesEmail@1000 : Codeunit 2129;
                   BEGIN
                     IF "Start Date" > "End Date" THEN
                       ERROR(PeriodErr);
                     O365ExportInvoicesEmail.ExportInvoicesToExcelandEmail("Start Date","End Date","E-mail");
                     EXIT(TRUE);
                   END;

    ODataKeyFields=Code;
  }
  CONTROLS
  {
    { 18  ;0   ;Container ;
                ContainerType=ContentArea }

    { 17  ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 1   ;2   ;Field     ;
                Name=startDate;
                CaptionML=[@@@={Locked};
                           DAN=startDate;
                           ENU=startDate];
                ApplicationArea=#All;
                SourceExpr="Start Date";
                OnValidate=BEGIN
                             IF "Start Date" = 0D THEN
                               ERROR(StartDateErr);
                           END;
                            }

    { 7   ;2   ;Field     ;
                Name=endDate;
                CaptionML=[@@@={Locked};
                           DAN=endDate;
                           ENU=endDate];
                ApplicationArea=#All;
                SourceExpr="End Date";
                OnValidate=BEGIN
                             IF "End Date" = 0D THEN
                               ERROR(EndDateErr);
                           END;
                            }

    { 4   ;2   ;Field     ;
                Name=email;
                CaptionML=[@@@={Locked};
                           DAN=email;
                           ENU=email];
                ApplicationArea=#All;
                SourceExpr="E-mail";
                OnValidate=BEGIN
                             IF "E-mail" = '' THEN
                               ERROR(EmailErr);
                           END;
                            }

  }
  CODE
  {
    VAR
      StartDateErr@1001 : TextConst 'DAN=Startdatoen er ikke angivet.;ENU=The start date is not specified.';
      EndDateErr@1005 : TextConst 'DAN=Slutdatoen er ikke angivet.;ENU=The end date is not specified.';
      EmailErr@1000 : TextConst 'DAN=Mailadressen er ikke angivet.;ENU=The email address is not specified.';
      PeriodErr@1006 : TextConst 'DAN=Den angivne periode er ugyldig.;ENU=The specified period is not valid.';

    BEGIN
    END.
  }
}

