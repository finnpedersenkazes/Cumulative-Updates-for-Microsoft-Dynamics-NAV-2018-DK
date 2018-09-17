OBJECT Page 8632 Config. Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfig.kladde;
               ENU=Config. Worksheet];
    SourceTable=Table8622;
    DelayedInsert=Yes;
    SourceTableView=SORTING(Vertical Sorting);
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Excel,Vis;
                                ENU=New,Process,Report,Excel,Show];
    OnOpenPage=BEGIN
                 FILTERGROUP := 2;
                 SETRANGE("Company Filter",COMPANYNAME);
                 FILTERGROUP := 0;
               END;

    OnClosePage=VAR
                  ConfigMgt@1002 : Codeunit 8616;
                BEGIN
                  ConfigMgt.AssignParentLineNos;
                END;

    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       CASE "Line Type" OF
                         "Line Type"::Group:
                           NameIndent := 1;
                         "Line Type"::Table:
                           NameIndent := 2;
                       END;

                       NameEmphasize := (NameIndent IN [0,1]);
                     END;

    OnNewRecord=BEGIN
                  "Line Type" := xRec."Line Type";
                END;

    OnInsertRecord=VAR
                     ConfigLine@1001 : Record 8622;
                   BEGIN
                     NextLineNo := 10000;
                     ConfigLine.RESET;
                     IF ConfigLine.FINDLAST THEN
                       NextLineNo := ConfigLine."Line No." + 10000;

                     ConfigLine.SETCURRENTKEY("Vertical Sorting");
                     IF BelowxRec THEN BEGIN
                       IF ConfigLine.FINDLAST THEN;
                       "Vertical Sorting" := ConfigLine."Vertical Sorting" + 1;
                       "Line No." := NextLineNo;
                     END ELSE BEGIN
                       NextVertNo := xRec."Vertical Sorting";

                       ConfigLine.SETFILTER("Vertical Sorting",'%1..',NextVertNo);
                       IF ConfigLine.FIND('+') THEN
                         REPEAT
                           ConfigLine."Vertical Sorting" := ConfigLine."Vertical Sorting" + 1;
                           ConfigLine.MODIFY;
                         UNTIL ConfigLine.NEXT(-1) = 0;

                       "Line No." := NextLineNo;
                       "Vertical Sorting" := NextVertNo;
                     END;
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ops‘tning;
                                 ENU=&Setup];
                      Image=Setup }
      { 9       ;2   ;Action    ;
                      Name=Questions;
                      CaptionML=[DAN=Sp›rgsm†l;
                                 ENU=Questions];
                      ToolTipML=[DAN=Vis de sp›rgsm†l, der skal besvares p† konfigurationssp›rgeskemaet.;
                                 ENU=View the questions that are to be answered on the setup questionnaire.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Answers;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 ShowQuestions;
                               END;
                                }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Brugere;
                                 ENU=Users];
                      ToolTipML=[DAN=Vis eller rediger brugere, der skal konfigureres i databasen.;
                                 ENU=View or edit users that will be configured in the database.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9800;
                      Image=Users }
      { 57      ;2   ;Action    ;
                      CaptionML=[DAN=Brugertilpasning;
                                 ENU=Users Personalization];
                      ToolTipML=[DAN=Vis eller rediger gr‘nseflade‘ndringer, der skal konfigureres i databasen.;
                                 ENU=View or edit UI changes that will be configured in the database.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9173;
                      Image=UserSetup }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vi&s;
                                 ENU=Sho&w];
                      Image=Action }
      { 58      ;2   ;Action    ;
                      Name=PackageCard;
                      CaptionML=[DAN=Pakkekort;
                                 ENU=Package Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om pakken.;
                                 ENU=View or edit information about the package.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Bin;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 TESTFIELD("Package Code");
                                 ConfigPackageTable.ShowPackageCard("Package Code");
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=PromotedOnly;
                      CaptionML=[DAN=Kun promoverede;
                                 ENU=Promoted Only];
                      ToolTipML=[DAN=Vis tabeller, der er markeret som overf›rt, eksempelvis fordi de ofte stammer fra en typisk bruger under konfigurationsprocessen.;
                                 ENU=View tables that are marked as promoted, for example, because they are frequently by a typical customer during the setup process.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ShowSelected;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 IF GETFILTER("Promoted Table") = '' THEN
                                   SETRANGE("Promoted Table",TRUE)
                                 ELSE
                                   SETRANGE("Promoted Table");
                               END;
                                }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Databasedata;
                                 ENU=Database Data];
                      ToolTipML=[DAN=Vis de data, der er udlignet med databasen.;
                                 ENU=View the data that has been applied to the database.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Database;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 ShowTableData;
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=PackageData;
                      CaptionML=[DAN=Pakkedata;
                                 ENU=Package Data];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om pakken.;
                                 ENU=View or edit information about the package.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Grid;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 GetConfigPackageTable(ConfigPackageTable);
                                 ConfigPackageTable.ShowPackageRecords(Show::Records,"Dimensions as Columns");
                               END;
                                }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Fejl;
                                 ENU=Errors];
                      ToolTipML=[DAN=Vis en liste med fejl, der er et resultat af dataoverf›rslen. Hvis du for eksempel importerer en debitor i Dynamics NAV og tildeler denne debitor en salgsperson, som ikke er i databasen, s† f†r du en fejl under overf›rslen. Du kan l›se problemet ved at fjerne det ukorrekte salgspersons-id eller opdatere oplysningerne om salgspersonalet, s† listen med s‘lgere er korrekt og opdateret.;
                                 ENU=View a list of errors that resulted from the data migration. For example, if you are importing a customer into Dynamics NAV and assign to that customer a salesperson who is not in the database, you get an error during migration. You can fix the error by removing the incorrect salesperson ID or by updating the information about salespeople so that the list of salespeople is correct and up-to-date.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ErrorLog;
                      OnAction=BEGIN
                                 GetConfigPackageTable(ConfigPackageTable);
                                 ConfigPackageTable.ShowPackageRecords(Show::Errors,"Dimensions as Columns");
                               END;
                                }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Felter;
                                 ENU=Fields];
                      ToolTipML=[DAN=Vis de felter, der bruges i virksomhedens konfigurationsproces. For hver tabel p† listen over konfigurationstabeller viser vinduet Konfig.pakkefelter en liste over alle felterne i tabellen og angiver den r‘kkef›lge, hvori dataene i et felt skal behandles.;
                                 ENU=View the fields that are used in the company configuration process. For each table in the list of configuration tables, the Config. Package Fields window displays a list of all the fields in the table and indicates the order in which the data in a field is to be processed.];
                      ApplicationArea=#Basic,#Suite;
                      Image=CheckList;
                      OnAction=BEGIN
                                 GetConfigPackageTable(ConfigPackageTable);
                                 ConfigPackageTable.ShowPackageFields;
                               END;
                                }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Filtre;
                                 ENU=Filters];
                      ToolTipML=[DAN=Vis eller indstil feltfilterv‘rdien for et konfigurationspakkefilter. Ved at indstille en v‘rdi angiver du, at kun records med denne v‘rdi inkluderes i konfigurationspakken.;
                                 ENU=View or set field filter values for a configuration package filter. By setting a value, you specify that only records with that value are included in the configuration package.];
                      ApplicationArea=#Basic,#Suite;
                      Image=FilterLines;
                      OnAction=BEGIN
                                 GetConfigPackageTable(ConfigPackageTable);
                                 ConfigPackageTable.ShowFilters;
                               END;
                                }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=Funktioner;
                                 ENU=Functions] }
      { 34      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent tabeller;
                                 ENU=Get Tables];
                      ToolTipML=[DAN=V‘lg tabeller, som du vil f›je til konfigurationspakken.;
                                 ENU=Select tables that you want to add to the configuration package.];
                      ApplicationArea=#Basic,#Suite;
                      PromotedIsBig=Yes;
                      Image=GetLines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 GetConfigTables@1000 : Report 8614;
                               BEGIN
                                 GetConfigTables.RUNMODAL;
                                 CLEAR(GetConfigTables);
                               END;
                                }
      { 56      ;2   ;Action    ;
                      Name=GetRelatedTables;
                      CaptionML=[DAN=Hent tilknyttede tabeller;
                                 ENU=Get Related Tables];
                      ToolTipML=[DAN=V‘lg tabeller, som relaterer til eksisterende valgte tabeller, som du ogs† vil f›je til konfigurationspakken.;
                                 ENU=Select tables that relate to existing selected tables that you also want to add to the configuration package.];
                      ApplicationArea=#Basic,#Suite;
                      Image=GetEntries;
                      OnAction=VAR
                                 AllObj@1002 : Record 2000000038;
                                 ConfigLine@1000 : Record 8622;
                                 ConfigMgt@1001 : Codeunit 8616;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ConfigLine);
                                 IF ConfigLine.FINDSET THEN
                                   REPEAT
                                     AllObj.SETRANGE("Object Type",AllObj."Object Type"::Table);
                                     AllObj.SETRANGE("Object ID",ConfigLine."Table ID");
                                     ConfigMgt.GetConfigTables(AllObj,FALSE,TRUE,FALSE,FALSE,FALSE);
                                     COMMIT;
                                   UNTIL ConfigLine.NEXT = 0;
                               END;
                                }
      { 59      ;2   ;Action    ;
                      Name=DeleteDuplicateLines;
                      CaptionML=[DAN=Slet dubletlinjer;
                                 ENU=Delete Duplicate Lines];
                      ToolTipML=[DAN=Fjern dublettabeller med den samme pakkekode.;
                                 ENU=Remove duplicate tables that have the same package code.];
                      ApplicationArea=#Basic,#Suite;
                      PromotedIsBig=Yes;
                      Image=RemoveLine;
                      OnAction=BEGIN
                                 DeleteDuplicateLines;
                               END;
                                }
      { 46      ;2   ;Action    ;
                      Name=ApplyData;
                      CaptionML=[DAN=Anvend data;
                                 ENU=Apply Data];
                      ToolTipML=[DAN=V‘lg dataene i pakken til databasen. N†r du har anvendt data, kan du kun se dem i databasen.;
                                 ENU=Apply the data in the package to the database. After you apply data, you can only see it in the database.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Apply;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ConfigLine@1002 : Record 8622;
                                 ConfigPackageMgt@1001 : Codeunit 8611;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ConfigLine);
                                 CheckSelectedLines(ConfigLine);
                                 IF CONFIRM(Text003,FALSE) THEN
                                   ConfigPackageMgt.ApplyConfigLines(ConfigLine);
                               END;
                                }
      { 38      ;2   ;Action    ;
                      Name=MoveUp;
                      CaptionML=[DAN=Flyt op;
                                 ENU=Move Up];
                      ToolTipML=[DAN=Skift sorteringsr‘kkef›lge for linjerne.;
                                 ENU=Change the sorting order of the lines.];
                      ApplicationArea=#Basic,#Suite;
                      Image=MoveUp;
                      OnAction=VAR
                                 ConfigLine@1000 : Record 8622;
                               BEGIN
                                 CurrPage.SAVERECORD;
                                 ConfigLine.SETCURRENTKEY("Vertical Sorting");
                                 ConfigLine.SETFILTER("Vertical Sorting",'..%1',"Vertical Sorting" - 1);
                                 IF ConfigLine.FINDLAST THEN BEGIN
                                   ExchangeLines(Rec,ConfigLine);
                                   CurrPage.UPDATE(FALSE);
                                 END;
                               END;
                                }
      { 39      ;2   ;Action    ;
                      Name=MoveDown;
                      CaptionML=[DAN=Flyt ned;
                                 ENU=Move Down];
                      ToolTipML=[DAN=Skift sorteringsr‘kkef›lge for linjerne.;
                                 ENU=Change the sorting order of the lines.];
                      ApplicationArea=#Basic,#Suite;
                      Image=MoveDown;
                      OnAction=VAR
                                 ConfigLine@1000 : Record 8622;
                               BEGIN
                                 CurrPage.SAVERECORD;
                                 ConfigLine.SETCURRENTKEY("Vertical Sorting");
                                 ConfigLine.SETFILTER("Vertical Sorting",'%1..',"Vertical Sorting" + 1);
                                 IF ConfigLine.FINDFIRST THEN BEGIN
                                   ExchangeLines(Rec,ConfigLine);
                                   CurrPage.UPDATE(FALSE);
                                 END;
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=AssignPackage;
                      CaptionML=[DAN=Tildel pakke;
                                 ENU=Assign Package];
                      ToolTipML=[DAN=Tildel de tabeller, der skal behandles som en del af konfigurationen, til en konfigurationspakke.;
                                 ENU=Assign the tables that you want to treat as part of your configuration to a configuration package.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Migration;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ConfigLine@1000 : Record 8622;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ConfigLine);
                                 AssignPackagePrompt(ConfigLine);
                               END;
                                }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=V‘rkt›jer;
                                 ENU=Tools] }
      { 48      ;2   ;Action    ;
                      Name=CopyDataFromCompany;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopi‚r data fra virksomhed;
                                 ENU=Copy Data from Company];
                      ToolTipML=[DAN=Kopi‚r almindeligt brugte v‘rdier fra en eksisterende virksomhed til en ny. Hvis du f.eks. har en standardliste med symptomkoder, der er f‘lles for alle dine servicestyringsimplementeringer, kan du nemt kopiere koderne fra ‚n virksomhed til en anden.;
                                 ENU=Copy commonly used values from an existing company to a new one. For example, if you have a standard list of symptom codes that is common to all your service management implementations, you can copy the codes easily from one company to another.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Copy;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"Copy Company Data");
                               END;
                                }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=Excel;
                                 ENU=Excel] }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Udl‘s til skabelon;
                                 ENU=Export to Template];
                      ToolTipML=[DAN=Eksporter hurtigt dataene til en Excel-projektmappe, s† de kan fungere som en skabelon, der er baseret p† strukturen fra en eksisterende databasetabel. Du kan derefter bruge skabelonen til at indsamle debitordata i et konsistent format til senere import i Dynamics NAV.;
                                 ENU=Export the data to an Excel workbook to serve as a template that is based on the structure of an existing database table quickly. You can then use the template to gather together customer data in a consistent format for later import into Dynamics NAV.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ExportToExcel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ConfigLine@1001 : Record 8622;
                                 ConfigExcelExchange@1000 : Codeunit 8618;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ConfigLine);
                                 CheckSelectedLines(ConfigLine);
                                 IF CONFIRM(Text005,TRUE,ConfigLine.COUNT) THEN
                                   ConfigExcelExchange.ExportExcelFromConfig(ConfigLine);
                               END;
                                }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Indl‘s fra skabelon;
                                 ENU=Import from Template];
                      ToolTipML=[DAN=Importer data, der eksisterer i en konfigurationsskabelon.;
                                 ENU=Import data that exists in a configuration template.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ImportExcel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ConfigExcelExchange@1000 : Codeunit 8618;
                               BEGIN
                                 IF CONFIRM(Text004,TRUE) THEN
                                   ConfigExcelExchange.ImportExcelFromConfig(Rec);
                               END;
                                }
      { 49      ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 50      ;1   ;ActionGroup;
                      CaptionML=[DAN=O&pret;
                                 ENU=C&reate] }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=Opret finanskontokladdelinjer;
                                 ENU=Create G/L Journal Lines];
                      ToolTipML=[DAN=Opret finanskontokladdelinjer for ‘ldre kontosaldi, du vil overf›re til den nye virksomhed.;
                                 ENU=Create G/L journal lines for the legacy account balances that you will transfer to the new company.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 8610;
                      Image=Report }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=Opret debitorkladdelinjer;
                                 ENU=Create Customer Journal Lines];
                      ToolTipML=[DAN=Opret kladdelinjer under konfiguration af den nye virksomhed.;
                                 ENU=Create journal lines during the setup of the new company.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 8611;
                      Image=Report }
      { 53      ;2   ;Action    ;
                      CaptionML=[DAN=Opret debitorkladdelinjer;
                                 ENU=Create Vendor Journal Lines];
                      ToolTipML=[DAN=G›r dig klar til at overf›re ‘ldre kreditorbel›b til den nye konfigurerede virksomhed.;
                                 ENU=Prepare to transfer legacy vendor balances to the newly configured company.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 8612;
                      Image=Report }
      { 54      ;2   ;Action    ;
                      CaptionML=[DAN=Opret varekladdelinjer;
                                 ENU=Create Item Journal Lines];
                      ToolTipML=[DAN=G›r dig klar til at overf›re ‘ldre lagerbel›b til den nye konfigurerede virksomhed.;
                                 ENU=Prepare to transfer legacy inventory balances to the newly configured company.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 8613;
                      Image=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konfigurationspakkelinjens type. Linjen kan v‘re en af de f›lgende typer:;
                           ENU=Specifies the type of the configuration package line. The line can be one of the following types:];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Type";
                Style=Strong;
                StyleExpr=NameEmphasize }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den tabel, som du vil bruge til linjetypen. N†r du har valgt et tabel-id p† listen over objekter i opslagstabellen, inds‘ttes navnet p† tabellen automatisk i feltet Navn.;
                           ENU=Specifies the ID of the table that you want to use for the line type. After you select a table ID from the list of objects in the lookup table, the name of the table is automatically filled in the Name field.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Table ID" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† linjetypen.;
                           ENU=Specifies the name of the line type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=NameEmphasize }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om tabellen overf›res. Mark‚r det afkrydsningsfelt, der skal opgradere tabellen i konfigurationsregnearket. Du kan bruge denne betegnelse som et signal om, at denne tabel kr‘ver yderligere opm‘rksomhed.;
                           ENU=Specifies whether the table is promoted. Select the check box to promote the table in the configuration worksheet. You can use this designation as a signal that this table requires additional attention.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Promoted Table" }

    { 2   ;2   ;Field     ;
                Width=20;
                ToolTipML=[DAN=Angiver en url-adresse. Brug dette felt til at anf›re en url-adresse til en placering, der angiver oplysninger om tabellen. Du kunne f.eks. anf›re adressen til en side, som angiver oplysninger om konfigurationsovervejelser, og som den, der implementerer l›sningen, b›r overveje.;
                           ENU=Specifies a url address. Use this field to provide a url address to a location that Specifies information about the table. For example, you could provide the address of a page that Specifies information about setup considerations that the solution implementer should consider.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Reference }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden til den pakke, der er knyttet til konfigurationen. Koden udfyldes, n†r du bruger funktionen Tildel pakke til at markere pakken for linjetypen.;
                           ENU=Specifies the code of the package associated with the configuration. The code is filled in when you use the Assign Package function to select the package for the line type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Package Code";
                Editable=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den pakke, der er tildelt til kladdelinjen, er oprettet.;
                           ENU=Specifies whether the package that has been assigned to the worksheet line has been created.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Package Exists" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p† den Dynamics NAV-bruger, der er ansvarlig for konfigurationsarket.;
                           ENU=Specifies the ID of the Dynamics NAV user who is responsible for the configuration worksheet.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Responsible ID" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tabellens status i konfigurationsarket. Du kan bruge de statusoplysninger, som du leverer, til at hj‘lpe dig med at planl‘gge og holde styr p† dit arbejde.;
                           ENU=Specifies the status of the table in the configuration worksheet. You can use the status information, which you provide, to help you in planning and tracking your work.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status }

    { 11  ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Page ID";
                OnAssistEdit=BEGIN
                               ShowTableData;
                             END;
                              }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det viste navn p† den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the displayed name of the journal or worksheet that uses the template.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Page Caption" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om tabellen er omfattet af licensen p† den person, der opretter konfigurationspakken.;
                           ENU=Specifies whether the table is covered by the license of the person creating the configuration package.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Licensed Table" }

    { 15  ;2   ;Field     ;
                Name=NoOfRecords;
                CaptionML=[DAN=Antal records;
                           ENU=No. of Records];
                ToolTipML=[DAN=Angiver, hvor mange records der oprettes i forbindelse med overf›rslen.;
                           ENU=Specifies how many records are created in connection with migration.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=GetNoOfRecords }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om konfigurationen omfatter dimensioner som kolonner. N†r du markerer afkrydsningsfeltet Dimensioner som kolonner, medtages dimensionerne i det Excel-regneark, du opretter til konfiguration. Du kan markere dette afkrydsningsfelt, hvis du inkluderer tabellerne Standarddimension og Dimensionsv‘rdi i konfigurationspakken.;
                           ENU=Specifies whether the configuration includes dimensions as columns. When you select the Dimensions as Columns check box, the dimensions are included in the Excel worksheet that you create for configuration. In order to select this check box, you must include the Default Dimension and Dimension Value tables in the configuration package.];
                ApplicationArea=#Suite;
                SourceExpr="Dimensions as Columns" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kopiering er tilg‘ngelig i konfigurationsregnearket.;
                           ENU=Specifies whether copying is available in the configuration worksheet.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Copying Available" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af sp›rgsm†lsgrupper, der er indeholdt i konfigurationsp›rgeskemaet.;
                           ENU=Specifies the number of question groups that are contained on the configuration questionnaire.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="No. of Question Groups";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den side, der er tilknyttet overflytningstabellen, er licenseret.;
                           ENU=Specifies whether the page that is associated with the table is licensed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Licensed Page" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 6   ;1   ;Part      ;
                CaptionML=[DAN=Pakketabel;
                           ENU=Package Table];
                ApplicationArea=#Basic,#Suite;
                SubPageView=SORTING(Package Code,Table ID);
                SubPageLink=Package Code=FIELD(Package Code),
                            Table ID=FIELD(Table ID);
                PagePartID=Page8634;
                PartType=Page }

    { 28  ;1   ;Part      ;
                CaptionML=[DAN=Relaterede tabeller;
                           ENU=Related Tables];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Table ID=FIELD(Table ID);
                PagePartID=Page8635;
                PartType=Page }

    { 22  ;1   ;Part      ;
                CaptionML=[DAN=Sp›rgsm†l;
                           ENU=Questions];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Table ID=FIELD(Table ID);
                PagePartID=Page8633;
                PartType=Page }

    { 25  ;1   ;Part      ;
                CaptionML=[DAN=Noter;
                           ENU=Notes];
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

    { 41  ;1   ;Part      ;
                CaptionML=[DAN=Links;
                           ENU=Links];
                ApplicationArea=#Advanced;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      ConfigPackageTable@1010 : Record 8613;
      Show@1002 : 'Records,Errors,All';
      NameEmphasize@1004 : Boolean INDATASET;
      NameIndent@1003 : Integer INDATASET;
      NextLineNo@1005 : Integer;
      NextVertNo@1006 : Integer;
      Text001@1001 : TextConst 'DAN=Du skal tildele en pakkekode, f›r du kan udf›re denne handling.;ENU=You must assign a package code before you can carry out this action.';
      Text002@1000 : TextConst 'DAN=Du skal v‘lge tabellinjer med samme pakkekode.;ENU=You must select table lines with the same package code.';
      Text003@1007 : TextConst 'DAN=Vil du anvende pakkedata p† de valgte tabeller?;ENU=Do you want to apply package data for the selected tables?';
      Text004@1008 : TextConst 'DAN=Vil du indl‘se data fra Excel-skabelonen?;ENU=Do you want to import data from the Excel template?';
      Text005@1009 : TextConst 'DAN=Vil du udl‘se data fra %1 tabeller til Excel-skabelonen?;ENU=Do you want to export data from %1 tables to the Excel template?';

    LOCAL PROCEDURE ExchangeLines@1(VAR ConfigLine1@1000 : Record 8622;VAR ConfigLine2@1001 : Record 8622);
    VAR
      VertSort@1002 : Integer;
    BEGIN
      VertSort := ConfigLine1."Vertical Sorting";
      ConfigLine1."Vertical Sorting" := ConfigLine2."Vertical Sorting";
      ConfigLine2."Vertical Sorting" := VertSort;
      ConfigLine1.MODIFY;
      ConfigLine2.MODIFY;
    END;

    LOCAL PROCEDURE AssignPackagePrompt@7(VAR ConfigLine@1000 : Record 8622);
    VAR
      ConfigPackage@1002 : Record 8623;
      ConfigPackageMgt@1003 : Codeunit 8611;
      ConfigPackages@1001 : Page 8615;
    BEGIN
      ConfigPackageMgt.CheckConfigLinesToAssign(ConfigLine);
      CLEAR(ConfigPackages);
      ConfigPackage.INIT;
      ConfigPackages.LOOKUPMODE(TRUE);
      IF ConfigPackages.RUNMODAL = ACTION::LookupOK THEN BEGIN
        ConfigPackages.GETRECORD(ConfigPackage);
        ConfigPackageMgt.AssignPackage(ConfigLine,ConfigPackage.Code);
      END;
    END;

    LOCAL PROCEDURE CheckSelectedLines@2(VAR SelectedConfigLine@1000 : Record 8622);
    VAR
      PackageCode@1001 : Code[20];
    BEGIN
      PackageCode := '';
      WITH SelectedConfigLine DO BEGIN
        IF FINDSET THEN
          REPEAT
            CheckBlocked;
            IF ("Package Code" <> '') AND
               ("Line Type" = "Line Type"::Table) AND
               (Status <= Status::"In Progress")
            THEN BEGIN
              IF PackageCode = '' THEN
                PackageCode := "Package Code"
              ELSE
                IF PackageCode <> "Package Code" THEN
                  ERROR(Text002);
            END ELSE
              IF "Package Code" = '' THEN
                ERROR(Text001);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE GetConfigPackageTable@4(VAR ConfigPackageTable@1000 : Record 8613);
    BEGIN
      TESTFIELD("Table ID");
      IF NOT ConfigPackageTable.GET("Package Code","Table ID") THEN
        ERROR(Text001);
    END;

    BEGIN
    END.
  }
}

