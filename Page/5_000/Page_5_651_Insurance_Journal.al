OBJECT Page 5651 Insurance Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Forsikringskladde;
               ENU=Insurance Journal];
    SaveValues=Yes;
    SourceTable=Table5635;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 InsuranceJnlManagement@1000 : Codeunit 5656;
                 JnlSelected@1001 : Boolean;
               BEGIN
                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   InsuranceJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 InsuranceJnlManagement.TemplateSelection(PAGE::"Insurance Journal",Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 InsuranceJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                  CLEAR(ShortcutDimCode);
                END;

    OnAfterGetCurrRecord=BEGIN
                           InsuranceJnlManagement.GetDescriptions(Rec,InsuranceDescription,FADescription);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 40      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 41      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&orsikring;
                                 ENU=Ins&urance];
                      Image=Insurance }
      { 31      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p�g�ldende record p� bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5644;
                      RunPageLink=No.=FIELD(Insurance No.);
                      Image=EditLines }
      { 32      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Coverage Ledger E&ntries];
                      ToolTipML=[DAN=Vis de forsikringsposter, der bliver dannet, n�r du posterer til en forsikringskonto fra en k�bsfaktura, en kreditnota eller en kladdelinje.;
                                 ENU=View insurance ledger entries that were created when you post to an insurance account from a purchase invoice, credit memo or journal line.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5647;
                      RunPageView=SORTING(Insurance No.,Disposed FA,Posting Date);
                      RunPageLink=Insurance No.=FIELD(Insurance No.);
                      Image=GeneralLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&osting];
                      Image=Post }
      { 34      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s� du kan finde og rette eventuelle fejl, f�r du udf�rer den faktiske bogf�ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#FixedAssets;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintInsuranceJnlLine(Rec);
                               END;
                                }
      { 35      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf�r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#FixedAssets;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Insurance Jnl.-Post",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 39      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden, og forbered udskrivning. V�rdierne og m�ngderne bogf�res p� de relevante konti. Du f�r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#FixedAssets;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Insurance Jnl.-Post+Print",Rec);
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

    { 37  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p� den kladdek�rsel, et personligt kladdelayout, som kladden er baseret p�.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#FixedAssets;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             InsuranceJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           InsuranceJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, du vil bruge som bogf�ringsdato p� forsikringsposten.;
                           ENU=Specifies the date to use as the posting date on the insurance coverage ledger entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Posting Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante dokumenttype til det bel�b, du vil bogf�re.;
                           ENU=Specifies the appropriate document type for the amount you want to post.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Document Type" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Document No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forsikringsnummer, der bruges til at bogf�re forsikringsposten.;
                           ENU=Specifies the insurance number to post an insurance coverage entry to.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Insurance No.";
                OnValidate=BEGIN
                             InsuranceJnlManagement.GetDescriptions(Rec,InsuranceDescription,FADescription);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver nummeret for det relaterede anl�g. ";
                           ENU="Specifies the number of the related fixed asset. "];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA No.";
                OnValidate=BEGIN
                             InsuranceJnlManagement.GetDescriptions(Rec,InsuranceDescription,FADescription);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af anl�gsaktivet.;
                           ENU=Specifies a description of the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Description";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den beskrivelse, som er angivet i feltet Forsikringsnr.;
                           ENU=Specifies the description that is entered in the Insurance No. field.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede bel�b for kladdelinjen. Kreditbel�b skal indtastes med et minustegn.;
                           ENU=Specifies the total amount the journal line consists of. Credit amounts must be entered with a minus sign.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Amount }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsv�rdikode, der er knyttet til kladdelinjen.;
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
                ToolTipML=[DAN=Angiver den dimensionsv�rdikode, der er knyttet til kladdelinjen.;
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
                ToolTipML=[DAN=Angiver den dimensionsv�rdikode, der er knyttet til kladdelinjen.;
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
                ToolTipML=[DAN=Angiver den dimensionsv�rdikode, der er knyttet til kladdelinjen.;
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
                ToolTipML=[DAN=Angiver den dimensionsv�rdikode, der er knyttet til kladdelinjen.;
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
                ToolTipML=[DAN=Angiver den dimensionsv�rdikode, der er knyttet til kladdelinjen.;
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

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �rsagskoden som et supplerende kildespor, der hj�lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil bogf�re en indeksering (dvs. indeksere den samlede forsikringssum).;
                           ENU=Specifies whether to post an indexation (that is, to index the total value insured).];
                ApplicationArea=#FixedAssets;
                SourceExpr="Index Entry";
                Visible=FALSE }

    { 38  ;1   ;Group      }

    { 1902204901;2;Group  ;
                GroupType=FixedLayout }

    { 1900724601;3;Group  ;
                CaptionML=[DAN=Forsikringsbeskrivelse;
                           ENU=Insurance Description] }

    { 3   ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af forsikringen.;
                           ENU=Specifies a description of the insurance.];
                ApplicationArea=#FixedAssets;
                SourceExpr=InsuranceDescription;
                Editable=FALSE;
                ShowCaption=No }

    { 1901313501;3;Group  ;
                CaptionML=[DAN=Anl�gsbeskrivelse;
                           ENU=FA Description] }

    { 16  ;4   ;Field     ;
                CaptionML=[DAN=Anl�gsbeskrivelse;
                           ENU=FA Description];
                ToolTipML=[DAN=Angiver en beskrivelse af det anl�g, der er angivet i feltet Anl�gsnr. p� linjen.;
                           ENU=Specifies a description of the fixed asset that is entered in the FA No. field on the line.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADescription;
                Editable=FALSE }

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
      InsuranceJnlManagement@1000 : Codeunit 5656;
      ReportPrint@1001 : Codeunit 228;
      CurrentJnlBatchName@1002 : Code[10];
      InsuranceDescription@1003 : Text[30];
      FADescription@1004 : Text[30];
      ShortcutDimCode@1005 : ARRAY [8] OF Code[20];

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      InsuranceJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

