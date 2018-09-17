OBJECT Page 5619 FA Depreciation Books
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl‘gsafskrivningsprofiler;
               ENU=FA Depreciation Books];
    SourceTable=Table5612;
    DataCaptionFields=FA No.,Depreciation Book Code;
    PageType=List;
    RefreshOnActivate=Yes;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 43      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Afskr.profil;
                                 ENU=&Depr. Book];
                      Image=DepreciationsBooks }
      { 45      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5604;
                      RunPageView=SORTING(FA No.,Depreciation Book Code);
                      RunPageLink=FA No.=FIELD(FA No.),
                                  Depreciation Book Code=FIELD(Depreciation Book Code);
                      Promoted=No;
                      Image=FixedAssetLedger }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=Fejlposter;
                                 ENU=Error Ledger Entries];
                      ToolTipML=[DAN=Vis de poster, der er blevet bogf›rt, fordi du har brugt funktionen Annuller til at annullere en post.;
                                 ENU=View the entries that have been posted as a result of you using the Cancel function to cancel an entry.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5605;
                      RunPageView=SORTING(Canceled from FA No.,Depreciation Book Code);
                      RunPageLink=Canceled from FA No.=FIELD(FA No.),
                                  Depreciation Book Code=FIELD(Depreciation Book Code);
                      Image=ErrorFALedgerEntries }
      { 47      ;2   ;Action    ;
                      CaptionML=[DAN=Reparationsposter;
                                 ENU=Maintenance Ledger Entries];
                      ToolTipML=[DAN=Vis reparationsposterne for det valgte faste anl‘gsaktiv.;
                                 ENU=View the maintenance ledger entries for the selected fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5641;
                      RunPageView=SORTING(FA No.,Depreciation Book Code);
                      RunPageLink=FA No.=FIELD(FA No.),
                                  Depreciation Book Code=FIELD(Depreciation Book Code);
                      Image=MaintenanceLedgerEntries }
      { 65      ;2   ;Separator  }
      { 59      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis detaljerede historiske oplysninger om det faste anl‘gsaktiv.;
                                 ENU=View detailed historical information about the fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5602;
                      RunPageLink=FA No.=FIELD(FA No.),
                                  Depreciation Book Code=FIELD(Depreciation Book Code);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 66      ;2   ;Action    ;
                      CaptionML=[DAN=&Hovedanl‘g - statistik;
                                 ENU=Main &Asset Statistics];
                      ToolTipML=[DAN=Vis statistikker for alle de komponenter, der udg›r hovedaktivet for den valgte profil. Den venstre side af oversigtspanelet Generelt viser hovedaktivets bogf›rte v‘rdi, afskrivningsgrundlaget og eventuelle vedligeholdelsesomkostninger, der er posteret p† de komponenter, der udg›r hovedaktivet. Den h›jre side viser antallet af komponenter i hovedaktivet og den dato, hvor der f›rst blev bogf›rt en anskaffelse og/eller et salg p† et af de aktiver, der udg›r hovedaktivet.;
                                 ENU=View statistics for all the components that make up the main asset for the selected book. The left side of the General FastTab displays the main asset's book value, depreciable basis and any maintenance expenses posted to the components that comprise the main asset. The right side shows the number of components for the main asset, the first date on which an acquisition and/or disposal entry was posted to one of the assets that comprise the main asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5603;
                      RunPageLink=FA No.=FIELD(FA No.),
                                  Depreciation Book Code=FIELD(Depreciation Book Code);
                      Image=StatisticsDocument }
      { 60      ;2   ;Action    ;
                      CaptionML=[DAN=Anl‘gsbogf.typeoversigt;
                                 ENU=FA Posting Types Overview];
                      ToolTipML=[DAN=Vis akkumulerede bel›b for hvert felt, f.eks. bogf›rt v‘rdi, anskaffelsespris, afskrivning, og for hvert anl‘g. For hvert anl‘g vises en separat linje for hver afskrivningsprofil, der er knyttet til anl‘gsaktivet.;
                                 ENU=View accumulated amounts for each field, such as book value, acquisition cost, and depreciation, and for each fixed asset. For every fixed asset, a separate line is shown for each depreciation book linked to the fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5662;
                      Image=ShowMatrix }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver nummeret for det relaterede anl‘g. ";
                           ENU="Specifies the number of the related fixed asset. "];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf›res til, hvis du har valgt Anl‘gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Book Code" }

    { 67  ;2   ;Field     ;
                CaptionML=[DAN=Anl. ekstra valutakode;
                           ENU=FA Add.-Currency Code];
                ToolTipML=[DAN=Angiver den valutakurs, der skal bruges, hvis du bogf›rer i en ekstra valuta.;
                           ENU=Specifies the exchange rate to be used if you post in an additional currency.];
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

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l‘ngden p† afskrivningsperioden, udtrykt i †r.;
                           ENU=Specifies the length of the depreciation period, expressed in years.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No. of Depreciation Years" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor afskrivningen af anl‘gsaktivet begynder.;
                           ENU=Specifies the date on which depreciation of the fixed asset starts.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Starting Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l‘ngden p† afskrivningsperioden, udtrykt i m†neder.;
                           ENU=Specifies the length of the depreciation period, expressed in months.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No. of Depreciation Months";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor afskrivningen af anl‘gsaktivet slutter.;
                           ENU=Specifies the date on which depreciation of the fixed asset ends.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Ending Date" }

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
                SourceExpr="Declining-Balance %";
                Visible=FALSE }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for den brugerdefinerede afskrivningstabel, hvis du har indtastet en kode i feltet Afskrivningstabelkode.;
                           ENU=Specifies the starting date for the user-defined depreciation table if you have entered a code in the Depreciation Table Code field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="First User-Defined Depr. Date";
                Visible=FALSE }

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

    { 75  ;2   ;Field     ;
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

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at afskrivningsmetoderne Saldo 1/Line‘r og Saldo 2/Line‘r bruger saldoafskrivningsbel›bet i det f›rste regnskabs†r.;
                           ENU=Specifies that the depreciation methods DB1/SL and DB2/SL use the declining balance depreciation amount in the first fiscal year.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Use DB% First Fiscal Year";
                Visible=FALSE }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for den periode, hvor et midlertidigt fast afskrivningsbel›b vil blive brugt.;
                           ENU=Specifies the ending date of the period during which a temporary fixed depreciation amount will be used.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Temp. Ending Date";
                Visible=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et midlertidigt fast afskrivningsbel›b.;
                           ENU=Specifies a temporary fixed depreciation amount.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Temp. Fixed Depr. Amount";
                Visible=FALSE }

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
      GLSetup@1000 : Record 98;
      ChangeExchangeRate@1001 : Page 511;
      AddCurrCodeIsFound@1002 : Boolean;

    LOCAL PROCEDURE GetAddCurrCode@1() : Code[10];
    BEGIN
      IF NOT AddCurrCodeIsFound THEN
        GLSetup.GET;
      EXIT(GLSetup."Additional Reporting Currency");
    END;

    BEGIN
    END.
  }
}

