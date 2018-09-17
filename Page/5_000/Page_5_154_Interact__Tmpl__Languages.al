OBJECT Page 5154 Interact. Tmpl. Languages
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Interaktionsskabelonsprog;
               ENU=Interact. Tmpl. Languages];
    SourceTable=Table5103;
    DataCaptionFields=Interaction Template Code;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Custom Layout Description");
                       CustomReportLayoutDescription := "Custom Layout Description";
                     END;

    OnAfterGetCurrRecord=BEGIN
                           CALCFIELDS("Custom Layout Description");
                           CustomReportLayoutDescription := "Custom Layout Description";
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&edhëftet fil;
                                 ENU=&Attachment];
                      Image=Attachments }
      { 12      ;2   ;Action    ;
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
      { 13      ;2   ;Action    ;
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
      { 14      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier &fra;
                                 ENU=Copy &from];
                      ToolTipML=[DAN=KopiÇr fra en vedhëftet fil.;
                                 ENU=Copy from an attachment.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Copy;
                      OnAction=BEGIN
                                 CopyFromAttachment;
                               END;
                                }
      { 15      ;2   ;Action    ;
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
      { 16      ;2   ;Action    ;
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
      { 17      ;2   ;Action    ;
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

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den interaktionsskabelon, som du har valgt.;
                           ENU=Specifies the code for the interaction template that you have selected.];
                ApplicationArea=#All;
                SourceExpr="Interaction Template Code" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved oversëttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen pÜ en ordrebekrëftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#All;
                SourceExpr="Language Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af interaktionsskabelonsproget. Feltet bliver ikke vist i det vedhëftede Word-dokument.;
                           ENU=Specifies the description of the interaction template language. This field will not be displayed in the Word attachment.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                Name=Attachment;
                CaptionML=[DAN=Vedhëftet fil;
                           ENU=Attachment];
                ToolTipML=[DAN=Angiver, om den tilknyttede vedhëftede fil er overfõrt eller entydig.;
                           ENU=Specifies if the linked attachment is inherited or unique.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Attachment No." <> 0;
                OnAssistEdit=BEGIN
                               IF "Attachment No." = 0 THEN
                                 CreateAttachment
                               ELSE
                                 OpenAttachment;

                               CurrPage.UPDATE;
                             END;
                              }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ rapportlayoutet.;
                           ENU=Specifies the number of the report layout.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Custom Layout Code";
                Visible=FALSE;
                OnValidate=BEGIN
                             UpdateAttachments("Custom Layout Code");
                           END;
                            }

    { 5   ;2   ;Field     ;
                Name=CustLayoutDescription;
                CaptionML=[DAN=Brugerdefineret layout;
                           ENU=Custom Layout];
                ToolTipML=[DAN=Angiver det rapportlayout, der vil blive brugt.;
                           ENU=Specifies the report layout that will be used.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=CustomReportLayoutDescription;
                OnValidate=VAR
                             CustomReportLayout@1000 : Record 9650;
                           BEGIN
                             IF CustomReportLayoutDescription = '' THEN BEGIN
                               VALIDATE("Custom Layout Code",'');
                               MODIFY(TRUE);
                             END ELSE BEGIN
                               CustomReportLayout.SETRANGE("Report ID",REPORT::"Email Merge");
                               CustomReportLayout.SETFILTER(Description,STRSUBSTNO('@*%1*',CustomReportLayoutDescription));
                               IF NOT CustomReportLayout.FINDFIRST THEN
                                 ERROR(CouldNotFindCustomReportLayoutErr,CustomReportLayoutDescription);

                               VALIDATE("Custom Layout Code",CustomReportLayout.Code);
                               MODIFY(TRUE);
                             END;

                             UpdateAttachments("Custom Layout Code");
                           END;

                OnLookup=VAR
                           CustomReportLayout@1000 : Record 9650;
                         BEGIN
                           IF CustomReportLayout.LookupLayoutOK(REPORT::"Email Merge") THEN BEGIN
                             VALIDATE("Custom Layout Code",CustomReportLayout.Code);
                             MODIFY(TRUE);

                             CustomReportLayoutDescription := CustomReportLayout.Description;
                             UpdateAttachments("Custom Layout Code");
                           END;
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
      CustomReportLayoutDescription@1000 : Text;
      CouldNotFindCustomReportLayoutErr@1001 : TextConst '@@@=%1 Description of Custom Report Layout;DAN=Der er intet brugerdefineret rapportlayout til %1 i beskrivelsen.;ENU=There is no Custom Report Layout with %1 in the description.';

    LOCAL PROCEDURE UpdateAttachments@1(NewCustomLayoutCode@1000 : Code[20]);
    BEGIN
      IF NewCustomLayoutCode <> '' THEN
        CreateAttachment
      ELSE
        IF xRec."Custom Layout Code" <> '' THEN
          RemoveAttachment(FALSE);

      CALCFIELDS("Custom Layout Description");
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

