OBJECT Page 5077 Create Interaction
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opret interaktion;
               ENU=Create Interaction];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5077;
    DataCaptionExpr=Caption;
    PageType=Card;
    ShowFilter=No;
    OnInit=BEGIN
             SalespersonCodeEditable := TRUE;
             OpportunityDescriptionEditable := TRUE;
             CampaignDescriptionEditable := TRUE;
             IsOnMobile := ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Phone;
           END;

    OnOpenPage=BEGIN
                 CampaignDescriptionEditable := FALSE;
                 OpportunityDescriptionEditable := FALSE;
                 IsContactEditable := (GETFILTER("Contact No.") = '') AND (GETFILTER("Contact Company No.") = '');
                 UpdateUIFlags;

                 IF SalesPurchPerson.GET(GETFILTER("Salesperson Code")) THEN
                   SalespersonCodeEditable := FALSE;

                 AttachmentReload;

                 IsFinished := FALSE;
                 CurrPage.UPDATE(FALSE);
               END;

    OnQueryClosePage=BEGIN
                       IF IsFinished THEN
                         EXIT;

                       FinishWizard(CloseAction IN [ACTION::OK,ACTION::LookupOK]);
                     END;

    ActionList=ACTIONS
    {
      { 8       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis udskrift;
                                 ENU=Preview];
                      ToolTipML=[DAN=Test ops‘tningen af interaktionen.;
                                 ENU=Test the setup of the interaction.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Visible=HTMLAttachment;
                      Enabled=HTMLAttachment;
                      PromotedIsBig=Yes;
                      Image=PreviewChecks;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PreviewHTMLContent;
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=Finish;
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Visible=IsOnMobile;
                      Enabled=IsMainInfoSet;
                      InFooterBar=Yes;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 FinishWizard(TRUE);
                                 IsFinished := TRUE;
                                 CurrPage.CLOSE;
                               END;
                                }
      { 7       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=ViewComments;
                      OnAction=BEGIN
                                 ShowComment;
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

    { 23  ;2   ;Field     ;
                Lookup=No;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver den kontakt, som du interagerer med.;
                           ENU=Specifies the contact that you are interacting with.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Wizard Contact Name";
                Editable=IsContactEditable;
                OnValidate=VAR
                             Contact@1000 : Record 5050;
                             FilterWithoutQuotes@1001 : Text;
                           BEGIN
                             "Wizard Contact Name" := DELCHR("Wizard Contact Name",'<>');
                             IF "Wizard Contact Name" = "Contact Name" THEN
                               EXIT;
                             IF "Wizard Contact Name" = '' THEN
                               CLEAR(Contact)
                             ELSE BEGIN
                               FilterWithoutQuotes := CONVERTSTR("Wizard Contact Name",'''','?');
                               Contact.SETFILTER(Name,'''@*' + FilterWithoutQuotes + '*''');
                               IF NOT Contact.FINDFIRST THEN
                                 CLEAR(Contact);
                             END;
                             SetContactNo(Contact)
                           END;

                OnAssistEdit=VAR
                               Contact@1000 : Record 5050;
                             BEGIN
                               IF IsContactEditable THEN BEGIN
                                 IF Contact.GET("Contact No.") THEN;
                                 IF PAGE.RUNMODAL(0,Contact) = ACTION::LookupOK THEN
                                   SetContactNo(Contact);
                               END;
                             END;

                ShowMandatory=TRUE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for interaktionen.;
                           ENU=Specifies the type of the interaction.];
                ApplicationArea=#RelationshipMgmt;
                NotBlank=Yes;
                SourceExpr="Interaction Template Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             UpdateUIFlags;

                             IF Campaign.GET("Campaign No.") THEN
                               "Campaign Description" := Campaign.Description;

                             IF "Attachment No." <> xRec."Attachment No." THEN
                               AttachmentReload;
                           END;

                ShowMandatory=TRUE }

    { 27  ;2   ;Field     ;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver, hvad interaktionen omhandler.;
                           ENU=Specifies what the interaction is about.];
                ApplicationArea=#RelationshipMgmt;
                NotBlank=Yes;
                SourceExpr=Description;
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=S‘lger;
                           ENU=Salesperson];
                ToolTipML=[DAN=Angiver den s‘lger, som er ansvarlig for denne interaktion.;
                           ENU=Specifies the salesperson who is responsible for this interaction.];
                ApplicationArea=#Suite,#RelationshipMgmt;
                SourceExpr="Salesperson Code";
                Editable=SalespersonCodeEditable;
                ShowMandatory=TRUE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Language Code";
                Enabled=IsMainInfoSet;
                OnValidate=BEGIN
                             IF "Attachment No." <> xRec."Attachment No." THEN
                               AttachmentReload;
                           END;

                OnLookup=BEGIN
                           LanguageCodeOnLookup;
                           IF "Attachment No." <> xRec."Attachment No." THEN
                             AttachmentReload;
                         END;
                          }

    { 4   ;1   ;Group     ;
                Name=BodyContent;
                CaptionML=[DAN=Indhold;
                           ENU=Content];
                Visible=HTMLAttachment;
                GroupType=Group }

    { 5   ;2   ;Field     ;
                Name=HTMLContentBodyText;
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=HTMLContentBodyText;
                MultiLine=Yes;
                OnValidate=BEGIN
                             UpdateContentBodyTextInCustomLayoutAttachment(HTMLContentBodyText);
                           END;

                ShowCaption=No }

    { 3   ;1   ;Group     ;
                Name=InteractionDetails;
                CaptionML=[DAN=Detaljer om interaktion;
                           ENU=Interaction Details];
                Enabled=IsMainInfoSet;
                GroupType=Group }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver korrespondancetypen for interaktionen. BEM’RK: Hvis du bruger webklient, m† du ikke v‘lge indstillingen Papirformat, fordi det ikke er muligt at udskrive fra webklienten.;
                           ENU=Specifies the type of correspondence for the interaction. NOTE: If you use the Web client, you must not select the Hard Copy option because printing is not possible from the web client.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Correspondence Type";
                Importance=Additional;
                Enabled=IsMainInfoSet;
                OnValidate=BEGIN
                             ValidateCorrespondenceType;
                           END;
                            }

    { 50  ;2   ;Field     ;
                CaptionML=[DAN=Dato for interaktion;
                           ENU=Date of Interaction];
                ToolTipML=[DAN=Angiver den dato, hvor interaktionen foregik.;
                           ENU=Specifies the date when the interaction took place.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Date;
                Importance=Additional;
                Enabled=IsMainInfoSet }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor interaktionen foregik;
                           ENU=Specifies the time when the interaction took place];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Time of Interaction";
                Importance=Additional;
                Enabled=IsMainInfoSet }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver retningen for interaktionen: indg†ende eller udg†ende.;
                           ENU=Specifies the direction of the interaction, inbound or outbound.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Information Flow";
                Importance=Additional;
                Enabled=IsMainInfoSet }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om interaktionen blev iv‘rksat af din virksomhed eller en af dine kontakter. Indstillingen Os angiver, at din virksomhed var initiativtageren, mens indstillingen Dem angiver, at en kontakt var initiativtageren.;
                           ENU="Specifies if the interaction was initiated by your company or by one of your contacts. The Us option indicates that your company was the initiator; the Them option indicates that a contact was the initiator."];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Initiated By";
                Importance=Additional;
                Enabled=IsMainInfoSet }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver evalueringen af den interaktion, som vedr›rer kontakten i m†lgruppen.;
                           ENU=Specifies the evaluation of the interaction involving the contact in the segment.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Evaluation;
                Importance=Additional;
                Enabled=IsMainInfoSet }

    { 36  ;2   ;Field     ;
                CaptionML=[DAN=Lykkedes;
                           ENU=Was Successful];
                ToolTipML=[DAN=Angiver, om interaktionen lykkedes. Ryd dette afkrydsningsfelt for at angive, at interaktionen ikke lykkedes.;
                           ENU=Specifies if the interaction was successful. Clear this check box to indicate that the interaction was not a success.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Interaction Successful";
                Importance=Additional;
                Enabled=IsMainInfoSet }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningerne for interaktionen med den kontakt, som denne m†lgruppelinje g‘lder for.;
                           ENU=Specifies the cost of the interaction with the contact that this segment line applies to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Cost (LCY)";
                Importance=Additional;
                Enabled=IsMainInfoSet }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varigheden af interaktionen med kontakten.;
                           ENU=Specifies the duration of the interaction with the contact.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Duration (Min.)";
                Importance=Additional;
                Enabled=IsMainInfoSet }

    { 20  ;2   ;Field     ;
                Lookup=No;
                CaptionML=[DAN=Kampagne;
                           ENU=Campaign];
                ToolTipML=[DAN=Angiver den kampagne, der er relateret til m†lgruppen. Beskrivelsen kopieres fra kampagnekortet.;
                           ENU=Specifies the campaign that is related to the segment. The description is copied from the campaign card.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Description";
                TableRelation=Campaign;
                Importance=Promoted;
                Enabled=IsMainInfoSet;
                Editable=CampaignDescriptionEditable;
                OnAssistEdit=VAR
                               Campaign@1102601000 : Record 5071;
                             BEGIN
                               IF GETFILTER("Campaign No.") = '' THEN BEGIN
                                 IF Campaign.GET("Campaign No.") THEN ;
                                 IF PAGE.RUNMODAL(0,Campaign) = ACTION::LookupOK THEN BEGIN
                                   VALIDATE("Campaign No.",Campaign."No.");
                                   "Campaign Description" := Campaign.Description;
                                 END;
                               END;
                             END;
                              }

    { 51  ;2   ;Field     ;
                CaptionML=[DAN=Kontakt er m†lgruppe;
                           ENU=Contact is Targeted];
                ToolTipML=[DAN=Angiver, at den m†lgruppe, der er involveret i interaktionen, er m†l for en kampagne. Det anvendes til at m†le svarprocenten for en kampagne.;
                           ENU=Specifies that the segment involved in this interaction is the target of a campaign. This is used to measure the response rate of a campaign.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Target";
                Importance=Additional;
                Enabled=IsMainInfoSet }

    { 53  ;2   ;Field     ;
                CaptionML=[DAN=Kampagnereaktion;
                           ENU=Campaign Response];
                ToolTipML=[DAN=Angiver, at den interaktion, der er oprettet for m†lgruppen, er resultatet af en kampagne. F.eks. kan du registrere kuponer, der sendes som svar p† en kampagne.;
                           ENU=Specifies that the interaction created for the segment is the response to a campaign. For example, coupons that are sent as a response to a campaign.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Response";
                Importance=Additional;
                Enabled=IsMainInfoSet }

    { 54  ;2   ;Field     ;
                Lookup=No;
                CaptionML=[DAN=Salgsmulighed;
                           ENU=Opportunity];
                ToolTipML=[DAN=Angiver en beskrivelse af den salgsmulighed, der er relateret til m†lgruppen. Beskrivelsen kopieres fra salgsmulighedskortet.;
                           ENU=Specifies a description of the opportunity that is related to the segment. The description is copied from the opportunity card.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Opportunity Description";
                TableRelation=Opportunity;
                Importance=Promoted;
                Enabled=IsMainInfoSet;
                Editable=OpportunityDescriptionEditable;
                OnAssistEdit=VAR
                               Opportunity@1000 : Record 5092;
                             BEGIN
                               FilterContactCompanyOpportunities(Opportunity);
                               IF PAGE.RUNMODAL(0,Opportunity) = ACTION::LookupOK THEN BEGIN
                                 VALIDATE("Opportunity No.",Opportunity."No.");
                                 "Opportunity Description" := Opportunity.Description;
                               END;
                             END;
                              }

  }
  CODE
  {
    VAR
      SalesPurchPerson@1007 : Record 13;
      Campaign@1008 : Record 5071;
      Task@1022 : Record 5080;
      ClientTypeManagement@1001 : Codeunit 4;
      HTMLContentBodyText@1011 : Text;
      CampaignDescriptionEditable@19061248 : Boolean INDATASET;
      OpportunityDescriptionEditable@19023234 : Boolean INDATASET;
      SalespersonCodeEditable@19071610 : Boolean INDATASET;
      IsMainInfoSet@1002 : Boolean;
      HTMLAttachment@1010 : Boolean;
      UntitledTxt@1004 : TextConst 'DAN=ikke navngivet;ENU=untitled';
      IsOnMobile@1005 : Boolean;
      IsFinished@1012 : Boolean;
      IsContactEditable@1000 : Boolean;

    LOCAL PROCEDURE Caption@1() : Text[260];
    VAR
      Contact@1001 : Record 5050;
      CaptionStr@1000 : Text[260];
    BEGIN
      IF Contact.GET(GETFILTER("Contact Company No.")) THEN
        CaptionStr := COPYSTR(Contact."No." + ' ' + Contact.Name,1,MAXSTRLEN(CaptionStr));
      IF Contact.GET(GETFILTER("Contact No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Contact."No." + ' ' + Contact.Name,1,MAXSTRLEN(CaptionStr));
      IF SalesPurchPerson.GET(GETFILTER("Salesperson Code")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + SalesPurchPerson.Code + ' ' + SalesPurchPerson.Name,1,MAXSTRLEN(CaptionStr));
      IF Campaign.GET(GETFILTER("Campaign No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Campaign."No." + ' ' + Campaign.Description,1,MAXSTRLEN(CaptionStr));
      IF Task.GET(GETFILTER("To-do No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Task."No." + ' ' + Task.Description,1,MAXSTRLEN(CaptionStr));

      IF CaptionStr = '' THEN
        CaptionStr := UntitledTxt;

      EXIT(CaptionStr);
    END;

    LOCAL PROCEDURE UpdateUIFlags@3();
    BEGIN
      IsMainInfoSet := "Interaction Template Code" <> '';
    END;

    LOCAL PROCEDURE AttachmentReload@4();
    BEGIN
      LoadAttachment(TRUE);
      HTMLAttachment := IsHTMLAttachment;
      IF HTMLAttachment THEN
        HTMLContentBodyText := LoadContentBodyTextFromCustomLayoutAttachment;
    END;

    LOCAL PROCEDURE SetContactNo@6(Contact@1000 : Record 5050);
    BEGIN
      VALIDATE("Contact No.",Contact."No.");
      "Wizard Contact Name" := Contact.Name;
    END;

    BEGIN
    END.
  }
}

