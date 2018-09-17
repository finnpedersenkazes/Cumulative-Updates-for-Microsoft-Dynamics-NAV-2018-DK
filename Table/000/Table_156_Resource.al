OBJECT Table 156 Resource
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Name;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 ResSetup.GET;
                 ResSetup.TESTFIELD("Resource Nos.");
                 NoSeriesMgt.InitSeries(ResSetup."Resource Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;

               IF GETFILTER("Resource Group No.") <> '' THEN
                 IF GETRANGEMIN("Resource Group No.") = GETRANGEMAX("Resource Group No.") THEN
                   VALIDATE("Resource Group No.",GETRANGEMIN("Resource Group No."));

               DimMgt.UpdateDefaultDim(
                 DATABASE::Resource,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
             END;

    OnModify=BEGIN
               "Last Date Modified" := TODAY;
             END;

    OnDelete=BEGIN
               CheckJobPlanningLine;

               MoveEntries.MoveResEntries(Rec);

               ResCapacityEntry.SETCURRENTKEY("Resource No.");
               ResCapacityEntry.SETRANGE("Resource No.","No.");
               ResCapacityEntry.DELETEALL;

               ResCost.SETRANGE(Type,ResCost.Type::Resource);
               ResCost.SETRANGE(Code,"No.");
               ResCost.DELETEALL;

               ResPrice.SETRANGE(Type,ResPrice.Type::Resource);
               ResPrice.SETRANGE(Code,"No.");
               ResPrice.DELETEALL;

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Resource);
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::Resource);
               ExtTextHeader.SETRANGE("No.","No.");
               ExtTextHeader.DELETEALL(TRUE);

               ResSkill.RESET;
               ResSkill.SETRANGE(Type,ResSkill.Type::Resource);
               ResSkill.SETRANGE("No.","No.");
               ResSkill.DELETEALL;

               ResLoc.RESET;
               ResLoc.SETCURRENTKEY("Resource No.","Starting Date");
               ResLoc.SETRANGE("Resource No.","No.");
               ResLoc.DELETEALL;

               ResServZone.RESET;
               ResServZone.SETRANGE("Resource No.","No.");
               ResServZone.DELETEALL;

               ResUnitMeasure.RESET;
               ResUnitMeasure.SETRANGE("Resource No.","No.");
               ResUnitMeasure.DELETEALL;

               SalesOrderLine.SETCURRENTKEY(Type,"No.");
               SalesOrderLine.SETRANGE(Type,SalesOrderLine.Type::Resource);
               SalesOrderLine.SETRANGE("No.","No.");
               IF SalesOrderLine.FINDFIRST THEN
                 ERROR(SalesDocumentExistsErr,"No.",SalesOrderLine."Document Type");

               IF ExistUnprocessedTimeSheets THEN
                 ERROR(Text006,TABLECAPTION,"No.");

               DimMgt.DeleteDefaultDim(DATABASE::Resource,"No.");
             END;

    OnRename=VAR
               SalesLine@1000 : Record 37;
             BEGIN
               SalesLine.RenameNo(SalesLine.Type::Resource,xRec."No.","No.");

               "Last Date Modified" := TODAY;
             END;

    CaptionML=[DAN=Ressource;
               ENU=Resource];
    LookupPageID=Page77;
    DrillDownPageID=Page77;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  ResSetup.GET;
                                                                  NoSeriesMgt.TestManual(ResSetup."Resource Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   AltSearchField=Search Name;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Person,Maskine;
                                                                    ENU=Person,Machine];
                                                   OptionString=Person,Machine }
    { 3   ;   ;Name                ;Text50        ;OnValidate=BEGIN
                                                                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                                                                  "Search Name" := Name;
                                                              END;

                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 4   ;   ;Search Name         ;Code50        ;CaptionML=[DAN=S›genavn;
                                                              ENU=Search Name] }
    { 5   ;   ;Name 2              ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2] }
    { 6   ;   ;Address             ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Address] }
    { 7   ;   ;Address 2           ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2] }
    { 8   ;   ;City                ;Text30        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 9   ;   ;Social Security No. ;Text30        ;CaptionML=[DAN=CPR-nr.;
                                                              ENU=Social Security No.] }
    { 10  ;   ;Job Title           ;Text30        ;CaptionML=[DAN=Stilling;
                                                              ENU=Job Title] }
    { 11  ;   ;Education           ;Text30        ;CaptionML=[DAN=Uddannelse;
                                                              ENU=Education] }
    { 12  ;   ;Contract Class      ;Text30        ;CaptionML=[DAN=Overenskomst;
                                                              ENU=Contract Class] }
    { 13  ;   ;Employment Date     ;Date          ;CaptionML=[DAN=Ans‘ttelsesdato;
                                                              ENU=Employment Date] }
    { 14  ;   ;Resource Group No.  ;Code20        ;TableRelation="Resource Group";
                                                   OnValidate=BEGIN
                                                                IF "Resource Group No." = xRec."Resource Group No." THEN
                                                                  EXIT;

                                                                IF xRec."Resource Group No." <> '' THEN
                                                                  IF NOT
                                                                     CONFIRM(
                                                                       Text001,FALSE,
                                                                       FIELDCAPTION("Resource Group No."))
                                                                  THEN BEGIN
                                                                    "Resource Group No." := xRec."Resource Group No.";
                                                                    EXIT;
                                                                  END;

                                                                IF xRec.GETFILTER("Resource Group No.") <> '' THEN
                                                                  SETFILTER("Resource Group No.","Resource Group No.");

                                                                // Resource Capacity Entries
                                                                ResCapacityEntry.SETCURRENTKEY("Resource No.");
                                                                ResCapacityEntry.SETRANGE("Resource No.","No.");
                                                                ResCapacityEntry.MODIFYALL("Resource Group No.","Resource Group No.");

                                                                PlanningLine.SETCURRENTKEY(Type,"No.");
                                                                PlanningLine.SETRANGE(Type,PlanningLine.Type::Resource);
                                                                PlanningLine.SETRANGE("No.","No.");
                                                                PlanningLine.SETRANGE("Schedule Line",TRUE);
                                                                PlanningLine.MODIFYALL("Resource Group No.","Resource Group No.");
                                                              END;

                                                   CaptionML=[DAN=Ressourcegruppenr.;
                                                              ENU=Resource Group No.] }
    { 16  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 17  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 18  ;   ;Base Unit of Measure;Code10        ;TableRelation="Unit of Measure";
                                                   OnValidate=VAR
                                                                UnitOfMeasure@1002 : Record 204;
                                                                ResUnitOfMeasure@1000 : Record 205;
                                                              BEGIN
                                                                IF "Base Unit of Measure" <> xRec."Base Unit of Measure" THEN BEGIN
                                                                  TestNoEntriesExist(FIELDCAPTION("Base Unit of Measure"));

                                                                  IF "Base Unit of Measure" <> '' THEN BEGIN
                                                                    UnitOfMeasure.GET("Base Unit of Measure");
                                                                    IF NOT ResUnitOfMeasure.GET("No.","Base Unit of Measure") THEN BEGIN
                                                                      ResUnitOfMeasure.INIT;
                                                                      ResUnitOfMeasure.VALIDATE("Resource No.","No.");
                                                                      ResUnitOfMeasure.VALIDATE(Code,"Base Unit of Measure");
                                                                      ResUnitOfMeasure."Qty. per Unit of Measure" := 1;
                                                                      ResUnitOfMeasure.INSERT;
                                                                    END ELSE BEGIN
                                                                      IF ResUnitOfMeasure."Qty. per Unit of Measure" <> 1 THEN
                                                                        ERROR(STRSUBSTNO(BaseUnitOfMeasureQtyMustBeOneErr,"Base Unit of Measure",ResUnitOfMeasure."Qty. per Unit of Measure"));
                                                                      ResUnitOfMeasure.TESTFIELD("Related to Base Unit of Meas.");
                                                                    END;
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Basisenhed;
                                                              ENU=Base Unit of Measure] }
    { 19  ;   ;Direct Unit Cost    ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Indirect Cost %");
                                                              END;

                                                   CaptionML=[DAN=K›bspris;
                                                              ENU=Direct Unit Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 20  ;   ;Indirect Cost %     ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Unit Cost",ROUND("Direct Unit Cost" * (1 + "Indirect Cost %" / 100)));
                                                              END;

                                                   CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=2:2 }
    { 21  ;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Price/Profit Calculation");
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 22  ;   ;Profit %            ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Price/Profit Calculation");
                                                              END;

                                                   CaptionML=[DAN=Avancepct.;
                                                              ENU=Profit %];
                                                   DecimalPlaces=0:5 }
    { 23  ;   ;Price/Profit Calculation;Option    ;OnValidate=BEGIN
                                                                CASE "Price/Profit Calculation" OF
                                                                  "Price/Profit Calculation"::"Profit=Price-Cost":
                                                                    IF "Unit Price" <> 0 THEN
                                                                      "Profit %" := ROUND(100 * (1 - "Unit Cost" / "Unit Price"),0.00001)
                                                                    ELSE
                                                                      "Profit %" := 0;
                                                                  "Price/Profit Calculation"::"Price=Cost+Profit":
                                                                    IF "Profit %" < 100 THEN
                                                                      "Unit Price" := ROUND("Unit Cost" / (1 - "Profit %" / 100),0.00001);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Avancepct.beregning;
                                                              ENU=Price/Profit Calculation];
                                                   OptionCaptionML=[DAN="Avance=Salgspris-Kostpris,Salgspris=Kostpris+Avance,Ingen";
                                                                    ENU="Profit=Price-Cost,Price=Cost+Profit,No Relationship"];
                                                   OptionString=Profit=Price-Cost,Price=Cost+Profit,No Relationship }
    { 24  ;   ;Unit Price          ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Price/Profit Calculation");
                                                              END;

                                                   CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 25  ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Kreditornr.;
                                                              ENU=Vendor No.] }
    { 26  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 27  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(Resource),
                                                                                           No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 38  ;   ;Blocked             ;Boolean       ;CaptionML=[DAN=Sp‘rret;
                                                              ENU=Blocked] }
    { 39  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 40  ;   ;Unit of Measure Filter;Code10      ;FieldClass=FlowFilter;
                                                   TableRelation="Unit of Measure";
                                                   CaptionML=[DAN=Enhedsfilter;
                                                              ENU=Unit of Measure Filter] }
    { 41  ;   ;Capacity            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Res. Capacity Entry".Capacity WHERE (Resource No.=FIELD(No.),
                                                                                                         Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kapacitet;
                                                              ENU=Capacity];
                                                   DecimalPlaces=0:5 }
    { 42  ;   ;Qty. on Order (Job) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Quantity (Base)" WHERE (Status=CONST(Order),
                                                                                                                Schedule Line=CONST(Yes),
                                                                                                                Type=CONST(Resource),
                                                                                                                No.=FIELD(No.),
                                                                                                                Planning Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Antal i sagsordre;
                                                              ENU=Qty. on Order (Job)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 43  ;   ;Qty. Quoted (Job)   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Quantity (Base)" WHERE (Status=CONST(Quote),
                                                                                                                Schedule Line=CONST(Yes),
                                                                                                                Type=CONST(Resource),
                                                                                                                No.=FIELD(No.),
                                                                                                                Planning Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Antal i sagstilbud;
                                                              ENU=Qty. Quoted (Job)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 44  ;   ;Usage (Qty.)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Res. Ledger Entry"."Quantity (Base)" WHERE (Entry Type=CONST(Usage),
                                                                                                                Chargeable=FIELD(Chargeable Filter),
                                                                                                                Unit of Measure Code=FIELD(Unit of Measure Filter),
                                                                                                                Resource No.=FIELD(No.),
                                                                                                                Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forbrug (antal);
                                                              ENU=Usage (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 45  ;   ;Usage (Cost)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Res. Ledger Entry"."Total Cost" WHERE (Entry Type=CONST(Usage),
                                                                                                           Chargeable=FIELD(Chargeable Filter),
                                                                                                           Unit of Measure Code=FIELD(Unit of Measure Filter),
                                                                                                           Resource No.=FIELD(No.),
                                                                                                           Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forbrug (kostpris);
                                                              ENU=Usage (Cost)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 46  ;   ;Usage (Price)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Res. Ledger Entry"."Total Price" WHERE (Entry Type=CONST(Usage),
                                                                                                            Chargeable=FIELD(Chargeable Filter),
                                                                                                            Unit of Measure Code=FIELD(Unit of Measure Filter),
                                                                                                            Resource No.=FIELD(No.),
                                                                                                            Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forbrug (salgspris);
                                                              ENU=Usage (Price)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 47  ;   ;Sales (Qty.)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Res. Ledger Entry"."Quantity (Base)" WHERE (Entry Type=CONST(Sale),
                                                                                                                 Unit of Measure Code=FIELD(Unit of Measure Filter),
                                                                                                                 Resource No.=FIELD(No.),
                                                                                                                 Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Salg (antal);
                                                              ENU=Sales (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 48  ;   ;Sales (Cost)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Res. Ledger Entry"."Total Cost" WHERE (Entry Type=CONST(Sale),
                                                                                                            Unit of Measure Code=FIELD(Unit of Measure Filter),
                                                                                                            Resource No.=FIELD(No.),
                                                                                                            Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Salg (kostpris);
                                                              ENU=Sales (Cost)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 49  ;   ;Sales (Price)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Res. Ledger Entry"."Total Price" WHERE (Entry Type=CONST(Sale),
                                                                                                             Unit of Measure Code=FIELD(Unit of Measure Filter),
                                                                                                             Resource No.=FIELD(No.),
                                                                                                             Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Salg (salgspris);
                                                              ENU=Sales (Price)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 50  ;   ;Chargeable Filter   ;Boolean       ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Fakturerbar - filter;
                                                              ENU=Chargeable Filter] }
    { 51  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   OnValidate=BEGIN
                                                                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN
                                                                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                                                                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Produktbogf›ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 52  ;   ;Picture             ;BLOB          ;CaptionML=[DAN=Billede;
                                                              ENU=Picture];
                                                   SubType=Bitmap }
    { 53  ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 54  ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 55  ;   ;Automatic Ext. Texts;Boolean       ;CaptionML=[DAN=Automatisk udv. tekster;
                                                              ENU=Automatic Ext. Texts] }
    { 56  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 57  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 58  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 59  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr†dekode;
                                                              ENU=Country/Region Code] }
    { 60  ;   ;IC Partner Purch. G/L Acc. No.;Code20;
                                                   TableRelation="IC G/L Account";
                                                   CaptionML=[DAN=Finanskt.nr. for IC-partnerk›b;
                                                              ENU=IC Partner Purch. G/L Acc. No.] }
    { 140 ;   ;Image               ;Media         ;CaptionML=[DAN=Grafik;
                                                              ENU=Image] }
    { 900 ;   ;Qty. on Assembly Order;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Assembly Line"."Remaining Quantity (Base)" WHERE (Document Type=CONST(Order),
                                                                                                                      Type=CONST(Resource),
                                                                                                                      No.=FIELD(No.),
                                                                                                                      Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Mgd. p† montageordre;
                                                              ENU=Qty. on Assembly Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 950 ;   ;Use Time Sheet      ;Boolean       ;OnValidate=BEGIN
                                                                IF "Use Time Sheet" <> xRec."Use Time Sheet" THEN
                                                                  IF ExistUnprocessedTimeSheets THEN
                                                                    ERROR(Text005,FIELDCAPTION("Use Time Sheet"));
                                                              END;

                                                   CaptionML=[DAN=Brug timeseddel;
                                                              ENU=Use Time Sheet] }
    { 951 ;   ;Time Sheet Owner User ID;Code50    ;TableRelation="User Setup";
                                                   OnValidate=BEGIN
                                                                IF "Time Sheet Owner User ID" <> xRec."Time Sheet Owner User ID" THEN BEGIN
                                                                  IF ExistUnprocessedTimeSheets THEN
                                                                    ERROR(Text005,FIELDCAPTION("Time Sheet Owner User ID"));

                                                                  IF (Type = Type::Person) AND ("Time Sheet Owner User ID" <> '') THEN
                                                                    TimeSheetMgt.CheckResourceTimeSheetOwner("Time Sheet Owner User ID","No.");
                                                                END;
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id p† timeseddelejer;
                                                              ENU=Time Sheet Owner User ID] }
    { 952 ;   ;Time Sheet Approver User ID;Code50 ;TableRelation="User Setup";
                                                   OnValidate=BEGIN
                                                                IF "Time Sheet Approver User ID" <> xRec."Time Sheet Approver User ID" THEN
                                                                  IF ExistUnprocessedTimeSheets THEN
                                                                    ERROR(Text005,FIELDCAPTION("Time Sheet Approver User ID"));
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id p† timeseddelgodkender;
                                                              ENU=Time Sheet Approver User ID] }
    { 1700;   ;Default Deferral Template Code;Code10;
                                                   TableRelation="Deferral Template"."Deferral Code";
                                                   CaptionML=[DAN=Standardskabelonkode for periodisering;
                                                              ENU=Default Deferral Template Code] }
    { 5900;   ;Qty. on Service Order;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Order Allocation"."Allocated Hours" WHERE (Posted=CONST(No),
                                                                                                                       Resource No.=FIELD(No.),
                                                                                                                       Allocation Date=FIELD(Date Filter),
                                                                                                                       Status=CONST(Active)));
                                                   CaptionML=[DAN=Antal p† serviceordre;
                                                              ENU=Qty. on Service Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5901;   ;Service Zone Filter ;Code10        ;TableRelation="Service Zone";
                                                   CaptionML=[DAN=Servicezonefilter;
                                                              ENU=Service Zone Filter] }
    { 5902;   ;In Customer Zone    ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Resource Service Zone" WHERE (Resource No.=FIELD(No.),
                                                                                                    Service Zone Code=FIELD(Service Zone Filter)));
                                                   CaptionML=[DAN=I kundezone;
                                                              ENU=In Customer Zone];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Name                              }
    {    ;Gen. Prod. Posting Group                 }
    {    ;Name                                     }
    {    ;Type                                     }
    {    ;Base Unit of Measure                     }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Name,Type,Base Unit of Measure       }
    { 2   ;Brick               ;No.,Name,Type,Base Unit of Measure,Image }
  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Skal %1 ‘ndres?;ENU=Do you want to change %1?';
      ResSetup@1002 : Record 314;
      Res@1003 : Record 156;
      ResCapacityEntry@1004 : Record 160;
      CommentLine@1006 : Record 97;
      ResCost@1007 : Record 202;
      ResPrice@1008 : Record 201;
      SalesOrderLine@1009 : Record 37;
      ExtTextHeader@1010 : Record 279;
      PostCode@1011 : Record 225;
      GenProdPostingGrp@1012 : Record 251;
      ResSkill@1016 : Record 5956;
      ResLoc@1017 : Record 5952;
      ResServZone@1018 : Record 5958;
      ResUnitMeasure@1020 : Record 205;
      PlanningLine@1005 : Record 1003;
      NoSeriesMgt@1013 : Codeunit 396;
      MoveEntries@1014 : Codeunit 361;
      DimMgt@1015 : Codeunit 408;
      Text002@1019 : TextConst 'DAN=Du kan ikke ‘ndre %1, fordi der findes poster til denne ressource.;ENU=You cannot change %1 because there are ledger entries for this resource.';
      Text004@1022 : TextConst 'DAN=Vinduet Ops‘tning af Online Map skal udfyldes, f›r du kan bruge Online Map.\Se Ops‘tning af Online Map i Hj‘lp.;ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      TimeSheetMgt@1023 : Codeunit 950;
      Text005@1024 : TextConst 'DAN=%1 kan ikke ‘ndres, da der findes ikkebehandlede timeseddellinjer for denne ressource.;ENU=%1 cannot be changed since unprocessed time sheet lines exist for this resource.';
      Text006@1025 : TextConst '@@@=You cannot delete Resource LIFT since unprocessed time sheet lines exist for this resource.;DAN=Du kan ikke slette %1 %2, fordi der findes en eller flere timeseddellinjer for denne ressource.;ENU=You cannot delete %1 %2 because unprocessed time sheet lines exist for this resource.';
      BaseUnitOfMeasureQtyMustBeOneErr@1026 : TextConst '@@@="%1 Name of Unit of measure (e.g. BOX, PCS, KG...), %2 Qty. of %1 per base unit of measure ";DAN=Antallet pr. basisenhed skal v‘re 1. %1 er konfigureret med %2 pr. enhed.;ENU=The quantity per base unit of measure must be 1. %1 is set up with %2 per unit of measure.';
      CannotDeleteResourceErr@1027 : TextConst '@@@="%1 = Resource No.";DAN=Du kan ikke slette ressourcen %1, fordi den bruges i en eller flere sagsplanl‘gningslinjer.;ENU=You cannot delete resource %1 because it is used in one or more job planning lines.';
      SalesDocumentExistsErr@1028 : TextConst '@@@="%1 = Resource No.";DAN=Du kan ikke slette ressourcen %1, fordi der er en eller flere udest†ende %2, der medtager denne ressource.;ENU=You cannot delete resource %1 because there are one or more outstanding %2 that include this resource.';

    [External]
    PROCEDURE AssistEdit@2(OldRes@1000 : Record 156) : Boolean;
    BEGIN
      WITH Res DO BEGIN
        Res := Rec;
        ResSetup.GET;
        ResSetup.TESTFIELD("Resource Nos.");
        IF NoSeriesMgt.SelectSeries(ResSetup."Resource Nos.",OldRes."No. Series","No. Series") THEN BEGIN
          ResSetup.GET;
          ResSetup.TESTFIELD("Resource Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := Res;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Resource,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    END;

    [Internal]
    PROCEDURE DisplayMap@7();
    VAR
      MapPoint@1001 : Record 800;
      MapMgt@1000 : Codeunit 802;
    BEGIN
      IF MapPoint.FINDFIRST THEN
        MapMgt.MakeSelection(DATABASE::Resource,GETPOSITION)
      ELSE
        MESSAGE(Text004);
    END;

    [External]
    PROCEDURE GetUnitOfMeasureFilter@1(No@1000 : Code[20];UnitofMeasureCode@1002 : Code[10]) Filter : Text;
    VAR
      ResourceUnitOfMeasure@1001 : Record 205;
    BEGIN
      ResourceUnitOfMeasure.GET(No,UnitofMeasureCode);
      IF ResourceUnitOfMeasure."Related to Base Unit of Meas." THEN BEGIN
        CLEAR(ResourceUnitOfMeasure);
        ResourceUnitOfMeasure.SETRANGE("Resource No.",No);
        ResourceUnitOfMeasure.SETRANGE("Related to Base Unit of Meas.",TRUE);
        IF ResourceUnitOfMeasure.FINDSET THEN BEGIN
          REPEAT
            Filter := Filter + GetQuotedCode(ResourceUnitOfMeasure.Code) + '|';
          UNTIL ResourceUnitOfMeasure.NEXT = 0;
          Filter := DELSTR(Filter,STRLEN(Filter));
        END;
      END ELSE
        Filter := GetQuotedCode(UnitofMeasureCode);
    END;

    LOCAL PROCEDURE ExistUnprocessedTimeSheets@9() : Boolean;
    VAR
      TimeSheetHeader@1001 : Record 950;
      TimeSheetLine@1002 : Record 951;
    BEGIN
      TimeSheetHeader.SETCURRENTKEY("Resource No.");
      TimeSheetHeader.SETRANGE("Resource No.","No.");
      IF TimeSheetHeader.FINDSET THEN
        REPEAT
          TimeSheetLine.SETRANGE("Time Sheet No.",TimeSheetHeader."No.");
          TimeSheetLine.SETRANGE(Posted,FALSE);
          IF NOT TimeSheetLine.ISEMPTY THEN
            EXIT(TRUE);
        UNTIL TimeSheetHeader.NEXT = 0;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE CreateTimeSheets@3();
    VAR
      Resource@1000 : Record 156;
    BEGIN
      TESTFIELD("Use Time Sheet",TRUE);
      Resource.GET("No.");
      Resource.SETRECFILTER;
      REPORT.RUNMODAL(REPORT::"Create Time Sheets",TRUE,FALSE,Resource);
    END;

    LOCAL PROCEDURE GetQuotedCode@5(Code@1000 : Text) : Text;
    BEGIN
      EXIT(STRSUBSTNO('''%1''',Code));
    END;

    LOCAL PROCEDURE TestNoEntriesExist@4(CurrentFieldName@1001 : Text[100]);
    VAR
      ResLedgEntry@1000 : Record 203;
    BEGIN
      ResLedgEntry.SETRANGE("Resource No.","No.");
      IF NOT ResLedgEntry.ISEMPTY THEN
        ERROR(Text002,CurrentFieldName);
    END;

    LOCAL PROCEDURE CheckJobPlanningLine@34();
    VAR
      JobPlanningLine@1001 : Record 1003;
    BEGIN
      JobPlanningLine.SETCURRENTKEY(Type,"No.");
      JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::Resource);
      JobPlanningLine.SETRANGE("No.","No.");
      IF NOT JobPlanningLine.ISEMPTY THEN
        ERROR(CannotDeleteResourceErr,"No.");
    END;

    BEGIN
    END.
  }
}

