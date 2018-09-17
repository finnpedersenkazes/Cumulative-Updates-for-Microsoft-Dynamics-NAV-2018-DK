OBJECT Page 99000886 Subcontracting Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Underleverand�rkladde;
               ENU=Subcontracting Worksheet];
    SaveValues=Yes;
    SourceTable=Table246;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Worksheet Template Name" = '');
                 IF OpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 ReqJnlManagement.TemplateSelection(PAGE::"Subcontracting Worksheet",FALSE,1,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
               END;

    OnNewRecord=BEGIN
                  ReqJnlManagement.SetUpNewLine(Rec,xRec);
                END;

    OnAfterGetCurrRecord=BEGIN
                           ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 52      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 70      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p�g�ldende record p� bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Codeunit 335;
                      Image=EditLines }
      { 6500    ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
      { 29      ;2   ;Action    ;
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 32      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn underleverancer;
                                 ENU=Calculate Subcontracts];
                      ToolTipML=[DAN=Beregn de eksterne arbejdscentre, der h�ndteres af en leverand�r i kontrakten.;
                                 ENU=Calculate the external work centers that are managed by a supplier under contract.];
                      ApplicationArea=#Manufacturing;
                      Image=Calculate;
                      OnAction=VAR
                                 CalculateSubContract@1001 : Report 99001015;
                               BEGIN
                                 CalculateSubContract.SetWkShLine(Rec);
                                 CalculateSubContract.RUNMODAL;
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Name=CarryOutActionMessage;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udf�r aktionsmeddelelse;
                                 ENU=Carry &Out Action Message];
                      ToolTipML=[DAN=Brug en k�rsel som hj�lp til at oprette faktiske forsyningsordrer ud fra ordreforslagene.;
                                 ENU=Use a batch job to help you create actual supply orders from the order proposals.];
                      ApplicationArea=#Manufacturing;
                      Image=CarryOutActionMessage;
                      OnAction=VAR
                                 MakePurchOrder@1001 : Report 493;
                               BEGIN
                                 MakePurchOrder.SetReqWkshLine(Rec);
                                 MakePurchOrder.RUNMODAL;
                                 CLEAR(MakePurchOrder);
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
                ToolTipML=[DAN=Angiver navnet p� kladdek�rslen for underleverand�rkladden.;
                           ENU=Specifies the name of the journal batch of the subcontracting worksheet.];
                ApplicationArea=#Manufacturing;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             ReqJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           ReqJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type indk�bskladdelinje, du vil oprette.;
                           ENU=Specifies the type of requisition worksheet line you are creating.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Type;
                OnValidate=BEGIN
                             ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No.";
                OnValidate=BEGIN
                             ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                           END;
                            }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den aktionsmeddelelse, som foresl�s for linjen, skal godkendes.;
                           ENU=Specifies whether to accept the action message proposed for the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Accept Action Message" }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en handling for at genoprette balancen i forholdet mellem udbud og eftersp�rgsel.;
                           ENU=Specifies an action to take to rebalance the demand-supply situation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Action Message" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order No." }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationsnummeret for rutelinjen.;
                           ENU=Specifies the operation number for this routing line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Operation No." }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdscenternummeret p� kladdelinjen.;
                           ENU=Specifies the work center number of the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Center No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tekst, der beskriver posten.;
                           ENU=Specifies text that describes the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ekstra tekst til beskrivelse af posten eller en bem�rkning om indk�bskladdelinjen.;
                           ENU=Specifies additional text describing the entry, or a remark about the requisition worksheet line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lagerlokation, hvor de bestilte varer skal registreres p�.;
                           ENU=Specifies a code for an inventory location where the items that are being ordered will be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder.;
                           ENU=Specifies the number of units of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Quantity }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kreditor, der skal levere varerne i k�bsordren.;
                           ENU=Specifies the number of the vendor who will ship the items in the purchase order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Vendor No.";
                OnValidate=BEGIN
                             ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                           END;
                            }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Order Address Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Vendor Item No." }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Sell-to Customer No.";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs� i tilf�lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver valutakoden for rekvisitionslinjerne.;
                           ENU=Specifies the currency code for the requisition lines.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Currency Code";
                Visible=FALSE;
                OnAssistEdit=VAR
                               ChangeExchangeRate@1001 : Page 511;
                             BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);

                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Direct Unit Cost" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der bruges til at beregne k�bslinjerabatten.;
                           ENU=Specifies the discount percentage used to calculate the purchase line discount.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Line Discount %";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken ordredato der skal g�lde for indk�bskladdelinjen.;
                           ENU=Specifies the order date that will apply to the requisition worksheet line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Order Date";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du kan forvente at modtage varerne.;
                           ENU=Specifies the date when you can expect to receive the items.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Due Date" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p� den bruger, der bestiller varerne p� linjen.;
                           ENU=Specifies the ID of the user who is ordering the items on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Requester ID";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varerne p� linjen er blevet godkendt til k�b.;
                           ENU=Specifies whether the items on the line have been approved for purchase.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Confirmed;
                Visible=FALSE }

    { 20  ;1   ;Group      }

    { 1901776201;2;Group  ;
                GroupType=FixedLayout }

    { 1902759801;3;Group  ;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description] }

    { 21  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af kladdebeskrivelsen.;
                           ENU=Specifies an additional part of the worksheet description.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description2;
                Editable=FALSE;
                ShowCaption=No }

    { 1901652601;3;Group  ;
                CaptionML=[DAN=Leverand�rnavn;
                           ENU=Buy-from Vendor Name] }

    { 23  ;4   ;Field     ;
                CaptionML=[DAN=Leverand�rnavn;
                           ENU=Buy-from Vendor Name];
                ToolTipML=[DAN=Angiver kreditorens navn.;
                           ENU=Specifies the vendor's name.];
                ApplicationArea=#Manufacturing;
                SourceExpr=BuyFromVendorName;
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
      ReqJnlManagement@1000 : Codeunit 330;
      CurrentJnlBatchName@1001 : Code[10];
      Description2@1002 : Text[50];
      BuyFromVendorName@1003 : Text[50];
      OpenedFromBatch@1004 : Boolean;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      ReqJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

