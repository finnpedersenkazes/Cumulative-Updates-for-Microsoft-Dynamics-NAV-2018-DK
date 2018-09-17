OBJECT Table 900 Assembly Header
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Description;
    OnInsert=VAR
               InvtAdjmtEntryOrder@1003 : Record 5896;
               NoSeriesMgt@1000 : Codeunit 396;
             BEGIN
               CheckIsNotAsmToOrder;

               AssemblySetup.GET;

               IF "No." = '' THEN BEGIN
                 TestNoSeries;
                 NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
               END;

               IF "Document Type" = "Document Type"::Order THEN BEGIN
                 InvtAdjmtEntryOrder.SETRANGE("Order Type",InvtAdjmtEntryOrder."Order Type"::Assembly);
                 InvtAdjmtEntryOrder.SETRANGE("Order No.","No.");
                 IF NOT InvtAdjmtEntryOrder.ISEMPTY THEN
                   ERROR(Text001,FORMAT("Document Type"),"No.");
               END;

               InitRecord;

               IF GETFILTER("Item No.") <> '' THEN
                 IF GETRANGEMIN("Item No.") = GETRANGEMAX("Item No.") THEN
                   VALIDATE("Item No.",GETRANGEMIN("Item No."));
             END;

    OnModify=BEGIN
               AssemblyHeaderReserve.VerifyChange(Rec,xRec);
             END;

    OnDelete=BEGIN
               CheckIsNotAsmToOrder;

               AssemblyHeaderReserve.DeleteLine(Rec);
               CALCFIELDS("Reserved Qty. (Base)");
               TESTFIELD("Reserved Qty. (Base)",0);

               DeleteAssemblyLines;
             END;

    OnRename=BEGIN
               ERROR(Text009,TABLECAPTION);
             END;

    CaptionML=[DAN=Montagehoved;
               ENU=Assembly Header];
    LookupPageID=Page904;
    DrillDownPageID=Page904;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                              END;

                                                   CaptionML=[DAN=Dokumenttype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,,,Rammeordre;
                                                                    ENU=Quote,Order,,,Blanket Order];
                                                   OptionString=Quote,Order,,,Blanket Order }
    { 2   ;   ;No.                 ;Code20        ;OnValidate=VAR
                                                                NoSeriesMgt@1000 : Codeunit 396;
                                                              BEGIN
                                                                TestStatusOpen;
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  AssemblySetup.GET;
                                                                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   AltSearchField=Search Description;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 3   ;   ;Description         ;Text50        ;OnValidate=BEGIN
                                                                "Search Description" := Description;
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Search Description  ;Code50        ;CaptionML=[DAN=S�gebeskrivelse;
                                                              ENU=Search Description] }
    { 5   ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 6   ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date];
                                                   Editable=No }
    { 7   ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 10  ;   ;Item No.            ;Code20        ;TableRelation=Item WHERE (Type=CONST(Inventory));
                                                   OnValidate=BEGIN
                                                                CheckIsNotAsmToOrder;
                                                                TestStatusOpen;
                                                                SetCurrentFieldNum(FIELDNO("Item No."));
                                                                IF "Item No." <> '' THEN BEGIN
                                                                  SetDescriptionsFromItem;
                                                                  "Unit Cost" := GetUnitCost;
                                                                  "Overhead Rate" := Item."Overhead Rate";
                                                                  "Inventory Posting Group" := Item."Inventory Posting Group";
                                                                  "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                                                                  "Indirect Cost %" := Item."Indirect Cost %";
                                                                  VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                                                                  SetDim;
                                                                  ValidateDates(FIELDNO("Due Date"),TRUE);
                                                                  GetDefaultBin;
                                                                END;
                                                                AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,FIELDNO("Item No."),TRUE,CurrFieldNo,CurrentFieldNum);
                                                                AssemblyHeaderReserve.VerifyChange(Rec,xRec);
                                                                ClearCurrentFieldNum(FIELDNO("Item No."));
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 12  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.),
                                                                                            Code=FIELD(Variant Code));
                                                   OnValidate=VAR
                                                                ItemVariant@1000 : Record 5401;
                                                              BEGIN
                                                                CheckIsNotAsmToOrder;
                                                                TestStatusOpen;
                                                                SetCurrentFieldNum(FIELDNO("Variant Code"));
                                                                IF "Variant Code" = '' THEN
                                                                  SetDescriptionsFromItem
                                                                ELSE BEGIN
                                                                  ItemVariant.GET("Item No.","Variant Code");
                                                                  Description := ItemVariant.Description;
                                                                  "Description 2" := ItemVariant."Description 2";
                                                                END;
                                                                ValidateDates(FIELDNO("Due Date"),TRUE);
                                                                AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,FIELDNO("Variant Code"),FALSE,CurrFieldNo,CurrentFieldNum);
                                                                AssemblyHeaderReserve.VerifyChange(Rec,xRec);
                                                                GetDefaultBin;
                                                                VALIDATE("Unit Cost",GetUnitCost);
                                                                ClearCurrentFieldNum(FIELDNO("Variant Code"));
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 15  ;   ;Inventory Posting Group;Code20     ;TableRelation="Inventory Posting Group";
                                                   CaptionML=[DAN=Varebogf�ringsgruppe;
                                                              ENU=Inventory Posting Group] }
    { 16  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                              END;

                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 19  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Assembly Comment Line" WHERE (Document Type=FIELD(Document Type),
                                                                                                    Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 20  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                CheckIsNotAsmToOrder;
                                                                TestStatusOpen;
                                                                SetCurrentFieldNum(FIELDNO("Location Code"));
                                                                ValidateDates(FIELDNO("Due Date"),TRUE);
                                                                AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,FIELDNO("Location Code"),FALSE,CurrFieldNo,CurrentFieldNum);
                                                                AssemblyHeaderReserve.VerifyChange(Rec,xRec);
                                                                GetDefaultBin;
                                                                VALIDATE("Unit Cost",GetUnitCost);
                                                                ClearCurrentFieldNum(FIELDNO("Location Code"));
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 21  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 22  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 23  ;   ;Posting Date        ;Date          ;OnValidate=VAR
                                                                ATOLink@1000 : Record 904;
                                                                SalesHeader@1001 : Record 36;
                                                              BEGIN
                                                                IF ATOLink.GET("Document Type","No.") AND (CurrFieldNo = FIELDNO("Posting Date")) THEN
                                                                  IF SalesHeader.GET(ATOLink."Document Type",ATOLink."Document No.") AND ("Posting Date" > SalesHeader."Posting Date") THEN
                                                                    ERROR(PostingDateLaterErr,"No.",SalesHeader."No.");
                                                              END;

                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 24  ;   ;Due Date            ;Date          ;OnValidate=BEGIN
                                                                ValidateDueDate("Due Date",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 25  ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                ValidateStartDate("Starting Date",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 27  ;   ;Ending Date         ;Date          ;OnValidate=BEGIN
                                                                ValidateEndDate("Ending Date",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 33  ;   ;Bin Code            ;Code20        ;TableRelation=IF (Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                          Item No.=FIELD(Item No.),
                                                                                                                          Variant Code=FIELD(Variant Code))
                                                                                                                          ELSE Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                CheckIsNotAsmToOrder;
                                                                ValidateBinCode("Bin Code");
                                                              END;

                                                   OnLookup=VAR
                                                              WMSManagement@1000 : Codeunit 7302;
                                                              BinCode@1001 : Code[20];
                                                            BEGIN
                                                              IF Quantity < 0 THEN
                                                                BinCode := WMSManagement.BinContentLookUp("Location Code","Item No.","Variant Code",'',"Bin Code")
                                                              ELSE
                                                                BinCode := WMSManagement.BinLookUp("Location Code","Item No.","Variant Code",'');

                                                              IF BinCode <> '' THEN
                                                                VALIDATE("Bin Code",BinCode);
                                                            END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 40  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                CheckIsNotAsmToOrder;
                                                                TestStatusOpen;

                                                                SetCurrentFieldNum(FIELDNO(Quantity));
                                                                RoundQty(Quantity);
                                                                "Cost Amount" := ROUND(Quantity * "Unit Cost");
                                                                IF Quantity < "Assembled Quantity" THEN
                                                                  ERROR(Text002,FIELDCAPTION(Quantity),FIELDCAPTION("Assembled Quantity"),"Assembled Quantity");

                                                                "Quantity (Base)" := CalcBaseQty(Quantity);
                                                                InitRemainingQty;
                                                                InitQtyToAssemble;
                                                                VALIDATE("Quantity to Assemble");

                                                                AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,FIELDNO(Quantity),ReplaceLinesFromBOM,CurrFieldNo,CurrentFieldNum);
                                                                AssemblyHeaderReserve.VerifyQuantity(Rec,xRec);

                                                                ClearCurrentFieldNum(FIELDNO(Quantity));
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 41  ;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Quantity (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 42  ;   ;Remaining Quantity  ;Decimal       ;CaptionML=[DAN=Restantal;
                                                              ENU=Remaining Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 43  ;   ;Remaining Quantity (Base);Decimal  ;CaptionML=[DAN=Restantal (basis);
                                                              ENU=Remaining Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 44  ;   ;Assembled Quantity  ;Decimal       ;AccessByPermission=TableData 90=R;
                                                   CaptionML=[DAN=Monteret antal;
                                                              ENU=Assembled Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 45  ;   ;Assembled Quantity (Base);Decimal  ;CaptionML=[DAN=Monteret antal (basis);
                                                              ENU=Assembled Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 46  ;   ;Quantity to Assemble;Decimal       ;OnValidate=VAR
                                                                ATOLink@1000 : Record 904;
                                                              BEGIN
                                                                SetCurrentFieldNum(FIELDNO("Quantity to Assemble"));
                                                                RoundQty("Quantity to Assemble");
                                                                IF "Quantity to Assemble" > "Remaining Quantity" THEN
                                                                  ERROR(Text003,
                                                                    FIELDCAPTION("Quantity to Assemble"),FIELDCAPTION("Remaining Quantity"),"Remaining Quantity");

                                                                IF "Quantity to Assemble" <> xRec."Quantity to Assemble" THEN
                                                                  ATOLink.CheckQtyToAsm(Rec);

                                                                VALIDATE("Quantity to Assemble (Base)",CalcBaseQty("Quantity to Assemble"));
                                                                AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,FIELDNO("Quantity to Assemble"),FALSE,CurrFieldNo,CurrentFieldNum);
                                                                ClearCurrentFieldNum(FIELDNO("Quantity to Assemble"));
                                                              END;

                                                   CaptionML=[DAN=Antal til montage;
                                                              ENU=Quantity to Assemble];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 47  ;   ;Quantity to Assemble (Base);Decimal;CaptionML=[DAN=Antal til montage (basis);
                                                              ENU=Quantity to Assemble (Base)];
                                                   DecimalPlaces=0:5 }
    { 48  ;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(No.),
                                                                                                       Source Type=CONST(900),
                                                                                                       Source Subtype=FIELD(Document Type),
                                                                                                       Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal;
                                                              ENU=Reserved Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 49  ;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(No.),
                                                                                                                Source Type=CONST(900),
                                                                                                                Source Subtype=FIELD(Document Type),
                                                                                                                Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 50  ;   ;Planning Flexibility;Option        ;OnValidate=BEGIN
                                                                CheckIsNotAsmToOrder;
                                                                TestStatusOpen;
                                                                IF "Planning Flexibility" <> xRec."Planning Flexibility" THEN
                                                                  AssemblyHeaderReserve.UpdatePlanningFlexibility(Rec);
                                                              END;

                                                   CaptionML=[DAN=Planl�gningsfleksibilitet;
                                                              ENU=Planning Flexibility];
                                                   OptionCaptionML=[DAN=Ubegr�nset,Ingen;
                                                                    ENU=Unlimited,None];
                                                   OptionString=Unlimited,None }
    { 51  ;   ;MPS Order           ;Boolean       ;OnValidate=BEGIN
                                                                TESTFIELD(Status,Status::Open);
                                                              END;

                                                   CaptionML=[DAN=Hovedplansordre;
                                                              ENU=MPS Order] }
    { 54  ;   ;Assemble to Order   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Assemble-to-Order Link" WHERE (Assembly Document Type=FIELD(Document Type),
                                                                                                     Assembly Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Montage til ordre;
                                                              ENU=Assemble to Order];
                                                   Editable=No }
    { 63  ;   ;Posting No.         ;Code20        ;CaptionML=[DAN=Tildelt fakturanr.;
                                                              ENU=Posting No.];
                                                   Editable=No }
    { 65  ;   ;Unit Cost           ;Decimal       ;OnValidate=VAR
                                                                SkuItemUnitCost@1000 : Decimal;
                                                              BEGIN
                                                                IF "Item No." <> '' THEN BEGIN
                                                                  GetItem;

                                                                  IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                                                                    SkuItemUnitCost := GetUnitCost;
                                                                    IF "Unit Cost" <> SkuItemUnitCost THEN
                                                                      ERROR(Text005,
                                                                        FIELDCAPTION("Unit Cost"),
                                                                        FIELDCAPTION("Cost Amount"),
                                                                        Item.FIELDCAPTION("Costing Method"),
                                                                        Item."Costing Method");
                                                                  END;
                                                                END;

                                                                "Cost Amount" := ROUND(Quantity * "Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 67  ;   ;Cost Amount         ;Decimal       ;CaptionML=[DAN=Kostbel�b;
                                                              ENU=Cost Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 68  ;   ;Rolled-up Assembly Cost;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Assembly Line"."Cost Amount" WHERE (Document Type=FIELD(Document Type),
                                                                                                        Document No.=FIELD(No.),
                                                                                                        Type=FILTER(Item|Resource)));
                                                   CaptionML=[DAN=Akkumuleret montageomkostning;
                                                              ENU=Rolled-up Assembly Cost] }
    { 75  ;   ;Indirect Cost %     ;Decimal       ;CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5 }
    { 76  ;   ;Overhead Rate       ;Decimal       ;CaptionML=[DAN=IPO-bidrag;
                                                              ENU=Overhead Rate];
                                                   DecimalPlaces=0:5 }
    { 80  ;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=VAR
                                                                UOMMgt@1001 : Codeunit 5402;
                                                              BEGIN
                                                                CheckIsNotAsmToOrder;
                                                                TESTFIELD("Assembled Quantity",0);
                                                                TestStatusOpen;
                                                                SetCurrentFieldNum(FIELDNO("Unit of Measure Code"));

                                                                GetItem;
                                                                "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                                                                "Unit Cost" := GetUnitCost;
                                                                "Overhead Rate" := RoundUnitAmount(Item."Overhead Rate" * "Qty. per Unit of Measure");

                                                                AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,FIELDNO("Unit of Measure Code"),ReplaceLinesFromBOM,CurrFieldNo,CurrentFieldNum);
                                                                ClearCurrentFieldNum(FIELDNO("Unit of Measure Code"));

                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 81  ;   ;Qty. per Unit of Measure;Decimal   ;OnValidate=BEGIN
                                                                CheckIsNotAsmToOrder;
                                                                TestStatusOpen;
                                                              END;

                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 107 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                              END;

                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 108 ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=VAR
                                                                NoSeriesMgt@1000 : Codeunit 396;
                                                              BEGIN
                                                                TestStatusOpen;
                                                                IF "Posting No. Series" <> '' THEN BEGIN
                                                                  AssemblySetup.GET;
                                                                  TestNoSeries;
                                                                  NoSeriesMgt.TestSeries(GetPostingNoSeriesCode,"Posting No. Series");
                                                                END;
                                                                TESTFIELD("Posting No.",'');
                                                              END;

                                                   OnLookup=VAR
                                                              AsmHeader@1000 : Record 900;
                                                              NoSeriesMgt@1001 : Codeunit 396;
                                                            BEGIN
                                                              AsmHeader := Rec;
                                                              AssemblySetup.GET;
                                                              TestNoSeries;
                                                              IF NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode,"Posting No. Series") THEN
                                                                VALIDATE("Posting No. Series");
                                                              Rec := AsmHeader;
                                                            END;

                                                   CaptionML=[DAN=Bogf�ringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 120 ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=�ben,Frigivet;
                                                                    ENU=Open,Released];
                                                   OptionString=Open,Released;
                                                   Editable=No }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=VAR
                                                                DimMgt@1000 : Codeunit 408;
                                                              BEGIN
                                                                SetCurrentFieldNum(FIELDNO("Dimension Set ID"));
                                                                IF "Dimension Set ID" <> xRec."Dimension Set ID" THEN
                                                                  AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,FIELDNO("Dimension Set ID"),FALSE,CurrFieldNo,CurrentFieldNum);
                                                                ClearCurrentFieldNum(FIELDNO("Dimension Set ID"));
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 9000;   ;Assigned User ID    ;Code50        ;TableRelation="User Setup";
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
  }
  KEYS
  {
    {    ;Document Type,No.                       ;Clustered=Yes }
    {    ;Document Type,Item No.,Variant Code,Location Code,Due Date;
                                                   SumIndexFields=Remaining Quantity (Base) }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      AssemblySetup@1000 : Record 905;
      Text001@1003 : TextConst '@@@="%1 = Document Type, %2 = No.";DAN=%1 %2 kan ikke oprettes, da den allerede findes eller er bogf�rt.;ENU=%1 %2 cannot be created, because it already exists or has been posted.';
      Text002@1008 : TextConst 'DAN=%1 m� ikke v�re lavere end %2, som er %3.;ENU=%1 cannot be lower than the %2, which is %3.';
      Text003@1009 : TextConst 'DAN=%1 m� ikke v�re h�jere end %2, som er %3.;ENU=%1 cannot be higher than the %2, which is %3.';
      Item@1004 : Record 27;
      GLSetup@1005 : Record 98;
      StockkeepingUnit@1013 : Record 5700;
      AssemblyHeaderReserve@1002 : Codeunit 925;
      AssemblyLineMgt@1010 : Codeunit 905;
      GLSetupRead@1006 : Boolean;
      Text005@1001 : TextConst 'DAN=�ndring af %1 eller %2 er ikke tilladt, n�r %3 er %4.;ENU=Changing %1 or %2 is not allowed when %3 is %4.';
      Text007@1007 : TextConst 'DAN=Der er intet at h�ndtere.;ENU=Nothing to handle.';
      Text009@1017 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename an %1.';
      StatusCheckSuspended@1016 : Boolean;
      TestReservationDateConflict@1055 : Boolean;
      HideValidationDialog@1024 : Boolean;
      CurrentFieldNum@1011 : Integer;
      Text010@1012 : TextConst 'DAN=Du har �ndret %1.;ENU=You have modified %1.';
      Text011@1014 : TextConst 'DAN=%1 fra %2 til %3;ENU=the %1 from %2 to %3';
      Text012@1021 : TextConst '@@@={Locked};DAN=%1 %2;ENU=%1 %2';
      Text013@1020 : TextConst 'DAN=Vil du opdatere %1?;ENU=Do you want to update %1?';
      Text014@1018 : TextConst 'DAN=%1 og %2;ENU=%1 and %2';
      Text015@1019 : TextConst '@@@="%1 and %3 = Date Captions, %2 and %4 = Date Values";DAN=%1 %2 er f�r %3 %4.;ENU=%1 %2 is before %3 %4.';
      PostingDateLaterErr@1022 : TextConst 'DAN=Bogf�ringsdatoen p� montageordren %1 m� ikke ligge efter bogf�ringsdatoen for salgsordren %2.;ENU=Posting Date on Assembly Order %1 must not be later than the Posting Date on Sales Order %2.';
      RowIdx@1023 : ',MatCost,ResCost,ResOvhd,AsmOvhd,Total';

    [Internal]
    PROCEDURE RefreshBOM@23();
    BEGIN
      AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,0,TRUE,CurrFieldNo,0);
    END;

    [External]
    PROCEDURE InitRecord@15();
    VAR
      NoSeriesMgt@1001 : Codeunit 396;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote,"Document Type"::"Blanket Order":
          NoSeriesMgt.SetDefaultSeries("Posting No. Series",AssemblySetup."Posted Assembly Order Nos.");
        "Document Type"::Order:
          BEGIN
            IF ("No. Series" <> '') AND
               (AssemblySetup."Assembly Order Nos." = AssemblySetup."Posted Assembly Order Nos.")
            THEN
              "Posting No. Series" := "No. Series"
            ELSE
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",AssemblySetup."Posted Assembly Order Nos.");
          END;
      END;

      "Creation Date" := WORKDATE;
      IF "Due Date" = 0D THEN
        "Due Date" := WORKDATE;
      "Posting Date" := WORKDATE;
      IF "Starting Date" = 0D THEN
        "Starting Date" := WORKDATE;
      IF "Ending Date" = 0D THEN
        "Ending Date" := WORKDATE;

      SetDefaultLocation;
    END;

    [External]
    PROCEDURE InitRemainingQty@17();
    BEGIN
      "Remaining Quantity" := Quantity - "Assembled Quantity";
      "Remaining Quantity (Base)" := "Quantity (Base)" - "Assembled Quantity (Base)";
    END;

    [External]
    PROCEDURE InitQtyToAssemble@53();
    VAR
      ATOLink@1000 : Record 904;
    BEGIN
      "Quantity to Assemble" := "Remaining Quantity";
      "Quantity to Assemble (Base)" := "Remaining Quantity (Base)";
      ATOLink.InitQtyToAsm(Rec,"Quantity to Assemble","Quantity to Assemble (Base)");
    END;

    [External]
    PROCEDURE AssistEdit@1(OldAssemblyHeader@1000 : Record 900) : Boolean;
    VAR
      AssemblyHeader@1001 : Record 900;
      AssemblyHeader2@1002 : Record 900;
      NoSeriesMgt@1003 : Codeunit 396;
    BEGIN
      WITH AssemblyHeader DO BEGIN
        COPY(Rec);
        AssemblySetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldAssemblyHeader."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          IF AssemblyHeader2.GET("Document Type","No.") THEN
            ERROR(Text001,FORMAT("Document Type"),"No.");
          Rec := AssemblyHeader;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE TestNoSeries@6();
    BEGIN
      AssemblySetup.GET;
      CASE "Document Type" OF
        "Document Type"::Quote:
          AssemblySetup.TESTFIELD("Assembly Quote Nos.");
        "Document Type"::Order:
          BEGIN
            AssemblySetup.TESTFIELD("Posted Assembly Order Nos.");
            AssemblySetup.TESTFIELD("Assembly Order Nos.");
          END;
        "Document Type"::"Blanket Order":
          AssemblySetup.TESTFIELD("Blanket Assembly Order Nos.");
      END;
    END;

    LOCAL PROCEDURE GetNoSeriesCode@9() : Code[20];
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote:
          EXIT(AssemblySetup."Assembly Quote Nos.");
        "Document Type"::Order:
          EXIT(AssemblySetup."Assembly Order Nos.");
        "Document Type"::"Blanket Order":
          EXIT(AssemblySetup."Blanket Assembly Order Nos.");
      END;
    END;

    LOCAL PROCEDURE GetPostingNoSeriesCode@8() : Code[20];
    BEGIN
      EXIT(AssemblySetup."Posted Assembly Order Nos.");
    END;

    [External]
    PROCEDURE SetHideValidationDialog@13(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    [External]
    PROCEDURE DeleteAssemblyLines@29();
    VAR
      AssemblyLine@1000 : Record 901;
      ReservMgt@1002 : Codeunit 99000845;
    BEGIN
      AssemblyLine.SETRANGE("Document Type","Document Type");
      AssemblyLine.SETRANGE("Document No.","No.");
      IF AssemblyLine.FIND('-') THEN BEGIN
        ReservMgt.DeleteDocumentReservation(DATABASE::"Assembly Line","Document Type","No.",HideValidationDialog);
        REPEAT
          AssemblyLine.SuspendStatusCheck(TRUE);
          AssemblyLine.DELETE(TRUE);
        UNTIL AssemblyLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE ShowReservation@121();
    VAR
      Reservation@1001 : Page 498;
    BEGIN
      TESTFIELD("Item No.");
      CLEAR(Reservation);
      Reservation.SetAssemblyHeader(Rec);
      Reservation.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowReservationEntries@122(Modal@1000 : Boolean);
    VAR
      ReservEntry@1001 : Record 337;
      ReservEngineMgt@1003 : Codeunit 99000831;
    BEGIN
      TESTFIELD("Item No.");
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
      AssemblyHeaderReserve.FilterReservFor(ReservEntry,Rec);
      IF Modal THEN
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      ELSE
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    END;

    [External]
    PROCEDURE AutoReserveAsmLine@16(AssemblyLine@1000 : Record 901);
    BEGIN
      IF AssemblyLine.Reserve = AssemblyLine.Reserve::Always THEN
        AssemblyLine.AutoReserve;
    END;

    [External]
    PROCEDURE SetTestReservationDateConflict@155(NewTestReservationDateConflict@1000 : Boolean);
    BEGIN
      TestReservationDateConflict := NewTestReservationDateConflict;
    END;

    LOCAL PROCEDURE CreateDim@4(Type1@1000 : Integer;No1@1001 : Code[20]);
    VAR
      SourceCodeSetup@1005 : Record 242;
      DimMgt@1004 : Codeunit 408;
      TableID@1002 : ARRAY [10] OF Integer;
      No@1003 : ARRAY [10] OF Code[20];
    BEGIN
      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Assembly,
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
      IF "No." <> '' THEN
        DimMgt.UpdateGlobalDimFromDimSetID(
          "Dimension Set ID",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@7(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    VAR
      DimMgt@1002 : Codeunit 408;
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");

      IF "No." <> '' THEN
        MODIFY;
    END;

    LOCAL PROCEDURE GetItem@5();
    BEGIN
      TESTFIELD("Item No.");
      IF Item."No." <> "Item No." THEN
        Item.GET("Item No.");
    END;

    LOCAL PROCEDURE GetGLSetup@14();
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE GetLocation@7300(VAR Location@1001 : Record 14;LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    [External]
    PROCEDURE FilterLinesWithItemToPlan@70(VAR Item@1000 : Record 27;DocumentType@1002 : Option);
    BEGIN
      RESET;
      SETCURRENTKEY("Document Type","Item No.","Variant Code","Location Code");
      SETRANGE("Document Type",DocumentType);
      SETRANGE("Item No.",Item."No.");
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Due Date",Item.GETFILTER("Date Filter"));
      SETFILTER("Shortcut Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
      SETFILTER("Shortcut Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
      SETFILTER("Remaining Quantity (Base)",'<>0');
    END;

    [External]
    PROCEDURE FindLinesWithItemToPlan@68(VAR Item@1000 : Record 27;DocumentType@1002 : Option) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item,DocumentType);
      EXIT(FIND('-'));
    END;

    [External]
    PROCEDURE LinesWithItemToPlanExist@67(VAR Item@1000 : Record 27;DocumentType@1002 : Option) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item,DocumentType);
      EXIT(NOT ISEMPTY);
    END;

    [Internal]
    PROCEDURE ShowDimensions@30();
    VAR
      DimMgt@1000 : Codeunit 408;
      OldDimSetId@1001 : Integer;
    BEGIN
      OldDimSetId := "Dimension Set ID";
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      IF OldDimSetId <> "Dimension Set ID" THEN BEGIN
        SetCurrentFieldNum(FIELDNO("Dimension Set ID"));
        AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,FIELDNO("Dimension Set ID"),FALSE,CurrFieldNo,CurrentFieldNum);
        ClearCurrentFieldNum(FIELDNO("Dimension Set ID"));
        MODIFY(TRUE);
      END;
    END;

    [External]
    PROCEDURE ShowStatistics@48();
    BEGIN
      TESTFIELD("Item No.");
      PAGE.RUN(PAGE::"Assembly Order Statistics",Rec);
    END;

    [External]
    PROCEDURE SetDim@3();
    BEGIN
      CreateDim(DATABASE::Item,"Item No.");
    END;

    [External]
    PROCEDURE UpdateUnitCost@10();
    VAR
      CalculateStandardCost@1002 : Codeunit 5812;
      RolledUpAsmUnitCost@1000 : Decimal;
      OverHeadAmt@1001 : Decimal;
    BEGIN
      RolledUpAsmUnitCost := CalcRolledUpAsmUnitCost;
      OverHeadAmt := CalculateStandardCost.CalcOverHeadAmt(RolledUpAsmUnitCost,"Indirect Cost %","Overhead Rate");
      VALIDATE("Unit Cost",RoundUnitAmount(RolledUpAsmUnitCost + OverHeadAmt));
      MODIFY(TRUE);
    END;

    LOCAL PROCEDURE CalcRolledUpAsmUnitCost@28() : Decimal;
    BEGIN
      TESTFIELD(Quantity);
      CALCFIELDS("Rolled-up Assembly Cost");

      EXIT("Rolled-up Assembly Cost" / Quantity);
    END;

    LOCAL PROCEDURE SetDefaultLocation@33();
    VAR
      AsmSetup@1000 : Record 905;
    BEGIN
      IF AsmSetup.GET THEN
        IF AsmSetup."Default Location for Orders" <> '' THEN
          IF "Location Code" = '' THEN
            VALIDATE("Location Code",AsmSetup."Default Location for Orders");
    END;

    [External]
    PROCEDURE SetItemFilter@46(VAR Item@1000 : Record 27);
    BEGIN
      IF "Due Date" = 0D THEN
        "Due Date" := WORKDATE;
      Item.SETRANGE("Date Filter",0D,"Due Date");
      Item.SETRANGE("Location Filter","Location Code");
      Item.SETRANGE("Variant Filter","Variant Code");
    END;

    [External]
    PROCEDURE ShowAssemblyList@42();
    VAR
      BOMComponent@1001 : Record 90;
    BEGIN
      TESTFIELD("Item No.");
      BOMComponent.SETRANGE("Parent Item No.","Item No.");
      PAGE.RUN(PAGE::"Assembly BOM",BOMComponent);
    END;

    LOCAL PROCEDURE CalcBaseQty@43(Qty@1000 : Decimal) : Decimal;
    VAR
      UOMMgt@1001 : Codeunit 5402;
    BEGIN
      EXIT(UOMMgt.CalcBaseQty(Qty,"Qty. per Unit of Measure"));
    END;

    [External]
    PROCEDURE RoundQty@45(VAR Qty@1000 : Decimal);
    VAR
      UOMMgt@1001 : Codeunit 5402;
    BEGIN
      Qty := UOMMgt.RoundQty(Qty);
    END;

    LOCAL PROCEDURE GetSKU@5802() : Boolean;
    BEGIN
      IF (StockkeepingUnit."Location Code" = "Location Code") AND
         (StockkeepingUnit."Item No." = "Item No.") AND
         (StockkeepingUnit."Variant Code" = "Variant Code")
      THEN
        EXIT(TRUE);
      IF StockkeepingUnit.GET("Location Code","Item No.","Variant Code") THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetUnitCost@51() : Decimal;
    VAR
      SkuItemUnitCost@1000 : Decimal;
    BEGIN
      IF "Item No." = '' THEN
        EXIT(0);

      GetItem;
      IF GetSKU THEN
        SkuItemUnitCost := StockkeepingUnit."Unit Cost" * "Qty. per Unit of Measure"
      ELSE
        SkuItemUnitCost := Item."Unit Cost" * "Qty. per Unit of Measure";

      EXIT(RoundUnitAmount(SkuItemUnitCost));
    END;

    LOCAL PROCEDURE RoundUnitAmount@131(UnitAmount@1000 : Decimal) : Decimal;
    BEGIN
      GetGLSetup;

      EXIT(ROUND(UnitAmount,GLSetup."Unit-Amount Rounding Precision"));
    END;

    [External]
    PROCEDURE CalcActualCosts@52(VAR ActCost@1006 : ARRAY [5] OF Decimal);
    VAR
      TempSourceInvtAdjmtEntryOrder@1005 : TEMPORARY Record 5896;
      CalcInvtAdjmtOrder@1001 : Codeunit 5896;
    BEGIN
      TempSourceInvtAdjmtEntryOrder.SetAsmOrder(Rec);
      CalcInvtAdjmtOrder.CalcActualUsageCosts(TempSourceInvtAdjmtEntryOrder,"Assembled Quantity (Base)",TempSourceInvtAdjmtEntryOrder);
      ActCost[RowIdx::MatCost] := TempSourceInvtAdjmtEntryOrder."Single-Level Material Cost";
      ActCost[RowIdx::ResCost] := TempSourceInvtAdjmtEntryOrder."Single-Level Capacity Cost";
      ActCost[RowIdx::ResOvhd] := TempSourceInvtAdjmtEntryOrder."Single-Level Cap. Ovhd Cost";
      ActCost[RowIdx::AsmOvhd] := TempSourceInvtAdjmtEntryOrder."Single-Level Mfg. Ovhd Cost";
    END;

    LOCAL PROCEDURE CalcStartDateFromEndDate@56(EndingDate@1000 : Date) : Date;
    VAR
      ReqLine@1004 : Record 246;
      LeadTimeMgt@1002 : Codeunit 5404;
    BEGIN
      EXIT(
        LeadTimeMgt.PlannedStartingDate(
          "Item No.","Location Code","Variant Code",'',
          LeadTimeMgt.ManufacturingLeadTime("Item No.","Location Code","Variant Code"),
          ReqLine."Ref. Order Type"::Assembly,EndingDate));
    END;

    LOCAL PROCEDURE CalcEndDateFromStartDate@21(StartingDate@1002 : Date) : Date;
    VAR
      ReqLine@1001 : Record 246;
      LeadTimeMgt@1000 : Codeunit 5404;
    BEGIN
      EXIT(
        LeadTimeMgt.PlannedEndingDate2(
          "Item No.","Location Code","Variant Code",'',
          LeadTimeMgt.ManufacturingLeadTime("Item No.","Location Code","Variant Code"),
          ReqLine."Ref. Order Type"::Assembly,StartingDate));
    END;

    LOCAL PROCEDURE CalcEndDateFromDueDate@31(DueDate@1002 : Date) : Date;
    VAR
      ReqLine@1001 : Record 246;
      LeadTimeMgt@1000 : Codeunit 5404;
    BEGIN
      EXIT(
        LeadTimeMgt.PlannedEndingDate(
          "Item No.","Location Code","Variant Code",DueDate,'',ReqLine."Ref. Order Type"::Assembly));
    END;

    LOCAL PROCEDURE CalcDueDateFromEndDate@32(EndingDate@1002 : Date) : Date;
    VAR
      ReqLine@1001 : Record 246;
      LeadTimeMgt@1000 : Codeunit 5404;
    BEGIN
      EXIT(
        LeadTimeMgt.PlannedDueDate(
          "Item No.","Location Code","Variant Code",EndingDate,'',ReqLine."Ref. Order Type"::Assembly));
    END;

    [Internal]
    PROCEDURE ValidateDates@34(FieldNumToCalculateFrom@1000 : Integer;DoNotValidateButJustAssign@1001 : Boolean);
    VAR
      NewDueDate@1002 : Date;
      NewEndDate@1003 : Date;
      NewStartDate@1004 : Date;
    BEGIN
      CASE FieldNumToCalculateFrom OF
        FIELDNO("Due Date"):
          BEGIN
            NewEndDate := CalcEndDateFromDueDate("Due Date");
            NewStartDate := CalcStartDateFromEndDate(NewEndDate);
            IF DoNotValidateButJustAssign THEN BEGIN
              "Ending Date" := NewEndDate;
              "Starting Date" := NewStartDate;
            END ELSE BEGIN
              ValidateEndDate(NewEndDate,FALSE);
              ValidateStartDate(NewStartDate,FALSE);
            END;
          END;
        FIELDNO("Ending Date"):
          BEGIN
            NewDueDate := CalcDueDateFromEndDate("Ending Date");
            NewStartDate := CalcStartDateFromEndDate("Ending Date");
            IF DoNotValidateButJustAssign THEN BEGIN
              "Due Date" := NewDueDate;
              "Starting Date" := NewStartDate;
            END ELSE BEGIN
              ValidateStartDate(NewStartDate,FALSE);
              IF NOT IsAsmToOrder THEN BEGIN
                IF "Due Date" <> NewDueDate THEN
                  IF GUIALLOWED AND
                     CONFIRM(STRSUBSTNO(Text012,
                         STRSUBSTNO(Text010,
                           STRSUBSTNO(Text011,FIELDCAPTION("Ending Date"),xRec."Ending Date","Ending Date")),
                         STRSUBSTNO(Text013,
                           STRSUBSTNO(Text011,FIELDCAPTION("Due Date"),"Due Date",NewDueDate))),
                       TRUE)
                  THEN
                    ValidateDueDate(NewDueDate,FALSE);
              END;
            END;
          END;
        FIELDNO("Starting Date"):
          BEGIN
            NewEndDate := CalcEndDateFromStartDate("Starting Date");
            NewDueDate := CalcDueDateFromEndDate(NewEndDate);
            IF DoNotValidateButJustAssign THEN BEGIN
              "Ending Date" := NewEndDate;
              "Due Date" := NewDueDate;
            END ELSE
              IF IsAsmToOrder THEN BEGIN
                IF "Ending Date" <> NewEndDate THEN
                  IF GUIALLOWED AND
                     CONFIRM(STRSUBSTNO(Text012,
                         STRSUBSTNO(Text010,
                           STRSUBSTNO(Text011,FIELDCAPTION("Starting Date"),xRec."Starting Date","Starting Date")),
                         STRSUBSTNO(Text013,
                           STRSUBSTNO(Text011,FIELDCAPTION("Ending Date"),"Ending Date",NewEndDate))),
                       TRUE)
                  THEN
                    ValidateEndDate(NewEndDate,FALSE);
              END ELSE
                IF ("Ending Date" <> NewEndDate) OR ("Due Date" <> NewDueDate) THEN
                  IF GUIALLOWED AND
                     CONFIRM(STRSUBSTNO(Text012,
                         STRSUBSTNO(Text010,
                           STRSUBSTNO(Text011,FIELDCAPTION("Starting Date"),xRec."Starting Date","Starting Date")),
                         STRSUBSTNO(Text013,
                           STRSUBSTNO(Text014,
                             STRSUBSTNO(Text011,FIELDCAPTION("Ending Date"),"Ending Date",NewEndDate),
                             STRSUBSTNO(Text011,FIELDCAPTION("Due Date"),"Due Date",NewDueDate)))),
                       TRUE)
                  THEN BEGIN
                    ValidateEndDate(NewEndDate,FALSE);
                    ValidateDueDate(NewDueDate,FALSE);
                  END;
          END;
      END;
      IF "Due Date" < "Ending Date" THEN
        ERROR(Text015,FIELDCAPTION("Due Date"),"Due Date",FIELDCAPTION("Ending Date"),"Ending Date");
      IF "Ending Date" < "Starting Date" THEN
        ERROR(Text015,FIELDCAPTION("Ending Date"),"Ending Date",FIELDCAPTION("Starting Date"),"Starting Date");
    END;

    LOCAL PROCEDURE ValidateDueDate@35(NewDueDate@1001 : Date;CallValidateOnOtherDates@1000 : Boolean);
    VAR
      ReservationCheckDateConfl@1002 : Codeunit 99000815;
    BEGIN
      "Due Date" := NewDueDate;
      CheckIsNotAsmToOrder;
      TestStatusOpen;

      IF CallValidateOnOtherDates THEN
        ValidateDates(FIELDNO("Due Date"),FALSE);
      IF (xRec."Due Date" <> "Due Date") AND (Quantity <> 0) THEN
        ReservationCheckDateConfl.AssemblyHeaderCheck(Rec,(CurrFieldNo <> 0) OR TestReservationDateConflict);
    END;

    LOCAL PROCEDURE ValidateEndDate@37(NewEndDate@1001 : Date;CallValidateOnOtherDates@1000 : Boolean);
    BEGIN
      "Ending Date" := NewEndDate;
      TestStatusOpen;

      IF CallValidateOnOtherDates THEN
        ValidateDates(FIELDNO("Ending Date"),FALSE);
    END;

    LOCAL PROCEDURE ValidateStartDate@39(NewStartDate@1000 : Date;CallValidateOnOtherDates@1001 : Boolean);
    BEGIN
      "Starting Date" := NewStartDate;
      TestStatusOpen;
      SetCurrentFieldNum(FIELDNO("Starting Date"));

      AssemblyLineMgt.UpdateAssemblyLines(Rec,xRec,FIELDNO("Starting Date"),FALSE,CurrFieldNo,CurrentFieldNum);
      ClearCurrentFieldNum(FIELDNO("Starting Date"));
      IF CallValidateOnOtherDates THEN
        ValidateDates(FIELDNO("Starting Date"),FALSE);
    END;

    LOCAL PROCEDURE CheckBin@36();
    VAR
      BinContent@1000 : Record 7302;
      Bin@1001 : Record 7354;
      Location@1002 : Record 14;
    BEGIN
      IF "Bin Code" <> '' THEN BEGIN
        GetLocation(Location,"Location Code");
        IF NOT Location."Directed Put-away and Pick" THEN
          EXIT;

        IF BinContent.GET(
             "Location Code","Bin Code",
             "Item No.","Variant Code","Unit of Measure Code")
        THEN
          BinContent.CheckWhseClass(FALSE)
        ELSE BEGIN
          Bin.GET("Location Code","Bin Code");
          Bin.CheckWhseClass("Item No.",FALSE);
        END;
      END;
    END;

    [External]
    PROCEDURE GetDefaultBin@50();
    VAR
      Location@1001 : Record 14;
      WMSManagement@1000 : Codeunit 7302;
    BEGIN
      IF (Quantity * xRec.Quantity > 0) AND
         ("Item No." = xRec."Item No.") AND
         ("Location Code" = xRec."Location Code") AND
         ("Variant Code" = xRec."Variant Code")
      THEN
        EXIT;

      "Bin Code" := '';
      IF ("Location Code" <> '') AND ("Item No." <> '') THEN BEGIN
        GetLocation(Location,"Location Code");
        IF GetFromAssemblyBin(Location,"Bin Code") THEN
          EXIT;

        IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
          WMSManagement.GetDefaultBin("Item No.","Variant Code","Location Code","Bin Code");
      END;
    END;

    [External]
    PROCEDURE GetFromAssemblyBin@11(Location@1000 : Record 14;VAR BinCode@1001 : Code[20]) BinCodeNotEmpty : Boolean;
    BEGIN
      IF Location."Bin Mandatory" THEN
        BinCode := Location."From-Assembly Bin Code";
      BinCodeNotEmpty := BinCode <> '';
    END;

    [External]
    PROCEDURE ValidateBinCode@12(NewBinCode@1002 : Code[20]);
    VAR
      WMSManagement@1001 : Codeunit 7302;
      WhseIntegrationMgt@1000 : Codeunit 7317;
    BEGIN
      "Bin Code" := NewBinCode;
      TestStatusOpen;

      IF "Bin Code" <> '' THEN BEGIN
        IF Quantity < 0 THEN
          WMSManagement.FindBinContent("Location Code","Bin Code","Item No.","Variant Code",'')
        ELSE
          WMSManagement.FindBin("Location Code","Bin Code",'');
        CALCFIELDS("Assemble to Order");
        IF NOT "Assemble to Order" THEN
          WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Assembly Header",
            FIELDCAPTION("Bin Code"),
            "Location Code",
            "Bin Code",0);
        CheckBin;
      END;
    END;

    [External]
    PROCEDURE CreatePick@44(ShowRequestPage@1005 : Boolean;AssignedUserID@1010 : Code[50];SortingMethod@1009 : Option;SetBreakBulkFilter@1008 : Boolean;DoNotFillQtyToHandle@1007 : Boolean;PrintDocument@1006 : Boolean);
    VAR
      WhseSourceCreateDocument@1002 : Report 7305;
    BEGIN
      AssemblyLineMgt.CreateWhseItemTrkgForAsmLines(Rec);
      COMMIT;

      TESTFIELD(Status,Status::Released);
      IF CompletelyPicked THEN
        ERROR(Text007);

      WhseSourceCreateDocument.SetAssemblyOrder(Rec);
      IF NOT ShowRequestPage THEN
        WhseSourceCreateDocument.Initialize(AssignedUserID,SortingMethod,PrintDocument,DoNotFillQtyToHandle,SetBreakBulkFilter);
      WhseSourceCreateDocument.USEREQUESTPAGE(ShowRequestPage);
      WhseSourceCreateDocument.RUNMODAL;
      WhseSourceCreateDocument.GetResultMessage(2);
      CLEAR(WhseSourceCreateDocument);
    END;

    [External]
    PROCEDURE CreateInvtMovement@40(MakeATOInvtMvmt@1001 : Boolean;PrintDocumentForATOMvmt@1004 : Boolean;ShowErrorForATOMvmt@1003 : Boolean;VAR ATOMovementsCreated@1006 : Integer;VAR ATOTotalMovementsToBeCreated@1005 : Integer);
    VAR
      WhseRequest@1000 : Record 5765;
      CreateInvtPutAwayPickMvmt@1002 : Report 7323;
    BEGIN
      TESTFIELD(Status,Status::Released);

      WhseRequest.RESET;
      WhseRequest.SETCURRENTKEY("Source Document","Source No.");
      WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Assembly Consumption");
      WhseRequest.SETRANGE("Source No.","No.");
      CreateInvtPutAwayPickMvmt.SETTABLEVIEW(WhseRequest);

      IF MakeATOInvtMvmt THEN BEGIN
        CreateInvtPutAwayPickMvmt.InitializeRequest(FALSE,FALSE,TRUE,PrintDocumentForATOMvmt,ShowErrorForATOMvmt);
        CreateInvtPutAwayPickMvmt.SuppressMessages(TRUE);
        CreateInvtPutAwayPickMvmt.USEREQUESTPAGE(FALSE);
      END;

      CreateInvtPutAwayPickMvmt.RUNMODAL;
      CreateInvtPutAwayPickMvmt.GetMovementCounters(ATOMovementsCreated,ATOTotalMovementsToBeCreated);
    END;

    [External]
    PROCEDURE CompletelyPicked@54() : Boolean;
    BEGIN
      EXIT(AssemblyLineMgt.CompletelyPicked(Rec));
    END;

    [External]
    PROCEDURE IsInbound@97() : Boolean;
    BEGIN
      IF "Document Type" IN ["Document Type"::Order,"Document Type"::Quote,"Document Type"::"Blanket Order"] THEN
        EXIT("Quantity (Base)" > 0);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@57();
    VAR
      AssemblyHeaderReserve@1000 : Codeunit 925;
    BEGIN
      TESTFIELD("No.");
      TESTFIELD("Quantity (Base)");
      AssemblyHeaderReserve.CallItemTracking(Rec);
    END;

    [External]
    PROCEDURE ItemExists@59(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      Item2@1001 : Record 27;
    BEGIN
      IF NOT Item2.GET(ItemNo) THEN
        EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE TestStatusOpen@60();
    BEGIN
      IF StatusCheckSuspended THEN
        EXIT;
      TESTFIELD(Status,Status::Open);
    END;

    [External]
    PROCEDURE SuspendStatusCheck@58(Suspend@1000 : Boolean);
    BEGIN
      StatusCheckSuspended := Suspend;
    END;

    [External]
    PROCEDURE IsStatusCheckSuspended@2() : Boolean;
    BEGIN
      EXIT(StatusCheckSuspended);
    END;

    [External]
    PROCEDURE ShowTracking@61();
    VAR
      OrderTracking@1000 : Page 99000822;
    BEGIN
      OrderTracking.SetAsmHeader(Rec);
      OrderTracking.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowAsmToOrder@62();
    VAR
      ATOLink@1000 : Record 904;
    BEGIN
      ATOLink.ShowSales(Rec);
    END;

    [External]
    PROCEDURE IsAsmToOrder@63() : Boolean;
    BEGIN
      CALCFIELDS("Assemble to Order");
      EXIT("Assemble to Order");
    END;

    LOCAL PROCEDURE CheckIsNotAsmToOrder@64();
    BEGIN
      CALCFIELDS("Assemble to Order");
      TESTFIELD("Assemble to Order",FALSE);
    END;

    [External]
    PROCEDURE IsStandardCostItem@65() : Boolean;
    BEGIN
      IF "Item No." = '' THEN
        EXIT(FALSE);
      GetItem;
      EXIT(Item."Costing Method" = Item."Costing Method"::Standard);
    END;

    [Internal]
    PROCEDURE ShowAvailability@18();
    VAR
      TempAssemblyHeader@1000 : TEMPORARY Record 900;
      TempAssemblyLine@1001 : TEMPORARY Record 901;
      AsmLineMgt@1002 : Codeunit 905;
    BEGIN
      AsmLineMgt.CopyAssemblyData(Rec,TempAssemblyHeader,TempAssemblyLine);
      AsmLineMgt.ShowAvailability(TRUE,TempAssemblyHeader,TempAssemblyLine);
    END;

    [External]
    PROCEDURE ShowDueDateBeforeWorkDateMsg@22();
    VAR
      TempAssemblyHeader@1002 : TEMPORARY Record 900;
      TempAssemblyLine@1001 : TEMPORARY Record 901;
      AsmLineMgt@1000 : Codeunit 905;
    BEGIN
      AsmLineMgt.CopyAssemblyData(Rec,TempAssemblyHeader,TempAssemblyLine);
      IF TempAssemblyLine.FINDSET THEN
        REPEAT
          IF TempAssemblyLine."Due Date" < WORKDATE THEN BEGIN
            AsmLineMgt.ShowDueDateBeforeWorkDateMsg(TempAssemblyLine."Due Date");
            EXIT;
          END;
        UNTIL TempAssemblyLine.NEXT = 0;
    END;

    [Internal]
    PROCEDURE AddBOMLine@19(BOMComp@1000 : Record 90);
    VAR
      AsmLine@1001 : Record 901;
    BEGIN
      AssemblyLineMgt.AddBOMLine(Rec,AsmLine,BOMComp);
      AutoReserveAsmLine(AsmLine);
    END;

    LOCAL PROCEDURE ReplaceLinesFromBOM@26() : Boolean;
    VAR
      NoLinesWerePresent@1002 : Boolean;
      LinesPresent@1000 : Boolean;
      DeleteLines@1001 : Boolean;
    BEGIN
      NoLinesWerePresent := (xRec.Quantity * xRec."Qty. per Unit of Measure" = 0);
      LinesPresent := (Quantity * "Qty. per Unit of Measure" <> 0);
      DeleteLines := (Quantity = 0);

      EXIT((NoLinesWerePresent AND LinesPresent) OR DeleteLines);
    END;

    LOCAL PROCEDURE SetCurrentFieldNum@20(NewCurrentFieldNum@1000 : Integer) : Boolean;
    BEGIN
      IF CurrentFieldNum = 0 THEN BEGIN
        CurrentFieldNum := NewCurrentFieldNum;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ClearCurrentFieldNum@24(NewCurrentFieldNum@1000 : Integer);
    BEGIN
      IF CurrentFieldNum = NewCurrentFieldNum THEN
        CurrentFieldNum := 0;
    END;

    [External]
    PROCEDURE UpdateWarningOnLines@47();
    BEGIN
      AssemblyLineMgt.UpdateWarningOnLines(Rec);
    END;

    [External]
    PROCEDURE SetWarningsOff@27();
    BEGIN
      AssemblyLineMgt.SetWarningsOff;
    END;

    LOCAL PROCEDURE SetDescriptionsFromItem@41();
    BEGIN
      GetItem;
      Description := Item.Description;
      "Description 2" := Item."Description 2";
    END;

    [External]
    PROCEDURE CalcTotalCost@25(VAR ExpCost@1001 : ARRAY [5] OF Decimal) : Decimal;
    VAR
      Resource@1004 : Record 156;
      AssemblyLine@1000 : Record 901;
      DirectLineCost@1005 : Decimal;
    BEGIN
      GLSetup.GET;

      AssemblyLine.SETRANGE("Document Type","Document Type");
      AssemblyLine.SETRANGE("Document No.","No.");
      IF AssemblyLine.FINDSET THEN
        REPEAT
          CASE AssemblyLine.Type OF
            AssemblyLine.Type::Item:
              ExpCost[RowIdx::MatCost] += AssemblyLine."Cost Amount";
            AssemblyLine.Type::Resource:
              BEGIN
                Resource.GET(AssemblyLine."No.");
                DirectLineCost :=
                  ROUND(
                    Resource."Direct Unit Cost" * AssemblyLine."Quantity (Base)",
                    GLSetup."Unit-Amount Rounding Precision");
                ExpCost[RowIdx::ResCost] += DirectLineCost;
                ExpCost[RowIdx::ResOvhd] += AssemblyLine."Cost Amount" - DirectLineCost;
              END;
          END
        UNTIL AssemblyLine.NEXT = 0;

      EXIT(ExpCost[RowIdx::MatCost] + ExpCost[RowIdx::ResCost] + ExpCost[RowIdx::ResOvhd]);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@138(VAR AssemblyHeader@1000 : Record 900;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

