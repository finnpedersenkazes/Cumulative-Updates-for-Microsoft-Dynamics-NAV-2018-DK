OBJECT Page 6520 Item Tracing
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varesporing;
               ENU=Item Tracing];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table6520;
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             NavigateEnable := TRUE;
             PrintEnable := TRUE;
             FunctionsEnable := TRUE;
           END;

    OnOpenPage=BEGIN
                 InitButtons;
                 TraceMethod := TraceMethod::"Usage->Origin";
                 ShowComponents := ShowComponents::"Item-tracked Only";
               END;

    OnAfterGetRecord=BEGIN
                       DescriptionIndent := 0;
                       ItemTracingMgt.SetExpansionStatus(Rec,TempTrackEntry,Rec,ActualExpansionStatus);
                       DescriptionOnFormat;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 34      ;1   ;ActionGroup;
                      Name=Line;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 60      ;2   ;Action    ;
                      Name=ShowDocument;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=bn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#ItemTracking;
                      Image=View;
                      OnAction=BEGIN
                                 ItemTracingMgt.ShowDocument("Record Identifier");
                               END;
                                }
      { 10      ;1   ;ActionGroup;
                      Name=Item;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 17      ;2   ;Action    ;
                      Name=Card;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Page 30;
                      RunPageLink=No.=FIELD(Item No.);
                      Image=EditLines }
      { 19      ;2   ;Action    ;
                      Name=LedgerEntries;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Finansp&oster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Page 38;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(Item No.);
                      Promoted=No;
                      Image=CustomerLedger;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 36      ;1   ;ActionGroup;
                      Name=Functions;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 59      ;2   ;Action    ;
                      Name=TraceOppositeFromLine;
                      CaptionML=[DAN=&Spor modsat - fra linje;
                                 ENU=&Trace Opposite - from Line];
                      ToolTipML=[DAN=Gentag den forrige sporing, men i modsat retning.;
                                 ENU=Repeat the previous trace, but going the opposite direction.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      Enabled=FunctionsEnable;
                      Image=TraceOppositeLine;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF TraceMethod = TraceMethod::"Origin->Usage" THEN
                                   TraceMethod := TraceMethod::"Usage->Origin"
                                 ELSE
                                   TraceMethod := TraceMethod::"Origin->Usage";
                                 OppositeTraceFromLine;
                               END;
                                }
      { 26      ;2   ;Action    ;
                      Name=SetFiltersWithLineValues;
                      CaptionML=[DAN=Indstil &filtre med linjev‘rdier;
                                 ENU=Set &Filters with Line Values];
                      ToolTipML=[DAN=Inds‘t v‘rdier for den valgte linje i de p†g‘ldende filterfelter i hovedet, og udf›r en ny sporing. Denne funktion er nyttig, f.eks., n†r en defekt vare oprindelse bliver fundet, og den aktuelle sporingslinje skal udg›re grundlaget for yderligere sporing med den samme sporingsmetode.;
                                 ENU=Insert the values of the selected line in the respective filter fields on the header and executes a new trace. This function is useful, for example, when the origin of the defective item is found and that particular trace line must form the basis of additional tracking with the same trace method.];
                      ApplicationArea=#ItemTracking;
                      Enabled=FunctionsEnable;
                      Image=FilterLines;
                      OnAction=BEGIN
                                 ItemTracingMgt.InitSearchParm(Rec,SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=Go to Already-Traced History;
                      CaptionML=[DAN=G† til allerede sporet historik;
                                 ENU=Go to Already-Traced History];
                      ToolTipML=[DAN=Vis historikken for varesporing.;
                                 ENU=View the item tracing history.];
                      ApplicationArea=#ItemTracking;
                      Enabled=FunctionsEnable;
                      Image=MoveUp;
                      OnAction=BEGIN
                                 SetFocus("Item Ledger Entry No.");
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Name=NextTraceResult;
                      CaptionML=[DAN=N‘ste sporingsresultat;
                                 ENU=Next Trace Result];
                      ToolTipML=[DAN="Vis n‘ste varetransaktion i sporingsretningen. ";
                                 ENU="View the next item transaction in the tracing direction. "];
                      ApplicationArea=#ItemTracking;
                      Image=NextRecord;
                      OnAction=BEGIN
                                 RecallHistory(1);
                               END;
                                }
      { 38      ;2   ;Action    ;
                      Name=PreviousTraceResult;
                      CaptionML=[DAN=Forrige sporingsresultat;
                                 ENU=Previous Trace Result];
                      ToolTipML=[DAN=Vis forrige varetransaktion i sporingsretningen.;
                                 ENU=View the previous item transaction in the tracing direction.];
                      ApplicationArea=#ItemTracking;
                      Image=PreviousRecord;
                      OnAction=BEGIN
                                 RecallHistory(-1);
                               END;
                                }
      { 16      ;1   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      Enabled=PrintEnable;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 xItemTracingBuffer@1002 : Record 6520;
                                 PrintTracking@1000 : Report 6520;
                               BEGIN
                                 CLEAR(PrintTracking);
                                 xItemTracingBuffer.COPY(Rec);
                                 PrintTracking.TransferEntries(Rec);
                                 COPY(xItemTracingBuffer);
                                 PrintTracking.RUN;
                               END;
                                }
      { 11      ;1   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      Enabled=NavigateEnable;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Navigate@1000 : Page 344;
                               BEGIN
                                 Navigate.SetTracking("Serial No.","Lot No.");
                                 Navigate.RUN;
                               END;
                                }
      { 20      ;1   ;Action    ;
                      Name=Trace;
                      CaptionML=[DAN=&Sporing;
                                 ENU=&Trace];
                      ToolTipML=[DAN=Spor, hvor en lot- eller et serienummer, som varen er blevet tildelt, blev anvendt, eksempelvis for at finde ud af, hvilket lot en defekt komponent stammer fra, eller for at finde alle de debitorer, som har modtaget varer, der indeholder den defekte komponent.;
                                 ENU=Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Trace;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 FindRecords;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000000001;1;Group  ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Serienr.filter;
                           ENU=Serial No. Filter];
                ToolTipML=[DAN=Angiver det serienummer eller et filter p† de serienumre, du vil spore.;
                           ENU=Specifies the serial number or a filter on the serial numbers that you would like to trace.];
                ApplicationArea=#ItemTracking;
                SourceExpr=SerialNoFilter;
                OnLookup=VAR
                           SerialNoInfo@1003 : Record 6504;
                           SerialNoList@1002 : Page 6509;
                         BEGIN
                           SerialNoInfo.RESET;

                           CLEAR(SerialNoList);
                           SerialNoList.SETTABLEVIEW(SerialNoInfo);
                           IF SerialNoList.RUNMODAL = ACTION::LookupOK THEN
                             SerialNoFilter := SerialNoList.GetSelectionFilter;
                         END;
                          }

    { 13  ;2   ;Field     ;
                CaptionML=[DAN=Lotnr.filter;
                           ENU=Lot No. Filter];
                ToolTipML=[DAN=Angiver det lotnummer eller et filter p† de lotnumre, du vil spore.;
                           ENU=Specifies the lot number or a filter on the lot numbers that you would like to trace.];
                ApplicationArea=#ItemTracking;
                SourceExpr=LotNoFilter;
                OnLookup=VAR
                           LotNoInfo@1002 : Record 6505;
                           LotNoList@1003 : Page 6508;
                         BEGIN
                           LotNoInfo.RESET;

                           CLEAR(LotNoList);
                           LotNoList.SETTABLEVIEW(LotNoInfo);
                           IF LotNoList.RUNMODAL = ACTION::LookupOK THEN
                             LotNoFilter := LotNoList.GetSelectionFilter;
                         END;
                          }

    { 1000000013;2;Field  ;
                CaptionML=[DAN=Varefilter;
                           ENU=Item Filter];
                ToolTipML=[DAN=Angiver det varenummer eller et filter p† de varenumre, du vil spore.;
                           ENU=Specifies the item number or a filter on the item numbers that you would like to trace.];
                ApplicationArea=#ItemTracking;
                SourceExpr=ItemNoFilter;
                OnValidate=BEGIN
                             IF ItemNoFilter = '' THEN
                               VariantFilter := '';
                           END;

                OnLookup=VAR
                           Item@1002 : Record 27;
                           ItemList@1003 : Page 31;
                         BEGIN
                           Item.RESET;

                           CLEAR(ItemList);
                           ItemList.SETTABLEVIEW(Item);
                           ItemList.LOOKUPMODE(TRUE);
                           IF ItemList.RUNMODAL = ACTION::LookupOK THEN
                             ItemNoFilter := ItemList.GetSelectionFilter;
                         END;
                          }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Variantfilter;
                           ENU=Variant Filter];
                ToolTipML=[DAN=Angiver den variantkode eller et filter p† de variantkoder, du vil spore.;
                           ENU=Specifies the variant code or a filter on the variant codes that you would like to trace.];
                ApplicationArea=#Advanced;
                SourceExpr=VariantFilter;
                OnValidate=BEGIN
                             IF ItemNoFilter = '' THEN
                               ERROR(Text001);
                           END;

                OnLookup=VAR
                           ItemVariant@1003 : Record 5401;
                           ItemVariants@1002 : Page 5401;
                         BEGIN
                           IF ItemNoFilter = '' THEN
                             ERROR(Text001);

                           ItemVariant.RESET;

                           CLEAR(ItemVariants);
                           ItemVariant.SETFILTER("Item No.",ItemNoFilter);
                           ItemVariants.SETTABLEVIEW(ItemVariant);
                           ItemVariants.LOOKUPMODE(TRUE);
                           IF ItemVariants.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             ItemVariants.GETRECORD(ItemVariant);
                             VariantFilter := ItemVariant.Code;
                           END;
                         END;
                          }

    { 25  ;2   ;Field     ;
                CaptionML=[DAN=Vis komponenter;
                           ENU=Show Components];
                ToolTipML=[DAN=Angiver, om du vil have vist komponenterne for den vare, du sporer.;
                           ENU=Specifies if you would like to see the components of the item that you are tracing.];
                OptionCaptionML=[DAN=Nej,Kun varesporing,Alle;
                                 ENU=No,Item-tracked Only,All];
                ApplicationArea=#ItemTracking;
                SourceExpr=ShowComponents }

    { 21  ;2   ;Field     ;
                CaptionML=[DAN=Sporingsmetode;
                           ENU=Trace Method];
                ToolTipML=[DAN=Angiver bogf›rte serienumre/lotnumre, der kan spores enten frem eller tilbage i en forsyningsk‘de.;
                           ENU=Specifies posted serial/lot numbers that can be traced either forward or backward in a supply chain.];
                OptionCaptionML=[DAN=Oprindelse -> Brug,Brug -> Oprindelse;
                                 ENU=Origin -> Usage,Usage -> Origin];
                ApplicationArea=#ItemTracking;
                SourceExpr=TraceMethod }

    { 35  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den tekst, der bruges til at spore varen.;
                           ENU=Specifies the text that is used to trace the item.];
                ApplicationArea=#ItemTracking;
                CaptionClass=FORMAT(TraceText);
                Editable=FALSE }

    { 1   ;1   ;Group     ;
                IndentationColumnName=DescriptionIndent;
                IndentationControls=Description;
                ShowAsTree=Yes;
                GroupType=Repeater }

    { 1000000015;2;Field  ;
                ToolTipML=[DAN=Angiver en beskrivelse af den sporede vare.;
                           ENU=Specifies a description of the traced item.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for den sporede post.;
                           ENU=Specifies the type of the traced entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Entry Type";
                Visible=FALSE }

    { 1000000034;2;Field  ;
                ToolTipML=[DAN=Angiver det serienummer, der skal spores.;
                           ENU=Specifies the serial number to be traced.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Editable=FALSE;
                Style=Strong }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sporede lotnummer.;
                           ENU=Specifies the traced lot number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Editable=FALSE;
                Style=Strong }

    { 1000000030;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret p† den sporede vare.;
                           ENU=Specifies the number of the traced item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Item No.";
                Editable=FALSE;
                Style=Strong }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of the item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Item Description";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 1000000032;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret p† det sporede bilag.;
                           ENU=Specifies the number of the traced document.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Document No.";
                Visible=FALSE }

    { 1000000043;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor den sporede vare blev bogf›rt.;
                           ENU=Specifies the date when the traced item was posted.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 1000000017;2;Field  ;
                ToolTipML=[DAN=Angiver recordens type, f.eks. Salgshoved, som varen er sporet fra.;
                           ENU=Specifies the type of record, such as Sales Header, that the item is traced from.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Source Type";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Source No.";
                Visible=FALSE;
                Editable=FALSE }

    { 1000000003;2;Field  ;
                ToolTipML=[DAN=Angiver navnet p† den record, som varen er sporet fra.;
                           ENU=Specifies the name of the record that the item is traced from.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Source Name";
                Visible=FALSE;
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationen p† den sporede vare.;
                           ENU=Specifies the location of the traced item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Location Code";
                Editable=FALSE }

    { 1000000021;2;Field  ;
                ToolTipML=[DAN=Angiver antallet af den sporede vare p† linjen.;
                           ENU=Specifies the quantity of the traced item in the line.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Quantity;
                OnDrillDown=VAR
                              ItemLedgerEntry@1000000000 : Record 32;
                            BEGIN
                              ItemLedgerEntry.RESET;
                              ItemLedgerEntry.SETRANGE("Entry No.","Item Ledger Entry No.");
                              PAGE.RUNMODAL(0,ItemLedgerEntry);
                            END;
                             }

    { 1000000019;2;Field  ;
                ToolTipML=[DAN=Angiver antallet i feltet Antal, der mangler at blive behandlet.;
                           ENU=Specifies the quantity in the Quantity field that remains to be processed.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Remaining Quantity" }

    { 1000000023;2;Field  ;
                Lookup=Yes;
                ToolTipML=[DAN=Angiver den bruger, der oprettede den sporede record.;
                           ENU=Specifies the user who created the traced record.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Created by";
                Visible=FALSE }

    { 1000000025;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor den sporede record blev oprettet.;
                           ENU=Specifies the date when the traced record was created.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Created on";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der allerede er sporet en supplerende transaktionsoversigt under denne linje af andre linjer over den.;
                           ENU=Specifies if additional transaction history under this line has already been traced by other lines above it.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Already Traced" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den sporede vares finanspost.;
                           ENU=Specifies the number of the traced item ledger entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Item Ledger Entry No.";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den overordnede for den sporede vares finanspost.;
                           ENU=Specifies the parent of the traced item ledger entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Parent Item Ledger Entry No.";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      TempTrackEntry@1000 : TEMPORARY Record 6520;
      ItemTracingMgt@1017 : Codeunit 6520;
      TraceMethod@1004 : 'Origin->Usage,Usage->Origin';
      ShowComponents@1000000002 : 'No,Item-tracked Only,All';
      ActualExpansionStatus@1009 : 'Has Children,Expanded,No Children';
      SerialNoFilter@1000000009 : Text;
      LotNoFilter@1006 : Text;
      ItemNoFilter@1000000007 : Text;
      VariantFilter@1001 : Text;
      Text001@1002 : TextConst 'DAN=Der skal angives et varenummerfilter.;ENU=Item No. Filter is required.';
      TraceText@1005 : Text;
      Text002@1007 : TextConst 'DAN=Serienr.: %1, Lotnr.: %2, Vare: %3, Variant: %4, Sporingsmetode: %5, Vis komponenter: %6;ENU=Serial No.: %1, Lot No.: %2, Item: %3, Variant: %4, Trace Method: %5, Show Components: %6';
      PreviousExists@1010 : Boolean;
      NextExists@1012 : Boolean;
      Text003@1008 : TextConst 'DAN=Filtrene er for store til at blive vist.;ENU=Filters are too large to show.';
      Text004@1003 : TextConst 'DAN=Oprindelse->Brug,Brug->Oprindelse;ENU=Origin->Usage,Usage->Origin';
      Text005@1013 : TextConst 'DAN=Nej,Kun varesporing,Alle;ENU=No,Item-tracked Only,All';
      DescriptionIndent@19057867 : Integer INDATASET;
      FunctionsEnable@19066687 : Boolean INDATASET;
      PrintEnable@19037407 : Boolean INDATASET;
      NavigateEnable@19005834 : Boolean INDATASET;

    [External]
    PROCEDURE FindRecords@1000000001();
    BEGIN
      ItemTracingMgt.FindRecords(TempTrackEntry,Rec,
        SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter,
        TraceMethod,ShowComponents);
      InitButtons;

      ItemTracingMgt.GetHistoryStatus(PreviousExists,NextExists);

      UpdateTraceText;

      ItemTracingMgt.ExpandAll(TempTrackEntry,Rec);
      CurrPage.UPDATE(FALSE)
    END;

    LOCAL PROCEDURE OppositeTraceFromLine@1();
    BEGIN
      ItemTracingMgt.InitSearchParm(Rec,SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter);
      FindRecords;
    END;

    [External]
    PROCEDURE InitButtons@7();
    BEGIN
      IF NOT TempTrackEntry.FINDFIRST THEN BEGIN
        FunctionsEnable := FALSE;
        PrintEnable := FALSE;
        NavigateEnable := FALSE;
      END ELSE BEGIN
        FunctionsEnable := TRUE;
        PrintEnable := TRUE;
        NavigateEnable := TRUE;
      END;
    END;

    [External]
    PROCEDURE InitFilters@4(VAR ItemTrackingEntry@1000 : Record 6520);
    BEGIN
      SerialNoFilter := ItemTrackingEntry.GETFILTER("Serial No.");
      LotNoFilter := ItemTrackingEntry.GETFILTER("Lot No.");
      ItemNoFilter := ItemTrackingEntry.GETFILTER("Item No.");
      VariantFilter := ItemTrackingEntry.GETFILTER("Variant Code");
      TraceMethod := TraceMethod::"Usage->Origin";
      ShowComponents := ShowComponents::"Item-tracked Only";
    END;

    LOCAL PROCEDURE RecallHistory@2(Steps@1000 : Integer);
    BEGIN
      ItemTracingMgt.RecallHistory(Steps,TempTrackEntry,Rec,SerialNoFilter,
        LotNoFilter,ItemNoFilter,VariantFilter,TraceMethod,ShowComponents);
      UpdateTraceText;
      InitButtons;
      ItemTracingMgt.GetHistoryStatus(PreviousExists,NextExists);

      ItemTracingMgt.ExpandAll(TempTrackEntry,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE UpdateTraceText@3();
    VAR
      LengthOfText@1001 : Integer;
      Overflow@1000 : Boolean;
    BEGIN
      LengthOfText := (STRLEN(Text002 + SerialNoFilter + LotNoFilter + ItemNoFilter + VariantFilter) +
                       STRLEN(FORMAT(TraceMethod)) + STRLEN(FORMAT(ShowComponents)) - 6); // 6 = number of positions in Text002

      Overflow := LengthOfText > 512;

      IF Overflow THEN
        TraceText := Text003
      ELSE
        TraceText := STRSUBSTNO(Text002,SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter,
            SELECTSTR(TraceMethod + 1,Text004) ,SELECTSTR(ShowComponents + 1,Text005));
    END;

    LOCAL PROCEDURE DescriptionOnFormat@19023855();
    BEGIN
      DescriptionIndent := Level;
    END;

    LOCAL PROCEDURE SetFocus@5(ItemLedgerEntryNo@1000 : Integer);
    BEGIN
      IF "Already Traced" THEN BEGIN
        TempTrackEntry.SETCURRENTKEY("Item Ledger Entry No.");
        TempTrackEntry.SETRANGE("Item Ledger Entry No.",ItemLedgerEntryNo);
        TempTrackEntry.FINDFIRST;
        CurrPage.SETRECORD(TempTrackEntry);
      END;
    END;

    BEGIN
    END.
  }
}

