OBJECT Page 659 Posted Approval Entries
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
    CaptionML=[DAN=Bogf�rte godkendelsesposter;
               ENU=Posted Approval Entries];
    SourceTable=Table456;
    DataCaptionFields=Document No.;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       PostedRecordID := FORMAT("Posted Record ID",0,1);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           PostedRecordID := FORMAT("Posted Record ID",0,1);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vi&s;
                                 ENU=&Show];
                      Image=View }
      { 29      ;2   ;Action    ;
                      Name=Comments;
                      CaptionML=[DAN=Bem�rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewComments;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PostedApprovalCommentLine@1000 : Record 457;
                               BEGIN
                                 PostedApprovalCommentLine.FILTERGROUP(2);
                                 PostedApprovalCommentLine.SETRANGE("Posted Record ID","Posted Record ID");
                                 PostedApprovalCommentLine.FILTERGROUP(0);
                                 PAGE.RUN(PAGE::"Posted Approval Comments",PostedApprovalCommentLine);
                               END;
                                }
      { 6       ;2   ;Action    ;
                      Name=Record;
                      CaptionML=[DAN=Record;
                                 ENU=Record];
                      ToolTipML=[DAN=�bn bilaget, kladdelinjen eller kortet, som godkendelsesanmodningen vedr�rer.;
                                 ENU=Open the document, journal line, or card that the approval request is for.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Document;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowRecord;
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

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Godkendt;
                           ENU=Approved];
                ToolTipML=[DAN=Angiver, om godkendelsesanmodningen er blevet godkendt.;
                           ENU=Specifies that the approval request has been approved.];
                ApplicationArea=#Suite;
                SourceExpr=PostedRecordID }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af h�ndteringsgentagelser, som denne godkendelsesanmodning har n�et.;
                           ENU=Specifies the number of handling iterations that this approval request has reached.];
                ApplicationArea=#Suite;
                SourceExpr="Iteration No." }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver r�kkef�lgen for godkenderne, n�r godkendelsesworkflowet omfatter flere godkendere.;
                           ENU=Specifies the order of approvers when an approval workflow involves more than one approver.];
                ApplicationArea=#Suite;
                SourceExpr="Sequence No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den tabel, hvor recorden, der er omfattet af godkendelsen, er gemt.;
                           ENU=Specifies the ID of the table where the record that is subject to approval is stored.];
                ApplicationArea=#Advanced;
                SourceExpr="Table ID";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bilagsnummer, der er kopieret fra det relevante salgs- eller k�bsbilag, f.eks. en k�bsordre eller et salgstilbud.;
                           ENU=Specifies the document number copied from the relevant sales or purchase document, such as a purchase order or a sales quote.];
                ApplicationArea=#Suite;
                SourceExpr="Document No." }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p� den bruger, som har sendt godkendelsesanmodningen for det bilag, der skal godkendes.;
                           ENU=Specifies the ID of the user who sent the approval request for the document to be approved.];
                ApplicationArea=#Suite;
                SourceExpr="Sender ID" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden p� den s�lger eller indk�ber, der er angivet i det bilag, der skal godkendes. Feltet er ikke obligatorisk, men nyttigt, hvis den s�lger eller indk�ber, der er ansvarlig for debitoren/kreditoren, skal godkende bilaget, f�r det sendes.;
                           ENU=Specifies the code for the salesperson or purchaser that was in the document to be approved. It is not a mandatory field, but is useful if a salesperson or a purchaser responsible for the customer/vendor needs to approve the document before it is sent.];
                ApplicationArea=#Suite;
                SourceExpr="Salespers./Purch. Code" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angivet id'et p� den bruger, der skal godkende bilaget.;
                           ENU=Specifies the ID of the user who must approve the document.];
                ApplicationArea=#Suite;
                SourceExpr="Approver ID" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver godkendelsesstatus for posten:;
                           ENU=Specifies the approval status for the entry:];
                ApplicationArea=#Suite;
                SourceExpr=Status }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato og det klokkesl�t, hvor dokumentet blev sendt til godkendelse.;
                           ENU=Specifies the date and the time that the document was sent for approval.];
                ApplicationArea=#Suite;
                SourceExpr="Date-Time Sent for Approval" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor godkendelsesposten senest blev �ndret. Hvis dokumentgodkendelsen f.eks. annulleres, opdateres dette felt tilsvarende.;
                           ENU=Specifies the date when the approval entry was last modified. If, for example, the document approval is canceled, this field will be updated accordingly.];
                ApplicationArea=#Suite;
                SourceExpr="Last Date-Time Modified" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p� den person, som senest har �ndret godkendelsesposten. Hvis dokumentgodkendelsen f.eks. annulleres, opdateres dette felt tilsvarende.;
                           ENU=Specifies the ID of the person who last modified the approval entry. If, for example, the document approval is canceled, this field will be updated accordingly.];
                ApplicationArea=#Suite;
                SourceExpr="Last Modified By ID" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der er bem�rkninger til godkendelsen af bilaget. Hvis du vil l�se bem�rkningerne, skal du klikke p� feltet for at �bne vinduet Bem�rkning.;
                           ENU=Specifies whether there are comments related to the approval of the document. If you want to read the comments, click the field to open the Comment Sheet window.];
                ApplicationArea=#Suite;
                SourceExpr=Comment }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor godkenderen senest skal godkende bilaget.;
                           ENU=Specifies the date when the document is due for approval by the approver.];
                ApplicationArea=#Suite;
                SourceExpr="Due Date" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede bel�b (ekskl. moms) i det bilag, der afventer godkendelse. Bel�bet vises i den lokale valuta.;
                           ENU=Specifies the total amount (excl. VAT) on the document waiting for approval. The amount is stated in the local currency.];
                ApplicationArea=#Suite;
                SourceExpr="Amount (LCY)" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel�bene p� salgs- eller k�bslinjerne.;
                           ENU=Specifies the code of the currency of the amounts on the sales or purchase lines.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver for den bogf�rte godkendelsespost, n�r en overskredet godkendelsesanmodning blev uddelegeret automatisk til den relevante stedfortr�der. Feltet udfyldes med v�rdien i feltet Uddeleger efter i vinduet Workflowrespons, oversat til en datoformular. Datoen for automatisk uddelegering bliver derefter beregnet ud fra Afsendelsesdato og -tidspunkt for godkendelse for feltet Godkendelse i vinduet Godkendelsesposter.;
                           ENU=Specifies for the posted approval entry when an overdue approval request was automatically delegated to the relevant substitute. The field is filled with the value in the Delegate After field in the Workflow Responses window, translated to a date formula. The date of automatic delegation is then calculated based on the Date-Time Sent for Approval field in the Approval Entries window.];
                ApplicationArea=#Suite;
                SourceExpr="Delegation Date Formula" }

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
      PostedRecordID@1000 : Text;

    BEGIN
    END.
  }
}

