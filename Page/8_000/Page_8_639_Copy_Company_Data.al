OBJECT Page 8639 Copy Company Data
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kopi‚r virksomhedsdata;
               ENU=Copy Company Data];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table8622;
    SourceTableView=SORTING(Line No.);
    PageType=Worksheet;
    OnOpenPage=BEGIN
                 FILTERGROUP := 2;
                 SETRANGE("Company Filter",COMPANYNAME);
                 FILTERGROUP := 0;
                 SETRANGE("Line Type","Line Type"::Table);
                 SETRANGE("Copying Available",TRUE);
                 SETRANGE("Licensed Table",TRUE);
                 SETRANGE("No. of Records",0);
                 SETFILTER("No. of Records (Source Table)",'<>0');
                 IF NewCompanyName <> '' THEN
                   IF NewCompanyName = COMPANYNAME THEN
                     NewCompanyName := ''
                   ELSE
                     IF NOT Company.GET(NewCompanyName) THEN
                       NewCompanyName := '';
                 SetCompanyFilter;
               END;

    OnAfterGetRecord=BEGIN
                       "Company Filter (Source Table)" := NewCompanyName;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Kopi‚r data;
                                 ENU=Copy Data];
                      ToolTipML=[DAN=Kopi‚r data fra den valgte virksomhed. Dette er nyttigt, n†r du vil flytte fra et testmilj› til et produktionsmilj›, og du vil kopiere data mellem versioner af virksomheden.;
                                 ENU=Copy data from the selected company. This is useful, when you want to move from a test environment to a production environment, and want to copy data between the versions of the company.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Copy;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 GetData;
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 6   ;1   ;Field     ;
                CaptionML=[DAN=Kopi‚r fra;
                           ENU=Copy from];
                ToolTipML=[DAN=Angiver, hvilken virksomhed der skal kopieres data fra.;
                           ENU=Specifies the company to copy data from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NewCompanyName;
                OnValidate=BEGIN
                             ValidateCompanyName;
                           END;

                OnLookup=BEGIN
                           CLEAR(Company);
                           Company.SETFILTER(Name,'<>%1',COMPANYNAME);
                           Company.Name := NewCompanyName;
                           IF PAGE.RUNMODAL(PAGE::Companies,Company) = ACTION::LookupOK THEN BEGIN
                             NewCompanyName := Company.Name;
                             ValidateCompanyName;
                           END;
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden til den pakke, der er knyttet til konfigurationen. Koden udfyldes, n†r du bruger funktionen Tildel pakke til at markere pakken for linjetypen.;
                           ENU=Specifies the code of the package associated with the configuration. The code is filled in when you use the Assign Package function to select the package for the line type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Package Code";
                Enabled=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den tabel, som du vil bruge til linjetypen. N†r du har valgt et tabel-id p† listen over objekter i opslagstabellen, inds‘ttes navnet p† tabellen automatisk i feltet Navn.;
                           ENU=Specifies the ID of the table that you want to use for the line type. After you select a table ID from the list of objects in the lookup table, the name of the table is automatically filled in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Table ID";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† linjetypen.;
                           ENU=Specifies the name of the line type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                Name=NoOfRecordsSourceTable;
                DrillDown=No;
                CaptionML=[DAN=Antal records (kildetabel);
                           ENU=No. of Records (Source Table)];
                ToolTipML=[DAN=Angiver, hvor mange records der findes i kildetabellen.;
                           ENU=Specifies how many records exist in the source table.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetNoOfRecordsSourceTable }

  }
  CODE
  {
    VAR
      Company@1000 : Record 2000000006;
      ConfigMgt@1001 : Codeunit 8616;
      NewCompanyName@1002 : Text[30];

    LOCAL PROCEDURE ValidateCompanyName@4();
    BEGIN
      IF NewCompanyName <> '' THEN BEGIN
        CLEAR(Company);
        Company.SETFILTER(Name,'<>%1',COMPANYNAME);
        Company.Name := NewCompanyName;
        Company.FIND;
      END;
      SetCompanyFilter;
    END;

    LOCAL PROCEDURE GetData@1();
    VAR
      ConfigLine@1000 : Record 8622;
    BEGIN
      CurrPage.SETSELECTIONFILTER(ConfigLine);
      FILTERGROUP := 2;
      ConfigLine.FILTERGROUP := 2;
      COPYFILTER("Company Filter (Source Table)",ConfigLine."Company Filter (Source Table)");
      COPYFILTER("Company Filter",ConfigLine."Company Filter");
      FILTERGROUP := 0;
      ConfigLine.FILTERGROUP := 0;
      ConfigLine := Rec;
      ConfigMgt.CopyDataDialog(NewCompanyName,ConfigLine);
    END;

    [External]
    PROCEDURE SetCompanyFilter@3();
    BEGIN
      FILTERGROUP := 2;
      SETRANGE("Company Filter (Source Table)",NewCompanyName);
      FILTERGROUP := 0;
    END;

    BEGIN
    END.
  }
}

