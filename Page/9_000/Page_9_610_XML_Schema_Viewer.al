OBJECT Page 9610 XML Schema Viewer
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=XML-skemafremviser;
               ENU=XML Schema Viewer];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table9610;
    SourceTableView=SORTING(XML Schema Code,Sort Key);
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Visning,Valg,Naviger;
                                ENU=New,Process,Report,View,Selection,Navigate];
    OnOpenPage=BEGIN
                 IF XMLSchemaCodeInternal <> '' THEN
                   XMLSchemaCode := XMLSchemaCodeInternal;
                 XMLSchema.Code := XMLSchemaCode;
                 IF XMLSchema.FIND('=<>') THEN;
                 XMLSchemaCode := XMLSchema.Code;
                 SETRANGE("XML Schema Code",XMLSchema.Code);
                 SetInternalVariables;
               END;

    OnAfterGetRecord=BEGIN
                       SetStyleExpression;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           NewObjectNo := NewObjectNoInternal;
                           SetStyleExpression;
                         END;

    ActionList=ACTIONS
    {
      { 12      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 16      ;1   ;Action    ;
                      Name=GenerateXMLPort;
                      CaptionML=[DAN=Gener‚r XMLport;
                                 ENU=Generate XMLport];
                      ToolTipML=[DAN=Opret XMLport-objektet til import i Object Designer.;
                                 ENU=Create the XMLport object for import into the Object Designer.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Export;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 XSDParser@1000 : Codeunit 9610;
                               BEGIN
                                 IF NewObjectNo = 0 THEN
                                   ERROR(NoObjectIDErr);

                                 XSDParser.CreateXMLPortFile(Rec,NewObjectNo,"XML Schema Code",TRUE,FALSE);
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Name=GenerateDataExchSetup;
                      CaptionML=[DAN=Gener‚r dataudvekslingsdefinition;
                                 ENU=Generate Data Exchange Definition];
                      ToolTipML=[DAN=Initialiser en dataudvekslingsdefinition, der er baseret p† de valgte dataelementer, som du derefter udf›rer inden for rammerne til udveksling af data.;
                                 ENU=Initialize a data exchange definition based on the selected data elements, which you then complete in the Data Exchange Framework.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Export;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 XSDParser@1000 : Codeunit 9610;
                               BEGIN
                                 XSDParser.CreateDataExchDefForCAMT(Rec);
                               END;
                                }
      { 19      ;1   ;Action    ;
                      Name=ShowAll;
                      CaptionML=[DAN=Vis alle;
                                 ENU=Show All];
                      ToolTipML=[DAN=Vis alle elementer.;
                                 ENU=Show all elements.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=AllLines;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 XSDParser@1000 : Codeunit 9610;
                               BEGIN
                                 XSDParser.ShowAll(Rec);
                               END;
                                }
      { 20      ;1   ;Action    ;
                      Name=HideNonMandatory;
                      CaptionML=[DAN=Skjul ikke-obligatoriske;
                                 ENU=Hide Nonmandatory];
                      ToolTipML=[DAN=Vis ikke elementer, der er markeret som ikke-obligatoriske.;
                                 ENU=Do not show the elements that are marked as non-mandatory.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ShowSelected;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 XSDParser@1000 : Codeunit 9610;
                               BEGIN
                                 XSDParser.HideNotMandatory(Rec);
                               END;
                                }
      { 22      ;1   ;Action    ;
                      Name=HideNonSelected;
                      CaptionML=[DAN=Skjul ikke-valgte;
                                 ENU=Hide Nonselected];
                      ToolTipML=[DAN=Vis ikke elementer, der er markeret som ikke-valgte.;
                                 ENU=Do not show the elements that are marked as non-selected.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ShowSelected;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 XSDParser@1000 : Codeunit 9610;
                               BEGIN
                                 XSDParser.HideNotSelected(Rec);
                               END;
                                }
      { 9       ;1   ;Action    ;
                      Name=SelectAll;
                      CaptionML=[DAN=V‘lg alle obligatoriske elementer;
                                 ENU=Select All Mandatory Elements];
                      ToolTipML=[DAN=Mark‚r alle elementer, der er obligatoriske.;
                                 ENU=Mark all elements that are mandatory.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=SelectEntries;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 XSDParser@1001 : Codeunit 9610;
                               BEGIN
                                 XSDParser.SelectMandatory(Rec);
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=DeselectAll;
                      CaptionML=[DAN=Annuller valgene;
                                 ENU=Cancel the Selections];
                      ToolTipML=[DAN=Afmarker alle elementer.;
                                 ENU=Deselect all elements.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=SelectEntries;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 XSDParser@1000 : Codeunit 9610;
                               BEGIN
                                 IF CONFIRM(DeselectQst) THEN
                                   XSDParser.DeselectAll(Rec);
                               END;
                                }
      { 24      ;1   ;Action    ;
                      Name=DataExchangeDefinitions;
                      CaptionML=[DAN=Dataudvekslingsdefinitioner;
                                 ENU=Data Exchange Definitions];
                      ToolTipML=[DAN=Vis eller rediger dataudvekslingsdefinitioner, der findes i databasen, for at aktivere import/eksport af data til eller fra bestemte datafiler.;
                                 ENU=View or edit the data exchange definitions that exist in the database to enable import/export of data to or from specific data files.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1211;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=XMLFile;
                      PromotedCategory=Category6 }
    }
  }
  CONTROLS
  {
    { 11  ;0   ;Container ;
                ContainerType=ContentArea }

    { 10  ;1   ;Group     ;
                GroupType=Group }

    { 23  ;2   ;Field     ;
                CaptionML=[DAN=Kode til XML-skema;
                           ENU=XML Schema Code];
                ToolTipML=[DAN=Angiver den XML-skemafil, hvis skemaindhold vises p† linjerne i vinduet XML-skemafremviser.;
                           ENU=Specifies the XML schema file whose schema content is displayed on the lines in the XML Schema Viewer window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=XMLSchemaCode;
                TableRelation="XML Schema".Code WHERE (Indentation=CONST(0));
                OnValidate=BEGIN
                             IF XMLSchemaCode = '' THEN
                               CLEAR(XMLSchema)
                             ELSE
                               XMLSchema.GET(XMLSchemaCode);
                             SETRANGE("XML Schema Code",XMLSchemaCode);
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 25  ;2   ;Group     ;
                GroupType=Group }

    { 18  ;3   ;Field     ;
                CaptionML=[DAN=Nyt XMLportnummer;
                           ENU=New XMLport No.];
                ToolTipML=[DAN=Angiver nummeret p† den XMLport, der er oprettet fra dette XML-skema, n†r du v‘lger handlingen Gener‚r XMLport i vinduet XML-skemafremviser.;
                           ENU=Specifies the number of the XMLport that is created from this XML schema when you choose the Generate XMLport action in the XML Schema Viewer window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NewObjectNo;
                OnValidate=BEGIN
                             SetInternalVariables;
                           END;
                            }

    { 8   ;1   ;Group     ;
                Name=Group;
                IndentationColumnName=Indentation;
                IndentationControls=Node Name;
                ShowAsTree=Yes;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nodens navn p† den importerede fil.;
                           ENU=Specifies the name of the node on the imported file.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Node Name";
                Editable=FALSE;
                StyleExpr=StyleExpression }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om noden er medtaget i den relaterede XMLport.;
                           ENU=Specifies if the node is included in the related XMLport.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Selected;
                OnValidate=BEGIN
                             SetStyleExpression;
                           END;
                            }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om noden har to eller flere sidestillede noder, der fungerer som valgmuligheder.;
                           ENU=Specifies if the node has two or more sibling nodes that function as options.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Choice;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Specificerer en type. Feltet er kun beregnet til internt brug.;
                           ENU=Specifies a type. This field is intended only for internal use.];
                ApplicationArea=#Advanced;
                SourceExpr="Node Type";
                Visible=FALSE;
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af dataene og giver yderligere forklaring af koderne i nodenavnet.;
                           ENU=Specifies the type of the data and provides additional explanation of the tags in the Node Name.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Data Type";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det laveste antal gange, som noden vises i XML-skemaet. Hvis v‘rdien i dette felt er 1 eller h›jere, anses noden for at v‘re obligatorisk til at oprette en gyldig XMLport.;
                           ENU=Specifies the lowest number of times that the node appears in the XML schema. If the value in this field is 1 or higher, then the node is considered mandatory to create a valid XMLport.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MinOccurs;
                Editable=FALSE }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det h›jeste antal gange, som noden vises i XML-skemaet.;
                           ENU=Specifies the highest number of times that the node appears in the XML schema.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MaxOccurs;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver basistypen for skemaelementet (ustruktureret) som f.eks. decimal- og datostrenge.;
                           ENU=Specifies the base (unstructured) type of the schema element, such as the Decimal and Date strings.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Simple Data Type" }

    { 14  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 15  ;1   ;Part      ;
                CaptionML=[DAN=Tilladte v‘rdier;
                           ENU=Allowed Values];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=XML Schema Code=FIELD(XML Schema Code),
                            Element ID=FIELD(ID);
                PagePartID=Page9611;
                PartType=Page }

  }
  CODE
  {
    VAR
      XMLSchema@1003 : Record 9600;
      XMLSchemaCode@1004 : Code[20];
      XMLSchemaCodeInternal@1010 : Code[20];
      NewObjectNo@1001 : Integer;
      NoObjectIDErr@1000 : TextConst 'DAN=Du skal angive et objektnummer.;ENU=You must provide an object number.';
      NewObjectNoInternal@1008 : Integer;
      DeselectQst@1007 : TextConst 'DAN=Vil du afmarkere alle elementer?;ENU=Do you want to deselect all elements?';
      StyleExpression@1006 : Text;

    [External]
    PROCEDURE SetXMLSchemaCode@1(NewXMLSchemaCode@1000 : Code[20]);
    BEGIN
      XMLSchemaCodeInternal := NewXMLSchemaCode;
    END;

    LOCAL PROCEDURE SetInternalVariables@9();
    BEGIN
      NewObjectNoInternal := NewObjectNo;
    END;

    LOCAL PROCEDURE SetStyleExpression@2();
    VAR
      ChildXMLSchemaElement@1000 : Record 9610;
    BEGIN
      StyleExpression := '';
      IF ("Defintion XML Schema Code" <> '') OR ("Definition XML Schema ID" <> 0) THEN BEGIN
        StyleExpression := 'Subordinate';
        EXIT;
      END;

      ChildXMLSchemaElement.SETRANGE("XML Schema Code","XML Schema Code");
      ChildXMLSchemaElement.SETRANGE("Parent ID",ID);
      IF NOT ChildXMLSchemaElement.ISEMPTY THEN
        StyleExpression := 'Strong';
    END;

    BEGIN
    END.
  }
}

