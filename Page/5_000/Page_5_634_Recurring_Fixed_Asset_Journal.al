OBJECT Page 5634 Recurring Fixed Asset Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl‘gsgentagelseskladde;
               ENU=Recurring Fixed Asset Journal];
    SaveValues=Yes;
    SourceTable=Table5621;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   FAJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 FAJnlManagement.TemplateSelection(PAGE::"Recurring Fixed Asset Journal",TRUE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 FAJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                  CLEAR(ShortcutDimCode);
                END;

    OnAfterGetCurrRecord=BEGIN
                           FAJnlManagement.GetFA("FA No.",FADescription);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 62      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 63      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 44      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Anl‘g;
                                 ENU=Fixed &Asset];
                      Image=FixedAssets }
      { 46      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5600;
                      RunPageLink=No.=FIELD(FA No.);
                      Image=EditLines }
      { 47      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Codeunit 5634;
                      Promoted=No;
                      Image=FixedAssetLedger;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 49      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#FixedAssets;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintFAJnlLine(Rec);
                               END;
                                }
      { 50      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#FixedAssets;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"FA. Jnl.-Post",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 4       ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#FixedAssets;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 FAJnlPost@1000 : Codeunit 5636;
                               BEGIN
                                 FAJnlPost.Preview(Rec);
                               END;
                                }
      { 51      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden, og forbered udskrivning. V‘rdierne og m‘ngderne bogf›res p† de relevante konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#FixedAssets;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"FA. Jnl.-Post+Print",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 42  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som kladden er baseret p†.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#FixedAssets;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             FAJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           FAJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et gentagelsesprincip, hvis du har angivet, at kladden gentages.;
                           ENU=Specifies a recurring method, if you have indicated that the journal is recurring.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Recurring Method" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et gentagelsesinterval, hvis du har angivet, at kladden skal gentages.;
                           ENU=Specifies a recurring frequency if you indicated that the journal is a recurring.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Recurring Frequency" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for den relaterede anl‘gstransaktion, f.eks. en afskrivning.;
                           ENU=Specifies the posting date of the related fixed asset transaction, such as a depreciation.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Posting Date" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samme dato som i feltet Bogf›ringsdato for anl‘g, n†r linjen bogf›res.;
                           ENU=Specifies the same date as the FA Posting Date field when the line is posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante dokumenttype til det bel›b, du vil bogf›re.;
                           ENU=Specifies the appropriate document type for the amount you want to post.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Document Type" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Document No." }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver nummeret for det relaterede anl‘g. ";
                           ENU="Specifies the number of the related fixed asset. "];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA No.";
                OnValidate=BEGIN
                             FAJnlManagement.GetFA("FA No.",FADescription);
                           END;
                            }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf›res til, hvis du har valgt Anl‘gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Book Code" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringstypen, hvis feltet Kontotype indeholder Anl‘gsaktiv.;
                           ENU=Specifies the posting type, if Account Type field contains Fixed Asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Posting Type" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en beskrivelse af anl‘gsaktivet. ";
                           ENU="Specifies a description of the fixed asset. "];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede bel›b for kladdelinjen.;
                           ENU=Specifies the total amount the journal line consists of.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Amount }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsv‘rdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 302 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsv‘rdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 304 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsv‘rdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 306 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsv‘rdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 308 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsv‘rdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 310 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsv‘rdikode, der er knyttet til kladdelinjen.;
                           ENU=Specifies the dimension value code linked to the journal line.];
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

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om afskrivningen er beregnet op til linjens anl‘gsbogf›ringsdato.;
                           ENU=Specifies if depreciation was calculated until the FA posting date of the line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depr. until FA Posting Date";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en reparationskode.;
                           ENU=Specifies a maintenance code.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Maintenance Code";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en forsikringskode, hvis du har valgt indstillingen Anskaffelse i feltet Anl‘gsbogf›ringstype.;
                           ENU=Specifies an insurance code if you have selected the Acquisition Cost option in the FA Posting Type field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Insurance No.";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angivet nummeret for et anl‘gsaktiv, hvor afkrydsningsfeltet Budgetanl‘g er markeret. N†r du bogf›rer kladde- eller bilagslinje, oprettes en ekstra post for det budgetterede anl‘gsaktiv, hvor bel›bet har det modsatte fortegn.;
                           ENU=Specifies the number of a fixed asset with the Budgeted Asset check box selected. When you post the journal or document line, an additional entry is created for the budgeted fixed asset where the amount has the opposite sign.];
                ApplicationArea=#Suite;
                SourceExpr="Budgeted FA No.";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en afskrivningsprofilkode, hvis kladdelinjen b†de skal bogf›res til den p†g‘ldende afskrivningsprofil og til afskrivningsprofilen i feltet Afskrivningsprofilkode.;
                           ENU=Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Duplicate in Depreciation Book";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver om linjen skal bogf›res til alle de afskrivningsprofiler, der bruger forskellige kladdenavne, og hvor feltet Del af kopiliste er markeret.;
                           ENU=Specifies whether the line is to be posted to all depreciation books, using different journal batches and with a check mark in the Part of Duplication List field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Use Duplication List";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er genereret fra en anl‘gsomposteringskladde.;
                           ENU=Specifies if the entry was generated from a fixed asset reclassification journal.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Reclassification Entry";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil bogf›re en indeksering.;
                           ENU=Specifies whether to post an indexation.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Index Entry";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† en bogf›rt anl‘gspost, der skal markeres som post med en fejl.;
                           ENU=Specifies the number of a posted FA ledger entry to mark as an error entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Error Entry No.";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dato, hvor gentagelseskladden vil blive bogf›rt.;
                           ENU=Specifies the last date on which the recurring journal will be posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Expiration Date" }

    { 2   ;1   ;Group      }

    { 1900116601;2;Group  ;
                GroupType=FixedLayout }

    { 1901313201;3;Group  ;
                CaptionML=[DAN=Anl‘gsbeskrivelse;
                           ENU=FA Description] }

    { 40  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af anl‘gget.;
                           ENU=Specifies a description of the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADescription;
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
      FAJnlManagement@1000 : Codeunit 5638;
      ReportPrint@1001 : Codeunit 228;
      CurrentJnlBatchName@1002 : Code[10];
      FADescription@1003 : Text[30];
      ShortcutDimCode@1004 : ARRAY [8] OF Code[20];

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      FAJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

