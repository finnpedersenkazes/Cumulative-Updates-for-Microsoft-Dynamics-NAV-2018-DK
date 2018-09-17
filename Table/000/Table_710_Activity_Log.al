OBJECT Table 710 Activity Log
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Aktivitetslogfil;
               ENU=Activity Log];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 3   ;   ;Activity Date       ;DateTime      ;CaptionML=[DAN=Aktivitetsdato;
                                                              ENU=Activity Date] }
    { 4   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 5   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Lykkedes,Mislykkedes;
                                                                    ENU=Success,Failed];
                                                   OptionString=Success,Failed }
    { 6   ;   ;Context             ;Text30        ;CaptionML=[DAN=Kontekst;
                                                              ENU=Context] }
    { 10  ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 20  ;   ;Activity Message    ;Text250       ;CaptionML=[DAN=Aktivitetsmeddelelse;
                                                              ENU=Activity Message] }
    { 21  ;   ;Detailed Info       ;BLOB          ;CaptionML=[DAN=Detaljerede oplysninger;
                                                              ENU=Detailed Info] }
    { 22  ;   ;Table No Filter     ;Integer       ;CaptionML=[DAN=Filter for tabelnr.;
                                                              ENU=Table No Filter] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
    {    ;Activity Date                            }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      DataTypeNotValidErr@1000 : TextConst 'DAN=Den angivne varianttype er ikke gyldig.;ENU=The specified variant type is not valid.';
      NoDetailsMsg@1001 : TextConst 'DAN=Logfilen indeholder ikke flere detaljer.;ENU=The log does not contain any more details.';

    [External]
    PROCEDURE LogActivity@1(RelatedVariant@1000 : Variant;NewStatus@1001 : Option;NewContext@1004 : Text[30];ActivityDescription@1002 : Text;ActivityMessage@1003 : Text);
    VAR
      UserCode@1007 : Code[50];
    BEGIN
      UserCode := '';
      LogActivityImplementation(RelatedVariant,NewStatus,NewContext,ActivityDescription,ActivityMessage,UserCode);
    END;

    [External]
    PROCEDURE ShowEntries@2(RecordVariant@1000 : Variant);
    VAR
      DataTypeManagement@1001 : Codeunit 701;
      RecRef@1002 : RecordRef;
    BEGIN
      IF NOT DataTypeManagement.GetRecordRef(RecordVariant,RecRef) THEN
        ERROR(DataTypeNotValidErr);

      SETRANGE("Record ID",RecRef.RECORDID);

      COMMIT;
      PAGE.RUNMODAL(PAGE::"Activity Log",Rec);
    END;

    [External]
    PROCEDURE SetDetailedInfoFromStream@3(InputStream@1000 : InStream);
    VAR
      InfoOutStream@1002 : OutStream;
    BEGIN
      "Detailed Info".CREATEOUTSTREAM(InfoOutStream);
      COPYSTREAM(InfoOutStream,InputStream);
      MODIFY;
    END;

    [External]
    PROCEDURE SetDetailedInfoFromText@5(Details@1000 : Text);
    VAR
      OutputStream@1001 : OutStream;
    BEGIN
      "Detailed Info".CREATEOUTSTREAM(OutputStream);
      OutputStream.WRITETEXT(Details);
      MODIFY;
    END;

    [Internal]
    PROCEDURE Export@4(DefaultFileName@1003 : Text;ShowFileDialog@1002 : Boolean) : Text;
    VAR
      TempBlob@1001 : Record 99008535;
      FileMgt@1000 : Codeunit 419;
    BEGIN
      CALCFIELDS("Detailed Info");
      IF NOT "Detailed Info".HASVALUE THEN BEGIN
        MESSAGE(NoDetailsMsg);
        EXIT;
      END;

      IF DefaultFileName = '' THEN
        DefaultFileName := 'Log.txt';

      TempBlob.Blob := "Detailed Info";

      EXIT(FileMgt.BLOBExport(TempBlob,DefaultFileName,ShowFileDialog));
    END;

    LOCAL PROCEDURE LogActivityImplementation@6(RelatedVariant@1000 : Variant;NewStatus@1001 : Option;NewContext@1004 : Text[30];ActivityDescription@1002 : Text;ActivityMessage@1003 : Text;UserCode@1007 : Code[50]);
    VAR
      DataTypeManagement@1005 : Codeunit 701;
      RecRef@1006 : RecordRef;
    BEGIN
      CLEAR(Rec);

      IF NOT DataTypeManagement.GetRecordRef(RelatedVariant,RecRef) THEN
        ERROR(DataTypeNotValidErr);

      "Record ID" := RecRef.RECORDID;
      "Activity Date" := CURRENTDATETIME;
      "User ID" := UserCode;
      IF "User ID" = '' THEN
        "User ID" := USERID;
      Status := NewStatus;
      Context := NewContext;
      Description := COPYSTR(ActivityDescription,1,MAXSTRLEN(Description));
      "Activity Message" := COPYSTR(ActivityMessage,1,MAXSTRLEN("Activity Message"));
      "Table No Filter" := RecRef.NUMBER;

      INSERT(TRUE);

      IF STRLEN(ActivityMessage) > MAXSTRLEN("Activity Message") THEN
        SetDetailedInfoFromText(ActivityMessage);
    END;

    [External]
    PROCEDURE LogActivityForUser@8(RelatedVariant@1000 : Variant;NewStatus@1001 : Option;NewContext@1004 : Text[30];ActivityDescription@1002 : Text;ActivityMessage@1003 : Text;UserCode@1007 : Code[50]);
    BEGIN
      LogActivityImplementation(RelatedVariant,NewStatus,NewContext,ActivityDescription,ActivityMessage,UserCode);
    END;

    BEGIN
    END.
  }
}

