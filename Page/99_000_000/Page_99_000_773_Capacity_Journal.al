OBJECT Page 99000773 Capacity Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kapacitetskladde;
               ENU=Capacity Journal];
    SaveValues=Yes;
    SourceTable=Table83;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 ItemJnlMgt.TemplateSelection(PAGE::"Capacity Journal",6,FALSE,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 ItemJnlMgt.OpenJnl(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                  VALIDATE("Entry Type","Entry Type"::Output);
                  CLEAR(ShortcutDimCode);
                END;

    OnAfterGetCurrRecord=BEGIN
                           ItemJnlMgt.GetCapacity(Type,"No.",CapDescription);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 38      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 61      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines(FALSE);
                               END;
                                }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&apacitet;
                                 ENU=&Capacity];
                      Image=Capacity }
      { 15      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p�g�ldende record p� bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      Image=EditLines;
                      OnAction=VAR
                                 WorkCenter@1000 : Record 99000754;
                                 MachCenter@1001 : Record 99000758;
                               BEGIN
                                 CASE Type OF
                                   Type::"Work Center":
                                     BEGIN
                                       WorkCenter.SETRANGE("No.","No.");
                                       PAGE.RUN(PAGE::"Work Center Card",WorkCenter);
                                     END;
                                   Type::"Machine Center":
                                     BEGIN
                                       MachCenter.SETRANGE("No.","No.");
                                       PAGE.RUN(PAGE::"Machine Center Card",MachCenter);
                                     END;
                                 END;
                               END;
                                }
      { 20      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogf�rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5832;
                      RunPageLink=Order Type=CONST(Production),
                                  Order No.=FIELD(Order No.);
                      Image=CustomerLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&osting];
                      Image=Post }
      { 41      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s� du kan finde og rette eventuelle fejl, f�r du udf�rer den faktiske bogf�ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Manufacturing;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintItemJnlLine(Rec);
                               END;
                                }
      { 56      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf�r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 57      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f�rdigg�res og forberedes til udskrivning. V�rdierne og antallene bogf�res p� de relaterede konti. Du f�r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print",Rec);
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

    { 78  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p� den kladdek�rsel, et personligt kladdelayout, som kladden er baseret p�.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Manufacturing;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             ItemJnlMgt.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           ItemJnlMgt.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Posting Date" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den ordre, hvor posten blev oprettet.;
                           ENU=Specifies the number of the order that created the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Order No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Document No." }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nummer p� kladdelinjen.;
                           ENU=Specifies the number of the item on the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Item No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;

                OnLookup=BEGIN
                           LookupItemNo;
                           ShowShortcutDimCode(ShortcutDimCode);
                         END;
                          }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� produktionsoperationen p� varekladdelinjen, n�r kladden fungerer som en afgangskladde.;
                           ENU=Specifies the number of the production operation on the item journal line when the journal functions as an output journal.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Operation No.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kladdetype, som enten er Arbejdscenter eller Produktionsressource.;
                           ENU=Specifies the journal type, which is either Work Center or Machine Center.];
                OptionCaptionML=[DAN=Arbejdscenter,Produktionsressource;
                                 ENU=Work Center,Machine Center];
                ApplicationArea=#Manufacturing;
                SourceExpr=Type;
                OnValidate=BEGIN
                             ItemJnlMgt.GetCapacity(Type,"No.",CapDescription);
                           END;
                            }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No.";
                OnValidate=BEGIN
                             ItemJnlMgt.GetCapacity(Type,"No.",CapDescription);
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p� kladdelinjen.;
                           ENU=Specifies a description of the item on the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdsskiftskoden for kladdelinjen.;
                           ENU=Specifies the work shift code for this Journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Shift Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver starttidspunktet for operationen p� varekladdelinjen.;
                           ENU=Specifies the starting time of the operation on the item journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sluttidspunktet for operationen p� varekladdelinjen.;
                           ENU=Specifies the ending time of the operation on the item journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samtidige kapacitet.;
                           ENU=Specifies the concurrent capacity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Concurrent Capacity";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl�ttet for kapacitetsposten.;
                           ENU=Specifies the stop time of this capacity ledger entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Stop Time" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedskoden for kapacitetsforbruget.;
                           ENU=Specifies the unit of measure code for the capacity usage.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Cap. Unit of Measure Code" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver stopkoden.;
                           ENU=Specifies the stop code.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Stop Code" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spildkoden.;
                           ENU=Specifies the scrap code.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Code";
                Visible=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af den producerede vare, der kan bogf�res som afgang p� kladdelinjen.;
                           ENU=Specifies the quantity of the produced item that can be posted as output on the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Output Quantity";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal enheder, der blev produceret forkert og derfor er uanvendelige.;
                           ENU=Specifies the number of units produced incorrectly, and therefore cannot be used.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Quantity";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
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
                ApplicationArea=#Dimensions;
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
                ApplicationArea=#Dimensions;
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
                ApplicationArea=#Dimensions;
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
                ApplicationArea=#Dimensions;
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
                ApplicationArea=#Dimensions;
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

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �rsagskoden som et supplerende kildespor, der hj�lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Manufacturing;
                SourceExpr="External Document No.";
                Visible=FALSE }

    { 73  ;1   ;Group      }

    { 1902114901;2;Group  ;
                GroupType=FixedLayout }

    { 1903098501;3;Group  ;
                CaptionML=[DAN=Kapacitetsnavn;
                           ENU=Capacity Name] }

    { 74  ;4   ;Field     ;
                ApplicationArea=#Manufacturing;
                SourceExpr=CapDescription;
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
      ItemJnlMgt@1000 : Codeunit 240;
      ReportPrint@1001 : Codeunit 228;
      CapDescription@1002 : Text[30];
      CurrentJnlBatchName@1003 : Code[10];
      ShortcutDimCode@1004 : ARRAY [8] OF Code[20];

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      ItemJnlMgt.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

