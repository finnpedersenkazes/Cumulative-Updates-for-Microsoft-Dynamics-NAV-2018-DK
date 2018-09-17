OBJECT Page 5097 Create Task
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opret opgave;
               ENU=Create Task];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5080;
    DataCaptionExpr=Caption;
    PageType=Card;
    OnInit=BEGIN
             AttachmentEnable := TRUE;
             LanguageCodeEnable := TRUE;
             CalcDueDateFromEnable := TRUE;
             RecurringDateIntervalEnable := TRUE;
             WizardContactNameEnable := TRUE;
             AllDayEventEnable := TRUE;
             LocationEnable := TRUE;
             DurationEnable := TRUE;
             EndingTimeEnable := TRUE;
             StartTimeEnable := TRUE;
             SalespersonCodeEnable := TRUE;
             SalespersonCodeEditable := TRUE;
             WizardOpportunityDescriptionEd := TRUE;
             WizardCampaignDescriptionEdita := TRUE;
             WizardContactNameEditable := TRUE;
             TeamTaskEditable := TRUE;
           END;

    OnOpenPage=BEGIN
                 IsOnMobile := ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Phone;

                 WizardContactNameEditable := FALSE;
                 WizardCampaignDescriptionEdita := FALSE;
                 WizardOpportunityDescriptionEd := FALSE;

                 IF SalesPurchPerson.GET(GETFILTER("Salesperson Code")) THEN BEGIN
                   SalespersonCodeEditable := FALSE;
                   TeamTaskEditable := FALSE;
                 END;

                 IF "Segment Description" <> '' THEN
                   SegmentDescEditable := FALSE;

                 IsMeeting := (Type = Type::Meeting);
               END;

    OnAfterGetRecord=BEGIN
                       EnableFields;
                       WizardContactNameOnFormat(FORMAT("Wizard Contact Name"));
                     END;

    OnQueryClosePage=BEGIN
                       IF CloseAction IN [ACTION::OK,ACTION::LookupOK] THEN
                         FinishPage;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 10      ;1   ;Action    ;
                      Name=Finish;
                      CaptionML=[DAN=&Udf�r;
                                 ENU=&Finish];
                      ToolTipML=[DAN=Afslut opgaven.;
                                 ENU=Finish the task.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Visible=IsOnMobile;
                      InFooterBar=Yes;
                      Image=Approve;
                      OnAction=BEGIN
                                 FinishPage;
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Name=General;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opgavens type.;
                           ENU=Specifies the type of the Task.];
                OptionCaptionML=[DAN=" ,,Telefonopkald";
                                 ENU=" ,,Phone Call"];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Type;
                OnValidate=BEGIN
                             IF Type <> xRec.Type THEN
                               IF Type = Type::Meeting THEN BEGIN
                                 AssignDefaultAttendeeInfo;
                                 LoadTempAttachment;
                                 IF NOT "Team To-do" THEN
                                   IF "Salesperson Code" = '' THEN BEGIN
                                     IF Cont.GET("Contact No.") THEN
                                       VALIDATE("Salesperson Code",Cont."Salesperson Code")
                                     ELSE
                                       IF Cont.GET("Contact Company No.") THEN
                                         VALIDATE("Salesperson Code",Cont."Salesperson Code");
                                     IF Campaign.GET(GETFILTER("Campaign No.")) THEN
                                       VALIDATE("Salesperson Code",Campaign."Salesperson Code");
                                     IF Opp.GET(GETFILTER("Opportunity No.")) THEN
                                       VALIDATE("Salesperson Code",Opp."Salesperson Code");
                                     IF SegHeader.GET(GETFILTER("Segment No.")) THEN
                                       VALIDATE("Salesperson Code",SegHeader."Salesperson Code");
                                     MODIFY;
                                   END;
                                 GetAttendee(AttendeeTemp);
                                 CurrPage.AttendeeSubform.PAGE.SetAttendee(AttendeeTemp);
                                 CurrPage.AttendeeSubform.PAGE.SetTaskFilter(SalespersonFilter,ContactFilter);
                                 CurrPage.AttendeeSubform.PAGE.UpdateForm;
                               END ELSE BEGIN
                                 ClearDefaultAttendeeInfo;
                                 CurrPage.AttendeeSubform.PAGE.GetAttendee(AttendeeTemp);
                                 SetAttendee(AttendeeTemp);
                                 SalespersonCodeEnable := FALSE;
                                 WizardContactNameEnable := TRUE;
                               END;
                             IsMeeting := (Type = Type::Meeting);
                             TypeOnAfterValidate;
                             CurrPage.UPDATE;
                           END;
                            }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af opgaven.;
                           ENU=Specifies the description of the Task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Description }

    { 44  ;2   ;Field     ;
                Name=AllDayEvent;
                CaptionML=[DAN=Hele dagen;
                           ENU=All Day Event];
                ToolTipML=[DAN=Angiver, at opgaven af typen M�de er en heldagsbegivenhed, dvs. en aktivitet, der varer 24 timer eller l�ngere.;
                           ENU=Specifies that the Task of the Meeting type is an all-day event, which is an activity that lasts 24 hours or longer.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="All Day Event";
                Enabled=AllDayEventEnable;
                OnValidate=BEGIN
                             AllDayEventOnAfterValidate;
                           END;
                            }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Startdato;
                           ENU=Start Date];
                ToolTipML=[DAN=Angiver den dato, hvor opgaven skal v�re startet. Der er bestemte regler for, hvordan datoer skal indtastes, som kan ses i vejledningen i angivelse af datoer og klokkesl�t.;
                           ENU=Specifies the date when the Task should be started. There are certain rules for how dates should be entered found in How to: Enter Dates and Times.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Date }

    { 49  ;2   ;Field     ;
                Name=Start Time;
                CaptionML=[DAN=Starttidspunkt;
                           ENU=Start Time];
                ToolTipML=[DAN=Angiver det tidspunkt, hvor opgaven af typen M�de skal v�re startet.;
                           ENU=Specifies the time when the Task of the Meeting type should be started.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Start Time";
                Enabled=StartTimeEnable }

    { 51  ;2   ;Field     ;
                CaptionML=[DAN=Varighed;
                           ENU=Duration];
                ToolTipML=[DAN=Angiver varigheden for opgaven af typen M�de.;
                           ENU=Specifies the duration of the Task of the Meeting type.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Duration;
                Enabled=DurationEnable }

    { 45  ;2   ;Field     ;
                Name=Ending Date;
                CaptionML=[DAN=Slutdato;
                           ENU=Ending Date];
                ToolTipML=[DAN=Angiver den dato, hvor opgaven skal v�re afsluttet. Der er bestemte regler for, hvordan datoer skal indtastes. Du kan finde flere oplysninger i vejledningen til angivelse af datoer og klokkesl�t.;
                           ENU=Specifies the date of when the Task should end. There are certain rules for how dates should be entered. For more information, see How to: Enter Dates and Times.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Ending Date" }

    { 55  ;2   ;Field     ;
                Name=Ending Time;
                CaptionML=[DAN=Sluttidspunkt;
                           ENU=Ending Time];
                ToolTipML=[DAN=Angiver det tidspunkt, hvor opgaven af typen M�de skal slutte.;
                           ENU=Specifies the time of when the Task of the Meeting type should end.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Ending Time";
                Enabled=EndingTimeEnable }

    { 29  ;2   ;Field     ;
                Name=TeamTask;
                CaptionML=[DAN=Holdopgave;
                           ENU=Team Task];
                ToolTipML=[DAN=Angiver, om opgaven skal udf�res af hele teamet. Mark�r afkrydsningsfeltet for at angive, at opgaven vedr�rer hele teamet.;
                           ENU=Specifies if the Task is meant to be done team-wide. Select the check box to specify that the Task applies to the entire Team.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Team To-do";
                Editable=TeamTaskEditable;
                OnValidate=BEGIN
                             IF NOT "Team To-do" THEN BEGIN
                               "Team Code" := '';
                               SalespersonCodeEnable := FALSE;
                               IF Type = Type::Meeting THEN BEGIN
                                 ClearDefaultAttendeeInfo;
                                 AssignDefaultAttendeeInfo;
                               END;
                             END;
                           END;
                            }

    { 21  ;2   ;Field     ;
                Lookup=No;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver et kontaktnavn fra guiden.;
                           ENU=Specifies a Contact name from the wizard.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Wizard Contact Name";
                TableRelation=Contact;
                Enabled=WizardContactNameEnable;
                Editable=WizardContactNameEditable;
                OnAssistEdit=VAR
                               Cont@1102601001 : Record 5050;
                             BEGIN
                               IF (GETFILTER("Contact No.") = '') AND (GETFILTER("Contact Company No.") = '') AND ("Segment Description" = '') THEN BEGIN
                                 IF Cont.GET("Contact No.") THEN ;
                                 IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                   VALIDATE("Contact No.",Cont."No.");
                                   "Wizard Contact Name" := Cont.Name;
                                 END;
                               END;
                             END;
                              }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=S�lger;
                           ENU=Salesperson];
                ToolTipML=[DAN=Angiver koden for den s�lger, der er tildelt til opgaven.;
                           ENU=Specifies the code of the Salesperson assigned to the Task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Salesperson Code";
                Enabled=SalespersonCodeEnable;
                Editable=SalespersonCodeEditable }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Team;
                           ENU=Team];
                ToolTipML=[DAN=Angiver koden for det team, som opgaven er tildelt.;
                           ENU=Specifies the code of the Team to which the Task is assigned.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Team Code";
                Enabled="Team To-do" OR NOT IsMeeting;
                Editable="Team To-do";
                OnValidate=BEGIN
                             IF (xRec."Team Code" <> "Team Code") AND
                                ("Team Code" <> '') AND
                                (Type = Type::Meeting)
                             THEN BEGIN
                               ClearDefaultAttendeeInfo;
                               AssignDefaultAttendeeInfo
                             END
                           END;
                            }

    { 11  ;2   ;Field     ;
                Lookup=No;
                CaptionML=[DAN=Kampagne;
                           ENU=Campaign];
                ToolTipML=[DAN=Angiver en beskrivelse af den kampagne, der er relateret til opgaven. Beskrivelsen kopieres fra kampagnekortet.;
                           ENU=Specifies a description of the campaign that is related to the task. The description is copied from the campaign card.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Wizard Campaign Description";
                TableRelation=Campaign;
                Importance=Additional;
                Editable=WizardCampaignDescriptionEdita;
                OnAssistEdit=VAR
                               Campaign@1102601001 : Record 5071;
                             BEGIN
                               IF GETFILTER("Campaign No.") = '' THEN BEGIN
                                 IF Campaign.GET("Campaign No.") THEN ;
                                 IF PAGE.RUNMODAL(0,Campaign) = ACTION::LookupOK THEN BEGIN
                                   VALIDATE("Campaign No.",Campaign."No.");
                                   "Wizard Campaign Description" := Campaign.Description;
                                 END;
                               END;
                             END;
                              }

    { 5   ;2   ;Field     ;
                Lookup=No;
                CaptionML=[DAN=Salgsmulighed;
                           ENU=Opportunity];
                ToolTipML=[DAN=Angiver en beskrivelse af den salgsmulighed, der relaterer til opgaven. Beskrivelsen kopieres fra kampagnekortet.;
                           ENU=Specifies a description of the Opportunity that is related to the Task. The description is copied from the Campaign card.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Wizard Opportunity Description";
                TableRelation=Opportunity;
                Importance=Additional;
                Editable=WizardOpportunityDescriptionEd;
                OnAssistEdit=VAR
                               Opp@1102601001 : Record 5092;
                             BEGIN
                               IF GETFILTER("Opportunity No.") = '' THEN BEGIN
                                 IF Opp.GET("Opportunity No.") THEN ;
                                 IF PAGE.RUNMODAL(0,Opp) = ACTION::LookupOK THEN BEGIN
                                   VALIDATE("Opportunity No.",Opp."No.");
                                   "Wizard Opportunity Description" := Opp.Description;
                                 END;
                               END;
                             END;
                              }

    { 6   ;2   ;Field     ;
                Name=SegmentDesc;
                Lookup=No;
                CaptionML=[DAN=Opret opgaver for m�lgruppes kontakter;
                           ENU=Create Tasks for Segment Contacts];
                ToolTipML=[DAN=Angiver en beskrivelse af den m�lgruppe, der er relateret til opgaven. Beskrivelsen kopieres fra m�lgruppekortet.;
                           ENU=Specifies a description of the Segment related to the Task. The description is copied from the Segment Card.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Segment Description";
                TableRelation="Segment Header";
                Importance=Additional;
                Editable=SegmentDescEditable;
                OnAssistEdit=VAR
                               SegmentHeader@1102601000 : Record 5076;
                             BEGIN
                               IF GETFILTER("Segment No.") = '' THEN BEGIN
                                 IF SegmentHeader.GET("Segment No.") THEN ;
                                 IF PAGE.RUNMODAL(0,SegmentHeader) = ACTION::LookupOK THEN BEGIN
                                   VALIDATE("Segment No.",SegmentHeader."No.");
                                   "Segment Description" := SegmentHeader.Description;
                                 END;
                               END;
                             END;
                              }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Prioritet;
                           ENU=Priority];
                ToolTipML=[DAN=Angiver opgavens prioritering. Der er tre indstillinger:;
                           ENU=Specifies the priority of the Task. There are three options:];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Priority;
                Importance=Additional }

    { 3   ;2   ;Field     ;
                Name=Location;
                CaptionML=[DAN=Lokation;
                           ENU=Location];
                ToolTipML=[DAN=Angiver det sted, hvor m�det skal foreg�.;
                           ENU=Specifies the Location where the Meeting will take place.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Location;
                Importance=Promoted;
                Enabled=LocationEnable }

    { 20  ;1   ;Group     ;
                Name=MeetingAttendees;
                CaptionML=[DAN=Deltagere i m�de;
                           ENU=Meeting Attendees];
                Visible=IsMeeting;
                GroupType=Group }

    { 19  ;2   ;Part      ;
                Name=AttendeeSubform;
                ApplicationArea=#RelationshipMgmt;
                SubPageLink=To-do No.=FIELD(No.);
                PagePartID=Page5198;
                PartType=Page }

    { 22  ;2   ;Group     ;
                Name=MeetingInteraction;
                CaptionML=[DAN=Interaktion;
                           ENU=Interaction];
                GroupType=Group }

    { 16  ;3   ;Field     ;
                CaptionML=[DAN=Send invitationer, n�r jeg klikker p� Udf�r;
                           ENU=Send Invitation(s) on Finish];
                ToolTipML=[DAN=Angiver, om m�deinvitationsopgaven skal sendes ved afslutning af guiden Opret opgave.;
                           ENU=Specifies if the meeting invitation task will be sent when the Create Task wizard is finished.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Send on finish" }

    { 15  ;3   ;Field     ;
                CaptionML=[DAN=Interaktionsskabelon;
                           ENU=Interaction Template];
                ToolTipML=[DAN=Angiver koden for den interaktionsskabelon, som du har valgt.;
                           ENU=Specifies the code for the Interaction Template that you have selected.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Interaction Template Code";
                TableRelation="Interaction Template";
                OnValidate=BEGIN
                             ValidateInteractionTemplCode;
                             InteractionTemplateCodeOnAfter;
                           END;
                            }

    { 14  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs�ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p� en ordrebekr�ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Language Code";
                Enabled=LanguageCodeEnable;
                OnValidate=BEGIN
                             ValidateLanguageCode;
                           END;

                OnLookup=BEGIN
                           LookupLanguageCode;
                         END;
                          }

    { 13  ;3   ;Field     ;
                Name=Attachment;
                AssistEdit=Yes;
                CaptionML=[DAN=Vedh�ftet fil;
                           ENU=Attachment];
                ToolTipML=[DAN=Angiver, om den tilknyttede vedh�ftede fil er overf�rt eller entydig.;
                           ENU=Specifies if the linked attachment is inherited or unique.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Attachment No." > 0;
                Enabled=AttachmentEnable;
                Editable=FALSE;
                OnAssistEdit=BEGIN
                               AssistEditAttachment;
                             END;
                              }

    { 4   ;1   ;Group     ;
                Name=RecurringOptions;
                CaptionML=[DAN=Gentagelse;
                           ENU=Recurring];
                GroupType=Group }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Tilbagevendende opgave;
                           ENU=Recurring Task];
                ToolTipML=[DAN=Angiver, at opgaven forekommer regelm�ssigt.;
                           ENU=Specifies that the Task occurs periodically.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Recurring;
                OnValidate=BEGIN
                             RecurringOnAfterValidate;
                           END;
                            }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=Gentagelsesinterval;
                           ENU=Recurring Date Interval];
                ToolTipML=[DAN=Angiver den datoformel, som programmet bruger til automatisk at tildele en tilbagevendende opgave til en s�lger eller et team.;
                           ENU=Specifies the date formula to assign automatically a recurring Task to a Salesperson or Team.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Recurring Date Interval";
                Enabled=RecurringDateIntervalEnable }

    { 34  ;2   ;Field     ;
                CaptionML=[DAN=Beregn fra dato;
                           ENU=Calculate from Date];
                ToolTipML=[DAN=Angiver datoen, der skal bruges til at beregne datoen, hvor n�ste opgave skal v�re afsluttet.;
                           ENU=Specifies the date to use to calculate the date on which the next Task should be completed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Calc. Due Date From";
                Enabled=CalcDueDateFromEnable }

  }
  CODE
  {
    VAR
      Text000@1025 : TextConst 'DAN=(Flere);ENU=(Multiple)';
      Text001@1001 : TextConst 'DAN=ikke navngivet;ENU=untitled';
      Cont@1004 : Record 5050;
      SalesPurchPerson@1005 : Record 13;
      Campaign@1006 : Record 5071;
      Team@1007 : Record 5083;
      Opp@1008 : Record 5092;
      SegHeader@1009 : Record 5076;
      AttendeeTemp@1012 : TEMPORARY Record 5199;
      ClientTypeManagement@1003 : Codeunit 4;
      SalespersonFilter@1026 : Code[20];
      ContactFilter@1030 : Code[20];
      TeamTaskEditable@19073246 : Boolean INDATASET;
      WizardContactNameEditable@19024232 : Boolean INDATASET;
      WizardCampaignDescriptionEdita@19073396 : Boolean INDATASET;
      WizardOpportunityDescriptionEd@19027967 : Boolean INDATASET;
      SalespersonCodeEditable@19071610 : Boolean INDATASET;
      SegmentDescEditable@19045407 : Boolean INDATASET;
      IsMeeting@1000 : Boolean;
      IsOnMobile@1002 : Boolean;
      SalespersonCodeEnable@19074307 : Boolean INDATASET;
      StartTimeEnable@19064228 : Boolean INDATASET;
      EndingTimeEnable@19019613 : Boolean INDATASET;
      DurationEnable@19035217 : Boolean INDATASET;
      LocationEnable@19013618 : Boolean INDATASET;
      AllDayEventEnable@19049519 : Boolean INDATASET;
      WizardContactNameEnable@19059568 : Boolean INDATASET;
      RecurringDateIntervalEnable@19019953 : Boolean INDATASET;
      CalcDueDateFromEnable@19036769 : Boolean INDATASET;
      LanguageCodeEnable@19042658 : Boolean INDATASET;
      AttachmentEnable@19033701 : Boolean INDATASET;

    LOCAL PROCEDURE Caption@1() : Text[260];
    VAR
      CaptionStr@1000 : Text[260];
    BEGIN
      IF Cont.GET(GETFILTER("Contact Company No.")) THEN
        CaptionStr := COPYSTR(Cont."No." + ' ' + Cont.Name,1,MAXSTRLEN(CaptionStr));
      IF Cont.GET(GETFILTER("Contact No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Cont."No." + ' ' + Cont.Name,1,MAXSTRLEN(CaptionStr));
      IF SalesPurchPerson.GET(GETFILTER("Salesperson Code")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + SalesPurchPerson.Code + ' ' + SalesPurchPerson.Name,1,MAXSTRLEN(CaptionStr));
      IF Team.GET(GETFILTER("Team Code")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Team.Code + ' ' + Team.Name,1,MAXSTRLEN(CaptionStr));
      IF Campaign.GET(GETFILTER("Campaign No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Campaign."No." + ' ' + Campaign.Description,1,MAXSTRLEN(CaptionStr));
      IF Opp.GET(GETFILTER("Opportunity No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Opp."No." + ' ' + Opp.Description,1,MAXSTRLEN(CaptionStr));
      IF SegHeader.GET(GETFILTER("Segment No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + SegHeader."No." + ' ' + SegHeader.Description,1,MAXSTRLEN(CaptionStr));
      IF CaptionStr = '' THEN
        CaptionStr := Text001;

      EXIT(CaptionStr);
    END;

    LOCAL PROCEDURE EnableFields@21();
    BEGIN
      RecurringDateIntervalEnable := Recurring;
      CalcDueDateFromEnable := Recurring;

      IF NOT Recurring THEN BEGIN
        EVALUATE("Recurring Date Interval",'');
        CLEAR("Calc. Due Date From");
      END;

      IsMeeting := Type = Type::Meeting;

      IF IsMeeting THEN BEGIN
        StartTimeEnable := NOT "All Day Event";
        EndingTimeEnable := NOT "All Day Event";
        DurationEnable := NOT "All Day Event";
        LocationEnable := TRUE;
        AllDayEventEnable := TRUE;
        LanguageCodeEnable := "Interaction Template Code" <> '';
        AttachmentEnable := "Interaction Template Code" <> '';
      END ELSE BEGIN
        StartTimeEnable := FALSE;
        EndingTimeEnable := FALSE;
        LocationEnable := FALSE;
        DurationEnable := FALSE;
        AllDayEventEnable := FALSE;
      END;
    END;

    LOCAL PROCEDURE TypeOnAfterValidate@19069045();
    BEGIN
      EnableFields;
    END;

    LOCAL PROCEDURE AllDayEventOnAfterValidate@19020274();
    BEGIN
      EnableFields;
    END;

    LOCAL PROCEDURE RecurringOnAfterValidate@19068337();
    BEGIN
      EnableFields;
    END;

    LOCAL PROCEDURE InteractionTemplateCodeOnAfter@19000597();
    BEGIN
      EnableFields
    END;

    LOCAL PROCEDURE WizardContactNameOnFormat@19031225(Text@19070643 : Text[1024]);
    BEGIN
      IF SegHeader.GET(GETFILTER("Segment No.")) THEN
        Text := Text000;
    END;

    LOCAL PROCEDURE FinishPage@2();
    BEGIN
      CurrPage.AttendeeSubform.PAGE.GetAttendee(AttendeeTemp);
      SetAttendee(AttendeeTemp);

      CheckStatus;
      FinishWizard(FALSE);
    END;

    BEGIN
    END.
  }
}

