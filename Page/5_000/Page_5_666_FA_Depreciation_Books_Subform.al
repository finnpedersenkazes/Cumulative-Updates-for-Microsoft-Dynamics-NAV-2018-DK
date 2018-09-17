OBJECT Page 5666 FA Depreciation Books Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table5612;
    DelayedInsert=Yes;
    DataCaptionFields=FA No.,Depreciation Book Code;
    PageType=ListPart;
    RefreshOnActivate=Yes;
    OnAfterGetRecord=BEGIN
                       UpdateBookValue;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907746904;1 ;ActionGroup;
                      CaptionML=[DAN=&Afskr.profil;
                                 ENU=&Depr. Book];
                      Image=DepreciationBooks }
      { 1900295504;2 ;Action    ;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#FixedAssets;
                      Image=CustomerLedger;
                      OnAction=BEGIN
                                 ShowFALedgEntries;
                               END;
                                }
      { 1901741904;2 ;Action    ;
                      CaptionML=[DAN=Fejlposter;
                                 ENU=Error Ledger Entries];
                      ToolTipML=[DAN=Vis de poster, der er blevet bogf›rt, fordi du har brugt funktionen Annuller til at annullere en post.;
                                 ENU=View the entries that have been posted as a result of you using the Cancel function to cancel an entry.];
                      ApplicationArea=#FixedAssets;
                      Image=ErrorFALedgerEntries;
                      OnAction=BEGIN
                                 ShowFAErrorLedgEntries;
                               END;
                                }
      { 1903866604;2 ;Action    ;
                      CaptionML=[DAN=Reparationsposter;
                                 ENU=Maintenance Ledger Entries];
                      ToolTipML=[DAN=Vis reparationsposterne for anl‘gsaktivet.;
                                 ENU=View the maintenance ledger entries for the fixed asset.];
                      ApplicationArea=#FixedAssets;
                      Image=MaintenanceLedgerEntries;
                      OnAction=BEGIN
                                 ShowMaintenanceLedgEntries;
                               END;
                                }
      { 1902759404;2 ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis detaljerede historiske oplysninger om det faste anl‘gsaktiv.;
                                 ENU=View detailed historical information about the fixed asset.];
                      ApplicationArea=#FixedAssets;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowStatistics;
                               END;
                                }
      { 1901991404;2 ;Action    ;
                      CaptionML=[DAN=&Hovedanl‘g - statistik;
                                 ENU=Main &Asset Statistics];
                      ToolTipML=[DAN="Vis statistikker for alle komponenter, der indg†r i hovedanl‘gget for den valgte profil. ";
                                 ENU="View statistics for all the components that make up the main asset for the selected book. "];
                      ApplicationArea=#FixedAssets;
                      Image=StatisticsDocument;
                      OnAction=BEGIN
                                 ShowMainAssetStatistics;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den afskrivningsprofil, som er tildelt anl‘gget.;
                           ENU=Specifies the depreciation book that is assigned to the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Book Code";
                Editable=TRUE }

    { 67  ;2   ;Field     ;
                CaptionML=[DAN=Anl. ekstra valutakode;
                           ENU=FA Add.-Currency Code];
                ToolTipML=[DAN=Angiver en ekstra valuta, der skal bruges ved bogf›ring.;
                           ENU=Specifies an additional currency to be used when posting.];
                ApplicationArea=#Suite;
                SourceExpr=GetAddCurrCode;
                Visible=FALSE;
                OnAssistEdit=BEGIN
                               ChangeExchangeRate.SetParameterFA("FA Add.-Currency Factor",GetAddCurrCode,WORKDATE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                                 "FA Add.-Currency Factor" := ChangeExchangeRate.GetParameter;

                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken bogf›ringsgruppe der bruges til afskrivningsprofilen ved bogf›ring af anl‘gstransaktioner.;
                           ENU=Specifies which posting group is used for the depreciation book when posting fixed asset transactions.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Posting Group" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan afskrivningen beregnes for afskrivningsprofilen.;
                           ENU=Specifies how depreciation is calculated for the depreciation book.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Method" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor afskrivningen af anl‘gsaktivet begynder.;
                           ENU=Specifies the date on which depreciation of the fixed asset starts.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Starting Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l‘ngden p† afskrivningsperioden, udtrykt i †r.;
                           ENU=Specifies the length of the depreciation period, expressed in years.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No. of Depreciation Years" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor afskrivningen af anl‘gsaktivet slutter.;
                           ENU=Specifies the date on which depreciation of the fixed asset ends.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Ending Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l‘ngden p† afskrivningsperioden, udtrykt i m†neder.;
                           ENU=Specifies the length of the depreciation period, expressed in months.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No. of Depreciation Months";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel, som anl‘gget skal afskrives med if›lge den line‘re metode, dog med fast †rlig procentandel.;
                           ENU=Specifies the percentage to depreciate the fixed asset by the straight-line principle, but with a fixed yearly percentage.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Straight-Line %";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bel›b til afskrivning p† anl‘gget med et fast †rligt bel›b.;
                           ENU=Specifies an amount to depreciate the fixed asset, by a fixed yearly amount.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Fixed Depr. Amount";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel, som anl‘gget skal afskrives med if›lge saldometoden, dog med fast †rlig procentandel.;
                           ENU=Specifies the percentage to depreciate the fixed asset by the declining-balance principle, but with a fixed yearly percentage.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Declining-Balance %" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for den brugerdefinerede afskrivningstabel, hvis du har indtastet en kode i feltet Afskrivningstabelkode.;
                           ENU=Specifies the starting date for the user-defined depreciation table if you have entered a code in the Depreciation Table Code field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="First User-Defined Depr. Date";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                CaptionML=[DAN=Solgt;
                           ENU=Disposed Of];
                ToolTipML=[DAN=Angiver, om anl‘gget er blevet solgt.;
                           ENU=Specifies whether the fixed asset has been disposed of.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Disposal Date" > 0D;
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›rte v‘rdi for anl‘gget som et FlowField.;
                           ENU=Specifies the book value for the fixed asset as a FlowField.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Book Value";
                OnDrillDown=VAR
                              FALedgEntry@1000 : Record 5601;
                            BEGIN
                              IF "Disposal Date" > 0D THEN
                                ShowBookValueAfterDisposal
                              ELSE BEGIN
                                SetBookValueFiltersOnFALedgerEntry(FALedgEntry);
                                PAGE.RUN(0,FALedgEntry);
                              END;
                            END;
                             }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for afskrivningstabellen, som du skal bruge, hvis du har valgt indstillingen Brugerdefineret i feltet Afskrivningsmetode.;
                           ENU=Specifies the code of the depreciation table to use if you have selected the User-Defined option in the Depreciation Method field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Table Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det slutafrundingsbel›b, der skal bruges.;
                           ENU=Specifies the final rounding amount to use.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Final Rounding Amount";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som skal bruges som den slutbogf›rte v‘rdi.;
                           ENU=Specifies the amount to use as the ending book value.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Ending Book Value";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den bogf›rte standardslutv‘rdi ignoreres, og v‘rdien i Slutbogf›rt v‘rdi.;
                           ENU=Specifies that the default ending book value is ignored, and the value in the Ending Book Value is used.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Ignore Def. Ending Book Value";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et decimaltal, der vil blive brugt som valutakurs, n†r der kopieres kladdelinjer til denne afskrivningsprofil.;
                           ENU=Specifies a decimal number, which will be used as an exchange rate when duplicating journal lines to this depreciation book.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Exchange Rate";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke kontroller der skal udf›res, f›r du bogf›rer en kladdelinje.;
                           ENU=Specifies which checks to perform before posting a journal line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Use FA Ledger Check";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en procentdel, hvis du har markeret feltet Tillad afskrivning under 0 i afskrivningsprofilen.;
                           ENU=Specifies a percentage if you have selected the Allow Depr. below Zero field in the depreciation book.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depr. below Zero %";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et positivt bel›b, hvis du har markeret feltet Tillad afskrivning under 0 i afskrivningsprofilen.;
                           ENU=Specifies a positive amount if you have selected the Allow Depr. below Zero field in the depreciation book.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Fixed Depr. Amount below Zero";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du vil s‘lge anl‘gget.;
                           ENU=Specifies the date on which you want to dispose of the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Projected Disposal Date";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forventede pris ved salget af anl‘gget.;
                           ENU=Specifies the expected proceeds from disposal of the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Projected Proceeds on Disposal";
                Visible=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for afskrivning af Bruger 1-poster.;
                           ENU=Specifies the starting date for depreciation of custom 1 entries.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depr. Starting Date (Custom 1)";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for afskrivning af Bruger 1-poster.;
                           ENU=Specifies the ending date for depreciation of custom 1 entries.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depr. Ending Date (Custom 1)";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede procentdel for afskrivning af Bruger 1-poster.;
                           ENU=Specifies the total percentage for depreciation of custom 1 entries.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Accum. Depr. % (Custom 1)";
                Visible=FALSE }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede procentdel for afskrivning af Bruger 1-poster i indev‘rende †r.;
                           ENU=Specifies the percentage for depreciation of custom 1 entries for the current year.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depr. This Year % (Custom 1)";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver anl‘gstypen for anl‘gget.;
                           ENU=Specifies the property class of the asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Property Class (Custom 1)";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der skal anvendes Half-Year Convention til den valgte afskrivningsmetode.;
                           ENU=Specifies that the Half-Year Convention is to be applied to the selected depreciation method.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Use Half-Year Convention";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at afskrivningsmetoderne Saldo 1/Line‘r og Saldo 2/Line‘r bruger saldoafskrivningsbel›bet i det f›rste regnskabs†r.;
                           ENU=Specifies that the depreciation methods DB1/SL and DB2/SL use the declining balance depreciation amount in the first fiscal year.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Use DB% First Fiscal Year";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for den periode, hvor et midlertidigt fast afskrivningsbel›b vil blive brugt.;
                           ENU=Specifies the ending date of the period during which a temporary fixed depreciation amount will be used.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Temp. Ending Date";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et midlertidigt fast afskrivningsbel›b.;
                           ENU=Specifies a temporary fixed depreciation amount.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Temp. Fixed Depr. Amount";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      GLSetup@1000 : Record 98;
      FALedgEntry@1001 : Record 5601;
      MaintenanceLedgEntry@1002 : Record 5625;
      FADeprBook@1003 : Record 5612;
      DepreciationCalc@1004 : Codeunit 5616;
      ChangeExchangeRate@1005 : Page 511;
      AddCurrCodeIsFound@1006 : Boolean;

    LOCAL PROCEDURE GetAddCurrCode@1() : Code[10];
    BEGIN
      IF NOT AddCurrCodeIsFound THEN
        GLSetup.GET;
      EXIT(GLSetup."Additional Reporting Currency");
    END;

    LOCAL PROCEDURE ShowFALedgEntries@2();
    BEGIN
      DepreciationCalc.SetFAFilter(FALedgEntry,"FA No.","Depreciation Book Code",FALSE);
      PAGE.RUN(PAGE::"FA Ledger Entries",FALedgEntry);
    END;

    LOCAL PROCEDURE ShowFAErrorLedgEntries@3();
    BEGIN
      FALedgEntry.RESET;
      FALedgEntry.SETCURRENTKEY("Canceled from FA No.");
      FALedgEntry.SETRANGE("Canceled from FA No.","FA No.");
      FALedgEntry.SETRANGE("Depreciation Book Code","Depreciation Book Code");
      PAGE.RUN(PAGE::"FA Error Ledger Entries",FALedgEntry);
    END;

    LOCAL PROCEDURE ShowMaintenanceLedgEntries@4();
    BEGIN
      MaintenanceLedgEntry.SETCURRENTKEY("FA No.","Depreciation Book Code");
      MaintenanceLedgEntry.SETRANGE("FA No.","FA No.");
      MaintenanceLedgEntry.SETRANGE("Depreciation Book Code","Depreciation Book Code");
      PAGE.RUN(PAGE::"Maintenance Ledger Entries",MaintenanceLedgEntry);
    END;

    LOCAL PROCEDURE ShowStatistics@5();
    BEGIN
      FADeprBook.SETRANGE("FA No.","FA No.");
      FADeprBook.SETRANGE("Depreciation Book Code","Depreciation Book Code");
      PAGE.RUN(PAGE::"Fixed Asset Statistics",FADeprBook);
    END;

    LOCAL PROCEDURE ShowMainAssetStatistics@6();
    BEGIN
      FADeprBook.SETRANGE("FA No.","FA No.");
      FADeprBook.SETRANGE("Depreciation Book Code","Depreciation Book Code");
      PAGE.RUN(PAGE::"Main Asset Statistics",FADeprBook);
    END;

    BEGIN
    END.
  }
}

