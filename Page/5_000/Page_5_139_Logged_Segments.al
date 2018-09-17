OBJECT Page 5139 Logged Segments
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
    CaptionML=[DAN=Gemte m†lgrupper;
               ENU=Logged Segments];
    SourceTable=Table5075;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Gemt m†lgruppe;
                                 ENU=&Logged Segment];
                      Image=Entry }
      { 20      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Interaktionslogp&ost;
                                 ENU=Interaction Log E&ntry];
                      ToolTipML=[DAN=Vis en liste med de interaktioner, som du har gemt, f.eks. hvis du vil oprette en interaktion, udskrive en f›lgeseddel en salgsordre osv.;
                                 ENU=View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5076;
                      RunPageView=SORTING(Logged Segment Entry No.);
                      RunPageLink=Logged Segment Entry No.=FIELD(Entry No.);
                      Image=Interaction }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=&Kampagnepost;
                                 ENU=&Campaign Entry];
                      ToolTipML=[DAN=F† vist alle de handlinger og interaktioner, der er knyttet til en kampagne. N†r du bogf›rer en salgs- eller k›bsordre, der er knyttet til en kampagne, eller n†r du opretter en interaktion som en del af en kampagne, registreres den i vinduet Kampagneposter.;
                                 ENU=View all the different actions and interactions that are linked to a campaign. When you post a sales or purchase order that is linked to a campaign or when you create an interaction as part of a campaign, it is recorded in the Campaign Entries window.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5089;
                      RunPageView=SORTING(Register No.);
                      RunPageLink=Register No.=FIELD(Entry No.);
                      Image=CampaignEntries }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Skift &markering i Annulleret;
                                 ENU=Switch Check&mark in Canceled];
                      ToolTipML=[DAN=Skift records, der har en markering i Annulleret.;
                                 ENU=Change records that have a checkmark in Canceled.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=ReopenCancelled;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(LoggedSegment);
                                 LoggedSegment.ToggleCanceledCheckmark;
                               END;
                                }
      { 22      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send igen;
                                 ENU=Resend];
                      ToolTipML=[DAN=Send vedh‘ftede filer, der ikke blev sendt, da du f›rste gang registrerede en m†lgruppe eller en interaktion.;
                                 ENU=Send attachments that were not sent when you initially logged a segment or interaction.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Reuse;
                      OnAction=VAR
                                 InteractLogEntry@1001 : Record 5065;
                               BEGIN
                                 InteractLogEntry.SETRANGE("Logged Segment Entry No.","Entry No.");
                                 REPORT.RUN(REPORT::"Resend Attachments",TRUE,FALSE,InteractLogEntry);
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

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at interaktionen er blevet annulleret.;
                           ENU=Specifies that the interaction has been canceled.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Canceled }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#All;
                SourceExpr="Entry No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor m†lgruppen blev logf›rt.;
                           ENU=Specifies the date on which the segment was logged.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Creation Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bruger-id'et for den bruger, der har oprettet eller registreret interaktionen og m†lgruppen i loggen. Feltet udfyldes automatisk, n†r m†lgruppen registreres i loggen.;
                           ENU=Specifies the ID of the user who created or logged the interaction and segment. The program automatically fills in this field when the segment is logged.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="User ID" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den m†lgruppe, som den gemte m†lgruppe er knyttet til. Oplysningerne i feltet kopieres automatisk fra feltet Nummer i vinduet M†lgruppe.;
                           ENU=Specifies the number of the segment to which the logged segment is linked. The program fills in this field by copying the contents of the No. field in the Segment window.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Segment No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af interaktionen.;
                           ENU=Specifies the description of the interaction.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af interaktioner, der er registreret for den logf›rte m†lgruppe. Klik i feltet, hvis du vil se en liste over de interaktioner, der er oprettet.;
                           ENU=Specifies the number of interactions recorded for the logged segment. To see a list of the created interactions, click the field.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="No. of Interactions" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af kampagneposter, der blev registreret i loggen for m†lgruppen. Klik i feltet, hvis du vil have vist en oversigt over de registrerede kampagneposter.;
                           ENU=Specifies the number of campaign entries that were recorded when you logged the segment. To see a list of the recorded campaign entries, click the field.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="No. of Campaign Entries" }

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
      LoggedSegment@1000 : Record 5075;

    BEGIN
    END.
  }
}

