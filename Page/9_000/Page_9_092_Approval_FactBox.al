OBJECT Page 9092 Approval FactBox
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Godkendelse;
               ENU=Approval];
    SourceTable=Table454;
    PageType=CardPart;
    OnFindRecord=BEGIN
                   DocumentHeading := '';
                   EXIT(FINDLAST);
                 END;

    OnAfterGetRecord=BEGIN
                       DocumentHeading := GetDocumentHeading(Rec);
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 7   ;1   ;Field     ;
                CaptionML=[DAN=Dokument;
                           ENU=Document];
                ToolTipML=[DAN=Angiver det salgsdokument, der er godkendt.;
                           ENU=Specifies the document that has been approved.];
                ApplicationArea=#Suite;
                SourceExpr=DocumentHeading }

    { 1   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver godkendelsesstatus for posten:;
                           ENU=Specifies the approval status for the entry:];
                ApplicationArea=#Suite;
                SourceExpr=Status }

    { 3   ;1   ;Field     ;
                ToolTipML=[DAN=Angivet id'et p† den bruger, der skal godkende dokumentet (godkenderen).;
                           ENU=Specifies the ID of the user who must approve the document (the Approver).];
                ApplicationArea=#Suite;
                SourceExpr="Approver ID" }

    { 5   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den dato og det klokkesl‘t, hvor dokumentet blev sendt til godkendelse.;
                           ENU=Specifies the date and the time that the document was sent for approval.];
                ApplicationArea=#Suite;
                SourceExpr="Date-Time Sent for Approval" }

    { 2   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, om der er bem‘rkninger til godkendelsen af recorden. Hvis du vil l‘se bem‘rkningerne, skal du v‘lge feltet for at †bne vinduet Godkendelsesbem‘rkninger.;
                           ENU=Specifies whether there are comments relating to the approval of the record. If you want to read the comments, choose the field to open the Approval Comment Sheet window.];
                ApplicationArea=#Suite;
                SourceExpr=Comment }

  }
  CODE
  {
    VAR
      DocumentHeading@1001 : Text[250];
      Text000@1000 : TextConst 'DAN=Dokument;ENU=Document';

    LOCAL PROCEDURE GetDocumentHeading@6(ApprovalEntry@1000 : Record 454) : Text[50];
    VAR
      Heading@1001 : Text[50];
    BEGIN
      IF ApprovalEntry."Document Type" = 0 THEN
        Heading := Text000
      ELSE
        Heading := FORMAT(ApprovalEntry."Document Type");
      Heading := Heading + ' ' + ApprovalEntry."Document No.";
      EXIT(Heading);
    END;

    PROCEDURE UpdateApprovalEntriesFromSourceRecord@1(SourceRecordID@1000 : RecordID);
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      SETRANGE("Record ID to Approve",SourceRecordID);
      ApprovalEntry.COPY(Rec);
      IF ApprovalEntry.FINDFIRST THEN
        SETFILTER("Approver ID",'<>%1',ApprovalEntry."Sender ID");
      IF FINDLAST THEN;
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

