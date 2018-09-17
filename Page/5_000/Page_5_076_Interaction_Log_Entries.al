OBJECT Page 5076 Interaction Log Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Interaktionslogposter;
               ENU=Interaction Log Entries];
    SourceTable=Table5065;
    SourceTableView=WHERE(Postponed=CONST(No));
    PageType=List;
    OnInit=BEGIN
             ShowEnable := TRUE;
           END;

    OnOpenPage=BEGIN
                 SetCaption;
               END;

    OnFindRecord=VAR
                   RecordsFound@1001 : Boolean;
                 BEGIN
                   RecordsFound := FIND(Which);
                   ShowEnable := RecordsFound;
                   EXIT(RecordsFound);
                 END;

    OnAfterGetRecord=BEGIN
                       ShowCreateOpportunity := CanCreateOpportunity;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           CALCFIELDS("Contact Name","Contact Company Name");
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 80      ;1   ;ActionGroup;
                      Name=Entry;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 11      ;2   ;Action    ;
                      Name=Filter;
                      CaptionML=[DAN=Filtr‚r;
                                 ENU=Filter];
                      ToolTipML=[DAN=Anvend et filter for at f† vist bestemte interaktionslogposterne.;
                                 ENU=Apply a filter to view specific interaction log entries.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=Filter;
                      OnAction=VAR
                                 FilterPageBuilder@1000 : FilterPageBuilder;
                               BEGIN
                                 FilterPageBuilder.ADDTABLE(TABLENAME,DATABASE::"Interaction Log Entry");
                                 FilterPageBuilder.SETVIEW(TABLENAME,GETVIEW);

                                 IF GETFILTER("Campaign No.") = '' THEN
                                   FilterPageBuilder.ADDFIELDNO(TABLENAME,FIELDNO("Campaign No."));
                                 IF GETFILTER("Segment No.") = '' THEN
                                   FilterPageBuilder.ADDFIELDNO(TABLENAME,FIELDNO("Segment No."));
                                 IF GETFILTER("Salesperson Code") = '' THEN
                                   FilterPageBuilder.ADDFIELDNO(TABLENAME,FIELDNO("Salesperson Code"));
                                 IF GETFILTER("Contact No.") = '' THEN
                                   FilterPageBuilder.ADDFIELDNO(TABLENAME,FIELDNO("Contact No."));
                                 IF GETFILTER("Contact Company No.") = '' THEN
                                   FilterPageBuilder.ADDFIELDNO(TABLENAME,FIELDNO("Contact Company No."));

                                 IF FilterPageBuilder.RUNMODAL THEN
                                   SETVIEW(FilterPageBuilder.GETVIEW(TABLENAME));
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=ClearFilter;
                      CaptionML=[DAN=Ryd filter;
                                 ENU=Clear Filter];
                      ToolTipML=[DAN=Ryd det anvendte filter p† bestemte interaktionslogposter.;
                                 ENU=Clear the applied filter on specific interaction log entries.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=ClearFilter;
                      OnAction=BEGIN
                                 RESET;
                                 FILTERGROUP(2);
                                 SETRANGE(Postponed,FALSE);
                                 FILTERGROUP(0);
                               END;
                                }
      { 83      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5187;
                      RunPageLink=Entry No.=FIELD(Entry No.);
                      Image=ViewComments }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 57      ;1   ;ActionGroup;
                      Name=Functions;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 59      ;2   ;Action    ;
                      CaptionML=[DAN=Skift &markering i Annulleret;
                                 ENU=Switch Check&mark in Canceled];
                      ToolTipML=[DAN=Skift records, der har en markering i Annulleret.;
                                 ENU=Change records that have a checkmark in Canceled.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=ReopenCancelled;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(InteractionLogEntry);
                                 InteractionLogEntry.ToggleCanceledCheckmark;
                               END;
                                }
      { 61      ;2   ;Action    ;
                      CaptionML=[DAN=Send igen;
                                 ENU=Resend];
                      ToolTipML=[DAN=Send de vedh‘ftede filer igen.;
                                 ENU=Resend the attachments.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Reuse;
                      OnAction=VAR
                                 InteractLogEntry@1001 : Record 5065;
                               BEGIN
                                 InteractLogEntry.SETRANGE("Logged Segment Entry No.","Logged Segment Entry No.");
                                 InteractLogEntry.SETRANGE("Entry No.","Entry No.");
                                 REPORT.RUNMODAL(REPORT::"Resend Attachments",TRUE,FALSE,InteractLogEntry);
                               END;
                                }
      { 85      ;2   ;Action    ;
                      CaptionML=[DAN=Evaluer interaktion;
                                 ENU=Evaluate Interaction];
                      ToolTipML=[DAN=Foretag en vurdering af interaktionen.;
                                 ENU=Make an evaluation of the interaction.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Evaluate;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(InteractionLogEntry);
                                 InteractionLogEntry.EvaluateInteraction;
                               END;
                                }
      { 75      ;2   ;Separator  }
      { 76      ;2   ;Action    ;
                      AccessByPermission=TableData 5080=R;
                      CaptionML=[DAN=Opret opgave;
                                 ENU=Create Task];
                      ToolTipML=[DAN=Opret en marketingopgave, der er baseret p† interaktionen.;
                                 ENU=Create a marketing task based on the interaction.];
                      ApplicationArea=#Advanced;
                      Image=NewToDo;
                      OnAction=BEGIN
                                 CreateTask;
                               END;
                                }
      { 2       ;1   ;Action    ;
                      Name=Show Attachments;
                      CaptionML=[DAN=Vi&s vedh‘ftede filer;
                                 ENU=&Show Attachments];
                      ToolTipML=[DAN=Viser vedh‘ftede filer eller tilknyttede bilag.;
                                 ENU=Show attachments or related documents.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Enabled=ShowEnable;
                      Image=View;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF "Attachment No." <> 0 THEN
                                   OpenAttachment
                                 ELSE
                                   ShowDocument;
                               END;
                                }
      { 60      ;1   ;Action    ;
                      CaptionML=[DAN=O&pret interaktion;
                                 ENU=Create &Interaction];
                      ToolTipML=[DAN=Opret en interaktion med en bestemt kontakt.;
                                 ENU=Create an interaction with a specified contact.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=CreateInteraction;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CreateInteraction;
                               END;
                                }
      { 15      ;1   ;Action    ;
                      Name=CreateOpportunity;
                      CaptionML=[DAN=Opret salgsmulighed;
                                 ENU=Create Opportunity];
                      ToolTipML=[DAN=Opret en salgsmulighed med en bestemt kontakt.;
                                 ENU=Create an opportunity with a specified contact.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Enabled=ShowCreateOpportunity;
                      Image=NewOpportunity;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 InteractionMgt@1000 : Codeunit 5067;
                               BEGIN
                                 AssignNewOpportunity;
                                 InteractionMgt.ShowNotificationOpportunityCreated(Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;

                      Gesture=None }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om interaktionen er blevet annulleret. Feltet kan ikke redigeres.;
                           ENU=Specifies whether the interaction has been canceled. The field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Canceled }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om interaktionen registrerer et mislykket fors›g p† at komme i forbindelse med kontakten. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies whether the interaction records an failed attempt to reach the contact. This field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Attempt Failed" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dokumenttype, som er registreret med interaktionslogrecorden. Du kan ikke ‘ndre indholdet i feltet.;
                           ENU=Specifies the type of document if there is one that the interaction log entry records. You cannot change the contents of this field.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Type";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bilag (hvis relevant), som er registreret med disse interaktionslogrecords.;
                           ENU=Specifies the number of the document (if any) that the interaction log entry records.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for afsendelse af den vedh‘ftede fil. Der er 3 indstillinger:;
                           ENU=Specifies the status of the delivery of the attachment. There are three options:];
                ApplicationArea=#Advanced;
                SourceExpr="Delivery Status";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som du angav i feltet Dato i guiden Opret interaktion eller vinduet M†lgruppe, da du oprettede interaktionen. Feltet kan ikke redigeres.;
                           ENU=Specifies the date that you have entered in the Date field in the Create Interaction wizard or the Segment window when you created the interaction. The field is not editable.];
                ApplicationArea=#All;
                SourceExpr=Date }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver klokkesl‘ttet for oprettelsen af interaktionen. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies the time when the interaction was created. This field is not editable.];
                ApplicationArea=#Advanced;
                SourceExpr="Time of Interaction";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver korrespondancetypen for den vedh‘ftede fil i interaktionsskabelonen. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies the type of correspondence of the attachment in the interaction template. This field is not editable.];
                ApplicationArea=#Advanced;
                SourceExpr="Correspondence Type";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den interaktionsgruppe, der anvendes til at oprette denne interaktion. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies the code of the interaction group used to create this interaction. This field is not editable.];
                ApplicationArea=#Advanced;
                SourceExpr="Interaction Group Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den interaktionsskabelon, der anvendes til at oprette interaktionen. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies the code for the interaction template used to create the interaction. This field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Interaction Template Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af interaktionen.;
                           ENU=Specifies the description of the interaction.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 3   ;2   ;Field     ;
                Name=Attachment;
                CaptionML=[DAN=Vedh‘ftet fil;
                           ENU=Attachment];
                ToolTipML=[DAN=Angiver, om den tilknyttede vedh‘ftede fil er overf›rt eller entydig.;
                           ENU=Specifies if the linked attachment is inherited or unique.];
                ApplicationArea=#RelationshipMgmt;
                BlankZero=Yes;
                SourceExpr="Attachment No." <> 0;
                OnAssistEdit=BEGIN
                               IF "Attachment No." <> 0 THEN
                                 OpenAttachment;
                             END;
                              }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver retningen p† informationsstr›mmen, der registreres af interaktionen. Der er to indstillinger: Udg†ende (oplysningerne blev modtaget af kontakten) og Indg†ende (oplysningerne blev modtaget af din virksomhed).;
                           ENU=Specifies the direction of information flow recorded by the interaction. There are two options: Outbound (the information was received by your contact) and Inbound (the information was received by your company).];
                ApplicationArea=#Advanced;
                SourceExpr="Information Flow";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvem der startede interaktionen. Der er to indstillinger: Os (interaktionen blev iv‘rksat af din virksomhed) og Dem (oplysningerne blev iv‘rksat af kontakten).;
                           ENU=Specifies who initiated the interaction. There are two options: Us (the interaction was initiated by your company) and Them (the interaction was initiated by your contact).];
                ApplicationArea=#Advanced;
                SourceExpr="Initiated By";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontakten i denne interaktion. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies the number of the contact involved in this interaction. This field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact No." }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kontakt, der er logf›rt en interaktion for.;
                           ENU=Specifies the name of the contact for which an interaction has been logged.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Name" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktvirksomheden.;
                           ENU=Specifies the number of the contact company.];
                ApplicationArea=#Advanced;
                SourceExpr="Contact Company No.";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kontaktvirksomhed, der er logf›rt en interaktion for.;
                           ENU=Specifies the name of the contact company for which an interaction has been logged.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Company Name" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver evalueringen af interaktionen. Der er fem indstillinger: Meget positiv, Positiv, Neutral, Negativ og Meget negativ.;
                           ENU=Specifies the evaluation of the interaction. There are five options: Very Positive, Positive, Neutral, Negative, and Very Negative.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Evaluation }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningerne for interaktionen.;
                           ENU=Specifies the cost of the interaction.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Cost (LCY)" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varigheden af interaktionen.;
                           ENU=Specifies the duration of the interaction.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Duration (Min.)" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, der udf›rte interaktionen. Du kan ikke ‘ndre oplysninger i feltet.;
                           ENU=Specifies the code for the salesperson who carried out the interaction. This field is not editable.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, som logf›rte posten. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies the ID of the user who logged this entry. This field is not editable.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver m†lgruppens nummer. Feltet kan kun anvendes til interaktioner, der er oprettet til m†lgrupper, og kan ikke redigeres.;
                           ENU=Specifies the number of the segment. This field is valid only for interactions created for segments, and is not editable.];
                ApplicationArea=#Advanced;
                SourceExpr="Segment No.";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne (hvis relevant), som interaktionen er knyttet til. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies the number of the campaign (if any) to which the interaction is linked. This field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No." }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagnepost, som interaktionslogposten er knyttet til.;
                           ENU=Specifies the number of the campaign entry to which the interaction log entry is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Entry No.";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om interaktionen registrerer et resultat af en kampagne.;
                           ENU=Specifies whether the interaction records a response to a campaign.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Response";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om interaktionen g‘lder kontakter, som er med i en kampagnem†lgruppe. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies whether the interaction is applied to contacts that are part of the campaign target. This field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Target";
                Visible=FALSE }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den salgsmulighed, som interaktionen er knyttet til.;
                           ENU=Specifies the number of the opportunity to which the interaction is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Opportunity No." }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† opgaven, hvis interaktionen er blevet oprettet for at fuldf›re en opgave. Dette felt kan ikke redigeres.;
                           ENU=Specifies the number of the task if the interaction has been created to complete a task. This field is not editable.];
                ApplicationArea=#Advanced;
                SourceExpr="To-do No.";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sprogkoden for interaktionen i interaktionslogfilen. Koden kopieres fra sprogkoden i interaktionsskabelonen, hvis der er angivet en.;
                           ENU=Specifies the language code for the interaction for the interaction log. The code is copied from the language code of the interaction template, if one is specified.];
                ApplicationArea=#Advanced;
                SourceExpr="Interaction Language Code";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver emneteksten, der skal bruges til denne interaktion.;
                           ENU=Specifies the subject text that will be used for this interaction.];
                ApplicationArea=#Advanced;
                SourceExpr=Subject;
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det telefonnummer, som benyttes ved opkald til kontakten.;
                           ENU=Specifies the telephone number that you used when calling the contact.];
                ApplicationArea=#Advanced;
                SourceExpr="Contact Via";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#All;
                SourceExpr="Entry No." }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der findes en bem‘rkning til denne interaktionslogpost.;
                           ENU=Specifies that a comment exists for this interaction log entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      InteractionLogEntry@1000 : Record 5065;
      ShowEnable@19017131 : Boolean INDATASET;
      ShowCreateOpportunity@1001 : Boolean;

    LOCAL PROCEDURE SetCaption@2();
    VAR
      Contact@1000 : Record 5050;
      Salesperson@1001 : Record 13;
      Task@1002 : Record 5080;
      Opportunity@1003 : Record 5092;
    BEGIN
      IF Contact.GET("Contact Company No.") THEN
        CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Contact."Company No." + ' . ' + Contact."Company Name");
      IF Contact.GET("Contact No.") THEN BEGIN
        CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Contact."No." + ' . ' + Contact.Name);
        EXIT;
      END;
      IF "Contact Company No." <> '' THEN
        EXIT;
      IF Salesperson.GET("Salesperson Code") THEN BEGIN
        CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + "Salesperson Code" + ' . ' + Salesperson.Name);
        EXIT;
      END;
      IF "Interaction Template Code" <> '' THEN BEGIN
        CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + "Interaction Template Code");
        EXIT;
      END;
      IF Task.GET("To-do No.") THEN BEGIN
        CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Task."No." + ' . ' + Task.Description);
        EXIT;
      END;
      IF Opportunity.GET("Opportunity No.") THEN
        CurrPage.CAPTION(CurrPage.CAPTION + ' - ' + Opportunity."No." + ' . ' + Opportunity.Description);
    END;

    BEGIN
    END.
  }
}

