OBJECT Codeunit 5305 Outlook Synch. Process Line
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
            CASE OSynchActionType OF
              OSynchActionType::Insert:
                InsertItem;
              OSynchActionType::Modify:
                ProcessItem;
              OSynchActionType::Delete:
                OSynchDeletionMgt.ProcessItem(OSynchUserSetup,EntityRecID,ErrorLogXMLWriter,StartDateTime);
            END;
          END;

  }
  CODE
  {
    VAR
      OSynchEntity@1007 : Record 5300;
      OSynchEntityElement@1009 : Record 5301;
      OSynchUserSetup@1008 : Record 5305;
      ErrorConflictBuffer@1025 : TEMPORARY Record 5302;
      Field@1011 : Record 2000000041;
      OSynchSetupMgt@1019 : Codeunit 5300;
      OSynchNAVMgt@1018 : Codeunit 5301;
      OSynchTypeConversion@1017 : Codeunit 5302;
      OSynchDeletionMgt@1016 : Codeunit 5303;
      OSynchOutlookMgt@1005 : Codeunit 5304;
      XMLTextReader@1001 : DotNet "'Microsoft.Dynamics.Nav.OLSync.Common, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.NAV.OLSync.Common.XmlTextReader";
      ErrorLogXMLWriter@1014 : DotNet "'Microsoft.Dynamics.Nav.OLSync.Common, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.NAV.OLSync.Common.XmlTextWriter";
      EntityRecID@1006 : RecordID;
      OSynchActionType@1002 : 'Insert,Modify,Delete,Undefined';
      StartDateTime@1037 : DateTime;
      Container@1026 : Text;
      OEntryIDHash@1012 : Text[32];
      RootIterator@1003 : Text[38];
      SkipCheckForConflicts@1004 : Boolean;
      Text001@1013 : TextConst 'DAN=Et Outlook-element kan ikke synkroniseres, fordi feltet %1 i enheden %2 ikke kan behandles. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=An Outlook item cannot be synchronized because the %1 field of the %2 entity cannot be processed. Try again later and if the problem persists contact your system administrator.';
      Text002@1015 : TextConst 'DAN=Et Outlook-element kan ikke synkroniseres, fordi samlingen %1 i enheden %2 ikke blev fundet. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=An Outlook item cannot be synchronized because the %1 collection of the %2 entity cannot be found. Try again later and if the problem persists contact your system administrator.';
      Text003@1027 : TextConst 'DAN=Et Outlook-element kan ikke synkroniseres, fordi der opstod en konflikt under behandling af enheden %1.;ENU=An Outlook item cannot be synchronized because a conflict has occurred when processing the %1 entity.';
      Text004@1020 : TextConst 'DAN=Et Outlook-element kan ikke synkroniseres, fordi der opstod en konflikt under behandling af samlingen %1 i enheden %2.;ENU=An Outlook item cannot be synchronized because a conflict has occurred when processing the %1 collection in the %2 entity.';
      Text005@1022 : TextConst 'DAN=Et Outlook-element i enheden %1 kan ikke synkroniseres, fordi samlingen %2 er afh�ngig af et Outlook-element, som ikke blev fundet i synkroniseringsmapperne.;ENU=An Outlook item of the %1 entity cannot be synchronized because the %2 collection depends on an Outlook item that could not be found in the synchronization folders.';
      Text006@1023 : TextConst 'DAN=Et Outlook-element i enheden %1 kan ikke synkroniseres, fordi samlingen %2 har en afh�ngighed, som ikke findes. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=An Outlook item of the %1 entity cannot be synchronized because the %2 collection has a dependency that does not exist. Try again later and if the problem persists contact your system administrator.';
      Text007@1030 : TextConst 'DAN=Et Outlook-element i enheden %1 kan ikke synkroniseres, fordi samlingen %2 er afh�ngig af et Outlook-element, som ikke er blevet synkroniseret. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=An Outlook item of the %1 entity cannot be synchronized because the %2 collection depends on an Outlook item that has not been synchronized. Try again later and if the problem persists contact your system administrator.';
      Text008@1031 : TextConst 'DAN=Et Outlook-element i enheden %1 kan ikke synkroniseres, fordi der opstod en fejl under behandling af samlingen %2. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=An Outlook item of the %1 entity cannot be synchronized because an error occurred when processing the %2 collection. Try again later and if the problem persists contact your system administrator.';
      Text009@1021 : TextConst 'DAN=Et Outlook-element i enheden %1 kan ikke synkroniseres, fordi der opstod en konflikt, som ikke kunne registreres. Kontakt systemadministratoren for at f� �ndret synkroniseringsindstillingerne.;ENU=An Outlook item of the %1 entity cannot be synchronized because a conflict occurred that could not be logged. Please contact your system administrator to change your synchronization settings.';
      Text010@1010 : TextConst 'DAN=Et Outlook-element kan ikke synkroniseres, fordi feltet %1 i samlingen %2 i enheden %3 ikke kan behandles. Fors�g igen senere, og kontakt systemadministratoren, hvis problemet ikke er l�st.;ENU=An Outlook item cannot be synchronized because the %1 field of the %2 collection in the %3 entity cannot be processed. Try again later and if the problem persists contact your system administrator.';

    [External]
    PROCEDURE SetGlobalParameters@5(VAR OSynchEntityIn@1006 : Record 5300;VAR OSynchUserSetupIn@1002 : Record 5305;VAR ErrorConflictBufferIn@1009 : TEMPORARY Record 5302;VAR XMLTextReaderIn@1000 : DotNet "'Microsoft.Dynamics.Nav.OLSync.Common, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.NAV.OLSync.Common.XmlTextReader";VAR ErrorLogXMLWriterIn@1008 : DotNet "'Microsoft.Dynamics.Nav.OLSync.Common, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.NAV.OLSync.Common.XmlTextWriter";RootIteratorIn@1001 : Text[38];OSynchActionTypeIn@1005 : Integer;SearchRecID@1004 : Code[250];ContainerIn@1003 : Text;OEntryIDHashIn@1007 : Text[32];StartDateTimeIn@1010 : DateTime;SkipCheckForConflictsIn@1011 : Boolean);
    BEGIN
      OSynchEntity := OSynchEntityIn;
      OSynchUserSetup := OSynchUserSetupIn;

      IF ErrorConflictBufferIn.FIND('-') THEN
        REPEAT
          ErrorConflictBuffer.INIT;
          ErrorConflictBuffer := ErrorConflictBufferIn;
          ErrorConflictBuffer.INSERT;
        UNTIL ErrorConflictBufferIn.NEXT = 0;

      XMLTextReader := XMLTextReaderIn;
      ErrorLogXMLWriter := ErrorLogXMLWriterIn;
      RootIterator := RootIteratorIn;
      OSynchActionType := OSynchActionTypeIn;
      CLEAR(EntityRecID);
      IF SearchRecID <> '' THEN
        EVALUATE(EntityRecID,SearchRecID);

      Container := ContainerIn;
      OEntryIDHash := OEntryIDHashIn;
      StartDateTime := StartDateTimeIn;
      SkipCheckForConflicts := SkipCheckForConflictsIn;
    END;

    LOCAL PROCEDURE ProcessItem@2();
    VAR
      OSynchLink@1002 : Record 5302;
      OSynchField@1001 : Record 5304;
      EntityRecRef@1003 : RecordRef;
      ModifiedEntityRecRef@1006 : RecordRef;
      RecID@1000 : RecordID;
    BEGIN
      OSynchLink.GET(OSynchUserSetup."User ID",EntityRecID);
      IF NOT EntityRecRef.GET(EntityRecID) THEN BEGIN
        IF SkipCheckForConflicts THEN BEGIN
          OSynchLink.DELETE;
          InsertItem;
          EXIT;
        END;
        OSynchOutlookMgt.WriteErrorLog(
          OSynchUserSetup."User ID",
          EntityRecID,
          'Conflict',
          OSynchEntity.Code,
          STRSUBSTNO(Text003,OSynchEntity.Code),
          ErrorLogXMLWriter,
          Container);
        ERROR('');
      END;

      IF NOT CheckEntityIdentity(EntityRecID,OSynchUserSetup."Synch. Entity Code") THEN
        EXIT;

      IF NOT SkipCheckForConflicts THEN
        IF ConflictDetected(EntityRecRef,OSynchUserSetup."Last Synch. Time") THEN BEGIN
          OSynchOutlookMgt.WriteErrorLog(
            OSynchUserSetup."User ID",
            EntityRecID,
            'Conflict',
            OSynchEntity.Code,
            STRSUBSTNO(Text003,OSynchEntity.Code),
            ErrorLogXMLWriter,
            Container);
          ERROR('');
        END;

      ModifiedEntityRecRef := EntityRecRef.DUPLICATE;

      OSynchField.RESET;
      OSynchField.SETRANGE("Synch. Entity Code",OSynchEntity.Code);
      OSynchField.SETRANGE("Element No.",0);
      ProcessProperties(OSynchField,ModifiedEntityRecRef,RootIterator,0,FALSE);

      ModifyRecRef(ModifiedEntityRecRef,EntityRecRef,0);
      ProcessCollections(ModifiedEntityRecRef);

      EVALUATE(RecID,FORMAT(EntityRecRef.RECORDID));
      UpdateSynchronizationDate(OSynchUserSetup."User ID",RecID);
    END;

    LOCAL PROCEDURE InsertItem@22();
    VAR
      OSynchLink@1003 : Record 5302;
      OSynchField@1000 : Record 5304;
      EntityRecRef@1012 : RecordRef;
      RecID@1002 : RecordID;
    BEGIN
      OSynchField.RESET;
      OSynchField.SETRANGE("Synch. Entity Code",OSynchEntity.Code) ;
      OSynchField.SETRANGE("Element No.",0);

      EntityRecRef.OPEN(OSynchEntity."Table No.");
      EntityRecRef.LOCKTABLE;
      EntityRecRef.INIT;
      ProcessFields(OSynchField,EntityRecRef,RootIterator,0,FALSE);
      EntityRecRef.INSERT(TRUE);

      OSynchLink.InsertOSynchLink(OSynchUserSetup."User ID",Container,EntityRecRef,OEntryIDHash);
      ProcessCollections(EntityRecRef);

      EVALUATE(RecID,FORMAT(EntityRecRef.RECORDID));
      UpdateSynchronizationDate(OSynchUserSetup."User ID",RecID);

      EntityRecRef.CLOSE;
    END;

    LOCAL PROCEDURE ProcessConstants@30(VAR OSynchField@1002 : Record 5304;VAR RecRef@1000 : RecordRef);
    VAR
      KeyFieldsBuffer@1001 : TEMPORARY Record 5306;
      FieldRef@1003 : FieldRef;
    BEGIN
      KeyFieldsBuffer.RESET;
      KeyFieldsBuffer.DELETEALL;
      OSynchField.CLEARMARKS;

      IF OSynchField.FIND('-') THEN
        REPEAT
          IF CheckKeyField(OSynchField."Master Table No.",OSynchField."Field No.") THEN BEGIN
            KeyFieldsBuffer.INIT;
            KeyFieldsBuffer."Entry No." := OSynchField."Field No.";
            KeyFieldsBuffer.Name := COPYSTR(OSynchField.DefaultValueExpression,1,MAXSTRLEN(KeyFieldsBuffer.Name));
            IF KeyFieldsBuffer.INSERT THEN;
          END ELSE
            OSynchField.MARK(TRUE);
        UNTIL OSynchField.NEXT = 0;

      IF OSynchField.FIND('-') THEN;
      KeyFieldsBuffer.RESET;
      IF KeyFieldsBuffer.FIND('-') THEN
        REPEAT
          FieldRef := RecRef.FIELD(KeyFieldsBuffer."Entry No.");
          IF NOT
             OSynchTypeConversion.EvaluateTextToFieldRef(
               OSynchTypeConversion.SetValueFormat(KeyFieldsBuffer.Name,FieldRef),
               FieldRef,
               TRUE)
          THEN
            IF OSynchField."Element No." = 0 THEN
              ERROR(Text001,FieldRef.CAPTION,OSynchField."Synch. Entity Code")
            ELSE
              ERROR(Text010,FieldRef.CAPTION,OSynchField."Outlook Object",OSynchField."Synch. Entity Code");
        UNTIL KeyFieldsBuffer.NEXT = 0;

      OSynchField.MARKEDONLY(TRUE);
      IF OSynchField.FIND('-') THEN
        REPEAT
          FieldRef := RecRef.FIELD(OSynchField."Field No.");
          IF NOT
             OSynchTypeConversion.EvaluateTextToFieldRef(
               OSynchTypeConversion.SetValueFormat(OSynchField.DefaultValueExpression,FieldRef),
               FieldRef,
               TRUE)
          THEN
            IF OSynchField."Element No." = 0 THEN
              ERROR(Text001,FieldRef.CAPTION,OSynchField."Synch. Entity Code")
            ELSE
              ERROR(Text010,FieldRef.CAPTION,OSynchField."Outlook Object",OSynchField."Synch. Entity Code");
        UNTIL OSynchField.NEXT = 0;
    END;

    LOCAL PROCEDURE ProcessProperties@10(VAR OSynchField@1001 : Record 5304;VAR SynchRecRef@1009 : RecordRef;Iterator@1021 : Text[38];ElementNo@1020 : Integer;ProcessOnlySearchFields@1022 : Boolean);
    VAR
      OSynchFilter@1004 : Record 5303;
      TempOSynchFilter@1017 : TEMPORARY Record 5303;
      OSynchOptionCorrel@1018 : Record 5307;
      RelatedRecRef@1013 : RecordRef;
      NullRecRef@1012 : RecordRef;
      FldRef@1006 : FieldRef;
      RelatedFldRef@1016 : FieldRef;
      ChildIterator@1000 : Text[38];
      TagName@1002 : Text[250];
      OProperty@1003 : Text[80];
      OPropertyValue@1007 : Text[1024];
      OLOptionValue@1019 : Integer;
      ValidateFieldValue@1005 : Boolean;
    BEGIN
      IF XMLTextReader.GetAllCurrentChildNodes(Iterator,ChildIterator) > 0 THEN BEGIN
        ValidateFieldValue := NOT ProcessOnlySearchFields;
        IF ProcessOnlySearchFields THEN
          OSynchField.SETRANGE("Search Field",TRUE);
        OSynchField.SETFILTER("Read-Only Status",'<>%1',OSynchField."Read-Only Status"::"Read-Only in Microsoft Dynamics NAV");
        REPEAT
          TagName := XMLTextReader.GetName(ChildIterator);
          IF TagName = 'Field' THEN BEGIN
            OProperty := XMLTextReader.GetCurrentNodeAttribute(ChildIterator,'Name');
            OSynchField.SETRANGE("Outlook Property",OProperty);
            IF OSynchField.FIND('-') THEN
              REPEAT
                IF OSynchNAVMgt.CheckSynchFieldCondition(SynchRecRef,OSynchField) THEN BEGIN
                  OPropertyValue := COPYSTR(XMLTextReader.GetValue(ChildIterator),1,MAXSTRLEN(OPropertyValue));
                  IF OSynchField."Table No." <> 0 THEN BEGIN
                    TempOSynchFilter.RESET;
                    TempOSynchFilter.DELETEALL;

                    OSynchFilter.RESET;
                    OSynchFilter.SETRANGE("Record GUID",OSynchField."Record GUID");
                    OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::"Table Relation");
                    OSynchFilter.SETFILTER(Type,'<>%1',OSynchFilter.Type::FIELD);
                    OSynchSetupMgt.CopyFilterRecords(OSynchFilter,TempOSynchFilter);

                    OSynchSetupMgt.CreateFilterCondition(
                      TempOSynchFilter,
                      OSynchField."Table No.",
                      OSynchField."Field No.",
                      TempOSynchFilter.Type::FILTER,
                      OPropertyValue);

                    RelatedRecRef.OPEN(OSynchField."Table No.");
                    RelatedRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(TempOSynchFilter,NullRecRef));
                    OSynchFilter.SETRANGE(Type,OSynchFilter.Type::FIELD);
                    IF RelatedRecRef.FIND('-') THEN BEGIN
                      IF OSynchFilter.FIND('-') THEN
                        REPEAT
                          FldRef := SynchRecRef.FIELD(OSynchFilter."Master Table Field No.");
                          RelatedFldRef := RelatedRecRef.FIELD(OSynchFilter."Field No.");
                          IF (FORMAT(RelatedFldRef.TYPE) = 'DATE') OR (FORMAT(RelatedFldRef.TYPE) = 'TIME') THEN
                            ProcessDateTimeProperty(SynchRecRef,OSynchField,OPropertyValue)
                          ELSE BEGIN
                            IF NOT
                               OSynchTypeConversion.EvaluateTextToFieldRef(
                                 OSynchTypeConversion.SetValueFormat(FORMAT(RelatedFldRef),RelatedFldRef),
                                 FldRef,
                                 ValidateFieldValue)
                            THEN
                              IF ElementNo = 0 THEN
                                ERROR(Text001,FldRef.CAPTION,OSynchEntity.Code)
                              ELSE
                                ERROR(Text010,FldRef.CAPTION,OSynchField."Outlook Object",OSynchEntity.Code);
                          END;
                        UNTIL OSynchFilter.NEXT = 0;
                    END ELSE
                      IF OPropertyValue = '' THEN BEGIN
                        IF OSynchFilter.FIND('-') THEN
                          REPEAT
                            FldRef := SynchRecRef.FIELD(OSynchFilter."Master Table Field No.");
                            IF NOT OSynchTypeConversion.EvaluateTextToFieldRef('',FldRef,ValidateFieldValue) THEN
                              IF ElementNo = 0 THEN
                                ERROR(Text001,FldRef.CAPTION,OSynchEntity.Code)
                              ELSE
                                ERROR(Text010,FldRef.CAPTION,OSynchField."Outlook Object",OSynchEntity.Code);
                          UNTIL OSynchFilter.NEXT = 0;
                      END ELSE
                        IF OSynchFilter.FINDFIRST THEN BEGIN
                          FldRef := SynchRecRef.FIELD(OSynchFilter."Master Table Field No.");
                          RelatedFldRef := RelatedRecRef.FIELD(OSynchFilter."Field No.");
                          IF ElementNo = 0 THEN
                            ERROR(Text001,FldRef.CAPTION,OSynchField."Synch. Entity Code");

                          ERROR(Text010,FldRef.CAPTION,OSynchField."Outlook Object",OSynchField."Synch. Entity Code");
                        END;
                    RelatedRecRef.CLOSE;
                  END ELSE BEGIN
                    FldRef := SynchRecRef.FIELD(OSynchField."Field No.");
                    // EVALUATE(Field.Type,FORMAT(FldRef.TYPE));

                    // CASE Field.Type OF
                    CASE FORMAT(FldRef.TYPE) OF
                      'Date','Time':
                        ProcessDateTimeProperty(SynchRecRef,OSynchField,OPropertyValue);
                      'BLOB':
                        ;
                      'Option':
                        IF EVALUATE(OLOptionValue,OPropertyValue) THEN BEGIN
                          OSynchOptionCorrel.RESET;
                          OSynchOptionCorrel.SETRANGE("Synch. Entity Code",OSynchField."Synch. Entity Code");
                          OSynchOptionCorrel.SETRANGE("Element No.",OSynchField."Element No.");
                          OSynchOptionCorrel.SETRANGE("Field Line No.",OSynchField."Line No.");
                          OSynchOptionCorrel.SETRANGE("Enumeration No.",OLOptionValue);
                          IF OSynchOptionCorrel.FINDFIRST THEN BEGIN
                            IF NOT
                               OSynchTypeConversion.EvaluateTextToFieldRef(
                                 FORMAT(OSynchOptionCorrel."Option No."),
                                 FldRef,
                                 ValidateFieldValue)
                            THEN
                              IF ElementNo = 0 THEN
                                ERROR(Text001,FldRef.CAPTION,OSynchEntity.Code)
                              ELSE
                                ERROR(Text010,FldRef.CAPTION,OSynchField."Outlook Object",OSynchEntity.Code);
                          END ELSE BEGIN
                            IF NOT OSynchSetupMgt.CheckOEnumeration(OSynchField) THEN BEGIN
                              IF NOT OSynchTypeConversion.EvaluateTextToFieldRef(OPropertyValue,FldRef,ValidateFieldValue) THEN
                                IF ElementNo = 0 THEN
                                  ERROR(Text001,FldRef.CAPTION,OSynchEntity.Code)
                                ELSE
                                  ERROR(Text010,FldRef.CAPTION,OSynchField."Outlook Object",OSynchEntity.Code);
                            END ELSE
                              IF ElementNo = 0 THEN
                                ERROR(Text001,FldRef.CAPTION,OSynchField."Synch. Entity Code")
                              ELSE
                                ERROR(Text010,FldRef.CAPTION,OSynchField."Outlook Object",OSynchField."Synch. Entity Code");
                          END;
                        END ELSE BEGIN
                          IF NOT OSynchTypeConversion.EvaluateTextToFieldRef(OPropertyValue,FldRef,ValidateFieldValue) THEN
                            IF ElementNo = 0 THEN
                              ERROR(Text001,FldRef.CAPTION,OSynchField."Synch. Entity Code")
                            ELSE
                              ERROR(Text010,FldRef.CAPTION,OSynchField."Outlook Object",OSynchField."Synch. Entity Code");
                        END;
                      ELSE BEGIN
                        IF NOT OSynchTypeConversion.EvaluateTextToFieldRef(OPropertyValue,FldRef,ValidateFieldValue) THEN
                          IF ElementNo = 0 THEN
                            ERROR(Text001,FldRef.CAPTION,OSynchField."Synch. Entity Code")
                          ELSE
                            ERROR(Text010,FldRef.CAPTION,OSynchField."Outlook Object",OSynchField."Synch. Entity Code");
                      END;
                    END;
                  END;
                END;
              UNTIL OSynchField.NEXT = 0;
          END;
        UNTIL NOT XMLTextReader.MoveNext(ChildIterator);
      END;
      XMLTextReader.RemoveIterator(ChildIterator);
    END;

    LOCAL PROCEDURE ProcessRelationsAndConditions@26(VAR OSynchEntityElementIn@1002 : Record 5301;EntityRecRef@1006 : RecordRef;VAR CollectionRecRef@1000 : RecordRef;DependentRecRef@1008 : RecordRef);
    VAR
      OSynchEntity1@1011 : Record 5300;
      OSynchFilter@1004 : Record 5303;
      TempOSynchFilter@1005 : TEMPORARY Record 5303;
      KeyFieldsBuffer@1001 : TEMPORARY Record 5306;
      OSynchDependency@1010 : Record 5311;
      TempDependentRecRef@1009 : RecordRef;
      NullRecRef@1012 : RecordRef;
      FieldRef@1003 : FieldRef;
      RecID@1007 : RecordID;
    BEGIN
      TempOSynchFilter.RESET;
      TempOSynchFilter.DELETEALL;

      OSynchFilter.RESET;
      OSynchFilter.SETRANGE("Record GUID",OSynchEntityElementIn."Record GUID");
      OSynchFilter.SETRANGE(Type,OSynchFilter.Type::FIELD);
      OSynchSetupMgt.ComposeFilterRecords(OSynchFilter,TempOSynchFilter,EntityRecRef,TempOSynchFilter.Type::CONST);

      IF OSynchEntityElementIn."No. of Dependencies" > 0 THEN BEGIN
        EVALUATE(RecID,FORMAT(DependentRecRef.RECORDID));
        TempDependentRecRef.OPEN(RecID.TABLENO,TRUE);
        OSynchNAVMgt.CopyRecordReference(DependentRecRef,TempDependentRecRef,FALSE);

        OSynchDependency.RESET;
        OSynchDependency.SETRANGE("Synch. Entity Code",OSynchEntityElementIn."Synch. Entity Code");
        OSynchDependency.SETRANGE("Element No.",OSynchEntityElementIn."Element No.");
        OSynchDependency.CALCFIELDS("Depend. Synch. Entity Tab. No.");
        OSynchDependency.SETRANGE("Depend. Synch. Entity Tab. No.",RecID.TABLENO);
        IF OSynchDependency.FIND('-') THEN
          REPEAT
            OSynchEntity1.GET(OSynchDependency."Depend. Synch. Entity Code");
            OSynchFilter.RESET;
            OSynchFilter.SETRANGE("Record GUID",OSynchEntity1."Record GUID");
            IF OSynchFilter.FINDFIRST THEN
              TempDependentRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,NullRecRef));

            IF TempDependentRecRef.FIND('-') THEN BEGIN
              OSynchFilter.RESET;
              OSynchFilter.SETRANGE("Record GUID",OSynchDependency."Record GUID");
              OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::Condition);
              OSynchFilter.SETRANGE(Type,OSynchFilter.Type::CONST);
              OSynchSetupMgt.CopyFilterRecords(OSynchFilter,TempOSynchFilter);

              OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::"Table Relation");
              OSynchFilter.SETRANGE(Type,OSynchFilter.Type::FIELD);
              OSynchSetupMgt.ComposeFilterRecords(OSynchFilter,TempOSynchFilter,TempDependentRecRef,TempOSynchFilter.Type::CONST);
            END;
          UNTIL OSynchDependency.NEXT = 0;
        TempDependentRecRef.CLOSE;
      END;

      KeyFieldsBuffer.RESET;
      KeyFieldsBuffer.DELETEALL;
      TempOSynchFilter.CLEARMARKS;

      IF TempOSynchFilter.FIND('-') THEN
        REPEAT
          IF CheckKeyField(TempOSynchFilter."Table No.",TempOSynchFilter."Field No.") THEN BEGIN
            KeyFieldsBuffer.INIT;
            KeyFieldsBuffer."Entry No." := TempOSynchFilter."Field No.";
            KeyFieldsBuffer.Name := COPYSTR(TempOSynchFilter.GetFilterExpressionValue,1,MAXSTRLEN(KeyFieldsBuffer.Name));
            IF KeyFieldsBuffer.INSERT THEN;
          END ELSE
            TempOSynchFilter.MARK(TRUE);
        UNTIL TempOSynchFilter.NEXT = 0;

      KeyFieldsBuffer.RESET;
      IF KeyFieldsBuffer.FIND('-') THEN
        REPEAT
          FieldRef := CollectionRecRef.FIELD(KeyFieldsBuffer."Entry No.");
          IF NOT
             OSynchTypeConversion.EvaluateTextToFieldRef(
               OSynchTypeConversion.SetValueFormat(KeyFieldsBuffer.Name,FieldRef),
               FieldRef,
               TRUE)
          THEN
            IF OSynchEntityElementIn."Element No." = 0 THEN
              ERROR(Text001,FieldRef.CAPTION,OSynchEntityElementIn."Synch. Entity Code")
            ELSE
              ERROR(
                Text010,
                FieldRef.CAPTION,
                OSynchEntityElementIn."Outlook Collection",
                OSynchEntityElementIn."Synch. Entity Code");
        UNTIL KeyFieldsBuffer.NEXT = 0;

      TempOSynchFilter.MARKEDONLY(TRUE);
      TempOSynchFilter.SETCURRENTKEY("Table No.","Field No."); // Defines validation order

      IF TempOSynchFilter.FIND('-') THEN
        REPEAT
          FieldRef := CollectionRecRef.FIELD(TempOSynchFilter."Field No.");
          IF NOT
             OSynchTypeConversion.EvaluateTextToFieldRef(
               OSynchTypeConversion.SetValueFormat(TempOSynchFilter.GetFilterExpressionValue,FieldRef),
               FieldRef,
               TRUE)
          THEN
            IF OSynchEntityElementIn."Element No." = 0 THEN
              ERROR(Text001,FieldRef.CAPTION,OSynchEntityElementIn."Synch. Entity Code")
            ELSE
              ERROR(
                Text010,
                FieldRef.CAPTION,
                OSynchEntityElementIn."Outlook Collection",
                OSynchEntityElementIn."Synch. Entity Code");
        UNTIL TempOSynchFilter.NEXT = 0;
    END;

    LOCAL PROCEDURE ProcessFields@7(VAR OSynchField@1005 : Record 5304;VAR SynchRecRef@1003 : RecordRef;Iterator@1002 : Text[38];ElementNo@1001 : Integer;ProcessOnlySearchFields@1000 : Boolean);
    VAR
      OSynchFieldBuffer@1004 : TEMPORARY Record 5304;
      IsConst@1006 : Boolean;
    BEGIN
      IF NOT OSynchField.FIND('-') THEN
        EXIT;

      REPEAT
        IF OSynchField."Outlook Property" = '' THEN BEGIN
          IF NOT IsConst THEN BEGIN
            ProcessProperties(OSynchFieldBuffer,SynchRecRef,Iterator,ElementNo,ProcessOnlySearchFields);
            OSynchFieldBuffer.RESET;
            OSynchFieldBuffer.DELETEALL;
          END;

          IF (OSynchField."Table No." = 0) AND
             (OSynchField."Read-Only Status" = OSynchField."Read-Only Status"::"Read-Only in Microsoft Dynamics NAV") AND
             (OSynchField.Condition = '')
          THEN BEGIN
            OSynchFieldBuffer.INIT;
            OSynchFieldBuffer.COPY(OSynchField);
            OSynchFieldBuffer.INSERT;
          END;

          IsConst := TRUE;
        END ELSE BEGIN
          IF IsConst THEN BEGIN
            ProcessConstants(OSynchFieldBuffer,SynchRecRef);
            OSynchFieldBuffer.RESET;
            OSynchFieldBuffer.DELETEALL;
          END;

          OSynchFieldBuffer.INIT;
          OSynchFieldBuffer.COPY(OSynchField);
          OSynchFieldBuffer.INSERT;

          IsConst := FALSE;
        END;
      UNTIL OSynchField.NEXT = 0;

      IF IsConst THEN
        ProcessConstants(OSynchFieldBuffer,SynchRecRef)
      ELSE
        ProcessProperties(OSynchFieldBuffer,SynchRecRef,Iterator,ElementNo,ProcessOnlySearchFields);
    END;

    LOCAL PROCEDURE ProcessDateTimeProperty@45(VAR SynchRecRef@1003 : RecordRef;OSynchFieldIn@1001 : Record 5304;OPropertyValue@1007 : Text[1024]);
    VAR
      OSynchField@1000 : Record 5304;
      OSynchFilter@1009 : Record 5303;
      TempOSynchFilter@1008 : TEMPORARY Record 5303;
      Field1@1002 : Record 2000000041;
      RelatedRecRef@1010 : RecordRef;
      NullRecRef@1006 : RecordRef;
      FldRef@1005 : FieldRef;
      RelatedFldRef@1004 : FieldRef;
      DateTimeVar@1011 : DateTime;
    BEGIN
      OSynchField.RESET;
      OSynchField.SETRANGE("Synch. Entity Code",OSynchFieldIn."Synch. Entity Code");
      OSynchField.SETRANGE("Element No.",OSynchFieldIn."Element No.");
      OSynchField.SETRANGE("Outlook Property",OSynchFieldIn."Outlook Property");
      IF OSynchField.FIND('-') THEN
        REPEAT
          IF OSynchField."Table No." = 0 THEN
            Field1.GET(OSynchField."Master Table No.",OSynchField."Field No.")
          ELSE
            Field1.GET(OSynchField."Table No.",OSynchField."Field No.");

          IF (Field1.Type = Field1.Type::Time) OR (Field1.Type = Field1.Type::Date) THEN BEGIN
            IF DateTimeVar = 0DT THEN
              OSynchTypeConversion.TextToDateTime(OPropertyValue,DateTimeVar);
            IF OSynchNAVMgt.CheckSynchFieldCondition(SynchRecRef,OSynchField) THEN
              IF OSynchField."Table No." = 0 THEN BEGIN
                FldRef := SynchRecRef.FIELD(OSynchField."Field No.");
                IF Field1.Type = Field1.Type::Time THEN
                  FldRef.VALIDATE(DT2TIME(DateTimeVar))
                ELSE
                  FldRef.VALIDATE(DT2DATE(DateTimeVar));
              END ELSE BEGIN
                TempOSynchFilter.RESET;
                TempOSynchFilter.DELETEALL;

                OSynchFilter.RESET;
                OSynchFilter.SETRANGE("Record GUID",OSynchField."Record GUID");
                OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::"Table Relation");
                OSynchFilter.SETFILTER(Type,'<>%1',OSynchFilter.Type::FIELD);
                OSynchSetupMgt.CopyFilterRecords(OSynchFilter,TempOSynchFilter);

                OSynchSetupMgt.CreateFilterCondition(
                  TempOSynchFilter,
                  OSynchField."Table No.",
                  OSynchField."Field No.",
                  TempOSynchFilter.Type::FILTER,
                  OSynchTypeConversion.SetDateTimeFormat(DateTimeVar));

                RelatedRecRef.OPEN(OSynchField."Table No.");
                RelatedRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(TempOSynchFilter,NullRecRef));
                IF RelatedRecRef.FIND('-') THEN BEGIN
                  OSynchFilter.SETRANGE(Type,OSynchFilter.Type::FIELD);
                  IF OSynchFilter.FIND('-') THEN
                    REPEAT
                      FldRef := SynchRecRef.FIELD(OSynchFilter."Master Table Field No.");
                      RelatedFldRef := RelatedRecRef.FIELD(OSynchFilter."Field No.");
                      IF NOT OSynchTypeConversion.EvaluateTextToFieldRef(FORMAT(RelatedFldRef),FldRef,TRUE) THEN
                        IF OSynchField."Element No." = 0 THEN
                          ERROR(Text001,FldRef.CAPTION,OSynchField."Synch. Entity Code")
                        ELSE
                          ERROR(Text010,FldRef.CAPTION,OSynchField."Outlook Object",OSynchField."Synch. Entity Code");
                    UNTIL OSynchFilter.NEXT = 0;
                END;
                RelatedRecRef.CLOSE;
              END;
          END;
        UNTIL OSynchField.NEXT = 0;
    END;

    LOCAL PROCEDURE ProcessCollections@6(EntityRecRef@1000 : RecordRef);
    VAR
      CollectionElementsBuffer@1005 : TEMPORARY Record 5302;
      CollectionsBuffer@1007 : RecordRef;
      ChildIterator@1001 : Text[38];
      ElementIterator@1003 : Text[38];
      ChildTagName@1002 : Text[250];
      OCollectionName@1004 : Text[80];
      CollectionTableID@1006 : Integer;
      CollectionElementNo@1008 : Integer;
      IsBufferUsed@1009 : Boolean;
    BEGIN
      IF XMLTextReader.GetAllCurrentChildNodes(RootIterator,ChildIterator) = 0 THEN BEGIN
        XMLTextReader.RemoveIterator(ChildIterator);
        EXIT;
      END;

      CollectionTableID := 0;
      OSynchEntityElement.RESET;
      OSynchEntityElement.SETRANGE("Synch. Entity Code",OSynchEntity.Code);
      REPEAT
        ChildTagName := XMLTextReader.GetName(ChildIterator);
        IF ChildTagName = 'Collection' THEN BEGIN
          CollectionElementsBuffer.RESET;
          CollectionElementsBuffer.DELETEALL;

          OCollectionName := XMLTextReader.GetCurrentNodeAttribute(ChildIterator,'Name');
          OSynchEntityElement.SETRANGE("Outlook Collection",OCollectionName);
          IF OSynchEntityElement.FINDFIRST THEN BEGIN
            IF XMLTextReader.GetAllCurrentChildNodes(ChildIterator,ElementIterator) > 0 THEN
              REPEAT
                ChildTagName := XMLTextReader.GetName(ElementIterator);
                IF ChildTagName = 'Element' THEN
                  CheckCollectionElement(OSynchEntityElement,ElementIterator);
              UNTIL NOT XMLTextReader.MoveNext(ElementIterator);
            XMLTextReader.RemoveIterator(ElementIterator);
          END ELSE
            ERROR(Text002,OCollectionName,OSynchEntityElement."Synch. Entity Code");

          IF NOT SkipCheckForConflicts THEN
            IF CollectionConflictDetected(OSynchEntityElement,EntityRecRef,OSynchUserSetup."Last Synch. Time") THEN BEGIN
              OSynchOutlookMgt.WriteErrorLog(
                OSynchUserSetup."User ID",
                EntityRecRef.RECORDID,
                'Conflict',
                OSynchEntityElement."Synch. Entity Code",
                STRSUBSTNO(
                  Text004,
                  OSynchEntityElement."Outlook Collection",
                  OSynchEntityElement."Synch. Entity Code"),
                ErrorLogXMLWriter,
                Container);
              ERROR('');
            END;

          IF XMLTextReader.GetAllCurrentChildNodes(ChildIterator,ElementIterator) > 0 THEN BEGIN
            IF CollectionTableID <> OSynchEntityElement."Table No." THEN BEGIN
              CollectionElementNo := 0;
              IF CollectionTableID = 0 THEN
                CollectionsBuffer.OPEN(OSynchEntityElement."Table No.",TRUE);

              IF CollectionsBuffer.FIND('-') THEN
                ProcessCollectiosBuffer(CollectionElementsBuffer,CollectionsBuffer,CollectionTableID);

              CollectionTableID := OSynchEntityElement."Table No.";
              CollectionsBuffer.CLOSE;
              CollectionsBuffer.OPEN(CollectionTableID,TRUE);
              IsBufferUsed := TRUE;
            END;

            REPEAT
              ChildTagName := XMLTextReader.GetName(ElementIterator);
              IF ChildTagName = 'Element' THEN BEGIN
                CollectionElementNo := CollectionElementNo + 1;
                ProcessCollectionElement(
                  OSynchEntityElement,
                  ElementIterator,
                  EntityRecRef,
                  CollectionElementsBuffer,
                  CollectionsBuffer,
                  CollectionElementNo);
              END;
            UNTIL NOT XMLTextReader.MoveNext(ElementIterator);
          END;

          XMLTextReader.RemoveIterator(ElementIterator);
          DeletedCollectionElements(CollectionElementsBuffer,OSynchEntityElement,EntityRecRef);
        END;
      UNTIL NOT XMLTextReader.MoveNext(ChildIterator);
      XMLTextReader.RemoveIterator(ChildIterator);

      IF IsBufferUsed THEN
        IF CollectionsBuffer.FIND('-') THEN
          ProcessCollectiosBuffer(CollectionElementsBuffer,CollectionsBuffer,CollectionTableID);
    END;

    [Internal]
    PROCEDURE ProcessCollectiosBuffer@18(VAR CollectionElementsBuffer@1005 : Record 5302;CollectionsBuffer@1000 : RecordRef;TableID@1001 : Integer);
    VAR
      CollectionRecRef@1002 : RecordRef;
      RecID@1004 : RecordID;
    BEGIN
      CollectionRecRef.OPEN(TableID);

      REPEAT
        OSynchNAVMgt.CopyRecordReference(CollectionsBuffer,CollectionRecRef,TRUE);

        EVALUATE(RecID,FORMAT(CollectionRecRef.RECORDID));

        CollectionElementsBuffer.INIT;
        CollectionElementsBuffer."User ID" := OSynchUserSetup."User ID";
        CollectionElementsBuffer."Record ID" := RecID;
        IF CollectionElementsBuffer.INSERT THEN;
      UNTIL CollectionsBuffer.NEXT = 0;

      CollectionRecRef.CLOSE;
    END;

    LOCAL PROCEDURE ProcessCollectionElement@20(OSynchEntityElementIn@1015 : Record 5301;ElementIterator@1000 : Text[38];EntityRecRef@1001 : RecordRef;VAR CollectionElementsBuffer@1013 : Record 5302;VAR CollectionsBuffer@1022 : RecordRef;CollectionElementNo@1023 : Integer);
    VAR
      OSynchEntity1@1014 : Record 5300;
      OSynchLink@1005 : Record 5302;
      OSynchFilter@1008 : Record 5303;
      OSynchFilter1@1011 : Record 5303;
      OSynchField@1019 : Record 5304;
      OSynchDependency@1004 : Record 5311;
      DependentRecRef@1006 : RecordRef;
      TempDependentRecRef@1018 : RecordRef;
      CollectionRecRef@1007 : RecordRef;
      TempCollectionRecRef@1009 : RecordRef;
      OriginalCollectionRecRef@1012 : RecordRef;
      NullRecRef@1010 : RecordRef;
      RecID@1016 : RecordID;
      ContainerLocal@1021 : Text;
      EntryIDHash@1002 : Text[32];
      ChildrenIterator@1003 : Text[38];
      IsFound@1017 : Boolean;
      IsOneToOneEntity@1020 : Boolean;
    BEGIN
      IF XMLTextReader.GetAllCurrentChildNodes(ElementIterator,ChildrenIterator) = 0 THEN
        EXIT;

      OSynchEntityElementIn.CALCFIELDS("Table Caption","Master Table No.","No. of Dependencies");
      IF OSynchEntityElementIn."No. of Dependencies" = 0 THEN BEGIN
        OSynchField.RESET;
        OSynchField.SETRANGE("Synch. Entity Code",OSynchEntityElementIn."Synch. Entity Code");
        OSynchField.SETRANGE("Element No.",OSynchEntityElementIn."Element No.");

        TempCollectionRecRef.OPEN(OSynchEntityElementIn."Table No.",TRUE);
        TempCollectionRecRef.INIT;
        ProcessProperties(OSynchField,TempCollectionRecRef,ElementIterator,OSynchEntityElementIn."Element No.",TRUE);
        TempCollectionRecRef.INSERT;

        FindEntityElementBySearchField(
          OSynchEntityElementIn."Synch. Entity Code",
          OSynchEntityElementIn."Element No.",
          EntityRecRef,
          TempCollectionRecRef,
          RecID);
        TempCollectionRecRef.CLOSE;

        IF FORMAT(RecID) = '' THEN BEGIN
          IF OSynchEntityElementIn."Master Table No." = OSynchEntityElementIn."Table No." THEN
            ModifyCollectionElement(EntityRecRef.RECORDID,OSynchEntityElementIn."Element No.",ElementIterator,CollectionElementsBuffer)
          ELSE
            PutCollectionElementToBuffer(
              EntityRecRef,
              NullRecRef,
              OSynchEntityElementIn,
              ElementIterator,
              CollectionsBuffer,
              CollectionElementNo);
        END ELSE
          ModifyCollectionElement(RecID,OSynchEntityElementIn."Element No.",ElementIterator,CollectionElementsBuffer);
      END ELSE BEGIN
        CLEAR(ContainerLocal);
        IsOneToOneEntity := FALSE;

        IF XMLTextReader.GetName(ChildrenIterator) = 'EntryID' THEN BEGIN
          ContainerLocal := OSynchOutlookMgt.ConvertValueFromBase64(XMLTextReader.GetValue(ChildrenIterator));
          EntryIDHash := OSynchOutlookMgt.ComputeHash(ContainerLocal);
        END;

        OSynchLink.RESET;
        OSynchLink.SETRANGE("User ID",OSynchUserSetup."User ID");
        OSynchLink.SETRANGE("Outlook Entry ID Hash",EntryIDHash);
        OSynchLink.FINDFIRST;

        DependentRecRef.GET(OSynchLink."Record ID");
        EVALUATE(RecID,FORMAT(DependentRecRef.RECORDID));

        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID",OSynchEntityElementIn."Record GUID");
        OSynchFilter.FINDFIRST;

        CollectionRecRef.OPEN(OSynchEntityElementIn."Table No.");
        CollectionRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,EntityRecRef));
        IF NOT CollectionRecRef.FIND('-') THEN
          IF OSynchEntityElementIn."Master Table No." <> OSynchEntityElementIn."Table No." THEN BEGIN
            PutCollectionElementToBuffer(
              EntityRecRef,
              DependentRecRef,
              OSynchEntityElementIn,
              ElementIterator,
              CollectionsBuffer,
              CollectionElementNo);

            EXIT;
          END ELSE BEGIN
            CollectionRecRef := EntityRecRef.DUPLICATE;
            IsOneToOneEntity := TRUE;
          END;

        TempDependentRecRef.OPEN(RecID.TABLENO,TRUE);
        OSynchNAVMgt.CopyRecordReference(DependentRecRef,TempDependentRecRef,FALSE);

        OSynchDependency.RESET;
        OSynchDependency.SETRANGE("Synch. Entity Code",OSynchEntityElementIn."Synch. Entity Code");
        OSynchDependency.SETRANGE("Element No.",OSynchEntityElementIn."Element No.");
        OSynchDependency.CALCFIELDS("Depend. Synch. Entity Tab. No.");
        OSynchDependency.SETRANGE("Depend. Synch. Entity Tab. No.",RecID.TABLENO);
        IF OSynchDependency.FIND('-') THEN
          REPEAT
            OSynchEntity1.GET(OSynchDependency."Depend. Synch. Entity Code");
            OSynchFilter.RESET;
            OSynchFilter.SETRANGE("Record GUID",OSynchEntity1."Record GUID");
            IF OSynchFilter.FINDFIRST THEN
              TempDependentRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,NullRecRef));

            IF TempDependentRecRef.FIND('-') THEN
              IsFound := TRUE;
          UNTIL (OSynchDependency.NEXT = 0) OR IsFound;

        OSynchFilter.RESET;
        OSynchFilter.SETRANGE("Record GUID",OSynchDependency."Record GUID");
        OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::Condition);

        OSynchFilter1.RESET;
        OSynchFilter1.SETRANGE("Record GUID",OSynchDependency."Record GUID");
        OSynchFilter1.SETRANGE("Filter Type",OSynchFilter1."Filter Type"::"Table Relation");
        OSynchFilter1.SETRANGE(Type,OSynchFilter1.Type::FIELD);

        IF NOT IsOneToOneEntity THEN BEGIN
          TempCollectionRecRef.OPEN(OSynchEntityElementIn."Table No.",TRUE);
          REPEAT
            OSynchNAVMgt.CopyRecordReference(CollectionRecRef,TempCollectionRecRef,FALSE);
          UNTIL CollectionRecRef.NEXT = 0;

          TempCollectionRecRef.SETVIEW(OSynchSetupMgt.ComposeTableView(OSynchFilter,OSynchFilter1,DependentRecRef));
          IF TempCollectionRecRef.FIND('-') THEN BEGIN
            EVALUATE(RecID,FORMAT(TempCollectionRecRef.RECORDID));
            ModifyCollectionElement(RecID,OSynchEntityElementIn."Element No.",ElementIterator,CollectionElementsBuffer);
            EXIT;
          END;
          TempCollectionRecRef.CLOSE;
        END;

        IF OSynchEntityElementIn."Table No." = OSynchEntityElementIn."Master Table No." THEN BEGIN
          EVALUATE(RecID,FORMAT(CollectionRecRef.RECORDID));
          OSynchFilter.RESET;
          OSynchFilter.SETRANGE("Record GUID",OSynchEntityElementIn."Record GUID");
          OSynchFilter.SETRANGE(Type,OSynchFilter.Type::FIELD);
          IF NOT OneToOneRelation(OSynchFilter) THEN
            ERROR(
              Text008,
              OSynchEntityElementIn."Synch. Entity Code",
              OSynchEntityElementIn."Outlook Collection");

          OriginalCollectionRecRef := CollectionRecRef.DUPLICATE;
          IF NOT SetRelation(CollectionRecRef,DependentRecRef,OSynchDependency) THEN
            ERROR(
              Text008,
              OSynchDependency."Synch. Entity Code",
              OSynchEntityElementIn."Outlook Collection");

          OSynchField.RESET;
          OSynchField.SETRANGE("Synch. Entity Code",OSynchEntityElementIn."Synch. Entity Code");
          OSynchField.SETRANGE("Element No.",OSynchEntityElementIn."Element No.");
          ProcessProperties(
            OSynchField,
            CollectionRecRef,
            ElementIterator,
            OSynchEntityElementIn."Element No.",
            FALSE);

          ModifyRecRef(CollectionRecRef,OriginalCollectionRecRef,OSynchEntityElementIn."Element No.");
          CollectionElementsBuffer.INIT;
          CollectionElementsBuffer."User ID" := OSynchUserSetup."User ID";
          CollectionElementsBuffer."Record ID" := RecID;
          IF CollectionElementsBuffer.INSERT THEN;
          EXIT;
        END;

        PutCollectionElementToBuffer(
          EntityRecRef,
          DependentRecRef,
          OSynchEntityElementIn,
          ElementIterator,
          CollectionsBuffer,
          CollectionElementNo);

        DependentRecRef.CLOSE;
        TempDependentRecRef.CLOSE;
        CollectionRecRef.CLOSE;
      END;
    END;

    LOCAL PROCEDURE DeletedCollectionElements@76(VAR CollectionElementsBuffer@1000 : Record 5302;OSynchEntityElementIn@1002 : Record 5301;EntityRecRef@1001 : RecordRef);
    VAR
      OSynchFilter@1003 : Record 5303;
      DeletedCollectionElementsBuf@1005 : TEMPORARY Record 5302;
      CollectionRecRef@1004 : RecordRef;
      RecID@1006 : RecordID;
    BEGIN
      OSynchFilter.RESET;
      OSynchFilter.SETRANGE("Record GUID",OSynchEntityElementIn."Record GUID");
      CollectionRecRef.OPEN(OSynchEntityElementIn."Table No.");
      CollectionRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,EntityRecRef));

      IF NOT CollectionElementsBuffer.FIND('-') THEN BEGIN
        IF NOT CollectionRecRef.FIND('-') THEN
          EXIT;
      END;

      DeletedCollectionElementsBuf.RESET;
      DeletedCollectionElementsBuf.DELETEALL;

      REPEAT
        EVALUATE(RecID,FORMAT(CollectionRecRef.RECORDID));
        IF NOT CollectionElementsBuffer.GET(OSynchUserSetup."User ID",RecID) THEN BEGIN
          DeletedCollectionElementsBuf.INIT;
          DeletedCollectionElementsBuf."User ID" := OSynchUserSetup."User ID";
          DeletedCollectionElementsBuf."Record ID" := RecID;
          DeletedCollectionElementsBuf.INSERT;
        END;
      UNTIL CollectionRecRef.NEXT = 0;

      EVALUATE(RecID,FORMAT(EntityRecRef.RECORDID));
      OSynchDeletionMgt.ProcessCollectionElements(DeletedCollectionElementsBuf,OSynchEntityElementIn,RecID);
      CollectionRecRef.CLOSE;
    END;

    LOCAL PROCEDURE ModifyCollectionElement@3(CollectionElementRecID@1002 : RecordID;ElementNo@1005 : Integer;ElementIterator@1000 : Text[38];VAR CollectionElementsBuffer@1004 : Record 5302);
    VAR
      OSynchField@1006 : Record 5304;
      CollectionRecRef@1003 : RecordRef;
      ModifiedCollectionRecRef@1001 : RecordRef;
    BEGIN
      CollectionRecRef.GET(CollectionElementRecID);

      ModifiedCollectionRecRef := CollectionRecRef.DUPLICATE;

      OSynchField.RESET;
      OSynchField.SETRANGE("Synch. Entity Code",OSynchEntity.Code);
      OSynchField.SETRANGE("Element No.",ElementNo);
      ProcessProperties(OSynchField,ModifiedCollectionRecRef,ElementIterator,ElementNo,FALSE);

      ModifyRecRef(ModifiedCollectionRecRef,CollectionRecRef,ElementNo);

      CollectionRecRef.CLOSE;

      CollectionElementsBuffer.INIT;
      CollectionElementsBuffer."User ID" := OSynchUserSetup."User ID";
      CollectionElementsBuffer."Record ID" := CollectionElementRecID;
      IF CollectionElementsBuffer.INSERT THEN;
    END;

    LOCAL PROCEDURE PutCollectionElementToBuffer@28(EntityRecRef@1002 : RecordRef;DependentRecRef@1001 : RecordRef;OSynchEntityElementIn@1003 : Record 5301;ElementIterator@1010 : Text[38];VAR CollectionElementRecRef@1020 : RecordRef;CollectionElementNo@1000 : Integer);
    VAR
      OSynchFilter@1004 : Record 5303;
      OSynchField@1008 : Record 5304;
      CollectionElementRecRef1@1018 : RecordRef;
      FldRef@1005 : FieldRef;
      KeyRef@1015 : KeyRef;
      IntVar@1016 : Integer;
      BigIntVar@1014 : BigInteger;
      DecimaVar@1017 : Decimal;
    BEGIN
      OSynchEntityElementIn.CALCFIELDS("Master Table No.");
      IF OSynchEntityElementIn."Master Table No." = OSynchEntityElementIn."Table No." THEN
        ERROR(Text008,OSynchEntityElementIn."Synch. Entity Code",OSynchEntityElementIn."Outlook Collection");

      OSynchField.RESET;
      OSynchField.SETRANGE("Synch. Entity Code",OSynchEntityElementIn."Synch. Entity Code");
      OSynchField.SETRANGE("Element No.",OSynchEntityElementIn."Element No.");

      CollectionElementRecRef.INIT;
      ProcessRelationsAndConditions(
        OSynchEntityElementIn,
        EntityRecRef,
        CollectionElementRecRef,
        DependentRecRef);
      ProcessFields(
        OSynchField,
        CollectionElementRecRef,
        ElementIterator,
        OSynchEntityElementIn."Element No.",
        FALSE);

      OSynchFilter.RESET;
      OSynchFilter.SETRANGE("Record GUID",OSynchEntityElementIn."Record GUID");
      OSynchFilter.SETRANGE(Type,OSynchFilter.Type::FIELD);

      CollectionElementRecRef1.OPEN(OSynchEntityElementIn."Table No.");
      CollectionElementRecRef1.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,EntityRecRef));
      IF CollectionElementRecRef1.FIND('+') THEN BEGIN
        KeyRef := CollectionElementRecRef1.KEYINDEX(1);
        FldRef := KeyRef.FIELDINDEX(KeyRef.FIELDCOUNT);
        EVALUATE(Field.Type,FORMAT(FldRef.TYPE));

        IF Field.Type IN [Field.Type::Integer,Field.Type::BigInteger,Field.Type::Decimal] THEN
          CASE Field.Type OF
            Field.Type::Integer:
              BEGIN
                EVALUATE(IntVar,FORMAT(CollectionElementRecRef1.FIELDINDEX(KeyRef.FIELDCOUNT).VALUE));
                IntVar := IntVar + CollectionElementNo * 10000;
              END;
            Field.Type::BigInteger:
              BEGIN
                EVALUATE(BigIntVar,FORMAT(CollectionElementRecRef1.FIELDINDEX(KeyRef.FIELDCOUNT).VALUE));
                BigIntVar := BigIntVar + CollectionElementNo * 10000;
              END;
            Field.Type::Decimal:
              BEGIN
                EVALUATE(DecimaVar,FORMAT(CollectionElementRecRef1.FIELDINDEX(KeyRef.FIELDCOUNT).VALUE));
                DecimaVar := DecimaVar + CollectionElementNo * 10000;
              END;
            Field.Type::GUID:
              FldRef.VALUE := CREATEGUID;
          END;
      END ELSE BEGIN
        IntVar := CollectionElementNo * 10000;
        BigIntVar := CollectionElementNo * 10000;
        DecimaVar := CollectionElementNo * 10000;
      END;

      KeyRef := CollectionElementRecRef.KEYINDEX(1);
      FldRef := KeyRef.FIELDINDEX(KeyRef.FIELDCOUNT);
      EVALUATE(Field.Type,FORMAT(FldRef.TYPE));

      IF Field.Type IN [Field.Type::Integer,Field.Type::BigInteger,Field.Type::Decimal,Field.Type::GUID] THEN
        CASE Field.Type OF
          Field.Type::Integer:
            FldRef.VALIDATE(IntVar);
          Field.Type::BigInteger:
            FldRef.VALIDATE(BigIntVar);
          Field.Type::Decimal:
            FldRef.VALIDATE(DecimaVar);
          Field.Type::GUID:
            FldRef.VALUE := CREATEGUID;
        END;

      CollectionElementRecRef.INSERT;
    END;

    LOCAL PROCEDURE SetRelation@19(CollectionElementRecRef@1008 : RecordRef;DependentRecRef@1000 : RecordRef;OSynchDependency@1002 : Record 5311) : Boolean;
    VAR
      OSynchFilter@1003 : Record 5303;
      SourceField@1006 : Record 2000000041;
      TargetField@1007 : Record 2000000041;
      SourceFieldRef@1004 : FieldRef;
      TargetFieldRef@1005 : FieldRef;
    BEGIN
      OSynchFilter.RESET;
      OSynchFilter.SETRANGE("Record GUID",OSynchDependency."Record GUID");
      OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::"Table Relation");
      OSynchFilter.SETRANGE(Type,OSynchFilter.Type::FIELD);
      IF OSynchFilter.FIND('-') THEN
        REPEAT
          IF (CollectionElementRecRef.NUMBER <> OSynchFilter."Master Table No.") OR
             (DependentRecRef.NUMBER <> OSynchFilter."Table No.")
          THEN
            EXIT(FALSE);

          SourceFieldRef := DependentRecRef.FIELD(OSynchFilter."Field No.");
          TargetFieldRef := CollectionElementRecRef.FIELD(OSynchFilter."Master Table Field No.");
          EVALUATE(SourceField.Type,FORMAT(SourceFieldRef.TYPE));
          EVALUATE(TargetField.Type,FORMAT(TargetFieldRef.TYPE));

          IF SourceField.Type <> TargetField.Type THEN
            EXIT(FALSE);

          TargetFieldRef.VALIDATE(SourceFieldRef.VALUE);
        UNTIL OSynchFilter.NEXT = 0;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ModifyRecRef@16(VAR RecRef@1000 : RecordRef;xRecRef@1001 : RecordRef;ElementNo@1006 : Integer);
    VAR
      Field@1005 : Record 2000000041;
      OSynchEntityElement1@1012 : Record 5301;
      TypeHelper@1007 : Codeunit 10;
      FldRef@1002 : FieldRef;
      xFldRef@1003 : FieldRef;
      ArrayPKFldRef@1010 : ARRAY [3] OF FieldRef;
      xArrayPKFldRef@1011 : ARRAY [3] OF FieldRef;
      PKeyRef@1009 : KeyRef;
      i@1004 : Integer;
      IsChanged@1008 : Boolean;
    BEGIN
      IF TypeHelper.FindFields(RecRef.NUMBER,Field) THEN
        REPEAT
          FldRef := RecRef.FIELD(Field."No.");
          xFldRef := xRecRef.FIELD(Field."No.");
          IF FORMAT(FldRef.CLASS) = 'Normal' THEN
            IF FORMAT(FldRef.VALUE) <> FORMAT(xFldRef.VALUE) THEN
              IsChanged := TRUE;
        UNTIL Field.NEXT = 0;

      IF IsChanged THEN BEGIN
        PKeyRef := RecRef.KEYINDEX(1);
        FOR i := 1 TO PKeyRef.FIELDCOUNT DO BEGIN
          ArrayPKFldRef[i] := PKeyRef.FIELDINDEX(i);
          xArrayPKFldRef[i] := xRecRef.KEYINDEX(1).FIELDINDEX(i);
          IF FORMAT(ArrayPKFldRef[i].VALUE) <> FORMAT(xArrayPKFldRef[i].VALUE) THEN
            IF ElementNo = 0 THEN
              ERROR(Text001,ArrayPKFldRef[i].CAPTION,OSynchEntity.Code)
            ELSE BEGIN
              OSynchEntityElement1.GET(OSynchEntity.Code,ElementNo);
              ERROR(Text010,ArrayPKFldRef[i].CAPTION,OSynchEntityElement1."Outlook Collection",OSynchEntity.Code);
            END;
        END;

        RecRef.MODIFY(TRUE);
      END;
    END;

    [External]
    PROCEDURE UpdateSynchronizationDate@1(UserID@1002 : Code[50];RecID@1000 : RecordID);
    VAR
      OSynchLink@1001 : Record 5302;
    BEGIN
      IF NOT OSynchLink.GET(UserID,RecID) THEN
        EXIT;

      OSynchLink."Synchronization Date" := CURRENTDATETIME;
      OSynchLink.MODIFY;
    END;

    LOCAL PROCEDURE CheckCollectionElement@59(OSynchEntityElementIn@1015 : Record 5301;CollectionIterator@1000 : Text[38]);
    VAR
      OSynchEntity1@1009 : Record 5300;
      OSynchLink@1005 : Record 5302;
      OSynchFilter@1010 : Record 5303;
      OSynchDependency@1008 : Record 5311;
      DependentRecRef@1006 : RecordRef;
      TempDependentRecRef@1012 : RecordRef;
      NullRecRef@1011 : RecordRef;
      RecID@1007 : RecordID;
      ContainerLocal@1014 : Text;
      DependentEntityIDHash@1013 : Text[32];
      ElementChildIterator@1002 : Text[38];
      IsEmptyEntryID@1004 : Boolean;
      DependencyFound@1001 : Boolean;
    BEGIN
      IF XMLTextReader.GetAllCurrentChildNodes(CollectionIterator,ElementChildIterator) <= 0 THEN BEGIN
        XMLTextReader.RemoveIterator(ElementChildIterator);
        EXIT;
      END;

      CLEAR(ContainerLocal);
      IsEmptyEntryID := TRUE;

      IF  XMLTextReader.GetName(ElementChildIterator) = 'EntryID' THEN BEGIN
        ContainerLocal := OSynchOutlookMgt.ConvertValueFromBase64(XMLTextReader.GetValue(ElementChildIterator));
        IsEmptyEntryID := ContainerLocal = '';
      END;

      OSynchEntityElementIn.CALCFIELDS("No. of Dependencies");

      IF IsEmptyEntryID AND (OSynchEntityElementIn."No. of Dependencies" > 0) THEN
        ERROR(
          Text005,
          OSynchEntityElementIn."Synch. Entity Code",
          OSynchEntityElementIn."Outlook Collection");

      IF NOT IsEmptyEntryID AND (OSynchEntityElementIn."No. of Dependencies" = 0) THEN
        ERROR(Text006,OSynchEntityElementIn."Synch. Entity Code",OSynchEntityElementIn."Outlook Collection");

      IF NOT IsEmptyEntryID THEN BEGIN
        ContainerLocal := OSynchOutlookMgt.ConvertValueFromBase64(XMLTextReader.GetValue(ElementChildIterator));
        DependentEntityIDHash := OSynchOutlookMgt.ComputeHash(ContainerLocal);
        IF DependentEntityIDHash = '' THEN
          ERROR(Text007,OSynchEntityElementIn."Synch. Entity Code",OSynchEntityElementIn."Outlook Collection");

        ErrorConflictBuffer.RESET;
        ErrorConflictBuffer.SETRANGE("Outlook Entry ID Hash",DependentEntityIDHash);
        IF ErrorConflictBuffer.FINDFIRST THEN
          ERROR(
            Text008,
            OSynchEntityElementIn."Synch. Entity Code",
            OSynchEntityElementIn."Outlook Collection");

        OSynchLink.RESET;
        OSynchLink.SETRANGE("User ID",OSynchUserSetup."User ID");
        OSynchLink.SETRANGE("Outlook Entry ID Hash",DependentEntityIDHash);
        IF NOT OSynchLink.FINDFIRST THEN
          ERROR(
            Text008,
            OSynchEntityElementIn."Synch. Entity Code",
            OSynchEntityElementIn."Outlook Collection");

        EVALUATE(RecID,FORMAT(OSynchLink."Record ID"));
        DependentRecRef.GET(RecID);
        TempDependentRecRef.OPEN(RecID.TABLENO,TRUE);
        OSynchNAVMgt.CopyRecordReference(DependentRecRef,TempDependentRecRef,FALSE);

        OSynchDependency.RESET;
        OSynchDependency.SETRANGE("Synch. Entity Code",OSynchEntityElementIn."Synch. Entity Code");
        OSynchDependency.SETRANGE("Element No.",OSynchEntityElementIn."Element No.");
        OSynchDependency.CALCFIELDS("Depend. Synch. Entity Tab. No.");
        OSynchDependency.SETRANGE("Depend. Synch. Entity Tab. No.",RecID.TABLENO);
        IF NOT OSynchDependency.FIND('-') THEN
          ERROR(Text006,OSynchEntityElementIn."Synch. Entity Code",OSynchEntityElementIn."Outlook Collection");

        DependencyFound := FALSE;
        REPEAT
          OSynchEntity1.GET(OSynchDependency."Depend. Synch. Entity Code");
          OSynchFilter.RESET;
          OSynchFilter.SETRANGE("Record GUID",OSynchEntity1."Record GUID");
          IF OSynchFilter.FINDFIRST THEN
            TempDependentRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,NullRecRef));

          IF TempDependentRecRef.FIND('-') THEN
            DependencyFound := TRUE;
        UNTIL OSynchDependency.NEXT = 0;

        IF NOT DependencyFound THEN
          ERROR(Text006,OSynchEntityElementIn."Synch. Entity Code",OSynchEntityElementIn."Outlook Collection");
      END;
      XMLTextReader.RemoveIterator(ElementChildIterator);
    END;

    [Internal]
    PROCEDURE CheckEntityIdentity@12(RecID@1000 : RecordID;SynchEntityCode@1001 : Code[10]) : Boolean;
    VAR
      OSynchEntity1@1003 : Record 5300;
      OSynchFilter@1006 : Record 5303;
      EntityRecRef@1002 : RecordRef;
      TempEntityRecRef@1004 : RecordRef;
      NullRecRef@1005 : RecordRef;
    BEGIN
      OSynchEntity1.GET(SynchEntityCode);
      OSynchFilter.RESET;
      OSynchFilter.SETRANGE("Record GUID",OSynchEntity1."Record GUID");
      OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::Condition);

      EntityRecRef.GET(RecID);
      TempEntityRecRef.OPEN(RecID.TABLENO,TRUE);
      OSynchNAVMgt.CopyRecordReference(EntityRecRef,TempEntityRecRef,FALSE);
      TempEntityRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,NullRecRef));
      IF NOT TempEntityRecRef.FIND('-') THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE CheckUserSettingsForConflicts@13(VAR SynchRecRef@1004 : RecordRef;TableID@1003 : Integer);
    VAR
      OSynchFilter@1001 : Record 5303;
      TempRecRef@1002 : RecordRef;
      NullRecRef@1000 : RecordRef;
    BEGIN
      IF OSynchUserSetup."Synch. Direction" = OSynchUserSetup."Synch. Direction"::"Outlook to Microsoft Dynamics NAV" THEN
        ERROR(Text009,OSynchUserSetup."Synch. Entity Code");

      OSynchFilter.RESET;
      OSynchFilter.SETFILTER(
        "Record GUID",
        '%1|%2',
        OSynchEntity."Record GUID",
        OSynchUserSetup."Record GUID");

      TempRecRef.OPEN(TableID,TRUE);
      OSynchNAVMgt.CopyRecordReference(SynchRecRef,TempRecRef,FALSE);
      TempRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,NullRecRef));
      IF NOT TempRecRef.FIND('-') THEN
        ERROR(Text009,OSynchUserSetup."Synch. Entity Code");
      TempRecRef.CLOSE;
    END;

    [Internal]
    PROCEDURE CheckKeyField@14(TableID@1000 : Integer;FieldID@1001 : Integer) : Boolean;
    VAR
      CheckRecordRef@1002 : RecordRef;
      CheckKeyRef@1004 : KeyRef;
      CheckFieldRef@1003 : FieldRef;
      Counter@1005 : Integer;
    BEGIN
      CheckRecordRef.OPEN(TableID,TRUE);
      CheckKeyRef := CheckRecordRef.KEYINDEX(1);

      FOR Counter := 1 TO CheckKeyRef.FIELDCOUNT DO BEGIN
        CheckFieldRef := CheckKeyRef.FIELDINDEX(Counter);
        IF CheckFieldRef.NUMBER = FieldID THEN
          EXIT(TRUE);
      END;

      CheckRecordRef.CLOSE;
    END;

    LOCAL PROCEDURE ConflictDetected@21(SynchRecRef@1009 : RecordRef;LastSynchTime@1002 : DateTime) IsConflict : Boolean;
    VAR
      ChangeLogEntry@1000 : Record 405;
      OSynchLink@1005 : Record 5302;
      RecID@1004 : RecordID;
    BEGIN
      EVALUATE(RecID,FORMAT(SynchRecRef.RECORDID));

      IF NOT OSynchLink.GET(OSynchUserSetup."User ID",RecID) THEN
        EXIT;

      ChangeLogEntry.SETCURRENTKEY("Table No.","Primary Key Field 1 Value");
      FilterChangeLog(RecID,ChangeLogEntry);
      ChangeLogEntry.SETRANGE("Type of Change",ChangeLogEntry."Type of Change"::Modification);

      IF OSynchLink."Synchronization Date" >= LastSynchTime THEN BEGIN
        ChangeLogEntry.SETFILTER("Date and Time",'>=%1',LastSynchTime);
        IF NOT ChangeLogEntry.FINDLAST THEN
          EXIT;

        IF ChangeLogEntry."Date and Time" <= OSynchLink."Synchronization Date" THEN
          EXIT;

        ChangeLogEntry.SETFILTER("Date and Time",'>=%1',OSynchLink."Synchronization Date");
      END ELSE
        ChangeLogEntry.SETFILTER("Date and Time",'>=%1',LastSynchTime);

      IF NOT ChangeLogEntry.FINDFIRST THEN
        EXIT;

      IsConflict := IsConflictDetected(ChangeLogEntry,SynchRecRef,RecID.TABLENO);
    END;

    [Internal]
    PROCEDURE IsConflictDetected@4(VAR ChangeLogEntry@1000 : Record 405;SynchRecRef@1009 : RecordRef;TableNo@1003 : Integer) IsConflict : Boolean;
    VAR
      OutlookSynchField@1001 : Record 5304;
    BEGIN
      OutlookSynchField.RESET;
      OutlookSynchField.SETRANGE("Synch. Entity Code",OSynchEntity.Code);
      OutlookSynchField.SETRANGE("Element No.",0);
      OutlookSynchField.SETFILTER("Read-Only Status",'<>%1',
        OutlookSynchField."Read-Only Status"::"Read-Only in Microsoft Dynamics NAV");
      IsConflict := SetupFieldsModified(ChangeLogEntry,OutlookSynchField);

      IF IsConflict THEN
        CheckUserSettingsForConflicts(SynchRecRef,TableNo);
    END;

    LOCAL PROCEDURE CollectionConflictDetected@65(OSynchEntityElementIn@1000 : Record 5301;EntityRecRef@1001 : RecordRef;LastSynchTime@1005 : DateTime) IsConflict : Boolean;
    VAR
      ChangeLogEntry@1004 : Record 405;
      TempChangeLogEntry@1006 : TEMPORARY Record 405;
      OSynchLink@1011 : Record 5302;
      OSynchFilter@1003 : Record 5303;
      OSynchField@1007 : Record 5304;
      CollectionRecRef@1002 : RecordRef;
      CollectionFieldRef@1009 : FieldRef;
      RecID@1012 : RecordID;
      FilteringExpression@1008 : Text;
    BEGIN
      EVALUATE(RecID,FORMAT(EntityRecRef.RECORDID));
      IF NOT OSynchLink.GET(OSynchUserSetup."User ID",RecID) THEN
        EXIT;

      OSynchFilter.RESET;
      OSynchFilter.SETRANGE("Record GUID",OSynchEntityElementIn."Record GUID");
      FilteringExpression := OSynchSetupMgt.ComposeTableFilter(OSynchFilter,EntityRecRef);

      ChangeLogEntry.SETCURRENTKEY("Table No.","Date and Time");
      ChangeLogEntry.SETRANGE("Table No.",OSynchEntityElementIn."Table No.");

      IF OSynchLink."Synchronization Date" >= LastSynchTime THEN BEGIN
        ChangeLogEntry.SETFILTER("Date and Time",'>=%1',LastSynchTime);
        IF NOT ChangeLogEntry.FINDLAST THEN
          EXIT;
        IF ChangeLogEntry."Date and Time" <= OSynchLink."Synchronization Date" THEN
          EXIT;
        ChangeLogEntry.SETFILTER("Date and Time",'>=%1',OSynchLink."Synchronization Date");
      END ELSE
        ChangeLogEntry.SETFILTER("Date and Time",'>=%1&<=%2',LastSynchTime,StartDateTime);

      ChangeLogEntry.SETFILTER("Type of Change",'<>%1',ChangeLogEntry."Type of Change"::Deletion);
      IF NOT ChangeLogEntry.ISEMPTY THEN BEGIN
        ChangeLogEntry.SETCURRENTKEY("Table No.","Primary Key Field 1 Value");
        CollectionRecRef.OPEN(OSynchEntityElementIn."Table No.");
        CollectionRecRef.SETVIEW(FilteringExpression);
        IF CollectionRecRef.FIND('-') THEN
          REPEAT
            EVALUATE(RecID,FORMAT(CollectionRecRef.RECORDID));
            FilterChangeLog(RecID,ChangeLogEntry);
            IF ChangeLogEntry.FINDFIRST THEN BEGIN
              OSynchField.RESET;
              OSynchField.SETRANGE("Synch. Entity Code",OSynchEntityElementIn."Synch. Entity Code");
              OSynchField.SETRANGE("Element No.",OSynchEntityElementIn."Element No.");
              OSynchField.SETFILTER("Read-Only Status",'<>%1',OSynchField."Read-Only Status"::"Read-Only in Microsoft Dynamics NAV");

              IsConflict := SetupFieldsModified(ChangeLogEntry,OSynchField);
              IF IsConflict THEN BEGIN
                EVALUATE(RecID,FORMAT(EntityRecRef.RECORDID));
                CheckUserSettingsForConflicts(EntityRecRef,RecID.TABLENO);
                EXIT;
              END;
            END;
          UNTIL CollectionRecRef.NEXT = 0;
        CollectionRecRef.CLOSE;
      END;

      ChangeLogEntry.SETRANGE("Primary Key Field 1 Value");
      ChangeLogEntry.SETRANGE("Primary Key Field 1 No.");
      ChangeLogEntry.SETRANGE("Primary Key Field 2 No.");
      ChangeLogEntry.SETRANGE("Primary Key Field 2 Value");
      ChangeLogEntry.SETRANGE("Primary Key Field 3 No.");
      ChangeLogEntry.SETRANGE("Primary Key Field 3 Value");

      ChangeLogEntry.SETRANGE("Type of Change",ChangeLogEntry."Type of Change"::Deletion);
      ChangeLogEntry.SETCURRENTKEY("Table No.","Date and Time");
      IF ChangeLogEntry.ISEMPTY THEN
        EXIT;

      TempChangeLogEntry.RESET;
      TempChangeLogEntry.DELETEALL;

      OSynchNAVMgt.RemoveChangeLogDuplicates(ChangeLogEntry,TempChangeLogEntry);
      ChangeLogEntry.SETCURRENTKEY("Table No.","Primary Key Field 1 Value");
      IF TempChangeLogEntry.FIND('-') THEN
        REPEAT
          CollectionRecRef.OPEN(OSynchEntityElementIn."Table No.",TRUE);
          CollectionRecRef.INIT;
          ChangeLogEntry.SETRANGE("Primary Key",TempChangeLogEntry."Primary Key");
          ChangeLogEntry.SETRANGE("Primary Key Field 1 Value",TempChangeLogEntry."Primary Key Field 1 Value");
          IF ChangeLogEntry.FINDSET THEN
            REPEAT
              OSynchFilter.SETRANGE("Field No.",ChangeLogEntry."Field No.");
              IF OSynchFilter.FINDFIRST THEN BEGIN
                CollectionFieldRef := CollectionRecRef.FIELD(ChangeLogEntry."Field No.");
                IF NOT
                   OSynchTypeConversion.EvaluateTextToFieldRef(
                     OSynchTypeConversion.SetValueFormat(ChangeLogEntry."Old Value",CollectionFieldRef),
                     CollectionFieldRef,
                     FALSE)
                THEN
                  ERROR(
                    Text010,
                    CollectionFieldRef.CAPTION,
                    OSynchEntityElementIn."Outlook Collection",
                    OSynchEntityElementIn."Synch. Entity Code");
              END;
            UNTIL ChangeLogEntry.NEXT = 0;
          CollectionRecRef.INSERT;

          CollectionRecRef.SETVIEW(FilteringExpression);
          IsConflict := CollectionRecRef.FIND('-');
          IF IsConflict THEN BEGIN
            EVALUATE(RecID,FORMAT(EntityRecRef.RECORDID));
            CheckUserSettingsForConflicts(EntityRecRef,RecID.TABLENO);
            EXIT;
          END;
          CollectionRecRef.CLOSE;
        UNTIL TempChangeLogEntry.NEXT = 0;
    END;

    [Internal]
    PROCEDURE FindEntityElementBySearchField@11(SynchEntityCode@1000 : Code[10];ElementNo@1004 : Integer;EntityRecRef@1013 : RecordRef;TemplateEntityElementRecRef@1001 : RecordRef;VAR RecID@1006 : RecordID);
    VAR
      OSynchEntityElement1@1014 : Record 5301;
      OSynchFilter@1009 : Record 5303;
      TempOSynchFilter@1005 : TEMPORARY Record 5303;
      TempOSynchFilter1@1011 : TEMPORARY Record 5303;
      OSynchField@1002 : Record 5304;
      CollectionElementRecRef@1003 : RecordRef;
      TempCollectionElementRecRef@1015 : RecordRef;
      RelatedRecRef@1008 : RecordRef;
      NullRecRef@1010 : RecordRef;
      FieldRef@1007 : FieldRef;
      RelatedFieldRef@1012 : FieldRef;
    BEGIN
      CLEAR(RecID);
      OSynchEntityElement1.GET(SynchEntityCode,ElementNo);
      TempCollectionElementRecRef.OPEN(OSynchEntityElement1."Table No.",TRUE);

      OSynchFilter.RESET;
      OSynchFilter.SETRANGE("Record GUID",OSynchEntityElement1."Record GUID");
      IF OSynchFilter.FINDFIRST THEN BEGIN
        CollectionElementRecRef.OPEN(OSynchEntityElement1."Table No.");
        CollectionElementRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(OSynchFilter,EntityRecRef));
        IF CollectionElementRecRef.FIND('-') THEN
          REPEAT
            OSynchNAVMgt.CopyRecordReference(CollectionElementRecRef,TempCollectionElementRecRef,FALSE);
          UNTIL CollectionElementRecRef.NEXT = 0;
        CollectionElementRecRef.CLOSE;
      END;

      OSynchField.RESET;
      OSynchField.SETRANGE("Synch. Entity Code",SynchEntityCode);
      OSynchField.SETRANGE("Element No.",ElementNo);
      OSynchField.SETRANGE("Search Field",TRUE);
      IF OSynchField.FIND('-') THEN
        REPEAT
          IF OSynchField."Table No." = 0 THEN BEGIN
            FieldRef := TemplateEntityElementRecRef.FIELD(OSynchField."Field No.");
            OSynchSetupMgt.CreateFilterCondition(
              TempOSynchFilter,
              OSynchField."Master Table No.",
              OSynchField."Field No.",
              TempOSynchFilter.Type::FILTER,
              FORMAT(FieldRef.VALUE));
          END ELSE BEGIN
            TempOSynchFilter1.RESET;
            TempOSynchFilter1.DELETEALL;

            OSynchFilter.RESET;
            OSynchFilter.SETRANGE("Record GUID",OSynchField."Record GUID");
            OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::"Table Relation");
            OSynchFilter.SETRANGE(Type,OSynchFilter.Type::CONST);
            OSynchSetupMgt.CopyFilterRecords(OSynchFilter,TempOSynchFilter1);

            RelatedFieldRef := TemplateEntityElementRecRef.FIELD(OSynchField."Field No.");
            OSynchSetupMgt.CreateFilterCondition(
              TempOSynchFilter1,
              OSynchField."Table No.",
              OSynchField."Field No.",
              TempOSynchFilter1.Type::FILTER,
              FORMAT(RelatedFieldRef.VALUE));

            RelatedRecRef.OPEN(OSynchField."Table No.");
            RelatedRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(TempOSynchFilter1,NullRecRef));
            IF RelatedRecRef.FIND('-') THEN BEGIN
              OSynchFilter.SETRANGE(Type,OSynchFilter.Type::FIELD);
              IF OSynchFilter.FIND('-') THEN
                REPEAT
                  FieldRef := TemplateEntityElementRecRef.FIELD(OSynchFilter."Master Table Field No.");
                  RelatedFieldRef := RelatedRecRef.FIELD(OSynchFilter."Field No.");

                  TempOSynchFilter.RESET;
                  TempOSynchFilter.SETRANGE("Field No.",OSynchFilter."Master Table Field No.");
                  IF NOT TempOSynchFilter.FINDFIRST THEN
                    OSynchSetupMgt.CreateFilterCondition(
                      TempOSynchFilter,
                      OSynchFilter."Master Table No.",
                      OSynchFilter."Master Table Field No.",
                      TempOSynchFilter.Type::FILTER,
                      FORMAT(RelatedFieldRef.VALUE));
                UNTIL OSynchFilter.NEXT = 0;
            END;
            RelatedRecRef.CLOSE;
          END;
        UNTIL OSynchField.NEXT = 0;

      TempOSynchFilter.RESET;
      IF TempOSynchFilter.FINDFIRST THEN BEGIN
        TempCollectionElementRecRef.SETVIEW(OSynchSetupMgt.ComposeTableFilter(TempOSynchFilter,NullRecRef));

        IF TempCollectionElementRecRef.FIND('-') THEN
          EVALUATE(RecID,FORMAT(TempCollectionElementRecRef.RECORDID));
      END;
    END;

    [External]
    PROCEDURE FilterChangeLog@98(RecID@1000 : RecordID;VAR ChangeLogEntry@1001 : Record 405);
    VAR
      SynchRecRef@1003 : RecordRef;
      KeyRef@1004 : KeyRef;
      KeyFldRef@1005 : FieldRef;
      i@1006 : Integer;
      MaxKeyCount@1007 : Integer;
    BEGIN
      SynchRecRef := RecID.GETRECORD;

      ChangeLogEntry.SETRANGE("Table No.",RecID.TABLENO);

      KeyRef := SynchRecRef.KEYINDEX(1);
      MaxKeyCount := KeyRef.FIELDCOUNT;
      IF MaxKeyCount > 3 THEN
        MaxKeyCount := 3;
      FOR i := 1 TO MaxKeyCount DO BEGIN
        KeyFldRef := KeyRef.FIELDINDEX(i);
        CASE i OF
          1:
            BEGIN
              ChangeLogEntry.SETRANGE("Primary Key Field 1 No.",KeyFldRef.NUMBER);
              ChangeLogEntry.SETRANGE("Primary Key Field 1 Value",COPYSTR(FORMAT(KeyFldRef.VALUE,0,9),1,50));
            END;
          2:
            BEGIN
              ChangeLogEntry.SETRANGE("Primary Key Field 2 No.",KeyFldRef.NUMBER);
              ChangeLogEntry.SETRANGE("Primary Key Field 2 Value",COPYSTR(FORMAT(KeyFldRef.VALUE,0,9),1,50));
            END;
          3:
            BEGIN
              ChangeLogEntry.SETRANGE("Primary Key Field 3 No.",KeyFldRef.NUMBER);
              ChangeLogEntry.SETRANGE("Primary Key Field 3 Value",COPYSTR(FORMAT(KeyFldRef.VALUE,0,9),1,50));
            END;
        END;
      END;
    END;

    [External]
    PROCEDURE SetupFieldsModified@9(VAR ChangeLogEntry@1000 : Record 405;VAR OSynchField@1001 : Record 5304) : Boolean;
    VAR
      OSynchFilter@1003 : Record 5303;
    BEGIN
      IF OSynchField.FIND('-') THEN
        REPEAT
          IF OSynchField."Table No." = 0 THEN BEGIN
            ChangeLogEntry.SETRANGE("Field No.",OSynchField."Field No.");
            IF ChangeLogEntry.FIND('-') THEN BEGIN
              ChangeLogEntry.SETRANGE("Field No.");
              EXIT(TRUE);
            END;
          END ELSE BEGIN
            OSynchFilter.RESET;
            OSynchFilter.SETRANGE("Record GUID",OSynchField."Record GUID");
            OSynchFilter.SETRANGE("Filter Type",OSynchFilter."Filter Type"::"Table Relation");
            OSynchFilter.SETRANGE(Type,OSynchFilter.Type::FIELD);
            IF OSynchFilter.FIND('-') THEN
              REPEAT
                ChangeLogEntry.SETRANGE("Field No.",OSynchFilter."Master Table Field No.");
                IF ChangeLogEntry.FIND('-') THEN BEGIN
                  ChangeLogEntry.SETRANGE("Field No.");
                  EXIT(TRUE);
                END;
              UNTIL OSynchFilter.NEXT = 0;
          END;
        UNTIL OSynchField.NEXT = 0;

      ChangeLogEntry.SETRANGE("Field No.");
    END;

    [Internal]
    PROCEDURE OneToOneRelation@17(VAR OSynchFilter@1000 : Record 5303) : Boolean;
    VAR
      RecRef@1001 : RecordRef;
      KeyRef@1002 : KeyRef;
      FieldRef@1004 : FieldRef;
      Counter@1003 : Integer;
    BEGIN
      OSynchFilter.FINDFIRST;

      RecRef.OPEN(OSynchFilter."Table No.",TRUE);
      KeyRef := RecRef.KEYINDEX(1);

      FOR Counter := 1 TO KeyRef.FIELDCOUNT DO BEGIN
        FieldRef := KeyRef.FIELDINDEX(Counter);
        OSynchFilter.SETRANGE("Field No.",FieldRef.NUMBER);
        IF NOT OSynchFilter.FINDFIRST THEN
          EXIT(FALSE);
      END;

      RecRef.CLOSE;
      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

