OBJECT Codeunit 703 Find Record Management
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    [External]
    PROCEDURE FindNoFromTypedValue@112(Type@1007 : ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';Value@1000 : Code[20];UseDefaultTableRelationFilters@1001 : Boolean) : Code[20];
    VAR
      Item@1005 : Record 27;
      GLAccount@1004 : Record 15;
      ResultValue@1002 : Text;
      RecordView@1003 : Text;
    BEGIN
      IF Type = Type::Item THEN
        EXIT(Item.GetItemNo(Value));

      IF UseDefaultTableRelationFilters AND (Type = Type::"G/L Account") THEN
        RecordView := GetGLAccountTableRelationView;

      IF FindRecordByDescriptionAndView(ResultValue,Type,Value,RecordView) = 1 THEN
        EXIT(COPYSTR(ResultValue,1,MAXSTRLEN(GLAccount."No.")));

      EXIT(Value);
    END;

    [External]
    PROCEDURE FindRecordByDescription@30(VAR Result@1001 : Text;Type@1004 : ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';SearchText@1000 : Text) : Integer;
    BEGIN
      EXIT(FindRecordByDescriptionAndView(Result,Type,SearchText,''));
    END;

    LOCAL PROCEDURE FindRecordByDescriptionAndView@32(VAR Result@1001 : Text;Type@1004 : ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';SearchText@1000 : Text;RecordView@1013 : Text) : Integer;
    VAR
      RecRef@1014 : RecordRef;
      SearchFieldRef@1010 : ARRAY [3] OF FieldRef;
      SearchFieldNo@1011 : ARRAY [3] OF Integer;
      KeyNoMaxStrLen@1005 : Integer;
      RecWithoutQuote@1008 : Text;
      RecFilterFromStart@1007 : Text;
      RecFilterContains@1006 : Text;
    BEGIN
      // Try to find a record by SearchText looking into "No." OR "Description" fields
      // SearchFieldNo[1] - "No."
      // SearchFieldNo[2] - "Description"/"Name"
      // SearchFieldNo[3] - "Base Unit of Measure" (used for items)
      Result := '';
      IF SearchText = '' THEN
        EXIT(0);

      GetRecRefAndFieldsNoByType(RecRef,Type,SearchFieldNo);
      RecRef.SETVIEW(RecordView);

      SearchFieldRef[1] := RecRef.FIELD(SearchFieldNo[1]);
      SearchFieldRef[2] := RecRef.FIELD(SearchFieldNo[2]);
      IF SearchFieldNo[3] <> 0 THEN
        SearchFieldRef[3] := RecRef.FIELD(SearchFieldNo[3]);

      // Try GET(SearchText)
      KeyNoMaxStrLen := SearchFieldRef[1].LENGTH;
      IF STRLEN(SearchText) <= KeyNoMaxStrLen THEN
        IF TrySetFilterOnFieldRef(SearchFieldRef[1],COPYSTR(SearchText,1,KeyNoMaxStrLen)) THEN
          IF RecRef.FINDFIRST THEN BEGIN
            Result := SearchFieldRef[1].VALUE;
            EXIT(1);
          END;
      SearchFieldRef[1].SETRANGE;
      CLEARLASTERROR;

      // Try FINDFIRST "No." by mask "Search string *"
      RecWithoutQuote := CONVERTSTR(SearchText,'''','?');
      IF TrySetFilterOnFieldRef(SearchFieldRef[1],RecWithoutQuote + '*') THEN
        IF RecRef.FINDFIRST THEN BEGIN
          Result := SearchFieldRef[1].VALUE;
          EXIT(1);
        END;
      SearchFieldRef[1].SETRANGE;
      CLEARLASTERROR;

      // Example of SearchText = "Search string ''";
      // Try FINDFIRST "Description" by mask "@Search string ?"
      RecWithoutQuote := CONVERTSTR(SearchText,'''','?');
      SearchFieldRef[2].SETFILTER('''@' + RecWithoutQuote + '''');
      IF RecRef.FINDFIRST THEN BEGIN
        Result := SearchFieldRef[1].VALUE;
        EXIT(1);
      END;
      SearchFieldRef[2].SETRANGE;

      // Try FINDFIRST "No." OR "Description" by mask "@Search string ?*"
      RecRef.FILTERGROUP := -1;
      RecFilterFromStart := '''@' + RecWithoutQuote + '*''';
      SearchFieldRef[1].SETFILTER(RecFilterFromStart);
      SearchFieldRef[2].SETFILTER(RecFilterFromStart);
      IF RecRef.FINDFIRST THEN BEGIN
        Result := SearchFieldRef[1].VALUE;
        EXIT(1);
      END;

      // Try FINDFIRST "No." OR "Description" OR additional field by mask "@*Search string ?*"
      RecFilterContains := '''@*' + RecWithoutQuote + '*''';
      SearchFieldRef[1].SETFILTER(RecFilterContains);
      SearchFieldRef[2].SETFILTER(RecFilterContains);
      IF SearchFieldNo[3] <> 0 THEN
        SearchFieldRef[3].SETFILTER(RecFilterContains);

      IF RecRef.FINDFIRST THEN BEGIN
        Result := SearchFieldRef[1].VALUE;
        EXIT(RecRef.COUNT);
      END;

      // Try FINDLAST record with similar "Description"
      IF FindRecordWithSimilarName(RecRef,SearchText,SearchFieldNo[2]) THEN BEGIN
        Result := SearchFieldRef[1].VALUE;
        EXIT(1);
      END;

      // Not found
      EXIT(0);
    END;

    LOCAL PROCEDURE FindRecordWithSimilarName@29(RecRef@1001 : RecordRef;SearchText@1000 : Text;DescriptionFieldNo@1006 : Integer) : Boolean;
    VAR
      TypeHelper@1007 : Codeunit 10;
      Description@1002 : Text;
      RecCount@1003 : Integer;
      TextLength@1004 : Integer;
      Treshold@1005 : Integer;
    BEGIN
      IF SearchText = '' THEN
        EXIT(FALSE);

      TextLength := STRLEN(SearchText);
      IF TextLength > RecRef.FIELD(DescriptionFieldNo).LENGTH THEN
        EXIT(FALSE);

      Treshold := TextLength DIV 5;
      IF Treshold = 0 THEN
        EXIT(FALSE);

      RecRef.RESET;
      RecRef.ASCENDING(FALSE); // most likely to search for newest records
      IF RecRef.FINDSET THEN
        REPEAT
          RecCount += 1;
          Description := RecRef.FIELD(DescriptionFieldNo).VALUE;
          IF ABS(TextLength - STRLEN(Description)) <= Treshold THEN
            IF TypeHelper.TextDistance(UPPERCASE(SearchText),UPPERCASE(Description)) <= Treshold THEN
              EXIT(TRUE);
        UNTIL (RecRef.NEXT = 0) OR (RecCount > 1000);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetRecRefAndFieldsNoByType@33(RecRef@1004 : RecordRef;Type@1002 : ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';VAR SearchFieldNo@1003 : ARRAY [3] OF Integer);
    VAR
      GLAccount@1005 : Record 15;
      Item@1006 : Record 27;
      FixedAsset@1007 : Record 5600;
      Resource@1008 : Record 156;
      ItemCharge@1009 : Record 5800;
      StandardText@1000 : Record 7;
    BEGIN
      CASE Type OF
        Type::"G/L Account":
          BEGIN
            RecRef.OPEN(DATABASE::"G/L Account");
            SearchFieldNo[1] := GLAccount.FIELDNO("No.");
            SearchFieldNo[2] := GLAccount.FIELDNO(Name);
            SearchFieldNo[3] := 0;
          END;
        Type::Item:
          BEGIN
            RecRef.OPEN(DATABASE::Item);
            SearchFieldNo[1] := Item.FIELDNO("No.");
            SearchFieldNo[2] := Item.FIELDNO(Description);
            SearchFieldNo[3] := Item.FIELDNO("Base Unit of Measure");
          END;
        Type::Resource:
          BEGIN
            RecRef.OPEN(DATABASE::Resource);
            SearchFieldNo[1] := Resource.FIELDNO("No.");
            SearchFieldNo[2] := Resource.FIELDNO(Name);
            SearchFieldNo[3] := 0;
          END;
        Type::"Fixed Asset":
          BEGIN
            RecRef.OPEN(DATABASE::"Fixed Asset");
            SearchFieldNo[1] := FixedAsset.FIELDNO("No.");
            SearchFieldNo[2] := FixedAsset.FIELDNO(Description);
            SearchFieldNo[3] := 0;
          END;
        Type::"Charge (Item)":
          BEGIN
            RecRef.OPEN(DATABASE::"Item Charge");
            SearchFieldNo[1] := ItemCharge.FIELDNO("No.");
            SearchFieldNo[2] := ItemCharge.FIELDNO(Description);
            SearchFieldNo[3] := 0;
          END;
        Type::" ":
          BEGIN
            RecRef.OPEN(DATABASE::"Standard Text");
            SearchFieldNo[1] := StandardText.FIELDNO(Code);
            SearchFieldNo[2] := StandardText.FIELDNO(Description);
            SearchFieldNo[3] := 0;
          END;
      END;
    END;

    LOCAL PROCEDURE GetGLAccountTableRelationView@36() : Text;
    VAR
      GLAccount@1000 : Record 15;
    BEGIN
      GLAccount.SETRANGE("Direct Posting",TRUE);
      GLAccount.SETRANGE("Account Type",GLAccount."Account Type"::Posting);
      GLAccount.SETRANGE(Blocked,FALSE);
      EXIT(GLAccount.GETVIEW);
    END;

    [TryFunction]
    LOCAL PROCEDURE TrySetFilterOnFieldRef@38(VAR FieldRef@1000 : FieldRef;Filter@1001 : Text);
    BEGIN
      FieldRef.SETFILTER(Filter);
    END;

    BEGIN
    END.
  }
}

