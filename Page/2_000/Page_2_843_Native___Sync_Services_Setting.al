OBJECT Page 2843 Native - Sync Services Setting
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@={Locked};
               DAN=nativeSyncServicesSettings;
               ENU=nativeSyncServicesSettings];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table2132;
    PageType=List;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             INSERT;
           END;

    OnOpenPage=BEGIN
                 SetCalculatedFields;
               END;

    OnAfterGetRecord=BEGIN
                       SetCalculatedFields;
                     END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 8   ;2   ;Field     ;
                Name=qboSyncTitle;
                CaptionML=[@@@={Locked};
                           DAN=qboSyncTitle;
                           ENU=qboSyncTitle];
                ToolTipML=[DAN=Angiver titlen for QuickBooks Online-synkronisering.;
                           ENU=Specifies QuickBooks Online Sync title.];
                ApplicationArea=#All;
                SourceExpr=QBOSyncTitle;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                Name=qboSyncDescription;
                CaptionML=[@@@={Locked};
                           DAN=qboSyncDescription;
                           ENU=qboSyncDescription];
                ToolTipML=[DAN=Angiver beskrivelsen af QuickBooks Online-synkronisering.;
                           ENU=Specifies QuickBooks Online Sync description.];
                ApplicationArea=#All;
                SourceExpr=QBOSyncDescription;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                Name=qboSyncEnabled;
                CaptionML=[@@@={Locked};
                           DAN=qboSyncEnabled;
                           ENU=qboSyncEnabled];
                ToolTipML=[DAN=Angiver, at QuickBooks Online-synkronisering er aktiveret.;
                           ENU=Specifies QuickBooks Online Sync enabled.];
                ApplicationArea=#All;
                SourceExpr=QBOSyncEnabled;
                OnValidate=BEGIN
                             IF QBOSyncEnabled THEN
                               ERROR(CantEnableSyncFromHereErr);
                             QBOSyncProxy.SetQBOSyncEnabled(QBOSyncEnabled);
                           END;
                            }

    { 3   ;2   ;Field     ;
                Name=qbdSyncTitle;
                CaptionML=[@@@={Locked};
                           DAN=qbdSyncTitle;
                           ENU=qbdSyncTitle];
                ToolTipML=[DAN=Angiver titlen for QuickBooks Desktop-synkronisering;
                           ENU=Specifies QuickBooks Desktop Sync title];
                ApplicationArea=#All;
                SourceExpr=QBDSyncTitle;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                Name=qbdSyncDescription;
                CaptionML=[@@@={Locked};
                           DAN=qbdSyncDescription;
                           ENU=qbdSyncDescription];
                ToolTipML=[DAN=Angiver beskrivelsen af QuickBooks Desktop-synkronisering;
                           ENU=Specifies QuickBooks Desktop Sync description];
                ApplicationArea=#All;
                SourceExpr=QBDSyncDescription;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                Name=qbdSyncEnabled;
                CaptionML=[@@@={Locked};
                           DAN=qbdSyncEnabled;
                           ENU=qbdSyncEnabled];
                ToolTipML=[DAN=Angiver, at QuickBooks Desktop-synkronisering er aktiveret;
                           ENU=Specifies QuickBooks Desktop Sync enabled];
                ApplicationArea=#All;
                SourceExpr=QBDSyncEnabled;
                OnValidate=BEGIN
                             QBDSyncProxy.SetQBDSyncEnabled(QBDSyncEnabled);
                           END;
                            }

    { 9   ;2   ;Field     ;
                Name=qbdSyncSendToEmail;
                CaptionML=[@@@={Locked};
                           DAN=qbdSyncSendToEmail;
                           ENU=qbdSyncSendToEmail];
                ToolTipML=[DAN=Angiver den mailadresse, som vejledningen i ops‘tning af QuickBooks Desktop-synkronisering skal sendes til.;
                           ENU=Specifies the email to send QuickBooks Desktop Sync setup instructions to.];
                ApplicationArea=#All;
                SourceExpr=QBDSyncSendToEmail;
                OnValidate=BEGIN
                             IF QBDSyncSendToEmail = '' THEN
                               ERROR(SendToEmailErr);

                             QBDSyncProxy.SetQBDSyncSendToEmail(QBDSyncSendToEmail);
                           END;
                            }

  }
  CODE
  {
    VAR
      QBDSyncProxy@1007 : Codeunit 1062;
      QBOSyncProxy@1006 : Codeunit 1061;
      QBOSyncTitle@1005 : Text;
      QBOSyncDescription@1004 : Text;
      QBOSyncEnabled@1003 : Boolean;
      QBDSyncTitle@1002 : Text;
      QBDSyncDescription@1001 : Text;
      QBDSyncEnabled@1000 : Boolean;
      QBDSyncSendToEmail@1008 : Text;
      SendToEmailErr@1009 : TextConst 'DAN=Modtageren er ikke angivet.;ENU=Send to email is not specified.';
      SendingEmailErr@1010 : TextConst 'DAN=Fejl under afsendelse af mail.;ENU=Error while sending email.';
      CantEnableSyncFromHereErr@1011 : TextConst 'DAN=Kan ikke aktivere synkronisering her. Brug tjenesten QBO Sync. Auth i stedet.;ENU=Can''t enable sync from here. Use QBO Sync. Auth service instead.';

    [ServiceEnabled]
    [External]
    PROCEDURE SendInstructionsByEmail@17(VAR ActionContext@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext");
    VAR
      ODataActionManagement@1001 : Codeunit 6711;
      Handled@1003 : Boolean;
    BEGIN
      QBDSyncProxy.SendEmailInBackground(Handled);
      IF NOT Handled THEN
        ERROR(SendingEmailErr);
      ODataActionManagement.SetDeleteResponseLocation(ActionContext,PAGE::"Native - Sync Services Setting");
    END;

    LOCAL PROCEDURE SetCalculatedFields@3();
    BEGIN
      QBOSyncProxy.GetQBOSyncSettings(QBOSyncTitle,QBOSyncDescription,QBOSyncEnabled);
      QBDSyncProxy.GetQBDSyncSettings(QBDSyncTitle,QBDSyncDescription,QBDSyncEnabled,QBDSyncSendToEmail);
    END;

    BEGIN
    END.
  }
}

