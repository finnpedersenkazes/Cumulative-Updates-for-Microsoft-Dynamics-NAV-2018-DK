OBJECT Page 207 Resource Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressourcekladde;
               ENU=Resource Journal];
    SaveValues=Yes;
    SourceTable=Table207;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport�r,Side;
                                ENU=New,Process,Report,Page];
    OnOpenPage=VAR
                 ServerConfigSettingHandler@1001 : Codeunit 6723;
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IsSaasExcelAddinEnabled := ServerConfigSettingHandler.GetIsSaasExcelAddinEnabled;
                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::ODataV4 THEN
                   EXIT;

                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   ResJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 ResJnlManagement.TemplateSelection(PAGE::"Resource Journal",FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 ResJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                  CLEAR(ShortcutDimCode);
                END;

    OnAfterGetCurrRecord=BEGIN
                           ResJnlManagement.GetRes("Resource No.",ResName);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 61      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 62      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Jobs;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&essource;
                                 ENU=&Resource];
                      Image=Resource }
      { 42      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p�g�ldende record p� bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 76;
                      RunPageLink=No.=FIELD(Resource No.);
                      Image=EditLines }
      { 45      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf�rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 202;
                      RunPageView=SORTING(Resource No.);
                      RunPageLink=Resource No.=FIELD(Resource No.);
                      Promoted=No;
                      Image=ResourceLedger;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&osting];
                      Image=Post }
      { 47      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=F� vist en testrapport, s� du kan finde og rette eventuelle fejl, f�r du udf�rer den faktiske bogf�ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Jobs;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintResJnlLine(Rec);
                               END;
                                }
      { 48      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf�r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Res. Jnl.-Post",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 49      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden, og forbered udskrivning. V�rdierne og m�ngderne bogf�res p� de relevante konti. Du f�r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Res. Jnl.-Post+Print",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 11      ;2   ;Action    ;
                      Name=SuggestLinesFromTimeSheets;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Foresl� linjer fra timesedler;
                                 ENU=Suggest Lines from Time Sheets];
                      ToolTipML=[DAN=Udfyld kladden med linjer, der findes p� timesedlerne.;
                                 ENU=Fill the journal with lines that exist in the time sheets.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=SuggestLines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SuggestResJnlLines@1000 : Report 951;
                               BEGIN
                                 SuggestResJnlLines.SetResJnlLine(Rec);
                                 SuggestResJnlLines.RUNMODAL;
                               END;
                                }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Side;
                                 ENU=Page] }
      { 13      ;2   ;Action    ;
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
                                 ODataUtility.EditJournalWorksheetInExcel(CurrPage.CAPTION,CurrPage.OBJECTID(FALSE),"Journal Batch Name","Journal Template Name");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 39  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p� den kladdek�rsel, et personligt kladdelayout, som kladden er baseret p�.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Jobs;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             ResJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           ResJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for tildelingen.;
                           ENU=Specifies the date when you want to assign.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Date" }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en posttype for hver linje.;
                           ENU=Specifies an entry type for each line.];
                ApplicationArea=#Jobs;
                SourceExpr="Entry Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Document No." }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Jobs;
                SourceExpr="External Document No.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den ressource, som du vil bogf�re en post for.;
                           ENU=Specifies the number of the resource that you want to post an entry for.];
                ApplicationArea=#Jobs;
                SourceExpr="Resource No.";
                OnValidate=BEGIN
                             ResJnlManagement.GetRes("Resource No.",ResName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ressourcegruppe, som denne ressource er tilknyttet.;
                           ENU=Specifies the resource group that this resource is assigned to.];
                ApplicationArea=#Jobs;
                SourceExpr="Resource Group No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af eller navnet p� den ressource, du har valgt i feltet Ressourcenr.;
                           ENU=Specifies the description or name of the resource you chose in the Resource No. field.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Jobs;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Jobs;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Jobs;
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

    { 302 ;2   ;Field     ;
                ApplicationArea=#Jobs;
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

    { 304 ;2   ;Field     ;
                ApplicationArea=#Jobs;
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

    { 306 ;2   ;Field     ;
                ApplicationArea=#Jobs;
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

    { 308 ;2   ;Field     ;
                ApplicationArea=#Jobs;
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

    { 310 ;2   ;Field     ;
                ApplicationArea=#Jobs;
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

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen udlignes med. Priserne opdateres ud fra denne post.;
                           ENU=Specifies which work type the resource applies to. Prices are updated based on this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Work Type Code" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen eller ressourcen der skal angives p� linjen.;
                           ENU=Specifies the number of units of the item or resource specified on the line.];
                ApplicationArea=#Jobs;
                SourceExpr=Quantity }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit of Measure Code" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Direct Unit Cost" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede kostbel�b for kladdelinjen.;
                           ENU=Specifies the total cost for this journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Cost" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for �n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f� den angivet i henhold til feltet Avancepct.beregning p� det dertilh�rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsbel�bet p� kladdelinjen.;
                           ENU=Specifies the total price on the journal line.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Price" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �rsagskoden som et supplerende kildespor, der hj�lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� en timeseddel.;
                           ENU=Specifies the number of a time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet No.";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret for en timeseddel.;
                           ENU=Specifies the line number for a time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet Line No.";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor der er oprettet en timeseddel.;
                           ENU=Specifies the date when a time sheet is created.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet Date";
                Visible=FALSE }

    { 41  ;1   ;Group      }

    { 1903222401;2;Group  ;
                GroupType=FixedLayout }

    { 1901652401;3;Group  ;
                CaptionML=[DAN=Ressourcenavn;
                           ENU=Resource Name] }

    { 43  ;4   ;Field     ;
                ApplicationArea=#Jobs;
                SourceExpr=ResName;
                Editable=FALSE;
                ShowCaption=No }

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
      ResJnlManagement@1000 : Codeunit 270;
      ReportPrint@1001 : Codeunit 228;
      ClientTypeManagement@1006 : Codeunit 4;
      CurrentJnlBatchName@1002 : Code[10];
      ResName@1003 : Text[50];
      ShortcutDimCode@1004 : ARRAY [8] OF Code[20];
      IsSaasExcelAddinEnabled@1005 : Boolean;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      ResJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

