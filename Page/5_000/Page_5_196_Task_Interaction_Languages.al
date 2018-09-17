OBJECT Page 5196 Task Interaction Languages
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sprog for opgaveinteraktion;
               ENU=Task Interaction Languages];
    SourceTable=Table5196;
    PageType=List;
    OnFindRecord=VAR
                   RecordsFound@1001 : Boolean;
                 BEGIN
                   RecordsFound := FIND(Which);
                   CurrPage.EDITABLE := ("To-do No." <> '');
                   IF Task.GET("To-do No.") THEN
                     CurrPage.EDITABLE := NOT Task.Closed;

                   EXIT(RecordsFound);
                 END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 11      ;1   ;ActionGroup;
                      Name=Attachment;
                      CaptionML=[DAN=V&edh‘ftet fil;
                                 ENU=&Attachment];
                      Image=Attachments }
      { 13      ;2   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=bn;
                                 ENU=Open];
                      ToolTipML=[DAN=bn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Advanced;
                      Image=Edit;
                      OnAction=BEGIN
                                 OpenAttachment(("To-do No." = '') OR Task.Closed);
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret;
                                 ENU=Create];
                      ToolTipML=[DAN=Opret en vedh‘ftet fil.;
                                 ENU=Create an attachment.];
                      ApplicationArea=#Advanced;
                      Image=New;
                      OnAction=BEGIN
                                 CreateAttachment(("To-do No." = '') OR Task.Closed);
                               END;
                                }
      { 15      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier &fra;
                                 ENU=Copy &from];
                      ToolTipML=[DAN=Kopi‚r fra en vedh‘ftet fil.;
                                 ENU=Copy from an attachment.];
                      ApplicationArea=#Advanced;
                      Image=Copy;
                      OnAction=BEGIN
                                 CopyFromAttachment;
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indl‘s;
                                 ENU=Import];
                      ToolTipML=[DAN=Indl‘s en vedh‘ftet fil.;
                                 ENU=Import an attachment.];
                      ApplicationArea=#Advanced;
                      Image=Import;
                      OnAction=BEGIN
                                 ImportAttachment;
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udl‘s;
                                 ENU=E&xport];
                      ToolTipML=[DAN=Udl‘s en vedh‘ftet fil.;
                                 ENU=Export an attachment.];
                      ApplicationArea=#Advanced;
                      Image=Export;
                      OnAction=BEGIN
                                 ExportAttachment;
                               END;
                                }
      { 18      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Slet;
                                 ENU=Remove];
                      ToolTipML=[DAN=Fjern en vedh‘ftet fil.;
                                 ENU=Remove an attachment.];
                      ApplicationArea=#Advanced;
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
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Advanced;
                SourceExpr="Language Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den interaktionsskabelon, som du har valgt til opgaven.;
                           ENU=Specifies the description of the interaction template that you have chosen for the task.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 9   ;2   ;Field     ;
                AssistEdit=Yes;
                CaptionML=[DAN=Vedh‘ftet fil;
                           ENU=Attachment];
                ToolTipML=[DAN=Angiver, om den tilknyttede vedh‘ftede fil er overf›rt eller entydig.;
                           ENU=Specifies if the linked attachment is inherited or unique.];
                ApplicationArea=#Advanced;
                SourceExpr="Attachment No." > 0;
                OnAssistEdit=BEGIN
                               IF "Attachment No." = 0 THEN
                                 CreateAttachment(("To-do No." = '') OR Task.Closed)
                               ELSE
                                 OpenAttachment(("To-do No." = '') OR Task.Closed);
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
    VAR
      Task@1000 : Record 5080;

    BEGIN
    END.
  }
}

