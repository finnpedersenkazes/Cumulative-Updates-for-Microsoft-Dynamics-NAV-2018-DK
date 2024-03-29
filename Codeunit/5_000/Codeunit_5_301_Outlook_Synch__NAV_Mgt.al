OBJECT Codeunit 5301 Outlook Synch. NAV Mgt
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      OSynchEntity@1002 : Record 5300;
      OSynchEntityElement@1007 : Record 5301;
      OSynchLink@1005 : Record 5302;
      OSynchFilter@1008 : Record 5303;
      OSynchField@1004 : Record 5304;
      OSynchUserSetup@1006 : Record 5305;
      OSynchSetupDetail@1009 : Record 5310;
      GlobalRecordIDBuffer@1014 : TEMPORARY Record 5302;
      SortedEntitiesBuffer@1020 : TEMPORARY Record 5306;
      OSynchSetupMgt@1001 : Codeunit 5300;
      OSynchTypeConversion@1013 : Codeunit 5302;
      OSynchOutlookMgt@1018 : Codeunit 5304;
      OSynchProcessLine@1023 : Codeunit 5305;
      XMLWriter@1000 : DotNet "'Microsoft.Dynamics.Nav.OLSync.Common, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.NAV.OLSync.Common.XmlTextWriter";
      Text001@1010 : TextConst '@@@=%1 - product name;DAN=Synkroniseringen mislykkedes, fordi synkroniseringsdataene ikke kunne hentes fra %1. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=The synchronization failed because the synchronization data could not be obtained from %1. Try again later and if the problem persists contact your system administrator.';
      Text002@1011 : TextConst 'DAN=Synkroniseringen mislykkedes, fordi synkroniseringsdataene fra Microsoft Outlook ikke kan behandles. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=The synchronization failed because the synchronization data from Microsoft Outlook cannot be processed. Try again later and if the problem persists contact your system administrator.';
      Text003@1016 : TextConst 'DAN=Synkroniseringen mislykkedes, fordi korrelationen af feltet %1 i enheden %2 ikke blev fundet. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=The synchronization failed because the correlation for the %1 field of the %2 entity cannot be found. Try again later and if the problem persists contact your system administrator.';
      Text004@1017 : TextConst 'DAN=Synkroniseringen mislykkedes, fordi et Outlook-element i enheden %1 ikke blev fundet i synkroniseringsmapperne.;ENU=The synchronization failed because an Outlook item of %1 entity could not be found in the synchronization folders.';
      Text005@1022 : TextConst 'DAN=Synkroniseringen mislykkedes, fordi enhederne %1 og %2 indeholder identiske poster. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=The synchronization failed because the %1 and %2 entities contain the same entries. Try again later and if the problem persists contact your system administrator.';
      Text008@1019 : TextConst '@@@=%1 - product name;DAN=Synkroniseringen kan ikke udf�res, fordi registreringen af data�ndringer i %1 ikke er aktiveret. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=The synchronization cannot be performed because the tracking of data changes in %1 has not been activated. Try again later and if the problem persists contact your system administrator.';
      Text009@1015 : TextConst 'DAN=Synkroniseringen mislykkedes, fordi korrelationen af feltet %1 for samlingen %2 i enheden %3 ikke blev fundet. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=The synchronization failed because the correlation for the %1 field of the %2 collection in the %3 entity cannot be found. Try again later and if the problem persists contact your system administrator.';
      Text010@1003 : TextConst '@@@=%2 - product name;DAN=Synkroniseringen mislykkedes, fordi synkroniseringsdataene ikke kunne hentes fra %2 for enheden %1. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=The synchronization failed because the synchronization data could not be obtained from %2 for the %1 entity. Try again later and if the problem persists contact your system administrator.';

    [Internal]
    PROCEDURE StartSynchronization@25(UserID@1000 : Code[50];VAR XMLMessage@1002 : Text;SynchronizeAll@1004 : Boolean);
    VAR
      SynchStartTime@1003 : DateTime;
    BEGIN
      IF NOT (STRLEN(XMLMessage) > 0) THEN
        ERROR(Text001);

      SortedEntitiesBuffer.RESET;
      SortedEntitiesBuffer.DELETEALL;

      GetSortedEntities(UserID,SortedEntitiesBuffer,FALSE);

      CLEAR(XMLWriter);
      XMLWriter := XMLWriter.XmlTextWriter;
      XMLWriter.WriteStartDocument;
      XMLWriter.WriteStartElement('SynchronizationMessage');

      IF (NOT CheckChangeLogAvailability) AND (NOT SynchronizeAll) THEN
        ERROR(Text008,PRODUCTNAME.FULL);

      ProcessRenamedRecords(UserID);
      SynchStartTime := OSynchOutlookMgt.ProcessOutlookChanges(UserID,XMLMessage,XMLWriter,FALSE);
      IF SynchronizeAll THEN BEGIN
        ProcessDeletedRecords(UserID);
        CollectNavisionChanges(UserID,SynchronizeAll,SynchStartTime);
      END ELSE BEGIN
        CollectNavisionChanges(UserID,SynchronizeAll,SynchStartTime);
        ProcessDeletedRecords(UserID);
      END;

      IF NOT ISNULL(XMLWriter) THEN BEGIN
        XMLWriter.WriteEndElement;
        XMLWriter.WriteEndDocument;

        XMLMessage := XMLWriter.ToString;
        CLEAR(XMLWriter);

        IF STRLEN(XMLMessage) = 0 THEN
          ERROR(Text001,PRODUCTNAME.FULL);
      END;
    END;

    [Internal]
    PROCEDURE CollectConflictedEntities@11(UserID@1002 : Code[50];VAR XMLMessage@1006 : Text);
    VAR
      EntityRecRef@1010 : RecordRef;
      TempEntityRecRef@1011 : RecordRef;
      EntityRecID@1007 : RecordID;
      XmlTextReader@1000 : DotNet "'Microsoft.Dynamics.Nav.OLSync.Common, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.NAV.OLSync.Common.XmlTextReader";
      SynchEntityCode@1009 : Code[10];
      Container@1005 : Text;
      TagName@1003 : Text[80];
      RootIterator@1004 : Text[38];
      EntryIDHash@1008 : Text[32];
    BEGIN
      XmlTextReader := XmlTextReader.XmlTextReader;

      IF NOT XmlTextReader.LoadXml(XMLMessage) THEN
        ERROR(Text002);

      TagName := XmlTextReader.RootLocalName;
      IF TagName <> 'RefreshTroubleshootingInfo' THEN
        ERROR(Text002);

      IF XmlTextReader.SelectElements(RootIterator,'*') < 1 THEN
        EXIT;

      TagName := XmlTextReader.GetName(RootIterator);
      IF TagName <> 'OutlookItem' THEN
        ERROR(Text002);

      IF ISNULL(XMLWriter) THEN
        XMLWriter := XMLWriter.XmlTextWriter;
      XMLWriter.WriteStartDocument;
      XMLWriter.WriteStartElement('SynchronizationMessage');

      IF XmlTextReader.SelectElements(RootIterator,'child::OutlookItem') > 0 THEN BEGIN
        CLEAR(Container);
        GlobalRecordIDBuffer.RESET;
        GlobalRecordIDBuffer.DELETEALL;

        REPEAT
          CLEAR(EntityRecID);
          EntryIDHash := '';

          TagName := XmlTextReader.GetName(RootIterator);
          SynchEntityCode :=
            COPYSTR(XmlTextReader.GetCurrentNodeAttribute(RootIterator,'SynchEntityCode'),1,MAXSTRLEN(SynchEntityCode));

          OSynchUserSetup.GET(UserID,SynchEntityCode);
          OSynchEntity.GET(SynchEntityCode);
          EntryIDHash := OSynchOutlookMgt.GetEntryIDHash(Container,XmlTextReader,RootIterator);
          IF EntryIDHash <> '' THEN BEGIN
            OSynchLink.RESET;
            OSynchLink.SETRANGE("User ID",UserID);
            OSynchLink.SETRANGE("Outlook Entry ID Hash",EntryIDHash);
            IF OSynchLink.FINDFIRST THEN BEGIN
              EVALUATE(EntityRecID,FORMAT(OSynchLink."Record ID"));
              GlobalRecordIDBuffer.SETRANGE("Search Record ID",UPPERCASE(FORMAT(EntityRecID)));
              IF NOT GlobalRecordIDBuffer.FINDFIRST THEN
                IF EntityRecRef.GET(EntityRecID) THEN BEGIN
                  TempEntityRecRef.OPEN(EntityRecID.TABLENO,TRUE);
                  CopyRecordReference(EntityRecRef,TempEntityRecRef,FALSE);
                  ProcessEntityRecords(TempEntityRecRef,SynchEntityCode);
                  TempEntityRecRef.CLOSE;
                END ELSE BEGIN
                  XMLWriter.WriteStartElement('DeletedOutlookItem');
                  XMLWriter.WriteAttribute('SynchEntityCode',SynchEntityCode);
                  XMLWriter.WriteAttribute('RecordID',FORMAT(EntityRecID));
                  XMLWriter.WriteAttribute(
                    'LastModificationTime',
                    OSynchTypeConversion.SetDateTimeFormat(
                      OSynchTypeConversion.LocalDT2UTC(OSynchOutlookMgt.GetLastModificationTime(EntityRecID))));
                  WriteLinkedOutlookEntryID(UserID,EntityRecID,XMLWriter);
                  XMLWriter.WriteEndElement;

                  UpdateGlobalRecordIDBuffer(EntityRecID,SynchEntityCode);
                END;
            END ELSE BEGIN
              XMLWriter.WriteStartElement('DeletedOutlookItem');
              XMLWriter.WriteAttribute('SynchEntityCode',SynchEntityCode);
              XMLWriter.WriteAttribute('RecordID','');
              XMLWriter.WriteAttribute(
                'LastModificationTime',
                OSynchTypeConversion.SetDateTimeFormat(OSynchTypeConversion.LocalDT2UTC(0DT)));

              XMLWriter.WriteStartElement('EntryID');
              XMLWriter.WriteElementTextContent(OSynchOutlookMgt.ConvertValueToBase64(Container));
              XMLWriter.WriteEndElement;

              XMLWriter.WriteEndElement;
            END;
          END ELSE
            OSynchOutlookMgt.WriteErrorLog(
              UserID,
              EntityRecID,
              'Error',
              SynchEntityCode,
              STRSUBSTNO(Text004,SynchEntityCode),
              XMLWriter,
              Container);
        UNTIL NOT XmlTextReader.MoveNext(RootIterator);
      END;

      IF NOT ISNULL(XMLWriter) THEN BEGIN
        XMLWriter.WriteEndElement;
        XMLWriter.WriteEndDocument;

        XMLMessage := XMLWriter.ToString;
        CLEAR(XMLWriter);

        IF STRLEN(XMLMessage) = 0 THEN
          ERROR(Text001);
      END;
    END;

    [Internal]
    PROCEDURE CollectNavisionChanges@4(UserID@1000 : Code[50];SynchronizeAll@1001 : Boolean;SynchStartTime@1002 : DateTime);
    BEGIN
      IF NOT SortedEntitiesBuffer.FINDSET THEN
        EXIT;

      GlobalRecordIDBuffer.RESET;
      GlobalRecordIDBuffer.DELETEALL;

      REPEAT
        OSynchUserSetup.GET(UserID,SortedEntitiesBuffer.Name);
        OSynchEntity.GET(SortedEntitiesBuffer.Name);

        CollectEntityChanges(SynchronizeAll,SynchStartTime);
        CollectEntityElementChanges(SynchronizeAll,SynchStartTime);
      UNTIL SortedEntitiesBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE CollectEntityChanges@22(SynchronizeAll@1001 : Boolean;SynchStartTime@1006 : DateTime);
    VAR
      TempDeletedChangeLogEntry@1000 : TEMPORARY Record 405;
      TempRecRef@1003 : RecordRef;
      TempRecRef1@1005 : RecordRef;
      NullRecRef@1002 : RecordRef;
      RecID@1004 : RecordID;
    BEGIN
      TempDeletedChangeLogEntry.RESET;
      TempDeletedChangeLogEntry.DELETEALL;

      IF NOT SynchronizeAll THEN BEGIN
        TempRecRef.OPEN(OSynchEntity."Table No.",TRUE);
        ProcessChangeLog(
          OSynchEntity."Table No.",
          OSynchUserSetup."Last Synch. Time",
          TempRecRef,
          TempDeletedChangeLogEntry);
      END ELSE
        TempRecRef.OPEN(OSynchEntity."Table No.");

      OSynchFilter.RESET;
      OSynchFilter.SETFILTER(
        "Record GUID",
        '%1|%2',
        OSynchEntity."Record GUID",
        OSynchUserSetup."Record GUID");

      TempRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,NullRecRef));
      IF TempRecRef.FIND('-') THEN
        REPEAT
          IF SynchronizeAll THEN
            ProcessEntityRecords(TempRecRef,OSynchUserSetup."Synch. Entity Code")
          ELSE BEGIN
            EVALUATE(RecID,FORMAT(TempRecRef.RECORDID));
            IF CheckTimeCondition(RecID,SynchStartTime) THEN BEGIN
              TempRecRef1.OPEN(OSynchEntity."Table No.",TRUE);
              CopyRecordReference(TempRecRef,TempRecRef1,FALSE);
              ProcessEntityRecords(TempRecRef1,OSynchUserSetup."Synch. Entity Code");
              TempRecRef1.CLOSE;
            END;
          END;
        UNTIL TempRecRef.NEXT = 0;

      IF NOT SynchronizeAll THEN
        IF TempDeletedChangeLogEntry.FIND('-') THEN
          ProcessDeletedEntityRecords(TempDeletedChangeLogEntry);

      TempDeletedChangeLogEntry.RESET;
      TempDeletedChangeLogEntry.DELETEALL;
      TempRecRef.CLOSE;
    END;

    LOCAL PROCEDURE CollectEntityElementChanges@23(SynchronizeAll@1000 : Boolean;SynchStartTime@1001 : DateTime);
    VAR
      TempDeletedChangeLogEntry@1004 : TEMPORARY Record 405;
      TempRecRef@1003 : RecordRef;
    BEGIN
      IF SynchronizeAll THEN
        EXIT;

      OSynchSetupDetail.RESET;
      OSynchSetupDetail.SETRANGE("User ID",OSynchUserSetup."User ID");
      OSynchSetupDetail.SETRANGE("Synch. Entity Code",OSynchUserSetup."Synch. Entity Code");
      IF OSynchSetupDetail.FIND('-') THEN
        REPEAT
          OSynchEntityElement.GET(OSynchSetupDetail."Synch. Entity Code",OSynchSetupDetail."Element No.");
          TempRecRef.OPEN(OSynchEntityElement."Table No.",TRUE);
          ProcessChangeLog(
            OSynchEntityElement."Table No.",
            OSynchUserSetup."Last Synch. Time",
            TempRecRef,
            TempDeletedChangeLogEntry);

          IF TempRecRef.FIND('-') THEN
            ProcessEntityElements(TempRecRef,SynchStartTime);
          IF TempDeletedChangeLogEntry.FIND('-') THEN
            ProcessDeletedEntityElements(TempDeletedChangeLogEntry,SynchStartTime);

          TempRecRef.CLOSE;
          TempDeletedChangeLogEntry.DELETEALL;
        UNTIL OSynchSetupDetail.NEXT = 0;
    END;

    LOCAL PROCEDURE ProcessEntityRecords@5(VAR EntityRecRefIn@1000 : RecordRef;SynchEntityCode@1002 : Code[10]);
    VAR
      OSynchEntity1@1003 : Record 5300;
      OSynchEntityElement1@1007 : Record 5301;
      OSynchField1@1001 : Record 5304;
      OSynchFilter1@1011 : Record 5303;
      OSynchUserSetup1@1006 : Record 5305;
      OSynchSetupDetail1@1004 : Record 5310;
      OSynchDependency1@1005 : Record 5311;
      EntityRecRef@1009 : RecordRef;
      EntityRecRefDependent@1014 : RecordRef;
      CollectionRecRef@1008 : RecordRef;
      CollectionRecRef1@1015 : RecordRef;
      NullRecRef@1010 : RecordRef;
      RecID@1012 : RecordID;
    BEGIN
      IF NOT EntityRecRefIn.FIND('-') THEN
        EXIT;

      EVALUATE(RecID,FORMAT(EntityRecRefIn.RECORDID));
      EntityRecRef.OPEN(RecID.TABLENO,TRUE);
      REPEAT
        CopyRecordReference(EntityRecRefIn,EntityRecRef,FALSE);
      UNTIL EntityRecRefIn.NEXT = 0;

      OSynchEntity1.GET(SynchEntityCode);
      OSynchFilter1.RESET;
      OSynchFilter1.SETRANGE("Record GUID",OSynchEntity1."Record GUID");
      EntityRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter1,NullRecRef));
      IF NOT EntityRecRef.FIND('-') THEN
        EXIT;

      OSynchField1.RESET;
      OSynchField1.SETRANGE("Synch. Entity Code",SynchEntityCode);
      OSynchField1.SETFILTER("Read-Only Status",'<>%1',OSynchField1."Read-Only Status"::"Read-Only in Outlook");
      OSynchField1.SETFILTER("Outlook Property",'<>%1','');
      IF OSynchField1.ISEMPTY THEN
        EXIT;

      OSynchUserSetup1.GET(OSynchUserSetup."User ID",SynchEntityCode);
      OSynchUserSetup1.CALCFIELDS("No. of Elements");

      REPEAT
        GlobalRecordIDBuffer.SETRANGE("Search Record ID",UPPERCASE(FORMAT(EntityRecRef.RECORDID)));
        IF NOT GlobalRecordIDBuffer.FINDFIRST THEN BEGIN
          IF OSynchUserSetup1."No. of Elements" > 0 THEN BEGIN
            OSynchSetupDetail1.RESET;
            OSynchSetupDetail1.SETRANGE("User ID",OSynchUserSetup."User ID");
            OSynchSetupDetail1.SETRANGE("Synch. Entity Code",SynchEntityCode);
            IF OSynchSetupDetail1.FIND('-') THEN
              REPEAT
                OSynchEntityElement1.GET(OSynchSetupDetail1."Synch. Entity Code",OSynchSetupDetail1."Element No.");
                OSynchEntityElement1.CALCFIELDS("No. of Dependencies");
                IF OSynchEntityElement1."No. of Dependencies" > 0 THEN BEGIN
                  OSynchDependency1.RESET;
                  OSynchDependency1.SETRANGE("Synch. Entity Code",OSynchEntityElement1."Synch. Entity Code");
                  OSynchDependency1.SETRANGE("Element No.",OSynchEntityElement1."Element No.");

                  OSynchFilter1.RESET;
                  OSynchFilter1.SETRANGE("Record GUID",OSynchEntityElement1."Record GUID");

                  CollectionRecRef.OPEN(OSynchEntityElement1."Table No.");
                  CollectionRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter1,EntityRecRef));
                  IF CollectionRecRef.FIND('-') THEN
                    REPEAT
                      GlobalRecordIDBuffer.SETRANGE("Search Record ID",UPPERCASE(FORMAT(CollectionRecRef.RECORDID)));
                      IF NOT GlobalRecordIDBuffer.FINDFIRST THEN BEGIN
                        IF OSynchDependency1.FIND('-') THEN
                          REPEAT
                            CollectionRecRef1.OPEN(OSynchEntityElement1."Table No.",TRUE);
                            CopyRecordReference(CollectionRecRef,CollectionRecRef1,FALSE);

                            OSynchFilter1.RESET;
                            OSynchFilter1.SETRANGE("Record GUID",OSynchDependency1."Record GUID");

                            IF OSynchDependency1.Condition <> '' THEN BEGIN
                              OSynchFilter1.SETRANGE("Filter Type",OSynchFilter1."Filter Type"::Condition);
                              CollectionRecRef1.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter1,NullRecRef));
                            END;

                            IF CollectionRecRef1.FIND('-') THEN BEGIN
                              OSynchFilter1.SETRANGE("Filter Type",OSynchFilter1."Filter Type"::"Table Relation");
                              OSynchDependency1.CALCFIELDS("Depend. Synch. Entity Tab. No.");

                              EntityRecRefDependent.OPEN(OSynchDependency1."Depend. Synch. Entity Tab. No.");
                              EntityRecRefDependent.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter1,CollectionRecRef1));
                              IF EntityRecRefDependent.FIND('-') THEN
                                ProcessEntityRecords(EntityRecRefDependent,OSynchDependency1."Depend. Synch. Entity Code");
                              EntityRecRefDependent.CLOSE;
                            END;
                            CollectionRecRef1.CLOSE;
                          UNTIL OSynchDependency1.NEXT = 0;
                      END;
                    UNTIL CollectionRecRef.NEXT = 0;
                  CollectionRecRef.CLOSE;
                END;
              UNTIL OSynchSetupDetail1.NEXT = 0;
          END;

          InsertEntity(EntityRecRef,SynchEntityCode);
          EVALUATE(RecID,FORMAT(EntityRecRef.RECORDID));
          UpdateGlobalRecordIDBuffer(RecID,SynchEntityCode);
        END ELSE
          IF GlobalRecordIDBuffer."User ID" <> SynchEntityCode THEN
            ERROR(Text005,GlobalRecordIDBuffer."User ID",SynchEntityCode);
      UNTIL EntityRecRef.NEXT = 0;
      EntityRecRef.CLOSE;
    END;

    LOCAL PROCEDURE ProcessDeletedEntityRecords@6(VAR TempDeletedChangeLogEntry@1000 : Record 405);
    VAR
      RecID@1001 : RecordID;
    BEGIN
      IF NOT TempDeletedChangeLogEntry.FIND('-') THEN
        EXIT;

      OSynchField.RESET;
      OSynchField.SETRANGE("Synch. Entity Code",OSynchEntity.Code);
      OSynchField.SETFILTER("Read-Only Status",'<>%1',OSynchField."Read-Only Status"::"Read-Only in Outlook");
      OSynchField.SETFILTER("Outlook Property",'<>%1','');
      IF NOT OSynchField.FIND('-') THEN
        EXIT;

      OSynchFilter.RESET;
      OSynchFilter.SETFILTER("Record GUID",'%1|%2',OSynchEntity."Record GUID",OSynchUserSetup."Record GUID");

      REPEAT
        IF CheckDeletedRecFilterCondition(TempDeletedChangeLogEntry,OSynchFilter) THEN BEGIN
          ObtainRecordID(TempDeletedChangeLogEntry,RecID);
          GlobalRecordIDBuffer.SETRANGE("Search Record ID",UPPERCASE(FORMAT(RecID)));
          IF NOT GlobalRecordIDBuffer.FINDFIRST THEN BEGIN
            IF OSynchLink.GET(OSynchUserSetup."User ID",RecID) THEN BEGIN
              XMLWriter.WriteStartElement('DeletedOutlookItem');
              XMLWriter.WriteAttribute('SynchEntityCode',OSynchEntity.Code);
              XMLWriter.WriteAttribute('RecordID',FORMAT(RecID));
              XMLWriter.WriteAttribute(
                'LastModificationTime',
                OSynchTypeConversion.SetDateTimeFormat(
                  OSynchTypeConversion.LocalDT2UTC(TempDeletedChangeLogEntry."Date and Time")));
              WriteLinkedOutlookEntryID(OSynchUserSetup."User ID",RecID,XMLWriter);
              XMLWriter.WriteEndElement;

              UpdateGlobalRecordIDBuffer(RecID,OSynchEntity.Code);
            END;
          END ELSE
            IF GlobalRecordIDBuffer."User ID" <> OSynchEntity.Code THEN
              ERROR(Text005,GlobalRecordIDBuffer."User ID",OSynchEntity.Code);
        END;
      UNTIL TempDeletedChangeLogEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE ProcessEntityElements@17(VAR ChangedCollectionRecRef@1000 : RecordRef;SynchStartTime@1010 : DateTime);
    VAR
      OSynchFilter1@1011 : Record 5303;
      TempOSynchFilter@1005 : TEMPORARY Record 5303;
      OSynchUserSetup1@1004 : Record 5305;
      ChangedCollectionRecRef1@1003 : RecordRef;
      EntityRecRef@1001 : RecordRef;
      TempEntityRecRef@1007 : RecordRef;
      TempEntityRecRef1@1009 : RecordRef;
      NullRecRef@1002 : RecordRef;
      EntityRecID@1008 : RecordID;
      CollectionElementRecID@1006 : RecordID;
    BEGIN
      IF NOT ChangedCollectionRecRef.FIND('-') THEN
        EXIT;

      EntityRecRef.OPEN(OSynchEntity."Table No.");
      REPEAT
        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID",OSynchEntityElement."Record GUID");

        TempOSynchFilter.RESET;
        TempOSynchFilter.DELETEALL;

        ChangedCollectionRecRef1.OPEN(OSynchEntityElement."Table No.",TRUE);
        CopyRecordReference(ChangedCollectionRecRef,ChangedCollectionRecRef1,FALSE);

        OSynchFilter.SETFILTER(Type,'<>%1',OSynchFilter.Type::FIELD);
        IF OSynchFilter.FINDFIRST THEN
          ChangedCollectionRecRef1.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,NullRecRef));

        IF ChangedCollectionRecRef1.FIND('-') THEN BEGIN
          OSynchFilter.SETRANGE(Type,OSynchFilter.Type::FIELD);
          IF OSynchFilter.FINDFIRST THEN BEGIN
            OSynchSetupMgt.ComposeFilterRecords(OSynchFilter,TempOSynchFilter,ChangedCollectionRecRef1,TempOSynchFilter.Type::CONST);

            EntityRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(TempOSynchFilter,NullRecRef));
            IF EntityRecRef.FIND('-') THEN BEGIN
              TempEntityRecRef.OPEN(OSynchEntity."Table No.",TRUE);
              REPEAT
                CopyRecordReference(EntityRecRef,TempEntityRecRef,FALSE);
              UNTIL EntityRecRef.NEXT = 0;

              OSynchUserSetup1.GET(OSynchUserSetup."User ID",OSynchEntityElement."Synch. Entity Code");
              OSynchFilter1.RESET;
              OSynchFilter1.SETRANGE("Record GUID",OSynchUserSetup1."Record GUID");
              IF OSynchFilter1.FINDFIRST THEN
                TempEntityRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter1,NullRecRef));

              IF TempEntityRecRef.FIND('-') THEN
                REPEAT
                  EVALUATE(EntityRecID,FORMAT(TempEntityRecRef.RECORDID));
                  EVALUATE(CollectionElementRecID,FORMAT(ChangedCollectionRecRef1.RECORDID));
                  IF CheckCollectionTimeCondition(EntityRecID,CollectionElementRecID,SynchStartTime) THEN BEGIN
                    TempEntityRecRef1.OPEN(OSynchEntity."Table No.",TRUE);
                    CopyRecordReference(TempEntityRecRef,TempEntityRecRef1,FALSE);
                    ProcessEntityRecords(TempEntityRecRef1,OSynchEntityElement."Synch. Entity Code");
                    TempEntityRecRef1.CLOSE;
                  END;
                UNTIL TempEntityRecRef.NEXT = 0;

              TempEntityRecRef.CLOSE;
            END;
          END;
        END;
        ChangedCollectionRecRef1.CLOSE;
      UNTIL ChangedCollectionRecRef.NEXT = 0;
      EntityRecRef.CLOSE;
    END;

    LOCAL PROCEDURE ProcessDeletedEntityElements@84(VAR TempDeletedChangeLogEntry@1000 : Record 405;SynchStartTime@1008 : DateTime);
    VAR
      ChangeLogEntry@1002 : Record 405;
      OSynchFilter1@1006 : Record 5303;
      TempOSynchFilter@1005 : TEMPORARY Record 5303;
      EntityRecRef@1001 : RecordRef;
      TempEntityRecRef@1003 : RecordRef;
      NullRecRef@1007 : RecordRef;
      RecID@1004 : RecordID;
    BEGIN
      IF NOT TempDeletedChangeLogEntry.FIND('-') THEN
        EXIT;

      EntityRecRef.OPEN(OSynchEntity."Table No.");

      OSynchFilter1.RESET;
      OSynchFilter1.SETRANGE("Record GUID",OSynchEntityElement."Record GUID");
      IF NOT OSynchFilter1.FINDFIRST THEN
        EXIT;

      ChangeLogEntry.SETCURRENTKEY("Table No.","Primary Key Field 1 Value");
      ChangeLogEntry.SETRANGE("Table No.",TempDeletedChangeLogEntry."Table No.");
      ChangeLogEntry.SETFILTER("Date and Time",'>=%1',OSynchUserSetup."Last Synch. Time");
      ChangeLogEntry.SETRANGE("Type of Change",ChangeLogEntry."Type of Change"::Deletion);

      REPEAT
        OSynchFilter1.SETFILTER(Type,'<>%1',OSynchFilter1.Type::FIELD);

        IF CheckDeletedRecFilterCondition(TempDeletedChangeLogEntry,OSynchFilter1) THEN BEGIN
          TempOSynchFilter.RESET;
          TempOSynchFilter.DELETEALL;
          OSynchFilter1.SETRANGE(Type,OSynchFilter1.Type::FIELD);

          IF OSynchFilter1.FIND('-') THEN
            REPEAT
              ChangeLogEntry.SETRANGE("Primary Key",TempDeletedChangeLogEntry."Primary Key");
              ChangeLogEntry.SETRANGE("Primary Key Field 1 Value",TempDeletedChangeLogEntry."Primary Key Field 1 Value");
              ChangeLogEntry.SETRANGE("Field No.",OSynchFilter1."Field No.");

              IF ChangeLogEntry.FINDLAST THEN
                OSynchSetupMgt.CreateFilterCondition(
                  TempOSynchFilter,
                  OSynchFilter1."Master Table No.",
                  OSynchFilter1."Master Table Field No.",
                  TempOSynchFilter.Type::CONST,
                  ChangeLogEntry."Old Value");
            UNTIL OSynchFilter1.NEXT = 0;

          EntityRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(TempOSynchFilter,NullRecRef));
          IF EntityRecRef.FIND('-') THEN
            REPEAT
              EVALUATE(RecID,FORMAT(EntityRecRef.RECORDID));
              IF OSynchLink.GET(OSynchUserSetup."User ID",RecID) THEN BEGIN
                TempEntityRecRef.OPEN(OSynchEntity."Table No.",TRUE);
                CopyRecordReference(EntityRecRef,TempEntityRecRef,FALSE);
                IF OSynchLink."Synchronization Date" < TempDeletedChangeLogEntry."Date and Time" THEN
                  ProcessEntityRecords(TempEntityRecRef,OSynchEntityElement."Synch. Entity Code")
                ELSE
                  IF SynchStartTime < TempDeletedChangeLogEntry."Date and Time" THEN
                    ProcessEntityRecords(TempEntityRecRef,OSynchEntityElement."Synch. Entity Code");
                TempEntityRecRef.CLOSE;
              END;
            UNTIL EntityRecRef.NEXT = 0;
        END;
      UNTIL TempDeletedChangeLogEntry.NEXT = 0;
      EntityRecRef.CLOSE;
    END;

    LOCAL PROCEDURE ProcessChangeLog@10(TableID@1000 : Integer;LastSynchTime@1001 : DateTime;VAR TempRecRef@1006 : RecordRef;VAR DeletedChangeLogEntry@1004 : Record 405);
    VAR
      ChangeLogEntry@1002 : Record 405;
      InsModChangeLogEntry@1005 : TEMPORARY Record 405;
    BEGIN
      ChangeLogEntry.SETCURRENTKEY("Table No.","Date and Time");
      ChangeLogEntry.SETRANGE("Table No.",TableID);
      ChangeLogEntry.SETFILTER("Date and Time",'>=%1',LastSynchTime);

      RemoveChangeLogDuplicates(ChangeLogEntry,InsModChangeLogEntry);

      InsModChangeLogEntry.SETRANGE("Type of Change",InsModChangeLogEntry."Type of Change"::Deletion);
      IF InsModChangeLogEntry.FIND('-') THEN
        REPEAT
          DeletedChangeLogEntry.INIT;
          DeletedChangeLogEntry := InsModChangeLogEntry;
          DeletedChangeLogEntry.INSERT;
        UNTIL InsModChangeLogEntry.NEXT = 0;

      InsModChangeLogEntry.DELETEALL;
      InsModChangeLogEntry.RESET;

      FindMasterRecByChangeLogEntry(InsModChangeLogEntry,TempRecRef);
    END;

    LOCAL PROCEDURE ProcessDependentEntity@3(OSynchEntityCode@1000 : Code[10];VAR I@1004 : Integer;VAR TempOSynchEntityUnsorted@1002 : Record 5300;VAR TempOSynchLookupName@1003 : Record 5306);
    VAR
      OSynchDependency@1001 : Record 5311;
    BEGIN
      OSynchDependency.SETRANGE("Synch. Entity Code",OSynchEntityCode);

      IF OSynchDependency.FIND('-') THEN
        REPEAT
          IF NOT (TempOSynchEntityUnsorted.GET(OSynchDependency."Depend. Synch. Entity Code") AND
                  TempOSynchEntityUnsorted.MARK)
          THEN
            ProcessDependentEntity(
              OSynchDependency."Depend. Synch. Entity Code",
              I,
              TempOSynchEntityUnsorted,
              TempOSynchLookupName);
        UNTIL OSynchDependency.NEXT = 0;

      IF TempOSynchEntityUnsorted.GET(OSynchEntityCode) THEN
        IF NOT TempOSynchEntityUnsorted.MARK THEN BEGIN
          TempOSynchLookupName.INIT;
          TempOSynchLookupName."Entry No." := I;
          TempOSynchLookupName.Name := TempOSynchEntityUnsorted.Code;
          TempOSynchLookupName.INSERT;
          TempOSynchEntityUnsorted.MARK(TRUE);
          I := I + 1;
        END;
    END;

    [Internal]
    PROCEDURE ProcessRenamedRecords@16(UserID@1010 : Code[50]);
    VAR
      ChangeLogEntry@1001 : Record 405;
      TempChangeLogEntry@1002 : TEMPORARY Record 405;
      TempChangeLogEntry1@1004 : TEMPORARY Record 405;
      OSynchLink@1000 : Record 5302;
      TempRecRef@1003 : RecordRef;
      TempMasterRecRef@1006 : RecordRef;
      EntityKeyRef@1005 : KeyRef;
      EntityFieldRef@1012 : FieldRef;
      RecID@1007 : RecordID;
      Counter@1008 : Integer;
      KeyString@1011 : Text[250];
      IsRenamed@1009 : Boolean;
    BEGIN
      IF NOT SortedEntitiesBuffer.FIND('-') THEN
        EXIT;

      REPEAT
        OSynchEntity.GET(SortedEntitiesBuffer.Name);
        OSynchUserSetup.GET(UserID,SortedEntitiesBuffer.Name);

        TempRecRef.OPEN(OSynchEntity."Table No.",TRUE);
        EntityKeyRef := TempRecRef.KEYINDEX(1);
        FOR Counter := 1 TO EntityKeyRef.FIELDCOUNT DO BEGIN
          IF KeyString <> '' THEN
            KeyString := KeyString + '|';
          EntityFieldRef := EntityKeyRef.FIELDINDEX(Counter);
          KeyString := KeyString + FORMAT(EntityFieldRef.NUMBER);
        END;
        TempRecRef.CLOSE;

        ChangeLogEntry.SETCURRENTKEY("Table No.","Date and Time");
        ChangeLogEntry.SETRANGE("Table No.",OSynchEntity."Table No.");
        ChangeLogEntry.SETFILTER("Date and Time",'>=%1',OSynchUserSetup."Last Synch. Time");
        ChangeLogEntry.SETRANGE("Type of Change",ChangeLogEntry."Type of Change"::Modification);
        ChangeLogEntry.SETFILTER("Field No.",KeyString);
        IF ChangeLogEntry.FIND('-') THEN BEGIN
          TempChangeLogEntry.RESET;
          TempChangeLogEntry.DELETEALL;
          TempChangeLogEntry1.RESET;
          TempChangeLogEntry1.DELETEALL;

          REPEAT
            TempChangeLogEntry.INIT;
            TempChangeLogEntry := ChangeLogEntry;
            TempChangeLogEntry.INSERT;
          UNTIL ChangeLogEntry.NEXT = 0;

          RemoveChangeLogDuplicates(TempChangeLogEntry,TempChangeLogEntry1);

          IF TempChangeLogEntry1.FIND('-') THEN
            REPEAT
              TempChangeLogEntry.RESET;
              TempChangeLogEntry.SETRANGE("Primary Key Field 1 Value",TempChangeLogEntry1."Primary Key Field 1 Value");
              IF TempChangeLogEntry1."Primary Key Field 2 No." <> 0 THEN
                TempChangeLogEntry.SETRANGE("Primary Key Field 2 Value",TempChangeLogEntry1."Primary Key Field 2 Value");
              IF TempChangeLogEntry1."Primary Key Field 3 No." <> 0 THEN
                TempChangeLogEntry.SETRANGE("Primary Key Field 3 Value",TempChangeLogEntry1."Primary Key Field 3 Value");

              ObtainRenamedRecordID(
                TempChangeLogEntry,
                TempChangeLogEntry1."Primary Key Field 1 No.",
                TempChangeLogEntry1."Primary Key Field 2 No.",
                TempChangeLogEntry1."Primary Key Field 3 No.",
                RecID);

              IF RecID.TABLENO <> 0 THEN
                IF OSynchLink.GET(OSynchUserSetup."User ID",RecID) THEN BEGIN
                  TempMasterRecRef.OPEN(TempChangeLogEntry1."Table No.",TRUE);
                  FindMasterRecByChangeLogEntry(TempChangeLogEntry1,TempMasterRecRef);

                  IF FORMAT(RecID) <> FORMAT(TempMasterRecRef.RECORDID) THEN BEGIN
                    EVALUATE(RecID,FORMAT(TempMasterRecRef.RECORDID));
                    OSynchLink.RENAME(OSynchUserSetup."User ID",RecID);
                    IsRenamed := TRUE;
                  END;

                  TempMasterRecRef.CLOSE;
                END;
            UNTIL TempChangeLogEntry1.NEXT = 0;
        END;
      UNTIL SortedEntitiesBuffer.NEXT = 0;

      IF IsRenamed THEN
        COMMIT;
    END;

    [Internal]
    PROCEDURE ProcessDeletedRecords@21(UserID@1003 : Code[50]);
    VAR
      ChangeLogEntry@1001 : Record 405;
      TempChangeLogEntry@1002 : TEMPORARY Record 405;
      OSynchLink@1000 : Record 5302;
      RecID@1007 : RecordID;
    BEGIN
      IF NOT SortedEntitiesBuffer.FIND('-') THEN
        EXIT;

      REPEAT
        OSynchEntity.GET(SortedEntitiesBuffer.Name);
        OSynchUserSetup.GET(UserID,SortedEntitiesBuffer.Name);

        ChangeLogEntry.SETCURRENTKEY("Table No.","Date and Time");
        ChangeLogEntry.SETRANGE("Table No.",OSynchEntity."Table No.");
        ChangeLogEntry.SETFILTER("Date and Time",'>=%1',OSynchUserSetup."Last Synch. Time");
        ChangeLogEntry.SETRANGE("Type of Change",ChangeLogEntry."Type of Change"::Deletion);
        IF NOT ChangeLogEntry.ISEMPTY THEN BEGIN
          TempChangeLogEntry.RESET;
          TempChangeLogEntry.DELETEALL;

          RemoveChangeLogDuplicates(ChangeLogEntry,TempChangeLogEntry);

          IF TempChangeLogEntry.FIND('-') THEN
            REPEAT
              ObtainRecordID(TempChangeLogEntry,RecID);
              IF OSynchLink.GET(OSynchUserSetup."User ID",RecID) THEN
                OSynchLink.DELETE;
            UNTIL TempChangeLogEntry.NEXT = 0;
        END;
      UNTIL SortedEntitiesBuffer.NEXT = 0;

      OSynchLink.RESET;
      OSynchLink.SETRANGE("User ID",OSynchUserSetup."User ID");
      OSynchLink.SETRANGE("Outlook Entry ID Hash",'');
      OSynchLink.DELETEALL;
    END;

    LOCAL PROCEDURE InsertEntity@50(EntityRecRef@1000 : RecordRef;SynchEntityCode@1001 : Code[10]);
    VAR
      RecID@1002 : RecordID;
      LastModificationTime@1003 : DateTime;
    BEGIN
      EVALUATE(RecID,FORMAT(EntityRecRef.RECORDID));
      LastModificationTime := OSynchOutlookMgt.GetLastModificationTime(RecID);

      XMLWriter.WriteStartElement('OutlookItem');
      XMLWriter.WriteAttribute('SynchEntityCode',SynchEntityCode);
      XMLWriter.WriteAttribute('RecordID',FORMAT(RecID));
      XMLWriter.WriteAttribute(
        'LastModificationTime',
        OSynchTypeConversion.SetDateTimeFormat(OSynchTypeConversion.LocalDT2UTC(LastModificationTime)));
      WriteLinkedOutlookEntryID(OSynchUserSetup."User ID",RecID,XMLWriter);

      OSynchField.RESET;
      OSynchField.SETRANGE("Synch. Entity Code",SynchEntityCode);
      OSynchField.SETFILTER("Read-Only Status",'<>%1',OSynchField."Read-Only Status"::"Read-Only in Outlook");
      OSynchField.SETFILTER("Outlook Property",'<>%1','');
      OSynchField.SETRANGE("Element No.",0);

      IF OSynchField.FIND('-') THEN
        InsertFields(EntityRecRef,FALSE);

      OSynchUserSetup.CALCFIELDS("No. of Elements");
      IF OSynchUserSetup."No. of Elements" > 0 THEN
        InsertCollections(EntityRecRef,SynchEntityCode);

      XMLWriter.WriteEndElement;
    END;

    LOCAL PROCEDURE InsertCollections@51(EntityRecRef@1001 : RecordRef;SynchEntityCode@1002 : Code[10]);
    VAR
      OSynchEntityElement1@1003 : Record 5301;
      MasterRecRef@1000 : RecordRef;
      EntityRecID@1004 : RecordID;
      DependencyFound@1005 : Boolean;
    BEGIN
      OSynchSetupDetail.RESET;
      OSynchSetupDetail.SETRANGE("User ID",OSynchUserSetup."User ID");
      OSynchSetupDetail.SETRANGE("Synch. Entity Code",SynchEntityCode);

      IF OSynchSetupDetail.FIND('-') THEN
        REPEAT
          OSynchEntityElement1.GET(OSynchSetupDetail."Synch. Entity Code",OSynchSetupDetail."Element No.");
          XMLWriter.WriteStartElement('Collection');
          XMLWriter.WriteAttribute('Name',OSynchEntityElement1."Outlook Collection");

          OSynchFilter.RESET;
          OSynchFilter.SETRANGE("Record GUID",OSynchEntityElement1."Record GUID");
          MasterRecRef.OPEN(OSynchEntityElement1."Table No.");
          MasterRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,EntityRecRef));
          IF MasterRecRef.FIND('-') THEN
            REPEAT
              CLEAR(EntityRecID);
              DependencyFound := FALSE;

              OSynchEntityElement1.CALCFIELDS("No. of Dependencies");
              IF OSynchEntityElement1."No. of Dependencies" = 0 THEN BEGIN
                XMLWriter.WriteStartElement('Element');
                XMLWriter.WriteAttribute('RecordID',FORMAT(MasterRecRef.RECORDID));
                DependencyFound := TRUE;
              END ELSE BEGIN
                DependencyFound := FindDependentRecord(OSynchEntityElement1,MasterRecRef,EntityRecID);
                IF DependencyFound THEN BEGIN
                  XMLWriter.WriteStartElement('Element');
                  XMLWriter.WriteAttribute('RecordID',FORMAT(EntityRecID));
                  WriteLinkedOutlookEntryID(OSynchUserSetup."User ID",EntityRecID,XMLWriter);
                END;
              END;

              IF DependencyFound THEN BEGIN
                OSynchField.RESET;
                OSynchField.SETRANGE("Synch. Entity Code",SynchEntityCode);
                OSynchField.SETFILTER("Read-Only Status",'<>%1',OSynchField."Read-Only Status"::"Read-Only in Outlook");
                OSynchField.SETFILTER("Outlook Property",'<>%1','');
                OSynchField.SETRANGE("Element No.",OSynchEntityElement1."Element No.");
                OSynchField.SETRANGE("Search Field",FALSE);
                IF OSynchField.FIND('-') THEN
                  InsertFields(MasterRecRef,FALSE);

                OSynchField.SETRANGE("Read-Only Status");
                OSynchField.SETRANGE("Search Field",TRUE);
                IF OSynchField.FIND('-') THEN
                  InsertFields(MasterRecRef,TRUE);

                XMLWriter.WriteEndElement;
              END;
            UNTIL MasterRecRef.NEXT = 0;
          XMLWriter.WriteEndElement;
          MasterRecRef.CLOSE;
        UNTIL OSynchSetupDetail.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertFields@9(SynchRecRef@1000 : RecordRef;SearchFields@1016 : Boolean);
    VAR
      OSynchField1@1015 : Record 5304;
      TempOSynchField@1009 : TEMPORARY Record 5304;
      OSynchOptionCorrel@1007 : Record 5307;
      TempBLOBStore@1004 : TEMPORARY Record 2000000001;
      RelatedRecRef@1002 : RecordRef;
      DateTimeRecRef@1014 : RecordRef;
      FieldRef@1001 : FieldRef;
      DateTimeFieldRef@1013 : FieldRef;
      InStrm@1005 : InStream;
      TempDateTime@1010 : DateTime;
      TempDate@1011 : Date;
      TempTime@1012 : Time;
      OptionId@1006 : Integer;
      FieldValueDefined@1008 : Boolean;
    BEGIN
      REPEAT
        IF NOT SearchFields THEN BEGIN
          TempOSynchField.RESET;
          TempOSynchField.SETRANGE("Synch. Entity Code",OSynchField."Synch. Entity Code");
          TempOSynchField.SETRANGE("Element No.",OSynchField."Element No.");
          TempOSynchField.SETRANGE("Outlook Property",OSynchField."Outlook Property");
          IF NOT TempOSynchField.FIND('-') THEN BEGIN
            TempOSynchField.INIT;
            TempOSynchField := OSynchField;
            TempOSynchField.INSERT;
          END;
        END ELSE BEGIN
          TempOSynchField.INIT;
          TempOSynchField := OSynchField;
          TempOSynchField.INSERT;
        END;
      UNTIL OSynchField.NEXT = 0;

      TempOSynchField.RESET;
      IF TempOSynchField.FIND('-') THEN
        REPEAT
          IF CheckSynchFieldCondition(SynchRecRef,TempOSynchField) THEN BEGIN
            FieldValueDefined := TRUE;
            IF TempOSynchField."Table No." <> 0 THEN BEGIN
              OSynchFilter.RESET;
              OSynchFilter.SETRANGE("Record GUID",TempOSynchField."Record GUID");
              OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::"Table Relation");

              RelatedRecRef.OPEN(TempOSynchField."Table No.");
              RelatedRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,SynchRecRef));
              FieldValueDefined := RelatedRecRef.FINDFIRST;
              IF FieldValueDefined THEN
                FieldRef := RelatedRecRef.FIELD(TempOSynchField."Field No.");
            END ELSE
              FieldRef := SynchRecRef.FIELD(TempOSynchField."Field No.");

            XMLWriter.WriteStartElement('Field');
            XMLWriter.WriteAttribute('Name',TempOSynchField."Outlook Property");

            IF FieldValueDefined THEN
              CASE FORMAT(FieldRef.TYPE) OF
                'Time':
                  BEGIN
                    TempDate := 01014501D;
                    IF NOT EVALUATE(TempTime,FORMAT(FieldRef.VALUE)) THEN
                      TempTime := 000000T;
                    OSynchField1.RESET;
                    OSynchField1.SETRANGE("Synch. Entity Code",TempOSynchField."Synch. Entity Code");
                    OSynchField1.SETRANGE("Element No.",TempOSynchField."Element No.");
                    OSynchField1.SETFILTER("Line No.",'<>%1',TempOSynchField."Line No.");
                    OSynchField1.SETRANGE("Outlook Property",TempOSynchField."Outlook Property");
                    IF OSynchField1.FIND('-') THEN
                      REPEAT
                        GetDateTimeFieldRef(OSynchField1,TempOSynchField,SynchRecRef,RelatedRecRef,DateTimeFieldRef);
                        IF (FORMAT(DateTimeFieldRef.TYPE) = 'Date') AND (FORMAT(DateTimeFieldRef.VALUE) <> '') THEN
                          IF EVALUATE(TempDate,FORMAT(DateTimeFieldRef.VALUE)) THEN;
                        DateTimeRecRef.CLOSE;
                      UNTIL OSynchField1.NEXT = 0;

                    IF OSynchTypeConversion.RunningUTC THEN
                      TempDateTime := OSynchTypeConversion.LocalDT2UTC(CREATEDATETIME(TempDate,TempTime))
                    ELSE
                      TempDateTime := CREATEDATETIME(TempDate,TempTime);
                    IF TempDate = 01014501D THEN
                      TempDateTime := CREATEDATETIME(TempDate,DT2TIME(TempDateTime));
                    XMLWriter.WriteElementTextContent(OSynchTypeConversion.SetDateTimeFormat(TempDateTime));
                  END;
                'Date':
                  BEGIN
                    TempTime := 000000T;
                    IF NOT EVALUATE(TempDate,FORMAT(FieldRef.VALUE)) OR (TempDate = 0D) THEN
                      TempDate := 01014501D;
                    OSynchField1.RESET;
                    OSynchField1.SETRANGE("Synch. Entity Code",TempOSynchField."Synch. Entity Code");
                    OSynchField1.SETRANGE("Element No.",TempOSynchField."Element No.");
                    OSynchField1.SETFILTER("Line No.",'<>%1',TempOSynchField."Line No.");
                    OSynchField1.SETRANGE("Outlook Property",TempOSynchField."Outlook Property");
                    IF OSynchField1.FIND('-') THEN
                      REPEAT
                        GetDateTimeFieldRef(OSynchField1,TempOSynchField,SynchRecRef,RelatedRecRef,DateTimeFieldRef);
                        IF (FORMAT(DateTimeFieldRef.TYPE) = 'Time') AND (FORMAT(DateTimeFieldRef.VALUE) <> '') THEN
                          IF EVALUATE(TempTime,FORMAT(DateTimeFieldRef.VALUE)) THEN;
                        DateTimeRecRef.CLOSE;
                      UNTIL OSynchField1.NEXT = 0;

                    IF OSynchTypeConversion.RunningUTC THEN
                      TempDateTime := OSynchTypeConversion.LocalDT2UTC(CREATEDATETIME(TempDate,TempTime))
                    ELSE
                      TempDateTime := CREATEDATETIME(TempDate,TempTime);
                    IF TempDate = 01014501D THEN
                      TempDateTime := CREATEDATETIME(TempDate,DT2TIME(TempDateTime));
                    XMLWriter.WriteElementTextContent(OSynchTypeConversion.SetDateTimeFormat(TempDateTime));
                  END;
                'BLOB':
                  BEGIN
                    CLEAR(InStrm);
                    FieldRef.CALCFIELD;
                    TempBLOBStore."BLOB Reference" := FieldRef.VALUE;
                    TempBLOBStore.CALCFIELDS("BLOB Reference");
                    IF TempBLOBStore."BLOB Reference".HASVALUE THEN BEGIN
                      TempBLOBStore."BLOB Reference".CREATEINSTREAM(InStrm);
                      XMLWriter.WriteStreamData(InStrm);
                    END;
                  END;
                'Option':
                  BEGIN
                    OSynchOptionCorrel.RESET;
                    OSynchOptionCorrel.SETRANGE("Synch. Entity Code",TempOSynchField."Synch. Entity Code");
                    OSynchOptionCorrel.SETRANGE("Element No.",TempOSynchField."Element No.");
                    OSynchOptionCorrel.SETRANGE("Field Line No.",TempOSynchField."Line No.");
                    OptionId := OSynchTypeConversion.TextToOptionValue(FORMAT(FieldRef.VALUE),FieldRef.OPTIONCAPTION);
                    OSynchOptionCorrel.SETRANGE("Option No.",OptionId);
                    IF OSynchOptionCorrel.FINDFIRST THEN
                      XMLWriter.WriteElementTextContent(FORMAT(OSynchOptionCorrel."Enumeration No."))
                    ELSE
                      IF NOT OSynchSetupMgt.CheckOEnumeration(TempOSynchField) THEN
                        XMLWriter.WriteElementTextContent(OSynchTypeConversion.PrepareFieldValueForXML(FieldRef))
                      ELSE BEGIN
                        IF TempOSynchField."Element No." = 0 THEN
                          ERROR(Text003,FieldRef.CAPTION,TempOSynchField."Synch. Entity Code");

                        ERROR(Text009,FieldRef.CAPTION,TempOSynchField."Outlook Object",TempOSynchField."Synch. Entity Code");
                      END;
                  END;
                ELSE
                  XMLWriter.WriteElementTextContent(OSynchTypeConversion.PrepareFieldValueForXML(FieldRef));
              END;

            XMLWriter.WriteEndElement;
            RelatedRecRef.CLOSE;
          END;
        UNTIL TempOSynchField.NEXT = 0;
    END;

    LOCAL PROCEDURE FindDependentRecord@31(OSynchEntityElement1@1002 : Record 5301;CollectionElementRecRef@1000 : RecordRef;VAR MasterRecID@1001 : RecordID) : Boolean;
    VAR
      OSynchEntity1@1010 : Record 5300;
      OSynchFilter1@1006 : Record 5303;
      OSynchDependency@1003 : Record 5311;
      EntityRecRef@1004 : RecordRef;
      TempEntityRecRef@1009 : RecordRef;
      TempCollectionElementRecRef@1005 : RecordRef;
      NullRecRef@1007 : RecordRef;
    BEGIN
      TempCollectionElementRecRef.OPEN(OSynchEntityElement1."Table No.",TRUE);
      CopyRecordReference(CollectionElementRecRef,TempCollectionElementRecRef,FALSE);

      OSynchDependency.RESET;
      OSynchDependency.SETRANGE("Synch. Entity Code",OSynchEntityElement1."Synch. Entity Code");
      OSynchDependency.SETRANGE("Element No.",OSynchEntityElement1."Element No.");
      IF OSynchDependency.FIND('-') THEN
        REPEAT
          TempCollectionElementRecRef.RESET;
          OSynchFilter1.RESET;
          OSynchFilter1.SETRANGE("Record GUID",OSynchDependency."Record GUID");
          OSynchFilter1.SETRANGE("Filter Type",OSynchFilter1."Filter Type"::Condition);
          IF OSynchFilter1.FINDFIRST THEN
            TempCollectionElementRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter1,NullRecRef));

          IF TempCollectionElementRecRef.FIND('-') THEN BEGIN
            OSynchDependency.CALCFIELDS("Depend. Synch. Entity Tab. No.");
            OSynchFilter1.SETRANGE("Filter Type",OSynchFilter1."Filter Type"::"Table Relation");
            IF OSynchFilter1.FINDFIRST THEN BEGIN
              EntityRecRef.OPEN(OSynchDependency."Depend. Synch. Entity Tab. No.");
              EntityRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter1,TempCollectionElementRecRef));
              IF EntityRecRef.FIND('-') THEN BEGIN
                TempEntityRecRef.OPEN(OSynchDependency."Depend. Synch. Entity Tab. No.",TRUE);
                CopyRecordReference(EntityRecRef,TempEntityRecRef,FALSE);
                OSynchEntity1.GET(OSynchDependency."Depend. Synch. Entity Code");

                OSynchFilter1.RESET;
                OSynchFilter1.SETRANGE("Record GUID",OSynchEntity1."Record GUID");
                TempEntityRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter1,NullRecRef));
                IF TempEntityRecRef.FIND('-') THEN BEGIN
                  EVALUATE(MasterRecID,FORMAT(TempEntityRecRef.RECORDID));
                  EXIT(TRUE);
                END;
                TempEntityRecRef.CLOSE;
              END;
              EntityRecRef.CLOSE;
            END;
          END;
        UNTIL OSynchDependency.NEXT = 0;
      TempCollectionElementRecRef.CLOSE;
    END;

    [Internal]
    PROCEDURE CheckSynchFieldCondition@12(SynchRecRef@1000 : RecordRef;VAR OSynchField1@1005 : Record 5304) : Boolean;
    VAR
      OSynchFilter1@1006 : Record 5303;
      SynchRecRef1@1002 : RecordRef;
      NullRecRef@1001 : RecordRef;
      RecID@1003 : RecordID;
    BEGIN
      IF OSynchField1.Condition = '' THEN
        EXIT(TRUE);

      EVALUATE(RecID,FORMAT(SynchRecRef.RECORDID));
      SynchRecRef1.OPEN(RecID.TABLENO,TRUE);
      CopyRecordReference(SynchRecRef,SynchRecRef1,FALSE);

      OSynchFilter1.RESET;
      OSynchFilter1.SETRANGE("Record GUID",OSynchField1."Record GUID");
      OSynchFilter1.SETRANGE("Filter Type",OSynchFilter1."Filter Type"::Condition);
      SynchRecRef1.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter1,NullRecRef));

      EXIT(NOT SynchRecRef1.ISEMPTY);
    END;

    [Internal]
    PROCEDURE CheckDeletedRecFilterCondition@20(VAR TempDeletedChangeLogEntry@1000 : Record 405;VAR OSynchFilterIn@1003 : Record 5303) IsMatched : Boolean;
    VAR
      ChangeLogEntry@1002 : Record 405;
      TempRecRef@1004 : RecordRef;
      NullRecRef@1006 : RecordRef;
      FieldRef@1005 : FieldRef;
    BEGIN
      IsMatched := TRUE;
      IF NOT OSynchFilterIn.FINDFIRST THEN
        EXIT;

      ChangeLogEntry.SETCURRENTKEY("Table No.","Primary Key Field 1 Value");
      ChangeLogEntry.SETRANGE("Table No.",TempDeletedChangeLogEntry."Table No.");
      ChangeLogEntry.SETRANGE("Primary Key Field 1 Value",TempDeletedChangeLogEntry."Primary Key Field 1 Value");
      ChangeLogEntry.SETFILTER("Date and Time",'>=%1',OSynchUserSetup."Last Synch. Time");
      ChangeLogEntry.SETRANGE("Type of Change",ChangeLogEntry."Type of Change"::Deletion);
      ChangeLogEntry.SETRANGE("Primary Key",TempDeletedChangeLogEntry."Primary Key");

      TempRecRef.OPEN(TempDeletedChangeLogEntry."Table No.",TRUE);
      TempRecRef.INIT;

      IF ChangeLogEntry.FINDSET THEN
        REPEAT
          FieldRef := TempRecRef.FIELD(ChangeLogEntry."Field No.");
          IF NOT
             OSynchTypeConversion.EvaluateTextToFieldRef(
               OSynchTypeConversion.SetValueFormat(ChangeLogEntry."Old Value",FieldRef),
               FieldRef,
               FALSE)
          THEN
            ERROR(Text010,OSynchEntity.Code,PRODUCTNAME.FULL);
        UNTIL ChangeLogEntry.NEXT = 0;

      TempRecRef.INSERT;

      TempRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilterIn,NullRecRef));
      IsMatched := TempRecRef.FIND('-');
      TempRecRef.CLOSE;
    END;

    [External]
    PROCEDURE CheckTimeCondition@13(RecID@1000 : RecordID;SynchStartTime@1001 : DateTime) : Boolean;
    VAR
      ChangeLogEntry@1002 : Record 405;
    BEGIN
      ChangeLogEntry.SETCURRENTKEY("Table No.","Primary Key Field 1 Value");
      OSynchProcessLine.FilterChangeLog(RecID,ChangeLogEntry);
      IF ChangeLogEntry.FINDLAST THEN;

      OSynchLink.RESET;
      IF OSynchLink.GET(OSynchUserSetup."User ID",RecID) THEN BEGIN
        IF (OSynchLink."Synchronization Date" >= ChangeLogEntry."Date and Time") AND
           (OSynchLink."Synchronization Date" <= SynchStartTime)
        THEN
          EXIT(FALSE);
        // Item was deleted during this synchronization so we should not return it.
        IF (OSynchLink."Synchronization Date" >= SynchStartTime) AND (OSynchLink."Outlook Entry ID Hash" = '') THEN
          EXIT(FALSE);
      END;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CheckCollectionTimeCondition@14(EntityRecID@1000 : RecordID;CollectionElementRecID@1001 : RecordID;SynchStartTime@1003 : DateTime) : Boolean;
    VAR
      ChangeLogEntry@1002 : Record 405;
      CollectionElementLMDT@1006 : DateTime;
    BEGIN
      IF CheckTimeCondition(EntityRecID,SynchStartTime) THEN
        EXIT(TRUE);

      ChangeLogEntry.RESET;
      ChangeLogEntry.SETCURRENTKEY("Table No.","Primary Key Field 1 Value");
      OSynchProcessLine.FilterChangeLog(CollectionElementRecID,ChangeLogEntry);
      IF ChangeLogEntry.FINDLAST THEN
        CollectionElementLMDT := ChangeLogEntry."Date and Time";

      IF OSynchLink.GET(OSynchUserSetup."User ID",EntityRecID) THEN
        IF OSynchLink."Synchronization Date" < CollectionElementLMDT THEN
          EXIT(TRUE)
        ELSE
          IF SynchStartTime < CollectionElementLMDT THEN
            EXIT(TRUE);
    END;

    LOCAL PROCEDURE SortEntitiesForXMLOutput@1(VAR TempOSynchEntityUnsorted@1000 : Record 5300;VAR TempOSynchLookupName@1001 : Record 5306);
    VAR
      OSynchDependency@1004 : Record 5311;
      LastIndex@1005 : Integer;
    BEGIN
      TempOSynchLookupName.DELETEALL;

      IF TempOSynchEntityUnsorted.FIND('-') THEN BEGIN
        OSynchDependency.RESET;
        IF NOT OSynchDependency.ISEMPTY THEN
          REPEAT
            ProcessDependentEntity(
              TempOSynchEntityUnsorted.Code,
              LastIndex,
              TempOSynchEntityUnsorted,
              TempOSynchLookupName);
          UNTIL TempOSynchEntityUnsorted.NEXT = 0;

        IF TempOSynchEntityUnsorted.FIND('-') THEN
          REPEAT
            IF NOT TempOSynchEntityUnsorted.MARK THEN BEGIN
              TempOSynchLookupName.INIT;
              TempOSynchLookupName."Entry No." := LastIndex;
              TempOSynchLookupName.Name := TempOSynchEntityUnsorted.Code;
              TempOSynchLookupName.INSERT;
              LastIndex := LastIndex + 1;
            END;
          UNTIL TempOSynchEntityUnsorted.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE ObtainRenamedRecordID@2(VAR ChangeLogEntry@1000 : Record 405;PKField1No@1004 : Integer;PKField2No@1005 : Integer;PKField3No@1006 : Integer;VAR RecID@1001 : RecordID);
    VAR
      TempRecRef@1002 : RecordRef;
      ArrayFieldRef@1003 : ARRAY [3] OF FieldRef;
    BEGIN
      IF NOT ChangeLogEntry.FIND('-') THEN
        EXIT;

      TempRecRef.OPEN(ChangeLogEntry."Table No.",TRUE);
      TempRecRef.INIT;
      REPEAT
        CASE ChangeLogEntry."Field No." OF
          ChangeLogEntry."Primary Key Field 1 No.":
            BEGIN
              ArrayFieldRef[1] := TempRecRef.FIELD(PKField1No);
              IF NOT OSynchTypeConversion.EvaluateTextToFieldRef(ChangeLogEntry."Old Value",ArrayFieldRef[1],FALSE) THEN
                ERROR(Text001);
            END;
          ChangeLogEntry."Primary Key Field 2 No.":
            BEGIN
              ArrayFieldRef[2] := TempRecRef.FIELD(PKField2No);
              IF NOT OSynchTypeConversion.EvaluateTextToFieldRef(ChangeLogEntry."Old Value",ArrayFieldRef[2],FALSE) THEN
                ERROR(Text001);
            END;
          ChangeLogEntry."Primary Key Field 3 No.":
            BEGIN
              ArrayFieldRef[3] := TempRecRef.FIELD(PKField3No);
              IF NOT OSynchTypeConversion.EvaluateTextToFieldRef(ChangeLogEntry."Old Value",ArrayFieldRef[3],FALSE) THEN
                ERROR(Text001);
            END;
        END;
      UNTIL ChangeLogEntry.NEXT = 0;
      TempRecRef.INSERT;
      EVALUATE(RecID,FORMAT(TempRecRef.RECORDID));
      TempRecRef.CLOSE;
    END;

    [Internal]
    PROCEDURE WriteLinkedOutlookEntryID@35(UserID@1003 : Code[50];RecID@1000 : RecordID;VAR XMLTextWriter@1002 : DotNet "'Microsoft.Dynamics.Nav.OLSync.Common, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.NAV.OLSync.Common.XmlTextWriter");
    VAR
      EntryIDContainer@1004 : Text;
    BEGIN
      IF NOT OSynchLink.GET(UserID,RecID) THEN
        EXIT;

      CLEAR(EntryIDContainer);
      IF NOT OSynchLink.GetEntryID(EntryIDContainer) THEN
        EXIT;

      XMLTextWriter.WriteStartElement('EntryID');
      XMLTextWriter.WriteElementTextContent(OSynchOutlookMgt.ConvertValueToBase64(EntryIDContainer));
      XMLTextWriter.WriteEndElement;
    END;

    [External]
    PROCEDURE RemoveChangeLogDuplicates@19(VAR ChangeLogEntry@1001 : Record 405;VAR TempChangeLogEntry@1000 : Record 405);
    BEGIN
      ChangeLogEntry.SETCURRENTKEY("Table No.","Date and Time");
      ChangeLogEntry.SETFILTER("Date and Time",'>=%1',OSynchUserSetup."Last Synch. Time");
      TempChangeLogEntry.RESET;
      TempChangeLogEntry.DELETEALL;

      IF ChangeLogEntry.FIND('+') THEN
        REPEAT
          IF ChangeLogEntry."Primary Key" <> TempChangeLogEntry."Primary Key" THEN BEGIN
            TempChangeLogEntry.SETRANGE("Primary Key",ChangeLogEntry."Primary Key");
            IF NOT TempChangeLogEntry.FIND('-') THEN BEGIN
              TempChangeLogEntry.INIT;
              TempChangeLogEntry := ChangeLogEntry;
              TempChangeLogEntry.INSERT;
            END;
          END;
        UNTIL ChangeLogEntry.NEXT(-1) = 0;

      TempChangeLogEntry.RESET;
    END;

    [Internal]
    PROCEDURE ObtainRecordID@18(TempChangeLogEntry@1000 : Record 405;VAR RecID@1001 : RecordID);
    VAR
      TempDeletedRecordRef@1004 : RecordRef;
      ArrayFieldRef@1003 : ARRAY [3] OF FieldRef;
      KeyRef@1002 : KeyRef;
      I@1006 : Integer;
    BEGIN
      TempDeletedRecordRef.OPEN(TempChangeLogEntry."Table No.",TRUE);

      KeyRef := TempDeletedRecordRef.KEYINDEX(1);
      FOR I := 1 TO KeyRef.FIELDCOUNT DO
        ArrayFieldRef[I] := KeyRef.FIELDINDEX(I);

      TempDeletedRecordRef.INIT;

      IF TempChangeLogEntry."Primary Key Field 1 No." > 0 THEN
        IF TempChangeLogEntry."Primary Key Field 1 No." = ArrayFieldRef[1].NUMBER THEN
          IF NOT
             OSynchTypeConversion.EvaluateTextToFieldRef(TempChangeLogEntry."Primary Key Field 1 Value",ArrayFieldRef[1],FALSE)
          THEN
            ERROR(Text001);

      IF TempChangeLogEntry."Primary Key Field 2 No." > 0 THEN
        IF TempChangeLogEntry."Primary Key Field 2 No." = ArrayFieldRef[2].NUMBER THEN
          IF NOT
             OSynchTypeConversion.EvaluateTextToFieldRef(TempChangeLogEntry."Primary Key Field 2 Value",ArrayFieldRef[2],FALSE)
          THEN
            ERROR(Text001);

      IF TempChangeLogEntry."Primary Key Field 3 No." > 0 THEN
        IF TempChangeLogEntry."Primary Key Field 3 No." = ArrayFieldRef[3].NUMBER THEN
          IF NOT
             OSynchTypeConversion.EvaluateTextToFieldRef(TempChangeLogEntry."Primary Key Field 3 Value",ArrayFieldRef[3],FALSE)
          THEN
            ERROR(Text001);

      TempDeletedRecordRef.INSERT;

      EVALUATE(RecID,FORMAT(TempDeletedRecordRef.RECORDID));
      TempDeletedRecordRef.CLOSE;
    END;

    LOCAL PROCEDURE FindMasterRecByChangeLogEntry@39(VAR InsModChangeLogEntry@1000 : Record 405;VAR TempRecRef@1001 : RecordRef);
    VAR
      MasterTableRef@1002 : RecordRef;
      RecID@1005 : RecordID;
    BEGIN
      IF NOT InsModChangeLogEntry.FIND('-') THEN
        EXIT;

      MasterTableRef.OPEN(InsModChangeLogEntry."Table No.");

      REPEAT
        ObtainRecordID(InsModChangeLogEntry,RecID);
        IF MasterTableRef.GET(RecID) THEN
          CopyRecordReference(MasterTableRef,TempRecRef,FALSE);
      UNTIL InsModChangeLogEntry.NEXT = 0;

      MasterTableRef.CLOSE;
    END;

    [External]
    PROCEDURE CopyRecordReference@15(FromRec@1000 : RecordRef;VAR ToRec@1001 : RecordRef;ValidateOnInsert@1007 : Boolean);
    VAR
      Field@1002 : Record 2000000041;
      TypeHelper@1005 : Codeunit 10;
      FromField@1004 : FieldRef;
      ToField@1003 : FieldRef;
      RecIDFrom@1008 : RecordID;
      RecIDTo@1006 : RecordID;
    BEGIN
      EVALUATE(RecIDFrom,FORMAT(FromRec.RECORDID));
      EVALUATE(RecIDTo,FORMAT(ToRec.RECORDID));
      IF RecIDFrom.TABLENO <> RecIDTo.TABLENO THEN
        EXIT;

      ToRec.INIT;
      IF TypeHelper.FindFields(FromRec.NUMBER,Field) THEN
        REPEAT
          FromField := FromRec.FIELD(Field."No.");
          IF NOT (FORMAT(FromField.TYPE) IN ['BLOB','Binary','TableFilter']) THEN BEGIN
            ToField := ToRec.FIELD(FromField.NUMBER);
            ToField.VALUE := FromField.VALUE;
          END;
        UNTIL Field.NEXT = 0;
      ToRec.INSERT(ValidateOnInsert);
    END;

    [External]
    PROCEDURE GetSortedEntities@30(UserID@1000 : Code[50];VAR EntitiesBuffer@1001 : Record 5306;IsSchema@1003 : Boolean);
    VAR
      TempOSynchEntityUnsorted@1002 : TEMPORARY Record 5300;
    BEGIN
      EntitiesBuffer.RESET;
      EntitiesBuffer.DELETEALL;

      OSynchUserSetup.RESET;
      OSynchUserSetup.SETRANGE("User ID",UserID);
      IF NOT IsSchema THEN
        OSynchUserSetup.SETFILTER("Synch. Direction",'<>%1',OSynchUserSetup."Synch. Direction"::"Outlook to Microsoft Dynamics NAV");

      IF NOT OSynchUserSetup.FIND('-') THEN
        EXIT;

      TempOSynchEntityUnsorted.RESET;
      TempOSynchEntityUnsorted.DELETEALL;

      REPEAT
        OSynchEntity.GET(OSynchUserSetup."Synch. Entity Code");
        TempOSynchEntityUnsorted.INIT;
        TempOSynchEntityUnsorted := OSynchEntity;
        TempOSynchEntityUnsorted.INSERT;
      UNTIL OSynchUserSetup.NEXT = 0;

      SortEntitiesForXMLOutput(TempOSynchEntityUnsorted,EntitiesBuffer);
    END;

    LOCAL PROCEDURE UpdateGlobalRecordIDBuffer@29(RecID@1000 : RecordID;SynchEntityCode@1001 : Code[10]);
    BEGIN
      GlobalRecordIDBuffer.SETRANGE("Search Record ID",UPPERCASE(FORMAT(RecID)));
      IF GlobalRecordIDBuffer.FINDFIRST THEN
        EXIT;

      GlobalRecordIDBuffer.INIT;
      GlobalRecordIDBuffer."User ID" := SynchEntityCode;
      GlobalRecordIDBuffer."Record ID" := RecID;
      GlobalRecordIDBuffer."Search Record ID" := FORMAT(RecID);
      GlobalRecordIDBuffer.INSERT;
    END;

    LOCAL PROCEDURE CheckChangeLogAvailability@24() : Boolean;
    VAR
      ChangeLogSetup@1000 : Record 402;
    BEGIN
      IF ChangeLogSetup.GET THEN
        EXIT(ChangeLogSetup."Change Log Activated");

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IsOSyncUser@7(UserID@1000 : Code[50]) : Boolean;
    VAR
      OutlookSynchUserSetup@1001 : Record 5305;
    BEGIN
      IF UserID = '' THEN
        EXIT(FALSE);

      OutlookSynchUserSetup.SETRANGE("User ID",UserID);
      EXIT(NOT OutlookSynchUserSetup.ISEMPTY);
    END;

    LOCAL PROCEDURE GetDateTimeFieldRef@8(OutlookSynchField@1001 : Record 5304;TempOutlookSynchField@1000 : TEMPORARY Record 5304;VAR SynchRecRef@1003 : RecordRef;VAR RelatedRecRef@1004 : RecordRef;VAR DateTimeFieldRef@1002 : FieldRef);
    VAR
      DateTimeRecRef@1005 : RecordRef;
    BEGIN
      IF OutlookSynchField."Table No." = TempOutlookSynchField."Table No." THEN BEGIN
        IF TempOutlookSynchField."Table No." = 0 THEN
          DateTimeFieldRef := SynchRecRef.FIELD(OutlookSynchField."Field No.")
        ELSE
          DateTimeFieldRef := RelatedRecRef.FIELD(OutlookSynchField."Field No.");
      END ELSE BEGIN
        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID",OutlookSynchField."Record GUID");
        OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::"Table Relation");

        DateTimeRecRef.OPEN(OutlookSynchField."Table No.");
        DateTimeRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,SynchRecRef));
        IF DateTimeRecRef.FIND('-') THEN
          DateTimeFieldRef := DateTimeRecRef.FIELD(OutlookSynchField."Field No.");
      END;
    END;

    BEGIN
    END.
  }
}

