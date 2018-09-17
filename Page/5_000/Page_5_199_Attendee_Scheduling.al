OBJECT Page 5199 Attendee Scheduling
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Deltagerplanl‘gning;
               ENU=Attendee Scheduling];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5080;
    PageType=Document;
    OnInit=BEGIN
             UnitDurationMinEnable := TRUE;
             UnitCostLCYEnable := TRUE;
             AttachmentEnable := TRUE;
             SubjectEnable := TRUE;
             LanguageCodeEnable := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       IF "No." <> "Organizer To-do No." THEN
                         CurrPage.EDITABLE := FALSE;

                       IF Closed THEN
                         CurrPage.EDITABLE := FALSE;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           EnableFields
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 30      ;1   ;ActionGroup;
                      Name=Functions;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 33      ;2   ;ActionGroup;
                      CaptionML=[DAN=Vedh‘ftet fil;
                                 ENU=Attachment];
                      Image=Attachments }
      { 32      ;3   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=bn;
                                 ENU=Open];
                      ToolTipML=[DAN=bn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Edit;
                      OnAction=BEGIN
                                 OpenAttachment(NOT CurrPage.EDITABLE);
                               END;
                                }
      { 34      ;3   ;Action    ;
                      CaptionML=[DAN=Opret;
                                 ENU=Create];
                      ToolTipML=[DAN=Opret en vedh‘ftet fil.;
                                 ENU=Create an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=New;
                      OnAction=BEGIN
                                 CreateAttachment(NOT CurrPage.EDITABLE);
                               END;
                                }
      { 35      ;3   ;Action    ;
                      CaptionML=[DAN=Indl‘s;
                                 ENU=Import];
                      ToolTipML=[DAN=Indl‘s en vedh‘ftet fil.;
                                 ENU=Import an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Import;
                      OnAction=BEGIN
                                 ImportAttachment;
                               END;
                                }
      { 36      ;3   ;Action    ;
                      CaptionML=[DAN=Udl‘s;
                                 ENU=Export];
                      ToolTipML=[DAN=Udl‘s en vedh‘ftet fil.;
                                 ENU=Export an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Export;
                      OnAction=BEGIN
                                 ExportAttachment;
                               END;
                                }
      { 37      ;3   ;Action    ;
                      CaptionML=[DAN=Slet;
                                 ENU=Remove];
                      ToolTipML=[DAN=Fjern en vedh‘ftet fil.;
                                 ENU=Remove an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Cancel;
                      OnAction=BEGIN
                                 RemoveAttachment(TRUE);
                               END;
                                }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Send invitationer;
                                 ENU=Send Invitations];
                      ToolTipML=[DAN=Send invitation til deltageren.;
                                 ENU=Send invitation to the attendee.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=DistributionGroup;
                      OnAction=BEGIN
                                 SendMAPIInvitations(Rec,FALSE);
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
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af posten.;
                           ENU=Specifies the description of the task.];
                ApplicationArea=#All;
                SourceExpr=Description;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sted, hvor m›det skal foreg†.;
                           ENU=Specifies the location where the meeting will take place.];
                ApplicationArea=#Advanced;
                SourceExpr=Location;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, der er tildelt til opgaven.;
                           ENU=Specifies the code of the salesperson assigned to the task.];
                ApplicationArea=#Suite,#RelationshipMgmt;
                SourceExpr="Salesperson Code";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opgavens type.;
                           ENU=Specifies the type of the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Type;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver opgavens status. Der er fem indstillinger: Ikke startet; Igangsat; Afsluttet, Venter og Udskudt.";
                           ENU=Specifies the status of the task. There are five options: Not Started, In Progress, Completed, Waiting and Postponed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Status;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opgavens prioritet.;
                           ENU=Specifies the priority of the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Priority;
                Editable=FALSE }

    { 29  ;1   ;Part      ;
                Name=AttendeeSubform;
                ApplicationArea=#Advanced;
                SubPageView=SORTING(To-do No.,Line No.);
                SubPageLink=To-do No.=FIELD(Organizer To-do No.);
                PagePartID=Page5197;
                PartType=Page }

    { 1907335101;1;Group  ;
                CaptionML=[DAN=Interaktion;
                           ENU=Interaction] }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den interaktionsskabelon, som du har valgt.;
                           ENU=Specifies the code for the interaction template that you have selected.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Interaction Template Code";
                OnValidate=BEGIN
                             InteractionTemplateCodeOnAfter;
                           END;
                            }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Language Code";
                Enabled=LanguageCodeEnable }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opgavens emne. Emnet bruges til mails eller Outlook-m›der, som du opretter.;
                           ENU=Specifies the subject of the task. The subject is used for e-mail messages or Outlook meetings that you create.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Subject;
                Enabled=SubjectEnable }

    { 27  ;2   ;Field     ;
                Name=Attachment;
                AssistEdit=Yes;
                CaptionML=[DAN=Vedh‘ftet fil;
                           ENU=Attachment];
                ToolTipML=[DAN=Angiver, om den tilknyttede vedh‘ftede fil er overf›rt eller entydig.;
                           ENU=Specifies if the linked attachment is inherited or unique.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Attachment No." > 0;
                Enabled=AttachmentEnable;
                OnAssistEdit=BEGIN
                               MaintainAttachment;
                             END;
                              }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Unit Cost (LCY)";
                Enabled=UnitCostLCYEnable }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varigheden af interaktionen.;
                           ENU=Specifies the duration of the interaction.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Unit Duration (Min.)";
                Enabled=UnitDurationMinEnable }

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
      LanguageCodeEnable@19042658 : Boolean INDATASET;
      SubjectEnable@19013405 : Boolean INDATASET;
      AttachmentEnable@19033701 : Boolean INDATASET;
      UnitCostLCYEnable@19056514 : Boolean INDATASET;
      UnitDurationMinEnable@19041420 : Boolean INDATASET;

    LOCAL PROCEDURE MaintainAttachment@13();
    BEGIN
      IF "Interaction Template Code" = '' THEN
        EXIT;

      IF "Attachment No." <> 0 THEN BEGIN
        IF NOT CurrPage.EDITABLE THEN BEGIN
          CurrPage.EDITABLE := TRUE;
          OpenAttachment(TRUE);
          CurrPage.EDITABLE := FALSE;
        END ELSE
          OpenAttachment(FALSE);
      END ELSE
        CreateAttachment(NOT CurrPage.EDITABLE);
    END;

    LOCAL PROCEDURE EnableFields@1();
    BEGIN
      LanguageCodeEnable := "Interaction Template Code" <> '';
      SubjectEnable := "Interaction Template Code" <> '';
      AttachmentEnable := "Interaction Template Code" <> '';
      UnitCostLCYEnable := "Interaction Template Code" <> '';
      UnitDurationMinEnable := "Interaction Template Code" <> ''
    END;

    LOCAL PROCEDURE InteractionTemplateCodeOnAfter@19000597();
    BEGIN
      EnableFields
    END;

    BEGIN
    END.
  }
}

