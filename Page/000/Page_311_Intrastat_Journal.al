OBJECT Page 311 Intrastat Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Intrastatkladde;
               ENU=Intrastat Journal];
    SaveValues=Yes;
    SourceTable=Table263;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Proces,Rapport,Bank,Udligning,L�nningsliste,Godkend,Side;
                                ENU=New,Process,Report,Bank,Application,Payroll,Approve,Page];
    OnInit=BEGIN
             StatisticalValueVisible := TRUE;
           END;

    OnOpenPage=VAR
                 ServerConfigSettingHandler@1001 : Codeunit 6723;
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   IntraJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 IntraJnlManagement.TemplateSelection(PAGE::"Intrastat Journal",Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 IntraJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);

                 LineStyleExpression := 'Standard';
               END;

    OnAfterGetRecord=BEGIN
                       UpdateErrors;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateStatisticalValue;
                           UpdateErrors;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 48      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vare;
                                 ENU=Item];
                      ToolTipML=[DAN=Vis og rediger detaljerede oplysninger om varen.;
                                 ENU=View and edit detailed information for the item.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 30;
                      RunPageLink=No.=FIELD(Item No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Item;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 53      ;1   ;Action    ;
                      Name=GetEntries;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Foresl� linjer;
                                 ENU=Suggest Lines];
                      ToolTipML=[DAN=Foresl�r Intrastattransaktioner, der skal rapporteres, og udfylder Intrastatkladden.;
                                 ENU=Suggests Intrastat transactions to be reported and fills in Intrastat journal.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SuggestLines;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 VATReportsConfiguration@1000 : Record 746;
                               BEGIN
                                 VATReportsConfiguration.SETRANGE("VAT Report Type",VATReportsConfiguration."VAT Report Type"::"Intrastat Report");
                                 IF VATReportsConfiguration.FINDFIRST AND (VATReportsConfiguration."Suggest Lines Codeunit ID" <> 0) THEN BEGIN
                                   CODEUNIT.RUN(VATReportsConfiguration."Suggest Lines Codeunit ID",Rec);
                                   EXIT;
                                 END;

                                 GetItemEntries.SetIntrastatJnlLine(Rec);
                                 GetItemEntries.RUNMODAL;
                                 CLEAR(GetItemEntries);
                               END;
                                }
      { 50      ;1   ;Action    ;
                      Name=ChecklistReport;
                      CaptionML=[DAN=Kontrolliste;
                                 ENU=Checklist Report];
                      ToolTipML=[DAN=Valider Intrastatkladdelinjerne.;
                                 ENU=Validate the Intrastat journal lines.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PrintChecklistReport;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 VATReportsConfiguration@1000 : Record 746;
                               BEGIN
                                 VATReportsConfiguration.SETRANGE("VAT Report Type",VATReportsConfiguration."VAT Report Type"::"Intrastat Report");
                                 IF VATReportsConfiguration.FINDFIRST AND (VATReportsConfiguration."Validate Codeunit ID" <> 0) THEN BEGIN
                                   CODEUNIT.RUN(VATReportsConfiguration."Validate Codeunit ID",Rec);
                                   EXIT;
                                 END;

                                 ReportPrint.PrintIntrastatJnlLine(Rec);
                               END;
                                }
      { 67      ;1   ;Action    ;
                      Name=Toggle Error Filter;
                      CaptionML=[DAN=Filtrer fejllinjer;
                                 ENU=Filter Error Lines];
                      ToolTipML=[DAN=Vis eller skjul Intrastatkladdelinjer, som ikke har fejl.;
                                 ENU=Show or hide Intrastat journal lines that do not have errors.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Filter;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 MARKEDONLY(NOT MARKEDONLY);
                               END;
                                }
      { 52      ;1   ;Action    ;
                      Name=CreateFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret fil;
                                 ENU=Create File];
                      ToolTipML=[DAN=Opret Intrastatrapporteringsfilen.;
                                 ENU=Create the Intrastat reporting file.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=MakeDiskette;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 VATReportsConfiguration@1000 : Record 746;
                               BEGIN
                                 VATReportsConfiguration.SETRANGE("VAT Report Type",VATReportsConfiguration."VAT Report Type"::"Intrastat Report");
                                 IF VATReportsConfiguration.FINDFIRST AND (VATReportsConfiguration."Validate Codeunit ID" <> 0) AND
                                    (VATReportsConfiguration."Content Codeunit ID" <> 0)
                                 THEN BEGIN
                                   CODEUNIT.RUN(VATReportsConfiguration."Validate Codeunit ID",Rec);
                                   IF ErrorsExistOnCurrentBatch(TRUE) THEN
                                     ERROR('');
                                   COMMIT;

                                   CODEUNIT.RUN(VATReportsConfiguration."Content Codeunit ID",Rec);
                                   EXIT;
                                 END;

                                 ReportPrint.PrintIntrastatJnlLine(Rec);
                                 IF ErrorsExistOnCurrentBatch(TRUE) THEN
                                   ERROR('');
                                 COMMIT;

                                 IntrastatJnlLine.COPYFILTERS(Rec);
                                 IntrastatJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
                                 IntrastatJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
                                 REPORT.RUN(REPORT::"Intrastat - Make Disk Tax Auth",TRUE,FALSE,IntrastatJnlLine);
                               END;
                                }
      { 51      ;1   ;Action    ;
                      Name=Form;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udskriver Intrastatkladde;
                                 ENU=Prints Intrastat Journal];
                      ToolTipML=[DAN=Udskriv den p�g�ldende formular - bruges til at udskrive Intrastatkladden.;
                                 ENU=Print that Form - this is used to print Intrastat journal.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PrintForm;
                      PromotedCategory=Report;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 IntrastatJnlLine.COPYFILTERS(Rec);
                                 IntrastatJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
                                 IntrastatJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
                                 REPORT.RUN(REPORT::"Intrastat - Form",TRUE,FALSE,IntrastatJnlLine);
                               END;
                                }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 5       ;2   ;Action    ;
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
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ODataUtility@1000 : Codeunit 6710;
                               BEGIN
                                 ODataUtility.EditJournalWorksheetInExcel(CurrPage.CAPTION,CurrPage.OBJECTID(FALSE),"Journal Batch Name","Journal Template Name");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 55  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p� den kladdek�rsel, et personligt kladdelayout, som kladden er baseret p�.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             IntraJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           EXIT(IntraJnlManagement.LookupName(GETRANGEMAX("Journal Template Name"),CurrentJnlBatchName,Text));
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om virksomheden har afsendt eller modtaget varen.;
                           ENU=Specifies whether the item was received or shipped by the company.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type;
                StyleExpr=LineStyleExpression }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor vareposten blev bogf�rt.;
                           ENU=Specifies the date the item entry was posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Date;
                StyleExpr=LineStyleExpression }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p� posten.;
                           ENU=Specifies the document number on the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                StyleExpr=LineStyleExpression }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� varen.;
                           ENU=Specifies the number of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No.";
                StyleExpr=LineStyleExpression }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varen.;
                           ENU=Specifies the name of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                StyleExpr=LineStyleExpression }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens tarifnummer.;
                           ENU=Specifies the item's tariff number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Tariff No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Description" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr�de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr�senterer med henblik p� rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Type" }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik p� rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Specification";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm�den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transport Method" }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det indf�rselssted, hvor varerne er kommet ind i landet/omr�det, eller for udf�rselsstedet.;
                           ENU=Specifies the code of either the port of entry where the items passed into your country/region or the port of exit.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry/Exit Point";
                Visible=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr�de med henblik p� rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Area;
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvis Told�Skat kr�ver oplysninger om varens antal og enhed.;
                           ENU=Specifies if you must report information about quantity and units of measure for this item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Supplementary Units" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder i posten.;
                           ENU=Specifies the number of units of the item in the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Quantity }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nettov�gten for en enhed af varen.;
                           ENU=Specifies the net weight of one unit of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Net Weight" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede v�gt af varerne i vareposten.;
                           ENU=Specifies the total weight for the items in the item entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Total Weight" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede bel�b for posten, ekskl. moms.;
                           ENU=Specifies the total amount of the entry, excluding VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens statistiske v�rdi, som skal indberettes til Danmarks Statistik.;
                           ENU=Specifies the entry's statistical value, which must be reported to the statistics authorities.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Statistical Value" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver posttypen.;
                           ENU=Specifies the entry type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Type" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som vareposten havde i den tabel, den stammer fra.;
                           ENU=Specifies the number that the item entry had in the table it came from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Entry No." }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver eventuelle indirekte omkostninger som en procentdel.;
                           ENU=Specifies any indirect costs, as a percentage.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost Regulation %";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bel�b, der repr�senterer omkostningerne ved fragt og forsikring.;
                           ENU=Specifies an amount that represents the costs for freight and insurance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Indirect Cost";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et referencenummer, som SKAT benytter.;
                           ENU=Specifies a reference number used by the customs and tax authorities.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Internal Ref. No." }

    { 40  ;1   ;Group      }

    { 41  ;2   ;Field     ;
                Name=StatisticalValue;
                CaptionML=[DAN=Statistisk v�rdi;
                           ENU=Statistical Value];
                ToolTipML=[DAN=Angiver den statistiske v�rdi, der er akkumuleret i Intrastat-kladden.;
                           ENU=Specifies the statistical value that has accumulated in the Intrastat journal.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=StatisticalValue + "Statistical Value" - xRec."Statistical Value";
                AutoFormatType=1;
                Visible=StatisticalValueVisible;
                Editable=FALSE }

    { 43  ;2   ;Field     ;
                CaptionML=[DAN=Total statistisk v�rdi;
                           ENU=Total Stat. Value];
                ToolTipML=[DAN=Angiver den samlede statistiske v�rdi i Intrastat-kladden.;
                           ENU=Specifies the total statistical value in the Intrastat journal.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalStatisticalValue + "Statistical Value" - xRec."Statistical Value";
                AutoFormatType=1;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 3   ;1   ;Part      ;
                Name=ErrorMessagesPart;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page701;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      IntrastatJnlLine@1000 : Record 263;
      GetItemEntries@1001 : Report 594;
      ReportPrint@1002 : Codeunit 228;
      IntraJnlManagement@1003 : Codeunit 350;
      ClientTypeManagement@1077 : Codeunit 4;
      LineStyleExpression@1009 : Text;
      StatisticalValue@1004 : Decimal;
      TotalStatisticalValue@1005 : Decimal;
      CurrentJnlBatchName@1006 : Code[10];
      ShowStatisticalValue@1007 : Boolean;
      ShowTotalStatisticalValue@1008 : Boolean;
      StatisticalValueVisible@1069 : Boolean INDATASET;
      IsSaasExcelAddinEnabled@1010 : Boolean;

    LOCAL PROCEDURE UpdateStatisticalValue@1();
    BEGIN
      IntraJnlManagement.CalcStatisticalValue(
        Rec,xRec,StatisticalValue,TotalStatisticalValue,
        ShowStatisticalValue,ShowTotalStatisticalValue);
      StatisticalValueVisible := ShowStatisticalValue;
      StatisticalValueVisible := ShowTotalStatisticalValue;
    END;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@6212();
    BEGIN
      CurrPage.SAVERECORD;
      IntraJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ErrorsExistOnCurrentBatch@2(ShowError@1002 : Boolean) : Boolean;
    VAR
      ErrorMessage@1000 : Record 700;
      IntrastatJnlBatch@1001 : Record 262;
    BEGIN
      IntrastatJnlBatch.GET("Journal Template Name","Journal Batch Name");
      ErrorMessage.SetContext(IntrastatJnlBatch);
      EXIT(ErrorMessage.HasErrors(ShowError));
    END;

    LOCAL PROCEDURE ErrorsExistOnCurrentLine@8() : Boolean;
    VAR
      ErrorMessage@1000 : Record 700;
      IntrastatJnlBatch@1001 : Record 262;
    BEGIN
      IntrastatJnlBatch.GET("Journal Template Name","Journal Batch Name");
      ErrorMessage.SetContext(IntrastatJnlBatch);
      EXIT(ErrorMessage.HasErrorMessagesRelatedTo(Rec));
    END;

    LOCAL PROCEDURE UpdateErrors@5();
    BEGIN
      CurrPage.ErrorMessagesPart.PAGE.SetRecordID(RECORDID);
      CurrPage.ErrorMessagesPart.PAGE.GetStyleOfRecord(Rec,LineStyleExpression);
      MARK(ErrorsExistOnCurrentLine);
    END;

    BEGIN
    END.
  }
}

