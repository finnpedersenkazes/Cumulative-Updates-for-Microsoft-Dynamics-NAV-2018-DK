OBJECT Page 6510 Item Tracking Lines
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varesporingslinjer;
               ENU=Item Tracking Lines];
    SourceTable=Table336;
    DelayedInsert=Yes;
    PopulateAllFields=Yes;
    DataCaptionFields=Item No.,Variant Code,Description;
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             WarrantyDateEditable := TRUE;
             ExpirationDateEditable := TRUE;
             NewExpirationDateEditable := TRUE;
             NewLotNoEditable := TRUE;
             NewSerialNoEditable := TRUE;
             DescriptionEditable := TRUE;
             LotNoEditable := TRUE;
             SerialNoEditable := TRUE;
             QuantityBaseEditable := TRUE;
             QtyToInvoiceBaseEditable := TRUE;
             QtyToHandleBaseEditable := TRUE;
             FunctionsDemandVisible := TRUE;
             FunctionsSupplyVisible := TRUE;
             ButtonLineVisible := TRUE;
             QtyToInvoiceBaseVisible := TRUE;
             Invoice3Visible := TRUE;
             Invoice2Visible := TRUE;
             Invoice1Visible := TRUE;
             QtyToHandleBaseVisible := TRUE;
             Handle3Visible := TRUE;
             Handle2Visible := TRUE;
             Handle1Visible := TRUE;
             LocationCodeEditable := TRUE;
             VariantCodeEditable := TRUE;
             ItemNoEditable := TRUE;
             InboundIsSet := FALSE;
             ApplFromItemEntryVisible := FALSE;
             ApplToItemEntryVisible := FALSE;
           END;

    OnOpenPage=BEGIN
                 ItemNoEditable := FALSE;
                 VariantCodeEditable := FALSE;
                 LocationCodeEditable := FALSE;
                 IF InboundIsSet THEN BEGIN
                   ApplFromItemEntryVisible := Inbound;
                   ApplToItemEntryVisible := NOT Inbound;
                 END;

                 UpdateUndefinedQtyArray;

                 CurrentFormIsOpen := TRUE;
               END;

    OnClosePage=BEGIN
                  IF UpdateUndefinedQty THEN
                    WriteToDatabase;
                  IF FormRunMode = FormRunMode::"Drop Shipment" THEN
                    CASE CurrentSourceType OF
                      DATABASE::"Sales Line":
                        SynchronizeLinkedSources(STRSUBSTNO(Text015,Text016));
                      DATABASE::"Purchase Line":
                        SynchronizeLinkedSources(STRSUBSTNO(Text015,Text017));
                    END;
                  IF FormRunMode = FormRunMode::Transfer THEN
                    SynchronizeLinkedSources('');
                  SynchronizeWarehouseItemTracking;
                END;

    OnAfterGetRecord=BEGIN
                       ExpirationDateOnFormat;
                     END;

    OnNewRecord=BEGIN
                  "Qty. per Unit of Measure" := QtyPerUOM;
                END;

    OnInsertRecord=BEGIN
                     IF "Entry No." <> 0 THEN
                       EXIT(FALSE);
                     "Entry No." := NextEntryNo;
                     IF (NOT InsertIsBlocked) AND (NOT ZeroLineExists) THEN
                       IF VerifyNewTrackingSpecification THEN BEGIN
                         TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                         TempItemTrackLineInsert.INSERT;
                         INSERT;
                         ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                           TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
                       END;
                     CalculateSums;

                     EXIT(FALSE);
                   END;

    OnModifyRecord=VAR
                     xTempTrackingSpec@1000 : TEMPORARY Record 336;
                   BEGIN
                     IF InsertIsBlocked THEN
                       IF (xRec."Lot No." <> "Lot No.") OR
                          (xRec."Serial No." <> "Serial No.") OR
                          (xRec."Quantity (Base)" <> "Quantity (Base)")
                       THEN
                         EXIT(FALSE);

                     IF VerifyNewTrackingSpecification THEN BEGIN
                       MODIFY;

                       IF (xRec."Lot No." <> "Lot No.") OR (xRec."Serial No." <> "Serial No.") THEN BEGIN
                         xTempTrackingSpec := xRec;
                         ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                           xTempTrackingSpec,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,2);
                       END;

                       IF TempItemTrackLineModify.GET("Entry No.") THEN
                         TempItemTrackLineModify.DELETE;
                       IF TempItemTrackLineInsert.GET("Entry No.") THEN BEGIN
                         TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                         TempItemTrackLineInsert.MODIFY;
                         ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                           TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,1);
                       END ELSE BEGIN
                         TempItemTrackLineModify.TRANSFERFIELDS(Rec);
                         TempItemTrackLineModify.INSERT;
                         ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                           TempItemTrackLineModify,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,1);
                       END;
                     END;
                     CalculateSums;

                     EXIT(FALSE);
                   END;

    OnDeleteRecord=VAR
                     TrackingSpec@1002 : Record 336;
                     WMSManagement@1001 : Codeunit 7302;
                     AlreadyDeleted@1000 : Boolean;
                   BEGIN
                     TrackingSpec."Item No." := "Item No.";
                     TrackingSpec."Location Code" := "Location Code";
                     TrackingSpec."Source Type" := "Source Type";
                     TrackingSpec."Source Subtype" := "Source Subtype";
                     WMSManagement.CheckItemTrackingChange(TrackingSpec,Rec);

                     IF NOT DeleteIsBlocked THEN BEGIN
                       AlreadyDeleted := TempItemTrackLineDelete.GET("Entry No.");
                       TempItemTrackLineDelete.TRANSFERFIELDS(Rec);
                       DELETE(TRUE);

                       IF NOT AlreadyDeleted THEN
                         TempItemTrackLineDelete.INSERT;
                       ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
                         TempItemTrackLineDelete,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,2);
                       IF TempItemTrackLineInsert.GET("Entry No.") THEN
                         TempItemTrackLineInsert.DELETE;
                       IF TempItemTrackLineModify.GET("Entry No.") THEN
                         TempItemTrackLineModify.DELETE;
                     END;
                     CalculateSums;

                     EXIT(FALSE);
                   END;

    OnQueryClosePage=BEGIN
                       IF NOT UpdateUndefinedQty THEN
                         EXIT(CONFIRM(Text006));

                       IF NOT ItemTrackingDataCollection.RefreshTrackingAvailability(Rec,FALSE) THEN BEGIN
                         CurrPage.UPDATE;
                         EXIT(CONFIRM(Text019,TRUE));
                       END;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateExpDateEditable;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 66      ;1   ;ActionGroup;
                      Name=ButtonLineReclass;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Visible=ButtonLineReclassVisible;
                      Image=Line }
      { 67      ;2   ;Action    ;
                      Name=Reclass_SerialNoInfoCard;
                      CaptionML=[DAN=Serienr.oplysningskort;
                                 ENU=Serial No. Information Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om serienummeret.;
                                 ENU=View or edit detailed information about the serial number.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Page 6509;
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Serial No.=FIELD(Serial No.);
                      Image=SNInfo;
                      OnAction=BEGIN
                                 TESTFIELD("Serial No.");
                               END;
                                }
      { 68      ;2   ;Action    ;
                      Name=Reclass_LotNoInfoCard;
                      CaptionML=[DAN=Lotnr.oplysningskort;
                                 ENU=Lot No. Information Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om lotnummeret.;
                                 ENU=View or edit detailed information about the lot number.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Page 6508;
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Lot No.=FIELD(Lot No.);
                      Image=LotInfo;
                      OnAction=BEGIN
                                 TESTFIELD("Lot No.");
                               END;
                                }
      { 69      ;2   ;Separator  }
      { 70      ;2   ;Action    ;
                      Name=NewSerialNoInformation;
                      CaptionML=[DAN=Nye s&erienr.oplysninger;
                                 ENU=New S&erial No. Information];
                      ToolTipML=[DAN=Opret en record med detaljerede oplysninger om serienummeret.;
                                 ENU=Create a record with detailed information about the serial number.];
                      ApplicationArea=#ItemTracking;
                      Image=NewSerialNoProperties;
                      OnAction=VAR
                                 SerialNoInfoNew@1000 : Record 6504;
                                 SerialNoInfoForm@1001 : Page 6504;
                               BEGIN
                                 TESTFIELD("New Serial No.");

                                 CLEAR(SerialNoInfoForm);
                                 SerialNoInfoForm.Init(Rec);

                                 SerialNoInfoNew.SETRANGE("Item No.","Item No.");
                                 SerialNoInfoNew.SETRANGE("Variant Code","Variant Code");
                                 SerialNoInfoNew.SETRANGE("Serial No.","New Serial No.");

                                 SerialNoInfoForm.SETTABLEVIEW(SerialNoInfoNew);
                                 SerialNoInfoForm.RUN;
                               END;
                                }
      { 71      ;2   ;Action    ;
                      Name=NewLotNoInformation;
                      CaptionML=[DAN=Nye l&otnr.oplysninger;
                                 ENU=New L&ot No. Information];
                      ToolTipML=[DAN=Opret en record med detaljerede oplysninger om lotnummeret.;
                                 ENU=Create a record with detailed information about the lot number.];
                      ApplicationArea=#ItemTracking;
                      RunPageOnRec=No;
                      Image=NewLotProperties;
                      OnAction=VAR
                                 LotNoInfoNew@1000 : Record 6505;
                                 LotNoInfoForm@1001 : Page 6505;
                               BEGIN
                                 TESTFIELD("New Lot No.");

                                 CLEAR(LotNoInfoForm);
                                 LotNoInfoForm.Init(Rec);

                                 LotNoInfoNew.SETRANGE("Item No.","Item No.");
                                 LotNoInfoNew.SETRANGE("Variant Code","Variant Code");
                                 LotNoInfoNew.SETRANGE("Lot No.","New Lot No.");

                                 LotNoInfoForm.SETTABLEVIEW(LotNoInfoNew);
                                 LotNoInfoForm.RUN;
                               END;
                                }
      { 72      ;1   ;ActionGroup;
                      Name=ButtonLine;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Visible=ButtonLineVisible;
                      Image=Line }
      { 73      ;2   ;Action    ;
                      Name=Line_SerialNoInfoCard;
                      CaptionML=[DAN=Serienr.oplysningskort;
                                 ENU=Serial No. Information Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om serienummeret.;
                                 ENU=View or edit detailed information about the serial number.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Page 6509;
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Serial No.=FIELD(Serial No.);
                      Image=SNInfo;
                      OnAction=BEGIN
                                 TESTFIELD("Serial No.");
                               END;
                                }
      { 74      ;2   ;Action    ;
                      Name=Line_LotNoInfoCard;
                      CaptionML=[DAN=Lotnr.oplysningskort;
                                 ENU=Lot No. Information Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om lotnummeret.;
                                 ENU=View or edit detailed information about the lot number.];
                      ApplicationArea=#ItemTracking;
                      RunObject=Page 6508;
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Lot No.=FIELD(Lot No.);
                      Image=LotInfo;
                      OnAction=BEGIN
                                 TESTFIELD("Lot No.");
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 50      ;1   ;ActionGroup;
                      Name=FunctionsSupply;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Visible=FunctionsSupplyVisible;
                      Image=Action }
      { 51      ;2   ;Action    ;
                      Name=Assign Serial No.;
                      CaptionML=[DAN=Tildel &serienr.;
                                 ENU=Assign &Serial No.];
                      ToolTipML=[DAN=Tildel automatisk de p�kr�vede serienumre fra foruddefinerede nummerserier.;
                                 ENU=Automatically assign the required serial numbers from predefined number series.];
                      ApplicationArea=#ItemTracking;
                      Image=SerialNo;
                      OnAction=BEGIN
                                 IF InsertIsBlocked THEN
                                   EXIT;
                                 AssignSerialNo;
                               END;
                                }
      { 52      ;2   ;Action    ;
                      Name=Assign Lot No.;
                      CaptionML=[DAN=Tildel &lotnr.;
                                 ENU=Assign &Lot No.];
                      ToolTipML=[DAN=Tildel automatisk de p�kr�vede lotnumre fra foruddefinerede nummerserier.;
                                 ENU=Automatically assign the required lot numbers from predefined number series.];
                      ApplicationArea=#ItemTracking;
                      Image=Lot;
                      OnAction=BEGIN
                                 IF InsertIsBlocked THEN
                                   EXIT;
                                 AssignLotNo;
                               END;
                                }
      { 77      ;2   ;Action    ;
                      CaptionML=[DAN=Opret brugerdef. serienr.;
                                 ENU=Create Customized SN];
                      ToolTipML=[DAN=Tilknyt automatisk de p�kr�vede serienumre ud fra en nummerserie, som du selv definerer.;
                                 ENU=Automatically assign the required serial numbers based on a number series that you define.];
                      ApplicationArea=#ItemTracking;
                      Image=CreateSerialNo;
                      OnAction=BEGIN
                                 IF InsertIsBlocked THEN
                                   EXIT;
                                 CreateCustomizedSN;
                               END;
                                }
      { 79      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater disponering;
                                 ENU=Refresh Availability];
                      ToolTipML=[DAN="Opdater oplysningerne om tilg�ngelighed i overensstemmelse med �ndringer foretaget af andre brugere, siden du �bnede vinduet. ";
                                 ENU="Update the availability information according to changes made by other users since you opened the window. "];
                      ApplicationArea=#ItemTracking;
                      Image=Refresh;
                      OnAction=BEGIN
                                 ItemTrackingDataCollection.RefreshTrackingAvailability(Rec,TRUE);
                               END;
                                }
      { 43      ;1   ;ActionGroup;
                      Name=FunctionsDemand;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Visible=FunctionsDemandVisible;
                      Image=Action }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Tildel &serienr.;
                                 ENU=Assign &Serial No.];
                      ToolTipML=[DAN=Tildel automatisk de p�kr�vede serienumre fra foruddefinerede nummerserier.;
                                 ENU=Automatically assign the required serial numbers from predefined number series.];
                      ApplicationArea=#ItemTracking;
                      Image=SerialNo;
                      OnAction=BEGIN
                                 IF InsertIsBlocked THEN
                                   EXIT;
                                 AssignSerialNo;
                               END;
                                }
      { 45      ;2   ;Action    ;
                      CaptionML=[DAN=Tildel &lotnr.;
                                 ENU=Assign &Lot No.];
                      ToolTipML=[DAN=Tildel automatisk de p�kr�vede lotnumre fra foruddefinerede nummerserier.;
                                 ENU=Automatically assign the required lot numbers from predefined number series.];
                      ApplicationArea=#ItemTracking;
                      Image=Lot;
                      OnAction=BEGIN
                                 IF InsertIsBlocked THEN
                                   EXIT;
                                 AssignLotNo;
                               END;
                                }
      { 57      ;2   ;Action    ;
                      Name=CreateCustomizedSN;
                      CaptionML=[DAN=Opret brugerdef. serienr.;
                                 ENU=Create Customized SN];
                      ToolTipML=[DAN=Tilknyt automatisk de p�kr�vede serienumre ud fra en nummerserie, som du selv definerer.;
                                 ENU=Automatically assign the required serial numbers based on a number series that you define.];
                      ApplicationArea=#ItemTracking;
                      Image=CreateSerialNo;
                      OnAction=BEGIN
                                 IF InsertIsBlocked THEN
                                   EXIT;
                                 CreateCustomizedSN;
                               END;
                                }
      { 55      ;2   ;Action    ;
                      Name=Select Entries;
                      CaptionML=[DAN=Marker p&oster;
                                 ENU=Select &Entries];
                      ToolTipML=[DAN=V�lg mellem eksisterende og tilg�ngelige serie- eller lotnumre.;
                                 ENU=Select from existing, available serial or lot numbers.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SelectEntries;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF InsertIsBlocked THEN
                                   EXIT;

                                 SelectEntries;
                               END;
                                }
      { 64      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater disponering;
                                 ENU=Refresh Availability];
                      ToolTipML=[DAN="Opdater oplysningerne om tilg�ngelighed i overensstemmelse med �ndringer foretaget af andre brugere, siden du �bnede vinduet. ";
                                 ENU="Update the availability information according to changes made by other users since you opened the window. "];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Refresh;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ItemTrackingDataCollection.RefreshTrackingAvailability(Rec,TRUE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 59  ;1   ;Group      }

    { 1903651101;2;Group  ;
                GroupType=FixedLayout }

    { 1900546401;3;Group  ;
                CaptionML=[DAN=Kilde;
                           ENU=Source] }

    { 38  ;4   ;Field     ;
                ApplicationArea=#ItemTracking;
                SourceExpr=CurrentSourceCaption;
                Editable=FALSE;
                ShowCaption=No }

    { 29  ;4   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver det antal af varen, som svarer til den bilagslinje, der er angivet med 0 i felterne Udefineret.;
                           ENU=Specifies the quantity of the item that corresponds to the document line, which is indicated by 0 in the Undefined fields.];
                ApplicationArea=#ItemTracking;
                DecimalPlaces=0:5;
                SourceExpr=SourceQuantityArray[1];
                Editable=FALSE }

    { 31  ;4   ;Field     ;
                Name=Handle1;
                CaptionML=[DAN=H�ndteringsantal;
                           ENU=Qty. to Handle];
                ToolTipML=[DAN=Angiver det varesporede antal, der skal h�ndteres. Antallene skal svare til dem p� bilagslinjen.;
                           ENU=Specifies the item-tracked quantity to be handled. The quantities must correspond to those of the document line.];
                ApplicationArea=#ItemTracking;
                DecimalPlaces=0:5;
                SourceExpr=SourceQuantityArray[2];
                Visible=Handle1Visible;
                Editable=FALSE }

    { 33  ;4   ;Field     ;
                Name=Invoice1;
                CaptionML=[DAN=Fakturer (antal);
                           ENU=Qty. to Invoice];
                ToolTipML=[DAN=Angiver det varesporede antal, der skal faktureres.;
                           ENU=Specifies the item-tracked quantity to be invoiced.];
                ApplicationArea=#ItemTracking;
                DecimalPlaces=0:5;
                SourceExpr=SourceQuantityArray[3];
                Visible=Invoice1Visible;
                Editable=FALSE }

    { 1901742101;3;Group  ;
                CaptionML=[DAN=Varesporing;
                           ENU=Item Tracking] }

    { 87  ;4   ;Field     ;
                ApplicationArea=#ItemTracking;
                SourceExpr=Text020;
                Visible=FALSE }

    { 35  ;4   ;Field     ;
                Name=Quantity_ItemTracking;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver det varesporede antal af varen, som svarer til den bilagslinje, der er angivet med 0 i felterne Udefineret.;
                           ENU=Specifies the item-tracked quantity of the item that corresponds to the document line, which is indicated by 0 in the Undefined fields.];
                ApplicationArea=#ItemTracking;
                DecimalPlaces=0:5;
                SourceExpr=TotalItemTrackingLine."Quantity (Base)";
                Editable=FALSE }

    { 36  ;4   ;Field     ;
                Name=Handle2;
                CaptionML=[DAN=H�ndteringsantal;
                           ENU=Qty. to Handle];
                ToolTipML=[DAN=Angiver det varesporede antal, der skal h�ndteres. Antallene skal svare til dem p� bilagslinjen.;
                           ENU=Specifies the item-tracked quantity to be handled. The quantities must correspond to those of the document line.];
                ApplicationArea=#ItemTracking;
                DecimalPlaces=0:5;
                SourceExpr=TotalItemTrackingLine."Qty. to Handle (Base)";
                Visible=Handle2Visible;
                Editable=FALSE }

    { 37  ;4   ;Field     ;
                Name=Invoice2;
                CaptionML=[DAN=Fakturer (antal);
                           ENU=Qty. to Invoice];
                ToolTipML=[DAN=Angiver det varesporede antal, der skal faktureres.;
                           ENU=Specifies the item-tracked quantity to be invoiced.];
                ApplicationArea=#ItemTracking;
                DecimalPlaces=0:5;
                SourceExpr=TotalItemTrackingLine."Qty. to Invoice (Base)";
                Visible=Invoice2Visible;
                Editable=FALSE }

    { 1903866601;3;Group  ;
                CaptionML=[DAN=Udefineret;
                           ENU=Undefined] }

    { 88  ;4   ;Field     ;
                ApplicationArea=#ItemTracking;
                SourceExpr=Text020;
                Visible=FALSE }

    { 40  ;4   ;Field     ;
                Name=Quantity3;
                CaptionML=[DAN=Udefineret antal;
                           ENU=Undefined Quantity];
                ToolTipML=[DAN=Angiver det varesporede antal, der stadig skal tildeles i overensstemmelse med antallet i bilaget.;
                           ENU=Specifies the item-tracked quantity that remains to be assigned, according to the document quantity.];
                ApplicationArea=#ItemTracking;
                DecimalPlaces=2:5;
                BlankZero=Yes;
                SourceExpr=UndefinedQtyArray[1];
                Editable=FALSE }

    { 41  ;4   ;Field     ;
                Name=Handle3;
                CaptionML=[DAN=Udefineret santal til h�ndtering;
                           ENU=Undefined Quantity to Handle];
                ToolTipML=[DAN=Angiver differencen mellem det antal, der kan v�lges for bilagslinjen (som vises i feltet Kan markeres) og det antal, som du har valgt i dette vindue (vist i feltet Markeret). Hvis du har angivet et st�rre varesporingsantal, end der kr�ves p� bilagslinjen, viser feltet overl�bsantallet som et negativt tal med r�dt.;
                           ENU=Specifies the difference between the quantity that can be selected for the document line (which is shown in the Selectable field) and the quantity that you have selected in this window (shown in the Selected field). If you have specified more item tracking quantity than is required on the document line, this field shows the overflow quantity as a negative number in red.];
                ApplicationArea=#ItemTracking;
                DecimalPlaces=2:5;
                BlankZero=Yes;
                SourceExpr=UndefinedQtyArray[2];
                Visible=Handle3Visible;
                Editable=FALSE }

    { 42  ;4   ;Field     ;
                Name=Invoice3;
                CaptionML=[DAN=Udefineret antal til fakturering;
                           ENU=Undefined Quantity to Invoice];
                ToolTipML=[DAN=Angiver differencen mellem det antal, der kan v�lges for bilagslinjen (som vises i feltet Kan markeres) og det antal, som du har valgt i dette vindue (vist i feltet Markeret). Hvis du har angivet et st�rre varesporingsantal, end der kr�ves p� bilagslinjen, viser feltet overl�bsantallet som et negativt tal med r�dt.;
                           ENU=Specifies the difference between the quantity that can be selected for the document line (which is shown in the Selectable field) and the quantity that you have selected in this window (shown in the Selected field). If you have specified more item tracking quantity than is required on the document line, this field shows the overflow quantity as a negative number in red.];
                ApplicationArea=#ItemTracking;
                DecimalPlaces=2:5;
                BlankZero=Yes;
                SourceExpr=UndefinedQtyArray[3];
                Visible=Invoice3Visible;
                Editable=FALSE }

    { 82  ;1   ;Group      }

    { 84  ;2   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Varesporingskode;
                           ENU=Item Tracking Code];
                ToolTipML=[DAN=Angiver de overf�rte varesporingslinjer.;
                           ENU=Specifies the transferred item tracking lines.];
                ApplicationArea=#ItemTracking;
                SourceExpr=ItemTrackingCode.Code;
                Editable=FALSE;
                OnLookup=BEGIN
                           PAGE.RUNMODAL(0,ItemTrackingCode);
                         END;
                          }

    { 85  ;2   ;Field     ;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver beskrivelsen af det, der spores.;
                           ENU=Specifies the description of what is being tracked.];
                ApplicationArea=#ItemTracking;
                SourceExpr=ItemTrackingCode.Description;
                Editable=FALSE }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 61  ;2   ;Field     ;
                Name=AvailabilitySerialNo;
                CaptionML=[DAN=Disponering, serienr.;
                           ENU=Availability, Serial No.];
                ToolTipML=[DAN=Angiver et advarselsikon, hvis summen af antallene for varen i udg�ende dokumenter er st�rre end antallet af serienumre p� lageret.;
                           ENU=Specifies a warning icon if the sum of the quantities of the item in outbound documents is greater than the serial number quantity in inventory.];
                OptionCaptionML=[DAN=Bitmap45;
                                 ENU=Bitmap45];
                ApplicationArea=#ItemTracking;
                SourceExpr=TrackingAvailable(Rec,0);
                Editable=False;
                OnDrillDown=BEGIN
                              LookupAvailable(0);
                            END;
                             }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serienummer, som er knyttet til posten.;
                           ENU=Specifies the serial number associated with the entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Editable=SerialNoEditable;
                OnValidate=BEGIN
                             SerialNoOnAfterValidate;
                           END;

                OnAssistEdit=VAR
                               MaxQuantity@1001 : Decimal;
                             BEGIN
                               MaxQuantity := UndefinedQtyArray[1];

                               "Bin Code" := ForBinCode;
                               ItemTrackingDataCollection.AssistEditTrackingNo(Rec,
                                 (CurrentSignFactor * SourceQuantityArray[1] < 0) AND NOT
                                 InsertIsBlocked,CurrentSignFactor,0,MaxQuantity);
                               "Bin Code" := '';
                               CurrPage.UPDATE;
                             END;
                              }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nyt serienummer, som bruges i stedet for serienummeret i feltet Serienr.;
                           ENU=Specifies a new serial number that will take the place of the serial number in the Serial No. field.];
                ApplicationArea=#ItemTracking;
                SourceExpr="New Serial No.";
                Visible=NewSerialNoVisible;
                Editable=NewSerialNoEditable }

    { 56  ;2   ;Field     ;
                Name=AvailabilityLotNo;
                CaptionML=[DAN=Disponering, lotnr.;
                           ENU=Availability, Lot No.];
                ToolTipML=[DAN=Angiver et advarselsikon, hvis summen af antallene for varen i udg�ende dokumenter er st�rre end antallet af lotnumre p� lageret.;
                           ENU=Specifies a warning icon if the sum of the quantities of the item in outbound documents is greater than the lot number quantity in inventory.];
                OptionCaptionML=[DAN=Bitmap45;
                                 ENU=Bitmap45];
                ApplicationArea=#ItemTracking;
                SourceExpr=TrackingAvailable(Rec,1);
                Editable=False;
                OnDrillDown=BEGIN
                              LookupAvailable(1);
                            END;
                             }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lotnummeret for den vare, der h�ndteres for den tilknyttede bilagslinje.;
                           ENU=Specifies the lot number of the item being handled for the associated document line.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Editable=LotNoEditable;
                OnValidate=BEGIN
                             LotNoOnAfterValidate;
                           END;

                OnAssistEdit=VAR
                               MaxQuantity@1001 : Decimal;
                             BEGIN
                               MaxQuantity := UndefinedQtyArray[1];

                               "Bin Code" := ForBinCode;
                               ItemTrackingDataCollection.AssistEditTrackingNo(Rec,
                                 (CurrentSignFactor * SourceQuantityArray[1] < 0) AND NOT
                                 InsertIsBlocked,CurrentSignFactor,1,MaxQuantity);
                               "Bin Code" := '';
                               CurrPage.UPDATE;
                             END;
                              }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nyt lotnummer, som bruges i stedet for lotnummeret i feltet Lotnr.;
                           ENU=Specifies a new lot number that will take the place of the lot number in the Lot No. field.];
                ApplicationArea=#ItemTracking;
                SourceExpr="New Lot No.";
                Visible=NewLotNoVisible;
                Editable=NewLotNoEditable }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den eventuelle udl�bsdato for varen med varesporingsnummeret.;
                           ENU=Specifies the expiration date, if any, of the item carrying the item tracking number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expiration Date";
                Visible=FALSE;
                Editable=ExpirationDateEditable;
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                           END;
                            }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en ny udl�bsdato.;
                           ENU=Specifies a new expiration date.];
                ApplicationArea=#ItemTracking;
                SourceExpr="New Expiration Date";
                Visible=NewExpirationDateVisible;
                Editable=NewExpirationDateEditable }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en garantidato skal angives manuelt.;
                           ENU=Specifies that a warranty date must be entered manually.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Warranty Date";
                Visible=FALSE;
                Editable=WarrantyDateEditable }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den vare, som er knyttet til posten.;
                           ENU=Specifies the number of the item associated with the entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Item No.";
                Visible=FALSE;
                Editable=ItemNoEditable }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE;
                Editable=VariantCodeEditable }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af posten.;
                           ENU=Specifies the description of the entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr=Description;
                Visible=FALSE;
                Editable=DescriptionEditable }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationskoden for posten.;
                           ENU=Specifies the location code for the entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Location Code";
                Visible=FALSE;
                Editable=LocationCodeEditable }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet p� linjen anf�rt i basisenheder.;
                           ENU=Specifies the quantity on the line expressed in base units of measure.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Quantity (Base)";
                Editable=QuantityBaseEditable;
                OnValidate=BEGIN
                             QuantityBaseOnValidate;
                             QuantityBaseOnAfterValidate;
                           END;
                            }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, som du vil h�ndtere, anf�rt i basisenheder.;
                           ENU=Specifies the quantity that you want to handle in the base unit of measure.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Qty. to Handle (Base)";
                Visible=QtyToHandleBaseVisible;
                Editable=QtyToHandleBaseEditable;
                OnValidate=BEGIN
                             QtytoHandleBaseOnAfterValidate;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange varer i basisenheder der er planlagt til fakturering.;
                           ENU=Specifies how many of the items, in base units of measure, are scheduled for invoicing.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Qty. to Invoice (Base)";
                Visible=QtyToInvoiceBaseVisible;
                Editable=QtyToInvoiceBaseEditable;
                OnValidate=BEGIN
                             QtytoInvoiceBaseOnAfterValidat;
                           END;
                            }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af serie- eller lotnumre, der leveres eller modtages for den tilknyttede bilagslinje, anf�rt i basisenheder.;
                           ENU=Specifies the quantity of serial/lot numbers shipped or received for the associated document line, expressed in base units of measure.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Quantity Handled (Base)";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af serie- eller lotnumre, der faktureres med den tilknyttede bilagslinje, anf�rt i basisenheder.;
                           ENU=Specifies the quantity of serial/lot numbers that are invoiced with the associated document line, expressed in base units of measure.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Quantity Invoiced (Base)";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den varepost, som dette dokument eller denne kladdelinje udlignes p�.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Appl.-to Item Entry";
                Visible=ApplToItemEntryVisible }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette bilag eller denne kladdelinje udlignes fra.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied from.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Appl.-from Item Entry";
                Visible=ApplFromItemEntryVisible }

  }
  CODE
  {
    VAR
      xTempItemTrackingLine@1009 : TEMPORARY Record 336;
      TotalItemTrackingLine@1003 : Record 336;
      TempItemTrackLineInsert@1054 : TEMPORARY Record 336;
      TempItemTrackLineModify@1055 : TEMPORARY Record 336;
      TempItemTrackLineDelete@1056 : TEMPORARY Record 336;
      TempItemTrackLineReserv@1060 : TEMPORARY Record 336;
      Item@1004 : Record 27;
      ItemTrackingCode@1005 : Record 6502;
      TempReservEntry@1015 : TEMPORARY Record 337;
      NoSeriesMgt@1030 : Codeunit 396;
      ItemTrackingMgt@1020 : Codeunit 6500;
      ReservEngineMgt@1034 : Codeunit 99000831;
      ItemTrackingDataCollection@1058 : Codeunit 6501;
      UndefinedQtyArray@1019 : ARRAY [3] OF Decimal;
      SourceQuantityArray@1011 : ARRAY [5] OF Decimal;
      QtyPerUOM@1021 : Decimal;
      QtyToAddAsBlank@1033 : Decimal;
      CurrentSignFactor@1012 : Integer;
      Text002@1014 : TextConst 'DAN=Antal skal v�re %1.;ENU=Quantity must be %1.';
      Text003@1001 : TextConst 'DAN=negativ;ENU=negative';
      Text004@1016 : TextConst 'DAN=positiv;ENU=positive';
      LastEntryNo@1008 : Integer;
      CurrentSourceType@1048 : Integer;
      SecondSourceID@1035 : Integer;
      IsAssembleToOrder@1053 : Boolean;
      ExpectedReceiptDate@1010 : Date;
      ShipmentDate@1017 : Date;
      Text005@1018 : TextConst 'DAN=Der opstod en fejl under skrivning til databasen.;ENU=Error when writing to database.';
      Text006@1022 : TextConst 'DAN=Rettelserne kan ikke gemmes, fordi der er angivet overskydende antal.\Vil du lukke formularen alligevel?;ENU=The corrections cannot be saved as excess quantity has been defined.\Close the form anyway?';
      Text007@1023 : TextConst 'DAN=En anden bruger har �ndret varesporingsoplysningerne, efter at de blev hentet fra databasen.\Start igen.;ENU=Another user has modified the item tracking data since it was retrieved from the database.\Start again.';
      CurrentEntryStatus@1024 : 'Reservation,Tracking,Surplus,Prospect';
      FormRunMode@1026 : ',Reclass,Combined Ship/Rcpt,Drop Shipment,Transfer';
      InsertIsBlocked@1025 : Boolean;
      Text008@1028 : TextConst 'DAN=Det oprettede antal skal v�re et heltal.;ENU=The quantity to create must be an integer.';
      Text009@1027 : TextConst 'DAN=Det oprettede antal skal v�re positivt.;ENU=The quantity to create must be positive.';
      Text011@1031 : TextConst 'DAN=Der findes allerede en sporingsspecifikation med serienr. %1 og lotnr. %2.;ENU=Tracking specification with Serial No. %1 and Lot No. %2 already exists.';
      Text012@1032 : TextConst 'DAN=Der findes allerede en sporingsspecifikation med serienr. %1.;ENU=Tracking specification with Serial No. %1 already exists.';
      DeleteIsBlocked@1036 : Boolean;
      Text014@1037 : TextConst 'DAN=Det totale varesporingsantal %1 overstiger %2-antallet %3.\�ndringerne kan ikke gemmes i databasen.;ENU=The total item tracking quantity %1 exceeds the %2 quantity %3.\The changes cannot be saved to the database.';
      Text015@1038 : TextConst 'DAN=Vil du synkronisere varesporing p� linjen med varesporing p� den tilknyttede direkte levering %1?;ENU=Do you want to synchronize item tracking on the line with item tracking on the related drop shipment %1?';
      BlockCommit@1041 : Boolean;
      IsCorrection@1046 : Boolean;
      CurrentFormIsOpen@1029 : Boolean;
      CalledFromSynchWhseItemTrkg@1000 : Boolean;
      Inbound@1059 : Boolean;
      CurrentSourceCaption@1047 : Text[255];
      CurrentSourceRowID@1039 : Text[250];
      SecondSourceRowID@1040 : Text[250];
      Text016@1044 : TextConst 'DAN=k�bsordrelinje;ENU=purchase order line';
      Text017@1045 : TextConst 'DAN=salgsordrelinje;ENU=sales order line';
      Text018@1057 : TextConst 'DAN=Gemmer �ndringer til elementsporingsliste;ENU=Saving item tracking line changes';
      ForBinCode@1043 : Code[20];
      Text019@1013 : TextConst 'DAN=Der er disponeringsadvarsler p� en eller flere linjer.\Vil du lukke formularen alligevel?;ENU=There are availability warnings on one or more lines.\Close the form anyway?';
      Text020@1002 : TextConst 'DAN=Pladsholder;ENU=Placeholder';
      ApplFromItemEntryVisible@19038403 : Boolean INDATASET;
      ApplToItemEntryVisible@1050 : Boolean INDATASET;
      ItemNoEditable@19055681 : Boolean INDATASET;
      VariantCodeEditable@19003611 : Boolean INDATASET;
      LocationCodeEditable@19048234 : Boolean INDATASET;
      Handle1Visible@19064734 : Boolean INDATASET;
      Handle2Visible@19067235 : Boolean INDATASET;
      Handle3Visible@19058196 : Boolean INDATASET;
      QtyToHandleBaseVisible@19036968 : Boolean INDATASET;
      Invoice1Visible@19017525 : Boolean INDATASET;
      Invoice2Visible@19053429 : Boolean INDATASET;
      Invoice3Visible@19043061 : Boolean INDATASET;
      QtyToInvoiceBaseVisible@19048430 : Boolean INDATASET;
      NewSerialNoVisible@19031772 : Boolean INDATASET;
      NewLotNoVisible@19006815 : Boolean INDATASET;
      NewExpirationDateVisible@19041101 : Boolean INDATASET;
      ButtonLineReclassVisible@19076729 : Boolean INDATASET;
      ButtonLineVisible@19043118 : Boolean INDATASET;
      FunctionsSupplyVisible@19000825 : Boolean INDATASET;
      FunctionsDemandVisible@19014220 : Boolean INDATASET;
      InboundIsSet@1006 : Boolean;
      QtyToHandleBaseEditable@19075992 : Boolean INDATASET;
      QtyToInvoiceBaseEditable@19015223 : Boolean INDATASET;
      QuantityBaseEditable@19065426 : Boolean INDATASET;
      SerialNoEditable@19056272 : Boolean INDATASET;
      LotNoEditable@19059315 : Boolean INDATASET;
      DescriptionEditable@19061412 : Boolean INDATASET;
      NewSerialNoEditable@19030864 : Boolean INDATASET;
      NewLotNoEditable@19020282 : Boolean INDATASET;
      NewExpirationDateEditable@19056874 : Boolean INDATASET;
      ExpirationDateEditable@19023942 : Boolean INDATASET;
      WarrantyDateEditable@19022604 : Boolean INDATASET;
      ExcludePostedEntries@1007 : Boolean;
      ProdOrderLineHandling@1052 : Boolean;
      DifferentExpDateMsg@1042 : TextConst '@@@="%1 = Lot no., %2 = Item expiration date (Example: A tracking specification exists for lot number ''L001'' and expiration date 25.01.2019.)";DAN=Der findes en sporingsspecifikation for lotnummer %1 og udl�bsdato %2. Alle varer i dette lotnummer skal have den samme udl�bsdato.;ENU=A tracking specification exists for lot number %1 and expiration date %2. All items with this lot number must have the same expiration date.';

    [External]
    PROCEDURE SetFormRunMode@19(Mode@1000 : ',Reclass,Combined Ship/Rcpt,Drop Shipment');
    BEGIN
      FormRunMode := Mode;
    END;

    [External]
    PROCEDURE SetSourceSpec@1(TrackingSpecification@1000 : Record 336;AvailabilityDate@1002 : Date);
    VAR
      ReservEntry@1001 : Record 337;
      TempTrackingSpecification@1005 : TEMPORARY Record 336;
      TempTrackingSpecification2@1006 : TEMPORARY Record 336;
      CreateReservEntry@1004 : Codeunit 99000830;
      Controls@1003 : 'Handle,Invoice,Quantity,Reclass,Tracking';
    BEGIN
      GetItem(TrackingSpecification."Item No.");
      ForBinCode := TrackingSpecification."Bin Code";
      SetFilters(TrackingSpecification);
      TempTrackingSpecification.DELETEALL;
      TempItemTrackLineInsert.DELETEALL;
      TempItemTrackLineModify.DELETEALL;
      TempItemTrackLineDelete.DELETEALL;

      TempReservEntry.DELETEALL;
      LastEntryNo := 0;
      IF ItemTrackingMgt.IsOrderNetworkEntity(TrackingSpecification."Source Type",
           TrackingSpecification."Source Subtype") AND NOT (FormRunMode = FormRunMode::"Drop Shipment")
      THEN
        CurrentEntryStatus := CurrentEntryStatus::Surplus
      ELSE
        CurrentEntryStatus := CurrentEntryStatus::Prospect;

      // Set controls for Qty to handle:
      SetControls(Controls::Handle,GetHandleSource(TrackingSpecification));
      // Set controls for Qty to Invoice:
      SetControls(Controls::Invoice,GetInvoiceSource(TrackingSpecification));

      SetControls(Controls::Reclass,FormRunMode = FormRunMode::Reclass);

      IF FormRunMode = FormRunMode::"Combined Ship/Rcpt" THEN
        SetControls(Controls::Tracking,FALSE);
      IF ItemTrackingMgt.ItemTrkgIsManagedByWhse(
           TrackingSpecification."Source Type",
           TrackingSpecification."Source Subtype",
           TrackingSpecification."Source ID",
           TrackingSpecification."Source Prod. Order Line",
           TrackingSpecification."Source Ref. No.",
           TrackingSpecification."Location Code",
           TrackingSpecification."Item No.")
      THEN BEGIN
        SetControls(Controls::Quantity,FALSE);
        QtyToHandleBaseEditable := TRUE;
        DeleteIsBlocked := TRUE;
      END;

      ReservEntry."Source Type" := TrackingSpecification."Source Type";
      ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
      CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
      CurrentSourceCaption := ReservEntry.TextCaption;
      CurrentSourceType := ReservEntry."Source Type";

      IF CurrentSignFactor < 0 THEN BEGIN
        ExpectedReceiptDate := 0D;
        ShipmentDate := AvailabilityDate;
      END ELSE BEGIN
        ExpectedReceiptDate := AvailabilityDate;
        ShipmentDate := 0D;
      END;

      SourceQuantityArray[1] := TrackingSpecification."Quantity (Base)";
      SourceQuantityArray[2] := TrackingSpecification."Qty. to Handle (Base)";
      SourceQuantityArray[3] := TrackingSpecification."Qty. to Invoice (Base)";
      SourceQuantityArray[4] := TrackingSpecification."Quantity Handled (Base)";
      SourceQuantityArray[5] := TrackingSpecification."Quantity Invoiced (Base)";
      QtyPerUOM := TrackingSpecification."Qty. per Unit of Measure";

      ReservEntry.SETCURRENTKEY(
        "Source ID","Source Ref. No.","Source Type","Source Subtype",
        "Source Batch Name","Source Prod. Order Line","Reservation Status");

      ReservEntry.SETRANGE("Source ID",TrackingSpecification."Source ID");
      ReservEntry.SETRANGE("Source Ref. No.",TrackingSpecification."Source Ref. No.");
      ReservEntry.SETRANGE("Source Type",TrackingSpecification."Source Type");
      ReservEntry.SETRANGE("Source Subtype",TrackingSpecification."Source Subtype");
      ReservEntry.SETRANGE("Source Batch Name",TrackingSpecification."Source Batch Name");
      ReservEntry.SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");

      // Transfer Receipt gets special treatment:
      IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
         (FormRunMode <> FormRunMode::Transfer) AND
         (TrackingSpecification."Source Subtype" = 1)
      THEN BEGIN
        ReservEntry.SETRANGE("Source Subtype",0);
        AddReservEntriesToTempRecSet(ReservEntry,TempTrackingSpecification2,TRUE,8421504);
        ReservEntry.SETRANGE("Source Subtype",1);
        ReservEntry.SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Ref. No.");
        ReservEntry.SETRANGE("Source Ref. No.");
        DeleteIsBlocked := TRUE;
        SetControls(Controls::Quantity,FALSE);
      END;

      AddReservEntriesToTempRecSet(ReservEntry,TempTrackingSpecification,FALSE,0);

      TempReservEntry.COPYFILTERS(ReservEntry);

      TrackingSpecification.SETCURRENTKEY(
        "Source ID","Source Type","Source Subtype",
        "Source Batch Name","Source Prod. Order Line","Source Ref. No.");

      TrackingSpecification.SETRANGE("Source ID",TrackingSpecification."Source ID");
      TrackingSpecification.SETRANGE("Source Type",TrackingSpecification."Source Type");
      TrackingSpecification.SETRANGE("Source Subtype",TrackingSpecification."Source Subtype");
      TrackingSpecification.SETRANGE("Source Batch Name",TrackingSpecification."Source Batch Name");
      TrackingSpecification.SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");
      TrackingSpecification.SETRANGE("Source Ref. No.",TrackingSpecification."Source Ref. No.");

      IF TrackingSpecification.FINDSET THEN
        REPEAT
          TempTrackingSpecification := TrackingSpecification;
          TempTrackingSpecification.INSERT;
        UNTIL TrackingSpecification.NEXT = 0;

      // Data regarding posted quantities on transfers is collected from Item Ledger Entries:
      IF TrackingSpecification."Source Type" = DATABASE::"Transfer Line" THEN
        CollectPostedTransferEntries(TrackingSpecification,TempTrackingSpecification);

      // Data regarding posted quantities on assembly orders is collected from Item Ledger Entries:
      IF NOT ExcludePostedEntries THEN
        IF (TrackingSpecification."Source Type" = DATABASE::"Assembly Line") OR
           (TrackingSpecification."Source Type" = DATABASE::"Assembly Header")
        THEN
          CollectPostedAssemblyEntries(TrackingSpecification,TempTrackingSpecification);

      // Data regarding posted output quantities on prod.orders is collected from Item Ledger Entries:
      IF TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line" THEN
        IF TrackingSpecification."Source Subtype" = 3 THEN
          CollectPostedOutputEntries(TrackingSpecification,TempTrackingSpecification);

      // If run for Drop Shipment a RowID is prepared for synchronisation:
      IF FormRunMode = FormRunMode::"Drop Shipment" THEN
        CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
            TrackingSpecification."Source Subtype",TrackingSpecification."Source ID",
            TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
            TrackingSpecification."Source Ref. No.");

      // Synchronization of outbound transfer order:
      IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
         (TrackingSpecification."Source Subtype" = 0)
      THEN BEGIN
        BlockCommit := TRUE;
        CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
            TrackingSpecification."Source Subtype",TrackingSpecification."Source ID",
            TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
            TrackingSpecification."Source Ref. No.");
        SecondSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
            1,TrackingSpecification."Source ID",
            TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
            TrackingSpecification."Source Ref. No.");
        FormRunMode := FormRunMode::Transfer;
      END;

      AddToGlobalRecordSet(TempTrackingSpecification);
      AddToGlobalRecordSet(TempTrackingSpecification2);
      CalculateSums;

      ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(ForBinCode,ItemTrackingCode);
      ItemTrackingDataCollection.RetrieveLookupData(Rec,FALSE);

      FunctionsDemandVisible := CurrentSignFactor * SourceQuantityArray[1] < 0;
      FunctionsSupplyVisible := NOT FunctionsDemandVisible;
    END;

    [External]
    PROCEDURE SetSecondSourceQuantity@1026(SecondSourceQuantityArray@1000 : ARRAY [3] OF Decimal);
    VAR
      Controls@1001 : 'Handle,Invoice';
    BEGIN
      CASE SecondSourceQuantityArray[1] OF
        DATABASE::"Warehouse Receipt Line",DATABASE::"Warehouse Shipment Line":
          BEGIN
            SourceQuantityArray[2] := SecondSourceQuantityArray[2]; // "Qty. to Handle (Base)"
            SourceQuantityArray[3] := SecondSourceQuantityArray[3]; // "Qty. to Invoice (Base)"
            SetControls(Controls::Invoice,FALSE);
          END;
        ELSE
          EXIT;
      END;
      CalculateSums;
    END;

    [External]
    PROCEDURE SetSecondSourceRowID@32(RowID@1000 : Text[250]);
    BEGIN
      SecondSourceRowID := RowID;
    END;

    LOCAL PROCEDURE AddReservEntriesToTempRecSet@15(VAR ReservEntry@1000 : Record 337;VAR TempTrackingSpecification@1001 : TEMPORARY Record 336;SwapSign@1002 : Boolean;Color@1004 : Integer);
    VAR
      FromReservEntry@1003 : Record 337;
      AddTracking@1005 : Boolean;
    BEGIN
      IF ReservEntry.FINDSET THEN
        REPEAT
          IF Color = 0 THEN BEGIN
            TempReservEntry := ReservEntry;
            TempReservEntry.INSERT;
          END;
          IF ReservEntry.TrackingExists THEN BEGIN
            AddTracking := TRUE;
            IF SecondSourceID = DATABASE::"Warehouse Shipment Line" THEN
              IF FromReservEntry.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive) THEN
                AddTracking := (FromReservEntry."Source Type" = DATABASE::"Assembly Header") = IsAssembleToOrder
              ELSE
                AddTracking := NOT IsAssembleToOrder;

            IF AddTracking THEN BEGIN
              TempTrackingSpecification.TRANSFERFIELDS(ReservEntry);
              // Ensure uniqueness of Entry No. by making it negative:
              TempTrackingSpecification."Entry No." *= -1;
              IF SwapSign THEN
                TempTrackingSpecification."Quantity (Base)" *= -1;
              IF Color <> 0 THEN BEGIN
                TempTrackingSpecification."Quantity Handled (Base)" :=
                  TempTrackingSpecification."Quantity (Base)";
                TempTrackingSpecification."Quantity Invoiced (Base)" :=
                  TempTrackingSpecification."Quantity (Base)";
                TempTrackingSpecification."Qty. to Handle (Base)" := 0;
                TempTrackingSpecification."Qty. to Invoice (Base)" := 0;
              END;
              TempTrackingSpecification."Buffer Status" := Color;
              TempTrackingSpecification.INSERT;
            END;
          END;
        UNTIL ReservEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE AddToGlobalRecordSet@17(VAR TempTrackingSpecification@1000 : TEMPORARY Record 336);
    VAR
      ExpDate@1001 : Date;
      EntriesExist@1002 : Boolean;
    BEGIN
      TempTrackingSpecification.SETCURRENTKEY("Lot No.","Serial No.");
      IF TempTrackingSpecification.FIND('-') THEN
        REPEAT
          TempTrackingSpecification.SetTrackingFilterFromSpec(TempTrackingSpecification);
          TempTrackingSpecification.CALCSUMS("Quantity (Base)","Qty. to Handle (Base)",
            "Qty. to Invoice (Base)","Quantity Handled (Base)","Quantity Invoiced (Base)");
          IF TempTrackingSpecification."Quantity (Base)" <> 0 THEN BEGIN
            Rec := TempTrackingSpecification;
            "Quantity (Base)" *= CurrentSignFactor;
            "Qty. to Handle (Base)" *= CurrentSignFactor;
            "Qty. to Invoice (Base)" *= CurrentSignFactor;
            "Quantity Handled (Base)" *= CurrentSignFactor;
            "Quantity Invoiced (Base)" *= CurrentSignFactor;
            "Qty. to Handle" :=
              CalcQty("Qty. to Handle (Base)");
            "Qty. to Invoice" :=
              CalcQty("Qty. to Invoice (Base)");
            "Entry No." := NextEntryNo;

            ExpDate := ItemTrackingMgt.ExistingExpirationDate(
                "Item No.","Variant Code",
                "Lot No.","Serial No.",FALSE,EntriesExist);

            IF ExpDate <> 0D THEN BEGIN
              "Expiration Date" := ExpDate;
              "Buffer Status2" := "Buffer Status2"::"ExpDate blocked";
            END;

            INSERT;

            IF "Buffer Status" = 0 THEN BEGIN
              xTempItemTrackingLine := Rec;
              xTempItemTrackingLine.INSERT;
            END;
          END;

          TempTrackingSpecification.FIND('+');
          TempTrackingSpecification.ClearTrackingFilter;
        UNTIL TempTrackingSpecification.NEXT = 0;
    END;

    LOCAL PROCEDURE SetControls@13(Controls@1000 : 'Handle,Invoice,Quantity,Reclass,Tracking';SetAccess@1001 : Boolean);
    BEGIN
      CASE Controls OF
        Controls::Handle:
          BEGIN
            Handle1Visible := SetAccess;
            Handle2Visible := SetAccess;
            Handle3Visible := SetAccess;
            QtyToHandleBaseVisible := SetAccess;
            QtyToHandleBaseEditable := SetAccess;
          END;
        Controls::Invoice:
          BEGIN
            Invoice1Visible := SetAccess;
            Invoice2Visible := SetAccess;
            Invoice3Visible := SetAccess;
            QtyToInvoiceBaseVisible := SetAccess;
            QtyToInvoiceBaseEditable := SetAccess;
          END;
        Controls::Quantity:
          BEGIN
            QuantityBaseEditable := SetAccess;
            SerialNoEditable := SetAccess;
            LotNoEditable := SetAccess;
            DescriptionEditable := SetAccess;
            InsertIsBlocked := TRUE;
          END;
        Controls::Reclass:
          BEGIN
            NewSerialNoVisible := SetAccess;
            NewSerialNoEditable := SetAccess;
            NewLotNoVisible := SetAccess;
            NewLotNoEditable := SetAccess;
            NewExpirationDateVisible := SetAccess;
            NewExpirationDateEditable := SetAccess;
            ButtonLineReclassVisible := SetAccess;
            ButtonLineVisible := NOT SetAccess;
          END;
        Controls::Tracking:
          BEGIN
            SerialNoEditable := SetAccess;
            LotNoEditable := SetAccess;
            ExpirationDateEditable := SetAccess;
            WarrantyDateEditable := SetAccess;
            InsertIsBlocked := SetAccess;
          END;
      END;
    END;

    LOCAL PROCEDURE GetItem@3(ItemNo@1000 : Code[20]);
    BEGIN
      IF Item."No." <> ItemNo THEN BEGIN
        Item.GET(ItemNo);
        Item.TESTFIELD("Item Tracking Code");
        IF ItemTrackingCode.Code <> Item."Item Tracking Code" THEN
          ItemTrackingCode.GET(Item."Item Tracking Code");
      END;
    END;

    LOCAL PROCEDURE SetFilters@12(TrackingSpecification@1000 : Record 336);
    BEGIN
      FILTERGROUP := 2;
      SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Source Ref. No.");
      SETRANGE("Source ID",TrackingSpecification."Source ID");
      SETRANGE("Source Type",TrackingSpecification."Source Type");
      SETRANGE("Source Subtype",TrackingSpecification."Source Subtype");
      SETRANGE("Source Batch Name",TrackingSpecification."Source Batch Name");
      IF (TrackingSpecification."Source Type" = DATABASE::"Transfer Line") AND
         (TrackingSpecification."Source Subtype" = 1)
      THEN BEGIN
        SETFILTER("Source Prod. Order Line",'0 | ' + FORMAT(TrackingSpecification."Source Ref. No."));
        SETRANGE("Source Ref. No.");
      END ELSE BEGIN
        SETRANGE("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");
        SETRANGE("Source Ref. No.",TrackingSpecification."Source Ref. No.");
      END;
      SETRANGE("Item No.",TrackingSpecification."Item No.");
      SETRANGE("Location Code",TrackingSpecification."Location Code");
      SETRANGE("Variant Code",TrackingSpecification."Variant Code");
      FILTERGROUP := 0;
    END;

    LOCAL PROCEDURE CheckLine@4(TrackingLine@1000 : Record 336);
    BEGIN
      IF TrackingLine."Quantity (Base)" * SourceQuantityArray[1] < 0 THEN
        IF SourceQuantityArray[1] < 0 THEN
          ERROR(Text002,Text003)
        ELSE
          ERROR(Text002,Text004);
    END;

    LOCAL PROCEDURE CalculateSums@2();
    VAR
      xTrackingSpec@1000 : Record 336;
    BEGIN
      xTrackingSpec.COPY(Rec);
      RESET;
      CALCSUMS("Quantity (Base)",
        "Qty. to Handle (Base)",
        "Qty. to Invoice (Base)");
      TotalItemTrackingLine := Rec;
      COPY(xTrackingSpec);

      UpdateUndefinedQtyArray;
    END;

    LOCAL PROCEDURE UpdateUndefinedQty@5() : Boolean;
    BEGIN
      UpdateUndefinedQtyArray;
      IF ProdOrderLineHandling THEN // Avoid check for prod.journal lines
        EXIT(TRUE);
      EXIT(ABS(SourceQuantityArray[1]) >= ABS(TotalItemTrackingLine."Quantity (Base)"));
    END;

    LOCAL PROCEDURE UpdateUndefinedQtyArray@51();
    BEGIN
      UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalItemTrackingLine."Quantity (Base)";
      UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalItemTrackingLine."Qty. to Handle (Base)";
      UndefinedQtyArray[3] := SourceQuantityArray[3] - TotalItemTrackingLine."Qty. to Invoice (Base)";
    END;

    LOCAL PROCEDURE TempRecIsValid@6() OK@1001 : Boolean;
    VAR
      ReservEntry@1000 : Record 337;
      RecordCount@1002 : Integer;
      IdenticalArray@1003 : ARRAY [2] OF Boolean;
    BEGIN
      OK := FALSE;
      TempReservEntry.SETCURRENTKEY("Entry No.",Positive);
      ReservEntry.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type",
        "Source Subtype","Source Batch Name","Source Prod. Order Line");

      ReservEntry.COPYFILTERS(TempReservEntry);

      IF ReservEntry.FINDSET THEN
        REPEAT
          IF NOT TempReservEntry.GET(ReservEntry."Entry No.",ReservEntry.Positive) THEN
            EXIT(FALSE);
          IF NOT EntriesAreIdentical(ReservEntry,TempReservEntry,IdenticalArray) THEN
            EXIT(FALSE);
          RecordCount += 1;
        UNTIL ReservEntry.NEXT = 0;

      OK := RecordCount = TempReservEntry.COUNT;
    END;

    LOCAL PROCEDURE EntriesAreIdentical@8(VAR ReservEntry1@1000 : Record 337;VAR ReservEntry2@1002 : Record 337;VAR IdenticalArray@1003 : ARRAY [2] OF Boolean) : Boolean;
    BEGIN
      IdenticalArray[1] := (
                            (ReservEntry1."Entry No." = ReservEntry2."Entry No.") AND
                            (ReservEntry1."Item No." = ReservEntry2."Item No.") AND
                            (ReservEntry1."Location Code" = ReservEntry2."Location Code") AND
                            (ReservEntry1."Quantity (Base)" = ReservEntry2."Quantity (Base)") AND
                            (ReservEntry1."Reservation Status" = ReservEntry2."Reservation Status") AND
                            (ReservEntry1."Creation Date" = ReservEntry2."Creation Date") AND
                            (ReservEntry1."Transferred from Entry No." = ReservEntry2."Transferred from Entry No.") AND
                            (ReservEntry1."Source Type" = ReservEntry2."Source Type") AND
                            (ReservEntry1."Source Subtype" = ReservEntry2."Source Subtype") AND
                            (ReservEntry1."Source ID" = ReservEntry2."Source ID") AND
                            (ReservEntry1."Source Batch Name" = ReservEntry2."Source Batch Name") AND
                            (ReservEntry1."Source Prod. Order Line" = ReservEntry2."Source Prod. Order Line") AND
                            (ReservEntry1."Source Ref. No." = ReservEntry2."Source Ref. No.") AND
                            (ReservEntry1."Expected Receipt Date" = ReservEntry2."Expected Receipt Date") AND
                            (ReservEntry1."Shipment Date" = ReservEntry2."Shipment Date") AND
                            (ReservEntry1."Serial No." = ReservEntry2."Serial No.") AND
                            (ReservEntry1."Created By" = ReservEntry2."Created By") AND
                            (ReservEntry1."Changed By" = ReservEntry2."Changed By") AND
                            (ReservEntry1.Positive = ReservEntry2.Positive) AND
                            (ReservEntry1."Qty. per Unit of Measure" = ReservEntry2."Qty. per Unit of Measure") AND
                            (ReservEntry1.Quantity = ReservEntry2.Quantity) AND
                            (ReservEntry1."Action Message Adjustment" = ReservEntry2."Action Message Adjustment") AND
                            (ReservEntry1.Binding = ReservEntry2.Binding) AND
                            (ReservEntry1."Suppressed Action Msg." = ReservEntry2."Suppressed Action Msg.") AND
                            (ReservEntry1."Planning Flexibility" = ReservEntry2."Planning Flexibility") AND
                            (ReservEntry1."Lot No." = ReservEntry2."Lot No.") AND
                            (ReservEntry1."Variant Code" = ReservEntry2."Variant Code") AND
                            (ReservEntry1."Quantity Invoiced (Base)" = ReservEntry2."Quantity Invoiced (Base)"));

      IdenticalArray[2] := (
                            (ReservEntry1.Description = ReservEntry2.Description) AND
                            (ReservEntry1."New Serial No." = ReservEntry2."New Serial No.") AND
                            (ReservEntry1."New Lot No." = ReservEntry2."New Lot No.") AND
                            (ReservEntry1."Expiration Date" = ReservEntry2."Expiration Date") AND
                            (ReservEntry1."Warranty Date" = ReservEntry2."Warranty Date") AND
                            (ReservEntry1."New Expiration Date" = ReservEntry2."New Expiration Date"));

      EXIT(IdenticalArray[1] AND IdenticalArray[2]);
    END;

    LOCAL PROCEDURE QtyToHandleAndInvoiceChanged@14(VAR ReservEntry1@1000 : Record 337;VAR ReservEntry2@1002 : Record 337) : Boolean;
    BEGIN
      EXIT(
        (ReservEntry1."Qty. to Handle (Base)" <> ReservEntry2."Qty. to Handle (Base)") OR
        (ReservEntry1."Qty. to Invoice (Base)" <> ReservEntry2."Qty. to Invoice (Base)"));
    END;

    LOCAL PROCEDURE NextEntryNo@9() : Integer;
    BEGIN
      LastEntryNo += 1;
      EXIT(LastEntryNo);
    END;

    LOCAL PROCEDURE WriteToDatabase@10();
    VAR
      Window@1002 : Dialog;
      ChangeType@1000 : 'Insert,Modify,Delete';
      EntryNo@1001 : Integer;
      NoOfLines@1003 : Integer;
      i@1004 : Integer;
      ModifyLoop@1005 : Integer;
      Decrease@1006 : Boolean;
    BEGIN
      IF CurrentFormIsOpen THEN BEGIN
        TempReservEntry.LOCKTABLE;
        TempRecValid;

        IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
          QtyToAddAsBlank := 0
        ELSE
          QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

        RESET;
        DELETEALL;

        Window.OPEN('#1############# @2@@@@@@@@@@@@@@@@@@@@@');
        Window.UPDATE(1,Text018);
        NoOfLines := TempItemTrackLineInsert.COUNT + TempItemTrackLineModify.COUNT + TempItemTrackLineDelete.COUNT;
        IF TempItemTrackLineDelete.FIND('-') THEN BEGIN
          REPEAT
            i := i + 1;
            IF i MOD 100 = 0 THEN
              Window.UPDATE(2,ROUND(i / NoOfLines * 10000,1));
            RegisterChange(TempItemTrackLineDelete,TempItemTrackLineDelete,ChangeType::Delete,FALSE);
            IF TempItemTrackLineModify.GET(TempItemTrackLineDelete."Entry No.") THEN
              TempItemTrackLineModify.DELETE;
          UNTIL TempItemTrackLineDelete.NEXT = 0;
          TempItemTrackLineDelete.DELETEALL;
        END;

        FOR ModifyLoop := 1 TO 2 DO BEGIN
          IF TempItemTrackLineModify.FIND('-') THEN
            REPEAT
              IF xTempItemTrackingLine.GET(TempItemTrackLineModify."Entry No.") THEN BEGIN
                // Process decreases before increases
                Decrease := (xTempItemTrackingLine."Quantity (Base)" > TempItemTrackLineModify."Quantity (Base)");
                IF ((ModifyLoop = 1) AND Decrease) OR ((ModifyLoop = 2) AND NOT Decrease) THEN BEGIN
                  i := i + 1;
                  IF (xTempItemTrackingLine."Serial No." <> TempItemTrackLineModify."Serial No.") OR
                     (xTempItemTrackingLine."Lot No." <> TempItemTrackLineModify."Lot No.") OR
                     (xTempItemTrackingLine."Appl.-from Item Entry" <> TempItemTrackLineModify."Appl.-from Item Entry") OR
                     (xTempItemTrackingLine."Appl.-to Item Entry" <> TempItemTrackLineModify."Appl.-to Item Entry")
                  THEN BEGIN
                    RegisterChange(xTempItemTrackingLine,xTempItemTrackingLine,ChangeType::Delete,FALSE);
                    RegisterChange(TempItemTrackLineModify,TempItemTrackLineModify,ChangeType::Insert,FALSE);
                    IF (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") OR
                       (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
                    THEN
                      SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
                  END ELSE BEGIN
                    RegisterChange(xTempItemTrackingLine,TempItemTrackLineModify,ChangeType::Modify,FALSE);
                    SetQtyToHandleAndInvoice(TempItemTrackLineModify);
                  END;
                  TempItemTrackLineModify.DELETE;
                END;
              END ELSE BEGIN
                i := i + 1;
                TempItemTrackLineModify.DELETE;
              END;
              IF i MOD 100 = 0 THEN
                Window.UPDATE(2,ROUND(i / NoOfLines * 10000,1));
            UNTIL TempItemTrackLineModify.NEXT = 0;
        END;

        IF TempItemTrackLineInsert.FIND('-') THEN BEGIN
          REPEAT
            i := i + 1;
            IF i MOD 100 = 0 THEN
              Window.UPDATE(2,ROUND(i / NoOfLines * 10000,1));
            IF TempItemTrackLineModify.GET(TempItemTrackLineInsert."Entry No.") THEN
              TempItemTrackLineInsert.TRANSFERFIELDS(TempItemTrackLineModify);
            IF NOT RegisterChange(TempItemTrackLineInsert,TempItemTrackLineInsert,ChangeType::Insert,FALSE) THEN
              ERROR(Text005);
            IF (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") OR
               (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
            THEN
              SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
          UNTIL TempItemTrackLineInsert.NEXT = 0;
          TempItemTrackLineInsert.DELETEALL;
        END;
        Window.CLOSE;
      END ELSE BEGIN
        TempReservEntry.LOCKTABLE;
        TempRecValid;

        IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
          QtyToAddAsBlank := 0
        ELSE
          QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

        RESET;
        SETFILTER("Buffer Status",'<>%1',0);
        DELETEALL;
        RESET;

        xTempItemTrackingLine.RESET;
        SETCURRENTKEY("Entry No.");
        xTempItemTrackingLine.SETCURRENTKEY("Entry No.");
        IF xTempItemTrackingLine.FIND('-') THEN
          REPEAT
            SetTrackingFilterFromSpec(xTempItemTrackingLine);
            IF FIND('-') THEN BEGIN
              IF RegisterChange(xTempItemTrackingLine,Rec,ChangeType::Modify,FALSE) THEN BEGIN
                EntryNo := xTempItemTrackingLine."Entry No.";
                xTempItemTrackingLine := Rec;
                xTempItemTrackingLine."Entry No." := EntryNo;
                xTempItemTrackingLine.MODIFY;
              END;
              SetQtyToHandleAndInvoice(Rec);
              DELETE;
            END ELSE BEGIN
              RegisterChange(xTempItemTrackingLine,xTempItemTrackingLine,ChangeType::Delete,FALSE);
              xTempItemTrackingLine.DELETE;
            END;
          UNTIL xTempItemTrackingLine.NEXT = 0;

        RESET;

        IF FIND('-') THEN
          REPEAT
            IF RegisterChange(Rec,Rec,ChangeType::Insert,FALSE) THEN BEGIN
              xTempItemTrackingLine := Rec;
              xTempItemTrackingLine.INSERT;
            END ELSE
              ERROR(Text005);
            SetQtyToHandleAndInvoice(Rec);
            DELETE;
          UNTIL NEXT = 0;
      END;

      UpdateOrderTracking;
      ReestablishReservations; // Late Binding

      IF NOT BlockCommit THEN
        COMMIT;
    END;

    LOCAL PROCEDURE RegisterChange@11(VAR OldTrackingSpecification@1000 : Record 336;VAR NewTrackingSpecification@1001 : Record 336;ChangeType@1002 : 'Insert,Modify,FullDelete,PartDelete,ModifyAll';ModifySharedFields@1011 : Boolean) OK@1003 : Boolean;
    VAR
      ReservEntry1@1004 : Record 337;
      ReservEntry2@1005 : Record 337;
      CreateReservEntry@1006 : Codeunit 99000830;
      ReservationMgt@1007 : Codeunit 99000845;
      QtyToAdd@1012 : Decimal;
      LostReservQty@1013 : Decimal;
      IdenticalArray@1010 : ARRAY [2] OF Boolean;
    BEGIN
      OK := FALSE;

      IF ((CurrentSignFactor * NewTrackingSpecification."Qty. to Handle") < 0) AND
         (FormRunMode <> FormRunMode::"Drop Shipment")
      THEN BEGIN
        NewTrackingSpecification."Expiration Date" := 0D;
        OldTrackingSpecification."Expiration Date" := 0D;
      END;

      CASE ChangeType OF
        ChangeType::Insert:
          BEGIN
            IF (OldTrackingSpecification."Quantity (Base)" = 0) OR NOT OldTrackingSpecification.TrackingExists THEN
              EXIT(TRUE);
            TempReservEntry.SetTrackingFilter('','');
            OldTrackingSpecification."Quantity (Base)" :=
              CurrentSignFactor *
              ReservEngineMgt.AddItemTrackingToTempRecSet(
                TempReservEntry,NewTrackingSpecification,
                CurrentSignFactor * OldTrackingSpecification."Quantity (Base)",QtyToAddAsBlank,
                ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
            TempReservEntry.ClearTrackingFilter;

            // Late Binding
            IF ReservEngineMgt.RetrieveLostReservQty(LostReservQty) THEN BEGIN
              TempItemTrackLineReserv := NewTrackingSpecification;
              TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
              TempItemTrackLineReserv.INSERT;
            END;

            IF OldTrackingSpecification."Quantity (Base)" = 0 THEN
              EXIT(TRUE);

            IF FormRunMode = FormRunMode::Reclass THEN BEGIN
              CreateReservEntry.SetNewSerialLotNo(
                OldTrackingSpecification."New Serial No.",OldTrackingSpecification."New Lot No.");
              CreateReservEntry.SetNewExpirationDate(OldTrackingSpecification."New Expiration Date");
            END;
            CreateReservEntry.SetDates(
              NewTrackingSpecification."Warranty Date",NewTrackingSpecification."Expiration Date");
            CreateReservEntry.SetApplyFromEntryNo(NewTrackingSpecification."Appl.-from Item Entry");
            CreateReservEntry.SetApplyToEntryNo(NewTrackingSpecification."Appl.-to Item Entry");
            CreateReservEntry.CreateReservEntryFor(
              OldTrackingSpecification."Source Type",
              OldTrackingSpecification."Source Subtype",
              OldTrackingSpecification."Source ID",
              OldTrackingSpecification."Source Batch Name",
              OldTrackingSpecification."Source Prod. Order Line",
              OldTrackingSpecification."Source Ref. No.",
              OldTrackingSpecification."Qty. per Unit of Measure",
              0,
              OldTrackingSpecification."Quantity (Base)",
              OldTrackingSpecification."Serial No.",
              OldTrackingSpecification."Lot No.");
            CreateReservEntry.CreateEntry(OldTrackingSpecification."Item No.",
              OldTrackingSpecification."Variant Code",
              OldTrackingSpecification."Location Code",
              OldTrackingSpecification.Description,
              ExpectedReceiptDate,
              ShipmentDate,0,CurrentEntryStatus);
            CreateReservEntry.GetLastEntry(ReservEntry1);
            IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN
              ReservEngineMgt.UpdateActionMessages(ReservEntry1);

            IF ModifySharedFields THEN BEGIN
              ReservEntry1.SetPointerFilter;
              ReservEntry1.SetTrackingFilterFromReservEntry(ReservEntry1);
              ReservEntry1.SETFILTER("Entry No.",'<>%1',ReservEntry1."Entry No.");
              ModifyFieldsWithinFilter(ReservEntry1,NewTrackingSpecification);
            END;

            OK := TRUE;
          END;
        ChangeType::Modify:
          BEGIN
            ReservEntry1.TRANSFERFIELDS(OldTrackingSpecification);
            ReservEntry2.TRANSFERFIELDS(NewTrackingSpecification);

            ReservEntry1."Entry No." := ReservEntry2."Entry No."; // If only entry no. has changed it should not trigger
            IF EntriesAreIdentical(ReservEntry1,ReservEntry2,IdenticalArray) THEN
              EXIT(QtyToHandleAndInvoiceChanged(ReservEntry1,ReservEntry2));

            IF ABS(OldTrackingSpecification."Quantity (Base)") < ABS(NewTrackingSpecification."Quantity (Base)") THEN BEGIN
              // Item Tracking is added to any blank reservation entries:
              TempReservEntry.SetTrackingFilter('','');
              QtyToAdd :=
                CurrentSignFactor *
                ReservEngineMgt.AddItemTrackingToTempRecSet(
                  TempReservEntry,NewTrackingSpecification,
                  CurrentSignFactor * (NewTrackingSpecification."Quantity (Base)" -
                                       OldTrackingSpecification."Quantity (Base)"),QtyToAddAsBlank,
                  ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
              TempReservEntry.ClearTrackingFilter;

              // Late Binding
              IF ReservEngineMgt.RetrieveLostReservQty(LostReservQty) THEN BEGIN
                TempItemTrackLineReserv := NewTrackingSpecification;
                TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                TempItemTrackLineReserv.INSERT;
              END;

              OldTrackingSpecification."Quantity (Base)" := QtyToAdd;
              OldTrackingSpecification."Warranty Date" := NewTrackingSpecification."Warranty Date";
              OldTrackingSpecification."Expiration Date" := NewTrackingSpecification."Expiration Date";
              OldTrackingSpecification.Description := NewTrackingSpecification.Description;
              OnAfterCopyTrackingSpec(NewTrackingSpecification,OldTrackingSpecification);

              RegisterChange(OldTrackingSpecification,OldTrackingSpecification,
                ChangeType::Insert,NOT IdenticalArray[2]);
            END ELSE BEGIN
              TempReservEntry.SetTrackingFilterFromSpec(OldTrackingSpecification);
              OldTrackingSpecification.ClearTracking;
              OnAfterClearTrackingSpec(OldTrackingSpecification);
              QtyToAdd :=
                CurrentSignFactor *
                ReservEngineMgt.AddItemTrackingToTempRecSet(
                  TempReservEntry,OldTrackingSpecification,
                  CurrentSignFactor * (OldTrackingSpecification."Quantity (Base)" -
                                       NewTrackingSpecification."Quantity (Base)"),QtyToAddAsBlank,
                  ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
              TempReservEntry.ClearTrackingFilter;
              RegisterChange(NewTrackingSpecification,NewTrackingSpecification,
                ChangeType::PartDelete,NOT IdenticalArray[2]);
            END;
            OK := TRUE;
          END;
        ChangeType::FullDelete,ChangeType::PartDelete:
          BEGIN
            ReservationMgt.SetItemTrackingHandling(1); // Allow deletion of Item Tracking
            ReservEntry1.TRANSFERFIELDS(OldTrackingSpecification);
            ReservEntry1.SetPointerFilter;
            ReservEntry1.SetTrackingFilterFromReservEntry(ReservEntry1);
            IF ChangeType = ChangeType::FullDelete THEN BEGIN
              TempReservEntry.SetTrackingFilterFromSpec(OldTrackingSpecification);
              OldTrackingSpecification.ClearTracking;
              OnAfterClearTrackingSpec(OldTrackingSpecification);
              QtyToAdd :=
                CurrentSignFactor *
                ReservEngineMgt.AddItemTrackingToTempRecSet(
                  TempReservEntry,OldTrackingSpecification,
                  CurrentSignFactor * OldTrackingSpecification."Quantity (Base)",QtyToAddAsBlank,
                  ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
              TempReservEntry.ClearTrackingFilter;
              ReservationMgt.DeleteReservEntries2(TRUE,0,ReservEntry1)
            END ELSE BEGIN
              ReservationMgt.DeleteReservEntries2(FALSE,ReservEntry1."Quantity (Base)" -
                OldTrackingSpecification."Quantity Handled (Base)",ReservEntry1);
              IF ModifySharedFields THEN BEGIN
                ReservEntry1.SETRANGE("Reservation Status");
                ModifyFieldsWithinFilter(ReservEntry1,OldTrackingSpecification);
              END;
            END;
            OK := TRUE;
          END;
      END;
      SetQtyToHandleAndInvoice(NewTrackingSpecification);
    END;

    LOCAL PROCEDURE UpdateOrderTracking@26();
    VAR
      TempReservEntry@1000 : TEMPORARY Record 337;
    BEGIN
      IF NOT ReservEngineMgt.CollectAffectedSurplusEntries(TempReservEntry) THEN
        EXIT;
      IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
        EXIT;
      ReservEngineMgt.UpdateOrderTracking(TempReservEntry);
    END;

    LOCAL PROCEDURE ModifyFieldsWithinFilter@25(VAR ReservEntry1@1000 : Record 337;VAR TrackingSpecification@1001 : Record 336);
    BEGIN
      // Used to ensure that field values that are common to a SN/Lot are copied to all entries.
      IF ReservEntry1.FIND('-') THEN
        REPEAT
          ReservEntry1.Description := TrackingSpecification.Description;
          ReservEntry1."Warranty Date" := TrackingSpecification."Warranty Date";
          ReservEntry1."Expiration Date" := TrackingSpecification."Expiration Date";
          ReservEntry1."New Serial No." := TrackingSpecification."New Serial No.";
          ReservEntry1."New Lot No." := TrackingSpecification."New Lot No.";
          ReservEntry1."New Expiration Date" := TrackingSpecification."New Expiration Date";
          OnAfterMoveFields(TrackingSpecification,ReservEntry1);
          ReservEntry1.MODIFY;
        UNTIL ReservEntry1.NEXT = 0;
    END;

    LOCAL PROCEDURE SetQtyToHandleAndInvoice@7(TrackingSpecification@1000 : Record 336);
    VAR
      ReservEntry1@1003 : Record 337;
      TotalQtyToHandle@1001 : Decimal;
      TotalQtyToInvoice@1002 : Decimal;
      QtyToHandleThisLine@1007 : Decimal;
      QtyToInvoiceThisLine@1006 : Decimal;
    BEGIN
      IF IsCorrection THEN
        EXIT;

      TotalQtyToHandle := TrackingSpecification."Qty. to Handle (Base)" * CurrentSignFactor;
      TotalQtyToInvoice := TrackingSpecification."Qty. to Invoice (Base)" * CurrentSignFactor;

      ReservEntry1.TRANSFERFIELDS(TrackingSpecification);
      ReservEntry1.SetPointerFilter;
      ReservEntry1.SetTrackingFilterFromReservEntry(ReservEntry1);
      IF TrackingSpecification.TrackingExists THEN BEGIN
        ItemTrackingMgt.SetPointerFilter(TrackingSpecification);
        TrackingSpecification.SetTrackingFilterFromSpec(TrackingSpecification);
        IF TrackingSpecification.FIND('-') THEN
          REPEAT
            IF NOT TrackingSpecification.Correction THEN BEGIN
              QtyToInvoiceThisLine :=
                TrackingSpecification."Quantity Handled (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
              IF ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) THEN
                QtyToInvoiceThisLine := TotalQtyToInvoice;

              IF TrackingSpecification."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine THEN BEGIN
                TrackingSpecification."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                TrackingSpecification.MODIFY;
              END;

              TotalQtyToInvoice -= QtyToInvoiceThisLine;
            END;
          UNTIL (TrackingSpecification.NEXT = 0);
      END;

      IF TrackingSpecification."Lot No." <> '' THEN
        FOR ReservEntry1."Reservation Status" := ReservEntry1."Reservation Status"::Reservation TO
            ReservEntry1."Reservation Status"::Prospect
        DO BEGIN
          ReservEntry1.SETRANGE("Reservation Status",ReservEntry1."Reservation Status");
          IF ReservEntry1.FIND('-') THEN
            REPEAT
              QtyToHandleThisLine := ReservEntry1."Quantity (Base)";
              QtyToInvoiceThisLine := QtyToHandleThisLine;

              IF ABS(QtyToHandleThisLine) > ABS(TotalQtyToHandle) THEN
                QtyToHandleThisLine := TotalQtyToHandle;
              IF ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) THEN
                QtyToInvoiceThisLine := TotalQtyToInvoice;

              IF (ReservEntry1."Qty. to Handle (Base)" <> QtyToHandleThisLine) OR
                 (ReservEntry1."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine) AND NOT ReservEntry1.Correction
              THEN BEGIN
                ReservEntry1."Qty. to Handle (Base)" := QtyToHandleThisLine;
                ReservEntry1."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                ReservEntry1.MODIFY;
              END;

              TotalQtyToHandle -= QtyToHandleThisLine;
              TotalQtyToInvoice -= QtyToInvoiceThisLine;

            UNTIL (ReservEntry1.NEXT = 0);
        END
      ELSE
        IF ReservEntry1.FIND('-') THEN
          IF (ReservEntry1."Qty. to Handle (Base)" <> TotalQtyToHandle) OR
             (ReservEntry1."Qty. to Invoice (Base)" <> TotalQtyToInvoice) AND NOT ReservEntry1.Correction
          THEN BEGIN
            ReservEntry1."Qty. to Handle (Base)" := TotalQtyToHandle;
            ReservEntry1."Qty. to Invoice (Base)" := TotalQtyToInvoice;
            ReservEntry1.MODIFY;
          END;
    END;

    LOCAL PROCEDURE CollectPostedTransferEntries@16(TrackingSpecification@1001 : Record 336;VAR TempTrackingSpecification@1000 : TEMPORARY Record 336);
    VAR
      ItemEntryRelation@1002 : Record 6507;
      ItemLedgerEntry@1003 : Record 32;
    BEGIN
      // Used for collecting information about posted Transfer Shipments from the created Item Ledger Entries.
      IF TrackingSpecification."Source Type" <> DATABASE::"Transfer Line" THEN
        EXIT;

      ItemEntryRelation.SETCURRENTKEY("Order No.","Order Line No.");
      ItemEntryRelation.SETRANGE("Order No.",TrackingSpecification."Source ID");
      ItemEntryRelation.SETRANGE("Order Line No.",TrackingSpecification."Source Ref. No.");

      CASE TrackingSpecification."Source Subtype" OF
        0: // Outbound
          ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Transfer Shipment Line");
        1: // Inbound
          ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Transfer Receipt Line");
      END;

      IF ItemEntryRelation.FIND('-') THEN
        REPEAT
          ItemLedgerEntry.GET(ItemEntryRelation."Item Entry No.");
          TempTrackingSpecification := TrackingSpecification;
          TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
          TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
          TempTrackingSpecification.CopyTrackingFromItemLedgEntry(ItemLedgerEntry);
          TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
          TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
          TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
          TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
          TempTrackingSpecification.InitQtyToShip;
          TempTrackingSpecification.INSERT;
        UNTIL ItemEntryRelation.NEXT = 0;
    END;

    LOCAL PROCEDURE CollectPostedAssemblyEntries@38(TrackingSpecification@1001 : Record 336;VAR TempTrackingSpecification@1000 : TEMPORARY Record 336);
    VAR
      ItemEntryRelation@1002 : Record 6507;
      ItemLedgerEntry@1003 : Record 32;
    BEGIN
      // Used for collecting information about posted Assembly Lines from the created Item Ledger Entries.
      IF (TrackingSpecification."Source Type" <> DATABASE::"Assembly Line") AND
         (TrackingSpecification."Source Type" <> DATABASE::"Assembly Header")
      THEN
        EXIT;

      ItemEntryRelation.SETCURRENTKEY("Order No.","Order Line No.");
      ItemEntryRelation.SETRANGE("Order No.",TrackingSpecification."Source ID");
      ItemEntryRelation.SETRANGE("Order Line No.",TrackingSpecification."Source Ref. No.");
      IF TrackingSpecification."Source Type" = DATABASE::"Assembly Line" THEN
        ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Posted Assembly Line")
      ELSE
        ItemEntryRelation.SETRANGE("Source Type",DATABASE::"Posted Assembly Header");

      IF ItemEntryRelation.FIND('-') THEN
        REPEAT
          ItemLedgerEntry.GET(ItemEntryRelation."Item Entry No.");
          TempTrackingSpecification := TrackingSpecification;
          TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
          TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
          TempTrackingSpecification.CopyTrackingFromItemLedgEntry(ItemLedgerEntry);
          TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
          TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
          TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
          TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
          TempTrackingSpecification.InitQtyToShip;
          TempTrackingSpecification.INSERT;
        UNTIL ItemEntryRelation.NEXT = 0;
    END;

    LOCAL PROCEDURE CollectPostedOutputEntries@30(TrackingSpecification@1001 : Record 336;VAR TempTrackingSpecification@1000 : TEMPORARY Record 336);
    VAR
      ItemLedgerEntry@1003 : Record 32;
      ProdOrderRoutingLine@1004 : Record 5409;
      BackwardFlushing@1002 : Boolean;
    BEGIN
      // Used for collecting information about posted prod. order output from the created Item Ledger Entries.
      IF TrackingSpecification."Source Type" <> DATABASE::"Prod. Order Line" THEN
        EXIT;

      IF (TrackingSpecification."Source Type" = DATABASE::"Prod. Order Line") AND
         (TrackingSpecification."Source Subtype" = 3)
      THEN BEGIN
        ProdOrderRoutingLine.SETRANGE(Status,TrackingSpecification."Source Subtype");
        ProdOrderRoutingLine.SETRANGE("Prod. Order No.",TrackingSpecification."Source ID");
        ProdOrderRoutingLine.SETRANGE("Routing Reference No.",TrackingSpecification."Source Prod. Order Line");
        IF ProdOrderRoutingLine.FINDLAST THEN
          BackwardFlushing :=
            ProdOrderRoutingLine."Flushing Method" = ProdOrderRoutingLine."Flushing Method"::Backward;
      END;

      ItemLedgerEntry.SETCURRENTKEY("Order Type","Order No.","Order Line No.","Entry Type");
      ItemLedgerEntry.SETRANGE("Order Type",ItemLedgerEntry."Order Type"::Production);
      ItemLedgerEntry.SETRANGE("Order No.",TrackingSpecification."Source ID");
      ItemLedgerEntry.SETRANGE("Order Line No.",TrackingSpecification."Source Prod. Order Line");
      ItemLedgerEntry.SETRANGE("Entry Type",ItemLedgerEntry."Entry Type"::Output);

      IF ItemLedgerEntry.FIND('-') THEN
        REPEAT
          TempTrackingSpecification := TrackingSpecification;
          TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
          TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
          TempTrackingSpecification.CopyTrackingFromItemLedgEntry(ItemLedgerEntry);
          TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
          TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
          TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
          TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
          TempTrackingSpecification.InitQtyToShip;
          TempTrackingSpecification.INSERT;

          IF BackwardFlushing THEN BEGIN
            SourceQuantityArray[1] += ItemLedgerEntry.Quantity;
            SourceQuantityArray[2] += ItemLedgerEntry.Quantity;
            SourceQuantityArray[3] += ItemLedgerEntry.Quantity;
          END;

        UNTIL ItemLedgerEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE ZeroLineExists@18() OK@1000 : Boolean;
    VAR
      xTrackingSpec@1001 : Record 336;
    BEGIN
      IF ("Quantity (Base)" <> 0) OR TrackingExists THEN
        EXIT(FALSE);
      xTrackingSpec.COPY(Rec);
      RESET;
      SETRANGE("Quantity (Base)",0);
      SetTrackingFilter('','');
      OK := NOT ISEMPTY;
      COPY(xTrackingSpec);
    END;

    LOCAL PROCEDURE AssignSerialNo@20();
    VAR
      EnterQuantityToCreate@1001 : Page 6513;
      QtyToCreate@1002 : Decimal;
      QtyToCreateInt@1000 : Integer;
      CreateLotNo@1004 : Boolean;
    BEGIN
      IF ZeroLineExists THEN
        DELETE;

      QtyToCreate := UndefinedQtyArray[1] * QtySignFactor;
      IF QtyToCreate < 0 THEN
        QtyToCreate := 0;

      IF QtyToCreate MOD 1 <> 0 THEN
        ERROR(Text008);

      QtyToCreateInt := QtyToCreate;

      CLEAR(EnterQuantityToCreate);
      EnterQuantityToCreate.SetFields("Item No.","Variant Code",QtyToCreate,FALSE);
      IF EnterQuantityToCreate.RUNMODAL = ACTION::OK THEN BEGIN
        EnterQuantityToCreate.GetFields(QtyToCreateInt,CreateLotNo);
        AssignSerialNoBatch(QtyToCreateInt,CreateLotNo);
      END;
    END;

    LOCAL PROCEDURE AssignSerialNoBatch@29(QtyToCreate@1001 : Integer;CreateLotNo@1002 : Boolean);
    VAR
      i@1004 : Integer;
    BEGIN
      IF QtyToCreate <= 0 THEN
        ERROR(Text009);
      IF QtyToCreate MOD 1 <> 0 THEN
        ERROR(Text008);

      GetItem("Item No.");

      IF CreateLotNo THEN BEGIN
        TESTFIELD("Lot No.",'');
        Item.TESTFIELD("Lot Nos.");
        VALIDATE("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WORKDATE,TRUE));
      END;

      Item.TESTFIELD("Serial Nos.");
      ItemTrackingDataCollection.SetSkipLot(TRUE);
      FOR i := 1 TO QtyToCreate DO BEGIN
        VALIDATE("Quantity Handled (Base)",0);
        VALIDATE("Quantity Invoiced (Base)",0);
        VALIDATE("Serial No.",NoSeriesMgt.GetNextNo(Item."Serial Nos.",WORKDATE,TRUE));
        OnAfterAssignNewTrackingNo(Rec);
        VALIDATE("Quantity (Base)",QtySignFactor);
        "Entry No." := NextEntryNo;
        IF TestTempSpecificationExists THEN
          ERROR('');
        INSERT;
        TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
        TempItemTrackLineInsert.INSERT;
        IF i = QtyToCreate THEN
          ItemTrackingDataCollection.SetSkipLot(FALSE);
        ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
          TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
      END;
      CalculateSums;
    END;

    LOCAL PROCEDURE AssignLotNo@21();
    VAR
      QtyToCreate@1000 : Decimal;
    BEGIN
      IF ZeroLineExists THEN
        DELETE;

      IF (SourceQuantityArray[1] * UndefinedQtyArray[1] <= 0) OR
         (ABS(SourceQuantityArray[1]) < ABS(UndefinedQtyArray[1]))
      THEN
        QtyToCreate := 0
      ELSE
        QtyToCreate := UndefinedQtyArray[1];

      GetItem("Item No.");

      Item.TESTFIELD("Lot Nos.");
      VALIDATE("Quantity Handled (Base)",0);
      VALIDATE("Quantity Invoiced (Base)",0);
      VALIDATE("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WORKDATE,TRUE));
      OnAfterAssignNewTrackingNo(Rec);
      "Qty. per Unit of Measure" := QtyPerUOM;
      VALIDATE("Quantity (Base)",QtyToCreate);
      "Entry No." := NextEntryNo;
      TestTempSpecificationExists;
      INSERT;
      TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
      TempItemTrackLineInsert.INSERT;
      ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
        TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
      CalculateSums;
    END;

    LOCAL PROCEDURE CreateCustomizedSN@22();
    VAR
      EnterCustomizedSN@1001 : Page 6515;
      QtyToCreate@1002 : Decimal;
      QtyToCreateInt@1000 : Integer;
      Increment@1004 : Integer;
      CreateLotNo@1005 : Boolean;
      CustomizedSN@1006 : Code[20];
    BEGIN
      IF ZeroLineExists THEN
        DELETE;

      QtyToCreate := UndefinedQtyArray[1] * QtySignFactor;
      IF QtyToCreate < 0 THEN
        QtyToCreate := 0;

      IF QtyToCreate MOD 1 <> 0 THEN
        ERROR(Text008);

      QtyToCreateInt := QtyToCreate;

      CLEAR(EnterCustomizedSN);
      EnterCustomizedSN.SetFields("Item No.","Variant Code",QtyToCreate,FALSE);
      IF EnterCustomizedSN.RUNMODAL = ACTION::OK THEN BEGIN
        EnterCustomizedSN.GetFields(QtyToCreateInt,CreateLotNo,CustomizedSN,Increment);
        CreateCustomizedSNBatch(QtyToCreateInt,CreateLotNo,CustomizedSN,Increment);
      END;
      CalculateSums;
    END;

    LOCAL PROCEDURE CreateCustomizedSNBatch@28(QtyToCreate@1001 : Decimal;CreateLotNo@1002 : Boolean;CustomizedSN@1003 : Code[20];Increment@1004 : Integer);
    VAR
      TextManagement@1005 : Codeunit 41;
      i@1000 : Integer;
      Counter@1007 : Integer;
    BEGIN
      TextManagement.EvaluateIncStr(CustomizedSN,CustomizedSN);
      NoSeriesMgt.TestManual(Item."Serial Nos.");

      IF QtyToCreate <= 0 THEN
        ERROR(Text009);
      IF QtyToCreate MOD 1 <> 0 THEN
        ERROR(Text008);

      IF CreateLotNo THEN BEGIN
        TESTFIELD("Lot No.",'');
        Item.TESTFIELD("Lot Nos.");
        VALIDATE("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WORKDATE,TRUE));
        OnAfterAssignNewTrackingNo(Rec);
      END;

      FOR i := 1 TO QtyToCreate DO BEGIN
        VALIDATE("Quantity Handled (Base)",0);
        VALIDATE("Quantity Invoiced (Base)",0);
        VALIDATE("Serial No.",CustomizedSN);
        OnAfterAssignNewTrackingNo(Rec);
        VALIDATE("Quantity (Base)",QtySignFactor);
        "Entry No." := NextEntryNo;
        IF TestTempSpecificationExists THEN
          ERROR('');
        INSERT;
        TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
        TempItemTrackLineInsert.INSERT;
        ItemTrackingDataCollection.UpdateTrackingDataSetWithChange(
          TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
        IF i < QtyToCreate THEN BEGIN
          Counter := Increment;
          REPEAT
            CustomizedSN := INCSTR(CustomizedSN);
            Counter := Counter - 1;
          UNTIL Counter <= 0;
        END;
      END;
      CalculateSums;
    END;

    LOCAL PROCEDURE TestTempSpecificationExists@23() Exists@1000 : Boolean;
    VAR
      TrackingSpecification@1004 : Record 336;
    BEGIN
      TrackingSpecification.COPY(Rec);
      SETCURRENTKEY("Lot No.","Serial No.");
      SETRANGE("Serial No.","Serial No.");
      IF "Serial No." = '' THEN
        SETRANGE("Lot No.","Lot No.");
      SETFILTER("Entry No.",'<>%1',"Entry No.");
      SETRANGE("Buffer Status",0);
      Exists := NOT ISEMPTY;
      COPY(TrackingSpecification);
      IF Exists AND CurrentFormIsOpen THEN
        IF "Serial No." = '' THEN
          MESSAGE(Text011,"Serial No.","Lot No.")
        ELSE
          MESSAGE(Text012,"Serial No.");
    END;

    LOCAL PROCEDURE TestExpirationDateMismatchOnTempSpec@34() Mismatch : Boolean;
    VAR
      TrackingSpecification@1000 : Record 336;
    BEGIN
      IF ("Expiration Date" = 0D) OR ("Lot No." = '') THEN
        EXIT(FALSE);

      TrackingSpecification.COPY(Rec);
      SETFILTER("Entry No.",'<>%1',"Entry No.");
      IF ISEMPTY THEN
        Mismatch := FALSE
      ELSE BEGIN
        SETRANGE("Lot No.","Lot No.");
        SETFILTER("Expiration Date",'<>%1',"Expiration Date");
        SETRANGE("Buffer Status",0);
        Mismatch := NOT ISEMPTY;
      END;
      COPY(TrackingSpecification);
      IF Mismatch AND CurrentFormIsOpen THEN
        MESSAGE(DifferentExpDateMsg,"Lot No.","Expiration Date");
    END;

    LOCAL PROCEDURE VerifyNewTrackingSpecification@61() : Boolean;
    BEGIN
      IF TestTempSpecificationExists THEN
        EXIT(FALSE);

      EXIT(NOT TestExpirationDateMismatchOnTempSpec);
    END;

    LOCAL PROCEDURE QtySignFactor@24() : Integer;
    BEGIN
      IF SourceQuantityArray[1] < 0 THEN
        EXIT(-1);

      EXIT(1)
    END;

    [External]
    PROCEDURE RegisterItemTrackingLines@27(SourceSpecification@1001 : Record 336;AvailabilityDate@1002 : Date;VAR TempTrackingSpecification@1000 : TEMPORARY Record 336);
    BEGIN
      SourceSpecification.TESTFIELD("Source Type"); // Check if source has been set.
      IF NOT CalledFromSynchWhseItemTrkg THEN
        TempTrackingSpecification.RESET;
      IF NOT TempTrackingSpecification.FIND('-') THEN
        EXIT;

      IsCorrection := SourceSpecification.Correction;
      ExcludePostedEntries := TRUE;
      SetSourceSpec(SourceSpecification,AvailabilityDate);
      RESET;
      SETCURRENTKEY("Lot No.","Serial No.");

      REPEAT
        SetTrackingFilterFromSpec(TempTrackingSpecification);
        IF FIND('-') THEN BEGIN
          IF IsCorrection THEN BEGIN
            "Quantity (Base)" += TempTrackingSpecification."Quantity (Base)";
            "Qty. to Handle (Base)" += TempTrackingSpecification."Qty. to Handle (Base)";
            "Qty. to Invoice (Base)" += TempTrackingSpecification."Qty. to Invoice (Base)";
          END ELSE
            VALIDATE("Quantity (Base)","Quantity (Base)" + TempTrackingSpecification."Quantity (Base)");
          MODIFY;
        END ELSE BEGIN
          TRANSFERFIELDS(SourceSpecification);
          "Serial No." := TempTrackingSpecification."Serial No.";
          "Lot No." := TempTrackingSpecification."Lot No.";
          "Warranty Date" := TempTrackingSpecification."Warranty Date";
          "Expiration Date" := TempTrackingSpecification."Expiration Date";
          IF FormRunMode = FormRunMode::Reclass THEN BEGIN
            "New Serial No." := TempTrackingSpecification."New Serial No.";
            "New Lot No." := TempTrackingSpecification."New Lot No.";
            "New Expiration Date" := TempTrackingSpecification."New Expiration Date"
          END;
          OnAfterCopyTrackingSpec(TempTrackingSpecification,Rec);
          VALIDATE("Quantity (Base)",TempTrackingSpecification."Quantity (Base)");
          "Entry No." := NextEntryNo;
          INSERT;
        END;
      UNTIL TempTrackingSpecification.NEXT = 0;
      RESET;
      IF FIND('-') THEN
        REPEAT
          CheckLine(Rec);
        UNTIL NEXT = 0;

      SetTrackingFilterFromSpec(SourceSpecification);

      CalculateSums;
      IF UpdateUndefinedQty THEN
        WriteToDatabase
      ELSE
        ERROR(Text014,TotalItemTrackingLine."Quantity (Base)",
          LOWERCASE(TempReservEntry.TextCaption),SourceQuantityArray[1]);

      // Copy to inbound part of transfer
      IF FormRunMode = FormRunMode::Transfer THEN
        SynchronizeLinkedSources('');
    END;

    LOCAL PROCEDURE SynchronizeLinkedSources@31(DialogText@1000 : Text[250]) : Boolean;
    BEGIN
      IF CurrentSourceRowID = '' THEN
        EXIT(FALSE);
      IF SecondSourceRowID = '' THEN
        EXIT(FALSE);

      ItemTrackingMgt.SynchronizeItemTracking(CurrentSourceRowID,SecondSourceRowID,DialogText);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE SetBlockCommit@33(NewBlockCommit@1000 : Boolean);
    BEGIN
      BlockCommit := NewBlockCommit;
    END;

    [External]
    PROCEDURE SetCalledFromSynchWhseItemTrkg@39(CalledFromSynchWhseItemTrkg2@1000 : Boolean);
    BEGIN
      CalledFromSynchWhseItemTrkg := CalledFromSynchWhseItemTrkg2;
    END;

    LOCAL PROCEDURE UpdateExpDateColor@41();
    BEGIN
      IF ("Buffer Status2" = "Buffer Status2"::"ExpDate blocked") OR (CurrentSignFactor < 0) THEN;
    END;

    LOCAL PROCEDURE UpdateExpDateEditable@42();
    BEGIN
      ExpirationDateEditable :=
        NOT (("Buffer Status2" = "Buffer Status2"::"ExpDate blocked") OR (CurrentSignFactor < 0));
    END;

    LOCAL PROCEDURE LookupAvailable@43(LookupMode@1000 : 'Serial No.,Lot No.');
    BEGIN
      "Bin Code" := ForBinCode;
      ItemTrackingDataCollection.LookupTrackingAvailability(Rec,LookupMode);
      "Bin Code" := '';
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE TrackingAvailable@45(VAR TrackingSpecification@1000 : Record 336;LookupMode@1001 : 'Serial No.,Lot No.') : Boolean;
    BEGIN
      EXIT(ItemTrackingDataCollection.TrackingAvailable(TrackingSpecification,LookupMode));
    END;

    LOCAL PROCEDURE SelectEntries@36();
    VAR
      xTrackingSpec@1001 : Record 336;
      MaxQuantity@1000 : Decimal;
    BEGIN
      xTrackingSpec.COPYFILTERS(Rec);
      MaxQuantity := UndefinedQtyArray[1];
      IF MaxQuantity * CurrentSignFactor > 0 THEN
        MaxQuantity := 0;
      "Bin Code" := ForBinCode;
      ItemTrackingDataCollection.SelectMultipleTrackingNo(Rec,MaxQuantity,CurrentSignFactor);
      "Bin Code" := '';
      IF FINDSET THEN
        REPEAT
          CASE "Buffer Status" OF
            "Buffer Status"::MODIFY:
              BEGIN
                IF TempItemTrackLineModify.GET("Entry No.") THEN
                  TempItemTrackLineModify.DELETE;
                IF TempItemTrackLineInsert.GET("Entry No.") THEN BEGIN
                  TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                  TempItemTrackLineInsert.MODIFY;
                END ELSE BEGIN
                  TempItemTrackLineModify.TRANSFERFIELDS(Rec);
                  TempItemTrackLineModify.INSERT;
                END;
              END;
            "Buffer Status"::INSERT:
              BEGIN
                TempItemTrackLineInsert.TRANSFERFIELDS(Rec);
                TempItemTrackLineInsert.INSERT;
              END;
          END;
          "Buffer Status" := 0;
          MODIFY;
        UNTIL NEXT = 0;
      LastEntryNo := "Entry No.";
      CalculateSums;
      UpdateUndefinedQtyArray;
      COPYFILTERS(xTrackingSpec);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ReestablishReservations@47();
    VAR
      LateBindingMgt@1000 : Codeunit 6502;
    BEGIN
      IF TempItemTrackLineReserv.FINDSET THEN
        REPEAT
          LateBindingMgt.ReserveItemTrackingLine2(TempItemTrackLineReserv,0,TempItemTrackLineReserv."Quantity (Base)");
          SetQtyToHandleAndInvoice(TempItemTrackLineReserv);
        UNTIL TempItemTrackLineReserv.NEXT = 0;
      TempItemTrackLineReserv.DELETEALL;
    END;

    [External]
    PROCEDURE SetInbound@48(NewInbound@1000 : Boolean);
    BEGIN
      InboundIsSet := TRUE;
      Inbound := NewInbound;
    END;

    LOCAL PROCEDURE SerialNoOnAfterValidate@19074494();
    BEGIN
      UpdateExpDateEditable;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE LotNoOnAfterValidate@19045288();
    BEGIN
      UpdateExpDateEditable;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE QuantityBaseOnAfterValidate@19029188();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE QuantityBaseOnValidate@19070694();
    BEGIN
      CheckLine(Rec);
    END;

    LOCAL PROCEDURE QtytoHandleBaseOnAfterValidate@19004517();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE QtytoInvoiceBaseOnAfterValidat@19062426();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ExpirationDateOnFormat@19045111();
    BEGIN
      UpdateExpDateColor;
    END;

    LOCAL PROCEDURE TempRecValid@49();
    BEGIN
      IF NOT TempRecIsValid THEN
        ERROR(Text007);
    END;

    LOCAL PROCEDURE GetHandleSource@37(TrackingSpecification@1000 : Record 336) : Boolean;
    VAR
      QtyToHandleColumnIsHidden@1001 : Boolean;
    BEGIN
      WITH TrackingSpecification DO BEGIN
        IF ("Source Type" = DATABASE::"Item Journal Line") AND ("Source Subtype" = 6) THEN BEGIN // 6 => Prod.order line
          ProdOrderLineHandling := TRUE;
          EXIT(TRUE);  // Display Handle column for prod. orders
        END;
        QtyToHandleColumnIsHidden :=
          ("Source Type" IN
           [DATABASE::"Item Ledger Entry",
            DATABASE::"Item Journal Line",
            DATABASE::"Job Journal Line",
            DATABASE::"Requisition Line"]) OR
          (("Source Type" IN [DATABASE::"Sales Line",DATABASE::"Purchase Line",DATABASE::"Service Line"]) AND
           ("Source Subtype" IN [0,2,3])) OR
          (("Source Type" = DATABASE::"Assembly Line") AND ("Source Subtype" = 0));
      END;
      EXIT(NOT QtyToHandleColumnIsHidden);
    END;

    LOCAL PROCEDURE GetInvoiceSource@50(TrackingSpecification@1000 : Record 336) : Boolean;
    VAR
      QtyToInvoiceColumnIsHidden@1001 : Boolean;
    BEGIN
      WITH TrackingSpecification DO BEGIN
        QtyToInvoiceColumnIsHidden :=
          ("Source Type" IN
           [DATABASE::"Item Ledger Entry",
            DATABASE::"Item Journal Line",
            DATABASE::"Job Journal Line",
            DATABASE::"Requisition Line",
            DATABASE::"Transfer Line",
            DATABASE::"Assembly Line",
            DATABASE::"Assembly Header",
            DATABASE::"Prod. Order Line",
            DATABASE::"Prod. Order Component"]) OR
          (("Source Type" IN [DATABASE::"Sales Line",DATABASE::"Purchase Line",DATABASE::"Service Line"]) AND
           ("Source Subtype" IN [0,2,3,4]))
      END;
      EXIT(NOT QtyToInvoiceColumnIsHidden);
    END;

    [External]
    PROCEDURE SetSecondSourceID@57(SourceID@1000 : Integer;IsATO@1001 : Boolean);
    BEGIN
      SecondSourceID := SourceID;
      IsAssembleToOrder := IsATO;
    END;

    LOCAL PROCEDURE SynchronizeWarehouseItemTracking@53();
    VAR
      WarehouseShipmentLine@1000 : Record 7321;
      ItemTrackingMgt@1002 : Codeunit 6500;
    BEGIN
      IF ItemTrackingMgt.ItemTrkgIsManagedByWhse(
           "Source Type","Source Subtype","Source ID",
           "Source Prod. Order Line","Source Ref. No.","Location Code","Item No.")
      THEN
        EXIT;

      WarehouseShipmentLine.SETRANGE("Source Type","Source Type");
      WarehouseShipmentLine.SETRANGE("Source Subtype","Source Subtype");
      WarehouseShipmentLine.SETRANGE("Source No.","Source ID");
      WarehouseShipmentLine.SETRANGE("Source Line No.","Source Ref. No.");
      IF WarehouseShipmentLine.FINDSET THEN
        REPEAT
          DeleteWhseItemTracking(WarehouseShipmentLine);
          WarehouseShipmentLine.CreateWhseItemTrackingLines;
        UNTIL WarehouseShipmentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE DeleteWhseItemTracking@52(WarehouseShipmentLine@1000 : Record 7321);
    VAR
      WhseItemTrackingLine@1001 : Record 6550;
    BEGIN
      WhseItemTrackingLine.SETRANGE("Source Type",DATABASE::"Warehouse Shipment Line");
      WhseItemTrackingLine.SETRANGE("Source ID",WarehouseShipmentLine."No.");
      WhseItemTrackingLine.SETRANGE("Source Ref. No.",WarehouseShipmentLine."Line No.");
      WhseItemTrackingLine.DELETEALL(TRUE);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyTrackingSpec@63(VAR SourceTrackingSpec@1000 : Record 336;VAR DestTrkgSpec@1001 : Record 336);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterClearTrackingSpec@64(VAR OldTrkgSpec@1000 : Record 336);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterMoveFields@65(VAR TrkgSpec@1000 : Record 336;VAR ReservEntry@1001 : Record 337);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignNewTrackingNo@66(VAR TrkgSpec@1000 : Record 336);
    BEGIN
    END;

    BEGIN
    END.
  }
}

