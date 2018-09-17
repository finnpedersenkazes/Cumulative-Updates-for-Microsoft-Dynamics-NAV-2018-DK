OBJECT Table 5940 Service Item
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Description;
    OnInsert=BEGIN
               ServMgtSetup.GET ;
               IF "No." = '' THEN BEGIN
                 ServMgtSetup.TESTFIELD("Service Item Nos.");
                 NoSeriesMgt.InitSeries(ServMgtSetup."Service Item Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;
               "Response Time (Hours)" := ServMgtSetup."Default Response Time (Hours)";

               ServLogMgt.ServItemCreated(Rec);
             END;

    OnDelete=VAR
               ResultDescription@1000 : Text;
             BEGIN
               MoveEntries.MoveServiceItemLedgerEntries(Rec);

               ResultDescription := CheckIfCanBeDeleted;
               IF ResultDescription <> '' THEN
                 ERROR(ResultDescription);

               DeleteServItemComponents;

               ServCommentLine.RESET;
               ServCommentLine.SETRANGE("Table Name",ServCommentLine."Table Name"::"Service Item");
               ServCommentLine.SETRANGE("Table Subtype",0);
               ServCommentLine.SETRANGE("No.","No.");
               ServCommentLine.DELETEALL;

               ResSkillMgt.DeleteServItemResSkills("No.");
               ServLogMgt.ServItemDeleted("No.");

               DimMgt.DeleteDefaultDim(DATABASE::"Service Item","No.");
             END;

    OnRename=BEGIN
               IF "No." <> xRec."No." THEN BEGIN
                 ServLogMgt.ServItemNoChange(Rec,xRec);
                 ServContractLine.RESET;
                 ServContractLine.SETCURRENTKEY("Service Item No.","Contract Status");
                 ServContractLine.SETRANGE("Service Item No.",xRec."No.");
                 ServContractLine.SETRANGE("Contract Type",ServContractLine."Contract Type"::Contract);
                 IF ServContractLine.FIND('-') THEN
                   REPEAT
                     ContractChangeLog.LogContractChange(
                       ServContractLine."Contract No.",1,
                       ServContractLine.FIELDCAPTION("Service Item No."),3,
                       xRec."No.","No.","No.",0);
                   UNTIL ServContractLine.NEXT = 0;
               END;
             END;

    CaptionML=[DAN=Serviceartikel;
               ENU=Service Item];
    LookupPageID=Page5981;
    DrillDownPageID=Page5981;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  ServMgtSetup.GET;
                                                                  NoSeriesMgt.TestManual(ServMgtSetup."Service Item Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   AltSearchField=Search Description;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Serial No.          ;Code20        ;OnValidate=BEGIN
                                                                IF "Serial No." <> xRec."Serial No." THEN
                                                                  MessageIfServItemLinesExist(FIELDCAPTION("Serial No."));

                                                                IF "Serial No." <> '' THEN BEGIN
                                                                  ServItem.RESET;
                                                                  ServItem.SETCURRENTKEY("Item No.","Serial No.");
                                                                  ServItem.SETRANGE("Item No.","Item No.");
                                                                  ServItem.SETRANGE("Serial No.","Serial No.");
                                                                  ServItem.SETFILTER("No.",'<>%1',"No.");
                                                                  IF ServItem.FINDFIRST THEN BEGIN
                                                                    IF "Item No." <> '' THEN
                                                                      ERROR(
                                                                        Text003,
                                                                        FIELDCAPTION("Serial No."),"Serial No.",TABLECAPTION,ServItem."No.");
                                                                    MESSAGE(
                                                                      Text003,
                                                                      FIELDCAPTION("Serial No."),"Serial No.",TABLECAPTION,ServItem."No.")
                                                                  END;
                                                                END;

                                                                IF "Serial No." <> xRec."Serial No." THEN
                                                                  ServLogMgt.ServItemSerialNoChange(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
    { 3   ;   ;Service Item Group Code;Code10     ;TableRelation="Service Item Group";
                                                   OnValidate=BEGIN
                                                                IF xRec."Service Item Group Code" = "Service Item Group Code" THEN BEGIN
                                                                  IF NOT CancelResSkillAssignment THEN
                                                                    ResSkillMgt.RevalidateRelation(
                                                                      ResSkill.Type::"Service Item",
                                                                      "No.",
                                                                      ResSkill.Type::"Service Item Group",
                                                                      "Service Item Group Code")
                                                                END ELSE BEGIN
                                                                  IF NOT CancelResSkillAssignment THEN BEGIN
                                                                    IF CancelResSkillChanges THEN
                                                                      ResSkillMgt.SkipValidationDialogs;

                                                                    IF NOT ResSkillMgt.ChangeRelationWithGroup(
                                                                         ResSkill.Type::"Service Item",
                                                                         "No.",
                                                                         ResSkill.Type::"Service Item Group",
                                                                         "Service Item Group Code",
                                                                         xRec."Service Item Group Code")
                                                                    THEN
                                                                      ERROR('');

                                                                    IF CancelResSkillChanges THEN BEGIN
                                                                      ResSkillMgt.DropGlobals;
                                                                      CancelResSkillChanges := FALSE;
                                                                    END ELSE
                                                                      CancelResSkillChanges := TRUE;
                                                                  END;

                                                                  IF "Service Item Group Code" <> '' THEN BEGIN
                                                                    ServItemGr.GET("Service Item Group Code");
                                                                    "Default Contract Discount %" := ServItemGr."Default Contract Discount %";
                                                                    IF "Service Price Group Code" = '' THEN
                                                                      "Service Price Group Code" := ServItemGr."Default Serv. Price Group Code";
                                                                    IF (xRec."Service Item Group Code" <> "Service Item Group Code") AND
                                                                       (ServItemGr."Default Response Time (Hours)" <> 0)
                                                                    THEN
                                                                      "Response Time (Hours)" := ServItemGr."Default Response Time (Hours)";
                                                                  END;
                                                                END;
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Serviceartikelgruppekode;
                                                              ENU=Service Item Group Code] }
    { 4   ;   ;Description         ;Text50        ;OnValidate=BEGIN
                                                                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                                                                  "Search Description" := Description;
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 5   ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 6   ;   ;Status              ;Option        ;OnValidate=BEGIN
                                                                IF Status <> xRec.Status THEN BEGIN
                                                                  IF (Status = Status::Installed) AND ("Installation Date" = 0D) THEN
                                                                    "Installation Date" := WORKDATE;
                                                                  ServLogMgt.ServItemStatusChange(Rec,xRec);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=" ,Egen serviceartikel,Installeret,Midlertidig installeret,Defekt";
                                                                    ENU=" ,Own Service Item,Installed,Temporarily Installed,Defective"];
                                                   OptionString=[ ,Own Service Item,Installed,Temporarily Installed,Defective] }
    { 7   ;   ;Priority            ;Option        ;CaptionML=[DAN=Prioritet;
                                                              ENU=Priority];
                                                   OptionCaptionML=[DAN=Lav,Medium,H�j;
                                                                    ENU=Low,Medium,High];
                                                   OptionString=Low,Medium,High }
    { 8   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   OnValidate=BEGIN
                                                                IF "Customer No." <> xRec."Customer No." THEN BEGIN
                                                                  IF CheckifActiveServContLineExist THEN
                                                                    ERROR(
                                                                      Text004,
                                                                      FIELDCAPTION("Customer No."),"Customer No.",TABLECAPTION,"No.");
                                                                  ServItemLinesExistErr(FIELDCAPTION("Customer No."));
                                                                  IF ServLedgEntryExist THEN
                                                                    IF NOT CONFIRM(
                                                                         Text017,
                                                                         FALSE,TABLECAPTION,FIELDCAPTION("Customer No."))
                                                                    THEN BEGIN
                                                                      "Customer No." := xRec."Customer No.";
                                                                      EXIT;
                                                                    END;
                                                                  "Ship-to Code" := '';
                                                                  IF ("Customer No." <> '') AND
                                                                     (xRec."Customer No." = '')
                                                                  THEN
                                                                    Status := Status::Installed;
                                                                  ServLogMgt.ServItemCustChange(Rec,xRec);
                                                                  ServLogMgt.ServItemShipToCodeChange(Rec,xRec);
                                                                END;
                                                              END;

                                                   ValidateTableRelation=Yes;
                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.] }
    { 9   ;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Customer No.));
                                                   OnValidate=BEGIN
                                                                IF "Ship-to Code" <> xRec."Ship-to Code" THEN BEGIN
                                                                  IF CheckifActiveServContLineExist THEN
                                                                    ERROR(
                                                                      Text004,
                                                                      FIELDCAPTION("Ship-to Code"),"Ship-to Code",TABLECAPTION,"No.");
                                                                  ServItemLinesExistErr(FIELDCAPTION("Ship-to Code"));
                                                                  IF ServLedgEntryExist THEN
                                                                    IF NOT CONFIRM(
                                                                         Text017,
                                                                         FALSE,TABLECAPTION,FIELDCAPTION("Customer No."))
                                                                    THEN BEGIN
                                                                      "Ship-to Code" := xRec."Ship-to Code";
                                                                      EXIT;
                                                                    END;
                                                                  ServLogMgt.ServItemShipToCodeChange(Rec,xRec);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Leveringsadressekode;
                                                              ENU=Ship-to Code] }
    { 10  ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   OnValidate=BEGIN
                                                                IF "Item No." <> xRec."Item No." THEN BEGIN
                                                                  IF "Item No." <> '' THEN BEGIN
                                                                    CALCFIELDS("Service Item Components");
                                                                    IF "Service Item Components" THEN
                                                                      IF NOT CONFIRM(
                                                                           Text005 +
                                                                           Text006,FALSE,
                                                                           FIELDCAPTION("Item No."),FIELDCAPTION("Service Item Components"))
                                                                      THEN BEGIN
                                                                        "Item No." := xRec."Item No.";
                                                                        EXIT;
                                                                      END;
                                                                  END;
                                                                  IF NOT CancelResSkillAssignment THEN BEGIN
                                                                    IF CancelResSkillChanges THEN
                                                                      ResSkillMgt.SkipValidationDialogs;
                                                                    IF NOT ResSkillMgt.ChangeRelationWithItem(
                                                                         ResSkill.Type::"Service Item",
                                                                         "No.",
                                                                         ResSkill.Type::Item,
                                                                         "Item No.",
                                                                         xRec."Item No.",
                                                                         xRec."Service Item Group Code")
                                                                    THEN
                                                                      ERROR('');
                                                                    IF CancelResSkillChanges THEN BEGIN
                                                                      ResSkillMgt.DropGlobals;
                                                                      CancelResSkillChanges := FALSE;
                                                                    END ELSE
                                                                      CancelResSkillChanges := TRUE;
                                                                  END;
                                                                  IF "Item No." <> '' THEN BEGIN
                                                                    Item.GET("Item No.");
                                                                    VALIDATE("Service Item Group Code",Item."Service Item Group");
                                                                    VALIDATE("Serial No.");
                                                                    VALIDATE("Sales Unit Cost",Item."Unit Cost");
                                                                    VALIDATE("Sales Unit Price",Item."Unit Price");
                                                                    "Variant Code" := '';
                                                                    "Unit of Measure Code" := Item."Base Unit of Measure";
                                                                    IF Description = '' THEN
                                                                      VALIDATE(Description,Item.Description);
                                                                    IF "Service Item Components" THEN BEGIN
                                                                      DeleteServItemComponents;
                                                                      CALCFIELDS("Service Item Components");
                                                                    END;
                                                                  END ELSE BEGIN
                                                                    "Serial No." := '';
                                                                    VALIDATE("Sales Unit Price",0);
                                                                    VALIDATE("Sales Unit Cost",0);
                                                                    "Variant Code" := '';
                                                                    "Service Item Group Code" := '';
                                                                    "Unit of Measure Code" := '';
                                                                  END;
                                                                  MessageIfServItemLinesExist(FIELDCAPTION("Item No."));
                                                                END ELSE
                                                                  IF NOT CancelResSkillAssignment THEN
                                                                    ResSkillMgt.RevalidateRelation(
                                                                      ResSkill.Type::"Service Item",
                                                                      "No.",
                                                                      ResSkill.Type::Item,
                                                                      "Item No.");

                                                                ServLogMgt.ServItemItemNoChange(Rec,xRec);
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 11  ;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Item No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.))
                                                                 ELSE "Unit of Measure";
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 12  ;   ;Location of Service Item;Text30    ;CaptionML=[DAN=Serviceartikellokation;
                                                              ENU=Location of Service Item] }
    { 13  ;   ;Sales Unit Price    ;Decimal       ;OnValidate=BEGIN
                                                                ServMgtSetup.GET;
                                                                Currency.InitRoundingPrecision;
                                                                IF (ServMgtSetup."Contract Value Calc. Method" =
                                                                    ServMgtSetup."Contract Value Calc. Method"::"Based on Unit Price") AND
                                                                   ("Sales Unit Price" <> xRec."Sales Unit Price")
                                                                THEN
                                                                  "Default Contract Value" :=
                                                                    ROUND("Sales Unit Price" * ServMgtSetup."Contract Value %" / 100,
                                                                      Currency."Unit-Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Salgsenhedspris;
                                                              ENU=Sales Unit Price];
                                                   BlankZero=Yes;
                                                   AutoFormatType=2 }
    { 14  ;   ;Sales Unit Cost     ;Decimal       ;OnValidate=BEGIN
                                                                ServMgtSetup.GET;
                                                                Currency.InitRoundingPrecision;
                                                                "Default Contract Cost" :=
                                                                  ROUND("Sales Unit Cost" * ServMgtSetup."Contract Value %" / 100,
                                                                    Currency."Unit-Amount Rounding Precision");
                                                                IF (ServMgtSetup."Contract Value Calc. Method" =
                                                                    ServMgtSetup."Contract Value Calc. Method"::"Based on Unit Cost") AND
                                                                   ("Sales Unit Cost" <> xRec."Sales Unit Cost")
                                                                THEN
                                                                  "Default Contract Value" := "Default Contract Cost";
                                                              END;

                                                   CaptionML=[DAN=Enhedsomkostninger;
                                                              ENU=Sales Unit Cost];
                                                   BlankZero=Yes;
                                                   AutoFormatType=2 }
    { 15  ;   ;Warranty Starting Date (Labor);Date;OnValidate=BEGIN
                                                                IF "Warranty Starting Date (Labor)" <> xRec."Warranty Starting Date (Labor)" THEN
                                                                  MessageIfServItemLinesExist(FIELDCAPTION("Warranty Starting Date (Labor)"));

                                                                ServMgtSetup.GET;
                                                                ServMgtSetup.TESTFIELD("Default Warranty Duration");
                                                                IF "Warranty Starting Date (Labor)" <> xRec."Warranty Starting Date (Labor)" THEN
                                                                  IF "Warranty Starting Date (Labor)" <> 0D THEN
                                                                    VALIDATE("Warranty Ending Date (Labor)",CALCDATE(ServMgtSetup."Default Warranty Duration","Warranty Starting Date (Labor)"))
                                                                  ELSE
                                                                    "Warranty Ending Date (Labor)" := 0D;

                                                                IF "Warranty Starting Date (Labor)" <> 0D THEN
                                                                  IF "Warranty Starting Date (Parts)" = 0D THEN
                                                                    VALIDATE("Warranty Starting Date (Parts)","Warranty Starting Date (Labor)");
                                                              END;

                                                   CaptionML=[DAN=Garantistartdato (arbejde);
                                                              ENU=Warranty Starting Date (Labor)] }
    { 16  ;   ;Warranty Ending Date (Labor);Date  ;OnValidate=BEGIN
                                                                IF "Warranty Ending Date (Labor)" <> xRec."Warranty Ending Date (Labor)" THEN
                                                                  MessageIfServItemLinesExist(FIELDCAPTION("Warranty Ending Date (Labor)"));

                                                                IF "Warranty Ending Date (Labor)" < "Warranty Starting Date (Labor)" THEN
                                                                  ERROR(
                                                                    Text007,
                                                                    FIELDCAPTION("Warranty Starting Date (Labor)"),FIELDCAPTION("Warranty Ending Date (Labor)"));

                                                                ServMgtSetup.GET;
                                                                IF "Warranty % (Labor)" = 0 THEN
                                                                  "Warranty % (Labor)" := ServMgtSetup."Warranty Disc. % (Labor)";
                                                              END;

                                                   CaptionML=[DAN=Garantislutdato (arbejde);
                                                              ENU=Warranty Ending Date (Labor)] }
    { 17  ;   ;Warranty Starting Date (Parts);Date;OnValidate=VAR
                                                                ItemTrackingCode@1000 : Record 6502;
                                                              BEGIN
                                                                IF "Warranty Starting Date (Parts)" <> xRec."Warranty Starting Date (Parts)" THEN
                                                                  MessageIfServItemLinesExist(FIELDCAPTION("Warranty Starting Date (Parts)"));

                                                                IF "Warranty Starting Date (Parts)" <> xRec."Warranty Starting Date (Parts)" THEN
                                                                  IF "Warranty Starting Date (Parts)" <> 0D THEN BEGIN
                                                                    IF Item.GET("Item No.") AND (Item."Item Tracking Code" <> '') AND
                                                                       ItemTrackingCode.GET(Item."Item Tracking Code") AND
                                                                       (FORMAT(ItemTrackingCode."Warranty Date Formula") <> '')
                                                                    THEN
                                                                      VALIDATE(
                                                                        "Warranty Ending Date (Parts)",
                                                                        CALCDATE(ItemTrackingCode."Warranty Date Formula",
                                                                          "Warranty Starting Date (Parts)"))
                                                                    ELSE BEGIN
                                                                      ServMgtSetup.GET;
                                                                      ServMgtSetup.TESTFIELD("Default Warranty Duration");
                                                                      VALIDATE(
                                                                        "Warranty Ending Date (Parts)",
                                                                        CALCDATE(ServMgtSetup."Default Warranty Duration",
                                                                          "Warranty Starting Date (Parts)"));
                                                                    END;
                                                                  END ELSE
                                                                    "Warranty Ending Date (Parts)" := 0D;

                                                                IF "Warranty Starting Date (Parts)" <> 0D THEN
                                                                  IF "Warranty Starting Date (Labor)" = 0D THEN
                                                                    VALIDATE("Warranty Starting Date (Labor)","Warranty Starting Date (Parts)");
                                                              END;

                                                   CaptionML=[DAN=Garantistartdato (dele);
                                                              ENU=Warranty Starting Date (Parts)] }
    { 18  ;   ;Warranty Ending Date (Parts);Date  ;OnValidate=BEGIN
                                                                IF "Warranty Ending Date (Parts)" < "Warranty Starting Date (Parts)" THEN
                                                                  ERROR(
                                                                    Text007,
                                                                    FIELDCAPTION("Warranty Starting Date (Parts)"),FIELDCAPTION("Warranty Ending Date (Parts)"));

                                                                IF "Warranty Ending Date (Parts)" <> xRec."Warranty Ending Date (Parts)" THEN
                                                                  MessageIfServItemLinesExist(FIELDCAPTION("Warranty Ending Date (Parts)"));

                                                                ServMgtSetup.GET;
                                                                IF "Warranty % (Parts)" = 0 THEN
                                                                  "Warranty % (Parts)" := ServMgtSetup."Warranty Disc. % (Parts)";
                                                              END;

                                                   CaptionML=[DAN=Garantislutdato (dele);
                                                              ENU=Warranty Ending Date (Parts)] }
    { 19  ;   ;Warranty % (Parts)  ;Decimal       ;OnValidate=BEGIN
                                                                IF "Warranty % (Parts)" <> xRec."Warranty % (Parts)" THEN
                                                                  MessageIfServItemLinesExist(FIELDCAPTION("Warranty % (Parts)"));
                                                              END;

                                                   CaptionML=[DAN=Garantipct. (dele);
                                                              ENU=Warranty % (Parts)];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   BlankZero=Yes }
    { 20  ;   ;Warranty % (Labor)  ;Decimal       ;OnValidate=BEGIN
                                                                IF "Warranty % (Labor)" <> xRec."Warranty % (Labor)" THEN
                                                                  MessageIfServItemLinesExist(FIELDCAPTION("Warranty % (Labor)"));
                                                              END;

                                                   CaptionML=[DAN=Garantipct. (arbejde);
                                                              ENU=Warranty % (Labor)];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   BlankZero=Yes }
    { 21  ;   ;Response Time (Hours);Decimal      ;CaptionML=[DAN=Svartid (timer);
                                                              ENU=Response Time (Hours)];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   BlankZero=Yes }
    { 22  ;   ;Installation Date   ;Date          ;CaptionML=[DAN=Installationsdato;
                                                              ENU=Installation Date] }
    { 23  ;   ;Sales Date          ;Date          ;OnValidate=BEGIN
                                                                IF "Sales Date" > 0D THEN BEGIN
                                                                  IF "Warranty Starting Date (Parts)" = 0D THEN
                                                                    VALIDATE("Warranty Starting Date (Parts)","Sales Date");
                                                                  IF "Warranty Starting Date (Labor)" = 0D THEN
                                                                    VALIDATE("Warranty Starting Date (Labor)","Sales Date");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Salgsdato;
                                                              ENU=Sales Date] }
    { 24  ;   ;Last Service Date   ;Date          ;CaptionML=[DAN=Sidste servicedato;
                                                              ENU=Last Service Date] }
    { 25  ;   ;Default Contract Value;Decimal     ;CaptionML=[DAN=Standardkontraktv�rdi;
                                                              ENU=Default Contract Value];
                                                   BlankZero=Yes;
                                                   AutoFormatType=2 }
    { 26  ;   ;Default Contract Discount %;Decimal;CaptionML=[DAN=Kontraktrabatpct. (standard);
                                                              ENU=Default Contract Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   BlankZero=Yes }
    { 28  ;   ;No. of Active Contracts;Integer    ;FieldClass=FlowField;
                                                   CalcFormula=Count("Service Contract Line" WHERE (Service Item No.=FIELD(No.),
                                                                                                    Contract Status=FILTER(<>Cancelled)));
                                                   CaptionML=[DAN=Antal aktive kontrakter;
                                                              ENU=No. of Active Contracts] }
    { 33  ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Leverand�rnr.;
                                                              ENU=Vendor No.] }
    { 34  ;   ;Vendor Item No.     ;Code20        ;CaptionML=[DAN=Leverand�rs varenr.;
                                                              ENU=Vendor Item No.] }
    { 47  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 48  ;   ;Item Description    ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Item.Description WHERE (No.=FIELD(Item No.)));
                                                   CaptionML=[DAN=Varebeskrivelse;
                                                              ENU=Item Description];
                                                   Editable=No }
    { 49  ;   ;Name                ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.Name WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   Editable=No }
    { 50  ;   ;Address             ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.Address WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Adresse;
                                                              ENU=Address];
                                                   Editable=No }
    { 51  ;   ;Address 2           ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Address 2" WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2];
                                                   Editable=No }
    { 52  ;   ;Post Code           ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Post Code" WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code];
                                                   Editable=No }
    { 53  ;   ;City                ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.City WHERE (No.=FIELD(Customer No.)));
                                                   TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City];
                                                   Editable=No }
    { 54  ;   ;Contact             ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.Contact WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Kontakt;
                                                              ENU=Contact];
                                                   Editable=No }
    { 55  ;   ;Phone No.           ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Phone No." WHERE (No.=FIELD(Customer No.)));
                                                   ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.];
                                                   Editable=No }
    { 56  ;   ;Ship-to Name        ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address".Name WHERE (Customer No.=FIELD(Customer No.),
                                                                                                    Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsnavn;
                                                              ENU=Ship-to Name];
                                                   Editable=No }
    { 57  ;   ;Ship-to Address     ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address".Address WHERE (Customer No.=FIELD(Customer No.),
                                                                                                       Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsadresse;
                                                              ENU=Ship-to Address];
                                                   Editable=No }
    { 58  ;   ;Ship-to Address 2   ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address"."Address 2" WHERE (Customer No.=FIELD(Customer No.),
                                                                                                           Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsadresse 2;
                                                              ENU=Ship-to Address 2];
                                                   Editable=No }
    { 59  ;   ;Ship-to Post Code   ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address"."Post Code" WHERE (Customer No.=FIELD(Customer No.),
                                                                                                           Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringspostnr.;
                                                              ENU=Ship-to Post Code];
                                                   Editable=No }
    { 60  ;   ;Ship-to City        ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address".City WHERE (Customer No.=FIELD(Customer No.),
                                                                                                    Code=FIELD(Ship-to Code)));
                                                   TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Leveringsby;
                                                              ENU=Ship-to City];
                                                   Editable=No }
    { 61  ;   ;Ship-to Contact     ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address".Contact WHERE (Customer No.=FIELD(Customer No.),
                                                                                                       Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveres attention;
                                                              ENU=Ship-to Contact];
                                                   Editable=No }
    { 62  ;   ;Ship-to Phone No.   ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address"."Phone No." WHERE (Customer No.=FIELD(Customer No.),
                                                                                                           Code=FIELD(Ship-to Code)));
                                                   ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Leveringstelefonnr.;
                                                              ENU=Ship-to Phone No.];
                                                   Editable=No }
    { 63  ;   ;Usage (Cost)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Ledger Entry"."Cost Amount" WHERE (Entry Type=CONST(Usage),
                                                                                                               Service Item No. (Serviced)=FIELD(No.),
                                                                                                               Service Contract No.=FIELD(Contract Filter),
                                                                                                               Service Order No.=FIELD(Service Order Filter),
                                                                                                               Type=FIELD(Type Filter),
                                                                                                               Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forbrug (kostpris);
                                                              ENU=Usage (Cost)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 64  ;   ;Usage (Amount)      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Ledger Entry"."Amount (LCY)" WHERE (Entry Type=CONST(Usage),
                                                                                                                Service Item No. (Serviced)=FIELD(No.),
                                                                                                                Service Contract No.=FIELD(Contract Filter),
                                                                                                                Service Order No.=FIELD(Service Order Filter),
                                                                                                                Type=FIELD(Type Filter),
                                                                                                                Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forbrug (bel�b);
                                                              ENU=Usage (Amount)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 65  ;   ;Invoiced Amount     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Service Ledger Entry"."Amount (LCY)" WHERE (Entry Type=CONST(Sale),
                                                                                                                 Moved from Prepaid Acc.=CONST(Yes),
                                                                                                                 Service Item No. (Serviced)=FIELD(No.),
                                                                                                                 Service Contract No.=FIELD(Contract Filter),
                                                                                                                 Service Order No.=FIELD(Service Order Filter),
                                                                                                                 Type=FIELD(Type Filter),
                                                                                                                 Posting Date=FIELD(Date Filter),
                                                                                                                 Open=CONST(No)));
                                                   CaptionML=[DAN=Faktureret bel�b;
                                                              ENU=Invoiced Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 66  ;   ;Total Quantity      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Ledger Entry".Quantity WHERE (Entry Type=CONST(Usage),
                                                                                                          Service Item No. (Serviced)=FIELD(No.),
                                                                                                          Service Contract No.=FIELD(Contract Filter),
                                                                                                          Service Order No.=FIELD(Service Order Filter),
                                                                                                          Type=FIELD(Type Filter),
                                                                                                          Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=I alt;
                                                              ENU=Total Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 67  ;   ;Total Qty. Invoiced ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Service Ledger Entry"."Charged Qty." WHERE (Entry Type=CONST(Sale),
                                                                                                                 Service Item No. (Serviced)=FIELD(No.),
                                                                                                                 Service Contract No.=FIELD(Contract Filter),
                                                                                                                 Service Order No.=FIELD(Service Order Filter),
                                                                                                                 Type=FIELD(Type Filter),
                                                                                                                 Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Antal faktureret i alt;
                                                              ENU=Total Qty. Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 68  ;   ;Resources Used      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Service Ledger Entry"."Cost Amount" WHERE (Service Item No. (Serviced)=FIELD(No.),
                                                                                                                Entry Type=CONST(Sale),
                                                                                                                Type=CONST(Resource),
                                                                                                                Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Brugte ressourcer;
                                                              ENU=Resources Used];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 69  ;   ;Parts Used          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Service Ledger Entry"."Cost Amount" WHERE (Service Item No. (Serviced)=FIELD(No.),
                                                                                                                Entry Type=CONST(Sale),
                                                                                                                Type=CONST(Item),
                                                                                                                Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Brugte komp.;
                                                              ENU=Parts Used];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 70  ;   ;Cost Used           ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Service Ledger Entry"."Cost Amount" WHERE (Service Item No. (Serviced)=FIELD(No.),
                                                                                                                Entry Type=CONST(Sale),
                                                                                                                Type=CONST(Service Cost),
                                                                                                                Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Omkostninger;
                                                              ENU=Cost Used];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 71  ;   ;Vendor Name         ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Vendor.Name WHERE (No.=FIELD(Vendor No.)));
                                                   CaptionML=[DAN=Kreditornavn;
                                                              ENU=Vendor Name];
                                                   Editable=No }
    { 72  ;   ;Vendor Item Name    ;Text50        ;CaptionML=[DAN=Leverand�rnavn;
                                                              ENU=Vendor Item Name] }
    { 73  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Service Comment Line" WHERE (Table Name=CONST(Service Item),
                                                                                                   Table Subtype=CONST(0),
                                                                                                   No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 74  ;   ;Service Item Components;Boolean    ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Service Item Component" WHERE (Parent Service Item No.=FIELD(No.),
                                                                                                     Active=CONST(Yes)));
                                                   CaptionML=[DAN=Serviceartikelkomponenter;
                                                              ENU=Service Item Components];
                                                   Editable=No }
    { 75  ;   ;Preferred Resource  ;Code20        ;TableRelation=Resource.No.;
                                                   OnLookup=VAR
                                                              Resource@1001 : Record 156;
                                                              SkilledResourceList@1000 : Page 6023;
                                                            BEGIN
                                                              SkilledResourceList.Initialize(ResSkill.Type::"Service Item","No.",Description);
                                                              SkilledResourceList.LOOKUPMODE(TRUE);
                                                              IF Resource.GET("Preferred Resource") THEN
                                                                SkilledResourceList.SETRECORD(Resource);
                                                              IF SkilledResourceList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                                                SkilledResourceList.GETRECORD(Resource);
                                                                "Preferred Resource" := Resource."No.";
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Foretrukken ressource;
                                                              ENU=Preferred Resource] }
    { 76  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=BEGIN
                                                                IF "Variant Code" <> xRec."Variant Code" THEN
                                                                  MessageIfServItemLinesExist(FIELDCAPTION("Variant Code"));
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 77  ;   ;County              ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.County WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Amt;
                                                              ENU=County];
                                                   Editable=No }
    { 78  ;   ;Ship-to County      ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address".County WHERE (Customer No.=FIELD(Customer No.),
                                                                                                      Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsamt;
                                                              ENU=Ship-to County];
                                                   Editable=No }
    { 79  ;   ;Contract Cost       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Service Ledger Entry"."Cost Amount" WHERE (Entry Type=CONST(Sale),
                                                                                                                Service Item No. (Serviced)=FIELD(No.),
                                                                                                                Service Contract No.=FIELD(Contract Filter),
                                                                                                                Service Order No.=FIELD(Service Order Filter),
                                                                                                                Type=CONST(Service Contract),
                                                                                                                Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kontraktomkostning;
                                                              ENU=Contract Cost] }
    { 81  ;   ;Country/Region Code ;Code10        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Country/Region Code" WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code];
                                                   Editable=No }
    { 82  ;   ;Ship-to Country/Region Code;Code10 ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address"."Country/Region Code" WHERE (Customer No.=FIELD(Customer No.),
                                                                                                                     Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Lande-/omr�dekode for levering;
                                                              ENU=Ship-to Country/Region Code];
                                                   Editable=No }
    { 83  ;   ;Name 2              ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Name 2" WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2];
                                                   Editable=No }
    { 84  ;   ;Ship-to Name 2      ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address"."Name 2" WHERE (Customer No.=FIELD(Customer No.),
                                                                                                        Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsnavn 2;
                                                              ENU=Ship-to Name 2];
                                                   Editable=No }
    { 85  ;   ;Service Price Group Code;Code10    ;TableRelation="Service Price Group";
                                                   CaptionML=[DAN=Serviceprisgruppekode;
                                                              ENU=Service Price Group Code] }
    { 86  ;   ;Default Contract Cost;Decimal      ;CaptionML=[DAN=Kontraktkostpris (standard);
                                                              ENU=Default Contract Cost];
                                                   BlankZero=Yes;
                                                   AutoFormatType=2 }
    { 87  ;   ;Prepaid Amount      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Service Ledger Entry"."Amount (LCY)" WHERE (Entry Type=CONST(Sale),
                                                                                                                 Moved from Prepaid Acc.=CONST(No),
                                                                                                                 Service Item No. (Serviced)=FIELD(No.),
                                                                                                                 Service Contract No.=FIELD(Contract Filter),
                                                                                                                 Service Order No.=FIELD(Service Order Filter),
                                                                                                                 Type=FIELD(Type Filter),
                                                                                                                 Posting Date=FIELD(Date Filter),
                                                                                                                 Open=CONST(No)));
                                                   CaptionML=[DAN=Forudbetalt bel�b;
                                                              ENU=Prepaid Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 88  ;   ;Search Description  ;Code50        ;CaptionML=[DAN=S�gebeskrivelse;
                                                              ENU=Search Description] }
    { 89  ;   ;Service Contracts   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Service Contract Line" WHERE (Service Item No.=FIELD(No.)));
                                                   CaptionML=[DAN=Servicekontrakter;
                                                              ENU=Service Contracts];
                                                   Editable=No }
    { 90  ;   ;Total Qty. Consumed ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Service Ledger Entry".Quantity WHERE (Entry Type=CONST(Consume),
                                                                                                           Service Item No. (Serviced)=FIELD(No.),
                                                                                                           Service Contract No.=FIELD(Contract Filter),
                                                                                                           Service Order No.=FIELD(Service Order Filter),
                                                                                                           Type=FIELD(Type Filter),
                                                                                                           Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Antal forbrugt i alt;
                                                              ENU=Total Qty. Consumed];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 100 ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 101 ;   ;Type Filter         ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Typefilter;
                                                              ENU=Type Filter];
                                                   OptionCaptionML=[DAN=" ,Ressource,Vare,Serviceomkostning,Servicekontrakt,Finanskonto";
                                                                    ENU=" ,Resource,Item,Service Cost,Service Contract,G/L Account"];
                                                   OptionString=[ ,Resource,Item,Service Cost,Service Contract,G/L Account] }
    { 102 ;   ;Contract Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract));
                                                   CaptionML=[DAN=Kontraktfilter;
                                                              ENU=Contract Filter] }
    { 103 ;   ;Service Order Filter;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Service Header".No.;
                                                   CaptionML=[DAN=Serviceordrefilter;
                                                              ENU=Service Order Filter] }
    { 104 ;   ;Sales/Serv. Shpt. Document No.;Code20;
                                                   TableRelation=IF (Shipment Type=CONST(Sales)) "Sales Shipment Line"."Document No."
                                                                 ELSE IF (Shipment Type=CONST(Service)) "Service Shipment Line"."Document No.";
                                                   CaptionML=[DAN=Bilagsnr. for salg/serviceleverance;
                                                              ENU=Sales/Serv. Shpt. Document No.] }
    { 105 ;   ;Sales/Serv. Shpt. Line No.;Integer ;TableRelation=IF (Shipment Type=CONST(Sales)) "Sales Shipment Line"."Line No." WHERE (Document No.=FIELD(Sales/Serv. Shpt. Document No.))
                                                                 ELSE IF (Shipment Type=CONST(Service)) "Service Shipment Line"."Line No." WHERE (Document No.=FIELD(Sales/Serv. Shpt. Document No.));
                                                   CaptionML=[DAN=Linjenr. for salg/serviceleverance;
                                                              ENU=Sales/Serv. Shpt. Line No.] }
    { 106 ;   ;Shipment Type       ;Option        ;CaptionML=[DAN=Leverancetype;
                                                              ENU=Shipment Type];
                                                   OptionCaptionML=[DAN=Salg,Service;
                                                                    ENU=Sales,Service];
                                                   OptionString=Sales,Service }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Item No.,Serial No.                      }
    {    ;Customer No.,Ship-to Code,Item No.,Serial No. }
    {    ;Warranty Ending Date (Parts),Customer No.,Ship-to Code }
    {    ;Sales/Serv. Shpt. Document No.,Sales/Serv. Shpt. Line No. }
    {    ;Service Item Group Code                  }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Description,Status,Item No.,Service Contracts }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi den er tilknyttet en serviceordre.;ENU=You cannot delete %1 %2,because it is attached to a service order.';
      Text001@1001 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi den bruges som %3 for %1 %4.;ENU=You cannot delete %1 %2, because it is used as %3 for %1 %4.';
      Text002@1002 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi det er knyttet til en eller flere kontrakter.;ENU=You cannot delete %1 %2, because it belongs to one or more contracts.';
      Text003@1003 : TextConst 'DAN=%1 %2 findes allerede i %3 %4.;ENU=%1 %2 already exists in %3 %4.';
      Text004@1004 : TextConst 'DAN=Du kan ikke �ndre %1 %2, fordi %3 %4 er knyttet til en eller flere kontrakter.;ENU=You cannot change %1 %2 because the %3 %4 belongs to one or more contracts.';
      Text005@1005 : TextConst 'DAN=Hvis du �ndrer %1, slettes den eksisterende %2 p� listen %2.\\;ENU=Changing the %1 will delete the existing %2 on the %2 list.\\';
      Text006@1006 : TextConst 'DAN=Vil du �ndre %1?;ENU=Do you want to change the %1?';
      Text007@1007 : TextConst 'DAN=%1 kan ikke ligge efter %2.;ENU=%1 cannot be later than %2.';
      Text014@1014 : TextConst 'DAN=Du har �ndret %1 p� serviceartiklen, men den er ikke �ndret p� de tilh�rende serviceordrer/tilbud.\;ENU=You have changed %1 on the service item, but it has not been changed on the associated service orders/quotes.\';
      Text015@1015 : TextConst 'DAN=Du skal opdatere dem manuelt.;ENU=You must update them manually.';
      ServMgtSetup@1016 : Record 5911;
      ServItem@1017 : Record 5940;
      ServItemGr@1018 : Record 5904;
      ServContract@1019 : Record 5965;
      ServContractLine@1031 : Record 5964;
      ServCommentLine@1020 : Record 5906;
      Item@1021 : Record 27;
      ContractChangeLog@1022 : Record 5967;
      ServLedgEntry@1024 : Record 5907;
      ServItemLine@1025 : Record 5901;
      ServItemComponent@1026 : Record 5941;
      ResSkill@1034 : Record 5956;
      Currency@1008 : Record 4;
      NoSeriesMgt@1027 : Codeunit 396;
      ServLogMgt@1028 : Codeunit 5906;
      MoveEntries@1032 : Codeunit 361;
      ResSkillMgt@1033 : Codeunit 5931;
      Text017@1030 : TextConst 'DAN=Der findes serviceposter til %1\\ Vil du �ndre %2?;ENU=Service ledger entries exist for this %1\\ Do you want to change the %2?';
      DimMgt@1039 : Codeunit 408;
      CancelResSkillChanges@1035 : Boolean;
      CancelResSkillAssignment@1036 : Boolean;
      ChgCustomerErr@1010 : TextConst '@@@="%1 - Field Caption; %2 - Service Order No.;%3 - Serice Line No.;%4 - Service Item No.;%5 - Serial No.;%6 - Customer No.;%7 - Ship to Code.";DAN=Du kan ikke �ndre %1 i serviceartiklen p� grund af f�lgende udest�ende serviceordrelinje:\\ Ordre %2, linje %3, serviceartikelnummer %4, serienummer %5, debitor %6, leveringskode %7.;ENU=You cannot change the %1 in the service item because of the following outstanding service order line:\\ Order %2, line %3, service item number %4, serial number %5, customer %6, ship-to code %7.';

    [External]
    PROCEDURE AssistEdit@3(OldServItem@1000 : Record 5940) : Boolean;
    BEGIN
      WITH ServItem DO BEGIN
        ServItem := Rec;
        ServMgtSetup.GET;
        ServMgtSetup.TESTFIELD("Service Item Nos.");
        IF NoSeriesMgt.SelectSeries(ServMgtSetup."Service Item Nos.",OldServItem."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          Rec := ServItem;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE ServItemLinesExist@2() : Boolean;
    BEGIN
      ServItemLine.RESET;
      ServItemLine.SETCURRENTKEY("Service Item No.");
      ServItemLine.SETRANGE("Service Item No.","No.");
      EXIT(ServItemLine.FINDFIRST);
    END;

    LOCAL PROCEDURE MessageIfServItemLinesExist@8(ChangedFieldName@1000 : Text[100]);
    BEGIN
      IF ServItemLinesExist THEN
        MESSAGE(
          Text014 +
          Text015,
          ChangedFieldName);
    END;

    LOCAL PROCEDURE DeleteServItemComponents@6();
    BEGIN
      ServItemComponent.RESET;
      ServItemComponent.SETRANGE("Parent Service Item No.","No.");
      ServItemComponent.DELETEALL;
    END;

    LOCAL PROCEDURE ServItemLinesExistErr@7(ChangedFieldName@1000 : Text[100]);
    BEGIN
      IF ServItemLinesExist THEN
        ERROR(
          ChgCustomerErr,
          ChangedFieldName,
          ServItemLine."Document No.",ServItemLine."Line No.",ServItemLine."Service Item No.",
          ServItemLine."Serial No.",ServItemLine."Customer No.",ServItemLine."Ship-to Code");
    END;

    LOCAL PROCEDURE ServLedgEntryExist@1() : Boolean;
    BEGIN
      ServLedgEntry.RESET;
      ServLedgEntry.SETCURRENTKEY(
        "Service Item No. (Serviced)","Entry Type","Moved from Prepaid Acc.",
        Type,"Posting Date",Open);
      ServLedgEntry.SETRANGE("Service Item No. (Serviced)","No.");
      EXIT(ServLedgEntry.FINDFIRST);
    END;

    LOCAL PROCEDURE CheckifActiveServContLineExist@4() : Boolean;
    BEGIN
      ServContractLine.RESET;
      ServContractLine.SETCURRENTKEY("Service Item No.","Contract Status");
      ServContractLine.SETRANGE("Service Item No.","No.");
      ServContractLine.SETFILTER("Contract Status",'<>%1',ServContractLine."Contract Status"::Cancelled);
      EXIT(ServContractLine.FIND('-'));
    END;

    [External]
    PROCEDURE CheckIfCanBeDeleted@5() : Text;
    VAR
      ServiceLedgerEntry@1000 : Record 5907;
    BEGIN
      IF ServItemLinesExist THEN
        EXIT(
          STRSUBSTNO(
            Text000,
            TABLECAPTION,"No."));

      ServItemComponent.RESET;
      ServItemComponent.SETCURRENTKEY(Type,"No.",Active);
      ServItemComponent.SETRANGE(Type,ServItemComponent.Type::"Service Item");
      ServItemComponent.SETRANGE("No.","No.");
      IF ServItemComponent.FINDFIRST THEN
        EXIT(
          STRSUBSTNO(
            Text001,
            TABLECAPTION,"No.",ServItemComponent.TABLECAPTION,ServItemComponent."Parent Service Item No."));

      ServContractLine.RESET;
      ServContractLine.SETCURRENTKEY("Service Item No.","Contract Status");
      ServContractLine.SETRANGE("Service Item No.","No.");
      ServContractLine.SETFILTER("Contract Status",'<>%1',ServContractLine."Contract Status"::Cancelled);
      IF ServContractLine.FIND('-') THEN
        IF ServContract.GET(ServContractLine."Contract Type",ServContractLine."Contract No.") THEN
          EXIT(
            STRSUBSTNO(Text002,TABLECAPTION,"No."));

      EXIT(MoveEntries.CheckIfServiceItemCanBeDeleted(ServiceLedgerEntry,"No."));
    END;

    [External]
    PROCEDURE OmitAssignResSkills@10(IsSetOmitted@1000 : Boolean);
    BEGIN
      CancelResSkillAssignment := IsSetOmitted;
    END;

    BEGIN
    END.
  }
}

