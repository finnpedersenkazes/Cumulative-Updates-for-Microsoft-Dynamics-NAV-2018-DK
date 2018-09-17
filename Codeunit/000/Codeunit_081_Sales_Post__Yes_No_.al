OBJECT Codeunit 81 Sales-Post (Yes/No)
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=36;
    EventSubscriberInstance=Manual;
    OnRun=VAR
            SalesHeader@1000 : Record 36;
          BEGIN
            IF NOT FIND THEN
              ERROR(NothingToPostErr);

            SalesHeader.COPY(Rec);
            Code(SalesHeader,FALSE);
            Rec := SalesHeader;
          END;

  }
  CODE
  {
    VAR
      ShipInvoiceQst@1000 : TextConst 'DAN=&Lever,&Fakturer,Lever &og fakturer;ENU=&Ship,&Invoice,Ship &and Invoice';
      PostConfirmQst@1001 : TextConst '@@@="%1 = Document Type";DAN=Skal %1 bogf�res?;ENU=Do you want to post the %1?';
      ReceiveInvoiceQst@1002 : TextConst 'DAN=&Modtag,&Fakturer,Modtag &og fakturer;ENU=&Receive,&Invoice,Receive &and Invoice';
      NothingToPostErr@1006 : TextConst 'DAN=Der er intet at bogf�re.;ENU=There is nothing to post.';

    PROCEDURE PostAndSend@10(VAR SalesHeader@1000 : Record 36);
    VAR
      SalesHeaderToPost@1001 : Record 36;
    BEGIN
      SalesHeaderToPost.COPY(SalesHeader);
      Code(SalesHeaderToPost,TRUE);
      SalesHeader := SalesHeaderToPost;
    END;

    LOCAL PROCEDURE Code@1(VAR SalesHeader@1001 : Record 36;PostAndSend@1005 : Boolean);
    VAR
      SalesSetup@1002 : Record 311;
      SalesPostViaJobQueue@1000 : Codeunit 88;
      HideDialog@1003 : Boolean;
    BEGIN
      HideDialog := FALSE;

      OnBeforeConfirmSalesPost(SalesHeader,HideDialog);
      IF NOT HideDialog THEN
        IF NOT ConfirmPost(SalesHeader) THEN
          EXIT;

      SalesSetup.GET;
      IF SalesSetup."Post with Job Queue" AND NOT PostAndSend THEN
        SalesPostViaJobQueue.EnqueueSalesDoc(SalesHeader)
      ELSE
        CODEUNIT.RUN(CODEUNIT::"Sales-Post",SalesHeader);

      OnAfterPost(SalesHeader);
    END;

    LOCAL PROCEDURE ConfirmPost@4(VAR SalesHeader@1000 : Record 36) : Boolean;
    VAR
      Selection@1001 : Integer;
    BEGIN
      WITH SalesHeader DO BEGIN
        CASE "Document Type" OF
          "Document Type"::Order:
            BEGIN
              Selection := STRMENU(ShipInvoiceQst,3);
              Ship := Selection IN [1,3];
              Invoice := Selection IN [2,3];
              IF Selection = 0 THEN
                EXIT(FALSE);
            END;
          "Document Type"::"Return Order":
            BEGIN
              Selection := STRMENU(ReceiveInvoiceQst,3);
              IF Selection = 0 THEN
                EXIT(FALSE);
              Receive := Selection IN [1,3];
              Invoice := Selection IN [2,3];
            END
          ELSE
            IF NOT CONFIRM(PostConfirmQst,FALSE,LOWERCASE(FORMAT("Document Type"))) THEN
              EXIT(FALSE);
        END;
        "Print Posted Documents" := FALSE;
      END;
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE Preview@2(VAR SalesHeader@1000 : Record 36);
    VAR
      SalesPostYesNo@1001 : Codeunit 81;
      GenJnlPostPreview@1002 : Codeunit 19;
    BEGIN
      BINDSUBSCRIPTION(SalesPostYesNo);
      GenJnlPostPreview.Preview(SalesPostYesNo,SalesHeader);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPost@6(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [EventSubscriber(Codeunit,19,OnRunPreview)]
    LOCAL PROCEDURE OnRunPreview@3(VAR Result@1000 : Boolean;Subscriber@1001 : Variant;RecVar@1002 : Variant);
    VAR
      SalesHeader@1004 : Record 36;
      SalesPost@1003 : Codeunit 80;
    BEGIN
      WITH SalesHeader DO BEGIN
        COPY(RecVar);
        Receive := "Document Type" = "Document Type"::"Return Order";
        Ship := "Document Type" = "Document Type"::Order;
        Invoice := TRUE;
      END;
      SalesPost.SetPreviewMode(TRUE);
      Result := SalesPost.RUN(SalesHeader);
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeConfirmSalesPost@5(VAR SalesHeader@1000 : Record 36;VAR HideDialog@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

