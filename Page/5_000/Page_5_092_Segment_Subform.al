OBJECT Page 5092 Segment Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table5077;
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInsertRecord=BEGIN
                     IF "Contact No." <> '' THEN BEGIN
                       SegCriteriaManagement.InsertContact("Segment No.","Contact No.");
                       SegmentHistoryMgt.InsertLine("Segment No.","Contact No.","Line No.");
                     END;
                   END;

    OnModifyRecord=BEGIN
                     IF "Contact No." <> xRec."Contact No." THEN BEGIN
                       IF xRec."Contact No." <> '' THEN BEGIN
                         SegCriteriaManagement.DeleteContact("Segment No.",xRec."Contact No.");
                         SegmentHistoryMgt.DeleteLine("Segment No.",xRec."Contact No.","Line No.");
                       END;
                       IF "Contact No." <> '' THEN BEGIN
                         SegCriteriaManagement.InsertContact("Segment No.","Contact No.");
                         SegmentHistoryMgt.InsertLine("Segment No.","Contact No.","Line No.");
                       END;
                     END;
                   END;

    OnDeleteRecord=BEGIN
                     IF "Contact No." <> '' THEN BEGIN
                       SegCriteriaManagement.DeleteContact("Segment No.","Contact No.");
                       SegmentHistoryMgt.DeleteLine("Segment No.","Contact No.","Line No.");
                     END;
                   END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1900562404;1 ;ActionGroup;
                      CaptionML=[DAN=Linje;
                                 ENU=Line];
                      Image=Line }
      { 1902760704;2 ;ActionGroup;
                      CaptionML=[DAN=Vedh�ftet fil;
                                 ENU=Attachment];
                      Image=Attachments }
      { 1900207104;3 ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=�ben;
                                 ENU=Open];
                      ToolTipML=[DAN=�bn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Edit;
                      OnAction=BEGIN
                                 TESTFIELD("Interaction Template Code");
                                 OpenAttachment;
                               END;
                                }
      { 1901653504;3 ;Action    ;
                      CaptionML=[DAN=Opret;
                                 ENU=Create];
                      ToolTipML=[DAN=Opret en vedh�ftet fil.;
                                 ENU=Create an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=New;
                      OnAction=BEGIN
                                 CreateAttachment;
                               END;
                                }
      { 1903099904;3 ;Action    ;
                      CaptionML=[DAN=Indl�s;
                                 ENU=Import];
                      ToolTipML=[DAN=Indl�s en vedh�ftet fil.;
                                 ENU=Import an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Import;
                      OnAction=BEGIN
                                 TESTFIELD("Interaction Template Code");
                                 ImportAttachment;
                               END;
                                }
      { 1900546304;3 ;Action    ;
                      CaptionML=[DAN=Udl�s;
                                 ENU=Export];
                      ToolTipML=[DAN=Udl�s en vedh�ftet fil.;
                                 ENU=Export an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Export;
                      OnAction=BEGIN
                                 TESTFIELD("Interaction Template Code");
                                 ExportAttachment;
                               END;
                                }
      { 1901992704;3 ;Action    ;
                      CaptionML=[DAN=Fjern;
                                 ENU=Remove];
                      ToolTipML=[DAN=Fjern en vedh�ftet fil.;
                                 ENU=Remove an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Cancel;
                      OnAction=BEGIN
                                 TESTFIELD("Interaction Template Code");
                                 RemoveAttachment;
                               END;
                                }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1900545304;2 ;Action    ;
                      CaptionML=[DAN=Foretag &tlf.opkald;
                                 ENU=Make &Phone Call];
                      ToolTipML=[DAN=Ring til den valgte kontakt.;
                                 ENU=Call the selected contact.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Calls;
                      OnAction=BEGIN
                                 CreatePhoneCall;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret til den kontakt, som denne m�lgruppelinje g�lder for.;
                           ENU=Specifies the number of the contact to which this segment line applies.];
                ApplicationArea=#All;
                SourceExpr="Contact No.";
                OnValidate=BEGIN
                             ContactNoOnAfterValidate;
                           END;
                            }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver korrespondancetypen for interaktionen. BEM�RK: Hvis du bruger webklient, m� du ikke v�lge indstillingen Papirformat, fordi det ikke er muligt at udskrive fra webklienten.;
                           ENU=Specifies the type of correspondence for the interaction. NOTE: If you use the Web client, you must not select the Hard Copy option because printing is not possible from the web client.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Correspondence Type" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at Microsoft Word-dokumentet, der er knyttet til denne m�lgruppelinje, skal sendes som en vedh�ftet fil i mailmeddelelsen.;
                           ENU=Specifies that the Microsoft Word document that is linked to that segment line should be sent as an attachment in the e-mail message.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Send Word Doc. As Attmt.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for kontaktens alternative adresse, som skal bruges til denne interaktion.;
                           ENU=Specifies the code of the contact's alternate address to use for this interaction.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Alt. Address Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p� den virksomhed, som kontakten arbejder for. Hvis kontakten er en virksomhed, viser feltet virksomhedens navn.;
                           ENU=Specifies the name of the company for which the contact works. If the contact is a company, this field contains the company's name.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Company Name" }

    { 4   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p� den kontakt, som denne m�lgruppelinje g�lder for. Feltet udfyldes automatisk, n�r du udfylder feltet Kontaktnr. p� linjen.;
                           ENU=Specifies the name of the contact to which the segment line applies. The program automatically fills in this field when you fill in the Contact No. field on the line.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Name" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen for m�lgruppelinjen.;
                           ENU=Specifies the description of the segment line.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden p� den s�lger, som er ansvarlig for m�lgruppelinjen og/eller interaktionen.;
                           ENU=Specifies the code of the salesperson responsible for this segment line and/or interaction.];
                ApplicationArea=#Suite,#RelationshipMgmt;
                SourceExpr="Salesperson Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver interaktionsskabelonkoden for interaktionen med kontakten p� denne m�lgruppelinje.;
                           ENU=Specifies the interaction template code of the interaction involving the contact on this segment line.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Interaction Template Code" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs�ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p� en ordrebekr�ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Language Code";
                OnValidate=BEGIN
                             LanguageCodeOnAfterValidate;
                           END;
                            }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver emnet for m�lgruppelinjen. Teksten i feltet bruges som emne i mails og Word-dokumenter.;
                           ENU=Specifies the subject of the segment line. The text in the field is used as the subject in e-mails and Word documents.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Subject }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver evalueringen af den interaktion, som vedr�rer kontakten i m�lgruppen.;
                           ENU=Specifies the evaluation of the interaction involving the contact in the segment.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Evaluation }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningerne for interaktionen med den kontakt, som denne m�lgruppelinje g�lder for.;
                           ENU=Specifies the cost of the interaction with the contact that this segment line applies to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Cost (LCY)" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varigheden af interaktionen med den kontakt, som denne m�lgruppelinje g�lder for.;
                           ENU=Specifies the duration of the interaction with the contact to which this segment line applies.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Duration (Min.)" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den registrerede interaktion for denne m�lgruppelinje blev iv�rksat af din virksomhed eller en af dine kontakter. Indstillingen Os angiver, at din virksomhed var initiativtageren, mens indstillingen Dem angiver, at en kontakt var initiativtageren.;
                           ENU="Specifies whether the interaction recorded for this segment line was initiated by your company or by one of your contacts. The Us option indicates that your company was the initiator; the Them option indicates that a contact was the initiator."];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Initiated By";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver retningen p� den informationsstr�m, der indg�r i den interaktion, som er oprettet for m�lgruppelinjen. Der er to indstillinger: Indg�ende og Udg�ende.;
                           ENU=Specifies the direction of the information that is part of the interaction created for this segment line. There are two options: Inbound and Outbound.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Information Flow";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kampagne, som m�lgruppelinjen er blevet oprettet til.;
                           ENU=Specifies the number of the campaign for which the segment line has been created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den m�lgruppe, der er involveret i interaktionen, er m�l for en kampagne. Det anvendes til at m�le svarprocenten for en kampagne.;
                           ENU=Specifies that the segment involved in this interaction is the target of a campaign. This is used to measure the response rate of a campaign.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Target";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den interaktion, der er oprettet for m�lgruppen, er resultatet af en kampagne. F.eks. kan du registrere kuponer, der sendes som svar p� en kampagne.;
                           ENU=Specifies that the interaction created for the segment is the response to a campaign. For example, coupons that are sent as a response to a campaign.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Response";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                AssistEdit=Yes;
                CaptionML=[DAN=Vedh�ftet fil;
                           ENU=Attachment];
                ToolTipML=[DAN=Angiver, om den tilknyttede vedh�ftede fil er overf�rt eller entydig.;
                           ENU=Specifies if the linked attachment is inherited or unique.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=AttachmentText;
                Editable=FALSE;
                OnAssistEdit=BEGIN
                               CurrPage.SAVERECORD;
                               MaintainAttachment;
                               CurrPage.UPDATE(FALSE);
                             END;
                              }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det telefonnummer, du benyttede, da du ringede til kontakten, eller den mailadresse, du benyttede, da du sendte en mail til kontakten.;
                           ENU=Specifies the telephone number you used when calling the contact, or the e-mail address you used when sending an e-mail to the contact.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Via";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      SegmentHistoryMgt@1000 : Codeunit 5061;
      SegCriteriaManagement@1001 : Codeunit 5062;

    [External]
    PROCEDURE UpdateForm@5();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ContactNoOnAfterValidate@19009577();
    BEGIN
      CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE LanguageCodeOnAfterValidate@19030422();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

