OBJECT Page 521 Application Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udligningskladde;
               ENU=Application Worksheet];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table32;
    PageType=Worksheet;
    OnOpenPage=BEGIN
                 Apply.SetCalledFromApplicationWorksheet(TRUE);
                 ReapplyTouchedEntries; // in case OnQueryClosePage trigger was not executed due to a sudden crash

                 InventoryPeriod.IsValidDate(InventoryOpenedFrom);
                 IF InventoryOpenedFrom <> 0D THEN
                   IF GETFILTER("Posting Date") = '' THEN
                     SETFILTER("Posting Date",'%1..',CALCDATE('<+1D>',InventoryOpenedFrom))
                   ELSE BEGIN
                     IF GETFILTER("Posting Date") <> STRSUBSTNO('%1..',CALCDATE('<+1D>',InventoryOpenedFrom)) THEN
                       SETFILTER("Posting Date",
                         STRSUBSTNO('%2&%1..',CALCDATE('<+1D>',InventoryOpenedFrom),GETFILTER("Posting Date")))
                   END;

                 UpdateFilterFields;
               END;

    OnFindRecord=VAR
                   Found@1000 : Boolean;
                 BEGIN
                   Found := FIND(Which);
                   IF NOT Found THEN ;
                   EXIT(Found);
                 END;

    OnQueryClosePage=BEGIN
                       IF Apply.AnyTouchedEntries THEN BEGIN
                         IF NOT CONFIRM(Text003) THEN
                           EXIT(FALSE);

                         UnblockItems;
                         Reapplyall;
                       END;

                       EXIT(TRUE);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateFilterFields;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&is;
                                 ENU=V&iew];
                      Image=View }
      { 28      ;2   ;Action    ;
                      Name=AppliedEntries;
                      ShortCutKey=F9;
                      CaptionML=[DAN=Udlignede poster;
                                 ENU=Applied Entries];
                      ToolTipML=[DAN=Vis finansposter, der er godkendt for denne record.;
                                 ENU=View the ledger entries that have been applied to this record.];
                      ApplicationArea=#Advanced;
                      Image=Approve;
                      OnAction=BEGIN
                                 CLEAR(ApplicationsForm);
                                 ApplicationsForm.SetRecordToShow(Rec,Apply,TRUE);
                                 ApplicationsForm.RUN;
                                 InsertUnapplyItem("Item No.");
                                 CurrPage.UPDATE;
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=UnappliedEntries;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=Ikke-udlignede poster;
                                 ENU=Unapplied Entries];
                      ToolTipML=[DAN=Vis poster, du har annulleret.;
                                 ENU=View entries that you have unapplied.];
                      ApplicationArea=#Advanced;
                      Image=Entries;
                      OnAction=BEGIN
                                 CLEAR(ApplicationsForm);
                                 ApplicationsForm.SetRecordToShow(Rec,Apply,FALSE);
                                 ApplicationsForm.LOOKUPMODE := TRUE;
                                 IF ApplicationsForm.RUNMODAL = ACTION::LookupOK THEN
                                   ApplicationsForm.ApplyRec;

                                 CurrPage.UPDATE;
                               END;
                                }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 37      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 48      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&V‘rdiposter;
                                 ENU=&Value Entries];
                      ToolTipML=[DAN=F† vist historikken over bogf›rte bel›b, der p†virker v‘rdien af varen. V‘rdiposter oprettes for hver transaktion med varen.;
                                 ENU=View the history of posted amounts that affect the value of the item. Value entries are created for every transaction with the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Item Ledger Entry No.);
                      RunPageLink=Item Ledger Entry No.=FIELD(Entry No.);
                      Image=ValueLedger }
      { 38      ;2   ;Action    ;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=Reservationsposter;
                                 ENU=Reservation Entries];
                      ToolTipML=[DAN=Vis posterne for hver reservation, der er foretaget, enten manuelt eller automatisk.;
                                 ENU=View the entries for every reservation that is made, either manually or automatically.];
                      ApplicationArea=#Advanced;
                      Image=ReservationLedger;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 30      ;1   ;ActionGroup;
                      Name=Functions;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Udl&ign igen;
                                 ENU=Rea&pply];
                      ToolTipML=[DAN=Anvend poster, du har fjernet.;
                                 ENU=Reapply entries that you have removed.];
                      ApplicationArea=#Advanced;
                      Image=Action;
                      OnAction=BEGIN
                                 Reapplyall;
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=UndoApplications;
                      CaptionML=[DAN=Fortryd manuelle ‘ndringer;
                                 ENU=Undo Manual Changes];
                      ToolTipML=[DAN=Fortryd din tidligere ‘ndring af programmet.;
                                 ENU=Undo your previous application change.];
                      ApplicationArea=#Advanced;
                      Image=Restore;
                      OnAction=BEGIN
                                 IF Apply.ApplicationLogIsEmpty THEN BEGIN
                                   MESSAGE(NothingToRevertMsg);
                                   EXIT;
                                 END;

                                 IF CONFIRM(RevertAllQst) THEN BEGIN
                                   Apply.UndoApplications;
                                   MESSAGE(RevertCompletedMsg);
                                 END
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 59  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 68  ;2   ;Field     ;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver det datointerval, v‘rdierne skal filtreres efter.;
                           ENU=Specifies the date interval by which values are filtered.];
                ApplicationArea=#Advanced;
                SourceExpr=DateFilter;
                OnValidate=VAR
                             ApplicationManagement@1002 : Codeunit 1;
                           BEGIN
                             IF ApplicationManagement.MakeDateFilter(DateFilter) = 0 THEN;
                             SETFILTER("Posting Date",DateFilter);
                             DateFilter := GETFILTER("Posting Date");
                             DateFilterOnAfterValidate;
                           END;
                            }

    { 73  ;2   ;Field     ;
                Name=Item Filter;
                CaptionML=[DAN=Varefilter;
                           ENU=Item Filter];
                ToolTipML=[DAN=Angiver et filter for at begr‘nse vareposterne i den f›rste tabel i udligningskladden til dem, der har de kr‘vede varenumre.;
                           ENU=Specifies a filter to limit the item ledger entries in the first table of the application worksheet to those that have item numbers.];
                ApplicationArea=#Advanced;
                SourceExpr=ItemFilter;
                TableRelation=Item;
                OnValidate=BEGIN
                             ItemFilterOnAfterValidate;
                           END;

                OnLookup=VAR
                           ItemList@1002 : Page 31;
                         BEGIN
                           ItemList.LOOKUPMODE(TRUE);
                           IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             Text := ItemList.GetSelectionFilter;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 64  ;2   ;Field     ;
                CaptionML=[DAN=Bilagsnummerfilter;
                           ENU=Document No. Filter];
                ToolTipML=[DAN=Angiver et filter for at begr‘nse vareposterne i den f›rste tabel i udligningskladden til dem, der har de kr‘vede bilagsnumre.;
                           ENU=Specifies a filter to limit the item ledger entries in the first table of the application worksheet, to those that have document numbers.];
                ApplicationArea=#Advanced;
                SourceExpr=DocumentFilter;
                OnValidate=BEGIN
                             SETFILTER("Document No.",DocumentFilter);
                             DocumentFilter := GETFILTER("Document No.");
                             DocumentFilterOnAfterValidate;
                           END;
                            }

    { 78  ;2   ;Field     ;
                CaptionML=[DAN=Lokationsfilter;
                           ENU=Location Filter];
                ToolTipML=[DAN=Angiver et filter for at begr‘nse vareposterne i den f›rste tabel i udligningskladden til dem, der har de kr‘vede lokationer.;
                           ENU=Specifies a filter to limit the item ledger entries in the first table of the application worksheet to those that have locations.];
                ApplicationArea=#Advanced;
                SourceExpr=LocationFilter;
                TableRelation=Location;
                OnValidate=BEGIN
                             SETFILTER("Location Code",LocationFilter);
                             LocationFilter := GETFILTER("Location Code");
                             LocationFilterOnAfterValidate;
                           END;

                OnLookup=VAR
                           LocationList@1002 : Page 15;
                         BEGIN
                           LocationList.LOOKUPMODE(TRUE);
                           IF LocationList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             Text := LocationList.GetSelectionFilter;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 1   ;1   ;Group     ;
                Enabled=TRUE;
                Editable=FALSE;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† varen i posten.;
                           ENU=Specifies the number of the item in the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No." }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† posten. Dokumentet er det regnskabsbilag, posten er baseret p†, f.eks. en kvittering.;
                           ENU=Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som posten er tilknyttet.;
                           ENU=Specifies the code for the location that the entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion posten er oprettet ud fra.;
                           ENU=Specifies which type of transaction that the entry is created from.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Type" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kildetype, der g‘lder for det kildenummer, der er vist i feltet Kildenr.;
                           ENU=Specifies the source type that applies to the source number, shown in the Source No. field.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Type" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type bilag der blev bogf›rt for at oprette vareposten.;
                           ENU=Specifies what type of document was posted to create the item ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Type" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den linje i det bogf›rte bilag, der svarer til vareposten.;
                           ENU=Specifies the number of the line on the posted document that corresponds to the item ledger entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Line No.";
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et serienummer, hvis den bogf›rte vare har et s†dant nummer.;
                           ENU=Specifies a serial number if the posted item carries such a number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et lotnummer, hvis den bogf›rte vare har et s†dant nummer.;
                           ENU=Specifies a lot number if the posted item carries such a number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor posten stammer fra.;
                           ENU=Specifies where the entry originated.];
                ApplicationArea=#Advanced;
                SourceExpr="Source No." }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Description;
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal vareenheder, der indg†r i vareposten.;
                           ENU=Specifies the number of units of the item in the item entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Quantity }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i feltet Antal, der mangler at blive behandlet.;
                           ENU=Specifies the quantity in the Quantity field that remains to be processed.];
                ApplicationArea=#Advanced;
                SourceExpr="Remaining Quantity" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet faktureret.;
                           ENU=Specifies how many units of the item on the line have been invoiced.];
                ApplicationArea=#Advanced;
                SourceExpr="Invoiced Quantity" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet faktureret.;
                           ENU=Specifies how many units of the item on the line have been reserved.];
                ApplicationArea=#Advanced;
                SourceExpr="Reserved Quantity" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for denne varepost, som blev leveret, og som endnu ikke er blevet returneret.;
                           ENU=Specifies the quantity for this item ledger entry that was shipped and has not yet been returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipped Qty. Not Returned" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den regulerede kostpris i RV for antalsbogf›ringen.;
                           ENU=Specifies the adjusted cost, in LCY, of the quantity posting.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount (Actual)" }

    { 66  ;2   ;Field     ;
                CaptionML=[DAN=Kostpris (RV);
                           ENU=Unit Cost(LCY)];
                ToolTipML=[DAN="Angiver omkostningen for ‚n enhed af varen. ";
                           ENU="Specifies the cost of one unit of the item. "];
                ApplicationArea=#Advanced;
                SourceExpr=GetUnitCostLCY;
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er fuldt udlignet.;
                           ENU=Specifies whether the entry has been fully applied to.];
                ApplicationArea=#Advanced;
                SourceExpr=Open }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen i vareposten er positiv.;
                           ENU=Specifies whether the item in the item ledge entry is positive.];
                ApplicationArea=#Advanced;
                SourceExpr=Positive }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om antallet p† kladdelinjen skal udlignes med en allerede bogf›rt post. Hvis det er tilf‘ldet, skal du angive det l›benummer, som antallet skal udlignes efter.;
                           ENU=Specifies if the quantity on the journal line must be applied to an already-posted entry. In that case, enter the entry number that the quantity will be applied to.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to Entry";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der er en eller flere udlignede poster, der skal reguleres.;
                           ENU=Specifies whether there is one or more applied entries, which need to be adjusted.];
                ApplicationArea=#Advanced;
                SourceExpr="Applied Entry to Adjust";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No." }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1903523907;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=Entry No.=FIELD(Entry No.);
                PagePartID=Page9125;
                Visible=FALSE;
                PartType=Page }

  }
  CODE
  {
    VAR
      InventoryPeriod@1010 : Record 5814;
      TempUnapplyItem@1001 : TEMPORARY Record 27;
      Apply@1003 : Codeunit 22;
      ApplicationsForm@1000 : Page 522;
      InventoryOpenedFrom@1011 : Date;
      DateFilter@1015 : Text;
      ItemFilter@1017 : Text;
      LocationFilter@1018 : Text;
      DocumentFilter@1020 : Text;
      Text003@1021 : TextConst 'DAN=N†r vinduet er lukket, s›ger systemet efter †bne poster og udligner dem igen.\Vil du lukke vinduet?;ENU=After the window is closed, the system will check for and reapply open entries.\Do you want to close the window?';
      RevertAllQst@1002 : TextConst 'DAN=Er du sikker p†, at du vil annullere alle ‘ndringer?;ENU=Are you sure that you want to undo all changes?';
      NothingToRevertMsg@1004 : TextConst 'DAN=Der er intet at fortryde.;ENU=Nothing to undo.';
      RevertCompletedMsg@1006 : TextConst 'DAN=’ndringerne er annulleret.;ENU=The changes have been undone.';

    LOCAL PROCEDURE UpdateFilterFields@8();
    BEGIN
      ItemFilter := GETFILTER("Item No.");
      LocationFilter := GETFILTER("Location Code");
      DateFilter := GETFILTER("Posting Date");
      DocumentFilter := GETFILTER("Document No.");
    END;

    LOCAL PROCEDURE Reapplyall@1();
    BEGIN
      Apply.RedoApplications;
      Apply.CostAdjust;
      Apply.ClearApplicationLog;
    END;

    LOCAL PROCEDURE ReapplyTouchedEntries@2();
    BEGIN
      Apply.RestoreTouchedEntries(TempUnapplyItem);

      IF Apply.AnyTouchedEntries THEN BEGIN
        UnblockItems;
        Reapplyall;
      END;
    END;

    [External]
    PROCEDURE SetRecordToShow@7(RecordToSet@1000 : Record 32);
    BEGIN
      Rec := RecordToSet;
    END;

    LOCAL PROCEDURE LocationFilterOnAfterValidate@19070361();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE DateFilterOnAfterValidate@19006009();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ItemFilterOnAfterValidate@19051257();
    BEGIN
      SETFILTER("Item No.",ItemFilter);
      ItemFilter := GETFILTER("Item No.");
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE InsertUnapplyItem@3(ItemNo@1000 : Code[20]);
    BEGIN
      WITH TempUnapplyItem DO
        IF NOT GET(ItemNo) THEN BEGIN
          INIT;
          "No." := ItemNo;
          INSERT;
        END;
    END;

    LOCAL PROCEDURE UnblockItems@6();
    VAR
      Item@1000 : Record 27;
    BEGIN
      WITH TempUnapplyItem DO BEGIN
        IF FINDSET THEN
          REPEAT
            Item.GET("No.");
            IF Item."Application Wksh. User ID" = UPPERCASE(USERID) THEN BEGIN
              Item."Application Wksh. User ID" := '';
              Item.MODIFY;
            END;
          UNTIL NEXT = 0;

        DELETEALL;
      END;
    END;

    LOCAL PROCEDURE DocumentFilterOnAfterValidate@19003250();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

