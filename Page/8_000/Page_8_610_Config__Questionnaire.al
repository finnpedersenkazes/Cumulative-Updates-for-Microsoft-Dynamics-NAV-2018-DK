OBJECT Page 8610 Config. Questionnaire
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfig.sp›rgeskema;
               ENU=Config. Questionnaire];
    SourceTable=Table8610;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Excel;
                                ENU=New,Process,Report,Excel];
    OnOpenPage=BEGIN
                 CanRunDotNet := FileMgt.CanRunDotNetOnClient;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Sp›rgeskema;
                                 ENU=&Questionnaire];
                      Image=Questionaire }
      { 11      ;2   ;Action    ;
                      Name=ExportToExcel;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udl‘s til Excel;
                                 ENU=E&xport to Excel];
                      ToolTipML=[DAN=Eksport‚r data i sp›rgeskemaet til Excel.;
                                 ENU=Export data in the questionnaire to Excel.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=CanRunDotNet;
                      Image=ExportToExcel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 TESTFIELD(Code);

                                 FileName := FileMgt.SaveFileDialog(Text002,FileName,'');
                                 IF FileName = '' THEN
                                   EXIT;

                                 IF QuestionnaireMgt.ExportQuestionnaireToExcel(FileName,Rec) THEN
                                   MESSAGE(Text000);
                               END;
                                }
      { 10      ;2   ;Action    ;
                      Name=ImportFromExcel;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Indl‘s fra Excel;
                                 ENU=&Import from Excel];
                      ToolTipML=[DAN=Importer oplysninger fra Excel til sp›rgeskemaet.;
                                 ENU=Import information from Excel into the questionnaire.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=CanRunDotNet;
                      Image=ImportExcel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 FileName := FileMgt.OpenFileDialog(Text002,FileName,'');
                                 IF FileName = '' THEN
                                   EXIT;

                                 IF QuestionnaireMgt.ImportQuestionnaireFromExcel(FileName) THEN
                                   MESSAGE(Text001);
                               END;
                                }
      { 9       ;2   ;Separator  }
      { 8       ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udl‘s til XML;
                                 ENU=&Export to XML];
                      ToolTipML=[DAN=Eksport‚r oplysningerne i sp›rgeskemaet til Excel.;
                                 ENU=Export information in the questionnaire to Excel.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Export;
                      OnAction=BEGIN
                                 IF QuestionnaireMgt.ExportQuestionnaireAsXML(FileName,Rec) THEN
                                   MESSAGE(Text000)
                                 ELSE
                                   MESSAGE(Text003);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Indl‘s fra XML;
                                 ENU=&Import from XML];
                      ToolTipML=[DAN=Importer oplysninger fra XML til sp›rgeskemaet.;
                                 ENU=Import information from XML into the questionnaire.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Import;
                      OnAction=BEGIN
                                 IF QuestionnaireMgt.ImportQuestionnaireAsXMLFromClient THEN
                                   MESSAGE(Text001);
                               END;
                                }
      { 6       ;2   ;Separator  }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=&Opdater sp›rgeskema;
                                 ENU=&Update Questionnaire];
                      ToolTipML=[DAN=Udfyld sp›rgsm†lslisten baseret p† felterne i tabellen, som sp›rgsm†lsomr†det er baseret p†.;
                                 ENU=Fill the question list based on the fields in the table on which the question area is based.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Refresh;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF QuestionnaireMgt.UpdateQuestionnaire(Rec) THEN
                                   MESSAGE(Text004);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=&Anvend svar;
                                 ENU=&Apply Answers];
                      ToolTipML=[DAN=Implementer svar i sp›rgeskemaet i de relaterede konfigurationsfelter.;
                                 ENU=Implement answers in the questionnaire in the related setup fields.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Apply;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF QuestionnaireMgt.ApplyAnswers(Rec) THEN
                                   MESSAGE(Text005);
                               END;
                                }
      { 15      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Omr†der;
                                 ENU=Areas] }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=&Sp›rgsm†lsomr†der;
                                 ENU=&Question Areas];
                      ToolTipML=[DAN=Vis de omr†der, som sp›rgsm†lene grupperes efter.;
                                 ENU=View the areas that questions are grouped by.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 8613;
                      RunPageLink=Questionnaire Code=FIELD(Code);
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for konfigurationssp›rgeskemaet, som du er ved at oprette.;
                           ENU=Specifies a code for the configuration questionnaire that you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af konfigurationssp›rgeskemaet. Du kan angive et navn eller en beskrivelse p† op til 50 tegn (inklusive tal og mellemrum).;
                           ENU=Specifies the description of the configuration questionnaire. You can provide a name or description of up to 50 characters, numbers, and spaces.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

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
      Text000@1001 : TextConst 'DAN=Sp›rgeskemaet er udl‘st.;ENU=The questionnaire has been successfully exported.';
      Text001@1000 : TextConst 'DAN=Sp›rgeskemaet er indl‘st.;ENU=The questionnaire has been successfully imported.';
      Text002@1002 : TextConst 'DAN=Gem som Excel-projektmappe.;ENU=Save as Excel workbook';
      Text003@1003 : TextConst 'DAN=Udl‘sning af sp›rgeskemaet er annulleret.;ENU=The export of the questionnaire has been canceled.';
      QuestionnaireMgt@1004 : Codeunit 8610;
      FileMgt@1009 : Codeunit 419;
      FileName@1005 : Text;
      Text004@1006 : TextConst 'DAN=Sp›rgeskemaet er opdateret.;ENU=The questionnaire has been updated.';
      Text005@1010 : TextConst 'DAN=Svarene er blevet anvendt.;ENU=Answers have been applied.';
      CanRunDotNet@1007 : Boolean;

    BEGIN
    END.
  }
}

