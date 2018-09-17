OBJECT Page 662 Approval Request Entries
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
    CaptionML=[DAN=Godkendelsesanmodningsposter;
               ENU=Approval Request Entries];
    SourceTable=Table454;
    PageType=List;
    OnOpenPage=BEGIN
                 IF Usersetup.GET(USERID) THEN
                   IF NOT Usersetup."Approval Administrator" THEN BEGIN
                     FILTERGROUP(2);
                     SETCURRENTKEY("Sender ID");
                     SETFILTER("Sender ID",'=%1',Usersetup."User ID");
                     FILTERGROUP(0);
                   END;

                 SETRANGE(Status);
                 SETRANGE("Due Date");
               END;

    OnAfterGetRecord=BEGIN
                       Overdue := Overdue::" ";
                       IF FormatField(Rec) THEN
                         Overdue := Overdue::Yes;

                       RecordIDText := FORMAT("Record ID to Approve",0,1);
                     END;

    OnAfterGetCurrRecord=VAR
                           RecRef@1000 : RecordRef;
                         BEGIN
                           ShowRecCommentsEnabled := RecRef.GET("Record ID to Approve");
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vi&s;
                                 ENU=&Show];
                      Image=View }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Record;
                                 ENU=Record];
                      ToolTipML=[DAN=èbn bilaget, kladdelinjen eller kortet, som godkendelsesanmodningen vedrõrer.;
                                 ENU=Open the document, journal line, or card that the approval request is for.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=ShowRecCommentsEnabled;
                      PromotedIsBig=Yes;
                      Image=Document;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowRecord;
                               END;
                                }
      { 36      ;2   ;Action    ;
                      Name=Comments;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=ShowRecCommentsEnabled;
                      PromotedIsBig=Yes;
                      Image=ViewComments;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                                 RecRef@1001 : RecordRef;
                               BEGIN
                                 RecRef.GET("Record ID to Approve");
                                 CLEAR(ApprovalsMgmt);
                                 ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(RecRef,"Workflow Step Instance ID");
                               END;
                                }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Fo&rfaldne poster;
                                 ENU=O&verdue Entries];
                      ToolTipML=[DAN=Vis godkendelsesanmodninger, der er overskredet.;
                                 ENU=View approval requests that are overdue.];
                      ApplicationArea=#Suite;
                      Image=OverdueEntries;
                      OnAction=BEGIN
                                 SETFILTER(Status,'%1|%2',Status::Created,Status::Open);
                                 SETFILTER("Due Date",'<%1',TODAY);
                               END;
                                }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Alle poster;
                                 ENU=All Entries];
                      ToolTipML=[DAN=FÜ vist alle godkendelsesposter.;
                                 ENU=View all approval entries.];
                      ApplicationArea=#Suite;
                      Image=Entries;
                      OnAction=BEGIN
                                 SETRANGE(Status);
                                 SETRANGE("Due Date");
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 25      ;1   ;Action    ;
                      CaptionML=[DAN=Ud&deleger;
                                 ENU=&Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsesanmodningen til en anden godkender, der er konfigureret som din stedfortrëder.;
                                 ENU=Delegate the approval request to another approver that has been set up as your substitute approver.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Delegate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalEntry@1001 : Record 454;
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                                 ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry)
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

    { 37  ;2   ;Field     ;
                CaptionML=[DAN=Forfald;
                           ENU=Overdue];
                ToolTipML=[DAN=Angiver, at godkendelsen er overskredet.;
                           ENU=Specifies that the approval is overdue.];
                ApplicationArea=#Suite;
                SourceExpr=Overdue;
                Editable=False }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den tabel, hvor recorden, der er omfattet af godkendelsen, er gemt.;
                           ENU=Specifies the ID of the table where the record that is subject to approval is stored.];
                ApplicationArea=#Advanced;
                SourceExpr="Table ID";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken bilagstype en godkendelsespost er oprettet til. Der kan oprettes godkendelsesposter til seks forskellige typer salgs- eller kõbsbilag:;
                           ENU=Specifies the type of document that an approval entry has been created for. Approval entries can be created for six different types of sales or purchase documents:];
                ApplicationArea=#Advanced;
                SourceExpr="Document Type";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bilagsnummer, der er kopieret fra det relevante salgs- eller kõbsbilag, f.eks. en kõbsordre eller et salgstilbud.;
                           ENU=Specifies the document number copied from the relevant sales or purchase document, such as a purchase order or a sales quote.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Til godkendelse;
                           ENU=To Approve];
                ToolTipML=[DAN=Angiver den record, som du bliver bedt om at godkende.;
                           ENU=Specifies the record that you are requested to approve.];
                ApplicationArea=#Suite;
                SourceExpr=RecordIDText }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rëkkefõlgen for godkenderne, nÜr godkendelsesworkflowet omfatter flere godkendere.;
                           ENU=Specifies the order of approvers when an approval workflow involves more than one approver.];
                ApplicationArea=#Suite;
                SourceExpr="Sequence No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et pÜ den bruger, som har sendt godkendelsesanmodningen for det bilag, der skal godkendes.;
                           ENU=Specifies the ID of the user who sent the approval request for the document to be approved.];
                ApplicationArea=#Suite;
                SourceExpr="Sender ID" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden pÜ den sëlger eller indkõber, der er angivet i det bilag, der skal godkendes. Feltet er ikke obligatorisk, men nyttigt, hvis den sëlger eller indkõber, der er ansvarlig for kunden/leverandõren, skal godkende dokumentet, fõr det behandles.;
                           ENU=Specifies the code for the salesperson or purchaser that was in the document to be approved. It is not a mandatory field, but is useful if a salesperson or a purchaser responsible for the customer/vendor needs to approve the document before it is processed.];
                ApplicationArea=#Suite;
                SourceExpr="Salespers./Purch. Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angivet id'et pÜ den bruger, der skal godkende bilaget.;
                           ENU=Specifies the ID of the user who must approve the document.];
                ApplicationArea=#Suite;
                SourceExpr="Approver ID" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver godkendelsesstatus for posten:;
                           ENU=Specifies the approval status for the entry:];
                ApplicationArea=#Suite;
                SourceExpr=Status }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato og det klokkeslët, hvor dokumentet blev sendt til godkendelse.;
                           ENU=Specifies the date and the time that the document was sent for approval.];
                ApplicationArea=#Suite;
                SourceExpr="Date-Time Sent for Approval" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor godkendelsesposten senest blev ëndret. Hvis dokumentgodkendelsen f.eks. annulleres, opdateres dette felt tilsvarende.;
                           ENU=Specifies the date when the approval entry was last modified. If, for example, the document approval is canceled, this field will be updated accordingly.];
                ApplicationArea=#Suite;
                SourceExpr="Last Date-Time Modified" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et pÜ den bruger, som senest har ëndret godkendelsesposten. Hvis dokumentgodkendelsen f.eks. annulleres, opdateres dette felt tilsvarende.;
                           ENU=Specifies the ID of the user who last modified the approval entry. If, for example, the document approval is canceled, this field will be updated accordingly.];
                ApplicationArea=#Suite;
                SourceExpr="Last Modified By User ID" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der er bemërkninger til godkendelsen af recorden. Hvis du vil lëse bemërkningerne, skal du vëlge feltet for at Übne vinduet Godkendelsesbemërkninger.;
                           ENU=Specifies whether there are comments relating to the approval of the record. If you want to read the comments, choose the field to open the Approval Comment Sheet window.];
                ApplicationArea=#Suite;
                SourceExpr=Comment }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, nÜr recorden skal godkendes af en eller flere godkendere.;
                           ENU=Specifies when the record must be approved, by one or more approvers.];
                ApplicationArea=#Suite;
                SourceExpr="Due Date" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kredit (i regnskabsvalutaen), som kunden har tilbage.;
                           ENU=Specifies the remaining credit (in LCY) that exists for the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Available Credit Limit (LCY)" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Usersetup@1000 : Record 91;
      Overdue@1005 : 'Yes, ';
      RecordIDText@1001 : Text;
      ShowRecCommentsEnabled@1002 : Boolean;

    LOCAL PROCEDURE FormatField@1(Rec@1000 : Record 454) : Boolean;
    BEGIN
      IF Status IN [Status::Created,Status::Open] THEN BEGIN
        IF Rec."Due Date" < TODAY THEN
          EXIT(TRUE);

        EXIT(FALSE);
      END;
    END;

    BEGIN
    END.
  }
}

