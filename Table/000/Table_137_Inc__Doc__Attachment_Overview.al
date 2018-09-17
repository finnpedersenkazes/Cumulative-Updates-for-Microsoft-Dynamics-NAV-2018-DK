OBJECT Table 137 Inc. Doc. Attachment Overview
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=VAR
               IncomingDocumentAttachment@1000 : Record 133;
             BEGIN
               IF IncomingDocumentAttachment.GET("Incoming Document Entry No.","Line No.") THEN
                 IncomingDocumentAttachment.DELETE(TRUE);
             END;

    CaptionML=[DAN=Ind. bilag. Oversigt over vedh�ftet fil;
               ENU=Inc. Doc. Attachment Overview];
  }
  FIELDS
  {
    { 1   ;   ;Incoming Document Entry No.;Integer;TableRelation="Incoming Document";
                                                   CaptionML=[DAN=L�benr. for indg�ende bilag;
                                                              ENU=Incoming Document Entry No.] }
    { 2   ;   ;Line No.            ;Integer       ;InitValue=0;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Created Date-Time   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl�t;
                                                              ENU=Created Date-Time] }
    { 4   ;   ;Created By User Name;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugernavn for oprettelse;
                                                              ENU=Created By User Name] }
    { 5   ;   ;Name                ;Text250       ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   Editable=No }
    { 6   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Billede,PDF,Word,Excel,PowerPoint,Mail,XML,Andet";
                                                                    ENU=" ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other"];
                                                   OptionString=[ ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other];
                                                   Editable=No }
    { 7   ;   ;File Extension      ;Text30        ;CaptionML=[DAN=Filtype;
                                                              ENU=File Extension];
                                                   Editable=No }
    { 100 ;   ;Attachment Type     ;Option        ;CaptionML=[DAN=Type vedh�ftet fil;
                                                              ENU=Attachment Type];
                                                   OptionCaptionML=[DAN=,Gruppe,Prim�r vedh�ftet fil,OCR-resultat,Supplerende vedh�ftet fil,Link;
                                                                    ENU=,Group,Main Attachment,OCR Result,Supporting Attachment,Link];
                                                   OptionString=,Group,Main Attachment,OCR Result,Supporting Attachment,Link;
                                                   Editable=No }
    { 101 ;   ;Sorting Order       ;Integer       ;CaptionML=[DAN=Sorteringsr�kkef�lge;
                                                              ENU=Sorting Order] }
    { 102 ;   ;Indentation         ;Integer       ;CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation] }
  }
  KEYS
  {
    {    ;Sorting Order,Incoming Document Entry No.;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Created Date-Time,Name,File Extension    }
  }
  CODE
  {
    VAR
      SupportingAttachmentsTxt@1000 : TextConst 'DAN=Supplerende vedh�ftede filer;ENU=Supporting Attachments';
      NotAvailableAttachmentMsg@1001 : TextConst 'DAN=Den vedh�ftede fil er ikke l�ngere tilg�ngelig.;ENU=The attachment is no longer available.';
      ClientTypeManagement@1077 : Codeunit 4;

    [Internal]
    PROCEDURE NameDrillDown@13();
    VAR
      IncomingDocument@1001 : Record 130;
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      CASE "Attachment Type" OF
        "Attachment Type"::Group:
          EXIT;
        "Attachment Type"::Link:
          BEGIN
            IncomingDocument.GET("Incoming Document Entry No.");
            HYPERLINK(IncomingDocument.GetURL);
          END
        ELSE BEGIN
          IF NOT IncomingDocumentAttachment.GET("Incoming Document Entry No.","Line No.") THEN
            MESSAGE(NotAvailableAttachmentMsg)
          ELSE
            IF (Type = Type::Image) AND (ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Phone) THEN
              PAGE.RUN(PAGE::"O365 Incoming Doc. Att. Pict.",IncomingDocumentAttachment)
            ELSE
              IncomingDocumentAttachment.Export(Name + '.' + "File Extension",TRUE);
        END
      END;
    END;

    [External]
    PROCEDURE GetStyleTxt@4() : Text;
    BEGIN
      CASE "Attachment Type" OF
        "Attachment Type"::Group,
        "Attachment Type"::"Main Attachment",
        "Attachment Type"::Link:
          EXIT('Strong');
        ELSE
          EXIT('Standard');
      END;
    END;

    [Internal]
    PROCEDURE InsertFromIncomingDocument@2(IncomingDocument@1000 : Record 130;VAR TempIncDocAttachmentOverview@1003 : TEMPORARY Record 137);
    VAR
      SortingOrder@1004 : Integer;
    BEGIN
      InsertMainAttachment(IncomingDocument,TempIncDocAttachmentOverview,SortingOrder);
      InsertLinkAddress(IncomingDocument,TempIncDocAttachmentOverview,SortingOrder);
      InsertSupportingAttachments(
        IncomingDocument,TempIncDocAttachmentOverview,SortingOrder,
        IncomingDocument."Document Type" <> IncomingDocument."Document Type"::"Sales Invoice");
    END;

    [External]
    PROCEDURE InsertSupportingAttachmentsFromIncomingDocument@1(IncomingDocument@1001 : Record 130;VAR TempIncDocAttachmentOverview@1000 : TEMPORARY Record 137);
    VAR
      SortingOrder@1002 : Integer;
    BEGIN
      InsertSupportingAttachments(IncomingDocument,TempIncDocAttachmentOverview,SortingOrder,FALSE);
    END;

    LOCAL PROCEDURE InsertMainAttachment@3(IncomingDocument@1000 : Record 130;VAR TempIncDocAttachmentOverview@1001 : TEMPORARY Record 137;VAR SortingOrder@1002 : Integer);
    VAR
      IncomingDocumentAttachment@1003 : Record 133;
    BEGIN
      IF NOT IncomingDocument.GetMainAttachment(IncomingDocumentAttachment) THEN
        EXIT;

      IF IncomingDocument."Document Type" = IncomingDocument."Document Type"::"Sales Invoice" THEN
        InsertFromIncomingDocumentAttachment(
          TempIncDocAttachmentOverview,IncomingDocumentAttachment,SortingOrder,
          TempIncDocAttachmentOverview."Attachment Type"::"Supporting Attachment",0)
      ELSE
        InsertFromIncomingDocumentAttachment(
          TempIncDocAttachmentOverview,IncomingDocumentAttachment,SortingOrder,
          TempIncDocAttachmentOverview."Attachment Type"::"Main Attachment",0);
    END;

    LOCAL PROCEDURE InsertSupportingAttachments@6(IncomingDocument@1000 : Record 130;VAR TempIncDocAttachmentOverview@1001 : TEMPORARY Record 137;VAR SortingOrder@1002 : Integer;IncludeGroupCaption@1004 : Boolean);
    VAR
      IncomingDocumentAttachment@1003 : Record 133;
      Indentation2@1005 : Integer;
    BEGIN
      IF NOT IncomingDocument.GetAdditionalAttachments(IncomingDocumentAttachment) THEN
        EXIT;

      IF IncludeGroupCaption THEN
        InsertGroup(TempIncDocAttachmentOverview,IncomingDocument,SortingOrder,SupportingAttachmentsTxt);
      IF IncomingDocument."Document Type" = IncomingDocument."Document Type"::"Sales Invoice" THEN
        Indentation2 := 0
      ELSE
        Indentation2 := 1;
      REPEAT
        InsertFromIncomingDocumentAttachment(
          TempIncDocAttachmentOverview,IncomingDocumentAttachment,SortingOrder,
          TempIncDocAttachmentOverview."Attachment Type"::"Supporting Attachment",Indentation2);
      UNTIL IncomingDocumentAttachment.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertLinkAddress@8(IncomingDocument@1003 : Record 130;VAR TempIncDocAttachmentOverview@1000 : TEMPORARY Record 137;VAR SortingOrder@1002 : Integer);
    VAR
      URL@1001 : Text;
    BEGIN
      URL := IncomingDocument.GetURL;
      IF URL = '' THEN
        EXIT;

      CLEAR(TempIncDocAttachmentOverview);
      TempIncDocAttachmentOverview.INIT;
      TempIncDocAttachmentOverview."Incoming Document Entry No." := IncomingDocument."Entry No.";
      AssignSortingNo(TempIncDocAttachmentOverview,SortingOrder);
      TempIncDocAttachmentOverview.Name := COPYSTR(URL,1,MAXSTRLEN(TempIncDocAttachmentOverview.Name));
      TempIncDocAttachmentOverview."Attachment Type" := TempIncDocAttachmentOverview."Attachment Type"::Link;
      TempIncDocAttachmentOverview.INSERT(TRUE);
    END;

    LOCAL PROCEDURE InsertFromIncomingDocumentAttachment@7(VAR TempIncDocAttachmentOverview@1001 : TEMPORARY Record 137;IncomingDocumentAttachment@1000 : Record 133;VAR SortingOrder@1002 : Integer;AttachmentType@1003 : Option;Indentation2@1004 : Integer);
    BEGIN
      CLEAR(TempIncDocAttachmentOverview);
      TempIncDocAttachmentOverview.INIT;
      TempIncDocAttachmentOverview.TRANSFERFIELDS(IncomingDocumentAttachment);
      AssignSortingNo(TempIncDocAttachmentOverview,SortingOrder);
      TempIncDocAttachmentOverview."Attachment Type" := AttachmentType;
      TempIncDocAttachmentOverview.Indentation := Indentation2;
      TempIncDocAttachmentOverview.INSERT(TRUE);
    END;

    LOCAL PROCEDURE InsertGroup@10(VAR TempIncDocAttachmentOverview@1001 : TEMPORARY Record 137;IncomingDocument@1000 : Record 130;VAR SortingOrder@1002 : Integer;Description@1003 : Text[50]);
    BEGIN
      CLEAR(TempIncDocAttachmentOverview);
      TempIncDocAttachmentOverview.INIT;
      TempIncDocAttachmentOverview."Incoming Document Entry No." := IncomingDocument."Entry No.";
      AssignSortingNo(TempIncDocAttachmentOverview,SortingOrder);
      TempIncDocAttachmentOverview."Attachment Type" := TempIncDocAttachmentOverview."Attachment Type"::Group;
      TempIncDocAttachmentOverview.Type := Type::" ";
      TempIncDocAttachmentOverview.Name := Description;
      TempIncDocAttachmentOverview.INSERT(TRUE);
    END;

    LOCAL PROCEDURE AssignSortingNo@5(VAR TempIncDocAttachmentOverview@1000 : TEMPORARY Record 137;VAR SortingOrder@1001 : Integer);
    BEGIN
      SortingOrder += 1;
      TempIncDocAttachmentOverview."Sorting Order" := SortingOrder;
    END;

    BEGIN
    END.
  }
}

