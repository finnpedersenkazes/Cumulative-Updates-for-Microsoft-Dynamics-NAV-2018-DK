OBJECT Page 9255 Tasks Matrix
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Opgavematrix;
               ENU=Tasks Matrix];
    LinksAllowed=No;
    SourceTable=Table5102;
    DataCaptionExpr=FORMAT(SELECTSTR(OutputOption + 1,Text001));
    PageType=List;
    OnOpenPage=BEGIN
                 MATRIX_NoOfMatrixColumns := ARRAYLEN(MATRIX_CellData);
                 IF IncludeClosed THEN
                   SETRANGE("Task Closed Filter")
                 ELSE
                   SETRANGE("Task Closed Filter",FALSE);

                 IF StatusFilter <> StatusFilter::" " THEN
                   SETRANGE("Task Status Filter",StatusFilter - 1)
                 ELSE
                   SETRANGE("Task Status Filter");

                 IF PriorityFilter <> PriorityFilter::" " THEN
                   SETRANGE("Priority Filter",PriorityFilter - 1)
                 ELSE
                   SETRANGE("Priority Filter");

                 ValidateFilter;
                 ValidateTableOption;
               END;

    OnFindRecord=BEGIN
                   EXIT(FindRec(TableOption,Rec,Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(NextRec(TableOption,Rec,Steps));
                 END;

    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1000 : Integer;
                     BEGIN
                       IF (Type = Type::Person) AND (TableOption = TableOption::Contact) THEN
                         NameIndent := 1
                       ELSE
                         NameIndent := 0;

                       MATRIX_CurrentColumnOrdinal := 0;
                       WHILE MATRIX_CurrentColumnOrdinal < MATRIX_NoOfMatrixColumns DO BEGIN
                         MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
                         MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
                       END;

                       FormatLine;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnLookup=VAR
                           Campaign@1040 : Record 5071;
                           SalesPurchPerson@1041 : Record 13;
                           Contact@1042 : Record 5050;
                           Team@1043 : Record 5083;
                         BEGIN
                           CASE TableOption OF
                             TableOption::Salesperson:
                               BEGIN
                                 SalesPurchPerson.GET("No.");
                                 PAGE.RUNMODAL(0,SalesPurchPerson);
                               END;
                             TableOption::Team:
                               BEGIN
                                 Team.GET("No.");
                                 PAGE.RUNMODAL(0,Team);
                               END;
                             TableOption::Campaign:
                               BEGIN
                                 Campaign.GET("No.");
                                 PAGE.RUNMODAL(0,Campaign);
                               END;
                             TableOption::Contact:
                               BEGIN
                                 Contact.GET("No.");
                                 PAGE.RUNMODAL(0,Contact);
                               END;
                           END;
                         END;
                          }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� opgaven.;
                           ENU=Specifies the name of the task.];
                ApplicationArea=#Advanced;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 1008;2   ;Field     ;
                Name=Field1;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[1];
                CaptionClass='3,' + ColumnCaptions[1];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(1);
                            END;
                             }

    { 1009;2   ;Field     ;
                Name=Field2;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[2];
                CaptionClass='3,' + ColumnCaptions[2];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(2);
                            END;
                             }

    { 1010;2   ;Field     ;
                Name=Field3;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[3];
                CaptionClass='3,' + ColumnCaptions[3];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(3);
                            END;
                             }

    { 1011;2   ;Field     ;
                Name=Field4;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[4];
                CaptionClass='3,' + ColumnCaptions[4];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(4);
                            END;
                             }

    { 1012;2   ;Field     ;
                Name=Field5;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[5];
                CaptionClass='3,' + ColumnCaptions[5];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(5);
                            END;
                             }

    { 1013;2   ;Field     ;
                Name=Field6;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[6];
                CaptionClass='3,' + ColumnCaptions[6];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(6);
                            END;
                             }

    { 1014;2   ;Field     ;
                Name=Field7;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[7];
                CaptionClass='3,' + ColumnCaptions[7];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(7);
                            END;
                             }

    { 1015;2   ;Field     ;
                Name=Field8;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[8];
                CaptionClass='3,' + ColumnCaptions[8];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(8);
                            END;
                             }

    { 1016;2   ;Field     ;
                Name=Field9;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[9];
                CaptionClass='3,' + ColumnCaptions[9];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(9);
                            END;
                             }

    { 1017;2   ;Field     ;
                Name=Field10;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[10];
                CaptionClass='3,' + ColumnCaptions[10];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(10);
                            END;
                             }

    { 1018;2   ;Field     ;
                Name=Field11;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[11];
                CaptionClass='3,' + ColumnCaptions[11];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(11);
                            END;
                             }

    { 1019;2   ;Field     ;
                Name=Field12;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[12];
                CaptionClass='3,' + ColumnCaptions[12];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(12);
                            END;
                             }

    { 1020;2   ;Field     ;
                Name=Field13;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[13];
                CaptionClass='3,' + ColumnCaptions[13];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(13);
                            END;
                             }

    { 1021;2   ;Field     ;
                Name=Field14;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[14];
                CaptionClass='3,' + ColumnCaptions[14];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(14);
                            END;
                             }

    { 1022;2   ;Field     ;
                Name=Field15;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[15];
                CaptionClass='3,' + ColumnCaptions[15];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(15);
                            END;
                             }

    { 1023;2   ;Field     ;
                Name=Field16;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[16];
                CaptionClass='3,' + ColumnCaptions[16];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(16);
                            END;
                             }

    { 1024;2   ;Field     ;
                Name=Field17;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[17];
                CaptionClass='3,' + ColumnCaptions[17];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(17);
                            END;
                             }

    { 1025;2   ;Field     ;
                Name=Field18;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[18];
                CaptionClass='3,' + ColumnCaptions[18];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(18);
                            END;
                             }

    { 1026;2   ;Field     ;
                Name=Field19;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[19];
                CaptionClass='3,' + ColumnCaptions[19];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(19);
                            END;
                             }

    { 1027;2   ;Field     ;
                Name=Field20;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[20];
                CaptionClass='3,' + ColumnCaptions[20];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(20);
                            END;
                             }

    { 1028;2   ;Field     ;
                Name=Field21;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[21];
                CaptionClass='3,' + ColumnCaptions[21];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(21);
                            END;
                             }

    { 1029;2   ;Field     ;
                Name=Field22;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[22];
                CaptionClass='3,' + ColumnCaptions[22];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(22);
                            END;
                             }

    { 1030;2   ;Field     ;
                Name=Field23;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[23];
                CaptionClass='3,' + ColumnCaptions[23];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(23);
                            END;
                             }

    { 1031;2   ;Field     ;
                Name=Field24;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[24];
                CaptionClass='3,' + ColumnCaptions[24];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(24);
                            END;
                             }

    { 1032;2   ;Field     ;
                Name=Field25;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[25];
                CaptionClass='3,' + ColumnCaptions[25];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(25);
                            END;
                             }

    { 1033;2   ;Field     ;
                Name=Field26;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[26];
                CaptionClass='3,' + ColumnCaptions[26];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(26);
                            END;
                             }

    { 1034;2   ;Field     ;
                Name=Field27;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[27];
                CaptionClass='3,' + ColumnCaptions[27];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(27);
                            END;
                             }

    { 1035;2   ;Field     ;
                Name=Field28;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[28];
                CaptionClass='3,' + ColumnCaptions[28];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(28);
                            END;
                             }

    { 1036;2   ;Field     ;
                Name=Field29;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[29];
                CaptionClass='3,' + ColumnCaptions[29];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(29);
                            END;
                             }

    { 1037;2   ;Field     ;
                Name=Field30;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[30];
                CaptionClass='3,' + ColumnCaptions[30];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(30);
                            END;
                             }

    { 1038;2   ;Field     ;
                Name=Field31;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[31];
                CaptionClass='3,' + ColumnCaptions[31];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(31);
                            END;
                             }

    { 1039;2   ;Field     ;
                Name=Field32;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[32];
                CaptionClass='3,' + ColumnCaptions[32];
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MatrixOnDrillDown(32);
                            END;
                             }

  }
  CODE
  {
    VAR
      Task@1003 : Record 5080;
      MatrixRecords@1002 : ARRAY [32] OF Record 2000000007;
      Salesperson@1000 : Record 13;
      Cont@1079 : Record 5050;
      Team@1080 : Record 5083;
      Campaign@1081 : Record 5071;
      OutputOption@1084 : 'No. of Tasks,Contact No.';
      TableOption@1085 : 'Salesperson,Team,Campaign,Contact';
      StatusFilter@1086 : ' ,Not Started,In Progress,Completed,Waiting,Postponed';
      PriorityFilter@1087 : ' ,Low,Normal,High';
      IncludeClosed@1088 : Boolean;
      StyleIsStrong@1004 : Boolean INDATASET;
      FilterSalesPerson@1089 : Code[250];
      FilterTeam@1090 : Code[250];
      FilterCampaign@1091 : Code[250];
      FilterContact@1092 : Code[250];
      Text001@1093 : TextConst 'DAN=Antal opgaver,Kontaktnr.;ENU=No. of Tasks,Contact No.';
      MATRIX_NoOfMatrixColumns@1095 : Integer;
      MATRIX_CellData@1096 : ARRAY [32] OF Text[1024];
      ColumnCaptions@1097 : ARRAY [32] OF Text[1024];
      ColumnDateFilters@1001 : ARRAY [32] OF Text[50];
      NameIndent@19079073 : Integer INDATASET;
      MultipleTxt@1094 : TextConst 'DAN=Flere;ENU=Multiple';

    LOCAL PROCEDURE SetFilters@1098();
    BEGIN
      IF StatusFilter <> StatusFilter::" " THEN BEGIN
        SETRANGE("Task Status Filter",StatusFilter - 1);
        Task.SETRANGE(Status,StatusFilter - 1);
      END ELSE BEGIN
        SETRANGE("Task Status Filter");
        Task.SETRANGE(Status);
      END;

      Task.SETFILTER("System To-do Type",'%1|%2',"System Task Type Filter"::Organizer,
        "System Task Type Filter"::"Salesperson Attendee");

      IF IncludeClosed THEN
        Task.SETRANGE(Closed)
      ELSE
        Task.SETRANGE(Closed,FALSE);

      IF PriorityFilter <> PriorityFilter::" " THEN BEGIN
        SETRANGE("Priority Filter",PriorityFilter - 1);
        Task.SETRANGE(Priority,PriorityFilter - 1);
      END ELSE BEGIN
        SETRANGE("Priority Filter");
        Task.SETRANGE(Priority);
      END;

      CASE TableOption OF
        TableOption::Salesperson:
          BEGIN
            SETRANGE("Salesperson Filter","No.");
            SETFILTER(
              "System Task Type Filter",'%1|%2',
              "System Task Type Filter"::Organizer,
              "System Task Type Filter"::"Salesperson Attendee");
          END;
        TableOption::Team:
          BEGIN
            SETRANGE("Team Filter","No.");
            SETRANGE("System Task Type Filter","System Task Type Filter"::Team);
          END;
        TableOption::Campaign:
          BEGIN
            SETRANGE("Campaign Filter","No.");
            SETRANGE("System Task Type Filter","System Task Type Filter"::Organizer);
          END;
        TableOption::Contact:
          IF Type = Type::Company THEN BEGIN
            SETRANGE("Contact Filter");
            SETRANGE("Contact Company Filter","Company No.");
            SETRANGE(
              "System Task Type Filter","System Task Type Filter"::"Contact Attendee");
          END ELSE BEGIN
            SETRANGE("Contact Filter","No.");
            SETRANGE("Contact Company Filter");
            SETRANGE(
              "System Task Type Filter","System Task Type Filter"::"Contact Attendee");
          END;
      END;
    END;

    LOCAL PROCEDURE FindRec@1099(TableOpt@1000 : 'Salesperson,Teams,Campaign,Contact';VAR RMMatrixMgt@1001 : Record 5102;Which@1002 : Text[250]) : Boolean;
    VAR
      Found@1100 : Boolean;
    BEGIN
      CASE TableOpt OF
        TableOpt::Salesperson:
          BEGIN
            RMMatrixMgt."No." := COPYSTR(RMMatrixMgt."No.",1,MAXSTRLEN(Salesperson.Code));
            Salesperson.Code := COPYSTR(RMMatrixMgt."No.",1,MAXSTRLEN(Salesperson.Code));
            Found := Salesperson.FIND(Which);
            IF Found THEN
              CopySalesPersonToBuf(Salesperson,RMMatrixMgt);
          END;
        TableOpt::Teams:
          BEGIN
            RMMatrixMgt."No." := COPYSTR(RMMatrixMgt."No.",1,MAXSTRLEN(Team.Code));
            Team.Code := RMMatrixMgt."No.";
            Found := Team.FIND(Which);
            IF Found THEN
              CopyTeamToBuf(Team,RMMatrixMgt);
          END;
        TableOpt::Campaign:
          BEGIN
            Campaign."No." := RMMatrixMgt."No.";
            Found := Campaign.FIND(Which);
            IF Found THEN
              CopyCampaignToBuf(Campaign,RMMatrixMgt);
          END;
        TableOpt::Contact:
          BEGIN
            Cont."Company Name" := RMMatrixMgt."Company Name";
            Cont.Type := RMMatrixMgt.Type;
            Cont.Name := COPYSTR(RMMatrixMgt.Name,1,MAXSTRLEN(Cont.Name));
            Cont."No." := RMMatrixMgt."No.";
            Cont."Company No." := RMMatrixMgt."Company No.";
            Found := Cont.FIND(Which);
            IF Found THEN
              CopyContactToBuf(Cont,RMMatrixMgt);
          END;
      END;
      EXIT(Found);
    END;

    LOCAL PROCEDURE NextRec@1101(TableOpt@1000 : 'Salesperson,Teams,Campaign,Contact';VAR RMMatrixMgt@1001 : Record 5102;Steps@1002 : Integer) : Integer;
    VAR
      ResultSteps@1102 : Integer;
    BEGIN
      CASE TableOpt OF
        TableOpt::Salesperson:
          BEGIN
            RMMatrixMgt."No." := COPYSTR(RMMatrixMgt."No.",1,MAXSTRLEN(Salesperson.Code));
            Salesperson.Code := COPYSTR(RMMatrixMgt."No.",1,MAXSTRLEN(Salesperson.Code));
            ResultSteps := Salesperson.NEXT(Steps);
            IF ResultSteps <> 0 THEN
              CopySalesPersonToBuf(Salesperson,RMMatrixMgt);
          END;
        TableOpt::Teams:
          BEGIN
            RMMatrixMgt."No." := COPYSTR(RMMatrixMgt."No.",1,MAXSTRLEN(Team.Code));
            Team.Code := RMMatrixMgt."No.";
            ResultSteps := Team.NEXT(Steps);
            IF ResultSteps <> 0 THEN
              CopyTeamToBuf(Team,RMMatrixMgt);
          END;
        TableOpt::Campaign:
          BEGIN
            Campaign."No." := RMMatrixMgt."No.";
            ResultSteps := Campaign.NEXT(Steps);
            IF ResultSteps <> 0 THEN
              CopyCampaignToBuf(Campaign,RMMatrixMgt);
          END;
        TableOpt::Contact:
          BEGIN
            Cont."Company Name" := RMMatrixMgt."Company Name";
            Cont.Type := RMMatrixMgt.Type;
            Cont.Name := COPYSTR(RMMatrixMgt.Name,1,MAXSTRLEN(Cont.Name));
            Cont."No." := RMMatrixMgt."No.";
            Cont."Company No." := RMMatrixMgt."Company No.";
            ResultSteps := Cont.NEXT(Steps);
            IF ResultSteps <> 0 THEN
              CopyContactToBuf(Cont,RMMatrixMgt);
          END;
      END;
      EXIT(ResultSteps);
    END;

    LOCAL PROCEDURE CopySalesPersonToBuf@1103(VAR Salesperson@1000 : Record 13;VAR RMMatrixMgt@1001 : Record 5102);
    BEGIN
      WITH RMMatrixMgt DO BEGIN
        INIT;
        "Company Name" := Salesperson.Code;
        Type := Type::Person;
        Name := Salesperson.Name;
        "No." := Salesperson.Code;
        "Company No." := '';
      END;
    END;

    LOCAL PROCEDURE CopyCampaignToBuf@1104(VAR TheCampaign@1000 : Record 5071;VAR RMMatrixMgt@1001 : Record 5102);
    BEGIN
      WITH RMMatrixMgt DO BEGIN
        INIT;
        "Company Name" := TheCampaign."No.";
        Type := Type::Person;
        Name := TheCampaign.Description;
        "No." := TheCampaign."No.";
        "Company No." := '';
      END;
    END;

    LOCAL PROCEDURE CopyContactToBuf@1105(VAR TheCont@1000 : Record 5050;VAR RMMatrixMgt@1001 : Record 5102);
    BEGIN
      WITH RMMatrixMgt DO BEGIN
        INIT;
        "Company Name" := TheCont."Company Name";
        Type := TheCont.Type;
        Name := TheCont.Name;
        "No." := TheCont."No.";
        "Company No." := TheCont."Company No.";
      END;
    END;

    LOCAL PROCEDURE CopyTeamToBuf@1106(VAR TheTeam@1000 : Record 5083;VAR RMMatrixMgt@1001 : Record 5102);
    BEGIN
      WITH RMMatrixMgt DO BEGIN
        INIT;
        "Company Name" := TheTeam.Code;
        Type := Type::Person;
        Name := TheTeam.Name;
        "No." := TheTeam.Code;
        "Company No." := '';
      END;
    END;

    LOCAL PROCEDURE ValidateTableOption@1116();
    BEGIN
      SETRANGE("Contact Company Filter");
      CASE TableOption OF
        TableOption::Salesperson:
          BEGIN
            SETFILTER("Team Filter",FilterTeam);
            SETFILTER("Campaign Filter",FilterCampaign);
            SETFILTER("Contact Filter",FilterContact);
            ValidateFilter;
          END;
        TableOption::Team:
          BEGIN
            SETFILTER("Salesperson Filter",FilterSalesPerson);
            SETFILTER("Campaign Filter",FilterCampaign);
            SETFILTER("Contact Filter",FilterContact);
            ValidateFilter;
          END;
        TableOption::Campaign:
          BEGIN
            SETFILTER("Salesperson Filter",FilterSalesPerson);
            SETFILTER("Team Filter",FilterTeam);
            SETFILTER("Contact Filter",FilterContact);
            ValidateFilter;
          END;
        TableOption::Contact:
          BEGIN
            SETFILTER("Salesperson Filter",FilterSalesPerson);
            SETFILTER("Team Filter",FilterTeam);
            SETFILTER("Campaign Filter",FilterCampaign);
            ValidateFilter;
          END;
      END;
    END;

    LOCAL PROCEDURE ValidateFilter@1117();
    BEGIN
      CASE TableOption OF
        TableOption::Salesperson:
          UpdateSalesPersonFilter;
        TableOption::Team:
          UpdateTeamFilter;
        TableOption::Campaign:
          UpdateCampaignFilter;
        TableOption::Contact:
          UpdateContactFilter;
      END;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE UpdateSalesPersonFilter@1118();
    BEGIN
      Salesperson.RESET;
      Salesperson.SETFILTER(Code,FilterSalesPerson);
      Salesperson.SETFILTER("Team Filter",FilterTeam);
      Salesperson.SETFILTER("Campaign Filter",FilterCampaign);
      Salesperson.SETFILTER("Contact Company Filter",FilterContact);
      Salesperson.SETFILTER("Task Status Filter",GETFILTER("Task Status Filter"));
      Salesperson.SETFILTER("Closed Task Filter",GETFILTER("Task Closed Filter"));
      Salesperson.SETFILTER("Priority Filter",GETFILTER("Priority Filter"));
      Salesperson.SETRANGE("Task Entry Exists",TRUE);
    END;

    LOCAL PROCEDURE UpdateCampaignFilter@1119();
    BEGIN
      Campaign.RESET;
      Campaign.SETFILTER("No.",FilterCampaign);
      Campaign.SETFILTER("Salesperson Filter",FilterSalesPerson);
      Campaign.SETFILTER("Team Filter",FilterTeam);
      Campaign.SETFILTER("Contact Company Filter",FilterContact);
      Campaign.SETFILTER("Task Status Filter",GETFILTER("Task Status Filter"));
      Campaign.SETFILTER("Task Closed Filter",GETFILTER("Task Closed Filter"));
      Campaign.SETFILTER("Priority Filter",GETFILTER("Priority Filter"));
      Campaign.SETRANGE("Task Entry Exists",TRUE);
    END;

    LOCAL PROCEDURE UpdateContactFilter@1120();
    BEGIN
      Cont.RESET;
      Cont.SETCURRENTKEY("Company Name","Company No.",Type,Name);
      Cont.SETFILTER("Company No.",FilterContact);
      Cont.SETFILTER("Campaign Filter",FilterCampaign);
      Cont.SETFILTER("Salesperson Filter",FilterSalesPerson);
      Cont.SETFILTER("Team Filter",FilterTeam);
      Cont.SETFILTER("Task Status Filter",GETFILTER("Task Status Filter"));
      Cont.SETFILTER("Task Closed Filter",GETFILTER("Task Closed Filter"));
      Cont.SETFILTER("Priority Filter",GETFILTER("Priority Filter"));
      Cont.SETRANGE("Task Entry Exists",TRUE);
    END;

    LOCAL PROCEDURE UpdateTeamFilter@1121();
    BEGIN
      Team.RESET;
      Team.SETFILTER(Code,FilterTeam);
      Team.SETFILTER("Campaign Filter",FilterCampaign);
      Team.SETFILTER("Salesperson Filter",FilterSalesPerson);
      Team.SETFILTER("Contact Company Filter",FilterContact);
      Team.SETFILTER("Task Status Filter",GETFILTER("Task Status Filter"));
      Team.SETFILTER("Task Closed Filter",GETFILTER("Task Closed Filter"));
      Team.SETFILTER("Priority Filter",GETFILTER("Priority Filter"));
      Team.SETRANGE("Task Entry Exists",TRUE);
    END;

    [Internal]
    PROCEDURE Load@1122(MatrixColumns1@1005 : ARRAY [32] OF Text[1024];VAR MatrixRecords1@1006 : ARRAY [32] OF Record 2000000007;TableOptionLocal@1001 : 'Salesperson,Team,Campaign,Contact';ColumnDateFilter@1000 : ARRAY [32] OF Text[50];OutputOptionLocal@1011 : 'No. of Tasks,Contact No.';FilterSalesPersonLocal@1007 : Code[250];FilterTeamLocal@1004 : Code[250];FilterCampaignLocal@1003 : Code[250];FilterContactLocal@1002 : Code[250];StatusFilterLocal@1010 : ' ,Not Started,In Progress,Completed,Waiting,Postponed';IncludeClosedLocal@1008 : Boolean;PriorityFilterLocal@1009 : ' ,Low,Normal,High');
    VAR
      i@1013 : Integer;
    BEGIN
      COPYARRAY(ColumnCaptions,MatrixColumns1,1);
      FOR i := 1 TO 32 DO
        MatrixRecords[i].COPY(MatrixRecords1[i]);
      TableOption := TableOptionLocal;
      COPYARRAY(ColumnDateFilters,ColumnDateFilter,1);
      OutputOption := OutputOptionLocal;
      FilterSalesPerson := FilterSalesPersonLocal;
      FilterTeam := FilterTeamLocal;
      FilterCampaign := FilterCampaignLocal;
      FilterContact := FilterContactLocal;
      StatusFilter := StatusFilterLocal;
      IncludeClosed := IncludeClosedLocal;
      PriorityFilter := PriorityFilterLocal;
      SetFilters;
    END;

    LOCAL PROCEDURE MatrixOnDrillDown@1123(ColumnID@1007 : Integer);
    BEGIN
      Task.SETRANGE(Date,MatrixRecords[ColumnID]."Period Start",MatrixRecords[ColumnID]."Period End");
      CASE TableOption OF
        TableOption::Salesperson:
          Task.SETFILTER("Salesperson Code","No.");
        TableOption::Team:
          Task.SETFILTER("Team Code","No.");
        TableOption::Campaign:
          Task.SETFILTER("Campaign No.","No.");
        TableOption::Contact:
          Task.SETFILTER("Contact No.","No.");
      END;
      Task.SETFILTER("Salesperson Code",GETFILTER("Salesperson Filter"));
      Task.SETFILTER("Team Code",GETFILTER("Team Filter"));
      Task.SETFILTER("Contact Company No.",GETFILTER("Contact Company Filter"));
      Task.SETFILTER(Status,GETFILTER("Task Status Filter"));
      Task.SETFILTER(Closed,GETFILTER("Task Closed Filter"));
      Task.SETFILTER(Priority,GETFILTER("Priority Filter"));
      Task.SETFILTER("System To-do Type",GETFILTER("System Task Type Filter"));

      PAGE.RUNMODAL(PAGE::"Task List",Task);
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1(Matrix_ColumnOrdinal@1000 : Integer);
    BEGIN
      SetFilters;
      SETRANGE("Date Filter",MatrixRecords[Matrix_ColumnOrdinal]."Period Start",MatrixRecords[Matrix_ColumnOrdinal]."Period End");
      CALCFIELDS("No. of Tasks");
      IF OutputOption <> OutputOption::"Contact No." THEN BEGIN
        IF "No. of Tasks" = 0 THEN
          MATRIX_CellData[Matrix_ColumnOrdinal] := ''
        ELSE
          MATRIX_CellData[Matrix_ColumnOrdinal] := FORMAT("No. of Tasks");
      END ELSE BEGIN
        IF GETFILTER("Team Filter") <> '' THEN
          Task.SETFILTER("Team Code",GETFILTER("Team Filter"));
        IF GETFILTER("Salesperson Filter") <> '' THEN
          Task.SETFILTER("Salesperson Code",GETFILTER("Salesperson Filter"));
        IF GETFILTER("Campaign Filter") <> '' THEN
          Task.SETFILTER("Campaign No.",GETFILTER("Campaign Filter"));
        IF GETFILTER("Contact Filter") <> '' THEN
          Task.SETFILTER("Contact No.","Contact Filter");
        IF GETFILTER("Date Filter") <> '' THEN
          Task.SETFILTER(Date,GETFILTER("Date Filter"));
        IF GETFILTER("Task Status Filter") <> '' THEN
          Task.SETFILTER(Status,GETFILTER("Task Status Filter"));
        IF GETFILTER("Priority Filter") <> '' THEN
          Task.SETFILTER(Priority,GETFILTER("Priority Filter"));
        IF GETFILTER("Task Closed Filter") <> '' THEN
          Task.SETFILTER(Closed,GETFILTER("Task Closed Filter"));
        IF GETFILTER("Contact Company Filter") <> '' THEN
          Task.SETFILTER("Contact Company No.",GETFILTER("Contact Company Filter"));
        IF "No. of Tasks" = 0 THEN
          MATRIX_CellData[Matrix_ColumnOrdinal] := ''
        ELSE
          IF "No. of Tasks" > 1 THEN
            MATRIX_CellData[Matrix_ColumnOrdinal] := MultipleTxt
          ELSE BEGIN
            Task.FINDFIRST;
            IF Task."Contact No." <> '' THEN
              MATRIX_CellData[Matrix_ColumnOrdinal] := Task."Contact No."
            ELSE
              MATRIX_CellData[Matrix_ColumnOrdinal] := MultipleTxt
          END;
      END;
    END;

    LOCAL PROCEDURE FormatLine@2();
    BEGIN
      StyleIsStrong := Type = Type::Company;
    END;

    BEGIN
    END.
  }
}

