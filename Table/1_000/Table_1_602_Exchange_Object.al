OBJECT Table 1602 Exchange Object
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Exchange-objekt;
               ENU=Exchange Object];
  }
  FIELDS
  {
    { 1   ;   ;Item ID             ;Text250       ;CaptionML=[DAN=Vare-id;
                                                              ENU=Item ID];
                                                   Description=ID of object in Exchange. }
    { 2   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Mail,Vedh‘ftet fil;
                                                                    ENU=Email,Attachment];
                                                   OptionString=Email,Attachment;
                                                   Description=Type of Exchange object. }
    { 3   ;   ;Name                ;Text250       ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   Description=Name of the object in Exchange. }
    { 4   ;   ;Body                ;BLOB          ;CaptionML=[DAN=Tekst;
                                                              ENU=Body];
                                                   Description=Body of the message. }
    { 5   ;   ;Parent ID           ;Text250       ;CaptionML=[DAN=Id for overordnet;
                                                              ENU=Parent ID];
                                                   Description=ID of the parent object. }
    { 6   ;   ;Content             ;BLOB          ;CaptionML=[DAN=Indhold;
                                                              ENU=Content];
                                                   Description=Content of the object. }
    { 8   ;   ;ViewLink            ;BLOB          ;CaptionML=[DAN=ViewLink;
                                                              ENU=ViewLink];
                                                   Description=A link to view the object in a browser. }
    { 10  ;   ;Owner               ;GUID          ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Ejer;
                                                              ENU=Owner];
                                                   Description=Owner of the Exchange object. }
    { 11  ;   ;Selected            ;Boolean       ;CaptionML=[DAN=Valgt;
                                                              ENU=Selected];
                                                   Description=A selection flag }
    { 12  ;   ;Content Type        ;Text250       ;CaptionML=[DAN=Indholdstype;
                                                              ENU=Content Type];
                                                   Description=The file type of the attachment }
    { 13  ;   ;InitiatedAction     ;Option        ;CaptionML=[DAN=InitiatedAction;
                                                              ENU=InitiatedAction];
                                                   OptionCaptionML=[DAN=InitiateSendToOCR,InitiateSendToIncomingDocuments,InitiateSendToWorkFlow;
                                                                    ENU=InitiateSendToOCR,InitiateSendToIncomingDocuments,InitiateSendToWorkFlow];
                                                   OptionString=InitiateSendToOCR,InitiateSendToIncomingDocuments,InitiateSendToWorkFlow;
                                                   Description=The action to be performed to the record }
    { 14  ;   ;VendorNo            ;Code50        ;CaptionML=[DAN=VendorNo;
                                                              ENU=VendorNo];
                                                   Description=Vendor Number of the current Vendor }
    { 15  ;   ;IsInline            ;Boolean       ;CaptionML=[DAN=ErInline;
                                                              ENU=IsInline];
                                                   Description=Indicates if the attachment is Inline }
  }
  KEYS
  {
    {    ;Item ID                                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE SetBody@1(BodyText@1000 : Text);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      CALCFIELDS(Body);
      CLEAR(Body);
      Body.CREATEOUTSTREAM(OutStream);
      OutStream.WRITETEXT(BodyText);
    END;

    [External]
    PROCEDURE GetBody@2() BodyText : Text;
    VAR
      InStream@1000 : InStream;
    BEGIN
      CALCFIELDS(Body);
      Body.CREATEINSTREAM(InStream);
      InStream.READTEXT(BodyText);
    END;

    [External]
    PROCEDURE SetViewLink@3(NewLinkUrl@1001 : Text);
    VAR
      WriteStream@1000 : OutStream;
    BEGIN
      CALCFIELDS(ViewLink);
      CLEAR(ViewLink);
      ViewLink.CREATEOUTSTREAM(WriteStream);
      WriteStream.WRITETEXT(NewLinkUrl);
    END;

    [External]
    PROCEDURE GetViewLink@4() UrlText : Text;
    VAR
      ReadStream@1001 : InStream;
    BEGIN
      CALCFIELDS(ViewLink);
      ViewLink.CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(UrlText);
    END;

    [External]
    PROCEDURE SetContent@5(NewContent@1000 : InStream);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      CALCFIELDS(Content);
      CLEAR(Content);
      Content.CREATEOUTSTREAM(OutStream);
      COPYSTREAM(OutStream,NewContent);
    END;

    BEGIN
    END.
  }
}

