OBJECT Page 5600 Fixed Asset Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Permissions=TableData 5612=rim;
    CaptionML=[DAN=Anl‘gskort;
               ENU=Fixed Asset Card];
    SourceTable=Table5600;
    PageType=Document;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 Simple := TRUE;
                 SetNoFieldVisible;
               END;

    OnAfterGetRecord=BEGIN
                       IF "No." <> xRec."No." THEN
                         SaveSimpleDepriciationBook(xRec."No.");

                       LoadDepreciationBooks;
                       CurrPage.UPDATE(FALSE);
                       FADepreciationBook.COPY(FADepreciationBookOld);
                       ShowAcquireNotification;
                       FADepreciationBook.UpdateBookValue;
                     END;

    OnQueryClosePage=BEGIN
                       SaveSimpleDepriciationBook("No.");
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Anl‘g;
                                 ENU=Fixed &Asset];
                      Image=FixedAssets }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=Afskriv&ningsprofiler;
                                 ENU=Depreciation &Books];
                      ToolTipML=[DAN=Vis eller rediger den afskrivningsprofil eller de afskrivningsprofiler, der skal bruges til hvert enkelt anl‘g. Du kan ogs† angive, hvordan afskrivningen skal beregnes.;
                                 ENU=View or edit the depreciation book or books that must be used for each of the fixed assets. Here you also specify the way depreciation must be calculated.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5619;
                      RunPageLink=FA No.=FIELD(No.);
                      Image=DepreciationBooks }
      { 40      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis detaljerede historiske oplysninger om anl‘gget.;
                                 ENU=View detailed historical information about the fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5602;
                      RunPageLink=FA No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 84      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5600),
                                  No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Reparations&registrering;
                                 ENU=Maintenance &Registration];
                      ToolTipML=[DAN=Vis eller rediger reparationskoder for forskellige former for reparation, vedligeholdelse og serviceydelser p† dine anl‘g. Du kan derefter angive koden i feltet Reparationskode i kladder.;
                                 ENU=View or edit maintenance codes for the various types of maintenance, repairs, and services performed on your fixed assets. You can then enter the code in the Maintenance Code field on journals.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5625;
                      RunPageLink=FA No.=FIELD(No.);
                      Promoted=Yes;
                      Image=MaintenanceRegistrations;
                      PromotedCategory=Process }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Anl‘gsbogf.typeoversigt;
                                 ENU=FA Posting Types Overview];
                      ToolTipML=[DAN=Vis akkumulerede bel›b for hvert felt, f.eks. bogf›rt v‘rdi, anskaffelsespris, afskrivning, og for hvert anl‘g. For hvert anl‘g vises en separat linje for hver afskrivningsprofil, der er knyttet til anl‘gget.;
                                 ENU=View accumulated amounts for each field, such as book value, acquisition cost, and depreciation, and for each fixed asset. For every fixed asset, a separate line is shown for each depreciation book linked to the asset.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5662;
                      Image=ShowMatrix }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Fixed Asset),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Hovedanl‘g;
                                 ENU=Main Asset] }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=&Hovedanl‘g;
                                 ENU=M&ain Asset Components];
                      ToolTipML=[DAN=Vis eller rediger anl‘gskomponenter for det hovedanl‘g, som er repr‘senteret af anl‘gskortet.;
                                 ENU=View or edit fixed asset components of the main fixed asset that is represented by the fixed asset card.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5658;
                      RunPageLink=Main Asset No.=FIELD(No.);
                      Image=Components }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Ho&vedanl‘g - statistik;
                                 ENU=Ma&in Asset Statistics];
                      ToolTipML=[DAN=Vis detaljerede historiske oplysninger om det faste anl‘gsaktiv.;
                                 ENU=View detailed historical information about the fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5603;
                      RunPageLink=FA No.=FIELD(No.);
                      Image=StatisticsDocument }
      { 39      ;2   ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Forsikring;
                                 ENU=Insurance];
                      Image=TotalValueInsured }
      { 68      ;2   ;Action    ;
                      CaptionML=[DAN=&Forsikret i alt;
                                 ENU=Total Value Ins&ured];
                      ToolTipML=[DAN=Vis de bel›b, du har bogf›rt for hver forsikringspolice for anl‘gsaktivet. De viste bel›b kan v‘re lavere eller h›jere end den faktiske forsikringsd‘kning. De viste bel›b kan afvige fra anl‘ggets faktiske bogf›rte v‘rdi.;
                                 ENU=View the amounts that you posted to each insurance policy for the fixed asset. The amounts shown can be more or less than the actual insurance policy coverage. The amounts shown can differ from the actual book value of the asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5649;
                      RunPageLink=No.=FIELD(No.);
                      Image=TotalValueInsured }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 7       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5604;
                      RunPageView=SORTING(FA No.)
                                  ORDER(Descending);
                      RunPageLink=FA No.=FIELD(No.);
                      Image=FixedAssetLedger }
      { 8       ;2   ;Action    ;
                      CaptionML=[DAN=Fejlposter;
                                 ENU=Error Ledger Entries];
                      ToolTipML=[DAN=Vis de poster, der er blevet bogf›rt, fordi du har brugt funktionen Annuller til at annullere en post.;
                                 ENU=View the entries that have been posted as a result of you using the Cancel function to cancel an entry.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5605;
                      RunPageView=SORTING(Canceled from FA No.)
                                  ORDER(Descending);
                      RunPageLink=Canceled from FA No.=FIELD(No.);
                      Image=ErrorFALedgerEntries }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Rep&arationsposter;
                                 ENU=Main&tenance Ledger Entries];
                      ToolTipML=[DAN=Vis alle reparationsposter for et anl‘gsaktiv.;
                                 ENU=View all the maintenance ledger entries for a fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5641;
                      RunPageView=SORTING(FA No.);
                      RunPageLink=FA No.=FIELD(No.);
                      Image=MaintenanceLedgerEntries }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 13      ;1   ;Action    ;
                      Name=Acquire;
                      CaptionML=[DAN=Anskaf;
                                 ENU=Acquire];
                      ToolTipML=[DAN=Anskaf anl‘gsaktivet.;
                                 ENU=Acquire the fixed asset.];
                      ApplicationArea=#FixedAssets;
                      Enabled=Acquirable;
                      Image=ValidateEmailLoggingSetup;
                      OnAction=VAR
                                 FixedAssetAcquisitionWizard@1000 : Codeunit 5550;
                               BEGIN
                                 FixedAssetAcquisitionWizard.RunAcquisitionWizard("No.");
                               END;
                                }
      { 57      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier anl&‘g;
                                 ENU=C&opy Fixed Asset];
                      ToolTipML=[DAN=Vis eller rediger anl‘gskomponenter for det hovedanl‘g, som er repr‘senteret af anl‘gskortet.;
                                 ENU=View or edit fixed asset components of the main fixed asset that is represented by the fixed asset card.];
                      ApplicationArea=#FixedAssets;
                      Image=CopyFixedAssets;
                      OnAction=VAR
                                 CopyFA@1000 : Report 5685;
                               BEGIN
                                 CopyFA.SetFANo("No.");
                                 CopyFA.RUNMODAL;
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1901902606;1 ;Action    ;
                      CaptionML=[DAN=Detaljer;
                                 ENU=Details];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om de anl‘gsposter, der er bogf›rt i en bestemt afskrivningsprofil for hvert enkelt anl‘g.;
                                 ENU=View detailed information about the fixed asset ledger entries that have been posted to a specified depreciation book for each fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5604;
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Report }
      { 1905598506;1 ;Action    ;
                      CaptionML=[DAN=Anl‘g - bogf›rt v‘rdi;
                                 ENU=FA Book Value];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om anskaffelsesbel›b, afskrivninger og bogf›rte v‘rdier for b†de enkelte anl‘gsaktiver og grupper af anl‘gsaktiver. For hver af de tre bel›bstyper beregnes bel›bene ved begyndelsen og ved slutningen af den valgte periode samt for selve perioden.;
                                 ENU=View detailed information about acquisition cost, depreciation and book value for both individual fixed assets and groups of fixed assets. For each of these three amount types, amounts are calculated at the beginning and at the end of a specified period as well as for the period itself.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5605;
                      Image=Report }
      { 1905598606;1 ;Action    ;
                      CaptionML=[DAN=Anl‘gs bogf›rte v‘rdi - Op- og nedskrivning;
                                 ENU=FA Book Val. - Appr. & Write-D];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om anskaffelsesbel›b, afskrivninger, opskrivninger, nedskrivninger og bogf›rte v‘rdier i forbindelse med b†de enkelte anl‘gsaktiver og grupper af anl‘gsaktiver. For hver af bel›bstyperne beregnes bel›bene ved begyndelsen og ved slutningen af den valgte periode samt for selve perioden.;
                                 ENU=View detailed information about acquisition cost, depreciation, appreciation, write-down and book value for both individual fixed assets and groups of fixed assets. For each of these categories, amounts are calculated at the beginning and at the end of a specified period, as well as for the period itself.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5606;
                      Image=Report }
      { 1901105406;1 ;Action    ;
                      CaptionML=[DAN=Analyse;
                                 ENU=Analysis];
                      ToolTipML=[DAN=Vis en analyse af anl‘gsaktiverne med oplysninger om b†de enkelte anl‘gsaktiver og grupper af anl‘gsaktiver.;
                                 ENU=View an analysis of your fixed assets with various types of data for both individual fixed assets and groups of fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5600;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902048606;1 ;Action    ;
                      CaptionML=[DAN=Forventet v‘rdi;
                                 ENU=Projected Value];
                      ToolTipML=[DAN=Vis den beregnede fremtidige afskrivning og den bogf›rte v‘rdi. Du kan udskrive rapporten for ‚n afskrivningsprofil ad gangen.;
                                 ENU=View the calculated future depreciation and book value. You can print the report for one depreciation book at a time.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5607;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903345906;1 ;Action    ;
                      CaptionML=[DAN=Finansanalyse;
                                 ENU=G/L Analysis];
                      ToolTipML=[DAN=Vis en analyse af anl‘gsaktiverne med oplysninger om b†de enkelte anl‘gsaktiver og/eller grupper af anl‘gsaktiver.;
                                 ENU=View an analysis of your fixed assets with various types of data for individual fixed assets and/or groups of fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5610;
                      Image=Report }
      { 1903807106;1 ;Action    ;
                      CaptionML=[DAN=Journal;
                                 ENU=Register];
                      ToolTipML=[DAN=Vis registre, der indeholder alle poster for faste anl‘gsaktiver, som er oprettet. Hvert register viser det f›rste og sidste l›benummer for dets poster.;
                                 ENU=View registers containing all the fixed asset entries that are created. Each register shows the first and last entry number of its entries.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5603;
                      Image=Confirm }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Additional;
                Visible=NoFieldVisible;
                OnValidate=BEGIN
                             ShowAcquireNotification
                           END;

                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af anl‘gget.;
                           ENU=Specifies a description of the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description;
                Importance=Promoted;
                OnValidate=BEGIN
                             ShowAcquireNotification
                           END;

                ShowMandatory=TRUE }

    { 34  ;2   ;Group     ;
                GroupType=Group }

    { 43  ;3   ;Field     ;
                CaptionML=[DAN=Artskode;
                           ENU=Class Code];
                ToolTipML=[DAN=Angiver den art, som anl‘gsaktivet tilh›rer.;
                           ENU=Specifies the class that the fixed asset belongs to.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Class Code";
                Importance=Promoted }

    { 45  ;3   ;Field     ;
                CaptionML=[DAN=Gruppekode;
                           ENU=Subclass Code];
                ToolTipML=[DAN=Angiver gruppen under den art, som anl‘gget tilh›rer.;
                           ENU=Specifies the subclass of the class that the fixed asset belongs to.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Subclass Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             SetDefaultDepreciationBook;
                             SetDefaultPostingGroup;
                             ShowAcquireNotification;
                           END;

                OnLookup=VAR
                           FASubclass@1000 : Record 5608;
                         BEGIN
                           IF "FA Class Code" <> '' THEN
                             FASubclass.SETFILTER("FA Class Code",'%1|%2','',"FA Class Code");

                           IF FASubclass.GET("FA Subclass Code") THEN;
                           IF PAGE.RUNMODAL(0,FASubclass) = ACTION::LookupOK THEN BEGIN
                             Text := FASubclass.Code;
                             EXIT(TRUE);
                           END;
                         END;

                ShowMandatory=TRUE }

    { 52  ;2   ;Field     ;
                CaptionML=[DAN=Lokationskode;
                           ENU=Location Code];
                ToolTipML=[DAN=Angiver den lokation, f.eks. en bygning, hvor anl‘gget er placeret.;
                           ENU=Specifies the location, such as a building, where the fixed asset is located.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Location Code";
                Importance=Additional }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om anl‘gget er til budgetform†l.;
                           ENU=Specifies if the asset is for budgeting purposes.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Budgeted Asset";
                Importance=Additional }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver anl‘ggets serienummer.;
                           ENU=Specifies the fixed asset's serial number.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Serial No.";
                Importance=Promoted }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om anl‘gsaktivet er et hovedanl‘g eller en komponent i et anl‘g.;
                           ENU=Specifies if the fixed asset is a main fixed asset or a component of a fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Main Asset/Component";
                Importance=Additional }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† hovedanl‘gget.;
                           ENU=Specifies the number of the main fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Component of Main Asset";
                Importance=Additional;
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en s›gebeskrivelse for anl‘gget.;
                           ENU=Specifies a search description for the fixed asset.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Description" }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den medarbejder, der er ansvarlig for anl‘gget.;
                           ENU=Specifies which employee is responsible for the fixed asset.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsible Employee";
                Importance=Promoted }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at anl‘gget er inaktivt (f.eks. taget ud af drift eller for‘ldet).;
                           ENU=Specifies that the fixed asset is inactive (for example, if the asset is not in service or is obsolete).];
                ApplicationArea=#FixedAssets;
                SourceExpr=Inactive;
                Importance=Additional }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Blocked;
                Importance=Additional }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om anl‘gget er blevet anskaffet.;
                           ENU=Specifies if the fixed asset has been acquired.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Acquired;
                Importance=Additional;
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r anl‘gskortet sidst blev ‘ndret.;
                           ENU=Specifies when the fixed asset card was last modified.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Last Date Modified";
                Importance=Additional }

    { 27  ;1   ;Group     ;
                CaptionML=[DAN=Afskrivningsprofil;
                           ENU=Depreciation Book];
                Visible=Simple;
                GroupType=Group }

    { 25  ;2   ;Field     ;
                Name=DepreciationBookCode;
                CaptionML=[DAN=Afskrivningsprofilkode;
                           ENU=Depreciation Book Code];
                ToolTipML=[DAN=Angiver den afskrivningsprofil, som er tildelt anl‘gget.;
                           ENU=Specifies the depreciation book that is assigned to the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADepreciationBook."Depreciation Book Code";
                TableRelation="Depreciation Book";
                Importance=Additional;
                OnValidate=BEGIN
                             LoadDepreciationBooks;
                             FADepreciationBook.VALIDATE("Depreciation Book Code");
                             SaveSimpleDepriciationBook(xRec."No.");
                             ShowAcquireNotification;
                           END;
                            }

    { 31  ;2   ;Field     ;
                Name=FAPostingGroup;
                CaptionML=[DAN=Bogf›ringsgruppe;
                           ENU=Posting Group];
                ToolTipML=[DAN=Angiver, hvilken bogf›ringsgruppe der bruges til afskrivningsprofilen ved bogf›ring af anl‘gstransaktioner.;
                           ENU=Specifies which posting group is used for the depreciation book when posting fixed asset transactions.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADepreciationBook."FA Posting Group";
                TableRelation="FA Posting Group";
                Importance=Additional;
                OnValidate=BEGIN
                             LoadDepreciationBooks;
                             FADepreciationBook.VALIDATE("FA Posting Group");
                             SaveSimpleDepriciationBook(xRec."No.");
                             ShowAcquireNotification;
                           END;
                            }

    { 23  ;2   ;Field     ;
                Name=DepreciationMethod;
                CaptionML=[DAN=Afskrivningsmetode;
                           ENU=Depreciation Method];
                ToolTipML=[DAN=Angiver, hvordan afskrivningen beregnes for afskrivningsprofilen.;
                           ENU=Specifies how depreciation is calculated for the depreciation book.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADepreciationBook."Depreciation Method";
                OnValidate=BEGIN
                             LoadDepreciationBooks;
                             FADepreciationBook.VALIDATE("Depreciation Method");
                             SaveSimpleDepriciationBook(xRec."No.");
                           END;
                            }

    { 33  ;2   ;Group     ;
                GroupType=Group }

    { 21  ;3   ;Field     ;
                Name=DepreciationStartingDate;
                CaptionML=[DAN=Afskriv fra den;
                           ENU=Depreciation Starting Date];
                ToolTipML=[DAN=Angiver den dato, hvor afskrivningen af anl‘gsaktivet begynder.;
                           ENU=Specifies the date on which depreciation of the fixed asset starts.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADepreciationBook."Depreciation Starting Date";
                OnValidate=BEGIN
                             LoadDepreciationBooks;
                             FADepreciationBook.VALIDATE("Depreciation Starting Date");
                             SaveSimpleDepriciationBook(xRec."No.");
                             ShowAcquireNotification;
                           END;

                ShowMandatory=TRUE }

    { 19  ;3   ;Field     ;
                Name=NumberOfDepreciationYears;
                CaptionML=[DAN=Antal afskrivnings†r;
                           ENU=No. of Depreciation Years];
                ToolTipML=[DAN=Angiver l‘ngden p† afskrivningsperioden, udtrykt i †r.;
                           ENU=Specifies the length of the depreciation period, expressed in years.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADepreciationBook."No. of Depreciation Years";
                OnValidate=BEGIN
                             LoadDepreciationBooks;
                             FADepreciationBook.VALIDATE("No. of Depreciation Years");
                             SaveSimpleDepriciationBook(xRec."No.");
                             ShowAcquireNotification;
                           END;
                            }

    { 17  ;3   ;Field     ;
                Name=DepreciationEndingDate;
                CaptionML=[DAN=Afskriv til den;
                           ENU=Depreciation Ending Date];
                ToolTipML=[DAN=Angiver den dato, hvor afskrivningen af anl‘gsaktivet slutter.;
                           ENU=Specifies the date on which depreciation of the fixed asset ends.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADepreciationBook."Depreciation Ending Date";
                OnValidate=BEGIN
                             LoadDepreciationBooks;
                             FADepreciationBook.VALIDATE("Depreciation Ending Date");
                             SaveSimpleDepriciationBook(xRec."No.");
                             ShowAcquireNotification;
                           END;

                ShowMandatory=TRUE }

    { 73  ;2   ;Field     ;
                Name=BookValue;
                CaptionML=[DAN=Bogf›rt v‘rdi;
                           ENU=Book Value];
                ToolTipML=[DAN=Angiver anl‘ggets bogf›rte v‘rdi.;
                           ENU=Specifies the book value for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADepreciationBook."Book Value";
                Editable=FALSE }

    { 38  ;2   ;Group     ;
                Visible=ShowAddMoreDeprBooksLbl;
                GroupType=Group }

    { 15  ;3   ;Field     ;
                Name=AddMoreDeprBooks;
                DrillDown=Yes;
                ApplicationArea=#FixedAssets;
                SourceExpr=AddMoreDeprBooksLbl;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              Simple := NOT Simple;
                            END;

                ShowCaption=No }

    { 6   ;1   ;Part      ;
                Name=DepreciationBook;
                CaptionML=[DAN=Afskrivningsprofiler;
                           ENU=Depreciation Books];
                ApplicationArea=#FixedAssets;
                SubPageLink=FA No.=FIELD(No.);
                PagePartID=Page5666;
                Visible=NOT Simple;
                PartType=Page }

    { 1903524101;1;Group  ;
                CaptionML=[DAN=Reparation;
                           ENU=Maintenance] }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, som du har k›bt anl‘gget af.;
                           ENU=Specifies the number of the vendor from which you purchased this fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Vendor No.";
                Importance=Promoted }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, som udf›rer reparationer og vedligeholdelse p† anl‘gget.;
                           ENU=Specifies the number of the vendor who performs repairs and maintenance on the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Maintenance Vendor No.";
                Importance=Promoted }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om anl‘gget er under reparation.;
                           ENU=Specifies if the fixed asset is currently being repaired.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Under Maintenance" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den n‘ste, planlagte servicedato for anl‘gget. Feltet bruges som et filter i rapporten Reparation - N‘ste service.;
                           ENU=Specifies the next scheduled service date for the fixed asset. This is used as a filter in the Maintenance - Next Service report.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Next Service Date";
                Importance=Promoted }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r garantien udl›ber for anl‘gget.;
                           ENU=Specifies the warranty expiration date of the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Warranty Date" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at anl‘gget er knyttet til en forsikringspolice.;
                           ENU=Specifies that the fixed asset is linked to an insurance policy.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Insured }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 46  ;1   ;Part      ;
                Name=FixedAssetPicture;
                CaptionML=[DAN=Anl‘gsbillede;
                           ENU=Fixed Asset Picture];
                ApplicationArea=#FixedAssets;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page5620;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      FADepreciationBook@1006 : Record 5612;
      FADepreciationBookOld@1002 : Record 5612;
      FAAcquireWizardNotificationId@1000 : GUID;
      NoFieldVisible@1005 : Boolean;
      Simple@1001 : Boolean;
      AddMoreDeprBooksLbl@1003 : TextConst 'DAN=Tilf›j flere afskrivningsprofiler;ENU=Add More Depreciation Books';
      Acquirable@1004 : Boolean;
      ShowAddMoreDeprBooksLbl@1007 : Boolean;

    LOCAL PROCEDURE ShowAcquireNotification@7();
    VAR
      ShowAcquireNotification@1001 : Boolean;
    BEGIN
      ShowAcquireNotification :=
        (NOT Acquired) AND FieldsForAcquitionInGeneralGroupAreCompleted AND AtLeastOneDepreciationLineIsComplete;
      IF ShowAcquireNotification AND ISNULLGUID(FAAcquireWizardNotificationId) THEN BEGIN
        Acquirable := TRUE;
        ShowAcquireWizardNotification;
      END;
    END;

    LOCAL PROCEDURE AtLeastOneDepreciationLineIsComplete@24() : Boolean;
    VAR
      FADepreciationBookMultiline@1000 : Record 5612;
    BEGIN
      IF Simple THEN
        EXIT(FADepreciationBook.RecIsReadyForAcquisition);

      EXIT(FADepreciationBookMultiline.LineIsReadyForAcquisition("No."));
    END;

    LOCAL PROCEDURE SaveSimpleDepriciationBook@28(FixedAssetNo@1000 : Code[20]);
    VAR
      FixedAsset@1001 : Record 5600;
    BEGIN
      IF NOT SimpleDepreciationBookHasChanged THEN
        EXIT;

      IF Simple AND FixedAsset.GET(FixedAssetNo) THEN BEGIN
        IF FADepreciationBook."Depreciation Book Code" <> '' THEN
          IF FADepreciationBook."FA No." = '' THEN BEGIN
            FADepreciationBook.VALIDATE("FA No.",FixedAssetNo);
            FADepreciationBook.INSERT(TRUE)
          END ELSE
            FADepreciationBook.MODIFY(TRUE)
      END;
    END;

    LOCAL PROCEDURE SetDefaultDepreciationBook@21();
    VAR
      FASetup@1001 : Record 5603;
    BEGIN
      IF FADepreciationBook."Depreciation Book Code" = '' THEN BEGIN
        FASetup.GET;
        FADepreciationBook.VALIDATE("Depreciation Book Code",FASetup."Default Depr. Book");
        SaveSimpleDepriciationBook("No.");
        LoadDepreciationBooks;
      END;
    END;

    LOCAL PROCEDURE SetDefaultPostingGroup@22();
    VAR
      FASubclass@1000 : Record 5608;
    BEGIN
      IF FASubclass.GET("FA Subclass Code") THEN;
      FADepreciationBook.VALIDATE("FA Posting Group",FASubclass."Default FA Posting Group");
      SaveSimpleDepriciationBook("No.");
    END;

    LOCAL PROCEDURE SimpleDepreciationBookHasChanged@3() : Boolean;
    BEGIN
      EXIT(FORMAT(FADepreciationBook) <> FORMAT(FADepreciationBookOld));
    END;

    LOCAL PROCEDURE LoadDepreciationBooks@5();
    BEGIN
      CLEAR(FADepreciationBookOld);
      FADepreciationBookOld.SETRANGE("FA No.","No.");
      IF FADepreciationBookOld.COUNT <= 1 THEN BEGIN
        IF FADepreciationBookOld.FINDFIRST THEN BEGIN
          FADepreciationBookOld.CALCFIELDS("Book Value");
          ShowAddMoreDeprBooksLbl := TRUE
        END;
        Simple := TRUE;
      END ELSE
        Simple := FALSE;
    END;

    LOCAL PROCEDURE SetNoFieldVisible@13();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      NoFieldVisible := DocumentNoVisibility.FixedAssetNoIsVisible;
    END;

    BEGIN
    END.
  }
}

