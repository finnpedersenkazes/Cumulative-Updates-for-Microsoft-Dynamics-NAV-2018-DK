OBJECT Page 5091 Segment
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=M†lgruppe;
               ENU=Segment];
    SourceTable=Table5076;
    PopulateAllFields=Yes;
    PageType=ListPlus;
    OnInit=BEGIN
             UnitDurationMinEnable := TRUE;
             UnitCostLCYEnable := TRUE;
             InitiatedByEnable := TRUE;
             InformationFlowEnable := TRUE;
             IgnoreContactCorresTypeEnable := TRUE;
             AttachmentEnable := TRUE;
             LanguageCodeDefaultEnable := TRUE;
             SubjectDefaultEnable := TRUE;
             CorrespondenceTypeDefaultEnabl := TRUE;
             CampaignResponseEnable := TRUE;
             CampaignTargetEnable := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Attachment No.");
                     END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateEditable;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&M†lgruppe;
                                 ENU=&Segment];
                      Image=Segment }
      { 68      ;2   ;Action    ;
                      CaptionML=[DAN=Kriterie;
                                 ENU=Criteria];
                      ToolTipML=[DAN=Se en liste over de handlinger, som du har foretaget (tilf›jet eller fjernet kontakter) for at definere m†lgruppekriterierne.;
                                 ENU=View a list of the actions that you have performed (adding or removing contacts) in order to define the segment criteria.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5143;
                      RunPageLink=Segment No.=FIELD(No.);
                      Image=Filter }
      { 69      ;2   ;Action    ;
                      CaptionML=[DAN=&Salgsmuligheder;
                                 ENU=Oppo&rtunities];
                      ToolTipML=[DAN=Vis de salgsmuligheder, der h†ndteres af s‘lgere for m†lgruppen. Salgsmuligheder skal omfatte en kontakt og kan knyttes til kampagner.;
                                 ENU=View the sales opportunities that are handled by salespeople for the segment. Opportunities must involve a contact and can be linked to campaigns.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5123;
                      RunPageView=SORTING(Segment No.);
                      RunPageLink=Segment No.=FIELD(No.);
                      Image=OpportunityList }
      { 3       ;2   ;Action    ;
                      Name=Create opportunity;
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5124;
                      RunPageLink=Segment No.=FIELD(No.);
                      Image=NewOpportunity;
                      RunPageMode=Create }
      { 5       ;2   ;Action    ;
                      Name=Create opportunities;
                      CaptionML=[DAN=Opret salgsmuligheder;
                                 ENU=Create opportunities];
                      ToolTipML=[DAN=Opret et nyt salgsmulighedskort, der er relateret til m†lgruppen.;
                                 ENU=Create a new opportunity card related to the segment.];
                      ApplicationArea=#Advanced;
                      OnAction=BEGIN
                                 CreateOpportunitiesForAllContacts;
                               END;
                                }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Opg&aver;
                                 ENU=T&asks];
                      ToolTipML=[DAN=F† vist alle marketingopgaver, der vedr›rer m†lgruppen.;
                                 ENU=View all marketing tasks that involve the segment.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5096;
                      RunPageView=SORTING(Segment No.);
                      RunPageLink=Segment No.=FIELD(No.),
                                  System To-do Type=FILTER(Organizer|Salesperson Attendee);
                      Image=TaskList }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 25      ;1   ;Action    ;
                      Name=LogSegment;
                      CaptionML=[DAN=&Log;
                                 ENU=&Log];
                      ToolTipML=[DAN=Gem de m†lgrupper og interaktioner, der er tildelt til dine m†lgrupper og leverede vedh‘ftede filer, du har sendt.;
                                 ENU=Log segments and interactions that are assigned to your segments and delivery attachments that you have sent.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 LogSegment@1001 : Report 5185;
                               BEGIN
                                 LogSegment.SetSegmentNo("No.");
                                 LogSegment.RUNMODAL;
                                 IF NOT GET("No.") THEN
                                   MESSAGE(Text011,"No.");
                               END;
                                }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 90      ;2   ;ActionGroup;
                      CaptionML=[DAN=Kontakter;
                                 ENU=Contacts];
                      Image=CustomerContact }
      { 29      ;3   ;Action    ;
                      Name=AddContacts;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Tilf›j kontakter;
                                 ENU=Add Contacts];
                      ToolTipML=[DAN=V‘lg, hvilke kontakter der skal tilf›jes til m†lgruppen.;
                                 ENU=Select which contacts to add to the segment.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=AddContacts;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SegHeader@1002 : Record 5076;
                               BEGIN
                                 SegHeader := Rec;
                                 SegHeader.SETRECFILTER;
                                 REPORT.RUNMODAL(REPORT::"Add Contacts",TRUE,FALSE,SegHeader);
                               END;
                                }
      { 30      ;3   ;Action    ;
                      Name=ReduceContacts;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Reducer kontakter;
                                 ENU=Reduce Contacts];
                      ToolTipML=[DAN=V‘lg, hvilke kontakter der skal fjernes fra m†lgruppen.;
                                 ENU=Select which contacts to remove from your segment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=RemoveContacts;
                      OnAction=VAR
                                 SegHeader@1002 : Record 5076;
                               BEGIN
                                 SegHeader := Rec;
                                 SegHeader.SETRECFILTER;
                                 REPORT.RUNMODAL(REPORT::"Remove Contacts - Reduce",TRUE,FALSE,SegHeader);
                               END;
                                }
      { 31      ;3   ;Action    ;
                      Name=RefineContacts;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beg&r‘ns kontakter;
                                 ENU=Re&fine Contacts];
                      ToolTipML=[DAN=V‘lg, hvilke kontakter der skal bevares i m†lgruppen.;
                                 ENU=Select which contacts to keep in your segment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=ContactFilter;
                      OnAction=VAR
                                 SegHeader@1002 : Record 5076;
                               BEGIN
                                 SegHeader := Rec;
                                 SegHeader.SETRECFILTER;
                                 REPORT.RUNMODAL(REPORT::"Remove Contacts - Refine",TRUE,FALSE,SegHeader);
                               END;
                                }
      { 28      ;2   ;ActionGroup;
                      CaptionML=[DAN=M&†lgruppe;
                                 ENU=S&egment];
                      Image=Segment }
      { 33      ;3   ;Action    ;
                      CaptionML=[DAN=G† tilbage;
                                 ENU=Go Back];
                      ToolTipML=[DAN=G† et trin tilbage, f.eks. hvis du har tilf›jet kontakter til et segment ved en fejl.;
                                 ENU=Go one step back, for example if you have added contacts to a segment by mistake.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Undo;
                      OnAction=VAR
                                 SegmentHistoryMgt@1001 : Codeunit 5061;
                               BEGIN
                                 CALCFIELDS("No. of Criteria Actions");
                                 IF "No. of Criteria Actions" > 0 THEN
                                   IF CONFIRM(Text012,FALSE) THEN
                                     SegmentHistoryMgt.GoBack("No.");
                               END;
                                }
      { 54      ;3   ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 56      ;3   ;Action    ;
                      Name=ReuseCriteria;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Genbrug kriterier;
                                 ENU=Reuse Criteria];
                      ToolTipML=[DAN=Genbrug et gemt m†lgruppekriterie.;
                                 ENU=Reuse a saved segment criteria.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Reuse;
                      OnAction=BEGIN
                                 ReuseCriteria;
                               END;
                                }
      { 55      ;3   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Genbrug m†lgruppe;
                                 ENU=Reuse Segment];
                      ToolTipML=[DAN=Genbrug en gemt m†lgruppe.;
                                 ENU=Reuse a logged segment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Reuse;
                      OnAction=BEGIN
                                 ReuseLogged(0);
                               END;
                                }
      { 50      ;3   ;Action    ;
                      Name=SaveCriteria;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Gem kriterie;
                                 ENU=Save Criteria];
                      ToolTipML=[DAN=Gem et m†lgruppekriterie.;
                                 ENU=Save a segment criteria.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Save;
                      OnAction=BEGIN
                                 SaveCriteria;
                               END;
                                }
      { 59      ;2   ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 60      ;2   ;ActionGroup;
                      CaptionML=[DAN=Vedh‘ftet fil;
                                 ENU=Attachment];
                      Image=Attachments }
      { 61      ;3   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=bn;
                                 ENU=Open];
                      ToolTipML=[DAN=bn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Edit;
                      OnAction=BEGIN
                                 TESTFIELD("Interaction Template Code");
                                 OpenAttachment;
                               END;
                                }
      { 62      ;3   ;Action    ;
                      CaptionML=[DAN=Opret;
                                 ENU=Create];
                      ToolTipML=[DAN=Opret en vedh‘ftet fil.;
                                 ENU=Create an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=New;
                      OnAction=BEGIN
                                 TESTFIELD("Interaction Template Code");
                                 CreateAttachment;
                               END;
                                }
      { 63      ;3   ;Action    ;
                      CaptionML=[DAN=Indl‘s;
                                 ENU=Import];
                      ToolTipML=[DAN=Indl‘s en vedh‘ftet fil.;
                                 ENU=Import an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Import;
                      OnAction=BEGIN
                                 TESTFIELD("Interaction Template Code");
                                 ImportAttachment;
                               END;
                                }
      { 64      ;3   ;Action    ;
                      CaptionML=[DAN=Udl‘s;
                                 ENU=Export];
                      ToolTipML=[DAN=Udl‘s en vedh‘ftet fil.;
                                 ENU=Export an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Export;
                      OnAction=BEGIN
                                 TESTFIELD("Interaction Template Code");
                                 ExportAttachment;
                               END;
                                }
      { 65      ;3   ;Action    ;
                      CaptionML=[DAN=Slet;
                                 ENU=Remove];
                      ToolTipML=[DAN=Fjern en vedh‘ftet fil.;
                                 ENU=Remove an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Cancel;
                      OnAction=BEGIN
                                 TESTFIELD("Interaction Template Code");
                                 RemoveAttachment(FALSE);
                               END;
                                }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=E&ksporter kontakter;
                                 ENU=E&xport Contacts];
                      ToolTipML=[DAN=Eksport‚r listen over m†lgruppekontakter som en Excel-fil.;
                                 ENU=Export the segment contact list as an Excel file.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=ExportFile;
                      OnAction=VAR
                                 SegLineLocal@1001 : Record 5077;
                               BEGIN
                                 SegLineLocal.SETRANGE("Segment No.","No.");
                                 SegLineLocal.ExportODataFields;
                               END;
                                }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Anvend m&ailgruppe;
                                 ENU=Apply &Mailing Group];
                      ToolTipML=[DAN=Tildel en mailgruppe til en m†lgruppe.;
                                 ENU=Assign a mailing group to a segment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=DistributionGroup;
                      OnAction=VAR
                                 SegHeader@1001 : Record 5076;
                               BEGIN
                                 SegHeader := Rec;
                                 SegHeader.SETRECFILTER;
                                 REPORT.RUN(REPORT::"Apply Mailing Group",TRUE,TRUE,SegHeader);
                               END;
                                }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      Image=Print }
      { 37      ;2   ;Action    ;
                      Name=CoverSheet;
                      CaptionML=[DAN=Udskriv &f›lgebreve;
                                 ENU=Print Cover &Sheets];
                      ToolTipML=[DAN=Vis f›lgebreve, der skal sendes til din kontakt.;
                                 ENU=View cover sheets to send to your contact.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=PrintCover;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SegHeader@1001 : Record 5076;
                                 ContactCoverSheet@1005 : Report 5085;
                               BEGIN
                                 SegHeader := Rec;
                                 SegHeader.SETRECFILTER;
                                 ContactCoverSheet.SetRunFromSegment;
                                 ContactCoverSheet.SETTABLEVIEW(SegHeader);
                                 ContactCoverSheet.RUNMODAL;
                               END;
                                }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Udskriv &etiketter;
                                 ENU=Print &Labels];
                      ToolTipML=[DAN=Vis adresseetiketter med navne og adresser.;
                                 ENU=View mailing labels with names and addresses.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Print;
                      OnAction=VAR
                                 SegHeader@1001 : Record 5076;
                               BEGIN
                                 SegHeader := Rec;
                                 SegHeader.SETRECFILTER;
                                 REPORT.RUN(REPORT::"Segment - Labels",TRUE,FALSE,SegHeader);
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
                Importance=Additional;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen for m†lgruppen.;
                           ENU=Specifies the description of the segment.];
                ApplicationArea=#All;
                SourceExpr=Description;
                OnValidate=BEGIN
                             DescriptionOnAfterValidate;
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden p† den s‘lger, som er ansvarlig for denne m†lgruppe og/eller interaktion.;
                           ENU=Specifies the code of the salesperson responsible for this segment and/or interaction.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code";
                OnValidate=BEGIN
                             SalespersonCodeOnAfterValidate;
                           END;
                            }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor m†lgruppen blev oprettet.;
                           ENU=Specifies the date that the segment was created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Date;
                OnValidate=BEGIN
                             DateOnAfterValidate;
                           END;
                            }

    { 39  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver antallet af linjer i m†lgruppen.;
                           ENU=Specifies the number of lines within the segment.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="No. of Lines" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af handlinger, du har foretaget ved ‘ndring af m†lgruppekriteriet, dvs. n†r du f›jer kontakter til m†lgruppen, opdaterer den eller reducerer den.;
                           ENU=Specifies the number of actions you have taken when modifying the segmentation criteria, that is, when adding contacts to the segment, refining, or reducing it.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="No. of Criteria Actions" }

    { 21  ;1   ;Part      ;
                Name=SegLines;
                ApplicationArea=#RelationshipMgmt;
                SubPageLink=Segment No.=FIELD(No.);
                PagePartID=Page5092;
                PartType=Page }

    { 1907335101;1;Group  ;
                CaptionML=[DAN=Interaktion;
                           ENU=Interaction] }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver interaktionsskabelonkoden for interaktionen, der involverer m†lgruppen.;
                           ENU=Specifies the interaction template code of the interaction involving the segment.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Interaction Template Code";
                OnValidate=BEGIN
                             InteractionTemplateCodeOnAfter;
                           END;
                            }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sprogkoden for m†lgruppen.;
                           ENU=Specifies the language code for the segment.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Language Code (Default)";
                Enabled=LanguageCodeDefaultEnable;
                OnValidate=BEGIN
                             LanguageCodeDefaultOnAfterVali;
                           END;
                            }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver emnet for m†lgruppen. Teksten i feltet bruges som emne i mails og Word-dokumenter.;
                           ENU=Specifies the subject of the segment. The text in the field is used as the subject in e-mails and in Word documents.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Subject (Default)";
                Enabled=SubjectDefaultEnable;
                OnValidate=BEGIN
                             SubjectDefaultOnAfterValidate;
                           END;
                            }

    { 18  ;2   ;Field     ;
                Name=Attachment;
                AssistEdit=Yes;
                CaptionML=[DAN=Vedh‘ftet fil;
                           ENU=Attachment];
                ToolTipML=[DAN=Angiver, om den tilknyttede vedh‘ftede fil er overf›rt eller entydig.;
                           ENU=Specifies if the linked attachment is inherited or unique.];
                ApplicationArea=#RelationshipMgmt;
                BlankZero=Yes;
                SourceExpr="Attachment No." > 0;
                Enabled=AttachmentEnable;
                OnAssistEdit=BEGIN
                               MaintainAttachment;
                               UpdateEditable;
                               CurrPage.SegLines.PAGE.UpdateForm;
                             END;
                              }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den korrespondancetype, som du v‘lger i feltet Korrespondancetype (standard), skal bruges. Hvis der ikke er nogen markering, bruger programmet den korrespondancetype, der er angivet p† kontaktkortet.;
                           ENU=Specifies that the correspondence type that you select in the Correspondence Type (Default) field should be used. If there is no check mark, the program uses the correspondence type selected on the Contact Card.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Ignore Contact Corres. Type";
                Enabled=IgnoreContactCorresTypeEnable;
                OnValidate=BEGIN
                             IgnoreContactCorresTypeOnAfter;
                           END;
                            }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den foretrukne type korrespondance for interaktionen. BEM’RK: Hvis du bruger webklient, m† du ikke v‘lge indstillingen Papirformat, fordi det ikke er muligt at udskrive fra webklienten.;
                           ENU=Specifies the preferred type of correspondence for the interaction. NOTE: If you use the Web client, you must not select the Hard Copy option because printing is not possible from the web client.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Correspondence Type (Default)";
                Enabled=CorrespondenceTypeDefaultEnabl;
                OnValidate=BEGIN
                             CorrespondenceTypeDefaultOnAft;
                           END;
                            }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver retningen p† den informationsstr›m, der indg†r i den interaktion, som er oprettet for m†lgruppen. Der er to indstillinger: Indg†ende og Udg†ende.;
                           ENU=Specifies the direction of the information that is part of the interaction created for the segment. There are two options: Inbound and Outbound.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Information Flow";
                Enabled=InformationFlowEnable;
                OnValidate=BEGIN
                             InformationFlowOnAfterValidate;
                           END;
                            }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den registrerede interaktion for denne m†lgruppe blev iv‘rksat af din virksomhed eller en af dine kontakter. Indstillingen Os angiver, at din virksomhed var initiativtageren, mens indstillingen Dem angiver, at en kontakt var initiativtageren.;
                           ENU="Specifies whether the interaction recorded for this segment was initiated by your company or by one of your contacts. The Us option indicates that your company was the initiator; the Them option indicates that a contact was the initiator."];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Initiated By";
                Enabled=InitiatedByEnable;
                OnValidate=BEGIN
                             InitiatedByOnAfterValidate;
                           END;
                            }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Unit Cost (LCY)";
                Enabled=UnitCostLCYEnable;
                OnValidate=BEGIN
                             UnitCostLCYOnAfterValidate;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varigheden af ‚n enkelt interaktion, som oprettes i forbindelse med m†lgruppen.;
                           ENU=Specifies the duration of a single interaction created for this segment.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Unit Duration (Min.)";
                Enabled=UnitDurationMinEnable;
                OnValidate=BEGIN
                             UnitDurationMinOnAfterValidate;
                           END;
                            }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at Microsoft Word-dokumentet skal sendes som en vedh‘ftet fil i mailmeddelelsen.;
                           ENU=Specifies that the Microsoft Word document should be sent as an attachment in the e-mail message.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Send Word Docs. as Attmt.";
                OnValidate=BEGIN
                             SendWordDocsasAttmtOnAfterVali;
                           END;
                            }

    { 1900598201;1;Group  ;
                CaptionML=[DAN=Kampagne;
                           ENU=Campaign] }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som m†lgruppen er blevet oprettet til.;
                           ENU=Specifies the number of the campaign for which the segment has been created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                OnValidate=BEGIN
                             CampaignNoOnAfterValidate;
                           END;
                            }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den kampagne, som m†lgruppen er relateret til. Beskrivelsen kopieres fra kampagnekortet.;
                           ENU=Specifies a description of the campaign to which the segment is related. The description is copied from the campaign card.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Description";
                Editable=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at m†lgruppen er en del af m†let for den kampagne, den er knyttet til.;
                           ENU=Specifies that the segment is part of the target of the campaign to which it is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Target";
                Enabled=CampaignTargetEnable;
                OnValidate=BEGIN
                             CampaignTargetOnAfterValidate;
                           END;
                            }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den interaktion, der er oprettet for m†lgruppen, er en reaktion p† en kampagne.;
                           ENU=Specifies that the interaction created for the segment is the response to a campaign.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Response";
                Enabled=CampaignResponseEnable;
                OnValidate=BEGIN
                             CampaignResponseOnAfterValidat;
                           END;
                            }

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
      Text011@1011 : TextConst 'DAN=M†lgruppen %1 er blevet logf›rt.;ENU=Segment %1 has been logged.';
      Text012@1013 : TextConst 'DAN=Dette vil annullere den sidste kriteriehandling.\Vil du forts‘tte?;ENU=This will undo the last criteria action.\Do you want to continue?';
      CampaignTargetEnable@19064124 : Boolean INDATASET;
      CampaignResponseEnable@19042996 : Boolean INDATASET;
      CorrespondenceTypeDefaultEnabl@19017412 : Boolean INDATASET;
      SubjectDefaultEnable@19030726 : Boolean INDATASET;
      LanguageCodeDefaultEnable@19053468 : Boolean INDATASET;
      AttachmentEnable@19033701 : Boolean INDATASET;
      IgnoreContactCorresTypeEnable@19029068 : Boolean INDATASET;
      InformationFlowEnable@19076079 : Boolean INDATASET;
      InitiatedByEnable@19020183 : Boolean INDATASET;
      UnitCostLCYEnable@19056514 : Boolean INDATASET;
      UnitDurationMinEnable@19041420 : Boolean INDATASET;
      CreateOppQst@1000 : TextConst 'DAN=Vil du oprette en salgsmulighed for alle kontakter i m†lgruppen?;ENU=Do you want to create an opportunity for all contacts in segment?';

    LOCAL PROCEDURE UpdateEditable@4();
    VAR
      SegInteractLanguage@1000 : Record 5104;
    BEGIN
      CampaignTargetEnable := "Campaign No." <> '';
      CampaignResponseEnable := "Campaign No." <> '';
      CorrespondenceTypeDefaultEnabl := "Ignore Contact Corres. Type" = TRUE;
      LanguageCodeDefaultEnable := "Interaction Template Code" <> '';
      SubjectDefaultEnable := SegInteractLanguage.GET("No.",0,"Language Code (Default)");
      AttachmentEnable := "Interaction Template Code" <> '';
      IgnoreContactCorresTypeEnable := "Interaction Template Code" <> '';
      InformationFlowEnable := "Interaction Template Code" <> '';
      InitiatedByEnable := "Interaction Template Code" <> '';
      UnitCostLCYEnable := "Interaction Template Code" <> '';
      UnitDurationMinEnable := "Interaction Template Code" <> '';
      LanguageCodeDefaultEnable := "Interaction Template Code" <> '';
    END;

    LOCAL PROCEDURE DateOnAfterValidate@19027017();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE SalespersonCodeOnAfterValidate@19011896();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE DescriptionOnAfterValidate@19030973();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE InteractionTemplateCodeOnAfter@19000597();
    BEGIN
      UpdateEditable;
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE InformationFlowOnAfterValidate@19041099();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE InitiatedByOnAfterValidate@19049832();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE UnitCostLCYOnAfterValidate@19001329();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE UnitDurationMinOnAfterValidate@19023271();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE CorrespondenceTypeDefaultOnAft@19059490();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE SendWordDocsasAttmtOnAfterVali@19026152();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE LanguageCodeDefaultOnAfterVali@19033064();
    BEGIN
      UpdateEditable;
      CurrPage.SegLines.PAGE.UpdateForm;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE IgnoreContactCorresTypeOnAfter@19053741();
    BEGIN
      UpdateEditable;
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE SubjectDefaultOnAfterValidate@19032581();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE CampaignResponseOnAfterValidat@19031993();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE CampaignTargetOnAfterValidate@19073096();
    BEGIN
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE CampaignNoOnAfterValidate@19036822();
    BEGIN
      IF "Campaign No." = '' THEN BEGIN
        "Campaign Target" := FALSE;
        "Campaign Response" := FALSE;
      END;

      CALCFIELDS("Campaign Description");
      CampaignTargetEnable := "Campaign No." <> '';
      CampaignResponseEnable := "Campaign No." <> '';
      CurrPage.SegLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE CreateOpportunitiesForAllContacts@1();
    BEGIN
      IF CONFIRM(CreateOppQst) THEN
        CreateOpportunities;
    END;

    BEGIN
    END.
  }
}

