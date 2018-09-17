OBJECT Page 7382 Inventory Movement
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Flytning (lager);
               ENU=Inventory Movement];
    SaveValues=Yes;
    SourceTable=Table5766;
    SourceTableView=WHERE(Type=CONST(Invt. Movement));
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
                  "Location Code" := xRec."Location Code";
                END;

    OnDeleteRecord=BEGIN
                     CurrPage.UPDATE;
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 100     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bev‘gelse;
                                 ENU=&Movement];
                      Image=CreateMovement }
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
      { 25      ;2   ;Action    ;
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
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Registrerede flytninger (lager);
                                 ENU=Registered Invt. Movements];
                      ToolTipML=[DAN=Vis listen over afsluttede flytninger (lager).;
                                 ENU=View the list of completed inventory movements.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7386;
                      RunPageView=SORTING(Invt. Movement No.);
                      RunPageLink=Invt. Movement No.=FIELD(No.);
                      Image=RegisteredDocs }
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
      { 13      ;2   ;Action    ;
                      Name=GetSourceDocument;
                      ShortCutKey=Ctrl+F7;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent kildedokument;
                                 ENU=&Get Source Document];
                      ToolTipML=[DAN=V‘lg det kildedokument, som du vil flytte varer efter.;
                                 ENU=Select the source document that you want to move items for.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CreateInvtPickMovement@1001 : Codeunit 7322;
                               BEGIN
                                 IF LineExist THEN
                                   ERROR(Text001);
                                 CreateInvtPickMovement.SetInvtMovement(TRUE);
                                 CreateInvtPickMovement.RUN(Rec);
                               END;
                                }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Autofyld h†ndteringsantal;
                                 ENU=Autofill Qty. to Handle];
                      ToolTipML=[DAN=F† systemet til at angive det udest†ende antal i feltet H†ndteringsantal.;
                                 ENU=Have the system enter the outstanding quantity in the Qty. to Handle field.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AutofillQtyToHandle;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 AutofillQtyToHandle;
                               END;
                                }
      { 39      ;2   ;Action    ;
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
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&egistrering;
                                 ENU=&Registering];
                      Image=PostOrder }
      { 28      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Registrer flytning (lager);
                                 ENU=&Register Invt. Movement];
                      ToolTipML=[DAN=Registrer bev‘gelse af varer mellem placeringer i en grundl‘ggende lagerops‘tning.;
                                 ENU=Register the movement of items between bins in a basic warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=RegisterPutAway;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 RegisterActivityYesNo;
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
                                 WhseDocPrint.PrintInvtMovementHeader(Rec,FALSE);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1903694506;1 ;Action    ;
                      CaptionML=[DAN=Bev‘gelsesoversigt;
                                 ENU=Movement List];
                      ToolTipML=[DAN=Vis oversigten over igangv‘rende bev‘gelser mellem placeringer i henhold til en grundl‘ggende lagerkonfiguration.;
                                 ENU=View the list of ongoing movements between bins according to a basic warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7301;
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

    { 15  ;2   ;Field     ;
                Lookup=No;
                DrillDown=No;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                OptionCaptionML=[DAN="  ,,,,,,,,,,,Prod. Forbrug,,,,,,,,,Montageforbrug";
                                 ENU="  ,,,,,,,,,,,Prod. Consumption,,,,,,,,,Assembly Consumption"];
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

                OnLookup=VAR
                           CreateInvtPickMovement@1002 : Codeunit 7322;
                         BEGIN
                           IF LineExist THEN
                             ERROR(Text001);

                           CreateInvtPickMovement.SetInvtMovement(TRUE);
                           CreateInvtPickMovement.RUN(Rec);
                           CurrPage.UPDATE;
                           CurrPage.WhseActivityLines.PAGE.UpdateForm;
                         END;
                          }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer eller den kode for debitoren eller kreditoren, som linjen er tilknyttet.;
                           ENU=Specifies the number or the code of the customer or vendor that the line is linked to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",0));
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† destinationen for den tilknyttede lagerflytning.;
                           ENU=Specifies the name of the destination for the inventory movement.];
                ApplicationArea=#Warehouse;
                SourceExpr=WMSMgt.GetDestinationName("Destination Type","Destination No.");
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",1));
                Editable=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re registreret som bogf›rt.;
                           ENU=Specifies the date when the warehouse activity should be recorded as being posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No.";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",2)) }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af det bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies an additional part of the document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No.2";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",3)) }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan linjerne sorteres i lagerhovedet, f.eks. efter Vare eller Bilag.;
                           ENU=Specifies the method by which the lines are sorted on the warehouse header, such as Item or Document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method";
                OnValidate=BEGIN
                             SortingMethodOnAfterValidate;
                           END;
                            }

    { 97  ;1   ;Part      ;
                Name=WhseActivityLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(Activity Type,No.,Sorting Sequence No.)
                            WHERE(Breakbulk=CONST(No));
                SubPageLink=Activity Type=FIELD(Type),
                            No.=FIELD(No.);
                PagePartID=Page7383;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 3   ;1   ;Part      ;
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
      WhseDocPrint@1000 : Codeunit 5776;
      WMSMgt@1001 : Codeunit 7302;
      Text001@1002 : TextConst 'DAN=Du kan ikke bruge denne funktion, hvis linjerne allerede findes.;ENU=You cannot use this function if the lines already exist.';

    LOCAL PROCEDURE AutofillQtyToHandle@1();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.AutofillQtyToHandle;
    END;

    LOCAL PROCEDURE DeleteQtyToHandle@2();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.DeleteQtyToHandle;
    END;

    LOCAL PROCEDURE RegisterActivityYesNo@3();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.RegisterActivityYesNo;
    END;

    LOCAL PROCEDURE SourceNoOnAfterValidate@19036011();
    BEGIN
      CurrPage.UPDATE;
      CurrPage.WhseActivityLines.PAGE.UpdateForm;
    END;

    LOCAL PROCEDURE SortingMethodOnAfterValidate@19063061();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

