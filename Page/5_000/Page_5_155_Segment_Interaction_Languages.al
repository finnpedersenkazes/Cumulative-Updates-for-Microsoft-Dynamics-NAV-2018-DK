OBJECT Page 5155 Segment Interaction Languages
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=MÜlgruppeinteraktionssprog;
               ENU=Segment Interaction Languages];
    SourceTable=Table5104;
    DataCaptionExpr=Caption;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 12      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&edhëftet fil;
                                 ENU=&Attachment];
                      Image=Attachments }
      { 13      ;2   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Edit;
                      OnAction=BEGIN
                                 OpenAttachment;
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret;
                                 ENU=Create];
                      ToolTipML=[DAN=Opret en vedhëftet fil.;
                                 ENU=Create an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=New;
                      OnAction=BEGIN
                                 CreateAttachment;
                               END;
                                }
      { 15      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier &fra;
                                 ENU=Copy &From];
                      ToolTipML=[DAN=KopiÇr fra en vedhëftet fil.;
                                 ENU=Copy from an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Copy;
                      OnAction=BEGIN
                                 CopyFromAttachment;
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indlës;
                                 ENU=Import];
                      ToolTipML=[DAN=Indlës en vedhëftet fil.;
                                 ENU=Import an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Import;
                      OnAction=BEGIN
                                 ImportAttachment;
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udlës;
                                 ENU=E&xport];
                      ToolTipML=[DAN=Udlës en vedhëftet fil.;
                                 ENU=Export an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Export;
                      OnAction=BEGIN
                                 ExportAttachment;
                               END;
                                }
      { 18      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Slet;
                                 ENU=Remove];
                      ToolTipML=[DAN=Fjern en vedhëftet fil.;
                                 ENU=Remove an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Cancel;
                      OnAction=BEGIN
                                 RemoveAttachment(TRUE);
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
                ToolTipML=[DAN=Angiver det sprog, der bruges ved oversëttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen pÜ en ordrebekrëftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#All;
                SourceExpr="Language Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af mÜlgruppeinteraktionssproget. Feltet bliver ikke vist i det vedhëftede Word-dokument.;
                           ENU=Specifies the description of the Segment Interaction Language. This field will not be displayed in the Word attachment.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver emneteksten. Teksten i feltet bruges som emne i mails og Word-dokumenter.;
                           ENU=Specifies the subject text. The text in the field is used as the subject in e-mails and Word documents.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Subject }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Vedhëftet fil;
                           ENU=Attachment];
                ToolTipML=[DAN=Angiver, om den tilknyttede vedhëftede fil er overfõrt eller entydig.;
                           ENU=Specifies if the linked attachment is inherited or unique.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=AttachmentText;
                OnAssistEdit=BEGIN
                               IF "Attachment No." = 0 THEN
                                 CreateAttachment
                               ELSE
                                 OpenAttachment;

                               CurrPage.UPDATE;
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

    BEGIN
    END.
  }
}

