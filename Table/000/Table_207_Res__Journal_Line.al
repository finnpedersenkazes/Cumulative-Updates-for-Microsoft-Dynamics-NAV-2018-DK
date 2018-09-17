OBJECT Table 207 Res. Journal Line
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               LOCKTABLE;
               ResJnlTemplate.GET("Journal Template Name");
               ResJnlBatch.GET("Journal Template Name","Journal Batch Name");

               ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
               ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
             END;

    CaptionML=[DAN=Ressourcekladdelinje;
               ENU=Res. Journal Line];
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="Res. Journal Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Forbrug,Salg;
                                                                    ENU=Usage,Sale];
                                                   OptionString=Usage,Sale }
    { 4   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 5   ;   ;Posting Date        ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Document Date","Posting Date");
                                                              END;

                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 6   ;   ;Resource No.        ;Code20        ;TableRelation=Resource;
                                                   OnValidate=BEGIN
                                                                IF "Resource No." = '' THEN BEGIN
                                                                  CreateDim(
                                                                    DATABASE::Resource,"Resource No.",
                                                                    DATABASE::"Resource Group","Resource Group No.",
                                                                    DATABASE::Job,"Job No.");
                                                                  EXIT;
                                                                END;

                                                                Res.GET("Resource No.");
                                                                Res.CheckResourcePrivacyBlocked(FALSE);
                                                                Res.TESTFIELD(Blocked,FALSE);
                                                                Description := Res.Name;
                                                                "Direct Unit Cost" := Res."Direct Unit Cost";
                                                                "Unit Cost" := Res."Unit Cost";
                                                                "Unit Price" := Res."Unit Price";
                                                                "Resource Group No." := Res."Resource Group No.";
                                                                "Work Type Code" := '';
                                                                "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                                                                VALIDATE("Unit of Measure Code",Res."Base Unit of Measure");

                                                                IF NOT "System-Created Entry" THEN
                                                                  IF "Time Sheet No." = '' THEN
                                                                    Res.TESTFIELD("Use Time Sheet",FALSE);

                                                                CreateDim(
                                                                  DATABASE::Resource,"Resource No.",
                                                                  DATABASE::"Resource Group","Resource Group No.",
                                                                  DATABASE::Job,"Job No.");
                                                              END;

                                                   CaptionML=[DAN=Ressourcenr.;
                                                              ENU=Resource No.] }
    { 7   ;   ;Resource Group No.  ;Code20        ;TableRelation="Resource Group";
                                                   OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::"Resource Group","Resource Group No.",
                                                                  DATABASE::Resource,"Resource No.",
                                                                  DATABASE::Job,"Job No.");
                                                              END;

                                                   CaptionML=[DAN=Ressourcegruppenr.;
                                                              ENU=Resource Group No.];
                                                   Editable=No }
    { 8   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 9   ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   OnValidate=VAR
                                                                ResourceUnitOfMeasure@1000 : Record 205;
                                                              BEGIN
                                                                IF "Resource No." <> '' THEN BEGIN
                                                                  IF WorkType.GET("Work Type Code") THEN
                                                                    "Unit of Measure Code" := WorkType."Unit of Measure Code"
                                                                  ELSE BEGIN
                                                                    Res.GET("Resource No.");
                                                                    "Unit of Measure Code" := Res."Base Unit of Measure";
                                                                  END;

                                                                  IF "Unit of Measure Code" = '' THEN BEGIN
                                                                    Res.GET("Resource No.");
                                                                    "Unit of Measure Code" := Res."Base Unit of Measure"
                                                                  END;
                                                                  ResourceUnitOfMeasure.GET("Resource No.","Unit of Measure Code");
                                                                  "Qty. per Unit of Measure" := ResourceUnitOfMeasure."Qty. per Unit of Measure";

                                                                  FindResUnitCost;
                                                                  FindResPrice;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 10  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   OnValidate=BEGIN
                                                                FindResPrice;

                                                                CreateDim(
                                                                  DATABASE::Job,"Job No.",
                                                                  DATABASE::Resource,"Resource No.",
                                                                  DATABASE::"Resource Group","Resource Group No.");
                                                              END;

                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 11  ;   ;Unit of Measure Code;Code10        ;TableRelation="Resource Unit of Measure".Code WHERE (Resource No.=FIELD(Resource No.));
                                                   OnValidate=VAR
                                                                ResourceUnitOfMeasure@1000 : Record 205;
                                                              BEGIN
                                                                IF CurrFieldNo <> FIELDNO("Work Type Code") THEN
                                                                  TESTFIELD("Work Type Code",'');

                                                                IF "Unit of Measure Code" = '' THEN BEGIN
                                                                  Res.GET("Resource No.");
                                                                  "Unit of Measure Code" := Res."Base Unit of Measure"
                                                                END;
                                                                ResourceUnitOfMeasure.GET("Resource No.","Unit of Measure Code");
                                                                "Qty. per Unit of Measure" := ResourceUnitOfMeasure."Qty. per Unit of Measure";

                                                                FindResUnitCost;
                                                                FindResPrice;

                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 12  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Unit Cost");
                                                                VALIDATE("Unit Price");
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 13  ;   ;Direct Unit Cost    ;Decimal       ;CaptionML=[DAN=K�bspris;
                                                              ENU=Direct Unit Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 14  ;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                "Total Cost" := Quantity * "Unit Cost";
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 15  ;   ;Total Cost          ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Quantity);
                                                                GetGLSetup;
                                                                "Unit Cost" := ROUND("Total Cost" / Quantity,GLSetup."Unit-Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Kostbel�b;
                                                              ENU=Total Cost];
                                                   AutoFormatType=1 }
    { 16  ;   ;Unit Price          ;Decimal       ;OnValidate=BEGIN
                                                                "Total Price" := Quantity * "Unit Price";
                                                              END;

                                                   CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 17  ;   ;Total Price         ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Quantity);
                                                                GetGLSetup;
                                                                "Unit Price" := ROUND("Total Price" / Quantity,GLSetup."Unit-Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Salgsbel�b;
                                                              ENU=Total Price];
                                                   AutoFormatType=1 }
    { 18  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 19  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 21  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code];
                                                   Editable=No }
    { 23  ;   ;Journal Batch Name  ;Code10        ;TableRelation="Res. Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 24  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 25  ;   ;Recurring Method    ;Option        ;CaptionML=[DAN=Gentagelsesprincip;
                                                              ENU=Recurring Method];
                                                   OptionCaptionML=[DAN=,Fast,Variabel;
                                                                    ENU=,Fixed,Variable];
                                                   OptionString=,Fixed,Variable;
                                                   BlankZero=Yes }
    { 26  ;   ;Expiration Date     ;Date          ;CaptionML=[DAN=Udl�bsdato;
                                                              ENU=Expiration Date] }
    { 27  ;   ;Recurring Frequency ;DateFormula   ;CaptionML=[DAN=Gentagelsesinterval;
                                                              ENU=Recurring Frequency] }
    { 28  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 29  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 30  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 31  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 32  ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogf�ringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 33  ;   ;Source Type         ;Option        ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Debitor";
                                                                    ENU=" ,Customer"];
                                                   OptionString=[ ,Customer] }
    { 34  ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) Customer.No.;
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 35  ;   ;Qty. per Unit of Measure;Decimal   ;CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure] }
    { 90  ;   ;Order Type          ;Option        ;CaptionML=[DAN=Ordretype;
                                                              ENU=Order Type];
                                                   OptionCaptionML=[DAN=" ,Produktion,Overf�rsel,Service,Montage";
                                                                    ENU=" ,Production,Transfer,Service,Assembly"];
                                                   OptionString=[ ,Production,Transfer,Service,Assembly];
                                                   Editable=No }
    { 91  ;   ;Order No.           ;Code20        ;CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.];
                                                   Editable=No }
    { 92  ;   ;Order Line No.      ;Integer       ;CaptionML=[DAN=Ordrelinjenr.;
                                                              ENU=Order Line No.];
                                                   Editable=No }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=BEGIN
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 950 ;   ;Time Sheet No.      ;Code20        ;TableRelation="Time Sheet Header";
                                                   CaptionML=[DAN=Timeseddelnr.;
                                                              ENU=Time Sheet No.] }
    { 951 ;   ;Time Sheet Line No. ;Integer       ;TableRelation="Time Sheet Line"."Line No." WHERE (Time Sheet No.=FIELD(Time Sheet No.));
                                                   CaptionML=[DAN=Timeseddellinjenr.;
                                                              ENU=Time Sheet Line No.] }
    { 952 ;   ;Time Sheet Date     ;Date          ;TableRelation="Time Sheet Detail".Date WHERE (Time Sheet No.=FIELD(Time Sheet No.),
                                                                                                 Time Sheet Line No.=FIELD(Time Sheet Line No.));
                                                   CaptionML=[DAN=Dato p� timeseddel;
                                                              ENU=Time Sheet Date] }
    { 959 ;   ;System-Created Entry;Boolean       ;CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Journal Template Name,Journal Batch Name,Line No.;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ResJnlTemplate@1000 : Record 206;
      ResJnlBatch@1001 : Record 236;
      ResJnlLine@1002 : Record 207;
      Res@1003 : Record 156;
      ResCost@1004 : Record 202;
      ResPrice@1005 : Record 201;
      WorkType@1006 : Record 200;
      GLSetup@1012 : Record 98;
      NoSeriesMgt@1009 : Codeunit 396;
      DimMgt@1010 : Codeunit 408;
      GLSetupRead@1011 : Boolean;

    LOCAL PROCEDURE FindResUnitCost@1();
    BEGIN
      ResCost.INIT;
      ResCost.Code := "Resource No.";
      ResCost."Work Type Code" := "Work Type Code";
      CODEUNIT.RUN(CODEUNIT::"Resource-Find Cost",ResCost);
      "Direct Unit Cost" := ResCost."Direct Unit Cost" * "Qty. per Unit of Measure";
      "Unit Cost" := ResCost."Unit Cost" * "Qty. per Unit of Measure";
      VALIDATE("Unit Cost");
    END;

    LOCAL PROCEDURE FindResPrice@2();
    BEGIN
      ResPrice.INIT;
      ResPrice.Code := "Resource No.";
      ResPrice."Work Type Code" := "Work Type Code";
      CODEUNIT.RUN(CODEUNIT::"Resource-Find Price",ResPrice);
      "Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
      VALIDATE("Unit Price");
    END;

    [External]
    PROCEDURE EmptyLine@5() : Boolean;
    BEGIN
      EXIT(("Resource No." = '') AND (Quantity = 0));
    END;

    [External]
    PROCEDURE SetUpNewLine@8(LastResJnlLine@1000 : Record 207);
    BEGIN
      ResJnlTemplate.GET("Journal Template Name");
      ResJnlBatch.GET("Journal Template Name","Journal Batch Name");
      ResJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      ResJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      IF ResJnlLine.FINDFIRST THEN BEGIN
        "Posting Date" := LastResJnlLine."Posting Date";
        "Document Date" := LastResJnlLine."Posting Date";
        "Document No." := LastResJnlLine."Document No.";
      END ELSE BEGIN
        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        IF ResJnlBatch."No. Series" <> '' THEN BEGIN
          CLEAR(NoSeriesMgt);
          "Document No." := NoSeriesMgt.TryGetNextNo(ResJnlBatch."No. Series","Posting Date");
        END;
      END;
      "Recurring Method" := LastResJnlLine."Recurring Method";
      "Source Code" := ResJnlTemplate."Source Code";
      "Reason Code" := ResJnlBatch."Reason Code";
      "Posting No. Series" := ResJnlBatch."Posting No. Series";
    END;

    LOCAL PROCEDURE CreateDim@13(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20]);
    VAR
      TableID@1006 : ARRAY [10] OF Integer;
      No@1007 : ARRAY [10] OF Code[20];
    BEGIN
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,"Source Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@14(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE LookupShortcutDimCode@18(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE ShowShortcutDimCode@15(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    END;

    [External]
    PROCEDURE CopyDocumentFields@129(DocNo@1003 : Code[20];ExtDocNo@1002 : Text[35];SourceCode@1001 : Code[10];NoSeriesCode@1000 : Code[20]);
    BEGIN
      "Document No." := DocNo;
      "External Document No." := ExtDocNo;
      "Source Code" := SourceCode;
      IF NoSeriesCode <> '' THEN
        "Posting No. Series" := NoSeriesCode;
    END;

    [External]
    PROCEDURE CopyFromSalesLine@6(SalesLine@1000 : Record 37);
    BEGIN
      "Resource No." := SalesLine."No.";
      Description := SalesLine.Description;
      "Source Type" := "Source Type"::Customer;
      "Source No." := SalesLine."Sell-to Customer No.";
      "Work Type Code" := SalesLine."Work Type Code";
      "Job No." := SalesLine."Job No.";
      "Unit of Measure Code" := SalesLine."Unit of Measure Code";
      "Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := SalesLine."Dimension Set ID";
      "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
      "Entry Type" := "Entry Type"::Sale;
      "Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
      Quantity := -SalesLine."Qty. to Invoice";
      "Unit Cost" := SalesLine."Unit Cost (LCY)";
      "Total Cost" := SalesLine."Unit Cost (LCY)" * Quantity;
      "Unit Price" := SalesLine."Unit Price";
      "Total Price" := -SalesLine.Amount;

      OnAfterCopyResJnlLineFromSalesLine(SalesLine,ResJnlLine);
    END;

    [External]
    PROCEDURE CopyFromServHeader@11(ServiceHeader@1000 : Record 5900);
    BEGIN
      "Document Date" := ServiceHeader."Document Date";
      "Reason Code" := ServiceHeader."Reason Code";
      "Order No." := ServiceHeader."No.";
    END;

    [External]
    PROCEDURE CopyFromServLine@7(ServiceLine@1000 : Record 5902);
    BEGIN
      "Posting Date" := ServiceLine."Posting Date";
      "Order Type" := "Order Type"::Service;
      "Order Line No." := ServiceLine."Line No.";
      "Resource No." := ServiceLine."No.";
      Description := ServiceLine.Description;
      "Work Type Code" := ServiceLine."Work Type Code";
      "Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServiceLine."Dimension Set ID";
      "Unit of Measure Code" := ServiceLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := ServiceLine."Qty. per Unit of Measure";
      "Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
      "Source Type" := "Source Type"::Customer;
      "Source No." := ServiceLine."Customer No.";
      "Time Sheet No." := ServiceLine."Time Sheet No.";
      "Time Sheet Line No." := ServiceLine."Time Sheet Line No.";
      "Time Sheet Date" := ServiceLine."Time Sheet Date";
      "Job No." := ServiceLine."Job No.";

      OnAfterCopyResJnlLineFromServLine(ServiceLine,ResJnlLine);
    END;

    [External]
    PROCEDURE CopyFromServShptHeader@10(ServShptHeader@1000 : Record 5990);
    BEGIN
      "Document Date" := ServShptHeader."Document Date";
      "Reason Code" := ServShptHeader."Reason Code";
      "Source Type" := "Source Type"::Customer;
      "Source No." := ServShptHeader."Customer No.";
    END;

    [External]
    PROCEDURE CopyFromServShptLine@9(ServShptLine@1000 : Record 5991);
    BEGIN
      "Posting Date" := ServShptLine."Posting Date";
      "Resource No." := ServShptLine."No.";
      Description := ServShptLine.Description;
      "Work Type Code" := ServShptLine."Work Type Code";
      "Unit of Measure Code" := ServShptLine."Unit of Measure Code";
      "Qty. per Unit of Measure" := ServShptLine."Qty. per Unit of Measure";
      "Shortcut Dimension 1 Code" := ServShptLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := ServShptLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServShptLine."Dimension Set ID";
      "Gen. Bus. Posting Group" := ServShptLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServShptLine."Gen. Prod. Posting Group";
      "Entry Type" := "Entry Type"::Usage;

      OnAfterCopyResJnlLineFromServShptLine(ServShptLine,ResJnlLine);
    END;

    [External]
    PROCEDURE CopyFromJobJnlLine@22(JobJnlLine@1000 : Record 210);
    BEGIN
      "Entry Type" := JobJnlLine."Entry Type";
      "Document No." := JobJnlLine."Document No.";
      "External Document No." := JobJnlLine."External Document No.";
      "Posting Date" := JobJnlLine."Posting Date";
      "Document Date" := JobJnlLine."Document Date";
      "Resource No." := JobJnlLine."No.";
      Description := JobJnlLine.Description;
      "Work Type Code" := JobJnlLine."Work Type Code";
      "Job No." := JobJnlLine."Job No.";
      "Shortcut Dimension 1 Code" := JobJnlLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := JobJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := JobJnlLine."Dimension Set ID";
      "Unit of Measure Code" := JobJnlLine."Unit of Measure Code";
      "Source Code" := JobJnlLine."Source Code";
      "Gen. Bus. Posting Group" := JobJnlLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := JobJnlLine."Gen. Prod. Posting Group";
      "Posting No. Series" := JobJnlLine."Posting No. Series";
      "Reason Code" := JobJnlLine."Reason Code";
      "Resource Group No." := JobJnlLine."Resource Group No.";
      "Recurring Method" := JobJnlLine."Recurring Method";
      "Expiration Date" := JobJnlLine."Expiration Date";
      "Recurring Frequency" := JobJnlLine."Recurring Frequency";
      Quantity := JobJnlLine.Quantity;
      "Qty. per Unit of Measure" := JobJnlLine."Qty. per Unit of Measure";
      "Direct Unit Cost" := JobJnlLine."Direct Unit Cost (LCY)";
      "Unit Cost" := JobJnlLine."Unit Cost (LCY)";
      "Total Cost" := JobJnlLine."Total Cost (LCY)";
      "Unit Price" := JobJnlLine."Unit Price (LCY)";
      "Total Price" := JobJnlLine."Line Amount (LCY)";
      "Time Sheet No." := JobJnlLine."Time Sheet No.";
      "Time Sheet Line No." := JobJnlLine."Time Sheet Line No.";
      "Time Sheet Date" := JobJnlLine."Time Sheet Date";

      OnAfterCopyResJnlLineFromJobJnlLine(Rec,JobJnlLine);
    END;

    LOCAL PROCEDURE GetGLSetup@3();
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    [External]
    PROCEDURE ShowDimensions@4();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."));
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE IsOpenedFromBatch@42() : Boolean;
    VAR
      ResJournalBatch@1002 : Record 236;
      TemplateFilter@1001 : Text;
      BatchFilter@1000 : Text;
    BEGIN
      BatchFilter := GETFILTER("Journal Batch Name");
      IF BatchFilter <> '' THEN BEGIN
        TemplateFilter := GETFILTER("Journal Template Name");
        IF TemplateFilter <> '' THEN
          ResJournalBatch.SETFILTER("Journal Template Name",TemplateFilter);
        ResJournalBatch.SETFILTER(Name,BatchFilter);
        ResJournalBatch.FINDFIRST;
      END;

      EXIT((("Journal Batch Name" <> '') AND ("Journal Template Name" = '')) OR (BatchFilter <> ''));
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyResJnlLineFromSalesLine@12(VAR SalesLine@1000 : Record 37;VAR ResJnlLine@1001 : Record 207);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyResJnlLineFromServLine@16(VAR ServLine@1000 : Record 5902;VAR ResJnlLine@1001 : Record 207);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyResJnlLineFromServShptLine@17(VAR ServShptLine@1000 : Record 5991;VAR ResJnlLine@1001 : Record 207);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyResJnlLineFromJobJnlLine@19(VAR ResJnlLine@1000 : Record 207;JobJnlLine@1001 : Record 210);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@164(VAR ResJournalLine@1000 : Record 207;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

