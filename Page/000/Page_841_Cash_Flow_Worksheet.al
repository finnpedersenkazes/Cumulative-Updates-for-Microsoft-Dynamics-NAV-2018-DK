OBJECT Page 841 Cash Flow Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Pengestr›mskladde;
               ENU=Cash Flow Worksheet];
    SaveValues=Yes;
    SourceTable=Table846;
    DelayedInsert=Yes;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Side;
                                ENU=New,Process,Report,Page];
    OnOpenPage=VAR
                 ServerConfigSettingHandler@1000 : Codeunit 6723;
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 DeleteErrors;
               END;

    OnClosePage=BEGIN
                  DeleteErrors;
                END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                       SourceNumEnabled := "Source Type" <> "Source Type"::Tax;
                     END;

    OnNewRecord=BEGIN
                  CFName := '';
                  CFAccName := '';
                END;

    OnAfterGetCurrRecord=BEGIN
                           ShowErrors;
                           CFName := CashFlowManagement.CashFlowName("Cash Flow Forecast No.");
                           CFAccName := CashFlowManagement.CashFlowAccountName("Cash Flow Account No.");
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1060    ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1061    ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 1055    ;1   ;ActionGroup;
                      CaptionML=[DAN=&Pengestr›m;
                                 ENU=&Cash Flow];
                      Image=CashFlow }
      { 1056    ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 847;
                      RunPageLink=No.=FIELD(Cash Flow Forecast No.);
                      Image=EditLines }
      { 1057    ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Poster;
                                 ENU=Entries];
                      ToolTipML=[DAN="F† vist eksisterende poster for pengestr›mskontoen. ";
                                 ENU="View the entries that exist for the cash flow account. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 850;
                      RunPageView=SORTING(Cash Flow Forecast No.,Cash Flow Date);
                      RunPageLink=Cash Flow Forecast No.=FIELD(Cash Flow Forecast No.);
                      Image=Entries }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1058    ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1059    ;2   ;Action    ;
                      Name=SuggestWorksheetLines;
                      ShortCutKey=Shift+Ctrl+F;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Foresl† kladdelinjer;
                                 ENU=&Suggest Worksheet Lines];
                      ToolTipML=[DAN=Overf›r oplysninger fra omr†derne finans, indk›b, salg, service, faste anl‘gsaktiver, manuelle indt‘gter og manuelle udgifter til pengestr›mskladden. Du skal bruge k›rslen til at lave en pengestr›msprognose.;
                                 ENU=Transfer information from the areas of general ledger, purchasing, sales, service, fixed assets, manual revenues, and manual expenses to the cash flow worksheet. You use the batch job to make a cash flow forecast.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DeleteErrors;
                                 SuggestWkshLines.RUNMODAL;
                                 CLEAR(SuggestWkshLines);
                               END;
                                }
      { 1051    ;1   ;ActionGroup;
                      CaptionML=[DAN=Registrer;
                                 ENU=Register];
                      Image=Approve }
      { 1053    ;2   ;Action    ;
                      Name=Register;
                      ShortCutKey=F9;
                      CaptionML=[DAN=Registrer;
                                 ENU=Register];
                      ToolTipML=[DAN="Opdat‚r negative eller positive bel›b for ind- og udg†ende pengestr›mme for pengestr›mskontoen ved at registrere kladdelinjerne. ";
                                 ENU="Update negative or positive amounts of cash inflows and outflows for the cash flow account by registering the worksheet lines. "];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Cash Flow Wksh. - Register",Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 2       ;1   ;Action    ;
                      Name=ShowSource;
                      CaptionML=[DAN=Vi&s;
                                 ENU=&Show];
                      ToolTipML=[DAN=Vis de faktiske pengestr›msprognoseposter.;
                                 ENU=View the actual cash flow forecast entries.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowSource;
                               END;
                                }
      { 4       ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 3       ;2   ;Action    ;
                      Name=EditInExcel;
                      CaptionML=[DAN=Rediger i Excel;
                                 ENU=Edit in Excel];
                      ToolTipML=[DAN=Send dataene i kladden til en Excel-fil til analyse eller redigering.;
                                 ENU=Send the data in the journal to an Excel file for analysis or editing.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaasExcelAddinEnabled;
                      PromotedIsBig=Yes;
                      Image=Excel;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ODataUtility@1000 : Codeunit 6710;
                               BEGIN
                                 ODataUtility.EditWorksheetInExcel(CurrPage.CAPTION,CurrPage.OBJECTID(FALSE),'');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000;1   ;Group     ;
                GroupType=Repeater }

    { 1001;2   ;Field     ;
                ToolTipML=[DAN=Angiver den pengestr›msdato, posten er bogf›rt p†.;
                           ENU=Specifies the cash flow date that the entry is posted to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cash Flow Date" }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver, om posten er relateret til en forfalden betaling. ";
                           ENU="Specifies if the entry is related to an overdue payment. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Overdue }

    { 1007;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bilag, der repr‘senterer prognoseposten.;
                           ENU=Specifies the document that represents the forecast entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 1009;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nummer p† pengestr›msprognosen.;
                           ENU=Specifies a number for the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cash Flow Forecast No.";
                OnValidate=BEGIN
                             CFName := CashFlowManagement.CashFlowName("Cash Flow Forecast No.");
                           END;
                            }

    { 1011;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af kladden.;
                           ENU=Specifies a description of the worksheet.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 1017;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kildetype, der g‘lder for det kildenummer, der vises i feltet Kildenr.;
                           ENU=Specifies the source type that applies to the source number that is shown in the Source No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Type" }

    { 1015;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source No.";
                Enabled=SourceNumEnabled }

    { 1019;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† pengestr›mskontoen.;
                           ENU=Specifies the number of the cash flow account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cash Flow Account No.";
                OnValidate=BEGIN
                             CFAccName := CashFlowManagement.CashFlowAccountName("Cash Flow Account No.");
                           END;
                            }

    { 1023;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet p† kladdelinjen i RV. Indt‘gter indtastes uden et plus- eller minustegn. Udgifter indtastes med et minustegn.;
                           ENU=Specifies the amount of the worksheet line in LCY. Revenues are entered without a plus or minus sign. Expenses are entered with a minus sign.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount (LCY)" }

    { 1025;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 1027;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 1029;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                           END;
                            }

    { 1031;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                           END;
                            }

    { 1033;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                           END;
                            }

    { 1035;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                           END;
                            }

    { 1037;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                           END;
                            }

    { 1039;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                           END;
                            }

    { 1046;1   ;Group      }

    { 5   ;2   ;Part      ;
                Name=ErrorMessagesPart;
                CaptionML=[DAN=Fejl og advarsler;
                           ENU=Errors and Warnings];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page701;
                PartType=Page }

    { 1907160701;2;Group  ;
                GroupType=FixedLayout }

    { 1901969701;3;Group  ;
                CaptionML=[DAN=Pengestr›msprognosebeskrivelse;
                           ENU=Cash Flow Forecast Description];
                GroupType=Group }

    { 1047;4   ;Field     ;
                ToolTipML=[DAN=Angiver pengestr›mmens kontonavn p† pengestr›mskladden.;
                           ENU=Specifies the cash flow account name on the cash flow worksheet.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CFName;
                Editable=FALSE;
                ShowCaption=No }

    { 1900380101;3;Group  ;
                CaptionML=[DAN=Pengestr›mskontonavn;
                           ENU=Cash Flow Account Name] }

    { 1049;4   ;Field     ;
                CaptionML=[DAN=Pengestr›mskontonavn;
                           ENU=Cash Flow Account Name];
                ToolTipML=[DAN=Angiver navnet p† pengestr›msprognosen.;
                           ENU=Specifies the name of the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CFAccName;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      SuggestWkshLines@1003 : Report 840;
      CashFlowManagement@1000 : Codeunit 841;
      ShortcutDimCode@1005 : ARRAY [8] OF Code[20];
      CFName@1006 : Text[50];
      CFAccName@1007 : Text[50];
      SourceNumEnabled@1001 : Boolean;
      IsSaasExcelAddinEnabled@1002 : Boolean;

    LOCAL PROCEDURE ShowErrors@2();
    VAR
      CashFlowSetup@1002 : Record 843;
      ErrorMessage@1001 : Record 700;
      TempErrorMessage@1000 : TEMPORARY Record 700;
    BEGIN
      IF CashFlowSetup.GET THEN BEGIN
        ErrorMessage.SETRANGE("Context Record ID",CashFlowSetup.RECORDID);
        ErrorMessage.CopyToTemp(TempErrorMessage);
        CurrPage.ErrorMessagesPart.PAGE.SetRecords(TempErrorMessage);
        CurrPage.ErrorMessagesPart.PAGE.UPDATE;
      END;
    END;

    LOCAL PROCEDURE DeleteErrors@11();
    VAR
      CashFlowSetup@1002 : Record 843;
      ErrorMessage@1001 : Record 700;
    BEGIN
      IF CashFlowSetup.GET THEN BEGIN
        ErrorMessage.SETRANGE("Context Record ID",CashFlowSetup.RECORDID);
        IF ErrorMessage.FINDFIRST THEN
          ErrorMessage.DELETEALL(TRUE);
        COMMIT;
      END;
    END;

    BEGIN
    END.
  }
}

