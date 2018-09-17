OBJECT Table 14 Location
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    DataCaptionFields=Code,Name;
    OnDelete=VAR
               TransferRoute@1000 : Record 5742;
               WhseEmployee@1003 : Record 7301;
               WorkCenter@1004 : Record 99000754;
               StockkeepingUnit@1001 : Record 5700;
             BEGIN
               StockkeepingUnit.SETRANGE("Location Code",Code);
               IF NOT StockkeepingUnit.ISEMPTY THEN
                 ERROR(CannotDeleteLocSKUExistErr,Code);

               WMSCheckWarehouse;

               TransferRoute.SETRANGE("Transfer-from Code",Code);
               TransferRoute.DELETEALL;
               TransferRoute.RESET;
               TransferRoute.SETRANGE("Transfer-to Code",Code);
               TransferRoute.DELETEALL;

               WhseEmployee.SETRANGE("Location Code",Code);
               WhseEmployee.DELETEALL(TRUE);

               WorkCenter.SETRANGE("Location Code",Code);
               IF WorkCenter.FINDSET(TRUE) THEN
                 REPEAT
                   WorkCenter.VALIDATE("Location Code",'');
                   WorkCenter.MODIFY(TRUE);
                 UNTIL WorkCenter.NEXT = 0;

               CalendarManagement.DeleteCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::Location,Code);
             END;

    OnRename=BEGIN
               CalendarManagement.RenameCustomizedBaseCalendarData(CustomizedCalendarChange."Source Type"::Location,Code,xRec.Code);
             END;

    CaptionML=[DAN=Lokation;
               ENU=Location];
    LookupPageID=Page15;
    DrillDownPageID=Page15;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 130 ;   ;Default Bin Code    ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   CaptionML=[DAN=Standardplaceringskode;
                                                              ENU=Default Bin Code] }
    { 5700;   ;Name 2              ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2] }
    { 5701;   ;Address             ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Address] }
    { 5702;   ;Address 2           ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2] }
    { 5703;   ;City                ;Text30        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                Postcode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 5704;   ;Phone No.           ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.] }
    { 5705;   ;Phone No. 2         ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon 2;
                                                              ENU=Phone No. 2] }
    { 5706;   ;Telex No.           ;Text30        ;CaptionML=[DAN=Telex;
                                                              ENU=Telex No.] }
    { 5707;   ;Fax No.             ;Text30        ;CaptionML=[DAN=Telefax;
                                                              ENU=Fax No.] }
    { 5713;   ;Contact             ;Text50        ;CaptionML=[DAN=Kontakt;
                                                              ENU=Contact] }
    { 5714;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                Postcode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 5715;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 5718;   ;E-Mail              ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Mail;
                                                              ENU=Email] }
    { 5719;   ;Home Page           ;Text90        ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=Hjemmeside;
                                                              ENU=Home Page] }
    { 5720;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code] }
    { 5724;   ;Use As In-Transit   ;Boolean       ;OnValidate=BEGIN
                                                                IF "Use As In-Transit" THEN BEGIN
                                                                  TESTFIELD("Require Put-away",FALSE);
                                                                  TESTFIELD("Require Pick",FALSE);
                                                                  TESTFIELD("Use Cross-Docking",FALSE);
                                                                  TESTFIELD("Require Receive",FALSE);
                                                                  TESTFIELD("Require Shipment",FALSE);
                                                                  TESTFIELD("Bin Mandatory",FALSE);
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 5740=R;
                                                   CaptionML=[DAN=Brug som transitlokation;
                                                              ENU=Use As In-Transit] }
    { 5726;   ;Require Put-away    ;Boolean       ;OnValidate=VAR
                                                                WhseActivHeader@1000 : Record 5766;
                                                                WhseRcptHeader@1001 : Record 7316;
                                                              BEGIN
                                                                WhseRcptHeader.SETRANGE("Location Code",Code);
                                                                IF NOT WhseRcptHeader.ISEMPTY THEN
                                                                  ERROR(Text008,FIELDCAPTION("Require Put-away"),xRec."Require Put-away",WhseRcptHeader.TABLECAPTION);

                                                                IF NOT "Require Put-away" THEN BEGIN
                                                                  TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                  WhseActivHeader.SETRANGE(Type,WhseActivHeader.Type::"Put-away");
                                                                  WhseActivHeader.SETRANGE("Location Code",Code);
                                                                  IF NOT WhseActivHeader.ISEMPTY THEN
                                                                    ERROR(Text008,FIELDCAPTION("Require Put-away"),TRUE,WhseActivHeader.TABLECAPTION);
                                                                  "Use Cross-Docking" := FALSE;
                                                                  "Cross-Dock Bin Code" := '';
                                                                END ELSE
                                                                  CreateInboundWhseRequest;
                                                              END;

                                                   AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Kr�v l�g-p�-lager;
                                                              ENU=Require Put-away] }
    { 5727;   ;Require Pick        ;Boolean       ;OnValidate=VAR
                                                                WhseActivHeader@1000 : Record 5766;
                                                                WhseShptHeader@1001 : Record 7320;
                                                              BEGIN
                                                                WhseShptHeader.SETRANGE("Location Code",Code);
                                                                IF NOT WhseShptHeader.ISEMPTY THEN
                                                                  ERROR(Text008,FIELDCAPTION("Require Pick"),xRec."Require Pick",WhseShptHeader.TABLECAPTION);

                                                                IF NOT "Require Pick" THEN BEGIN
                                                                  TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                  WhseActivHeader.SETRANGE(Type,WhseActivHeader.Type::Pick);
                                                                  WhseActivHeader.SETRANGE("Location Code",Code);
                                                                  IF NOT WhseActivHeader.ISEMPTY THEN
                                                                    ERROR(Text008,FIELDCAPTION("Require Pick"),TRUE,WhseActivHeader.TABLECAPTION);
                                                                  "Use Cross-Docking" := FALSE;
                                                                  "Cross-Dock Bin Code" := '';
                                                                  "Pick According to FEFO" := FALSE;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Kr�v pluk;
                                                              ENU=Require Pick] }
    { 5728;   ;Cross-Dock Due Date Calc.;DateFormula;
                                                   AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Dir. afs. dato formel;
                                                              ENU=Cross-Dock Due Date Calc.] }
    { 5729;   ;Use Cross-Docking   ;Boolean       ;OnValidate=BEGIN
                                                                IF "Use Cross-Docking" THEN BEGIN
                                                                  TESTFIELD("Require Receive");
                                                                  TESTFIELD("Require Shipment");
                                                                  TESTFIELD("Require Put-away");
                                                                  TESTFIELD("Require Pick");
                                                                END ELSE
                                                                  "Cross-Dock Bin Code" := '';
                                                              END;

                                                   AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Brug dir. afsendelse;
                                                              ENU=Use Cross-Docking] }
    { 5730;   ;Require Receive     ;Boolean       ;OnValidate=VAR
                                                                WhseRcptHeader@1000 : Record 7316;
                                                                WhseActivHeader@1001 : Record 5766;
                                                              BEGIN
                                                                IF NOT "Require Receive" THEN BEGIN
                                                                  TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                  WhseRcptHeader.SETRANGE("Location Code",Code);
                                                                  IF NOT WhseRcptHeader.ISEMPTY THEN
                                                                    ERROR(Text008,FIELDCAPTION("Require Receive"),TRUE,WhseRcptHeader.TABLECAPTION);
                                                                  "Receipt Bin Code" := '';
                                                                  "Use Cross-Docking" := FALSE;
                                                                  "Cross-Dock Bin Code" := '';
                                                                END ELSE BEGIN
                                                                  WhseActivHeader.SETRANGE(Type,WhseActivHeader.Type::"Put-away");
                                                                  WhseActivHeader.SETRANGE("Location Code",Code);
                                                                  IF NOT WhseActivHeader.ISEMPTY THEN
                                                                    ERROR(Text008,FIELDCAPTION("Require Receive"),FALSE,WhseActivHeader.TABLECAPTION);

                                                                  CreateInboundWhseRequest;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 7316=R;
                                                   CaptionML=[DAN=Kr�v modtagelse;
                                                              ENU=Require Receive] }
    { 5731;   ;Require Shipment    ;Boolean       ;OnValidate=VAR
                                                                WhseShptHeader@1000 : Record 7320;
                                                                WhseActivHeader@1001 : Record 5766;
                                                              BEGIN
                                                                IF NOT "Require Shipment" THEN BEGIN
                                                                  TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                  WhseShptHeader.SETRANGE("Location Code",Code);
                                                                  IF NOT WhseShptHeader.ISEMPTY THEN
                                                                    ERROR(Text008,FIELDCAPTION("Require Shipment"),TRUE,WhseShptHeader.TABLECAPTION);
                                                                  "Shipment Bin Code" := '';
                                                                  "Use Cross-Docking" := FALSE;
                                                                  "Cross-Dock Bin Code" := '';
                                                                END ELSE BEGIN
                                                                  WhseActivHeader.SETRANGE(Type,WhseActivHeader.Type::Pick);
                                                                  WhseActivHeader.SETRANGE("Location Code",Code);
                                                                  IF NOT WhseActivHeader.ISEMPTY THEN
                                                                    ERROR(Text008,FIELDCAPTION("Require Shipment"),FALSE,WhseActivHeader.TABLECAPTION);
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 7320=R;
                                                   CaptionML=[DAN=Kr�v leverance;
                                                              ENU=Require Shipment] }
    { 5732;   ;Bin Mandatory       ;Boolean       ;OnValidate=VAR
                                                                ItemLedgEntry@1004 : Record 32;
                                                                WhseEntry@1000 : Record 7312;
                                                                WhseActivHeader@1001 : Record 5766;
                                                                WhseShptHeader@1002 : Record 7320;
                                                                WhseRcptHeader@1003 : Record 7316;
                                                                WhseIntegrationMgt@1006 : Codeunit 7317;
                                                                Window@1005 : Dialog;
                                                              BEGIN
                                                                IF "Bin Mandatory" AND NOT xRec."Bin Mandatory" THEN BEGIN
                                                                  Window.OPEN(Text010);
                                                                  ItemLedgEntry.SETRANGE(Open,TRUE);
                                                                  ItemLedgEntry.SETRANGE("Location Code",Code);
                                                                  IF NOT ItemLedgEntry.ISEMPTY THEN
                                                                    ERROR(Text009,FIELDCAPTION("Bin Mandatory"));

                                                                  "Default Bin Selection" := "Default Bin Selection"::"Fixed Bin";
                                                                END;

                                                                WhseActivHeader.SETRANGE("Location Code",Code);
                                                                IF NOT WhseActivHeader.ISEMPTY THEN
                                                                  ERROR(Text008,FIELDCAPTION("Bin Mandatory"),xRec."Bin Mandatory",WhseActivHeader.TABLECAPTION);

                                                                WhseRcptHeader.SETCURRENTKEY("Location Code");
                                                                WhseRcptHeader.SETRANGE("Location Code",Code);
                                                                IF NOT WhseRcptHeader.ISEMPTY THEN
                                                                  ERROR(Text008,FIELDCAPTION("Bin Mandatory"),xRec."Bin Mandatory",WhseRcptHeader.TABLECAPTION);

                                                                WhseShptHeader.SETCURRENTKEY("Location Code");
                                                                WhseShptHeader.SETRANGE("Location Code",Code);
                                                                IF NOT WhseShptHeader.ISEMPTY THEN
                                                                  ERROR(Text008,FIELDCAPTION("Bin Mandatory"),xRec."Bin Mandatory",WhseShptHeader.TABLECAPTION);

                                                                IF NOT "Bin Mandatory" AND xRec."Bin Mandatory" THEN BEGIN
                                                                  WhseEntry.SETRANGE("Location Code",Code);
                                                                  WhseEntry.CALCSUMS("Qty. (Base)");
                                                                  IF WhseEntry."Qty. (Base)" <> 0 THEN
                                                                    ERROR(Text002,FIELDCAPTION("Bin Mandatory"));
                                                                END;

                                                                IF NOT "Bin Mandatory" THEN BEGIN
                                                                  "Open Shop Floor Bin Code" := '';
                                                                  "To-Production Bin Code" := '';
                                                                  "From-Production Bin Code" := '';
                                                                  "Adjustment Bin Code" := '';
                                                                  "Receipt Bin Code" := '';
                                                                  "Shipment Bin Code" := '';
                                                                  "Cross-Dock Bin Code" := '';
                                                                  "To-Assembly Bin Code" := '';
                                                                  "From-Assembly Bin Code" := '';
                                                                  WhseIntegrationMgt.CheckLocationOnManufBins(Rec);
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Tvungen placering;
                                                              ENU=Bin Mandatory] }
    { 5733;   ;Directed Put-away and Pick;Boolean ;OnValidate=VAR
                                                                WhseActivHeader@1002 : Record 5766;
                                                                WhseShptHeader@1001 : Record 7320;
                                                                WhseRcptHeader@1000 : Record 7316;
                                                              BEGIN
                                                                WhseActivHeader.SETRANGE("Location Code",Code);
                                                                IF NOT WhseActivHeader.ISEMPTY THEN
                                                                  ERROR(Text014,FIELDCAPTION("Directed Put-away and Pick"),WhseActivHeader.TABLECAPTION);

                                                                WhseRcptHeader.SETCURRENTKEY("Location Code");
                                                                WhseRcptHeader.SETRANGE("Location Code",Code);
                                                                IF NOT WhseRcptHeader.ISEMPTY THEN
                                                                  ERROR(Text014,FIELDCAPTION("Directed Put-away and Pick"),WhseRcptHeader.TABLECAPTION);

                                                                WhseShptHeader.SETCURRENTKEY("Location Code");
                                                                WhseShptHeader.SETRANGE("Location Code",Code);
                                                                IF NOT WhseShptHeader.ISEMPTY THEN
                                                                  ERROR(Text014,FIELDCAPTION("Directed Put-away and Pick"),WhseShptHeader.TABLECAPTION);

                                                                IF "Directed Put-away and Pick" THEN BEGIN
                                                                  TESTFIELD("Use As In-Transit",FALSE);
                                                                  TESTFIELD("Bin Mandatory");
                                                                  VALIDATE("Require Receive",TRUE);
                                                                  VALIDATE("Require Shipment",TRUE);
                                                                  VALIDATE("Require Put-away",TRUE);
                                                                  VALIDATE("Require Pick",TRUE);
                                                                  VALIDATE("Use Cross-Docking",TRUE);
                                                                  "Default Bin Selection" := "Default Bin Selection"::" ";
                                                                END ELSE
                                                                  VALIDATE("Adjustment Bin Code",'');

                                                                IF (NOT "Directed Put-away and Pick") AND xRec."Directed Put-away and Pick" THEN BEGIN
                                                                  "Default Bin Selection" := "Default Bin Selection"::"Fixed Bin";
                                                                  "Use Put-away Worksheet" := FALSE;
                                                                  VALIDATE("Use Cross-Docking",FALSE);
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Styret l�g-p�-lager og pluk;
                                                              ENU=Directed Put-away and Pick] }
    { 5734;   ;Default Bin Selection;Option       ;OnValidate=BEGIN
                                                                IF ("Default Bin Selection" <> xRec."Default Bin Selection") AND ("Default Bin Selection" = "Default Bin Selection"::" ") THEN
                                                                  TESTFIELD("Directed Put-away and Pick");
                                                              END;

                                                   AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Standardplacering;
                                                              ENU=Default Bin Selection];
                                                   OptionCaptionML=[DAN=" ,Fast placering,Sidst anv. placering";
                                                                    ENU=" ,Fixed Bin,Last-Used Bin"];
                                                   OptionString=[ ,Fixed Bin,Last-Used Bin] }
    { 5790;   ;Outbound Whse. Handling Time;DateFormula;
                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=Udg�ende lagerekspeditionstid;
                                                              ENU=Outbound Whse. Handling Time] }
    { 5791;   ;Inbound Whse. Handling Time;DateFormula;
                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=Indg�ende lagerekspeditionstid;
                                                              ENU=Inbound Whse. Handling Time] }
    { 7305;   ;Put-away Template Code;Code10      ;TableRelation="Put-away Template Header";
                                                   CaptionML=[DAN=L�g-p�-lager-skabelonkode;
                                                              ENU=Put-away Template Code] }
    { 7306;   ;Use Put-away Worksheet;Boolean     ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Brug l�g-p�-lager-kladde;
                                                              ENU=Use Put-away Worksheet] }
    { 7307;   ;Pick According to FEFO;Boolean     ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=V�lg i overensstemmelse med FEFO;
                                                              ENU=Pick According to FEFO] }
    { 7308;   ;Allow Breakbulk     ;Boolean       ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Tillad nedbrydning;
                                                              ENU=Allow Breakbulk] }
    { 7309;   ;Bin Capacity Policy ;Option        ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Placeringskap.regel;
                                                              ENU=Bin Capacity Policy];
                                                   OptionCaptionML=[DAN=Tjek aldrig kapacitet,Tillad mere end maks. kap.,Forbyd mere end maks. kap.;
                                                                    ENU=Never Check Capacity,Allow More Than Max. Capacity,Prohibit More Than Max. Cap.];
                                                   OptionString=Never Check Capacity,Allow More Than Max. Capacity,Prohibit More Than Max. Cap. }
    { 7313;   ;Open Shop Floor Bin Code;Code20    ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   OnValidate=VAR
                                                                WhseIntegrationMgt@1000 : Codeunit 7317;
                                                              BEGIN
                                                                WhseIntegrationMgt.CheckBinCode(Code,
                                                                  "Open Shop Floor Bin Code",
                                                                  FIELDCAPTION("Open Shop Floor Bin Code"),
                                                                  DATABASE::Location,Code);
                                                              END;

                                                   CaptionML=[DAN=�ben prod.placeringskode;
                                                              ENU=Open Shop Floor Bin Code] }
    { 7314;   ;To-Production Bin Code;Code20      ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   OnValidate=VAR
                                                                WhseIntegrationMgt@1000 : Codeunit 7317;
                                                              BEGIN
                                                                WhseIntegrationMgt.CheckBinCode(Code,
                                                                  "To-Production Bin Code",
                                                                  FIELDCAPTION("To-Production Bin Code"),
                                                                  DATABASE::Location,Code);
                                                              END;

                                                   CaptionML=[DAN=Til-produktionsplaceringskode;
                                                              ENU=To-Production Bin Code] }
    { 7315;   ;From-Production Bin Code;Code20    ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   OnValidate=VAR
                                                                WhseIntegrationMgt@1000 : Codeunit 7317;
                                                              BEGIN
                                                                WhseIntegrationMgt.CheckBinCode(Code,
                                                                  "From-Production Bin Code",
                                                                  FIELDCAPTION("From-Production Bin Code"),
                                                                  DATABASE::Location,Code);
                                                              END;

                                                   CaptionML=[DAN=Fra-produktionsplaceringskode;
                                                              ENU=From-Production Bin Code] }
    { 7317;   ;Adjustment Bin Code ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   OnValidate=BEGIN
                                                                IF "Adjustment Bin Code" <> xRec."Adjustment Bin Code" THEN BEGIN
                                                                  IF "Adjustment Bin Code" = '' THEN
                                                                    CheckEmptyBin(
                                                                      xRec."Adjustment Bin Code",FIELDCAPTION("Adjustment Bin Code"))
                                                                  ELSE
                                                                    CheckEmptyBin(
                                                                      "Adjustment Bin Code",FIELDCAPTION("Adjustment Bin Code"));

                                                                  CheckWhseAdjmtJnl;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Regul.placeringskode;
                                                              ENU=Adjustment Bin Code] }
    { 7319;   ;Always Create Put-away Line;Boolean;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Opret altid l�g-p�-lager-linje;
                                                              ENU=Always Create Put-away Line] }
    { 7320;   ;Always Create Pick Line;Boolean    ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Opret altid pluklinje;
                                                              ENU=Always Create Pick Line] }
    { 7321;   ;Special Equipment   ;Option        ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Specialudstyr;
                                                              ENU=Special Equipment];
                                                   OptionCaptionML=[DAN=" ,Efter placering,Efter lagervare/vare";
                                                                    ENU=" ,According to Bin,According to SKU/Item"];
                                                   OptionString=[ ,According to Bin,According to SKU/Item] }
    { 7323;   ;Receipt Bin Code    ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   CaptionML=[DAN=Modt.placeringskode;
                                                              ENU=Receipt Bin Code] }
    { 7325;   ;Shipment Bin Code   ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   CaptionML=[DAN=Lev.placeringskode;
                                                              ENU=Shipment Bin Code] }
    { 7326;   ;Cross-Dock Bin Code ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   CaptionML=[DAN=Dir.afs.placeringskode;
                                                              ENU=Cross-Dock Bin Code] }
    { 7330;   ;To-Assembly Bin Code;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   OnValidate=VAR
                                                                WhseIntegrationMgt@1000 : Codeunit 7317;
                                                              BEGIN
                                                                WhseIntegrationMgt.CheckBinCode(Code,
                                                                  "To-Assembly Bin Code",
                                                                  FIELDCAPTION("To-Assembly Bin Code"),
                                                                  DATABASE::Location,Code);
                                                              END;

                                                   CaptionML=[DAN=Placeringskode til til-montage;
                                                              ENU=To-Assembly Bin Code] }
    { 7331;   ;From-Assembly Bin Code;Code20      ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   OnValidate=VAR
                                                                WhseIntegrationMgt@1000 : Codeunit 7317;
                                                              BEGIN
                                                                WhseIntegrationMgt.CheckBinCode(Code,
                                                                  "From-Assembly Bin Code",
                                                                  FIELDCAPTION("From-Assembly Bin Code"),
                                                                  DATABASE::Location,Code);
                                                              END;

                                                   CaptionML=[DAN=Placeringskode til fra-montage;
                                                              ENU=From-Assembly Bin Code] }
    { 7332;   ;Asm.-to-Order Shpt. Bin Code;Code20;TableRelation=Bin.Code WHERE (Location Code=FIELD(Code));
                                                   OnValidate=VAR
                                                                WhseIntegrationMgt@1000 : Codeunit 7317;
                                                              BEGIN
                                                                WhseIntegrationMgt.CheckBinCode(Code,
                                                                  "Asm.-to-Order Shpt. Bin Code",
                                                                  FIELDCAPTION("Asm.-to-Order Shpt. Bin Code"),
                                                                  DATABASE::Location,Code);
                                                              END;

                                                   CaptionML=[DAN=Pla.kode til ordremontagelev.;
                                                              ENU=Asm.-to-Order Shpt. Bin Code] }
    { 7600;   ;Base Calendar Code  ;Code10        ;TableRelation="Base Calendar";
                                                   CaptionML=[DAN=Basiskalenderkode;
                                                              ENU=Base Calendar Code] }
    { 7700;   ;Use ADCS            ;Boolean       ;AccessByPermission=TableData 7700=R;
                                                   CaptionML=[DAN=Brug ADCS;
                                                              ENU=Use ADCS] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
    {    ;Name                                     }
    {    ;Use As In-Transit,Bin Mandatory          }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Bin@1000 : Record 7354;
      Postcode@1001 : Record 225;
      WhseSetup@1002 : Record 5769;
      InvtSetup@1003 : Record 313;
      Location@1004 : Record 14;
      CustomizedCalendarChange@1023 : Record 7602;
      Text000@1005 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi de indeholder varer.;ENU=You cannot delete the %1 %2, because they contain items.';
      Text001@1006 : TextConst 'DAN=Du kan ikke slette %1 %2 , fordi der findes �n eller flere lageraktivitetslinjer til %1.;ENU=You cannot delete the %1 %2, because one or more Warehouse Activity Lines exist for this %1.';
      Text002@1007 : TextConst 'DAN=%1 skal v�re Ja, fordi placeringerne indeholder varer.;ENU=%1 must be Yes, because the bins contain items.';
      Text003@1009 : TextConst 'DAN=Annulleret.;ENU=Cancelled.';
      Text004@1010 : TextConst 'DAN=Det samlede antal varer p� lageret er 0, men justeringsplaceringen indeholder et negativt antal, og andre placeringer indeholder et positivt antal.\;ENU=The total quantity of items in the warehouse is 0, but the Adjustment Bin contains a negative quantity and other bins contain a positive quantity.\';
      Text005@1012 : TextConst 'DAN=Vil du stadig slette %1?;ENU=Do you still want to delete this %1?';
      Text006@1011 : TextConst 'DAN=Du kan ikke �ndre %1, f�r lagerbeholdningen i %2 %3 er 0.;ENU=You cannot change the %1 until the inventory stored in %2 %3 is 0.';
      Text007@1013 : TextConst 'DAN=Du skal slette alle justerings-lagerkladdelinjer, f�r du �ndrer %1.;ENU=You have to delete all Adjustment Warehouse Journal Lines first before you can change the %1.';
      Text008@1008 : TextConst 'DAN=%1 skal v�re %2, fordi der findes en eller flere %3er.;ENU=%1 must be %2, because one or more %3 exist.';
      Text009@1014 : TextConst 'DAN=Du kan ikke �ndre %1, fordi der er en eller flere �bne poster p� denne lokation.;ENU=You cannot change %1 because there are one or more open ledger entries on this location.';
      Text010@1015 : TextConst 'DAN=Kontrollerer vareposter for �bne poster...;ENU=Checking item ledger entries for open entries...';
      Text011@1016 : TextConst 'DAN=Du kan ikke �ndre %1 til %2, f�r lageret, der er gemt p� denne placering, er 0.;ENU=You cannot change the %1 to %2 until the inventory stored in this bin is 0.';
      Text012@1017 : TextConst 'DAN=Vinduet Ops�tning af Online Map skal udfyldes, f�r du kan bruge Online Map.\Se Ops�tning af Online Map i Hj�lp.;ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      Text013@1018 : TextConst 'DAN=Du kan ikke slette %1, fordi der er en eller flere finansposter p� denne lokation.;ENU=You cannot delete %1 because there are one or more ledger entries on this location.';
      Text014@1019 : TextConst 'DAN=Du kan ikke �ndre %1, da der findes en eller flere %2.;ENU=You cannot change %1 because one or more %2 exist.';
      CannotDeleteLocSKUExistErr@1021 : TextConst '@@@=%1: Field(Code);DAN=Du kan ikke slette %1, fordi en eller flere lagervarer findes p� denne lokation.;ENU=You cannot delete %1 because one or more stockkeeping units exist at this location.';
      CalendarManagement@1022 : Codeunit 7600;
      UnspecifiedLocationLbl@1020 : TextConst 'DAN=(Ikke specificeret lokation);ENU=(Unspecified Location)';

    [External]
    PROCEDURE RequireShipment@5(LocationCode@1000 : Code[10]) : Boolean;
    BEGIN
      IF Location.GET(LocationCode) THEN
        EXIT(Location."Require Shipment");
      WhseSetup.GET;
      EXIT(WhseSetup."Require Shipment");
    END;

    [External]
    PROCEDURE RequirePicking@1(LocationCode@1000 : Code[10]) : Boolean;
    BEGIN
      IF Location.GET(LocationCode) THEN
        EXIT(Location."Require Pick");
      WhseSetup.GET;
      EXIT(WhseSetup."Require Pick");
    END;

    [External]
    PROCEDURE RequireReceive@4(LocationCode@1000 : Code[10]) : Boolean;
    BEGIN
      IF Location.GET(LocationCode) THEN
        EXIT(Location."Require Receive");
      WhseSetup.GET;
      EXIT(WhseSetup."Require Receive");
    END;

    [External]
    PROCEDURE RequirePutaway@2(LocationCode@1000 : Code[10]) : Boolean;
    BEGIN
      IF Location.GET(LocationCode) THEN
        EXIT(Location."Require Put-away");
      WhseSetup.GET;
      EXIT(WhseSetup."Require Put-away");
    END;

    [External]
    PROCEDURE GetLocationSetup@3(LocationCode@1000 : Code[10];VAR Location2@1001 : Record 14) : Boolean;
    BEGIN
      IF NOT GET(LocationCode) THEN
        WITH Location2 DO BEGIN
          INIT;
          WhseSetup.GET;
          InvtSetup.GET;
          Code := LocationCode;
          "Use As In-Transit" := FALSE;
          "Require Put-away" := WhseSetup."Require Put-away";
          "Require Pick" := WhseSetup."Require Pick";
          "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
          "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
          "Require Receive" := WhseSetup."Require Receive";
          "Require Shipment" := WhseSetup."Require Shipment";
          EXIT(FALSE);
        END;

      Location2 := Rec;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE WMSCheckWarehouse@7300();
    VAR
      Zone@1005 : Record 7300;
      Bin@1006 : Record 7354;
      BinContent@1004 : Record 7302;
      WhseActivLine@1003 : Record 5767;
      WarehouseEntry@1002 : Record 7312;
      WarehouseEntry2@1001 : Record 7312;
      WhseJnlLine@1000 : Record 7311;
      ItemLedgerEntry@1007 : Record 32;
    BEGIN
      ItemLedgerEntry.SETRANGE("Location Code",Code);
      ItemLedgerEntry.SETRANGE(Open,TRUE);
      IF NOT ItemLedgerEntry.ISEMPTY THEN
        ERROR(Text013,Code);

      WarehouseEntry.SETRANGE("Location Code",Code);
      WarehouseEntry.CALCSUMS("Qty. (Base)");
      IF WarehouseEntry."Qty. (Base)" = 0 THEN BEGIN
        IF "Adjustment Bin Code" <> '' THEN BEGIN
          WarehouseEntry2.SETRANGE("Bin Code","Adjustment Bin Code");
          WarehouseEntry2.SETRANGE("Location Code",Code);
          WarehouseEntry2.CALCSUMS("Qty. (Base)");
          IF WarehouseEntry2."Qty. (Base)" < 0 THEN
            IF NOT CONFIRM(Text004 + Text005,FALSE,TABLECAPTION) THEN
              ERROR(Text003)
        END;
      END ELSE
        ERROR(Text000,TABLECAPTION,Code);

      WhseActivLine.SETRANGE("Location Code",Code);
      WhseActivLine.SETRANGE("Activity Type",WhseActivLine."Activity Type"::Movement);
      WhseActivLine.SETFILTER("Qty. Outstanding",'<>0');
      IF NOT WhseActivLine.ISEMPTY THEN
        ERROR(Text001,TABLECAPTION,Code);

      WhseJnlLine.SETRANGE("Location Code",Code);
      WhseJnlLine.SETFILTER(Quantity,'<>0');
      IF NOT WhseJnlLine.ISEMPTY THEN
        ERROR(Text001,TABLECAPTION,Code);

      Zone.SETRANGE("Location Code",Code);
      Zone.DELETEALL;
      Bin.SETRANGE("Location Code",Code);
      Bin.DELETEALL;
      BinContent.SETRANGE("Location Code",Code);
      BinContent.DELETEALL;
    END;

    LOCAL PROCEDURE CheckEmptyBin@7302(BinCode@1001 : Code[20];CaptionOfField@1002 : Text[30]);
    VAR
      WarehouseEntry@1003 : Record 7312;
      WhseEntry2@1000 : Record 7312;
    BEGIN
      WarehouseEntry.SETCURRENTKEY("Bin Code","Location Code","Item No.");
      WarehouseEntry.SETRANGE("Bin Code",BinCode);
      WarehouseEntry.SETRANGE("Location Code",Code);
      IF WarehouseEntry.FINDFIRST THEN
        REPEAT
          WarehouseEntry.SETRANGE("Item No.",WarehouseEntry."Item No.");

          WhseEntry2.SETCURRENTKEY("Item No.","Bin Code","Location Code");
          WhseEntry2.COPYFILTERS(WarehouseEntry);
          WhseEntry2.CALCSUMS("Qty. (Base)");
          IF WhseEntry2."Qty. (Base)" <> 0 THEN BEGIN
            IF (BinCode = "Adjustment Bin Code") AND (xRec."Adjustment Bin Code" = '') THEN
              ERROR(Text011,CaptionOfField,BinCode);

            ERROR(Text006,CaptionOfField,Bin.TABLECAPTION,BinCode);
          END;

          WarehouseEntry.FINDLAST;
          WarehouseEntry.SETRANGE("Item No.");
        UNTIL WarehouseEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckWhseAdjmtJnl@7303();
    VAR
      WhseJnlTemplate@1002 : Record 7309;
      WhseJnlLine@1003 : Record 7311;
    BEGIN
      WhseJnlTemplate.SETRANGE(Type,WhseJnlTemplate.Type::Item);
      IF WhseJnlTemplate.FIND('-') THEN
        REPEAT
          WhseJnlLine.SETRANGE("Journal Template Name",WhseJnlTemplate.Name);
          WhseJnlLine.SETRANGE("Location Code",Code);
          IF NOT WhseJnlLine.ISEMPTY THEN
            ERROR(
              Text007,
              FIELDCAPTION("Adjustment Bin Code"));
        UNTIL WhseJnlTemplate.NEXT = 0;
    END;

    [External]
    PROCEDURE GetRequirementText@6(FieldNumber@1000 : Integer) : Text[50];
    VAR
      Text000@1002 : TextConst 'DAN=Leverance,Modtagelse,Pluk,L�g-p�-lager;ENU=Shipment,Receive,Pick,Put-Away';
    BEGIN
      CASE FieldNumber OF
        FIELDNO("Require Shipment"):
          EXIT(SELECTSTR(1,Text000));
        FIELDNO("Require Receive"):
          EXIT(SELECTSTR(2,Text000));
        FIELDNO("Require Pick"):
          EXIT(SELECTSTR(3,Text000));
        FIELDNO("Require Put-away"):
          EXIT(SELECTSTR(4,Text000));
      END;
    END;

    [Internal]
    PROCEDURE DisplayMap@7();
    VAR
      MapPoint@1001 : Record 800;
      MapMgt@1000 : Codeunit 802;
    BEGIN
      IF MapPoint.FINDFIRST THEN
        MapMgt.MakeSelection(DATABASE::Location,GETPOSITION)
      ELSE
        MESSAGE(Text012);
    END;

    [External]
    PROCEDURE IsBWReceive@8() : Boolean;
    BEGIN
      EXIT("Bin Mandatory" AND (NOT "Directed Put-away and Pick") AND "Require Receive");
    END;

    [External]
    PROCEDURE IsBWShip@12() : Boolean;
    BEGIN
      EXIT("Bin Mandatory" AND (NOT "Directed Put-away and Pick") AND "Require Shipment");
    END;

    [External]
    PROCEDURE IsBinBWReceiveOrShip@11(BinCode@1000 : Code[20]) : Boolean;
    BEGIN
      EXIT(("Receipt Bin Code" <> '') AND (BinCode = "Receipt Bin Code") OR
        ("Shipment Bin Code" <> '') AND (BinCode = "Shipment Bin Code"));
    END;

    [External]
    PROCEDURE IsInTransit@10(LocationCode@1000 : Code[10]) : Boolean;
    BEGIN
      IF Location.GET(LocationCode) THEN
        EXIT(Location."Use As In-Transit");
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CreateInboundWhseRequest@13();
    VAR
      TransferHeader@1002 : Record 5740;
      TransferLine@1004 : Record 5741;
      WarehouseRequest@1000 : Record 5765;
      WhseTransferRelease@1003 : Codeunit 5773;
    BEGIN
      TransferLine.SETRANGE("Transfer-to Code",Code);
      IF TransferLine.FINDSET THEN
        REPEAT
          IF TransferLine."Quantity Received" <> TransferLine."Quantity Shipped" THEN BEGIN
            TransferHeader.GET(TransferLine."Document No.");
            WhseTransferRelease.InitializeWhseRequest(WarehouseRequest,TransferHeader,TransferHeader.Status);
            WhseTransferRelease.CreateInboundWhseRequest(WarehouseRequest,TransferHeader);

            TransferLine.SETRANGE("Document No.",TransferLine."Document No.");
            TransferLine.FINDLAST;
            TransferLine.SETRANGE("Document No.");
          END;
        UNTIL TransferLine.NEXT = 0;
    END;

    PROCEDURE GetLocationsIncludingUnspecifiedLocation@14(IncludeOnlyUnspecifiedLocation@1001 : Boolean;ExcludeInTransitLocations@1000 : Boolean);
    VAR
      Location@1002 : Record 14;
    BEGIN
      INIT;
      VALIDATE(Name,UnspecifiedLocationLbl);
      INSERT;

      IF NOT IncludeOnlyUnspecifiedLocation THEN BEGIN
        IF ExcludeInTransitLocations THEN
          Location.SETRANGE("Use As In-Transit",FALSE);

        IF Location.FINDSET THEN
          REPEAT
            INIT;
            COPY(Location);
            INSERT;
          UNTIL Location.NEXT = 0;
      END;

      FINDFIRST;
    END;

    BEGIN
    END.
  }
}

