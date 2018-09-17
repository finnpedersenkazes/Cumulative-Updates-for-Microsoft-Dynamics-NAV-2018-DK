OBJECT Page 7375 Inventory Put-away
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=L‘g-p†-lager (lager);
               ENU=Inventory Put-away];
    SaveValues=Yes;
    SourceTable=Table5766;
    SourceTableView=WHERE(Type=CONST(Invt. Put-away));
    PageType=Document;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 ErrorIfUserIsNotWhseEmployee;
               END;

    OnFindRecord=BEGIN
                   EXIT(FindFirstAllowedRec(Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(FindNextAllowedRec(Steps));
                 END;

    OnNewRecord=BEGIN
                  "Location Code" := GetUserLocation;
                END;

    OnDeleteRecord=BEGIN
                     CurrPage.UPDATE;
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 100     ;1   ;ActionGroup;
                      CaptionML=[DAN=L&‘g-p†-lager;
                                 ENU=Put-&away];
                      Image=CreatePutAway }
      { 101     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=F† vist alle eksisterende lagerdokumenter af denne type.;
                                 ENU=View all warehouse documents of this type that exist.];
                      ApplicationArea=#Warehouse;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 LookupActivityHeader("Location Code",Rec);
                               END;
                                }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Whse. Activity Header),
                                  Type=FIELD(Type),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. l‘g-p†-lager-akt.;
                                 ENU=Posted Put-aways];
                      ToolTipML=[DAN=Vis alle antal, der allerede er blevet lagt p† lager.;
                                 ENU=View any quantities that have already been put away.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7394;
                      RunPageView=SORTING(Invt. Put-away No.);
                      RunPageLink=Invt. Put-away No.=FIELD(No.);
                      Image=PostedPutAway }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Kildedokument;
                                 ENU=Source Document];
                      ToolTipML=[DAN=Vis kildedokumentet for lageraktiviteten.;
                                 ENU=View the source document of the warehouse activity.];
                      ApplicationArea=#Warehouse;
                      Image=Order;
                      OnAction=VAR
                                 WMSMgt@1000 : Codeunit 7302;
                               BEGIN
                                 WMSMgt.ShowSourceDocCard("Source Type","Source Subtype","Source No.");
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 4       ;2   ;Action    ;
                      Name=GetSourceDocument;
                      ShortCutKey=Ctrl+F7;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent kildedokument;
                                 ENU=&Get Source Document];
                      ToolTipML=[DAN=V‘lg det kildedokument, som du vil l‘gge varer p† lager efter.;
                                 ENU=Select the source document that you want to put items away for.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Create Inventory Put-away",Rec);
                               END;
                                }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=Autofyld h†ndteringsantal;
                                 ENU=Autofill Qty. to Handle];
                      ToolTipML=[DAN=F† systemet til at angive det udest†ende antal i feltet H†ndteringsantal.;
                                 ENU=Have the system enter the outstanding quantity in the Qty. to Handle field.];
                      ApplicationArea=#Warehouse;
                      Image=AutofillQtyToHandle;
                      OnAction=BEGIN
                                 AutofillQtyToHandle;
                               END;
                                }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Slet h†ndteringsantal;
                                 ENU=Delete Qty. to Handle];
                      ToolTipML=[DAN="F† systemet til at slette v‘rdien i feltet H†ndteringsantal. ";
                                 ENU="Have the system clear the value in the Qty. To Handle field. "];
                      ApplicationArea=#Warehouse;
                      Image=DeleteQtyToHandle;
                      OnAction=BEGIN
                                 DeleteQtyToHandle;
                               END;
                                }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 18      ;2   ;Action    ;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PostPutAwayYesNo;
                               END;
                                }
      { 41      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f‘rdigg›res og forberedes til udskrivning. V‘rdierne og antallene bogf›res p† de relaterede konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PostAndPrint;
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WhseActPrint.PrintInvtPutAwayHeader(Rec,FALSE);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1903358206;1 ;Action    ;
                      CaptionML=[DAN=L‘g-p†-lager-oversigt;
                                 ENU=Put-away List];
                      ToolTipML=[DAN=F† vist eller udskriv en detaljeret liste over varer, som skal l‘gges p† lager.;
                                 ENU=View or print a detailed list of items that must be put away.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 5751;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
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
                ApplicationArea=#Warehouse;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor lageraktiviteten finder sted.;
                           ENU=Specifies the code for the location where the warehouse activity takes place.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 13  ;2   ;Field     ;
                Lookup=No;
                DrillDown=No;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No.";
                OnValidate=BEGIN
                             SourceNoOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           CODEUNIT.RUN(CODEUNIT::"Create Inventory Put-away",Rec);
                           CurrPage.WhseActivityLines.PAGE.UpdateForm;
                         END;
                          }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer eller den kode for debitoren eller kreditoren, som linjen er tilknyttet.;
                           ENU=Specifies the number or the code of the customer or vendor that the line is linked to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",0));
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† de modtagne varer, der er lagt p† lager.;
                           ENU=Specifies the name of the received items put away into storage.];
                ApplicationArea=#Warehouse;
                SourceExpr=WMSMgt.GetDestinationName("Destination Type","Destination No.");
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",1));
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re registreret som bogf›rt.;
                           ENU=Specifies the date when the warehouse activity should be recorded as being posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilg‘ngelige p† lageret. Hvis du lader feltet v‘re tomt, bliver det beregnet p† f›lgende m†de: Planlagt modtagelsesdato + Sikkerhedstid + Indg†ende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#Warehouse;
                SourceExpr="Expected Receipt Date";
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No.";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",2)) }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af det bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies an additional part of the document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No.2";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",3)) }

    { 97  ;1   ;Part      ;
                Name=WhseActivityLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(Activity Type,No.,Sorting Sequence No.)
                            WHERE(Breakbulk=CONST(No));
                SubPageLink=Activity Type=FIELD(Type),
                            No.=FIELD(No.);
                PagePartID=Page7376;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 7   ;1   ;Part      ;
                ApplicationArea=#ItemTracking;
                SubPageLink=Item No.=FIELD(Item No.),
                            Variant Code=FIELD(Variant Code),
                            Location Code=FIELD(Location Code);
                PagePartID=Page9126;
                ProviderID=97;
                Visible=False;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      WMSMgt@1002 : Codeunit 7302;
      WhseActPrint@1000 : Codeunit 5776;

    LOCAL PROCEDURE AutofillQtyToHandle@1();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.AutofillQtyToHandle;
    END;

    LOCAL PROCEDURE DeleteQtyToHandle@2();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.DeleteQtyToHandle;
    END;

    LOCAL PROCEDURE PostPutAwayYesNo@3();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.PostPutAwayYesNo;
    END;

    LOCAL PROCEDURE PostAndPrint@4();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.PostAndPrint;
    END;

    LOCAL PROCEDURE SourceNoOnAfterValidate@19036011();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.UpdateForm;
    END;

    BEGIN
    END.
  }
}

