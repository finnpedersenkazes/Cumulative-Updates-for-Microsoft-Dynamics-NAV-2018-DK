OBJECT Page 7121 Purchase Analysis Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=K›bsanalyselinjer;
               ENU=Purchase Analysis Lines];
    MultipleNewLines=Yes;
    SourceTable=Table7114;
    DelayedInsert=Yes;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 GLSetup@1001 : Record 98;
                 AnalysisLineTemplate@1000 : Record 7112;
               BEGIN
                 AnalysisReportMgt.OpenAnalysisLines(CurrentAnalysisLineTempl,Rec);

                 GLSetup.GET;

                 IF AnalysisLineTemplate.GET(GETRANGEMAX("Analysis Area"),CurrentAnalysisLineTempl) THEN
                   IF AnalysisLineTemplate."Item Analysis View Code" <> '' THEN
                     ItemAnalysisView.GET(GETRANGEMAX("Analysis Area"),AnalysisLineTemplate."Item Analysis View Code")
                   ELSE BEGIN
                     CLEAR(ItemAnalysisView);
                     ItemAnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
                     ItemAnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
                   END;
               END;

    OnAfterGetRecord=BEGIN
                       DescriptionIndent := 0;
                       DescriptionOnFormat;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 28      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Inds‘t varer;
                                 ENU=Insert &Items];
                      ToolTipML=[DAN=Inds‘t en eller flere varer, som du vil medtage i salgsanalyserapporten.;
                                 ENU=Insert one or more items that you want to include in the sales analysis report.];
                      ApplicationArea=#Suite;
                      Image=Item;
                      OnAction=BEGIN
                                 InsertLine(0);
                               END;
                                }
      { 30      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Inds‘t &kreditorer;
                                 ENU=Insert &Vendors];
                      ToolTipML=[DAN=Inds‘t en eller flere kreditorer, som du vil medtage i salgsanalyserapporten.;
                                 ENU=Insert one or more vendors that you want to include in the sales analysis report.];
                      ApplicationArea=#Suite;
                      Image=Vendor;
                      OnAction=BEGIN
                                 InsertLine(2);
                               END;
                                }
      { 36      ;2   ;Separator  }
      { 31      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Inds‘t &varegrupper;
                                 ENU=Insert Ite&m Groups];
                      ToolTipML=[DAN=Inds‘t en eller flere varegrupper, som du vil medtage i salgsanalyserapporten.;
                                 ENU=Insert one or more item groups that you want to include in the sales analysis report.];
                      ApplicationArea=#Suite;
                      Image=ItemGroup;
                      OnAction=BEGIN
                                 InsertLine(3);
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Inds‘t &s‘lgere/indk›bere;
                                 ENU=Insert &Sales/Purchase Persons];
                      ToolTipML=[DAN=Inds‘t en eller flere salgsmedarbejdere for indk›bere, som du vil medtage i salgsanalyserapporten.;
                                 ENU=Insert one or more sales people of purchasers that you want to include in the sales analysis report.];
                      ApplicationArea=#Suite;
                      Image=SalesPurchaseTeam;
                      OnAction=BEGIN
                                 InsertLine(5);
                               END;
                                }
      { 48      ;2   ;Separator  }
      { 49      ;2   ;Action    ;
                      CaptionML=[DAN=Renummerer linjer;
                                 ENU=Renumber Lines];
                      ToolTipML=[DAN=Renummerer linjer i analyserapporten fortl›bende fra et nummer, som du angiver.;
                                 ENU=Renumber lines in the analysis report sequentially from a number that you specify.];
                      ApplicationArea=#Suite;
                      Image=Refresh;
                      OnAction=VAR
                                 AnalysisLine@1000 : Record 7114;
                                 RenAnalysisLines@1001 : Report 7110;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(AnalysisLine);
                                 RenAnalysisLines.Init(AnalysisLine);
                                 RenAnalysisLines.RUNMODAL;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 25  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Suite;
                SourceExpr=CurrentAnalysisLineTempl;
                OnValidate=BEGIN
                             AnalysisReportMgt.CheckAnalysisLineTemplName(CurrentAnalysisLineTempl,Rec);
                             CurrentAnalysisLineTemplOnAfte;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           AnalysisReportMgt.LookupAnalysisLineTemplName(CurrentAnalysisLineTempl,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                IndentationColumnName=DescriptionIndent;
                IndentationControls=Description;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et r‘kkereferencenummer for analyselinjen.;
                           ENU=Specifies a row reference number for the analysis line.];
                ApplicationArea=#Suite;
                SourceExpr="Row Ref. No.";
                StyleExpr='Strong';
                OnValidate=BEGIN
                             RowRefNoOnAfterValidate;
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse til analyselinjen.;
                           ENU=Specifies a description for the analysis line.];
                ApplicationArea=#Suite;
                SourceExpr=Description;
                StyleExpr='Strong' }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver samment‘llingstypen for analyselinjen. Typen bestemmer, hvilke varer der skal samment‘lles i det interval, som du har angivet i feltet Interval.;
                           ENU=Specifies the type of totaling for the analysis line. The type determines which items within the totaling range that you specify in the Range field will be totaled.];
                OptionCaptionML=[DAN=Vare,Varegruppe,,,Kreditor,S‘lger/indk›ber,Formel;
                                 ENU=Item,Item Group,,,Vendor,Sales/Purchase person,Formula];
                ApplicationArea=#Suite;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret eller formlen for den type, der skal bruges til at beregne totalen p† linjen.;
                           ENU=Specifies the number or formula of the type to use to calculate the total for this line.];
                ApplicationArea=#Suite;
                SourceExpr=Range;
                OnLookup=BEGIN
                           EXIT(LookupTotalingRange(Text));
                         END;
                          }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsv‘rdibel›b der vil blive sammentalt i linjen.;
                           ENU=Specifies which dimension value amounts will be totaled on this line.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 1 Totaling";
                OnLookup=BEGIN
                           EXIT(LookupDimTotalingRange(Text,ItemAnalysisView."Dimension 1 Code"));
                         END;
                          }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsv‘rdibel›b der vil blive sammentalt i linjen. Hvis typen i linjen er Formel, skal feltet v‘re tomt. Hvis du ikke ›nsker bel›bene i linjen filtreret efter dimension, skal feltet ogs† v‘re tomt.;
                           ENU=Specifies which dimension value amounts will be totaled on this line. If the type on the line is Formula, this field must be blank. Also, if you do not want the amounts on the line to be filtered by dimensions, this field must be blank.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 2 Totaling";
                OnLookup=BEGIN
                           EXIT(LookupDimTotalingRange(Text,ItemAnalysisView."Dimension 2 Code"));
                         END;
                          }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsv‘rdibel›b der vil blive sammentalt i linjen. Hvis typen i linjen er Formel, skal feltet v‘re tomt. Hvis du ikke ›nsker bel›bene i linjen filtreret efter dimension, skal feltet ogs† v‘re tomt.;
                           ENU=Specifies which dimension value amounts will be totaled on this line. If the type on the line is Formula, this field must be blank. Also, if you do not want the amounts on the line to be filtered by dimensions, this field must be blank.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 3 Totaling";
                OnLookup=BEGIN
                           EXIT(LookupDimTotalingRange(Text,ItemAnalysisView."Dimension 3 Code"));
                         END;
                          }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der i rapportudskriften skal inds‘ttes et sideskift efter den aktuelle linje.;
                           ENU=Specifies if you want a page break after the current line when you print the analysis report.];
                ApplicationArea=#Suite;
                SourceExpr="New Page" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om analyselinjen skal med i rapportudskriften.;
                           ENU=Specifies whether you want the analysis line to be included when you print the report.];
                ApplicationArea=#Suite;
                SourceExpr=Show }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bel›bene i denne r‘kke skal udskrives med fed.;
                           ENU=Specifies if you want the amounts on this line to be printed in bold.];
                ApplicationArea=#Suite;
                SourceExpr=Bold }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjens indrykning.;
                           ENU=Specifies the indentation of the line.];
                ApplicationArea=#PurchaseAnalysis;
                SourceExpr=Indentation;
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bel›bene i denne r‘kke skal udskrives med kursiv.;
                           ENU=Specifies if you want the amounts in this line to be printed in italics.];
                ApplicationArea=#Suite;
                SourceExpr=Italic }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bel›bene i denne r‘kke skal understreges ved udskrivningen.;
                           ENU=Specifies if you want the amounts in this line to be underlined when printed.];
                ApplicationArea=#Suite;
                SourceExpr=Underline }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil have vist salg og nedreguleringer som positive bel›b og k›b og opreguleringer som negative bel›b.;
                           ENU=Specifies if you want sales and negative adjustments to be shown as positive amounts and purchases and positive adjustments to be shown as negative amounts.];
                ApplicationArea=#Suite;
                SourceExpr="Show Opposite Sign" }

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
      ItemAnalysisView@1000 : Record 7152;
      AnalysisReportMgt@1001 : Codeunit 7110;
      CurrentAnalysisLineTempl@1002 : Code[10];
      DescriptionIndent@19057867 : Integer INDATASET;

    LOCAL PROCEDURE InsertLine@1(Type@1001 : 'Item,Customer,Vendor,ItemGroup,CustGroup,SalespersonGroup');
    VAR
      AnalysisLine@1003 : Record 7114;
      InsertAnalysisLine@1002 : Codeunit 7111;
    BEGIN
      CurrPage.UPDATE(TRUE);
      AnalysisLine.COPY(Rec);
      IF "Line No." = 0 THEN BEGIN
        AnalysisLine := xRec;
        IF AnalysisLine.NEXT = 0 THEN
          AnalysisLine."Line No." := xRec."Line No." + 10000;
      END;
      CASE Type OF
        Type::Item:
          InsertAnalysisLine.InsertItems(AnalysisLine);
        Type::Customer:
          InsertAnalysisLine.InsertCust(AnalysisLine);
        Type::Vendor:
          InsertAnalysisLine.InsertVend(AnalysisLine);
        Type::ItemGroup:
          InsertAnalysisLine.InsertItemGrDim(AnalysisLine);
        Type::CustGroup:
          InsertAnalysisLine.InsertCustGrDim(AnalysisLine);
        Type::SalespersonGroup:
          InsertAnalysisLine.InsertSalespersonPurchaser(AnalysisLine);
      END;
    END;

    [External]
    PROCEDURE SetCurrentAnalysisLineTempl@2(AnalysisLineTemlName@1000 : Code[10]);
    BEGIN
      CurrentAnalysisLineTempl := AnalysisLineTemlName;
    END;

    LOCAL PROCEDURE RowRefNoOnAfterValidate@19011265();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE CurrentAnalysisLineTemplOnAfte@19019881();
    VAR
      ItemSchedName@1001 : Record 7112;
    BEGIN
      CurrPage.SAVERECORD;
      AnalysisReportMgt.SetAnalysisLineTemplName(CurrentAnalysisLineTempl,Rec);
      IF ItemSchedName.GET(GETRANGEMAX("Analysis Area"),CurrentAnalysisLineTempl) THEN
        CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE DescriptionOnFormat@19023855();
    BEGIN
      DescriptionIndent := Indentation;
    END;

    BEGIN
    END.
  }
}

