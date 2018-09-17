OBJECT Page 9257 Opportunities Matrix
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
    CaptionML=[DAN=Matrix for salgsmuligheder;
               ENU=Opportunities Matrix];
    LinksAllowed=No;
    SourceTable=Table5102;
    DataCaptionExpr=FORMAT(SELECTSTR(OutPutOption + 1,Text002));
    PageType=List;
    OnInit=BEGIN
             Field32Visible := TRUE;
             Field31Visible := TRUE;
             Field30Visible := TRUE;
             Field29Visible := TRUE;
             Field28Visible := TRUE;
             Field27Visible := TRUE;
             Field26Visible := TRUE;
             Field25Visible := TRUE;
             Field24Visible := TRUE;
             Field23Visible := TRUE;
             Field22Visible := TRUE;
             Field21Visible := TRUE;
             Field20Visible := TRUE;
             Field19Visible := TRUE;
             Field18Visible := TRUE;
             Field17Visible := TRUE;
             Field16Visible := TRUE;
             Field15Visible := TRUE;
             Field14Visible := TRUE;
             Field13Visible := TRUE;
             Field12Visible := TRUE;
             Field11Visible := TRUE;
             Field10Visible := TRUE;
             Field9Visible := TRUE;
             Field8Visible := TRUE;
             Field7Visible := TRUE;
             Field6Visible := TRUE;
             Field5Visible := TRUE;
             Field4Visible := TRUE;
             Field3Visible := TRUE;
             Field2Visible := TRUE;
             Field1Visible := TRUE;
           END;

    OnOpenPage=BEGIN
                 TestFilters;
                 ValidateStatus;
                 ValidateFilter;
                 SetColumnVisibility;
               END;

    OnFindRecord=BEGIN
                   EXIT(FindRec(TableOption,Rec,Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(NextRec(TableOption,Rec,Steps));
                 END;

    OnAfterGetRecord=VAR
                       MATRIX_CurrentColumnOrdinal@1561 : Integer;
                     BEGIN
                       StyleIsStrong := Type = Type::Company;
                       IF (Type = Type::Person) AND (TableOption = TableOption::Contact) THEN
                         NameIndent := 1
                       ELSE
                         NameIndent := 0;

                       MATRIX_CurrentColumnOrdinal := 0;
                       WHILE MATRIX_CurrentColumnOrdinal < MATRIX_CurrentNoOfMatrixColumn DO BEGIN
                         MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
                         MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
                       END;
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
                           Campaign@1562 : Record 5071;
                           SalesPurchPerson@1563 : Record 13;
                           Contact@1564 : Record 5050;
                         BEGIN
                           CASE TableOption OF
                             TableOption::SalesPerson:
                               BEGIN
                                 SalesPurchPerson.GET("No.");
                                 PAGE.RUNMODAL(0,SalesPurchPerson);
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
                ToolTipML=[DAN=Angiver navnet p� salgsmuligheden.;
                           ENU=Specifies the name of the opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 1529;2   ;Field     ;
                Name=Field1;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[1];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[1];
                Visible=Field1Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(1);
                            END;
                             }

    { 1530;2   ;Field     ;
                Name=Field2;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[2];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[2];
                Visible=Field2Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(2);
                            END;
                             }

    { 1531;2   ;Field     ;
                Name=Field3;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[3];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[3];
                Visible=Field3Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(3);
                            END;
                             }

    { 1532;2   ;Field     ;
                Name=Field4;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[4];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[4];
                Visible=Field4Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(4);
                            END;
                             }

    { 1533;2   ;Field     ;
                Name=Field5;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[5];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[5];
                Visible=Field5Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(5);
                            END;
                             }

    { 1534;2   ;Field     ;
                Name=Field6;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[6];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[6];
                Visible=Field6Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(6);
                            END;
                             }

    { 1535;2   ;Field     ;
                Name=Field7;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[7];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[7];
                Visible=Field7Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(7);
                            END;
                             }

    { 1536;2   ;Field     ;
                Name=Field8;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[8];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[8];
                Visible=Field8Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(8);
                            END;
                             }

    { 1537;2   ;Field     ;
                Name=Field9;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[9];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[9];
                Visible=Field9Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(9);
                            END;
                             }

    { 1538;2   ;Field     ;
                Name=Field10;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[10];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[10];
                Visible=Field10Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(10);
                            END;
                             }

    { 1539;2   ;Field     ;
                Name=Field11;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[11];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[11];
                Visible=Field11Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(11);
                            END;
                             }

    { 1540;2   ;Field     ;
                Name=Field12;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[12];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[12];
                Visible=Field12Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(12);
                            END;
                             }

    { 1541;2   ;Field     ;
                Name=Field13;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[13];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[13];
                Visible=Field13Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(13);
                            END;
                             }

    { 1542;2   ;Field     ;
                Name=Field14;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[14];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[14];
                Visible=Field14Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(14);
                            END;
                             }

    { 1543;2   ;Field     ;
                Name=Field15;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[15];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[15];
                Visible=Field15Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(15);
                            END;
                             }

    { 1544;2   ;Field     ;
                Name=Field16;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[16];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[16];
                Visible=Field16Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(16);
                            END;
                             }

    { 1545;2   ;Field     ;
                Name=Field17;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[17];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[17];
                Visible=Field17Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(17);
                            END;
                             }

    { 1546;2   ;Field     ;
                Name=Field18;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[18];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[18];
                Visible=Field18Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(18);
                            END;
                             }

    { 1547;2   ;Field     ;
                Name=Field19;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[19];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[19];
                Visible=Field19Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(19);
                            END;
                             }

    { 1548;2   ;Field     ;
                Name=Field20;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[20];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[20];
                Visible=Field20Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(20);
                            END;
                             }

    { 1549;2   ;Field     ;
                Name=Field21;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[21];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[21];
                Visible=Field21Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(21);
                            END;
                             }

    { 1550;2   ;Field     ;
                Name=Field22;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[22];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[22];
                Visible=Field22Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(22);
                            END;
                             }

    { 1551;2   ;Field     ;
                Name=Field23;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[23];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[23];
                Visible=Field23Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(23);
                            END;
                             }

    { 1552;2   ;Field     ;
                Name=Field24;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[24];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[24];
                Visible=Field24Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(24);
                            END;
                             }

    { 1553;2   ;Field     ;
                Name=Field25;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[25];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[25];
                Visible=Field25Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(25);
                            END;
                             }

    { 1554;2   ;Field     ;
                Name=Field26;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[26];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[26];
                Visible=Field26Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(26);
                            END;
                             }

    { 1555;2   ;Field     ;
                Name=Field27;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[27];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[27];
                Visible=Field27Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(27);
                            END;
                             }

    { 1556;2   ;Field     ;
                Name=Field28;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[28];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[28];
                Visible=Field28Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(28);
                            END;
                             }

    { 1557;2   ;Field     ;
                Name=Field29;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[29];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[29];
                Visible=Field29Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(29);
                            END;
                             }

    { 1558;2   ;Field     ;
                Name=Field30;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[30];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[30];
                Visible=Field30Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(30);
                            END;
                             }

    { 1559;2   ;Field     ;
                Name=Field31;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[31];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[31];
                Visible=Field31Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(31);
                            END;
                             }

    { 1560;2   ;Field     ;
                Name=Field32;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=MATRIX_CellData[32];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                CaptionClass='3,' + MATRIX_CaptionSet[32];
                Visible=Field32Visible;
                Style=Strong;
                StyleExpr=StyleIsStrong;
                OnDrillDown=BEGIN
                              SetFilters;
                              MATRIX_OnDrillDown(32);
                            END;
                             }

  }
  CODE
  {
    VAR
      Text000@1599 : TextConst 'DAN=<Sign><Integer>;ENU=<Sign><Integer>';
      Text001@1600 : TextConst 'DAN=<Sign><Integer Thousand><Decimals,2>;ENU=<Sign><Integer Thousand><Decimals,2>';
      MatrixRecords@1013 : ARRAY [32] OF Record 2000000007;
      TempOpp@1012 : TEMPORARY Record 5092;
      OppEntry@1011 : Record 5093;
      Opp@1002 : Record 5092;
      SalespersonPurchaser@1001 : Record 13;
      Cont@1601 : Record 5050;
      Campaign@1602 : Record 5071;
      MatrixMgt@1003 : Codeunit 9200;
      OptionStatusFilter@1605 : 'In Progress,Won,Lost';
      OutPutOption@1606 : 'No of Opportunities,Estimated Value (LCY),Calc. Current Value (LCY),Avg. Estimated Value (LCY),Avg. Calc. Current Value (LCY)';
      RoundingFactor@1607 : 'None,1,1000,1000000';
      TableOption@1608 : 'SalesPerson,Campaign,Contact';
      Text002@1609 : TextConst 'DAN=Antal salgsmuligheder,Ansl�et v�rdi (RV),Beregn. aktuel v�rdi (RV),Gnsn. ansl�et v�rdi (RV),Gnsn. beregn. aktuel v�rdi (RV);ENU=No of Opportunities,Estimated Value (LCY),Calc. Current Value (LCY),Avg. Estimated Value (LCY),Avg. Calc. Current Value (LCY)';
      MATRIX_CurrentNoOfMatrixColumn@1611 : Integer;
      MATRIX_CellData@1612 : ARRAY [32] OF Text[80];
      MATRIX_CaptionSet@1613 : ARRAY [32] OF Text[80];
      EstimatedValueFilter@1004 : Text;
      SalesCycleStageFilter@1005 : Text;
      SuccessChanceFilter@1006 : Text;
      ProbabilityFilter@1007 : Text;
      CompletedFilter@1008 : Text;
      CalcdCurrentValueFilter@1009 : Text;
      SalesCycleFilter@1010 : Text;
      RoundingFactorFormatString@1039 : Text;
      StyleIsStrong@1000 : Boolean INDATASET;
      NameIndent@19079073 : Integer INDATASET;
      Field1Visible@19069335 : Boolean INDATASET;
      Field2Visible@19014807 : Boolean INDATASET;
      Field3Visible@19062679 : Boolean INDATASET;
      Field4Visible@19074839 : Boolean INDATASET;
      Field5Visible@19043543 : Boolean INDATASET;
      Field6Visible@19067287 : Boolean INDATASET;
      Field7Visible@19067863 : Boolean INDATASET;
      Field8Visible@19039959 : Boolean INDATASET;
      Field9Visible@19008663 : Boolean INDATASET;
      Field10Visible@19006501 : Boolean INDATASET;
      Field11Visible@19052468 : Boolean INDATASET;
      Field12Visible@19013039 : Boolean INDATASET;
      Field13Visible@19079726 : Boolean INDATASET;
      Field14Visible@19077225 : Boolean INDATASET;
      Field15Visible@19035896 : Boolean INDATASET;
      Field16Visible@19003763 : Boolean INDATASET;
      Field17Visible@19049730 : Boolean INDATASET;
      Field18Visible@19007213 : Boolean INDATASET;
      Field19Visible@19053180 : Boolean INDATASET;
      Field20Visible@19014629 : Boolean INDATASET;
      Field21Visible@19060596 : Boolean INDATASET;
      Field22Visible@19021167 : Boolean INDATASET;
      Field23Visible@19047854 : Boolean INDATASET;
      Field24Visible@19045353 : Boolean INDATASET;
      Field25Visible@19004024 : Boolean INDATASET;
      Field26Visible@19011891 : Boolean INDATASET;
      Field27Visible@19057858 : Boolean INDATASET;
      Field28Visible@19015341 : Boolean INDATASET;
      Field29Visible@19061308 : Boolean INDATASET;
      Field30Visible@19010597 : Boolean INDATASET;
      Field31Visible@19056564 : Boolean INDATASET;
      Field32Visible@19017135 : Boolean INDATASET;

    LOCAL PROCEDURE SetFilters@1614();
    BEGIN
      CASE TableOption OF
        TableOption::SalesPerson:
          SETRANGE("Salesperson Filter","No.");
        TableOption::Campaign:
          SETRANGE("Campaign Filter","No.");
        TableOption::Contact:
          IF Type = Type::Company THEN BEGIN
            SETRANGE("Contact Filter");
            SETRANGE("Contact Company Filter","Company No.");
          END ELSE BEGIN
            SETRANGE("Contact Filter","No.");
            SETRANGE("Contact Company Filter","Company No.");
          END;
      END;
    END;

    LOCAL PROCEDURE ReturnOutput@1615() : Decimal;
    BEGIN
      CASE OutPutOption OF
        OutPutOption::"No of Opportunities":
          EXIT("No. of Opportunities");
        OutPutOption::"Estimated Value (LCY)":
          EXIT("Estimated Value (LCY)");
        OutPutOption::"Calc. Current Value (LCY)":
          EXIT("Calcd. Current Value (LCY)");
        OutPutOption::"Avg. Estimated Value (LCY)":
          EXIT("Avg. Estimated Value (LCY)");
        OutPutOption::"Avg. Calc. Current Value (LCY)":
          EXIT("Avg.Calcd. Current Value (LCY)");
      END;
    END;

    LOCAL PROCEDURE FormatAmount@1616(VAR Text@1000 : Text[250]);
    VAR
      Amount@1617 : Decimal;
    BEGIN
      IF Text <> '' THEN BEGIN
        EVALUATE(Amount,Text);
        IF OutPutOption = OutPutOption::"No of Opportunities" THEN
          Text := FORMAT(Amount,0,Text000);
        Amount := MatrixMgt.RoundValue(Amount,RoundingFactor);
        IF Amount = 0 THEN
          Text := ''
        ELSE
          CASE RoundingFactor OF
            RoundingFactor::"1":
              Text := FORMAT(Amount);
            RoundingFactor::"1000",RoundingFactor::"1000000":
              Text := FORMAT(Amount,0,Text001);
          END;
      END;
    END;

    LOCAL PROCEDURE FindRec@1618(TableOpt@1000 : 'Salesperson,Campaign,Contact';VAR RMMatrixMgt@1001 : Record 5102;Which@1002 : Text[250]) : Boolean;
    VAR
      Found@1619 : Boolean;
    BEGIN
      CASE TableOpt OF
        TableOpt::Salesperson:
          BEGIN
            RMMatrixMgt."No." := COPYSTR(RMMatrixMgt."No.",1,MAXSTRLEN(SalespersonPurchaser.Code));
            SalespersonPurchaser.Code := COPYSTR(RMMatrixMgt."No.",1,MAXSTRLEN(SalespersonPurchaser.Code));
            Found := SalespersonPurchaser.FIND(Which);
            IF Found THEN
              CopySalespersonToBuf(SalespersonPurchaser,RMMatrixMgt);
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
            Cont.Name := RMMatrixMgt.Name;
            Cont."No." := RMMatrixMgt."No.";
            Cont."Company No." := RMMatrixMgt."Company No.";
            Found := Cont.FIND(Which);
            IF Found THEN
              CopyContactToBuf(Cont,RMMatrixMgt);
          END;
      END;
      EXIT(Found);
    END;

    LOCAL PROCEDURE NextRec@1620(TableOpt@1000 : 'Salesperson,Campaign,Contact';VAR RMMatrixMgt@1001 : Record 5102;Steps@1002 : Integer) : Integer;
    VAR
      ResultSteps@1621 : Integer;
    BEGIN
      CASE TableOpt OF
        TableOpt::Salesperson:
          BEGIN
            RMMatrixMgt."No." := COPYSTR(RMMatrixMgt."No.",1,MAXSTRLEN(SalespersonPurchaser.Code));
            SalespersonPurchaser.Code := COPYSTR(RMMatrixMgt."No.",1,MAXSTRLEN(SalespersonPurchaser.Code));
            ResultSteps := SalespersonPurchaser.NEXT(Steps);
            IF ResultSteps <> 0 THEN
              CopySalespersonToBuf(SalespersonPurchaser,RMMatrixMgt);
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
            Cont.Name := RMMatrixMgt.Name;
            Cont."No." := RMMatrixMgt."No.";
            Cont."Company No." := RMMatrixMgt."Company No.";
            ResultSteps := Cont.NEXT(Steps);
            IF ResultSteps <> 0 THEN
              CopyContactToBuf(Cont,RMMatrixMgt);
          END;
      END;
      EXIT(ResultSteps);
    END;

    LOCAL PROCEDURE CopySalespersonToBuf@1622(VAR SalesPurchPerson@1000 : Record 13;VAR RMMatrixMgt@1001 : Record 5102);
    BEGIN
      WITH RMMatrixMgt DO BEGIN
        INIT;
        "Company Name" := SalesPurchPerson.Code;
        Type := Type::Person;
        Name := SalesPurchPerson.Name;
        "No." := SalesPurchPerson.Code;
        "Company No." := '';
      END;
    END;

    LOCAL PROCEDURE CopyCampaignToBuf@1623(VAR TheCampaign@1000 : Record 5071;VAR RMMatrixMgt@1001 : Record 5102);
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

    LOCAL PROCEDURE CopyContactToBuf@1624(VAR TheCont@1000 : Record 5050;VAR RMMatrixMgt@1001 : Record 5102);
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

    LOCAL PROCEDURE ValidateStatus@1625();
    BEGIN
      CASE OptionStatusFilter OF
        OptionStatusFilter::"In Progress":
          SETRANGE("Action Taken Filter","Action Taken Filter"::" ","Action Taken Filter"::Jumped);
        OptionStatusFilter::Won:
          SETRANGE("Action Taken Filter","Action Taken Filter"::Won);
        OptionStatusFilter::Lost:
          SETRANGE("Action Taken Filter","Action Taken Filter"::Lost);
      END;
    END;

    LOCAL PROCEDURE ValidateFilter@1626();
    BEGIN
      CASE TableOption OF
        TableOption::SalesPerson:
          BEGIN
            SETRANGE("Campaign Filter");
            SETRANGE("Contact Filter");
            SETRANGE("Contact Company Filter");
            UpdateSalespersonFilter;
          END;
        TableOption::Campaign:
          BEGIN
            SETRANGE("Salesperson Filter");
            SETRANGE("Contact Filter");
            SETRANGE("Contact Company Filter");
            UpdateCampaignFilter;
          END;
        TableOption::Contact:
          BEGIN
            SETRANGE("Salesperson Filter");
            SETRANGE("Campaign Filter");
            UpdateContactFilter;
          END;
      END;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE UpdateSalespersonFilter@1627();
    BEGIN
      SalespersonPurchaser.RESET;
      IF GETFILTER("Action Taken Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Action Taken Filter",GETFILTER("Action Taken Filter"));
      IF GETFILTER("Sales Cycle Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Sales Cycle Filter",GETFILTER("Sales Cycle Filter"));
      IF GETFILTER("Sales Cycle Stage Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Sales Cycle Stage Filter",GETFILTER("Sales Cycle Stage Filter"));
      IF GETFILTER("Probability % Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Probability % Filter",GETFILTER("Probability % Filter"));
      IF GETFILTER("Completed % Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Completed % Filter",GETFILTER("Completed % Filter"));
      IF GETFILTER("Close Opportunity Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Close Opportunity Filter",GETFILTER("Close Opportunity Filter"));
      IF GETFILTER("Contact Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Contact Filter",GETFILTER("Contact Filter"));
      IF GETFILTER("Contact Company Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Contact Company Filter",GETFILTER("Contact Company Filter"));
      IF GETFILTER("Campaign Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Campaign Filter",GETFILTER("Campaign Filter"));
      IF GETFILTER("Estimated Value Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Estimated Value Filter",GETFILTER("Estimated Value Filter"));
      IF GETFILTER("Calcd. Current Value Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Calcd. Current Value Filter",GETFILTER("Calcd. Current Value Filter"));
      IF GETFILTER("Chances of Success % Filter") <> '' THEN
        SalespersonPurchaser.SETFILTER("Chances of Success % Filter",GETFILTER("Chances of Success % Filter"));
      SalespersonPurchaser.SETRANGE("Opportunity Entry Exists",TRUE);
    END;

    LOCAL PROCEDURE UpdateCampaignFilter@1628();
    BEGIN
      Campaign.RESET;
      IF GETFILTER("Action Taken Filter") <> '' THEN
        Campaign.SETFILTER("Action Taken Filter",GETFILTER("Action Taken Filter"));
      IF GETFILTER("Sales Cycle Filter") <> '' THEN
        Campaign.SETFILTER("Sales Cycle Filter",GETFILTER("Sales Cycle Filter"));
      IF GETFILTER("Sales Cycle Stage Filter") <> '' THEN
        Campaign.SETFILTER("Sales Cycle Stage Filter",GETFILTER("Sales Cycle Stage Filter"));
      IF GETFILTER("Probability % Filter") <> '' THEN
        Campaign.SETFILTER("Probability % Filter",GETFILTER("Probability % Filter"));
      IF GETFILTER("Completed % Filter") <> '' THEN
        Campaign.SETFILTER("Completed % Filter",GETFILTER("Completed % Filter"));
      IF GETFILTER("Close Opportunity Filter") <> '' THEN
        Campaign.SETFILTER("Close Opportunity Filter",GETFILTER("Close Opportunity Filter"));
      IF GETFILTER("Contact Filter") <> '' THEN
        Campaign.SETFILTER("Contact Filter",GETFILTER("Contact Filter"));
      IF GETFILTER("Contact Company Filter") <> '' THEN
        Campaign.SETFILTER("Contact Company Filter",GETFILTER("Contact Company Filter"));
      IF GETFILTER("Estimated Value Filter") <> '' THEN
        Campaign.SETFILTER("Estimated Value Filter",GETFILTER("Estimated Value Filter"));
      IF GETFILTER("Salesperson Filter") <> '' THEN
        Campaign.SETFILTER("Salesperson Filter",GETFILTER("Salesperson Filter"));
      IF GETFILTER("Calcd. Current Value Filter") <> '' THEN
        Campaign.SETFILTER("Calcd. Current Value Filter",GETFILTER("Calcd. Current Value Filter"));
      IF GETFILTER("Chances of Success % Filter") <> '' THEN
        Campaign.SETFILTER("Chances of Success % Filter",GETFILTER("Chances of Success % Filter"));
      Campaign.SETRANGE("Opportunity Entry Exists",TRUE);
    END;

    LOCAL PROCEDURE UpdateContactFilter@1629();
    BEGIN
      Cont.RESET;
      Cont.SETCURRENTKEY("Company Name","Company No.",Type,Name);
      IF GETFILTER("Action Taken Filter") <> '' THEN
        Cont.SETFILTER("Action Taken Filter",GETFILTER("Action Taken Filter"));
      IF GETFILTER("Sales Cycle Filter") <> '' THEN
        Cont.SETFILTER("Sales Cycle Filter",GETFILTER("Sales Cycle Filter"));
      IF GETFILTER("Sales Cycle Stage Filter") <> '' THEN
        Cont.SETFILTER("Sales Cycle Stage Filter",GETFILTER("Sales Cycle Stage Filter"));
      IF GETFILTER("Probability % Filter") <> '' THEN
        Cont.SETFILTER("Probability % Filter",GETFILTER("Probability % Filter"));
      IF GETFILTER("Completed % Filter") <> '' THEN
        Cont.SETFILTER("Completed % Filter",GETFILTER("Completed % Filter"));
      IF GETFILTER("Close Opportunity Filter") <> '' THEN
        Cont.SETFILTER("Close Opportunity Filter",GETFILTER("Close Opportunity Filter"));
      IF GETFILTER("Estimated Value Filter") <> '' THEN
        Cont.SETFILTER("Estimated Value Filter",GETFILTER("Estimated Value Filter"));
      IF GETFILTER("Salesperson Filter") <> '' THEN
        Cont.SETFILTER("Salesperson Filter",GETFILTER("Salesperson Filter"));
      IF GETFILTER("Calcd. Current Value Filter") <> '' THEN
        Cont.SETFILTER("Calcd. Current Value Filter",GETFILTER("Calcd. Current Value Filter"));
      IF GETFILTER("Chances of Success % Filter") <> '' THEN
        Cont.SETFILTER("Chances of Success % Filter",GETFILTER("Chances of Success % Filter"));
      IF GETFILTER("Campaign Filter") <> '' THEN
        Cont.SETFILTER("Campaign Filter",GETFILTER("Campaign Filter"));
      Cont.SETRANGE("Opportunity Entry Exists",TRUE);
    END;

    [Internal]
    PROCEDURE Load@1630(MatrixColumns1@1522 : ARRAY [32] OF Text[1024];VAR MatrixRecords1@1523 : ARRAY [32] OF Record 2000000007;TableOptionLocal@1000 : 'SalesPerson,Campaign,Contact';OutPutOptionLocal@1001 : 'No of Opportunities,Estimated Value (LCY),Calc. Current Value (LCY),Avg. Estimated Value (LCY),Avg. Calc. Current Value (LCY)';RoundingFactorLocal@1002 : 'None,1,1000,1000000';OptionStatusFilterLocal@1003 : 'In Progress,Won,Lost';CloseOpportunityFilterLocal@1004 : Text;SuccessChanceFilterLocal@1005 : Text;ProbabilityFilterLocal@1006 : Text;CompletedFilterLocal@1007 : Text;EstimatedValueFilterLocal@1008 : Text;CalcdCurrentValueFilterLocal@1009 : Text;SalesCycleFilterLocal@1010 : Text;SalesCycleStageFilterLocal@1011 : Text;NoOfColumns@1013 : Integer);
    BEGIN
      COPYARRAY(MATRIX_CaptionSet,MatrixColumns1,1);
      COPYARRAY(MatrixRecords,MatrixRecords1,1);
      TableOption := TableOptionLocal;
      OutPutOption := OutPutOptionLocal;
      RoundingFactor := RoundingFactorLocal;
      OptionStatusFilter := OptionStatusFilterLocal;
      "Close Opportunity Filter" := CloseOpportunityFilterLocal;
      SuccessChanceFilter := SuccessChanceFilterLocal;
      ProbabilityFilter := ProbabilityFilterLocal;
      CompletedFilter := CompletedFilterLocal;
      CalcdCurrentValueFilter := CalcdCurrentValueFilterLocal;
      SalesCycleFilter := SalesCycleFilterLocal;
      SalesCycleStageFilter := SalesCycleStageFilterLocal;
      EstimatedValueFilter := EstimatedValueFilterLocal;
      MATRIX_CurrentNoOfMatrixColumn := NoOfColumns;
      RoundingFactorFormatString := MatrixMgt.GetFormatString(RoundingFactor,FALSE);
    END;

    LOCAL PROCEDURE MATRIX_OnDrillDown@1631(MATRIX_ColumnOrdinal@1525 : Integer);
    BEGIN
      TempOpp.DELETEALL;

      OppEntry.SETCURRENTKEY(Active,"Salesperson Code","Estimated Close Date",
        "Action Taken","Sales Cycle Code","Sales Cycle Stage",
        "Completed %","Probability %","Contact No.","Contact Company No.",
        "Campaign No.","Chances of Success %","Estimated Value (LCY)",
        "Calcd. Current Value (LCY)","Close Opportunity Code");

      OppEntry.SETRANGE("Estimated Close Date",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start",
        MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

      OppEntry.SETRANGE(Active,TRUE);

      CASE TableOption OF
        TableOption::SalesPerson:
          OppEntry.SETFILTER("Salesperson Code","No.");
        TableOption::Campaign:
          OppEntry.SETFILTER("Campaign No.","No.");
        TableOption::Contact:
          OppEntry.SETFILTER("Contact No.","No.");
      END;

      IF GETFILTER("Contact Company Filter") <> '' THEN
        OppEntry.SETFILTER("Contact Company No.","Company No.");

      IF GETFILTER("Sales Cycle Filter") <> '' THEN
        OppEntry.SETFILTER("Sales Cycle Code",GETFILTER("Sales Cycle Filter"));

      IF GETFILTER("Sales Cycle Stage Filter") <> '' THEN
        OppEntry.SETFILTER("Sales Cycle Stage",GETFILTER("Sales Cycle Stage Filter"));

      IF GETFILTER("Action Taken Filter") <> '' THEN
        OppEntry.SETFILTER("Action Taken",GETFILTER("Action Taken Filter"));

      IF GETFILTER("Probability % Filter") <> '' THEN
        OppEntry.SETFILTER("Probability %",GETFILTER("Probability % Filter"));

      IF GETFILTER("Completed % Filter") <> '' THEN
        OppEntry.SETFILTER("Completed %",GETFILTER("Completed % Filter"));

      IF GETFILTER("Close Opportunity Filter") <> '' THEN
        OppEntry.SETFILTER("Close Opportunity Code",GETFILTER("Close Opportunity Filter"));

      IF GETFILTER("Chances of Success % Filter") <> '' THEN
        OppEntry.SETFILTER("Chances of Success %",GETFILTER("Chances of Success % Filter"));

      IF GETFILTER("Estimated Value Filter") <> '' THEN
        OppEntry.SETFILTER("Estimated Value (LCY)",GETFILTER("Estimated Value Filter"));

      IF GETFILTER("Calcd. Current Value Filter") <> '' THEN
        OppEntry.SETFILTER("Calcd. Current Value (LCY)",GETFILTER("Calcd. Current Value Filter"));

      IF OppEntry.FIND('-') THEN
        REPEAT
          Opp.GET(OppEntry."Opportunity No.");
          TempOpp := Opp;
          TempOpp.INSERT;
        UNTIL OppEntry.NEXT = 0;

      PAGE.RUN(PAGE::"Active Opportunity List",TempOpp);
    END;

    LOCAL PROCEDURE MATRIX_OnAfterGetRecord@1633(MATRIX_ColumnOrdinal@1527 : Integer);
    VAR
      TestAmount@1000 : Text[80];
    BEGIN
      SetFilters;
      SETRANGE("Date Filter",MatrixRecords[MATRIX_ColumnOrdinal]."Period Start",MatrixRecords[MATRIX_ColumnOrdinal]."Period End");

      CASE OutPutOption OF
        OutPutOption::"No of Opportunities":
          CALCFIELDS("No. of Opportunities");
        OutPutOption::"Estimated Value (LCY)":
          CALCFIELDS("Estimated Value (LCY)");
        OutPutOption::"Calc. Current Value (LCY)":
          CALCFIELDS("Calcd. Current Value (LCY)");
        OutPutOption::"Avg. Estimated Value (LCY)":
          CALCFIELDS("Avg. Estimated Value (LCY)");
        OutPutOption::"Avg. Calc. Current Value (LCY)":
          CALCFIELDS("Avg.Calcd. Current Value (LCY)");
      END;
      IF ReturnOutput = 0 THEN
        MATRIX_CellData[MATRIX_ColumnOrdinal] := ''
      ELSE BEGIN
        TestAmount := FORMAT(ReturnOutput,0,0);
        FormatAmount(TestAmount);
        MATRIX_CellData[MATRIX_ColumnOrdinal] := TestAmount;
      END;
    END;

    LOCAL PROCEDURE TestFilters@2();
    BEGIN
      IF EstimatedValueFilter <> '' THEN
        SETFILTER("Estimated Value Filter",EstimatedValueFilter)
      ELSE
        SETRANGE("Estimated Value Filter");

      IF SalesCycleStageFilter <> '' THEN
        SETFILTER("Sales Cycle Stage Filter",SalesCycleStageFilter)
      ELSE
        SETRANGE("Sales Cycle Stage Filter");

      IF SuccessChanceFilter <> '' THEN
        SETFILTER("Chances of Success % Filter",SuccessChanceFilter)
      ELSE
        SETRANGE("Chances of Success % Filter");

      IF ProbabilityFilter <> '' THEN
        SETFILTER("Probability % Filter",ProbabilityFilter)
      ELSE
        SETRANGE("Probability % Filter");

      IF CompletedFilter <> '' THEN
        SETFILTER("Completed % Filter",CompletedFilter)
      ELSE
        SETRANGE("Completed % Filter");

      IF CalcdCurrentValueFilter <> '' THEN
        SETFILTER("Calcd. Current Value Filter",CalcdCurrentValueFilter)
      ELSE
        SETRANGE("Calcd. Current Value Filter");

      IF SalesCycleFilter <> '' THEN
        SETFILTER("Sales Cycle Filter",SalesCycleFilter)
      ELSE
        SETRANGE("Sales Cycle Filter");
    END;

    [External]
    PROCEDURE SetColumnVisibility@1();
    BEGIN
      Field1Visible := MATRIX_CurrentNoOfMatrixColumn >= 1;
      Field2Visible := MATRIX_CurrentNoOfMatrixColumn >= 2;
      Field3Visible := MATRIX_CurrentNoOfMatrixColumn >= 3;
      Field4Visible := MATRIX_CurrentNoOfMatrixColumn >= 4;
      Field5Visible := MATRIX_CurrentNoOfMatrixColumn >= 5;
      Field6Visible := MATRIX_CurrentNoOfMatrixColumn >= 6;
      Field7Visible := MATRIX_CurrentNoOfMatrixColumn >= 7;
      Field8Visible := MATRIX_CurrentNoOfMatrixColumn >= 8;
      Field9Visible := MATRIX_CurrentNoOfMatrixColumn >= 9;
      Field10Visible := MATRIX_CurrentNoOfMatrixColumn >= 10;
      Field11Visible := MATRIX_CurrentNoOfMatrixColumn >= 11;
      Field12Visible := MATRIX_CurrentNoOfMatrixColumn >= 12;
      Field13Visible := MATRIX_CurrentNoOfMatrixColumn >= 13;
      Field14Visible := MATRIX_CurrentNoOfMatrixColumn >= 14;
      Field15Visible := MATRIX_CurrentNoOfMatrixColumn >= 15;
      Field16Visible := MATRIX_CurrentNoOfMatrixColumn >= 16;
      Field17Visible := MATRIX_CurrentNoOfMatrixColumn >= 17;
      Field18Visible := MATRIX_CurrentNoOfMatrixColumn >= 18;
      Field19Visible := MATRIX_CurrentNoOfMatrixColumn >= 19;
      Field20Visible := MATRIX_CurrentNoOfMatrixColumn >= 20;
      Field21Visible := MATRIX_CurrentNoOfMatrixColumn >= 21;
      Field22Visible := MATRIX_CurrentNoOfMatrixColumn >= 22;
      Field23Visible := MATRIX_CurrentNoOfMatrixColumn >= 23;
      Field24Visible := MATRIX_CurrentNoOfMatrixColumn >= 24;
      Field25Visible := MATRIX_CurrentNoOfMatrixColumn >= 25;
      Field26Visible := MATRIX_CurrentNoOfMatrixColumn >= 26;
      Field27Visible := MATRIX_CurrentNoOfMatrixColumn >= 27;
      Field28Visible := MATRIX_CurrentNoOfMatrixColumn >= 28;
      Field29Visible := MATRIX_CurrentNoOfMatrixColumn >= 29;
      Field30Visible := MATRIX_CurrentNoOfMatrixColumn >= 30;
      Field31Visible := MATRIX_CurrentNoOfMatrixColumn >= 31;
      Field32Visible := MATRIX_CurrentNoOfMatrixColumn >= 32;
    END;

    LOCAL PROCEDURE FormatStr@8() : Text;
    BEGIN
      EXIT(RoundingFactorFormatString);
    END;

    BEGIN
    END.
  }
}

