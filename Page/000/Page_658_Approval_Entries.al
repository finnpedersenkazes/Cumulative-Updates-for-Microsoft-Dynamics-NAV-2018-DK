OBJECT Page 658 Approval Entries
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
    CaptionML=[DAN=Godkendelsesposter;
               ENU=Approval Entries];
    SourceTable=Table454;
    SourceTableView=SORTING(Record ID to Approve,Workflow Step Instance ID,Sequence No.)
                    ORDER(Ascending);
    PageType=List;
    OnOpenPage=BEGIN
                 IF Usersetup.GET(USERID) THEN
                   SETCURRENTKEY("Table ID","Document Type","Document No.");
                 MarkAllWhereUserisApproverOrSender;
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
                           ShowChangeFactBox := CurrPage.Change.PAGE.SetFilterFromApprovalEntry(Rec);
                           DelegateEnable := CanCurrentUserEdit;
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
      { 38      ;2   ;Action    ;
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
      { 42      ;2   ;Action    ;
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
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 RecRef@1000 : RecordRef;
                               BEGIN
                                 RecRef.GET("Record ID to Approve");
                                 CLEAR(ApprovalsMgmt);
                                 ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(RecRef,"Workflow Step Instance ID");
                               END;
                                }
      { 49      ;2   ;Action    ;
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
      { 50      ;2   ;Action    ;
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
      { 35      ;1   ;Action    ;
                      AccessByPermission=TableData 454=M;
                      CaptionML=[DAN=Ud&deleger;
                                 ENU=&Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsesanmodningen til en anden godkender, der er konfigureret som din stedfortrëder.;
                                 ENU=Delegate the approval request to another approver that has been set up as your substitute approver.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=DelegateEnable;
                      PromotedIsBig=Yes;
                      Image=Delegate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalEntry@1001 : Record 454;
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                                 ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
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

    { 40  ;2   ;Field     ;
                CaptionML=[DAN=Forfald;
                           ENU=Overdue];
                ToolTipML=[DAN=Angiver, at godkendelsen er overskredet.;
                           ENU=Specifies that the approval is overdue.];
                ApplicationArea=#Suite;
                SourceExpr=Overdue;
                Editable=False }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den tabel, hvor recorden, der er omfattet af godkendelsen, er gemt.;
                           ENU=Specifies the ID of the table where the record that is subject to approval is stored.];
                ApplicationArea=#Advanced;
                SourceExpr="Table ID";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den grënsetype, der gëlder for godkendelsesskabelonen:;
                           ENU=Specifies the type of limit that applies to the approval template:];
                ApplicationArea=#Suite;
                SourceExpr="Limit Type" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke godkendere der bruges i denne godkendelsesskabelon:;
                           ENU=Specifies which approvers apply to this approval template:];
                ApplicationArea=#Suite;
                SourceExpr="Approval Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken bilagstype en godkendelsespost er oprettet til. Der kan oprettes godkendelsesposter til seks forskellige typer salgs- eller kõbsbilag:;
                           ENU=Specifies the type of document that an approval entry has been created for. Approval entries can be created for six different types of sales or purchase documents:];
                ApplicationArea=#Advanced;
                SourceExpr="Document Type";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bilagsnummer, der er kopieret fra det relevante salgs- eller kõbsbilag, f.eks. en kõbsordre eller et salgstilbud.;
                           ENU=Specifies the document number copied from the relevant sales or purchase document, such as a purchase order or a sales quote.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Til godkendelse;
                           ENU=To Approve];
                ToolTipML=[DAN=Angiver den record, som du bliver bedt om at godkende.;
                           ENU=Specifies the record that you are requested to approve.];
                ApplicationArea=#Suite;
                SourceExpr=RecordIDText }

    { 9   ;2   ;Field     ;
                Name=Details;
                ToolTipML=[DAN=Angiver den record, som godkendelsen relaterer til.;
                           ENU=Specifies the record that the approval is related to.];
                ApplicationArea=#Suite;
                SourceExpr=RecordDetails }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rëkkefõlgen for godkenderne, nÜr godkendelsesworkflowet omfatter flere godkendere.;
                           ENU=Specifies the order of approvers when an approval workflow involves more than one approver.];
                ApplicationArea=#Suite;
                SourceExpr="Sequence No." }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver godkendelsesstatus for posten:;
                           ENU=Specifies the approval status for the entry:];
                ApplicationArea=#Suite;
                SourceExpr=Status }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et pÜ den bruger, som har sendt godkendelsesanmodningen for det bilag, der skal godkendes.;
                           ENU=Specifies the ID of the user who sent the approval request for the document to be approved.];
                ApplicationArea=#Suite;
                SourceExpr="Sender ID" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden pÜ den sëlger eller indkõber, der er angivet i det bilag, der skal godkendes. Feltet er ikke obligatorisk, men nyttigt, hvis den sëlger eller indkõber, der er ansvarlig for kunden/leverandõren, skal godkende dokumentet, fõr det behandles.;
                           ENU=Specifies the code for the salesperson or purchaser that was in the document to be approved. It is not a mandatory field, but is useful if a salesperson or a purchaser responsible for the customer/vendor needs to approve the document before it is processed.];
                ApplicationArea=#Suite;
                SourceExpr="Salespers./Purch. Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angivet id'et pÜ den bruger, der skal godkende bilaget.;
                           ENU=Specifies the ID of the user who must approve the document.];
                ApplicationArea=#Suite;
                SourceExpr="Approver ID" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for belõbene pÜ salgs- eller kõbslinjerne.;
                           ENU=Specifies the code of the currency of the amounts on the sales or purchase lines.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede belõb (ekskl. moms) i det dokument, der afventer godkendelse. Belõbet vises i den lokale valuta.;
                           ENU=Specifies the total amount (excl. VAT) on the document awaiting approval. The amount is stated in the local currency.];
                ApplicationArea=#Suite;
                SourceExpr="Amount (LCY)" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kredit (i regnskabsvalutaen), som kunden har tilbage.;
                           ENU=Specifies the remaining credit (in LCY) that exists for the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Available Credit Limit (LCY)" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato og det klokkeslët, hvor dokumentet blev sendt til godkendelse.;
                           ENU=Specifies the date and the time that the document was sent for approval.];
                ApplicationArea=#Suite;
                SourceExpr="Date-Time Sent for Approval" }

    { 25  ;2   ;Field     ;
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

    { 7   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 11  ;1   ;Part      ;
                Name=Change;
                ApplicationArea=#Suite;
                PagePartID=Page1527;
                Visible=ShowChangeFactBox;
                Enabled=FALSE;
                Editable=FALSE;
                PartType=Page;
                ShowFilter=No;
                UpdatePropagation=SubPart }

    { 5   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 4   ;1   ;Part      ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Usersetup@1000 : Record 91;
      Overdue@1005 : 'Yes, ';
      RecordIDText@1001 : Text;
      ShowChangeFactBox@1002 : Boolean;
      DelegateEnable@1003 : Boolean;
      ShowRecCommentsEnabled@1004 : Boolean;

    [External]
    PROCEDURE Setfilters@1(TableId@1001 : Integer;DocumentType@1002 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';DocumentNo@1003 : Code[20]);
    BEGIN
      IF TableId <> 0 THEN BEGIN
        FILTERGROUP(2);
        SETCURRENTKEY("Table ID","Document Type","Document No.");
        SETRANGE("Table ID",TableId);
        SETRANGE("Document Type",DocumentType);
        IF DocumentNo <> '' THEN
          SETRANGE("Document No.",DocumentNo);
        FILTERGROUP(0);
      END;
    END;

    LOCAL PROCEDURE FormatField@2(ApprovalEntry@1000 : Record 454) : Boolean;
    BEGIN
      IF Status IN [Status::Created,Status::Open] THEN BEGIN
        IF ApprovalEntry."Due Date" < TODAY THEN
          EXIT(TRUE);

        EXIT(FALSE);
      END;
    END;

    [External]
    PROCEDURE CalledFrom@3();
    BEGIN
      Overdue := Overdue::" ";
    END;

    BEGIN
    END.
  }
}

