OBJECT Page 755 Standard Item Journal Subform
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
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table753;
    DelayedInsert=Yes;
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  "Entry Type" := xRec."Entry Type";
                  CLEAR(ShortcutDimCode);
                  "Source Code" := GetSourceCodeFromJnlTemplate;
                END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1900206304;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion posten er oprettet ud fra.;
                           ENU=Specifies which type of transaction that the entry is created from.];
                ApplicationArea=#Suite;
                SourceExpr="Entry Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nummer p� kladdelinjen.;
                           ENU=Specifies the number of the item on the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Item No." }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen p� linjen.;
                           ENU=Specifies the description of the item on the line.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateSaveShortcutDimCode(3,ShortcutDimCode[3]);
                           END;
                            }

    { 20  ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateSaveShortcutDimCode(4,ShortcutDimCode[4]);
                           END;
                            }

    { 22  ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateSaveShortcutDimCode(5,ShortcutDimCode[5]);
                           END;
                            }

    { 24  ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateSaveShortcutDimCode(6,ShortcutDimCode[6]);
                           END;
                            }

    { 26  ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateSaveShortcutDimCode(7,ShortcutDimCode[7]);
                           END;
                            }

    { 32  ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateSaveShortcutDimCode(8,ShortcutDimCode[8]);
                           END;
                            }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationskoden for varen p� linjen.;
                           ENU=Specifies the location code for the item on the line.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l�gges p� lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s�lger eller indk�ber, der er knyttet til salget eller k�bet p� kladdelinjen.;
                           ENU=Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varen i kladdelinjen.;
                           ENU=Specifies the quantity of the item in the journal line.];
                ApplicationArea=#Suite;
                SourceExpr=Quantity }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Suite;
                SourceExpr="Unit of Measure Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel�bet for enheden p� kladdelinjen.;
                           ENU=Specifies the amount of the unit in the line of the journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Unit Amount" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel�bet for enheden p� kladdelinjen.;
                           ENU=Specifies the amount of the unit in the line of the journal line.];
                ApplicationArea=#Suite;
                SourceExpr=Amount }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k�bspris, der omfatter indirekte omkostninger, s�som fragt, der er knyttet til k�bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Indirect Cost %";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Suite;
                SourceExpr="Unit Cost" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr�senterer med henblik p� rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm�den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr�de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �rsagskoden som et supplerende kildespor, der hj�lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Reason Code";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ShortcutDimCode@1000 : ARRAY [8] OF Code[20];

    LOCAL PROCEDURE GetSourceCodeFromJnlTemplate@1() : Code[10];
    VAR
      ItemJnlTemplate@1000 : Record 82;
    BEGIN
      ItemJnlTemplate.GET("Journal Template Name");
      EXIT(ItemJnlTemplate."Source Code");
    END;

    LOCAL PROCEDURE ValidateSaveShortcutDimCode@5(FieldNumber@1001 : Integer;VAR ShortcutDimCode@1000 : Code[20]);
    BEGIN
      ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
      CurrPage.SAVERECORD;
    END;

    BEGIN
    END.
  }
}

